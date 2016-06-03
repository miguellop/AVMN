function genlinearaddfcn(ni, nrows, nagents, type) 
%GENLINEARADDFCN crea y almacena un cell-array 'uf' de tamaño {NROW}{NCOLS} de
%   funciones de utilidad FCNADD homogéneas de NI issues.
%
%   NROWS define el número de sets de funciones de utilidad.
%   NCOLS define el número de agentes. En definitiva, cada nrow hay ncols
%   agentes y por tanto funciones de utilidad.
%
%   La función almacena en un fichero el cell con nrows*ncols funciones de
%   utilidad, con el nombre "UFB100i"
%   para 100 issues, ... Almacena además en un cell-array swnk de tamaño
%   {nrows}{ncols} que almacena por cada elemento una estructura con los
%   elementos .fval, .nash, .sw y .kalai. SWNK{nrow,1} siempre es una cell
%   vacía. SWNK{nrow,2} representa la estructura del frente de pareto para el
%   set nrow y dos agentes: uf{nrow}{1} y uf{nrow}{2}. SWNK{nrow,10}
%   representa por tanto el set nrow y 10 agentes: UF{nrow}{1},
%   UF{nrow}{2}, ..., UF{nrow}{10}

options = gaoptimset;
options = gaoptimset(options,'Display', 'off');
options = gaoptimset(options,'Vectorized', 'on');
options = gaoptimset(options,'PopulationType', 'bitstring'); 


disp('Generating FCNADD functions ...');

if strcmp(type,'uniform')
    fcoeffs{1} = @() unifrnd(-100,100,ni,ni);
    lc = 1;
    filename = 'UFhom';
else
    fcoeffs{1} = @() (betarnd(1,1,ni,ni)-0.5)*100;
    fcoeffs{2} = @() (betarnd(5,5,ni,ni)-0.5)*100;
    fcoeffs{3} = @() (betarnd(6,2,ni,ni)-0.75)*100;
    fcoeffs{4} = @() (betarnd(2,6,ni,ni)-0.25)*100;
    agenttypes = [3 4 3 4 2 2];
    lc = 4;
    filename = 'UFhet';
end

for i=1:nrows
    for j=1:nagents(end)
        disp(['FCNADD:' num2str(i) ',' num2str(j)]);
        
        %uf{i,j} = linearaddfcn(ni,fcoeffs{randi(lc)}());
        uf{i,j} = linearaddfcn(ni,fcoeffs{agenttypes(j)}());
    end
end

disp('Computing SW, Nash and Kalai ...');

for i=1:nrows
    for j=2:nagents
        if j<=3
            %%%PD
            disp(['PD: Set: ' num2str(i) '- Agents: ' num2str(j)]);

            f = '@(x) -1*[';
            for k=1:j-1
                f = [f, 'uf{' num2str(i) ',' num2str(k) '}(x),'];
            end
            f = eval([f, 'uf{' num2str(i) ',' num2str(j) '}(x)]']);
            options = gaoptimset(options,'PopulationSize', 1000); 
            [x, fval] = gamultiobj(f, ni, [], [], [], [], [], [], options);
            fval = -1*fval;

            swnk{i,j}.x = x;       
            swnk{i,j}.fval = fval;
            % Aproximación a nash y kalai desde el set pareto
    %         [~,ind] = max(prod(fval,2));
    %         swnk{i,j}.nashpf = fval(ind,:);
    %         [~,ind] = max(min(fval,[],2));
    %         swnk{i,j}.kalaipf = fval(ind,:);
        end
        %%%SW
        options = gaoptimset(options,'PopulationSize', 200); 
        disp(['SW: Set: ' num2str(i) '- Agents: ' num2str(j)]);
        f = '@(x) -1*[';
        for k=1:j-1
            f = [f, 'uf{' num2str(i) ',' num2str(k) '}(x)+'];
        end
        f = eval([f, 'uf{' num2str(i) ',' num2str(j) '}(x)]']);
        
        [x] = ga(f, ni,[],[],[],[],[],[],[],[],options);
        
        f = '@(x) [';
        for k=1:j-1
            f = [f, 'uf{' num2str(i) ',' num2str(k) '}(x),'];
        end
        f = eval([f, 'uf{' num2str(i) ',' num2str(j) '}(x)]']);
        
        swnk{i,j}.sw = f(x);
        %%%NASH
        disp(['NASH: Set: ' num2str(i) '- Agents: ' num2str(j)]);
        f = '@(x) -1*[';
        for k=1:j-1
            f = [f, 'uf{' num2str(i) ',' num2str(k) '}(x).*'];
        end
        f = eval([f, 'uf{' num2str(i) ',' num2str(j) '}(x)]']);
        
        [x] = ga(f, ni,[],[],[],[],[],[],[],[],options);
        
        f = '@(x) [';
        for k=1:j-1
            f = [f, 'uf{' num2str(i) ',' num2str(k) '}(x),'];
        end
        f = eval([f, 'uf{' num2str(i) ',' num2str(j) '}(x)]']);
        
        swnk{i,j}.nash = f(x);
        %%%KALAI
        disp(['KALAI: Set: ' num2str(i) '- Agents: ' num2str(j)]);
        f = '@(x) -1*min([';
        for k=1:j-1
            f = [f, 'uf{' num2str(i) ',' num2str(k) '}(x),'];
        end
        f = eval([f, 'uf{' num2str(i) ',' num2str(j) '}(x)],[],2)']);
        
        [x] = ga(f, ni,[],[],[],[],[],[],[],[],options);
        
        f = '@(x) [';
        for k=1:j-1
            f = [f, 'uf{' num2str(i) ',' num2str(k) '}(x),'];
        end
        f = eval([f, 'uf{' num2str(i) ',' num2str(j) '}(x)]']);
        
        swnk{i,j}.kalai = f(x);
    end     
end

save(filename, 'uf', 'swnk');
end

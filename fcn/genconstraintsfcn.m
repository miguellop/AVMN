function genconstraintsfcn(ni, nrows, nagents) 
%GENCONSTRAINTSFCN crea y almacena un cell-array 'uf' de tamaño {NROW}{size(NAGENTS)} de
%   funciones de utilidad FCNADD homogéneas de NI issues.
%
%   NROWS define el número de sets de funciones de utilidad.
%   NAGENTS define el número de agentes. En definitiva, cada nrow hay
%   SIZE(NAGENTS) agentes y por tanto funciones de utilidad.
%
%   La función almacena en un fichero el cell con nrows*size(nagents) funciones de
%   utilidad, con el nombre "UFB100i"
%   para 100 issues, ... Almacena además en un cell-array swnk de tamaño
%   {nrows}{size(nagents)} que almacena por cada elemento una estructura con los
%   elementos .fval, .nash, .sw y .kalai. SWNK{nrow,1} siempre es una cell
%   vacía. SWNK{nrow,2} representa la estructura del frente de pareto para el
%   set nrow y dos agentes: uf{nrow}{1} y uf{nrow}{2}. SWNK{nrow,10}
%   representa por tanto el set nrow y 10 agentes: UF{nrow}{1},
%   UF{nrow}{2}, ..., UF{nrow}{10}

d = [ones(1,ni);10*ones(1,ni)];

options = gaoptimset;
options = gaoptimset(options,'Display', 'off');
options = gaoptimset(options,'Vectorized', 'on');

disp('Generating CONSTRAINTSFCN functions ...');

filename = 'UFconstraintsSimple';

for i=1:nrows
    for j=1:nagents(end)
        disp(['CONSFCN:' num2str(i) ',' num2str(j)]);
        
        uf{i,j} = constraintsfcn(ni,[1 10]);
    end
end

disp('Computing SW, Nash and Kalai ...');

for i=1:nrows
    for j=nagents
        if j<=3
            %%%PD
            disp(['PD: Set: ' num2str(i) '- Agents: ' num2str(j)]);

            f = '@(x) -1*[';
            for k=1:j-1
                f = [f, 'uf{' num2str(i) ',' num2str(k) '}(x),'];
            end
            f = eval([f, 'uf{' num2str(i) ',' num2str(j) '}(x)]']);
            options = gaoptimset(options,'PopulationSize', 1000); 
            [x, fval] = gamultiobj(f, ni, [], [], [], [], d(1,:), d(2,:),options);
            fval = -1*fval;

            swnk{i,j}.x = x;       
            swnk{i,j}.fval = fval;
        end
        %%%SW
        options = gaoptimset(options,'PopulationSize', 200); 
        disp(['SW: Set: ' num2str(i) '- Agents: ' num2str(j)]);
        f = '@(x) -1*[';
        for k=1:j-1
            f = [f, 'uf{' num2str(i) ',' num2str(k) '}(x)+'];
        end
        f = eval([f, 'uf{' num2str(i) ',' num2str(j) '}(x)]']);
        
        [x] = ga(f, ni,[],[],[],[],d(1,:),d(2,:),[],[],options);
        
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
        
        [x] = ga(f, ni,[],[],[],[],d(1,:),d(2,:),[],[],options);
        
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
        
        [x] = ga(f, ni,[],[],[],[],d(1,:),d(2,:),[],[],options);
        
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

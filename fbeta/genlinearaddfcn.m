function genlinearaddfcn(ni, nrows, ncols) 
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
options = gaoptimset(options,'PopulationSize', 1000); 

disp('Generating FCNADD functions ...');

for i=1:nrows
    for j=1:ncols
        disp(['FCNADD:' num2str(i) ',' num2str(j)]);
        uf{i,j} = linearaddfcn(ni);
    end
end

disp('Computing SW, Nash and Kalai ...');

for i=1:nrows
    for j=2:ncols
        disp(['SWNK: Set: ' num2str(i) '- Agents: ' num2str(j)]);
        
        f = '@(x) -1*[';
        for k=1:j-1
            f = [f, 'uf{' num2str(i) ',' num2str(k) '}(x),'];
        end
        f = eval([f, 'uf{' num2str(i) ',' num2str(j) '}(x)]']);
        
        [x, fval] = gamultiobj(f, ni, [], [], [], [], [], [], options);
        fval = -1*fval;
        
        swnk{i,j}.x = x;       
        swnk{i,j}.fval = fval;
        % Aproximación a nash y kalai desde el set pareto
        [~,ind] = max(prod(fval,2));
        swnk{i,j}.nash = fval(ind,:);
        [~,ind] = max(min(fval,[],2));
        swnk{i,j}.kalai = fval(ind,:);
        
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
    end     
end

save(['UF' num2str(ni) 'i'], 'uf', 'swnk');
end

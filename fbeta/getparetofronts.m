function pf = getparetofronts(uf, ni, nrows, ncols)
%GETPARETOFRONTS crea los frentes de pareto correspondientes a la funciones
%   de utilidad UF, para NI issues y NROWS sets de funciones de utilidad
%   y NCOLS experimentos por set.
%
%   La función guarda en pf{i}{j}.sw,nash,kalai las utilidades que las 
%   soluciones de máximo SW, NASH y KALAI dan a cada agente. pf{i}{j}.fval
%   contiene el frente de pareto completo.

for i=1:nrows
        for j=2:ncols
            disp(['Pareto Frontier Set:' num2str(i) '- Number of Agents: ' num2str(j)]);
            f = '@(x) -1*[';
            for k=1:j
                f = [f, 'uf{' num2str(i) '}{' num2str(k) '}(x),'];
            end
            f = eval([f, ']']);
            [x, fval] = gamultiobj(f, ni, [], [], [], [], zeros(1,ni), ones(1,ni));
            fval = -1*fval;
            [x, isw] = max(sum(fval, 2));
            [x, inash] = max(prod(fval, 2));
            [x, ikalai] = max(min(fval, [], 2));
            pf{i}{j}.('fval') = fval;
            pf{i}{j}.('sw') = fval(isw,:);
            pf{i}{j}.('nash') = fval(inash,:);
            pf{i}{j}.('kalai') = fval(ikalai,:);
        end
    end     
end
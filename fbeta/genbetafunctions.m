function genbetafunctions(ni, nrows, ncols) 
%GENBETAFUNCTIONS crea y almacena un cell-array uf de tamaño {nrows}{ncols} de
%funciones de utilidad Beta de NI issues.
%   NROWS define el número de sets de funciones de utilidad.
%   NCOLS define el número de agentes. En definitiva, cada nrow hay ncols
%   agentes y por tanto funciones de utilidad.
%
%   La función almacena en un fichero el cell con nrows*ncols funciones de
%   utilidad, con el nombre "UFB20i" para el caso de 20 issues, o "UFB100i"
%   para 100 issues, ... Almacena además en un cell-array pf de tamaño
%   {nrows}{ncols} que almacena por cada elemento una estructura con los
%   elementos .fval, .nash, .sw y .kalai. pf{nrow,1} siempre es una cell
%   vacía. pf{nrow,2} representa la estructura del frente de pareto para el
%   set nrow y dos agentes: uf{nrow}{1} y uf{nrow}{2}. pf{nrow,10}
%   representa por tanto el set nrow y 10 agentes: uf{nrow}{1},
%   uf{nrow}{2}, ..., uf{nrow}{10}

    domain = [zeros(1,ni);ones(1,ni)];
%     abc.uniform = [1 1 0];
%     abc.bell_shaped = [5 5 1.75];
%     abc.left_skewed = [6 2 1]; 
%     abc.right_skewed = [2 6 1];
% 
%     fu =fbeta(abc.('uniform'), ni, domain, 'het');
%     fb =fbeta(abc.('bell_shaped'), ni, domain, 'het');
%     fl =fbeta(abc.('left_skewed'), ni, domain, 'het');
%     fr =fbeta(abc.('right_skewed'), ni, domain, 'het');
    disp('Generating Beta Functions');
    for i=1:nrows
        for j=1:ncols
            disp(['Beta function:' num2str(i) ',' num2str(j)]);
            uf{i}{j} = fbeta([], ni, domain, 'hom');
        end
    end
    disp('Generating Pareto Frontiers');
    pf = getparetofronts(uf, ni, nrows, ncols);
    save(['UFB' num2str(ni) 'i'], 'uf*', 'pf*'); 
end


%Para pintar en 2D funciones de utilidad de 2 issues
% ni=2;
% figure
% d=[zeros(1,ni);...
%     ones(1,ni)];
% ezmeshc(@(x,y) fr([x y]), reshape(d, 1, numel(d)));
% hold on;
% ezmeshc(@(x,y) fl([x y]), reshape(d, 1, numel(d)));

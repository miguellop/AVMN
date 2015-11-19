function genhbetafunctions(ni) 
%GENHBETAFUNCTIONS crea y almacena un cell-array uf de tama�o {nrows}{ncols} de
%funciones de utilidad heterog�nea Beta de NI issues.
%   NROWS define el n�mero de sets de funciones de utilidad.
%   NCOLS define el n�mero de agentes. En definitiva, cada nrow hay ncols
%   agentes y por tanto funciones de utilidad.
%
%   La funci�n almacena en un fichero el cell con nrows*ncols funciones de
%   utilidad, con el nombre "UFHB20i" para el caso de 20 issues, o "UFHB100i"
%   para 100 issues, ... Almacena adem�s en un cell-array pf de tama�o
%   {nrows}{ncols} que almacena por cada elemento una estructura con los
%   elementos .fval, .nash, .sw y .kalai. pf{nrow,1} siempre es una cell
%   vac�a. pf{nrow,2} representa la estructura del frente de pareto para el
%   set nrow y dos agentes: uf{nrow}{1} y uf{nrow}{2}. pf{nrow,10}
%   representa por tanto el set nrow y 10 agentes: uf{nrow}{1},
%   uf{nrow}{2}, ..., uf{nrow}{10}

    domain = [zeros(1,ni);ones(1,ni)];
    abc.uniform = [1 1 0];
    abc.bell_shaped = [5 5 1.75];
    abc.left_skewed = [6 2 1]; 
    abc.right_skewed = [2 6 1];
    
    disp('Generating Beta Functions');
    
    fu =fbeta(abc.('uniform'), ni, domain, 'het');
    fb =fbeta(abc.('bell_shaped'), ni, domain, 'het');
    fl =fbeta(abc.('left_skewed'), ni, domain, 'het');
    fr =fbeta(abc.('right_skewed'), ni, domain, 'het');
    fh =fbeta([], ni, domain, 'hom');
    
    nrows = 1;
    ncols = 4;
    uf{1}{1} = fl;
    uf{1}{2} = fr;
    uf{1}{3} = fl;
    uf{1}{4} = fr;
    
    disp('Generating Pareto Frontiers');
    pf = getparetofronts(uf, ni, nrows, ncols);
    save(['UFHB' num2str(ni) 'i'], 'uf*', 'pf*');
end


%Para pintar en 2D funciones de utilidad de 2 issues
% ni=2;
% figure
% d=[zeros(1,ni);...
%     ones(1,ni)];
% ezmeshc(@(x,y) fr([x y]), reshape(d, 1, numel(d)));
% hold on;
% ezmeshc(@(x,y) fl([x y]), reshape(d, 1, numel(d)));

    function U = fu1(res, options)
    %FU1 Generador de utilidades gaussianas.
    %   U = FUTIL1(RES, OPTIONS) retorna un vector
    %   U de NRES filas y 1 columna. RES es una matriz NINTERVALOSx3. 
    %   Cada fila define un valor de utilidad.
    %   Los valores de utilidad se generan entre 0 y 1 conforme a una
    %   distribución Normal de media MEDIA y desviación típica DESV. Los
    %   valores de mapeo están comprendidos entre 0 y 1. Los valores MEDIA y
    %   DESV vienen dados en OPTIONS en forma de string.

        %eval(options);
        %U = normpdf(linspace(0,9, size(res, 1)), media*10, desv*10)*10000;
        U = unifrnd(0,200,size(res,1),1);
        %U = 50*ones(1, size(res,1))';
        %U = U'/max(U);

    function U = fu2(res, options)
    %FU2 Generador de utilidades gaussianas.
    %   U = FUNCIONUTILIDAD1(RES, OPTIONS) retorna un vector
    %   U de NRES filas y 1 columna. RES es una matriz NINTERVALOSx3. 
    %   Cada fila define un valor de utilidad.
    %   Los valores de utilidad se generan entre 0 y 1 conforme a una
    %   distribución Normal de media MEDIA y desviación típica DESV. Los
    %   valores de mapeo están comprendidos entre 0 y 1. Los valores MEDIA y
    %   DESV vienen dados en OPTIONS en forma de string.

        eval(options);
        %U = normpdf(linspace(0,1, size(res, 1)), media, desv);
        %U = unifrnd(0,1,1,size(res,1));
        U = unifrnd(0,200,size(res,1),1);
        %U = 100*ones(size(res,1),1);
        %U = U'/max(U);

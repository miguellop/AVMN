function [u] = frsgr (x, sgr, d)
%FRSGR Permite obtener el valor de utilidad de los valores de
%entrada XA, en relación con la función basada en restricciones definida
%por SGR, restringida a un dominio D
%
%   La función recibe como parámetros XA, que es un array de puntos donde
%   cada fila es punto, y el número de columnas es igual al número de
%   variables. SGR es una estructura que incluye una matriz 3D de restricciones 
%   con tantas filas como restricciones, 3 columnas (limInf, limSup,
%   Utilidad), y una tercera dimensión para describir la variable. D es una
%   matriz de dominios de los issues (en forma [0 0 0...; 1 1 1...]). Si un
%   punto de entrada tiene uno o más valores fuera del dominio D, el valor
%   de utilidad que se asigna es 0.

%   Para el caso especial de un XA procedente de utilizar la función
%   MESHGRID, el formato de entrada será una estructura XA.X, XA.Y de
%   matrices pareadas. En este caso la función transforma al formato de una
%   sóla matriz, y en el retorno U se transforma a formato MESHGRID (es
%   decir a formato matriz).
%   Retorna un vector U con una utilidad por punto de entrada.

    if isstruct (x)%Caso de llamada a la función con MESHGRID. Este caso sólo es
                                %válido para dos dimensiones (dos variables).
        xa = x;
        x =reshape(xa.x, numel(xa.x), 1);
        y = reshape(xa.y, numel(xa.y), 1);
        x = [x y];
    end
    
    np = size(x, 1);
    x = x';
    
    for iV = 1:sgr.nv %recorrido de variables
        xr = repmat(x(iV, :), sgr.nr, 1);
        sat(:, :, iV) = (xr >= repmat(sgr.R(:, 1, iV), 1, np)) & ...
            (xr <= repmat(sgr.R(:, 2, iV), 1, np));
    end
    u = repmat(sum(reshape(sgr.R(:, 3, :), sgr.nr, sgr.nv), 2), 1, np); %cálculo de utilidades
    u = sum(u.*all(sat,3));
    
    %los puntos fuera de dominio toman valor 0
    u(any(x < repmat(d(1,:)', 1, np) | x > repmat(d(2,:)', 1, np))) = 0;
    
    if exist('xa','var')
        u = reshape(u, size(xa.x,1),size(xa.x,2));
    else
        u=u';
    end
   



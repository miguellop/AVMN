function [u] = frsgr (x, sgr, d)
%FRSGR Permite obtener el valor de utilidad de los valores de
%entrada XA, en relaci�n con la funci�n basada en restricciones definida
%por SGR, restringida a un dominio D
%
%   La funci�n recibe como par�metros XA, que es un array de puntos donde
%   cada fila es punto, y el n�mero de columnas es igual al n�mero de
%   variables. SGR es una estructura que incluye una matriz 3D de restricciones 
%   con tantas filas como restricciones, 3 columnas (limInf, limSup,
%   Utilidad), y una tercera dimensi�n para describir la variable. D es una
%   matriz de dominios de los issues (en forma [0 0 0...; 1 1 1...]). Si un
%   punto de entrada tiene uno o m�s valores fuera del dominio D, el valor
%   de utilidad que se asigna es 0.

%   Para el caso especial de un XA procedente de utilizar la funci�n
%   MESHGRID, el formato de entrada ser� una estructura XA.X, XA.Y de
%   matrices pareadas. En este caso la funci�n transforma al formato de una
%   s�la matriz, y en el retorno U se transforma a formato MESHGRID (es
%   decir a formato matriz).
%   Retorna un vector U con una utilidad por punto de entrada.

    if isstruct (x)%Caso de llamada a la funci�n con MESHGRID. Este caso s�lo es
                                %v�lido para dos dimensiones (dos variables).
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
    u = repmat(sum(reshape(sgr.R(:, 3, :), sgr.nr, sgr.nv), 2), 1, np); %c�lculo de utilidades
    u = sum(u.*all(sat,3));
    
    %los puntos fuera de dominio toman valor 0
    u(any(x < repmat(d(1,:)', 1, np) | x > repmat(d(2,:)', 1, np))) = 0;
    
    if exist('xa','var')
        u = reshape(u, size(xa.x,1),size(xa.x,2));
    else
        u=u';
    end
   



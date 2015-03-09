function [f] = fagg(uf)
% uf-cell array de funciones de utilidad a agregar para calcular la suma
f= @(x) funcion_agg(x, uf);
end


function z = funcion_agg (x, uf)
    z=0;
    
    for i=1:length(uf)
        z = uf{i}(x)+z;
    end
   
    z(x(:,1)<0 | x(:,2)<0) = 0;
    z(x(:,1)>100 | x(:,2)>100) = 0;
    
end

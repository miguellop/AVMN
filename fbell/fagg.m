function [f] = fagg(uf)
% uf-cell array de funciones de utilidad a agregar para calcular la suma
f= @(x,y) funcion_agg(x, y, uf);
end


function z = funcion_agg (x, y, uf)
    z=0;
    
    for i=1:length(uf)
        z = uf{i}(x,y)+z;
    end
   
    z(x<0 | y<0) = 0;
    z(x>100 | y>100) = 0;
    
end

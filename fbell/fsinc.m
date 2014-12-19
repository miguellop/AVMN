function [f] = fsinc(c, t, delta)
%c-centros
%r-radios
%h-alturas

f= @(x,y) funcion_sinc(x, y, c, t, delta);
end


function z = funcion_sinc (x, y, c, Tcos, delta)
    Texp = 100;
    r = (1+cos(sqrt(((x-c(1))./Tcos).^2+((y-c(2))./Tcos).^2)))/2;
    m = exp(-1.5*...
        sqrt(((x-c(1))./Texp).^2+...
        ((y-c(2))./Texp).^2));
    
%Generación de Planos. Se utilizaba con la generación de función sinc
%original
%     if all(c==0)
%         
%         m = x./400+y./400;
%         
%     elseif all(c==100)
%         
%         m = -1*x./400-y./400+0.5;
%         
%     elseif c(1)==100 && c(2) == 0
%         
%         m = y./400-x./400+0.25;
%         
%     else
%         
%         m = -1*y./400+x./400+0.25;
%         
%     end
%     
%     m = 1-m.*delta;
    
    
    z = r.*m;
   
    z(x<0 | y<0) = 0;
    z(x>100 | y>100) = 0;
    
end

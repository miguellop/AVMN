function f = fcournotA(b, type, norm)
    d = [0 0;100 100];
    options = saoptimset('Display','off');
    if norm
        [x maxval] = simulannealbnd(@(x) -1.*funcion_cournotA(x, d, b, type, false), unifrnd(d(1,:),d(2,:)), d(1,:),d(2,:), options);
        [x minval] = simulannealbnd(@(x) funcion_cournotA(x, d, b, type, false), unifrnd(d(1,:),d(2,:)), d(1,:),d(2,:), options);
        f= @(xa, d) funcion_cournotA(xa, d, b, type, true, minval,-1*maxval);
    else
        f= @(xa, d) funcion_cournotA(xa, d, b, type, false);
    end
end

function z = funcion_cournotA(xa, d, b, type, norm, minval, maxval)
    if isstruct (xa)
        x=xa.x; y=xa.y;
    else
        x=xa(:,1); y=xa(:,2);         
    end
    if type==0
        z =  x.*(b(1)-b(3)*x-b(4)*y)-b(5).*x-b(7).*x.^2;
    else
        z =  y.*(b(2)-b(3)*x-b(4)*y)-b(6).*y-b(8).*y.^2;
    end
    if norm
        z = (z-minval)/(maxval-minval);
    end
%  z(x<d(1,1) | y<d(1,2)) = 0;
%  z(x>d(2,1) | y>d(2,2)) = 0;
    
    z(x<0 | y<0) = 0;
    z(x>100 | y>100) = 0;
end
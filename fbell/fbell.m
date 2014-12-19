function [f ] = fbell(np, ni, r, h, norm)
%np-número de picos
%ni-número de issues
%r-rango de radios
%h-rango de alturas
%norm-flag de normalización a utilidad 1
    options = saoptimset('Display','off');
    d = [zeros(1,ni);100*ones(1,ni)];
    cv = unifrnd(0,100,np,ni);
    rv = unifrnd(r(1),r(2),np,1);
    hv = unifrnd(h(1),h(2),np,1);
    if norm
        [x mval] = simulannealbnd(@(x) -1.*funcion_bell(x(1),x(2),np,cv,rv,hv,false,0), unifrnd(0,100,1,2), [0 0], [100 100], options);
        f= @(x,y) funcion_bell(x, y, np, cv, rv, hv, true, -1*mval);
    else
        f= @(x,y) funcion_bell(x, y, np, cv, rv, hv, false);
    end
end

function z = funcion_bell (x, y, npeaks, c, r, h, norm, m)
    z = zeros(size(x));
    
    for i=1:npeaks
        dist = sqrt((x-c(i,1)).^2+ (y-c(i,2)).^2);
        ind = dist<(r(i)./2);
        z(ind) = z(ind)+h(i)-2*h(i)*dist(ind).^2./r(i).^2;
        ind = dist>=(r(i)./2) & dist<r(i);
        z(ind) = z(ind)+(2.*h(i)./r(i).^2).*(dist(ind)-r(i)).^2;
    end
    
    if norm
        z = z./m;
    end
    
    z(x<0 | y<0) = 0;
    z(x>100 | y>100) = 0;
end
function [f] = fbellfix(c, r, h, norm)
%c-centros
%r-radios
%h-alturas
% ej: fbellfix([50 50;25 25],[10 20], [1 0.5]);
    d = repmat(0:100, 1, size(c,2));
    options = saoptimset('Display','off');
    d = [0 0;100 100];
    np = size(c,1);
    if norm
        [x mval] = simulannealbnd(@(x) -1.*funcion_bell(x,d,np,c,r,h,false), unifrnd(d(1,:),d(2,:)), d(1,:),d(2,:), options);
        f= @(x) funcion_bell(x,np, c, r, h, true, -1*mval);
    else
        f= @(x) funcion_bell(x,np, c, r, h, false);
    end
end

function y = funcion_bell (x, npeaks, c, r, h, nor, m)
    npoints = size(x,1);
    y = zeros(1,npoints);
    for j=1:npoints
        z = 0;
        for i=1:npeaks
            dist = norm(x(j,:)-c(i,:));
            ind = dist<(r(i)./2);
            z(ind) = z(ind)+h(i)-2*h(i)*dist(ind).^2./r(i).^2;
            ind = dist>=(r(i)./2) & dist<r(i);
            z(ind) = z(ind)+(2.*h(i)./r(i).^2).*(dist(ind)-r(i)).^2;
        end
        if nor
            z = z./m;
        end
        y(j) = z;
    end
    
    y(not(prod(x>=0 & x<=100,2))) = 0;
    
end
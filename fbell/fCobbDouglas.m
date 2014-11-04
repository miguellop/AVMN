function f = fCobbDouglas(gamma, alfa, type, norm)
    d = [0 0;100 100];
    options = saoptimset('Display','off');
    if norm
        [x maxval] = simulannealbnd(@(x) -1.*funcion_CD(x, d, gamma, alfa, type, false), unifrnd(d(1,:),d(2,:)), d(1,:),d(2,:), options);
        [x minval] = simulannealbnd(@(x) funcion_CD(x, d, gamma, alfa, type, false), unifrnd(d(1,:),d(2,:)), d(1,:),d(2,:), options);
        f= @(xa, d) funcion_CD(xa, d, gamma, alfa, type, true, minval,-1*maxval);
    else
        f= @(xa, d) funcion_CD(xa, d, gamma, alfa, type, false);
    end
end

function z = funcion_CD(xa, d, gamma, alfa, type, norm, minval, maxval)
    if isstruct (xa)
        x=xa.x; y=xa.y;
    else
        x=xa(:,1); y=xa(:,2);         
    end
    if norm
        if type==1
            z = (gamma.*(x.^alfa(1).*y.^alfa(2))-minval)/(maxval-minval);
        else
            z = (gamma.*((100-x).^alfa(1).*(100-y).^alfa(2))-minval)/(maxval-minval);
        end
    else
        if type==1
            z = gamma.*(x.^alfa(1).*y.^alfa(2));
        else
            z = gamma.*((100-x).^alfa(1).*(100-y).^alfa(2));
        end
    end    
    
    z(x<0 | y<0) = 0;
    z(x>100 | y>100) = 0;
end
function f = fcournotB(Q, beta, alfa, type, norm)
    d = [0 0;100 100];
    options = saoptimset('Display','off');
    if norm
        [x maxval] = simulannealbnd(@(x) -1.*funcion_cournotB(x, d, Q, beta, alfa, type, false), unifrnd(d(1,:),d(2,:)), d(1,:),d(2,:), options);
        [x minval] = simulannealbnd(@(x) funcion_cournotB(x, d, Q, beta, alfa, type, false), unifrnd(d(1,:),d(2,:)), d(1,:),d(2,:), options);
        f= @(xa, d) funcion_cournotB(xa, d, Q, beta, alfa, type, true, minval,-1*maxval);
    else
        f= @(xa, d) funcion_cournotB(xa, d, Q, beta, alfa, type, false);
    end
end

function z = funcion_cournotB(xa, d, Q, beta, alfa, type, norm, minval, maxval)
    if isstruct (xa)
        x=xa.x; y=xa.y;
    else
        x=xa(:,1); y=xa(:,2);         
    end
    if type == 0
        aux = y; y = x; x = aux; 
    end
    if norm
        z = (log(x+eps)+beta.*log(0.5*(Q-x-y).^alfa)-minval)/(maxval-minval);
    else
        z = log(x+eps)+beta.*log(0.5*(Q-x-y).^alfa);
    end
    
    z(x<0 | y<0) = 0;
    z(x>100 | y>100) = 0;
end
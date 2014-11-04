function f = fCES(type, norm)
    d = [0 0;100 100];
    options = saoptimset('Display','off');
    if norm
        [x maxval] = simulannealbnd(@(x) -1.*funcion_CES(x, d, type, false), unifrnd(d(1,:),d(2,:)), d(1,:),d(2,:), options);
        [x minval] = simulannealbnd(@(x) funcion_CES(x, d, type, false), unifrnd(d(1,:),d(2,:)), d(1,:),d(2,:), options);
        f= @(xa, d) funcion_CES(xa, d, type, true, minval,-1*maxval);
    else
        f= @(xa, d) funcion_CES(xa, d, type, false);
    end
end

function z = funcion_CES(xa, d, type, norm, minval, maxval)
    beta1 = 0.3; beta2 = 0.3;
    alfa1 = unifrnd(0,1,1,2); alfa1 = alfa1./sum(alfa1);
    alfa2 = unifrnd(0,1,1,2); alfa2 = alfa2./sum(alfa2);
    if isstruct (xa)
        x=xa.x; y=xa.y;
    else
        x=xa(:,1); y=xa(:,2);         
    end
    if type == 0
        if norm
            z = (100.*(alfa1(1).*x.^beta+alfa1(2).* y.^beta).^(1/beta)-minval)/(maxval-minval);
        else
            z = 100.*(alfa1(1).*x.^beta+alfa1(2).* y.^beta).^(1/beta);
        end
    else
        if norm
            z = (100.*(alfa2(1).*x.^beta+alfa2(2).* y.^beta).^(1/beta)-minval)/(maxval-minval);
        else
            z = 100.*(alfa2(1).*x.^beta+alfa2(2).* y.^beta).^(1/beta);
        end
    end
    
    z(x<0 | y<0) = 0;
    z(x>100 | y>100) = 0;
end
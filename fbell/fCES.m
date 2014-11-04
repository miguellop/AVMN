function f = fCES(d, gamma, beta, alfa, r, type, norm)
    options = saoptimset('Display','off');
    if norm
        [x maxval] = simulannealbnd(@(x) -1.*funcion_CES(x, d, gamma, beta, alfa, r, type, false), unifrnd(d(1,:),d(2,:)), d(1,:),d(2,:), options);
        f= @(xa, d) funcion_CES(xa, d, gamma, beta, alfa, r, type, true, -1*maxval);
    else
        f= @(xa, d) funcion_CES(xa, d, gamma, beta, alfa, r, type, false);
    end
end

function z = funcion_CES(xa, d, gamma, beta, alfa, r, type, norm, maxval)
    ns = size(xa,1);
    if isstruct (xa)
        x=xa.x; y=xa.y;
        if norm
            if type==1
                z = (gamma.*(alfa(1).*x.^beta+alfa(2).* y.^beta).^(r/beta))/maxval;
            else
                z = (gamma.*(alfa(1).*(100-x).^beta+alfa(2).* (100-y).^beta).^(r/beta))/maxval;
            end
        else
            if type==1
                z = gamma.*(alfa(1).*x.^beta+alfa(2).* y.^beta).^(r/beta);
            else
                z = gamma.*(alfa(1).*(100-x).^beta+alfa(2).*(100-y).^beta).^(r/beta);
            end
        end    
        z(x<0 | y<0) = 0;
        z(x>100 | y>100) = 0;
    else
        xa = xa';
        if norm
            if type==1
                z = (gamma.*sum(repmat(alfa',1,ns).*(xa.^beta)).^(r/beta))/maxval;
            else
                z = (gamma.*sum(repmat(alfa',1,ns).*((100-xa).^beta)).^(r/beta))/maxval;
            end
        else
            if type==1
                z = gamma.*sum(repmat(alfa',1,ns).*(xa.^beta)).^(r/beta);
            else
                z = gamma.*sum(repmat(alfa',1,ns).*((100-xa).^beta)).^(r/beta);
            end
        end    
        z(logical(sum(xa<0))) = 0;
        z(logical(sum(xa>100))) = 0;
        z=z';
    end
end
%      z(x<d(1,1) | y<d(1,2)) = 0;
% z(x>d(2,1) | y>d(2,2)) = 0;
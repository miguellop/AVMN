function [f ] = flinear(w, norm)
%w-vector de pesos
%norm-flag de normalización a utilidad 1
    options = saoptimset('Display','off');
    ni = length(w);
    d = [zeros(1,ni);100*ones(1,ni)];
    if norm
        [x mval] = simulannealbnd(@(x) -1.*funcion_linear(x,d,w, false), unifrnd(d(1,:),d(2,:)), d(1,:),d(2,:), options);
        f= @(xa, d) funcion_linear(xa, d, w, true, -1*mval);
    else
        f= @(xa, d) funcion_linear(xa, d, w, false);
    end
end

function z = funcion_linear (xa, d, w, norm, m)
    if isstruct (xa)
        x=xa.x; y=xa.y; %Para representación gráfica con meshgrid
        z = x.*w(1)+y.*w(2);
        if norm
            z = z/m;
        end
        z(x<0 | y<0) = 0;
        z(x>100 | y>100) = 0;
    else
        xa = xa';
        z = sum(xa.*repmat(w', 1, size(xa,2)));
        if norm
            z = z/m;
        end
        z(logical(sum(xa<0))) = 0;
        z(logical(sum(xa>100))) = 0;
        z = z';
    end
    
%  z(x<d(1,1) | y<d(1,2)) = 0;
% z(x>d(2,1) | y>d(2,2)) = 0;

end
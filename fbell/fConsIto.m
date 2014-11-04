function [f C] = fConsIto(d, n, L, norm, nc)
    % n->número de issues, L->[lmin,lmax]Ancho máximo de
    % restricciones, nc->nconstraints=nc*n
    [C l] = genconstraints(n, d(2,1), L, 1, 1, nc); % Se generan las restricciones
    options = saoptimset('Display','off');
    if norm
        [x maxval] = simulannealbnd(@(x) -1.*funcion_ConsIto(x, d, C, false), unifrnd(d(1,:),d(2,:)), d(1,:), d(2,:), options);
        f= @(xa, d) funcion_ConsIto(xa, d, C, true, -1*maxval);
    else
        f= @(xa, d) funcion_ConsIto(xa, d, C, false);
    end
end

function z = funcion_ConsIto(xa, d, C, norm, maxval)
    if isstruct (xa)
        x=xa.x; y=xa.y; % Aquí los datos vienen dados en forma de matrices x e y
        if norm
                z = utility(xa, C)/maxval;
        else
                z = utility(xa, C);
        end    
        z(x<0 | y<0) = 0;
        z(x>d(2,1) | y>d(2,1)) = 0;
    else
        if norm
                z = utility(xa, C)/maxval;
        else
                z = utility(xa, C);
        end    
        z(logical(sum(xa<0))) = 0;
        z(logical(sum(xa>100))) = 0;
        z=z';
    end
end
% z(x<d(1,1) | y<d(1,2)) = 0;
% z(x>d(2,1) | y>d(2,2)) = 0;
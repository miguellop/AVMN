function z = utility(x,C)
% Calcula la utilidad del contrato X en funcion del conjunto de
% restricciones C
if isstruct(x)
    [nr nc] = size(x.x);
    z = zeros(nr,nc);
    for i=1:nr
        for j=1:nc
            for k=1:length(C)
                if satisfies([x.x(i,j) x.y(i,j)], C(k))
                    z(i,j) =z(i,j)+C(k).u;
                end
            end
        end
    end
else
    n = size(x, 1);
    z = zeros(1, n);
    for i=1:n
        z(i) = 0;
        for j=1:length(C)
            if satisfies(x(i,:),C(j))
                z(i) = z(i)+C(j).u;
            end 
        end
    end
end
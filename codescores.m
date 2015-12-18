%% Codificamos cada fila de valores binarios como un número binario
function y = codescores(scores)
    [nr,nc] = size(scores);
    y = zeros(nr,1);
    for i=1:nc
        y = y+scores(:,i)*2^(nc-i);
    end
end
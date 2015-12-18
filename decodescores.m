%% Decodificamos cada fila de caracteres binarios como valores binarios
function y = decodescores(scores,na)
    scores = dec2bin(scores,na);
    y = [];
    for i=1:na
        y = [y,str2num(scores(:,i))];
    end
end
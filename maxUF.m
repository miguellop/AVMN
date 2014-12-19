%%
%Cálculo de máximos y mínimos del Social Welfare de las funciones de
%utilidad generadas
load UFrandom;

d = [0 0;100 100];
% [x fval exitflag] = obtenerFronteraParetoGlobal(UF, 2, [0 0;100 100], 200, 60);
% [ymax i] = max(sum(fval'));

% maxuf = @(x) -1*(UF{1}(x,d)+UF{2}(x,d)+UF{3}(x,d)+UF{4}(x,d)+UF{5}(x,d)+UF{6}(x,d)+UF{7}(x,d));

maxuf = @(x) -1*(UF{1}(x,d)+UF{2}(x,d)+UF{3}(x,d)+UF{4}(x,d));

    [xmax ymax] = patternsearch(maxuf, rand(1,2)*100,[],[],[],[],[0 0],[100 100]);
    xmax
    ymax*-1

% minuf = @(x) UF{1}(x,d)+UF{2}(x,d)+UF{3}(x,d)+UF{4}(x,d)+UF{5}(x,d)+UF{6}(x,d)+UF{7}(x,d);
% minuf = @(x) UF{1}(x,d)+UF{2}(x,d);
% [xmin ymin] = patternsearch(minuf, [50 50]);
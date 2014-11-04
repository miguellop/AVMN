%%
%BELLs Random (UFrandom)

ni = 2; %nissues
na = 1; %nagents
d=[zeros(1,ni);100*ones(1,ni)];

for index = 1:na
    p = [0.15 0.4];% p fija la complejidad de las bells
    r = @(d,n)  (d*(100^n)*gamma(n/2+1)/pi^(n/2))^(1/n);
    f = fbell(4, ni,[r(p(1),ni) r(p(2),ni)],[0.1 1],true);
    UF{index} = f;
end

%[x.x, x.y]=meshgrid(linspace(0,100,100));
%[C h]=  contour(x.x,x.y,f(x,d),5,'LineStyle',':'); clabel(C, h,'manual','fontsize',15);

save UFrandom UF

figure
for i=1:na
    plotSurfs(UF{i});
    hold on;
end
axis auto
%%
%BELL testbed (UFfix)
centers = [35 35; 65 65];

w = [50 50];

h = [1,1];

for i=1:2
    UF{i} = fbellfix(centers(i,:),w(i),h(i), false);
end
save UFfix UF

% [x.x, x.y]=meshgrid(linspace(0,100,100));
% [C h]=  contour(x.x,x.y,UF{1}(x,d),5,'LineStyle',':'); clabel(C, h,'manual','fontsize',15);

figure
for i=1:2
    plotSurfs(UF{i});
    hold on;
end
axis auto

%%
%Cálculo de máximos y mínimos del Social Welfare de las funciones de
%utilidad generadas
load UFfix;

d = [0 0;100 100];
% [x fval exitflag] = obtenerFronteraParetoGlobal(UF, 2, [0 0;100 100], 200, 60);
% [ymax i] = max(sum(fval'));

% maxuf = @(x) -1*(UF{1}(x,d)+UF{2}(x,d)+UF{3}(x,d)+UF{4}(x,d)+UF{5}(x,d)+UF{6}(x,d)+UF{7}(x,d));

maxuf = @(x) -1*(UF{1}(x,d)+UF{2}(x,d));

[xmax ymax] = patternsearch(maxuf, rand(1,2)*100)

% minuf = @(x) UF{1}(x,d)+UF{2}(x,d)+UF{3}(x,d)+UF{4}(x,d)+UF{5}(x,d)+UF{6}(x,d)+UF{7}(x,d);
% minuf = @(x) UF{1}(x,d)+UF{2}(x,d);
% [xmin ymin] = patternsearch(minuf, [50 50]);

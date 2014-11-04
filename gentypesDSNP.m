%%
% CES Utility Function
d=[0 0;100 100];
gamm = 0.01;
r1 = 1; r2 = 1;
beta1 = [0.0275 0.8251 0.0110 0.4719]; 
beta2 = [0.2705 0.6977 0.8810 0.7671];
alfa1 = [0.5159 0.4841; 0.9396 0.0604; 0.3703 0.6297; 0.9536 0.0464];
alfa2 = [0.6742 0.3258; 0.5322 0.4678; 0.4414 0.5586; 0.5080 0.4920];
for index=1:5
    CES = index;
    f1=fCES(d, gamm, beta1(CES), alfa1(CES,:), r1, 1, true);
    f2=fCES(d, gamm, beta2(CES), alfa2(CES,:), r2, 0, true);
    UF{2*index-1} = f1;
    UF{2*index} = f2;
end

%%
%BELLs Random
clf
colormap gray;
ni = 2;
d=[zeros(1,ni);100*ones(1,ni)];
[x.x x.y]=meshgrid(linspace(0,100,100));

for index = 1:7
    p = [0.15 0.4];%BELLs
    %p = [0.015 0.04];%BELLc
    r = @(d,n)  (d*(100^n)*gamma(n/2+1)/pi^(n/2))^(1/n);
    f = fbell(4, ni,[r(p(1),ni) r(p(2),ni)],[0.1 1],true);
    UF{index} = f;
end
%[C h]=  contour(x.x,x.y,f(x,d),5,'LineStyle',':'); clabel(C, h,
%'manual','fontsize',15);
%%
%BELLs Random1
clf
colormap gray;
ni = 2;
d=[zeros(1,ni);100*ones(1,ni)];
[x.x x.y]=meshgrid(linspace(0,100,100));

for index = 1:7
    p = [0.1 0.3];%BELLs
    %p = [0.015 0.04];%BELLc
    r = @(d,n)  (d*(100^n)*gamma(n/2+1)/pi^(n/2))^(1/n);
    f = fbell(4, ni,[r(p(1),ni) r(p(2),ni)],[0.1 1],true);
    UF{index} = f;
end
%save UFrandom1 UF
%[C h]=  contour(x.x,x.y,f(x,d),5,'LineStyle',':'); clabel(C, h,
%'manual','fontsize',15);

%BELLs Random2
clf
colormap gray;
ni = 2;
d=[zeros(1,ni);100*ones(1,ni)];
[x.x x.y]=meshgrid(linspace(0,100,100));

for index = 1:7
    p = [0.1 0.2];%BELLs
    %p = [0.015 0.04];%BELLc
    r = @(d,n)  (d*(100^n)*gamma(n/2+1)/pi^(n/2))^(1/n);
    f = fbell(4, ni,[r(p(1),ni) r(p(2),ni)],[0.1 1],true);
    UF{index} = f;
end
%save UFrandom2 UF
%[C h]=  contour(x.x,x.y,f(x,d),5,'LineStyle',':'); clabel(C, h,
%'manual','fontsize',15);
%%
%BELLs Random3
clf
colormap gray;
ni = 2;
d=[zeros(1,ni);100*ones(1,ni)];
[x.x x.y]=meshgrid(linspace(0,100,100));

for index = 1:7
    p = [0.1 0.1];%BELLs
    %p = [0.015 0.04];%BELLc
    r = @(d,n)  (d*(100^n)*gamma(n/2+1)/pi^(n/2))^(1/n);
    f = fbell(4, ni,[r(p(1),ni) r(p(2),ni)],[0.1 1],true);
    UF{index} = f;
end
%save UFrandom3 UF
%[C h]=  contour(x.x,x.y,f(x,d),5,'LineStyle',':'); clabel(C, h,
%'manual','fontsize',15);
%%
%BELL testbed
centers = [15 50; 25 50; 15 40; 25 40; 55 45; 70 45; 80 80];
%w = 18;
w = [20 20 20 20 20 20 20];
%w = 80*ones(1,7);
h = [1,1,1,1,1,1,1];
for i=1:7
    UF{i} = fbellfix(centers(i,:),w(i),h(i), false);
end
save UFfix UF
%%

figure
for i=1:7
    %subplot(4,2,i)
    plotSurfs(UF{i});
    hold on;
end
axis auto
%%
a=[];
for i=1:7
    a=[UF{i}(output.x,d) a];
end
%%
%Cálculo de máximos y mínimos del Social Welfare de las funciones de
%utilidad generadas
load UFrandom2;
%Calculo del frente de pareto
d = [0 0;100 100];
[x fval exitflag] = obtenerFronteraParetoGlobal(UF, 2, [0 0;100 100], 200, 60);
[ymax i] = max(sum(fval'));

% maxuf = @(x) -1*(UF{1}(x,d)+UF{2}(x,d)+UF{3}(x,d)+UF{4}(x,d)+UF{5}(x,d)+UF{6}(x,d)+UF{7}(x,d));
% [xmax ymax] = patternsearch(maxuf, [50 50]);
minuf = @(x) UF{1}(x,d)+UF{2}(x,d)+UF{3}(x,d)+UF{4}(x,d)+UF{5}(x,d)+UF{6}(x,d)+UF{7}(x,d);
[xmin ymin] = patternsearch(minuf, [50 50]);

%%
load UFfix;
%Calculo del frente de pareto
d = [0 0;100 100];
[x fval exitflag] = obtenerFronteraParetoGlobal(UF, 2, [0 0;100 100], 100, 60);
[ymax i] = max(sum(fval'));
% maxuf = @(x) -1*(UF{1}(x,d)+UF{2}(x,d)+UF{3}(x,d)+UF{4}(x,d)+UF{5}(x,d)+UF{6}(x,d)+UF{7}(x,d));
% [xmax ymax] = patternsearch(maxuf, 100*rand(1,2));
minuf = @(x) UF{1}(x,d)+UF{2}(x,d)+UF{3}(x,d)+UF{4}(x,d)+UF{5}(x,d)+UF{6}(x,d)+UF{7}(x,d);
[xmin ymin] = patternsearch(minuf, 100*rand(1,2));
% El máximo Social Welfare es: 3
% El mínimo es: 0
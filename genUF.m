%%
%BELLs Random (UFrandom)

ni = 2; %nissues
na = 4; %nagents
d=[zeros(1,ni);100*ones(1,ni)];

for index = 1:na
    p = [0.1 0.6];% p fija la complejidad de las bells
    r = @(d,n)  (d*(100^n)*gamma(n/2+1)/pi^(n/2))^(1/n);
    f = fbell(6, ni,[r(p(1),ni) r(p(2),ni)],[0.1 1],true);
    UF{index} = f;
end

%[x.x, x.y]=meshgrid(linspace(0,100,100));
%[C h]=  contour(x.x,x.y,f(x,d),5,'LineStyle',':'); clabel(C, h,'manual','fontsize',15);

save UFrandom UF

%%
%BELL fix 
centers = [25 75 25 75; 25 25 75 75]';

w = [100 100 100 100];

h = [1,1,1,1];

for i=1:4
    UF{i} = fbellfix(centers(i,:),w(i),h(i), false);
end
save UFfix UF

% [x.x, x.y]=meshgrid(linspace(0,100,100));
% [C h]=  contour(x.x,x.y,UF{1}(x,d),5,'LineStyle',':'); clabel(C, h,'manual','fontsize',15);

%%
%BELL fix con dos bells para mostrar como funciona GPS
centers = [25 75; 25 75]';

w = [100 100];

h = [1,1];

for i=1:2
    UF{i} = fbellfix(centers(i,:),w(i),h(i), false);
end
save UFfixforGPS UF

% [x.x, x.y]=meshgrid(linspace(0,100,100));
% [C h]=  contour(x.x,x.y,UF{1}(x,d),5,'LineStyle',':'); clabel(C, h,'manual','fontsize',15);


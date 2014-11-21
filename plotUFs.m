%%
figure
for i=1:na
    plotSurfs(UF{i});
    hold on;
end
axis auto
%%
clf
d=[0 0;100 100];

for i=1:4
        subplot(2,2,i);
        fB = UF{i};
        [xa.x xa.y]=meshgrid(linspace(d(1,1), d(2,1),10));
        colormap('default')
        ezmeshc(@(x,y) fB([x y], d), reshape(d, 1, numel(d)));
        hold on;
end
axis auto
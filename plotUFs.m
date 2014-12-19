%%
figure
for i=1:4
    plotSurfs(uf{1}{i});
    hold on;
end
axis auto
%%
figure
d=[0 0;100 100];
colormap('default')
for i=1:4
        subplot(2,2,i);
        ezmeshc(@(x,y) uf{1}{i}(x,y), reshape(d, 1, numel(d)));
        hold on;
end
axis auto
function plotquotafcn(generations,MaxPopulationSize,generation,quota,popsize)
    switch generation
        case 1
            cla
            hold on;
            set(gca,'xlim',[0,generations]);
            set(gca,'ylim',[0,MaxPopulationSize]);
            xlabel('Generation','interp','none');
            ylabel('Quota','interp','none');
            plotquota = plot(generation, quota, 'o', 'MarkerSize', 5);
            set(plotquota,'Tag','plotquota');
            title('Quota','interp','none')
            box off;grid off;
        case generations
            LegnD = legend('Quota');
            set(LegnD,'FontSize',8);
            hold off;
        otherwise
            set(gca,'ylim',[0,MaxPopulationSize]);
            plotquota = findobj(get(gca,'Children'),'Tag','plotquota');
            plot(generation, [quota popsize], 'o', 'MarkerSize', 5);
            
        
    end
end
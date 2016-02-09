function plotquotafcn(generations,MaxPopulationSize,generation,quota,popsize)
    switch generation
        case 1
            cla
            hold on;
            set(gca,'xlim',[0,generations]);
            set(gca,'ylim',[0,MaxPopulationSize]);
            xlabel('Generation','interp','none');
            ylabel('Quota','interp','none');
            plotquota = plot(generation, quota);
            set(plotquota,'Tag','plotquota');
            title('Quota','interp','none')
            box off;grid off;
        case generations
            
            hold off;
        otherwise
            set(gca,'ylim',[0,MaxPopulationSize+5]);
            plotquota = findobj(get(gca,'Children'),'Tag','plotquota');
            plot(generation, quota, 'x',generation, popsize, 'o', 'MarkerSize', 3);
          
        
    end
end
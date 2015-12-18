function plotrewardsfcn(options,CurrentAgents,generation,x)
    switch generation
        case 1
            clf
            y = CurrentAgents(x);
            hold on;
            set(gca,'xlim',[0,options.Generations]);
            set(gca,'ylim',[0 1]);
            xlabel('Generation','interp','none');
            ylabel('Rewards','interp','none');
            plotrewards = plot(generation, y, 'o', 'MarkerSize', 3);
            set(plotrewards,'Tag','plotrewards');
            title('Rewards','interp','none')
            box;grid;

        case options.Generations
            LegnD = legend('Rewards');
            set(LegnD,'FontSize',8);
            y = CurrentAgents(x);
            plotrewards = findobj(get(gca,'Children'),'Tag','plotrewards');
            plot(generation, y, 'o', 'MarkerSize', 3);
            drawnow();
            hold off;
            
        otherwise
            y = CurrentAgents(x);
            plotrewards = findobj(get(gca,'Children'),'Tag','plotrewards');
            plot(generation, y, 'o', 'MarkerSize', 3);
            drawnow();

    end
end


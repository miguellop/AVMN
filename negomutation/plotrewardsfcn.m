function plotrewardsfcn(generations,y,generation)

    switch generation
        case 1
            cla
            hold on;
            set(gca,'xlim',[0,generations]);
            set(gca,'ylim',[0 1]);
            xlabel('Generation','interp','none');
            ylabel('Rewards','interp','none');
            plotrewards = plot(generation, y, 'o', 'MarkerSize', 3);
            set(plotrewards,'Tag','plotrewards');
            title('Rewards','interp','none')
            box on;grid on;

        case generations
            LegnD = legend('Rewards');
            set(LegnD,'FontSize',8);
            plotrewards = findobj(get(gca,'Children'),'Tag','plotrewards');
            plot(generation, y, 'o', 'MarkerSize', 3);
            drawnow();
            hold off;
            
        otherwise
            plotrewards = findobj(get(gca,'Children'),'Tag','plotrewards');
            plot(generation, y, 'o', 'MarkerSize', 3);
            drawnow();

    end
end


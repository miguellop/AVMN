function plotscorefcn(generations,generation,score)
    switch generation
        case 1
            cla
            hold on;
            set(gca,'xlim',[0,generations]);
            set(gca,'ylim',[-0.1,1.1]);
            xlabel('Generation','interp','none');
            ylabel('Score','interp','none');
            plotscore = plot(generation, score, 'o', 'MarkerSize', 5);
            set(plotscore,'Tag','plotscore');
            title('Score','interp','none')
            box off;grid off;
        case generations
            LegnD = legend('Score');
            set(LegnD,'FontSize',8);
            hold off;
        otherwise
            plotscore = findobj(get(gca,'Children'),'Tag','plotscore');
            plot(generation, score, 'o', 'MarkerSize', 5);
        
    end
end


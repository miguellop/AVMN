function plotcumscorefcn(generations,generation,cumscore)
    switch generation
        case 1
            cla
            hold on;
            set(gca,'xlim',[0,generations]);
            set(gca,'ylim',[0,generations]);
            xlabel('Generation','interp','none');
            ylabel('CumScore','interp','none');
            plotcumscore = plot(generation, cumscore, 'o', 'MarkerSize', 3);
            set(plotcumscore,'Tag','plotcumscore');
            title('CumScore','interp','none')
            box on;grid on;
        case generations
            LegnD = legend('CumScore');
            set(LegnD,'FontSize',8);
            hold off;
        otherwise
            plotcumscore = findobj(get(gca,'Children'),'Tag','plotcumscore');
            plot(generation, cumscore, 'o', 'MarkerSize', 3);
        
    end
end


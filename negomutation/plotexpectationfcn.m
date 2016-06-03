function plotexpectationfcn(generations,generation,expectation)
    switch generation
        case 1
            cla
            hold on;
            set(gca,'xlim',[0,generations]);
            set(gca,'ylim',[0,1.2]);
            xlabel('Generation','interp','none');
            ylabel('Expectation','interp','none');
            plotexpectation = plot(generation, expectation, 'o', 'MarkerSize', 3);
            set(plotexpectation,'Tag','plotexpectation');
            title('Expectation','interp','none')
            box on;grid on;
        case generations
            LegnD = legend('Expectation');
            set(LegnD,'FontSize',8);
            hold off;
        otherwise
            plotexpectation = findobj(get(gca,'Children'),'Tag','plotexpectation');
            plot(generation, expectation, 'o', 'MarkerSize', 3);
        
    end
end


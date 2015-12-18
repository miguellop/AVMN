function state = plotwinnercounterfcn(options, state, flag)
    global negostate;
    switch flag
        case 'init'
            win = zeros(1,negostate.nAgents);
            hold on;
            set(gca,'xlim',[0,options.Generations]);
            set(gca,'ylim',[0,options.Generations]);
            xlabel('Generation','interp','none');
            ylabel('WinnerCounter','interp','none');
            plotwinnercounter = plot(state.Generation, win, 'o', 'MarkerSize', 3);
            set(plotwinnercounter,'Tag','plotwinnercounter');
            title('WinnerCounter','interp','none')
            box;grid;
        case 'iter'
            win = negostate.WinnerCounter;
            plotwinnercounter = findobj(get(gca,'Children'),'Tag','plotwinnercounter');
            plot(state.Generation, win, 'o', 'MarkerSize', 3);
        case 'done'
            LegnD = legend('WinnerCount');
            set(LegnD,'FontSize',8);
            hold off;
    end
end


function state = gaplotquota(options,state,flag)
global quota;

switch flag
    case 'init'
        
    case 'iter'
        if state.Generation == 1
            colors = {'ok','ok','og','oc','om','ok','xr','xb','xk','xc'};
            hold on;
            set(gca,'xlim',[0,options.Generations],'ylim',[0,options.PopulationSize]);
            xlabel('Generation','interp','none');
            ylabel('Quota','interp','none');
            for i=1:1
                plotquota = plot(state.Generation,0,colors{i},'MarkerSize',2);
                set(plotquota,'Tag',['plotquota' num2str(i)]);
            end
            title('Quota: ','interp','none')
        end
        Y(1) = quota;
        for i=1:1
            plotquota = findobj(get(gca,'Children'),'Tag',['plotquota' num2str(i)]);
            newX = [get(plotquota,'Xdata') state.Generation];
            newY = [get(plotquota,'Ydata') Y(i)];
            set(plotquota,'Xdata',newX, 'Ydata',newY);
        end
                
    case 'done'
        hold off;
end


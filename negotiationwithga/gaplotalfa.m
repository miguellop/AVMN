function state = gaplotalfa(options,state,flag)
%GAPLOTALFA Plots ALFA
%   STATE = GAPLOTALFA(OPTIONS,STATE,FLAG)
%

global ALFA;

switch flag
    case 'init'
        
    case 'iter'
        if state.Generation == 1
            colors = {'or','ok','og','oc','om','ok','xr','xb','xk','xc'};
            hold on;
            set(gca,'xlim',[0,options.Generations],'ylim',[-300,+300]);
            xlabel('Generation','interp','none');
            ylabel('ALFA','interp','none');
            for i=1:1
                plotalfa = plot(state.Generation,0,colors{i},'MarkerSize',1);
                set(plotalfa,'Tag',['plotalfa' num2str(i)]);
            end
            title('ALFA: ','interp','none')
        end
        Y(1) = ALFA;
        for i=1:1
            plotalfa = findobj(get(gca,'Children'),'Tag',['plotalfa' num2str(i)]);
            newX = [get(plotalfa,'Xdata') state.Generation];
            newY = [get(plotalfa,'Ydata') Y(i)];
            set(plotalfa,'Xdata',newX, 'Ydata',newY);
        end
                
    case 'done'
        hold off;
end


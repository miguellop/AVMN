function state = gaplotsupport(options,state,flag)
%GAPLOTSA Plots Support, Support Test
%   STATE = GAPLOTSUPPORT(OPTIONS,STATE,FLAG) plots S, ST.
%
global nag;
global S;
global ST;

switch flag
    case 'init'
        
    case 'iter'
        if state.Generation == 1
            colors = {'or','ok','og','oc','om','ok','xr','xb','xk','xc'};
            hold on;
            set(gca,'xlim',[0,options.Generations],'ylim',[0,1]);
            xlabel('Generation','interp','none');
            ylabel('Support','interp','none');
            for i=1:2
                plotsupport = plot(state.Generation,0,colors{i},'MarkerSize',1);
                set(plotsupport,'Tag',['plotsupport' num2str(i)]);
            end
            title('Support: ','interp','none')
        end
        Y(1) = S;
        Y(2) = ST;
        for i=1:2
            plotsupport = findobj(get(gca,'Children'),'Tag',['plotsupport' num2str(i)]);
            newX = [get(plotsupport,'Xdata') state.Generation];
            newY = [get(plotsupport,'Ydata') Y(i)];
            set(plotsupport,'Xdata',newX, 'Ydata',newY);
        end
                
    case 'done'
        hold off;
end


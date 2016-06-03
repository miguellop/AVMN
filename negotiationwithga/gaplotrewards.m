function state = gaplotrewards(options,state,flag)
%GAPLOTREWARDS Plots the agents' rewards.
%   STATE = GAPLOTREWARDS(OPTIONS,STATE,FLAG) plots the agents' rewards.
%
global agents;
global nag;

switch flag
    case 'init'
        
    case 'iter'
        if state.Generation == 1
            colors = {'or','ob','og','oc','om','ok','xr','xb','xk','xc'};
            hold on;
            grid on;
            set(gca,'xlim',[0,options.Generations]);
            xlabel('Generation','interp','none');
            ylabel('Rewards','interp','none');
            for i=1:nag
                plotrewards = plot(state.Generation,0,colors{i},'MarkerSize',2);
                set(plotrewards,'Tag',['plotrewards' num2str(i)]);
            end
            title('Rewards: ','interp','none')
        end
        [best,ind] = min(state.Score);
        Y = agents(state.Population(ind,:))';
        for i=1:nag
            plotrewards = findobj(get(gca,'Children'),'Tag',['plotrewards' num2str(i)]);
            newX = [get(plotrewards,'Xdata') state.Generation];
            newY = [get(plotrewards,'Ydata') Y(i)];
            set(plotrewards,'Xdata',newX, 'Ydata',newY);
        end
                
    case 'done'
        hold off;
end


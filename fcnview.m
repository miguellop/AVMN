classdef fcnview < handle
    properties
        graph
        Ag
        Nagents
    end
    methods
        function obj = fcnview(MA, Ag)
            obj.Ag = Ag;
            obj.Nagents = length(Ag);
            addlistener(MA, 'ContractsEvalReady', 'PostSet', @(src, evnt) obj.listenUpdateGraph(src, evnt));
        end
        function Reset(obj, MA)
            clf;
            colormap('Gray');
            subplot(2,2,1);
            axis([-1 1 -1 1]);
            title('Negotiation Space: (x1, x2)', 'FontSize', 11, 'FontWeight', 'bold')
            xlabel('x1')
            ylabel('x2')
            hold on;
%             for i=1:obj.Nagents
%                 ezcontour(@(x,y) obj.Ag{i}.UF([x y]), [-1 1 -1 1]);
%             end
            box; 
            hold on;
            
            subplot(2,2,2);
            axis([0 MA.MaxRounds 0 1.1]);
            hold on;
            title('Rewards', 'FontSize', 11, 'FontWeight', 'bold')
            xlabel('Round Number')
            ylabel('Utility')
            box; grid;
            
            subplot(2,2,3);
            axis([0 MA.MaxRounds 0 1]);
            hold on;
            title('Social Welfare', 'FontSize', 11, 'FontWeight', 'bold')
            xlabel('Number')
            ylabel('Group Preference')
            box; grid;
            
            subplot(2,2,4);
            axis([0 MA.MaxRounds 0 100]);
            hold on;
            title('Sigma-Deterministic', 'FontSize', 11, 'FontWeight', 'bold')
            xlabel('Number')
            ylabel('Sigma')
            box; grid;
        end
        function listenUpdateGraph(obj, src, evnt)
            nround = evnt.AffectedObject.Nround;
            mesh = [evnt.AffectedObject.Msh.currentpoint;evnt.AffectedObject.Msh.meshpoints];
            h = subplot(2,2,1);
%             cla(h);
%             scatter(mesh(:,1), mesh(:,2), evnt.AffectedObject.Msh.deltam*5+5);
            subplot(2,2,2);
            plot(nround, ...
                evnt.AffectedObject.PrivEval(evnt.AffectedObject.Winner,:), 'o', 'MarkerSize', 5);
            subplot(2,2,3);
            plot(nround, ...
                evnt.AffectedObject.D(:, nround), 'o', 'MarkerSize', 5); 
            subplot(2,2,4);
            plot(nround, ...
                evnt.AffectedObject.sigma(nround), 'o', 'MarkerSize', 5); 

            drawnow();
        end
    end
end
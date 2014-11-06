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
            
            subplot(3,1,1);
            axis([0 100 0 100]);
            title('Negotiation Space: (x1, x2)', 'FontSize', 11, 'FontWeight', 'bold')
            xlabel('x1')
            ylabel('x2')
            hold on;
            for i=1:obj.Nagents
                ezcontour(@(x,y) obj.Ag{i}.UF([x y], [0 0;100 100]), [0 100 0 100]);
            end
            box; 
            hold on;
            
            subplot(3,1,2);
            axis([0 MA.MaxRounds 0 1.1]);
            hold on;
            title('Current Utilities', 'FontSize', 11, 'FontWeight', 'bold')
            xlabel('Round Number')
            ylabel('Utility')
            box; grid;
            
            subplot(3,1,3);
            axis([0 MA.MaxRounds 0 1.5]);
            hold on;
            title('Group Preferences', 'FontSize', 11, 'FontWeight', 'bold')
            xlabel('Number')
            ylabel('Group Preference')
            box; grid;
        end
        function listenUpdateGraph(obj, src, evnt)
            mesh = [evnt.AffectedObject.Msh.currentpoint;evnt.AffectedObject.Msh.meshpoints];
            subplot(3,1,1);
            scatter(mesh(:,1), mesh(:,2), '*');
            subplot(3,1,2);
            plot(evnt.AffectedObject.Nround, ...
                evnt.AffectedObject.PrivEval(evnt.AffectedObject.Winner,:), '*', 'MarkerSize', 5);
            subplot(3,1,3);
            plot(evnt.AffectedObject.Nround, ...
                evnt.AffectedObject.D(:, evnt.AffectedObject.Nround), '*', 'MarkerSize', 5); 

            drawnow();
        end
    end
end
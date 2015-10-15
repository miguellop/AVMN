classdef medagent < handle
    properties
        MaxRounds = 500;
        Nagents = 0;
        PubEval
        PrivEval
        ReceptionFlags
        Nround
        DeltaTolerance = 1e-6;
        Msh
        Type
        Winner
     
        D
        sg
        sigma
    end
    
    properties (SetObservable = true)
        ContractsEvalReady
    end
    
    methods
        function output = Negotiate(MA, Msh)          
            MA.Msh = [];
            MA.Msh = Msh; MA.D = [];
            for i=1:MA.MaxRounds
                MA.Nround = i;     
                notify(MA, 'ProposeMesh', eventProposeMesh(Msh));
                MA.waitAgentsResponses();
                MA.computeGroupPreferences();    
                MA.selectionProcess();
                convergence = MA.AssessConvergence();
                MA.ContractsEvalReady = true; %Orden de pintado

                if convergence == true
                    break;
                end
            end

            output.agreement = MA.Msh.currentpoint;
            output.PubEval = MA.PubEval(1,:);
            output.PrivEval = MA.PrivEval(1,:);
            output.D = MA.D(1,MA.Nround);
            output.sw = sum(output.PrivEval);
        end
              
        function computeGroupPreferences(obj)
            %NSao
            if obj.Type == 1
                obj.D(:, obj.Nround) = sum(obj.PubEval,2)/obj.Nagents;
            %GPSao
            elseif obj.Type == 3 
                St = obj.devMax(obj.PubEval); %[0 0.3 1] Ag1-ego�sta Ag2-menos ego�sta Ag3-cooperativo
                Sagg = sum(St);
                if Sagg == 0 %Todos los agentes son ego�stas, los transformamos a cooperativos
                    St = ones(1,obj.Nagents);
                    Sagg = obj.Nagents;
                end
                wt = St/Sagg;
                obj.D(:, obj.Nround) = sum(repmat(wt, obj.Msh.npoints+1, 1).*obj.PubEval, 2);
            % Yager
            else 
                St = sum(obj.PubEval);
                Sagg = sum(St);
                if Sagg <= 0.001
                    St = ones(1,obj.Nagents);
                    Sagg = obj.Nagents;
                end
                wt = St/Sagg;
                obj.D(:, obj.Nround) = sum(repmat(wt, obj.Msh.npoints+1, 1).*obj.PubEval, 2);
            end
        end
        
        function selectionProcess(obj)
            cp = obj.Msh.currentpoint;
            mp = obj.Msh.meshpoints;
            ap = [cp;mp];
            % Puntos de la malla dentro del dominio
            %validPoints = not(sum(ap<0 | ap>1, 2));
            % �ndices de la malla dentro del dominio
            %validIndexes = find(validPoints);
            
            %Gd = obj.D(validIndexes,obj.Nround);
            %G = max(Gd);
            Gd = obj.D(:,obj.Nround);
            G = max(Gd);
            validIndexes = 1:size(Gd,1);
%             if obj.Nround<obj.sg(4)
                obj.sigma = obj.sg(1) + (obj.sg(2)-obj.sg(1))*(G)^...
                    (obj.sg(3)*(1-obj.Nround/obj.MaxRounds));
%             else
%                 obj.sigma = obj.sg(1) + (obj.sg(2)-obj.sg(1))*(G)^...
%                     (obj.sg(3)*(1-(obj.Nround-obj.sg(4))/(obj.MaxRounds-obj.sg(4))));
%             end
            P = cumsum(Gd.^obj.sigma/sum(Gd.^obj.sigma));
            winnercontract = validIndexes(find(not(rand()>=P),1));
            
            %Si el winner est� fuera del dominio, se selecciona otro punto
            
            if winnercontract == 1 %The maximum support is for the current contract
                obj.Msh.Contract();
            else
                obj.Msh.currentpoint = obj.Msh.meshpoints(winnercontract-1,:);
                obj.Msh.Expand();
            end
            obj.Winner = winnercontract;
        end
        
        function dm = devMax(obj, v)
            [maxv, indv] = max(v);
            for i=1:length(indv)
                if maxv(i) == 0
                    dm(i) = 0;
                else
                    vp = v(:,i);
                    vp(indv(i)) = [];
                    diff = maxv(i) - vp;
                
                    dm(i) = 1-sum(diff)/(obj.Msh.npoints*maxv(i));
                end
            end
        end
        
        function RegisterAgent(MA, A)
            MA.ReceptionFlags(A.AgentIndex) = 0;
            MA.Nagents = MA.Nagents+1;
        end
        
        function AddMeshEval(MA, AgentIndex, PubEval, PrivEval)
            MA.PubEval(:, AgentIndex) = PubEval;
            MA.PrivEval(:, AgentIndex) = PrivEval;
            MA.ReceptionFlags(AgentIndex) = 1;
        end
        
        function convergence = AssessConvergence(MA)
            if  MA.Msh.deltam <= MA.DeltaTolerance
                convergence = true;
            else
                convergence = false;
            end
            MA.Msh.deltam
        end
        
        function waitAgentsResponses(obj)
            while any(obj.ReceptionFlags == 0)              
            end
            obj.ReceptionFlags = zeros(1, obj.Nagents);
        end
    end
          
    events
        ProposeMesh
    end
end
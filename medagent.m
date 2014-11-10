classdef medagent < handle
    properties
        MaxRounds = 500;
        Nagents = 0;
        PubEval
        PrivEval
        ReceptionFlags
        Nround
        DeltaTolerance = 1e-3;
        Msh
        Type
        Winner
                 
        D
        sg
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
            if obj.Type == 2                    %Yager
                St = obj.devMax(obj.PubEval); %[0 0.3] Ag1-egoísta Ag2-menos egoísta
                Sagg = sum(St);
                if Sagg == 0 %Todos los agentes son egoístas, los pesos wt serán todos 0--> D=0, G=0, sigma=sigmamin
                    Sagg = 1;
                end
                wt = St/Sagg;
                obj.D(:, obj.Nround) = sum(repmat(wt, obj.Msh.npoints+1, 1).*obj.PubEval, 2);
                
            else                                %Sumas de preferencias de cada agente por cada meshpoint
                obj.D(:, obj.Nround) = sum(obj.PubEval,2)/obj.Nagents;
            end
        end
        
        function selectionProcess(obj)
            Gd = obj.D(:,obj.Nround);
            G = max(Gd)^2;
            if obj.Nround<obj.sg(4)
                sigma = obj.sg(1) + (obj.sg(2)-obj.sg(1))*G^...
                    (obj.sg(3)*(1-obj.Nround/obj.MaxRounds));
            else
                sigma = obj.sg(1) + (obj.sg(2)-obj.sg(1))*G^...
                    (obj.sg(3)*(1-(obj.Nround-obj.sg(4))/(obj.MaxRounds-obj.sg(4))));
            end
            P = cumsum(Gd.^sigma/sum(Gd.^sigma));
            winnercontract = find(not(rand()>=P),1);
            
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
                vp = v(:,i);
                vp(indv(i)) = [];
                diff = maxv(i) - vp;
                dm(i) = 1-sum(diff)/(4*maxv(i));
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
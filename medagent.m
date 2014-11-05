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
                 
        D
        sg
    end
    
    properties (SetObservable = true)
        ContractsEvalReady
    end
    
    methods
        function output = Negotiate(MA, Msh)          
            MA.Msh = [];
            MA.Msh = Msh; MA.Nround = 1; MA.D = [];
                        
            notify(MA, 'ProposeMesh', eventProposeMesh(Msh));
            MA.waitAgentsResponses();
            MA.computeGroupPreferences();
            
            for i=2:MA.MaxRounds
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
            output.PubEval = MA.PubEval;
            output.PrivEval = MA.PrivEval;
            output.mesh = MA.Msh;
            output.D = MA.D;
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
        
        function computeGroupPreferences(obj)
            if obj.Type == 1 || obj.Type == 2
                St = sum(obj.PubEval);        %Vector con sumas de evaluaciones de cada Agente St
                Sagg = sum(St);                     %Agregación de evaluaciones de todos los Agentes
                wt = St/Sagg;                       %Vector con pesos por cada Agente
                
                obj.D(:, obj.Nround) = sum(repmat(wt, obj.Msh.npoints+1, 1).*obj.PubEval, 2);
            else
                obj.D(:, obj.Nround) = sum(obj.PubEval./obj.Nagents,2);
            end
        end
        
        function selectionProcess(obj)
            if obj.Type == 2 || obj.Type == 4
                if obj.Nround<obj.sg(4)
                    sigma = obj.sg(1) + (obj.sg(2)-obj.sg(1))*max(obj.D(:, obj.Nround))^(obj.sg(3)*(1-obj.Nround/obj.MaxRounds))
                else
                    sigma = obj.sg(1) + (obj.sg(2)-obj.sg(1))*max(obj.D(:, obj.Nround))^(obj.sg(3)*(1-(obj.Nround-obj.sg(4))/(obj.MaxRounds-obj.sg(4))))
                end
                P = cumsum(obj.D(:, obj.Nround).^sigma/sum(obj.D(:, obj.Nround).^sigma));
                winnercontract = find(not(rand()>=P),1);
            else
                [contract, winnercontract] = max(obj.D(:, obj.Nround));
            end
            if winnercontract == 1 %The maximum support is for the current contract
                obj.Msh.Contract();
            else
                obj.Msh.currentpoint = obj.Msh.meshpoints(winnercontract-1,:);
                obj.Msh.Expand();
            end
        end
    end
          
    events
        ProposeMesh
    end
end
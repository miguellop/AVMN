classdef medagent < handle
    properties
        Nroundslimit = 500;
        Nagents = 0;
        ContractsEval
        ReceptionFlags
        Nround
        DeltaTolerance = 1e-3;
        Msh
        Type %0-Reference 1-DSNPc activado
                 
        GP
        QGA
        RPolicy
        wt
        sigmamin
        sigmamax
        p
        kr
    end
    
    properties (SetObservable = true)
        ContractsEvalReady
    end
    
    methods
        function output = Negotiate(MA, Msh)          
            MA.Msh = [];
            MA.Msh = Msh; MA.Nround = 1; MA.GP = [];
            MA.computeWeights();
            
            notify(MA, 'ProposeMesh', eventProposeMesh(Msh));
            MA.waitAgentsResponses();
            MA.computeGroupPreferences();
            
            for i=2:MA.Nroundslimit
                MA.Nround = i;     
                notify(MA, 'ProposeMesh', eventProposeMesh(Msh));
                MA.waitAgentsResponses();
                MA.computeGroupPreferences();    
                MA.searchProcess();
                convergence = MA.AssessConvergence();
                MA.ContractsEvalReady = true; %Orden de pintado
                
                if convergence == true
                    break;
                end
            end
            
            output.agreement = MA.Msh.currentpoint;
            output.contractsEval = MA.ContractsEval;
            output.mesh = MA.Msh;
            output.GP = MA.GP;
        end
        
        function RegisterAgent(MA, A)
            MA.ReceptionFlags(A.AgentIndex) = 0;
            MA.Nagents = MA.Nagents+1;
        end
        
        function AddMeshEval(MA, AgentIndex, ContractsEval)
            MA.ContractsEval(AgentIndex, :) = ContractsEval;
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
        
        function computeWeights(obj)
            clear wt;
            for t=1:obj.Nagents
                wt(t) = obj.QGA(t/obj.Nagents)-obj.QGA((t-1)/obj.Nagents);
            end
            obj.wt = wt';
        end
        
        function computeGroupPreferences(obj)
            if obj.Type
                obj.GP(:, obj.Nround) = sum(repmat(obj.wt, 1, obj.Msh.npoints+1).*sort(obj.ContractsEval, 'descend'))';
            else
                obj.GP(:, obj.Nround) = sum(obj.ContractsEval)';
%                obj.GP(:, obj.Nround) = prod(obj.ContractsEval)';
%                obj.GP(:, obj.Nround) = min(obj.ContractsEval)';
            end
        end
        
        function searchProcess(obj)
            if obj.Type
                if obj.Nround<obj.kr
                    sigma = obj.sigmamin + (obj.sigmamax-obj.sigmamin)*max(obj.GP(:, obj.Nround))^(obj.p*(1-obj.Nround/obj.Nroundslimit))
                else
                    sigma = obj.sigmamin + (obj.sigmamax-obj.sigmamin)*max(obj.GP(:, obj.Nround))^(obj.p*(1-(obj.Nround-obj.kr)/(obj.Nroundslimit-obj.kr)))
                end
                P = cumsum(obj.GP(:, obj.Nround).^sigma/sum(obj.GP(:, obj.Nround).^sigma));
                winnercontract = find(not(rand()>=P),1);
            else
                [contract winnercontract] = max(obj.GP(:, obj.Nround));
            end
            if winnercontract == 1 %The maximum support is for the current contract
                obj.Msh.Contract();
                %disp 'C'
            else
                obj.Msh.currentpoint = obj.Msh.meshpoints(winnercontract-1,:);
                obj.Msh.Expand();
                %disp 'E'
            end
        end
    end
          
    events
        ProposeMesh
    end
end
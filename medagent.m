classdef medagent < handle
    properties
        MaxRounds
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
        priorities
        collaboration
        winners
        sg
        sigma
    end
    
    properties (SetObservable = true)
        ContractsEvalReady
    end
    
    methods
        
        function MA = medagent(maxrounds, mediator, sg)
            MA.MaxRounds = maxrounds;
            MA.Type = mediator;
            MA.sg = sg;
        end
        
        function output = negotiate(MA, Msh)          
            MA.Msh = [];
            MA.Msh = Msh; MA.D = [];
            
            MA.priorities = ones(1, MA.Nagents)./MA.Nagents;
            MA.collaboration = ones(1, MA.Nagents);
        
            MA.sigma = MA.sg(2)+(MA.sg(1)-MA.sg(2))...
                *(1-exp(MA.sg(3)*(1-((1:MA.MaxRounds)-1)./(MA.MaxRounds-1))))./(1-exp(MA.sg(3)));
            
            for i=1:MA.MaxRounds
                MA.Nround = i;     
                notify(MA, 'ProposeMesh', eventProposeMesh(Msh));
                MA.waitagents();
                MA.computepreferences();    
                MA.selectwinner();
                convergence = MA.assessconvergence();
                MA.ContractsEvalReady = true; %Orden de pintado

                if convergence == true
                    break;
                end
            end
  
            output = MA.PrivEval(1,:);
        end
              
        function computepreferences(obj)
            %NSao
            if obj.Type == 1
                obj.D(:, obj.Nround) = sum(obj.PubEval,2)/obj.Nagents;
            %OWA Colaborativo
            elseif obj.Type == 2
                obj.D(:, obj.Nround) = obj.owa();
            %OWA No-colaborativo
            elseif obj.Type == 3
                obj.D(:, obj.Nround) = obj.owa();
            %DSao    
            else
                St = obj.devMax(obj.PubEval); % [0 0.3 1] Ag1-egoísta Ag2-menos egoísta Ag3-cooperativo
                Sagg = sum(St);
                if Sagg == 0            %Todos los agentes son egoístas, los transformamos a cooperativos
                    St = ones(1,obj.Nagents);
                    Sagg = obj.Nagents;
                end
                wt = St/Sagg;
                
                obj.D(:, obj.Nround) = sum(repmat(wt, obj.Msh.npoints+1, 1).*obj.PubEval, 2);
            end
        end
        
        function selectwinner(obj)
            % Puntos de la malla dentro del dominio
            feasiblepoints = obj.Msh.getFeasiblePoints();
               
            Gd = obj.D(feasiblepoints, obj.Nround);
            sigm = obj.sigma(obj.Nround);
            P = cumsum(Gd.^sigm/sum(Gd.^sigm));
            winnercontract = feasiblepoints(find(not(rand() >= P), 1));

            if winnercontract == 1 %The maximum support is for the current contract
                obj.Msh.Contract();
            else
                obj.Msh.currentpoint = obj.Msh.meshpoints(winnercontract-1,:);
                obj.Msh.Expand();
            end
            
            obj.Winner = winnercontract;
            obj.winners(obj.Nround, :) = obj.PubEval(winnercontract, :); 
            obj.setcollaboration();
            obj.setpriorities();
        end
        
        function w = getowaweights(obj, ind)
            Q = @(x) x.^2;
            [nrows, ncols] = size(ind);
            r = [];
            for i=1:nrows
                r(i,:) = obj.priorities(ind(i,:));
            end
            r = cumsum(r, 2);
            w(:,1) = Q(r(:,1));
            for i=2:ncols
                w(:,i) = Q(r(:,i))-Q(r(:,i-1));
            end
        end
                
        function d = owa(obj)
            [eval, ind] = sort(obj.PubEval, 2, 'descend');
            w = obj.getowaweights(ind);
            d = sum(eval.*w, 2);      
        end
        
        function setcollaboration(obj)
            if obj.Nround >= 10
                obj.collaboration = sum(obj.winners(obj.Nround-9:obj.Nround, :));
            end
        end
        
        function setpriorities(obj)
            col = obj.collaboration./sum(obj.collaboration);
            if obj.Type == 2 % premia al colaborativo
                obj.priorities = col;
            elseif obj.Type == 3 % premia al no-colaborativo
%                 obj.priorities = (1-col)./sum(1-col);
                obj.priorities = 1./col;
                obj.priorities = obj.priorities./sum(obj.priorities);
            end
            disp(obj.priorities);
        end
        
        function y = satisfiesmediationrule(obj)
            y = obj.D(obj.Winner, obj.Nround);
        end
        
        function dm = devMax(obj, v)
            [maxv, indv] = max(v);
            % recorrido de agentes
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
        
        function registeragent(MA, A)
            MA.ReceptionFlags(A.AgentIndex) = 0;
            MA.Nagents = MA.Nagents+1;
        end
        
        function addmesheval(MA, AgentIndex, PubEval, PrivEval)
            MA.PubEval(:, AgentIndex) = PubEval;
            MA.PrivEval(:, AgentIndex) = PrivEval;
            MA.ReceptionFlags(AgentIndex) = 1;
        end
        
        function convergence = assessconvergence(MA)
            if  MA.Msh.deltam <= MA.DeltaTolerance
                convergence = true;
            else
                convergence = false;
            end
            MA.Msh.deltam;
        end
        
        function waitagents(obj)
            while any(obj.ReceptionFlags == 0)              
            end
            obj.ReceptionFlags = zeros(1, obj.Nagents);
        end
    end
          
    events
        ProposeMesh
    end
end
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
        lfilter = 20
        priorities
        collaboration
        expectedsw
        expectedswprev
        expectedswflag
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
            
            MA.priorities = ones(1, MA.Nagents);
            MA.priorities = MA.priorities/sum(MA.priorities);
            MA.collaboration = ones(1, MA.Nagents);
            MA.expectedsw = 0;
            MA.expectedswprev = 0;
            MA.expectedswflag = false;
        
            MA.sigma = MA.sg(2)+(MA.sg(1)-MA.sg(2))...
                *(1-exp(MA.sg(3)*(1-((1:MA.MaxRounds)-1)./(MA.MaxRounds-1))))./(1-exp(MA.sg(3)));
            
            for i=1:MA.MaxRounds
                MA.Nround = i;     
                notify(MA, 'ProposeMesh', eventProposeMesh(Msh));
                MA.waitagents();
                MA.computepreferences();    
                MA.selectwinner();
                MA.updateexpectedsw();
                MA.updatecollaboration();
                MA.updatepriorities();
                convergence = MA.assessconvergence();
                MA.ContractsEvalReady = true; % Orden de pintado

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
                obj.D(:, obj.Nround) = obj.owa();
%                 St = obj.devMax(obj.PubEval); % [0 0.3 1] Ag1-egoísta Ag2-menos egoísta Ag3-cooperativo
%                 Sagg = sum(St);
%                 if Sagg == 0            %Todos los agentes son egoístas, los transformamos a cooperativos
%                     St = ones(1,obj.Nagents);
%                     Sagg = obj.Nagents;
%                 end
%                 wt = St/Sagg;
%                 
%                 obj.D(:, obj.Nround) = sum(repmat(wt, obj.Msh.npoints+1, 1).*obj.PubEval, 2);
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
        end
        
        function d = owa(obj)
            [eval, ind] = sort(obj.PubEval, 2, 'descend');
            w = obj.getowaweights(ind);
            d = sum(eval.*w, 2);      
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
        
        function updateexpectedsw(obj)
            if obj.Nround >= obj.lfilter
                obj.expectedsw = sum(sum(obj.winners(obj.Nround-obj.lfilter+1:obj.Nround, :)));
                if obj.expectedsw > obj.expectedswprev
                    obj.expectedswflag = false;
                else
                    obj.expectedswflag = true;
                end
                obj.expectedswprev = obj.expectedsw;
            end
        end
              
        function updatecollaboration(obj)
            if obj.Nround >= obj.lfilter
                obj.collaboration = sum(obj.winners(obj.Nround-obj.lfilter+1:obj.Nround, :));
            end
        end
        
        function updatepriorities(obj)
            if mod(obj.Nround,1)
                return
            end
            if obj.Nround < obj.lfilter
                return
            end
            if obj.Type == 2 % castiga a los perdedores
                obj.priorities = ones(1, obj.Nagents);
                [colab, indcolab] = sort(obj.collaboration, 'ascend');
                obj.priorities(indcolab(1:obj.Nagents-3)) = 0;
            elseif obj.Type == 3 % premia a los perdedores
                obj.priorities = zeros(1, obj.Nagents);
                [colab, indcolab] = sort(obj.collaboration, 'ascend');
                obj.priorities(indcolab(1:2)) = 1;   
            elseif obj.Type == 4 % rotar prioridad de agentes
                if obj.expectedswflag == true
                    obj.priorities = randperm(obj.Nagents)>0.5*obj.Nagents;
                    %obj.priorities = circshift(obj.priorities',1)';
                end
            end
            obj.priorities = obj.priorities./sum(obj.priorities);
            %disp(obj.priorities);
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
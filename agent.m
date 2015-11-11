classdef agent < handle
    properties
        AgentIndex %cada agente debe tener asignado un número único entero y secuencial
        UF %Utility function
        Type 
        quotas
    end
    methods
        function A = agent(AgentIndex, UF, MA, Typeneg, Quotas)
            A.AgentIndex = AgentIndex;
            A.UF = UF;
            A.Type = Typeneg;
            qo = Quotas(1,1);
            qf = Quotas(1,2);
            beta = Quotas(:,3);
            mr = MA.MaxRounds;
            A.quotas(1,:) = round(qf+(qo-qf)*(1-exp(beta(1)*(1-((1:mr)-1)./(mr-1))))./(1-exp(beta(1))));
            A.quotas(2,:) = round(qf+(qo-qf)*(1-exp(beta(2)*(1-((1:mr)-1)./(mr-1))))./(1-exp(beta(2))));
            A.quotas(3,:) = round(qf+(qo-qf)*(1-exp(beta(3)*(1-((1:mr)-1)./(mr-1))))./(1-exp(beta(3))));
            MA.registeragent(A);
            addlistener(MA, 'ProposeMesh', @(src, evnt) A.responsestrategy(src, evnt));
        end
        %% RESPONSE STRATEGY
        function responsestrategy(A, src, evnt)
            priveval = A.UF([evnt.mesh.currentpoint; evnt.mesh.meshpoints]);
            [maxpriveval, indmaxpriveval] = max(priveval);
            [ordpriveval, indpriveval] = sort(priveval,'descend');
            %CAg
            if A.Type == 1      
                pubeval = priveval/maxpriveval;
            elseif A.Type == 2
                nc = 1;
                pubeval = zeros(evnt.mesh.npoints+1, 1);
                pubeval(indpriveval(1:nc)) = 1;
            else
                if A.Type == 31
                    quota = A.quotas(1, src.Nround);
                elseif A.Type == 32
                    quota = A.quotas(2, src.Nround);
                else
                    quota = A.quotas(3, src.Nround);
                end
                
                pubeval = zeros(evnt.mesh.npoints+1, 1);
                pubeval(indpriveval(1:quota)) = 1; 
            end
            src.addmesheval(A.AgentIndex, pubeval, priveval);
        end
    end
end
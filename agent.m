classdef agent < handle
    properties
        AgentIndex %cada agente debe tener asignado un número único entero y secuencial
        UF %Utility function
        Type 
    end
    methods
        function A = agent(AgentIndex, UF, MA, type)
            A.AgentIndex = AgentIndex;
            A.UF = UF;
            A.Type = type;
            MA.RegisterAgent(A);
            addlistener(MA, 'ProposeMesh', @(src, evnt) A.ResponseStrategy(src, evnt));
        end
        %% RESPONSE STRATEGY
        function ResponseStrategy(A, src, evnt)
            priveval = A.UF([evnt.mesh.currentpoint; evnt.mesh.meshpoints], evnt.mesh.domain);
            sumpriveval = sum(priveval);
            [maxpriveval, indmaxpriveval] = max(priveval);
            if A.Type == 1
                pubeval = zeros(evnt.mesh.npoints+1, 1);
                pubeval(indmaxpriveval) = 1;
            else
                if max(priveval) == 0
                    priveval = ones(evnt.mesh.npoints+1,1);
                end
                priveval = priveval/sum(priveval);
                pubeval = priveval;
            end
            src.AddMeshEval(A.AgentIndex, pubeval, priveval);
        end
    end
end
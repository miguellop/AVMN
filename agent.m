classdef agent < handle
    properties
        AgentIndex %cada agente debe tener asignado un número único entero y secuencial
        UF %Utility function
    end
    methods
        function A = agent(AgentIndex, UF, MA)
            A.AgentIndex = AgentIndex;
            A.UF = UF;
            MA.RegisterAgent(A);
            addlistener(MA, 'ProposeMesh', @(src, evnt) A.ResponseStrategy(src, evnt));
        end
        %% RESPONSE STRATEGY
        function ResponseStrategy(A, src, evnt)
            eval = A.UF([evnt.mesh.currentpoint; evnt.mesh.meshpoints], evnt.mesh.domain)';
            src.AddMeshEval(A.AgentIndex, eval);
        end
    end
end
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
            priveval = A.UF([evnt.mesh.currentpoint(1); evnt.mesh.meshpoints(:,1)],...
                [evnt.mesh.currentpoint(2); evnt.mesh.meshpoints(:,2)]);
            [maxpriveval, indmaxpriveval] = max(priveval);
            %CAg
             if A.Type == 1      
%                 if maxpriveval == 0
%                     %pubeval = 0.01*ones(evnt.mesh.npoints+1,1);
%                     pubeval = rand(evnt.mesh.npoints+1,1)/10;
%                 else
                    pubeval = priveval;
%                end
            %SAg
            elseif A.Type == 2  
%                 if maxpriveval == 0
%                     %pubeval = 0.01*ones(evnt.mesh.npoints+1,1);
%                     pubeval = rand(evnt.mesh.npoints+1,1)/10;
%                     pubeval = [0.1 0.1 0.1 0 0];
%                 else
                    pubeval = zeros(evnt.mesh.npoints+1, 1);
                    pubeval(indmaxpriveval) = maxpriveval;
%                 end
            %eCAg
            elseif A.Type ==3
%                 if maxpriveval == 0
%                     pubeval = rand(evnt.mesh.npoints+1,1)/10;
%                 else
                    pubeval = priveval/maxpriveval;
%                 end
            %eSAg
            else
%                 if maxpriveval == 0
%                     pubeval = rand(evnt.mesh.npoints+1,1)/4;
%                 else
                    pubeval = zeros(evnt.mesh.npoints+1, 1);
                    pubeval(indmaxpriveval) = 1;
%                 end
            end
            
            src.AddMeshEval(A.AgentIndex, pubeval, priveval);
        end
    end
end
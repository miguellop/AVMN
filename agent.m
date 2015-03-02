classdef agent < handle
    properties
        AgentIndex %cada agente debe tener asignado un n�mero �nico entero y secuencial
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
            priveval = A.UF([evnt.mesh.currentpoint; evnt.mesh.meshpoints]);
            [maxpriveval, indmaxpriveval] = max(priveval);
            [ordpriveval, indpriveval] = sort(priveval,'descend');
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
            elseif A.Type == 3
%                 if maxpriveval == 0
%                     pubeval = rand(evnt.mesh.npoints+1,1)/10;
%                 else
                    pubeval = priveval/maxpriveval;
%                 end
            %eSAg
            elseif A.Type == 4
%                 if maxpriveval == 0
%                     pubeval = rand(evnt.mesh.npoints+1,1)/4;
%                 else
                    pubeval = zeros(evnt.mesh.npoints+1, 1);
                    pubeval(indmaxpriveval) = 1;
%                 end
            %Lang-Fink: Se divide la negociaci�n en etapas. La primera
            %etapa obliga a votar con 1 por ncontracts - 1, la segunda por
            %ncontracts -2 y la �ltima por 1 contrato s�lo
            elseif A.Type == 5 
                pubeval = zeros(evnt.mesh.npoints+1, 1);
                if src.Nround <20
                    pubeval(indpriveval(1:3)) = 1; 
                elseif src.Nround < 35
                    pubeval(indpriveval(1:2)) = 1;
                else
                    pubeval(indpriveval(1)) = 1; 
                end
            else 
                pubeval = zeros(evnt.mesh.npoints+1, 1);
                if src.Msh.deltam > 15
                    pubeval(indpriveval(1:3)) = 1; 
                elseif src.Msh.deltam > 5
                    pubeval(indpriveval(1:2)) = 1;
                else
                    pubeval(indpriveval(1)) = 1; 
                end
            end
            
            src.AddMeshEval(A.AgentIndex, pubeval, priveval);
        end
    end
end
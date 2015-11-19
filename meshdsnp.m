classdef meshdsnp < handle
    properties
        ndim = 2;
        currentpoint
        domain
        type = 'GPS2N';
        genvect;        
        meshpoints;            
        deltam = 0.1;
        expfactor = 2;
        confactor = 0.5;
        npoints
    end
    
    methods
        %CONSTRUCTOR
        function Msh = meshdsnp(ndim, currentpoint, domain, deltam, expfactor, confactor, type)
            if nargin == 7
                Msh.ndim = ndim;
                Msh.currentpoint = currentpoint;
                Msh.domain = domain;
                Msh.deltam = deltam;
                Msh.expfactor = expfactor;
                Msh.confactor = confactor;
                Msh.type = type;
            else
                Msh.currentpoint = rand(1,Msh.ndim);
            end
            if strcmp(Msh.type, 'GPS2N')
                Msh.genvect = [eye(Msh.ndim, Msh.ndim); eye(Msh.ndim, Msh.ndim)*-1];
                Msh.meshpoints = repmat(Msh.currentpoint, Msh.ndim*2, 1)+Msh.genvect*Msh.deltam;
                Msh.npoints = 2*Msh.ndim;
            elseif strcmp(Msh.type, 'GPSN1')
                Msh.genvect = [eye(Msh.ndim, Msh.ndim); ones(1, Msh.ndim)*-1];    
                Msh.meshpoints = repmat(Msh.currentpoint, Msh.ndim+1, 1)+Msh.genvect*Msh.deltam;
                Msh.npoints = Msh.ndim+1;
            end
        end
        %EXPANSION
        function Expand(Msh)
%             if strcmp(Msh.type, 'GPS2N')
                % Genero una mesh candidata con el delta actual
                Msh.meshpoints = repmat(Msh.currentpoint, Msh.ndim*2, 1)+Msh.genvect*Msh.deltam;
                if Msh.isMeshInDomain() % Test de puntos dentro del dominio
                    % Expando la malla
                    Msh.deltam = Msh.deltam*Msh.expfactor;
                else
                    Msh.deltam = Msh.deltam;
                end
                Msh.meshpoints = repmat(Msh.currentpoint, Msh.ndim*2, 1)+Msh.genvect*Msh.deltam;
%             elseif strcmp(Msh.type, 'GPSN1')
%                 Msh.meshpoints = repmat(Msh.currentpoint, Msh.ndim+1, 1)+Msh.genvect*Msh.deltam;
%             end
        end
        %CONTRACTION
        function Contract(Msh)
            Msh.deltam = Msh.deltam*Msh.confactor;
%             if strcmp(Msh.type, 'GPS2N')
                Msh.meshpoints = repmat(Msh.currentpoint, Msh.ndim*2, 1)+Msh.genvect*Msh.deltam;
%             elseif strcmp(Msh.type, 'GPSN1')
%                 Msh.meshpoints = repmat(Msh.currentpoint, Msh.ndim+1, 1)+Msh.genvect*Msh.deltam;
%             end
        end
        %MESH DOMAIN FUNCTIONS
        % Prueba si la malla tiene todos los puntos externos dentro del dominio
        function t = isMeshInDomain(Msh)
            Tolerance = 1e-3;
            T = Msh.meshpoints >= (Msh.domain(1,1)-Tolerance)...
                & (Msh.meshpoints <= Msh.domain(2,1)+Tolerance);
            t = all(T(:));
        end
        % Devuelve los �ndices de los puntos que est�n dentro del dominio
        function ind = getFeasiblePoints(Msh)
            ap = [Msh.currentpoint; Msh.meshpoints];
            ind = find(all(ap >= Msh.domain(1,1) & ap <= Msh.domain(2,1), 2));    
        end
    end
end
            
                
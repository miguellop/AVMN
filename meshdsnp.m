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
            Msh.deltam = Msh.deltam*Msh.expfactor;
            if strcmp(Msh.type, 'GPS2N')
                Msh.genvect = [eye(Msh.ndim, Msh.ndim); eye(Msh.ndim, Msh.ndim)*-1];
                Msh.meshpoints = repmat(Msh.currentpoint, Msh.ndim*2, 1)+Msh.genvect*Msh.deltam;
                % Se comprueba que las variables no excedan el dominio
                % correspondiente.
%                 v1 = Msh.meshpoints > 1;
%                 v0 = Msh.meshpoints < 0;
%                 Msh.meshpoints(v1) = 1;
%                 Msh.meshpoints(v0) = 0;
                
            elseif strcmp(Msh.type, 'GPSN1')
                Msh.genvect = [eye(Msh.ndim, Msh.ndim); ones(1, Msh.ndim)*-1];    
                Msh.meshpoints = repmat(Msh.currentpoint, Msh.ndim+1, 1)+Msh.genvect*Msh.deltam;
            end
        end
        %CONTRACTION
        function Contract(Msh)
            Msh.deltam = Msh.deltam*Msh.confactor;
            if strcmp(Msh.type, 'GPS2N')
                Msh.genvect = [eye(Msh.ndim, Msh.ndim); eye(Msh.ndim, Msh.ndim)*-1];
                Msh.meshpoints = repmat(Msh.currentpoint, Msh.ndim*2, 1)+Msh.genvect*Msh.deltam;
            elseif strcmp(Msh.type, 'GPSN1')
                Msh.genvect = [eye(Msh.ndim, Msh.ndim); ones(1, Msh.ndim)*-1];    
                Msh.meshpoints = repmat(Msh.currentpoint, Msh.ndim+1, 1)+Msh.genvect*Msh.deltam;
            end
        end
    end
end
            
                
classdef eventProposeMesh < event.EventData
    properties
        mesh;
    end
    methods
        function eventData = eventProposeMesh(mesh)
            eventData.mesh = mesh;
        end
    end
end
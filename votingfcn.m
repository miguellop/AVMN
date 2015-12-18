function [scores] = votingfcn(thisPopulation,quota,CurrentAgents,options)
    
    switch options.AgentType

        case {'quotas'}
            
            [scores, ind] = sort(CurrentAgents(thisPopulation), 'descend');
            scores = scores*0;

            for i=1:size(scores,2)
                scores(ind(1:round(quota),i),i) = 1;
            end
            
    end
end

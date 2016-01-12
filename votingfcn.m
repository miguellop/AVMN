function [scores] = votingfcn(y,quota,AgentType)
    
    switch AgentType

        case {'quotas'}
            
            [scores, ind] = sort(y, 'descend');
            scores = scores*0;

            for i=1:size(scores,2)
                scores(ind(1:round(quota),i),i) = 1;
            end
            
    end
end

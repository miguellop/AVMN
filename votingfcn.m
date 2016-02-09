function [scores] = votingfcn(y,quota,AgentType)
    
    switch AgentType

        case {'quotas'}
            
            [scores, ind] = sort(y, 'descend');
            scores = scores*0;

            for i=1:size(scores,2)
                scores(ind(1:quota,i),i) = 1;
            end
        case {'rank'}
            [scores, ind] = sort(y, 'descend');
            scores = scores*0;

            for i=1:size(scores,2)
                scores(ind(1:quota+1,i),i) = linspace(1,0,quota+1);
            end
        case {'truevoting'}
            [scores, ind] = sort(y, 'descend');
            scores = scores*0;
            [nr,nc] = size(scores);
            for i=1:nc
                scores(ind(1:quota,i),i) = y(ind(1:quota,i),i);
            end
            
            scores = scores./repmat(max(scores),nr,1); %se normalizan las votaciones            
    end
end

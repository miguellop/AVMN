function [scores] = votingfcn(y,Type)
    global quota;
    Type = Type(1);
    
    switch Type

        case {'q'}
            
            [scores, ind] = sort(y, 'descend');
            scores = scores*0;

            for i=1:size(scores,2)
                scores(ind(1:quota,i),i) = 1;
            end
        case {'r'}
            [scores, ind] = sort(y, 'descend');
            scores = scores*0;

            for i=1:size(scores,2)
                scores(ind(1:quota+1,i),i) = linspace(1,0,quota+1);
            end
        case {'t'}
            [scores, ind] = sort(y, 'descend');
            scores = scores*0;
            [nr,nc] = size(scores);
            for i=1:nc
                scores(ind(1:quota,i),i) = y(ind(1:quota,i),i);
            end
            
            scores = scores./repmat(max(scores),nr,1); %se normalizan las votaciones   
    end
end

function expectation = aggregationfcn(score,AgentPriorities,options)
% AGGREGATION Aggregates Agents' preferences
    switch options.MediationType
        case {'additive'}
            expectation = sum(score, 2)/options.Nag;
        case {'dgm1','dgm2','dgm3'}
            expectation = owa(score,AgentPriorities);
    end
end

function expectation = owa(score,AgentPriorities)
    Q = @(x) x.^2;
    
    [expectation, ind] = sort(score, 2, 'descend');
    [nrows, ncols] = size(ind);
    r = [];
    for i=1:nrows
        r(i,:) = AgentPriorities(ind(i,:));
    end
    r = cumsum(r, 2);
    w(:,1) = Q(r(:,1));
    for i=2:ncols
        w(:,i) = Q(r(:,i))-Q(r(:,i-1));
    end
    expectation = sum(expectation.*w, 2);      
end
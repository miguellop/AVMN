function expectation = aggregationfcn(score,w)
% AGGREGATION Aggregates Agents' preferences
    nr = size(score,1);
    expectation = sort(score, 2, 'descend');
    expectation = sum(expectation.*repmat(w,nr,1), 2);
end



%%%OWA with priorities
% function expectation = owap(score,AgentPriorities)
%     Q = @(x) x;
%     
%     [expectation, ind] = sort(score, 2, 'descend');
%     [nrows, ncols] = size(ind);
%     r = [];
%     for i=1:nrows
%         r(i,:) = AgentPriorities(ind(i,:));
%     end
%     r = cumsum(r, 2);
%     w(:,1) = Q(r(:,1));
%     for i=2:ncols
%         w(:,i) = Q(r(:,i))-Q(r(:,i-1));
%     end
%     expectation = sum(expectation.*w, 2);      
% end
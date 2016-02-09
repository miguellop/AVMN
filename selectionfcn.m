function selection = selectionfcn(expectation,k)
% Selección probabilística
% so = 10;
% sf = 10;
% sigma = so+(sf-so)*(k-1)/(generations-1);
% 
% selection = find(not(rand()>=cumsum(expectation.^sigma/sum(expectation.^sigma))),1);

ind = find(expectation == max(expectation));
selection = ind(randi(length(ind)));

end

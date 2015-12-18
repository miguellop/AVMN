function mutationChildren = mutationfcn(sel,popsize)
    ni = length(sel);
    mutationChildren(1,:) = sel;
    for i=2:popsize
        mutationPoint = randi(ni);
        child = sel;
        child(mutationPoint) = ~child(mutationPoint);
        mutationChildren(i,:) = child;
    end
end
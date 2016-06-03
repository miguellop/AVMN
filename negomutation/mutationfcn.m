function mutationChildren = mutationfcn(sel,popsize,type,dominterval)
    ni = length(sel);
    mutationChildren(1,:) = sel;
    if strcmp(type,'A') %mutación en dominio contínuo
        for i=2:popsize
            mutationPoint = randi(ni);
            child = sel;
            child(mutationPoint) = (dominterval(2)-dominterval(1))*rand()+dominterval(1);
            mutationChildren(i,:) = child;
        end
    else
        for i=2:popsize
            mutationPoint = randi(ni);
            child = sel;
            child(mutationPoint) = ~child(mutationPoint);
            mutationChildren(i,:) = child;
        end
    end
end
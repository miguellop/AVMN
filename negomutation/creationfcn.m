function thisPopulation = creationfcn(popsize,ni,type,interval)
    if strcmp(type,'discrete')
        thisPopulation = randi(interval,popsize,ni);
    else
        thisPopulation = (interval(2)-interval(1))*rand(popsize,ni)+interval(1);
    end
end
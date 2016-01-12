function state = updatepopulationsizefcn(state,k)
    if state.Expectation(k) >= 0.9999999 
        state.PopulationSize = 1.1*state.PopulationSize;
    else
        state.PopulationSize = max(1,state.PopulationSize*0.9);
    end
end
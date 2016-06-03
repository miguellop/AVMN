function state = updatepopulationsizefcn(threshold,state,k)
    if state.Expectation(k) >= threshold 
        state.PopulationSize = min(200,1.1*state.PopulationSize);
    else
        state.PopulationSize = max(5,state.PopulationSize*0.9);
        if fix(state.PopulationSize) <= state.Quota
            state.PopulationSize = state.Quota+2;
        end
    end
end
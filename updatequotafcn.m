function state = updatequotafcn(threshold,state,k)
    if state.Expectation(k) >= threshold 
        state.Quota = max(2,state.Quota*0.9);
    else
        state.Quota = min(state.PopulationSize-2,state.Quota*1.1);
    end
end
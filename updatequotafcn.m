function state = updatequotafcn(state,k)
    if state.Expectation(k) >= 0.9999999 
        state.Quota = max(1,state.Quota*0.9);
    else
        state.Quota = min(state.PopulationSize,state.Quota*1.1);
    end
end
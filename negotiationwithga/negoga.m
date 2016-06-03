function state = negoga(options,optionsga)
    
    global quota;
    global alfa;
    global agents;
    global nag;
       
    state.Results.x = [];
    state.Results.y = [];  
    options = dgmset(options, 'Quotas', ...
        floor(options.InitialQuota*(1/options.InitialQuota).^((0:options.Generations-1)/(options.Generations-1))));
    pd = []; sw = []; nash = []; kalai = [];
    
    %%SETS
    for i=1:options.Nsets
        agents = getAgents(i,nag,options.Agents);
        f = @(x) -1*owafcn(votingfcn(agents(x),options.MediationType));  
        
        %%NEGOCIACIONES POR SET
        for j=1:options.Nexp
            fprintf(' %i - ', j);
            %%%%
            xj = ga(f,100,[],[],[],[],[],[],[],[],optionsga);
            %%%%
            x(j,:) = xj;
            y(j,:) = agents(xj);
        end
        
        state.Results.x = [state.Results.x;x];
        state.Results.y = [state.Results.y;y];
        sw = [sw; y./repmat(options.Swnk{i,nag}.sw, options.Nexp, 1)];
        nash = [nash; repmat(options.Swnk{i,nag}.nash, options.Nexp, 1) - y];
        kalai = [kalai; repmat(options.Swnk{i,nag}.kalai, options.Nexp, 1) - y];
        if nag <= 3
            pd = [pd; getparetoeval(y, options.Swnk{i,nag}.fval) - y];
        end
    end
    
    state.Results.nash = sqrt(sum(nash.^2, 2))*100;
    state.Results.kalai = sqrt(sum(kalai.^2, 2))*100;
    state.Results.sw = sum(sw,2)/nag;
    
    if nag <= 3
        state.Results.pd = sqrt(sum(pd.^2, 2))*100;
        state.Results.stats = mean([state.Results.pd, ...
                          state.Results.nash, ...
                          state.Results.kalai, ...
                          state.Results.sw]); 
    else
        state.Results.stats = mean([state.Results.nash, ...
                      state.Results.kalai, ...
                      state.Results.sw]); 
    end
end

function pd = getparetoeval(eval, fval)
    [nre, nce] = size(eval);
    [nrf, ncf] = size(fval);
    pd = [];
    for i=1:nre
        [x, ind] = min( sum((fval-repmat(eval(i,:),nrf,1)).^2, 2));
        pd = [pd; fval(ind, :)];
    end
end



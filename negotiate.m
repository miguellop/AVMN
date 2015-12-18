function state = negotiate()
   
    load ('UF100i');
    qo = 50; qf = 50;
   
    options = dgmset('Swnk', swnk, ...
                    'Agents', uf , ...
                    'AgentType', 'quotas', ...
                    'MediationType', 'dgm1', ...
                    'Nag', 3, ...
                    'Ni', 100, ...
                    'Nsets', 1, ...
                    'Nexp', 1, ...
                    'SelectionThreshold', 1,...
                    'Generations', 100, ...
                    'PopulationSize', 100, ...
                    'Plot', 'on', ...
                    'PlotFcn', {@plotrewardsfcn,@plotwinnercounterfcn});
                
    options = dgmset(options, 'Quotas', ...
        round(qf+(qo-qf)*(1-exp(2*(1-((1:options.Generations+1)-1)./(options.Generations))))./(1-exp(2))));          
    
    state.AgentPriorities = ones(1,options.Nag)/options.Nag;
    state.Score = [];               %Votos emitidos sobre el hijo ganador
    state.Expectation = [];         %Agregación de votos del hijo ganador
    state.Results.x = [];
    state.Results.y = [];  
    
    pd = []; sw = []; nash = []; kalai = [];
    
    %%Bucle de Sets
    for i=1:options.Nsets
        CurrentAgents = '@(x) [';
        for k=1:options.Nag-1
            CurrentAgents = [CurrentAgents, ...
                'options.Agents{' num2str(i) ',' num2str(k) '}(x),'];
        end
        CurrentAgents = [CurrentAgents, ...
            'options.Agents{' num2str(i) ',' num2str(k+1) '}(x)]'];
        fprintf('\n\n%s\n', CurrentAgents);
        CurrentAgents = eval(CurrentAgents);
        
        %%Bucle de Experimentos por Set       
        for j=1:options.Nexp
            fprintf(' %i - ', j);
            %Bucle de Generaciones
            thisPopulation = creationfcn(options.PopulationSize,options.Ni);
            for k=1:options.Generations
                quota = options.Quotas(k);
                
                score = votingfcn(thisPopulation,quota,CurrentAgents,options);
                expectation = aggregationfcn(score,state.AgentPriorities,options);
                selection = selectionfcn(expectation,options.SelectionThreshold);
                thisPopulation = mutationfcn(thisPopulation(selection,:),options.PopulationSize);
                
                state.Score(k,:) = score(selection,:);
                state.Expectation(k) = expectation(selection,:);
                
                plotrewardsfcn(options,CurrentAgents,k,thisPopulation(1,:));
            end
            
            x(j,:) = thisPopulation(1,:);
            y(j,:) = CurrentAgents(x(j,:));
        end
        
        state.Results.x = [state.Results.x;x];
        state.Results.y = [state.Results.y;y];
        pd = [pd; getparetoeval(y, options.Swnk{i,options.Nag}.fval) - y];
        sw = [sw; repmat(options.Swnk{i,options.Nag}.sw, options.Nexp, 1) - y];
        nash = [nash; repmat(options.Swnk{i,options.Nag}.nash, options.Nexp, 1) - y];
        kalai = [kalai; repmat(options.Swnk{i,options.Nag}.kalai, options.Nexp, 1) - y];
    end
    
    state.Results.pd = sqrt(sum(pd.^2, 2))*100;
    state.Results.sw = sqrt(sum(sw.^2, 2))*100;
    state.Results.nash = sqrt(sum(nash.^2, 2))*100;
    state.Results.kalai = sqrt(sum(kalai.^2, 2))*100;
    state.Results.stats = mean([state.Results.pd,...
                              state.Results.sw,...
                              state.Results.nash,...
                              state.Results.kalai]); 
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

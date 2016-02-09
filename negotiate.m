function state = negotiate(options)

    if isempty(options)
       load ('UFhom');
       options = dgmset(options, ...
                    'Swnk', swnk, ...
                    'Agents', uf , ...
                    'AgentType', 'quotas', ...
                    'MediationType', 'dgm1', ...
                    'Nag', 2, ...
                    'Ni', 100, ...
                    'Nsets', 1, ...
                    'Nexp', 1, ...
                    'SelectionThreshold', [], ...
                    'Generations', 100, ...
                    'PopulationSize', 20, ...
                    'Plot', 'on', ...
                    'PlotFcn', {@plotrewardsfcn,@plotwinnercounterfcn}, ...
                    'QuotaType', 'decay', ...
                    'InitialQuota', 10);
    end
    if strcmp(options.AgentType,'quotas')
        options.SelectionThreshold = 0.999999;
    else
        options.SelectionThreshold = 0.75;
    end
    state.AgentPriorities = ones(1,options.Nag)/options.Nag;
    state.Results.x = [];
    state.Results.y = [];  
    options = dgmset(options, 'Quotas', ...
        floor(options.InitialQuota*(1/options.InitialQuota).^((0:options.Generations-1)/(options.Generations-1))));
        
    pd = []; sw = []; nash = []; kalai = []; nashpf = []; kalaipf = [];
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
        
        %%Bucle de negociaciones por Set       
        for j=1:options.Nexp
            fprintf(' %i - ', j);
            state.Quota = options.InitialQuota;
            state.PopulationSize = options.PopulationSize;
            state.Score = [];               %Votos emitidos sobre el hijo ganador
            state.Expectation = [];         %Agregación de votos del hijo ganador
            state.MaxPopulationSize = options.PopulationSize;
            
            thisPopulation = creationfcn(options.PopulationSize,options.Ni);
            prevScore = zeros(1,options.Nag);
            
            %Bucle de negociación
            for k=1:options.Generations
                fval = CurrentAgents(thisPopulation);
                score = votingfcn(fval,fix(state.Quota),options.AgentType);
                expectation = aggregationfcn(score,state.AgentPriorities,options.MediationType);
                selection = selectionfcn(expectation,k);
                                
                state.Score(k,:) = score(selection,:) + prevScore;
                prevScore = state.Score(k,:);
                state.Expectation(k) = expectation(selection);

                switch options.QuotaType
                    case 'fixed'
                        
                    case 'dynamic'
                        state = updatepopulationsizefcn(options.SelectionThreshold,state,k);
                        state = updatequotafcn(options.SelectionThreshold,state,k);
                    case 'decay'
                        state.Quota = options.Quotas(k);
                    case 'dynamicquota'
                        state = updatequotafcn(options.SelectionThreshold,state,k);
                    case 'dynamicpopulationsize'
                        state = updatepopulationsizefcn(options.SelectionThreshold,state,k);
                    
                end
                thisPopulation = mutationfcn(thisPopulation(selection,:),state.PopulationSize);
                

                if strcmp(options.Plot,'on')
                    subplot(3,2,1);
                    plotrewardsfcn(options.Generations,fval(1,:),k);
                    subplot(3,2,2);
                    plotexpectationfcn(options.Generations,k,expectation(selection));
                    subplot(3,2,3);
                    plotcumscorefcn(options.Generations,k,prevScore);
                    subplot(3,2,4);
                    plotscorefcn(options.Generations,k,score(selection,:));
                    subplot(3,2,5);
                    if state.PopulationSize>state.MaxPopulationSize
                        state.MaxPopulationSize = state.PopulationSize;
                    end
                    plotquotafcn(options.Generations,state.MaxPopulationSize,k,state.Quota,state.PopulationSize);
                    subplot(3,2,6);
                    plotxfcn(thisPopulation(1,:),options.Ni);
                end

            end
            
            x(j,:) = thisPopulation(1,:);
            y(j,:) = fval(1,:);
        end
        
        state.Results.x = [state.Results.x;x];
        state.Results.y = [state.Results.y;y];
        sw = [sw; y./repmat(options.Swnk{i,options.Nag}.sw, options.Nexp, 1)];
        %sw = [sw; sum(y,2)/sum(options.Swnk{i,options.Nag}.sw)];
        nash = [nash; repmat(options.Swnk{i,options.Nag}.nash, options.Nexp, 1) - y];
        kalai = [kalai; repmat(options.Swnk{i,options.Nag}.kalai, options.Nexp, 1) - y];
        if options.Nag <= 3
            pd = [pd; getparetoeval(y, options.Swnk{i,options.Nag}.fval) - y];
        end
    end
    
    state.Results.nash = sqrt(sum(nash.^2, 2))*100;
    state.Results.kalai = sqrt(sum(kalai.^2, 2))*100;
    state.Results.sw = sum(sw,2)/options.Nag;
    
    if options.Nag <= 3
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

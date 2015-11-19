function options = negoset()
    options.draw = false;
    options.save = true;
    options.ni = 5;
    options.na = 3;
    options.maxrounds = 1000;
    options.mediator = [1 3 4]; % 1:NSao 2:DGM colaborativo 3:DGM no-colaborativa 4:Random priorities
    options.sg = [1 1 5];
    options.agents = [2]'*ones(1,options.na); % 1:CAg 2:sAg 31:quotas (beta(1)) 32:quotas (beta(2))...
    
    options.nat = size(options.agents, 1);
    load(['UFB' num2str(options.ni) 'i']);
    options.uf = uf;
    options.pf = pf;
    
    if options.draw == false
        options.nsets = length(uf);          % Número de diferentes sets de funciones de utilidad
        options.nexp =  100/options.nsets;   % Número de experimentos con cada función de utilidad
    else
        options.nsets = 1;
        options.nexp  = 1;
    end
    
    options.qo = 0.25*(options.ni*2+1); 
    options.qf = 1; 
    options.beta = [2 1 -2];
    options.nm = length(options.mediator); 
    options.ns = size(options.sg,1);  
    options.domain = [zeros(1, options.ni); ...
            ones(1, options.ni)];
    options.quotas = [options.qo options.qf options.beta(1);options.qo options.qf options.beta(2);options.qo options.qf options.beta(3)];
    options.name = [datestr(clock) '_test_' num2str(options.ni) 'i' num2str(options.na) 'a' num2str(options.mediator) 'm' num2str(options.nat) 'at' num2str(options.maxrounds) 'rs']; 
end

% options.qo quota ioptions.nicial % options.qf quota fioptions.nal
% options.beta: a mayor options.beta más rápida es la caída
% figure;
% mr = options.maxrounds;
% t = 1:mr;
% plot(t, round(options.qf+(options.qo-options.qf)*(1-exp(options.beta*(1-(t-1)/(mr-1))))/(1-exp(options.beta))));
function negotiation = negotiate()
% NEGOTIATE
    options = negoset();
    sol = cell(options.nm, options.ns, options.nat, options.nsets);
    negotiation.options = options;

    for im=1:options.nm
        for is=1:options.ns
            for ia=1:options.nat
                for iset=1:options.nsets
                    clear MA;
                    MA = medagent(options.maxrounds, options.mediator(im), options.sg(is,:));
                    for i=1:options.na
                        ag{i} = agent(i, options.uf{iset}{i}, MA, options.agents(ia, i),...
                            options.quotas);
                    end
                    if options.draw
                        v = fcnview(MA, ag);
                    end
                    for ie=1:options.nexp
                        clear Msh;
                        if options.draw
                            v.Reset(MA);
                        end
                        Msh = meshdsnp(options.ni,...
                                rand(1,options.ni),...
                                options.domain, 0.1, 2, 0.5, 'GPS2N');
                        tic
                        sol{im, is, ia, iset}.eval(ie,:) = MA.negotiate(Msh);
                        sol{im, is, ia, iset}.t(ie) = toc;
                        disp(['Mediator: ' num2str(im) ' Sigma:' num2str(is) ' Ag: ' ...
                            num2str(options.agents(ia,:)) ' Exp: ' num2str(iset) '-' num2str(ie)]);
                    end
                end
                negotiation.sol = sol;
                if options.save == true
                    save(options.name, 'negotiation');
                end
            end
        end
    end

end
function perf = evalperformance(sol, ni)
%  EVALPERFORMANCE Mide el rendimiento de negociaciones entre agentes.
%   [P] = EVALPERFORMANCE(SOL, NI) retorna las distancias al frente de
%   pareto, solución nash y solución kalai (maximin), y social welfare de 
%   las negociaciones contenidas en SOL. NI
%   indica el número de issues que a su vez permite extraer el frente de
%   pareto del fichero UFBxxi.mat de funciones de utilidad.
%   
%   SOL es un cell-array {nm,ns,nat,nsets} donde NM indexa los
%   tipos de mediador, NS los tipos de función sigma, NAT los tipos de
%   agentes negociadores, y NSETS el número de sets de funciones.
%
%   Copyright 2015 Miguel Á. López-Carmona, UAH.

    load(['UFB' num2str(ni) 'i']);
    [nm, ns, nat, nsets] = size(sol);
    [nexp, na] = size(sol{1,1,1,1}.eval);
    
    for im=1:nm
        for is=1:ns
            for ia=1:nat
                pd = [];
                sw = [];
                nash = [];
                kalai = [];
                for iset=1:nsets
                    eval = sol{im,is,ia,iset}.eval;
                    pd = [pd; getparetodist(eval, pf{iset}{na}.fval) - eval];
                    sw = [sw; repmat(pf{iset}{na}.sw, nexp, 1) - eval];
                    nash = [nash; repmat(pf{iset}{na}.nash, nexp, 1) - eval];
                    kalai = [kalai; repmat(pf{iset}{na}.kalai, nexp, 1) - eval];
                end
                perf{im,is,ia}.pd = sqrt(sum(pd.^2, 2))*100;
                perf{im,is,ia}.sw = sqrt(sum(sw.^2, 2))*100;
                perf{im,is,ia}.nash = sqrt(sum(nash.^2, 2))*100;
                perf{im,is,ia}.kalai = sqrt(sum(kalai.^2, 2))*100;
                perf{im,is,ia}.stats = mean([perf{im,is,ia}.pd,...
                                             perf{im,is,ia}.sw,...
                                             perf{im,is,ia}.nash,...
                                             perf{im,is,ia}.kalai]);              
            end
        end
    end
end

function pd = getparetodist(eval, fval)
    [nre, nce] = size(eval);
    [nrf, ncf] = size(fval);
    pd = [];
    for i=1:nre
        [x, ind] = min( sum((fval-repmat(eval(i,:),nrf,1)).^2, 2));
        pd = [pd; fval(ind, :)];
    end
end
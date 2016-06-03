function feval = getAgents(nset,nag,uf)
    feval = '@(x) [';
    for k=1:nag-1
        feval = [feval, ...
            'uf{' num2str(nset) ',' num2str(k) '}(x),']; %#ok<AGROW>
    end
    feval = [feval, ...
         'uf{' num2str(nset) ',' num2str(k+1) '}(x)]'];       
    feval = eval(feval);
end
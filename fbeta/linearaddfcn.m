function f = linearaddfcn(ni,type,params)
%   F = LINEARADDFCN(NI, TYPE, PARAMS) crea una funci�n de utilidad aditiva binaria por defecto.
%   Se puede extender a funci�n aditiva real.
%
%   NI es el n�mero de issues, TYPE fuerza la
%   generaci�n de un determinado tipo de funci�n de utilidad. PARAMS recibe
%   los par�metros espec�ficos de un determinado TYPE de funci�n de utilidad.
%
%   Se contempla una funci�n U(c) = sum_p=1->I sum_q=p->I (P(p,q))*dq*dp))
%   TYPE y PARAMS determinan los ni*(ni+1)/2 coeficientes P(p,q) que se van a
%   utilizar.
%
%   F es una funci�n de NI issues vectorizada.

    coeffs = triu(unifrnd(-100,100,ni,ni));
    f = @(x) fcn(x,coeffs);

    options = gaoptimset;
    options = gaoptimset(options,'Display', 'off');
    options = gaoptimset(options,'Vectorized', 'on');
    options = gaoptimset(options,'PopulationType', 'bitstring'); 


    [x,maxfval] = ga(@(x) -1*f(x), ni,[],[],[],[],[],[],[],[],options);
    [x,minfval] = ga(@(x) f(x), ni,[],[],[],[],[],[],[],[],options);

    maxfval = -1*maxfval;

    f = @(x) (f(x)-minfval)/(maxfval-minfval);

end

function y = fcn(x,coeffs)  
    [nc,lc] = size(x); % N�mero de contratos e issues
    xp = x';
    p=repmat(reshape(xp,1,[]),lc,1);
    r=reshape(repmat(xp,lc,1),lc,lc*nc);
    y = sum(reshape(sum(p.*r.*repmat(coeffs,1,nc)),lc,nc))';
end










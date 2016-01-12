function f = fcnadd(ni, type, params)
%FCNADD Creación de una functión de utilidad Non-linear additive
%   F = FCNADD(NI, TYPE, PARAMS) crea una función de utilidad aditiva binaria.
%
%   NI es el número de issues, TYPE fuerza la
%   generación de un determinado tipo de función de utilidad. PARAMS recibe
%   los parámetros específicos de un determinado TYPE de función de utilidad.
%
%   Se contempla una función U(c) = sum_p=1->I sum_q=p->I (P(p,q))*dq*dp))
%   TYPE y PARAMS determinan los ni*(ni+1)/2 coeficientes P(p,q) que se van a
%   utilizar.
%
%   TYPE puede ser 'het' si los coeficientes se generan a partir de una
%   función de distribución Beta, o 'hom', si se generan a partir de una
%   distribución uniforme.
%   En el caso de una distribución Beta, los coeficiente que podemos
%   utilizar son los siguientes:
%
%   Uniform:    [1 1 0]
%   Bell:       [5 5 1.75]
%   Left:       [6 2 1] 
%   Right:      [2 6 1]

%   PARAMS contiene los parámetros necesarios para utilizar el TYPE 'het'.
%   Para este tipo de funciones, PARAMS es un vector con tres elementos que
%   configuran una distribución Beta (Ver paper de Fabian Lang y Andreas
%   Fink).
%
%   F es una función de NI issues vectorizada.

if strcmp(type,'het')
    beta = betapdf(linspace(0,1,2*ni+1), params(1), params(2));
    beta = (beta - params(3));
    k=1;
    for i=1:ni
        for j=i:ni
            b(k) = beta(i+j);
            k=k+1;
        end
    end
else
    b = unifrnd(-100,100,1,ni*(ni+1)/2);
end

f = @(x) uc(x, b);

options = gaoptimset;
options = gaoptimset(options,'Display', 'off');
options = gaoptimset(options,'Vectorized', 'on');
options = gaoptimset(options,'PopulationType', 'bitstring'); 


[x,maxfval] = ga(@(x) -1*f(x), ni,[],[],[],[],[],[],[],[],options);
[x,minfval] = ga(@(x) f(x), ni,[],[],[],[],[],[],[],[],options);

maxfval = -1*maxfval;

f = @(x) (f(x)-minfval)/(maxfval-minfval);

end

function y = uc(x, b)  

nc = size(x,1); % Número de contratos
lc = size(x,2); % Número de issues

if(lc==1)
    y=x*b(end);
    return
end
s = zeros(nc,1);
for i=1:lc
    s = s+x(:,1).*x(:,i)*b(i);
end
y = s+uc(x(:,2:end), b(lc+1:end));

end




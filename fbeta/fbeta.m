function f = fbeta(abc, ni, domain, type)
%abc-parámetros A, B y C de la distribución Beta con parámetros A y B
%ni-número de issues
%domain-dominio del espacio de acuerdos
%type- 'hom' 'het'
% homogeneous agents: Uniform Distribution; heterogeneous agents: Beta
    if strcmp(type,'het')
        beta = betapdf(linspace(0,1,2*ni+1), abc(1), abc(2));
        beta = (beta - abc(3));
        % Reordenación de la distribución lineal en función de índices
        % Calculo un vector con la suma de índices
        k=1;
        for i=1:ni
            for j=i:ni
                b(k) = beta(i+j);
                k=k+1;
            end
        end
    else
        b = unifrnd(-1,1,1,ni*(ni+1)/2);
    end
    options = optimset('MaxIter', 1500, 'Display', 'iter');
    
    [x, maxval] = patternsearch(@(sc) ...
        -1.*uc(sc, b), ...
        unifrnd(0,1,1,ni), ...
        [], [], [], [], ...
        zeros(1,ni), ...
        ones(1,ni), ...
        [], ...
        options);
    maxval = maxval*-1;
    [x, minval] = patternsearch(@(sc) ...
        uc(sc, b), ...
        unifrnd(0,1,1,ni), ...
        [], [], [], [], ...
        zeros(1,ni), ...
        ones(1,ni), ...
        [], ...
        options);  
    f = @(sc) ucmain(sc, b, domain, [minval maxval]);
end

function y = ucmain(sc, b, domain, normparams)
    y = uc(sc, b);
    y = (y-normparams(1))/(normparams(2)-normparams(1));
    nc = size(sc, 1);
    domainlow = repmat(domain(1,:), nc, 1);
    domainhigh = repmat(domain(2,:), nc, 1);
    y(sum(sc < domainlow | sc > domainhigh, 2) > 0) = 0;
end

function y = uc(sc, b)
    % sc-matriz dónde cada fila representa un contrato
    % Función recursiva para calcular la utilidad de contratos con una
    % función de distribución Beta
    % C Contrato de nissues
    % B Vector con los coeficientes de la distribución Beta
    
    nc = size(sc,1); % Número de contratos
    lc = size(sc,2); % Número de issues del contrato que quedan por computar
    if(lc==1)
        y=sc*b(end);
        return
    end
    s = zeros(nc,1);
    for i=1:lc
        s = s+sc(:,1).*sc(:,i)*b(i);
    end
    y = s+uc(sc(:,2:end), b(lc+1:end));
end




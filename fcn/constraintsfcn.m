function f = constraintsfcn(ni,domaininterval)
%   F = CONSTRAINTSFCN(NI, DOMAININTERVAL) crea una función de utilidad basada en restricciones.
%
%   NI es el número de issues.
%
%   F es una función de NI issues vectorizada.
    d = [ones(1,ni)*domaininterval(1); ones(1,ni)*domaininterval(2)];
    %nint = 3;
    nint = 2;
    matinterv = ones(ni,ni)*nint;
    %nconstr = ones(1,ni)*5;
    nconstr = ones(1,ni)*2;
    for i=1:ni
        for j=1:ni
            ft{i,j} = @ft1;
            fu{i,j} = @fu1;
            ftopt{i,j} = [];
            fuopt{i,j} = [];
        end
    end
    sg = sgr(ni,...
            matinterv,...
            d,...
            ft,...
            ftopt,...
            fu,...
            fuopt);

    r = rsgr(sg,nconstr);
    f = @(x) frsgr(x,r,d);

    options = gaoptimset;
    options = gaoptimset(options,'Display', 'off');
    options = gaoptimset(options,'Vectorized', 'on');

   
%     [x,maxfval] = ga(@(x) -1*f(x), ni,[],[],[],[],d(1,:),d(2,:),[],1:ni,options);
%     [x,minfval] = ga(@(x) f(x), ni,[],[],[],[],d(1,:),d(2,:),[],1:ni,options);
    [x,maxfval] = ga(@(x) -1*f(x), ni,[],[],[],[],d(1,:),d(2,:),[],[],options);
    [x,minfval] = ga(@(x) f(x), ni,[],[],[],[],d(1,:),d(2,:),[],[],options);
    
    maxfval = -1*maxfval;

    f = @(x) (f(x)-minfval)/(maxfval-minfval);

end










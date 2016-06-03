
nvars = 2;
d = [ones(1,nvars);ones(1,nvars)*10];
nint = 10;
matintres = ones(nvars,nvars)*nint;

% nres = 0;
% for i=2:nvars
%     nres = [nres round(nchoosek(nvars,i)*(nint.^i)/2)];
% end
nres = ones(1,nvars)*20;
for i=1:nvars
    for j=1:nvars
        ft{i,j} = @ft1;
        fu{i,j} = @fu1;
        ftopt{i,j} = [];
        fuopt{i,j} = [];
    end
end


sgB=sgr(nvars,...
    matintres,...
    d,...
    ft,...
    ftopt,...
    fu,...
    fuopt);

rB=rsgr(sgB,nres);
% nvars = 10;
% nres = ones(1,10)*20;
% r=myrsgr(1,[0 10],nvars,nres);
% rB.R = r;
% rB.nv = nvars;
% rB.nr = sum(nres);
%Normalización a 1 de las funciones de utilidad. El optimizador genético
%funciona mejor que los restantes.
% fB = @(x) -1*frsgr(x,rB,d);
% options = gaoptimset('PopulationSize', 100*length(d));
% [x, fvalB] = ga(fB, length(d), [], [], [], [], d(1,:), d(2,:), [], options);
% fvalB = abs(fvalB);
%fB = @(x,d) frsgr(x,rB,d)./fvalB;
fB = @(x) frsgr(x,rB,d);
plotSurfs(d,fB,[]);
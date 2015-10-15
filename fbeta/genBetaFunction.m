%% BETA 
ni = 2; 
domain = [zeros(1,ni);ones(1,ni)];
abc.uniform = [1 1 0];
abc.bell_shaped = [5 5 1.75];
abc.left_skewed = [6 2 1]; 
abc.right_skewed = [2 6 1];

fu =fbeta(abc.('uniform'), ni, domain, [0 5050], 'het');
fr =fbeta(abc.('right_skewed'), ni, domain, [1 2.5], 'het');
fl =fbeta(abc.('left_skewed'), ni, domain, [1 2.5], 'het');
%fl =fbeta(abc.('left_skewed'), ni, domain, [1710 1680+1710], 'het');
fb =fbeta(abc.('bell_shaped'), ni, domain, [1270 451+1270], 'het');
fh1 =fbeta(abc.('uniform'), ni, domain, [200 360], 'hom');
fh2 =fbeta(abc.('uniform'), ni, domain, [200 360], 'hom');
fh3 =fbeta(abc.('uniform'), ni, domain, [200 360], 'hom');
fh4 =fbeta(abc.('uniform'), ni, domain, [200 360], 'hom');
fh5 =fbeta(abc.('uniform'), ni, domain, [200 360], 'hom');
fh6 =fbeta(abc.('uniform'), ni, domain, [200 360], 'hom');
fh7 =fbeta(abc.('uniform'), ni, domain, [200 360], 'hom');
fh8 =fbeta(abc.('uniform'), ni, domain, [200 360], 'hom');
fh9 =fbeta(abc.('uniform'), ni, domain, [200 360], 'hom');
fh10 =fbeta(abc.('uniform'), ni, domain, [200 360], 'hom');

fo = @(x) [-1*fr(x) -1*fl(x)];
fho = @(x) [-1*fr(x) -1*fl(x) -1*fh3(x) -1*fh4(x)];

uf{1}{1} = fr; % Agente 1
uf{1}{2} = fl; % Agente 2
uf{1}{3} = fb; % Agente 3
uf{1}{4} = fu; % Agente 4

save UFBeta f* u*

%Para pintar en 2D funciones de utilidad de 2 issues
ni=2;
d=[zeros(1,ni);...
    ones(1,ni)*2];
ezmeshc(@(x,y) fr([x y]), reshape(d, 1, numel(d)));
hold on;
ezmeshc(@(x,y) fl([x y]), reshape(d, 1, numel(d)));

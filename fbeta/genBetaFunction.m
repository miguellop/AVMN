%% BETA 
ni = 2; 
abc.uniform = [1 1 0];
abc.bell_shaped = [5 5 1.75];
abc.left_skewed = [6 2 1]; 
abc.right_skewed = [2 6 1];

fu =fbeta(abc.('uniform'), ni, 'het');
fr =fbeta(abc.('right_skewed'), ni, 'het');
fl =fbeta(abc.('left_skewed'), ni, 'het');
fb =fbeta(abc.('bell_shaped'), ni, 'het');
fh1 =fbeta(abc.('uniform'), ni, 'hom');
fh2 =fbeta(abc.('uniform'), ni, 'hom');
fh3 =fbeta(abc.('uniform'), ni, 'hom');
fh4 =fbeta(abc.('uniform'), ni, 'hom');
fh5 =fbeta(abc.('uniform'), ni, 'hom');
fh6 =fbeta(abc.('uniform'), ni, 'hom');
fh7 =fbeta(abc.('uniform'), ni, 'hom');
fh8 =fbeta(abc.('uniform'), ni, 'hom');
fh9 =fbeta(abc.('uniform'), ni, 'hom');
fh10 =fbeta(abc.('uniform'), ni, 'hom');

fuo= @(x)  fu(x)/5050;
fbo= @(x)  (fb(x)+1270)/(451+1270);
fro= @(x)  (fr(x)+1710)/(1680+1710);
flo= @(x)  (fl(x)+1710)/(1680+1710);

fh1o= @(x) (fh1(x)+194)/(161+194);
fh2o= @(x) (fh2(x)+181)/(153+181);
fh3o= @(x) (fh3(x)+203)/(165+203);
fh4o= @(x) (fh4(x)+217)/(140+217);
fh5o= @(x) (fh1(x)+194)/(161+194);
fh6o= @(x) (fh2(x)+181)/(153+181);
fh7o= @(x) (fh3(x)+203)/(165+203);
fh8o= @(x) (fh4(x)+217)/(140+217);
fh9o= @(x) (fh3(x)+203)/(165+203);
fh10o= @(x) (fh4(x)+217)/(140+217);

fo = @(x) [-1*fro(x) -1*flo(x)];
fho = @(x) [-1*fro(x) -1*flo(x) -1*fh3o(x) -1*fh4o(x)];

uf{1}{1} = fro; % Agente 1
uf{1}{2} = flo; % Agente 2
uf{1}{3} = fbo; % Agente 3
uf{1}{4} = fuo; % Agente 4

save UFBeta f* u*

%Para pintar en 2D funciones de utilidad de 2 issues
% d=[zeros(1,ni);...
%     ones(1,ni)];
% ezmeshc(@(x,y) fro([x y]), reshape(d, 1, numel(d)));
% hold on;
% ezmeshc(@(x,y) flo([x y]), reshape(d, 1, numel(d)));

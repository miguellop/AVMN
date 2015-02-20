%% BELL fix con 2 picos por UF. Función muy Suave

clf
a = 0;
b = 50;
c = 100

w = [35 40 40 80];

A = [a c; b c; a b; b b]; 
B = [c c; b c; c b; b b];
C = [a a; b a; a b; b b];
D = [c a; c b; b a; b b];

h = [1 0.45  0.45 0.5];

uf{1}{1} = fbellfix(A,w,h, false);
uf{1}{2} = fbellfix(B,w,h, false);
uf{1}{3} = fbellfix(C,w,h, false);
uf{1}{4} = fbellfix(D,w,h, false);

clf
d=[0 0;100 100];
nfAll = [1 2 3 4];
nfTwo = [3 4];

ufaggAll = cell(1,length(nfAll));
ufaggTwo = cell(1,length(nfTwo));

for i = 1:length(nfAll)
    ufaggAll{i} = uf{1}{nfAll(i)};
end
for i = 1:length(nfTwo)
    ufaggTwo{i} = uf{1}{nfTwo(i)};
end

ufAll = fagg(ufaggAll);
ufTwo = fagg(ufaggTwo);

colormap('default')
for i=1:4
        subplot(3,2,i);
        ezmeshc(@(x,y) uf{1}{i}(x,y), reshape(d, 1, numel(d)));
        hold on;
end
subplot(3,2,5);
ezmeshc(@(x,y) ufAll(x,y), [0 100 0 100]);

subplot(3,2,6);
ezmeshc(@(x,y) ufTwo(x,y), [0 100 0 100]);

axis auto

%save UFfix uf

%% BELLs Random (UFrandom)

ni = 2; %nissues
na = 4; %nagents
d=[zeros(1,ni);100*ones(1,ni)];
for k=1:1
    for index = 1:na
        p = [0.01 0.5];% p fija la complejidad de las bells
        r = @(d,n)  (d*(100^n)*gamma(n/2+1)/pi^(n/2))^(1/n);
        uf{k}{index} = fbell(30, ni,[r(p(1),ni) r(p(2),ni)],[0.1 1],true);
    end
end

clf
colormap('default')
for i=1:4
        subplot(2,2,i);
        ezmeshc(@(x,y) uf{1}{i}(x,y), reshape(d, 1, numel(d)));
        hold on;
end
axis auto
%save UFrandom uf

%% BELLs Random (UFrandom) VERSIÓN HARD

ni = 2; %nissues
na = 4; %nagents
d=[zeros(1,ni);100*ones(1,ni)];
for k=1:5
    for index = 1:na
        p = [0.01 0.05];% p fija la complejidad de las bells
        r = @(d,n)  (d*(100^n)*gamma(n/2+1)/pi^(n/2))^(1/n);
        uf{k}{index} = fbell(100, ni,[r(p(1),ni) r(p(2),ni)],[0.1 1],true);
    end
end

clf
colormap('default')
for i=1:4
        subplot(2,2,i);
        ezmeshc(@(x,y) uf{1}{i}(x,y), reshape(d, 1, numel(d)));
        hold on;
end
axis auto
save UFrandomHard uf

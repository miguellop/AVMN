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

%% BELL fix con 1 pico por UF
for k=1:5
    centers = [25 75 25 75; 25 25 75 75]';

    w = [100 100 100 100];

    h = [1,1,1,1];

    for i=1:4
        uf{k}{i} = fbellfix(centers(i,:),w(i),h(i), false);
    end
end

clf
d=[0 0;100 100];
nf = 4;
ufagg = cell(1,nf);
for i=1:nf
    ufagg{i} = uf{1}{i};
end

ufa = fagg(ufagg);

colormap('default')
for i=1:4
        subplot(3,2,i);
        ezmeshc(@(x,y) uf{1}{i}(x,y), reshape(d, 1, numel(d)));
        hold on;
end
subplot(3,2,5);
ezmeshc(@(x,y) ufa(x,y), [0 100 0 100]);
axis auto

%save UFfix uf

%% BELL fix con dos bells para mostrar como funciona GPS
centers = [25 75; 25 75]';

w = [100 100];

h = [1,1];

for i=1:2
    uf{1}{i} = fbellfix(centers(i,:),w(i),h(i), false);
end
%save UFfixforGPS uf
clf
d=[0 0;100 100];
nf = 2;
ufagg = cell(1,nf);
for i=1:nf
    ufagg{i} = uf{1}{i};
end

ufa = fagg(ufagg);

colormap('default')
for i=1:2
        subplot(2,2,i);
        ezmeshc(@(x,y) uf{1}{i}(x,y), reshape(d, 1, numel(d)));
        hold on;
end
subplot(2,2,3);
ezmeshc(@(x,y) ufa(x,y), [0 100 0 100]);
axis auto

%% FSINC

clf

A = [0 100]; 
B = [100 100];
C = [0 0];
D = [100 0];
Tcos = 10;
delta = 1;

uf{1}{1} = fsinc(A,Tcos,delta);
uf{1}{2} = fsinc(B,Tcos,delta);
uf{1}{3} = fsinc(C,Tcos,delta);
uf{1}{4} = fsinc(D,Tcos,delta);

clf
d=[0 0;100 100];
nfAll = [ 1 2 3 4 ];
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

save UFfix uf


%% Generar función basada en Restricciones
ni = 2; %nissues
na = 1; %nagents
d=[zeros(1,ni);100*ones(1,ni)];
nc = 10;
L = [2 10];
norm = false;

[uf C] = fConsIto(d, ni, L, norm, nc)

clf

for i=1:na
        %subplot(1,1,i);
        fB = uf;
        [xa.x xa.y]=meshgrid(linspace(d(1,1), d(2,1),10));
        colormap('default')
        ezmeshc(@(x,y) fB([x y], d), reshape(d, 1, numel(d)));
        hold on;
end
axis auto

%% BELLs Random (UFrandom)

ni = 2; %nissues
na = 4; %nagents
d=[zeros(1,ni);100*ones(1,ni)];
for k=1:5
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
        p = [0.01 0.5];% p fija la complejidad de las bells
        r = @(d,n)  (d*(100^n)*gamma(n/2+1)/pi^(n/2))^(1/n);
        uf{k}{index} = fbell(10, ni,[r(p(1),ni) r(p(2),ni)],[0.1 1],true);
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
%save UFrandomHard uf

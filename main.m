%%%%%%%%%
% Main
%%%%%%%%%
clear all;
draw = false;
ni = 100;
load(['UFB' num2str(ni) 'i']);
nsets = length(uf);  % Número de diferentes sets de funciones de utilidad
nexp =  20;  % Número de experimentos con cada función de utilidad

domain = [zeros(1, ni);...
    ones(1, ni)];
maxrounds = 1000;
mediator = [1];                                 % 1:NSao 2:DGM 3:DSao
sg = [1 100 5];
agents = [ones(1,3);2*ones(1,3);31*ones(1,3)];% 1:CAg 2:sAg 31:quotas (beta(1)) 32:quotas (beta(2))...

qo = 0.95*(ni*2+1); 
qf = 1; 
beta = [2 1 -2];
quotas = [qo qf beta(1);qo qf beta(2);qo qf beta(3)];
% qo quota inicial % qf quota final
% beta: a mayor beta más rápida es la caída
% figure;
% mr = maxrounds;
% t = 1:mr;
% plot(t, ...
%     round(qf+(qo-qf)*(1-exp(beta*(1-(t-1)/(mr-1))))/(1-exp(beta))));

nm          =  length(mediator); 
ns          =  size(sg,1);     
[nat, na]   =  size(agents); 

fname = [datestr(clock) '_test_' num2str(ni) 'i' num2str(na) 'a' num2str(mediator) 'm' num2str(nat) 'at' num2str(maxrounds) 'rs']; 
sol = cell(nm, ns, nat, nsets);

for im=1:nm
    for is=1:ns
        for ia=1:nat
            for iset=1:nsets
                clear MA;
                MA = medagent(maxrounds, mediator(im), sg(is,:));
                for i=1:na
                    ag{i} = agent(i, uf{iset}{i}, MA, agents(ia, i),...
                        quotas);
                end
                if draw
                    v = fcnview(MA, ag);
                end
                for ie=1:nexp
                    clear Msh;
                    if draw
                        v.Reset(MA);
                    end
                    Msh = meshdsnp(ni,...
                            rand(1,ni),...
                            domain, 0.1, 2, 0.5, 'GPS2N');
                    tic
                    sol{im, is, ia, iset}.eval(ie,:) = MA.Negotiate(Msh);
                    sol{im, is, ia, iset}.t(ie) = toc;
                    disp(['Mediator: ' num2str(im) ' Sigma: ' num2str(is) ' Ag: ' ...
                        num2str(agents(ia,:)) ' Exp: ' num2str(iset) '-' num2str(ie)]);
                end
            end
            save(fname, 'sol');
        end
    end
end

%% Evalperformance
perf = evalperformance(sol,20)
disp('                                    pd         sw         nash           kalai')
for i=1:1
    for j=1:1
        for k=1:nat
            disp(['Mediator: ' num2str(i) ' Sigma: ' num2str(j) ' Ag: ' ...
                        num2str(agents(k,:)) ' -> '  num2str(perf{i,j,k}.stats)]);
        end
    end
end
% p-value y h=1|0
% p-value indica la probabilidad de que dadas las muestras, su estadístico
% se corresponda con la hipótesis nula. La hipótesis nula representa la
% suposición de partida. Por ejemplo, si estamos comprobando que dos
% experimentos tienen la misma media (es decir, que son similares), un
% valor p-value alto indica que las muestras, con una
% probabilidad p-value, se corresponden efectivamente con la suposición de
% que los experimentos similares. Si p-value es muy bajo, indica que la
% probabilidad de que las muestras se correspondan con experimentos con
% resultados similares es muy baja. Podemos por tanto rechazar la hipótesis
% y h=1. h=0 indica que no podemos rechazar la hipótesis.
% En definitiva, si utilizo ranksum(a,b), y p-value es pequeño, significa
% que a y b son diferentes, en cuyo caso h=1. Si p-value es alto, significa
% que la hipótesis nula se confirma, y a y b son similares.
%
% Antes de aplicar un test no paramétrico o paramétrico, tengo que
% comprobar la normalidad de las muestras. Para comprobar la normalidad
% puedo utilizar ttest(). Si son normales, puedo utilizar ttest2() para
% muestras no apareadas. Si no son normales, tengo que utilizar un test de
% medianas no paramétrico como Wilcoxon. Para ello utilizo ranksum() si las
% muestras no están apareadas.

%% HISTOGRAMAS 3D DE UTILIDADES DE AGENTES
figure
nagents = 8;
z=1;
sets = [1:5 13 14];
x = 0:0.1:1;
sz = length(sets)*3;
p = 1:sz; %orden de plots
p = reshape(reshape(p,3,length(sets))',1,sz);


% Plot de bar3 de utilidades de los 4 agentes
for i=1:3 % (1)-Sum operator (2)-GPS operator (3)-Yager operator
    for j=1:1 % (1)-Sgm off (2)-Sgm on
        for k=sets                 
            subplot(length(sets),3,p(z));
            z=z+1;
            bincounts = zeros(length(x),4);
            for ag=1:nagents  % (1) Ag1 (2) Ag2 (3) Ag3 (4) Ag4              
                bincounts(:,ag) = histc(e(i,j,k).peval(:,ag),x);
            end
            %bincounts = log10(bincounts);       
            colors = {[0.8 0.8 0.8],[0.4 0.4 0.4],...
                [0.8 0.8 0.8],[0.4 0.4 0.4],[0.8 0.8 0.8],[0.8 0.8 0.8]};
            
            h = bar3(x,bincounts);
            ylim([0 1]);
            zlim([0 40]);
            for c = 1:nagents
                set(h(c),'FaceColor',colors{experiment.Agent.Types(k,c)});  
            end
        end
    end
end

%% PLOTCDF REWARDS
% 'red','yellow' NSao 
% 'green','cyan' YAo 
% 'blue','black' DSao 
LineStyle = {'-',':','--','-.'};
MarkerStyle = {'.','o','^','s'};
colors = {'red','green','blue','yellow','cyan','black'};
profile = [1 13];

for i=1:3 % (1)-NSao (2)-YAo (3)-DSao
    for pf = 1:length(profile)
        pl = e(i,1,profile(pf)).peval(:,1:4);
        pl = reshape(pl,1,numel(pl)); 

        hc = cdfplot(pl);
        xlim([0 1.1]);
        set(hc,'color',colors{i},'LineStyle',LineStyle{pf});
        hold on;   
    end
end
%% PLOTCDF SW
% 'red','yellow' NSao 
% 'green','cyan' YAo 
% 'blue','black' DSao 

LineStyle = {':','--','-','-.',':'};
MarkerStyle = {'.','o','^','s'};
colors = {'red','green','blue','yellow','cyan','black'};
profile = [1 2 3];

for i=1:3 % (1)-NSao (2)-YAo (3)-DSao
    for pf = 1:length(profile)
        pl = e(i,1,profile(pf)).sw;
        pl = reshape(pl,1,numel(pl)); 
        [hc,st(i,pf)] = cdfplot(pl);
        set(hc,'color',colors{i},'LineStyle',LineStyle{pf});
        hold on;  
    end

end
%% PLOT BAR3

% z=1;
% % Plot de bar3 de utilidades de los 4 agentes
% for i=1:3 % (1)-Sum operator (2)-GPS operator (3)-Yager operator
%     for j=1:1 % (1)-Sgm off (2)-Sgm on
%         for k=sets                 
%             subplot(3,length(sets),z);
%             z=z+1;
%             bincounts = histc(e(i,j,k).sw,x);
%             colors = {[0.8 0.8 0.8],[0.4 0.4 0.4],[0.8 0.8 0.8],[0.4 0.4 0.4],};
%             
%             h = bar(x,bincounts);
%         end
%     end
% end
%% HISTFIT
sets = [1 6 7];
LineStyle = {'-','--',':','-.'};
MarkerStyle = {'.','o','^','s'};
ColorStyle = {'black','red','green','blue'};
z=1;
for i=1:3 % (1)-Sum operator (2)-GPS operator (3)-Yager operator
    for j=1:1 % (1)-Sgm off (2)-Sgm on
        for k=sets     
            subplot(3,length(sets),z);
            z=z+1;
            for ag=1:4  % (1) Ag1 (2) Ag2 (3) Ag3 (4) Ag4              
                h=histfit(e(i,j,k).peval(:,ag),20,'normal');
                hold on;
            
                set(h(2),'LineStyle','none',...
                         'LineWidth',0.25,...
                         'Marker',MarkerStyle{ag},...
                         'MarkerEdgeColor','k',...
                         'MarkerFaceColor','w',...
                         'MarkerSize',4);
                %set(h(1),'FaceColor',ColorStyle{p});
                delete(h(1)); % Borra el histograma, pero deja el ajuste. delete(h(2)) borra el ajuste
                hold on;
                xlim(0:1);
            end
            mediana(i,k,:) = median(e(i,j,k).peval(:,1:4));
            media(i,k,:) = mean(e(i,j,k).peval(:,1:4));
            desviacion(i,k,:) = std(e(i,j,k).peval(:,1:4));
            numfallos(i,k,:) = sum(e(i,j,k).peval(:,1:4)<=0.25);
        end
    end
end
%% ANOVA
[p,table,stats]=anova1(e(1,5).peval,{'Ag1','Ag2','Ag3','Ag4'},'on')

%% STATISTICS
z=0;
for i=1:3
    for k=1:20
        z=z+1;
        resultmediana(z,:) = mediana(i,k,:);
        resultmedia(z,:) = media(i,k,:);
        resultstdv(z,:) = desviacion(i,k,:);
        resultnumfallos(z,:) = numfallos(i,k,:);
    end
end
% resultmediana(1:20,:)
% resultmediana(21:40,:)
% resultmediana(41:60,:)
% resultmedia(1:20,:)
% resultmedia(21:40,:)
% resultmedia(41:60,:)
% resultstdv(1:20,:)
% resultstdv(21:40,:)
% resultstdv(41:60,:)
resultnumfallos(1:20,:)
resultnumfallos(21:40,:)
resultnumfallos(41:60,:)
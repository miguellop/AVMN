%%%%%%%%%
% Main
%%%%%%%%%
clear all;
% He fabricado experimentos con NexpA = 1 ó 5, y NexpB = 50, (10, 40) ...
experiment.NexpA = 4; %Número de diferentes sets de funciones de utilidad
experiment.NexpB = 25; %Número de experimentos con cada función de utilidad
experiment.UF = 'UFrandom8agents8issues';
experiment.nissues = 8;
experiment.nagents = 8;
experiment.Domain = [zeros(1,experiment.nissues);ones(1,experiment.nissues)*100];
experiment.Mediator.MaxRounds = 50;

experiment.draw = false;

experiment.Mediator.Types = [1 2 3]; 
nMdTypes = length(experiment.Mediator.Types);

                    % 1 - NSao 
                    % 2 - YAo 
                    % 3 - DSao
                    
experiment.Mediator.Sgm = [0 100 4 100]; 
nMdSgm = size(experiment.Mediator.Sgm,1);
                    % Sgm(1,:)=>(sgmy)
          
if experiment.nagents == 8                  
experiment.Agent.Types = [1 1 1 1 1 1 1 1;...
                          2 1 1 1 1 1 1 1;...
                          2 2 2 2 1 1 1 1;...
                          2 2 2 2 2 2 2 1;...
                          2 2 2 2 2 2 2 2;...
                            
                          3 3 3 3 3 3 3 3;...
                          4 4 4 4 4 4 4 4;...
                           
                          4 4 4 4 3 3 3 3;...
                             
                          4 4 4 4 1 1 1 1;...
                         
                          4 4 4 4 2 2 2 2;...
                          
                          3 3 3 3 1 1 1 1;...
                           
                          3 3 3 3 2 2 2 2;...

                          5 5 5 5 5 5 5 5;...
                          6 6 6 6 6 6 6 6;...
                            ]; 

else

experiment.Agent.Types = [1 1 1 1;...
                          2 1 1 1;...
                          2 2 1 1;...
                          2 2 2 1;...
                          2 2 2 2;...
                            
                          3 3 3 3;...
                          4 4 4 4;...
                           
                          4 4 3 3;...
                             
                          4 4 1 1;...
                         
                          4 4 2 2;...
                          
                          3 3 1 1;...
                           
                          3 3 2 2;...

                          5 5 5 5;...
                          6 6 6 6;...
                            ]; 
end
                        nAgTypes =  size(experiment.Agent.Types,1); 
                        nAgs     =  size(experiment.Agent.Types,2);
% 1 - CAg (Cooperative) 0.5 0.2 0.4 0.5 0.1
% 2 - SAg (Selfish) 0.5 0 0 0 0
% 3 - eCAg (Exagerate Cooperative) 1 0.6 0.4 0.3 0.1
% 4 - eSAg (Exagerate Selfish) 1 0 0 0 0

%% NEGOCIACIÓN                           
load (experiment.UF); 
fname = [datestr(clock) '_test_' experiment.UF]; 
sol = cell(nMdTypes, nMdSgm, nAgTypes, experiment.NexpA, experiment.NexpB);
for imdtype=1:nMdTypes
    for imdsgm=1:nMdSgm
        for iagtype=1:nAgTypes
            for k=1:experiment.NexpA
                UF = uf{k};
                
                clear MA;
                MA = medagent();
                MA.MaxRounds = experiment.Mediator.MaxRounds;
                MA.sg = experiment.Mediator.Sgm(imdsgm,:);
                MA.Type = experiment.Mediator.Types(imdtype);
                for i=1:nAgs
                    Ag{i} = agent(i, UF{i}, MA, experiment.Agent.Types(iagtype,i));
                end
                if experiment.draw
                    v = fcnview(MA, Ag);
                end
                for i=1:experiment.NexpB
                    clear Msh;
                    if experiment.draw
                        v.Reset(MA);
                    end
                    Msh = meshdsnp(experiment.nissues,...
                        100*rand(1,experiment.nissues),...
                        experiment.Domain, 10, 2, 0.5, 'GPS2N');
                    tic
                    sol{imdtype, imdsgm, iagtype, k, i} = MA.Negotiate(Msh);
                    sol{imdtype, imdsgm, iagtype, k, i}.t = toc;
                    
                    disp(['Mediator: ' num2str(imdtype) ' Sigma: ' num2str(imdsgm-1) ' Ag: ' ...
                        num2str(experiment.Agent.Types(iagtype,:)) ' Exp: ' num2str(k) '-' num2str(i)]);
                end
                
                save(fname, 'sol');
            end
        end
    end
end
% Para calcular intervalos de confianza ttest o normfit

%% GENERATE PRIVEVAL, SOCIAL WELFARE and NASH PRODUCT

load '07-Mar-2015 09:11:36_test_UFrandom8agents8issues'


for imdtype=1:nMdTypes
    for imdsgm=1:nMdSgm
        for iagtype=1:nAgTypes
            z=1;
            for k=1:experiment.NexpA
                for i=1:experiment.NexpB
                    priveval(z,:) = sol{imdtype, imdsgm, iagtype, k, i}.PrivEval;
                    z=z+1;
                end
            end
            e(imdtype,imdsgm,iagtype).peval = priveval;
            e(imdtype,imdsgm,iagtype).sw = sum(priveval,2);     % SOCIAL WELFARE
            e(imdtype,imdsgm,iagtype).np = prod(priveval,2);    % NASH PRODUCT
        end
    end
end
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
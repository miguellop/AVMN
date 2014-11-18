%%%%%%%%%
% Main
%%%%%%%%%
clear all;

experiment.Nexp = 1;
experiment.UF = 'UFfixforGPS';
experiment.Domain = [0 0;100 100];
experiment.Mediator.MaxRounds = 35;

experiment.Mediator.Types = [2 2]; nMdTypes = 1;
                    % 1 - RMd (Reference Mediator)
                    % 2 - YMd (Yager Mediator)
experiment.Mediator.Sgm = [200 200 2 200]; nMdSgm = 1;
                    % Sgm(1,:)=>(sgmy)
                    
experiment.Agent.Types = [1 1;...
                        %  2 1 1 1;...
                        %  2 2 1 1;...
                        %  2 2 2 1;...
                        %  2 2 2 2;...                            
                            ]; 
                        nAgTypes = size(experiment.Agent.Types,1); 
                        nAgs = size(experiment.Agent.Types,2);
                    % 1 - CAg (Cooperative)
                    % 2 - SAg (Selfish)
                    % 3 - eCAg (Exagerate Cooperative)
                    % 4 - eSAg (Exagerate Selfish)
                                  
load (experiment.UF); 

sol = cell(nMdTypes, nAgTypes, experiment.Nexp);
for imdtype=1:nMdTypes
    
    %for imdsgm=1:nMdSgm
        imdsgm = 1;
        for iagtype=1:nAgTypes
            clear MA;
            MA = medagent();
            MA.MaxRounds = experiment.Mediator.MaxRounds;
            MA.sg = experiment.Mediator.Sgm(imdsgm,:);
            MA.Type = experiment.Mediator.Types(imdtype);
            for i=1:nAgs
                Ag{i} = agent(i, UF{i}, MA, experiment.Agent.Types(iagtype,i));
            end
            v = fcnview(MA, Ag);

            for i=1:experiment.Nexp
                clear Msh;
                v.Reset(MA);
                Msh = meshdsnp();
                tic
                sol{imdtype, iagtype, i} = MA.Negotiate(Msh);
                sol{imdtype, iagtype, i}.t = toc;
                 
                
                %disp(['Mediator: ' num2str(imdtype) ' Sigma: ' num2str(imdsgm-1) ' Ag: ' ...
                 %   num2str(experiment.Agent.Types(iagtype,:))])
                disp(['Mediator: ' num2str(imdtype) ' Ag: ' ...
                    num2str(experiment.Agent.Types(iagtype,:))])
            end
            %save experiments sol;
        end
    %end
end
% Para calcular intervalos de confianza ttest
%%
load experiments

for imdtype=1:nMdTypes
    %for imdsgm=1:nMdSgm
        for iagtype=1:nAgTypes
            for i=1:experiment.Nexp
                priveval(i,:) = sol{imdtype, iagtype, i}.PrivEval;
            end
            e(imdtype,iagtype).peval = priveval;
            e(imdtype,iagtype).ev = mean(priveval);
            e(imdtype,iagtype).sw = mean(sum(priveval,2));

        end
    %end
end
%%
[p,table,stats]=anova1(e(1,5).peval,{'Ag1','Ag2','Ag3','Ag4'},'on')
%%
clf
axis([0 1 0 10]);
LineStyle = {'-','--',':','-.'};
MarkerStyle = {'.','o','^','s'};
hold on
z=1;
for k=1:2 % (1)-Sum operator (2)-GPS operator
    for j=1:5 
%          1 1 1 1;(1)
%          2 1 1 1;(2)
%          2 2 1 1;(3)
%          2 2 2 1;(4)
%          2 2 2 2;(5)                             
        subplot(2,5,z);
        z=z+1;
        for i=1:4  % (1) Ag1 (2) Ag2 (3) Ag3 (4) Ag4  
            h=histfit(e(k,j).peval(:,i),100);
            set(h(2),'LineStyle','none',...
                     'LineWidth',0.25,...
                     'Marker',MarkerStyle{i},...
                     'MarkerEdgeColor','k',...
                     'MarkerFaceColor','w',...
                     'MarkerSize',4);
            delete(h(1)); % Borra el histograma, pero deja el ajuste. delete(h(2)) borra el ajuste
            axis([0 1 0 2.2])
            hold on
        end
    end
end
  

%%
%Backup de configuración de experimentos
experiment.Agent.Types = [1 1 1 1;...
                          2 1 1 1;...
                          2 2 1 1;...
                          2 2 2 1;...
                          2 2 2 2;...
                            
                          3 3 3 3;...
                          4 4 4 4;...
                          
                          4 4 3 3;...
                            
                          4 1 1 1;...
                          4 4 1 1;...
                          4 4 4 1;...
                          
                          4 2 2 2;...
                          4 4 2 2;...
                          4 4 4 2;...
                          
                          3 1 1 1;...
                          3 3 1 1;...
                          3 3 3 1;...
                          
                          3 2 2 2;...
                          3 3 2 2;...
                          3 3 3 2;
                            ]; 
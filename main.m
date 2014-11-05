%%%%%%%%%
% Main
%%%%%%%%%
clear experiment;

experiment.Type = 'testbed';
experiment.Nexp = 1;
experiment.UF = 'UFfix';
experiment.Domain = [0 0;100 100];
experiment.Mediator.MaxRounds = 50;
experiment.Mediator.Selection = [2000 2000 2 200];
experiment.Mediator.Type = 3;
                    % 1 - Yager+Selection(determinista) 
                    % 2 - Yager+Selection(probabilístico) 
                    % 3 - Suma+Selection(determinista)
                    % 4 - Suma+Selection(probabilístico)

experiment.Agent.Types = [2 2];
                    % 1 - Selfish
                    % 2 - Cooperative
%%%%%%                                       
load (experiment.UF); 

MA = medagent();
MA.Type = experiment.Mediator.Type;              
MA.MaxRounds = experiment.Mediator.MaxRounds;
MA.sg = experiment.Mediator.Selection;
    % sg = sigmamin+(sigmamax-sigmamin)*G^((1-1/Nroundslimit)*p)

for i=1:length(experiment.Agent.Types)
    Ag{i} = agent(i, UF{i}, MA, experiment.Agent.Types(i));
end
v = fcnview(MA, Ag);

%ds = dataset({rand(length(upfactors),4, nexperiments),'EvalAverage','EvalProduct','Nrounds','MaxDistance'},...
%    {zeros(9,5),'FailureRate100','avgUtility','prodUtility', 'avgDistance', 'avgNrounds'},...
%    'ObsNames',{'UpStep0','UpStep0.25','UpStep0.5','UpStep0.75','UpStep1','UpStep1.25','UpStep1.5','UpStep1.75','UpStep2'});

for i=1:experiment.Nexp
    clear Msh;
    v.Reset(MA);
    Msh = meshdsnp();
    tic
    s = MA.Negotiate(Msh);
    t(i) = toc;
    disp(['Nexp: ' num2str(i)])
end
%    eval(['save output_' experimenttypestr '_' voidness{z} ' output']); 




% %Global Results
%     for i=1:nexperiments
%         EvalAverage(i) = sol(i).EvalAverage;
%         EvalProduct(i) = sol(i).EvalProduct;
%         Nrounds(i) = sol(i).Nrounds;
%     end
%     sel = MaxDistance <= m.SolTolerance;
%     fr = 100-sum(sel)/nexperiments*100;
%     av = mean(EvalAverage(sel));
%     pr = mean(EvalProduct(sel));
%     avd = mean(MaxDistance(sel));
%     nr = mean(Nrounds(sel));
%     ds(z,:) = dataset(EvalAverage, EvalProduct, Nrounds, MaxDistance, fr, av, pr, avd, nr);
%     %end
% 
% %%
% ds = dataset({rand(length(upfactors),4, nexperiments),'EvalAverage','EvalProduct','Nrounds','MaxDistance'},{zeros(9,5),'FailureRate100','avgUtility','prodUtility', 'avgDistance', 'avgNrounds'},'ObsNames',{'UpStep0','UpStep0.25','UpStep0.5','UpStep0.75','UpStep1','UpStep1.25','UpStep1.5','UpStep1.75','UpStep2'});
% %%
% boxplot([ds{'UpStep0','EvalAverage'}', ds{'UpStep0.25','EvalAverage'}', ds{'UpStep0.5','EvalAverage'}', ds{'UpStep0.75','EvalAverage'}', ds{'UpStep1','EvalAverage'}',...
%     ds{'UpStep1.25','EvalAverage'}', ds{'UpStep1.5','EvalAverage'}', ds{'UpStep1.75','EvalAverage'}']);
% 
% %% 
% load output_1e-06
% output = cumsum(sort(output,'descend'))';
% output=output./repmat(1:10,100,1);
% boxplot(output);
%%
%Código para dibujar plots de Distribuciones Acumuladas
% colors = 'kmcrgbk';
% nexperiments = 100;
% voidness = {'ref', '0', '0-25', '0-5', '0-75', '0-95'};
% lines = {'-','--',':','-.',':','--','-'};
% %markers = {'.','+','^','s','p','h','o'};
% markers = {'','','','','','',''};
% nfigures = 6;
% clf
% for i=1:nfigures
%     subplot(2,3,i);
%     eval(['load output_random1_' voidness{i}]);
%     output = sort(output,'descend');
%     for j=1:7
%         [f,x,flo,fup] = ecdf(reshape(output(1:j,:), 1,nexperiments*j));
%         %[f,x,flo,fup] = ecdf(mean(output(1:j,:)));
%  %       stairs(x,flo,[colors(j) ':'],'LineWidth',1); stairs(x,fup,[colors(j) ':'],'LineWidth',1);
% %        stairs(x,f,lines{j},'color',colors(j),'LineWidth',0.5);
%         stairs(x,f,strcat(lines{j},markers{j}),'color','k','LineWidth',0.75,'Markersize',3);
%         axis([0 1 0 1]);
%         hold on;
%     end
%     %output = cumsum(sort(output,'descend'))';
%     %output1 = median(output');
%     %boxplot(output);
%     title(voidness{i})
%     %axis([0 1.1 0 1.1])
%     grid off;
% end
% %plot([output1',output2',output3',output4'])
%%
%Cálculo de sumas de utilidades de los resultados (social welfare)

%%
% 
% load output_testbed_ref
% sw_sum_testbed_ref = mean(sum(output));
% [h p ci_testbed(1,:)] = ttest(sum(output),mean(sum(output)),0.15);
% load output_testbed_0
% sw_sum_testbed(1) = mean(sum(output));
% [h p ci_testbed(2,:)] = ttest(sum(output),mean(sum(output)),0.15);
% load output_testbed_0-25
% sw_sum_testbed(2) = mean(sum(output));
% [h p ci_testbed(3,:)] = ttest(sum(output),mean(sum(output)),0.15);
% load output_testbed_0-5
% sw_sum_testbed(3) = mean(sum(output));
% [h p ci_testbed(4,:)] = ttest(sum(output),mean(sum(output)),0.15);
% load output_testbed_0-75
% sw_sum_testbed(4) = mean(sum(output));
% [h p ci_testbed(5,:)] = ttest(sum(output),mean(sum(output)),0.15);
% load output_testbed_0-95
% sw_sum_testbed(5) = mean(sum(output));
% [h p ci_testbed(6,:)] = ttest(sum(output),mean(sum(output)),0.15);
% 
% load output_random_ref
% sw_sum_random_ref = mean(sum(output));
% [h p ci_random(1,:)] = ttest(sum(output),mean(sum(output)),0.15);
% load output_random_0
% sw_sum_random(1) = mean(sum(output));
% [h p ci_random(2,:)] = ttest(sum(output),mean(sum(output)),0.15);
% load output_random_0-25
% sw_sum_random(2) = mean(sum(output));
% [h p ci_random(3,:)] = ttest(sum(output),mean(sum(output)),0.15);
% load output_random_0-5
% sw_sum_random(3) = mean(sum(output));
% [h p ci_random(4,:)] = ttest(sum(output),mean(sum(output)),0.15);
% load output_random_0-75
% sw_sum_random(4) = mean(sum(output));
% [h p ci_random(5,:)] = ttest(sum(output),mean(sum(output)),0.15);
% load output_random_0-95
% sw_sum_random(5) = mean(sum(output));
% [h p ci_random(6,:)] = ttest(sum(output),mean(sum(output)),0.15);
% 
% load output_random1_ref
% sw_sum_random1_ref = mean(sum(output));
% [h p ci_random1(1,:)] = ttest(sum(output),mean(sum(output)),0.15);
% load output_random1_0
% sw_sum_random1(1) = mean(sum(output));
% [h p ci_random1(2,:)] = ttest(sum(output),mean(sum(output)),0.15);
% load output_random1_0-25
% sw_sum_random1(2) = mean(sum(output));
% [h p ci_random1(3,:)] = ttest(sum(output),mean(sum(output)),0.15);
% load output_random1_0-5
% sw_sum_random1(3) = mean(sum(output));
% [h p ci_random1(4,:)] = ttest(sum(output),mean(sum(output)),0.15);
% load output_random1_0-75
% sw_sum_random1(4) = mean(sum(output));
% [h p ci_random1(5,:)] = ttest(sum(output),mean(sum(output)),0.15);
% load output_random1_0-95
% sw_sum_random1(5) = mean(sum(output));
% [h p ci_random1(6,:)] = ttest(sum(output),mean(sum(output)),0.15);
% 
% load output_random2_ref
% sw_sum_random2_ref = mean(sum(output));
% [h p ci_random2(1,:)] = ttest(sum(output),mean(sum(output)),0.15);
% load output_random2_0
% sw_sum_random2(1) = mean(sum(output));
% [h p ci_random2(2,:)] = ttest(sum(output),mean(sum(output)),0.15);
% load output_random2_0-25
% sw_sum_random2(2) = mean(sum(output));
% [h p ci_random2(3,:)] = ttest(sum(output),mean(sum(output)),0.15);
% load output_random2_0-5
% sw_sum_random2(3) = mean(sum(output));
% [h p ci_random2(4,:)] = ttest(sum(output),mean(sum(output)),0.15);
% load output_random2_0-75
% sw_sum_random2(4) = mean(sum(output));
% [h p ci_random2(5,:)] = ttest(sum(output),mean(sum(output)),0.15);
% load output_random2_0-95
% sw_sum_random2(5) = mean(sum(output));
% [h p ci_random2(6,:)] = ttest(sum(output),mean(sum(output)),0.15);
% 
% load output_random3_ref
% sw_sum_random3_ref = mean(sum(output));
% [h p ci_random3(1,:)] = ttest(sum(output),mean(sum(output)),0.15);
% load output_random3_0
% sw_sum_random3(1) = mean(sum(output));
% [h p ci_random3(2,:)] = ttest(sum(output),mean(sum(output)),0.15);
% load output_random3_0-25
% sw_sum_random3(2) = mean(sum(output));
% [h p ci_random3(3,:)] = ttest(sum(output),mean(sum(output)),0.15);
% load output_random3_0-5
% sw_sum_random3(3) = mean(sum(output));
% [h p ci_random3(4,:)] = ttest(sum(output),mean(sum(output)),0.15);
% load output_random3_0-75
% sw_sum_random3(4) = mean(sum(output));
% [h p ci_random3(5,:)] = ttest(sum(output),mean(sum(output)),0.15);
% load output_random3_0-95
% sw_sum_random3(5) = mean(sum(output));
% [h p ci_random3(6,:)] = ttest(sum(output),mean(sum(output)),0.15);
% 
% disp 'testbed'
% a=[sw_sum_testbed_ref sw_sum_testbed]/3
% ci_testbed = ci_testbed/3
% disp 'random'
% b=[sw_sum_random_ref sw_sum_random]/2.3986
% ci_random = ci_random/2.3986
% disp 'random1'
% c=[sw_sum_random1_ref sw_sum_random1]/3.2215
% ci_random1 = ci_random1/3.2215
% disp 'random2'
% d=[sw_sum_random2_ref sw_sum_random2]/2.383
% ci_random2 = ci_random2/2.383
% disp 'random3'
% e=[sw_sum_random3_ref sw_sum_random3]/2.1345
% ci_random3 = ci_random3/2.1345
% %%RESULTADOS
% testbed
% a = 0.8123    0.5224    0.6746    0.7852    0.8219    0.8470
%     0.7774    0.8471
%     0.4983    0.5466
%     0.6428    0.7065
%     0.7477    0.8228
%     0.7845    0.8593
%     0.8138    0.8802
% random
% b = 0.8915    0.5206    0.8600    0.9368    0.8100    0.5426
%     0.8700    0.9131
%     0.4986    0.5426
%     0.8250    0.8951
%     0.9188    0.9549
%     0.7814    0.8386
%     0.5138    0.5715
% random1
% c = 0.5465    0.4396    0.5061    0.5588    0.5102    0.3705
%     0.5291    0.5640
%     0.4218    0.4574
%     0.4867    0.5255
%     0.5455    0.5720
%     0.4898    0.5306
%     0.3426    0.3985
% random2
% d = 0.8115    0.6381    0.7021    0.7958    0.7600    0.4094
%     0.7865    0.8365
%     0.6134    0.6629
%     0.6765    0.7278
%     0.7714    0.8202
%     0.7358    0.7841
%     0.3802    0.4386
% random3
% e = 0.7056    0.5945    0.6481    0.7068    0.6434    0.3361
%     0.6942    0.7170
%     0.5811    0.6079
%     0.6354    0.6609
%     0.6969    0.7167
%     0.6301    0.6566
%     0.3134    0.3588
% results = [
%     0.5851    0.7556    0.8794    0.9205    0.9486  0.9098;
%     0.5206    0.8600    0.9368    0.8100    0.5426  0.8915;
%     0.4396    0.5061    0.5588    0.5102    0.3705  0.5465;
%     0.6381    0.7021    0.7958    0.7600    0.4094  0.8115;
%     0.5945    0.6481    0.7068    0.6434    0.3361  0.7056];
%%
%Código para dibujar plots de Distribuciones Acumuladas separadas por
%número de agentes. Cada plot representa las curvas para un número de
%agentes determinado y los diferentes VOIDNESS.

% voidness = {'0', '0-25', '0-5', '0-75', '0-95'};
% experimenttypestr = 'random1';
% nexperiments = 100;
% colors = 'kmcrg';
% lines = {'-','--',':','-.',':'};
% %markers = {'.','+','^','s','p','h','o'};
% markers = {'','','','',''};
% nfigures = 7;
% clf
% for i=1:7
%     subplot(3,3,i);
%     for j=1:5
%         eval(['load output_' experimenttypestr '_' voidness{j}]);
%         output = sort(output','descend');
%         [f,x,flo,fup] = ecdf(reshape(output(1:i,:), 1,nexperiments*i));
%         stairs(x,f,strcat(lines{j},markers{j}),'color',colors(j),'LineWidth',2,'Markersize',3);
%         axis([0 1 0 1]);
%         hold on;
%     end
%     title(num2str(i))
%     grid off;
% end
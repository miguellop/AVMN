%%
clear MA; clear Ag; clear v;
d=[0 0;100 100];
nagents = 7;
MA = medagent();
for i=1:nagents 
    Ag{i} = agent(i, UF{i}, MA);
end
v = fcnview(MA, Ag);

MA.Nroundslimit = 50;
MA.sigmamin = 1;
MA.sigmamax = 200;
MA.p = 2;
MA.kr = 200;
MA.Type = 1;
clear sol;

nexperiments = 10;
%p = [0 1e-6 0.3333 1 3 20];
p = 1e-6;
voidness = {'ref', '0', '0-25', '0-5', '0-75', '0-95'};

experimenttypestr = 'incentive';

if strcmp(experimenttypestr, 'random')
    load UFRandom;
end


for z=1:length(p)
    output.x = [];
    output.y = [];
    if p(z) == 0
        MA.Type = 0;
    else
        MA.Type = 1;
    end
    MA.QGA = @(x) x.^p(z); %p-the exponent- defines how important is to consider many agents 
    for j=1:nexperiments
        clear Msh;
        v.Reset(MA);
        Msh = meshdsnp();
        s = MA.Negotiate(Msh);
        output.y = [output.y s.contractsEval(:,1)]
        output.x = [output.x ;s.agreement];
        disp(['Nexp: ' num2str(j)])
    end
%    eval(['save output_' experimenttypestr '_' voidness{z} ' output']); 
end

%%
%Global Results
    for i=1:nexperiments
        EvalAverage(i) = sol(i).EvalAverage;
        EvalProduct(i) = sol(i).EvalProduct;
        Nrounds(i) = sol(i).Nrounds;
    end
    sel = MaxDistance <= m.SolTolerance;
    fr = 100-sum(sel)/nexperiments*100;
    av = mean(EvalAverage(sel));
    pr = mean(EvalProduct(sel));
    avd = mean(MaxDistance(sel));
    nr = mean(Nrounds(sel));
    ds(z,:) = dataset(EvalAverage, EvalProduct, Nrounds, MaxDistance, fr, av, pr, avd, nr);
    %end

%%
ds = dataset({rand(length(upfactors),4, nexperiments),'EvalAverage','EvalProduct','Nrounds','MaxDistance'},{zeros(9,5),'FailureRate100','avgUtility','prodUtility', 'avgDistance', 'avgNrounds'},'ObsNames',{'UpStep0','UpStep0.25','UpStep0.5','UpStep0.75','UpStep1','UpStep1.25','UpStep1.5','UpStep1.75','UpStep2'});
%%
boxplot([ds{'UpStep0','EvalAverage'}', ds{'UpStep0.25','EvalAverage'}', ds{'UpStep0.5','EvalAverage'}', ds{'UpStep0.75','EvalAverage'}', ds{'UpStep1','EvalAverage'}',...
    ds{'UpStep1.25','EvalAverage'}', ds{'UpStep1.5','EvalAverage'}', ds{'UpStep1.75','EvalAverage'}']);

%% 
load output_1e-06
output = cumsum(sort(output,'descend'))';
output=output./repmat(1:10,100,1);
boxplot(output);
%%
colors = 'kmcrgbk';
lines = {'-','--',':','-.',':','--','-'};
%markers = {'.','+','^','s','p','h','o'};
markers = {'','','','','','',''};
nfigures = 6;
clf
for i=1:nfigures
    subplot(2,3,i);
    %eval(['load output_testbed_' voidness{i}]);
    outputaux = sort(output,'descend');
    for j=1:nagents
        [f,x,flo,fup] = ecdf(reshape(outputaux(1:j,:), 1,nexperiments*j));
        %[f,x,flo,fup] = ecdf(mean(output(1:j,:)));
 %       stairs(x,flo,[colors(j) ':'],'LineWidth',1); stairs(x,fup,[colors(j) ':'],'LineWidth',1);
%        stairs(x,f,lines{j},'color',colors(j),'LineWidth',0.5);
        stairs(x,f,strcat(lines{j},markers{j}),'color','k','LineWidth',0.75,'Markersize',3);
        axis([0 1 0 1]);
        hold on;
    end
    %output = cumsum(sort(output,'descend'))';
    %output1 = median(output');
    %boxplot(output);
    title(voidness{i})
    %axis([0 1.1 0 1.1])
    grid off;
end
%plot([output1',output2',output3',output4'])
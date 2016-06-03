clf
hold on
y=0:0.01:1;
delta = 2;
alfa = 400:-1*delta:-400;
alfa = 2;
beta = 1.1;

for i=1:length(alfa)
    Q=getquantifier(beta,alfa(i));
    plot(y,Q(y));
    w(i,:)=getowaweights(Q,10);
end
hold off
w



X = 0:.01:1;
y1 = (betapdf(X,1,1));
y2 = (betapdf(X,5,5)-1.75);
y3 = (betapdf(X,6,2)-1);
y4 = (betapdf(X,2,6)-1);
%y1 = y1+y3+y4;

figure
plot(X,y1,'Color','r','LineWidth',2)
hold on
plot(X,y2,'LineStyle','-.','Color','b','LineWidth',2)
plot(X,y3,'LineStyle',':','Color','g','LineWidth',2)
plot(X,y4,'LineStyle',':','Color','c','LineWidth',2)
legend({'a = b = 1','a = b = 5','a = 6 b = 2','a = 2 b = 6'},'Location','NorthEast');
hold off

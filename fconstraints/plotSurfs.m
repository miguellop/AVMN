function plotSurfs(d,fB,uB,fS,uS)
%%PLOTSURFS
%   fB uB fS uS


[xa.x xa.y]=meshgrid(linspace(d(1,1), d(2,1),10));

if nargin==2
    colormap('default')
    ezmeshc(@(x,y) fB([x y]), reshape(d, 1, numel(d)));
    return;
end

if nargin==3
    subplot(2,1,1); 
    ezsurf(@(x,y) fB([x y]), reshape(d, 1, numel(d)));
    subplot(2,1,2, 'replace'); hold on;
    h = ezcontour(@(x,y) fB([x y]), reshape(d, 1, numel(d))); set(h, 'LineStyle', ':');
    contour(xa.x, xa.y, fB(xa),[uB uB],'color','red','LineWidth',1); set(h, 'LineStyle', ':');
    grid on;
    hold off;
    return;
end

subplot(3,1,1);
ezsurf(@(x,y) fB([x y]), reshape(d, 1, numel(d)));
subplot(3,1,2); 
ezsurf(@(x,y) fS([x y]), reshape(d, 1, numel(d)));
subplot(3,1,3, 'replace');  hold on;
h = ezcontour(@(x,y) fB([x y]), reshape(d, 1, numel(d)),40); set(h, 'LineStyle', ':');
h = ezcontour(@(x,y) fS([x y]), reshape(d, 1, numel(d))); set(h, 'LineStyle', ':');
contour(xa.x,xa.y,fB(xa),[uB uB],'color','red','LineWidth',1);drawnow;
contour(xa.x,xa.y,fS(xa),[uS uS],'color','blue','LineWidth',1); drawnow;
grid on;
hold off;
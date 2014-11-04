clf
axis square
axis([0 100 0 100])
grid
box
hold on
nagents = 7;
centers = [15 50; 25 50; 15 40; 25 40; 55 45; 70 45; 80 80];
radios = 18*ones(1,nagents);

for i=1:nagents
    ezplot(@(x,y) mycircle(x,y, centers(i,:), radios(i)), [0 100 0 100]);
    drawnow;
end


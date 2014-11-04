%Experimento:
%Distancias de correlación 0.5 para números de picos vs radios 

nr=0;
peaks = 2:8:512;
rad = 2:4:64;
vd = linspace(0.1, 50, 200);
dc = zeros(length(peaks), length(rad));

for npeaks=peaks
    nc=1;
    nr=nr+1;
    nr
    for r=rad
        fB=fbell(npeaks,2,r,1);
        dc(nr,nc) = rugfactor(fB, 2, [0 0;100 100], vd, 500);
        nc=nc+1;
    end
end

[x,y]=meshgrid(peaks, rad);
tam=numel(x);
scatter3(reshape(x,tam,1),reshape(y,tam, 1),reshape(dc',tam,1));

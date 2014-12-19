function optimo=findmaxutil(C,D,s)

i=0;
j=0;

[X,Y]=meshgrid(0:s:D);

[m,n]=size(X);
Z=zeros(m,n);

for i=1:m
    for j=1:m
       
       Z(i,j)=utility([X(i,j),Y(i,j)],C);
    end
end

optimo=max(max(Z));
end
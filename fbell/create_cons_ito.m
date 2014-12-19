function C = create_cons_ito(n,m,D,L,alpha,beta)
%Generaci?n de una restricci?n m-aria sobre n atributos
%en un dominio desde 0 hasta D, con un anch m?ximo l


%generamos una restricci?n que cubra todo el dominio


C.min=zeros(1,n);
C.max=C.min+D;

%genero una permutacion aleatoria de issues
r=randperm(n);

%n tiene que ser mayor que m

if m>n
   m=n;
end

%genero m aristas uniformes
%l=unifrnd(1,L,1,m);
%enteros
%l=ceil(unifrnd(0.5,L-0.5,1,m));
var= L(2)-L(1)+1;
l=unidrnd(var,1,m)+L(1)-1;

% Calculamos la "movilidad" del cubo (lo que falta para llegar a los
% bordes)

mobility=ones(1,m)*D-l;

%Generamos un movimiento aleatorio uniformemente distribuido en cada
%dimension

%movement=unifrnd(0,mobility);
%enteros
%movement=ceil(unifrnd(0.5,mobility+0.5));
movement=unidrnd(mobility);

for i=1:m
   C.min(r(i))=movement(i);
   C.max(r(i))=movement(i)+l(i);
end

%Asignamos una utilidad proporcional al numero de issues
%C.u=ceil(unifrnd(0.5,100*m+0.5));
C.u=unidrnd(100*m);

%Calculamos el volumen de la restriccion
C.v=vol_cons(C);

%Calculamos el factor de calidad q de la restriccion
C.q=C.v.^alpha*C.u.^beta;

%Cada restriccion es un bid unario
C.n=1;

%A priori, cada restriccion es compatible con el resto
C.incompatibles=[];

end
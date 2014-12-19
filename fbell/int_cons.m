
function I = int_cons(C,alpha, beta)
%Calcula la intersecci?n de las restricciones contenidas en C


%Creo una matriz con los m?ximos de cada restricci?n



N = length(C); %numero de restricciones
n = length(C(1).min); % numero de issues

I = C(1); %por temas estructurales

%caso particular:solo una constraint
if N==1
    I=C;
    I.n=1;
    return;
end


mMax=zeros(N,n);
mMin=zeros(N,n);
u=0;
%I
I.incompatibles=[];
for i =1:length(C)

    mMax (i,:) = C(i).max;
    mMin (i,:) = C(i).min;
    u=u+C(i).u;
    I.incompatibles=[I.incompatibles C(i).incompatibles];

end

% La intersecci?n estar? limitada por los m?ximos de los m?nimos y los
% m?nimos de los m?ximos

I.min=max(mMin);
I.max=min(mMax);

% La intersecci?n tendra como utilidad la suma de las utilidades

% Comprobamos que la intersecci?n no es vacia
if not(isempty(find(I.min>I.max, 1)))
    I=[];
else
    I.u=u;
    I.v=vol_cons(I);
    I.q=I.u.^alpha*I.v.^beta;
    I.n=N;
end


end

 
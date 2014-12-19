function [C,qTotal] = genconstraints(n,D,L,alpha,beta,nc)
%Generaci?n de 25 restricciones para el experimento de Ito

k=1;
qTotal=0;
    %Determino aleatoriamente el numero de issues de cada restriccion
    %cIssues=unidrnd(n,1,50);
for i=1:(nc*n) % En el paper de Ito son 5*n restricciones
    cIssues=mod(i,n)+1; % Quitar comentario para n restricciones unarias,
    %n binarias n terciarias ... n narias (es decir, lo del paper de Ito)
    %cIssues = unidrnd(n); % número de issues aleatorio para cada
    %restricción
    %Dejo las restricciones ordenadas por Q descendente
    
    c=create_cons_ito(n,cIssues,D,L,alpha,beta);
    c.incompatibles=[];
    if i==1 %trivial
        C(1)=c;
        qTotal=C(1).q;
    else
       q=c.q;
       qTotal=qTotal+q;
       insertada=0;
       for j=1:(i-1)
           if q>C(j).q
              C=[C(1:(j-1)) c C(j:(i-1))]; 
              insertada=1;
              break;
           end
       end
       %Si no ha sido insertada ya, insertar al final
       if insertada==0
         C=[C c];
       end
    end
%     C(k)=create_cons_ito(n,1,D,L);k=k+1;
%     %C(k-1)
%     C(k)=create_cons_ito(n,2,D,L);k=k+1;
%     %C(k-1)
%     if n>2
%        C(k)=create_cons_ito(n,3,D,L);k=k+1;
%        %C(k-1)
%     end
%     if n>3
%       C(k)=create_cons_ito(n,4,D,L);k=k+1;
%       %C(k-1)
%     end
%     if n>4
%        C(k)=create_cons_ito(n,5,D,L);k=k+1;
%        %C(k-1)
%     end
%     if n>5
%        C(k)=create_cons_ito(n,6,D,L);k=k+1;
%        %C(k-1)
%     end
%     if n>6
%        C(k)=create_cons_ito(n,7,D,L);k=k+1;
%        %C(k-1)
%     end
%     if n>7
%        C(k)=create_cons_ito(n,8,D,L);k=k+1;
%        %C(k-1)
%     end
%     if n>8
%        C(k)=create_cons_ito(n,9,D,L);k=k+1;
%        %C(k-1)
%     end
%     if n>9
%        C(k)=create_cons_ito(n,10,D,L);k=k+1;
%        %C(k-1)
%     end
end

nCons=length(C)


for i=1:nCons
       for j=(i+1):nCons
           CX=[C(i);C(j)];
           if isempty(int_cons(CX,alpha,beta))
              C(i).incompatibles=[C(i).incompatibles j];
              C(j).incompatibles=[C(j).incompatibles i];
           end
       end
end

%if n==2
%    figure;plot_utility(C,D,D./100);
%end


end
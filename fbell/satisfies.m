function b = satisfies(x,c)
%Comprueba si el contrato x satisface la restricci?n c

n = length (x);
if (n~=length(c.min))
    disp('Error: contract and constraint must have the same length');
    b= false;
    return;
end

b=true;

%Comprobamos cada issue hasta que uno falle
for i=1:n
   if (x(i)<c.min(i)) || (x(i)>c.max(i))
       b=false;
       return;
   end
end

end
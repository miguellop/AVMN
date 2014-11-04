function u = fconstraints(x,C)
%Calcula la utilidad del contrato X en funci?n del conjunto de
%restricciones C

u=0;

for i=1:length(C)
   if satisfies(x,C(i));
      %disp('satisface');
      %i
      u=u+C(i).u;
   end 
end


end
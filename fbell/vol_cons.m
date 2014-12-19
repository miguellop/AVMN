
function v = vol_cons(c)
%Calcula el volumen dela restriccion c

if sum(c.max<c.min)>0
    v=0;
else
    v =  prod(c.max-c.min+1);
end


end

 
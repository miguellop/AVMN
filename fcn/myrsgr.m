% Extensión de la función RSGR. Una vez generadas y almacenadas las
% restricciones, se realiza un remapeo en formato matricial. Esta
% extensión se ha realizado debido a la lenta ejecución de FRSGR con el
% formato r{1:orden}(1:2,1:nvar,nres). El mapeo genera una única matriz
% tridimensional M(1:sum(nres(1:orden)), 1:3, 1:nvars). La tercera
% columna determina la variable a restringir. La segunda columna
% determina (1) limInf (2) limSup (3) Utilidad. La primera columna
% determina cada una de las restricciones. Todas las restricciones
% n-arias se convierten por tanto en restricciones de orden único y
% máximo equivalente a nvars. Para las restricciones de orden inferior
% a nvars, y aquellas variables no restringidas, se fija un intervalo
% [-Inf Inf 0] (el valor 0 es de utilidad).

function r = myrsgr(delta,domain,nvars,nres)

n = 1;
for i=1:nvars
    nr = nres(i); %número de restricciones de orden i
    for j=1:nr
        for k=1:nvars-i
            r(n,:,k) = [-inf +inf 0];
        end
        for k=nvars-i+1:nvars
            val = randi(domain);
            r(n,:,k) = [val min(val+delta,domain(2)) rand()*10];
        end
        r(n,:,randperm(k)) = r(n,:,randperm(k));      
        n = n+1;
    end
end   
 
        

    
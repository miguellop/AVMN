function sgr = rsgr(sg, nres)
    %RSGR Generador aleatorio de restricciones a partir
    %de un SISTEMA GENERADOR SG.
    %
    %  R = RSGR(SG, NRES) Crea un cell-array 1xNVARS
    %  de restricciones. Cada celda K contiene una matriz tridimensional
    %  con las restricciones K-arias correspondientes. p.ej. R{3}(:,:,1)=[2
    %  4 1;3 5 6] hace referencia a la primera restricción ternaria, donde
    %  las variables relacionadas son la 2, 4 y 1, para los intervalos
    %  respectivos 3, 5 y 6. El tercer índice de la matriz tridimensional
    %  es símplemente por tanto un contador de restricciones.
    %   El parámetro SG es el Sistema Generador de restricciones, que
    %   tendrá dimensión 1xNVARS. El segundo parámetro es NRES, que
    %   corresponde a un vector 1xNVARS que indica el número de
    %   restricciones a generar de cada orden. p.ej. [0 2 0 2] indica que
    %   se deben generar 2 restricciones binarias, y 2 cuaternarias. El
    %   primer valor del array es siempre 0, y hace referencia a las
    %   restricciones unarias, aunque dicho valor no se utiliza debido a
    %   que las restricciones unarias son directamente todos los intervalos
    %   del sistema generador unario.
    %
    %   La función retorna una estructura con el cell-array 1xNVARS de
    %   restricciones y el Sistema Generador que se pasó como parámetro.
    %   Se incluyen además, el número de restricciones de cada orden, y el
    %   número de variables.
    
    nvar = length(nres);
    
    %Generación de restricciones unarias
    k=0;
    
    for i=1:nvar
        nint = size(sg{1}{i}(:,:),1);
        nres(1) = nres(1)+nint;
        for j=1:nint
            k = k+1;
            r{1}(:,:,k) = [i;j];
        end
    end
    %Generación de restricciones binarias, ternarias, ...
    for orden=2:nvar
        if nres(orden) == 0
            r{orden} = [];
        else
            for i=1:nvar
                nint(i) = size(sg{orden}{i}(:,:),1); %Se obtiene el número de intervalos de cada variable
            end
            i=1;
            while i<=nres(orden)
                vars = randperm(nvar);
                vars = sort(vars(1:orden));
                for j=1:orden
                    p = randperm(nint(vars(j)));
                    int(j) = p(1);
                end
                r{orden}(:,:,i) = [vars;int];
                %Comprobación de no repetición
                if  i>1
                    for j=1:i-1
                        c = all((r{orden}(:,:,j) - r{orden}(:,:,i))==0);
                        if all(c)
                            i= i-1;
                            break;
                        end
                    end
                end
                i=i+1;
            end
        end
    end
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
    vNres = nres;
    vNres(1) = size(r{1}, 3);
    numres = sum(vNres(1:nvar));
    R = repmat([-inf inf 0], [numres 1 nvar]);
    cRes = 1;
    for iOrd=1:nvar
        for iR=1:vNres(iOrd)
            iVar = r{iOrd}(1, 1:iOrd, iR);
            iInt = r{iOrd}(2, 1:iOrd, iR);
            for k=1:iOrd
                R(cRes, :, iVar(k)) = sg{iOrd}{iVar(k)}(iInt(k), :);
            end
            cRes = cRes + 1;
        end
    end
        
    sgr.R = R;
    sgr.nv = nvar;
    sgr.nr = numres;
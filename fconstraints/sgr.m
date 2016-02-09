function sg = sgr(nvars, ninterv, d, ftransf, ftoptions, futils, fuoptions)
    %SGR Crea el conjunto completo de
    %intervalos generadores de restricciones.
    %   SG = SGR(NVARS, NINTERV, D,
    %   FTRANSF, FUTILS, FUTILSOPTIONS) retorna un cell-array de dimensión
    %   1xNVARS, con los NVARS sistemas de generación (unario hasta
    %   N-ario) donde N=NVARS.
    %   NINTERV es un array NVARSxNVARS que define al número de intervalos
    %   para cada variable. Cada fila corresponde con un sistema generador
    %   n-ario, y cada columna con una variable.
    %   D es una matriz 2xNVARS con los dominios de cada variable.
    %   FTRANSF es una matriz cell-array de NVARSxNVARS. Cada fila
    %   corresponde con un sistema generador n-ario, y cada columna con una
    %   variable.
    %   FUTILS es equivalente a FTRANSF pero haciendo referencia a las
    %   funciones de utilidad.
    %   FTOPTIONS y FUOPTIONS son matrices cell-array NVARSxNVARS. Cada fila
    %   corresponde con las opciones para un sistema generador, y cada
    %   columna con una variable. Si no se utilizan opciones se introduce
    %   [].
    %
    %   La función retorna un cell-array 1xNVARS SG, donde cada elemento es
    %   a su vez un cell-array 1xNVARS que contiene las matrices de
    %   intervalos y utilidades correspondientes a las restricciones
    %   n-arias. p.ej. SG{1}{4} hace referencia a las restricciones
    %   unarias, variable 4. Dicha referencia es una matriz NINTERVx3 con los
    %   correspondientes intervalos y sus utilidades.
    
    for i=1:nvars
        for j=1:nvars
            ft{j} = ftransf{i,j};
            ftopt{j} = ftoptions{i,j};
            fu{j} = futils{i,j};
            fuopt{j} = fuoptions{i,j};
        end
        sg{i} = isgr(nvars, ninterv(i,:), d, ft, ftopt, fu, fuopt);
    end
end
    function si = isgr(nvars, ninterv, d, ftransf, ftoptions, futils, fuoptions)
    %ISGR Generación de intervalos consecutivos para NVARS
    %variables y NINTERV intervalos, aplicando funciones de transformación
    %FTRANSF para cada variable de forma independiente. FUTILS define las
    %funciones generadoras de utilidad para cada variable. FUTILSOPTIONS
    %permite introducir mediante un cell-array unidimensional de strings, un conjunto de opciones que
    %utilizará la función correspondiente.
    %
    %   SI = ISGR(NVARS, NINTERV, D, FTRANSF, FUTILS)
    %   retorna un cell-array 1xNVARS que contiene
    %   matrices bidimensionales de NINTERV x 3  elementos. 
    %   NINTERV es un vector 1xNVARS que define el número de intervalos por
    %   variable.
    %   D es una matriz 2xNVARS que define
    %   los dominios de cada variable. FTRANSF es un cell-array 1xNVARS de handles a funciones de 
    %   transformación de intervalos. Cada una de las funciones de
    %   transformación debe operar sobre un vector de entrada y unas opciones (si no hay opciones []), y retornar
    %   un vector transformado con las mismas dimensiones. FUTILS de forma
    %   similar es un cell-array 1xNVARS de handles a funciones que reciben
    %   como parámetro las restricciones y unas opciones (si no hay opciones []), y retornan un vector de longitud ninterv
    %   con los valores de utilidad para cada intervalo. FT y FUOPTIONS
    %   permiten introducir las opciones extra a las funciones de
    %   transformación y utilidad. Si no se utilizan opciones se asigna en
    %   la llamada []. Dichas opciones se introducen en cell-arrays de dimensión
    %   1xNVARS en forma de strings. p.ej. {'mu=2; sigma=1;','mu=1; sigma=3;'}
    %   
    %   La función retorna SI, que es un cell-array 1xNVARS que almacena
    %   matrices bidimensionales
    %   NINTERVx3 elementos.p.ej. SI{3}(1,1) hace referencia al
    %   primer intervalo, límite inferior, y tercera variable. SI{3}(1,2)
    %   hace referencia a la primera restricción, límite superior, y
    %   tercera variable. SI{3}(1,3) hace referencia al primer
    %   intervalo, utilidad, y tercera variable.
    
        for i=1:nvars
            int = linspace(d(1, i), d(2, i), ninterv(i)+1);
            int = ftransf{i} (int, ftoptions{i})/(ftransf{i}(int(ninterv(i)+1), ftoptions{i})-ftransf{i}(int(1), ftoptions{i}));
            int = (int-int(1))*(d(2, i)-d(1, i))+d(1, i); 
            aux = int(2:ninterv(i))-eps;
            aux(ninterv(i)) = int(ninterv(i)+1);
            int(ninterv(i)) = aux(ninterv(i)-1)+eps;
            int(ninterv(i)+1) = [];
            si{i}(:,:) = [int', aux', zeros(ninterv(i), 1)];
            si{i}(:, 3) = futils{i} (si{i}, fuoptions{i});
        end
    end

    


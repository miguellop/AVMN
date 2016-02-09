    function v = ft1(int, options)
    %FT1 Transformador de intervalos exponencial/lineal.
    %   U = FUNCIONTRANSF1(INT, OPTIONS) retorna un vector
    %   V de tamaño 1xSIZE(INT). INT es un vector de intervalos.

        %v = exp(int);%Exponencial
        v=(9-int).*exp(int.*0.1); %Lineal
        v=int;
        
    function v = ft1(int, options)
    %FT1 Transformador de intervalos exponencial/lineal.
    %   U = FUNCIONTRANSF1(INT, OPTIONS) retorna un vector
    %   V de tamaño 1xSIZE(INT). INT es un vector de intervalos.

        %v = exp(int);%Exponencial
        %v=(9-int).*exp(int.*0.1); %Lineal
        
        %Distribución aleatoria de intervalos
        
        if length(int)==1 || length(int)==2
            v = int;
            return;
        end
        l = length(int)-2;
        b = max(int);
        a = min(int);
        
        v = [a sort((b-a)*unifrnd(0,1,1,l)+a) b];
        
        
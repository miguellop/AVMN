%% Generación de Funciones de Utilidad basadas en Restricciones
% En este texto se describen los aspectos fundamentales del proceso de
% generación de funciones de utilidad basadas en restricciones.
%% Definición de Restricción
% Una restricción sobre una variable o atributo se define como un 
% intervalo de valores que puede tomar dicha variable y una utilidad
% asociada. p.ej.
%
%   r1 = [1 10]; u1 = 1;
%   r2 = [2.5 10.7]; u2 = 0.5;
%%
% Podemos distinguir entre restricciones de dominio discreto o dominio
% real. En el primer caso un intervalo está acotado por valores enteros, y
% los valores que forman parte de la restricción son también valores
% enteros comprendidos en el intervalo. Para el caso de dominio real,
% cualquier valor real comprendido en el intervalo pertenece a la
% restricción. De aquí en adelante se describen únicamente restricciones
% de dominio real.
%
% El elemento básico de una restricción por tanto es el intervalo o rango.
% Utilizaremos indistintamente los términos restricción, intervalo o rango.
% En el caso de Matlab, la forma idónea de definir un intervalo es utilizar
% un vector con dos elementos, que indiquen respectivamente el límite
% inferior y el superior.
%
% Para una variable x1->Dom[1 100], podemos tener una o más restricciones sobre su
% dominio. p.ej.
%
%   r11 = [1 10]; u11 = 1; 
%   r12 = [11 20]; u12 = 0.5;
%
%   ...
%   r1n
%
% En un caso más general, tendremos varias variables o atributos con sus
% correspondientes dominios. En este caso podemos tener restricciones de
% diferente orden: unarias, binarias, ... dependiendo de relaciones lógicas
% AND que se puedan establecer entre diferentes restricciones individuales.
% p.ej. (los ejemplos no son código literalmente ejecutable en Matlab, son
% pseudocódigo)
%   
%   r121 = {x1==[1 5] && x2==[8 10]}
%   r122 = {x1==[1 5] && x2==[11 20]}
%   r123 = {x1==[2 5] && x2==[1 3]}
%   ...
%   r12n
%
% En el ejemplo anterior, se han definido tres restricciones binarias, que
% relacionan los atributos 1 y 2. Cada restricción rXYZ se satisface si se
% cumplen ambas restricciones individuales sobres x1 y x2.
% Para un número N de variables, se tendrán como máximo restricciones
% M-arias, donde M=N.
%% Parámetros de una Función de Utilidad basada en Restricciones
% Una función de utilidad vendrá determinada por el NÚMERO DE ATRIBUTOS, y
% el NÚMERO DE RESTRICCIONES de diferentes órdenes. Esto significa que la
% función generadora de Funciones de Utilidad debe permitir la entrada del
% número de atributos y sus correspondientes dominios, y el número de
% restricciones de diferente orden que se quieren generar. De esta manera,
% lo ideal es fijar una estructura de tamaño fijo, dependiente del número
% de atributos, que determine el número de restricciones de cada orden a
% generar. 
%
%
%% Restricciones Unarias
% Una restricción unaria relaciona una sóla variable. Para una función de
% utilidad, habrá que definir en todos los casos restricciones que cubran
% por completo el dominio de cada variable. Además, dichas restricciones no
%   deben solaparse. p.ej.
%   
%   Dado x1->Dom[1 100] se podrían definir las restricciones r11=[1 50]
%   r12=[51 100]
%
% En el ejemplo anterior por simplicidad se han supuesto intervalos
% discretos, pero para el caso de intervalos reales habrá que aplicar otro
% método de generación de rangos. En cualquier caso, toda función de
% utilidad tendrá que definir obligatoriamente restricciones unarias que
% cubran todas las variables. De esta manera, y para cada variable a
% restringir con restricciones unarias, se deben fijar el número de
% restricciones, y la distribución de rangos de cada una de ellas.
%
% En principio debe ser posible particularizar el número de restricciones
% unarias por variable, y la distribución de restricciones por variable.
% Para formar las restricciones se divide el dominio de la variable en
% tantos intervalos N como restricciones N haya que generar. Esto significa
% generar un vector de N+1 elementos equiespaciados. Una vez generado el
% vector se aplica una transformación para generar otro tipo de intervalos
% no equiespaciados si se considera necesario. p.ej. para una
% transformación exp(x/100)
    n = 10; d = [1 100];
    interv = linspace(d(1), d(2), n+1)
    intervt = exp(interv/100)/(exp(interv(n+1)/100)-exp(interv(1)/100));% Transformación y normalización a intervalo de distancia 1
    intervt = (intervt-intervt(1))*(d(2)-d(1))+d(1)
    plot(interv, intervt);
%% 
% Una vez generado el set de intervalos es necesario generar el set de
% restricciones unarias. Para ello se aplica la siguiente transformación:
    aux = intervt(2:n)-eps;
    aux(n) = intervt(n+1);
    intervt(n) = aux(n-1)+eps;
    intervt(n+1) = [];
    res = [intervt',aux']

    %% Restricciones M-arias
    % Una restricción M-aria relaciona M atributos mediante M intervalos
    % que corresponden cada uno a una variable diferente. Como ya sabemos,
    % M tomará como máximo el valor N. De esta manera, para generar una
    % restricción M-aria, se tendrá que disponer de una generación de
    % intervalos para cada una de las variables del problema. Dichas
    % generaciones podrán ser independientes de las generaciones de otras
    % restricciones K-arias. Lo ideal por tanto es crear un sistema de
    % intervalos (para todas las variables) para cada una de las
    % restricciones K-arias. p.ej. para tres variables
    %
    %   1-aria...
    %   [1 3; 4 6; 7 10][1 2; 3 8; 9 10][1 3; 4 5; 6 10]
    %   2-aria...
    %   [1 2; 3 6; 7 10][1 7; 8 9; 10 10][1 2; 3 4; 5 10]
    %   3-aria...
    %   [1 4; 5 6; 7 10][1 6; 7 9; 9 10][1 2; 3 4; 5 10]
    %   
    % Como podemos comprobar, independientemente del orden de las
    % restricciones, la fuente generadora de las mismas es un set de
    %   intervalos para cada una de las tres variables. Sin embargo, la
    %   generacion de restricciones a partir de dichas fuentes varía en
    %   función del orden. Para el caso de restricciones unarias, por
    %   definición la función de utilidad debe considerar por defecto todos
    %   los intervalos como restricciones de facto. De esta manera, todos
    %   los intervalos definidos para todas las variables sonrestricciones
    %   operativas. En cambio, para el resto de fuentes de restricciones, se debe
    %   indicar de forma explícita qué restricciones son operativas. En
    %   definitiva, la función de utilidad debe conocer el número de
    %   restricciones k-arias que queremos definir, pudiéndo ser 0, 1,..., hasta
    %   el número máximo de combinaciones posibles. Para el caso por
    %   ejemplo de restricciones 3-arias, el número  máximo de
    %   combinaciones será 3^3 (M^N). Para el caso de restricciones 2-arias
    %   podremos definir 3*3^3, resultado de combinar restricciones sobre
    %   la variable 1 y 2, 1 y 3, 2 y 3, y tener en cuenta que cada
    %   relación está limitada a 3^3 combinaciones de intervalos. En
    %   principio el generador de funciones de utilidad debe permitir
    %   generar un número de intervalos independiente para cada sistema
    %   generador K-ario. Sin embargo, el número de intervalos será el
    %   mismo para todas las variables dentro de un mismo sistema K-ario.
    %
    % Para un problema de 3 atributos, 1-aria con 10 intervalos; con funciones de
    % transformación independientes para cada k-aria y variable. p.ej.
n = 10; d1 = [1 100];d2 = [1 100];d3 = [1 100];
interv = linspace(d1(1), d1(2), n+1)
intervt1 = exp(interv/100)/(exp(interv(n+1)/100)-exp(interv(1)/100));
intervt1 = (intervt1-intervt1(1))*(d1(2)-d1(1))+d1(1);
interv = linspace(d2(1), d2(2), n+1);
intervt2 = exp(interv/80)/(exp(interv(n+1)/80)-exp(interv(1)/80));
intervt2 = (intervt2-intervt2(1))*(d2(2)-d2(1))+d2(1);
interv = linspace(d3(1), d3(2), n+1);
intervt3 = exp(interv/70)/(exp(interv(n+1)/70)-exp(interv(1)/70));
intervt3 = (intervt3-intervt3(1))*(d3(2)-d3(1))+d3(1);

aux = intervt1(2:n)-eps;
aux(n) = intervt1(n+1);
intervt1(n) = aux(n-1)+eps;
intervt1(n+1) = [];
res1 = [intervt',aux'];
aux = intervt2(2:n)-eps;
aux(n) = intervt2(n+1);
intervt2(n) = aux(n-1)+eps;
intervt2(n+1) = [];
res2 = [intervt2',aux'];
aux = intervt3(2:n)-eps;
aux(n) = intervt3(n+1);
intervt3(n) = aux(n-1)+eps;
intervt3(n+1) = [];
res3 = [intervt3',aux'];

S{1}(:,:,1) = res1;
S{1}(:,:,2) = res2;
S{1}(:,:,3) = res3;
S{1}(:,:,1)
S{1}(:,:,2)
S{1}(:,:,3)

%% 
% Para el caso de 2-aria y 3-aria el procedimiento es exactamente el mismo.
% Los dos índices son consistentes para restricciones K-arias, de
% manera que los intervalos 3-arios de la variable 2 serían S{3}(:,:,2).
% Es importante aclarar que podría pensarse en una configuración de sistema
% K-ario más compleja, en la que para cada generación de una restricción
% K-aria, se renovasen los intervalos generadores de cada variable. Sin
% embargo, creo que este exceso en la complejidad presenta una estructura
% de preferencias poco realista. En principio parece suficiente esta
% aproximación para conseguir estructuras de preferencias suficientemente
% complejas.
%% Elicitación de Restricciones
% Hemos visto en el apartado anterior cómo podemos crear el sistema
% generador de restricciones K-arias, mediante la generación de intervalos
% desacoplados para cada variable y para cada orden K. Sólo se mantiene
% constante para cada sistema generador K-ario el número de intervalos por
% variable. Dado un sistema generador K-ario donde K>1, se podrán definir
% restricciones de orden K mediante un vector con el siguiente formato:
% [ind1 ind2 ... indK rang1 rang2 ... rangN], donde K
% indica el orden de la restricción, indM hace referencia a la variable M
% implicada, y rangM hace referencia al rango M dentro de la variable indM
% correspodiente. p.ej. para 4 variables, 10 rangos por variable y una restricción de orden 2:
%
%   [2 4 ; 5 10] representa una restricción 2-aria, que relaciona las
%   variables 2 y 4, donde se toma el intervalo 5 de la variable 2 y el
%   intervalo 10 de la variable 4. Para comprobar que en la generación de
%   restricciones K-arias no hay repetición, no hay más que comprobar que
%   la resta de vectores  previos es distinta de 0 para al menos un elemento.
%
% Para generar aleatoriamente restricciones K-arias donde K>1 y K<=nvars se
% genera un vector [1 2 3 ... nvars], se permuta...[3 2 5 8 ...], y se toman
% los K primeros elementos. Estos K primeros elementos serán los índices de
% las variables elegidas. Para K=3, el vector sería [3 2 5]. Falta la
% selección de intervalo o rango para cada variable. En este caso generamos
% 3 veces un número aleatorio entero entre 1 y N, donde N es el número 
% de intervalos en el que partimos cada variable, p.ej. [2 4 1]. Finalmente
% la restricción quedaría como: [3 2 5; 2 4 1].
% Para indexar el sistema generador en este ejemplo se tendría que hacer:
% S{3}(2,:,3); S{3}(4,:,2); S{3}(1,:,5). Con estas sentencias extraemos las restricciones 3-arias que
% que relacionan las variables 3, 2 y 5 con los intervalos respectivos 2 4
% y 1.
% Siguiendo la misma metodología de almacenaje de sistemas generadores
% K-arios, las restricciones se almacenan en cell-arrays de la siguiente
% forma: R{3}(:,:,1)=[3 2 5; 2 4 1]; R{3}(:,:,2)=[1 7 5; 3 1 2];... donde
% el primer índice indica el orden de las restricciones que almacena, y el
% último subíndice indica el número de restricción 3-aria.
%
% Mientras que para sistemas generadores la estructura es fija, en el caso
% de la indexación de restricciones el número de restricciones varía a
% excepción de las unarias. Por ello es necesario introducir en el sistema
% un vector que indice cuántas restricciones hay de cada orden K. p.ej.
% [0 2 10 0 1] indica la existencia de 2 restricciones binarias, 10
% ternarias, 0 cuaternarias y 1 quinaria. El valor 0 inicial hace
% referencia a restricciones unarias, pero no es utilizado. Se coloca por
% consistencia.
%% UTILIDAD
% La utilidad de una restricción viene definida por un número real. Dichas
% utilidades se van a definir en base al conjunto de restricciones de una
% variable, de forma independiente para cada variable/orden. Esto significa
% que para un problema de N variables, tendremos NxN conjuntos de
% restricciones por variable: N para unarias, N para binarias, ..., N para
% N-arias. Dado un determinado orden y una determinada variable se tiene
% que conocer el número de intervalos definidos, y por tanto definir otros
% tantos valores de utilidad. Para ello vamos a utilizar una función de
% distribución gaussiana de media mu y desviación sigma, dependiendo  de la
% uniformidad de utilidades y su desplazamiento, dentro de una base
% definida por el conjunto de restricciones de una variable/orden. Por
% regla general asignaremos valores de utilidad mayores de forma
% proporcional al orden de la restricción.



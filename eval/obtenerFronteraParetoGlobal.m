function [x fval exitflag] = obtenerFronteraParetoGlobal(fs, nvars, d, popsize, timelimit)
%He cambiado esta funcion para que en lugar de introducir fB y fS se
%introduzca un cell-array de funciones
options = gaoptimset('PlotFcns', @gaplotpareto,'PopulationSize', popsize,'TimeLimit',timelimit);
options = gaoptimset(options,'PopInitRange', d);
ft = '[';
for i=1:length(fs)
    ft = [ft 'fs{' num2str(i) '}(x,d) '];
end
ft = ['@(x) -1*' ft ']'];
f = eval(ft);
[x fval exitflag] = gamultiobj(f, nvars, [], [], [], [], d(1,:), d(2,:),options);
fval = -1*fval;

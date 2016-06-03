function state = negotiate(options)

    global quota;
    global alfa;
    global nag;

    if isempty(options)
       load ('UFhom');
       clf
       options = dgmset([], ...
                    'Swnk', swnk, ...
                    'Agents', uf , ...
                    'MediationType', 'rfof', ...
                    'Nag', 2, ...
                    'Ni', 100, ...
                    'Nsets', 1, ...
                    'Nexp', 1, ...
                    'Generations', 1000, ...
                    'PopulationSize', 20, ...               
                    'InitialQuota', 5);
    end

    quota = options.InitialQuota;
    alfa = 0;
    nag = options.Nag;

    optionsga = gaoptimset;
    optionsga = gaoptimset(optionsga,'PopulationType', 'bitstring');
    optionsga = gaoptimset(optionsga,'PopulationSize', options.PopulationSize);
    optionsga = gaoptimset(optionsga,'Generations', options.Generations);
    optionsga = gaoptimset(optionsga,'StallGenLimit', Inf);
    optionsga = gaoptimset(optionsga,'FitnessScalingFcn', @fitscalingprop);
    optionsga = gaoptimset(optionsga,'MutationFcn', {  @mutationuniform [] });
    optionsga = gaoptimset(optionsga,'Display', 'off');
    optionsga = gaoptimset(optionsga,'PlotFcns', {  @gaplotbestf @gaplotbestindiv ...
        @gaplotexpectation @gaplotscores @gaplotrewards});
    optionsga = gaoptimset(optionsga,'Vectorized', 'on');

    state = negoga(options,optionsga); 
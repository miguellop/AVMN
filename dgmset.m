function options = dgmset(varargin)
%DGMSET Create/alter DGM OPTIONS structure.
%   DGMSET returns a listing of the fields in the options structure as
%   well as valid parameters and the default parameter.
%   
%   OPTIONS = DGMSET('PARAM',VALUE) creates a structure with the
%   default parameters used for all PARAM not specified, and will use the
%   passed argument VALUE for the specified PARAM.
%
%   OPTIONS = DGMSET('PARAM1',VALUE1,'PARAM2',VALUE2,....) will create a
%   structure with the default parameters used for all fields not specified.
%   Those FIELDS specified will be assigned the corresponding VALUE passed,
%   PARAM and VALUE should be passed as pairs.
%
%   OPTIONS = DGMSET(OLDOPTS,'PARAM',VALUE) will create a structure named 
%   OPTIONS.  OPTIONS is created by altering the PARAM specified of OLDOPTS to
%   become the VALUE passed.  
%
%   OPTIONS = DGMSET(OLDOPTS,'PARAM1',VALUE1,'PARAM2',VALUE2,...) will
%   reassign those fields in OLDOPTS specified by PARAM1, PARAM2, ... to 
%   VALUE1, VALUE2, ...
%                  
%DGMSET PARAMETERS
%   
%   Agents              - 2D cell-array, where each row is a set of utility functions 
%                       [ 2D{@(x)} ]
%   AgentType           - The type of agent
%                       [ 'quotas' | {'quotas'} ]
%   Display             - Level of display 
%                       [ 'off' | 'iter' | 'diagnose' | {'final'} ]
%   Generations         - Maximum number of generations allowed
%                       [ positive scalar ]
%   MediationType       - The type of mediator
%                       [ 'additive' | 'dgm1' | {'additive'} ]
%   Nag                 - Number of agents 
%                       [ positive scalar ]
%   Ni                  - Number of issues 
%                       [ positive scalar ]
%   Nsets               - The number of sets of agents
%                       [ positive scalar ]
%   Nexp                - The number of experiments per set of agents 
%                       [ positive scalar ]
%   Plot                - Plot flag
%                       [ 'on' | 'off' ]
%   PlotFcns            - Function(s) used in plotting various quantities 
%                         during simulation
%                       [ @plotrewardsfcn | @plotwinnercounterfcn | {[]} ]
%   PopulationSize      - Positive scalar indicating the number of individuals
%                       [ positive scalar ]
%   Quotas              - Vector of Quotas
%                       [ vector of positive integers ]
%   SelectionThreshold  - The threshold to select a member from a
%                       Population
%                       [ positive scalar ]
%   Swnk                - 2D cell-array which stores: x, fval, sw, nash, kalai
%                       Swnk{1,3} stores those values for set 1 and agents
%                       1,2,3
%                       [ 2D{} ]


%   Copyright 2015 Miguel Angel Lopez-Carmona. UAH.
%   $Revision: 1.1 $  $Date: 2015/12/17 $
%%
if (nargin == 0) && (nargout == 0)
    fprintf('                  Agents: [ 2D cell-array of function-handle ]\n');
    fprintf('               AgentType: [ ''quotas'' | {''quotas''} ]\n');
    fprintf('           MediationType: [ ''additive'' | ''dgm1'' {''additive''} ]\n\n');

    fprintf('                 Display: [ ''off'' | ''iter'' | ''diagnose'' | {''final''} ]\n');
    fprintf('             Generations: [ positive scalar ]\n');
    fprintf('                     Nag: [ positive scalar ]\n');
    fprintf('                      Ni: [ positive scalar ]\n');
    fprintf('                   Nsets: [ positive scalar ]\n');
    fprintf('                    Nexp: [ positive scalar ]\n\n');
    
    fprintf('                    Plot: [ ''on'' | ''off'' ]\n');
    fprintf('                PlotFcns: [ function_handle  | @plotrewardsfcn | @plotwinnercounter | {[]} ]\n');
    fprintf('          PopulationSize: [ positive scalar ]\n');
    fprintf('                  Quotas: [ vector of positive integers ]\n');
    fprintf('      SelectionThreshold: [ positive scalar ]\n');
    fprintf('                    Swnk: [ 2D cell-array of x, fval, nash, kalai and sw ]\n\n');
    
    return; 
end     

numberargs = nargin; 

%Return options with default values and return it when called with one output argument
options=struct('AgentType', [], ...
               'Agents', [], ...
               'MediationType', [], ...
               'PopulationSize', [], ...
               'Nag', [], ...
               'SelectionThreshold', [], ...
               'Nsets',[], ...
               'Generations', [], ...
               'Nexp', [], ...
               'Ni', [], ...
               'Display', [], ...
               'Swnk', [], ...
               'Plot', [], ...
               'PlotFcns', [], ...
               'Quotas', []);

% If we pass in a function name then return the defaults.
if (numberargs==1) && (ischar(varargin{1}) || isa(varargin{1},'function_handle') )
    if ischar(varargin{1})
        funcname = lower(varargin{1});
        if ~exist(funcname,'file')
            error(message('dgm:DGMSET:functionNotFound',funcname));
        end
    elseif isa(varargin{1},'function_handle')
        funcname = func2str(varargin{1});
    end
    try 
        optionsfcn = feval(varargin{1},'defaults');
    catch ME
        error(message('dgm:DGMSET:noDefaultOptions',funcname));
    end
    % To get output, run the rest of psoptimset as if called with DGMSET(options, optionsfcn)
    varargin{1} = options;
    varargin{2} = optionsfcn;
    numberargs = 2;
end

Names = fieldnames(options);
m = size(Names,1);
names = lower(Names);

i = 1;
while i <= numberargs
    arg = varargin{i};
    if ischar(arg)                         % arg is an option name
        break;
    end
    if ~isempty(arg)                      % [] is a valid options argument
        if ~isa(arg,'struct')
            error(message('dgm:DGMSET:invalidArgument', i));
        end
        for j = 1:m
            if any(strcmp(fieldnames(arg),Names{j,:}))
                val = arg.(Names{j,:});
            else
                val = [];
            end
            if ~isempty(val)
                if ischar(val)
                    val = deblank(val);
                end
                options.(Names{j,:}) = checkfield(Names{j,:},val);
            end
        end
    end
    i = i + 1;
end

% A finite state machine to parse name-value pairs.
if rem(numberargs-i+1,2) ~= 0
    error(message('dgm:DGMSET:invalidArgPair'));
end
expectval = 0;                          % start expecting a name, not a value
while i <= numberargs
    arg = varargin{i};
    
    if ~expectval
        if ~ischar(arg)
            error(message('dgm:DGMSET:invalidArgFormat', i));
        end
        
        lowArg = lower(arg);
        j = strmatch(lowArg,names);
        if isempty(j)                       % if no matches
            error(message('dgm:DGMSET:invalidParamName', arg));
        elseif length(j) > 1                % if more than one match
            % Check for any exact matches (in case any names are subsets of others)
            k = strmatch(lowArg,names,'exact');
            if length(k) == 1
                j = k;
            else
                allNames = ['(' Names{j(1),:}];
                for k = j(2:length(j))'
                    allNames = [allNames ', ' Names{k,:}];
                end
                allNames = sprintf('%s).', allNames);
                error(message('dgm:DGMSET:ambiguousParamName',arg,allNames));
            end
        end
        expectval = 1;                      % we expect a value next
        
    else           
        if ischar(arg)
            arg = (deblank(arg));
        end
        options.(Names{j,:}) = checkfield(Names{j,:},arg);
        expectval = 0;
    end
    i = i + 1;
end

if expectval
    error(message('dgm:DGMSET:invalidParamVal', arg));
end


%-------------------------------------------------
function value = checkfield(field,value)
%CHECKFIELD Check validity of structure field contents.
%   CHECKFIELD('field',V) checks the contents of the specified
%   value V to be valid for the field 'field'. 
%

% empty matrix is always valid
if isempty(value)
    return
end

switch field
    case {'AgentType','MediationType'}
        if ~isa(value,'char') 
            error(message('dgm:DGMSET:checkfield:NotAString','OPTIONS',field));
        end
        
    case {'PlotFcns','Agents','Swnk'}
        if ~(iscell(value) ||  isa(value,'function_handle'))
            error(message('dgm:DGMSET:checkfield:NotAFunctionOrCellArray','OPTIONS',field));
        end
    case {'Quotas'}
        if ~(isvector(value))
            error(message('dgm:DGMSET:checkfield:NotAVector','OPTIONS',field));
        end
    case {'SelectionThreshold'} 
        if ~(isa(value,'double'))
            if ischar(value)
                error(message('dgm:DGMSET:checkfield:NotAPosRealNumButString','OPTIONS',field));
            else
                error(message('dgm:DGMSET:checkfield:NotAPosRealNum','OPTIONS',field));
            end
        end
    case {'Display'}
        if ~isa(value,'char') || ~any(strcmpi(value,{'off','none','iter','diagnose','final'}))            
            error(message('dgm:DGMSET:checkfield:NotADisplayType','OPTIONS',field,'off','iter','diagnose','final'));
        end
    case {'Plot'}
        if ~isa(value,'char') || ~any(strcmpi(value,{'off','on'}))            
            error(message('dgm:DGMSET:checkfield:NotADisplayType','OPTIONS',field,'off','iter','diagnose','final'));
        end
    case {'Generations','Nexp','Nsets','Nag','Ni'} % integer including inf or default string
        if ~(isscalar(value) && isa(value,'double') && value >= 0) && ...
                ~strcmpi(value, '200*numberOfVariables') && ...
                ~strcmpi(value, '100*numberOfVariables')
            if ischar(value)
                error(message('dgm:DGMSET:checkfield:NotAPosNumericScalarButString','OPTIONS',field));                
            else
                error(message('dgm:DGMSET:checkfield:NotAPosNumericScalar','OPTIONS',field));  
            end
        end
        
    case {'PopulationSize'} % integer including inf or default string
        if ~(isa(value,'double') && all(value(:) >= 0)) && ...
                ~strcmpi(value,'15*numberOfVariables') && ...
                ~strcmpi(value,'50 when numberOfVariables <= 5, else 200')
            if ischar(value)
                error(message('dgm:DGMSET:checkfield:NotAPosNumericButString','OPTIONS',field));
            else
                error(message('dgm:DGMSET:checkfield:NotAPosNumeric','OPTIONS',field));
            end
        end
    
   
    otherwise
        error(message('dgm:DGMSET:unknownOptionsField'))
end    


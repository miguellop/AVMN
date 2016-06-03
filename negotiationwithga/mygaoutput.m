function [state,optnew,updateoptions]  = mygaoutput(optlast,state,flag)

global popsize;


optnew = optlast;
updateoptions = false;

switch flag
    case 'init'   
        popsize = optlast.PopulationSize;    

    case 'iter'  

            updateowafcn();

    case 'interrupt'

    case 'done'

end

end

global agents;
global nag;
global quota;
global type;
global ALFA;
global WT;
global flagupdate;
      
load ('UFhom');
type = 'qfof';
nag = 2;
quota = 5;
flagupdate = 2;
ALFA = 100;

WT = getowaweights(getquantifier(1.1,100),nag);

agents = getAgents(1,nag,uf);
f = @(x) -1*owafcn(x);
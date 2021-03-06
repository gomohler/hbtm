function [K0 w mu p_back p_on p_off p]=EMhb(t,m,marks,cutoff,emiter)
if nargin < 4
   cutoff=100000;
end

if nargin < 5
   emiter=35;
end
% EM estimation of HBTM 
% t is array of event times (sorted increasing order)
% m is array of event binary word arrays
% marks is array of event categories
%
% cutoff is optional parameter to speed up EM, branching probability is
% forced to zero if i-j>cutoff
%
% emiter optional parameter, number of EM iterations

N=max(size(t));
p=zeros(N,N);
T=max(t)-min(t);
Msize=size(m,2);
Nmarks=max(size(unique(marks)));

K0=.1*ones(Nmarks,Nmarks);
w=.5*ones(Nmarks,Nmarks);
mu=.1*ones(Nmarks,1);

p_back=.1*ones(Nmarks,1);
p_off=.1*ones(Nmarks,Nmarks);
p_on=.1*ones(Nmarks,Nmarks);

% number of iterations
for k=1:emiter

% E-Step
p=updatep(mu,p,t,m,K0,w,Msize,p_back,p_on,p_off,marks,cutoff);   
    
mu=updatemu(mu,p,T,marks);

% M-Step

[K0 w p_on p_off p_back]=updatepar(t,m,p,marks,cutoff);


end


end
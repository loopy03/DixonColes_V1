function [Output] = DCoptim(model,current_date,xi)

model.xi = xi ;

% Init
nteams = length(model.teams) ;
attack_params = 0.01*ones(1,nteams-1) ;
defence_params = -0.08*ones(1,nteams) ;
home_param = 0.06 ;
rho_param = 0.03 ;
par_inits = [home_param rho_param attack_params defence_params] ;

% Weights computation
weights = DCweights( model.dates , current_date , model.xi ) ;

% Solve
DCoptimFun = @(par) (DCoptimFn(par,model,weights)) ;
options = optimoptions(@fminunc,'Algorithm','quasi-newton','StepTolerance',10e-6);
par = fminunc(DCoptimFun,par_inits,options) ;

% Fill in the missing attack parameter
missing_attack = sum(par(3:nteams+1))*-1 ;
par = [par(1:nteams+1), missing_attack, par(nteams+2:end)] ;

par(3:nteams+2) = par(3:nteams+2)+1 ;
par(nteams+3:end) = par(nteams+3:end)-1 ;

Output.home = par(1) ; 
Output.rho = par(2) ;
Output.attack = par(3:nteams+2)' ;
Output.defence = par(nteams+3:end)' ;


% Fonction de calcul des poids de temps
function [ weights ] = DCweights( dates , currentDate , xi )
for i=1:length(dates)
    datediffs(i) = days((dates{i}-currentDate)*-1) ;
    weights(i) = exp(-xi*datediffs(i)) ;
end

t = find(weights>1,1) ;

weights(t:end) = 0 ;


%% optimisation function
function [ DCoptimFn ] = DCoptimFn( params , DCm , weights )
nteams = length(DCm.teams) ;

home_p = params(1) ;
rho_p = params(2) ;

attack_p = params(3:(nteams+1)) ;
defence_p = params((nteams+2):length(params)) ;

lambda = exp(DCm.homeTeamDMa * attack_p' + DCm.awayTeamDMd * defence_p' + home_p) ;
mu = exp(DCm.awayTeamDMa * attack_p' + DCm.homeTeamDMd * defence_p') ;

DCoptimFn = DClogLikWeighted(DCm.homeGoals, DCm.awayGoals, lambda, mu, rho_p, weights) * -1 ;


%% log-likelihood function
function [ lik ] = DClogLikWeighted( y1 , y2 , lambda , mu , rho , weights )
lik = sum(log(tau(y1,y2,lambda,mu,rho)) + log(poisspdf(y1,lambda)') + log(poisspdf(y2,mu)').*weights) ;


%% computes the degree in which the probabilities for the low scoring goals changes
function [ tau ] = tau( xx , yy , lambda , mu , rho )
for i=1:length(xx)
if xx(i)==0 && yy(i)==0
    tau(i) = 1-lambda(i)*mu(i)*rho ;
elseif xx(i)==0 && yy(i)==1
    tau(i) = 1+lambda(i)*rho ;
elseif xx(i)==1 && yy(i)==0
    tau(i) = 1+mu(i)*rho ;
elseif xx(i)==1 && yy(i)==1
    tau(i) = 1-rho ;
else
    tau(i) = 1 ;
end
end
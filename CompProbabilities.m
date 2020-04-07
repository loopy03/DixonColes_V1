function [ probabilities , lambda , mu , x , diff ] = CompProbabilities( Input ,T_pred ,match,  maxgoal ,  DCm )

hometeam = find(strcmp(DCm.teams,T_pred.HomeTeam{match})) ;
awayteam = find(strcmp(DCm.teams,T_pred.AwayTeam{match})) ;

home_p = Input.home ;
rho_p = Input.rho ;

attack_p = Input.attack ;
defence_p = Input.defence ;

lambda = exp( attack_p(hometeam) + defence_p(awayteam) + home_p) ;
mu = exp(attack_p(awayteam) + defence_p(hometeam)) ;

tau_p = tau( [0 1 0 1] , [0 0 1 1] , lambda*ones(4,1) , mu*ones(4,1) , rho_p ) ;
probability_matrix = poisspdf(0:maxgoal,lambda)' * poisspdf(0:maxgoal,mu) ;
scaling_factor_vec = tau( [0 1 0 1] , [0 0 1 1] , lambda*ones(4,1) , mu*ones(4,1) , rho_p ) ;
scaling_factor_mat = [scaling_factor_vec(1) scaling_factor_vec(3); scaling_factor_vec(2) scaling_factor_vec(4)] ;
probability_matrix(1:2,1:2) = probability_matrix(1:2,1:2) .* scaling_factor_mat ;
    
probabilities(1) = sum(sum(tril(probability_matrix,-1))) ;
probabilities(2) = trace(probability_matrix) ;
probabilities(3) = sum(sum(triu(probability_matrix,1))) ;

x=-maxgoal:maxgoal ;
p_diff_1=[];
for i=1:maxgoal
    p_diff_1(end+1) = sum(diag(probability_matrix,-i)) ;
end
p_diff_2=[];
for i=-maxgoal:-1
    p_diff_2(end+1) = sum(diag(probability_matrix,-i)) ;
end
p_diff_N=sum(diag(probability_matrix));

diff = [p_diff_2,p_diff_N,p_diff_1];

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
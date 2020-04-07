function [ T ] = res2table( res )
%UNTITLED8 Summary of this function goes here
%   Detailed explanation goes here

% Table des scores
HomeTeam = {} ;
AwayTeam = {} ;
HomeGoals = [] ;
AwayGoals = [] ;
Dates = {} ;
Days = [] ;
League = {};

nb_matchs = length(res) ;

for i=1:nb_matchs
    HomeTeam{end+1} = res{i,3} ;
    AwayTeam{end+1} = res{i,4} ;
    HomeGoals(end+1) = res{i,5} ;
    AwayGoals(end+1) = res{i,6} ;
    Dates{end+1} = datetime(res{i,2},'InputFormat','dd/MM/yy') ;
    Days(end+1) = datenum(Dates{end}) ;
    League{end+1} = res{i,1} ;
end

HomeTeam=HomeTeam'; AwayTeam=AwayTeam'; HomeGoals=HomeGoals'; AwayGoals=AwayGoals'; Dates=Dates'; Days = Days' ; League=League';

A = table(HomeTeam,AwayTeam,HomeGoals,AwayGoals,Dates,Days,League);
T = sortrows(A,6) ;


end


function [ DCm ] = DCmodelData( T_connue , T_pred )
T = [T_connue;T_pred] ;

team_names = unique([T.HomeTeam;T.AwayTeam]);
last_team = team_names{end};

hm_a = zeros(height(T_connue),length(team_names)) ;
am_a = zeros(height(T_connue),length(team_names)) ;
hm_d = hm_a ;
am_d = am_a ;

% Design matrix pour attaque avec contrainte de somme à 0 et classique
% Design matrix pour défence classique
for i=1:length(team_names)
    for j=1:height(T_connue)
        if strcmp(team_names{i},T.HomeTeam(j))
            hm_a(j,i)=1 ;
            hm_d(j,i)=1 ;
        end
        if strcmp(T.HomeTeam(j),last_team)
            hm_a(j,:)=-1 ;
        end
        if strcmp(team_names{i},T.AwayTeam(j))
            am_a(j,i)=1 ;
            am_d(j,i)=1 ;
        end
        if strcmp(T.AwayTeam(j),last_team)
            am_a(j,:)=-1 ;     
        end
    end
end

hm_a = hm_a(:,1:end-1) ;
am_a = am_a(:,1:end-1) ;

% Time
time = days(zeros(1,height(T))) ;
for i=1:height(T)
    time(i) = days(T.Dates{i}-T.Dates{1})+1 ;
end


DCm.homeTeamDMa = hm_a ;
DCm.homeTeamDMd = hm_d ;
DCm.awayTeamDMa = am_a ;
DCm.awayTeamDMd = am_d ;
DCm.homeGoals = T_connue.HomeGoals ;
DCm.awayGoals = T_connue.AwayGoals ;
DCm.dates = T_connue.Dates ;
DCm.teams = team_names ;
DCm.resultsTable = T ;
DCm.time = time' ;
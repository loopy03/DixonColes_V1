clear all
close all
clc

%% Chargement des données connues
years = 2018 ;
league = {'F1'} ;
T = importDatatoTable( years , league ) ;

%% Chargement des données de test
current_date = datetime('24/05/2019','InputFormat','dd/MM/yy') ;
T_test = T(1,:) ;
T_test.HomeTeam = {'Marseille'} ; T_test.HomeGoals = NaN ;
T_test.AwayTeam = {'Lyon'} ; T_test.AwayGoals = NaN ;
T_test.Dates{1} = current_date ; T_test.Days = datenum('24-May-2019') ;
T_test.League = 1 ;

%% Initialisation
maxgoal = 10 ;
xi = 0 ;


%% Calcul des probabilités par la méthode de Dixon-Coles

% Création du modèle
DCm = DCmodelData( T , T_test ) ;

% Résolution et rendus
Output = DCoptim(DCm,current_date,xi) ;
Output_DC_TI = Output ;
% Calcul des probabilités
[p_DC_TI , lambda_marseille , lambda_lyon, x , diff_DC_TI] = CompProbabilities( Output ,T_test ,1,  maxgoal ,  DCm );
Output.rho = 0 ;
Output_PLM = Output ;
[p_PLM , lambda_marseille , lambda_lyon, x , diff_PLM] = CompProbabilities( Output ,T_test ,1,  maxgoal ,  DCm );

xi=0.0065 ;
Output = DCoptim(DCm,current_date,xi) ;
Output_DC_TD = Output ;
[p_DC_TD , lambda_marseille , lambda_lyon, x , diff_DC_TD] = CompProbabilities( Output ,T_test ,1,  maxgoal ,  DCm );

% Graphe des probabilités des écarts PLM
subplot(1,3,1)
hold on
idx=x>=0&x<=8;
area(x(idx),diff_PLM(idx),'FaceAlpha',0.5,'EdgeColor','none');
idx=x>=-8&x<=0;
area(x(idx),diff_PLM(idx),'FaceAlpha',0.5,'EdgeColor','none');
idx=x==0;
area(x(idx),diff_PLM(idx),'LineWidth',1.5,'EdgeColor','green','EdgeAlpha',0.5,'FaceAlpha',0);
plot(x,diff_PLM,'-x','LineWidth',1.5,'color','k')

%text(-7,0.31,'Modèle par lois de Poisson indépendantes')

legend('Cas Marseille gagne','Cas Lyon gagne','Cas match nul','Distribution')
xlim([-8 8])
ylim([0 0.4])
xlabel('Différence de buts')
ylabel('Probabilité')
title('Modèle par lois de Poisson indépendantes')

set(gca, ...
     'Box'         , 'off'     , ...
    'TickDir'     , 'out'     , ...
    'TickLength'  , [.02 .02] , ...
    'XMinorTick'  , 'off'      , ...
    'YMinorTick'  , 'on'      , ...
    'XGrid'       , 'on'      , ...
    'YGrid'       , 'on'      , ...
    'XColor'      , [.3 .3 .3], ...
    'YColor'      , [.3 .3 .3], ...
    'YTick'       , 0:0.05:1, ...
    'XTick'       , -10:1:10, ...
    'LineWidth'   , 1         );

% Graphe des probabilités des écarts Dixon COles time independant
subplot(1,3,2)
hold on
idx=x>=0&x<=8;
area(x(idx),diff_DC_TI(idx),'FaceAlpha',0.5,'EdgeColor','none');
idx=x>=-8&x<=0;
area(x(idx),diff_DC_TI(idx),'FaceAlpha',0.5,'EdgeColor','none');
idx=x==0;
area(x(idx),diff_DC_TI(idx),'LineWidth',1.5,'EdgeColor','green','EdgeAlpha',0.5,'FaceAlpha',0);
plot(x,diff_DC_TI,'-x','LineWidth',1.5,'color','k')

%text(-7,0.31,'Modèle de Dixon-Coles avec \xi=0')

legend('Cas Marseille gagne','Cas Lyon gagne','Cas match nul','Distribution')
xlim([-8 8])
ylim([0 0.4])
xlabel('Différence de buts')
ylabel('Probabilité')
title('Modèle de Dixon-Coles avec \xi=0')

set(gca, ...
     'Box'         , 'off'     , ...
    'TickDir'     , 'out'     , ...
    'TickLength'  , [.02 .02] , ...
    'XMinorTick'  , 'off'      , ...
    'YMinorTick'  , 'on'      , ...
    'XGrid'       , 'on'      , ...
    'YGrid'       , 'on'      , ...
    'XColor'      , [.3 .3 .3], ...
    'YColor'      , [.3 .3 .3], ...
    'YTick'       , 0:0.05:1, ...
    'XTick'       , -10:1:10, ...
    'LineWidth'   , 1         );

% Graphe des probabilités des écarts Dixon COles time dependant
subplot(1,3,3)
hold on
idx=x>=0&x<=8;
area(x(idx),diff_DC_TD(idx),'FaceAlpha',0.5,'EdgeColor','none');
idx=x>=-8&x<=0;
area(x(idx),diff_DC_TD(idx),'FaceAlpha',0.5,'EdgeColor','none');
idx=x==0;
area(x(idx),diff_DC_TD(idx),'LineWidth',1.5,'EdgeColor','green','EdgeAlpha',0.5,'FaceAlpha',0);
plot(x,diff_DC_TD,'-x','LineWidth',1.5,'color','k')

%text(-7,0.31,'Modèle de Dixon-Coles avec \xi=0.0065')

legend('Cas Marseille gagne','Cas Lyon gagne','Cas match nul','Distribution')
xlim([-8 8])
ylim([0 0.4])
xlabel('Différence de buts')
ylabel('Probabilité')
title('Modèle de Dixon-Coles avec \xi=0.0065')

set(gca, ...
     'Box'         , 'off'     , ...
    'TickDir'     , 'out'     , ...
    'TickLength'  , [.02 .02] , ...
    'XMinorTick'  , 'off'      , ...
    'YMinorTick'  , 'on'      , ...
    'XGrid'       , 'on'      , ...
    'YGrid'       , 'on'      , ...
    'XColor'      , [.3 .3 .3], ...
    'YColor'      , [.3 .3 .3], ...
    'YTick'       , 0:0.05:1, ...
    'XTick'       , -10:1:10, ...
    'LineWidth'   , 1         );

set(gcf, 'PaperPositionMode', 'auto');
print('fig','-dpng')


proba = [p_PLM;p_DC_TI;p_DC_TD];

cotes = 1./proba ;




    
    
    
    
    
    

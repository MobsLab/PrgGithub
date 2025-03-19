
%% Fear analysis

GetEmbReactMiceFolderList_BM
Voltage_UMaze_Drugs_BM
Drug_Group={'SalineSB','ChronicFlx','AcuteFlx','Midazolam','SalineBM_Short','Diazepam_Short','SalineBM_Long','Diazepam_Long'};

% Stim and time spent in zones in TestPost
for group=5:length(Drug_Group)
    drug=group; % must be corrected when I'll have the time
    Drugs_Groups_UMaze_BM
    
    clear Mouse_names
    for mouse = 1:length(Mouse)
        Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
    end
    for mouse = 1:length(Mouse)
        
        % Test Post analysis
        ZoneEpoch.PostTest.(Drug_Group{drug}).(Mouse_names{mouse})=ConcatenateDataFromFolders_SB(TestPostSess.(Mouse_names{mouse}),'Epoch','epochname','zoneepoch');
        ShockZoneEpoch.PostTest.(Drug_Group{drug}).(Mouse_names{mouse})=or(ZoneEpoch.PostTest.(Drug_Group{drug}).(Mouse_names{mouse}){1},ZoneEpoch.PostTest.(Drug_Group{drug}).(Mouse_names{mouse}){4});
        SafeZoneEpoch.PostTest.(Drug_Group{drug}).(Mouse_names{mouse})=or(ZoneEpoch.PostTest.(Drug_Group{drug}).(Mouse_names{mouse}){2},ZoneEpoch.PostTest.(Drug_Group{drug}).(Mouse_names{mouse}){5});
        
        ShockZonePostTime.(Mouse_names{mouse})=sum(Stop(ShockZoneEpoch.PostTest.(Drug_Group{drug}).(Mouse_names{mouse}))-Start(ShockZoneEpoch.PostTest.(Drug_Group{drug}).(Mouse_names{mouse})));
        SafeZonePostTime.(Mouse_names{mouse})=sum(Stop(SafeZoneEpoch.PostTest.(Drug_Group{drug}).(Mouse_names{mouse}))-Start(SafeZoneEpoch.PostTest.(Drug_Group{drug}).(Mouse_names{mouse})));
        ShockVersusSafeZonesPost.(Mouse_names{mouse})=ShockZonePostTime.(Mouse_names{mouse})/SafeZonePostTime.(Mouse_names{mouse});
        
        % Test Pre analysis
        ZoneEpoch.PreTest.(Drug_Group{drug}).(Mouse_names{mouse})=ConcatenateDataFromFolders_SB(TestPreSess.(Mouse_names{mouse}),'Epoch','epochname','zoneepoch');
        
        ShockZoneEpoch.PreTest.(Drug_Group{drug}).(Mouse_names{mouse})=or(ZoneEpoch.PreTest.(Drug_Group{drug}).(Mouse_names{mouse}){1},ZoneEpoch.PreTest.(Drug_Group{drug}).(Mouse_names{mouse}){4});
        SafeZoneEpoch.PreTest.(Drug_Group{drug}).(Mouse_names{mouse})=or(ZoneEpoch.PreTest.(Drug_Group{drug}).(Mouse_names{mouse}){2},ZoneEpoch.PreTest.(Drug_Group{drug}).(Mouse_names{mouse}){5});
        
        ShockZonePreTime.(Mouse_names{mouse})=sum(Stop(ShockZoneEpoch.PreTest.(Drug_Group{drug}).(Mouse_names{mouse}))-Start(ShockZoneEpoch.PreTest.(Drug_Group{drug}).(Mouse_names{mouse})));
        SafeZonePreTime.(Mouse_names{mouse})=sum(Stop(SafeZoneEpoch.PreTest.(Drug_Group{drug}).(Mouse_names{mouse}))-Start(SafeZoneEpoch.PreTest.(Drug_Group{drug}).(Mouse_names{mouse})));
        
        ShockVersusSafeZonesPre.(Mouse_names{mouse})=ShockZonePreTime.(Mouse_names{mouse})/SafeZonePreTime.(Mouse_names{mouse});
        ShockVersusSafePostTime.(Drug_Group{drug})(mouse)=ShockVersusSafeZonesPost.(Mouse_names{mouse});
        ShockVersusSafePreTime.(Drug_Group{drug})(mouse)=ShockVersusSafeZonesPre.(Mouse_names{mouse});
       
        % Stim analysis
        StimEpoch.(Mouse_names{mouse})=ConcatenateDataFromFolders_SB(CondSess.(Mouse_names{mouse}),'Epoch','epochname','stimepoch');
        StartStimEpoch.(Mouse_names{mouse})=Start(StimEpoch.(Mouse_names{mouse}));
        StimNumb.(Mouse_names{mouse})=length(StartStimEpoch.(Mouse_names{mouse}));
        StimNumb.(Drug_Group{drug})(mouse)=StimNumb.(Mouse_names{mouse});
        
        % Freezing analysis
        ZoneEpoch.Cond.(Mouse_names{mouse})=ConcatenateDataFromFolders_SB(CondSess.(Mouse_names{mouse}),'Epoch','epochname','zoneepoch');
        FreezeEpoch.Fear.(Mouse_names{mouse})=ConcatenateDataFromFolders_SB(FearSess.(Mouse_names{mouse}),'Epoch','epochname','freezeepoch');
        FreezeEpoch.TestPost.(Mouse_names{mouse})=ConcatenateDataFromFolders_SB(TestPostSess.(Mouse_names{mouse}),'Epoch','epochname','freezeepoch');
        FreezeEpoch.Cond.(Mouse_names{mouse})=ConcatenateDataFromFolders_SB(CondSess.(Mouse_names{mouse}),'Epoch','epochname','freezeepoch');
        FreezeEpoch.Cond.Shock.(Mouse_names{mouse})=and(FreezeEpoch.Cond.(Mouse_names{mouse}),ZoneEpoch.Cond.(Mouse_names{mouse}){1});
        FreezeEpoch.Cond.Safe.(Mouse_names{mouse})=and(FreezeEpoch.Cond.(Mouse_names{mouse}),or(ZoneEpoch.Cond.(Mouse_names{mouse}){2},ZoneEpoch.Cond.(Mouse_names{mouse}){5}));
        FreezeEpoch.Ext.(Mouse_names{mouse})=ConcatenateDataFromFolders_SB(ExtSess.(Mouse_names{mouse}),'Epoch','epochname','freezeepoch');
        
        FreezeTime.Fear.(Mouse_names{mouse})=sum(Stop(FreezeEpoch.Fear.(Mouse_names{mouse}))-Start(FreezeEpoch.Fear.(Mouse_names{mouse})));
        FreezeTime.TestPost.(Mouse_names{mouse})=sum(Stop(FreezeEpoch.TestPost.(Mouse_names{mouse}))-Start(FreezeEpoch.TestPost.(Mouse_names{mouse})));
        FreezeTime.Cond.(Mouse_names{mouse})=sum(Stop(FreezeEpoch.Cond.(Mouse_names{mouse}))-Start(FreezeEpoch.Cond.(Mouse_names{mouse})));
        FreezeTime.Cond.Shock.(Mouse_names{mouse})=sum(Stop(FreezeEpoch.Cond.Shock.(Mouse_names{mouse}))-Start(FreezeEpoch.Cond.Shock.(Mouse_names{mouse})));
        FreezeTime.Cond.Safe.(Mouse_names{mouse})=sum(Stop(FreezeEpoch.Cond.Safe.(Mouse_names{mouse}))-Start(FreezeEpoch.Cond.Safe.(Mouse_names{mouse})));
        FreezeTime.Ext.(Mouse_names{mouse})=sum(Stop(FreezeEpoch.Ext.(Mouse_names{mouse}))-Start(FreezeEpoch.Ext.(Mouse_names{mouse})));
       
        % Total time
        TotalTime.Fear.(Mouse_names{mouse})=max(Range(ConcatenateDataFromFolders_SB(FearSess.(Mouse_names{mouse}),'speed')));
        TotalTime.TestPost.(Mouse_names{mouse})=max(Range(ConcatenateDataFromFolders_SB(TestPostSess.(Mouse_names{mouse}),'speed')));
        TotalTime.Ext.(Mouse_names{mouse})=max(Range(ConcatenateDataFromFolders_SB(ExtSess.(Mouse_names{mouse}),'speed')));
        
        %Gathering in drugs groups
        FreezeTime.Fear.(Drug_Group{drug})(mouse) = FreezeTime.Fear.(Mouse_names{mouse});
        FreezeTime.TestPost.(Drug_Group{drug})(mouse) = FreezeTime.TestPost.(Mouse_names{mouse});
        FreezeTime.Ext.(Drug_Group{drug})(mouse) = FreezeTime.Ext.(Mouse_names{mouse});
        FreezeTime.Cond.(Drug_Group{drug})(mouse) = FreezeTime.Cond.(Mouse_names{mouse});
        FreezeTime.CondShock.(Drug_Group{drug})(mouse) = FreezeTime.Cond.Shock.(Mouse_names{mouse});
        FreezeTime.CondSafe.(Drug_Group{drug})(mouse) = FreezeTime.Cond.Safe.(Mouse_names{mouse});
         
        TotalTime.Fear.(Drug_Group{drug})(mouse) = TotalTime.Fear.(Mouse_names{mouse});
        TotalTime.TestPost.(Drug_Group{drug})(mouse) = TotalTime.TestPost.(Mouse_names{mouse});
        TotalTime.Ext.(Drug_Group{drug})(mouse) = TotalTime.Ext.(Mouse_names{mouse});
        
        % Cond Blocked analysis
%         ZoneEpoch.CondBlocked.(Mouse_names{mouse})=ConcatenateDataFromFolders_SB(CondBlockedSess.(Mouse_names{mouse}),'Epoch','epochname','zoneepoch');
%         FreezeEpoch.CondBlocked.(Mouse_names{mouse})=ConcatenateDataFromFolders_SB(CondBlockedSess.(Mouse_names{mouse}),'Epoch','epochname','freezeepoch');
%         FreezeEpoch.CondBlocked.Shock.(Mouse_names{mouse})=and(FreezeEpoch.CondBlocked.(Mouse_names{mouse}),ZoneEpoch.CondBlocked.(Mouse_names{mouse}){1});
%         FreezeEpoch.CondBlocked.Safe.(Mouse_names{mouse})=and(FreezeEpoch.CondBlocked.(Mouse_names{mouse}),or(ZoneEpoch.CondBlocked.(Mouse_names{mouse}){2},ZoneEpoch.CondBlocked.(Mouse_names{mouse}){5}));
%         
%         FreezeTime.CondBlocked.(Mouse_names{mouse})=sum(Stop(FreezeEpoch.CondBlocked.(Mouse_names{mouse}))-Start(FreezeEpoch.CondBlocked.(Mouse_names{mouse})));
%         FreezeTime.CondBlocked.Shock.(Mouse_names{mouse})=sum(Stop(FreezeEpoch.CondBlocked.Shock.(Mouse_names{mouse}))-Start(FreezeEpoch.CondBlocked.Shock.(Mouse_names{mouse})));
%         FreezeTime.CondBlocked.Safe.(Mouse_names{mouse})=sum(Stop(FreezeEpoch.CondBlocked.Safe.(Mouse_names{mouse}))-Start(FreezeEpoch.CondBlocked.Safe.(Mouse_names{mouse})));
%         
%         FreezeTime.CondBlocked.(Drug_Group{drug})(mouse) = FreezeTime.CondBlocked.(Mouse_names{mouse});
%         FreezeTime.CondBlockedShock.(Drug_Group{drug})(mouse) = FreezeTime.CondBlocked.Shock.(Mouse_names{mouse});
%         FreezeTime.CondBlockedSafe.(Drug_Group{drug})(mouse) = FreezeTime.CondBlocked.Safe.(Mouse_names{mouse});
%         
        %Speed for Cond sessions
        Speed.Cond.(Mouse_names{mouse})=ConcatenateDataFromFolders_SB(CondSess.(Mouse_names{mouse}),'speed');
        SpeedAverage.Cond.(Mouse_names{mouse})=nanmean(Data(Speed.Cond.(Mouse_names{mouse})));
        SpeedAverage.Cond.(Drug_Group{drug})(mouse) = SpeedAverage.Cond.(Mouse_names{mouse});
        
        %Total time for Cond sessions for shock and safe zones
        TotalTime.Cond.(Mouse_names{mouse})=max(Range(Speed.Cond.(Mouse_names{mouse})));
        TotalTime.Cond.(Drug_Group{drug})(mouse) = TotalTime.Cond.(Mouse_names{mouse});
        TotalTime.CondShock.(Mouse_names{mouse})=sum(Stop(ZoneEpoch.Cond.(Mouse_names{mouse}){1})-Start(ZoneEpoch.Cond.(Mouse_names{mouse}){1}));
        TotalTime.CondSafe.(Mouse_names{mouse})=sum(Stop(ZoneEpoch.Cond.(Mouse_names{mouse}){2})-Start(ZoneEpoch.Cond.(Mouse_names{mouse}){2}))+sum(Stop(ZoneEpoch.Cond.(Mouse_names{mouse}){5})-Start(ZoneEpoch.Cond.(Mouse_names{mouse}){5}));
        TotalTime.CondShock.(Drug_Group{drug})(mouse) = TotalTime.CondShock.(Mouse_names{mouse});
        TotalTime.CondSafe.(Drug_Group{drug})(mouse) = TotalTime.CondSafe.(Mouse_names{mouse});
        
        %Time spent Active during Cond sessions
        ActiveStateTime.Cond.(Mouse_names{mouse})=TotalTime.Cond.(Mouse_names{mouse}) - FreezeTime.Cond.(Mouse_names{mouse});
        ActiveStateTime.Cond.(Drug_Group{drug})(mouse) = ActiveStateTime.Cond.(Mouse_names{mouse});
        
        %Total distance for Cond sessions for shock and safe zones
        TotalDistance.Cond.(Mouse_names{mouse})=TotalTime.Cond.(Mouse_names{mouse})*SpeedAverage.Cond.(Mouse_names{mouse});
        TotalDistance.Cond.(Drug_Group{drug})(mouse) = TotalDistance.Cond.(Mouse_names{mouse});

        %Ripples for Cond sessions for shock and safe zones
        Ripples.Cond.(Mouse_names{mouse})=ConcatenateDataFromFolders_SB(CondSess.(Mouse_names{mouse}),'ripples');
        RipplesNumbTot.Cond.(Mouse_names{mouse})=length(Ripples.Cond.(Mouse_names{mouse}));
        RipplesNumbWhileFreezing.Cond.Shock.(Mouse_names{mouse})=length(Restrict(Ripples.Cond.(Mouse_names{mouse}),FreezeEpoch.Cond.Shock.(Mouse_names{mouse})));
        RipplesNumbWhileFreezing.Cond.Safe.(Mouse_names{mouse})=length(Restrict(Ripples.Cond.(Mouse_names{mouse}),FreezeEpoch.Cond.Safe.(Mouse_names{mouse})));
        RipplesNumbWhileFreezing.CondShock.(Drug_Group{drug})(mouse) = RipplesNumbWhileFreezing.Cond.Shock.(Mouse_names{mouse});
        RipplesNumbWhileFreezing.CondSafe.(Drug_Group{drug})(mouse) = RipplesNumbWhileFreezing.Cond.Safe.(Mouse_names{mouse});
        RipplesNumbTot.Cond.(Drug_Group{drug})(mouse) = RipplesNumbTot.Cond.(Mouse_names{mouse});
        
        Mouse_names{mouse}
    end
    
%     if drug==1;
%         StimNumb.(Drug_Group{drug})=StimNumb.(Drug_Group{drug})-[12 12 12 12 16 16 16 16 16 16 16];
%     elseif drug==4;
%         StimNumb.(Drug_Group{drug})=(StimNumb.(Drug_Group{drug})-16)+[4 4 4 4 zeros(1,20)];
%     else
%         StimNumb.(Drug_Group{drug})=StimNumb.(Drug_Group{drug})-16;
%     end
            
    StimNumb.(Drug_Group{drug})(StimNumb.(Drug_Group{drug})>34)=NaN; % deleting aberrant stim numbers
    Volt.(Drug_Group{drug})(StimNumb.(Drug_Group{drug})>40)=NaN;
    
    ShockVersusSafe.(Drug_Group{drug})=[ShockVersusSafePreTime.(Drug_Group{drug})' ShockVersusSafePostTime.(Drug_Group{drug})'];
    
    FigureFreezeTime.(Drug_Group{drug})=[ (FreezeTime.Fear.(Drug_Group{drug})./TotalTime.Fear.(Drug_Group{drug}))'  (FreezeTime.Cond.(Drug_Group{drug})./TotalTime.Cond.(Drug_Group{drug}))'  (FreezeTime.TestPost.(Drug_Group{drug})./TotalTime.TestPost.(Drug_Group{drug}))'  (FreezeTime.Ext.(Drug_Group{drug})./TotalTime.Ext.(Drug_Group{drug}))' ];
    
    TotalDistance.Cond.(Drug_Group{drug})(SpeedAverage.Cond.(Drug_Group{drug})>10)=NaN;
    SpeedAverage.Cond.(Drug_Group{drug})(SpeedAverage.Cond.(Drug_Group{drug})>10)=NaN;

    ShockVersusSafe.(Drug_Group{drug})(ShockVersusSafe.(Drug_Group{drug})(:,2)>3,:)=NaN; % delete weird data
  
    RipplesNumbWhileFreezing.CondShock.(Drug_Group{drug})(RipplesNumbWhileFreezing.CondShock.(Drug_Group{drug})==0)=NaN;
    RipplesNumbWhileFreezing.CondSafe.(Drug_Group{drug})(RipplesNumbWhileFreezing.CondSafe.(Drug_Group{drug})==0)=NaN;

end

StimNumb.ChronicFlx(1)=3; StimNumb.All(12)=3; % correction of M875

%% Plot
drug=1; % CHOOSE YOUR DRUG
% Extrashocks as a function of shock intensity
figure
subplot(1,3,1)
clear lgcl_vect; lgcl_vect = ~isnan(StimNumb.(Drug_Group{drug})); % logical vector
clear X_to_use Y_to_use; X_to_use = Volt.(Drug_Group{drug})(lgcl_vect); Y_to_use = StimNumb.(Drug_Group{drug})(lgcl_vect);
plot( X_to_use , Y_to_use ,'.r','MarkerSize',30); makepretty; xlabel('Shock Intensity (V)'); ylabel('non imposed shocks'); hold on
[R,P] = corrcoef( X_to_use , Y_to_use )
p=polyfit( X_to_use , Y_to_use ,1);
x=[0 10]; y=x.*p(1)+p(2); plot(x,y,'r','LineWidth',2)
text(5,5,['R = ' num2str(R(2,1)) '     P = ' num2str(P(2,1))])
makepretty
title('non imposed shocks = f( shock intensity )')

% Time spent in test pre and post
subplot(1,3,2)
PlotErrorBarN_KJ(ShockVersusSafe.(Drug_Group{drug}),'newfig',0)
ylabel('Test Post : shock/safe zone time time')
xticks([1:2])
xticklabels({'Test Pre','Test Post'})
xtickangle(45)
makepretty
title('Shock/safe zone time')

% Freeze time during differents sessions
subplot(1,3,3)
PlotErrorBarN_KJ(FigureFreezeTime.(Drug_Group{drug})*100,'newfig',0)
ylabel('Freezing proportion (%)');
xticks([1:4])
xticklabels({'All Sessions','Conditionning sessions','Test Post sessions',' Extinction sessions'})
xtickangle(45)
title('Time spent freezing in differents sessions')
makepretty

a=suptitle('Fear conditionning analysis, saline mice (n=10)'); a.FontSize=30;
a=suptitle('Fear conditionning analysis, chronic flx mice (n=6)'); a.FontSize=30;
a=suptitle('Fear conditionning analysis, midazolam mice (n=7)'); a.FontSize=30;
a=suptitle('Fear conditionning analysis, all mice (n=22)'); a.FontSize=30;


%% correlations 
figure
subplot(1,3,1)
[R,P]=PlotCorrelations_BM(StimNumb.(Drug_Group{drug}),ShockVersusSafe.(Drug_Group{drug})(:,2)');
xlabel('non imposed shocks'); ylabel('Test Post : shock/safe zone time'); 
subplot(1,3,2)
[R,P]=PlotCorrelations_BM((FreezeTime.Cond.(Drug_Group{drug})./TotalTime.Cond.(Drug_Group{drug}))*100,StimNumb.(Drug_Group{drug}));
 ylabel('non imposed shocks'); xlabel('Freezing proportion (%)'); 
subplot(1,3,3)
[R,P]=PlotCorrelations_BM((FreezeTime.Cond.(Drug_Group{drug})./TotalTime.Cond.(Drug_Group{drug}))*100,ShockVersusSafe.(Drug_Group{drug})(:,2)');
ylabel('Test Post : shock/safe zone time'); xlabel('Freezing proportion (%)'); 

a=suptitle('Correlations analyses (Test Post : shock/safe zone time, non imposed shocks, freezing time)'); a.FontSize=25;

% correlatioons extrashocks / freezing time looking at shock and safe side
% freezing
figure
subplot(121)
[R,P]=PlotCorrelations_BM((FreezeTime.CondShock.(Drug_Group{drug})./TotalTime.CondShock.(Drug_Group{drug}))*100 , StimNumb.(Drug_Group{drug}));
xlabel('non imposed shocks'); ylabel('Shock side freezing proportion (%)');
subplot(122)
[R,P]=PlotCorrelations_BM((FreezeTime.CondSafe.(Drug_Group{drug})./TotalTime.CondSafe.(Drug_Group{drug}))*100 , StimNumb.(Drug_Group{drug}));
xlabel('non imposed shocks'); ylabel('Safe side freezing proportion (%)');

a=suptitle('Correlations of freezing time and non imposed shocks​'); a.FontSize=25;

% Normalization of imposed shocks by distance traveled
figure
subplot(221) % the more we freeze, the less we walk
[R,P]=PlotCorrelations_BM( (FreezeTime.Cond.(Drug_Group{drug})./TotalTime.Cond.(Drug_Group{drug}))*100 , TotalDistance.Cond.(Drug_Group{drug}));
xlabel('Freezing proportion (%)'); ylabel('Total traveled distance'); 
subplot(222) % the less we travel distance, the less we take shocks
[R,P]=PlotCorrelations_BM( TotalDistance.Cond.(Drug_Group{drug}) , StimNumb.(Drug_Group{drug}) );
xlabel('Total traveled distance'); ylabel('non imposed shocks'); 
subplot(223) % extra-shocks normalization by total distance traveled
[R,P]=PlotCorrelations_BM( (FreezeTime.Cond.(Drug_Group{drug})./TotalTime.Cond.(Drug_Group{drug}))*100 ,  StimNumb.(Drug_Group{drug})./TotalDistance.Cond.(Drug_Group{drug}) );
ylabel('non imposed shocks normalization'); xlabel('Freezing proportion (%)'); hold on

a=suptitle('Control figures to link freezing time and non imposed shocks using total traveled distance​'); a.FontSize=25;

% Normalization of imposed shocks by time spent active
figure
subplot(221) % the more we freeze, the less we are active (indeed !)
[R,P]=PlotCorrelations_BM( (FreezeTime.Cond.(Drug_Group{drug})./TotalTime.Cond.(Drug_Group{drug}))*100 ,  (ActiveStateTime.Cond.(Drug_Group{drug})./TotalTime.Cond.(Drug_Group{drug}))*100 );
xlabel('Freezing proportion (%)'); ylabel('Active state proportion (%)'); 
subplot(222) % the less we are active, the less we take shocks
[R,P]=PlotCorrelations_BM( (ActiveStateTime.Cond.(Drug_Group{drug})./TotalTime.Cond.(Drug_Group{drug}))*100 ,  StimNumb.(Drug_Group{drug}) );
xlabel('Active state proportion (%)'); ylabel('non imposed shocks');
xlim([80 100]); ylim([0 9])
subplot(223) % normalization
[R,P]=PlotCorrelations_BM( (FreezeTime.Cond.(Drug_Group{drug})./TotalTime.Cond.(Drug_Group{drug}))*100 ,   StimNumb.(Drug_Group{drug})./((ActiveStateTime.Cond.(Drug_Group{drug})./TotalTime.Cond.(Drug_Group{drug}))*100) );
xlabel('non imposed shocks normalized by time spent active'); ylabel('Freezing proportion (%)'); 

a=suptitle('Control figures to link freezing time and non imposed shocks using total time spent active​'); a.FontSize=25;

% correlatioons extrashocks / ripples numbers while freezing
figure
subplot(1,2,1)
[R,P]=PlotCorrelations_BM( RipplesNumbWhileFreezing.CondShock.(Drug_Group{drug}) ,   StimNumb.(Drug_Group{drug}) );
ylabel('non imposed shocks'); xlabel('# Shock side ripples'); 
subplot(1,2,2)
[R,P]=PlotCorrelations_BM( RipplesNumbWhileFreezing.CondSafe.(Drug_Group{drug}) ,   StimNumb.(Drug_Group{drug}) );
ylabel('non imposed shocks'); xlabel('# Safe side ripples'); hold on

a=suptitle('Correlations of ripples and non imposed shocks​​'); a.FontSize=25;


figure
subplot(1,2,1)
[R,P]=PlotCorrelations_BM( RipplesNumbWhileFreezing.CondShock.(Drug_Group{drug}) ,   StimNumb.(Drug_Group{drug}) );
ylabel('non imposed shocks'); xlabel('# Shock side ripples'); 
subplot(1,2,2)
[R,P]=PlotCorrelations_BM( RipplesNumbWhileFreezing.CondSafe.(Drug_Group{drug}) ,   StimNumb.(Drug_Group{drug}) );
ylabel('non imposed shocks'); xlabel('# Safe side ripples'); hold on

a=suptitle('Correlations of ripples and non imposed shocks​​'); a.FontSize=25;

figure
subplot(1,2,1)
[R,P]=PlotCorrelations_BM( RipplesNumbWhileFreezing.CondShock.(Drug_Group{drug}) , ShockVersusSafe.(Drug_Group{drug})(:,2)' );
ylabel('non imposed shocks'); xlabel('# Shock side ripples'); 
subplot(1,2,2)
[R,P]=PlotCorrelations_BM( RipplesNumbWhileFreezing.CondSafe.(Drug_Group{drug}) , ShockVersusSafe.(Drug_Group{drug})(:,2)' );
ylabel('non imposed shocks'); xlabel('# Safe side ripples'); hold on

a=suptitle('Correlations of ripples and test post times​​'); a.FontSize=25;



%% Drugs comparison
% Overview
figure
Comparison = [mean(FigureFreezeTime.Saline (:,1)) mean(FigureFreezeTime.ChronicFlx(:,1)) mean(FigureFreezeTime.Mdz(:,1)) ; mean(FigureFreezeTime.Saline(:,2)) mean(FigureFreezeTime.ChronicFlx(:,2)) mean(FigureFreezeTime.Mdz(:,2)) ; mean(FigureFreezeTime.Saline(:,3)) mean(FigureFreezeTime.ChronicFlx(:,3)) mean(FigureFreezeTime.Mdz(:,3)) ; mean(FigureFreezeTime.Saline(:,4)) mean(FigureFreezeTime.ChronicFlx(:,4)) mean(FigureFreezeTime.Mdz(:,4))];
bar(Comparison/1e4)
makepretty
legend('saline','flx chronic','mdz')
xticklabels({'All Sessions','Conditionning sessions','Test Post sessions','Extinction sessions'}); xtickangle(45)
ylabel('Freezing time (s)')
title('Drug comparison freezing time')

% Conditioning sessions details
CondFzTimeComparison(:,1)=FreezeTime.Cond.Saline./TotalTime.Cond.Saline;
CondFzTimeComparison(1:6,2)=FreezeTime.Cond.ChronicFlx./TotalTime.Cond.ChronicFlx;
CondFzTimeComparison(1:7,3)=FreezeTime.Cond.Mdz./TotalTime.Cond.Mdz;
CondFzTimeComparison(CondFzTimeComparison==0)=NaN;

for drug=1:length(Drug_Group) % little correction for mice that never freeze on shock side
    FreezeTime.CondShock.(Drug_Group{drug})(FreezeTime.CondShock.(Drug_Group{drug})==0)=0.01;
end

figure
subplot(131)
PlotErrorBarN_KJ(CondFzTimeComparison*100,'newfig',0,'paired',0)
makepretty
xticks([1:3]); xticklabels({'Saline','Flx chronic','Midazolam'}); xtickangle(45)
title('All freezing'); ylabel('Freezing / Total time (%)');
ylim([0 20])

subplot(132)
CondShockZoneFzTimeComparison(:,1)=FreezeTime.CondShock.Saline./TotalTime.CondShock.Saline ;
CondShockZoneFzTimeComparison(1:6,2)=FreezeTime.CondShock.ChronicFlx./TotalTime.CondShock.ChronicFlx;
CondShockZoneFzTimeComparison(1:7,3)=FreezeTime.CondShock.Mdz./TotalTime.CondShock.Mdz;
CondShockZoneFzTimeComparison(CondShockZoneFzTimeComparison==0)=NaN;
PlotErrorBarN_KJ(CondShockZoneFzTimeComparison*100,'newfig',0,'paired',0)
makepretty
xticks([1:3]); xticklabels({'Saline','Flx chronic','Midazolam'}); xtickangle(45)
title('Shock zone freezing')
ylim([0 20])

subplot(133)
CondSafeZoneFzTimeComparison(:,1)=FreezeTime.CondSafe.Saline./TotalTime.CondSafe.Saline ;
CondSafeZoneFzTimeComparison(1:6,2)=FreezeTime.CondSafe.ChronicFlx./TotalTime.CondSafe.ChronicFlx ;
CondSafeZoneFzTimeComparison(1:7,3)=FreezeTime.CondSafe.Mdz./TotalTime.CondSafe.Mdz;
CondSafeZoneFzTimeComparison(CondSafeZoneFzTimeComparison==0)=NaN;
PlotErrorBarN_KJ(CondSafeZoneFzTimeComparison*100,'newfig',0,'paired',0)
makepretty
xticks([1:3]); xticklabels({'Saline','Flx chronic','Midazolam'}); xtickangle(45)
title('Safe zone freezing')
ylim([0 20])

a=suptitle('Freezing proportion for conditioning sessions, drug experiments'); a.FontSize=20;

% Same analysis but only for blocked sessions
CondBlockedFzTimeComparison(:,1)=FreezeTime.CondBlocked.Saline;
CondBlockedFzTimeComparison(1:5,2)=FreezeTime.CondBlocked.ChronicFlx ;
CondBlockedFzTimeComparison(1:7,3)=FreezeTime.CondBlocked.Mdz;
CondBlockedFzTimeComparison(CondBlockedFzTimeComparison==0)=NaN;

for drug=1:length(Drug_Group) % little correction for mice that never freeze on shock side
    FreezeTime.CondBlockedShock.(Drug_Group{drug})(FreezeTime.CondBlockedShock.(Drug_Group{drug})==0)=0.01;
end

figure
subplot(131)
PlotErrorBarN_KJ(CondBlockedFzTimeComparison/1e4,'newfig',0,'paired',0)
makepretty
xticks([1:3]); xticklabels({'Saline','Flx chronic','Midazolam'}); xtickangle(45)
title('All freezing')
% little correction for mice that never freeze on shock side
for drug=1:length(Drug_Group)
    FreezeTime.CondBlockedShock.(Drug_Group{drug})(FreezeTime.CondBlockedShock.(Drug_Group{drug})==0)=0.01;
end

subplot(132)
CondBlockedShockZoneFzTimeComparison(:,1)=FreezeTime.CondBlockedShock.Saline ;
CondBlockedShockZoneFzTimeComparison(1:5,2)=FreezeTime.CondBlockedShock.ChronicFlx ;
CondBlockedShockZoneFzTimeComparison(1:7,3)=FreezeTime.CondBlockedShock.Mdz;
CondBlockedShockZoneFzTimeComparison(CondBlockedShockZoneFzTimeComparison==0)=NaN;
PlotErrorBarN_KJ(CondBlockedShockZoneFzTimeComparison/1e4,'newfig',0,'paired',0)
makepretty; ylim([0 700])
xticks([1:3]); xticklabels({'Saline','Flx chronic','Midazolam'}); xtickangle(45)
title('Shock zone freezing')

subplot(133)
CondBlockedSafeZoneFzTimeComparison(:,1)=FreezeTime.CondBlockedSafe.Saline ;
CondBlockedSafeZoneFzTimeComparison(1:5,2)=FreezeTime.CondBlockedSafe.ChronicFlx ;
CondBlockedSafeZoneFzTimeComparison(1:7,3)=FreezeTime.CondBlockedSafe.Mdz;
CondBlockedSafeZoneFzTimeComparison(CondBlockedSafeZoneFzTimeComparison==0)=NaN;
PlotErrorBarN_KJ(CondBlockedSafeZoneFzTimeComparison/1e4,'newfig',0,'paired',0)
makepretty; ylim([0 700])
xticks([1:3]); xticklabels({'Saline','Flx chronic','Midazolam'}); xtickangle(45)
title('Safe zone freezing')

suptitle('Freezing time for conditioning blocked sessions, drug experiments')












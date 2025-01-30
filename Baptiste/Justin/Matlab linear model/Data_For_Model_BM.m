

clear all
GetAllSalineSessions_BM
GetEmbReactMiceFolderList_BM
Group=22;
Mouse=Drugs_Groups_UMaze_BM(Group);
Session_type={'Cond'};

for sess=1%:length(Session_type)% generate all data required for analyses
        [OutPutData.(Session_type{sess}) , Epoch1.(Session_type{sess}) , NameEpoch] = ...
    MeanValuesPhysiologicalParameters_BM('all_saline',Mouse,lower(Session_type{sess}),'respi_freq_bm','ripples','linearposition');
    %     [OutPutData.(Session_type{sess}) , Epoch1.(Session_type{sess}) , NameEpoch] = ...
    %         MeanValuesPhysiologicalParameters_BM('all_saline',Mouse,lower(Session_type{sess}),'instfreq_wv','ripples','linearposition');
%     [OutPutData.(Session_type{sess}) , Epoch1.(Session_type{sess}) , NameEpoch] = ...
%         MeanValuesPhysiologicalParameters_BM('drugs',Mouse,lower(Session_type{sess}),'respi_freq_bm','ripples','linearposition');
end

clearvars -except OutPutData Epoch1 CondSess FearSess NameEpoch Session_type Group A

Mouse=Drugs_Groups_UMaze_BM(Group);
for sess=1:length(Session_type)
    Sessions_List_ForLoop_BM
    for mouse=1:length(Mouse)
        try
            Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
            i=1;
            clear ep ind_to_use
            
            BlockedEpoch.(Session_type{sess}).(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}),'epoch','epochname','blockedepoch');
            try
                TotEpoch.(Session_type{sess}).(Mouse_names{mouse}) = intervalSet(0,max(Range(OutPutData.(Session_type{sess}).instfreq_wv.tsd{mouse,1})));
            catch
                TotEpoch.(Session_type{sess}).(Mouse_names{mouse}) = intervalSet(0,max(Range(OutPutData.(Session_type{sess}).respi_freq_bm.tsd{mouse,1})));
            end
            UnblockedEpoch.(Session_type{sess}).(Mouse_names{mouse}) = TotEpoch.(Session_type{sess}).(Mouse_names{mouse}) - BlockedEpoch.(Session_type{sess}).(Mouse_names{mouse});
            
            ShockZoneEpoch.(Session_type{sess}).(Mouse_names{mouse}) = and(Epoch1.(Session_type{sess}){mouse,7} , UnblockedEpoch.(Session_type{sess}).(Mouse_names{mouse}));
            SafeZoneEpoch.(Session_type{sess}).(Mouse_names{mouse}) = and(Epoch1.(Session_type{sess}){mouse,8} , UnblockedEpoch.(Session_type{sess}).(Mouse_names{mouse}));
            [ShockZoneEpoch_Corrected.(Session_type{sess}).(Mouse_names{mouse}) , SafeZoneEpoch_Corrected.(Session_type{sess}).(Mouse_names{mouse})] =...
                Correct_ZoneEntries_Maze_BM(ShockZoneEpoch.(Session_type{sess}).(Mouse_names{mouse}) , SafeZoneEpoch.(Session_type{sess}).(Mouse_names{mouse}));
            
            EyelidTimes.(Session_type{sess}).(Mouse_names{mouse}) = Start(Epoch1.(Session_type{sess}){mouse,2});
            ShockZoneTimes.(Session_type{sess}).(Mouse_names{mouse}) = Start(ShockZoneEpoch_Corrected.(Session_type{sess}).(Mouse_names{mouse}));
            
            for ep=1:length(Start(Epoch1.(Session_type{sess}){mouse, 3}))
                ShockTime_Fz_Distance_pre.(Session_type{sess}).(Mouse_names{mouse}) = Start(Epoch1.(Session_type{sess}){mouse, 2})-Start(subset(Epoch1.(Session_type{sess}){mouse, 3},ep));
                
                ShockTime_Fz_Distance.(Session_type{sess}).(Mouse_names{mouse}) = abs(max(ShockTime_Fz_Distance_pre.(Session_type{sess}).(Mouse_names{mouse})(ShockTime_Fz_Distance_pre.(Session_type{sess}).(Mouse_names{mouse})<0))/1e4);
                if isempty(ShockTime_Fz_Distance.(Session_type{sess}).(Mouse_names{mouse})); ShockTime_Fz_Distance.(Session_type{sess}).(Mouse_names{mouse})=NaN; end
                
                for bin=1:ceil(((DurationEpoch(subset(Epoch1.(Session_type{sess}){mouse, 3},ep)))/1e4)/2)-1 % bin of 2s or less
                    
                    SmallEpoch.(Session_type{sess}).(Mouse_names{mouse}) = intervalSet(Start(subset(Epoch1.(Session_type{sess}){mouse, 3},ep))+2*(bin-1)*1e4 , Start(subset(Epoch1.(Session_type{sess}){mouse, 3},ep))+2*(bin)*1e4);
                    PositionArray.(Session_type{sess}).(Mouse_names{mouse})(i) = nanmean(Data(Restrict(OutPutData.(Session_type{sess}).linearposition.tsd{mouse, 1} , SmallEpoch.(Session_type{sess}).(Mouse_names{mouse}))));
                    try
                        OB_FrequencyArray.(Session_type{sess}).(Mouse_names{mouse})(i) = nanmean(Data(Restrict(OutPutData.(Session_type{sess}).instfreq_wv.tsd{mouse, 1} , SmallEpoch.(Session_type{sess}).(Mouse_names{mouse}))));
                    catch
                        OB_FrequencyArray.(Session_type{sess}).(Mouse_names{mouse})(i) = nanmean(Data(Restrict(OutPutData.(Session_type{sess}).respi_freq_bm.tsd{mouse, 1} , SmallEpoch.(Session_type{sess}).(Mouse_names{mouse}))));
                    end
                    try RipplesDensityArray.(Session_type{sess}).(Mouse_names{mouse})(i) = sum(length(Data(Restrict(OutPutData.(Session_type{sess}).ripples.ts{mouse,1}, SmallEpoch.(Session_type{sess}).(Mouse_names{mouse})))))/2; end
                    try RipplesNumberArray.(Session_type{sess}).(Mouse_names{mouse})(i) = sum(length(Data(Restrict(OutPutData.(Session_type{sess}).ripples.ts{mouse,1}, SmallEpoch.(Session_type{sess}).(Mouse_names{mouse}))))); end
                    GlobalTimeArray.(Session_type{sess}).(Mouse_names{mouse})(i) = Start(subset(Epoch1.(Session_type{sess}){mouse, 3},ep))/1e4+2*(bin-1);
                    TimeSinceLastShockArray.(Session_type{sess}).(Mouse_names{mouse})(i) = ShockTime_Fz_Distance.(Session_type{sess}).(Mouse_names{mouse})+2*(bin-1);
                    TimepentFreezing.(Session_type{sess}).(Mouse_names{mouse})(i) = 2*(bin-1);
                    try
                        R = Range(Restrict(OutPutData.(Session_type{sess}).linearposition.tsd{mouse,1} , SmallEpoch.(Session_type{sess}).(Mouse_names{mouse})));
                        EyelidNumber.(Session_type{sess}).(Mouse_names{mouse})(i) = sum(EyelidTimes.(Session_type{sess}).(Mouse_names{mouse})<R(1));
                        ShockZoneNumber.(Session_type{sess}).(Mouse_names{mouse})(i) = sum(ShockZoneTimes.(Session_type{sess}).(Mouse_names{mouse})<R(1));
                    catch
                        EyelidNumber.(Session_type{sess}).(Mouse_names{mouse})(i) = EyelidNumber.(Session_type{sess}).(Mouse_names{mouse})(i-1);
                        ShockZoneNumber.(Session_type{sess}).(Mouse_names{mouse})(i) = ShockZoneNumber.(Session_type{sess}).(Mouse_names{mouse})(i-1);
                    end
                    
                    i=i+1;
                end
                
                ind_to_use = ceil(((DurationEpoch(subset(Epoch1.(Session_type{sess}){mouse, 3},ep)))/1e4)/2)-1; % se(Session_type{sess}) to last freezing episode indice
                
                SmallEpoch.(Session_type{sess}).(Mouse_names{mouse}) = intervalSet(Start(subset(Epoch1.(Session_type{sess}){mouse, 3},ep))+2*(ind_to_use)*1e4 , Stop(subset(Epoch1.(Session_type{sess}){mouse, 3},ep))); % last small epoch is a bin with time < 2s
                PositionArray.(Session_type{sess}).(Mouse_names{mouse})(i) = nanmean(Data(Restrict(OutPutData.(Session_type{sess}).linearposition.tsd{mouse, 1} , SmallEpoch.(Session_type{sess}).(Mouse_names{mouse}))));
                try
                    OB_FrequencyArray.(Session_type{sess}).(Mouse_names{mouse})(i) = nanmean(Data(Restrict(OutPutData.(Session_type{sess}).respi_freq_bm.tsd{mouse, 1} , SmallEpoch.(Session_type{sess}).(Mouse_names{mouse}))));
                catch
                    OB_FrequencyArray.(Session_type{sess}).(Mouse_names{mouse})(i) = nanmean(Data(Restrict(OutPutData.(Session_type{sess}).instfreq_wv.tsd{mouse, 1} , SmallEpoch.(Session_type{sess}).(Mouse_names{mouse}))));
                end
                try RipplesDensityArray.(Session_type{sess}).(Mouse_names{mouse})(i) = sum(length(Data(Restrict(OutPutData.(Session_type{sess}).ripples.ts{mouse,1}, SmallEpoch.(Session_type{sess}).(Mouse_names{mouse})))))/(DurationEpoch(SmallEpoch.(Session_type{sess}).(Mouse_names{mouse}))/2e4); end
                try RipplesNumberArray.(Session_type{sess}).(Mouse_names{mouse})(i) = sum(length(Data(Restrict(OutPutData.(Session_type{sess}).ripples.ts{mouse,1}, SmallEpoch.(Session_type{sess}).(Mouse_names{mouse}))))); end
                GlobalTimeArray.(Session_type{sess}).(Mouse_names{mouse})(i) = Start(subset(Epoch1.(Session_type{sess}){mouse, 3},ep))/1e4+2*(ind_to_use);
                TimeSinceLastShockArray.(Session_type{sess}).(Mouse_names{mouse})(i) = ShockTime_Fz_Distance.(Session_type{sess}).(Mouse_names{mouse})+2*(ind_to_use);
                try; TimepentFreezing.(Session_type{sess}).(Mouse_names{mouse})(i) = 2*bin; catch; TimepentFreezing.(Session_type{sess}).(Mouse_names{mouse})(i) = 0; end
                try
                    R = Range(Restrict(OutPutData.(Session_type{sess}).linearposition.tsd{mouse,1} , SmallEpoch.(Session_type{sess}).(Mouse_names{mouse})));
                    EyelidNumber.(Session_type{sess}).(Mouse_names{mouse})(i) = sum(EyelidTimes.(Session_type{sess}).(Mouse_names{mouse})<R(1));
                    ShockZoneNumber.(Session_type{sess}).(Mouse_names{mouse})(i) = sum(ShockZoneTimes.(Session_type{sess}).(Mouse_names{mouse})<R(1));
                catch
                    EyelidNumber.(Session_type{sess}).(Mouse_names{mouse})(i) = EyelidNumber.(Session_type{sess}).(Mouse_names{mouse})(i-1);
                    ShockZoneNumber.(Session_type{sess}).(Mouse_names{mouse})(i) = ShockZoneNumber.(Session_type{sess}).(Mouse_names{mouse})(i-1);
                end
                
                i=i+1;
                
            end
            
            Timefreezing_cumul.(Session_type{sess}).(Mouse_names{mouse})(1) = 0;
            for j=2:length(TimepentFreezing.(Session_type{sess}).(Mouse_names{mouse}))
                if TimepentFreezing.(Session_type{sess}).(Mouse_names{mouse})(j) == 0
                    Timefreezing_cumul.(Session_type{sess}).(Mouse_names{mouse})(j) = Timefreezing_cumul.(Session_type{sess}).(Mouse_names{mouse})(j-1);
                else
                    Timefreezing_cumul.(Session_type{sess}).(Mouse_names{mouse})(j) = Timefreezing_cumul.(Session_type{sess}).(Mouse_names{mouse})(j-1) + 2;
                end
            end
            
            try
                TotalArray_mouse.(Session_type{sess}).(Mouse_names{mouse}) = [OB_FrequencyArray.(Session_type{sess}).(Mouse_names{mouse})' PositionArray.(Session_type{sess}).(Mouse_names{mouse})' ...
                    GlobalTimeArray.(Session_type{sess}).(Mouse_names{mouse})' TimeSinceLastShockArray.(Session_type{sess}).(Mouse_names{mouse})' TimepentFreezing.(Session_type{sess}).(Mouse_names{mouse})'...
                    Timefreezing_cumul.(Session_type{sess}).(Mouse_names{mouse})' EyelidNumber.(Session_type{sess}).(Mouse_names{mouse})' ShockZoneNumber.(Session_type{sess}).(Mouse_names{mouse})'...
                    RipplesNumberArray.(Session_type{sess}).(Mouse_names{mouse})'];
            catch
                TotalArray_mouse.(Session_type{sess}).(Mouse_names{mouse}) = [OB_FrequencyArray.(Session_type{sess}).(Mouse_names{mouse})' PositionArray.(Session_type{sess}).(Mouse_names{mouse})' ...
                    GlobalTimeArray.(Session_type{sess}).(Mouse_names{mouse})' TimeSinceLastShockArray.(Session_type{sess}).(Mouse_names{mouse})' TimepentFreezing.(Session_type{sess}).(Mouse_names{mouse})'...
                    Timefreezing_cumul.(Session_type{sess}).(Mouse_names{mouse})' EyelidNumber.(Session_type{sess}).(Mouse_names{mouse})' ShockZoneNumber.(Session_type{sess}).(Mouse_names{mouse})'...
                    ];
            end
            disp(Mouse_names{mouse})
        end
    end
end

DATA = TotalArray_mouse;
Name = {'OB frequency','Position','Global Time','Time since last shock','Time spent freezing',...
'Time spent freezing cumul','EyelidNumber','ShockZoneNumber','RipplesNumber'};

save('/home/ratatouille/Dropbox/Mobs_member/BaptisteMaheo/Data/Data_KB/Data_Model_30112023.mat','DATA','Name')
save('/home/ratatouille/Dropbox/Mobs_member/BaptisteMaheo/Data/Data_KB/Data_Model_DZP.mat','DATA','Name')
save('/home/ratatouille/Dropbox/Mobs_member/BaptisteMaheo/Data/Data_KB/Data_Model_AllSaline.mat','DATA','Name')


save('/home/ratatouille/Dropbox/Mobs_member/BaptisteMaheo/Data/Data_KB/Data_Model_AllSaline_WV.mat','DATA','Name')
























%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%




Mouse=[688 739 777 779 849 893];
% bin de freezing tous les 2s et avoir
% sa fréquence et d'associer à chaque bin
% la position normalisée,
% le temps global dans le conditionnement (qui sert pour situer dans l'apprentissage) et
% le temps depuis le dernier choc.


Session_type={'Cond'};
for sess=1:length(Session_type) % generate all data required for analyses
    [OutPutData.(Session_type{sess}) , Epoch1.(Session_type{sess}) , NameEpoch] = MeanValuesPhysiologicalParameters_BM('drugs',Mouse,lower(Session_type{sess}),'respi_freq_BM','linearposition');
end


i=1;
for ep=1:length(Start(Epoch1.Cond{1, 3}))
    ShockTime_Fz_Distance_pre = Start(Epoch1.Cond{1, 2})-Start(subset(Epoch1.Cond{1, 3},ep));
    ShockTime_Fz_Distance = abs(max(ShockTime_Fz_Distance_pre(ShockTime_Fz_Distance_pre<0))/1e4);
    if isempty(ShockTime_Fz_Distance); ShockTime_Fz_Distance=NaN; end
    
    for bin=1:ceil((sum(Stop(subset(Epoch1.Cond{1, 3},ep))-Start(subset(Epoch1.Cond{1, 3},ep)))/1e4)/2)-1 % bin of 2s or less
        
        SmallEpoch = intervalSet(Start(subset(Epoch1.Cond{1, 3},ep))+2*(bin-1)*1e4 , Start(subset(Epoch1.Cond{1, 3},ep))+2*(bin)*1e4);
        PositionArray(i) = nanmean(Data(Restrict(OutPutData.Cond.linearposition.tsd{1, 1} , SmallEpoch)));
        OB_FrequencyArray(i) = nanmean(Data(Restrict(OutPutData.Cond.respi_freq_BM.tsd{1, 1} , SmallEpoch)));
        GlobalTimeArray(i) = Start(subset(Epoch1.Cond{1, 3},ep))/1e4+2*(bin-1);
        TimeSinceLastShockArray(i) = ShockTime_Fz_Distance+2*(bin-1);
        TimepentFreezing(i) = 2*(bin-1);
        i=i+1;
    end
    
    ind_to_use = ceil((sum(Stop(subset(Epoch1.Cond{1, 3},ep))-Start(subset(Epoch1.Cond{1, 3},ep)))/1e4)/2)-1; % second to last freezing episode indice
    
    SmallEpoch = intervalSet(Start(subset(Epoch1.Cond{1, 3},ep))+2*(ind_to_use)*1e4 , Stop(subset(Epoch1.Cond{1, 3},ep))); % last small epoch is a bin with time < 2s
    PositionArray(i) = nanmean(Data(Restrict(OutPutData.Cond.linearposition.tsd{1, 1} , SmallEpoch)));
    OB_FrequencyArray(i) = nanmean(Data(Restrict(OutPutData.Cond.respi_freq_BM.tsd{1, 1} , SmallEpoch)));
    GlobalTimeArray(i) = Start(subset(Epoch1.Cond{1, 3},ep))/1e4+2*(ind_to_use);
    TimeSinceLastShockArray(i) = ShockTime_Fz_Distance+2*(ind_to_use);
    try; TimepentFreezing(i) = 2*bin; catch; TimepentFreezing(i) = 0; end
    
    i=i+1;
    
end

TotalArray = [OB_FrequencyArray' PositionArray' GlobalTimeArray' TimeSinceLastShockArray' TimepentFreezing'];

%
% % Descente de gradient
% Ensuite on essaie de fitter nos 7 paramètres pour prédire à partir des 3 entrées la fréquence du OB.
% Il faudra faire ça par descente de gradient, malheureusement ce n'est pas un système linéaire donc on ne peut pas faire une régression directe.
% Il y a des familles de fonction Matlab pour faire ça (fmincon, fminunc...), je pense que ça devrait aller parce qu'on sait à peu près quelles vont être les bonnes valeurs (parce qu'on connait le range de valeurs pour le OB par exemple) donc on peut faire partir la recherche de paramètres d'un point de départ qui sera pas trop loin de l'optimum et on pourrai bien restreindre pour éviter que ça diverge.

OBFreq_Shock = (1-AlphaLearn) .* ((MaxFreqSk - MinFreqSk) *exp([(-[0:10] -TimeToShock)]/Tau) + MinFreqSk);
OBFreq_Pos = (AlphaLearn) .* ((MaxFreqPos*Pos - MinFreqPos) *Pos + MinFreqPos);
OBFreq_Tot = OBFreq_Shock + OBFreq_Pos;
Learning = 1./(1+exp(-LearnSlope*([0:1500]-LearnPoint)));




OBFreq_Tot = @(x)(1-1./(1+exp(-x(7)*([0:1500]-x(6))))) .* ((x(1) - x(2)) *exp([(-[0:10] -TimeToShock)]/x(3)) + x(2)) + (1./(1+exp(-x(7)*([0:1500]-x(6))))) .* ((x(4)*Pos - x(5)) *Pos + x(5));


fun = @(x)TotalArray(:,1).*(x(2)-x(1)^2) + (1-x(1).*TotalArray(:,2));
x0 = [-1,2];
x = fmincon(fun,x0)


edit FitLaserStims
edit FitTheDataKernal
edit ErrorModelLaserAlphaFunction



figure
subplot(411)
plot(TotalArray(:,1))
subplot(412)
plot(TotalArray(:,2))
subplot(413)
plot(TotalArray(:,3))
subplot(414)
plot(TotalArray(:,4))



fun = @(x)3*x(1)^2 + 2*x(1)*x(2) + x(2)^2 - 4*x(1) + 5*x(2);


x0 = [1,1];
[x,fval] = fminunc(fun,x0)

figure
plot(Range(OutPutData.Fear.linearposition.tsd{1, 1}) , Data(OutPutData.Fear.linearposition.tsd{1, 1}))
hold on
plot(Range(OutPutData.Fear.linearposition.tsd{1, 3}) , Data(OutPutData.Fear.linearposition.tsd{1, 3}))



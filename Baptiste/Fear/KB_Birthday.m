

%% Look at TestPost and CondAfter1 OB rythm during freezing

load('Sess.mat','Sess')

Mouse=[688 739 777 779 849 893 875 876 877 1001 1002 1095 1131 11184 11147 11200];

for mouse = [14:16]%1:length(Mouse) % generate all sessions of interest
    Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
end
Sess.(Mouse_names{mouse}) = GetAllMouseTaskSessions(Mouse(mouse));
    TestPostSess.(Mouse_names{mouse}) = Sess.(Mouse_names{mouse})(find(not(cellfun(@isempty,strfind(Sess.(Mouse_names{mouse}) ,'TestPost')))));
    TestSess.(Mouse_names{mouse}) = Sess.(Mouse_names{mouse})(find(not(cellfun(@isempty,strfind(Sess.(Mouse_names{mouse}) ,'Test')))));
    CondSess.(Mouse_names{mouse}) = Sess.(Mouse_names{mouse})(find(not(cellfun(@isempty,strfind(Sess.(Mouse_names{mouse}) ,'Cond')))));
    CondSessCorrections
    ExtSess.(Mouse_names{mouse}) = Sess.(Mouse_names{mouse})(find(not(cellfun(@isempty,strfind(Sess.(Mouse_names{mouse}) ,'Ext')))));
    Get_First_AfterCond_Sess
    FearSess.(Mouse_names{mouse}) =  [CondSess.(Mouse_names{mouse}) ExtSess.(Mouse_names{mouse})];
    TestPreSess.(Mouse_names{mouse}) = Sess.(Mouse_names{mouse})(find(not(cellfun(@isempty,strfind(Sess.(Mouse_names{mouse}) ,'TestPre')))));
end


Session_type={'TestPostSess','FirstAfterCondSess','ExtSess'};

for mouse = 1:length(Mouse_names)
    for sess=1:length(Session_type)
        if sess==1; Sess_To_use = TestPostSess.(Mouse_names{mouse});
        else Sess_To_use = FirstAfterCondSess.(Mouse_names{mouse});
        end
        
        OBSpec.(Session_type{sess}).(Mouse_names{mouse})=ConcatenateDataFromFolders_SB(Sess_To_use,'spectrum','prefix','B_Low');
        Freeze_Epoch.(Session_type{sess}).(Mouse_names{mouse})=ConcatenateDataFromFolders_SB(Sess_To_use,'Epoch','epochname','freezeepoch');
        ZoneEpoch.(Session_type{sess}).(Mouse_names{mouse})=ConcatenateDataFromFolders_SB(Sess_To_use,'Epoch','epochname','zoneepoch');
        
        ShockEpoch.(Session_type{sess}).(Mouse_names{mouse}) = ZoneEpoch.(Session_type{sess}).(Mouse_names{mouse}){1};
        SafeEpoch.(Session_type{sess}).(Mouse_names{mouse}) = or(ZoneEpoch.(Session_type{sess}).(Mouse_names{mouse}){2},ZoneEpoch.(Session_type{sess}).(Mouse_names{mouse}){5});
        
        OBSpec.(Session_type{sess}).Fz.(Mouse_names{mouse})=Restrict(OBSpec.(Session_type{sess}).(Mouse_names{mouse}),Freeze_Epoch.(Session_type{sess}).(Mouse_names{mouse}));
        OBSpec.(Session_type{sess}).Fz_Shock.(Mouse_names{mouse})=Restrict(OBSpec.(Session_type{sess}).Fz.(Mouse_names{mouse}),ShockEpoch.(Session_type{sess}).(Mouse_names{mouse}) );
        OBSpec.(Session_type{sess}).Fz_Safe.(Mouse_names{mouse})=Restrict(OBSpec.(Session_type{sess}).Fz.(Mouse_names{mouse}),SafeEpoch.(Session_type{sess}).(Mouse_names{mouse}));
        
        %Times
        TimeSpent.(Session_type{sess}).Fz_Shock.(Mouse_names{mouse})=sum( Stop(and(Freeze_Epoch.(Session_type{sess}).(Mouse_names{mouse}) , ShockEpoch.(Session_type{sess}).(Mouse_names{mouse}) )) - Start(and(Freeze_Epoch.(Session_type{sess}).(Mouse_names{mouse}) , ShockEpoch.(Session_type{sess}).(Mouse_names{mouse}) )))/1e4;
        TimeSpent.(Session_type{sess}).Fz_Safe.(Mouse_names{mouse})=sum( Stop(and(Freeze_Epoch.(Session_type{sess}).(Mouse_names{mouse}) , SafeEpoch.(Session_type{sess}).(Mouse_names{mouse}) )) - Start(and(Freeze_Epoch.(Session_type{sess}).(Mouse_names{mouse}) , SafeEpoch.(Session_type{sess}).(Mouse_names{mouse}) )))/1e4;
        
    end
end


Drug_Group={'Saline','ChronicFlx','Diazepam'};
noise_thr=12;
for group=1:length(Drug_Group)
    
    if group==1 % saline mice
        Mouse_names={'M688','M739','M777','M779','M849','M893'}; % add 1096
        Mouse=[688 739 777 779 849 893];
    elseif group==2 % chronic flx mice
        Mouse_names={'M875','M876','M877','M1001','M1002','M1095'};
        Mouse=[875 876 877 1001 1002 1095];    
    elseif group==3 % chronic flx mice
        Mouse_names={'M11184','M11147','M11200'};
        Mouse=[11184 11147 11200];
    end
    
    for sess=1:length(Session_type)
        for mouse=1:length(Mouse_names)
            try
                AllSpectrum.(Drug_Group{group}).(Session_type{sess}).Shock(mouse,:) = nanmean(zscore_nan_BM(Data(OBSpec.(Session_type{sess}).Fz_Shock.(Mouse_names{mouse}))')') ;
                AllSpectrum.(Drug_Group{group}).(Session_type{sess}).Safe(mouse,:) = nanmean(zscore_nan_BM(Data(OBSpec.(Session_type{sess}).Fz_Safe.(Mouse_names{mouse}))')') ;
            end
        end
    end
end

figure
plot(nanmean(zscore_nan_BM(Data(OBSpec.(Session_type{sess}).Fz_Shock.(Mouse_names{mouse}))')'))


% Test Post
figure; sess=2; group=1;
subplot(131)
Conf_Inter=nanstd(AllSpectrum.(Drug_Group{group}).(Session_type{sess}).Shock)/sqrt(size(AllSpectrum.(Drug_Group{group}).(Session_type{sess}).Shock,1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(AllSpectrum.(Drug_Group{group}).(Session_type{sess}).Shock);
shadedErrorBar(Spectro{3},Mean_All_Sp/max(Mean_All_Sp),Conf_Inter/max(Mean_All_Sp),'-r',1); hold on;
Conf_Inter=nanstd(AllSpectrum.(Drug_Group{group}).(Session_type{sess}).Safe)/sqrt(size(AllSpectrum.(Drug_Group{group}).(Session_type{sess}).Safe,1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(AllSpectrum.(Drug_Group{group}).(Session_type{sess}).Safe);
h=shadedErrorBar(Spectro{3},Mean_All_Sp/max(Mean_All_Sp),Conf_Inter/max(Mean_All_Sp),'-b',1); hold on;
makepretty;
xlabel('Frequency (Hz)'); ylabel('Power (A.U.)'); xlim([0 10]);
[c,d]=max(nanmean(AllSpectrum.(Drug_Group{group}).(Session_type{sess}).Shock));
vline(Spectro{3}(d),'--r')
[c,d]=max(nanmean(AllSpectrum.(Drug_Group{group}).(Session_type{sess}).Safe(:,26:end)));
vline(Spectro{3}(d+25),'--b')
f=get(gca,'Children');
legend([f(5),f(1)],'Shock side freezing','Safe side freezing')
%title('mean OB spectrum for all mice')

subplot(132); sess=2; group=2;
Conf_Inter=nanstd(AllSpectrum.(Drug_Group{group}).(Session_type{sess}).Shock)/sqrt(size(AllSpectrum.(Drug_Group{group}).(Session_type{sess}).Shock,1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(AllSpectrum.(Drug_Group{group}).(Session_type{sess}).Shock);
shadedErrorBar(Spectro{3},Mean_All_Sp/max(Mean_All_Sp),Conf_Inter/max(Mean_All_Sp),'-r',1); hold on;
Conf_Inter=nanstd(AllSpectrum.(Drug_Group{group}).(Session_type{sess}).Safe)/sqrt(size(AllSpectrum.(Drug_Group{group}).(Session_type{sess}).Safe,1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(AllSpectrum.(Drug_Group{group}).(Session_type{sess}).Safe);
h=shadedErrorBar(Spectro{3},Mean_All_Sp/max(Mean_All_Sp),Conf_Inter/max(Mean_All_Sp),'-b',1); hold on;
makepretty;
xlabel('Frequency (Hz)'); ylabel('Power (A.U.)'); xlim([0 10]);
[c,d]=max(nanmean(AllSpectrum.(Drug_Group{group}).(Session_type{sess}).Shock));
vline(Spectro{3}(d),'--r')
[c,d]=max(nanmean(AllSpectrum.(Drug_Group{group}).(Session_type{sess}).Safe(:,26:end)));
vline(Spectro{3}(d+25),'--b')
title('mean OB spectrum for all mice')

subplot(133); sess=2; group=3;
Conf_Inter=nanstd(AllSpectrum.(Drug_Group{group}).(Session_type{sess}).Shock)/sqrt(size(AllSpectrum.(Drug_Group{group}).(Session_type{sess}).Shock,1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(AllSpectrum.(Drug_Group{group}).(Session_type{sess}).Shock);
shadedErrorBar(Spectro{3},Mean_All_Sp/max(Mean_All_Sp),Conf_Inter/max(Mean_All_Sp),'-r',1); hold on;
Conf_Inter=nanstd(AllSpectrum.(Drug_Group{group}).(Session_type{sess}).Safe)/sqrt(size(AllSpectrum.(Drug_Group{group}).(Session_type{sess}).Safe,1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(AllSpectrum.(Drug_Group{group}).(Session_type{sess}).Safe);
h=shadedErrorBar(Spectro{3},Mean_All_Sp/max(Mean_All_Sp),Conf_Inter/max(Mean_All_Sp),'-b',1); hold on;
makepretty;
xlabel('Frequency (Hz)'); ylabel('Power (A.U.)'); xlim([0 10]);
[c,d]=max(nanmean(AllSpectrum.(Drug_Group{group}).(Session_type{sess}).Shock));
vline(Spectro{3}(d),'--r')
[c,d]=max(nanmean(AllSpectrum.(Drug_Group{group}).(Session_type{sess}).Safe(:,26:end)));
vline(Spectro{3}(d+25),'--b')
title('mean OB spectrum for all mice')







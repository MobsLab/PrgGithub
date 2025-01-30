
function Preliminary_Analysis_OBSpectrum_Freezing_BM(Mouse_numb)

Session_type={'Fear','Cond','Ext'};

GetEmbReactMiceFolderList_BM
GetAllSalineSessions_BM
Mouse=Mouse_numb; clear Mouse_names
for mouse=1:length(Mouse)
    Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
end

for mouse = 1:length(Mouse_names)
    for sess=1:length(Session_type)
        if sess==1; Sess_To_use=FearSess.(Mouse_names{mouse});
        elseif sess==2; Sess_To_use=CondSess.(Mouse_names{mouse});
        else Sess_To_use=ExtSess.(Mouse_names{mouse});
        end
        Acc.(Session_type{sess}).(Mouse_names{mouse})=ConcatenateDataFromFolders_SB(Sess_To_use,'accelero');
        
        OBSpec.(Session_type{sess}).(Mouse_names{mouse})=ConcatenateDataFromFolders_SB(Sess_To_use,'spectrum','prefix','B_Low');
        Freeze_Epoch.(Session_type{sess}).(Mouse_names{mouse})=ConcatenateDataFromFolders_SB(Sess_To_use,'Epoch','epochname','freezeepoch');
        ZoneEpoch.(Session_type{sess}).(Mouse_names{mouse})=ConcatenateDataFromFolders_SB(Sess_To_use,'Epoch','epochname','zoneepoch');
        
        ShockEpoch.(Session_type{sess}).(Mouse_names{mouse}) = ZoneEpoch.(Session_type{sess}).(Mouse_names{mouse}){1};
        SafeEpoch.(Session_type{sess}).(Mouse_names{mouse}) = or(ZoneEpoch.(Session_type{sess}).(Mouse_names{mouse}){2},ZoneEpoch.(Session_type{sess}).(Mouse_names{mouse}){5});
        
        OBSpec.(Session_type{sess}).Fz.(Mouse_names{mouse})=Restrict(OBSpec.(Session_type{sess}).(Mouse_names{mouse}),Freeze_Epoch.(Session_type{sess}).(Mouse_names{mouse}));
        OBSpec.(Session_type{sess}).Fz_Shock.(Mouse_names{mouse})=Restrict(OBSpec.(Session_type{sess}).Fz.(Mouse_names{mouse}),ShockEpoch.(Session_type{sess}).(Mouse_names{mouse}) );
        OBSpec.(Session_type{sess}).Fz_Safe.(Mouse_names{mouse})=Restrict(OBSpec.(Session_type{sess}).Fz.(Mouse_names{mouse}),SafeEpoch.(Session_type{sess}).(Mouse_names{mouse}));
        
        try
            % Heart Rate
            HRConcat.(Session_type{sess}).(Mouse_names{mouse})=ConcatenateDataFromFolders_SB(Sess_To_use,'heartrate');
            HRVarConcat.(Session_type{sess}).(Mouse_names{mouse})=ConcatenateDataFromFolders_SB(Sess_To_use,'heartratevar');
            
            HR_Freeze.(Session_type{sess}).(Mouse_names{mouse}) = Restrict(HRConcat.(Session_type{sess}).(Mouse_names{mouse}),Freeze_Epoch.(Session_type{sess}).(Mouse_names{mouse}));
            HR_Freeze.(Session_type{sess}).Shock.(Mouse_names{mouse}) = Restrict(HR_Freeze.(Session_type{sess}).(Mouse_names{mouse}),ShockEpoch.(Session_type{sess}).(Mouse_names{mouse}));
            HR_Freeze.(Session_type{sess}).Safe.(Mouse_names{mouse}) = Restrict(HR_Freeze.(Session_type{sess}).(Mouse_names{mouse}),SafeEpoch.(Session_type{sess}).(Mouse_names{mouse}));
            
            HRVar_Freeze.(Session_type{sess}).(Mouse_names{mouse}) = Restrict(HRVarConcat.(Session_type{sess}).(Mouse_names{mouse}),Freeze_Epoch.(Session_type{sess}).(Mouse_names{mouse}));
            HRVar_Freeze.(Session_type{sess}).Shock.(Mouse_names{mouse}) = Restrict(HRVar_Freeze.(Session_type{sess}).(Mouse_names{mouse}),ShockEpoch.(Session_type{sess}).(Mouse_names{mouse}));
            HRVar_Freeze.(Session_type{sess}).Safe.(Mouse_names{mouse}) = Restrict(HRVar_Freeze.(Session_type{sess}).(Mouse_names{mouse}),SafeEpoch.(Session_type{sess}).(Mouse_names{mouse}));
        end
        try
            RipplesConcat.(Session_type{sess}).(Mouse_names{mouse})=ConcatenateDataFromFolders_SB(Sess_To_use,'ripples');
            Ripples_Freeze.(Session_type{sess}).(Mouse_names{mouse}) = Restrict(RipplesConcat.(Session_type{sess}).(Mouse_names{mouse}),Freeze_Epoch.(Session_type{sess}).(Mouse_names{mouse}));
            Ripples_Freeze.(Session_type{sess}).Shock.(Mouse_names{mouse}) = Restrict(Ripples_Freeze.(Session_type{sess}).(Mouse_names{mouse}),ShockEpoch.(Session_type{sess}).(Mouse_names{mouse}));
            Ripples_Freeze.(Session_type{sess}).Safe.(Mouse_names{mouse}) = Restrict(Ripples_Freeze.(Session_type{sess}).(Mouse_names{mouse}),SafeEpoch.(Session_type{sess}).(Mouse_names{mouse}));
        end
        % Times
        TimeSpent.(Session_type{sess}).Fz_Shock.(Mouse_names{mouse})=sum( Stop(and(Freeze_Epoch.(Session_type{sess}).(Mouse_names{mouse}) , ShockEpoch.(Session_type{sess}).(Mouse_names{mouse}) )) - Start(and(Freeze_Epoch.(Session_type{sess}).(Mouse_names{mouse}) , ShockEpoch.(Session_type{sess}).(Mouse_names{mouse}) )))/1e4;
        TimeSpent.(Session_type{sess}).Fz_Safe.(Mouse_names{mouse})=sum( Stop(and(Freeze_Epoch.(Session_type{sess}).(Mouse_names{mouse}) , SafeEpoch.(Session_type{sess}).(Mouse_names{mouse}) )) - Start(and(Freeze_Epoch.(Session_type{sess}).(Mouse_names{mouse}) , SafeEpoch.(Session_type{sess}).(Mouse_names{mouse}) )))/1e4;
        
    end
    
    % Test Pre/Post
    try
        ZoneEpoch.TestPre.(Mouse_names{mouse})=ConcatenateDataFromFolders_SB(TestPreSess.(Mouse_names{mouse}),'Epoch','epochname','zoneepoch');
        ShockEpoch.TestPre.(Mouse_names{mouse}) = or(ZoneEpoch.TestPre.(Mouse_names{mouse}){1},ZoneEpoch.TestPre.(Mouse_names{mouse}){4});
        SafeEpoch.TestPre.(Mouse_names{mouse}) = or(ZoneEpoch.TestPre.(Mouse_names{mouse}){2},ZoneEpoch.TestPre.(Mouse_names{mouse}){5});
        ShockZonePreTime.(Mouse_names{mouse})=sum(Stop(ShockEpoch.TestPre.(Mouse_names{mouse}))-Start(ShockEpoch.TestPre.(Mouse_names{mouse})));
        SafeZonePreTime.(Mouse_names{mouse})=sum(Stop(SafeEpoch.TestPre.(Mouse_names{mouse}))-Start(SafeEpoch.TestPre.(Mouse_names{mouse})));
        ShockVersusSafeZonesPre.(Mouse_names{mouse})=ShockZonePreTime.(Mouse_names{mouse})/SafeZonePreTime.(Mouse_names{mouse});
    end
    % Test Post/Post
    ZoneEpoch.TestPost.(Mouse_names{mouse})=ConcatenateDataFromFolders_SB(TestPostSess.(Mouse_names{mouse}),'Epoch','epochname','zoneepoch');
    ShockEpoch.TestPost.(Mouse_names{mouse}) = or(ZoneEpoch.TestPost.(Mouse_names{mouse}){1},ZoneEpoch.TestPost.(Mouse_names{mouse}){4});
    SafeEpoch.TestPost.(Mouse_names{mouse}) = or(ZoneEpoch.TestPost.(Mouse_names{mouse}){2},ZoneEpoch.TestPost.(Mouse_names{mouse}){5});
    ShockZonePostTime.(Mouse_names{mouse})=sum(Stop(ShockEpoch.TestPost.(Mouse_names{mouse}))-Start(ShockEpoch.TestPost.(Mouse_names{mouse})));
    SafeZonePostTime.(Mouse_names{mouse})=sum(Stop(SafeEpoch.TestPost.(Mouse_names{mouse}))-Start(SafeEpoch.TestPost.(Mouse_names{mouse})));
    ShockVersusSafeZonesPost.(Mouse_names{mouse})=ShockZonePostTime.(Mouse_names{mouse})/SafeZonePostTime.(Mouse_names{mouse});
    
    %Occupancy
    try
        OccupancyShockPre.(Mouse_names{mouse})=sum(Stop(ZoneEpoch.TestPre.(Mouse_names{mouse}){1})-Start(ZoneEpoch.TestPre.(Mouse_names{mouse}){1}))/(max(Range(ConcatenateDataFromFolders_SB(TestPostSess.(Mouse_names{mouse}),'accelero'))));
        OccupancyShockPost.(Mouse_names{mouse})=sum(Stop(ZoneEpoch.TestPost.(Mouse_names{mouse}){1})-Start(ZoneEpoch.TestPost.(Mouse_names{mouse}){1}))/(max(Range(ConcatenateDataFromFolders_SB(TestPostSess.(Mouse_names{mouse}),'accelero'))));
        OccupancySafePre.(Mouse_names{mouse})=sum(Stop(ZoneEpoch.TestPre.(Mouse_names{mouse}){2})-Start(ZoneEpoch.TestPre.(Mouse_names{mouse}){2}))/(max(Range(ConcatenateDataFromFolders_SB(TestPostSess.(Mouse_names{mouse}),'accelero'))));
        OccupancySafePost.(Mouse_names{mouse})=sum(Stop(ZoneEpoch.TestPost.(Mouse_names{mouse}){2})-Start(ZoneEpoch.TestPost.(Mouse_names{mouse}){2}))/(max(Range(ConcatenateDataFromFolders_SB(TestPostSess.(Mouse_names{mouse}),'accelero'))));
    end
    % stim
    StimEpoch.(Mouse_names{mouse})=ConcatenateDataFromFolders_SB(CondSess.(Mouse_names{mouse}),'Epoch','epochname','stimepoch');
    StartStimEpoch.(Mouse_names{mouse})=Start(StimEpoch.(Mouse_names{mouse}));
    StimNumb.(Mouse_names{mouse})=length(StartStimEpoch.(Mouse_names{mouse}));
    load('ExpeInfo.mat')
    
    try
        VoltageIntensity.(Mouse_names{mouse})=ExpeInfo.ElecStimInfo.ElecStimIntensity;
    catch
        VoltageIntensity.(Mouse_names{mouse})=0;
    end
    
    % HR on Test Pre sessions
    try
        % Heart Rate
        HRConcat.TestPre.(Mouse_names{mouse})=ConcatenateDataFromFolders_SB(TestPreSess.(Mouse_names{mouse}),'heartrate');
        HRVarConcat.TestPre.(Mouse_names{mouse})=ConcatenateDataFromFolders_SB(TestPreSess.(Mouse_names{mouse}),'heartratevar');
    end
    
end

HistData = Get_Data_Peak_Spectrum_BM(Mouse_numb);


%% Figures
sess=1; mouse=1;

load('B_Low_Spectrum.mat'); RangeLow=Spectro{3};

% first figure
e=figure; e.Position=[1e3 1e3 3e3 2e3];
e=subplot(331); e.Position=[0.13 0.7 0.5 0.2357];

plot(Range(Acc.Fear.(Mouse_names{mouse})),Data(Acc.Fear.(Mouse_names{mouse})))
hold on
plot(Range(Restrict(Acc.Fear.(Mouse_names{mouse}),Freeze_Epoch.Fear.(Mouse_names{mouse}))),Data(Restrict(Acc.Fear.(Mouse_names{mouse}),Freeze_Epoch.Fear.(Mouse_names{mouse}))))
title('Accelerometer')
legend('All','Freezing')
vline(max(Range(Acc.Cond.(Mouse_names{mouse}))),'--r')

subplot(333)
FreezingProportion(1)=sum(Stop(Freeze_Epoch.Fear.(Mouse_names{mouse}))-Start(Freeze_Epoch.Fear.(Mouse_names{mouse})))/max(Range(Acc.Fear.(Mouse_names{mouse})));
FreezingProportion(2)=TimeSpent.Fear.Fz_Shock.(Mouse_names{mouse})/max(Range(Acc.Fear.(Mouse_names{mouse}),'s'));
FreezingProportion(3)=TimeSpent.Fear.Fz_Safe.(Mouse_names{mouse})/max(Range(Acc.Fear.(Mouse_names{mouse}),'s'));
FreezingTime=sum(Stop(Freeze_Epoch.Fear.(Mouse_names{mouse}))-Start(Freeze_Epoch.Fear.(Mouse_names{mouse})))/1e4;
bar(FreezingProportion*100)
makepretty
xticklabels({'Total freezing','Shock side fz','Safe side fz'})
ylabel('Freezing proportion (%)')
xtickangle(45)
text(0.5,(max(FreezingProportion(1))*100)*1.05,[num2str(FreezingTime) 's'])

subplot(367)
try
    bar([OccupancyShockPre.(Mouse_names{mouse}) , OccupancySafePre.(Mouse_names{mouse})])
    xticklabels({'Shock','Safe'})
    ylabel('% time in zone')
    title('PreExplo')
    makepretty
    hline(0.35,'--r')
end
subplot(368)
try
    bar([OccupancyShockPost.(Mouse_names{mouse}) , OccupancySafePost.(Mouse_names{mouse})])
    xticklabels({'Shock','Safe'})
    ylabel('% time in zone')
    title('PostExplo')
    makepretty
    hline(0.35,'--r')
end
try
    subplot(369)
    StPre=Start(ZoneEpoch.TestPre.(Mouse_names{mouse}){1},'s');
    StPost=Start(ZoneEpoch.TestPost.(Mouse_names{mouse}){1},'s');
    try
        bar([StPre(1) , StPost(1)])
    catch
        bar([StPre(1) , 0]) % when mouse never enter Shock zone
    end
    xticklabels({'Pre','Post'})
    ylabel('time to shock zone entry (s)')
    title('Shock zone entry')
    makepretty
end

subplot(324)
plot(Start(StimEpoch.(Mouse_names{mouse}))/1e4,[1:length(Start(StimEpoch.(Mouse_names{mouse})))],'.r','MarkerSize',30); axis xy
ylabel('# stims'); xlabel('Cond sessions time (s)')
makepretty
title(['Stim analysis, intensity=' num2str(VoltageIntensity.(Mouse_names{mouse})) 'V'])

try
    subplot(337)
    data_to_plot=[nanmean(Data(HR_Freeze.Cond.Shock.(Mouse_names{mouse}))) , nanmean(Data(HR_Freeze.Cond.Safe.(Mouse_names{mouse}))) , nanmean(Data(HR_Freeze.Ext.Shock.(Mouse_names{mouse}))) , nanmean(Data(HR_Freeze.Ext.Safe.(Mouse_names{mouse})))];
    b=bar(data_to_plot);
    ylabel('Frequency (Hz)'); xticklabels({'Cond Shock','Cond Safe','Ext Shock','Ext Safe'})
    max_b=max(data_to_plot); min_b=min(data_to_plot);
    xtickangle(45); ylim([min_b-0.2 max_b+0.2])
    makepretty;
    title('Heart rate, freezing')
    
    subplot(338)
    data_to_plot=[nanmean(Data(HRVar_Freeze.Cond.Shock.(Mouse_names{mouse}))) , nanmean(Data(HRVar_Freeze.Cond.Safe.(Mouse_names{mouse}))) , nanmean(Data(HRVar_Freeze.Ext.Shock.(Mouse_names{mouse}))) , nanmean(Data(HRVar_Freeze.Ext.Safe.(Mouse_names{mouse})))];
    b=bar(data_to_plot);
    ylabel('Frequency (Hz)'); xticklabels({'Cond Shock','Cond Safe','Ext Shock','Ext Safe'})
    max_b=max(data_to_plot); min_b=min(data_to_plot);
    xtickangle(45); ylim([min_b-0.05 max_b+0.05])
    makepretty;
    title('Heart rate variability, freezing')
end
try
    subplot(339)
    data_to_plot=[length(Ripples_Freeze.Cond.Shock.(Mouse_names{mouse}))/TimeSpent.Cond.Fz_Shock.(Mouse_names{mouse}) , length(Ripples_Freeze.Cond.Safe.(Mouse_names{mouse}))/TimeSpent.Cond.Fz_Safe.(Mouse_names{mouse}) , 0 , length(Ripples_Freeze.Ext.Shock.(Mouse_names{mouse}))/TimeSpent.Ext.Fz_Shock.(Mouse_names{mouse}) , length(Ripples_Freeze.Ext.Safe.(Mouse_names{mouse}))/TimeSpent.Ext.Fz_Safe.(Mouse_names{mouse})];
    b=bar(data_to_plot);
    ylabel('Frequency (Hz)'); xticklabels({'Cond Shock Fz','Cond Safe Fz','','Ext Shock Fz','Ext Safe Fz'})
    max_b=max(data_to_plot); min_b=min(data_to_plot);
    xtickangle(45); ylim([0 1.2])
    makepretty;
    title('Ripples density')
end


% try
%     b=suptitle(['Mouse ' num2str(Mouse) ' ID card 1']); b.FontSize=20;
% catch
%     b=sgtitle(['Mouse ' num2str(Mouse) ' ID card 1']); b.FontSize=20;
% end

% second figure
c=figure; c.Position=[1e3 1e3 3e3 2e3]; n=1;
for sess=[2 3]
    
    subplot(4,2,n)     % spectrograms
    imagesc( linspace(0 , round(TimeSpent.(Session_type{sess}).Fz_Shock.(Mouse_names{mouse})) , size(Range(OBSpec.(Session_type{sess}).Fz_Shock.(Mouse_names{mouse})),1) ), RangeLow , zscore_nan_BM(Data(OBSpec.(Session_type{sess}).Fz_Shock.(Mouse_names{mouse}))')), axis xy; makepretty
    l=hline([2 4 6],{'-k','-k','-k'},{'','',''});
    u=text(-round(TimeSpent.(Session_type{sess}).Fz_Shock.(Mouse_names{mouse}))/10 , 8,'Shock','FontSize',10,'FontWeight','bold'); set(u,'Rotation',90);
    title((Session_type{sess}))
    
    subplot(4,2,n+2)
    imagesc( linspace(0 , round(TimeSpent.(Session_type{sess}).Fz_Safe.(Mouse_names{mouse})) , size(Range(OBSpec.(Session_type{sess}).Fz_Safe.(Mouse_names{mouse})),1) ), RangeLow , zscore_nan_BM(Data(OBSpec.(Session_type{sess}).Fz_Safe.(Mouse_names{mouse}))')), axis xy; makepretty
    hline([2 4 6],{'-k','-k','-k'},{'','',''})
    u=text(-round(TimeSpent.(Session_type{sess}).Fz_Safe.(Mouse_names{mouse}))/10 , 8,'Safe','FontSize',10,'FontWeight','bold'); set(u,'Rotation',90);
    xlabel('time (s)')
    
    a=subplot(2,4,5+(n-1)*2);  % mean spectrums
    clear Mean_All_Sp; Mean_All_Sp=nanmean(Data(OBSpec.(Session_type{sess}).Fz_Shock.(Mouse_names{mouse})).*RangeLow);
    [a,b]=max(Mean_All_Sp(:,16:end)); vline(RangeLow(b+15),'--r')
    plot(RangeLow,Mean_All_Sp/a,'r','linewidth',2), hold on
    clear Mean_All_Sp; Mean_All_Sp=nanmean(Data(OBSpec.(Session_type{sess}).Fz_Safe.(Mouse_names{mouse})).*RangeLow);
    [c,d]=max(Mean_All_Sp(:,16:end)); vline(RangeLow(d+15),'--b')
    plot(RangeLow,Mean_All_Sp/c,'b','linewidth',2), ylabel('power (a.u.)'); xlabel('Frequency (Hz)'); hold on
    makepretty
    xlim([0 8]); xticks([1:8]); grid on
    a=legend('shock zone freezing','safe zone freezing'); a.Position=[0.01 0.11 0.11 0.024]
    title((Session_type{sess}))
    
    a=subplot(2,4,6+(n-1)*2); % time spent
    clear Mean_All_Sp; Mean_All_Sp=runmean(HistData.Shock.(Session_type{sess}).(Mouse_names{mouse})/sum(HistData.Shock.(Session_type{sess}).(Mouse_names{mouse})),3);
    [a,b]=max(Mean_All_Sp); vline(RangeLow(b+12),'--r')
    plot(Spectro{3}(13:103) , Mean_All_Sp/a,'-r','linewidth',2); hold on
    clear Mean_All_Sp; Mean_All_Sp=runmean(HistData.Safe.(Session_type{sess}).(Mouse_names{mouse})/sum(HistData.Safe.(Session_type{sess}).(Mouse_names{mouse})),3);
    [c,d]=max(Mean_All_Sp); vline(RangeLow(d+12),'--b')
    plot(Spectro{3}(13:103) , Mean_All_Sp/c,'-b','linewidth',2); hold on
    makepretty; grid on;
    xlabel('Frequency (Hz)'); ylabel('%'); xlim([0 8]); xticks([1:8]);
    
    n=n+1;
end

% 
% try
%     h=suptitle(['Mouse ' num2str(Mouse) ' ID card 2']); h.FontSize=20;
% catch
%     h=sgtitle(['Mouse ' num2str(Mouse) ' ID card 2']); h.FontSize=20;
% end





















%% All mice

clear all

Dir=PathForExperimentsERC_Dima('UMazePAG');

for d=1:length(Dir.path)
    Mouse_names{d}= ['M' num2str(Dir.ExpeInfo{1, d}.nmouse)];
    Mouse(d)=Dir.ExpeInfo{1, d}.nmouse;
end

noise_thr=12;
Session_type={'Fear','Cond','Ext'};

cd(Dir.path{1, d}{1, 1})
load('B_Low_Spectrum.mat'); RangeLow = Spectro{3};
load('H_VHigh_Spectrum.mat'); RangeVHigh = Spectro{3};

for mouse=1:length(Dir.path)
    
    cd(Dir.path{1, mouse}{1, 1})
    load('behavResources.mat', 'SessionEpoch')
    
    load('behavResources.mat', 'ZoneEpoch')
    ZoneEpoch_To_Use=ZoneEpoch;
    
    
    load('behavResources.mat', 'MovAcctsd')
    
    try
        ExtEpoch.(Mouse_names{mouse}) =  SessionEpoch.Ext;
    catch
        try
            ExtEpoch.(Mouse_names{mouse}) =  SessionEpoch.Extinction;
        catch
            try
                ExtEpoch.(Mouse_names{mouse}) = SessionEpoch.ExploAfter;
            catch
                ExtEpoch.(Mouse_names{mouse}) = intervalSet([],[]);
            end
        end
    end
    CondEpoch.(Mouse_names{mouse}) =  or(SessionEpoch.Cond1,or(SessionEpoch.Cond2,or(SessionEpoch.Cond3,SessionEpoch.Cond4)));
    FearEpoch.(Mouse_names{mouse}) =  or(CondEpoch.(Mouse_names{mouse}) , ExtEpoch.(Mouse_names{mouse}));
    
    load('B_Low_Spectrum.mat')
    OB_Sptsd=tsd(Spectro{1, 2}*1e4,Spectro{1, 1});
    load('H_Low_Spectrum.mat')
    HPC_Sptsd = tsd(Spectro{1, 2}*1e4,Spectro{1, 1});
    try; load('H_VHigh_Spectrum.mat')
    Ripples_Sptsd=tsd(Spectro{1, 2}*1e4,Spectro{1, 1}); end
    
    for sess=1:length(Session_type)
        
        if sess==1
            Epoch_to_use=FearEpoch.(Mouse_names{mouse});
        elseif sess==2
            Epoch_to_use=CondEpoch.(Mouse_names{mouse});
        elseif sess==3
            Epoch_to_use=ExtEpoch.(Mouse_names{mouse});
        end
        
        Acc.(Session_type{sess}).(Mouse_names{mouse})=Restrict(MovAcctsd,Epoch_to_use);
        OBSpec.(Session_type{sess}).(Mouse_names{mouse})=Restrict(OB_Sptsd,Epoch_to_use);
        try
            ShockEpoch.(Session_type{sess}).(Mouse_names{mouse}) =and(Epoch_to_use,or(ZoneEpoch_To_Use.Shock,ZoneEpoch_To_Use.FarShock ));
        catch
            ShockEpoch.(Session_type{sess}).(Mouse_names{mouse}) =and(Epoch_to_use,ZoneEpoch_To_Use.Shock);
        end
        
        try
            SafeEpoch.(Session_type{sess}).(Mouse_names{mouse}) =and(Epoch_to_use,or(ZoneEpoch_To_Use.NoShock,or(ZoneEpoch_To_Use.FarNoShock,ZoneEpoch_To_Use.CentreNoShock)));
        catch
            SafeEpoch.(Session_type{sess}).(Mouse_names{mouse}) =and(Epoch_to_use,or(ZoneEpoch_To_Use.NoShock,ZoneEpoch_To_Use.CentreNoShock));
        end
        
        try
            load('behavResources.mat', 'FreezeAccEpoch')
            Freeze_Epoch.(Session_type{sess}).(Mouse_names{mouse})=and(FreezeAccEpoch,Epoch_to_use);
        catch
            keyboard
            Params.thtps_immob=2;  Params.smoofact_Acc = 30;  Params.th_immob_Acc = 1.7e7;
            FreezeAccEpoch=MakeFreezeAccEpoch_BM(MovAcctsd,Params);
            Freeze_Epoch.(Session_type{sess}).(Mouse_names{mouse})=and(Epoch_to_use,FreezeAccEpoch);
        end
        
        % OB mean spectrum maxima
        OBSpec.(Session_type{sess}).Fz.(Mouse_names{mouse})=Restrict(OBSpec.(Session_type{sess}).(Mouse_names{mouse}),Freeze_Epoch.(Session_type{sess}).(Mouse_names{mouse}));
        OBSpec.(Session_type{sess}).Fz_Shock.(Mouse_names{mouse})=Restrict(OBSpec.(Session_type{sess}).Fz.(Mouse_names{mouse}),ShockEpoch.(Session_type{sess}).(Mouse_names{mouse}) );
        OBSpec.(Session_type{sess}).Fz_Safe.(Mouse_names{mouse})=Restrict(OBSpec.(Session_type{sess}).Fz.(Mouse_names{mouse}),SafeEpoch.(Session_type{sess}).(Mouse_names{mouse}));
        if isnan(nanmean(zscore_nan_BM(Data(OBSpec.(Session_type{sess}).Fz_Shock.(Mouse_names{mouse}))')'))
            AllSpectrumOB.(Session_type{sess}).Shock(mouse,:) = NaN(1,261) ;
        else
            AllSpectrumOB.(Session_type{sess}).Shock(mouse,:) = nanmean(zscore_nan_BM(Data(OBSpec.(Session_type{sess}).Fz_Shock.(Mouse_names{mouse}))')') ;
        end
        if isnan(nanmean(zscore_nan_BM(Data(OBSpec.(Session_type{sess}).Fz_Safe.(Mouse_names{mouse}))')'))
            AllSpectrumOB.(Session_type{sess}).Safe(mouse,:) =  NaN(1,261) ;
        else
            AllSpectrumOB.(Session_type{sess}).Safe(mouse,:) = nanmean(zscore_nan_BM(Data(OBSpec.(Session_type{sess}).Fz_Safe.(Mouse_names{mouse}))')') ;
        end
        [PowerMax.(Session_type{sess}).Shock.(Mouse_names{mouse}),FreqMax.(Session_type{sess}).Shock.(Mouse_names{mouse})]=max(AllSpectrumOB.(Session_type{sess}).Shock(mouse,noise_thr:end));
        [PowerMax.(Session_type{sess}).Safe.(Mouse_names{mouse}),FreqMax.(Session_type{sess}).Safe.(Mouse_names{mouse})]=max(AllSpectrumOB.(Session_type{sess}).Safe(mouse,noise_thr:end));
        try
            FreqMaxAll.(Session_type{sess}).Shock(mouse) = RangeLow(FreqMax.(Session_type{sess}).Shock.(Mouse_names{mouse})+noise_thr-1);
        catch
            FreqMaxAll.(Session_type{sess}).Shock(mouse) =NaN;
        end
        try
            FreqMaxAll.(Session_type{sess}).Safe(mouse) = RangeLow(FreqMax.(Session_type{sess}).Safe.(Mouse_names{mouse})+noise_thr-1);
        catch
            FreqMaxAll.(Session_type{sess}).Safe(mouse) =NaN;
        end
        
        % HPC data
        HPCSpec.(Session_type{sess}).(Mouse_names{mouse})=Restrict(HPC_Sptsd,Epoch_to_use);
        HPCSpec.(Session_type{sess}).Fz.(Mouse_names{mouse})=Restrict(HPCSpec.(Session_type{sess}).(Mouse_names{mouse}),Freeze_Epoch.(Session_type{sess}).(Mouse_names{mouse}));
        HPCSpec.(Session_type{sess}).Fz_Shock.(Mouse_names{mouse})=Restrict(HPCSpec.(Session_type{sess}).Fz.(Mouse_names{mouse}),ShockEpoch.(Session_type{sess}).(Mouse_names{mouse}) );
        HPCSpec.(Session_type{sess}).Fz_Safe.(Mouse_names{mouse})=Restrict(HPCSpec.(Session_type{sess}).Fz.(Mouse_names{mouse}),SafeEpoch.(Session_type{sess}).(Mouse_names{mouse}));
        if isnan(nanmean(zscore_nan_BM(Data(HPCSpec.(Session_type{sess}).Fz_Shock.(Mouse_names{mouse}))')'))
            AllSpectrumHPC.(Session_type{sess}).Shock(mouse,:) = NaN(1,261) ;
        else
            AllSpectrumHPC.(Session_type{sess}).Shock(mouse,:) = nanmean(zscore_nan_BM(Data(HPCSpec.(Session_type{sess}).Fz_Shock.(Mouse_names{mouse}))')') ;
        end
        if isnan(nanmean(zscore_nan_BM(Data(HPCSpec.(Session_type{sess}).Fz_Safe.(Mouse_names{mouse}))')'))
            AllSpectrumHPC.(Session_type{sess}).Safe(mouse,:) =  NaN(1,261) ;
        else
            AllSpectrumHPC.(Session_type{sess}).Safe(mouse,:) = nanmean(zscore_nan_BM(Data(HPCSpec.(Session_type{sess}).Fz_Safe.(Mouse_names{mouse}))')') ;
        end
        
        % Ripples spectrum
        try; RipplesSpec.(Session_type{sess}).(Mouse_names{mouse})=Restrict(Ripples_Sptsd,Epoch_to_use);
        RipplesSpec.(Session_type{sess}).Fz.(Mouse_names{mouse})=Restrict(RipplesSpec.(Session_type{sess}).(Mouse_names{mouse}) , Freeze_Epoch.(Session_type{sess}).(Mouse_names{mouse}));
        RipplesSpec.(Session_type{sess}).Fz_Shock.(Mouse_names{mouse})=Restrict(RipplesSpec.(Session_type{sess}).Fz.(Mouse_names{mouse}),ShockEpoch.(Session_type{sess}).(Mouse_names{mouse}) );
        RipplesSpec.(Session_type{sess}).Fz_Safe.(Mouse_names{mouse})=Restrict(RipplesSpec.(Session_type{sess}).Fz.(Mouse_names{mouse}),SafeEpoch.(Session_type{sess}).(Mouse_names{mouse}));
        if isnan(nanmean(zscore_nan_BM(Data(RipplesSpec.(Session_type{sess}).Fz_Shock.(Mouse_names{mouse}))')'))
            AllSpectrumRipples.(Session_type{sess}).Shock(mouse,:) = NaN(1,94) ;
        else
            clear Data_to_use; Data_to_use = nanmean(Data(RipplesSpec.(Session_type{sess}).Fz_Shock.(Mouse_names{mouse})));
            AllSpectrumRipples.(Session_type{sess}).Shock(mouse,:) = Data_to_use/max(Data_to_use(54:79)) ;
        end
        if isnan(nanmean(zscore_nan_BM(Data(RipplesSpec.(Session_type{sess}).Fz_Safe.(Mouse_names{mouse}))')'))
            AllSpectrumRipples.(Session_type{sess}).Safe(mouse,:) =  NaN(1,94) ;
        else
            clear Data_to_use; Data_to_use = nanmean(Data(RipplesSpec.(Session_type{sess}).Fz_Safe.(Mouse_names{mouse})));
            AllSpectrumRipples.(Session_type{sess}).Safe(mouse,:) = Data_to_use/max(Data_to_use(54:79)) ;
        end
        end
        
        TimeSpent.(Session_type{sess}).Fz_Shock.(Mouse_names{mouse}) = sum( Stop(and(Freeze_Epoch.(Session_type{sess}).(Mouse_names{mouse}) , ShockEpoch.(Session_type{sess}).(Mouse_names{mouse}) )) - Start(and(Freeze_Epoch.(Session_type{sess}).(Mouse_names{mouse}) , ShockEpoch.(Session_type{sess}).(Mouse_names{mouse}) )))/1e4;
        TimeSpent.(Session_type{sess}).Fz_Safe.(Mouse_names{mouse}) = sum( Stop(and(Freeze_Epoch.(Session_type{sess}).(Mouse_names{mouse}) , SafeEpoch.(Session_type{sess}).(Mouse_names{mouse}) )) - Start(and(Freeze_Epoch.(Session_type{sess}).(Mouse_names{mouse}) , SafeEpoch.(Session_type{sess}).(Mouse_names{mouse}) )))/1e4;
        AllTimeSpent.(Session_type{sess}).Fz_Shock(mouse) = TimeSpent.(Session_type{sess}).Fz_Shock.(Mouse_names{mouse});
        AllTimeSpent.(Session_type{sess}).Fz_Safe(mouse) = TimeSpent.(Session_type{sess}).Fz_Safe.(Mouse_names{mouse});
        
        % Ripples numb
        try
            load('SWR.mat')
        RipplesNumb.(Session_type{sess}).(Mouse_names{mouse}) = RipplesEpoch;
        RipplesNumb.(Session_type{sess}).Fz.(Mouse_names{mouse}) = and(RipplesNumb.(Session_type{sess}).(Mouse_names{mouse}) , Freeze_Epoch.(Session_type{sess}).(Mouse_names{mouse}));
        RipplesNumb.(Session_type{sess}).Fz_Shock.(Mouse_names{mouse}) = length(Start(and(RipplesNumb.(Session_type{sess}).Fz.(Mouse_names{mouse}) , ShockEpoch.(Session_type{sess}).(Mouse_names{mouse}))));
        RipplesNumb.(Session_type{sess}).Fz_Safe.(Mouse_names{mouse}) = length(Start(and(RipplesNumb.(Session_type{sess}).Fz.(Mouse_names{mouse}) , SafeEpoch.(Session_type{sess}).(Mouse_names{mouse}))));
        AllRipplesDensity_Shock.(Session_type{sess})(mouse) = RipplesNumb.(Session_type{sess}).Fz_Shock.(Mouse_names{mouse})/TimeSpent.Fear.Fz_Shock.(Mouse_names{mouse});
        AllRipplesDensity_Safe.(Session_type{sess})(mouse) = RipplesNumb.(Session_type{sess}).Fz_Safe.(Mouse_names{mouse})/TimeSpent.Fear.Fz_Safe.(Mouse_names{mouse});
         
        AllRipplesDensity_Shock.(Session_type{sess})(AllRipplesDensity_Shock.(Session_type{sess})==0)=NaN;
        AllRipplesDensity_Safe.(Session_type{sess})(AllRipplesDensity_Safe.(Session_type{sess})==0)=NaN; 
        end
        
        FreezeTime(mouse)=((sum(Stop(Freeze_Epoch.(Session_type{sess}).(Mouse_names{mouse}))-Start(Freeze_Epoch.(Session_type{sess}).(Mouse_names{mouse}))))/max(Range(Acc.Fear.(Mouse_names{mouse}))))*100;
        
    end
    
    %Stim
    load('behavResources.mat', 'TTLInfo')
    StimEpoch.(Mouse_names{mouse})=and(TTLInfo.StimEpoch,FearEpoch.(Mouse_names{mouse}));
    StartStimEpoch.(Mouse_names{mouse})=Start(StimEpoch.(Mouse_names{mouse}));
    StimNumb.(Mouse_names{mouse})=length(StartStimEpoch.(Mouse_names{mouse}));
    StimNumb_AllMice(mouse)=StimNumb.(Mouse_names{mouse});
    
    % Test Post
    TestPostSess.(Mouse_names{mouse}) =or(SessionEpoch.TestPost1,or(SessionEpoch.TestPost2,or(SessionEpoch.TestPost3,SessionEpoch.TestPost4)));
    ShockZoneEpoch.PostTest.(Mouse_names{mouse})=and(ZoneEpoch_To_Use.Shock,TestPostSess.(Mouse_names{mouse}));
    SafeZoneEpoch.PostTest.(Mouse_names{mouse})=and(ZoneEpoch_To_Use.NoShock,TestPostSess.(Mouse_names{mouse}));
    
    ShockZonePostTime.(Mouse_names{mouse})=sum(Stop(ShockZoneEpoch.PostTest.(Mouse_names{mouse}))-Start(ShockZoneEpoch.PostTest.(Mouse_names{mouse})));
    SafeZonePostTime.(Mouse_names{mouse})=sum(Stop(SafeZoneEpoch.PostTest.(Mouse_names{mouse}))-Start(SafeZoneEpoch.PostTest.(Mouse_names{mouse})));
    ShockVersusSafeZonesPost.(Mouse_names{mouse})=ShockZonePostTime.(Mouse_names{mouse})/SafeZonePostTime.(Mouse_names{mouse});
    ShockVersusSafePostTime(mouse)=ShockVersusSafeZonesPost.(Mouse_names{mouse});
    OccupancyShockTestPost(mouse)=(ShockZonePostTime.(Mouse_names{mouse})/sum(Stop(TestPostSess.(Mouse_names{mouse}))-Start(TestPostSess.(Mouse_names{mouse}))))*100;
    
    disp(Mouse_names{mouse})
end

StimNumb_AllMice(1)=NaN;


for sess=1:length(Session_type)
    FreqMaxAll.(Session_type{sess}).Shock([2 3 4 8 9 12 13 16 23])=NaN;
    FreqMaxAll.(Session_type{sess}).Safe([2 3 4 7 9 12 13 23])=NaN;
    AllSpectrumOB.(Session_type{sess}).Shock([2 3 8 9 12 13 16 23],:)=NaN;
    AllSpectrumOB.(Session_type{sess}).Safe([2 3 7 12 13 23],:)=NaN;
    
    AllSpectrumHPC.(Session_type{sess}).Shock([6 8 9 10 11 13 23],:)=NaN;
    AllSpectrumHPC.(Session_type{sess}).Safe([7],:)=NaN;
end
    
FreqMaxAll.Fear.Shock(10)=7.78;
FreqMaxAll.Fear.Shock(11)=5.65;
FreqMaxAll.Fear.Shock(15)=4.65; FreqMaxAll.Fear.Safe(15)=3.128;

FreqMaxAll.Cond.Shock(10)=7.78;
FreqMaxAll.Cond.Shock(11)=5.65;
FreqMaxAll.Cond.Shock(22)=NaN;

FreqMaxAll.Ext.Shock([1 6 7 10 11 17 21])=NaN;
FreqMaxAll.Ext.Shock(24)=4.425;


%% Overview figure
figure
subplot(411)
plot(FreezeTime); hold on
plot(FreezeTime,'.k','MarkerSize',30)
ylabel('Freezing percentage (%)')
xticks([1:24]); xticklabels({'','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','',''})
makepretty
title('Freezing percentage')

subplot(412)
plot(StimNumb_AllMice); hold on
plot(StimNumb_AllMice,'.k','MarkerSize',30)
ylabel('extra shocks number')
xticks([1:24]); xticklabels({'','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','',''})
makepretty
title('Extra shocks')

subplot(413)
plot(OccupancyShockTestPost); hold on
plot(OccupancyShockTestPost,'.k','MarkerSize',30)
ylabel('%')
xticks([1:24]); xticklabels({'','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','',''})
makepretty
title('Shock zone occupancy')

subplot(414)
plot(FreqMaxAll.Shock,'.','Color',[1 0.5 0.5],'MarkerSize',30); hold on
plot(FreqMaxAll.Shock,'Color',[1 0.5 0.5]); hold on
plot(FreqMaxAll.Safe,'.','Color',[0.5 0.5 1],'MarkerSize',30); hold on
plot(FreqMaxAll.Safe,'Color',[0.5 0.5 1]); hold on
ylabel('OB max frequency')
xticks([1:24]); xticklabels(Mouse_names); xtickangle(45);
makepretty
title('OB Analysis')
f=get(gca,'Children');
legend([f(3),f(1)],'Shock side freezing','Safe side freezing')

a=suptitle('Dima experiments overview, PAG stimulation, n=20'); a.FontSize=20;

%% Mean spectrum
% OB
X = [1,2];
Cols = {[1, 0.5, 0.5],[0.5, 0.5, 1]};
Legends ={'Shock' 'Safe'};

figure
for sess=1:length(Session_type)
    subplot(2,3,sess)
    MakeSpreadAndBoxPlot2_SB({FreqMaxAll.(Session_type{sess}).Shock , FreqMaxAll.(Session_type{sess}).Safe},Cols,X,Legends,'showpoints',0,'paired',1);
    if sess==1; ylabel('Frequency (Hz)'); end; ylim([0.5 9])
    title(Session_type{sess})
    
    subplot(2,3,sess+3)
    Conf_Inter=nanstd(AllSpectrumOB.(Session_type{sess}).Shock)/sqrt(size(AllSpectrumOB.(Session_type{sess}).Shock,1));
    shadedErrorBar(RangeLow , nanmean(AllSpectrumOB.(Session_type{sess}).Shock) , Conf_Inter ,'-r',1); hold on;
    hold on
    Conf_Inter=nanstd(AllSpectrumOB.(Session_type{sess}).Safe)/sqrt(size(AllSpectrumOB.(Session_type{sess}).Safe,1));
    shadedErrorBar(RangeLow , nanmean(AllSpectrumOB.(Session_type{sess}).Safe) , Conf_Inter ,'-b',1); hold on;
    makepretty
    xlim([0 10])
    ylabel('Power (a.u.)')
    xlabel('Frequency (Hz)')
    if sess==1; f=get(gca,'Children'); legend([f(5),f(1)],'Shock side freezing','Safe side freezing'); end
    Mean_All_Sp=nanmean(AllSpectrumOB.(Session_type{sess}).Shock);
    [u,v]=max(Mean_All_Sp(16:end)); a=vline(RangeLow(v+15),'--r'); a.LineWidth=2;
    Mean_All_Sp=nanmean(AllSpectrumOB.(Session_type{sess}).Safe);
    [u,v]=max(Mean_All_Sp(16:end)); a=vline(RangeLow(v+15),'--b'); a.LineWidth=2;
end

a=suptitle('OB Low data, Dima mice, n=24'); a.FontSize=20;

% HPC
figure
for sess=1:length(Session_type)
    
    subplot(1,3,sess)
    Conf_Inter=nanstd(AllSpectrumHPC.(Session_type{sess}).Shock)/sqrt(size(AllSpectrumHPC.(Session_type{sess}).Shock,1));
    shadedErrorBar(RangeLow , nanmean(AllSpectrumHPC.(Session_type{sess}).Shock) , Conf_Inter ,'-r',1); hold on;
    hold on
    Conf_Inter=nanstd(AllSpectrumHPC.(Session_type{sess}).Safe)/sqrt(size(AllSpectrumHPC.(Session_type{sess}).Safe,1));
    shadedErrorBar(RangeLow , nanmean(AllSpectrumHPC.(Session_type{sess}).Safe) , Conf_Inter ,'-b',1); hold on;
    makepretty
    xlim([0 12]); ylim([-1 2.5])
    ylabel('Power (a.u.)')
    xlabel('Frequency (Hz)')
    if sess==1; f=get(gca,'Children'); legend([f(5),f(1)],'Shock side freezing','Safe side freezing'); end
    title(Session_type{sess})
    Mean_All_Sp=nanmean(AllSpectrumHPC.(Session_type{sess}).Shock);
    [u,v]=max(Mean_All_Sp(50:end)); a=vline(RangeLow(v+49),'--r'); a.LineWidth=2;
    Mean_All_Sp=nanmean(AllSpectrumHPC.(Session_type{sess}).Safe);
    [u,v]=max(Mean_All_Sp(50:end)); a=vline(RangeLow(v+49),'--b'); a.LineWidth=2;
    
end

a=suptitle('HPC Low data, Dima mice, n=24'); a.FontSize=20;

% mice with bimodal activity during sfe side freezing
figure
for sess=1:length(Session_type)
    
    subplot(1,3,sess)
    Conf_Inter=nanstd(AllSpectrumHPC.(Session_type{sess}).Shock([2 4 5 12 17 18 19 21 22 23 24],:))/sqrt(size(AllSpectrumHPC.(Session_type{sess}).Shock([2 4 5 12 17 18 19 21 22 23 24],:),1));
    shadedErrorBar(RangeLow , nanmean(AllSpectrumHPC.(Session_type{sess}).Shock) , Conf_Inter ,'-r',1); hold on;
    hold on
    Conf_Inter=nanstd(AllSpectrumHPC.(Session_type{sess}).Safe([2 4 5 12 17 18 19 21 22 23 24],:))/sqrt(size(AllSpectrumHPC.(Session_type{sess}).Safe([2 4 5 12 17 18 19 21 22 23 24],:),1));
    shadedErrorBar(RangeLow , nanmean(AllSpectrumHPC.(Session_type{sess}).Safe([2 4 5 12 17 18 19 21 22 23 24],:)) , Conf_Inter ,'-b',1); hold on;
    makepretty
    xlim([0 12]); ylim([-1 2.5])
    ylabel('Power (a.u.)')
    xlabel('Frequency (Hz)')
    if sess==1; f=get(gca,'Children'); legend([f(5),f(1)],'Shock side freezing','Safe side freezing'); end
    title(Session_type{sess})
    [u,v]=max(Mean_All_Sp(50:end)); a=vline(RangeLow(v+49),'--r'); a.LineWidth=2;
    Mean_All_Sp=nanmean(AllSpectrumHPC.(Session_type{sess}).Safe([2 4 5 12 17 18 19 21 22 23 24],:));
    [u,v]=max(Mean_All_Sp(50:end)); a=vline(RangeLow(v+49),'--b'); a.LineWidth=2;
    Mean_All_Sp=nanmean(AllSpectrumHPC.(Session_type{sess}).Safe([2 4 5 12 17 18 19 21 22 23 24],:));
    [u,v]=max(Mean_All_Sp); a=vline(RangeLow(v),'--b'); a.LineWidth=2;
    
end

% HPC and OB fz shock
figure
Conf_Inter=nanstd(AllSpectrumHPC.Cond.Shock([1 5 15 17 18 21],:))/sqrt(size(AllSpectrumHPC.Cond.Shock([1 5 15 17 18 21],:),1));
shadedErrorBar(RangeLow , nanmean(AllSpectrumHPC.Cond.Shock) , Conf_Inter ,'-g',1); hold on;
hold on
Conf_Inter=nanstd(AllSpectrumOB.Cond.Shock([1 5 15 17 18 21],:))/sqrt(size(AllSpectrumOB.Cond.Shock([1 5 15 17 18 21],:),1));
shadedErrorBar(RangeLow , nanmean(AllSpectrumOB.Cond.Shock([1 5 15 17 18 21],:)) , Conf_Inter ,'-b',1); hold on;
makepretty
xlim([0 12]); ylim([-1 2.5])
ylabel('Power (a.u.)')
xlabel('Frequency (Hz)')
f=get(gca,'Children'); legend([f(5),f(1)],'HPC','OB');
Mean_All_Sp=nanmean(AllSpectrumHPC.Cond.Shock([1 5 12 15 17 18 21],:));
[u,v]=max(Mean_All_Sp(50:end)); a=vline(RangeLow(v+49),'--g'); a.LineWidth=2;
Mean_All_Sp=nanmean(AllSpectrumOB.Cond.Shock([1 5 12 15 17 18 21],:));
[u,v]=max(Mean_All_Sp); a=vline(RangeLow(v),'--b'); a.LineWidth=2;

title('HPC and OB mean spectrums during shock side freezing, DIMA mice, n=6')

%% Frequencies correlations

HPC_Autocorrelation_Freezing_SumUp_BM(HPCSpec,OBSpec,Spectro,Mouse,Mouse_names,'Dima')

%% Ripples power

figure; sess=2;
Conf_Inter=nanstd(AllSpectrumRipples.(Session_type{sess}).Shock)/sqrt(size(AllSpectrumRipples.(Session_type{sess}).Shock,1));
shadedErrorBar(RangeVHigh , nanmean(AllSpectrumRipples.(Session_type{sess}).Shock) , Conf_Inter ,'-r',1); hold on;
hold on
Conf_Inter=nanstd(AllSpectrumRipples.(Session_type{sess}).Safe)/sqrt(size(AllSpectrumRipples.(Session_type{sess}).Safe,1));
shadedErrorBar(RangeVHigh , nanmean(AllSpectrumRipples.(Session_type{sess}).Safe) , Conf_Inter ,'-b',1); hold on;
makepretty
set(gca, 'YScale', 'log')
xlim([20 250]);
ylabel('Power (a.u.)')
xlabel('Frequency (Hz)')
f=get(gca,'Children'); legend([f(5),f(1)],'Shock side freezing','Safe side freezing');

title('Very High mean Spectrum, HPC, DIMA mice, n=24')


%% ID card
load('B_Low_Spectrum.mat')
RangeLow = Spectro{3};

for mouse=1:length(Dir.path)
    
    clf
    
    subplot(421) % spectrograms
    imagesc( linspace(0 , round(TimeSpent.Cond.Fz_Shock.(Mouse_names{mouse})) , size(Range(OBSpec.Cond.Fz_Shock.(Mouse_names{mouse})),1) ), RangeLow , zscore_nan_BM(Data(OBSpec.Cond.Fz_Shock.(Mouse_names{mouse}))')), axis xy; makepretty
    l=hline([2 4 6],{'-k','-k','-k'},{'','',''});
    u=text(-round(TimeSpent.Cond.Fz_Shock.(Mouse_names{mouse}))/10 , 0,'Shock side freezing','FontSize',10,'FontWeight','bold'); set(u,'Rotation',90);
    title('OB')
    subplot(423)
    imagesc( linspace(0 , round(TimeSpent.Cond.Fz_Safe.(Mouse_names{mouse})) , size(Range(OBSpec.Cond.Fz_Safe.(Mouse_names{mouse})),1) ), RangeLow , zscore_nan_BM(Data(OBSpec.Cond.Fz_Safe.(Mouse_names{mouse}))')), axis xy; makepretty
    hline([2 4 6],{'-k','-k','-k'},{'','',''})
    u=text(-round(TimeSpent.Cond.Fz_Safe.(Mouse_names{mouse}))/10 , 0,'Safe side freezing','FontSize',10,'FontWeight','bold'); set(u,'Rotation',90);
    xlabel('time (s)')
    
    a=subplot(223);  % mean spectrums
    clear Mean_All_Sp; Mean_All_Sp=nanmean(zscore_nan_BM(Data(OBSpec.Cond.Fz_Shock.(Mouse_names{mouse}))')');
    plot(RangeLow,Mean_All_Sp/max(Mean_All_Sp(16:end)),'r','linewidth',2), hold on
    [a,b]=max(Mean_All_Sp(:,16:end));
    vline(RangeLow(b+15),'--r')
    clear Mean_All_Sp; Mean_All_Sp=nanmean(zscore_nan_BM(Data(OBSpec.Cond.Fz_Safe.(Mouse_names{mouse}))')');
    plot(RangeLow,Mean_All_Sp/max(Mean_All_Sp(16:end)),'b','linewidth',2), ylabel('OB'); xlabel('Frequency (Hz)'); hold on
    [c,d]=max(Mean_All_Sp(:,16:end));
    vline(RangeLow(d+15),'--b')
    makepretty
    xlim([0 10])
    title('OB mean spectrum')
    
    
    subplot(422) % spectrograms
    imagesc( linspace(0 , round(TimeSpent.Cond.Fz_Shock.(Mouse_names{mouse})) , size(Range(HPCSpec.Cond.Fz_Shock.(Mouse_names{mouse})),1) ), RangeLow , zscore_nan_BM(Data(HPCSpec.Cond.Fz_Shock.(Mouse_names{mouse}))')), axis xy; makepretty
    l=hline([2 4 6],{'-k','-k','-k'},{'','',''});
    u=text(-round(TimeSpent.Cond.Fz_Shock.(Mouse_names{mouse}))/10 , 0,'Shock side freezing','FontSize',10,'FontWeight','bold'); set(u,'Rotation',90);
    title('HPC')
    subplot(424)
    imagesc( linspace(0 , round(TimeSpent.Cond.Fz_Safe.(Mouse_names{mouse})) , size(Range(HPCSpec.Cond.Fz_Safe.(Mouse_names{mouse})),1) ), RangeLow , zscore_nan_BM(Data(HPCSpec.Cond.Fz_Safe.(Mouse_names{mouse}))')), axis xy; makepretty
    hline([2 4 6],{'-k','-k','-k'},{'','',''})
    u=text(-round(TimeSpent.Cond.Fz_Safe.(Mouse_names{mouse}))/10 , 0,'Safe side freezing','FontSize',10,'FontWeight','bold'); set(u,'Rotation',90);
    xlabel('time (s)')
    
    a=subplot(224);  % mean spectrums
    clear Mean_All_Sp; Mean_All_Sp=nanmean(zscore_nan_BM(Data(HPCSpec.Cond.Fz_Shock.(Mouse_names{mouse}))')');
    plot(RangeLow,Mean_All_Sp,'r','linewidth',2), hold on
    [a,b]=max(Mean_All_Sp(:,16:end));
    vline(RangeLow(b+15),'--r')
    clear Mean_All_Sp; Mean_All_Sp=nanmean(zscore_nan_BM(Data(HPCSpec.Cond.Fz_Safe.(Mouse_names{mouse}))')');
    plot(RangeLow,Mean_All_Sp,'b','linewidth',2), ylabel('OB'); xlabel('Frequency (Hz)'); hold on
    [c,d]=max(Mean_All_Sp(:,16:end));
    vline(RangeLow(d+15),'--b')
    makepretty
    xlim([0 14])
    title('HPC mean spectrum')
    
    
    a=suptitle(['Mouse ' num2str(Mouse(mouse)) ' ID card']); a.FontSize=20;
    
    saveFigure(1,['ID_card_M' num2str(Mouse(mouse))],'/home/mobsmorty/Desktop/ID_UMaze_Drugs/')
    
end

% Ripples number
X = [1,2];
Cols = {[1, 0.5, 0.5],[0.5, 0.5, 1]};
Legends ={'Shock' 'Safe'};

figure
subplot(121)
sess=2;
MakeSpreadAndBoxPlot2_SB({AllRipplesDensity_Shock.(Session_type{sess}) , AllRipplesDensity_Safe.(Session_type{sess})},Cols,X,Legends,'showpoints',0,'paired',1);
ylim([-0.1 1.1]); ylabel('Ripples density #/s')
title('All mice')
subplot(122)
MakeSpreadAndBoxPlot2_SB({AllRipplesDensity_Shock.(Session_type{sess})(15:end) , AllRipplesDensity_Safe.(Session_type{sess})(15:end)},Cols,X,Legends,'showpoints',0,'paired',1);
ylim([-0.1 1.1]); 
title('All mice with regular protocol')

a=suptitle('Ripples density, Dima mice'); a.FontSize=20;


% amount of freezing


figure
subplot(121)
sess=2;
MakeSpreadAndBoxPlot2_SB({AllTimeSpent.Cond.Fz_Shock , AllTimeSpent.Cond.Fz_Safe},Cols,X,Legends,'showpoints',0,'paired',1);
ylim([-50 1200]); ylabel('Time spent freezing (s)')
title('All mice')
subplot(122)
MakeSpreadAndBoxPlot2_SB({AllTimeSpent.Cond.Fz_Shock(15:end) , AllTimeSpent.Cond.Fz_Safe(15:end)},Cols,X,Legends,'showpoints',0,'paired',1);
ylim([-50 1200]); 
title('All mice with regular protocol')

a=suptitle('Time spent freezing, Dima mice'); a.FontSize=20;





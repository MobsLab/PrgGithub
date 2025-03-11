close all
Mouse_names_NicHC = {'M1411','M1412','M1413','M1414','M1415','M1416','M1417','M1418','M1385','M1393'};
Mouse_names_SalHC = {'M1411','M1412','M1414','M1416','M1417','M1418','M1207','M1224','M1225','M1227','M1252','M1253','M1254'};

Mouse_names = Mouse_names_NicHC;


for mouse = 1:length(Mouse_names)
    clearvars -except mouse Mouse_names
    close all
    GetNicotineSessions_CH
    Name = {'SalineOF','NicotineOF','NicotineLowOF','SalineHC','NicotineHC','DiazepamHC'};
    EpochName = {'HCPre','HCPost'};
    Session_type = {'OFPre','OFPost'};
    
    smootime = 1;
    interp_value = 100;
    
    sizeMap = 100;
    sizeMap2 = 1000;
    
    path = sprintf('%s{%d}', Name{5}, mouse);
    folder_path = eval(path);
    cd(folder_path);
    disp(folder_path);
    load('behavResources.mat')
    load('B_Low_Spectrum.mat')
    load('SleepScoring_OBGamma.mat')
    OBtsd = tsd(Spectro{2}*1e4 , Spectro{1});
    
    EpochDrugs1 = Stop(Epoch_Drugs{1});
    EpochDrugs2 = Start(Epoch_Drugs{2});
    
    Fifteen_Bef_Inj = intervalSet(EpochDrugs1-900e4 , EpochDrugs1);
    Fifteen_Aft_Inj = intervalSet(EpochDrugs2 , EpochDrugs2+900e4);
    
    AcceleroPre = Restrict(MovAcctsd,Fifteen_Bef_Inj);
    AcceleroPost = Restrict(MovAcctsd,Fifteen_Aft_Inj);
    
    
    SpeedPre = Restrict(Vtsd,Fifteen_Bef_Inj);
    SpeedPost = Restrict(Vtsd,Fifteen_Aft_Inj);
    
    thtps_immob=2;
    smoofact_Acc = 20;
    th_immob_Acc = 1.7e7;
    
    NewMovAcctsd=tsd(Range(MovAcctsd),runmean(Data(MovAcctsd),smoofact_Acc));
    FreezeAccEpoch2=thresholdIntervals(NewMovAcctsd,th_immob_Acc,'Direction','Below');
    FreezeAccEpoch2=mergeCloseIntervals(FreezeAccEpoch2,0.3*1e4);
    FreezeAccEpoch2=dropShortIntervals(FreezeAccEpoch2,thtps_immob*1e4);
    FreezeAccEpoch2 = FreezeAccEpoch2 - Sleep;

    FreezeEpochAccPre = and(FreezeAccEpoch,Fifteen_Bef_Inj);
    FreezeEpochAccPost = and(FreezeAccEpoch,Fifteen_Aft_Inj);
    FreezeEpochAccPre2 = and(FreezeAccEpoch2,Fifteen_Bef_Inj);
    FreezeEpochAccPost2 = and(FreezeAccEpoch2,Fifteen_Aft_Inj);
    
    
    FreezeTimeAccPre = sum(DurationEpoch(FreezeEpochAccPre))./1e4
    FreezeTimeAccPost = sum(DurationEpoch(FreezeEpochAccPost))./1e4
    
      FreezeTimeAccPre2 = sum(DurationEpoch(FreezeEpochAccPre2))./1e4
    FreezeTimeAccPost2 = sum(DurationEpoch(FreezeEpochAccPost2))./1e4
  
    FreezePropPre = FreezeTimeAccPre./sum(DurationEpoch(Fifteen_Bef_Inj)/1e4)
    FreezePropPost = FreezeTimeAccPost./sum(DurationEpoch(Fifteen_Aft_Inj)/1e4)
    
    FreezePropPre2 = FreezeTimeAccPre2./sum(DurationEpoch(Fifteen_Bef_Inj)/1e4)
    FreezePropPost2 = FreezeTimeAccPost2./sum(DurationEpoch(Fifteen_Aft_Inj)/1e4)
    
    OB_Sp_tsdPre = Restrict(OBtsd,Fifteen_Bef_Inj);
    OB_Sp_tsdPost = Restrict(OBtsd,Fifteen_Aft_Inj);
    
    
    MeanSpectroPre = nanmean(Data(OB_Sp_tsdPre));
    MeanSpectroPost = nanmean(Data(OB_Sp_tsdPost));
    
    SpectroBulbFzPre = Restrict(OB_Sp_tsdPre, FreezeEpochAccPre);
    SpectroBulbFzPost = Restrict(OB_Sp_tsdPost, FreezeEpochAccPost);
    
    MeanSpectroFzPre = nanmean(Data(SpectroBulbFzPre));
    MeanSpectroFzPre = nanmean(Data(SpectroBulbFzPre));
    
    
    Respi = ConvertSpectrum_in_Frequencies_BM(Spectro{3} , Spectro{2}*1e4 , Spectro{1});
    RespiPre = Restrict(Respi,Fifteen_Bef_Inj);
    RespiPost = Restrict(Respi,Fifteen_Aft_Inj);
    
    
    RespiFzPre = Restrict(RespiPre,FreezeEpochAccPre);
    RespiFzPost = Restrict(RespiPost,FreezeEpochAccPost);
    
    
    MeanRespiFzPre = nanmean(Data(RespiFzPre));
    MeanRespiFzPost = nanmean(Data(RespiFzPost));
    
    
    XtsdAlignedPre = Restrict(AlignedXtsd,Fifteen_Bef_Inj);
    XtsdAlignedPost = Restrict(AlignedXtsd,Fifteen_Aft_Inj);
    
    YtsdAlignedPre = Restrict(AlignedYtsd,Fifteen_Bef_Inj);
    YtsdAlignedPost = Restrict(AlignedYtsd,Fifteen_Aft_Inj);
    
    %     figure
    %     subplot(2,4,1)
    %     plot(Data(XtsdAlignedPre),Data(YtsdAlignedPre))
    %     vline(0,'r--')
    %     vline(40,'r--')
    %     hline(0,'r--')
    %     hline(20,'r--')
    %
    % %     imagesc(OccupMaptemp.HCPre), axis xy
    %     subplot(2,4,2)
    %     plot(Data(XtsdAlignedPost),Data(YtsdAlignedPost))
    %     vline(0,'r--')
    %     vline(40,'r--')
    %     hline(0,'r--')
    %     hline(20,'r--')
    
    %     imagesc(OccupMaptemp.HCPost), axis xy
    %     subplot(2,4,3:4), hold on
    %     plot(Range(AcceleroPre),Data(AcceleroPre),'k');
    %     plot(Range(AcceleroPost),Data(AcceleroPost),'k');
    %     plot(Range(Restrict(AcceleroPre,FreezeEpochAccPre)),Data(Restrict(AcceleroPre,FreezeEpochAccPre)),'r');
    %     plot(Range(Restrict(AcceleroPost,FreezeEpochAccPost)),Data(Restrict(AcceleroPost,FreezeEpochAccPost)),'r');
    % %     subplot(2,4,5:6), hold on
    %     b1 = bar([1:15],FreezeTime(1,:));
    %     b2 = bar([16:30],FreezeTime(2,:));
    %     b1.FaceColor = [0,0,0];
    %     b2.FaceColor = [0,0,0];
    %     b3 = plot([1:15],RespiTempMean(1,:));
    %     b4 = plot([16:30],RespiTempMean(2,:));
    
    % mtitle(Mouse_names{mouse});
    %
    figure
    % subplot(2,4,5:8)
    plot(Range(MovAcctsd),Data(MovAcctsd),'k')
    hold on
    plot(Range(Restrict(MovAcctsd,FreezeAccEpoch)),Data(Restrict(MovAcctsd,FreezeAccEpoch)),'r')
    plot(Range(Restrict(MovAcctsd,EpochDrugs2)),Data(Restrict(MovAcctsd,EpochDrugs2)),'g.','MarkerSize',30)
    plot(Range(Restrict(MovAcctsd,EpochDrugs1)),Data(Restrict(MovAcctsd,EpochDrugs1)),'g.','MarkerSize',30)
    xlim([0,max(Range(MovAcctsd))])
    plot(Range(SmoothGamma),Data(SmoothGamma)*1e6,'g');
    hline(gamma_thresh2*1e6,'g--')
    PlotPerAsLine(FreezeAccEpoch, 1e9, 'k', 'linewidth',2,'timescaling',1)
    xlim([Start(Fifteen_Bef_Inj) Stop(Fifteen_Aft_Inj)])
    
    title(Mouse_names{mouse});
    % vline(EpochDrugs2,'r--')
    keyboard
    saveFigure_BM(1,Mouse_names{mouse},'/home/greta/Dropbox/Mobs_member/ChloeHayhurst/Data/Nicotine')
    
end

clear all
Cols = {'k','r'};
enregistrements{1} = { ...
    '/media/nas7/ProjetPFCVLPO/M1423/20230320/BaselineSleep/CTRL_PFC_VLPO_1423_baselinesleep_230320_083012/';
    '/media/nas7/ProjetPFCVLPO/M1424/20230320/BaselineSleep/CTRL_PFC_VLPO_1424_baselinesleep_230320_083012/';
    '/media/nas7/ProjetPFCVLPO/M1425/20230320/BaselineSleep/CTRL_PFC_VLPO_1425_baselinesleep_230320_083012/';
    '/media/nas7/ProjetPFCVLPO/M1426/20230320/BaselineSleep/CTRL_PFC_VLPO_1426_baselinesleep_230320_083012/';
    '/media/nas7/ProjetPFCVLPO/M1433/20230419/BaselineSleep/CTRL_PFC_VLPO_1433_BaselineSleep_230419_091255/';
    % '/media/nas7/ProjetPFCVLPO/M1434/20230419/BaselineSleep/CTRL_PFC_VLPO_1434_BaselineSleep_230419_091255/';
    '/media/nas7/ProjetPFCVLPO/M1449/20230517/Sleep_SalineInjection_10h/CTRL_1449_saline_10h_230517_100502/';
    '/media/nas7/ProjetPFCVLPO/M1450/20230517/Sleep_SalineInjection_10h/CTRL_1450_saline_10h_230517_100502/';
    '/media/nas7/ProjetPFCVLPO/M1451/20230517/Sleep_SalineInjection_10h/CTRL_1451_saline_10h_230517_100502/';
    '/media/nas7/ProjetPFCVLPO/M1414/20230615/Sleep_SalineInjection_10h/BM_1414_Sleep_saline_10h_230615_100317/';
    '/media/nas7/ProjetPFCVLPO/M1439/20230601/Sleep_SalineInjection_10h/BM_1439_saline_10h_230601_095914/';
    '/media/nas7/ProjetPFCVLPO/M1440/20230601/Sleep_SalineInjection_10h/BM_1440_saline_10h_230601_095914/';
    '/media/nas7/ProjetPFCVLPO/M1437/20230615/Sleep_SalineInjection_10h/BM_1437_Sleep_saline_10h_230615_100317/';
    };


enregistrements{2} = { ...
    '/media/nas6/ProjetPFCVLPO/M1148/20210520/SocialDefeat/SleepPostSD/DREADD_1148_SleepPostSD_210520_103704/'
    '/media/nas6/ProjetPFCVLPO/M1149/20210520/SocialDefeat/SleepPostSD/DREADD_1149_SleepPostSD_210520_103704/'
    '/media/nas6/ProjetPFCVLPO/M1150/20210520/SocialDefeat/SleepPostSD/DREADD_1150_SleepPostSD_210520_103704/'
    '/media/nas6/ProjetPFCVLPO/M1217/20210804/SocialDefeat/SleepPostSD/DREADD_1217_SleepPostSD_210804_100450/'
    '/media/nas6/ProjetPFCVLPO/M1218/20210804/SocialDefeat/SleepPostSD/DREADD_1218_SleepPostSD_210804_100450/'
    '/media/nas6/ProjetPFCVLPO/M1219/20210818/SocialDefeat/SleepPostSD/DREADD_1219_SleepPostSD_210818_102638/'
    '/media/nas7/ProjetPFCVLPO/M1449/20230525/SocialDefeat_SalineInjection/SleepPostSD_SalineInjection/CTRL_1449_sleepPostSD_230525_100459/'
    '/media/nas7/ProjetPFCVLPO/M1450/20230525/SocialDefeat_SalineInjection/SleepPostSD_SalineInjection/CTRL_1450_sleepPostSD_230525_100459/'
    '/media/nas7/ProjetPFCVLPO/M1416/20230616/SocialDefeat_SalineInjection/SleepPostSD_SalineInjecton/BM_1416_SleepPostSD_saline_230616_100541/'
    '/media/nas7/ProjetPFCVLPO/M1437/20230616/SocialDefeat_SalineInjection/SleepPostSD_SalineInjecton/BM_1437_SleepPostSD_saline_230616_100541/'
    };

Lim = [4.1,4.1];

for grp = 1:2
    for mm = 1:length(enregistrements{grp})
        cd(enregistrements{grp}{mm})
        mm
        % load SeepScoring
        load('SleepScoring_Accelero.mat','REMEpoch','Wake','SWSEpoch','tsdMovement')
        
        Epoch = intervalSet(0*3600*1e4,7.5*3600*1e4);
        Wake = and(Wake,Epoch);
        REMEpoch = and(REMEpoch,Epoch);
        SWSEpoch = and(SWSEpoch,Epoch);
        maxtime{grp}(mm) = max(Range(Restrict(tsdMovement,Epoch),'min'));
        
        StpREM = Stop(REMEpoch, 's');
        StrtREM = Start(REMEpoch,'s');
        RemDur{grp}{mm} = StpREM - StrtREM;
        RemDur{grp}{mm}(end) = [];
        RemInterval{grp}{mm} = StrtREM(2:end) - StpREM(1:end-1);
        SeqNREM = intervalSet(0,0);
        SingleNREM = intervalSet(0,0);
        SeqREM = intervalSet(0,0);
        SingleREM = intervalSet(0,0);
        
        for rr = 1:length(StrtREM)-1
            MiniEpoch = intervalSet(StpREM(rr)*1e4,StrtREM(rr+1)*1e4);
            MiniEpoch_NREM = and(MiniEpoch,SWSEpoch);
            RemInterval_SWS{grp}{mm}(rr) = sum(Stop(MiniEpoch_NREM) - Start(MiniEpoch_NREM))/1e4;
            
            if log(RemInterval_SWS{grp}{mm}(rr))<Lim(grp)
                SeqNREM = or(SeqNREM,MiniEpoch_NREM);
                SeqREM = or(SeqREM,intervalSet(StrtREM(rr)*1e4,StpREM(rr)*1e4));
                
            else
                SingleNREM = or(SingleNREM,MiniEpoch_NREM);
                SingleREM = or(SingleREM,intervalSet(StrtREM(rr)*1e4,StpREM(rr)*1e4));
                
            end
        end
        
        load('Bulb_deep_Low_Spectrum.mat')
        Sptsd = tsd(Spectro{2}*1e4,(Spectro{1}));
        MeanSpec.OB.Single(grp,mm,:) = nanmean(Data(Restrict(Sptsd,SingleNREM)));
        MeanSpec.OB.Seq(grp,mm,:) = nanmean(Data(Restrict(Sptsd,SeqNREM)));
        MeanSpec.OB.All(grp,mm,:) = nanmean(Data(Restrict(Sptsd,SWSEpoch)));
        MeanSpec.OB.SingleR(grp,mm,:) = nanmean(Data(Restrict(Sptsd,SingleREM)));
        MeanSpec.OB.SeqR(grp,mm,:) = nanmean(Data(Restrict(Sptsd,SeqREM)));
        
        load('dHPC_deep_Low_Spectrum.mat')
        Sptsd = tsd(Spectro{2}*1e4,(Spectro{1}));
        MeanSpec.dHPC.Single(grp,mm,:) = nanmean(Data(Restrict(Sptsd,SingleNREM)));
        MeanSpec.dHPC.Seq(grp,mm,:) = nanmean(Data(Restrict(Sptsd,SeqNREM)));
        MeanSpec.dHPC.All(grp,mm,:) = nanmean(Data(Restrict(Sptsd,SWSEpoch)));
        MeanSpec.dHPC.SingleR(grp,mm,:) = nanmean(Data(Restrict(Sptsd,SingleREM)));
        MeanSpec.dHPC.SeqR(grp,mm,:) = nanmean(Data(Restrict(Sptsd,SeqREM)));
        
        try,load('PFCx_sup_Low_Spectrum.mat')
        catch
            load('PFCx_deep_Low_Spectrum.mat')
        end
        Sptsd = tsd(Spectro{2}*1e4,(Spectro{1}));
        MeanSpec.PFC.Single(grp,mm,:) = nanmean(Data(Restrict(Sptsd,SingleNREM)));
        MeanSpec.PFC.Seq(grp,mm,:) = nanmean(Data(Restrict(Sptsd,SeqNREM)));
        MeanSpec.PFC.All(grp,mm,:) = nanmean(Data(Restrict(Sptsd,SWSEpoch)));
        MeanSpec.PFC.SingleR(grp,mm,:) = nanmean(Data(Restrict(Sptsd,SingleREM)));
        MeanSpec.PFC.SeqR(grp,mm,:) = nanmean(Data(Restrict(Sptsd,SeqREM)));
        
        
    end
    
    
end


Regions = fieldnames(MeanSpec);
Type = fieldnames(MeanSpec.PFC);
f = Spectro{3};
figure
for reg = 1:length(Regions)
    for grp = 1:2
        subplot(2,3,reg+3*(grp-1))
        dat = squeeze(MeanSpec.(Regions{reg}).Single(grp,:,:));
        dat(find(sum(sum(dat,3)')==0),:) = [];
        dat =  dat./repmat(mean(dat'),249,1)';
        shadedErrorBar(f,log(nanmean(dat)),(stdError(dat)),'k')
        hold on
        dat = squeeze(MeanSpec.(Regions{reg}).Seq(grp,:,:));
        dat(find(sum(sum(dat,3)')==0),:) = [];
        dat =  dat./repmat(mean(dat'),249,1)';
        shadedErrorBar(f,log(nanmean(dat)),(stdError(dat)),'r')
        title(Regions{reg})
    end
end


Regions = fieldnames(MeanSpec);
Type = fieldnames(MeanSpec.PFC);
figure
for reg = 1:length(Regions)
    %     for grp = 1:2
    
    subplot(1,3,reg)
    dat = squeeze(MeanSpec.(Regions{reg}).All(1,:,:));
    dat(find(sum(dat')==0),:) = [];
    dat =  dat./repmat(mean(dat'),249,1)';
    shadedErrorBar(f,log(nanmean(dat)),(stdError(dat)),'k')
    hold on
    dat = squeeze(MeanSpec.(Regions{reg}).All(2,:,:));
    dat(find(sum(isnan(dat)')),:) = [];
    dat =  dat./repmat(mean(dat'),249,1)';
    shadedErrorBar(f,log(nanmean(dat)),(stdError(dat)),'r')
    title(Regions{reg})
    
end
    subplot(3,3,reg+3)
    dat = squeeze(MeanSpec.(Regions{reg}).Single(1,:,:));
    dat(find(sum(dat')==0),:) = [];
    dat =  dat./repmat(mean(dat'),249,1)';
    shadedErrorBar(f,log(nanmean(dat)),(stdError(dat)),'k')
    hold on
    dat = squeeze(MeanSpec.(Regions{reg}).Single(2,:,:));
    dat(find(sum(dat')==0),:) = [];
    dat =  dat./repmat(mean(dat'),249,1)';
    shadedErrorBar(f,log(nanmean(dat)),(stdError(dat)),'r')
    title(Regions{reg})
    
    subplot(3,3,reg+6)
    dat = squeeze(MeanSpec.(Regions{reg}).Seq(1,:,:));
    dat(find(sum(dat')==0),:) = [];
    dat =  dat./repmat(mean(dat'),249,1)';
    shadedErrorBar(f,(nanmean(dat)),(stdError(dat)),'k')
    hold on
    dat = squeeze(MeanSpec.(Regions{reg}).Seq(2,:,:));
    dat(find(sum(dat')==0),:) = [];
    dat =  dat./repmat(mean(dat'),249,1)';
    shadedErrorBar(f,(nanmean(dat)),(stdError(dat)),'r')
    title(Regions{reg})
    %     end
end


Regions = fieldnames(MeanSpec);
Type = fieldnames(MeanSpec.PFC);
figure
for reg = 1:length(Regions)
    for grp = 1:2
        subplot(2,3,reg+3*(grp-1))
        dat = squeeze(MeanSpec.(Regions{reg}).SingleR(grp,:,:));
        dat(find(sum(dat')==0),:) = [];
        plot(Spectro{3},(nanmean(dat)),'k')
        hold on
        dat = squeeze(MeanSpec.(Regions{reg}).SeqR(grp,:,:));
        dat(find(sum(dat')==0),:) = [];
        plot(Spectro{3},(nanmean(dat)),'r')
        title(Regions{reg})
    end
end

    
    
    
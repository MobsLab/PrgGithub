clear all
Cols = {'k','r'};
enregistrements{1} = { ...
    '/media/nas7/ProjetPFCVLPO/M1449/20230517/Sleep_SalineInjection_10h/CTRL_1449_saline_10h_230517_100502/';
    '/media/nas7/ProjetPFCVLPO/M1450/20230517/Sleep_SalineInjection_10h/CTRL_1450_saline_10h_230517_100502/';
    '/media/nas7/ProjetPFCVLPO/M1437/20230615/Sleep_SalineInjection_10h/BM_1437_Sleep_saline_10h_230615_100317/';
    };


enregistrements{2} = { ...
    '/media/nas6/ProjetPFCVLPO/M1149/20210520/SocialDefeat/SleepPostSD/DREADD_1149_SleepPostSD_210520_103704/'
    '/media/nas6/ProjetPFCVLPO/M1150/20210520/SocialDefeat/SleepPostSD/DREADD_1150_SleepPostSD_210520_103704/'
    '/media/nas7/ProjetPFCVLPO/M1437/20230616/SocialDefeat_SalineInjection/SleepPostSD_SalineInjecton/BM_1437_SleepPostSD_saline_230616_100541/'
    };

Lim = [4.2,4.2];

for grp = 1:2
    for mm = 1:length(enregistrements{grp})
        cd(enregistrements{grp}{mm})
        mm
        % load SeepScoring
        load('SleepScoring_Accelero.mat','REMEpoch','Wake','SWSEpoch','tsdMovement')
        
        Epoch = intervalSet(0*3600*1e4,7.8*3600*1e4);
        Wake = and(Wake,Epoch);
        REMEpoch = and(REMEpoch,Epoch);
        SWSEpoch = and(SWSEpoch,Epoch);
        maxtime{grp}(mm) = max(Range(Restrict(tsdMovement,Epoch),'min'));
        
        StpREM = Stop(REMEpoch,'s');
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
        Sptsd = tsd(Spectro{2}*1e4,log(Spectro{1}));
        MeanSpec.OB.Single(grp,mm,:) = nanmean(Data(Restrict(Sptsd,SingleNREM)));
        MeanSpec.OB.Seq(grp,mm,:) = nanmean(Data(Restrict(Sptsd,SeqNREM)));
        MeanSpec.OB.SingleR(grp,mm,:) = nanmean(Data(Restrict(Sptsd,SingleREM)));
        MeanSpec.OB.SeqR(grp,mm,:) = nanmean(Data(Restrict(Sptsd,SeqREM)));
        
        load('dHPC_deep_Low_Spectrum.mat')
        Sptsd = tsd(Spectro{2}*1e4,log(Spectro{1}));
        MeanSpec.dHPC.Single(grp,mm,:) = nanmean(Data(Restrict(Sptsd,SingleNREM)));
        MeanSpec.dHPC.Seq(grp,mm,:) = nanmean(Data(Restrict(Sptsd,SeqNREM)));
        MeanSpec.dHPC.SingleR(grp,mm,:) = nanmean(Data(Restrict(Sptsd,SingleREM)));
        MeanSpec.dHPC.SeqR(grp,mm,:) = nanmean(Data(Restrict(Sptsd,SeqREM)));

        try,load('PFCx_sup_Low_Spectrum.mat')
        catch
            load('PFCx_deep_Low_Spectrum.mat')
        end
        Sptsd = tsd(Spectro{2}*1e4,log(Spectro{1}));
        MeanSpec.PFC.Single(grp,mm,:) = nanmean(Data(Restrict(Sptsd,SingleNREM)));
        MeanSpec.PFC.Seq(grp,mm,:) = nanmean(Data(Restrict(Sptsd,SeqNREM)));
        MeanSpec.PFC.SingleR(grp,mm,:) = nanmean(Data(Restrict(Sptsd,SingleREM)));
        MeanSpec.PFC.SeqR(grp,mm,:) = nanmean(Data(Restrict(Sptsd,SeqREM)));

        
        
    end
    
    
end


Regions = fieldnames(MeanSpec);
Type = fieldnames(MeanSpec.PFC);
figure
for reg = 1:length(Regions)
    for grp = 1:2
        subplot(2,3,reg+3*(grp-1))
        dat = squeeze(MeanSpec.(Regions{reg}).Single(grp,:,:));
        dat(find(sum(sum(dat,3)')==0),:) = [];
        plot(Spectro{3},(nanmean(dat)),'k')
        hold on
        dat = squeeze(MeanSpec.(Regions{reg}).Seq(grp,:,:));
        dat(find(sum(sum(dat,3)')==0),:) = [];
        plot(Spectro{3},(nanmean(dat)),'r')
        title(Regions{reg})
    end
end


Regions = fieldnames(MeanSpec);
Type = fieldnames(MeanSpec.PFC);
figure
for reg = 1:length(Regions)
    %     for grp = 1:2
    subplot(2,3,reg)
    dat = squeeze(MeanSpec.(Regions{reg}).Single(1,:,:));
    dat(find(sum(sum(dat,3)')==0),:) = [];
    dat =  dat./repmat(mean(dat'),249,1)';
    plot(Spectro{3},(nanmean(dat)),'k')
    hold on
    dat = squeeze(MeanSpec.(Regions{reg}).Single(2,:,:));
    dat(find(sum(sum(dat,3)')==0),:) = [];
    dat =  dat./repmat(mean(dat'),249,1)';
    plot(Spectro{3},(nanmean(dat)),'r')
    title(Regions{reg})
    
    subplot(2,3,reg+3)
    dat = squeeze(MeanSpec.(Regions{reg}).Seq(1,:,:));
    dat(find(sum(sum(dat,3)')==0),:) = [];
    dat =  dat./repmat(mean(dat'),249,1)';
    plot(Spectro{3},(nanmean(dat)),'k')
    hold on
    dat = squeeze(MeanSpec.(Regions{reg}).Seq(2,:,:));
    dat(find(sum(sum(dat,3)')==0),:) = [];
    dat =  dat./repmat(mean(dat'),249,1)';
    plot(Spectro{3},(nanmean(dat)),'r')
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
        dat(find(sum(sum(dat,3)')==0),:) = [];
        plot(Spectro{3},(nanmean(dat)),'k')
        hold on
        dat = squeeze(MeanSpec.(Regions{reg}).SeqR(grp,:,:));
        dat(find(sum(sum(dat,3)')==0),:) = [];
        plot(Spectro{3},(nanmean(dat)),'r')
        title(Regions{reg})
    end
end
    
    
% 'SoundHab' 'SoundCond' 'SoundTest' 'SoundTestPlethysmo'

Sessions = {'SoundHab' ,'SoundTest', 'SoundTestPlethysmo'};

for ss = 2
    
    Dir=PathForExperimentsMtzlProject(Sessions{ss})
    
    for d = 1:length(Dir.path)
        clf
        cd(Dir.path{d}{1})
        disp(Dir.path{d}{1})
        
        load('behavResources.mat')
        TotEpoch = intervalSet(0,max(Range(MovAcctsd)));
        
        th_immob_Acc=3E7;% see EstablishAThresholdForFreezingFromAcceleration.m
        th_2merge_FreezAcc=0.5;
        thtps_immob_Acc=2;
        SmoothFactorAcc=3;
        MovAccSmotsd=tsd(Range(MovAcctsd),SmoothDec(Data(MovAcctsd),SmoothFactorAcc));
        FreezeAccEpoch=thresholdIntervals(MovAccSmotsd,th_immob_Acc,'Direction','Below');
        FreezeAccEpoch=mergeCloseIntervals(FreezeAccEpoch,th_2merge_FreezAcc*1E4);
        FreezeAccEpoch=dropShortIntervals(FreezeAccEpoch,thtps_immob_Acc*1E4);
        
        load('B_Low_Spectrum.mat')
        sptsd=tsd(Spectro{2}*1e4,(Spectro{1}));
        OBSpecFz(d,:) = nanmean(log(Data(Restrict(sptsd,FreezeAccEpoch))));
        OBSpecNoFz(d,:) = nanmean(log(Data(Restrict(sptsd,TotEpoch-FreezeAccEpoch))));
        
        try
            load('PFCx_Low_Spectrum.mat')
            sptsd=tsd(Spectro{2}*1e4,(Spectro{1}));
            PFCxSpecFz(d,:) = nanmean(log(Data(Restrict(sptsd,FreezeAccEpoch))));
            PFCxSpecNoFz(d,:) = nanmean(log(Data(Restrict(sptsd,TotEpoch-FreezeAccEpoch))));
        catch
                
                PFCxSpecFz(d,:) = nan(1,261);
                PFCxSpecNoFz(d,:) = nan(1,261);
        end
        
        load('H_Low_Spectrum.mat')
        sptsd=tsd(Spectro{2}*1e4,(Spectro{1}));
        HSpecFz(d,:) = nanmean(log(Data(Restrict(sptsd,FreezeAccEpoch))));
        HSpecNoFz(d,:) = nanmean(log(Data(Restrict(sptsd,TotEpoch-FreezeAccEpoch))));
        
        load('H_B_Low_Coherence.mat')
        sptsd=tsd(Coherence{2}*1e4,(Coherence{1}));
        HOBCohFz(d,:) = nanmean((Data(Restrict(sptsd,FreezeAccEpoch))));
        HOBCohNoFz(d,:) = nanmean((Data(Restrict(sptsd,TotEpoch-FreezeAccEpoch))));
        
        
        try,load('PFCx_B_Low_Coherence.mat')
            sptsd=tsd(Coherence{2}*1e4,(Coherence{1}));
            POBCohFz(d,:) = nanmean((Data(Restrict(sptsd,FreezeAccEpoch))));
            POBCohNoFz(d,:) = nanmean((Data(Restrict(sptsd,TotEpoch-FreezeAccEpoch))));
        catch
            POBCohFz(d,:) = nan(1,261);
            POBCohNoFz(d,:) = nan(1,261);
        end
        
        try,load('PFCx_H_Low_Coherence.mat')
            sptsd=tsd(Coherence{2}*1e4,(Coherence{1}));
            PhCohFz(d,:) = nanmean((Data(Restrict(sptsd,FreezeAccEpoch))));
            PhCohNoFz(d,:) = nanmean((Data(Restrict(sptsd,TotEpoch-FreezeAccEpoch))));
        catch
            PhCohFz(d,:) = nan(1,261);
            PhCohNoFz(d,:) = nan(1,261);
        end


    end
end

Colors_Boxplot = [0.6,1,0.6;0.6,0.6,1];
figure
subplot(231)
hold on
line([-1 0],[-1 0],'color',Colors_Boxplot(1,:),'linewidth',2)
line([-1 0],[-1 0],'color',Colors_Boxplot(2,:),'linewidth',2)
[hl,hp]=boundedline(Spectro{3},nanmean(PhCohFz(6:9,:)),stdError(PhCohFz(6:9,:)),'alpha','g','transparency',0.2)
hold on
[hl,hp]=boundedline(Spectro{3},nanmean(PhCohFz(1:5,:)),stdError(PhCohFz(1:5,:)),'alpha','b','transparency',0.2);
title('PFC/HPC Coh - Fz')
xlabel('Frequency')
ylabel('Coh')
legend('Saline','Methimazole')
xlim([0 20])
ylim([0.3 1])
subplot(232)
[hl,hp]=boundedline(Spectro{3},nanmean(POBCohFz(6:9,:)),stdError(POBCohFz(6:9,:)),'alpha','g','transparency',0.2);
hold on
[hl,hp]=boundedline(Spectro{3},nanmean(POBCohFz(1:5,:)),stdError(POBCohFz(1:5,:)),'alpha','b','transparency',0.2);
title('PFC/OB Coh - Fz')
xlabel('Frequency')
xlim([0 20])
ylim([0.3 1])
subplot(233)
[hl,hp]=boundedline(Spectro{3},nanmean(HOBCohFz(6:9,:)),stdError(HOBCohFz(6:9,:)),'alpha','g','transparency',0.2);
hold on
[hl,hp]=boundedline(Spectro{3},nanmean(HOBCohFz(1:5,:)),stdError(HOBCohFz(1:5,:)),'alpha','b','transparency',0.2);
title('HPC+/OB Coh - Fz')
xlabel('Frequency')
xlim([0 20])
ylim([0.3 1])
subplot(234)
[hl,hp]=boundedline(Spectro{3},nanmean(PhCohNoFz(6:9,:)),stdError(PhCohNoFz(6:9,:)),'alpha','g','transparency',0.2);
hold on
[hl,hp]=boundedline(Spectro{3},nanmean(PhCohNoFz(1:5,:)),stdError(PhCohNoFz(1:5,:)),'alpha','b','transparency',0.2);
title('PFC/HPC Coh - NoFz')
xlabel('Frequency')
ylabel('Coh')
xlim([0 20])
ylim([0.3 1])
subplot(235)
[hl,hp]=boundedline(Spectro{3},nanmean(POBCohNoFz(6:9,:)),stdError(POBCohNoFz(6:9,:)),'alpha','g','transparency',0.2);
hold on
[hl,hp]=boundedline(Spectro{3},nanmean(POBCohNoFz(1:5,:)),stdError(POBCohNoFz(1:5,:)),'alpha','b','transparency',0.2);
title('PFC/OB Coh - NoFz')
xlabel('Frequency')
xlim([0 20])
ylim([0.3 1])
subplot(236)
[hl,hp]=boundedline(Spectro{3},nanmean(HOBCohNoFz(6:9,:)),stdError(HOBCohNoFz(6:9,:)),'alpha','g','transparency',0.2);
hold on
[hl,hp]=boundedline(Spectro{3},nanmean(HOBCohNoFz(1:5,:)),stdError(HOBCohNoFz(1:5,:)),'alpha','b','transparency',0.2);
title('HPC+/OB Coh - NoFz')
xlabel('Frequency')
xlim([0 20])
ylim([0.3 1])

figure
subplot(231)
hold on
line([-1 0],[-1 0],'color',Colors_Boxplot(1,:),'linewidth',2)
line([-1 0],[-1 0],'color',Colors_Boxplot(2,:),'linewidth',2)
[hl,hp]=boundedline(Spectro{3},nanmean(HSpecFz(6:9,:)),stdError(HSpecFz(6:9,:)),'alpha','g','transparency',0.2);
hold on
[hl,hp]=boundedline(Spectro{3},nanmean(HSpecFz(1:5,:)),stdError(HSpecFz(1:5,:)),'alpha','b','transparency',0.2);
title('HPC - Fz')
xlabel('Frequency')
ylabel('log pow')
legend('Saline','Methimazole')
set(gca,'Linewidth',1.5,'FontSize',12)
subplot(232)
[hl,hp]=boundedline(Spectro{3},nanmean(PFCxSpecFz(6:9,:)),stdError(PFCxSpecFz(6:9,:)),'alpha','g','transparency',0.2);
hold on
[hl,hp]=boundedline(Spectro{3},nanmean(PFCxSpecFz(1:5,:)),stdError(PFCxSpecFz(1:5,:)),'alpha','b','transparency',0.2);
title('PFC - Fz')
xlabel('Frequency')
set(gca,'Linewidth',1.5,'FontSize',12)
subplot(233)
[hl,hp]=boundedline(Spectro{3},nanmean(OBSpecFz(6:9,:)),stdError(OBSpecFz(6:9,:)),'alpha','g','transparency',0.2);
hold on
[hl,hp]=boundedline(Spectro{3},nanmean(OBSpecFz(1:5,:)),stdError(OBSpecFz(1:5,:)),'alpha','b','transparency',0.2);
title('OB - Fz')
xlabel('Frequency')
set(gca,'Linewidth',1.5,'FontSize',12)

subplot(234)
[hl,hp]=boundedline(Spectro{3},nanmean(HSpecNoFz(6:9,:)),stdError(HSpecNoFz(6:9,:)),'alpha','g','transparency',0.2);
hold on
[hl,hp]=boundedline(Spectro{3},nanmean(HSpecNoFz(1:5,:)),stdError(HSpecNoFz(1:5,:)),'alpha','b','transparency',0.2);
title('HPC - NoFz')
xlabel('Frequency')
ylabel('log pow')
set(gca,'Linewidth',1.5,'FontSize',12)
subplot(235)
[hl,hp]=boundedline(Spectro{3},nanmean(PFCxSpecNoFz(6:9,:)),stdError(PFCxSpecNoFz(6:9,:)),'alpha','g','transparency',0.2);
hold on
[hl,hp]=boundedline(Spectro{3},nanmean(PFCxSpecNoFz(1:5,:)),stdError(PFCxSpecNoFz(1:5,:)),'alpha','b','transparency',0.2);
title('PFC - NoFz')
xlabel('Frequency')
set(gca,'Linewidth',1.5,'FontSize',12)
subplot(236)
[hl,hp]=boundedline(Spectro{3},nanmean(OBSpecNoFz(6:9,:)),stdError(OBSpecNoFz(6:9,:)),'alpha','g','transparency',0.2);
hold on
[hl,hp]=boundedline(Spectro{3},nanmean(OBSpecNoFz(1:5,:)),stdError(OBSpecNoFz(1:5,:)),'alpha','b','transparency',0.2);
title('OB - NoFz')
xlabel('Frequency')
set(gca,'Linewidth',1.5,'FontSize',12)

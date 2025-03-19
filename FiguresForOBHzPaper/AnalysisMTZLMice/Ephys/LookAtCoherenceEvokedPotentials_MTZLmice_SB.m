%% figure
clear all
Dir = PathForExperimentsMtzlProject('SleepPlethysmograph');
nbin = 30;
rmpath('/home/vador/Dropbox/Kteam/PrgMatlab/Fra/UtilsStats')
num=1;
for d = 1:length(Dir.path)
    for dd = 1:length(Dir.path{d})
        cd(Dir.path{d}{dd})
        
        if (exist('NeuronModulation/NeuronMod_Respi_ZeroCross_total_nonoise'))>0
            clear Kappa pval
            load('SleepSubstages.mat')
            disp(Dir.path{d}{dd})
            
            load('BreathingInfo_ZeroCross.mat')
            
            clear C
            load('ChannelsToAnalyse/Bulb_deep.mat'); chOB = channel;
            load(['LFPData/LFP',num2str(chOB),'.mat'])
            LFPOB = LFP;
            load('ChannelsToAnalyse/PFCx_deep.mat'); chPFC = channel;
            load(['LFPData/LFP',num2str(chPFC),'.mat'])
            LFPPFC = LFP;
            load('ChannelsToAnalyse/Respi.mat'); chRESPI = channel;
            load(['LFPData/LFP',num2str(chRESPI),'.mat'])
            LFPRespi = LFP;
            
            try,load(['CohgramcDataL/Cohgram_',num2str(chOB),'_' num2str(chPFC) '.mat'])
            catch, load(['CohgramcDataL/Cohgram_',num2str(chPFC),'_' num2str(chOB) '.mat'])
            end
            Ctsd_PFC_OB = tsd(t*1e4,C);
            try,load(['CohgramcDataL/Cohgram_',num2str(chOB),'_' num2str(chRESPI) '.mat'])
            catch, load(['CohgramcDataL/Cohgram_',num2str(chRESPI),'_' num2str(chOB) '.mat'])
            end
            Ctsd_Respi_OB = tsd(t*1e4,C);
            try,load(['CohgramcDataL/Cohgram_',num2str(chRESPI),'_' num2str(chPFC) '.mat'])
            catch, load(['CohgramcDataL/Cohgram_',num2str(chPFC),'_' num2str(chRESPI) '.mat'])
            end
            Ctsd_Respi_PFC = tsd(t*1e4,C);
            
            mkdir('RespiEvokedPotentials')
            load('RespiEvokedPotentials/EvokedPotentialBySubStage.mat')
            
            for ep = 1:5
                % coherence
                Coherence_PFC_OB{ep} = nanmean(Data(Restrict(Ctsd_PFC_OB,Epoch{ep})));
                Coherence_Respi_OB{ep} = nanmean(Data(Restrict(Ctsd_Respi_OB,Epoch{ep})));
                Coherence_Respi_PFC{ep} = nanmean(Data(Restrict(Ctsd_Respi_PFC,Epoch{ep})));
                
                Coherence_PFC_OB_All{ep}{num} = nanmean(Data(Restrict(Ctsd_PFC_OB,Epoch{ep})));
                Coherence_Respi_OB_All{ep}{num} = nanmean(Data(Restrict(Ctsd_Respi_OB,Epoch{ep})));
                Coherence_Respi_PFC_All{ep}{num} = nanmean(Data(Restrict(Ctsd_Respi_PFC,Epoch{ep})));
               
                
                % respiration
                dat = Data(Restrict(Frequecytsd,Epoch{ep}));
                dat(dat>30)=[];
                [Y,X] = hist(dat,[0:1:30]);
                Breathing{ep}{num} = Y/sum(Y);
                
                %                 % evoked potential
                %                 [M,T]=PlotRipRaw(LFPRespi,Range(Restrict(Breathtsd,Epoch{ep}),'s'),500,0,0);
                %                 EvokPotRespi{ep} = T;
                %                 EvokPotRespi_All{ep}{num} = M(:,1:2);
                %                 [M,T]=PlotRipRaw(LFPOB,Range(Restrict(Breathtsd,Epoch{ep}),'s'),500,0,0);
                %                 EvokPotOB{ep} = T;
                %                 EvokPotOB_All{ep}{num} = M(:,1:2);
                %                 [M,T]=PlotRipRaw(LFPPFC,Range(Restrict(Breathtsd,Epoch{ep}),'s'),500,0,0);
                %                 EvokPotPFC{ep} = T;
                %                 EvokPotPFC_All{ep}{num} = M(:,1:2);
                EvokPotPFC_All{ep}{num} = nanmean(EvokPotPFC{ep});
                EvokPotOB_All{ep}{num} = nanmean(EvokPotOB{ep});
                EvokPotRespi_All{ep}{num} = nanmean(EvokPotRespi{ep});
            end
            %             save('RespiEvokedPotentials/EvokedPotentialBySubStage.mat','EvokPotRespi','EvokPotOB','EvokPotPFC','Breathtsd','Epoch')
                         save('RespiEvokedPotentials/CoherenceBySubstage.mat','Coherence_PFC_OB',...
                             'Coherence_Respi_OB','Coherence_Respi_PFC','f')
                         clear Coherence_Respi_OB Coherence_PFC_OB Coherence_Respi_PFC
           

                         clear EvokPotRespi EvokPotOB EvokPotPFC
            close all
            num = num+1;
        end
    end
end


%%
%% figure
clear all
Dir = PathForExperimentsMtzlProject('SleepPlethysmograph');
nbin = 30;
rmpath('/home/vador/Dropbox/Kteam/PrgMatlab/Fra/UtilsStats')
num=1;
for d = 1:length(Dir.path)
    for dd = 1:length(Dir.path{d})
        cd(Dir.path{d}{dd})
        
        if (exist('NeuronModulation/NeuronMod_Respi_ZeroCross_total_nonoise'))>0
            clear Kappa pval
            disp(Dir.path{d}{dd})
                        DRUG{num} = Dir.ExpeInfo{d}{dd}.DrugInjected;
            
            load('BreathingInfo_ZeroCross.mat')
            load('RespiEvokedPotentials/EvokedPotentialBySubStage.mat')
            load('RespiEvokedPotentials/CoherenceBySubstage.mat')
            DRUG{num} = Dir.ExpeInfo{d}{dd}.DrugInjected;

            for ep = 1:5
                % coherence
                Coherence_PFC_OB_All{ep}{num} = Coherence_PFC_OB{ep};
                Coherence_Respi_OB_All{ep}{num} = Coherence_Respi_OB{ep};
                Coherence_Respi_PFC_All{ep}{num} = Coherence_Respi_PFC{ep};
                
                % respiration
                dat = Data(Restrict(Frequecytsd,Epoch{ep}));
                dat(dat>30)=[];
                [Y,X] = hist(dat,[0:1:30]);
                Breathing{ep}{num} = Y/sum(Y);
                
                EvokPotPFC_All{ep}{num} = nanmean(EvokPotPFC{ep});
                EvokPotOB_All{ep}{num} = nanmean(EvokPotOB{ep});
                EvokPotRespi_All{ep}{num} = nanmean(EvokPotRespi{ep});
            end
                        

            num = num+1;
        end
    end
end

save('LFPResults_coh_evokpot.mat','EvokPotPFC_All','EvokPotOB_All','EvokPotRespi_All','Breathing','Coherence_PFC_OB',...
    'Coherence_Respi_OB','Coherence_Respi_PFC','DRUG')
                

DRUG{1} = 'SALINE';
DRUG{2} = 'SALINE';
DRUG{6} = 'MTZLRecovery';
load('SleepSubstages.mat')
tps = [-0.5:1/1250:0.5];
clf
for ep=1:5
    
    AllOB.METHIMAZOLE=[];
    AllOB.SALINE=[];
    AllOB.MTZLRecovery=[];
   
    
    for mm = 1:num-1
        AllOB.(DRUG{mm}) = [AllOB.(DRUG{mm}); EvokPotRespi_All{ep}{mm}];
    end

subplot(5,3,(ep-1)*3+1)
plot(tps,AllOB.METHIMAZOLE','r')
hold on
plot(tps,AllOB.SALINE','b')
plot(tps,AllOB.MTZLRecovery','m')
title(NameEpoch{ep})

subplot(5,3,(ep-1)*3+2)
plot(tps,zscore(AllOB.METHIMAZOLE'),'r')
hold on
plot(tps,zscore(AllOB.SALINE'),'b')
plot(tps,zscore(AllOB.MTZLRecovery'),'m')
title(NameEpoch{ep})

subplot(5,3,(ep-1)*3+3)
plot(tps,zscore(AllOB.METHIMAZOLE'))
title(NameEpoch{ep})

end

legend('794','775','778')

clf
for ep=1:5
    
    AllCoh_PFC_OB.METHIMAZOLE=[];
    AllCoh_PFC_OB.SALINE=[];
    AllCoh_PFC_OB.MTZLRecovery=[];
    AllCoh_PFC_Respi.METHIMAZOLE=[];
    AllCoh_PFC_Respi.SALINE=[];
    AllCoh_PFC_Respi.MTZLRecovery=[];
    AllCoh_Respi_OB.METHIMAZOLE=[];
    AllCoh_Respi_OB.SALINE=[];
    AllCoh_Respi_OB.MTZLRecovery=[];
    
    for mm = 1:num-1
        AllCoh_PFC_OB.(DRUG{mm}) = [AllCoh_PFC_OB.(DRUG{mm}); Coherence_PFC_OB_All{ep}{mm}];
        AllCoh_Respi_OB.(DRUG{mm}) = [AllCoh_Respi_OB.(DRUG{mm}); Coherence_Respi_OB_All{ep}{mm}];
        AllCoh_PFC_Respi.(DRUG{mm}) = [AllCoh_PFC_Respi.(DRUG{mm}); Coherence_Respi_PFC_All{ep}{mm}];
    end
    
    subplot(5,3,(ep-1)*3+1)
    plot(f,AllCoh_PFC_OB.METHIMAZOLE','r')
    hold on
    plot(f,AllCoh_PFC_OB.SALINE','b')
    plot(f,AllCoh_PFC_OB.MTZLRecovery','m')
    ylim([0.2 0.9])
    title(NameEpoch{ep})
    ylabel('coherence')
    subplot(5,3,(ep-1)*3+2)
    plot(f,AllCoh_Respi_OB.METHIMAZOLE','r')
    hold on
    plot(f,AllCoh_Respi_OB.SALINE','b')
    plot(f,AllCoh_Respi_OB.MTZLRecovery','m')
    ylim([0.2 0.9])
    title(NameEpoch{ep})
    ylabel('coherence')
    subplot(5,3,(ep-1)*3+3)
    plot(f,AllCoh_PFC_Respi.METHIMAZOLE','r')
    hold on
    plot(f,AllCoh_PFC_Respi.SALINE','b')
    plot(f,AllCoh_PFC_Respi.MTZLRecovery','m')
    ylim([0.2 0.9])
    title(NameEpoch{ep})
    ylabel('coherence')
    
end



%% figure
clear all
Dir = PathForExperimentsMtzlProject('SleepPlethysmograph');
nbin = 30;
rmpath('/home/vador/Dropbox/Kteam/PrgMatlab/Fra/UtilsStats')
num=1;
for d = 1:length(Dir.path)
    for dd = 1:length(Dir.path{d})
        cd(Dir.path{d}{dd})
        
        if (exist('NeuronModulation/NeuronMod_Respi_ZeroCross_total_nonoise'))>0
            clear Kappa pval
            load('SleepSubstages.mat')
            disp(Dir.path{d}{dd})
            
            load('BreathingInfo_ZeroCross.mat')
            %             load(['LFPData/InfoLFP.mat'])
            %             channel_accelero = InfoLFP.channel(strcmp(InfoLFP.structure,'Accelero'));
            %             for ch = 1:length(channel_accelero)
            %                 load(['LFPData/LFP',num2str(channel_accelero(ch)),'.mat'])
            load('behavResources.mat')
            
            for ep = 1:5
                
                % evoked potential
                [M,T]=PlotRipRaw(MovAcctsd,Range(Restrict(Breathtsd,Epoch{ep}),'s'),500,0,0);
                EvokPotAcceleroAv{ep} = T;
                
            end
            %             end
            save('RespiEvokedPotentials/EvokedPotentialAcceleroBySubStage.mat','EvokPotAcceleroAv','-append')
            
            
            clear EvokPotAcceleroAv
            close all
            num = num+1;
        end
    end
end

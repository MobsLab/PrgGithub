DataLocationPFCMultipleDepths
for m=4
    cc=1;
    for ff=1:length(Filename{m})
        
        cd(Filename{m}{ff})
        load('behavResources.mat')
        if exist('Behav')
            try
                FreezeEpoch=Behav.FreezeAccEpoch;
            catch
                FreezeEpoch=Behav.FreezeEpoch;
            end
            TotEpoch=intervalSet(0,max(Range(Behav.Movtsd)));
            load('StateEpochSB.mat')
            FreezeEpoch=FreezeEpoch-SleepyEpoch;
            
        else
            try
                FreezeEpoch=Behav.FreezeAccEpoch;
            catch
            end
            TotEpoch=intervalSet(0,max(Range(Movtsd)));
        end
        
        if sum(Stop(FreezeEpoch,'s')-Start(FreezeEpoch,'s'))>10
            
            figure(1)
            load('PFCLocbis_High_Spectrum.mat'); Sptsd=tsd(Spectro{2}*1e4,log(Spectro{1}));
            subplot(121)
            plot(Spectro{3},mean(Data(Restrict(Sptsd,FreezeEpoch))),'k'), hold on
            subplot(122)
            plot(Spectro{3},mean(Data(Restrict(Sptsd,TotEpoch-FreezeEpoch))),'k'), hold on
            load('PFCLocbisE1_High_Spectrum.mat');Sptsd=tsd(Spectro{2}*1e4,log(Spectro{1}));
            subplot(121)
            plot(Spectro{3},mean(Data(Restrict(Sptsd,FreezeEpoch))),'r'), hold on
            subplot(122)
            plot(Spectro{3},mean(Data(Restrict(Sptsd,TotEpoch-FreezeEpoch))),'r'), hold on
            load('PFCLocbisE2_High_Spectrum.mat');Sptsd=tsd(Spectro{2}*1e4,log(Spectro{1}));
            subplot(121)
            plot(Spectro{3},mean(Data(Restrict(Sptsd,FreezeEpoch))),'r'), hold on
            subplot(122)
            plot(Spectro{3},mean(Data(Restrict(Sptsd,TotEpoch-FreezeEpoch))),'r'), hold on
            
            
            figure(2)
            load('PFCLocbis_Low_Spectrum.mat');Sptsd=tsd(Spectro{2}*1e4,log(Spectro{1}));
            subplot(121)
            plot(Spectro{3},mean(Data(Restrict(Sptsd,FreezeEpoch))),'k','linewidth',3), hold on
            subplot(122)
            plot(Spectro{3},mean(Data(Restrict(Sptsd,TotEpoch-FreezeEpoch))),'k','linewidth',3), hold on
            load('PFCLocbisE1_Low_Spectrum.mat');Sptsd=tsd(Spectro{2}*1e4,log(Spectro{1}));
            subplot(121)
            plot(Spectro{3},mean(Data(Restrict(Sptsd,FreezeEpoch))),'r'), hold on
            subplot(122)
            plot(Spectro{3},mean(Data(Restrict(Sptsd,TotEpoch-FreezeEpoch))),'r'), hold on
            load('PFCLocbisE2_Low_Spectrum.mat');Sptsd=tsd(Spectro{2}*1e4,log(Spectro{1}));
            subplot(121)
            plot(Spectro{3},mean(Data(Restrict(Sptsd,FreezeEpoch))),'r'), hold on
            subplot(122)
            plot(Spectro{3},mean(Data(Restrict(Sptsd,TotEpoch-FreezeEpoch))),'r'), hold on
            
            
            figure(5)
            load('PFCLocbis_B_Low_Coherence.mat');Sptsd=tsd(Coherence{2}*1e4,Coherence{1});
            subplot(121)
            plot(Coherence{3},mean(Data(Restrict(Sptsd,FreezeEpoch))),'k','linewidth',3), hold on
            subplot(122)
            plot(Coherence{3},mean(Data(Restrict(Sptsd,TotEpoch-FreezeEpoch))),'k','linewidth',3), hold on
            load('PFCLocbisE1_B_Low_Coherence.mat');Sptsd=tsd(Coherence{2}*1e4,Coherence{1});
            subplot(121)
            plot(Coherence{3},mean(Data(Restrict(Sptsd,FreezeEpoch))),'r'), hold on
            subplot(122)
            plot(Coherence{3},mean(Data(Restrict(Sptsd,TotEpoch-FreezeEpoch))),'r'), hold on
            load('PFCLocbisE2_B_Low_Coherence.mat');Sptsd=tsd(Coherence{2}*1e4,Coherence{1});
            subplot(121)
            plot(Coherence{3},mean(Data(Restrict(Sptsd,FreezeEpoch))),'r'), hold on
            subplot(122)
            plot(Coherence{3},mean(Data(Restrict(Sptsd,TotEpoch-FreezeEpoch))),'r'), hold on
            
            
            figure(6)
            load('PFCLocbis_H_Low_Coherence.mat');Sptsd=tsd(Coherence{2}*1e4,Coherence{1});
            subplot(121)
            plot(Coherence{3},mean(Data(Restrict(Sptsd,FreezeEpoch))),'k','linewidth',3), hold on
            subplot(122)
            plot(Coherence{3},mean(Data(Restrict(Sptsd,TotEpoch-FreezeEpoch))),'k','linewidth',3), hold on
            load('PFCLocbisE1_H_Low_Coherence.mat');Sptsd=tsd(Coherence{2}*1e4,Coherence{1});
            subplot(121)
            plot(Coherence{3},mean(Data(Restrict(Sptsd,FreezeEpoch))),'r'), hold on
            subplot(122)
            plot(Coherence{3},mean(Data(Restrict(Sptsd,TotEpoch-FreezeEpoch))),'r'), hold on
            load('PFCLocbisE2_H_Low_Coherence.mat');Sptsd=tsd(Coherence{2}*1e4,Coherence{1});
            subplot(121)
            plot(Coherence{3},mean(Data(Restrict(Sptsd,FreezeEpoch))),'r'), hold on
            subplot(122)
            plot(Coherence{3},mean(Data(Restrict(Sptsd,TotEpoch-FreezeEpoch))),'r'), hold on
            
            
            cd('/home/vador/Dropbox/Mobs_member/SophieBagur/LocalPFC')
            figure(1)
            subplot(121)
            title('freezing')
            legend('PFC1','PFC2','PFCLocbis')
            box off
            ylabel('Frequency -Hz')
            xlabel('power')
            line([3 3],ylim); line([6 6],ylim)
            subplot(122)
            title('nofreezing')
            legend('PFC1','PFC2','PFCLocbis')
            box off
            ylabel('Frequency -Hz')
            xlabel('power')
            line([3 3],ylim); line([6 6],ylim)
            saveas(1,['Mouse',num2str(mouseNum{m}),'Session',num2str(ff),'SpecHiPFC.fig'])
            saveas(1,['Mouse',num2str(mouseNum{m}),'Session',num2str(ff),'SpecHiPFC.png'])
            figure(2)
            subplot(121)
            title('freezing')
            legend('PFC1','PFC2','PFCLocbis')
            box off
            ylabel('Frequency -Hz')
            xlabel('power')
            line([3 3],ylim); line([6 6],ylim)
            subplot(122)
            title('nofreezing')
            legend('PFC1','PFC2','PFCLocbis')
            box off
            ylabel('Frequency -Hz')
            xlabel('power')
            line([3 3],ylim); line([6 6],ylim)
            saveas(2,['Mouse',num2str(mouseNum{m}),'Session',num2str(ff),'SpecLowPFC.fig'])
            saveas(2,['Mouse',num2str(mouseNum{m}),'Session',num2str(ff),'SpecLowPFC.png'])

            figure(3)
            subplot(121)
            title('freezing')
            legend('PFC1','PFC2','PFCLocbis')
            box off
            ylabel('Frequency -Hz')
            xlabel('coherence')
            ylim([0.2 1])
            line([3 3],ylim); line([6 6],ylim)
            subplot(122)
            title('nofreezing')
            legend('PFC1','PFC2','PFCLocbis')
            box off
            ylabel('Frequency -Hz')
            xlabel('coherence')
            ylim([0.2 1])
            line([3 3],ylim); line([6 6],ylim)
            saveas(3,['Mouse',num2str(mouseNum{m}),'Session',num2str(ff),'CoherenceOBPFC.fig'])
            saveas(3,['Mouse',num2str(mouseNum{m}),'Session',num2str(ff),'CoherenceOBPFC.png'])
            figure(4)
            subplot(121)
            title('freezing')
            legend('PFC1','PFC2','PFCLocbis')
            box off
            ylabel('Frequency -Hz')
            xlabel('coherence')
            ylim([0.2 1])
            line([3 3],ylim); line([6 6],ylim)
            subplot(122)
            title('nofreezing')
            legend('PFC1','PFC2','PFCLocbis')
            box off
            ylabel('Frequency -Hz')
            xlabel('coherence')
            ylim([0.2 1])
            line([3 3],ylim); line([6 6],ylim)
            saveas(4,['Mouse',num2str(mouseNum{m}),'Session',num2str(ff),'CoherenceHPCPFC.fig'])
            saveas(4,['Mouse',num2str(mouseNum{m}),'Session',num2str(ff),'CoherenceHPCPFC.png'])

            close all
            
            clear Behav FreezeEpoch FreezeAccEpoch Movtsd
        end
    end
end




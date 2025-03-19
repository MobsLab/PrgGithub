clear all
Dir{1} = PathForExperimentsTRAPMice('TestA');
Dir{2} = PathForExperimentsTRAPMice('TestB');
Dir{3} = PathForExperimentsTRAPMice('TestC');

for env = 1:3
    for mouse = 1:size(Dir{env}.path,2)
        for sess = 1:3
            cd(Dir{env}.path{mouse}{sess})
            
            
            load('behavResources.mat')
            
            % iF YOU WANT TO RESTRIST
          %  ResEpoch = intervalSet(0,360*1e4);
            %FreezeAccEpoch = and(FreezeAccEpoch,ResEpoch);
            
            % percent freezing
            TotalTime=max(Range(MovAcctsd,'s')); % remplacer 360
            %TotalTime = 360;
            Dur = sum(Stop(FreezeAccEpoch,'s')-Start(FreezeAccEpoch,'s'));
            PercentFz{env}(mouse,sess)=(Dur/TotalTime)*100;
            
            % freezing in time
            [Y,X] = hist(Range(Restrict(MovAcctsd,FreezeAccEpoch),'s'),[0:30:60*6]);
            [Y2,X] = hist(Range(MovAcctsd,'s'),[0:30:60*6]);
            PercentFzTime{env}(mouse,sess,:) = 100*Y./Y2;
            
            %
            % Get OB spectrum
            [Sp,t,f]=LoadSpectrumML('Bulb_deep',pwd,'low');
            Sptsd  = tsd(t*1e4,Sp);
            SpecOB{env}(mouse,sess,:) = nanmean(Data(Restrict(Sptsd,FreezeAccEpoch)))
            
            [Sp,t,f]=LoadSpectrumML('PFCx_deep',pwd,'low');
            Sptsd  = tsd(t*1e4,Sp);
            SpecPFC{env}(mouse,sess,:) = nanmean(Data(Restrict(Sptsd,FreezeAccEpoch)))
            
            try
                [Sp,t,f]=LoadSpectrumML('dHPC_deep',pwd,'low');
            catch
                try
                    [Sp,t,f]=LoadSpectrumML('dHPC_rip',pwd,'low');
                catch
                    [Sp,t,f]=LoadSpectrumML('dHPC_sup',pwd,'low');
                end
            end
                Sptsd  = tsd(t*1e4,Sp);
                SpecHPC{env}(mouse,sess,:) = nanmean(Data(Restrict(Sptsd,FreezeAccEpoch)))
            end
        end
    
end

clf
for env = 1:3
    subplot(1,3,env)
    MeanVal = squeeze(nanmean(PercentFzTime{env}(:,:,:),2));
    for mouse = 1:size(Dir{env}.path,2)
        StdVal(mouse,:) = stdError(squeeze(PercentFzTime{env}(mouse,:,:)));
    end
    for mouse = 1:size(Dir{env}.path,2)
        errorbar(X,MeanVal(mouse,:),StdVal(mouse,:),'linewidth',3), hold on
    end
    xlabel('Time (s)')
    ylabel('% Time freezing')
    set(gca,'FontSize',12,'FontWeight','bold','linewidth',3)
    box off
    ylim([0 100])
    
    legend({['Mouse923 :' num2str(nanmean(PercentFz{env}(1,:))) '%'],['Mouse926 :' num2str(nanmean(PercentFz{env}(2,:))) '%'],['Mouse927 :' num2str(nanmean(PercentFz{env}(3,:))) '%'],['Mouse928 :' num2str(nanmean(PercentFz{env}(4,:))) '%']})
    EVnFzAllMice(env,:,:) = MeanVal;
    if env==1
        title('EnvA (neutral)')
    elseif env==2
        title('EnvB (neutral)')
    elseif env==3
        title('EnvC (aversive)')
    end
end


figure
clf
hold on
 for env = 1:3
errorbar(X,nanmean(squeeze(EVnFzAllMice(env,:,:))),stdError(squeeze(EVnFzAllMice(env,:,:))),'linewidth',3), hold on
 end
legend('Env A (neutral)','Env B (neutral)','Env C (aversive)')
xlabel('time (s)')
ylabel('%Time Freezing')
set(gca,'FontSize',12,'FontWeight','bold','linewidth',3)
title('%Fz by environment')

 
 
clf
envt={'TestA','TestB','TestC'}
for env = 1:3
    subplot(3,3,env)
    plot(f,squeeze(nanmean(SpecOB{env},2))','linewidth',3), hold on
    line([2.1 2.1],ylim,'color',UMazeColors('Safe'),'linewidth',2)
    line([4.5 4.5],ylim,'color',UMazeColors('Shock'),'linewidth',2)
    set(gca,'FontSize',12,'FontWeight','bold','linewidth',2)
    xlabel('Frequency (Hz)')
    title({['OB   ' num2str(envt{env})]})
    ylabel('Power')
    ylim([0 1E6])
    
    box off
    
    subplot(3,3,env+3)
    plot(f,squeeze(nanmean(SpecHPC{env},2))','linewidth',3), hold on
    set(gca,'FontSize',12,'FontWeight','bold','linewidth',2)
    xlabel('Frequency (Hz)')
    title({['HPC   ' num2str(envt{env})]})
    ylabel('Power')
    ylim([0 4E5])
    
    box off
    
    
    subplot(3,3,env+6)
    plot(f,squeeze(nanmean(SpecPFC{env},2))','linewidth',3), hold on
    set(gca,'FontSize',12,'FontWeight','bold','linewidth',2)
    xlabel('Frequency (Hz)')
    title({['PFC   ' num2str(envt{env})]})
    ylabel('Power')
    ylim([0 1.1E5])
    
    box off
    
end

subplot(3,3,1)
legend('923','926','927','928')



%%
figure
clf
for env = 1:3
    for mouse = 1:size(Dir{env}.path,2)
        for sess = 1:3
            
            cd(Dir{env}.path{mouse}{sess})
            
            
            load('behavResources.mat')
            th_immob_Acc = 25000000;
            thtps_immob = 2;
            smoofact_Acc = 30;
            NewMovAcctsd=tsd(Range(MovAcctsd),runmean(Data(MovAcctsd),smoofact_Acc));
            FreezeAccEpoch=thresholdIntervals(NewMovAcctsd,th_immob_Acc,'Direction','Below');
            FreezeAccEpoch=mergeCloseIntervals(FreezeAccEpoch,0.3*1e4);
            FreezeAccEpoch=dropShortIntervals(FreezeAccEpoch,thtps_immob*1e4);
            
            
            plot(Range(NewMovAcctsd,'s'),Data(NewMovAcctsd))
            hold on
            plot(Range(Restrict(NewMovAcctsd,FreezeAccEpoch),'s'),Data(Restrict(NewMovAcctsd,FreezeAccEpoch)))
        
            keyboard
            
            save('behavResources.mat','FreezeAccEpoch','smoofact_Acc','th_immob_Acc','-append')
            clf
            
        end
    end
end

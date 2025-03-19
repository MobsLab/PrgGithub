clear all, close all
cd /media/DataMOBsRAIDN/ProjetSlSc/FiguresReview
load('Gamma_HR_Corr_Response_RangeOfTimeBins.mat','T','Time','GammaThresh','MeannGamSleep','MeannGamWake')
IsoLevels = {'08','10','12','15','18'};
StimLevels = {'0V','2V','4V','6V'};

% Average stim response at different levels
figure
clf
cols = jet(5);
for Stim = 1:4
    subplot(1,4,Stim)
    for exp = 2:6
        hold on
        clear AvResp
        for k = 1:4
            T.Mov{exp,k,Stim}(T.Mov{exp,k,Stim}==0)=NaN;
            AvResp(k,:) = nanmean(T.Mov{exp,k,Stim});
        end
        plot(Time.Mov,nanmean(AvResp),'color',cols(exp-1,:),'linewidth',2)
        ylim([0 4*1e8])
        title(StimLevels(Stim))
    end
            line([0 0],ylim,'color','k')
set(gca,'FontSize',18,'linewidth',2)
xlabel('time to stim (s)')
ylabel('Head Acc')
end
subplot(1,4,1)
legend(IsoLevels)


figure
clf
cols = lines(4);
for exp = 2:6
    subplot(1,5,exp-1)
    
    for Stim = 1:4
        
        hold on
        clear AvResp
        for k = 1:4
            T.Mov{exp,k,Stim}(T.Mov{exp,k,Stim}==0)=NaN;
            AvResp(k,:) = nanmean(T.Mov{exp,k,Stim});
        end
        plot(Time.Mov,nanmean(AvResp),'color',cols(Stim,:),'linewidth',2)
        
        
    end
    ylim([0 4*1e8])
    title(IsoLevels(exp-1))
    
    line([0 0],ylim,'color','k')
    set(gca,'FontSize',18,'linewidth',2)
    xlabel('time to stim (s)')
    ylabel('Head Acc')
end
subplot(1,5,1)
legend(StimLevels)

AllResp=[];
for exp = 2:6
    for Stim = 1:4        
        hold on
        for k = 1:4
            T.Mov{exp,k,Stim}(T.Mov{exp,k,Stim}==0)=NaN;
            AllResp = [AllResp;naninterp((T.Mov{exp,k,Stim}))];
        end
       
    end
end

TimeWindow.Mov{1} = [find(Time.Mov<0.0,1,'last'):find(Time.Mov<0.1,1,'last')];
TimeWindow.Mov{2} = [find(Time.Mov<0.1,1,'last'):find(Time.Mov<0.3,1,'last')];

for timewin = 1:2
    for exp = 2:6
        for Stim = 1:4
            subplot(1,5,exp-1)
            
            hold on
            for k = 1:4
                T.Mov{exp,k,Stim}(T.Mov{exp,k,Stim}==0)=NaN;
                AccResp{timewin}(k,exp-1,Stim) = nanmean(nanmean(T.Mov{exp,k,Stim}(:,TimeWindow.Mov{timewin})));
            end
            
        end
    end
end


figure
clf
TitleToUse = {'Early','Late'}
for timewin = 1:2
    subplot(1,2,timewin)
    for Stim = 1:4
        Vals = squeeze(log(AccResp{timewin}(:,:,Stim)));
        errorbar([0.8,1,1.2,1.5,1.8],nanmean(Vals),stdError(Vals),'linewidth',3), hold on
        [R,P] = corrcoef([0.8,1,1.2,1.5,1.8],nanmean(Vals));
        text(0.5,max(nanmean(Vals)),num2str(R(1,2)))
    end
    ylim([15 19])
    box off
    set(gca,'FontSize',18,'linewidth',2,'XTick',[0.8,1,1.2,1.5,1.8])
    xlabel('Iso Level')
    ylabel('Head Acc')
    if timewin==2
    legend(StimLevels)
    end
    title(TitleToUse{timewin})
end
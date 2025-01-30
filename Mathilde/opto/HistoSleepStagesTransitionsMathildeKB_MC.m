function [h,rg,vec]=HistoSleepStagesTransitionsMathildeKB_MC(SleepSubStage,stim,vec,plo)

%[h,rg,vec]=HistoSleepStagesTransitionsMathilde(SleepStages,stim,vec)
%[h,rg,vec]=HistoSleepStagesTransitionsMathilde(SleepStages,Restrict(ts(Stim*1E4),Epoch{1}));title([NameEpoch{1},', n=',num2str(length(Range(Restrict(ts(Stim*1E4),Epoch{1}))))])


% [transitiontimes,idxtransition, SleepStages]=FindTransitionsSleep(Epoch,'N3','N2',1);
% subplot(4,1,1:3), hold on, plot(Stim4*1E4,2.5,'ko','markerfacecolor','y')
% n=3; [h,rg,vec]=HistoSleepStagesTransitionsMathilde(SleepStages,Restrict(ts(Stim4*1E4),Epoch{n}),-30:1:60,2); title([NameEpoch{n},', n=',num2str(length(Range(Restrict(ts(Stim4*1E4),Epoch{n}))))])
% n=2; [h,rg,vec]=HistoSleepStagesTransitionsMathilde(SleepStages,Restrict(ts(Stim4*1E4),Epoch{n}),-30:1:60,2); title([NameEpoch{n},', n=',num2str(length(Range(Restrict(ts(Stim4*1E4),Epoch{n}))))])
% n=1; [h,rg,vec]=HistoSleepStagesTransitionsMathilde(SleepStages,Restrict(ts(Stim4*1E4),Epoch{n}),-30:1:60,2); title([NameEpoch{n},', n=',num2str(length(Range(Restrict(ts(Stim4*1E4),Epoch{n}))))])
% n=4; [h,rg,vec]=HistoSleepStagesTransitionsMathilde(SleepStages,Restrict(ts(Stim4*1E4),Epoch{n}),-30:1:60,2); title([NameEpoch{n},', n=',num2str(length(Range(Restrict(ts(Stim4*1E4),Epoch{n}))))])


try
    plo;
catch
    plo=1;
end

try
    vec;
catch
    vec=-60:1:60;
end

co(1,:)=[0         0.4470    0.7410 ];
co(2,:)=[0.8500    0.3250    0.0980 ];
co(3,:)=[0.9290    0.6940    0.1250 ];
co(4,:)=[0.4940    0.1840    0.5560 ];
co(5,:)=[0.4660    0.6740    0.1880 ];
co(6,:)=[0.3010    0.7450    0.9330 ];
co(7,:)=[0.6350    0.0780    0.1840 ];
 

% q=length(find(Data(SleepSubStage)==1.5));

rg=Range(stim);

clear h
a=1;
for j=vec
epoch=intervalSet(rg+j*1E4,rg+(j+median(diff(vec)))*1E4);
% 
    h(a,1)=length(find(Data(Restrict(SleepSubStage,epoch))==5))/length(Data(Restrict(SleepSubStage,epoch)))*100; %wake
    h(a,2)=length(find(Data(Restrict(SleepSubStage,epoch))==4))/length(Data(Restrict(SleepSubStage,epoch)))*100; %REM
    h(a,3)=length(find(Data(Restrict(SleepSubStage,epoch))==1))/length(Data(Restrict(SleepSubStage,epoch)))*100; %N1
    h(a,4)=length(find(Data(Restrict(SleepSubStage,epoch))==2))/length(Data(Restrict(SleepSubStage,epoch)))*100; %N2
    h(a,5)=length(find(Data(Restrict(SleepSubStage,epoch))==3))/length(Data(Restrict(SleepSubStage,epoch)))*100; %N3
%         h(a,6)=length(find(Data(Restrict(SleepSubStage,epoch))==6))/length(Data(Restrict(SleepSubStage,epoch)))*100; %SWS

%     h(a,1)=length(find(Data(Restrict(SleepSubStage,epoch))==5))/(length(Data(Restrict(SleepSubStage,epoch)))-length(find(Data(Restrict(SleepSubStage,epoch))==6)))*100; %wake
%     h(a,2)=length(find(Data(Restrict(SleepSubStage,epoch))==4))/(length(Data(Restrict(SleepSubStage,epoch)))-length(find(Data(Restrict(SleepSubStage,epoch))==6)))*100; %REM
%     h(a,3)=length(find(Data(Restrict(SleepSubStage,epoch))==1))/(length(Data(Restrict(SleepSubStage,epoch)))-length(find(Data(Restrict(SleepSubStage,epoch))==6)))*100; %N1
%     h(a,4)=length(find(Data(Restrict(SleepSubStage,epoch))==2))/(length(Data(Restrict(SleepSubStage,epoch)))-length(find(Data(Restrict(SleepSubStage,epoch))==6)))*100; %N2
%     h(a,5)=length(find(Data(Restrict(SleepSubStage,epoch))==3))/(length(Data(Restrict(SleepSubStage,epoch)))-length(find(Data(Restrict(SleepSubStage,epoch))==6)))*100; %N3


    a=a+1;

end

% 
% 
% if plo
% 
% figure('color',[1 1 1]), hold on
% plot(vec,h,'linewidth',2)
% %line([0 0],[0 100],'color','k','linestyle',':')
% line([0 0],[0 100],'color','k')
% xlim([vec(1) vec(end)])
% ylim([0 100])
% 
%     legend({'Wake','REM','N1','N2','N3'})

    


% end

end


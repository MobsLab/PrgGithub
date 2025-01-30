cd /media/DataMOBSSlSc/SleepScoringMice/M60/20130415/
load('StateEpochSB.mat')
load('TransitionInfo.mat')
t=Range(smooth_ghi);
GhiSubSample=(Restrict(smooth_ghi,ts(t)));
ThetaSubSample=(Restrict(smooth_Theta,ts(t)));
        [aft_cell,bef_cell]=transEpoch(SWSEpoch,Wake);

clear tempG tempT
DiffDur=15;
%W--S
disp('wake-->sleep')
LengthAfter=(Stop(bef_cell{1,2})-Start(bef_cell{1,2}))/1e4;
LengthBefore=(Stop(aft_cell{2,1})-Start(aft_cell{2,1}))/1e4;
Transitions=Start(bef_cell{1,2});
num=1;
for k=1:length(Start(bef_cell{1,2}))
    if LengthAfter(k)>3+5 & LengthBefore(k)>3+5
        TransTime=Transitions(k);
        for nn=3
            tempG{num,1}=Data(Restrict(GhiSubSample,intervalSet(TransTime-(DiffDur-nn+1)*1e4,TransTime+(nn-1)*1e4)));
            tempT{num,1}=Data(Restrict(ThetaSubSample,intervalSet(TransTime-(DiffDur-nn+1)*1e4,TransTime+(nn-1)*1e4)));
            if not(isempty(find(tempG{num,1}>800,1,'last'):find(tempG{num,1}<600,1,'first')))
                tempT{num,1}=tempT{num,1}(find(tempG{num,1}>800,1,'last'):find(tempG{num,1}<600,1,'first'));
                tempG{num,1}=tempG{num,1}(find(tempG{num,1}>800,1,'last'):find(tempG{num,1}<600,1,'first'));
                num=num+1;
            end
        end
    end
end
%S--W
disp('sleep-->wake')
LengthAfter=(Stop(bef_cell{2,1})-Start(bef_cell{2,1}))/1e4;
LengthBefore=(Stop(aft_cell{1,2})-Start(aft_cell{1,2}))/1e4;
Transitions=Start(bef_cell{2,1});
num=1;
for k=1:length(Start(bef_cell{2,1}))
    if LengthAfter(k)>3+5 & LengthBefore(k)>3+5
        TransTime=Transitions(k);
        for nn=3
            tempG{num,2}=Data(Restrict(GhiSubSample,intervalSet(TransTime-(DiffDur-nn+1)*1e4,TransTime+(nn-1)*1e4)));
            tempT{num,2}=Data(Restrict(ThetaSubSample,intervalSet(TransTime-(DiffDur-nn+1)*1e4,TransTime+(nn-1)*1e4)));
            
            if not(isempty( find(tempG{num,2}<600,1,'last'):find(tempG{num,2}>800,1,'first')))
                tempT{num,2}=tempT{num,2}(find(tempG{num,2}<600,1,'last'):find(tempG{num,2}>800,1,'first'));
                tempG{num,2}=tempG{num,2}(find(tempG{num,2}<600,1,'last'):find(tempG{num,2}>800,1,'first'));
                num=num+1;
            end
            
        end
    end
end
LitEp=intervalSet(Start(subset(SWSEpoch,2))+13*1e4,Start(subset(SWSEpoch,2))+16*1e4);
tempGS=Data(Restrict(GhiSubSample,LitEp));
tempTS=Data(Restrict(ThetaSubSample,LitEp));
LitEp=intervalSet(Start(subset(Wake,3))+20*1e4,Start(subset(Wake,3))+25*1e4);
tempGW=Data(Restrict(GhiSubSample,LitEp));
tempTW=Data(Restrict(ThetaSubSample,LitEp));

figure
t=Range(smooth_ghi);
t=t(1:800:end);
GhiSubSample2=(Restrict(smooth_ghi,ts(t)));
ThetaSubSample2=(Restrict(smooth_Theta,ts(t)));
subplot(121)
plot(Data(GhiSubSample2),Data(ThetaSubSample2),'.','MarkerSize',1,'color',[0.6 0.6 0.6]), hold on
ylim([0.7 14.2])
xlim([220 3780])
plot(tempGS,tempTS,'b','linewidth',3)
plot(tempGW,tempTW,'k','linewidth',3)
set(gca,'XScale','log','YScale','log')
subplot(122)
plot(Data(GhiSubSample2),Data(ThetaSubSample2),'.','MarkerSize',1,'color',[0.6 0.6 0.6]), hold on
set(gca,'XScale','log','YScale','log')
ylim([0.7 14.2])
xlim([220 3780])
plot(tempGS,tempTS,'b','linewidth',3)
plot(tempGW,tempTW,'k','linewidth',3)


for k=1:20
    subplot(121),hold on
    plot(tempG{k,1},tempT{k,1},'color',[0.6 0.2 0.8],'linewidth',2)
    subplot(122),hold on
    plot(tempG{k,2},tempT{k,2},'color',[0.6 0.2 0.8],'linewidth',2)
end


for k=1:20
    subplot(121),hold on
    plot(tempG{k,1},'color',[1 0.4 0.4],'linewidth',2)
    subplot(122),hold on
    plot(tempG{k,2},'color',[0.4 0.4 1],'linewidth',2)
end

for k=1:20
    subplot(223),hold on
    plot((tempG{k,1}-tempG{k,1}(1)).^2,'color',[1 0.4 0.4],'linewidth',2)
    subplot(224),hold on
    plot((tempG{k,2}-tempG{k,2}(1)).^2,'color',[0.4 0.4 1],'linewidth',2)
end


fig=figure;
clf
plot(Data(GhiSubSample2),Data(ThetaSubSample2),'.','MarkerSize',1,'color',[1 1 1]*0.8), hold on
hold on
set(gca,'XScale','log','YScale','log')
ylim([0.7 14.2])
xlim([220 3780])

i=2419*2;
tempG=Data(Restrict(GhiSubSample,intervalSet(120975000+i*1e4,120975000+5*1e4+i*1e4)));
tempT=Data(Restrict(ThetaSubSample,intervalSet(120975000+i*1e4,120975000+5*1e4+i*1e4)));
Traj1=plot(tempG,tempT,'b','linewidth',2);
% v=VideoWriter('WakeandSleep.avi');v.FrameRate=10;open(v);
% for i=1:250
%     i
%     tempG=Data(Restrict(GhiSubSample,intervalSet(120975000+i*1e4,120975000+5*1e4+i*1e4)));
%     tempT=Data(Restrict(ThetaSubSample,intervalSet(120975000+i*1e4,120975000+5*1e4+i*1e4)));
%     if size(Data(Restrict(smooth_ghi,and(SWSEpoch,intervalSet(120975000+i*1e4,120975000+5*1e4+i*1e4)))),1)> size(Data(Restrict(smooth_ghi,and(Wake,intervalSet(120975000+i*1e4,120975000+5*1e4+i*1e4)))),1)
%         set(Traj1,'xData',tempG,'YData',tempT,'color','b');
%     else
%         set(Traj1,'xData',tempG,'YData',tempT,'color','k');
%     end
%     pause(0.05)
%          writeVideo(v,getframe(gcf));
% end
% close(v)
% 
% 
% v=VideoWriter('JustWake.avi');v.FrameRate=10;open(v);
% % Just waking up
% for i=35:50
%     i
%     tempG=Data(Restrict(GhiSubSample,intervalSet(120975000+i*1e4,120975000+5*1e4+i*1e4)));
%     tempT=Data(Restrict(ThetaSubSample,intervalSet(120975000+i*1e4,120975000+5*1e4+i*1e4)));
%     if size(Data(Restrict(smooth_ghi,and(SWSEpoch,intervalSet(120975000+i*1e4,120975000+5*1e4+i*1e4)))),1)> size(Data(Restrict(smooth_ghi,and(Wake,intervalSet(120975000+i*1e4,120975000+5*1e4+i*1e4)))),1)
%         set(Traj1,'xData',tempG,'YData',tempT,'color','b');
%     else
%         set(Traj1,'xData',tempG,'YData',tempT,'color','k');
%     end
%     pause(0.05)
%      writeVideo(v,getframe(gcf));
% end
% close(v)
% 

 v=VideoWriter('JustSleep.avi');v.FrameRate=10;open(v);
% Just falling asleep
for i=3095:3120
    i
    tempG=Data(Restrict(GhiSubSample,intervalSet(120975000+i*1e4,120975000+5*1e4+i*1e4)));
    tempT=Data(Restrict(ThetaSubSample,intervalSet(120975000+i*1e4,120975000+5*1e4+i*1e4)));
    if size(Data(Restrict(smooth_ghi,and(SWSEpoch,intervalSet(120975000+i*1e4,120975000+5*1e4+i*1e4)))),1)> size(Data(Restrict(smooth_ghi,and(Wake,intervalSet(120975000+i*1e4,120975000+5*1e4+i*1e4)))),1)
        set(Traj1,'xData',tempG,'YData',tempT,'color','b');
    else
        set(Traj1,'xData',tempG,'YData',tempT,'color','k');
    end
     pause(0.05)
     writeVideo(v,getframe(gcf));
end
 close(v)





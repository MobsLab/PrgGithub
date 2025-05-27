clear all
cd /media/DataMOBsRAIDN/ProjectEmbReact/Mouse490/20161201/ProjectEmbReact_M490_20161201_UMazeCond/Cond4
th_immob=0.003;
smoofact=10;


load('CompressedFrames.mat')
load('behavResources_SB.mat')
Behav.MovAcctsd = tsd(Range(Behav.MovAcctsd),runmean(Data(Behav.MovAcctsd),20));
tps=Range(Behav.Ytsd,'s');
FrameSize=size(Params.ref);
XDat=Data(Behav.Xtsd)/Params.pixratio;
YDat=Data(Behav.Ytsd)/Params.pixratio;


disp('load LFP')
load(['LFPData/LFP',num2str(45),'.mat'])
LFPB = FilterLFP(LFP,[1 200],1024);

load(['LFPData/LFP',num2str(14),'.mat'])
LFPH = FilterLFP(LFP,[1 200],1024);

load(['LFPData/LFP',num2str(52),'.mat'])
LFPP = FilterLFP(LFP,[1 200],1024);

load(['LFPData/LFP',num2str(41),'.mat'])
LFPEKG = FilterLFP(LFP,[1 200],1024);

load('Ripples.mat')


writerObj = VideoWriter(['FreezingExample_VF.avi']);
writerObj.FrameRate = 20;
writerObj.Quality = 70;


% Just freezing
open(writerObj);



figure
subplot(212)
FzBar =  bar(1,nanmean(Data(Restrict(Behav.MovAcctsd,intervalSet(tps(i)*1e4-1e4,tps(i)*1e4 )))),'FaceColor',[0.6 0.6 0.6]);
line(xlim,[1 1]*Params.th_immob_Acc*1.2,'linewidth',3,'color','k')
ylim([0 8*1e7])
set(gca,'Xtick',[],'YTick',[])
ylabel('Quantity of movement')
set(gca,'FontSize',14)
text(0.1,5e6,'Freezing')
text(0.1,4e7,'Active')

b=double(zeros(FrameSize));

for i=1:4700
    bnew=b(:);
    bnew(CompressionInfo.Location{i})=bnew(CompressionInfo.Location{i})+double(CompressionInfo.Value{i});
    bnew=reshape(bnew,FrameSize(1),FrameSize(2));
    b=bnew;
    
    if i>4000
        subplot(211)
        imagesc(bnew)
        xlim([62 137])
        ylim([100 187])
        hold on
        plot(XDat(i),YDat(i),'r*')
        hold off
        set(gca,'Xtick',[],'YTick',[])
        colormap gray
        clim([0 30])

        
        FzBar.YData = nanmean(Data(Restrict(Behav.MovAcctsd,intervalSet(tps(i)*1e4-1e4,tps(i)*1e4 ))));
        
        pause(0.001)
        writeVideo(writerObj,getframe(1));
        
    end
    
end
close(writerObj);



%%
% open(writerObj);
% 
% 
% 
% figure
% subplot(212)
% hold on
% plot(Range(LFPH,'s'),Data(LFPB)*1+2000,'color',[0 0 0.8])
% 
% plot(Range(LFPP,'s'),Data(LFPP)*2-5000,'color',[1 0.4 0.4])
% 
% plot(Range(LFPH,'s'),Data(LFPH)*1.5-12000,'color',[0.2 0.8 0.8])
% 
% plot(Range(LFPEKG,'s'),Data(LFPEKG)-18000,'color','k')
% 
% plot(Ripples(:,2)/1e3,-9000,'k*','MarkerSize',10)
% 
% set(gca,'Xtick',[],'YTick',[-18000,-12000,-5000,2000],'YTickLabel',{'EKG','HPC','PFC','OB'},'FontSize',18)
% 
% subplot(222)
% FzBar =  bar(1,nanmean(Data(Restrict(Behav.MovAcctsd,intervalSet(tps(i)*1e4-1e4,tps(i)*1e4 )))),'FaceColor',[0.6 0.6 0.6]);
% line(xlim,[1 1]*Params.th_immob_Acc*1.2,'linewidth',3,'color','k')
% ylim([0 8*1e7])
% set(gca,'Xtick',[],'YTick',[])
% ylabel('Quantity of movement')
% set(gca,'FontSize',14)
% text(0.1,5e6,'Freezing')
% text(0.1,4e7,'Active')
% 
% b=double(zeros(FrameSize));
% 
% for i=1:length(CompressionInfo.Location)
%     bnew=b(:);
%     bnew(CompressionInfo.Location{i})=bnew(CompressionInfo.Location{i})+double(CompressionInfo.Value{i});
%     bnew=reshape(bnew,FrameSize(1),FrameSize(2));
%     b=bnew;
%     
%     if i>4000
%         subplot(221)
%         imagesc(bnew.*double(maskint))
%         hold on
%         plot(XDat(i),YDat(i),'r*')
%         hold off
%         set(gca,'Xtick',[],'YTick',[])
%         ylim([25 188])
%         xlim([53 250])
%         colormap gray
% 
%         
%         FzBar.YData = nanmean(Data(Restrict(Behav.MovAcctsd,intervalSet(tps(i)*1e4-1e4,tps(i)*1e4 ))));
%         
%         subplot(212)
%         xlim([tps(i)-4 tps(i)])
%         ylim([-20000 10000])
%         pause(0.001)
%         writeVideo(writerObj,getframe(1));
%         
%     end
%     
% end
% close(writerObj);



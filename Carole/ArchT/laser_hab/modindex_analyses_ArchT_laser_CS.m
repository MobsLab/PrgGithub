

%/!\ met la toolbox dans le path !!!!!!!!


%% for all ArchT mice

clear all
A={{},{},{},{},{},{}};
%AClose={{},{},{},{},{},{}};
Mice=[915,916,917,918,919,920];
type=[{'A'},{'A'},{'A'},{'A'},{'mCh'},{'mCh'}]
ModIndxtot=[]

for i=1:length(Mice)
    %go to mouse folder
    clear ModIndx
    clear DigTSD
    clear FiringOff
    clear FiringOn
    clear FiringInClose
    mouse_num=Mice(i)
    path=strcat('/media/gruffalo/09E7077B1FE07CCB/ARCHT/ArchT/', num2str(mouse_num), '/laser_hab'); % /!\ a modifier !!!!!!!
    cd(path)
    % get spike data
    [numNeurons, numtt, TT]=GetSpikesFromStructure('PFCx', 'remove_MUA',1);
    load('SpikeData.mat')
    %get laser data
    load('LFPData/DigInfo9.mat')   
    
    StimOn = thresholdIntervals(DigTSD,0.9,'Direction','Above');
    StimOff = intervalSet(0,900*1e4)-StimOn;
    StimOnClose = intervalSet(Start(StimOn),Start(StimOn)+1*1e4);
    StimOffClose = intervalSet(Start(StimOn)-1*1e4,Start(StimOn));
    clear RemResp
    %calculer les firing rates des neurones en fonction du laser,
    for sp = 1:length(numNeurons)
        FiringOff(sp) = length(Range(Restrict(S{numNeurons(sp)},StimOff)))./sum(Stop(StimOff,'s')-Start(StimOff,'s'));
        FiringOn(sp) = length(Range(Restrict(S{numNeurons(sp)},StimOn)))./sum(Stop(StimOn,'s')-Start(StimOn,'s'));
        %FiringOnClose(sp) = length(Range(Restrict(S{numNeurons(sp)},StimOnClose)))./sum(Stop(StimOnClose,'s')-Start(StimOnClose,'s'));
        %FiringOffClose(sp) = length(Range(Restrict(S{numNeurons(sp)},StimOffClose)))./sum(Stop(StimOffClose,'s')-Start(StimOffClose,'s'));
    end
    ModIndx = ((FiringOn-FiringOff)./(FiringOn+FiringOff));
    ModIndxtot(i)= ((sum(FiringOn)-sum(FiringOff))/(sum(FiringOn)+sum(FiringOff)));
    %ModIndxClose = ((FiringOnClose-FiringOffClose)./(FiringOnClose+FiringOffClose));
    % remplir la matrice correctement
    A{1,i} = ModIndx;
    %AClose{1,i} = ModIndxClose;
end
    
    
%% figure modulation index
figure
line([-1 0],[-1 0],'color',[1 0 0],'linewidth',4)
hold on
line([-1 0],[-1 0],'color',[0 0 1],'linewidth',4)
hold on

MakeSpreadAndBoxPlot_SB(A,{[1 0 0],[1 0 0],[1 0 0],[1 0 0],[0 0 1],[0 0 1]},[1,2,3,4,5,6],[{'A'},{'B'},{'C'},{'D'},{'E'},{'F'}])
hold on
ylabel('modulation index')
xlabel('Mice')
line(xlim,[0 0],'linewidth',1,'color','k','linestyle',':')
ylim([-1.1 0.4])
% for i=1:length(Mice)
%     [p,h,stats] = signrank(A{i})
% end
% for i=1:length(Mice)
%     [ht,pt,statst] = ttest(A{i})
% end
% legend('ArchT','mCherry')
% title('Modulation index for each mouse')


%% figure standard deviation of modulation index
STD=[];
for i=1:length(Mice)
    STD(i)=std(A{i});
end
Mat=zeros(4,2);
for k=1:4
    Mat(k,1)=STD(k);
end
Mat(1,2)=STD(5);
Mat(2,2)=STD(6);
Mat(3,2)=NaN;
Mat(4,2)=NaN;
figure
line([-1 0],[-1 0],'color','k','linewidth',4)
hold on
line([-1 0],[-1 0],'color','c','linewidth',4)
hold on
line([-1 0],[-1 0],'color','m','linewidth',4)
hold on
line([-1 0],[-1 0],'color','y','linewidth',4)
hold on
PlotErrorBar_color_points_CS(Mat, 'newfig', 0, 'paired',0,'barcolors',{[1 0 0],[0 0 1]}, 'ShowSigstar', 'all');
set(gca,'xticklabel',{'','','ArchT','','mCherry','',''});
%legend('915/919','916/920','917','918')
ylabel('Std(modulation index)')
%% figure modulation index close
% subplot(2,2,3)
% MakeSpreadAndBoxPlot_SB(AClose,{[1 0 0],[1 0 0],[1 0 0],[1 0 0],[0 0 1],[0 0 1]},[1,2,3,4,5,6],type)
% hold on
% line(xlim,[0 0],'linewidth',1,'color','k','linestyle',':')
% ylim([-1.1 0.6])
% for i=1:length(Mice)
%     [p,h,stats] = signrank(A{i})
%     sigstar({{i-0.2,i+0.2}},p)
% end
% title('Modulation index for each mouse (1sec bef_1sec after')
%% figure standard deviation of modulation index
% STDClose=[];
% for i=1:length(Mice)
%     STDClose(i)=std(AClose{i});
% end
% MatClose=zeros(4,2);
% for k=1:4
%     MatClose(k,1)=STDClose(k);
% end
% MatClose(1,2)=STDClose(5);
% MatClose(2,2)=STDClose(6);
% MatClose(3,2)=NaN;
% MatClose(4,2)=NaN;
% subplot(2,2,4)
% PlotErrorBarN_KJ(MatClose, 'newfig', 0, 'paired',0, 'barcolors',{[1 0 0],[0 0 1]}, 'ShowSigstar', 'all');
% set(gca,'xticklabel',{'','','ArchT','','mCherry','',''});
% title('Standard deviation of modulation index (1sec bef and after)')



%%
% [UnitID,AllParams,WFInfo,figid] = MakeData_ClassifySpikeWaveforms(W,[dropbox '/Kteam'],1);
% IDint=find(UnitID==-1);
% IDpyr=find(UnitID==+1);
% unitid=UnitID(numNeurons);
% PlotErrorBar2(ModIndx(unitid==1),ModIndx(unitid==-1))
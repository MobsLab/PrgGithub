clear all, close all
m=1;
filename{m,1}='/media/DataMOBSSlSc/SleepScoringMice/M147';
m=m+1;
filename{m,1}='/media/DataMOBSSlSc/SleepScoringMice/M148/20140828/';
m=m+1;
filename{m,1}='/media/DataMOBSSlSc/SleepScoringMice/M177178/M177178-Sleep-22102014/M177';
m=m+1;
filename{m,1}='/media/DataMOBSSlSc/SleepScoringMice/M177178/M177178-Sleep-22102014/M178';
m=m+1;
filename{m,1}='/media/DataMOBSSlSc/SleepScoringMice/M177178/M177178-Sleep-23022014/M177';
m=m+1;
filename{m,1}='/media/DataMOBSSlSc/SleepScoringMice/M177178/M177178-Sleep-23022014/M178';
m=m+1;
filename{m,1}='/media/DataMOBsRAID/ProjetSlSc/M258/20151112/';
m=m+1;
filename{m,1}='/media/DataMOBsRAID/ProjetSlSc/M259/20151112/';

%% Get all diffusion curves
DiffDurTimes=[1,2,3,5,7];
dt=0.0008;
for dd=1:length(DiffDurTimes)
    DiffDur=DiffDurTimes(dd);
    normaldur=DiffDur/dt;
    clear EMGDisp ThetDisp
    for mm=1:length(filename)
        mm
        cd(filename{mm})
        load('StateEpochEMGSB.mat')
        
        t=Range(EMGData);
        EMGSubSample=(Restrict(EMGData,ts(t)));
        DelGhi{1,1}=max(Data(Restrict(EMGSubSample,Wake)))-min(Data(Restrict(EMGSubSample,Wake)));
        DelGhi{2,1}=max(Data(Restrict(EMGSubSample,Wake)))-min(Data(Restrict(EMGSubSample,SWSEpoch)));
        DelGhi{3,1}=max(Data(Restrict(EMGSubSample,Wake)))-min(Data(Restrict(EMGSubSample,REMEpoch)));
        DelGhi{1,2}=max(Data(Restrict(EMGSubSample,Wake)))-min(Data(Restrict(EMGSubSample,Wake)));
        DelGhi{2,2}=max(Data(Restrict(EMGSubSample,Wake)))-min(Data(Restrict(EMGSubSample,SWSEpoch)));
        DelGhi{3,2}=max(Data(Restrict(EMGSubSample,Wake)))-min(Data(Restrict(EMGSubSample,REMEpoch)));
        
        %% Look at diffusion coefficient at heart of Epoch
        %Wake
        disp('wake')
        num=1;
        for k=1:length(Start(Wake))
            Duration=(Stop(subset(Wake,k))-Start(subset(Wake,k)))/1e4;
            if Duration>2*3+DiffDur
                StrtTime=Start(subset(Wake,k));
                NumWindows=floor((Duration-(2*3))-DiffDur+1);
                DataToUse=[ceil(NumWindows/2)-10:ceil(NumWindows/2)+9];
                if sum(DataToUse<0)+sum(DataToUse>NumWindows)>0
                    DataToUse=[1:NumWindows];
                end
                for nn=DataToUse
                    tempE=Data(Restrict(EMGSubSample,intervalSet(StrtTime+(nn-1)*1e4,StrtTime+(DiffDur+nn-1)*1e4)));           
                    if size(tempE,1)==normaldur
                        EMGDisp{1}(num,:)=(tempE-tempE(1)).^2;
                        num=num+1;
                    end
                end
            end
        end
        
        %SWS
        disp('SWS')
        num=1;
        for k=1:length(Start(SWSEpoch))
            Duration=(Stop(subset(SWSEpoch,k))-Start(subset(SWSEpoch,k)))/1e4;
            if Duration>2*3+DiffDur
                StrtTime=Start(subset(SWSEpoch,k));
                NumWindows=floor((Duration-(2*3))-DiffDur+1);
                DataToUse=[ceil(NumWindows/2)-10:ceil(NumWindows/2)+9];
                if sum(DataToUse<0)+sum(DataToUse>NumWindows)>0
                    DataToUse=[1:NumWindows];
                end
                for nn=DataToUse
                    tempE=Data(Restrict(EMGSubSample,intervalSet(StrtTime+(nn-1)*1e4,StrtTime+(DiffDur+nn-1)*1e4)));
                    if size(tempE,1)==normaldur
                        EMGDisp{2}(num,:)=(tempE-tempE(1)).^2;
                        num=num+1;
                    end
                end
            end
        end
        
        %REM
        disp('REM')
        num=1;
        for k=1:length(Start(REMEpoch))
            Duration=(Stop(subset(REMEpoch,k))-Start(subset(REMEpoch,k)))/1e4;
            if Duration>2*3+DiffDur
                StrtTime=Start(subset(REMEpoch,k));
                NumWindows=floor((Duration-(2*3))-DiffDur+1);
                DataToUse=[ceil(NumWindows/2)-10:ceil(NumWindows/2)+9];
                if sum(DataToUse<0)+sum(DataToUse>NumWindows)>0
                    DataToUse=[1:NumWindows];
                end
                for nn=DataToUse
                    tempE=Data(Restrict(EMGSubSample,intervalSet(StrtTime+(nn-1)*1e4,StrtTime+(DiffDur+nn-1)*1e4)));
                    if size(tempE,1)==normaldur
                        EMGDisp{3}(num,:)=(tempE-tempE(1)).^2;
                        num=num+1;
                    end
                end
            end
        end
        
        %% Now look specifically at transitions
        [aft_cell,bef_cell]=transEpoch(SWSEpoch,Wake);
        % Start(bef_cell{1,2}) ---> beginning of all SWS that is preceded by Wake
        % (W-->S)
        %Start(bef_cell{2,1})---> beginning of all Wake  that is preceded by SWS
        %(S-->W)
        
        NumWindows=DiffDur+1;
        %W--S
        disp('wake-->sleep')
        LengthAfter=(Stop(bef_cell{1,2})-Start(bef_cell{1,2}))/1e4;
        LengthBefore=(Stop(aft_cell{2,1})-Start(aft_cell{2,1}))/1e4;
        Transitions=Start(bef_cell{1,2});
        num=1;
        for k=1:length(Start(bef_cell{1,2}))
            if LengthAfter(k)>3+DiffDur & LengthBefore(k)>3+DiffDur
                TransTime=Transitions(k);
                for nn=1:NumWindows
                    tempE=Data(Restrict(EMGSubSample,intervalSet(TransTime-(DiffDur-nn+1)*1e4,TransTime+(nn-1)*1e4)));
                    if size(tempE,1)==normaldur
                        EMGDisp{4}(num,:)=(tempE-tempE(1)).^2;
                        num=num+1;
                    end
                end
            end
        end
        
        NumWindows=DiffDur+1;
        %S--W
        disp('sleep-->wake')
        LengthAfter=(Stop(bef_cell{2,1})-Start(bef_cell{2,1}))/1e4;
        LengthBefore=(Stop(aft_cell{1,2})-Start(aft_cell{1,2}))/1e4;
        Transitions=Start(bef_cell{2,1});
        num=1;
        for k=1:length(Start(bef_cell{2,1}))
            if LengthAfter(k)>3+DiffDur & LengthBefore(k)>3+DiffDur
                TransTime=Transitions(k);
                for nn=1:NumWindows
                    tempE=Data(Restrict(EMGSubSample,intervalSet(TransTime-(DiffDur-nn+1)*1e4,TransTime+(nn-1)*1e4)));
                    if size(tempE,1)==normaldur
                        EMGDisp{5}(num,:)=(tempE-tempE(1)).^2;
                        num=num+1;
                    end
                end
            end
        end
        
        %% Now look specifically at transitions
        [aft_cell,bef_cell]=transEpoch(REMEpoch,Wake);
        % Start(bef_cell{1,2}) ---> beginning of all REM that is preceded by Wake
        % (W-->S)
        %Start(bef_cell{2,1})---> beginning of all Wake  that is preceded by
        %REM
        %(S-->W)
        
        NumWindows=DiffDur+1;
        %S--W
        disp('REM-->wake')
        LengthAfter=(Stop(bef_cell{2,1})-Start(bef_cell{2,1}))/1e4;
        LengthBefore=(Stop(aft_cell{1,2})-Start(aft_cell{1,2}))/1e4;
        Transitions=Start(bef_cell{2,1});
        num=1;
        for k=1:length(Start(bef_cell{2,1}))
            if LengthAfter(k)>3+DiffDur & LengthBefore(k)>3+DiffDur
                TransTime=Transitions(k);
                for nn=1:NumWindows
                    tempE=Data(Restrict(EMGSubSample,intervalSet(TransTime-(DiffDur-nn+1)*1e4,TransTime+(nn-1)*1e4)));
                    if size(tempE,1)==normaldur
                        EMGDisp{6}(num,:)=(tempE-tempE(1)).^2;
                        num=num+1;
                    end
                end
            end
        end
        
        %% Now look specifically at transitions
        [aft_cell,bef_cell]=transEpoch(SWSEpoch,REMEpoch);
        % Start(bef_cell{1,2}) ---> beginning of all SWS that is preceded by Wake
        % (W-->S)
        %Start(bef_cell{2,1})---> beginning of all Wake  that is preceded by SWS
        %(S-->W)
        
        NumWindows=DiffDur+1;
        %W--S
        disp('REM-->sleep')
        LengthAfter=(Stop(bef_cell{1,2})-Start(bef_cell{1,2}))/1e4;
        LengthBefore=(Stop(aft_cell{2,1})-Start(aft_cell{2,1}))/1e4;
        Transitions=Start(bef_cell{1,2});
        num=1;
        for k=1:length(Start(bef_cell{1,2}))
            if LengthAfter(k)>3+DiffDur & LengthBefore(k)>3+DiffDur
                TransTime=Transitions(k);
                for nn=1:NumWindows
                    tempE=Data(Restrict(EMGSubSample,intervalSet(TransTime-(DiffDur-nn+1)*1e4,TransTime+(nn-1)*1e4)));
                    if size(tempE,1)==normaldur
                        EMGDisp{7}(num,:)=(tempE-tempE(1)).^2;
                        num=num+1;
                    end
                end
            end
        end
        
        NumWindows=DiffDur+1;
        %S--W
        disp('sleep-->REM')
        LengthAfter=(Stop(bef_cell{2,1})-Start(bef_cell{2,1}))/1e4;
        LengthBefore=(Stop(aft_cell{1,2})-Start(aft_cell{1,2}))/1e4;
        Transitions=Start(bef_cell{2,1});
        num=1;
        for k=1:length(Start(bef_cell{2,1}))
            if LengthAfter(k)>3+DiffDur & LengthBefore(k)>3+DiffDur
                TransTime=Transitions(k);
                for nn=1:NumWindows
                    tempE=Data(Restrict(EMGSubSample,intervalSet(TransTime-(DiffDur-nn+1)*1e4,TransTime+(nn-1)*1e4)));
                    if size(tempE,1)==normaldur
                        EMGDisp{8}(num,:)=(tempE-tempE(1)).^2;
                        num=num+1;
                    end
                end
            end
        end
        
        save(strcat('DisplacementMeasureEMG',num2str(DiffDur),'Part1.mat'),'EMGDisp','DelGhi','-v7.3')
        clear EMGDisp ThetDisp

       
        
    end
end

%% Plots
    

figure
time=[dt:dt:dt*normaldur];
for mm=1:m
    mm
    cd(filename{mm})
    load(strcat('DisplacementMeasureEMG',num2str(DiffDur),'Part1.mat'))
    disp('Part1')
    g=4;if not(isempty(EMGDisp{g})),[cf_,goodness]=FitDiffusion2(time,nanmean(EMGDisp{g}),[max(nanmean(EMGDisp{1}))./max(time),1]);     temp=coeffvalues(cf_);CoeffAG(g,mm)=temp(2);CoeffDG(g,mm)=temp(1);RsqG(g,mm)=goodness.rsquare; end%WtoS
    g=5;if not(isempty(EMGDisp{g})),[cf_,goodness]=FitDiffusion2(time,nanmean(EMGDisp{g}),[max(nanmean(EMGDisp{1}))./max(time),1]);     temp=coeffvalues(cf_);CoeffAG(g,mm)=temp(2);CoeffDG(g,mm)=temp(1);RsqG(g,mm)=goodness.rsquare; end%StoW
    plot((time),(mean(EMGDisp{4})./(CoeffDG(4,mm)*2)),'r'), hold on
    plot((time),(mean(EMGDisp{5})./(CoeffDG(5,mm)*2)),'b'), hold on
end
plot(time,time.^mean(CoeffAG(5,:)),'k','linewidth',4)
plot(time,time.^mean(CoeffAG(4,:)),'k','linewidth',4)
box off


    figure
     normaldur=DiffDur/dt;
    time=[dt:dt:dt*normaldur];
    for mm=1:m
        mm
        cd(filename{mm})
        load(strcat('DisplacementMeasureEMG',num2str(DiffDur),'Part1.mat'))
        disp('Part1')       
        g=1;if not(isempty(EMGDisp{g})),[cf_,goodness]=FitDiffusion2(time,nanmean(EMGDisp{g}),[max(nanmean(EMGDisp{1}))./max(time),1]);    temp=coeffvalues(cf_);CoeffAG(g,mm)=temp(2);CoeffDG(g,mm)=temp(1);RsqG(g,mm)=goodness.rsquare;end %Wake
        g=g+1;if not(isempty(EMGDisp{g})),[cf_,goodness]=FitDiffusion2(time,nanmean(EMGDisp{g}),[max(nanmean(EMGDisp{1}))./max(time),1]);     temp=coeffvalues(cf_);CoeffAG(g,mm)=temp(2);CoeffDG(g,mm)=temp(1);RsqG(g,mm)=goodness.rsquare; end%SWS
        g=g+1;if not(isempty(EMGDisp{g})),[cf_,goodness]=FitDiffusion2(time,nanmean(EMGDisp{g}),[max(nanmean(EMGDisp{1}))./max(time),1]);     temp=coeffvalues(cf_);CoeffAG(g,mm)=temp(2);CoeffDG(g,mm)=temp(1);RsqG(g,mm)=goodness.rsquare; end %REM
        g=g+1;if not(isempty(EMGDisp{g})),[cf_,goodness]=FitDiffusion2(time,nanmean(EMGDisp{g}),[max(nanmean(EMGDisp{1}))./max(time),1]);     temp=coeffvalues(cf_);CoeffAG(g,mm)=temp(2);CoeffDG(g,mm)=temp(1);RsqG(g,mm)=goodness.rsquare; end%WtoS
        g=g+1;if not(isempty(EMGDisp{g})),[cf_,goodness]=FitDiffusion2(time,nanmean(EMGDisp{g}),[max(nanmean(EMGDisp{1}))./max(time),1]);     temp=coeffvalues(cf_);CoeffAG(g,mm)=temp(2);CoeffDG(g,mm)=temp(1);RsqG(g,mm)=goodness.rsquare; end%StoW
        g=g+1;if not(isempty(EMGDisp{g})),[cf_,goodness]=FitDiffusion2(time,nanmean(EMGDisp{g}),[max(nanmean(EMGDisp{1}))./max(time),1]);     temp=coeffvalues(cf_);CoeffAG(g,mm)=temp(2);CoeffDG(g,mm)=temp(1);RsqG(g,mm)=goodness.rsquare; end%RtoS
        g=g+1;if not(isempty(EMGDisp{g})),[cf_,goodness]=FitDiffusion2(time,nanmean(EMGDisp{g}),[max(nanmean(EMGDisp{1}))./max(time),1]);     temp=coeffvalues(cf_);CoeffAG(g,mm)=temp(2);CoeffDG(g,mm)=temp(1);RsqG(g,mm)=goodness.rsquare; end%SltoR
        g=g+1;if not(isempty(EMGDisp{g})),[cf_,goodness]=FitDiffusion2(time,nanmean(EMGDisp{g}),[max(nanmean(EMGDisp{1}))./max(time),1]);     temp=coeffvalues(cf_);CoeffAG(g,mm)=temp(2);CoeffDG(g,mm)=temp(1);RsqG(g,mm)=goodness.rsquare; end%RtoSl
        subplot(131), plot(time,mean(EMGDisp{1})/CoeffDG(1,mm)), hold on
        subplot(132), plot(time,mean(EMGDisp{2}/CoeffDG(2,mm))), hold on
        subplot(133), plot(time,mean(EMGDisp{3}/CoeffDG(6,mm))), hold on        
end
      
subplot(231)
title(num2str(DiffDur))
xlabel('Wake Gamma')
subplot(232)
xlabel('SWS Gamma')
subplot(233)
xlabel('REM Gamma')
subplot(234)
xlabel('Wake Theta')
subplot(235)
xlabel('SWS Theta')
subplot(236)
xlabel('REM Theta')
    
% Average Diffusion rates
ToUse=[1:5,7,8];
figure
subplot(221)
PlotErrorBar(CoeffAG(ToUse,:)',0)
for g=1:7
    plot(g-0.3,CoeffAG(ToUse(g),:),'.','color','w','MarkerSize',21)
    plot(g-0.3,CoeffAG(ToUse(g),:),'.','color','k','MarkerSize',10)
end
title(num2str(DiffDur))
set(gca,'XTick',[1:7],'Xticklabel',{'Wake','SWS','REM','W--S','S--W','S--R','R--S'})
ylabel('Gamma - alpha')
subplot(223)
PlotErrorBar( (CoeffDG(ToUse,:)'./(CoeffDG(1,:)'*ones(7,1)')),0)
for g=1:7
    plot(g-0.3,CoeffDG(ToUse(g),:)./CoeffDG(1,:),'.','color','w','MarkerSize',21)
    plot(g-0.3,CoeffDG(ToUse(g),:)./CoeffDG(1,:),'.','color','k','MarkerSize',10)
end
set(gca,'XTick',[1:7],'Xticklabel',{'Wake','SWS','REM','W--S','S--W','S--R','R--S'})
ylabel('Gamma-D')

subplot(222)
PlotErrorBar(CoeffAT(ToUse,:)',0)
for g=1:7
    plot(g-0.3,CoeffAT(g,:),'.','color','w','MarkerSize',21)
    plot(g-0.3,CoeffAT(g,:),'.','color','k','MarkerSize',10)
end
ylabel('Theta - alpha')
set(gca,'XTick',[1:7],'Xticklabel',{'Wake','SWS','REM','W--S','S--W','S--R','R--S'})
subplot(224)
PlotErrorBar( (CoeffDT(ToUse,:)'./(CoeffDT(1,:)'*ones(7,1)')),0)
for g=1:7
    plot(g-0.3,CoeffDT(g,:)./CoeffDT(1,:),'.','color','w','MarkerSize',21)
    plot(g-0.3,CoeffDT(g,:)./CoeffDT(1,:),'.','color','k','MarkerSize',10)
end
set(gca,'XTick',[1:7],'Xticklabel',{'Wake','SWS','REM','W--S','S--W','S--R','R--S'})
ylabel('Theta - D')


%Evolution of Diffusion rates
figure
subplot(2,2,1)
PlotErrorBar(CoeffAGTr{1}',0)
for g=1:10
    plot(g-0.3,CoeffAGTr{1}(g,:),'.','color','w','MarkerSize',21)
    plot(g-0.3,CoeffAGTr{1}(g,:),'.','color','k','MarkerSize',10)
end
ylim([0 4])
plot([5.5 5.5],[0 4],'r','linewidth',3)
set(gca,'XTick',[1:10],'XTickLabel',{'-9.1','-7.1','-5.1','-3.1','-1.1','1.1','3.1','5.1','7.1','9.1'})
subplot(2,2,3)
PlotErrorBar(CoeffAGTr{3}',0)
for g=1:10
    plot(g-0.3,CoeffAGTr{3}(g,:),'.','color','w','MarkerSize',21)
    plot(g-0.3,CoeffAGTr{3}(g,:),'.','color','k','MarkerSize',10)
end
ylim([0 4])
plot([5.5 5.5],[0 4],'r','linewidth',3)
set(gca,'XTick',[1:10],'XTickLabel',{'-4.5','-3.5','-2.5','-1.5','-0.5','0.5','1.5','2.5','3.5','4.5'})
subplot(2,2,2)
PlotErrorBar(CoeffAGTr{2}',0)
for g=1:10
    plot(g-0.3,CoeffAGTr{2}(g,:),'.','color','w','MarkerSize',21)
    plot(g-0.3,CoeffAGTr{2}(g,:),'.','color','k','MarkerSize',10)
end
ylim([0 4])
plot([5.5 5.5],[0 4],'r','linewidth',3)
set(gca,'XTick',[1:10],'XTickLabel',{'-9.1','-7.1','-5.1','-3.1','-1.1','1.1','3.1','5.1','7.1','9.1'})
subplot(2,2,4)
PlotErrorBar(CoeffAGTr{4}',0)
for g=1:10
    plot(g-0.3,CoeffAGTr{4}(g,:),'.','color','w','MarkerSize',21)
    plot(g-0.3,CoeffAGTr{4}(g,:),'.','color','k','MarkerSize',10)
end
ylim([0 4])
plot([5.5 5.5],[0 4],'r','linewidth',3)
set(gca,'XTick',[1:10],'XTickLabel',{'-4.5','-3.5','-2.5','-1.5','-0.5','0.5','1.5','2.5','3.5','4.5'})


%Evolution of Diffusion rates
figure
subplot(2,2,1)
PlotErrorBar(CoeffATTr{1}',0)
for g=1:10
    plot(g-0.3,CoeffATTr{1}(g,:),'.','color','w','MarkerSize',21)
    plot(g-0.3,CoeffATTr{1}(g,:),'.','color','k','MarkerSize',10)
end
ylim([0 2.5])
plot([5.5 5.5],[0 2.5],'r','linewidth',3)
set(gca,'XTick',[1:10],'XTickLabel',{'-9.1','-7.1','-5.1','-3.1','-1.1','1.1','3.1','5.1','7.1','9.1'})
subplot(2,2,3)
PlotErrorBar(CoeffATTr{3}',0)
for g=1:10
    plot(g-0.3,CoeffATTr{3}(g,:),'.','color','w','MarkerSize',21)
    plot(g-0.3,CoeffATTr{3}(g,:),'.','color','k','MarkerSize',10)
end
ylim([0 2.5])
plot([5.5 5.5],[0 2.5],'r','linewidth',3)
set(gca,'XTick',[1:10],'XTickLabel',{'-4.5','-3.5','-2.5','-1.5','-0.5','0.5','1.5','2.5','3.5','4.5'})
subplot(2,2,2)
PlotErrorBar(CoeffATTr{2}',0)
for g=1:10
    plot(g-0.3,CoeffATTr{2}(g,:),'.','color','w','MarkerSize',21)
    plot(g-0.3,CoeffATTr{2}(g,:),'.','color','k','MarkerSize',10)
end
ylim([0 2.5])
plot([5.5 5.5],[0 2.5],'r','linewidth',3)
set(gca,'XTick',[1:10],'XTickLabel',{'-9.1','-7.1','-5.1','-3.1','-1.1','1.1','3.1','5.1','7.1','9.1'})
subplot(2,2,4)
PlotErrorBar(CoeffATTr{4}',0)
for g=1:10
    plot(g-0.3,CoeffATTr{4}(g,:),'.','color','w','MarkerSize',21)
    plot(g-0.3,CoeffATTr{4}(g,:),'.','color','k','MarkerSize',10)
end
ylim([0 2.5])
plot([5.5 5.5],[0 2.5],'r','linewidth',3)
set(gca,'XTick',[1:10],'XTickLabel',{'-4.5','-3.5','-2.5','-1.5','-0.5','0.5','1.5','2.5','3.5','4.5'})




% %Evolution of Diffusion rates
% figure
% subplot(2,2,1)
% PlotErrorBar(CoeffDTTr{1}'./(CoeffDTTr{1}(1,:)'*ones(1,10)),0)
% for g=1:10
%     plot(g-0.3,CoeffDTTr{1}(g,:)./CoeffDTTr{1}(1,:),'.','color','w','MarkerSize',21)
%     plot(g-0.3,CoeffDTTr{1}(g,:)./CoeffDTTr{1}(1,:),'.','color','k','MarkerSize',10)
% end
% % ylim([0 2.5])
% plot([5.5 5.5],[0 2.5],'r','linewidth',3)
% subplot(2,2,3)
% PlotErrorBar(CoeffDTTr{3}'./(CoeffDTTr{3}(1,:)'*ones(1,10)),0)
% for g=1:10
%     plot(g-0.3,CoeffDTTr{3}(g,:)./CoeffDTTr{3}(1,:),'.','color','w','MarkerSize',21)
%     plot(g-0.3,CoeffDTTr{3}(g,:)./CoeffDTTr{3}(1,:),'.','color','k','MarkerSize',10)
% end
% % ylim([0 2.5])
% plot([5.5 5.5],[0 2.5],'r','linewidth',3)
% subplot(2,2,2)
% PlotErrorBar(CoeffDTTr{2}'./(CoeffDTTr{2}(1,:)'*ones(1,10)),0)
% for g=1:10
%     plot(g-0.3,CoeffDTTr{2}(g,:)./CoeffDTTr{2}(1,:),'.','color','w','MarkerSize',21)
%     plot(g-0.3,CoeffDTTr{2}(g,:)./CoeffDTTr{2}(1,:),'.','color','k','MarkerSize',10)
% end
% % ylim([0 2.5])
% plot([5.5 5.5],[0 2.5],'r','linewidth',3)
% subplot(2,2,4)
% PlotErrorBar(CoeffDTTr{4}'./(CoeffDTTr{4}(1,:)'*ones(1,10)),0)
% for g=1:10
%     plot(g-0.3,CoeffDTTr{4}(g,:)./CoeffDTTr{4}(1,:),'.','color','w','MarkerSize',21)
%     plot(g-0.3,CoeffDTTr{4}(g,:)./CoeffDTTr{4}(1,:),'.','color','k','MarkerSize',10)
% end
% % ylim([0 2.5])
% plot([5.5 5.5],[0 2.5],'r','linewidth',3)
% 

% %Evolution of Diffusion rates
% figure
% subplot(2,2,1)
% PlotErrorBar(CoeffDGTr{1}'./(CoeffDGTr{1}(1,:)'*ones(1,10)),0)
% for g=1:10
%     plot(g-0.3,CoeffDGTr{1}(g,:)./CoeffDGTr{1}(1,:),'.','color','w','MarkerSize',21)
%     plot(g-0.3,CoeffDGTr{1}(g,:)./CoeffDGTr{1}(1,:),'.','color','k','MarkerSize',10)
% end
% % ylim([0 2.5])
% plot([5.5 5.5],[0 2.5],'r','linewidth',3)
% subplot(2,2,3)
% PlotErrorBar(CoeffDGTr{3}'./(CoeffDGTr{3}(1,:)'*ones(1,10)),0)
% for g=1:10
%     plot(g-0.3,CoeffDGTr{3}(g,:)./CoeffDGTr{3}(1,:),'.','color','w','MarkerSize',21)
%     plot(g-0.3,CoeffDGTr{3}(g,:)./CoeffDGTr{3}(1,:),'.','color','k','MarkerSize',10)
% end
% % ylim([0 2.5])
% plot([5.5 5.5],[0 2.5],'r','linewidth',3)
% subplot(2,2,2)
% PlotErrorBar(CoeffDGTr{2}'./(CoeffDGTr{2}(1,:)'*ones(1,10)),0)
% for g=1:10
%     plot(g-0.3,CoeffDGTr{2}(g,:)./CoeffDGTr{2}(1,:),'.','color','w','MarkerSize',21)
%     plot(g-0.3,CoeffDGTr{2}(g,:)./CoeffDGTr{2}(1,:),'.','color','k','MarkerSize',10)
% end
% % ylim([0 2.5])
% plot([5.5 5.5],[0 2.5],'r','linewidth',3)
% subplot(2,2,4)
% PlotErrorBar(CoeffDGTr{4}'./(CoeffDGTr{4}(1,:)'*ones(1,10)),0)
% for g=1:10
%     plot(g-0.3,CoeffDGTr{4}(g,:)./CoeffDGTr{4}(1,:),'.','color','w','MarkerSize',21)
%     plot(g-0.3,CoeffDGTr{4}(g,:)./CoeffDGTr{4}(1,:),'.','color','k','MarkerSize',10)
% end
% % ylim([0 2.5])
% plot([5.5 5.5],[0 2.5],'r','linewidth',3)

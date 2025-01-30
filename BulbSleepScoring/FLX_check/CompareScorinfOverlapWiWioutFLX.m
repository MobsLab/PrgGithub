Mice = [666,667,668,669];
for mm=1:4
    FileName = {'/media/DataMOBsRAIDN/ProjectEmbReact/FLX_Ctrl_exp/MouseX/20180221_Day',
        '/media/DataMOBsRAIDN/ProjectEmbReact/FLX_Ctrl_exp/MouseX/20180221_Night',
        '/media/DataMOBsRAIDN/ProjectEmbReact/FLX_Ctrl_exp/MouseX/20180222_Day_saline',
        '/media/DataMOBsRAIDN/ProjectEmbReact/FLX_Ctrl_exp/MouseX/20180222_Night_saline',
        '/media/DataMOBsRAIDN/ProjectEmbReact/FLX_Ctrl_exp/MouseX/20180223_Day_fluoxetine',
        '/media/DataMOBsRAIDN/ProjectEmbReact/FLX_Ctrl_exp/MouseX/20180223_Night_fluoxetine',
        '/media/DataMOBsRAIDN/ProjectEmbReact/FLX_Ctrl_exp/MouseX/20180224_Day_fluoxetine48H',
        '/media/DataMOBsRAIDN/ProjectEmbReact/FLX_Ctrl_exp/MouseX/20180224_Night_fluoxetine48H'};
    FileName = strrep(FileName,'MouseX',['Mouse',num2str(Mice(mm))]);
    
    for f = 3
        cd(FileName{f})
        load('SleepScoring_Accelero.mat','REMEpoch','SWSEpoch','Wake')
        REMEpoch1= REMEpoch;
        SWSEpoch1=SWSEpoch;
        Wake1= Wake;
        load('StateEpochSB.mat','REMEpoch','SWSEpoch','Wake','Epoch','smooth_ghi')
        Ep1={REMEpoch,SWSEpoch,Wake};
        Ep1={REMEpoch,SWSEpoch,Wake};
        Ep2={REMEpoch1,SWSEpoch1,Wake1};
        tsdcalc=smooth_ghi;
        Kap(mm,f)=CohenKappaSleepScoring(Ep1,Ep2,tsdcalc);
        
        StateComp{1}(mm,f)=size(Data(Restrict(smooth_ghi,SWSEpoch1)),1);
        StateComp{2}(mm,f)=size(Data(Restrict(smooth_ghi,and(SWSEpoch1,SWSEpoch))),1); %SS
        StateComp{3}(mm,f)=size(Data(Restrict(smooth_ghi,and(SWSEpoch1,Wake))),1); %SW
        StateComp{4}(mm,f)=size(Data(Restrict(smooth_ghi,and(SWSEpoch1,REMEpoch))),1); %SR
        StateComp{5}(mm,f)=size(Data(Restrict(smooth_ghi,REMEpoch1)),1);
        StateComp{6}(mm,f)=size(Data(Restrict(smooth_ghi,and(REMEpoch1,REMEpoch))),1);%RR
        StateComp{7}(mm,f)=size(Data(Restrict(smooth_ghi,and(REMEpoch1,Wake))),1); %RW
        StateComp{8}(mm,f)=size(Data(Restrict(smooth_ghi,and(REMEpoch1,SWSEpoch))),1); %RS
        StateComp{9}(mm,f)=size(Data(Restrict(smooth_ghi,Wake1)),1);
        StateComp{10}(mm,f)=size(Data(Restrict(smooth_ghi,and(Wake,Wake1))),1); %WW
        StateComp{11}(mm,f)=size(Data(Restrict(smooth_ghi,and(Wake1,SWSEpoch))),1); %WS
        StateComp{12}(mm,f)=size(Data(Restrict(smooth_ghi,and(Wake1,REMEpoch))),1); %WR
        
        
    end
end

figure
subplot(121)
f=3;
SWSprop=[(StateComp{2}(:,f)./StateComp{1}(:,f)),(StateComp{4}(:,f)./StateComp{1}(:,f)),...
    (StateComp{3}(:,f)./StateComp{1}(:,f))];
REMprop=[(StateComp{8}(:,f)./StateComp{5}(:,f)),(StateComp{6}(:,f)./StateComp{5}(:,f)),...
    ((StateComp{7}(:,f)./StateComp{5}(:,f)))];
Wakeprop=[(StateComp{11}(:,f)./StateComp{9}(:,f)),(StateComp{12}(:,f)./StateComp{9}(:,f)),...
    (StateComp{10}(:,f)./StateComp{9}(:,f))];

g=bar([1:3],[SWSprop;REMprop;Wakeprop],'Stack'); hold on
set(groot,'defaultAxesColorOrder',[[0.4 0.5 1];[1 0.2 0.2];[0.6 0.6 0.6]])
set(gca,'XTick',[1:3],'XTickLabel',{'SWS','REM','Wake'})
xlim([0.5 3.5])
ylim([0 1.1])
box off
subplot(122)
f=5;
SWSprop=[mean(StateComp{2}(:,f)./StateComp{1}(:,f)),mean(StateComp{4}(:,f)./StateComp{1}(:,f)),...
    mean(StateComp{3}(:,f)./StateComp{1}(:,f))];
REMprop=[mean(StateComp{8}(:,f)./StateComp{5}(:,f)),mean(StateComp{6}(:,f)./StateComp{5}(:,f)),...
    mean((StateComp{7}(:,f)./StateComp{5}(:,f)))];
Wakeprop=[mean(StateComp{11}(:,f)./StateComp{9}(:,f)),mean(StateComp{12}(:,f)./StateComp{9}(:,f)),...
    mean(StateComp{10}(:,f)./StateComp{9}(:,f))];

g=bar([1:3],[SWSprop;REMprop;Wakeprop],'Stack'); hold on
set(groot,'defaultAxesColorOrder',[[0.4 0.5 1];[1 0.2 0.2];[0.6 0.6 0.6]])
set(gca,'XTick',[1:3],'XTickLabel',{'SWS','REM','Wake'})
xlim([0.5 3.5])
ylim([0 1.1])
box off



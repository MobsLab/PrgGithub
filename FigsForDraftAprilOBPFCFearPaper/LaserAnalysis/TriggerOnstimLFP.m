% INPUTS
clear all
Dir.path={
    '/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse458/20161116';
    '/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse458/20161117';
    '/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse459/20161123';
    '/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse465/20170126';
    '/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse465/20170127';
%     '/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse466/20170130';
%     '/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse466/20170131';
    '/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse467/20170202';
    '/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse467/20170203';
%     '/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse468/20170207';
%     '/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse468/20170208';
};

for k=1:length(Dir.path)
    ind_mouse=strfind(Dir.path{k},'Mouse');
    Dir.name{k}=Dir.path{k}(ind_mouse:end);Dir.name{k}=strrep(Dir.name{k},'/','_');
end

AllFreq=[1,2,4,7,10,13,15,20];
Structures={'PFCx','PiCx','dHPC'};
Sides={'Left','Right'}

for d=1:length(Dir.path)
    cd(Dir.path{d})
    clear AllLFP
    load('StimInfo.mat')
    load('StateEpoch.mat','SWSEpoch')
    load('ChannelsToAnalyse/Bulb_deep_left.mat')
    AllChans.Bulb.Left=channel;
    load('ChannelsToAnalyse/Bulb_deep_right.mat')
    AllChans.Bulb.Right=channel;
    load('ChannelsToAnalyse/PFCx_deep_left.mat')
    AllChans.PFCx.Left=channel;
    load('ChannelsToAnalyse/PFCx_deep_right.mat')
    AllChans.PFCx.Right=channel;
    try,load('ChannelsToAnalyse/dHPC_rip.mat')
        AllChans.dHPC.Right=channel;
    catch
        load('ChannelsToAnalyse/dHPC_deep.mat')
        AllChans.dHPC.Right=channel;
    end
    load('ChannelsToAnalyse/PiCx_left.mat')
    AllChans.PiCx.Left=channel;
    load('ChannelsToAnalyse/PiCx_right.mat')
    AllChans.PiCx.Right=channel;
    load('LFPData/DigInfo4.mat')
    Laser=DigTSD;
    StimsTTL=thresholdIntervals(Laser,0.9998,'Direction','Above');
    
    for sd=1:length(Sides)
        OBChan=AllChans.Bulb.(Sides{sd});
        PFCCHan=AllChans.PFCx.(Sides{sd});
        PiCxChan=AllChans.PiCx.(Sides{sd});
        if sd==2
            dHPCChan=AllChans.dHPC.(Sides{sd});
        end
        fig=figure;set(fig,'Position',[680 5580 1500 720])
        subplot(141)
        load(['LFPData/LFP' num2str(OBChan) '.mat'])
        for freq=1:length(AllFreq)
            Stims=find(StimInfo.Freq==AllFreq(freq));
            StimEpoch=and(intervalSet(StimInfo.StartTime(Stims)*1e4,StimInfo.StopTime(Stims)*1e4),SWSEpoch);
            LaserOnTimes=Start(and(StimsTTL,StimEpoch));
            [m,s,tps]=mETAverage(LaserOnTimes,Range(LFP),Data(LFP),10,1000/AllFreq(freq));
            if freq==1
                range=1.5*(max(m)-min(m));
            end
            tps=[-100:200/length(tps):100-200/length(tps)];
            plot(tps,m+range*freq,'k'), hold on
                AllResp.OB.(Sides{sd}){freq}(d,:)=m;
        end
        set(gca,'YTick',[range:range:range*length(AllFreq)],'YTickLabel',{'1Hz','2Hz','4Hz','7Hz','10Hz','13Hz','15Hz','20Hz'});
        ylim([0 range*length(AllFreq)+range])
        title('OB')
        subplot(142)
        load(['LFPData/LFP' num2str(PiCxChan) '.mat'])
        for freq=1:length(AllFreq)
            Stims=find(StimInfo.Freq==AllFreq(freq));
            StimEpoch=and(intervalSet(StimInfo.StartTime(Stims)*1e4,StimInfo.StopTime(Stims)*1e4),SWSEpoch);
            LaserOnTimes=Start(and(StimsTTL,StimEpoch));
            [m,s,tps]=mETAverage(LaserOnTimes,Range(LFP),Data(LFP),10,1000/AllFreq(freq));
            if freq==1
                range=1.5*(max(m)-min(m));
            end
            tps=[-100:200/length(tps):100-200/length(tps)];
            plot(tps,m+range*freq,'k'), hold on
                AllResp.PiCx.(Sides{sd}){freq}(d,:)=m;
        end
        set(gca,'YTick',[range:range:range*length(AllFreq)],'YTickLabel',{'1Hz','2Hz','4Hz','7Hz','10Hz','13Hz','15Hz','20Hz'});
        ylim([0 range*length(AllFreq)+range])
        title('PiCx')
        subplot(143)
        load(['LFPData/LFP' num2str(PFCCHan) '.mat'])
        for freq=1:length(AllFreq)
            Stims=find(StimInfo.Freq==AllFreq(freq));
            StimEpoch=and(intervalSet(StimInfo.StartTime(Stims)*1e4,StimInfo.StopTime(Stims)*1e4),SWSEpoch);
            LaserOnTimes=Start(and(StimsTTL,StimEpoch));
            [m,s,tps]=mETAverage(LaserOnTimes,Range(LFP),Data(LFP),10,1000/AllFreq(freq));
            if freq==1
                range=1.5*(max(m)-min(m));
            end
            tps=[-100:200/length(tps):100-200/length(tps)];
            plot(tps,m+range*freq,'k'), hold on
                AllResp.PFC.(Sides{sd}){freq}(d,:)=m;
        end
        set(gca,'YTick',[range:range:range*length(AllFreq)],'YTickLabel',{'1Hz','2Hz','4Hz','7Hz','10Hz','13Hz','15Hz','20Hz'});
        ylim([0 range*length(AllFreq)+range])
        title('PFCx')
        if sd==2
            subplot(144)
            load(['LFPData/LFP' num2str(dHPCChan) '.mat'])
            for freq=1:length(AllFreq)
                Stims=find(StimInfo.Freq==AllFreq(freq));
                StimEpoch=and(intervalSet(StimInfo.StartTime(Stims)*1e4,StimInfo.StopTime(Stims)*1e4),SWSEpoch);
                LaserOnTimes=Start(and(StimsTTL,StimEpoch));
                [m,s,tps]=mETAverage(LaserOnTimes,Range(LFP),Data(LFP),10,1000/AllFreq(freq));
                if freq==1
                    range=1.5*(max(m)-min(m));
                end
                tps=[-100:200/length(tps):100-200/length(tps)];
                plot(tps,m+range*freq,'k'), hold on
                AllResp.HPC.(Sides{sd}){freq}(d,:)=m;
            end
            set(gca,'YTick',[range:range:range*length(AllFreq)],'YTickLabel',{'1Hz','2Hz','4Hz','7Hz','10Hz','13Hz','15Hz','20Hz'});
            ylim([0 range*length(AllFreq)+range])
            title('dHPC')
        end
%         saveas(fig.Number,['/home/vador/Dropbox/Mobs_member/SophieBagur/FiguresLaserHzFear/StimTriggeredLFP_' Sides{sd} '_' Dir.name{d} '.png'])
%         saveas(fig.Number,['/home/vador/Dropbox/Mobs_member/SophieBagur/FiguresLaserHzFear/StimTriggeredLFP_' Sides{sd} '_' Dir.name{d} '.fig'])
        close all
    end
end

cd /home/vador/Dropbox/Mobs_member/SophieBagur/Figures/FiguresLaserHzFear/ForPaperFigure
load('TriggeredOnLaser.mat','AllFreq','Structures','Sides','AllResp')

% zscore across frequencies
clear AllRespBis
Structures={'OB','PiCx','PFC','HPC'};
for st=1:length(Structures)
    for d=1:length(Dir.path)
        for sd=1:length(Sides)
            try
            temp=[];
            for freq=1:length(AllFreq)
                temp=[temp,AllResp.(Structures{st}).(Sides{sd}){freq}(d,:)];
                lg(freq)=length(temp);
            end
            lg=[0,lg];
            temp=zscore(temp);
            for freq=1:length(AllFreq)
                AllRespBis.(Structures{st}).(Sides{sd}){freq}(d,:)=temp(lg(freq)+1:lg(freq+1));
            end
            end
        end
    end
end

figure
cols=lines(8);
cols=cols([1,6,5,3,2],:);cols=[[0 0 0.5];cols;[0.8 0 0;0.5 0 0]];
for st=1:length(Structures)-1
    subplot(1,3,st)
    for freq=1:length(AllFreq)
        mnamp=[];
        tps=[0:20*pi/length(AllRespBis.PFC.Left{freq}):20*pi-20*pi/length(AllRespBis.PFC.Left{freq})];
%         try,plot(tps,AllRespBis.(Structures{st}).Left{freq}'+freq*8,'color',cols(freq,:)), hold on,
%             mnamp=[mnamp;max(AllRespBis.(Structures{st}).Left{freq}')-min(AllRespBis.(Structures{st}).Left{freq}')];
%         end
        plot(tps,AllRespBis.(Structures{st}).Right{freq}'+freq*8,'color',cols(freq,:)), hold on
        mnamp=[mnamp;max(AllRespBis.(Structures{st}).Right{freq}')-min(AllRespBis.(Structures{st}).Right{freq}')];
        set(gca,'YTick',[8:8:8*length(AllFreq)],'YTickLabel',{'1Hz','2Hz','4Hz','7Hz','10Hz','13Hz','15Hz','20Hz'});
        Amp{st}(freq,:)=mean(mnamp,1)';
    end
    title(Structures{st})
    box off
    xlim([0 60])
end

figure
for st=1:length(Structures)-1
    subplot(1,3,st)
    for freq=1:length(AllFreq)
        mnamp=[];
        tempresp=[];
        tps=[0:20*pi/length(AllRespBis.PFC.Left{freq}):20*pi-20*pi/length(AllRespBis.PFC.Left{freq})];
        try,
            mnamp=[mnamp;max(AllRespBis.(Structures{st}).Left{freq}')-min(AllRespBis.(Structures{st}).Left{freq}')];
            tempresp=[tempresp,AllRespBis.(Structures{st}).Left{freq}'+freq*8];
        end
        mnamp=[mnamp;max(AllRespBis.(Structures{st}).Right{freq}')-min(AllRespBis.(Structures{st}).Right{freq}')];
        tempresp=[tempresp,AllRespBis.(Structures{st}).Right{freq}'+freq*8];
        plot(tps,mean(tempresp'),'r','linewidth',3), hold on
        set(gca,'YTick',[8:8:8*length(AllFreq)],'YTickLabel',{'1Hz','2Hz','4Hz','7Hz','10Hz','13Hz','15Hz','20Hz'});
        Amp{st}(freq,:)=mean(mnamp,1)';
    end
    title(Structures{st})
    box off
    xlim([0 60])
end


figure
cols=[0 0 153/256;153/256 0 153/256;1 51/256 51/256];
for st=1:3%length(Structures)
    Amp2{st}=(Amp{st});
    errorbar(AllFreq,mean(Amp2{st}')',stdError((Amp2{st}')),'linewidth',3,'color',cols(st,:)), hold on
end
legend(Structures)
set(gca,'XTick',AllFreq)
box off

MiceTogether={{1,2},{3},{4,5},{6,7}};

for st=1:3%length(Structures)
for mm=1:length(MiceTogether)
    for ff=1:length(AllFreq)
        Amp2New{st}(ff,mm)=mean(Amp2{st}(ff,cell2mat(MiceTogether{mm})));
    end
end
end


cols=[0 0 153/256;153/256 0 153/256;1 51/256 51/256];
for st=1:3%length(Structures)
    figure
    errorbar(AllFreq,mean(Amp2New{st}')',stdError((Amp2New{st}')),'linewidth',3,'color',cols(st,:)), hold on
end
legend(Structures)
set(gca,'XTick',AllFreq)
box off
xlim([0 21])

figure
cols=[0 0 153/256;153/256 0 153/256;1 51/256 51/256];
for st=1:3%length(Structures)
    Amp2{st}=zscore(Amp{st});
    errorbar(AllFreq,mean(Amp2{st}')',stdError((Amp2{st}')),'linewidth',3,'color',cols(st,:)), hold on
end
legend(Structures)
set(gca,'XTick',AllFreq)
box off

num=1;
for d=1:length(Dir.path)
    cd(Dir.path{d})
    clear AllLFP
    load('StimInfo.mat')
    load('StateEpoch.mat','SWSEpoch')

    load('ChannelsToAnalyse/Bulb_deep_left.mat')
    AllChans.Bulb.Left=channel;
    load('ChannelsToAnalyse/Bulb_deep_right.mat')
    AllChans.Bulb.Right=channel;
    load('ChannelsToAnalyse/PFCx_deep_left.mat')
    AllChans.PFCx.Left=channel;
    load('ChannelsToAnalyse/PFCx_deep_right.mat')
    AllChans.PFCx.Right=channel;
    try,load('ChannelsToAnalyse/dHPC_rip.mat')
        AllChans.dHPC.Right=channel;
    catch
        load('ChannelsToAnalyse/dHPC_deep.mat')
        AllChans.dHPC.Right=channel;
    end
    load('ChannelsToAnalyse/PiCx_left.mat')
    AllChans.PiCx.Left=channel;
    load('ChannelsToAnalyse/PiCx_right.mat')
    AllChans.PiCx.Right=channel;
    load('LFPData/DigInfo4.mat')
    Laser=DigTSD;
    StimsTTL=thresholdIntervals(Laser,0.9998,'Direction','Above');
    
    for sd=1:length(Sides)
        OBChan=AllChans.Bulb.(Sides{sd});
        PFCCHan=AllChans.PFCx.(Sides{sd});
        
        
        load(['LFPData/LFP' num2str(OBChan) '.mat'])
        for freq=1:length(AllFreq)
            Stims=find(StimInfo.Freq==AllFreq(freq));
            LaserOnTimes=ts(StimInfo.StopTime(Stims)*1e4-15*1e4);
            LaserOnTimes=Restrict(LaserOnTimes,SWSEpoch);
            [m,s,tps]=mETAverage(Range(LaserOnTimes),Range(LFP),Data(LFP),10,5000);
            SaveOB{freq}(num,:)=m;
        end
        load(['LFPData/LFP' num2str(PFCCHan) '.mat'])
        for freq=1:length(AllFreq)
            Stims=find(StimInfo.Freq==AllFreq(freq));
            LaserOnTimes=ts(StimInfo.StopTime(Stims)*1e4-15*1e4);
            LaserOnTimes=Restrict(LaserOnTimes,SWSEpoch);
            [m,s,tps]=mETAverage(Range(LaserOnTimes),Range(LFP),Data(LFP),10,5000);
            SavePFC{freq}(num,:)=m;
        end
        num=num+1;
    end
end

% zscore across frequencies
for nn=1:num-1
    for sd=1:length(Sides)
        try
            temp=[];
            for freq=1:length(AllFreq)
                temp=[temp,SavePFC{freq}(nn,:)];
                lg(freq)=length(temp);
            end
            lg=[0,lg];
            temp=zscore(temp);
            for freq=1:length(AllFreq)
                SavePFCBis{freq}(nn,:)=temp(lg(freq)+1:lg(freq+1));
            end
        end
    end
end
for nn=1:num-1
    for sd=1:length(Sides)
        try
            temp=[];
            for freq=1:length(AllFreq)
                temp=[temp,SaveOB{freq}(nn,:)];
                lg(freq)=length(temp);
            end
            lg=[0,lg];
            temp=zscore(temp);
            for freq=1:length(AllFreq)
                SaveOBBis{freq}(nn,:)=temp(lg(freq)+1:lg(freq+1));
            end
        end
    end
end


close all
for freq=1:length(AllFreq)
    figure(1)
    plot(tps,nanmean(SaveOBBis{freq})/2+3*freq,'b','linewidth',2), hold on
    line([0 0],ylim)
    figure(2)
    plot(tps,nanmean(SavePFCBis{freq})+3*freq,'r','linewidth',2), hold on
    line([0 0],ylim)
end

close all
for freq=1:length(AllFreq)
    figure(1)
    plot(tps,(SaveOB{freq})/2+5000*freq,'b','linewidth',2), hold on
    line([0 0],ylim)
    figure(2)
    plot(tps,(SavePFC{freq})+5000*freq,'r','linewidth',2), hold on
    line([0 0],ylim)
end

%%%%%%%%%%%%%%%%

clear all
load('StimInfo.mat')
load('StateEpoch.mat','SWSEpoch')
load('ChannelsToAnalyse/Bulb_deep_left.mat')
AllChans.Bulb.Left=channel;
load('ChannelsToAnalyse/Bulb_deep_right.mat')
AllChans.Bulb.Right=channel;
load('ChannelsToAnalyse/PFCx_deep_left.mat')
AllChans.PFCx.Left=channel;
load('ChannelsToAnalyse/PFCx_deep_right.mat')
AllChans.PFCx.Right=channel;
try,load('ChannelsToAnalyse/dHPC_rip.mat')
    AllChans.dHPC.Right=channel;
catch
    load('ChannelsToAnalyse/dHPC_deep.mat')
    AllChans.dHPC.Right=channel;
end
load('ChannelsToAnalyse/PiCx_left.mat')
AllChans.PiCx.Left=channel;
load('ChannelsToAnalyse/PiCx_right.mat')
AllChans.PiCx.Right=channel;
load('LFPData/DigInfo4.mat')
Laser=DigTSD;
StimsTTL=thresholdIntervals(Laser,0.9998,'Direction','Above');
sd=1;
figure
AllFreq=[1,2,4,7,10,13,15,20];
for freq=1:length(AllFreq)
    OBChan=AllChans.Bulb.Left;
    PFCCHan=AllChans.PFCx.Left;

    
    clf
    Stims=find(StimInfo.Freq==AllFreq(freq));
    StimEpoch=and(intervalSet(StimInfo.StartTime(Stims)*1e4,StimInfo.StopTime(Stims)*1e4),SWSEpoch);
    LaserOnTimes=Start(and(StimsTTL,StimEpoch));
    subplot(121)
    load(['LFPData/LFP' num2str(OBChan) '.mat'])
    
    for k=1:4
        try
            [m,s,tps]=mETAverage(LaserOnTimes(1+50*(k-1):50*(k)),Range(LFP),Data(LFP),10,1000/AllFreq(freq));
            plot(tps,m+20*k,'linewidth',2,'color','b'), hold on
            [m,s,tps]=mETAverage(LaserOnTimes,Range(LFP),Data(LFP),10,1000/AllFreq(freq));
            plot(tps,m+20*k,'linewidth',2,'color','r'), hold on
            
%             [m,s,tps]=mETAverage(LaserOnTimes(1+50*(k-1):1+50*(k)),Range(Laser),Data(Laser),10,1000/AllFreq(freq));
%             plot(tps,m*200+4450*k,'linewidth',2,'color','k'), hold on
        end
    end
    line([0 0],ylim)
    
    subplot(122)
    load(['LFPData/LFP' num2str(PFCCHan) '.mat'])
    for k=1:4
        try
            [m,s,tps]=mETAverage(LaserOnTimes(1+50*(k-1):50*(k)),Range(LFP),Data(LFP),10,1000/AllFreq(freq));
            plot(tps,m+1500*k,'linewidth',2,'color','b'), hold on
            [m,s,tps]=mETAverage(LaserOnTimes,Range(LFP),Data(LFP),10,1000/AllFreq(freq));
            plot(tps,m+1500*k,'linewidth',2,'color','r'), hold on
            
%             [m,s,tps]=mETAverage(LaserOnTimes(1+50*(k-1):1+50*(k)),Range(Laser),Data(Laser),10,1000/AllFreq(freq));
%             plot(tps,m*200+1450*k,'linewidth',2,'color','k'), hold on
        end
    end
    line([0 0],ylim)
    pause
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


       
for freq=1:length(AllFreq)

figure
Stims=find(StimInfo.Freq==AllFreq(freq));
StimEpoch=and(intervalSet(StimInfo.StartTime(Stims)*1e4,StimInfo.StopTime(Stims)*1e4),SWSEpoch);
LaserOnTimes=Start(and(StimsTTL,StimEpoch));
        subplot(121)
        load(['LFPData/LFP' num2str(OBChan) '.mat'])

for k=1:4
    try
    [m,s,tps]=mETAverage(LaserOnTimes(1+50*(k-1):50*(k)),Range(LFP),Data(LFP),10,1000/AllFreq(freq));
    plot(tps,m+4500*k,'linewidth',2,'color','b'), hold on
    [m,s,tps]=mETAverage(LaserOnTimes,Range(LFP),Data(LFP),10,1000/AllFreq(freq));
    plot(tps,m+4500*k,'linewidth',2,'color','r'), hold on
    
    [m,s,tps]=mETAverage(LaserOnTimes(1+50*(k-1):1+50*(k)),Range(Laser),Data(Laser),10,1000/AllFreq(freq));
    plot(tps,m*200+4450*k,'linewidth',2,'color','k'), hold on
    end
end
line([0 0],ylim)

subplot(122)
load(['LFPData/LFP' num2str(PFCCHan) '.mat'])
for k=1:4
    try
    [m,s,tps]=mETAverage(LaserOnTimes(1+50*(k-1):50*(k)),Range(LFP),Data(LFP),10,1000/AllFreq(freq));
    plot(tps,m+1500*k,'linewidth',2,'color','b'), hold on
    [m,s,tps]=mETAverage(LaserOnTimes,Range(LFP),Data(LFP),10,1000/AllFreq(freq));
    plot(tps,m+1500*k,'linewidth',2,'color','r'), hold on
    
    [m,s,tps]=mETAverage(LaserOnTimes(1+50*(k-1):1+50*(k)),Range(Laser),Data(Laser),10,1000/AllFreq(freq));
    plot(tps,m*200+1450*k,'linewidth',2,'color','k'), hold on
    end
end
line([0 0],ylim)
end




MiceTogether={{1,2,3,4},{5,6},{7,8,9,10},{11,12,13,14}};
clear DurSpec
for mm=1:length(MiceTogether)
    BefSpec(mm,:)=zeros(1,263);
    for ff=1:length(AllFreq)
        BefSpec(mm,:)=BefSpec(mm,:)+nanmean(Spec1Pre{ff}(cell2mat(MiceTogether{mm}),:));
        DurSpec{ff}(mm,:)=nanmean(Spec1{ff}(cell2mat(MiceTogether{mm}),:));
    end
end



%%%%%%%%%%%
% INPUTS
clear all
Dir.path={
    '/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse458/20161116';
    '/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse458/20161117';
    '/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse459/20161123';
    '/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse465/20170126';
    '/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse465/20170127';
    %     '/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse466/20170130';
    %     '/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse466/20170131';
    '/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse467/20170202';
    '/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse467/20170203';
    %     '/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse468/20170207';
    %     '/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse468/20170208';
    };

for k=1:length(Dir.path)
    ind_mouse=strfind(Dir.path{k},'Mouse');
    Dir.name{k}=Dir.path{k}(ind_mouse:end);Dir.name{k}=strrep(Dir.name{k},'/','_');
end

AllFreq=[1,2,4,7,10,13,15,20];
Structures={'PFCx','PiCx','dHPC'};
Sides={'Left','Right'}

for d=1:length(Dir.path)
    cd(Dir.path{d})
    clear AllLFP
    load('StimInfo.mat')
    load('StateEpoch.mat','SWSEpoch')
    load('ChannelsToAnalyse/Bulb_deep_left.mat')
    AllChans.Bulb.Left=channel;
    load('ChannelsToAnalyse/Bulb_deep_right.mat')
    AllChans.Bulb.Right=channel;
    load('ChannelsToAnalyse/PFCx_deep_left.mat')
    AllChans.PFCx.Left=channel;
    load('ChannelsToAnalyse/PFCx_deep_right.mat')
    AllChans.PFCx.Right=channel;
    try,load('ChannelsToAnalyse/dHPC_rip.mat')
        AllChans.dHPC.Right=channel;
    catch
        load('ChannelsToAnalyse/dHPC_deep.mat')
        AllChans.dHPC.Right=channel;
    end
    load('ChannelsToAnalyse/PiCx_left.mat')
    AllChans.PiCx.Left=channel;
    load('ChannelsToAnalyse/PiCx_right.mat')
    AllChans.PiCx.Right=channel;
    load('LFPData/DigInfo4.mat')
    Laser=DigTSD;
    StimsTTL=thresholdIntervals(Laser,0.9998,'Direction','Above');
    
    for sd=1:length(Sides)
        OBChan=AllChans.Bulb.(Sides{sd});
        PFCCHan=AllChans.PFCx.(Sides{sd});
        PiCxChan=AllChans.PiCx.(Sides{sd});
        if sd==2
            dHPCChan=AllChans.dHPC.(Sides{sd});
        end
        load(['LFPData/LFP' num2str(OBChan) '.mat'])
        
        for freq=1:length(AllFreq)
            Stims=find(StimInfo.Freq==AllFreq(freq));
            StimEpoch=and(intervalSet(StimInfo.StartTime(Stims)*1e4,StimInfo.StopTime(Stims)*1e4),SWSEpoch);
            [m,s]=PlotRipRaw(LFP,Start(StimEpoch)/1e4+15,15*1e3,0,0);
            varresp=[];
            for kk=1:size(s,1)
                varresp(kk,:)=s(kk,:)-mean(s);
            end
            AllVar.OB.(Sides{sd}){freq}(d,:)=nanmean(std(varresp'))./(std(mean(s)));
        end
        
        load(['LFPData/LFP' num2str(PiCxChan) '.mat'])
        for freq=1:length(AllFreq)
            Stims=find(StimInfo.Freq==AllFreq(freq));
            StimEpoch=and(intervalSet(StimInfo.StartTime(Stims)*1e4,StimInfo.StopTime(Stims)*1e4),SWSEpoch);
            [m,s]=PlotRipRaw(LFP,Start(StimEpoch)/1e4+15,15*1e3,0,0);
            varresp=[];
            for kk=1:size(s,1)
                varresp(kk,:)=s(kk,:)-mean(s);
            end
            AllVar.PiCx.(Sides{sd}){freq}(d,:)=nanmean(std(varresp'))./(std(mean(s)));
        end
        
        
        load(['LFPData/LFP' num2str(PFCCHan) '.mat'])
        for freq=1:length(AllFreq)
            Stims=find(StimInfo.Freq==AllFreq(freq));
            StimEpoch=and(intervalSet(StimInfo.StartTime(Stims)*1e4,StimInfo.StopTime(Stims)*1e4),SWSEpoch);
            [m,s]=PlotRipRaw(LFP,Start(StimEpoch)/1e4+15,15*1e3,0,0);
            varresp=[];
            for kk=1:size(s,1)
                varresp(kk,:)=s(kk,:)-mean(s);
            end
            AllVar.PFC.(Sides{sd}){freq}(d,:)=nanmean(std(varresp'))./(std(mean(s)));
        end
        
        if sd==2
            subplot(144)
            load(['LFPData/LFP' num2str(dHPCChan) '.mat'])
            for freq=1:length(AllFreq)
                Stims=find(StimInfo.Freq==AllFreq(freq));
                StimEpoch=and(intervalSet(StimInfo.StartTime(Stims)*1e4,StimInfo.StopTime(Stims)*1e4),SWSEpoch);
                [m,s]=PlotRipRaw(LFP,Start(StimEpoch)/1e4+15,15*1e3,0,0);
                varresp=[];
                for kk=1:size(s,1)
                    varresp(kk,:)=s(kk,:)-mean(s);
                end
                AllVar.HPC.(Sides{sd}){freq}(d,:)=nanmean(std(varresp'))./(std(mean(s)));
            end
        end
    end
end
figure
Structures={'OB','PiCx','PFC','HPC'};
cols=[0 0 153/256;153/256 0 153/256;1 51/256 51/256];
for st=1:3%length(Structures)
errorbar(AllFreq,mean(zscore([AllVar.(Structures{st}).Left{:}]')'),stdError(zscore([AllVar.(Structures{st}).Left{:}]')'),'color',cols(st,:),'linewidth',3)
hold on
end
ylim([-1.5 2.5])
legend(Structures{1:3})
xlim([0 21])



%%%%%%%%%%%%%%%%%%%%ùù
figure
for kk=1:7
plot(AllRespBis.PFC.Left{1}(kk,:)-mean(AllRespBis.PFC.Left{1})), hold on
end


clear Variab

for st=1:length(Structures)-1
    subplot(1,3,st)
    for freq=1:length(AllFreq)
        varresp=[];
        for kk=1:size(AllRespBis.(Structures{st}).Left{freq},1)
            varresp(kk,:)=AllRespBis.(Structures{st}).Left{freq}(kk,:)-mean(AllRespBis.(Structures{st}).Left{freq});
        end
        
        Variab.(Structures{st}).Left(freq)=nanmean(std(varresp')./(std((AllRespBis.(Structures{st}).Left{freq}'))));
    end
end

for st=1:length(Structures)-1
    subplot(1,3,st)
    for freq=1:length(AllFreq)
        varresp=[];
        for kk=1:size(AllRespBis.(Structures{st}).Right{freq},1)
            varresp(kk,:)=AllRespBis.(Structures{st}).Right{freq}(kk,:)-mean(AllRespBis.(Structures{st}).Right{freq});
        end
        
        Variab.(Structures{st}).Right(freq)=nanmean(std(varresp')./(std((AllRespBis.(Structures{st}).Right{freq}'))));
    end
end

figure
for st=1:length(Structures)-1
    subplot(1,3,st)
    plot(AllFreq,Variab.(Structures{st}).Right+Variab.(Structures{st}).Left,'linewidth',3)
    title(Structures{st})
    xlim([0 21])
    ylim([0.4 2])
end

clear Variab
MiceTogether={{1,2},{3},{4,5},{6,7}};

for st=1:3%length(Structures)
        for freq=1:length(AllFreq)
        varresp=[];
            for mm=1:length(MiceTogether)
                varresp(kk,:)=mean(AllRespBis.(Structures{st}).Right{freq}(cell2mat(MiceTogether{mm}),:))-mean(AllRespBis.(Structures{st}).Right{freq});
            end
            
        Variab.(Structures{st}).Right(freq)=nanmean(std(varresp')./(std(AllRespBis.(Structures{st}).Right{freq}')));
    end
end


for st=1:3%length(Structures)
        for freq=1:length(AllFreq)
        varresp=[];
            for mm=1:length(MiceTogether)
                varresp(kk,:)=mean(AllRespBis.(Structures{st}).Left{freq}(cell2mat(MiceTogether{mm}),:))-mean(AllRespBis.(Structures{st}).Left{freq});
            end
            
        Variab.(Structures{st}).Left(freq)=nanmean(std(varresp')./(std(AllRespBis.(Structures{st}).Right{freq}')));
    end
end


figure
for st=1:length(Structures)-1
    subplot(1,3,st)
    plot(AllFreq,Variab.(Structures{st}).Right+Variab.(Structures{st}).Left,'*-','linewidth',2,'color','k')
    title(Structures{st})
    ylim([0 .35])
    xlim([0 21])
    box off
end
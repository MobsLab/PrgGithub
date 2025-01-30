CaclulateRipples=0;
% Only execute if you want to recalculate ripples
if CaclulateRipples
    clear all
    Files=PathForExperimentsEmbReact('SleepPostUMaze');
    
    for mm=1:size(Files.path,2)
        mm
        if  not(isempty(Files.ExpeInfo{mm}.Ripples))
            cd(Files.path{mm}{1})
            load('StateEpochSB.mat','SWSEpoch')
            load('ChannelsToAnalyse/dHPC_rip.mat')
            load(['LFPData/LFP',num2str(channel),'.mat'])
            InputInfo.SaveRipples=1;
            InputInfo.Epoch=SWSEpoch;
            InputInfo.thresh=[3,5];
            InputInfo.duration=[0.02,0.02,0.2];
            InputInfo.MakeEventFile=1;
            InputInfo.EventFileName='HPCRipplesSleep';
            [Rip2,usedEpoch]=FindRipplesSB(LFP,InputInfo);
            clear SWSEpoch
        end
    end
    
    
    Files=PathForExperimentsEmbReact('SleepPreUmaze');
    
    for mm=1:size(Files.path,2)
        mm
        if  not(isempty(Files.ExpeInfo{mm}.Ripples))
            cd(Files.path{mm}{1})
            load('StateEpochSB.mat','SWSEpoch')
            load('ChannelsToAnalyse/dHPC_rip.mat')
            load(['LFPData/LFP',num2str(channel),'.mat'])
            InputInfo.SaveRipples=1;
            InputInfo.Epoch=SWSEpoch;
            InputInfo.thresh=[3,5];
            InputInfo.duration=[0.02,0.02,0.2];
            InputInfo.MakeEventFile=1;
            InputInfo.EventFileName='HPCRipplesSleep';
            [Rip2,usedEpoch]=FindRipplesSB(LFP,InputInfo);
            clear SWSEpoch
        end
    end
    
    Files=PathForExperimentsEmbReact('UMazeCond');
    for mm=1:size(Files.path,2)
        mm
        if  not(isempty(Files.ExpeInfo{mm}{1}.Ripples))
            for c=1:size(Files.path{mm},2)
                cd( Files.path{mm}{c})
                load('behavResources.mat','FreezeEpoch')
                load('ChannelsToAnalyse/dHPC_rip.mat')
                load(['LFPData/LFP',num2str(channel),'.mat'])
                InputInfo.SaveRipples=1;
                InputInfo.Epoch=FreezeEpoch;
                InputInfo.thresh=[3,5];
                InputInfo.duration=[0.02,0.02,0.2];
                InputInfo.MakeEventFile=1;
                InputInfo.EventFileName='HPCRipplesFreezing';
                if not(isempty(Start(FreezeEpoch)))
                    [Rip2,usedEpoch]=FindRipplesSB(LFP,InputInfo);
                    clear FreezeEpoch
                end
            end
        end
    end
    
end


% Get ripple information
Struct={'dHPC_rip','Bulb_deep','PFCx_deep','TaeniaTecta','InsCx'};
Files=PathForExperimentsEmbReact('SleepPreUmaze');

for mm=1:size(Files.path,2)
    mm
    MouseNameBef{mm}=num2str(Files.ExpeInfo{mm}.nmouse);
    if  not(isempty(Files.ExpeInfo{mm}.Ripples))
        cd(Files.path{mm}{1})
        load('Ripples.mat')
        load('StateEpochSB.mat','SWSEpoch')
        RippleInfo{1}(mm,1)=length(Rip(:,1))./sum(Stop(SWSEpoch,'s')-Start(SWSEpoch,'s')); % density
        RippleInfo{2}(mm,1)=nanmean(Rip(:,3)-Rip(:,1)); % duration
      %  Trigger LFPs on ripples but only beginning of bursts
        RipInterval=diff(Rip(:,2));
        NewRip=Rip(:,2);
        NewRip(find(RipInterval<0.28)+1)=[];
        RandRip=NewRip-rand*4;
        for s=1:length(Struct)
            try
            %Trigger LFP on ripples
            load(['ChannelsToAnalyse/',Struct{s},'.mat'])
            load(['LFPData/LFP',num2str(channel),'.mat'])
            [M,T]=PlotRipRaw(LFP,NewRip,500,1);close;
            AllBLFPBef{s,mm}=M(:,2);
            [M,T]=PlotRipRaw(LFP,RandRip,500,1);close;
            AllBLFPBefRand{s,mm}=M(:,2);
            catch
                AllBLFPBef{s,mm}=NaN;
            end
        end
    end
end

Files=PathForExperimentsEmbReact('SleepPostUMaze');
for mm=1:size(Files.path,2)
    mm
    MouseNameBef{mm}=num2str(Files.ExpeInfo{mm}.nmouse);
    if  not(isempty(Files.ExpeInfo{mm}.Ripples))
        cd(Files.path{mm}{1})
        load('Ripples.mat')
        load('StateEpochSB.mat','SWSEpoch')
        RippleInfo{1}(mm,2)=length(Rip(:,1))./sum(Stop(SWSEpoch,'s')-Start(SWSEpoch,'s')); % density
        RippleInfo{2}(mm,2)=nanmean(Rip(:,3)-Rip(:,1)); % duration
    %    Trigger OB Spectrogram on ripples but only beginning of bursts
        RipInterval=diff(Rip(:,2));
        NewRip=Rip(:,2);
        NewRip(find(RipInterval<0.28)+1)=[];
        RandRip=NewRip-rand*4;
        for s=1:length(Struct)
            try
            %Trigger LFP on ripples
            load(['ChannelsToAnalyse/',Struct{s},'.mat'])
            load(['LFPData/LFP',num2str(channel),'.mat'])
            [M,T]=PlotRipRaw(LFP,NewRip,500,1);close;
            AllBLFPAft{s,mm}=M(:,2);
            [M,T]=PlotRipRaw(LFP,RandRip,500,1);close;
            AllBLFPAftRand{s,mm}=M(:,2);
            catch
                AllBLFPAft{s,mm}=NaN;
            end
        end
    end
end

Files=PathForExperimentsEmbReact('UMazeCond');
clear AllBLFPCond tempdensity tempduration AllBLFPCondRand
for mm=1:size(Files.path,2)
    mm
    if  not(isempty(Files.ExpeInfo{mm}{1}.Ripples))
        for c=1:size(Files.path{mm},2)
            cd( Files.path{mm}{c})
            MouseCondName{mm}=num2str(Files.ExpeInfo{mm}{c}.nmouse);
            load('Ripples.mat')
            load('behavResources.mat','FreezeEpoch')
            if sum(Stop(FreezeEpoch,'s')-Start(FreezeEpoch,'s'))>2
                tempdensity(c)=length(Rip(:,1))./sum(Stop(FreezeEpoch,'s')-Start(FreezeEpoch,'s')); % density
                tempduration(c)=nanmean(Rip(:,3)-Rip(:,1)); % duration
            else
                tempdensity(c)=NaN;
                tempduration(c)=NaN;
            end
            %    Trigger OB Spectrogram on ripples but only beginning of bursts
            RipInterval=diff(Rip(:,2));
            NewRip=Rip(:,2);
            NewRip(find(RipInterval<0.28)+1)=[];
            RandRip=NewRip-rand*4;
            for s=1:length(Struct)
                try
                    %Trigger LFP on ripples
                    load(['ChannelsToAnalyse/',Struct{s},'.mat'])
                    load(['LFPData/LFP',num2str(channel),'.mat'])
                    [M,T]=PlotRipRaw(LFP,NewRip,500,1);close;
                    AllBLFPCond{s,mm}=M(:,2);
                    [M,T]=PlotRipRaw(LFP,RandRip,500,1);close;
                    AllBLFPCondRand{s,mm}=M(:,2);
                catch
                    AllBLFPCond{s,mm}=NaN;
                end
            end
        end
        RippleInfo{1}(mm,3)=nanmean(tempdensity); % density
        RippleInfo{2}(mm,3)=nanmean(tempduration); % duration
        clear tempdensity tempduration
    end
end
RippleInfo{1}(RippleInfo{1}==0)=NaN;
RippleInfo{2}(RippleInfo{2}==0)=NaN;
PlotErrorBarN(RippleInfo{1})
title('density of ripples'),ylabel('per sec'),set(gca,'XTick',[1:3],'XTickLabel',{'SleepBef','CondFZ','SleepAfter'})
PlotErrorBarN(RippleInfo{2})
title('duration of ripples'),ylabel('per sec'),set(gca,'XTick',[1:3],'XTickLabel',{'SleepBef','CondFZ','SleepAfter'})

% Look at triggered LFPs before and after conditinning during sleep
figure
for s=1:length(Struct)
    subplot(5,1,s)
    AllBef=[];AllAft=[];
    for m=1:4
        if size(AllBLFPBef{s,m},1)>1
            plot(M(:,1),AllBLFPBef{s,m},'k')
            AllBef=[AllBef,AllBLFPBef{s,m}];
        end
        hold on
        if size(AllBLFPAft{s,m+1},1)>1
            plot(M(:,1),AllBLFPAft{s,m+1},'r')
            AllAft=[AllAft,AllBLFPAft{s,m+1}];
        end
    end
    plot(M(:,1),nanmean(AllBef'),'k','linewidth',3)
    plot(M(:,1),nanmean(AllAft'),'r','linewidth',3)
    if s==1
    ylim([-2000 2000])
    else
        ylim([-1500 1500])
    end
    xlim([-0.3 0.3])
    line([0 0],ylim)
    title(Struct{s})
    if s==1
        legend({'Before','After'})
    end
end

% Look at triggered LFPs during conditinning during freezing
figure
for s=1:length(Struct)
    subplot(5,1,s)
    AllCond=[];
    for m=1:6
        if size(AllBLFPCond{s,m},1)>1
            plot(M(:,1),AllBLFPCond{s,m},'color',[0.6 0.6 0.6])
            AllCond=[AllCond,AllBLFPCond{s,m}];
        end
        hold on
        
    end
    plot(M(:,1),nanmean(AllCond'),'k','linewidth',3)
  if s==1
    ylim([-2000 2000])
    else
        ylim([-1500 1500])
  end
  xlim([-0.3 0.3])
    line([0 0],ylim)
    title(Struct{s})
end



%%%
% Random this tme
figure
for s=1:length(Struct)
    subplot(5,1,s)
    AllBef=[];AllAft=[];
    for m=1:4
        if size(AllBLFPBefRand{s,m},1)>1
        plot(M(:,1),AllBLFPBefRand{s,m},'k')
        AllBef=[AllBef,AllBLFPBefRand{s,m}];
        end
        hold on
        if size(AllBLFPAftRand{s,m+1},1)>1
        plot(M(:,1),AllBLFPAftRand{s,m+1},'r')
        AllAft=[AllAft,AllBLFPAftRand{s,m+1}];
        end
    end
    plot(M(:,1),nanmean(AllBef'),'k','linewidth',3)
    plot(M(:,1),nanmean(AllAft'),'r','linewidth',3)
       line([0 0],ylim)
 title(Struct{s})
end

% Zscore
figure
for s=1:length(Struct)
    subplot(5,1,s)
    AllBef=[];AllAft=[];
    for m=1:4
        if size(AllBLFPBef{s,m},1)>1
        plot(M(:,1),zscore(AllBLFPBef{s,m}),'k')
        AllBef=[AllBef,zscore(AllBLFPBef{s,m})];
        end
        hold on
        if size(AllBLFPAft{s,m+1},1)>1
        plot(M(:,1),zscore(AllBLFPAft{s,m+1}),'r')
        AllAft=[AllAft,zscore(AllBLFPAft{s,m+1})];
        end
    end
    plot(M(:,1),nanmean(AllBef'),'k','linewidth',3)
    plot(M(:,1),nanmean(AllAft'),'r','linewidth',3)
        line([0 0],ylim)
title(Struct{s})
end

figure
for s=1:length(Struct)
    subplot(5,1,s)
    AllBef=[];AllAft=[];
    for m=1:4
        if size(AllBLFPBef{s,m},1)>1
        plot(M(:,1),ZScoreWiWindowSB(AllBLFPBef{s,m},[1:500]),'k')
        AllBef=[AllBef,ZScoreWiWindowSB(AllBLFPBef{s,m},[1:500])];
        end
        hold on
        if size(AllBLFPAft{s,m+1},1)>1
        plot(M(:,1),ZScoreWiWindowSB(AllBLFPAft{s,m+1},[1:500]),'r')
        AllAft=[AllAft,ZScoreWiWindowSB(AllBLFPAft{s,m+1},[1:500])];
        end
    end
    plot(M(:,1),nanmean(AllBef'),'k','linewidth',3)
    plot(M(:,1),nanmean(AllAft'),'r','linewidth',3)
    line([0 0],ylim)
    title(Struct{s})
end




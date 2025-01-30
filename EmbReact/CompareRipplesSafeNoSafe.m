clear all

if 0
    paramsH.Fs=1250;
paramsH.trialave=0;
paramsH.err=[1 0.0500];
paramsH.pad=2;
paramsH.fpass=[100 300];
paramsH.tapers=[2 3];
movingwinH=[0.05 0.01];


Files=PathForExperimentsEmbReact('UMazeCond');
MouseToAvoid=[431]; % mice with noisy data to exclude
Files=RemoveElementsFromDir(Files,'nmouse',431);

for mm=1:size(Files.path,2)
    mm
    if  not(isempty(Files.ExpeInfo{mm}{1}.Ripples))
        for c=1:size(Files.path{mm},2)
            cd( Files.path{mm}{c})
            load('ChannelsToAnalyse/dHPC_rip.mat')
            load(['LFPData/LFP',num2str(channel),'.mat'])
            [Spectro{1},Spectro{2},Spectro{3}]=mtspecgramc(Data(LFP),movingwinH,paramsH);
            save('HPC_UltraHigh_Spectrum.mat','Spectro'), clear Spectro
            if exist('Ripples.mat')==0
                load('behavResources.mat','FreezeEpoch')
                load('ChannelsToAnalyse/dHPC_rip.mat')
                load(['LFPData/LFP',num2str(channel),'.mat'])
                InputInfo.SaveRipples=1;
                InputInfo.Epoch=FreezeEpoch;
                InputInfo.thresh=[2,4];
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


Files=PathForExperimentsEmbReact('UMazeCondNight');
for mm=1:size(Files.path,2)
    mm
    if  not(isempty(Files.ExpeInfo{mm}{1}.Ripples))
        for c=1:size(Files.path{mm},2)
            cd( Files.path{mm}{c})
            load('ChannelsToAnalyse/dHPC_rip.mat')
            load(['LFPData/LFP',num2str(channel),'.mat'])
            [Spectro{1},Spectro{2},Spectro{3}]=mtspecgramc(Data(LFP),movingwinH,paramsH);
            save('HPC_UltraHigh_Spectrum.mat','Spectro'), clear Spectro
            
            if exist('Ripples.mat')==0
                load('behavResources.mat','FreezeEpoch')
                load('ChannelsToAnalyse/dHPC_rip.mat')
                load(['LFPData/LFP',num2str(channel),'.mat'])
                InputInfo.SaveRipples=1;
                InputInfo.Epoch=FreezeEpoch;
                InputInfo.thresh=[2,4];
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

end
% Get ripple information
clear all
Struct={'dHPC_rip','Bulb_deep','PFCx_deep'};
Files=PathForExperimentsEmbReact('UMazeCond');
MouseToAvoid=[431]; % mice with noisy data to exclude
Files=RemoveElementsFromDir(Files,'nmouse',431);
clear AllBLFPCond tempdensity tempduration AllBLFPCondRand
for mm=1:size(Files.path,2)
    mm
    if  not(isempty(Files.ExpeInfo{mm}{1}.Ripples))
        for c=1:size(Files.path{mm},2)
            cd( Files.path{mm}{c})
            MouseCondName{mm}=num2str(Files.ExpeInfo{mm}{c}.nmouse);
            load('Ripples.mat')
            Riptsd=tsd(Rip(:,1)*1e4,Rip(:,3)-Rip(:,1));
            load('behavResources.mat')
            try
                load('StateEpochSB.mat','TotalNoiseEpoch')
            catch
                TotalNoiseEpoch=intervalSet(0,0.1*1e4);
            end
            load('HPC_UltraHigh_Spectrum.mat','Spectro')
            Sptsd=tsd(Spectro{2}*1e4,Spectro{1});
            RemovEpoch=or(or(StimEpoch,SleepyEpoch),TotalNoiseEpoch);
            FreezeEpoch=FreezeEpoch-RemovEpoch;
            TotEpoch=intervalSet(0,max(Range(Sptsd)));TotEpoch=TotEpoch-RemovEpoch;
            EpToUse={TotEpoch-FreezeEpoch,FreezeEpoch,and(FreezeEpoch,or(ZoneEpoch{2},ZoneEpoch{5})),and(FreezeEpoch,ZoneEpoch{1})};
            
            for Ep=1:length(EpToUse)
                LitEp=EpToUse{Ep};
                if sum(Stop(LitEp,'s')-Start(LitEp,'s'))>2
                    tempdensity(Ep,c)=length(Range(Restrict(Riptsd,LitEp)))./sum(Stop(LitEp,'s')-Start(LitEp,'s')); % density
                    tempduration(Ep,c)=nanmean(Data(Restrict(Riptsd,LitEp))); % duration
                    MeanSpectemp{Ep}(c,:)=mean(Data(Restrict(Sptsd,LitEp)));
                else
                    tempdensity(Ep,c)=NaN;
                    tempduration(Ep,c)=NaN;
                    MeanSpectemp{Ep}(c,:)=nan(1,41);
                end
            end
            
            
            
            
                        %    Trigger LFP on ripples but only beginning of bursts
                        for Ep=1:length(EpToUse)
                            LitEp=EpToUse{Ep};
                            for s=1:length(Struct)
                                if sum(Stop(LitEp,'s')-Start(LitEp,'s'))>2
                                    try
                                    %Trigger LFP on ripples
                                    load(['ChannelsToAnalyse/',Struct{s},'.mat'])
                                    load(['LFPData/LFP',num2str(channel),'.mat'])
                                    [M,T]=PlotRipRaw(LFP,Range(Restrict(Riptsd,LitEp),'s'),500,1);close;
                                    AllBLFPCond{Ep}{s,mm}=M(:,2);
                                    catch
                                        AllBLFPCond{Ep}{s,mm}=NaN;
                                    end
                                else
                                    AllBLFPCond{Ep}{s,mm}=NaN;
                                end
                            end
                        end
        end
        RippleInfo{1}(:,mm)=nanmean(tempdensity'); % density
        RippleInfo{2}(:,mm)=nanmean(tempduration'); % duration
        for Ep=1:length(EpToUse)
            MeanSpec{Ep}(mm,:)=nanmean(MeanSpectemp{Ep});
        end
    end
            clear tempdensity tempduration MeanSpectemp

end
lastm=size(RippleInfo{1},2);

Files=PathForExperimentsEmbReact('UMazeCondNight');
for mm=1:size(Files.path,2)
    mm
    if  not(isempty(Files.ExpeInfo{mm}{1}.Ripples))
        for c=1:size(Files.path{mm},2)
            cd( Files.path{mm}{c})
            MouseCondName{mm}=num2str(Files.ExpeInfo{mm}{c}.nmouse);
            load('Ripples.mat')
            Riptsd=tsd(Rip(:,1)*1e4,Rip(:,3)-Rip(:,1));
            load('behavResources.mat')
            try
                load('StateEpochSB.mat','TotalNoiseEpoch')
            catch
                TotalNoiseEpoch=intervalSet(0,0.1*1e4);
            end
            load('HPC_UltraHigh_Spectrum.mat','Spectro')
            Sptsd=tsd(Spectro{2}*1e4,Spectro{1});
            RemovEpoch=or(or(StimEpoch,SleepyEpoch),TotalNoiseEpoch);
            
            FreezeEpoch=FreezeEpoch-RemovEpoch;
            TotEpoch=intervalSet(0,max(Range(Sptsd)));TotEpoch=TotEpoch-RemovEpoch;
            EpToUse={TotEpoch-FreezeEpoch,FreezeEpoch,and(FreezeEpoch,or(ZoneEpoch{2},ZoneEpoch{5})),and(FreezeEpoch,ZoneEpoch{1})};
            for Ep=1:length(EpToUse)
                LitEp=EpToUse{Ep};
                if sum(Stop(LitEp,'s')-Start(LitEp,'s'))>2
                    tempdensity(Ep,c)=length(Range(Restrict(Riptsd,LitEp)))./sum(Stop(LitEp,'s')-Start(LitEp,'s')); % density
                    tempduration(Ep,c)=nanmean(Data(Restrict(Riptsd,LitEp))); % duration
                    MeanSpectemp{Ep}(c,:)=mean(Data(Restrict(Sptsd,LitEp)));
                else
                    tempdensity(Ep,c)=NaN;
                    tempduration(Ep,c)=NaN;
                    MeanSpectemp{Ep}(c,:)=nan(1,41);
                end
            end
            
            
            %    Trigger LFP on ripples but only beginning of bursts
            for Ep=1:length(EpToUse)
                LitEp=EpToUse{Ep};
                for s=1:length(Struct)
                    if sum(Stop(LitEp,'s')-Start(LitEp,'s'))>2
                        try
                            %Trigger LFP on ripples
                            load(['ChannelsToAnalyse/',Struct{s},'.mat'])
                            load(['LFPData/LFP',num2str(channel),'.mat'])
                            [M,T]=PlotRipRaw(LFP,Range(Restrict(Riptsd,LitEp),'s'),500,1);close;
                            AllBLFPCond{Ep}{s,lastm+mm}=M(:,2);
                        catch
                            AllBLFPCond{Ep}{s,lastm+mm}=NaN;
                        end
                    else
                        AllBLFPCond{Ep}{s,lastm+mm}=NaN;
                    end
                end
            end
        end
        
        RippleInfo{1}(:,lastm+mm)=nanmean(tempdensity'); % density
        RippleInfo{2}(:,lastm+mm)=nanmean(tempduration'); % duration
        for Ep=1:length(EpToUse)
            MeanSpec{Ep}(mm+lastm,:)=nanmean(MeanSpectemp{Ep});
        end
        
        clear tempdensity tempduration MeanSpectemp
    end
end


% RippleInfo{1}(RippleInfo{1}==0)=NaN;
RippleInfo{1}(:,6)=NaN;
RippleInfo{2}(RippleInfo{2}==0)=NaN;
p=PlotErrorBarN(RippleInfo{1}([1,3,4],:)',1,0)
title('density of ripples'),ylabel('per sec'),set(gca,'XTick',[1:3],'XTickLabel',{'NoFz','Fz-Safe','Fz-NoSafe'})

MeanSpec{1}(:,[29:41])=[];
MeanSpec{3}(:,[29:41])=[];
MeanSpec{4}(:,[29:41])=[];

for mm=1:8
    MeanSpec{1}(mm,:)=runmean(MeanSpec{1}(mm,:),3);
    MeanSpec{3}(mm,:)=runmean(MeanSpec{3}(mm,:),3);
    MeanSpec{4}(mm,:)=runmean(MeanSpec{4}(mm,:),3);
    Div=nanmean([(nanmean(MeanSpec{4}(mm,:))),nanmean(MeanSpec{3}(mm,:))]);
    MeanSpec{3}(mm,:)=MeanSpec{3}(mm,:)/Div;
    MeanSpec{4}(mm,:)=MeanSpec{4}(mm,:)/Div;
    MeanSpec{1}(mm,:)=MeanSpec{1}(mm,:)/Div;
end

figure
g=shadedErrorBar(Spectro{3}(1:28),nanmean(MeanSpec{3}),[stdError(MeanSpec{3});stdError(MeanSpec{3})],'r')
hold on
g=shadedErrorBar(Spectro{3}(1:28),nanmean(MeanSpec{4}),[stdError(MeanSpec{4});stdError(MeanSpec{4})],'b')
g=shadedErrorBar(Spectro{3}(1:28),nanmean(MeanSpec{1}),[stdError(MeanSpec{1});stdError(MeanSpec{1})],'k')




% Look at triggered LFPs during conditinning during freezing
figure
for s=1:length(Struct)
    subplot(5,1,s)
    AllCond=[];
    for m=1:6
        if size(AllBLFPCond{Ep}{s,m},1)>1
            plot(M(:,1),AllBLFPCond{Ep}{s,m},'color',[0.6 0.6 0.6])
            AllCond=[AllCond,AllBLFPCond{Ep}{s,m}];
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



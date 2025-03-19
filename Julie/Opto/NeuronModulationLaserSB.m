clear all
WindWid=0.1; %Width of window for PSTH of stim triggered activity
WindWidSnd=0.5; %Width of window for PSTH of sound triggered activity
DirExpe=PathForExperimentFEAR('Fear-electrophy-opto');
OBCH=[23,27];

for expe=1:3
    expe
    cd(DirExpe.path{expe})
    load('LFPData/InfoLFP.mat')
    load('SpikeData.mat')
    load('behavResources.mat')
    Las=InfoLFP.channel(find(strcmp(InfoLFP.structure,'DiodeInput')));
    load(['LFPData/LFP',num2str(Las),'.mat'])
    TotEpoch=intervalSet(0,max(Range(LFP)));
    StimEpoch=thresholdIntervals(LFP,-100,'Direction','Below');
    StTimes=Start(StimEpoch); %precise times of laser stimulation
    BroadStimEpoch=mergeCloseIntervals(StimEpoch,5*1e4);
    BroadStimEpoch=intervalSet(Start(BroadStimEpoch)-1*1e4,Stop(BroadStimEpoch)+1*1e4); % laser on periods
    
    CSMoinsimes=TTL(TTL(:,2)==4,1)*1e4;
    CSPlusTimes=TTL(TTL(:,2)==3,1)*1e4-CSMoinsimes(28)+StTimes(1);
    CSMoinsimes=CSMoinsimes-CSMoinsimes(28)+StTimes(1);
    CSMoinsimes=ts(CSMoinsimes);CSMoinsimes=Restrict(CSMoinsimes,TotEpoch-BroadStimEpoch); % just CS times wihtout the laser stimulations
    CSPlusTimes=ts(CSPlusTimes);CSPlusTimes=Restrict(CSPlusTimes,TotEpoch-BroadStimEpoch);
    % equivalent perdios to the laser on (sound +10sec) when the laser was off
    NoStimEpoch=intervalSet([Range(CSMoinsimes);Range(CSPlusTimes)],[Range(CSMoinsimes);Range(CSPlusTimes)]+0.01*1e4);
    NoStimEpoch=mergeCloseIntervals(NoStimEpoch,3*1e4);NoStimEpoch=intervalSet(Start(NoStimEpoch),Stop(NoStimEpoch)+10*1e4);
    
    for c=1:2
        load(['LFPData/LFP',num2str(OBCH(c)),'.mat'])
        FilLFP{1,c}=FilterLFP(LFP,[1 6],1024);
        FilLFP{2,c}=FilterLFP(LFP,[8 12],1024);
    end
    
    for struct=1:2
        if struct==1,[S,NumNeurons,numtt,TT]=GetSpikesFromStructure('PFCx');elseif struct==2,[S,NumNeurons,numtt,TT]=GetSpikesFromStructure('Bulb');end
        
        goodTT=reshape([TT{NumNeurons}],2,length(NumNeurons));
        NumNeurons(goodTT(2,:)==1)=[];% get rid of MUA
        goodTT(:,goodTT(2,:)==1)=[]; % get rid of MUA
        
        % Triggered on opto stim
        for num=1:length(NumNeurons)
            [fh,sq{struct}{1,num},sweeps{struct}{1,num}, rasterAx, histAx,dArea]=RasterPETH(S{NumNeurons(num)},ts(StTimes),-WindWid*1e4,WindWid*1e4,'BinSize',20);
            keyboard
            [fh,sq{struct}{2,num},sweeps{struct}{2,num}, rasterAx, histAx,dArea]=RasterPETH(S{NumNeurons(num)},CSMoinsimes,-WindWidSnd*1e4,WindWidSnd*1e4,'BinSize',50);close(fh)
            [fh,sq{struct}{3,num},sweeps{struct}{3,num}, rasterAx, histAx,dArea]=RasterPETH(S{NumNeurons(num)},CSPlusTimes,-WindWidSnd*1e4,WindWidSnd*1e4,'BinSize',50);close(fh)
            FR(num)=length(S{NumNeurons(num)})/max(Range(LFP,'s'));
            for c=1:2
                [ph,mu{struct}(c,num), Kappa{struct}(c,num), pval{struct}(c,num),B,C]=ModulationTheta(S{NumNeurons(num)},FilLFP{1,c},BroadStimEpoch,30,0);
                [ph,mu{struct}(2+c,num), Kappa{struct}(2+c,num), pval{struct}(2+c,num),B,C]=ModulationTheta(S{NumNeurons(num)},FilLFP{1,c},NoStimEpoch,30,0);
                [ph,mu{struct}(4+c,num), Kappa{struct}(4+c,num), pval{struct}(4+c,num),B,C]=ModulationTheta(S{NumNeurons(num)},FilLFP{2,c},BroadStimEpoch,30,0);
                [ph,mu{struct}(6+c,num), Kappa{struct}(6+c,num), pval{struct}(6+c,num),B,C]=ModulationTheta(S{NumNeurons(num)},FilLFP{2,c},NoStimEpoch,30,0);
                
            end
        end
    end

    save('NeuronResp.mat','sq','sweeps','FR','mu','Kappa','pval')
    clear sq sweeps FR mu Kappa pval
end



%%% Figures
% Are neurons responding to the opto stims
Structures={'PFCx','OB'};
StimTypes={'Stim','No Stim'};
options=[0,4;2,6] % Stim, 4 vs 10 / No stim 4vs 10
Zwind=[15:45]; % To zscore the PSTH
SortWind=[52:60]; % average to reorder the PSTH
close all
for expe=1:3
    figure
    AllPCFC=[];
    AllOB=[];
    AllNeurp=[];AllNeurB=[];
    ManipP=[];ManipB=[];
    
    cd(DirExpe.path{expe})
    clear sq Kappa pval
    load('NeuronResp.mat','sq','Kappa','pval')
    
    for nn=1:size(sq{1},2)
        if not(isempty(sq{1}{1,nn}))
            temp=ZScoreWiWindowSB(Data(sq{1}{1,nn}),Zwind);
               if not(any(temp>100)) & sum(Data(sq{1}{1,nn}))~=0
            AllPCFC=[AllPCFC,temp];
            AllNeurp=[AllNeurp,nn];
            ManipP=[ManipP,expe];
               end
        end
    end
    
    for nn=1:size(sq{2},2)
        if not(isempty(sq{2}{1,nn}))
            temp=ZScoreWiWindowSB(Data(sq{2}{1,nn}),Zwind);
            if not(any(temp>100)) & sum(Data(sq{2}{1,nn}))~=0
                AllOB=[AllOB,temp];
                AllNeurB=[AllNeurB,nn];
                ManipB=[ManipB,expe];
            end
        end
    end
    
    subplot(3,2,[1,3])
    t=[-0.1:0.002:0.1-0.002];
    PFCOrder=[mean(AllPCFC(SortWind,1:end));AllPCFC(1:end-1,1:end)];
    [PFCOrder,ind]=sortrows(PFCOrder');PFCOrder=PFCOrder(:,2:end);
    imagesc(t,[1:size(PFCOrder,1)],PFCOrder), line([0 0],ylim,'color','k','linewidth',3), caxis([-2 2])
    title(Structures{1})
    subplot(3,2,5)
    g=shadedErrorBar(t,runmean(nanmean(PFCOrder),1),[stdError(PFCOrder);stdError(PFCOrder)],'r'), hold on
    line([0 0],ylim,'color','k','linewidth',3),plot(t(Zwind),ones(1,31))
    subplot(3,2,[1,3]+1)
    OBOrder=[mean(AllOB(SortWind,1:end));AllOB(1:end-1,1:end)];
    [OBOrder,ind]=sortrows(OBOrder');OBOrder=OBOrder(:,2:end);
    imagesc(t,[1:size(OBOrder,1)],OBOrder), line([0 0],ylim,'color','k','linewidth',3), caxis([-2 2])
    title(Structures{2})
    subplot(3,2,6)
    g=shadedErrorBar(t,runmean(nanmean(OBOrder),1),[stdError(OBOrder);stdError(OBOrder)],'r'), hold on
    line([0 0],ylim,'color','k','linewidth',3),plot(t(Zwind),ones(1,31))
    
    
    
    % Which rythym are the neurons entrained to?
    fig1=figure; fig2=figure;
    for struct=1:2
        for stim=1:2 %1 for stim, 2 for nostim
            figure(fig1)
            subplot(2,4,(struct-1)*4+(stim-1)*2+1)
            chanob=1;
            plot(Kappa{struct}(chanob+options(stim,1),:),Kappa{struct}(chanob+options(stim,2),:),'r*'), hold on
            NumNeur(chanob,1)=sum(pval{struct}(chanob+options(stim,1),:)<0.01)./length(pval{struct}(chanob+options(stim,1),:));
            NumNeur(chanob,2)=sum(pval{struct}(chanob+options(stim,2),:)<0.01)./length(pval{struct}(chanob+options(stim,2),:));
            chanob=2;
            plot(Kappa{struct}(chanob+options(stim,1),:),Kappa{struct}(chanob+options(stim,2),:),'b*'), hold on
            NumNeur(chanob,1)=sum(pval{struct}(chanob+options(stim,1),:)<0.01)./length(pval{struct}(chanob+options(stim,1),:));
            NumNeur(chanob,2)=sum(pval{struct}(chanob+options(stim,2),:)<0.01)./length(pval{struct}(chanob+options(stim,2),:));
            legend({'OBch23','OBch27'})
            plot(Kappa{struct}(chanob+options(stim,1),:),Kappa{struct}(chanob+options(stim,1),:),'k')
            xlabel('Kappa for 1-6 Hz'), ylabel('Kappa for 8-12 Hz')
            title([Structures{struct},StimTypes{stim}])
            subplot(2,4,(struct-1)*4+(stim-1)*2+2)
            Vals={[Kappa{struct}(1+options(stim,2),:)-Kappa{struct}(1+options(stim,1),:)]./[Kappa{struct}(1+options(stim,2),:)+Kappa{struct}(1+options(stim,1),:)],...
                [Kappa{struct}(2+options(stim,2),:)-Kappa{struct}(2+options(stim,1),:)]./[Kappa{struct}(2+options(stim,2),:)+Kappa{struct}(2+options(stim,1),:)]};
            plotSpread(Vals,'distributionColors',[0.6 0.6 0.6],'spreadWidth',1,'showMM',4,'xNames',{'OBchan23','OBchan27'})
            line(xlim,[0 0])
            figure(fig2)
            subplot(2,2,(struct-1)*2+stim)
            bar(NumNeur), set(gca,'XTickLabel',{'OBch23','OBch27'}), ylim([0 0.5])
            legend('1-6','10')
            title([Structures{struct},StimTypes{stim}])
            
        end
    end
end

% figure
% plot(Range(LFP,'s'),Data(LFP)), hold on
% plot(Range(Restrict(LFP,BroadStimEpoch),'s'),Data(Restrict(LFP,BroadStimEpoch)),'g')
% plot(StTimes/1e4,-700,'b*')
% plot(CSMoinsimes/1e4,50,'g*')
% plot(CSPlusTimes/1e4,50,'r*')



clear all
WindWid=0.1; %Width of window for PSTH of stim triggered activity
WindWidSnd=0.5; %Width of window for PSTH of sound triggered activity
DirExpe=PathForExperimentFEAR('Fear-electrophy-opto');
OBCH=[23,27];
QtyTime=[];
for expe=1:3
    expe
    cd(DirExpe.path{expe})
    LowSpectrumSB([cd,filesep],23,'B');
    load('B_Low_Spectrum.mat')
    Sptsd=tsd(Spectro{2}*1e4,Spectro{1});
    load('LFPData/InfoLFP.mat')
    load('SpikeData.mat')
    load('behavResources.mat')
    Las=InfoLFP.channel(find(strcmp(InfoLFP.structure,'DiodeInput')));
    load(['LFPData/LFP',num2str(Las),'.mat'])
    TotEpoch=intervalSet(0,max(Range(LFP)));
    StimEpoch=thresholdIntervals(LFP,-100,'Direction','Below');
    StTimes=Start(StimEpoch); %precise times of laser stimulation
    BroadStimEpoch=mergeCloseIntervals(StimEpoch,5*1e4);
    BroadStimEpoch=intervalSet(Start(BroadStimEpoch)-1*1e4,Stop(BroadStimEpoch)+1*1e4); % laser on periods
    
    CSMoinsimes=TTL(TTL(:,2)==4,1)*1e4;
    CSPlusTimes=TTL(TTL(:,2)==3,1)*1e4-CSMoinsimes(28)+StTimes(1);
    CSMoinsimes=CSMoinsimes-CSMoinsimes(28)+StTimes(1);
    CSMoinsimes=ts(CSMoinsimes);CSMoinsimes=Restrict(CSMoinsimes,TotEpoch-BroadStimEpoch); % just CS times wihtout the laser stimulations
    CSPlusTimes=ts(CSPlusTimes);CSPlusTimes=Restrict(CSPlusTimes,TotEpoch-BroadStimEpoch);
    % equivalent perdios to the laser on (sound +10sec) when the laser was off
    NoStimEpoch=intervalSet([Range(CSMoinsimes);Range(CSPlusTimes)],[Range(CSMoinsimes);Range(CSPlusTimes)]+0.01*1e4);
    NoStimEpoch=mergeCloseIntervals(NoStimEpoch,3*1e4);NoStimEpoch=intervalSet(Start(NoStimEpoch),Stop(NoStimEpoch)+10*1e4);
    QtyTime(expe,1)=length(Range(Restrict(LFP,and(BroadStimEpoch,FreezeEpoch))));
    QtyTime(expe,2)=length(Range(Restrict(LFP,BroadStimEpoch-FreezeEpoch)));
    QtyTime(expe,3)=length(Range(Restrict(LFP,and(NoStimEpoch,FreezeEpoch))));
    QtyTime(expe,4)=length(Range(Restrict(LFP,NoStimEpoch-FreezeEpoch)));
    Spec{expe,1}=mean(Data(Restrict(Sptsd,and(BroadStimEpoch,FreezeEpoch))));
    Spec{expe,2}=mean(Data(Restrict(Sptsd,BroadStimEpoch-FreezeEpoch)));
    Spec{expe,3}=mean(Data(Restrict(Sptsd,and(NoStimEpoch,FreezeEpoch))));
    Spec{expe,4}=mean(Data(Restrict(Sptsd,NoStimEpoch-FreezeEpoch)));
    
end

figure
for i=1:3
    subplot(1,3,i)
    plot(Spectro{3},Spec{i,1},'linewidth',2)
    hold on
    plot(Spectro{3},Spec{i,2},'linewidth',2)
    plot(Spectro{3},Spec{i,3},'linewidth',2)
    plot(Spectro{3},Spec{i,4},'linewidth',2)
   legend({'StimFz','StimNoFz','NoStimFz','NoStimNoFZ'}) 
    
end
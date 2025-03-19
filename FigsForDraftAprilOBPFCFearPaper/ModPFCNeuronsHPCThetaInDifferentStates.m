clear all
[Dir,KeepFirstSessionOnly,CtrlEphys]=GetRightSessionsFor4HzPaper('CtrlAllDataSpikes');
ThreshRun=5;
nbin=30;
TimeDur=60;
StartEp=intervalSet(0,TimeDur*1e4);
ToExclude=[];
for sessnum=1:length(KeepFirstSessionOnly)
    cd(Dir.path{KeepFirstSessionOnly(sessnum)})
    disp(Dir.path{KeepFirstSessionOnly(sessnum)})
    % Get Epochs
    load('behavResources.mat')
    DurFz=Stop(FreezeEpoch,'s')-Start(FreezeEpoch,'s');
    if sum(DurFz)>100
        
        RunEp=thresholdIntervals(Movtsd,ThreshRun,'Direction','Above');
        RunEp=dropShortIntervals(RunEp,3*1e4);
        DurRun=Stop(RunEp,'s')-Start(RunEp,'s');
        CumSumDurRun=cumsum(DurRun);
        Lim1=find(CumSumDurRun>TimeDur,1,'first');
        Lim2=find(CumSumDurRun>(max(CumSumDurRun)-TimeDur),1,'first');
        Ep{1}=subset(RunEp,1:Lim1);
        Ep{2}=subset(RunEp,Lim2-1:length(DurRun));
        
        CumSumDurFz=cumsum(DurFz);
        Lim1=find(CumSumDurFz>TimeDur,1,'first');
        Lim2=find(CumSumDurFz>(max(CumSumDurFz)-TimeDur),1,'first');
        Ep{3}=subset(FreezeEpoch,1:Lim1);
        Ep{4}=subset(FreezeEpoch,Lim2-1:length(DurFz));
        
        
        %Get Spikes
        numtt=[]; % nb tetrodes ou montrodes du PFCx
        load LFPData/InfoLFP.mat
        chans=InfoLFP.channel(strcmp(InfoLFP.structure,'PFCx'));
        load('SpikeData.mat')
        for cc=1:length(chans)
            for tt=1:length(tetrodeChannels) % tetrodeChannels= tetrodes ou montrodes (toutes)
                if ~isempty(find(tetrodeChannels{tt}==chans(cc)))
                    numtt=[numtt,tt];
                end
            end
        end
        
        numNeurons=[]; % neurones du PFCx
        for i=1:length(S);
            if ismember(TT{i}(1),numtt)
                numNeurons=[numNeurons,i];
            end
        end
        
        numMUA=[];
        for k=1:length(numNeurons)
            j=numNeurons(k);
            if TT{j}(2)==1
                numMUA=[numMUA, k];
            end
        end
        numNeurons(numMUA)=[];
        
        load('H_Low_Spectrum.mat')
        Sptsd=tsd(Spectro{2}*1e4,Spectro{1});
        
        load('FilteredLFP/MiniMaxiLFPHPC1.mat')
        Sig1=tsd(Range(PhaseInterpol),-sin(mod(Data(PhaseInterpol),2*pi)-pi/2));
        dat=Data(Sig1);tps=Range(Sig1);
        tps(isnan(dat))=[]; dat(isnan(dat))=[];
        Sig1=tsd(tps,dat);
        
        for ep=1:length(Ep)
            for i=1:length(numNeurons)
                try
                    [PhasesSpikes.Real.HPC{sessnum}{ep}{i},mu.Real.HPC{sessnum}{ep}(i),Kappa.Real.HPC{sessnum}{ep}(i),pval.Real.HPC{sessnum}{ep}(i)]=SpikeLFPModulationTransform(S{numNeurons(i)},Sig1,Ep{ep},nbin,0,1);
                catch
                    PhasesSpikes.Real.HPC{sessnum}{ep}{i}.Nontransf=NaN;mu.Real.HPC{sessnum}{ep}(i).Nontransf=NaN;Kappa.Real.HPC{sessnum}{ep}(i).Nontransf=NaN;pval.Real.HPC{sessnum}{ep}(i).Nontransf=NaN;
                    PhasesSpikes.Real.HPC{sessnum}{ep}{i}.Transf=NaN;mu.Real.HPC{sessnum}{ep}(i).Transf=NaN;Kappa.Real.HPC{sessnum}{ep}(i).Transf=NaN;pval.Real.HPC{sessnum}{ep}(i).Transf=NaN;
                end
                a=Range(S{numNeurons(i)});
                b=diff(a);
                b=b(randperm(length(b)));
                S1=tsd(cumsum(b),cumsum(b));
                try,
                    [PhasesSpikes.Rnd.HPC{sessnum}{ep}{i},mu.Rnd.HPC{sessnum}{ep}(i),Kappa.Rnd.HPC{sessnum}{ep}(i),pval.Rnd.HPC{sessnum}{ep}(i)]=SpikeLFPModulationTransform(S1,Sig1,Ep{ep},nbin,0,1);
                catch
                    PhasesSpikes.Rnd.HPC{sessnum}{ep}{i}.Nontransf=NaN;mu.Rnd.HPC{sessnum}{ep}(i).Nontransf=NaN;Kappa.Rnd.HPC{sessnum}{ep}(i).Nontransf=NaN;pval.Rnd.HPC{sessnum}{ep}(i).Nontransf=NaN;
                    PhasesSpikes.Rnd.HPC{sessnum}{ep}{i}.Transf=NaN;mu.Rnd.HPC{sessnum}{ep}(i).Transf=NaN;Kappa.Rnd.HPC{sessnum}{ep}(i).Transf=NaN;pval.Rnd.HPC{sessnum}{ep}(i).Transf=NaN;
                end
                clear S1 a b
                FR{sessnum}{ep}{i}=length(PhasesSpikes.Real.HPC{sessnum}{1}{i}.Transf);
            end
            SpecHPC{sessnum}{ep}=mean(Data(Restrict(Sptsd,Ep{ep})));
            Dur{sessnum}{ep}=sum(Stop(Ep{ep},'s')-Start(Ep{ep},'s'));
            
        end
        
        
        load('B_Low_Spectrum.mat')
        Sptsd=tsd(Spectro{2}*1e4,Spectro{1});
        
        load('FilteredLFP/MiniMaxiLFPOB1.mat')
        Sig1=tsd(Range(PhaseInterpol),-sin(mod(Data(PhaseInterpol),2*pi)-pi/2));
        dat=Data(Sig1);tps=Range(Sig1);
        tps(isnan(dat))=[]; dat(isnan(dat))=[];
        Sig1=tsd(tps,dat);
        
        for ep=1:length(Ep)
            for i=1:length(numNeurons)
                try
                    [PhasesSpikes.Real.OB{sessnum}{ep}{i},mu.Real.OB{sessnum}{ep}(i),Kappa.Real.OB{sessnum}{ep}(i),pval.Real.OB{sessnum}{ep}(i)]=SpikeLFPModulationTransform(S{numNeurons(i)},Sig1,Ep{ep},nbin,0,1);
                catch
                    PhasesSpikes.Real.OB{sessnum}{ep}{i}.Nontransf=NaN;mu.Real.OB{sessnum}{ep}(i).Nontransf=NaN;Kappa.Real.OB{sessnum}{ep}(i).Nontransf=NaN;pval.Real.OB{sessnum}{ep}(i).Nontransf=NaN;
                    PhasesSpikes.Real.OB{sessnum}{ep}{i}.Transf=NaN;mu.Real.OB{sessnum}{ep}(i).Transf=NaN;Kappa.Real.OB{sessnum}{ep}(i).Transf=NaN;pval.Real.OB{sessnum}{ep}(i).Transf=NaN;
                end
                a=Range(S{numNeurons(i)});
                b=diff(a);
                b=b(randperm(length(b)));
                S1=tsd(cumsum(b),cumsum(b));
                try,
                    [PhasesSpikes.Rnd.OB{sessnum}{ep}{i},mu.Rnd.OB{sessnum}{ep}(i),Kappa.Rnd.OB{sessnum}{ep}(i),pval.Rnd.OB{sessnum}{ep}(i)]=SpikeLFPModulationTransform(S1,Sig1,Ep{ep},nbin,0,1);
                catch
                    PhasesSpikes.Rnd.OB{sessnum}{ep}{i}.Nontransf=NaN;mu.Rnd.OB{sessnum}{ep}(i).Nontransf=NaN;Kappa.Rnd.OB{sessnum}{ep}(i).Nontransf=NaN;pval.Rnd.OB{sessnum}{ep}(i).Nontransf=NaN;
                    PhasesSpikes.Rnd.OB{sessnum}{ep}{i}.Transf=NaN;mu.Rnd.OB{sessnum}{ep}(i).Transf=NaN;Kappa.Rnd.OB{sessnum}{ep}(i).Transf=NaN;pval.Rnd.OB{sessnum}{ep}(i).Transf=NaN;
                end
                clear S1 a b
            end
            SpecOB{sessnum}{ep}=mean(Data(Restrict(Sptsd,Ep{ep})));
        end
        
        clear Ep
    else
        ToExclude=[ToExclude,sessnum];
    end
end

SessToUse=1:length(KeepFirstSessionOnly);
SessToUse(ToExclude)=[];

figure,
cols=paruly(4);
subplot(121)
for ep=1:4
plot([25:30],[25:30],'linewidth',3,'color',cols(ep,:)), hold on
end
legend({'Act-beg','Act-end','Fz-beg','Fz-end'})
for ep=1:4
    AllSpec=[];
    for sessnum=SessToUse
        AllSpec=[AllSpec;SpecHPC{sessnum}{ep}];
    end
    [hl,hp]=boundedline(Spectro{3},nanmean(AllSpec),[stdError(AllSpec);stdError(AllSpec)]','alpha'),hold on
    set(hp,'FaceColor',cols(ep,:))
    set(hl,'Color',cols(ep,:)*0.7,'linewidth',2)
end
xlim([0 20])
title('HPC')
subplot(122)
for ep=1:4
    AllSpec=[];
    for sessnum=SessToUse
        AllSpec=[AllSpec;SpecOB{sessnum}{ep}];
    end
    [hl,hp]=boundedline(Spectro{3},nanmean(AllSpec),[stdError(AllSpec);stdError(AllSpec)]','alpha'),hold on
    set(hp,'FaceColor',cols(ep,:))
    set(hl,'Color',cols(ep,:)*0.7,'linewidth',2)
end
title('OB')


Struc={'HPC','OB'};
for ss=1:2
    AllKappa.(Struc{ss}){1}=[];AllKappa.(Struc{ss}){2}=[];AllKappa.(Struc{ss}){3}=[];AllKappa.(Struc{ss}){4}=[];
    for sessnum=SessToUse
        for ep=1:4
            AllKappa.(Struc{ss}){ep}=[AllKappa.(Struc{ss}){ep},[Kappa.Real.(Struc{ss}){sessnum}{ep}(:).Nontransf]];
        end
    end
    
    AllPval.(Struc{ss}){1}=[];AllPval.(Struc{ss}){2}=[];AllPval.(Struc{ss}){3}=[];AllPval.(Struc{ss}){4}=[];
    for sessnum=SessToUse
        for ep=1:3
            AllPval.(Struc{ss}){ep}=[AllPval.(Struc{ss}){ep},[pval.Real.(Struc{ss}){sessnum}{ep}(:).Transf]];
        end
    end
    
    AllMuVal.(Struc{ss}){1}=[];AllMuVal.(Struc{ss}){2}=[];AllMuVal.(Struc{ss}){3}=[];AllMuVal.(Struc{ss}){4}=[];
    for sessnum=SessToUse
        for ep=1:4
            AllMuVal.(Struc{ss}){ep}=[AllMuVal.(Struc{ss}){ep},[mu.Real.(Struc{ss}){sessnum}{ep}(:).Transf]];
        end
    end
end

figure
for ss=1:2
    for k=1:2
        subplot(2,2,k+(ss-1)*2)
        [p,h,stats]=ModIndexPlot(AllKappa.(Struc{ss}){1+(k-1)*2},AllKappa.(Struc{ss}){2+(k-1)*2});
        title(Struc{ss})
        ylabel('BegvsEnd MI')
    end
end

figure
for ss=1:2
    for k=1:2
        
        subplot(2,2,k+(ss-1)*2)
        plot(log(AllKappa.(Struc{ss}){1+(k-1)*2}),log(AllKappa.(Struc{ss}){1+(k-1)*2}),'k'), hold on
        plot(log(AllKappa.(Struc{ss}){1+(k-1)*2}),log(AllKappa.(Struc{ss}){2+(k-1)*2}),'r*')
        xlim([-5 2]),ylim([-5 2])
        xlabel('Beg sess')
        ylabel('End sess')
        title(Struc{ss})
        X=AllKappa.(Struc{ss}){1+(k-1)*2};
        Y=AllKappa.(Struc{ss}){2+(k-1)*2}
        X(isnan(AllKappa.(Struc{ss}){1+(k-1)*2})|isnan(AllKappa.(Struc{ss}){2+(k-1)*2}))=[];
        Y(isnan(AllKappa.(Struc{ss}){1+(k-1)*2})|isnan(AllKappa.(Struc{ss}){2+(k-1)*2}))=[];
        [R,P]=corrcoef(X,Y);
        title(['R=',num2str(R(1,2)),' p=',num2str(P(1,2))])
    end
end


figure
for ss=1:2
    for k=1:2
        
        subplot(2,2,k+(ss-1)*2)
        plot(AllMuVal.(Struc{ss}){1+(k-1)*2},AllMuVal.(Struc{ss}){1+(k-1)*2},'k'), hold on
        scatter(AllMuVal.(Struc{ss}){1+(k-1)*2},AllMuVal.(Struc{ss}){2+(k-1)*2},40,log(AllKappa.(Struc{ss}){2+(k-1)*2}+AllKappa.(Struc{ss}){1+(k-1)*2}),'filled')
        xlabel('Beg sess')
        ylabel('End sess')
        title(Struc{ss})
    end
end

figure
for ss=1:2
    for k=1:2
        
        subplot(2,2,k+(ss-1)*2)
        plot(AllMuVal.(Struc{ss}){1+(k-1)*2},AllMuVal.(Struc{ss}){1+(k-1)*2},'k'), hold on
        scatter(AllMuVal.(Struc{ss}){1+(k-1)*2},AllMuVal.(Struc{ss}){2+(k-1)*2},40,log(AllKappa.(Struc{ss}){2+(k-1)*2}+AllKappa.(Struc{ss}){1+(k-1)*2}),'filled')
        xlabel('Beg sess')
        ylabel('End sess')
        title(Struc{ss})
    end
end

figure
for ss=1:2
    for k=1:2
        
        subplot(2,2,k+(ss-1)*2)
        hist2(AllMuVal.(Struc{ss}){1+(k-1)*2},AllMuVal.(Struc{ss}){2+(k-1)*2},30)
        axis xy
        xlabel('Beg sess')
        ylabel('End sess')
        title(Struc{ss})
    end
end


figure
Cols1=[0,109,219;240,73,73]/263;
alphaval=0.05;
A=[sum(AllPval{2}<=alphaval&AllPval{3}>alphaval),...
    sum(AllPval{2}<=alphaval&AllPval{3}<=alphaval),...
    sum(AllPval{2}>alphaval&AllPval{3}<=alphaval),...
    sum(AllPval{2}>alphaval&AllPval{3}>alphaval)];
h=pie(A)
set(h(1), 'FaceColor', Cols1(1,:));
hh1 = hatchfill(h(3), 'single', -90, 10,Cols1(1,:));
hh1.LineWidth=3;
hh1.Color=Cols1(2,:);
set(h(5), 'FaceColor', Cols1(2,:));
set(h(7), 'FaceColor', 'w');
title('HPC')
X1=(AllPval{2}<alphaval);
X2=(AllPval{3}<alphaval);
[h,p, chi2stat,df] =prop_test([sum(X1),sum(X2)],[length(X1),length(X2)],'true');

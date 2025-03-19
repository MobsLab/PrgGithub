clear all
SessionNames={'ExtinctionBlockedShock_EyeShock' 'ExtinctionBlockedSafe_EyeShock' 'UMazeCond_EyeShock' 'UMazeCondBlockedShock_EyeShock' 'UMazeCondBlockedSafe_EyeShock' };
BiteSize=0.5;
for mm=1:5
    index=1;
    for ss=1:length(SessionNames)
        Files=PathForExperimentsEmbReact(SessionNames{ss});
        MouseToAvoid=[117,560]; % mice with noisy data to exclude
        Files=RemoveElementsFromDir(Files,'nmouse',MouseToAvoid);
        
        for c=1:length(Files.path{mm})
            cd(Files.path{mm}{c})
            disp(Files.path{mm}{c})
            if exist('ChannelsToAnalyse/dHPC_rip.mat')>0
                load('behavResources.mat')
                dt=median(diff(Range(Behav.Movtsd,'s')));
                if not(isempty(Behav.FreezeAccEpoch))
                    FreezeEpoch=Behav.FreezeAccEpoch;
                else
                    FreezeEpoch=Behav.FreezeEpoch;
                end
                load('StateEpochSB.mat','TotalNoiseEpoch')
                TTLInfo.StimEpoch=intervalSet(Start(TTLInfo.StimEpoch),Start(TTLInfo.StimEpoch)+2*1e4);
                RemovEpoch=(or(TTLInfo.StimEpoch,TotalNoiseEpoch));
                clear SleepyEpoch
                try,load('StateEpochSB.mat','SleepyEpoch')
                    RemovEpoch=or(RemovEpoch,SleepyEpoch);
                end
                
                LitEp=dropShortIntervals(FreezeEpoch-RemovEpoch,5*1e4);
                
                load('H_VHigh_Spectrum.mat')
                SptsdHHi=tsd(Spectro{2}*1e4,Spectro{1});
                fHi=Spectro{3};
                
                load('B_Low_Spectrum.mat')
                fLow=Spectro{3};
                Sptsd=tsd(Spectro{2}*1e4,Spectro{1});
                load('H_Low_Spectrum.mat')
                fLow=Spectro{3};
                SptsdHLo=tsd(Spectro{2}*1e4,Spectro{1});
                load('PFCx_Low_Spectrum.mat')
                fLow=Spectro{3};
                SptsdP=tsd(Spectro{2}*1e4,Spectro{1});
                
                begin=Start(LitEp);
                endin=Stop(LitEp);
                for ff=1:length(begin)
                    dur=endin(ff)-begin(ff);
                    numbins=round(dur/(BiteSize*1E4));
                    epdur=(dur/1E4)/numbins;
                    for nn=1:numbins
                        startcounting=begin(ff)+(nn-1)*dur/numbins;
                        stopcounting=begin(ff)+nn*dur/numbins;
                        SpecDataB{mm}(index,:)=mean(Data(Restrict(Sptsd,intervalSet(startcounting,stopcounting))));
                        SpecDataHHi{mm}(index,:)=mean(Data(Restrict(SptsdHHi,intervalSet(startcounting,stopcounting))));
                        SpecDataHLo{mm}(index,:)=mean(Data(Restrict(SptsdHLo,intervalSet(startcounting,stopcounting))));
                        SpecDataP{mm}(index,:)=mean(Data(Restrict(SptsdP,intervalSet(startcounting,stopcounting))));
                        Position{mm}(index,:)=mean(Data(Restrict(Behav.LinearDist,intervalSet(startcounting,stopcounting))));
                        index=index+1;
                    end
                end
                
            end
            
        end
    end
end

SessionNames={'UMazeCond'};
Files=PathForExperimentsEmbReact(SessionNames{1});
MouseToAvoid=[431,117,560]; % mice with noisy data to exclude
Files=RemoveElementsFromDir(Files,'nmouse',MouseToAvoid);
for mm=1:13
    index=1;
    for c=1:length(Files.path{mm})
        cd(Files.path{mm}{c})
        if exist('ChannelsToAnalyse/dHPC_rip.mat')>0
            disp(Files.path{mm}{c})
            load('behavResources.mat')
            dt=median(diff(Range(Behav.Movtsd,'s')));
            if not(isempty(Behav.FreezeAccEpoch))
                FreezeEpoch=Behav.FreezeAccEpoch;
            else
                FreezeEpoch=Behav.FreezeEpoch;
            end
            load('StateEpochSB.mat','TotalNoiseEpoch')
            TTLInfo.StimEpoch=intervalSet(Start(TTLInfo.StimEpoch),Start(TTLInfo.StimEpoch)+2*1e4);
            RemovEpoch=(or(TTLInfo.StimEpoch,TotalNoiseEpoch));
            clear SleepyEpoch
            try,load('StateEpochSB.mat','SleepyEpoch')
                RemovEpoch=or(RemovEpoch,SleepyEpoch);
            end
            LitEp=dropShortIntervals(FreezeEpoch-RemovEpoch,5*1e4);
            
            load('H_VHigh_Spectrum.mat')
            SptsdHHi=tsd(Spectro{2}*1e4,Spectro{1});
            fHi=Spectro{3};
            
            load('B_Low_Spectrum.mat')
            fLow=Spectro{3};
            Sptsd=tsd(Spectro{2}*1e4,Spectro{1});
            load('H_Low_Spectrum.mat')
            fLow=Spectro{3};
            SptsdHLo=tsd(Spectro{2}*1e4,Spectro{1});
            load('PFCx_Low_Spectrum.mat')
            fLow=Spectro{3};
            SptsdP=tsd(Spectro{2}*1e4,Spectro{1});
            
            begin=Start(LitEp);
            endin=Stop(LitEp);
            for ff=1:length(begin)
                dur=endin(ff)-begin(ff);
                numbins=round(dur/(BiteSize*1E4));
                epdur=(dur/1E4)/numbins;
                for nn=1:numbins
                    startcounting=begin(ff)+(nn-1)*dur/numbins;
                    stopcounting=begin(ff)+nn*dur/numbins;
                    SpecDataB{mm+5}(index,:)=mean(Data(Restrict(Sptsd,intervalSet(startcounting,stopcounting))));
                    SpecDataHHi{mm+5}(index,:)=mean(Data(Restrict(SptsdHHi,intervalSet(startcounting,stopcounting))));
                    SpecDataHLo{mm+5}(index,:)=mean(Data(Restrict(SptsdHLo,intervalSet(startcounting,stopcounting))));
                    SpecDataP{mm+5}(index,:)=mean(Data(Restrict(SptsdP,intervalSet(startcounting,stopcounting))));
                    Position{mm+5}(index,:)=mean(Data(Restrict(Behav.LinearDist,intervalSet(startcounting,stopcounting))));
                    index=index+1;
                end
            end
            
        end
    end
end

close all
clear SaveEig
MiceWithRipples=[1,3:9,12:15,18]
ind=1;
for m=1:length(MiceWithRipples)
    mm=MiceWithRipples(m);
    AllData=[];AllPos=[];MouseNum=[];
    AllData=[AllData;(SpecDataB{mm}./nansum(nansum(SpecDataB{mm})))];
    AllPos=[AllPos;Position{mm}];
    MouseNum=[MouseNum;Position{mm}*0+mm];
    if size(AllData,1)>500
        AllPos(find(sum(isnan(AllData'))))=[];
        MouseNum(find(sum(isnan(AllData'))))=[];
        AllData(find(sum(isnan(AllData'))),:)=[];
        AllData=zscore(AllData);
        [EigVect,EigVals]=PerformPCA(AllData');
        for k=1:3
            SaveEig{k}(ind,:)=EigVect(:,k).* sign(EigVect(find(abs(EigVect(:,k))==max(abs(EigVect(1:Lim,k)))),1));
        end
        ind=ind+1;
    end
end

figure
[hl,hp]=boundedline(fLow,nanmean(SaveEig{1}),[stdError(SaveEig{1});stdError(SaveEig{1})]','r','alpha'),hold on
[hl,hp]=boundedline(fLow,nanmean(SaveEig{2}),[stdError(SaveEig{2});stdError(SaveEig{2})]','b','alpha'),hold on
[hl,hp]=boundedline(fLow,nanmean(SaveEig{3}),[stdError(SaveEig{3});stdError(SaveEig{3})]','g','alpha'),hold on

figure
ind=1;
AllData=[];AllPos=[];MouseNum=[];
ind=1;
for mm=1:length(MiceWithRipples)
    TempData=(SpecDataB{MiceWithRipples(mm)}./nansum(nansum(SpecDataB{MiceWithRipples(mm)})));
    AllData=[AllData;TempData];
    AllPos=[AllPos;Position{MiceWithRipples(mm)}];
    MouseNum=[MouseNum;Position{MiceWithRipples(mm)}*0+mm];
    subplot(4,4,ind)
    scatter3(nanmean(SaveEig{1})*TempData',nanmean(SaveEig{2})*TempData',nanmean(SaveEig{3})*TempData',20,Position{MiceWithRipples(mm)},'filled')
    ind=ind+1;
end



Lim=length(fLow);
clear SaveEig
MiceWithRipples=[1,3:9,12:15,18]
ind=1;
for m=1:length(MiceWithRipples)
    mm=MiceWithRipples(m);
    AllData=[];AllPos=[];MouseNum=[];
    AllData=[AllData;(SpecDataHLo{mm}./nansum(nansum(SpecDataHLo{mm})))];
    AllPos=[AllPos;Position{mm}];
    MouseNum=[MouseNum;Position{mm}*0+mm];
    if size(AllData,1)>500
        AllPos(find(sum(isnan(AllData'))))=[];
        MouseNum(find(sum(isnan(AllData'))))=[];
        AllData(find(sum(isnan(AllData'))),:)=[];
        AllData=zscore(AllData);
        [EigVect,EigVals]=PerformPCA(AllData');
        for k=1:3
            SaveEig{k}(ind,:)=EigVect(:,k).* sign(EigVect(find(abs(EigVect(:,k))==max(abs(EigVect(1:Lim,k)))),1));
        end
        ind=ind+1;
    end
end

figure
[hl,hp]=boundedline(fLow,nanmean(SaveEig{1}),[stdError(SaveEig{1});stdError(SaveEig{1})]','r','alpha'),hold on
[hl,hp]=boundedline(fLow,nanmean(SaveEig{2}),[stdError(SaveEig{2});stdError(SaveEig{2})]','b','alpha'),hold on
[hl,hp]=boundedline(fLow,nanmean(SaveEig{3}),[stdError(SaveEig{3});stdError(SaveEig{3})]','g','alpha'),hold on

figure
ind=1;
AllData=[];AllPos=[];MouseNum=[];
ind=1;
for mm=1:length(MiceWithRipples)
    TempData=(SpecDataHLo{MiceWithRipples(mm)}./nansum(nansum(SpecDataHLo{MiceWithRipples(mm)})));
    AllData=[AllData;TempData];
    AllPos=[AllPos;Position{MiceWithRipples(mm)}];
    MouseNum=[MouseNum;Position{MiceWithRipples(mm)}*0+mm];
    subplot(4,4,ind)
    scatter3(nanmean(SaveEig{1})*TempData',nanmean(SaveEig{2})*TempData',nanmean(SaveEig{3})*TempData',20,Position{MiceWithRipples(mm)},'filled')
    ind=ind+1;
end

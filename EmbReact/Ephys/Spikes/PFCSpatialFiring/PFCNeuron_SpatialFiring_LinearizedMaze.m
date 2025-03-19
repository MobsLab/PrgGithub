%% this code generates Neuron spiking along the length of the maze in each condition

clear all, close all
SessNames={'Habituation','TestPre', 'UMazeCond','TestPost','Extinction'};

MiceNumber=[490,507,508,509,510,512,514];

for ss=1:length(SessNames)
    Dir=PathForExperimentsEmbReact(SessNames{ss});
    disp(SessNames{ss})
    
    
    for d=1:length(Dir.path)
        MouseNum_Dir(d) = Dir.ExpeInfo{d}{1}.nmouse;
    end
    [~,PosOfMice]=intersect(MouseNum_Dir,MiceNumber);
    for d=1:length(PosOfMice)
        for dd=1:length(Dir.path{PosOfMice(d)})
            cd(Dir.path{PosOfMice(d)}{dd})
            
            load('behavResources_SB.mat')
            [RunningEpoch,RunSpeed]=GetRunPer(Behav.Xtsd,Behav.Ytsd,4,0);
            
            load('StateEpochSB.mat','TotalNoiseEpoch','SleepyEpoch','Epoch')
            TTLInfo.StimEpoch=intervalSet(Start(TTLInfo.StimEpoch),Stop(TTLInfo.StimEpoch)+1*1e4);
            RemovEpoch=or(or(TTLInfo.StimEpoch,TotalNoiseEpoch),SleepyEpoch);
            RemovEpoch=or(RemovEpoch,Behav.FreezeAccEpoch);
            
            LinDistTemp=Restrict(Behav.LinearDist,RunningEpoch-RemovEpoch);
            LinDistAll{ss}{d}{dd}=Data(LinDistTemp);
            
            Speed=Restrict(Behav.Vtsd,RunningEpoch-RemovEpoch);
            Speed_realigned = (Restrict(Speed,LinDistTemp,'align','closest'));
            SpeedAll{ss}{d}{dd}=Data(Speed_realigned);
            
            load('SpikeData.mat')
            [numNeurons, numtt, TT]=GetSpikesFromStructure('PFCx');
            for nn=1:length(numNeurons)
                S{numNeurons(nn)}=Restrict(S{numNeurons(nn)},RunningEpoch-RemovEpoch);
                tempSp=tsd([0:600:max(Range(LinDistTemp))],hist(Range(S{numNeurons(nn)}),[0:600:max(Range(LinDistTemp))])');
                SAll{ss}{d}{dd}{nn}=(Restrict(tempSp,LinDistTemp,'align','closest'));
            end
        end
    end
end

cd /media/DataMOBsRAIDN/ProjectEmbReact/Figures/SpikeAnalysis/PFCNeurons_UMazeSpatialFiring


NumLims=40;
x=[2:NumLims-1];
clear SpikeTemp AllSpkProfiles
for ss=1:length(SessNames)
    AllSpkProfiles{ss}=[];
    AllOccup{ss}=[];
    AllSpeedLin{ss}=[];
    
    for d=1:length(SAll{ss})
        clear SpikeTemp
        Lintemp=[];
        SpeedTemp=[];
        for sp=1:length(SAll{ss}{d}{1})
            SpikeTemp{sp}=[];
        end
        
        for dd=1:length(SAll{ss}{d})
            Lintemp=[Lintemp;LinDistAll{ss}{d}{dd}];
            SpeedTemp=[SpeedTemp;SpeedAll{ss}{d}{dd}];
            
            for sp=1:length(SAll{ss}{d}{dd})
                SpikeTemp{sp}=[SpikeTemp{sp};Data(SAll{ss}{d}{dd}{sp})];
            end
        end
        
        clear MeanSpk  Occup
        for sp=1:length(SAll{ss}{d}{dd})
            for k=1:NumLims
                Bins=find(Lintemp>(k-1)*1/NumLims & Lintemp<(k)*1/NumLims);
                MeanSpk(sp,k)=nansum(SpikeTemp{sp}(Bins))./length(Bins);
                Occup(k)=length(Bins);
                Spd(k)=nanmean(SpeedTemp(Bins));
            end
        end
        
        AllSpkProfiles{ss}=[AllSpkProfiles{ss};MeanSpk];
        AllOccup{ss}=[AllOccup{ss};Occup];
        AllSpeedLin{ss}=[AllSpeedLin{ss};Spd];
        
        disp(num2str(length(AllSpkProfiles{ss})))
    end
    
end
cd /media/DataMOBsRAIDN/ProjectEmbReact/Figures/SpikeAnalysis/PFCNeurons_UMazeSpatialFiring
save('DataForeSpatialLinearizedSpiking.mat','SAll','LinDistAll','SpeedAll','AllSpkProfiles','AllOccup','AllSpeedLin','-append')

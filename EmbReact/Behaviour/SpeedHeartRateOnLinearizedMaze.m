clear all
% Sessions to study
SessNames={'Habituation','TestPre', 'UMazeCond','TestPost','Extinction',...
    'HabituationNight' 'TestPreNight' 'UMazeCondNight' 'TestPostNight' 'ExtinctionNight',...
    'TestPre_EyeShock' 'UMazeCond_EyeShock' 'TestPost_EyeShock' 'Extinction_EyeShock'};

for ss=1:length(SessNames)
    % Load the data
    Dir=PathForExperimentsEmbReact(SessNames{ss});
    disp(SessNames{ss})
    MouseToAvoid=[404,485,425,560,568,117,431]; % mice with noisy data to exclude
    Dir=RemoveElementsFromDir(Dir,'nmouse',MouseToAvoid);
    
    
    for d=1:length(Dir.path)
        for dd=1:length(Dir.path{(d)})
            cd(Dir.path{d}{dd})
            
            if exist('HeartBeatInfo.mat')>0
                load('HeartBeatInfo.mat')
                
            load('behavResources_SB.mat')
            if median(diff(Range(Behav.Vtsd,'s')))>10
                Behav.Vtsd=tsd(Range(Behav.Vtsd)/1e4,Data(Behav.Vtsd));
                save('behavResources_SB.mat','Behav','-append')
                load('behavResources_SB.mat')
                
            end
            
            [RunningEpoch,RunSpeed]=GetRunPer(Behav.Xtsd,Behav.Ytsd,0.1,0);
            
            load('StateEpochSB.mat','TotalNoiseEpoch','SleepyEpoch','Epoch')
            TTLInfo.StimEpoch=intervalSet(Start(TTLInfo.StimEpoch),Stop(TTLInfo.StimEpoch)+1*1e4);
            RemovEpoch=or(or(TTLInfo.StimEpoch,TotalNoiseEpoch),SleepyEpoch);
            if isfield(Behav,'FreezeAccEpoch')
                Behav.FreezeEpoch=Behav.FreezeAccEpoch;
            end
            if isempty(Behav.FreezeEpoch)
                Behav.FreezeEpoch=intervalSet(0,0.1*1e4);
            end
            RemovEpoch=or(RemovEpoch,Behav.FreezeEpoch);
            
            LinDistTemp=Restrict(Behav.LinearDist,RunningEpoch-RemovEpoch);
            LinDistAll{ss}{d}{dd}=Data(LinDistTemp);
            
            Speed=Restrict(Behav.Vtsd,RunningEpoch-RemovEpoch);
            Speed_realigned = (Restrict(Speed,LinDistTemp,'align','closest'));
            if isempty(Data(Speed_realigned))
            SpeedAll{ss}{d}{dd}=[];
            else
            SpeedAll{ss}{d}{dd}=runmean(Data(Speed_realigned),3);
            SpeedAll{ss}{d}{dd}=(Data(Speed_realigned));
            end
            
            HR=Restrict(EKG.HBRate,RunningEpoch-RemovEpoch);
            HR_realigned = (Restrict(HR,LinDistTemp,'align','closest'));
            if isempty(Data(HR_realigned))
            HRAll{ss}{d}{dd}=[];
            else
            HRAll{ss}{d}{dd}=(Data(HR_realigned));
            end
            
        end
    end
    end 
end

NumLims=40;
for ss=1:length(SessNames)
    AllOccup{ss}=[];
    AllSpeedLin{ss}=[];
    AllHeartLin{ss}=[];
    AllSpeedLin_hist{ss}=[];
    AllHRLin_hist{ss}=[];
    clear AllSpeedLin_temp AllHRLin_temp
    for d=1:length(SpeedAll{ss})
        Lintemp=[];
        SpeedTemp=[];
        HeartTemp=[];
        
        for dd=1:length(SpeedAll{ss}{d})
            Lintemp=[Lintemp;LinDistAll{ss}{d}{dd}];
            SpeedTemp=[SpeedTemp;SpeedAll{ss}{d}{dd}];
            HeartTemp=[HeartTemp;HRAll{ss}{d}{dd}];
        end
        
        clear  Occup Spd HR_hist  Spd_hist
        for k=1:NumLims
            Bins=find(Lintemp>(k-1)*1/NumLims & Lintemp<(k)*1/NumLims);
            Occup(k)=length(Bins);
            Spd(k)=nanmean(SpeedTemp(Bins));
            HR_data(k)=nanmean(HeartTemp(Bins));
            Y=hist(SpeedTemp(Bins),[0:0.1:5]);Y=Y./sum(Y);
            Spd_hist(k,:)=Y;
            Y=hist(HeartTemp(Bins),[7:0.2:15]);Y=Y./sum(Y);
            HR_hist(k,:)=Y;
            
        end
        
        AllOccup{ss}=[AllOccup{ss};Occup];
        AllSpeedLin{ss}=[AllSpeedLin{ss};Spd];
        AllHeartLin{ss}=[AllHeartLin{ss};HR_data];
        AllSpeedLin_temp(d,:,:)=Spd_hist;
        AllHRLin_temp(d,:,:)=HR_hist;
        
    end
    AllSpeedLin_hist{ss}=squeeze(nanmean(AllSpeedLin_temp,1));
    AllHRLin_hist{ss}=squeeze(nanmean(AllHRLin_temp,1));
    
end

figure
for ss=1:length(SessNames)
    if ss>10
        subplot(3,5,ss+1)
    else
        subplot(3,5,ss)
    end
    temp=(AllHeartLin{ss}(:,2:end-1)')';
    mn=nanmean(temp);
    mn(isnan(mn))=0;
    std=stdError(temp);
    std(isnan(std))=0;
    
    [hl,hp]=boundedline([2:39],mn,std);
    title(SessNames{ss})
    ylim([11 14])
end
figure
for ss=1:length(SessNames)
    
    for d=1:length(SpeedAll{ss})
    

        for dd=1:length(SpeedAll{ss}{d})
            Lintemp=[Lintemp;LinDistAll{ss}{d}{dd}];
            SpeedTemp=[SpeedTemp;SpeedAll{ss}{d}{dd}];
            HeartTemp=[HeartTemp;HRAll{ss}{d}{dd}];
        end
   plot(log(SpeedTemp(1:100:end)),HeartTemp(1:100:end),'*'), hold on
        
    end
end
            
            
figure
for ss=1:length(SessNames)
    if ss>10
        subplot(3,5,ss+1)
    else
        subplot(3,5,ss)
        
    end
    imagesc([1:40],[0:0.1:5],log(AllSpeedLin_hist{ss})'), axis xy
    clim([-10 -1])
    hold on
    temp=(AllSpeedLin{ss}(:,2:end-1)')';
    mn=nanmean(temp);
    mn(isnan(mn))=0;
    std=stdError(temp);
    std(isnan(std))=0;
    [hl,hp]=boundedline([2:39],mn,std);
    set(hl,'linewidth',2)
    title(SessNames{ss})
end


figure
for ss=1:length(SessNames)
    if ss>10
        subplot(3,5,ss+1)
    else
        subplot(3,5,ss)
        
    end
    imagesc([1:40],[7:0.2:15],log(AllHRLin_hist{ss})'), axis xy
    clim([-8 -1])
    hold on
    temp=(AllHeartLin{ss}(:,2:end-1)')';
    mn=nanmean(temp);
    mn(isnan(mn))=0;
    std=stdError(temp);
    std(isnan(std))=0;
    
    [hl,hp]=boundedline([2:39],mn,std);
        set(hl,'linewidth',2)

    title(SessNames{ss})
    
end


figure
for ss=1:length(SessNames)
    if ss>10
        subplot(3,5,ss+1)
    else
        subplot(3,5,ss)
        
    end
    AllSp=[];
    AllHrt=[];
    for d=1:length(SpeedAll{ss})
        SpeedTemp=[];
        HeartTemp=[];
        for dd=1:length(SpeedAll{ss}{d})
            Lintemp=[Lintemp;LinDistAll{ss}{d}{dd}];
            SpeedTemp=[SpeedTemp;SpeedAll{ss}{d}{dd}];
            HeartTemp=[HeartTemp;HRAll{ss}{d}{dd}];
        end
%         plot(log(SpeedTemp(1:100:end)),HeartTemp(1:100:end),'*'), hold on
        %            hist2(log(SpeedTemp(1:100:end)),HeartTemp(1:100:end)), hold on
        AllSp=[AllSp;SpeedTemp(1:100:end)];
        AllHrt=[AllHrt;HeartTemp(1:100:end)];
    end
histogram2(log(AllSp),AllHrt,[-7.5:0.5:4],[7:0.5:15],'DisplayStyle','tile'), hold on
    title(SessNames{ss})
xlim([-7.5 4])
ylim([7 15])
xlabel('speed - log'),ylabel('HR')
end

figure
AllSp=[];
AllHrt=[];

for ss=1:length(SessNames)
    for d=1:length(SpeedAll{ss})
        SpeedTemp=[];
        HeartTemp=[];
        for dd=1:length(SpeedAll{ss}{d})
            Lintemp=[Lintemp;LinDistAll{ss}{d}{dd}];
            SpeedTemp=[SpeedTemp;SpeedAll{ss}{d}{dd}];
            HeartTemp=[HeartTemp;HRAll{ss}{d}{dd}];
        end
        AllSp=[AllSp;SpeedTemp(1:100:end)];
        AllHrt=[AllHrt;HeartTemp(1:100:end)];
    end
end
histogram2(log(AllSp),AllHrt,[-7.5:0.5:4],[7:0.5:15],'DisplayStyle','tile'), hold on
xlim([-7.5 4])
ylim([7 15])
xlabel('speed - log'),ylabel('HR')


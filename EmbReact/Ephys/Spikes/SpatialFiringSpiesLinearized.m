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


NumLims=40;
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

temp=[];
for ss=1:length(SessNames)
    temp=[temp,nanzscore(AllSpkProfiles{ss}')'];
end

ToUse=(sum(isnan(temp)')<10);

% Habituation on MI
OnlySigNeur=0;
load('Firing_Hab_NewRandomisation.mat')
AllNeurMI=[];AllNeurMIVal=[];
for mouse_num=1:7
    for sp=1:length(EpochFR{mouse_num,1})
        if IsPFCNeuron{mouse_num}(sp)==1
            if OnlySigNeur
                AllNeurMI=[AllNeurMI,EpochFR{mouse_num,1}(sp).Run.Shock_NoShock.IsSig];
            else
                AllNeurMI=[AllNeurMI,1];
            end
            AllNeurMIVal=[AllNeurMIVal,EpochFR{mouse_num,1}(sp).Run.Shock_NoShock.real];
            
        end
    end
end
AllNeurMI=AllNeurMI(ToUse);
AllNeurMIVal=AllNeurMIVal(ToUse);
AllNeurMIVal=AllNeurMIVal(find(AllNeurMI));

figure
for ss=1:length(SessNames)
    subplot(5,3,(ss-1)*3+1)
    A=(nanzscore(AllSpkProfiles{ss}')');
    A=A(:,2:end-1);
    A=A(ToUse,:);
    A=A(find(AllNeurMI),:);
    B{ss}=(sortrows([AllNeurMIVal',A]));
    B{ss}=B{ss}(:,2:end);
    imagesc(B{ss}(:,2:end)),axis xy
    set(gca,'XTick',[10,28],'XTickLabel',{'Shock','Safe'})
    title(SessNames{ss})
    clim([-2 2])
end


clear Mat
for s=1:size(B{1},1)
    for t=1:size(B{1},1)
        Mat(s,t)=abs(s-t);
    end
end

for ss=1:length(SessNames)
    X=corr(B{ss}',B{1}');
    subplot(5,3,(ss-1)*3+2)
    imagesc(X),clim([-0.3 0.3]),axis xy
    xlabel('Hab'), ylabel(SessNames{ss})
 subplot(5,3,(ss-1)*3+3)
    plot(Mat(:),X(:),'*'), xlim([0 max(max(Mat))]), ylim([-1 1])
    [Val_H(ss,1),Val_H(ss,2)]=corr(Mat(:),X(:));
    MeanCorr_diag_H(ss)=nanmean(diag(X));
    title(SessNames{ss})
end

% Extinction on MI
load('Firing_Ext_NewRandomisation.mat')
AllNeurMI=[];AllNeurMIVal=[];
for mouse_num=1:7
    for sp=1:length(EpochFR{mouse_num,1})
        if IsPFCNeuron{mouse_num}(sp)==1
            if OnlySigNeur
            AllNeurMI=[AllNeurMI,EpochFR{mouse_num,1}(sp).Run.Shock_NoShock.IsSig];
            else
                AllNeurMI=[AllNeurMI,1];
            end
            AllNeurMIVal=[AllNeurMIVal,EpochFR{mouse_num,1}(sp).Run.Shock_NoShock.real];
            
        end
    end
end
AllNeurMI=AllNeurMI(ToUse);
AllNeurMIVal=AllNeurMIVal(ToUse);
AllNeurMIVal=AllNeurMIVal(find(AllNeurMI));
figure
temp=[];
for ss=1:length(SessNames)
    temp=[temp,nanzscore(AllSpkProfiles{ss}')'];
end

ToUse=(sum(isnan(temp)')<10);
for ss=1:length(SessNames)
    subplot(5,3,(ss-1)*3+1)
    A=(nanzscore(AllSpkProfiles{ss}')');
    A=A(:,2:end-1);
    A=A(ToUse,:);
    A=A(find(AllNeurMI),:);
    B{ss}=(sortrows([AllNeurMIVal',A]));
    B{ss}=B{ss}(:,2:end);
    imagesc(B{ss}(:,2:end)),axis xy
    set(gca,'XTick',[10,28],'XTickLabel',{'Shock','Safe'})
    title(SessNames{ss})
    clim([-2 2])
end


clear Mat
for s=1:size(B{1},1)
    for t=1:size(B{1},1)
        Mat(s,t)=abs(s-t);
    end
end

for ss=1:length(SessNames)
    X=corr(B{ss}',B{5}');
    subplot(5,3,(ss-1)*3+2)
    imagesc(X),clim([-0.2 0.2]),axis xy
    xlabel('Ext'), ylabel(SessNames{ss})
    subplot(5,3,(ss-1)*3+3)
    tree=linkage((2*sqrt(1-X)));
    plot(Mat(:),X(:),'*'), xlim([0 max(max(Mat))]), ylim([-1 1])
    [Val_E(ss,1),Val_E(ss,2)]=corr(Mat(:),X(:));
    MeanCorr_diag_E(ss)=nanmean(diag(X));
    title(SessNames{ss})
end

figure,
plot(Val_E(:,1),'r-o','linewidth',3), hold on, plot(Val_H(:,1),'b-o','linewidth',3)
for ss=1:length(SessNames)
    if Val_E(ss,2)<0.05
        plot(ss,0.1,'r*')
    end
    if Val_H(ss,2)<0.05
        plot(ss,0.15,'b*')
    end
end
line(xlim,[0 0],'linewidth',3,'color','k')
set(gca,'XTick',[1:5],'XTickLabel',SessNames)


% Habituation on peak
ss=1;
A=(nanzscore(AllSpkProfiles{ss}')');
A=A(:,2:end-1);
A=A(ToUse,:);
[val,ind]=max(A');

figure
for ss=1:length(SessNames)
    subplot(5,3,(ss-1)*3+1)
    A=(nanzscore(AllSpkProfiles{ss}')');
    A=A(:,2:end-1);
    A=A(ToUse,:);
    B{ss}=(sortrows([-ind',A]));
    B{ss}=B{ss}(:,2:end);
    imagesc(B{ss}(:,2:end)),axis xy
    set(gca,'XTick',[10,28],'XTickLabel',{'Shock','Safe'})
    title(SessNames{ss})
    clim([-2 2])
end


clear Mat
for s=1:size(B{1},1)
    for t=1:size(B{1},1)
        Mat(s,t)=abs(s-t);
    end
end

for ss=1:length(SessNames)
    X=corr(B{ss}',B{1}');
    subplot(5,3,(ss-1)*3+2)
    imagesc(X),clim([-0.3 0.3]),axis xy
    xlabel('Hab'), ylabel(SessNames{ss})
    subplot(5,3,(ss-1)*3+3)
    plot(Mat(:),X(:),'*'), xlim([0 max(max(Mat))]), ylim([-1 1])
    [Val_H(ss,1),Val_H(ss,2)]=corr(Mat(:),X(:));
    MeanCorr_diag_H(ss)=nanmean(diag(X));
    title(SessNames{ss})
end

% Extinction on peak
figure
ss=5;
A=(nanzscore(AllSpkProfiles{ss}')');
A=A(:,2:end-1);
A=A(ToUse,:);
[val,ind]=max(A');

for ss=1:length(SessNames)
    subplot(5,3,(ss-1)*3+1)
    A=(nanzscore(AllSpkProfiles{ss}')');
    A=A(:,2:end-1);
    A=A(ToUse,:);
    B{ss}=(sortrows([-ind',A]));
    B{ss}=B{ss}(:,2:end);
    imagesc(B{ss}(:,2:end)),axis xy
    set(gca,'XTick',[10,28],'XTickLabel',{'Shock','Safe'})
    title(SessNames{ss})
    clim([-2 2])
end


clear Mat
for s=1:size(B{1},1)
    for t=1:size(B{1},1)
        Mat(s,t)=abs(s-t);
    end
end

for ss=1:length(SessNames)
    X=corr(B{ss}',B{5}');
    subplot(5,3,(ss-1)*3+2)
    imagesc(X),clim([-0.2 0.2]),axis xy
    xlabel('Ext'), ylabel(SessNames{ss})
    subplot(5,3,(ss-1)*3+3)
    tree=linkage((2*sqrt(1-X)));
    plot(Mat(:),X(:),'*'), xlim([0 max(max(Mat))]), ylim([-1 1])
    [Val_E(ss,1),Val_E(ss,2)]=corr(Mat(:),X(:));
    MeanCorr_diag_E(ss)=nanmean(diag(X));
    title(SessNames{ss})
end

figure,
plot(Val_E(:,1),'r-o','linewidth',3), hold on, plot(Val_H(:,1),'b-o','linewidth',3)
for ss=1:length(SessNames)
    if Val_E(ss,2)<0.05
        plot(ss,0.1,'r*')
    end
    if Val_H(ss,2)<0.05
        plot(ss,0.15,'b*')
    end
end
line(xlim,[0 0],'linewidth',3,'color','k')
set(gca,'XTick',[1:5],'XTickLabel',SessNames)

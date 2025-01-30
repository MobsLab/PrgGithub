function [WfId,W]=IdentifyWaveforms(Filename,FilenamDropBox,PlotOrNot,numNeurons)

% This function requires the information in MeanWaveform.mat
% You can generate this matrix using function GetWFInfo.m
% But it would be best to automatically perform this stage during
% pre-processing : see makeDataSBVfin to get lines of code

% This function get's the library of WF stored in
% PrgMatlab/WaveFormLibrary.mat that is generated from 629 PFCX neurons and
% re-clusters your waveforms with these neurons to identigy putative pyr
% cells and interneurons

%% Required input
% Filename : MeanWaveform must be here
% PlotOrNot : 1 if you want a plot, 0 otherwise
% FilenamDropBox : the folder that contains the dropbox
% numNeurons : neurons to actually use, [1:totnumberofneurons]

%% Output
% WfId :The identity of your neurons. -1 for putative interneurons, 1 for
% putative pyramidal cells

clear W
try
    load([Filename 'MeanWaveform.mat'])
catch
    load([Filename filesep 'MeanWaveform.mat'])
end

try
    load([FilenamDropBox 'Dropbox/Kteam/PrgMatlab/WaveFormLibrary.mat'])
catch
    load([FilenamDropBox  filesep 'Dropbox/Kteam/PrgMatlab/WaveFormLibrary.mat'])
end

% Get new WF Data
WFData=reshape([Params{numNeurons}],3,size(numNeurons,2))';
% Add library WF Data
ClusterData=[AllData2(:,1:3);WFData];
% Cluster using FR and half-spike width
ClusterData(:,1)=ClusterData(:,1)./(max(ClusterData(:,1))-min(ClusterData(:,1)));
ClusterData(:,2)=ClusterData(:,2)./(max(ClusterData(:,2))-min(ClusterData(:,2)));
ClusterData(:,3)=ClusterData(:,3)./(max(ClusterData(:,3))-min(ClusterData(:,3)));

rmpath([FilenamDropBox  filesep 'Dropbox/Kteam/PrgMatlab/Fra/UtilsStats']);
AllWfId=kmeans(ClusterData(:,1:3),2);
addpath([FilenamDropBox  filesep 'Dropbox/Kteam/PrgMatlab/Fra/UtilsStats']);
% Identify the PN cell group as the most numerous one
NumofOnes=sum(AllWfId==1)/length(AllWfId);
if NumofOnes>0.5
    AllWfId(AllWfId==1)=1;
    AllWfId(AllWfId==2)=-1;
else
    AllWfId(AllWfId==1)=-1;
    AllWfId(AllWfId==2)=1;
end

% Get new waveforms

for ww=1:length(numNeurons)
    clear Peak
    for elec=1:4
        try
            Peak{ww}(elec)=min(W{numNeurons(ww)}(elec,:));
        end
    end
    [~,BestElec{ww}]=min(Peak{ww});
    WaveToUse(ww,:)=W{numNeurons(ww)}(BestElec{ww},:);
end

% Just restrict to new WF
WfId=AllWfId(size(AllData2,1)+1:end);
for ff=1:size(WfId,1)
    WaveToUse(ff,:)=WaveToUse(ff,:)./(abs(min(WaveToUse(ff,:))));
end
% Restrict to library WF
AllWF=(AllData2(:,end-31:end)')';
OldWfId=AllWfId(1:size(AllData2,1));
for ff=1:size(OldWfId,1)
    AllWF(ff,:)=AllWF(ff,:)./(abs(min(AllWF(ff,:))));
end


%% Look at distance to average WF to find the WF that are hard to classify
MeanPyr=mean(AllWF(OldWfId==1,:));
PyrNeurons=find(OldWfId==1);
for ff=1:length(PyrNeurons)
    DistToMeanPyr(ff,:)=sum(abs(AllWF(PyrNeurons(ff),:)-MeanPyr));
end
LimPyr=mean(DistToMeanPyr)+2*std(DistToMeanPyr);
AmbigPyrOld=PyrNeurons((DistToMeanPyr>LimPyr));
PyrNeurons=find(WfId==1);

for ff=1:length(PyrNeurons)
    DistToMeanPyrNew(ff,:)=sum(abs(WaveToUse(PyrNeurons(ff),:)-MeanPyr));
end
if ~isempty(PyrNeurons)
    AmbigPyrNew=PyrNeurons((DistToMeanPyrNew>LimPyr));
else
    AmbigPyrNew=[];
end

MeanInt=mean(AllWF(OldWfId==-1,:));
IntNeurons=find(OldWfId==-1);
for ff=1:length(IntNeurons)
    DistToMeanInt(ff)=sum(abs(AllWF(IntNeurons(ff),:)-MeanInt));
end
LimInt=mean(DistToMeanInt)+2*std(DistToMeanInt);
AmbigIntOld=IntNeurons((DistToMeanInt>LimInt));
IntNeurons=find(WfId==-1);
for ff=1:length(IntNeurons)
    DistToMeanIntNew(ff,:)=sum(abs(WaveToUse(IntNeurons(ff),:)-MeanInt));
end
if ~isempty(IntNeurons)
    AmbigIntNew=IntNeurons((DistToMeanIntNew>LimInt));
else
    AmbigIntNew=[];DistToMeanIntNew=[];
end



% Make figure if desired
if PlotOrNot
    figure;
    subplot(2,3,[1,2])
    plot3(AllData2(OldWfId==-1,3),AllData2(OldWfId==-1,2),AllData2(OldWfId==-1,1),'r.','MarkerSize',5)
    hold on,plot3(AllData2(OldWfId==1,3),AllData2(OldWfId==1,2),AllData2(OldWfId==1,1),'b.','MarkerSize',5)
    legend({'Int','PN'})
    plot3(AllData2(AmbigIntOld,3),AllData2(AmbigIntOld,2),AllData2(AmbigIntOld,1),'ro','MarkerSize',15)
    plot3(AllData2(AmbigPyrOld,3),AllData2(AmbigPyrOld,2),AllData2(AmbigPyrOld,1),'bo','MarkerSize',15)
    plot3(WFData(WfId==-1,3),WFData(WfId==-1,2),WFData(WfId==-1,1),'m.','MarkerSize',5)
    hold on,plot3(WFData(WfId==1,3),WFData(WfId==1,2),WFData(WfId==1,1),'c.','MarkerSize',5)
    plot3(WFData(AmbigIntNew,3),WFData(AmbigIntNew,2),WFData(AmbigIntNew,1),'mo','MarkerSize',15)
    plot3(WFData(AmbigPyrNew,3),WFData(AmbigPyrNew,2),WFData(AmbigPyrNew,1),'co','MarkerSize',15)
    subplot(2,3,4)
    hist(DistToMeanPyr,50,'k'),
    h = findobj(gca,'Type','patch');
    set(h,'FaceColor','b','EdgeColor','w')
    hold on, line([LimPyr LimPyr],get(gca,'ylim'),'color','k','linewidth',3)
    if ~isempty(PyrNeurons)
    plot(DistToMeanPyrNew,max(get(gca,'ylim'))/2,'k*')
    title('Dist to MeanWF Pyr')
    end
    subplot(2,3,5)
    hist(DistToMeanInt,50),
    h = findobj(gca,'Type','patch');
    set(h,'FaceColor','r','EdgeColor','w')
    hold on, line([LimInt LimInt],get(gca,'ylim'),'color','k','linewidth',3)
    if ~isempty(IntNeurons)
        plot(DistToMeanIntNew,max(get(gca,'ylim'))/2,'k*')
        title('Dist to MeanWF Int')
    end
    subplot(2,3,[3])
    plot(AllWF(OldWfId==1,:)','b'),
    hold on
    if ~isempty(PyrNeurons)
        plot(WaveToUse(WfId==1,:)','c'),
        plot(AllWF(AmbigPyrOld,:)','k'),
        legend({'old','new','ambig'})
    end
    subplot(2,3,[6])
    plot(AllWF(OldWfId==-1,:)','r'),
    hold on
    if ~isempty(IntNeurons)
        
        plot(WaveToUse(WfId==-1,:)','m')
        plot(AllWF(AmbigIntOld,:)','k'),
    end
end
WfId(AmbigIntNew)=-0.5;
WfId(AmbigPyrNew)=0.5;
disp(['Proportion of interneurons : ' num2str(length(find(WfId==-1))./(length(find(WfId==-1))+length(find(WfId==1)))*100) '%'])


end
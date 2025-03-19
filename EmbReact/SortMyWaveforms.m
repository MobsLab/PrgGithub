function [UnitID,UnitIDOld,WFInfo]=SortMyWaveforms(WFMat,DropBoxLocation,PlotOrNot)

% WFMat : matrix of WF for n units : n x 32 data points
% DropBoxLocation : location of PrgMatlab/WaveFormLibrary.matm should look something
% like this '/Users/sophiebagur/Dropbox/'
% PlotOrNot=1 if you want to plot

% UnitID = -1/-0.5 for IN and 1/0.5 for PN - just for your new neurons
% UnitIDOld for the library neurons
% WFInfo All Params for all neurons, new and library

% Load the  data
load([DropBoxLocation 'PrgMatlab/WaveFormLibrary.mat'])
LibraryWF=(AllData2(:,end-31:end)');
Dat=[LibraryWF,WFMat];

% Get all the parameters
for k=1:size(Dat,2)
    WaveToUseResample(k,:) = resample(Dat(:,k),300,1);
    WaveToUseResample(k,:)=WaveToUseResample(k,:)./(max(WaveToUseResample(k,:))-min(WaveToUseResample(k,:)));
   
    % Trough To Peak
    [valMin,indMin]=min(WaveToUseResample(k,:));
    [val2,ind2]=max(WaveToUseResample(k,indMin:end));
    WFInfo.TroughToPeakTime(k)=ind2*5e-5/300;
   
    % Half amplitude duration
    HalfAmp=valMin/2;
    TimeAtHlafAmp(1)=find(WaveToUseResample(k,:)<HalfAmp,1,'first');
    TimeAtHlafAmp(2)=find(WaveToUseResample(k,:)<HalfAmp,1,'last');
    WFInfo.HalfAmpDur(k)=(TimeAtHlafAmp(2)-TimeAtHlafAmp(1))*5e-5/300;
   
    % Get half width
    DD=diff(WaveToUseResample(k,:));
    diffpeak=find(DD(indMin:end)==max(DD(indMin:end)))+indMin;
    DD=DD(diffpeak:end);
    IndMax=find(DD<max(abs(diff(WaveToUseResample(k,:))))*0.01,1,'first')+diffpeak;
    if WaveToUseResample(k,IndMax)<0
        try
            IndMax=find(WaveToUseResample(k,IndMax:end)>0,1,'first')+IndMax ;
        catch
            IndMax=length(WaveToUseResample(k,:));
        end
    end
    WFInfo.HalfWidth(k)=(IndMax-indMin)*5e-5/300;
   
    % Area under curve
    WaveToUseResampleTemp=WaveToUseResample(k,indMin:end);
    valzero=find(WaveToUseResampleTemp>0,1,'first');
    WaveToCalc=WaveToUseResampleTemp(valzero:end);
    WFInfo.AreaUnderCurve(k)=sum(abs(WaveToCalc));
    WFInfo.AreaUnderCurveNorm(k)=sum(abs(WaveToCalc))./(length(WaveToUseResample(k,:))-valzero);
   
    % Assymetry
    MaxBef=max(WaveToUseResample(k,1:indMin));
    MaxAft=max(WaveToUseResample(k,indMin:end));
    WFInfo.Assymetry(k)=(MaxAft-MaxBef)./(MaxAft+MaxBef);
    
    % is this for a new (0) or a library neuron (1)
    WFInfo.OldOrNew(k)=k<=size(LibraryWF,2);
end

% classify using the parameters TroughToPeakTime, HalfAmpDur and Assymetry

rmpath([DropBoxLocation 'PrgMatlab/Fra/UtilsStats']);
AllParams=([WFInfo.HalfAmpDur/range(WFInfo.HalfAmpDur);WFInfo.Assymetry/range(WFInfo.Assymetry);WFInfo.TroughToPeakTime/range(WFInfo.TroughToPeakTime)]');
A=kmeans(AllParams,2);
addpath([DropBoxLocation 'PrgMatlab/Fra/UtilsStats']);

% 1 is Pyr, -1 is Int
NumofOnes=sum(A==1)/length(A);
if NumofOnes>0.5
    A(A==1)=1;
    A(A==2)=-1;
else
    A(A==1)=-1;
    A(A==2)=1;
end


%% Look at distance to average WF to find the WF that are hard to classify
MeanPyr=mean(Dat(:,A==1)')';
PyrNeurons=find(A==1);
for ff=1:length(PyrNeurons)
    DistToMeanPyr(ff)=sum(abs(Dat(:,PyrNeurons(ff))-MeanPyr));
end
LimPyr=mean(DistToMeanPyr)+2*std(DistToMeanPyr);
AmbigPyr=PyrNeurons((DistToMeanPyr>LimPyr));
A(AmbigPyr)=0.5;

MeanInt=mean(Dat(:,A==-1)')';
IntNeurons=find(A==-1);
for ff=1:length(IntNeurons)
    DistToMeanInt(ff)=sum(abs(Dat(:,IntNeurons(ff))-MeanInt));
end
LimInt=mean(DistToMeanInt)+2*std(DistToMeanInt);
AmbigInt=IntNeurons((DistToMeanInt>LimInt));
A(AmbigInt)=-0.5;

%Separate the old from the new
UnitID=A(end-size(WFMat,2)+1:end);
UnitIDOld=A(1:size(LibraryWF,2));
% Make figure if desired
if PlotOrNot
    figure;
    subplot(2,3,[1,2])
    %old units
    plot3(AllParams(UnitIDOld==-1,3),AllParams(UnitIDOld==-1,2),AllParams(UnitIDOld==-1,1),'r.','MarkerSize',5)
    hold on,plot3(AllParams(UnitIDOld==1,3),AllParams(UnitIDOld==1,2),AllParams(UnitIDOld==1,1),'b.','MarkerSize',5)
    legend({'Int','PN'})
    plot3(AllParams(UnitIDOld==-0.5,3),AllParams(UnitIDOld==-0.5,2),AllParams(UnitIDOld==-0.5,1),'ro','MarkerSize',15)
    plot3(AllParams(UnitIDOld==0.5,3),AllParams(UnitIDOld==0.5,2),AllParams(UnitIDOld==0.5,1),'bo','MarkerSize',15)
   
    plot3(AllParams(UnitID==-1,3),AllParams(UnitID==-1,2),AllParams(UnitID==-1,1),'m.','MarkerSize',5)
    hold on,plot3(AllParams(UnitID==1,3),AllParams(UnitID==1,2),AllParams(UnitID==1,1),'c.','MarkerSize',5)
    plot3(AllParams(UnitID==-0.5,3),AllParams(UnitID==-0.5,2),AllParams(UnitID==-0.5,1),'mo','MarkerSize',15)
    plot3(AllParams(UnitID==0.5,3),AllParams(UnitID==0.5,2),AllParams(UnitID==0.5,1),'co','MarkerSize',15)
   
    subplot(2,3,4)
    hist(DistToMeanPyr,50,'k'),
    h = findobj(gca,'Type','patch');
    set(h,'FaceColor','b','EdgeColor','w')
    hold on, line([LimPyr LimPyr],get(gca,'ylim'),'color','k','linewidth',3)
   
   
    subplot(2,3,5)
    hist(DistToMeanInt,50),
    h = findobj(gca,'Type','patch');
    set(h,'FaceColor','r','EdgeColor','w')
    hold on, line([LimInt LimInt],get(gca,'ylim'),'color','k','linewidth',3)
    
   
    subplot(2,3,[3])
    plot(Dat(:,UnitIDOld==1),'b'),
    hold on
    if ~isempty(PyrNeurons)
        plot(Dat(:,UnitID==1),'c'),
        plot(Dat(:,UnitID==0.5),'k'),
        legend({'old','new','ambig'})
    end
   
    subplot(2,3,[6])
    plot(Dat(:,UnitIDOld==-1),'r'),
    hold on
    if ~isempty(IntNeurons)
        plot(Dat(:,UnitID==-1),'m'),
        plot(Dat(:,UnitID==-0.5),'k'),
    end
end

disp(['Proportion of interneurons new data : ' num2str(length(find(UnitID==-1))./(length(find(UnitID==-1))+length(find(UnitID==1)))*100) '%'])
disp(['Proportion of interneurons library data: ' num2str(length(find(UnitIDOld==-1))./(length(find(UnitIDOld==-1))+length(find(UnitIDOld==1)))*100) '%'])



end

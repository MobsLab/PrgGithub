FolderNameAllUMaze{1}{1,1}=strrep(FolderNameAllUMaze{1}{1,1},'/media/DataSophie1/ProjectEmbReac','/media/sophie/My Passport1/ProjectEmbReac');
FolderNameAllUMaze{1}{1,1}=strrep(FolderNameAllUMaze{1}{1,1},'/media/DataSophie2/ProjectEmbReac','/media/sophie/My Passport/ProjectEmbReac');

cd(FolderNameAllUMaze{1}{1,1})

clear im_diff PosMat Movtsd Zone pixratio
%% Get all data for time stamps
load([cd filesep 'behavResources.mat'],'im_diff','PosMat','pixratio','Zone','ref','mask')
try im_diff;
catch
    load([cd filesep 'Behavior.mat'],'im_diff','PosMat','pixratio','Zone')
end

tps=PosMat(:,1);
PosMatOriginal=PosMat;
im_diffOriginal=tps;
clear im_diff PosMat Movtsd

%% load new data
if exist('ResultsTrackinfOfflineBis.mat')
    copyfile('ResultsTrackinfOfflineBis.mat','ResultsTrackinfOffline.mat')
    delete('ResultsTrackinfOfflineBis.mat')
end
load('ResultsTrackinfOffline.mat')

% Sort out PosMat
PosMatOriginal(:,2)=PosMat(:,1)*pixratio;
PosMatOriginal(:,3)=PosMat(:,2)*pixratio;
PosMat=PosMatOriginal;
% correct for nans
PosMatInt=PosMat;
x=PosMatInt(:,2);
nanx = isnan(x);
t    = 1:numel(x);
x(nanx) = interp1(t(~nanx), x(~nanx), t(nanx));
if isnan(x(1))
    x(1:find(not(isnan(x)),1,'first'))=x(find(not(isnan(x)),1,'first'));
end
if isnan(x(end))
    x(find(not(isnan(x)),1,'last'):end)=x(find(not(isnan(x)),1,'last'));
end

PosMatInt(:,2)=x;
x=PosMatInt(:,3);
nanx = isnan(x);
t    = 1:numel(x);
x(nanx) = interp1(t(~nanx), x(~nanx), t(nanx));
if isnan(x(1))
    x(1:find(not(isnan(x)),1,'first'))=x(find(not(isnan(x)),1,'first'));
end
if isnan(x(end))
    x(find(not(isnan(x)),1,'last'):end)=x(find(not(isnan(x)),1,'last'));
end
PosMatInt(:,3)=x;
PosMat=PosMatInt;
Movtsd=tsd(PosMat(1:end-1,1)*1e4,sqrt(diff(PosMat(:,2)).^2+diff(PosMat(:,3)).^2));
Xtsd=tsd(PosMat(:,1)*1e4,(PosMat(:,2)));
Ytsd=tsd(PosMat(:,1)*1e4,(PosMat(:,3)));
clear PosMatInt PosMatOriginal Movtsd

% Sort out im_diff
im_diffOriginal(:,2)=im_diff;
im_diff=im_diffOriginal;
%deal zith nans
im_diffint=im_diff;
x=im_diffint(:,2);
nanx = isnan(x);
t    = 1:numel(x);
x(nanx) = interp1(t(~nanx), x(~nanx), t(nanx));
x(isnan(x))=nanmean(x);
im_diffint(:,2)=x;
im_diff=im_diffint;
ImDiffTsd=tsd(tps*1e4,runmean(im_diff(:,2),smoofact));
clear im_diffint im_diffOriginal

% Freezing

FreezeEpoch=thresholdIntervals(ImDiffTsd,th_immob,'Direction','Below');
FreezeEpoch=dropShortIntervals(FreezeEpoch,thtps_immob*1e4);
if DoSave
    % Behav Vars
    Xtemp=Data(Xtsd); Ytemp=Data(Ytsd); T1=Range(Ytsd);
    for t=1:length(Zone)
        ZoneIndices{t}=find(diag(Zone{t}((floor(Data(Ytsd)./pixratio)),(floor(Data(Xtsd)./pixratio)))));
        Xtemp2=Xtemp*0;
        Xtemp2(ZoneIndices{t})=1;
        ZoneEpoch{t}=thresholdIntervals(tsd(T1,Xtemp2),0.5,'Direction','Above');
        Occup(t)=size(ZoneIndices{t},1)./size(Data(Xtsd),1);
        FreezeTime(t)=length(Data(Restrict(Xtsd,and(FreezeEpoch,ZoneEpoch{t}))))./length(Data((Restrict(Xtsd,ZoneEpoch{t}))));
    end
end
%GlobalFigure
subplot(211)
plot(Data(Xtsd),Data(Ytsd))

subplot(212)
plot(Range((ImDiffTsd)),Data(ImDiffTsd))
hold on
plot(Range(Restrict(ImDiffTsd,FreezeEpoch)),Data(Restrict(ImDiffTsd,FreezeEpoch)));
line(xlim,[1 1]*th_immob,'color','r')
ylim([0 0.1])
if DoSave
    %save
    cd ..
    cd ..
    try
        copyfile('behavResources.mat','behavResourcesNewTracking.mat')
        save('behavResourcesNewTracking.mat','PosMat','im_diff','FreezeTime','smoofact','Occup','ZoneIndices','ZoneEpoch','th_immob','Ytsd','Xtsd','ref','pixratio','mask',-append')
    catch,
        save('behavResourcesNewTracking.mat','PosMat','im_diff','FreezeTime','smoofact','Occup','ZoneIndices','ZoneEpoch','Ytsd','Xtsd','ref','pixratio','th_immob','mask')
    end
    clear im_diff PosMat Movtsd FreezeTime Occup ZoneIndices ZoneEpoch tps PosMatOriginal im_diffOriginal pixratio Zone
end

if DoSave
    saveas(1,[FolderName,'/BehavEPMOverall.fig'])
end
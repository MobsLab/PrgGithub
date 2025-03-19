clear all
cd /media/DataMOBS78/ProcessedData_EMbRerct_FLX/Mouse666/20171228/ProjectEmbReact_M666_20171228_TestPost/TestPost1
load('behavResources.mat')
se= strel('disk',strsz);
cd /media/DataMOBS78/ProcessedData_EMbRerct_FLX/Mouse666/20171228/ProjectEmbReact_M666_20171228_TestPost/TestPost1/raw/FEAR-Mouse-666-28122017-TestPost_02/F28122017-0000
load('frame000002.mat')
tps0 = datas.time;
IM = datas.image;
OldIm = IM;
OldZone = mask;
List=dir;
num_fr = 1;

for k=4:length(List)
    load(List(k).name)
    % find the mouse and calculate quantity of movement
    [Pos,ImDiff,PixelsUsed,NewIm,FzZone]=Track_ImDiff(datas.image,mask,ref,BW_threshold,smaller_object_size,sm_fact,se,SrdZone,...
        Ratio_IMAonREAL,OldIm,OldZone,'IR');
    
    if sum(isnan(Pos))==0
        PosMat(num_fr,1)=etime(datas.time,tps0);
        PosMat(num_fr,2)=Pos(1);
        PosMat(num_fr,3)=Pos(2);
        PosMat(num_fr,4)=0;
        im_diff(num_fr,1)=etime(datas.time,tps0);
        im_diff(num_fr,2)=ImDiff;
        im_diff(num_fr,3)=PixelsUsed;
        MouseTemp(num_fr,1)=etime(datas.time,tps0);
        MouseTemp(num_fr,2)=mean(mean(IM.*FzZone));
    else
        PosMat(num_fr,:)=[etime(datas.time,tps0);NaN;NaN;NaN];
        im_diff(num_fr,1:3)=[etime(datas.time,tps0);NaN;NaN];
    end
    
    num_fr=num_fr+1;
    
    OldIm=NewIm;
    OldZone=FzZone;
    
end

im_diff(:,1)=im_diff(:,1)+1;
PosMat(:,1)=PosMat(:,1)+1;

%% This is the strict minimum all codes need to save %%
[PosMat,PosMatInit,im_diff,im_diffInit,Vtsd,Xtsd,Ytsd,Imdifftsd]=CommonInterpPosMatImDiff(im_diff,etime(datas.time,tps0),PosMat);
ref=TrObj.ref;mask=TrObj.mask;Ratio_IMAonREAL=TrObj.Ratio_IMAonREAL;
frame_limits=TrObj.frame_limits;
save([ExpeInfo.name_folder,filesep,'TrObject.mat'],'TrObj');

save(['behavResources.mat'],'PosMat','PosMatInit','im_diff','im_diffInit','Vtsd','Xtsd','Ytsd','Imdifftsd',...
    'ref','mask','Ratio_IMAonREAL','BW_threshold','frame_limits','smaller_object_size','sm_fact','strsz','SrdZone','-append');
clear ref mask Ratio_IMAonREAL frame_limits


% Do some extra code-specific calculations
try FreezeEpoch=thresholdIntervals(Imdifftsd,th_immob,'Direction','Below');
    FreezeEpoch=mergeCloseIntervals(FreezeEpoch,0.3*1E4);
    FreezeEpoch=dropShortIntervals(FreezeEpoch,thtps_immob*1E4);
    Freeze=sum(End(FreezeEpoch)-Start(FreezeEpoch));
catch
    Freeze=NaN;
    Freeze2=NaN;
end

Xtemp=Data(Xtsd); Ytemp=Data(Ytsd); T1=Range(Ytsd);
if not(isempty('Zone'))
    for t=1:length(Zone)
        try
            ZoneIndices{t}=find(diag(Zone{t}(floor(Data(Xtsd)*TrObj.Ratio_IMAonREAL),floor(Data(Ytsd)*TrObj.Ratio_IMAonREAL))));
            Xtemp2=Xtemp*0;
            Xtemp2(ZoneIndices{t})=1;
            ZoneEpoch{t}=thresholdIntervals(tsd(T1,Xtemp2),0.5,'Direction','Above');
            Occup(t)=size(ZoneIndices{t},1)./size(Data(Xtsd),1);
            FreezeTime(t)=length(Data(Restrict(Xtsd,and(FreezeEpoch,ZoneEpoch{t}))))./length(Data((Restrict(Xtsd,ZoneEpoch{t}))));
        catch
            ZoneIndices{t}=[];
            ZoneEpoch{t}=intervalSet(0,0);
            Occup(t)=0;
            FreezeTime(t)=0;
        end
    end
else
    for t=1:2
        ZoneIndices{t}=[];
        ZoneEpoch{t}=intervalSet(0,0);
        Occup(t)=0;
        FreezeTime(t)=0;
    end
end
save(['behavResources.mat'],'FreezeEpoch','th_immob','thtps_immob',...
    'Zone','ZoneEpoch','ZoneIndices','FreezeTime','Occup',...
    'MouseTemp','-append');

% save and copy file in save_folder
msg_box=msgbox('Saving behavioral Information','save','modal');
% Shut the video if compression was being done on the fly
close(writerObj);

pause(0.5)
try set(PlotFreez,'YData',0,'XData',0);end

%% generate figure that gives overviewof the tracking session
figbilan=figure;
subplot(2,3,1:3)
plot(Range(Vtsd,'s'),Data(Vtsd)./prctile(Data(Vtsd),98),'k'), hold on
plot(Range(Imdifftsd,'s'),Data(Imdifftsd)./prctile(Data(Imdifftsd),98),'b')
for k=1:length(Start(FreezeEpoch))
    plot(Range(Restrict(Imdifftsd,subset(FreezeEpoch,k)),'s'),Data(Restrict(Imdifftsd,subset(FreezeEpoch,k)))*0+max(ylim)*0.8,'c','linewidth',2)
end
plot(PosMat(PosMat(:,4)==1,1),PosMat(PosMat(:,4)==1,1)*0+max(ylim)*0.9,'k*')
if exist('ZoneEpoch')
    for k=1:length(Start(ZoneEpoch{1}))
        plot(Range(Restrict(Imdifftsd,subset(ZoneEpoch{1},k)),'s'),Data(Restrict(Imdifftsd,subset(ZoneEpoch{1},k)))*0+max(ylim)*0.95,'r','linewidth',2)
    end
    for k=1:length(Start(ZoneEpoch{2}))
        plot(Range(Restrict(Imdifftsd,subset(ZoneEpoch{2},k)),'s'),Data(Restrict(Imdifftsd,subset(ZoneEpoch{2},k)))*0+max(ylim)*0.95,'g','linewidth',2)
    end
end
title('Raw Data')
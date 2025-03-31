clear all
% Get video
VideoName = 'F30052019-0000.avi';
a = VideoReader(VideoName);
global camtype;camtype = 'IR';


% Get frame number
num_fr = 2;
load('behavResources.mat')
maxtime = max(Range(MovAcctsd,'s'));
clear PosMat im_diff
se= strel('disk',strsz);
IM = a.readFrame;
IM = IM(:,:,1);
OldIm = double(IM)/256;
OldZone = mask;
PosMat(1,1:4)=[NaN;NaN;NaN;NaN];
im_diff(1,1:3)=[NaN;NaN;NaN];
MouseTemp(1,1:2)=[NaN;NaN];

while a.hasFrame
    IM = a.readFrame;
    IM = IM(:,:,1);
    IM = double(IM)/256;
    [Pos,ImDiff,PixelsUsed,NewIm,FzZone]=Track_ImDiff(IM,mask,ref,BW_threshold,smaller_object_size,sm_fact,se,SrdZone,...
        Ratio_IMAonREAL,OldIm,OldZone,camtype);
    if sum(isnan(Pos))==0
        PosMat(num_fr,1)=NaN;
        PosMat(num_fr,2)=Pos(1);
        PosMat(num_fr,3)=Pos(2);
        PosMat(num_fr,4)=0;
        im_diff(num_fr,1)=NaN;
        im_diff(num_fr,2)=ImDiff;
        im_diff(num_fr,3)=PixelsUsed;
%         MouseTemp(num_fr,1)=KeepTime.chrono;
        MouseTemp(num_fr,2)=max(max(IM.*double(FzZone)));
    else
        PosMat(num_fr,:)=[NaN;NaN;NaN;NaN];
        im_diff(num_fr,1:3)=[NaN;NaN;NaN];
        MouseTemp(num_fr,1:2)=[NaN;NaN];
    end
    num_fr=num_fr+1;
    OldIm=NewIm;
    OldZone=FzZone;
end

% if figurebilan exists get exact time points
if exist('FigBilan.fig')>0
    open('FigBilan.fig')
    h = gcf;
    axesObjs = get(h, 'Children');  %axes handles
    dataObjs = get(axesObjs(3), 'Children'); %handles to low-level graphics objects in axes
    time = dataObjs(end).XData;
else
    time = maxtime/length(PosMat):maxtime/length(PosMat):maxtime;;
end

PosMat(:,1) = [max(time)/length(PosMat):max(time)/length(PosMat):max(time)];
im_diff(:,1) = [max(time)/length(PosMat):max(time)/length(PosMat):max(time)];
MouseTemp(:,1) = [max(time)/length(PosMat):max(time)/length(PosMat):max(time)];
[PosMat,PosMatInit,im_diff,im_diffInit,Vtsd,Xtsd,Ytsd,Imdifftsd]=CommonInterpPosMatImDiff(im_diff,max(time),PosMat);


save('behavResources.mat','PosMat','PosMatInit','im_diff','im_diffInit','Vtsd','Xtsd','Ytsd','Imdifftsd','-append');
%%
th_immob=0.005;
thtps_immob=2;
%%
% Do some extra code-specific calculations
 FreezeEpoch=thresholdIntervals(Imdifftsd,th_immob,'Direction','Below');
    FreezeEpoch=mergeCloseIntervals(FreezeEpoch,0.3*1E4);
    FreezeEpoch=dropShortIntervals(FreezeEpoch,thtps_immob*1E4);
    Freeze=sum(End(FreezeEpoch)-Start(FreezeEpoch));

Xtemp=Data(Xtsd); Ytemp=Data(Ytsd); T1=Range(Ytsd);
if not(isempty('Zone'))
    for t=1:length(Zone)
        try
            ZoneIndices{t}=find(diag(Zone{t}(floor(Data(Xtsd)*Ratio_IMAonREAL),floor(Data(Ytsd)*Ratio_IMAonREAL))));
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

save('behavResources.mat','FreezeEpoch','th_immob','thtps_immob',...
    'Zone','ZoneEpoch','ZoneIndices','FreezeTime','Occup','-append');


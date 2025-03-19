load('behavResources.mat')
se= strel('disk',strsz);
load('frame000001.mat')
IM = datas.image;
OldIm = IM;
OldZone = mask;


% find the mouse and calculate quantity of movement
[Pos,ImDiff,PixelsUsed,NewIm,FzZone]=Track_ImDiff(IM,mask,ref,BW_threshold,smaller_object_size,sm_fact,se,SrdZone,...
    Ratio_IMAonREAL,OldIm,OldZone,'IR');

if sum(isnan(Pos))==0
    PosMat(num_fr,1)=etime(datas.time,tps0);
    PosMat(num_fr,2)=Pos(1);
    PosMat(num_fr,3)=Pos(2);
    PosMat(num_fr,4)=0;
    im_diff(num_fr,1)=etime(datas.time,tps0);
    im_diff(num_fr,2)=ImDiff;d
    im_diff(num_fr,3)=PixelsUsed;
    MouseTemp(num_fr,1)=etime(datas.time,tps0);
    MouseTemp(num_fr,2)=mean(mean(IM.*FzZone));
else
    PosMat(num_fr,:)=[KeepTime.chrono;NaN;NaN;NaN];
    im_diff(num_fr,1:3)=[KeepTime.chrono;NaN;NaN];
end

% Update displays at 5Hz - faster would just be a waste of
% time
% For compression the actual picture is updated faster so
% as to save it
frame.cdata = cat(3,IM,IM,IM);
frame.colormap = [];
try,writeVideo(writerObj,frame);
    GotFrame(num_fr) = 1;
catch,disp('missed frame video')
    GotFrame(num_fr) = 0;
    ,end
num_fr=num_fr+1;

if  mod(num_fr-2,UpdateImage)==0
    set(g,'Xdata',Pos(1).*TrObj.Ratio_IMAonREAL,'YData',Pos(2).*TrObj.Ratio_IMAonREAL)
    diffshow=double(NewIm);
    diffshow(FzZone==1)=0.4;
    diffshow(OldZone==1)=0.4;
    diffshow(NewIm==1)=0.8;
    set(htrack2,'Cdata',diffshow);
    set(htrack,'Cdata',IM);
    try
        dattemp=im_diff;
        dattemp(isnan(im_diff(:,2)),2)=0;
        set(PlotFreez,'YData',im_diff(max(1,num_fr-maxfrvis):end,2),'XData',[1:length(dattemp(max(1,num_fr-maxfrvis):end,2))]')
    end
    figure(Fig_UMaze), subplot(5,5,22:25)
    set(gca,'Ylim',[0 max(ymax,1e-5)]);
end
OldIm=NewIm;
OldZone=FzZone;

% --------------------- SAVE FRAMES every NumFramesToSave  -----------------------
if TrObj.SaveToMatFile==1
    datas.image =IM;
    datas.time = KeepTime.t1;
    prefac1=char; for ii=1:6-length(num2str(n)), prefac1=cat(2,prefac1,'0');end
    save([ ExpeInfo.name_folder filesep ExpeInfo.Fname filesep 'frame' prefac1 sprintf('%0.5g',n)],'datas','-v6');
    n = n+1;
    clear datas
end

if  mod(num_fr,1000)==0
    fwrite(a,arduinoDictionary.ThousandFrames);
end

%% Specific to UMaze protocol
if strcmp('Cond',ExpeInfo.namePhase) &  sum(isnan(Pos))==0
    where= Zone{1}(max(floor(Pos(2).*TrObj.Ratio_IMAonREAL),1),max(floor(Pos(1).*TrObj.Ratio_IMAonREAL),1));
    if where==1
        set(chronostim,'string',num2str(floor(etime(clock,KeepTime.LastStim))));
        if etime(clock,KeepTime.LastStim)>1.5*delStim
            KeepTime.LastStim=clock;
            KeepTime.LastStim(end)=KeepTime.LastStim(end)-(delStim-delStimreturn); % was 5
        end
        if etime(clock,KeepTime.LastStim)>delStim +2*rand
            KeepTime.LastStim=clock;
            fwrite(a,arduinoDictionary.SendStim);
            PosMat(end,4)=1;
            disp('stim')
        end
    end
end


if (strcmp('BlockedWallShock',ExpeInfo.namePhase))
    if etime(clock,KeepTime.tDeb)>SinglShockTime(ShTN)
        fwrite(a,arduinoDictionary.SendStim);
        PosMat(end,4)=1;
        SinglShockTime(ShTN)
        disp('shock')
        ShTN=ShTN+1;
        set(chronostim,'string',num2str(SinglShockTime(ShTN)));
    end
end

if (strcmp('CondWallSafe',ExpeInfo.namePhase))
    if etime(clock,KeepTime.tDeb)>280
        set(inputDisplay(11),'string','Remove door at 300','ForegroundColor','r','FontSize',15);
    end
    if etime(clock,KeepTime.tDeb)>300  &   sum(isnan(Pos))==0
        where= Zone{1}(max(floor(Pos(2).*TrObj.Ratio_IMAonREAL),1),max(floor(Pos(1).*TrObj.Ratio_IMAonREAL),1));
        if where==1
            set(chronostim,'string',num2str(floor(etime(clock,KeepTime.LastStim))));
            if etime(clock,KeepTime.LastStim)>1.5*delStim %was 2
                KeepTime.LastStim=clock;
                KeepTime.LastStim(end)=KeepTime.LastStim(end)-(delStim-delStimreturn); % was 5
            end
            if etime(clock,KeepTime.LastStim)>delStim +2*rand
                KeepTime.LastStim=clock;
                fwrite(a,arduinoDictionary.SendStim);
                PosMat(end,4)=1;
                disp('stim')
            end
        end
    end
end

if (strcmp('CondWallShock',ExpeInfo.namePhase))
    if etime(clock,KeepTime.tDeb)>280
        set(inputDisplay(11),'string','Remove door at 300','ForegroundColor','r','FontSize',15);
    end
    if etime(clock,KeepTime.tDeb)>CondWallShockTime(ShTN)
        fwrite(a,arduinoDictionary.SendStim);
        PosMat(end,4)=1;
        CondWallShockTime(ShTN)
        disp('shock')
        ShTN=ShTN+1;
        set(chronostim,'string',num2str(CondWallShockTime(ShTN)));
    end
    
    if etime(clock,KeepTime.tDeb)>300  &  sum(isnan(Pos))==0
        set(inputDisplay(10),'string','TimeInZone');
        where= Zone{1}(max(floor(Pos(2).*TrObj.Ratio_IMAonREAL),1),max(floor(Pos(1).*TrObj.Ratio_IMAonREAL),1));
        if where==1
            set(chronostim,'string',num2str(floor(etime(clock,KeepTime.LastStim))));
            if etime(clock,KeepTime.LastStim)>1.5*delStim %was 2
                KeepTime.LastStim=clock;
                KeepTime.LastStim(end)=KeepTime.LastStim(end)-(delStim-delStimreturn); % was 5
            end
            if etime(clock,KeepTime.LastStim)>delStim +2*rand
                KeepTime.LastStim=clock;
                fwrite(a,arduinoDictionary.SendStim);
                PosMat(end,4)=1;
                disp('stim')
            end
        end
    end
end


%% Sound Protocols
if strcmp('SoundCnd',ExpeInfo.namePhase)
    if etime(clock,KeepTime.tDeb)>SoundTimesCond(ShTN)
        if rem(ShTN,2)==0
            fwrite(a,arduinoDictionary.Sound);
            PosMat(end,4)=2;
            disp('CS-')
            set(chronostim,'ForegroundColor','r');
            set(inputDisplay(11),'string','Change Sound to CS+','ForegroundColor','r');
        else
            fwrite(a,arduinoDictionary.SoundStim);
            PosMat(end,4)=1;
            disp('CS+ shock')
            set(chronostim,'ForegroundColor','g');
            set(inputDisplay(11),'string','Change Sound to CS-','ForegroundColor','g');
        end
        ShTN=ShTN+1;
        set(chronostim,'string',num2str(SoundTimesCond(ShTN)));
    end
end

if (strcmp('SoundHab',ExpeInfo.namePhase)|strcmp('SoundTest',ExpeInfo.namePhase))
    if etime(clock,KeepTime.tDeb)>SoundTimesHabTest(ShTN)
        fwrite(a,arduinoDictionary.Sound);
        PosMat(end,4)=2;
        disp('CS-/CS+')
        if ShTN<=4
            disp('CS-')
        else
            disp('CS+')
        end
        if ShTN==4
            set(chronostim,'ForegroundColor','r');
            set(inputDisplay(11),'string','Change Sound to CS+','ForegroundColor','r');
        end
        ShTN=ShTN+1;
        set(chronostim,'string',num2str(SoundTimesHabTest(ShTN)));
    end
end

%% Calibration Protocols
if (strcmp('Calibration',ExpeInfo.namePhase))
    if etime(clock,KeepTime.tDeb)>CalibTimes(ShTN)
        fwrite(a,arduinoDictionary.SendStim);
        PosMat(end,4)=1;
        CalibTimes(ShTN)
        disp('shock')
        ShTN=ShTN+1;
        set(chronostim,'string',num2str(CalibTimes(ShTN)));
    end
end

if (strcmp('CalibrationEyeshock',ExpeInfo.namePhase))
    if etime(clock,KeepTime.tDeb)>CalibTimesEyeshock(ShTN)
        fwrite(a,arduinoDictionary.SendStim);
        PosMat(end,4)=1;
        CalibTimesEyeshock(ShTN)
        disp('shock')
        ShTN=ShTN+1;
        set(chronostim,'string',num2str(CalibTimesEyeshock(ShTN)));
    end
end

end

KeepTime.t2 = clock;
if StartChrono && etime(KeepTime.t2,KeepTime.tDeb)> ExpeInfo.lengthPhase+0.5
    enableTrack=0;
end
end


ShTN=1;% reset for next phase
fwrite(a,arduinoDictionary.Off); % switch off intan

% Correct for intan trigger time to realign with ephys
im_diff(:,1)=im_diff(:,1)+1;
PosMat(:,1)=PosMat(:,1)+1;

%% This is the strict minimum all codes need to save %%
[PosMat,PosMatInit,im_diff,im_diffInit,Vtsd,Xtsd,Ytsd,Imdifftsd]=CommonInterpPosMatImDiff(im_diff,KeepTime.chrono,PosMat);
ref=TrObj.ref;mask=TrObj.mask;Ratio_IMAonREAL=TrObj.Ratio_IMAonREAL;
frame_limits=TrObj.frame_limits;
save([ExpeInfo.name_folder,filesep,'TrObject.mat'],'TrObj');

save([ExpeInfo.name_folder,filesep,'behavResources.mat'],'PosMat','GotFrame','PosMatInit','im_diff','im_diffInit','Vtsd','Xtsd','Ytsd','Imdifftsd',...
    'ref','mask','Ratio_IMAonREAL','BW_threshold','frame_limits','smaller_object_size','sm_fact','strsz','SrdZone');
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
save([ExpeInfo.name_folder,filesep,'behavResources.mat'],'FreezeEpoch','th_immob','thtps_immob',...
    'Zone','ZoneEpoch','ZoneIndices','FreezeTime','Occup','DoorChangeMat',...
    'delStim','delStimreturn','MouseTemp','-append');

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
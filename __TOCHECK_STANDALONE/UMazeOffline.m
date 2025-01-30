clear all
load('behavResources.mat')
FileName='F06072017-0001/';

disp('   Begining tracking...')

im_diff=0;
try 
    frame_rate
catch
    frame_rate=NaN;
end

% -----------------------------------------------------------------
% ---------------------- INITIATE TRACKING ------------------------
n=1;
num_fr=1; num_fr_f=1;
PosMat=[];
clear Movtsd Imdifftsd PosMat im_diff
cd(FileName)
a=dir;
begin=0;
for k=1:length([a.isdir])
    if not(isempty(findstr(a(k).name,'frame')))
        load(a(k).name)
        if begin==0
            t1=datas.time;
            begin=1;
        end
        IM=datas.image;
        chrono=etime(datas.time,t1);
        
        % ---------------------------------------------------------
        % --------------------- TREAT IMAGE -----------------------
        % Substract reference image
        subimage = (imageRef-IM);
        subimage = uint8(double(subimage).*double(mask));
        % Convert the resulting grayscale image into a binary image.
        diff_im = im2bw(subimage,BW_threshold2);
        % Remove all the objects less large than smaller_object_size
        diff_im = bwareaopen(diff_im,smaller_object_size2);
        % Label all the connected components in the image.
        bw = logical(diff_im); %CHANGED
        if n==2
            image_temp=bw;
        end
        % ---------------------------------------------------------
        % --------------------- FREEZING -----------------------
        
        % Used to only used on in three images for im_diff, modified
        % 19/07/2017 to make compatible with online tracking
        if  n>3
            immob_IM = bw - image_temp;
            diffshow=ones(size(immob_IM,1),size(immob_IM,2));
            diffshow(bw==1)=0;
            diffshow(immob_IM==1)=0.4;
            diffshow(immob_IM==-1)=0.7;
            im_diff(num_fr,1)=chrono;
            im_diff(num_fr,2)=(sum(sum(((immob_IM).*(immob_IM)))))/Ratio_IMAonREAL.^2;
            image_temp=bw;
        end
        
        
        % ---------------------------------------------------------
        % --------------------- FIND MOUSE ------------------------
        % We get a set of properties for each labeled region.
        stats = regionprops( bw, 'Centroid','MajorAxisLength','MinorAxisLength');
        centroids = cat(1, stats.Centroid);
        maj = cat(1, stats.MajorAxisLength);
        mini = cat(1, stats.MinorAxisLength);
        rap=maj./mini;
        centroids=centroids(rap<shape_ratio2,:); %CHANGED
        
        
        % mouse position and save in posmat
        
        if size(centroids) == [1 2]
            PosMat(num_fr,1)=chrono;
            PosMat(num_fr,2)=centroids(1)/Ratio_IMAonREAL;
            PosMat(num_fr,3)=centroids(2)/Ratio_IMAonREAL;
            PosMat(num_fr,4)=0;
            
        else
            PosMat(num_fr,:)=[chrono;NaN;NaN;NaN];
        end
        
        num_fr=num_fr+1;
        
        n = n+1;
        
        
    end
end
cd ..
im_diff(:,1)=im_diff(:,1)+1;
PosMat(:,1)=PosMat(:,1)+1;
save('behavResources.mat','PosMat','im_diff','frame_rate','th_immob','imageRef',...
    'shape_ratio2','BW_threshold2','mask','smaller_object_size2','Ratio_IMAonREAL');

% calculate freezing
im_diff=im_diff(1:find(im_diff(:,1)>chrono-1,1,'last'),:);
PosMatInt=PosMat;
x=PosMatInt(:,2);
nanx = isnan(x);
t    = 1:numel(x);
x(nanx) = interp1(t(~nanx), x(~nanx), t(nanx));
PosMatInt(:,2)=x;
x=PosMatInt(:,3);
nanx = isnan(x);
t    = 1:numel(x);
x(nanx) = interp1(t(~nanx), x(~nanx), t(nanx));
PosMatInt(:,3)=x;
im_diffint=im_diff;
x=im_diffint(:,2);
nanx = isnan(x);
t    = 1:numel(x);
x(nanx) = interp1(t(~nanx), x(~nanx), t(nanx));
im_diffint(:,2)=x;
PosMat=PosMatInt;
im_diff=im_diffint;

Movtsd=tsd(PosMatInt(1:end-1,1)*1e4,sqrt(diff(PosMatInt(:,2)).^2+diff(PosMatInt(:,1)).^2));
Xtsd=tsd(PosMatInt(:,1)*1e4,(PosMatInt(:,3)));
Ytsd=tsd(PosMatInt(:,1)*1e4,(PosMatInt(:,2)));
Imdifftsd=tsd(im_diffint(:,1)*1e4,SmoothDec(im_diffint(:,2)',1));

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

% save and copy file in save_folder
msg_box=msgbox('Saving behavioral Information','save','modal');

save('behavResourcesnew.mat','PosMat','im_diff','frame_rate','FreezeEpoch','Movtsd','th_immob','imageRef',...
    'shape_ratio2','BW_threshold2','mask','smaller_object_size2','Zone','ZoneEpoch','ZoneIndices','Ratio_IMAonREAL','FreezeTime','Occup','TurnMat');
pause(0.5)

%% generate figure
figbilan=figure;

% raw data : movement over time
subplot(2,3,1:3)
plot(Range(Movtsd,'s'),Data(Movtsd)./prctile(Data(Movtsd),98),'k'), hold on
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

subplot(2,2,3)
bar(Occup(1:2))
hold on
try,set(gca,'Xtick',[1,2],'XtickLabel',{ZoneLabels{1:2}}),end
colormap copper
ylabel('% time spent')
xlim([0.5 2.5])
box off

subplot(2,2,4)
bar(FreezeTime(1:2))
hold on
try,set(gca,'Xtick',[1,2],'XtickLabel',{ZoneLabels{1:2}}),end
colormap copper
ylabel('% time spent freezing')
xlim([0.5 2.5])
box off

saveas(figbilan,['FigBilanbnew.fig'])
saveas(figbilan,['FigBilannew.png'])
close(figbilan)
%%

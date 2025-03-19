% clear all
% load('behavResources.mat');
% 
% mask_conv = im2double(mask);
% y1 = find(mean(mask_conv));
% x1 = find(mean(mask_conv'));
% %%
% VideoName = dir('*.avi');
% a=VideoReader(VideoName.name);
% i=0;


%%


% while a.hasFrame
%     figure(1)
%     i=i+1;
%     
%     IM=a.readFrame;
%     IM=IM(:,:,1);
%     IM=double(IM)/256;
%     imagesc(IM(x1,y1,:))
   
%     VideoFrameCelcius=IR2DEG(cd,IM(x1,y1,:));
%     if ~exist('BW_threshold'); BW_threshold=0.5; end
%     % binarize the image using a threshold
%     diff_im = im2bw(IM(x1,y1,:),BW_threshold);
%     % drop parts of the binary image that are too small
%     diff_im = bwareaopen(diff_im,smaller_object_size);
%     diff_im_inv=diff_im==0;
%     
%     TemperatureCurve(5,i)=mean(VideoFrameCelcius(diff_im_inv));
%     TemperatureCurve(6,i)=mean(VideoFrameCelcius(diff_im));
    
%         pause
% end

% disp('all done :)')

%%
%%%%

clear all
cd /media/nas6/ProjetPFCVLPO/M1148/20210224/Sleep_CNOInjection/DREADD_1148_CNO_210224_090824
load('behavResources.mat');

mask_conv = im2double(mask);
y1 = find(mean(mask_conv));
x1 = find(mean(mask_conv'));
% x1=x1(34:end);

cd /media/nas6/ProjetPFCVLPO/M1148/20210224/Sleep_CNOInjection/DREADD_1148_CNO_210224_090824/SLEEP-Mouse-1148&1149&0&1-24022021_00
Video_Name = 'F04082021-0000.avi';
a=VideoReader(Video_Name);

cd /media/nas6/ProjetPFCVLPO/M1148/20210224/Sleep_CNOInjection/DREADD_1148_CNO_210224_090824
if ~exist('BW_threshold'); BW_threshold=0.5; end

%%
for i = 1: a.NumberOfFrames/2
% for i = 122817: a.NumberOfFrames

    %     figure(1)
    disp('read frame')
    disp(num2str(i/a.NumberOfFrames/2))
%     disp(num2str(i/a.NumberOfFrames))

    IM = read(a,i);
    
    disp('get degrees')
    VideoFrameCelcius=IR2DEG(cd,IM(x1,y1,:));
    
    % binarize the image using a threshold
    diff_im = im2bw(IM(x1,y1,:),BW_threshold);
    % drop parts of the binary image that are too small
    diff_im = bwareaopen(diff_im,smaller_object_size);
    diff_im_inv=diff_im==0;
    
    disp('mean temp ')
    TemperatureCurve(5,i)=mean(VideoFrameCelcius(diff_im_inv));
    TemperatureCurve(6,i)=mean(VideoFrameCelcius(diff_im));
    clear IM VideoFrameCelcius diff_im
end

%% BM code to correct temperature
% if you want to modify a Temperature file
save('Temperature.mat','TemperatureCurve')
% in other cases : save('Temperature.mat','TemperatureCurve')

%Way to correct abberant values in TemperatureCurve
TemperatureCurve_corrected=TemperatureCurve;
for j=1:length(TemperatureCurve_corrected(:,1))
    for i=2:length(TemperatureCurve_corrected(j,:))-1
        if (TemperatureCurve_corrected(j,i)>TemperatureCurve_corrected(j,i-1)+2)&(TemperatureCurve_corrected(j,i)>TemperatureCurve_corrected(j,i+1)+2)
            TemperatureCurve_corrected(j,i)=NaN;
        elseif (TemperatureCurve_corrected(j,i)<TemperatureCurve_corrected(j,i-1)-2)&(TemperatureCurve_corrected(j,i)<TemperatureCurve_corrected(j,i+1)-2)
            TemperatureCurve_corrected(j,i)=NaN;
        end
    end
    NaN_numb(j)=sum(isnan(TemperatureCurve_corrected(j,:)));
    TemperatureCurve_corrected(j,:)= naninterp(TemperatureCurve_corrected(j,:));
end

save('Temperature.mat','TemperatureCurve_corrected','-append');


%Creating Temperature tsd
names = {'TailTemperatureTSD','NoseTemperatureTSD','NeckTemperatureTSD','BodyTemperatureTSD','RoomTemperatureTSD','MouseTemperatureTSD'};
load('behavResources.mat')
names_MF = {'Tail','Nose','Neck','Body','Room','Mouse'};

%if length(TemperatureCurve)==length(Data(Behav.Xtsd))
if length(TemperatureCurve)==length(Data(Xtsd))
    disp('all good, baby baby')
    VideoTimes=Range(Xtsd);
    for ind = 1:length(names)
        Temp.(names{ind})=tsd(VideoTimes,TemperatureCurve_corrected(ind,:)');%create tsd for temperature
    end
else
    if logical(exist('GotFrame'))
        disp('Got Frame'); clear RangeX;
        RangeX(:,1)=Range(Xtsd);
        lost_values=length(RangeX)-length(TemperatureCurve);
        VideoTimes=RangeX(GotFrame==1,1);
        for ind = 1:length(names_MF)
            Video.(names_MF{ind}).time=VideoTimes;
            Video.(names_MF{ind}).values=TemperatureCurve_corrected(ind,:)';
            Video.(names_MF{ind}).time(end+1:end+lost_values)=RangeX(GotFrame==0,1); %avec vidéos coupées, pbl de taille entre xtsd et got frame qui est sur la vidéo coupée
            Video.(names_MF{ind}).values(end+1:end+lost_values)=NaN;
            [Video.(names_MF{ind}).sorted_times,Video.(names_MF{ind}).sorted_values]=sort(Video.(names_MF{ind}).time);
            Video.(names_MF{ind}).sorted_values=Video.(names_MF{ind}).values(Video.(names_MF{ind}).sorted_values);
        end
        for ind = 1:length(names)
            Temp.(names{ind})=tsd(Video.(names_MF{ind}).sorted_times,Video.(names_MF{ind}).sorted_values);%create tsd for temperature
        end
    else
        disp('Missed Frames')
        Missed_frames; close all %remove
        for ind = 1:length(names)
            Temp.(names{ind})=tsd(Video.(names_MF{ind}).sorted_times,Video.(names_MF{ind}).sorted_values);%create tsd for temperature
        end
    end
    save('Temperature.mat','Video','-append')
end

if exist('MovAcctsd')
    names2 = {'TailTemperatureintTSD','NoseTemperatureintTSD','NeckTemperatureintTSD','BodyTemperatureintTSD','RoomTemperatureintTSD','MouseTemperatureintTSD'};
    for ind = 1:length(names2)
        Temp.(names2{ind}) = Data(Temp.(names{ind}));%create a new tsd adapted for analysis with Acc
        Temp.(names2{ind}) = interp1(Range(Temp.(names{ind})),Data(Temp.(names{ind})),Range(MovAcctsd));
        Temp.(names2{ind}) = tsd(Range(MovAcctsd),Temp.(names2{ind}));
    end
end

save('Temperature.mat','Temp','-append');

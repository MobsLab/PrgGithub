%[filename,pathname]=uigetfile('*.csv','Select the DeepLabCut tracking file')
file=dir('*.csv'); filename=file.name;
pathname=pwd;
DLC=csvread(fullfile(pathname,filename),3); %loads the csv from line 3 to the end (to skip the Header)

% Extract the body parts coordinates
Nose_X = abs(DLC(:,2));
Nose_Y = abs(DLC(:,3));
REar_X = DLC(:,5);
REar_Y = DLC(:,6);
LEar_X = DLC(:,8);
LEar_Y = DLC(:,9);
Neck_X = abs(DLC(:,11));
Neck_Y = abs(DLC(:,12));
Body_X = abs(DLC(:,14));
Body_Y = abs(DLC(:,15));
TailBase_X = DLC(:,17);
TailBase_Y = DLC(:,18);
TailCenter_X = DLC(:,20);
TailCenter_Y = DLC(:,21);
TailCenter_Certitude=DLC(:,22);
Nose_Y(Nose_Y>240)=240;

%[filename pathname]= uigetfile({'*.avi'},'Select The AVI video file');
file=dir('*.avi'); filename=file.name;
pathname=pwd;
pathAVI=fullfile(pathname,filename);

movie=importdata(pathAVI);
xbase=ceil(TailBase_X);
ybase=ceil(TailBase_Y);
xcenter=ceil(TailCenter_X);
ycenter=ceil(TailCenter_Y);


Ymin=1;Ymax=size(movie(1).cdata(:,:,1),1);
Xmin=1;Xmax=size(movie(1).cdata(:,:,1),2);
Radius=10; %In pixels
TemperatureCurve=zeros(1,size(movie,2));
names = {'Nose','Neck','Body'};
dx_error=0;

load('behavResources.mat')

for frame=1:size(movie,2)
    frame
    dx=xcenter(frame)-xbase(frame);dy=ycenter(frame)-ybase(frame);
    if dx==0&dy==0
        TemperatureCurve(1,frame)=NaN;
        dx_error=dx_error+1;
    else
        alpha=xbase(frame)+dx/2;
        beta=ybase(frame)+dy/2;
        delta=-1*(dx/dy); %The slope of the line perpendicular to the "Base-center" line is equal to -1* the inverse of the slope of the line between the two tail points.
        K=beta-delta*alpha;
        if abs(delta)==inf
            %Vertical line
            YWithinLine=Ymin:Ymax;
            XWithinLine=(0*YWithinLine+alpha);%same size as Y but replaced by alpha
        elseif abs(delta)>0.5
            Yinterval=1:size(movie(frame).cdata(:,:,1),1);
            Xinterval=round((Yinterval-K)/delta);
            WithinImage=logical(Xinterval>=Xmin.*Xinterval<=Xmax);
            YWithinLine=Yinterval(WithinImage);
            XWithinLine=Xinterval(WithinImage);
        else
            Xinterval=1:size(movie(frame).cdata(:,:,1),2);
            Yinterval=round(Xinterval*delta+K);
            WithinImage=logical(Yinterval>=Ymin.*Yinterval<=Ymax);
            YWithinLine=Yinterval(WithinImage);
            XWithinLine=Xinterval(WithinImage);
        end
        WithinRadius=(((YWithinLine-beta).*(YWithinLine-beta))+((XWithinLine-alpha).*(XWithinLine-alpha)))<Radius*Radius;%Pixel distance of all these pixels from the point halfway between TailBase and TailCenter
        XWithinAll=XWithinLine(WithinRadius);
        YWithinAll=YWithinLine(WithinRadius);
        
        % Vector with negative values for index
        if sum((XWithinAll>320)|(XWithinAll<1)|(YWithinAll>240)|(YWithinAll<1))>0
            if sum(XWithinAll>320)>0
                XWithinAll=XWithinAll-(XWithinAll320);
            elseif sum(XWithinAll<1)>0
                XWithinAll=XWithinAll+((XWithinAll<1).*(-XWithinAll+1));
            elseif sum(YWithinAll>240)>0
                Y_correction=YWithinAll-240;
                Y_correction=(Y_correction).*(YWithinAll>240);
                YWithinAll=YWithinAll-Y_correction;
            elseif sum(YWithinAll<1)>0
                YWithinAll=YWithinAll+((YWithinAll<1).*(-YWithinAll+1));
            end
        end
        
        VideoFrame=movie(frame).cdata(:,:,1);
        VideoFrameCelcius=IR2DEG(cd,VideoFrame);
        LinearIndices=sub2ind(size(VideoFrameCelcius),YWithinAll,round(XWithinAll));
        LinearTemperature=VideoFrameCelcius(LinearIndices);
        TempGradient=diff(VideoFrameCelcius(LinearIndices));
        TempExtremum=find(TempGradient==max(TempGradient));
        if TempExtremum+3>size(LinearIndices,2)
            TailTemp=max(LinearTemperature(TempExtremum:size(LinearIndices,2)));
        else
            TailTemp=max(LinearTemperature(TempExtremum:TempExtremum+3));
        end
        TemperatureCurve(1,frame)=TailTemp;
      end
    
    %Others body parts tracking, filling Temperature Curve. 2nd line for
    %the Nose, 3rd for the Neck, 4th for the Body
    for ind = 1:length(names) % number of body part tracked
        Indices.(names{ind})=sub2ind(size(VideoFrameCelcius),[ceil(eval([names{ind} sprintf('_Y(%d)',frame)]))],[ceil(eval([names{ind} sprintf('_X(%d)',frame)]))]);
        Temperature.(names{ind})=VideoFrameCelcius(Indices.(names{ind}));
        TemperatureCurve(ind+1,frame)=Temperature.(names{ind});
    end
    
    % binarize the image using a threshold
    diff_im = im2bw(VideoFrame,BW_threshold);
    % drop parts of the binary image that are too small
    diff_im = bwareaopen(diff_im,smaller_object_size);
    diff_im_inv=diff_im==0;
    
    TemperatureCurve(5,frame)=mean(VideoFrameCelcius(diff_im_inv));
    TemperatureCurve(6,frame)=mean(VideoFrameCelcius(diff_im));
    
end
    
% if you want to modify a Temperature file
save('Temperature.mat','TemperatureCurve','-append')
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

certitude_loss= sum(TailCenter_Certitude<0.9)/length(TailCenter_Certitude<0.9)
TemperatureCurve_corrected(1,TailCenter_Certitude<0.9)=NaN;

save('Temperature.mat','TemperatureCurve_corrected','-append');

% Save an array named TempResults.Values in TailTemperatureCurve with 
%- first line : average temperature for each zone
%- second line : average temperature during freezing for each UMaze Zone
%- third line : average temperature during the session, average temperature during the session
%- fourth line : classified data for plot

%Creating Temperature tsd
names = {'TailTemperatureTSD','NoseTemperatureTSD','NeckTemperatureTSD','BodyTemperatureTSD','RoomTemperatureTSD','MouseTemperatureTSD'};
load('behavResources_SB.mat')
names_MF = {'Tail','Nose','Neck','Body','Room','Mouse'};

if length(TemperatureCurve)==length(Data(Behav.Xtsd))
    disp('all good, baby baby')
    VideoTimes=Range(Behav.Xtsd);
    for ind = 1:length(names)
        Temp.(names{ind})=tsd(VideoTimes,TemperatureCurve_corrected(ind,:)');%create tsd for temperature
    end
else
    if logical(exist('GotFrame'))
        disp('Got Frame'); clear RangeX;
        RangeX(:,1)=Range(Behav.Xtsd); 
        lost_values=length(RangeX)-length(TemperatureCurve);
        VideoTimes=RangeX(GotFrame==1,1);
        for ind = 1:length(names_MF)
            Video.(names_MF{ind}).time=VideoTimes;
            Video.(names_MF{ind}).values=TemperatureCurve_corrected(ind,:)';
            Video.(names_MF{ind}).time(end+1:end+lost_values)=RangeX(GotFrame==0,1);
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

names2 = {'TailTemperatureintTSD','NoseTemperatureintTSD','NeckTemperatureintTSD','BodyTemperatureintTSD','RoomTemperatureintTSD','MouseTemperatureintTSD'};
for ind = 1:length(names2)
    Temp.(names2{ind}) = Data(Temp.(names{ind}));%create a new tsd adapted for analysis with Acc
    Temp.(names2{ind}) = interp1(Range(Temp.(names{ind})),Data(Temp.(names{ind})),Range(Behav.MovAcctsd));
    Temp.(names2{ind}) = tsd(Range(Behav.MovAcctsd),Temp.(names2{ind}));
end

save('Temperature.mat','Temp','-append');

TotalEpoch = intervalSet(0,max(Range(Behav.MovAcctsd)));
Non_FreezinggAccEpoch=TotalEpoch-Behav.FreezeAccEpoch;
% Mean Temperature during freezing of each zone  
names3 = {'TailValues','NoseValues','NeckValues','BodyValues'};
for ind = 1:length(names3)
for Zones=1:5%7
    TempResults.(names3{ind})(1,Zones)=nanmean(Data(Restrict(Temp.(names{ind}),and(Behav.ZoneEpoch{Zones},Non_FreezinggAccEpoch))));
    TempResults.(names3{ind})(2,Zones)=nanmean(Data(Restrict(Temp.(names{ind}),and(Behav.ZoneEpoch{Zones},Behav.FreezeAccEpoch))));
    end
end 

save('Temperature.mat','TempResults','-append');

%Add FreezeAcc array to behavRessources_SB, 1st line : %time spent freezing
%in a zone
for Zones=1:5
    FreezeAccTime(Zones)=length(Data(Restrict(Behav.Xtsd,and(Behav.FreezeAccEpoch,Behav.ZoneEpoch{Zones}))))./length(Data((Restrict(Behav.Xtsd,Behav.ZoneEpoch{Zones}))));
end
Results.FreezeAccTime=FreezeAccTime;
save('behavResources_SB.mat','Results','-append');


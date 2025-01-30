function OfflineTrackingFinal_CompNewTracking

close hidden
clear hidden
close all
clear all

OLDIM=[];OBJ=[]; IM=[];
type=0; n=1; doin=0;

PosMat=[]; im_diff=[];
PosMatInit=[]; im_diffInit=[]; Vtsd=[]; ,Xtsd=[]; ,Ytsd=[]; ,Imdifftsd=[];

% Tracking parameters
ref=[];mask=[];Ratio_IMAonREAL=1;
BW_threshold=0;
strsz=2; maxsrtsz=20; se=[];
smaller_object_size=0;
shape_ratio=0; % extra parameter compared to online tracking,
sm_fact = 0; MaxSmoothFact=20;
SrdZone=20; maxsrndsz=80;
camera_type = [];

intvar=[]; % temporary variable to load from .mat
datas=[]; % variable name for frames
fr=1; % frame number
chrono=0; % start the clock
durmax=[]; % sessin duration
t1=[]; % start time
fcy=0.05; % frequency of frame change - can be modified by slider
totframe=[]; % number of frames
nx=1;ny=1;l1=0;l2=0; sizeOccMap=5;
occupation = zeros(ny,nx); %carte d'occupation
RGBoccupation=zeros(size(occupation,1),size(occupation,2),3); %initalize occupation map
OldIm = []; OldZone = [];
ImageDisplayBottom=[]; ImageDisplayTop=[];PositionPlot=[]; % name the subplots to be refreshed

nannum=0; totnum=0; % number of nans and number of frames
nx=1;ny=1;l1=0;l2=0; % coordinates and size of image
nameFile=''; PathName=''; NameLis=[];index=[]; private=1; % name the file

% Some colors
inter_col=copper(5);
button_col=inter_col(3,:);

% initialize the sliders
slider_speed=[];slider_seuil=[];slider_rapport=[];slider_small=[];slider_time=[];slider_strel=[];slider_smooth=[];slider_srdzone=[];
typical_rapport=8; typical_size=0; accel=3;
hand=[]; showfig=1;bnw_watchin=[];ratiofig=[];text=[];

% count the different files to be processed
batchnum=1; batchlist=cell(4,1);
nameFileB=[]; PathNameB=[];
ref1=[]; ref2=[];subimage=[];

%% graphical interface n�1 with all the pushbuttons

hand(1)=figure('units','normalized',...
    'position',[0.05 0.1 0.9 0.8],...
    'numbertitle','off',...
    'name','Menu',...
    'menubar','none',...
    'tag','fenetre depart');

hand(2)=uicontrol(hand(1),'style','pushbutton',...
    'units','normalized',...
    'position',[0.01 0.85 0.8/9 0.05],...
    'string','Tracking',...
    'tag','track',...
    'callback', @track);

hand(3)=uicontrol(hand(1),'style','pushbutton',...
    'units','normalized',...
    'position',[0.01 0.75 0.8/9 0.05],...
    'string','Launch Batch',...
    'tag','launchbatch',...
    'callback', @LaunchBatch);

hand(4)=uicontrol(hand(1),'style','pushbutton',...
    'units','normalized',...
    'position',[0.01 0.65 0.8/9 0.05],...
    'string','Create Ref',...
    'tag','reference',...
    'callback', @create_ref);

%% Track from Matlab generated frames

    function track(~,~)
        for y=2:4
            set(hand(y),'enable','off');
        end
        type=inputdlg('Track from matlab files (1) or from Video (2)?','Type of tracking')
        type=eval(type{1});
        
        camera_type=questdlg('What kind of video input are you using?',['Camera  choice'],'IRCamera','Webcam','IRCamera');
        
        start=1;
        doin=0;
        accel=3; % from 0 to  20
        
        if type==1
            GetFileInfo
        else
            GetVidInfo
        end
figure(hand(1));
        watchin=subplot(2,2,1);
        ImageDisplayTop = imagesc(double(IM));
        axis image
        hold on
        PositionPlot=plot(0,0,'m+');
        bnw_watchin=subplot(2,2,3);
        ImageDisplayBottom = imagesc((ones(size(ref,1),size(ref,2))));
        
        hand(7)=uicontrol(hand(1),'style','pushbutton',...
            'units','normalized',...
            'position',[0.01 0.35 0.8/9 0.05],...
            'string','Play',...
            'tag','play',...
            'callback', @play_vid,...
            'BackgroundColor',button_col);
        
        hand(8)=uicontrol(hand(1),'style','pushbutton',...
            'units','normalized',...
            'position',[0.01 0.25 0.8/9 0.05],...
            'string','Stop',...
            'tag','stop',...
            'callback', @stop_vid,...
            'BackgroundColor',button_col);
        
        hand(9)=uicontrol(hand(1),'style','pushbutton',...
            'units','normalized',...
            'position',[0.01 0.15 0.8/9 0.05],...
            'string','Get Mask',...
            'tag','get_mask',...
            'callback', @make_mask,...
            'BackgroundColor',button_col);
        
        hand(10)=uicontrol(hand(1),'style','pushbutton',...
            'units','normalized',...
            'position',[0.01 0.05 0.8/9 0.05],...
            'string','Done',...
            'tag','done',...
            'callback', @Done,...
            'BackgroundColor',button_col);
        
        
        slider_seuil = uicontrol(hand(1),'style','slider',...
            'units','normalized',...
            'position',[0.6 0.1 0.02 0.7],...
            'callback', @seuil);
        text(1)=uicontrol(hand(1),'style','text', ...
            'units','normalized',...
            'position',[0.6 0.85 0.03 0.05],...
            'string','thr.');
        text(2)=uicontrol(hand(1),'style','text', ...
            'units','normalized',...
            'position',[0.6 0.05 0.02 0.03],...
            'string',num2str(BW_threshold));
        set(slider_seuil,'value',BW_threshold);
        
        
        slider_rapport = uicontrol(hand(1),'style','slider',...
            'units','normalized',...
            'position',[0.65 0.1 0.02 0.7],...
            'callback', @rapport);
        text(3)=uicontrol(hand(1),'style','text', ...
            'units','normalized',...
            'position',[0.65 0.85 0.03 0.05],...
            'string','rat');
        text(4)=uicontrol(hand(1),'style','text', ...
            'units','normalized',...
            'position',[0.65 0.05 0.02 0.03],...
            'string',num2str(shape_ratio));
        set(slider_rapport,'value',shape_ratio/typical_rapport);
        
        slider_small=uicontrol(hand(1),'style','slider',...
            'units','normalized',...
            'position',[0.7 0.1 0.02 0.7],...
            'callback', @elimination);
        text(5)=uicontrol(hand(1),'style','text', ...
            'units','normalized',...
            'position',[0.7 0.85 0.03 0.05],...
            'string','min sz');
        text(6)=uicontrol(hand(1),'style','text', ...
            'units','normalized',...
            'position',[0.7 0.05 0.02 0.03],...
            'string',num2str(smaller_object_size));
        set(slider_small,'value',smaller_object_size/typical_size);
        
        slider_speed = uicontrol(hand(1),'style','slider',...
            'units','normalized',...
            'position',[0.5 0.1 0.02 0.7],...
            'callback', @vid_speed);
        text(7)=uicontrol(hand(1),'style','text', ...
            'units','normalized',...
            'position',[0.5 0.85 0.03 0.05],...
            'string','video speed');
        text(8)=uicontrol(hand(1),'style','text', ...
            'units','normalized',...
            'position',[0.5 0.05 0.02 0.03],...
            'string',num2str(accel));
        set(slider_speed,'value',accel/10);
        
        slider_time = uicontrol(hand(1),'style','slider',...
            'units','normalized',...
            'position',[0.55 0.1 0.02 0.7],...
            'callback', @time_vid);
        text(9)=uicontrol(hand(1),'style','text', ...
            'units','normalized',...
            'position',[0.55 0.85 0.03 0.05],...
            'string','time of vid');
        text(10)=uicontrol(hand(1),'style','text', ...
            'units','normalized',...
            'position',[0.55 0.05 0.02 0.03],...
            'string',num2str(chrono));
        set(slider_time,'value',fr/totframe);
        
        slider_strel = uicontrol(hand(1),'style','slider',...
            'units','normalized',...
            'position',[0.75 0.1 0.02 0.7],...
            'callback', @strelsize);
        text(11)=uicontrol(hand(1),'style','text', ...
            'units','normalized',...
            'position',[0.75 0.85 0.03 0.05],...
            'string','strl sz');
        text(12)=uicontrol(hand(1),'style','text', ...
            'units','normalized',...
            'position',[0.75 0.05 0.02 0.03],...
            'string',num2str(strsz));
        set(slider_strel,'value',strsz/maxsrtsz);
        
        slider_smooth = uicontrol(hand(1),'style','slider',...
            'units','normalized',...
            'position',[0.8 0.1 0.02 0.7],...
            'callback', @setsmoothval);
        text(13)=uicontrol(hand(1),'style','text', ...
            'units','normalized',...
            'position',[0.8 0.85 0.03 0.05],...
            'string','smooth');
        text(14)=uicontrol(hand(1),'style','text', ...
            'units','normalized',...
            'position',[0.8 0.05 0.02 0.03],...
            'string',num2str(sm_fact));
        set(slider_smooth,'value',sm_fact/MaxSmoothFact);
        
        
        slider_srdzone = uicontrol(hand(1),'style','slider',...
            'units','normalized',...
            'position',[0.85 0.1 0.02 0.7],...
            'callback', @setsrndsz);
        text(15)=uicontrol(hand(1),'style','text', ...
            'units','normalized',...
            'position',[0.85 0.85 0.03 0.05],...
            'string','surround');
        text(16)=uicontrol(hand(1),'style','text', ...
            'units','normalized',...
            'position',[0.85 0.05 0.02 0.03],...
            'string',num2str(maxsrndsz));
        set(slider_srdzone,'value',SrdZone/maxsrndsz);
        
        set(slider_time,'value',fr/totframe);
        
        pause(0.1)
        fr=1;
        go=0;
        OldIm=mask;
        OldZone=mask;
        
        %         keyboard
        while start==1
            pause(0.001)
            while (go==1) %'Everything',
                showfig=1;
                GenTracking
                
                totnum=totnum+1;
                
                % accelerate frame rate according to slider
                pause(fcy/accel)
                if accel<5
                    fr=fr+1;
                elseif accel>5
                    fr=fr+5;
                elseif accel>9
                    fr=fr+10;
                end
                
                fr=max(mod(fr,totframe+1),1);
                set(slider_time,'value',fr/totframe);
                set(text(10),'string',num2str(chrono));
            end
            
            
            while (go==2) %'Just the Nans'
                showfig=1;
                indnan=find(isnan(PosMat(:,2)));
                nanind=1;
                while nanind<=length(indnan)
                    fr=indnan(nanind);
                    GenTracking
                    totnum=totnum+1;
                    nanind=nanind+1;
                    nanind=max(mod(nanind,length(indnan)+1),1);
                    set(slider_time,'value',fr/totframe);
                    set(text(10),'string',num2str(chrono));
                    pause(fcy/accel)
                end
            end
            
            if go==3 % answer 'TrackOffLine' to 'Do you need to improve tacking? '
                showfig=0;
                n=1;
                waittracking=waitbar(0,'Offline Tracking');
                %                 keyboard
                PosMat=[];im_diff=[];
                for i=1:totframe
                    fr=i;
                    waitbar(fr/totframe,waittracking);
                    GenTracking
                end
                
                close(waittracking)
                set(hand(7),'enable','on');
                set(hand(8),'enable','on');
                set(hand(9),'enable','on');
                
                review=figure;
                subplot(131), imagesc(ref), colormap gray, axis image
                hold on
                plot(PosMat(:,2)*Ratio_IMAonREAL,PosMat(:,3)*Ratio_IMAonREAL,'color',[1 0.5 0.2]);
                err=100*sum(isnan(PosMat(:,2)))/size(PosMat,1);
                title(strcat('NaNs in tracking : ',double(num2str(err)),'%'))
                subplot(132)
                imagesc(RGBoccupation);
                subplot(165)
                vit=sqrt(diff(PosMat(:,3)).^2+diff(PosMat(:,2)).^2)/median(diff(PosMat(:,1)));
                hist(vit,size(PosMat,1)/10)
                title('Speed Histogram')
                subplot(166)
                difftime=diff(PosMat(:,1));
                hist(difftime(difftime<1),size(PosMat,1)/10)
                title('Sampling Histogram')
                
                savetrack=inputdlg('Are you happy?(y/n)','Save offline tracking');
                
                % keyboard
                if savetrack{1}=='y'
                    
                    [PosMat,PosMatInit,im_diff,im_diffInit,Vtsd,Xtsd,Ytsd,Imdifftsd]=CommonInterpPosMatImDiff(im_diff,chrono,PosMat);
                    
                    
                    saveas(review,[nameFile 'review.fig']);
                    saveas(review,[ nameFile 'review.png']);
                    
                    save('behavResources_Offline.mat','PosMat','PosMatInit','im_diff','im_diffInit','Vtsd','Xtsd','Ytsd','Imdifftsd',...
                        'ref','mask','Ratio_IMAonREAL','BW_threshold','smaller_object_size','sm_fact','strsz','SrdZone','shape_ratio');
                    
%                     try
%                         freezefig=figure;
%                         plot(im_diff(:,1),(im_diff(:,2)))
%                         [~,th_immob] = ginput(1);
%                         % Do some extra code-specific calculations
%                         FreezeEpoch=thresholdIntervals(Imdifftsd,th_immob,'Direction','Below');
%                         FreezeEpoch=mergeCloseIntervals(FreezeEpoch,0.3*1E4);
%                         FreezeEpoch=dropShortIntervals(FreezeEpoch,2*1E4);
%                         save('behavResources_Offline.mat','FreezeEpoch','-append');
%                     end
                    
                    
                    close(review);
                    go=0;
                    start = 0;
                else
                    go=0;
                end
                
                im_diff=[]; PosMat = [];
            end
            
        end
        
        function make_mask(~,~)
            GenMask
        end
        
        function play_vid(~,~)
            start=1;
            playwhat=questdlg('What do you want to watch? ','Play','Everything','Just the Nans','Nothing','Nothing');
            if length(playwhat)==10
                go=1;
                nanind=1E7;
                set(hand(7),'enable','off');
                set(hand(9),'enable','off');
            elseif length(playwhat)==13
                go=2;
                nanind=1;
                set(hand(7),'enable','off');
                set(hand(9),'enable','off');
            else
                go=0;
            end
        end
        
        function stop_vid(~,~)
            choice=questdlg('Do you need to improve tracking? ','what to do?','No','Track offline','Add to batch','No');
            if  length(choice)==13 %'Track offline'
                go=3;
                nanind=1E7;
                set(hand(7),'enable','off');
                set(hand(8),'enable','off');
                set(hand(9),'enable','off');
            elseif length(choice)==2 % 'No'
                go=0;
                nanind=1E7;
                set(hand(7),'enable','on');
                set(hand(9),'enable','on');
            elseif length(choice)== 12 % Add to batch'
                
                go=0;
                nanind=1E7;
                set(hand(7),'enable','on');
                set(hand(9),'enable','on');
                batchlist{1,batchnum}=type;
                batchlist{2,batchnum}=PathName;
                if type==1
                    batchlist{3,batchnum}='';
                else
                    batchlist{3,batchnum}=nameFile;
                end
                
                
                try
                    save('InfoTrackingOffline.mat','ref','mask','Ratio_IMAonREAL','BW_threshold','smaller_object_size','sm_fact','strsz','SrdZone','shape_ratio','-append')
                catch
                    save('InfoTrackingOffline.mat','ref','mask','Ratio_IMAonREAL','BW_threshold','smaller_object_size','sm_fact','strsz','SrdZone','shape_ratio')
                end
                go=0;
                
                batchnum=batchnum+1;
                options.Resize='on';
                options.WindowStyle='normal';

            end
        end
        
        function Done(~,~)
            start=0;
            go=0;
            nanind=1E7;
            for handdel=[7,8,9,10]
                delete(hand(handdel))
            end
            for textdel=1:10
                delete(text(textdel))
            end
            delete(watchin);delete(slider_time);delete(slider_seuil);delete(slider_speed);
            delete(slider_small);delete(slider_rapport); delete(bnw_watchin);
            PosMat=[];
            im_diff=[];
            for y=2:4
                set(hand(y),'enable','on');
            end
            pause(0.0001);
        end
        
        function GetFileInfo
            
            private=0;
            
            PathName =  uigetdir;
            cd(PathName);
            lis=dir(PathName);
            index=[];
            try
                PosMat=load('PosMat.mat');PosMat=struct2array(PosMat);
            end
            
            
            try
                availinfo(1)=exist('behavResources.mat');
                availinfo(2)=exist('InfoTrackingOffline.mat');
                [~,indavail]=max(availinfo);
                indavail=max(indavail);
                filenameinfotracking{1}='behavResources.mat';
                filenameinfotracking{2}='InfoTrackingOffline.mat';
                ref=load(filenameinfotracking{indavail},'ref');
                ref=struct2array(ref);
                if length(size(ref))==3
                    ref=(double(ref(:,:,3,1)));
                end
                if max(ref)>1
                    ref = ref/256;
                end
                private=1;
                cd(PathName);
                if size(ref,1)==0
                    %                     keyboard
                    msgbox('No reference found, cannot proceed','No ref !!','waarn')
                end
            catch
                try
                    cd ..
                    availinfo(1)=exist('behavResources.mat');
                    availinfo(2)=exist('InfoTrackingOffline.mat');
                    [~,indavail]=max(availinfo);
                    indavail=max(indavail);
                    filenameinfotracking{1}='behavResources.mat';
                    filenameinfotracking{2}='InfoTrackingOffline.mat';
                    ref=load(filenameinfotracking{indavail},'ref');ref=struct2array(ref);
                    if length(size(ref))==3
                        ref=(double(ref(:,:,3,1)));
                    end
                    if max(ref)>1
                        ref = ref/256;
                    end
                    cd(PathName);
                    if size(ref,1)==0
                        msgbox('No reference found, cannot proceed','No ref !!','warn')
                    end
                catch
                    msgbox('No reference found, cannot proceed','No ref !!','warn')
                    cd(PathName);
                    
                end
            end
            for i=1:length(lis)
                NameLis{i}=lis(i).name;
                if strfind(NameLis{i},'frame')
                    index=[index,i];
                end
            end
            
            try
                
                totframe=length(index);
                datas=load(NameLis{index(1)});datas=struct2array(datas);
                t1=datas.time;
                IM=datas.image;
                datas=load(NameLis{index(totframe)});datas=struct2array(datas);
                t2=datas.time;
                [l2,l1] = size(ref);
                typical_size = 5*sqrt(l1*l2);
                durmax=etime(t2,t1);
                nx = l2/10;
                ny = l1/10;
                occupation = zeros(ny,nx);
                RGBoccupation=zeros(size(occupation,1),size(occupation,2),3); %matrice couleur
                fcy=durmax/totframe;
                
                
                
                try
                    if private==0
                        cd ..
                    end
                    mask=load(filenameinfotracking{indavail},'mask');mask=struct2array(mask);
                    cd(PathName);
                    if size(mask,1)==0
                        mask=ones(size(ref,1),size(ref,2));
                        answer = inputdlg('No mask want to make one (y/n)?','Mask',1);
                        if answer{1} =='y'
                            GenMask
                        end
                    end
                    cd(PathName);
                catch
                    mask=ones(size(ref,1),size(ref,2));
                    answer = inputdlg('No mask want to make one (y/n)?','Mask',1);
                    if answer{1} =='y'
                        GenMask
                    end
                    cd(PathName);
                end
                
                try
                    if private==0
                        cd ..
                    end
                    intvar=load(filenameinfotracking{indavail},'smaller_object_size','BW_threshold','shape_ratio');
                    BW_threshold=intvar.BW_threshold;
                    smaller_object_size=intvar.smaller_object_size;
                    shape_ratio=intvar.shape_ratio;
                    cd(PathName);
                catch
                    BW_threshold=0;
                    smaller_object_size=0;
                    shape_ratio=0;
                    cd(PathName);
                end
                
                try
                    if private==0
                        cd ..
                    end
                    intvar=load(filenameinfotracking{indavail},'strsz');
                    strsz=intvar.strsz;
                    se = strel('disk',strsz);
                    cd(PathName);
                catch
                    strsz=0;
                    se = strel('disk',strsz);
                    cd(PathName);
                end
                
                
                try
                    keyboard
                    if private==0
                        cd ..
                    end
                    try
                        intvar=load(filenameinfotracking{indavail},'Ratio_IMAonREAL');
                        Ratio_IMAonREAL=intvar.Ratio_IMAonREAL;
                    catch
                        intvar=load(filenameinfotracking{indavail},'pixratio');
                        Ratio_IMAonREAL=1./intvar.pixratio;
                    end
                    cd(PathName);
                catch
                    cd(PathName);
                    PathName
                    getpixrat=questdlg('There is no pixel ratio, do you want to get the scale?','Scale Tracking','yes','no','yes');
                    if length(getpixrat)==3
                        GenPixelRatio
                    else
                        Ratio_IMAonREAL=1;
                    end
                end
                
                try
                    if private==0
                        cd ..
                    end
                    intvar=load(filenameinfotracking{indavail},'BW_threshold_imdiff','smaller_object_size_imdiff');
                    BW_threshold=intvar.BW_threshold_imdiff;
                    smaller_object_size=intvar.smaller_object_size_imdiff;
                    cd(PathName);
                catch
                    BW_threshold_imdiff=0;
                    smaller_object_size_imdiff=0;
                    cd(PathName);
                end
                
            end
        end
        
        function GetVidInfo
            
            [nameFile,PathName,FilterIndex] =  uigetfile({'*.avi';'*.mpg';'*.wmv';'*.mov'});
            disp('loading file, be patient')
            cd(eval(strcat('''',PathName,'''')))
            OBJ = VideoReader(nameFile);
            totframe = get(OBJ, 'numberOfFrames');
            vidFrames = read(OBJ,1);
            IM=(double(vidFrames(:,:,3,1)));
            [l2,l1] = size(IM);
            typical_size = 5*sqrt(l1*l2);
            durmax = inputdlg('how long is recording in s');
            durmax = eval(durmax{1});
            fcy=durmax/totframe;
            nx = l2/10;
            ny = l1/10;
            occupation = zeros(ny,nx);
            RGBoccupation=zeros(size(occupation,1),size(occupation,2),3); %matrice couleur
            availinfo(1)=exist('behavResources.mat');
            availinfo(2)=exist('InfoTrackingOffline.mat');
            [~,indavail]=max(availinfo);
            indavail=max(indavail);
            disp('file loaded')
            filenameinfotracking{1}='behavResources.mat';
            filenameinfotracking{2}='InfoTrackingOffline.mat';
            try
                PosMat=load('PosMat.mat');PosMat=struct2array(PosMat);
            end
            
            try
                ref=load(filenameinfotracking{indavail},'ref');ref=struct2array(ref);
                if length(size(ref))==3
                    ref=(double(ref(:,:,3,1)));
                end
                if size(ref,1)==0
                    msgbox('No reference found, cannot proceed','No ref !!','waarn')
                end
            catch
                msgbox('No reference found, cannot proceed','No ref !!','waarn')
                
            end
            
            try
                try
                    intvar=load(filenameinfotracking{indavail},'Ratio_IMAonREAL');
                    Ratio_IMAonREAL=intvar.Ratio_IMAonREAL;
                catch
                    % deals with older codes where is was the opposite
                    intvar=load(filenameinfotracking{indavail},'pixratio');
                    Ratio_IMAonREAL=1./intvar.pixratio;
                end
                
            catch
                getpixrat=questdlg('There is no pixel ratio, do you want to get the scale?','Scale Tracking','yes','no','yes');
                if length(getpixrat)==3
                    GenPixelRatio
                else
                    Ratio_IMAonREAL=1;
                end
            end
            
            try
                mask=load(filenameinfotracking{indavail},'mask');mask=struct2array(mask);
                if size(mask,1)==0
                    mask=ones(size(IM,1),size(IM,2));
                    answer = inputdlg('No mask want to make one (y/n)?','Mask',1);
                    if answer{1} =='y'
                        GenMask
                    end
                end
            catch
                mask=ones(size(IM,1),size(IM,2));
                answer = inputdlg('No mask want to make one (y/n)?','Mask',1);
                if answer{1} =='y'
                    GenMask
                end
            end
            
            
            try
                intvar=load(filenameinfotracking{indavail},'smaller_object_size','BW_threshold','shape_ratio');
                BW_threshold=intvar.BW_threshold;
                smaller_object_size=intvar.smaller_object_size;
                shape_ratio=intvar.shape_ratio;
            catch
                BW_threshold=0;
                smaller_object_size=0;
                shape_ratio=0;
            end
            
            try
                intvar=load(filenameinfotracking{indavail},'strsz');
                strsz=intvar.strsz;
                se = strel('disk',strsz);
                
            catch
                strsz=0;
                se = strel('disk',strsz);
            end
            
            try
                intvar=load(filenameinfotracking{indavail},'BW_threshold_imdiff','smaller_object_size_imdiff');
                BW_threshold_imdiff=intvar.BW_threshold_imdiff;
                smaller_object_size_imdiff=intvar.smaller_object_size_imdiff;
            catch
                BW_threshold_imdiff=0;
                smaller_object_size_imdiff=0;
            end
            
        end
        
        
        
        
    end

%% Create an artificial ref
    function create_ref(~,~)
        OBJ=[];
        private=1;
        IM=[];
        chrono=0;
        GetVidInfo
        watchin=subplot(2,2,1);
        ImageDisplayTop = imagesc(IM);
        new_ref=subplot(2,2,3);
        ImageDisplayBottom = imagesc(IM);
        colormap gray
        accel=3; % from 0 to  20
        fr=1;
        start=1;
        go=0;
        refno=1;
        imtoref=[];
        ref=[];
        hand(7)=uicontrol(hand(1),'style','pushbutton',...
            'units','normalized',...
            'position',[0.01 0.35 0.8/9 0.05],...
            'string','Play',...
            'tag','play',...
            'callback', @play_vid,...
            'BackgroundColor',button_col);
        
        hand(8)=uicontrol(hand(1),'style','pushbutton',...
            'units','normalized',...
            'position',[0.01 0.25 0.8/9 0.05],...
            'string','Get Frame',...
            'tag','getframe',...
            'callback', @get_frame,...
            'BackgroundColor',button_col);
        
        hand(9)=uicontrol(hand(1),'style','pushbutton',...
            'units','normalized',...
            'position',[0.01 0.15 0.8/9 0.05],...
            'string','Done',...
            'tag','done',...
            'callback', @Done,...
            'BackgroundColor',button_col);
        
        slider_speed = uicontrol(hand(1),'style','slider',...
            'units','normalized',...
            'position',[0.7 0.1 0.05 0.7],...
            'callback', @vid_speed);
        text(7)=uicontrol(hand(1),'style','text', ...
            'units','normalized',...
            'position',[0.7 0.85 0.1 0.06],...
            'string','video speed');
        text(8)=uicontrol(hand(1),'style','text', ...
            'units','normalized',...
            'position',[0.725 0.05 0.05 0.03],...
            'string',num2str(accel));
        set(slider_speed,'value',accel/10);
        
        slider_time = uicontrol(hand(1),'style','slider',...
            'units','normalized',...
            'position',[0.8 0.1 0.05 0.7],...
            'callback', @time_vid);
        text(9)=uicontrol(hand(1),'style','text', ...
            'units','normalized',...
            'position',[0.8 0.85 0.1 0.06],...
            'string','time of vid');
        text(10)=uicontrol(hand(1),'style','text', ...
            'units','normalized',...
            'position',[0.825 0.05 0.05 0.03],...
            'string',num2str(chrono));
        
        set(slider_time,'value',fr/totframe);
        pause(0.1)
        
        while start==1
            pause(0.001)
            
            while go==1
                fr=1;
                
                while fr<=totframe & refno<=2
                    vidFrames = read(OBJ,fr);
                    IM=(double(vidFrames(:,:,3,1)))/256;
                    chrono=fr*fcy;
                    set(slider_time,'value',fr/totframe);
                    set(text(10),'string',num2str(chrono));
                    set(ImageDisplayTop,'Cdata',IM);
                    pause(fcy/accel)
                    fr=fr+1;
                    if accel<5
                        fr=fr+1;
                    elseif accel>5
                        fr=fr+8;
                    elseif accel>9
                        fr=fr+15;
                    end
                    fr=max(mod(fr,totframe+1),1)
                end
                
                if refno==3
                    %                     keyboard
                    ref1=refs{1};
                    ref2=refs{2};
                    set(ImageDisplayBottom,'Cdata',ref1);
                    pause(0.1)
                    where=inputdlg('Where is the mouse on the top frame? Top(T)/Bottom(B)/Left(L)/Right(R)','Mouse location');
                    subplot(new_ref)
                    [x,y]=ginput(1);
                    
                    if where{1}=='T'
                        ref=[ref1(1:floor(y),:);ref2(floor(y)+1:end,:)];
                    elseif where{1}=='B'
                        ref=[ref2(1:floor(y),:);ref1(floor(y)+1:end,:)];
                    elseif where{1}=='L'
                        ref=[ref1(:,1:floor(x)),ref2(:,floor(x)+1:end)];
                    elseif where{1}=='R'
                        ref=[ref2(:,1:floor(x)),ref1(:,floor(x)+1:end)];
                    end
                    set(ImageDisplayBottom,'Cdata',ref);
                    pause(0.1)
                    happy=questdlg('Are you happy','Save ref');
                    ref = double(ref); ref=ref;
                    if length(happy)==3
                        try
                            save('InfoTrackingOffline.mat','ref','-append')
                        catch
                            save('InfoTrackingOffline.mat','ref')
                        end
                    end
                    go=0;
                    refno=1;
                    imtoref=[];
                    
                end
            end
        end
        
        function get_frame(~,~)
            refs{refno}=IM;
            refno=refno+1;
        end
        
        function Done(~,~)
            start=0;
            go=0;
            for handdel=[7,8,9]
                delete(hand(handdel))
            end
            for textdel=[7,8,9,10]
                delete(text(textdel))
            end
            delete(watchin);delete(slider_time);delete(slider_speed);
            delete(new_ref);
        end
        
        
        
        function play_vid(~,~)
            go=1;
            refno=1;
            imtoref=[];
        end
        
        function GetVidInfo
            
            [nameFile,PathName,FilterIndex] =  uigetfile({'*.avi';'*.mpg';'*.wmv';'*.mov'});
            cd(eval(strcat('''',PathName,'''')))
            disp('loading file, be patient')
            OBJ = VideoReader(nameFile);
            totframe = get(OBJ, 'numberOfFrames');
            fcy=1./get(OBJ, 'FrameRate');
            durmax=fcy*totframe;
            vidFrames = read(OBJ,1);
            IM=(double(vidFrames(:,:,3,1)))/256;
            disp('file loaded')
        end
        
        
    end

%% Function called by the others
    function GenMask
        %   keyboard
        mask=ones(size(IM,1),size(IM,2));
        
        color_on = [ 0 0 0];
        
        %% graphical interface n�3
        mask_fig=figure('units','normalized',...
            'position',[0.15 0.1 0.8 0.8],...
            'numbertitle','off',...
            'name','Online Mouse Tracking : Setting Parameters',...
            'menubar','none',...
            'tag','figure mask');
        set(mask_fig,'Color',color_on);
        
        uicontrol(mask_fig,'style','text', ...
            'units','normalized',...
            'position',[0.25 0.02 0.06 0.03],...
            'string','click on maze edges');
        
        uicontrol(mask_fig,'style','text', ...
            'units','normalized',...
            'position',[0.70 0.02 0.06 0.03],...
            'string','satisfied?');
        
        maskbutton(1)= uicontrol(mask_fig,'style','pushbutton',...
            'units','normalized',...
            'position',[0.25 0.85 0.08 0.05],...
            'string','Circle',...
            'callback', @Option_Circle);
        
        maskbutton(2)= uicontrol(mask_fig,'style','pushbutton',...
            'units','normalized',...
            'position',[0.01 0.25 0.08 0.05],...s
            'string','save',...
            'callback', @save_mask);
        
        maskbutton(3)=uicontrol(mask_fig,'style','pushbutton',...
            'units','normalized',...
            'position',[0.01 0.65 0.08 0.05],...
            'string','mask IN',...
            'callback', @Do_maskIN);
        
        maskbutton(4)= uicontrol(mask_fig,'style','pushbutton',...
            'units','normalized',...
            'position',[0.01 0.75 0.08 0.05],...
            'string','Reset mask',...
            'callback', @Reset_mask);
        
        maskbutton(5)=uicontrol(mask_fig,'style','pushbutton',...
            'units','normalized',...
            'position',[0.01 0.55 0.08 0.05],...
            'string','mask OUT',...
            'callback', @Do_maskOUT);
        
        maskbutton(6)= uicontrol(mask_fig,'style','pushbutton',...
            'units','normalized',...
            'position',[0.01 0.45 0.08 0.05],...
            'string','Load mask',...
            'callback', @Load_mask);
        
        maskbutton(7)= uicontrol(mask_fig,'style','pushbutton',...
            'units','normalized',...
            'position',[0.01 0.04 0.08 0.05],...
            'string','Close',...
            'callback', @fermeture_mask);
        
        
        ref2=IM;
        figure(mask_fig),colormap gray
        subplot(1,2,1), imagesc(ref),axis image
        Docircle=0; title('rectligne shape','Color','w')

        function Do_maskIN(obj,event)
            for var_boucle=1:7
                set(maskbutton(var_boucle),'Enable','off')
            end
            figure(mask_fig), subplot(1,2,1)
            if Docircle
                imel = imellipse;
                BW = createMask(imel);
            else
                [x1,y1,BW,y2]=roipoly(uint8(IM));
            end
            maskint=uint8(BW);
            maskint=uint8(-(double(maskint)-1));
            mask=uint8(double(mask).*double(maskint));
            
            colormap gray
            ref2((find(mask==0)))=0;
            figure(mask_fig), subplot(1,2,2)
            imagesc(ref2),axis image
            for var_boucle=1:7
                set(maskbutton(var_boucle),'Enable','on')
            end
        end
        
        function Do_maskOUT(obj,event)
            for var_boucle=1:7
                set(maskbutton(var_boucle),'Enable','off')
            end
            
            figure(mask_fig), subplot(1,2,1)
            if Docircle
                imel = imellipse;
                BW = createMask(imel);
            else
                [x1,y1,BW,y2]=roipoly(uint8(IM));
            end
            maskint=uint8(BW);
            mask=uint8(double(mask).*double(maskint));
            
            colormap gray
            ref2((find(mask==0)))=0;
            figure(mask_fig), subplot(1,2,2)
            imagesc(ref2),axis image
            for var_boucle=1:7
                set(maskbutton(var_boucle),'Enable','on')
            end
        end
        
        function Load_mask(obj,event)
            [filename,path] = uigetfile('*.mat','Please select a mask for this session');
            try
                load(strcat(path,filename),'mask');
            catch
                msg_box=msgbox('no mask found in this file','mask','modal');
                
            end
            
            if size(mask)~=size(IM)
                mask=ones(size(IM,1),size(IM,2));
                msg_box=msgbox('Mask wrong size, resetting','mask','modal');
            end
            
            ref2=IM;
            ref2((find(mask==0)))=0;
            figure(mask_fig), subplot(1,2,2)
            imagesc(ref2),axis image
            
        end
        
        function Option_Circle(obj,event)
            if Docircle
                Docircle=0;
                subplot(1,2,1), title('rectligne shape','Color','w')
            else
                Docircle=1;
                subplot(1,2,1), title('CIRCLE ACITVATED','Color','w')
            end
            
        end
        
        function Reset_mask(obj,event)
            figure(mask_fig),colormap gray
            subplot(1,2,1), imagesc(IM),axis image
            Docircle=0; title('rectligne shape','Color','w')
            mask=ones(size(ref2,1),size(ref2,2));
            ref2=IM;
            subplot(122), imagesc(ref2), axis image
        end
        
        
        function save_mask(obj,event) % keep ref in memory
            try
                save('InfoTrackingOffline.mat','mask','-append');
            catch
                save('InfoTrackingOffline.mat','mask');
            end
            msg_box=msgbox('Mask saved','save','modal');
        end
        
        function fermeture_mask(obj,event)
            delete(mask_fig)
        end
        
        
    end

    function GenTracking
        
        if type==1
            datas=load(NameLis{index(fr)});datas=struct2array(datas);
            IM=double(datas.image)/256;
            chrono=etime(datas.time,t1);
        elseif type==2
            vidFrames = read(OBJ,fr);
            IM=(double(vidFrames(:,:,3,1)))/256;
            chrono=fr*fcy;
        end
        
        [Pos,ImDiff,PixelsUsed,NewIm,FzZone]=Track_ImDiff(double(IM),double(mask),double(ref),BW_threshold,smaller_object_size,sm_fact,se,SrdZone,...
            Ratio_IMAonREAL,OldIm,OldZone,camera_type);
        
        diffshow=double(NewIm);
        diffshow(FzZone==1)=0.4;
        diffshow(OldZone==1)=0.4;
        diffshow(NewIm==1)=0.8;
        
        if sum(isnan(Pos))==0
            PosMat(fr,1)=chrono;
            PosMat(fr,2)=Pos(1);
            PosMat(fr,3)=Pos(2);
            PosMat(fr,4)=0;
            im_diff(fr,1)=chrono;
            im_diff(fr,2)=ImDiff;
            im_diff(fr,3)=PixelsUsed;
            switch camera_type
                case 'IRCamera'
                    MouseTemp(fr,1)=chrono;
                    MouseTemp(fr,2)=max(max(IM.*FzZone));
                case 'Webcam'
                    MouseTemp(fr,1:2)=[chrono;NaN];
            end
            x_oc = max(round(Pos(1)*Ratio_IMAonREAL/l1*nx),1);
            y_oc = max(round(Pos(2)*Ratio_IMAonREAL/l2*ny),1);
            occupation(y_oc,x_oc) = occupation(y_oc,x_oc) + 1;
            
        else
            
            PosMat(fr,:)=[chrono;NaN;NaN;NaN];
            im_diff(fr,1:3)=[chrono;NaN;NaN];
            MouseTemp(fr,1:2)=[chrono;NaN];
            nannum=nannum+1;
            
        end
        
        if showfig==1
            set(PositionPlot,'Xdata',Pos(1).*Ratio_IMAonREAL,'YData',Pos(2).*Ratio_IMAonREAL)
            set(ImageDisplayBottom,'Cdata',diffshow);
            set(ImageDisplayTop,'Cdata',double(IM));
            subplot(bnw_watchin)
            title(strcat('nans since last change :',num2str(double(nannum/totnum))))
        end
        
        occupation_norm=occupation/n;
        n=n+1;
        log_occupation_norm=log(1+occupation_norm); % echelle log
        max_log_oc=max(max(log_occupation_norm));
        log_occupation_norm=log_occupation_norm/max_log_oc;
        
        nopath=(occupation==0); % endroit o� la souris n'est jamais pass�e
        
        RGBoccupation(:,:,3)=nopath;
        RGBoccupation(:,:,2)=nopath;
        RGBoccupation(:,:,1)= log_occupation_norm+nopath; %en blanc l� o� elle n'est jamais pass�e ; en rouge ailleurs ;
        
        
        OldIm=NewIm;
        OldZone=FzZone;
        
    end


    function rapport(obj,event)
        shape_ratio = (get(slider_rapport,'value')*typical_rapport);
        set(text(4),'string',num2str(shape_ratio))
        nannum=0;totnum=0;
    end

    function setsrndsz(obj,event)
        SrdZone = round(get(slider_srdzone,'value')*maxsrndsz);
        set(text(16),'string',num2str(SrdZone));
        nannum=0;totnum=0;
    end


    function seuil(obj,event)
        if doin==0
            BW_threshold = get( slider_seuil, 'value');
            set(text(2),'string',num2str(BW_threshold))
            nannum=0;totnum=0;
        elseif doin==1
            BW_threshold_imdiff = get( slider_seuil, 'value');
            set(text(2),'string',num2str(BW_threshold_imdiff))
            
        end
    end

    function elimination(obj,event)
        if doin==0
            smaller_object_size = round(get(slider_small,'value')*typical_size);
            set(text(6),'string',num2str(smaller_object_size))
            nannum=0;totnum=0;
        elseif doin==1
            smaller_object_size_imdiff = round(get(slider_small,'value')*typical_size);
            set(text(6),'string',num2str(smaller_object_size_imdiff))
        end
    end

    function setsmoothval(obj,event)
        if doin==0
            sm_fact = round(get(slider_smooth,'value')*MaxSmoothFact);
            set(text(14),'string',num2str(sm_fact))
            nannum=0;totnum=0;
        end
    end

    function strelsize(~,~)
        strsz = round(get(slider_strel,'value')*maxsrtsz);
        se = strel('disk',strsz);
        set(text(12),'string',num2str(strsz));
        nannum=0;totnum=0;
    end


    function vid_speed(obj,event)
        accel = (get(slider_speed,'value')*10)+0.1;
        set(text(8),'string',num2str(accel))
    end

    function time_vid(obj,event)
        chrono_int = (get(slider_time,'value'));
        fr=max(floor(chrono_int*totframe),1);
        chrono=chrono_int*durmax;
        set(text(10),'string',num2str(chrono))
        pause(0.1)
    end


    function GenPixelRatio
        ratiofig=figure;
        imagesc(IM);
        title('Select length on image');
        [x,y] = ginput(2);
        distpix=sqrt((x(2)-x(1)).^2+(y(2)-y(1)).^2);
        distrel=inputdlg('Please give corresponding length in cm','length');
        Ratio_IMAonREAL=distpix/eval(distrel{1});
        try
            save('InfoTrackingOffline.mat','Ratio_IMAonREAL','-append')
        catch
            save('InfoTrackingOffline.mat','Ratio_IMAonREAL')
        end
        delete(ratiofig);
    end

    function LaunchBatch(~,~)
        
        keyboard
        
        for b=1:batchnum-1 % for each file of batchlist
            try
                disp(num2str(b/batchnum))
                dobatch=1;
                cd(batchlist{2,b})
                if batchlist{1,b}==2 % video
                    OBJ = VideoReader(batchlist{3,b});
                    totframe = get(OBJ, 'numberOfFrames');
                    fcy=1./get(OBJ, 'FrameRate');
                    durmax=fcy*totframe;
                    vidFrames = read(OBJ,1);
                    IM=(double(vidFrames(:,:,3,1)))/256;
                    [l2,l1] = size(IM);
                    nameFile=batchlist{3,b};
                    
                else % matlab frame
                    lis=dir(batchlist{2,b});
                    index=[];
                    
                    for i=1:length(lis)
                        NameLis{i}=lis(i).name;
                        if strfind(NameLis{i},'frame')
                            index=[index,i];
                        end
                    end
                    totframe=length(index);
                    datas=load(NameLis{index(1)});datas=struct2array(datas);
                    t1=datas.time;
                    IM=datas.image;
                    datas=load(NameLis{index(totframe)});datas=struct2array(datas);
                    t2=datas.time;
                    [l2,l1] = size(ref);
                    durmax=etime(t2,t1);
                end
                
                typical_size = 5*sqrt(l1*l2);
                nx = l2/10;
                ny = l1/10;
                occupation = zeros(ny,nx);
                RGBoccupation=zeros(size(occupation,1),size(occupation,2),3); %matrice couleur
                fcy=durmax/totframe;
                
                
                try
                    ref=load('InfoTrackingOffline.mat','ref');
                    ref=struct2array(ref);
                    if length(size(ref))==3
                        ref=(double(ref(:,:,3,1)));
                    end
                    if size(ref,1)==0
                        dobatch=0;
                        batchlist{4,batchnum}='no ref';
                    end
                catch
                    dobatch=0;
                    batchlist{4,batchnum}='no ref';
                end
                try
                    intvar=load('InfoTrackingOffline.mat','Ratio_IMAonREAL');
                    Ratio_IMAonREAL=intvar.Ratio_IMAonREAL;
                catch
                    Ratio_IMAonREAL=1;
                end
                
                try
                    mask=load('InfoTrackingOffline.mat','mask');
                    mask=struct2array(mask);
                    if size(mask,1)==0
                        mask=ones(size(ref,1),size(ref,2));
                    end
                catch
                    mask=ones(size(ref,1),size(ref,2));
                end
                
                try
                    intvar=load('InfoTrackingOffline.mat','smaller_object_size','BW_threshold','shape_ratio');
                    BW_threshold=intvar.BW_threshold;
                    smaller_object_size=intvar.smaller_object_size;
                    shape_ratio=intvar.shape_ratio;
                    
                catch
                    batchlist{4,b}='no posmat thresholds';
                end
                
                try
                    intvar=load('InfoTrackingOffline.mat','strsz');
                    strsz=intvar.strsz;
                    se = strel('disk',strsz);
                    
                catch
                    strsz=0;
                    se = strel('disk',strsz);
                end
                
                
                
                if dobatch==1
                    PosMat=[]; im_diff=[];
                    disp('Tracking calculation')
                    showfig=0;
                    n=1;
                    for i=1:totframe
                        fr=i;
                        GenTracking
                    end
                    
                    disp('Tracking done, saving')
                    
                    
                    
                    review=figure;
                    subplot(131), imagesc(ref), colormap gray, axis image
                    hold on
                    plot(PosMat(:,2),PosMat(:,3),'color',[1 0.5 0.2]);
                    err=100*sum(isnan(PosMat(:,2)))/size(PosMat,1);
                    title(strcat('NaNs in tracking : ',double(num2str(err))))
                    subplot(132)
                    imagesc(RGBoccupation);
                    subplot(165)
                    vit=sqrt(diff(PosMat(:,3)).^2+diff(PosMat(:,2)).^2)/median(diff(PosMat(:,1)));
                    hist(vit,size(PosMat,1)/10)
                    title('Speed Histogram')
                    subplot(166)
                    difftime=diff(PosMat(:,1));
                    hist(difftime(difftime<1),size(PosMat,1)/10)
                    title('Sampling Histogram')
                    
                    [~,nameFile,~]=fileparts(nameFile);
                    
                    [PosMat,PosMatInit,im_diff,im_diffInit,Vtsd,Xtsd,Ytsd,Imdifftsd]=CommonInterpPosMatImDiff(im_diff,chrono,PosMat);
                    
                    
                    saveas(review,[nameFile 'review.fig']);
                    saveas(review,[ nameFile 'review.png']);
                    
                    save('behavResources_Offline.mat','PosMat','PosMatInit','im_diff','im_diffInit','Vtsd','Xtsd','Ytsd','Imdifftsd',...
                        'ref','mask','Ratio_IMAonREAL','BW_threshold','smaller_object_size','sm_fact','strsz','SrdZone','shape_ratio');
                    
%                     try
%                         freezefig=figure;
%                         plot(im_diff(:,1),(im_diff(:,2)))
%                         [~,th_immob] = ginput(1);
%                         % Do some extra code-specific calculations
%                         FreezeEpoch=thresholdIntervals(Imdifftsd,th_immob,'Direction','Below');
%                         FreezeEpoch=mergeCloseIntervals(FreezeEpoch,0.3*1E4);
%                         FreezeEpoch=dropShortIntervals(FreezeEpoch,2*1E4);
%                         save('behavResources_Offline.mat','FreezeEpoch','-append');
%                     end
                    
                    
                    close(review);
                    
                    
                    im_diff=[]; % Julie 22.12.2014
                    batchlist{4,b}='OK';
                    
                end
            catch
                keyboard
            end
        end
    end


end


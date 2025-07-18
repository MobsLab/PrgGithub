function OfflineTrackingFinal_v3
close hidden
clear hidden
close all
clear all
OLDIM=[];OBJ=[]; IM=[];
type=0; n=1; doin=0;
global PosMat
global im_diff
PosMat=[]; im_diff=[];
ref=[];mask=[];pixratio=1;
BW_threshold=0; smaller_object_size=0; shape_ratio=0; bigger_object_size=0;
BW_threshold_imdiff=0; smaller_object_size_imdiff=0;
intvar=[];datas=[];
fr=1; chrono=0; durmax=[];t1=[]; fcy=0.05; totframe=[];
j=[]; h=[];g=[];
nannum=0; totnum=0;
nx=1;ny=1;l1=0;l2=0; sizeOccMap=5;
occupation = zeros(ny,nx); %carte d'occupatione
RGBoccupation=zeros(size(occupation,1),size(occupation,2),3); %matrice couleur
nameFile=''; PathName=''; NameLis=[];index=[]; private=1;
inter_col=copper(5);
button_col=inter_col(3,:);
slider_speed=[];slider_seuil=[];slider_rapport=[];slider_small=[];slider_time=[];slider_strel=[];slider_big=[];
strsz=2;maxsrtsz=20;se=[];
typical_rapport=8; typical_size=0; accel=3;
hand=[]; showfig=1;bnw_watchin=[];ratiofig=[];text=[];
batchnum=1; batchlist=cell(5,1);
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
%
% hand(5)=uicontrol(hand(1),'style','pushbutton',...
%     'units','normalized',...
%     'position',[0.01 0.55 0.8/9 0.05],...
%     'string','Analyze Data',...
%     'tag','analdat',...
%     'callback', @anal_dat);
%% Track from Matlab generated frames

    function track(~,~)
        
        for y=2:4
            set(hand(y),'enable','off');
        end
        type=inputdlg('Track from matlab files (1) or from Video (2)?','Type of tracking')
        type=eval(type{1});
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
        h = imagesc(ref);
        axis image
        hold on
        g=plot(0,0,'m+');
        bnw_watchin=subplot(2,2,3);
        j = imagesc(uint8(ones(size(ref,1),size(ref,2))));
        
        
        
        
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
        
        hand(20)=uicontrol(hand(1),'style','pushbutton',...
            'units','normalized',...
            'position',[0.21 0.05 0.8/9 0.05],...
            'string','Toggle Im diff',...
            'tag','toggle',...
            'callback', @Toggle,...
            'BackgroundColor',button_col);
        
        slider_seuil = uicontrol(hand(1),'style','slider',...
            'units','normalized',...
            'position',[0.6 0.1 0.02 0.7],...
            'callback', @seuil);
        text(1)=uicontrol(hand(1),'style','text', ...
            'units','normalized',...
            'position',[0.6 0.85 0.02 0.05],...
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
            'position',[0.65 0.85 0.02 0.05],...
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
            'position',[0.7 0.85 0.02 0.03],...
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
            'position',[0.5 0.85 0.02 0.03],...
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
            'position',[0.55 0.85 0.02 0.03],...
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
            'position',[0.75 0.85 0.02 0.03],...
            'string','strl sz');
        text(12)=uicontrol(hand(1),'style','text', ...
            'units','normalized',...
            'position',[0.75 0.05 0.02 0.03],...
            'string',num2str(strsz));
        set(slider_strel,'value',strsz/maxsrtsz);
        
        slider_big = uicontrol(hand(1),'style','slider',...
            'units','normalized',...
            'position',[0.8 0.1 0.02 0.7],...
            'callback', @bigelimination);
        text(13)=uicontrol(hand(1),'style','text', ...
            'units','normalized',...
            'position',[0.8 0.85 0.02 0.03],...
            'string','max sz');
        text(14)=uicontrol(hand(1),'style','text', ...
            'units','normalized',...
            'position',[0.8 0.05 0.02 0.03],...
            'string',num2str(strsz));
        set(slider_big,'value',bigger_object_size/typical_size);
        
        set(slider_time,'value',fr/totframe);
        
        pause(0.1)
        fr=1;
        go=0;
        while start==1
            pause(0.001)
            while (go==1)
                showfig=1;
                if doin==0
                    disp('trck')
                    GenTracking
                elseif doin==1
                    disp('imdiff')
                    GenImDiff
                end
                
                totnum=totnum+1;
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
            
            
            while (go==2)
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
            
            if go==3
                showfig=0;
                n=1;
                tosave=questdlg('What do you want to save','Save to file','Tracking','Im Diff','Both','Both');
                waittracking=waitbar(0,'Offline Tracking');
                for i=1:totframe
                    fr=i;
                    waitbar(fr/totframe,waittracking);
                    if length(tosave)==8
                        GenTracking
                    elseif length(tosave)==7
                        GenImDiff
                    elseif length(tosave)==4
                        GenImDiff
                        GenTracking
                    end
                end
                close(waittracking)
                set(hand(7),'enable','on');
                set(hand(8),'enable','on');
                set(hand(9),'enable','on');
                set(hand(20),'enable','on');
                if length(tosave)==8 | length(tosave)==4
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
                else
                    savetrack{1}='y';
                end
                savetrack=inputdlg('Are you happy?(y/n)','Save offline tracking');
                if savetrack{1}=='y'
                    
                    if length(tosave)==8
                        PosMat(:,2:3)=PosMat(:,2:3)*pixratio;
                        saveas(review,[nameFile 'review.fig']);
                        saveas(review,[ nameFile 'review.png']);
                        save('PosMat.mat','PosMat')
                        try
                            save('InfoTrackingOffline.mat','pixratio','ref','mask','smaller_object_size','BW_threshold','shape_ratio','strsz','bigger_object_size','-append')
                        catch
                            save('InfoTrackingOffline.mat','pixratio','ref','mask','smaller_object_size','BW_threshold','shape_ratio','strsz','bigger_object_size')
                        end
                        close(review);
                        go=0;
                    elseif length(tosave)==7
                        im_diff(:,2)=im_diff(:,2)*pixratio;
                        save('Imdiff.mat','im_diff')
                        try
                            save('InfoTrackingOffline.mat','pixratio','mask','ref','smaller_object_size_imdiff','BW_threshold_imdiff','-append')
                        catch
                            save('InfoTrackingOffline.mat','pixratio','ref','mask','smaller_object_size_imdiff','BW_threshold_imdiff')
                        end
                        go=0;
                    elseif length(tosave)==4
                        PosMat(:,2:3)=PosMat(:,2:3)*pixratio;
                        im_diff(:,2)=im_diff(:,2)*pixratio;
                        saveas(review,[nameFile 'review.fig']);
                        saveas(review,[ nameFile 'review.png']);
                        save('PosMat.mat','PosMat')
                        save('Imdiff.mat','im_diff')
                        try
                                                        save('InfoTrackingOffline.mat','pixratio','ref','mask','smaller_object_size','BW_threshold','shape_ratio',...
                                                        'strsz','bigger_object_size','smaller_object_size_imdiff','BW_threshold_imdiff','-append')
                        catch
                                                        save('InfoTrackingOffline.mat','pixratio','ref','mask','smaller_object_size','BW_threshold','shape_ratio',...
                                                        'strsz','bigger_object_size','smaller_object_size_imdiff','BW_threshold_imdiff','-append')
                        end
                        close(review);
                        go=0;
                    end
                else
                    go=0;
                    
                end
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
                set(hand(20),'enable','off');
            elseif length(playwhat)==13
                go=2;
                nanind=1;
                set(hand(7),'enable','off');
                set(hand(9),'enable','off');
                set(hand(20),'enable','off');
            else
                go=0;
            end
        end
        
        function stop_vid(~,~)
            choice=questdlg('Do you need to improve tracking? ','what to do?','No','Track offline','Add to batch','No');
            if  length(choice)==13
                go=3;
                nanind=1E7;
                set(hand(7),'enable','off');
                set(hand(8),'enable','off');
                set(hand(9),'enable','off');
                set(hand(20),'enable','off');
            elseif length(choice)==2
                go=0;
                nanind=1E7;
                set(hand(7),'enable','on');
                set(hand(9),'enable','on');
                set(hand(20),'enable','on');
            elseif length(choice)== 12
                go=0;
                nanind=1E7;
                set(hand(7),'enable','on');
                set(hand(9),'enable','on');
                set(hand(20),'enable','on');
                batchlist{1,batchnum}=type;
                batchlist{2,batchnum}=PathName;
                if type==1
                    batchlist{3,batchnum}='';
                else
                    batchlist{3,batchnum}=nameFile;
                end
                tosave=questdlg('What do you want to save','Save to file','Tracking','Im Diff','Both','Both');
                if length(tosave)==8
                    batchlist{4,batchnum}=0;
                    try
                        save('InfoTrackingOffline.mat','pixratio','ref','mask','smaller_object_size','BW_threshold','shape_ratio','strsz','-append')
                    catch
                        save('InfoTrackingOffline.mat','pixratio','ref','mask','smaller_object_size','BW_threshold','shape_ratio','strsz')
                    end
                    go=0;
                elseif length(tosave)==7
                    batchlist{4,batchnum}=1;
                    try
                        save('InfoTrackingOffline.mat','pixratio','mask','ref','smaller_object_size_imdiff','BW_threshold_imdiff','-append')
                    catch
                        save('InfoTrackingOffline.mat','pixratio','ref','mask','smaller_object_size_imdiff','BW_threshold_imdiff')
                    end
                    go=0;
                elseif length(tosave)==4
                    batchlist{4,batchnum}=2;
                    try
                                                        save('InfoTrackingOffline.mat','pixratio','ref','mask','smaller_object_size','BW_threshold','shape_ratio',...
                                                        'strsz','bigger_object_size','smaller_object_size_imdiff','BW_threshold_imdiff','-append')
                    catch
                                                        save('InfoTrackingOffline.mat','pixratio','ref','mask','smaller_object_size','BW_threshold','shape_ratio',...
                                                        'strsz','bigger_object_size','smaller_object_size_imdiff','BW_threshold_imdiff','-append')
                    end
                    go=0;
                    
                end
                batchnum=batchnum+1;
                options.Resize='on';
                options.WindowStyle='normal';
                enlargebatch=inputdlg('Do you want to add some files with same parameters only vids? (y/n)','Enlarge Batch',1,{'n'},options);
                
                if enlargebatch{1}=='y'
                    [nameFileB,PathNameB]=uigetfile({'*.avi';'*.mpg';'*.wmv';'*.mov'},'Choose','MultiSelect','on');
                    for b=batchnum:batchnum+size(nameFileB,2)-1
                        batchlist{1,b}=batchlist{1,batchnum-1};
                        batchlist{2,b}=PathNameB;
                        batchlist{3,b}=cell2mat(nameFileB(:,b-batchnum+1));
                        batchlist{4,b}=batchlist{4,batchnum-1};
                    end
                    batchnum=batchnum+size(nameFileB,2)+1;
                end
            end
        end
        
        function Done(~,~)
            start=0;
            go=0;
            nanind=1E7;
            for handdel=[7,8,9,10,20]
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
                availinfo(1)=exist('InfoTracking.mat');
                availinfo(2)=exist('InfoTrackingOffline.mat');
                [~,indavail]=max(availinfo);
                indavail=max(indavail);
                filenameinfotracking{1}='InfoTracking.mat';
                filenameinfotracking{2}='InfoTrackingOffline.mat';
                ref=load(filenameinfotracking{indavail},'ref');
                ref=struct2array(ref);
                private=1;
                cd(PathName);
                if size(ref,1)==0
                    
                    
                    msgbox('No reference found, cannot proceed','No ref !!','waarn')
                end
            catch
                try
                    cd ..
                    
                    availinfo(1)=exist('InfoTracking.mat');
                    availinfo(2)=exist('InfoTrackingOffline.mat');
                    [~,indavail]=max(availinfo);
                    indavail=max(indavail);
                    filenameinfotracking{1}='InfoTracking.mat';
                    filenameinfotracking{2}='InfoTrackingOffline.mat';
                    ref=load(filenameinfotracking{indavail},'ref');ref=struct2array(ref);
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
            
            totframe=length(index);
            keyboard
            datas=load(NameLis{index(1)});datas=struct2array(datas);
            t1=datas.time;
            IM=datas.image;
            datas=load(NameLis{index(totframe)});datas=struct2array(datas);
            t2=datas.time;
            [l2,l1] = size(ref);
            typical_size = 5*sqrt(l1*l2);
                    try,durmax=etime(t2,t1); catch, durmax=t2; end
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
                intvar=load(filenameinfotracking{indavail});
                try, BW_threshold=intvar.BW_threshold; catch,  BW_threshold=0; end
                try, smaller_object_size=intvar.smaller_object_size; catch,  smaller_object_size=0; end
                try, shape_ratio=intvar.shape_ratio; catch,  shape_ratio=0; end
                try, BW_threshold_imdiff=intvar.BW_threshold_imdiff; catch,  BW_threshold_imdiff=0; end
                try, smaller_object_size_imdiff=intvar.smaller_object_size_imdiff; catch,  smaller_object_size_imdiff=0; end
                try, bigger_object_size=intvar.bigger_object_size; catch,  bigger_object_size=0; end
                try, strsz=intvar.strsz; se = strel('disk',strsz);catch,  strsz=0; se = strel('disk',strsz);end
                
                cd(PathName);
            catch
                cd(PathName);
            end
            
            try
                if private==0
                    cd ..
                end
                intvar=load(filenameinfotracking{indavail},'pixratio');
                pixratio=intvar.pixratio;
                cd(PathName);
            catch
                cd(PathName);
                PathName
                getpixrat=questdlg('There is no pixel ratio, do you want to get the scale?','Scale Tracking','yes','no','yes');
                if length(getpixrat)==3
                    
                    
                    GenPixelRatio
                else
                    pixratio=1;
                end
            end
        end
        
        function GetVidInfo
            [nameFile,PathName,FilterIndex] =  uigetfile({'*.avi';'*.mpg';'*.wmv';'*.mov'});
            disp('loading file, be patient')
            cd(eval(strcat('''',PathName,'''')))
            OBJ = VideoReader(nameFile);
            totframe = get(OBJ, 'numberOfFrames');
            fcy=1./get(OBJ, 'FrameRate');
            vidFrames = read(OBJ,1);
            IM=uint8(double(vidFrames(:,:,3,1)));
            [l2,l1] = size(IM);
            typical_size = 5*sqrt(l1*l2);
            durmax=fcy*totframe;
            nx = l2/10;
            ny = l1/10;
            occupation = zeros(ny,nx);
            RGBoccupation=zeros(size(occupation,1),size(occupation,2),3); %matrice couleur
            availinfo(1)=exist('InfoTracking.mat');
            availinfo(2)=exist('InfoTrackingOffline.mat');
            [~,indavail]=max(availinfo);
            indavail=max(indavail);
            disp('file loaded')
            filenameinfotracking{1}='InfoTracking.mat';
            filenameinfotracking{2}='InfoTrackingOffline.mat';
            try
                PosMat=load('PosMat.mat');PosMat=struct2array(PosMat);
            end
            
            try
                ref=load(filenameinfotracking{indavail},'ref');ref=struct2array(ref);
                if size(ref,1)==0
                    msgbox('No reference found, cannot proceed','No ref !!','waarn')
                end
            catch
                msgbox('No reference found, cannot proceed','No ref !!','waarn')
                
            end
            
            try
                intvar=load(filenameinfotracking{indavail},'pixratio');
                pixratio=intvar.pixratio;
            catch
                getpixrat=questdlg('There is no pixel ratio, do you want to get the scale?','Scale Tracking','yes','no','yes');
                if length(getpixrat)==3
                    GenPixelRatio
                else
                    pixratio=1;
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
            
            
            try, BW_threshold=intvar.BW_threshold; catch,  BW_threshold=0; end
            try, smaller_object_size=intvar.smaller_object_size; catch,  smaller_object_size=0; end
            try, shape_ratio=intvar.shape_ratio; catch,  shape_ratio=0; end
            try, BW_threshold_imdiff=intvar.BW_threshold_imdiff; catch,  BW_threshold_imdiff=0; end
            try, smaller_object_size_imdiff=intvar.smaller_object_size_imdiff; catch,  smaller_object_size_imdiff=0; end
            try, bigger_object_size=intvar.bigger_object_size; catch,  bigger_object_size=0; end
            try, strsz=intvar.strsz;   se = strel('disk',strsz);catch,  strsz=0; se = strel('disk',strsz);end
            
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
        h = imagesc(IM);
        new_ref=subplot(2,2,3);
        j = imagesc(IM);
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
                    IM=uint8(double(vidFrames(:,:,3,1)));
                    chrono=fr*fcy;
                    set(slider_time,'value',fr/totframe);
                    set(text(10),'string',num2str(chrono));
                    set(h,'Cdata',IM);
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
                    
                    ref1=refs{1};
                    ref2=refs{2};
                    set(j,'Cdata',ref1);
                    pause(0.1)
                    where=inputdlg('Where is the mouse? Top/Bottom/Left/Right','Mouse location');
                    subplot(new_ref)
                    [x,y]=ginput(1);
                    
                    if where{1}=='B'
                        ref=[ref1(1:floor(y),:);ref2(floor(y)+1:end,:)];
                    elseif where{1}=='T'
                        ref=[ref2(1:floor(y),:);ref1(floor(y)+1:end,:)];
                    elseif where{1}=='R'
                        ref=[ref1(:,1:floor(x)),ref2(:,floor(x)+1:end)];
                    elseif where{1}=='L'
                        ref=[ref2(:,1:floor(x)),ref1(:,floor(x)+1:end)];
                    end
                    set(j,'Cdata',ref);
                    pause(0.1)
                    happy=questdlg('Are you happy','Save ref');
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
        
        
        close
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
            IM=uint8(double(vidFrames(:,:,3,1)));
            disp('file loaded')
        end
        
        
    end

%% Function called by the others
    function GenMask
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
        subplot(1,2,1), imagesc(IM),axis image
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
                [x1,y1,BW,y2]=roipoly(IM);
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
                [x1,y1,BW,y2]=roipoly(IM);
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
            IM=datas.image;
            
            try,chrono=etime(datas.time,t1); catch, ,chrono=datas.time; end
        elseif type==2
            vidFrames = read(OBJ,fr);
            IM=uint8(double(vidFrames(:,:,3,1)));
            chrono=fr*fcy;
        end
        %Substract reference image
        
        subimage = (ref-IM);
        subimage = uint8(double(subimage).*double(mask));
        % Convert the resulting grayscale image into a binary image.
        
        diff_im = im2bw(subimage,BW_threshold);
        diff_im1=diff_im;
        diffshow=ones(size(diff_im,1),size(diff_im,2));
        diffshow(diff_im==1)=0.1;
        diff_im=imerode(diff_im,se);
        diff_im=imdilate(diff_im,se);

        diffshow(diff_im==1)=0.6;
        % Remove all the objects less large than smaller_object_size
        diff_im = bwareaopen(diff_im,smaller_object_size);
        %bwareaopen(diff_im,2*bigger_object_size));
        %         diff_im = bwareaopen(diff_im,smaller_object_size);
        diffshow(diff_im==1)=0.9;
        if showfig==1
            subplot(bnw_watchin)
            imagesc(diffshow), colormap hot, freezeColors
            set(h,'Cdata',IM); colormap gray, freezeColors;
            
        end
        % Label all the connected components in the image.
        bw = logical(diff_im); %CHANGED
        % We get a set of properties for each labeled region.
        stats = regionprops( bw, 'Centroid','MajorAxisLength','MinorAxisLength','Area','Orientation');
        centroids = cat(1, stats.Centroid);
        maj = cat(1, stats.MajorAxisLength);
        mini = cat(1, stats.MinorAxisLength);
        rap=maj./mini;
        centroids=centroids(rap<shape_ratio,:); %CHANGED
        
        %display video, mouse position and occupation map
        
        if size(centroids) == [1 2]
            
            if showfig==1
                set(g,'Xdata',centroids(1),'YData',centroids(2))
            end
            PosMat(fr,1)=chrono;
            PosMat(fr,2)=centroids(1);
            PosMat(fr,3)=centroids(2);
            try,PosMat(fr,10)=maj;catch,PosMat(fr,10)=NaN;end
            try,PosMat(fr,11)=mini;catch,PosMat(fr,11)=NaN;end
            try,PosMat(fr,12)=stats.Area;catch,PosMat(fr,12)=NaN;end
            try,PosMat(fr,13)=stats.Orientation;catch,PosMat(fr,13)=NaN;end

            x_oc = max(round(centroids(1)/l1*nx),1);
            y_oc = max(round(centroids(2)/l2*ny),1);
            occupation(y_oc,x_oc) = occupation(y_oc,x_oc) + 1;
            
        else
            PosMat(fr,1)=chrono;
            PosMat(fr,2)=NaN;
            PosMat(fr,3)=NaN;
            PosMat(fr,10)=NaN;
            PosMat(fr,11)=NaN;
            PosMat(fr,12)=NaN;
            PosMat(fr,13)=NaN;

            nannum=nannum+1;
            if showfig==1
                set(g,'Xdata',0,'YData',0)
            end
        end
        if showfig==1
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
        
        
        
        
        %then see in which zone animal is --> open andclose door
        %accordingly, possibly deliver stimulation, record the stimulation
        %and the positionning in the PosMatmatrix
    end

    function GenImDiff
        pause(0.001)
        if type==1
            datas=load(NameLis{index(fr)});datas=struct2array(datas);
            IM=datas.image;
            try,chrono=etime(datas.time,t1); catch, ,chrono=datas.time; end
        elseif type==2
            vidFrames = read(OBJ,fr);
            IM=uint8(double(vidFrames(:,:,3,1)));
            chrono=fr*fcy;
        end
        
        if fr>1
            
            subimage = abs(OLDIM-IM);
            subimage = uint8(double(subimage).*double(mask));
            % Convert the resulting grayscale image into a binary image.
            diff_im = im2bw(subimage,BW_threshold_imdiff);
            diff_im1=diff_im;
            diffshow=ones(size(diff_im,1),size(diff_im,2));
            diffshow(diff_im==1)=0.5;
            
            % Remove all the objects less large than smaller_object_size
            diff_im = bwareaopen(diff_im,smaller_object_size_imdiff);
            diffshow(diff_im==1)=0;
            if showfig==1
                subplot(bnw_watchin)
                imagesc(diffshow)
                colormap hot, freezeColors
                set(h,'Cdata',IM);
                colormap gray, freezeColors
                
            end
            OLDIM=IM;
            im_diff(fr,1)=chrono;
            im_diff(fr,2)=sum(sum(diff_im));
            
            
        else
            OLDIM=IM;
        end
    end

    function rapport(obj,event)
        shape_ratio = (get(slider_rapport,'value')*typical_rapport);
        set(text(4),'string',num2str(shape_ratio))
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
            smaller_object_size = round(get(slider_small,'value')*typical_size*2);
            set(text(6),'string',num2str(smaller_object_size))
            nannum=0;totnum=0;
        elseif doin==1
            smaller_object_size_imdiff = round(get(slider_small,'value')*typical_size*2);
            set(text(6),'string',num2str(smaller_object_size_imdiff))
        end
    end

    function bigelimination(obj,event)
        if doin==0
            bigger_object_size = round(get(slider_big,'value')*typical_size);
            set(text(14),'string',num2str(bigger_object_size))
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

    function Toggle(obj,event)
        
        
        
        doin=mod(doin+1 ,2);
        if doin==1
            set(slider_rapport,'enable','off');
            set(slider_strel,'enable','off');
            set(slider_big,'enable','off');
            set(hand(20),'string','Toggle Tracking','BackgroundColor',button_col);
            fr=1;
            set(g,'Xdata',0,'YData',0)
            set(slider_seuil,'value',BW_threshold_imdiff);
            set(text(2),'string',num2str(BW_threshold_imdiff))
            set(slider_small,'value',smaller_object_size_imdiff/typical_size);
            set(text(6),'string',num2str(smaller_object_size_imdiff))
            
        else
            set(slider_rapport,'enable','on');
            set(slider_strel,'enable','on');
            set(slider_big,'enable','on');
            set(hand(20),'string','Toggle Im diff','BackgroundColor',button_col);
            set(slider_seuil,'value',BW_threshold);
            set(text(2),'string',num2str(BW_threshold))
            set(slider_small,'value',smaller_object_size/typical_size);
            set(text(6),'string',num2str(smaller_object_size))
            
            fr=1;
        end
    end

    function GenPixelRatio
        ratiofig=figure;
        imagesc(IM);
        title('Select length on image');
        [x,y] = ginput(2);
        distpix=sqrt((x(2)-x(1)).^2+(y(2)-y(1)).^2);
        distrel=inputdlg('Please give corresponding length in cm','length');
        pixratio=eval(distrel{1})/distpix;
        try
            save('InfoTrackingOffline.mat','pixratio','-append')
        catch
            save('InfoTrackingOffline.mat','pixratio')
        end
        delete(ratiofig);
    end



    function LaunchBatch(~,~)
        keyboard
        for b=1:batchnum-1
            try
                disp(num2str(b/batchnum))
                dobatch=1;
                cd(batchlist{2,b})
                if batchlist{1,b}==2
                    OBJ = VideoReader(batchlist{3,b});
                    totframe = get(OBJ, 'numberOfFrames');
                    fcy=1./get(OBJ, 'FrameRate');
                    durmax=fcy*totframe;
                    vidFrames = read(OBJ,1);
                    IM=uint8(double(vidFrames(:,:,3,1)));
                    [l2,l1] = size(IM);
                    nameFile=batchlist{3,b};
                else
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
                    try,durmax=etime(t2,t1); catch, durmax=t2; end
                    
                end
                typical_size = 5*sqrt(l1*l2);
                nx = l2/10;
                ny = l1/10;
                occupation = zeros(ny,nx);
                RGBoccupation=zeros(size(occupation,1),size(occupation,2),3); %matrice couleur
                fcy=durmax/totframe;
                
                try
                    PosMat=load('PosMat.mat');PosMat=struct2array(PosMat);
                end
                
                try
                    ref=load('InfoTrackingOffline.mat','ref');
                    ref=struct2array(ref);
                    if size(ref,1)==0
                        dobatch=0;
                        batchlist{5,batchnum}='no ref';
                    end
                catch
                    dobatch=0;
                    batchlist{5,batchnum}='no ref';
                end
                
                try
                    intvar=load('InfoTrackingOffline.mat','pixratio');
                    pixratio=intvar.pixratio;
                catch
                    pixratio=1;
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
                
                if batchlist{4,b}==0 | batchlist{4,b}==2
                    
                    intvar=load('InfoTrackingOffline.mat');
                    try, BW_threshold=intvar.BW_threshold; catch,  BW_threshold=0;  batchlist{5,b}='no posmat thresholds'; dobatch=0;end
                    try, smaller_object_size=intvar.smaller_object_size; catch,  smaller_object_size=0;  batchlist{5,b}='no posmat thresholds'; dobatch=0;end
                    try, shape_ratio=intvar.shape_ratio; catch,  shape_ratio=0; batchlist{5,b}='no posmat thresholds'; dobatch=0; end
                    try, bigger_object_size=intvar.bigger_object_size; catch,  bigger_object_size=0;  batchlist{5,b}='no posmat thresholds'; dobatch=0;end
                    try, strsz=intvar.strsz;   se = strel('disk',strsz);catch,  strsz=0; se = strel('disk',strsz); batchlist{5,b}='no posmat thresholds'; dobatch=0;end
                    
                end
                
                if batchlist{4,b}==1 | batchlist{4,b}==2
                    try
                        intvar=load('InfoTrackingOffline.mat');
                        BW_threshold_imdiff=intvar.BW_threshold_imdiff;
                        smaller_object_size_imdiff=intvar.smaller_object_size_imdiff;
                    catch
                        dobatch=0;
                        batchlist{5,b}='no imdiff thresholds';
                        
                    end
                end
                
                
                if dobatch==1
                    PosMat=[];
                    disp('Tracking calculation')
                    showfig=0;
                    n=1;
                    for i=1:totframe
                        
                        fr=i;
                        if batchlist{4,b}==0
                            GenTracking
                        elseif batchlist{4,b}==1
                            GenImDiff
                        elseif batchlist{4,b}==2
                            GenImDiff
                            GenTracking
                        end
                    end
                    
                    disp('Tracking done, saving')
                    if batchlist{4,b}==0 | batchlist{4,b}==2
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
                    end
                    [~,nameFile,~]=fileparts(nameFile);
                    
                    if batchlist{4,b}==0
                        PosMat(:,2:3)=PosMat(:,2:3)*pixratio;
                        saveas(review,[nameFile 'review.fig']);
                        saveas(review,[ nameFile 'review.png']);
                        save([nameFile, 'PosMat.mat'],'PosMat')
                        close(review);
                    elseif batchlist{4,b}==1
                        im_diff(:,2)=im_diff(:,2)*pixratio;
                        save([nameFile, 'Imdiff.mat'],'im_diff')
                    elseif batchlist{4,b}==2
                        PosMat(:,2:3)=PosMat(:,2:3)*pixratio;
                        im_diff(:,2)=im_diff(:,2)*pixratio;
                        saveas(review,[nameFile 'review.fig']);
                        saveas(review,[ nameFile 'review.png']);
                        save([nameFile, 'PosMat.mat'],'PosMat')
                        save([nameFile, 'Imdiff.mat'],'im_diff')
                        close(review);
                    end
                    batchlist{5,b}='OK';
                    
                end
            catch
                keyboard
            end
        end
    end


end


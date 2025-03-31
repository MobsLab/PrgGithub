function OfflineTrackingUMaze
close hidden,clear hidden
close all,clear all
warning off
% Variables required for listing correct folders
global SessOfInterest SubSession AllSess SessId
SessOfInterest = {'YourSession'};
SubSession = {{}};
n=1;
for k=1:length(SessOfInterest)
    if not(isempty(SubSession{k}))
    for l=1:length(SubSession{k})
        AllSess{n}={[SessOfInterest{k},'-',SubSession{k}{l}]};
        SessId{n}=[k,l];
        n=n+1;
    end
    else
        AllSess{n}={SessOfInterest{k}};
        SessId{n}=[k,1];
        n=n+1;

    end
end
AllSess=strjoin(AllSess,'|');
global FolderNameAllUMaze

% Tracking Variables
IM=[];image_temp=[]; FzZone_temp=[];
global maxsrndsz SrdZone; maxsrndsz=[]; SrdZone=20;

n=1;MaskStats=[];
global PosMat
global im_diff
PosMat=[]; im_diff=[];
ref=[];mask=[];pixratio=1; % (real in m / pixels)
BW_threshold=0; smaller_object_size=0; shape_ratio=0;
BW_threshold_imdiff=0; smaller_object_size_imdiff=0;
intvar=[];datas=[];
fr=1; chrono=0; durmax=[];t1=[]; fcy=0.05; totframe=[];
h=[];g=[];gbad=[];
nannum=0; totnum=0;
nx=1;ny=1;l1=0;l2=0;
nameFile=''; PathName=''; NameLis=[];index=[]; private=1;
inter_col=copper(5);
button_col=inter_col(3,:);
slider_speed=[];slider_seuil=[];slider_rapport=[];slider_small=[];slider_time=[];slider_strel=[];
slider_seuil_Fz=[];slider_small_Fz=[];slider_srndsz=[];
strsz=2;maxsrtsz=20;        se = strel('disk',strsz);
typical_rapport=8; typical_size=0; accel=1;
hand=[]; showfig=1;bnw_watchin=[];ratiofig=[];text=[];bnw_watchin_FZ=[];
barName=[]; FzQuantif=[];
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
    'callback', @track, 'enable','off');

hand(3)=uicontrol(hand(1),'style','pushbutton',...
    'units','normalized',...
    'position',[0.01 0.75 0.8/9 0.05],...
    'string','Get Folders',...
    'tag','launchbatch',...
    'callback', @GetAllFolders);

hand(4)=uicontrol(hand(1),'style','popup',...
    'units','normalized',...
    'position',[0.01 0.65 0.8/9 0.05],...
    'string',AllSess,...
    'callback',@SetSessionToTrack,...
    'enable','off');

hand(5)=uicontrol(hand(1),'style','text',...
    'units','normalized',...
    'position',[0.5 0.9 0.2 0.1],...
    'string','NoLocation');

%% Track from Matlab generated frames

    function track(~,~)
        
        for y=2:3
            set(hand(y),'enable','off');
        end
        start=1;
        figure(hand(1));
        watchin=subplot(3,2,1);
        h = imagesc(ref);
        axis image
        hold on
        g=plot(0,0,'msq','MarkerFaceColor','m','MarkerSize',10);
        gbad=plot(0,0,'k*');
        bnw_watchin=subplot(3,8,9:11);
        imagesc(uint8(ones(size(ref,1),size(ref,2))));
        bnw_watchin_FZ=subplot(3,8,17:19);
        imagesc(uint8(ones(size(ref,1),size(ref,2))));
        FzQuantif=subplot(3,8,20);
        barName=bar(1,2);
        ylim([0 0.2])
        
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
        slider_speed = uicontrol(hand(1),'style','slider',...
            'units','normalized',...
            'position',[0.5 0.1 0.02 0.7],...
            'callback', @vid_speed);
        text(7)=uicontrol(hand(1),'style','text', ...
            'units','normalized',...
            'position',[0.5 0.8 0.02 0.1],...
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
            'position',[0.55 0.8 0.02 0.1],...
            'string','time of vid');
        text(10)=uicontrol(hand(1),'style','text', ...
            'units','normalized',...
            'position',[0.55 0.05 0.02 0.03],...
            'string',num2str(chrono));
        set(slider_time,'value',fr/totframe);
        
        slider_seuil = uicontrol(hand(1),'style','slider',...
            'units','normalized',...
            'position',[0.6 0.1 0.02 0.7],...
            'callback', @seuil);
        text(1)=uicontrol(hand(1),'style','text', ...
            'units','normalized',...
            'position',[0.6 0.8 0.02 0.1],...
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
            'position',[0.65 0.8 0.02 0.1],...
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
            'position',[0.7 0.8 0.02 0.1],...
            'string','min sz');
        text(6)=uicontrol(hand(1),'style','text', ...
            'units','normalized',...
            'position',[0.7 0.05 0.02 0.03],...
            'string',num2str(smaller_object_size));
        set(slider_small,'value',smaller_object_size/typical_size);
        
        
        slider_strel = uicontrol(hand(1),'style','slider',...
            'units','normalized',...
            'position',[0.75 0.1 0.02 0.7],...
            'callback', @strelsize);
        text(11)=uicontrol(hand(1),'style','text', ...
            'units','normalized',...
            'position',[0.75 0.8 0.02 0.1],...
            'string','strl sz');
        text(12)=uicontrol(hand(1),'style','text', ...
            'units','normalized',...
            'position',[0.75 0.05 0.02 0.03],...
            'string',num2str(strsz));
        set(slider_strel,'value',strsz/maxsrtsz);
        set(slider_time,'value',fr/totframe);
        
        slider_seuil_Fz = uicontrol(hand(1),'style','slider',...
            'units','normalized',...
            'position',[0.8 0.1 0.02 0.7],...
            'callback', @seuil_Fz);
        text(13)=uicontrol(hand(1),'style','text', ...
            'units','normalized',...
            'position',[0.8 0.8 0.02 0.1],...
            'string','thr.');
        text(14)=uicontrol(hand(1),'style','text', ...
            'units','normalized',...
            'position',[0.8 0.05 0.02 0.03],...
            'string',num2str(BW_threshold_imdiff));
        set(slider_seuil_Fz,'value',BW_threshold_imdiff);
        
        
        slider_small_Fz=uicontrol(hand(1),'style','slider',...
            'units','normalized',...
            'position',[0.85 0.1 0.02 0.7],...
            'callback', @elimination_Fz);
        text(15)=uicontrol(hand(1),'style','text', ...
            'units','normalized',...
            'position',[0.85 0.8 0.02 0.1],...
            'string','min sz');
        text(16)=uicontrol(hand(1),'style','text', ...
            'units','normalized',...
            'position',[0.85 0.05 0.02 0.03],...
            'string',num2str(smaller_object_size_imdiff));
        set(slider_small_Fz,'value',smaller_object_size_imdiff/typical_size);
        
        slider_srndsz = uicontrol(hand(1),'style','slider',...
            'units','normalized',...
            'position',[0.9 0.1 0.02 0.7],...
            'callback', @setsrndsz);
        text(17)=uicontrol(hand(1),'style','text', ...
            'units','normalized',...
            'position',[0.9 0.8 0.02 0.1],...
            'string','srd sz');
        text(18)=uicontrol(hand(1),'style','text', ...
            'units','normalized',...
            'position',[0.9 0.05 0.02 0.03],...
            'string',num2str(SrdZone));
        set(slider_srndsz,'Value',SrdZone/maxsrndsz);
        
        pause(0.1)
        fr=1;
        go=0;
        while start==1
            pause(0.001)
            while (go==1)
                showfig=1;
                GenTracking
                
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
        end
        
        function make_mask(~,~)
            GenMask
        end
        
        function play_vid(~,~)
            start=1;
                go=1;
                nanind=1E7;
                set(hand(7),'enable','off');
                set(hand(9),'enable','off');
                set(hand(5),'enable','off');
        end
        
        function stop_vid(~,~)
            go=0;
            nanind=1E7;
            set(hand(7),'enable','on');
            set(hand(9),'enable','on');
            set(hand(5),'enable','on');
        end
        
        function Done(~,~)
            
            cd(FolderNameAllUMaze{1}{1,1})
            save('InfoTrackingOffline.mat','BW_threshold','BW_threshold_imdiff','shape_ratio',...
                'SrdZone','smaller_object_size','smaller_object_size_imdiff','se','-append');
            
            start=0;
            go=0;
            disp('done')
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
        
        datas=load(NameLis{index(fr)});datas=struct2array(datas);
        IM=datas.image;
        try,chrono=etime(datas.time,t1); catch, ,chrono=datas.time; end
        
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
        diffshow(diff_im==1)=0.9;
        if showfig==1
            subplot(bnw_watchin)
            imagesc(diffshow), colormap hot, freezeColors
            set(h,'Cdata',IM); colormap gray, freezeColors;
        end
        
        % Label all the connected components in the image.
        bw = logical(diff_im); %CHANGED
        % We get a set of properties for each labeled region.
        stats = regionprops( bw, 'Centroid','MajorAxisLength','MinorAxisLength','Area');
        centroids = cat(1, stats.Centroid);
        maj = cat(1, stats.MajorAxisLength);
        mini = cat(1, stats.MinorAxisLength);
        rap=maj./mini;
        badcentroids=centroids(rap>shape_ratio,:); %CHANGED
        centroids=centroids(rap<shape_ratio,:); %CHANGED
        
        %display video, mouse position
        if size(centroids) == [1 2]
            if showfig==1
                set(g,'Xdata',centroids(1),'YData',centroids(2))
                if not(isempty(badcentroids))
                    set(gbad,'Xdata',badcentroids(:,1),'YData',badcentroids(:,2))
                end
            end
            PosMat(fr,1)=chrono;
            PosMat(fr,2)=centroids(1);
            PosMat(fr,3)=centroids(2);
            
            if fr>3
                FzZone=roipoly([1:l1],[1:l2],IM,[centroids(1)-SrdZone centroids(1)-SrdZone centroids(1)+SrdZone centroids(1)+SrdZone],...
                    [centroids(2)-SrdZone centroids(2)+SrdZone centroids(2)+SrdZone centroids(2)-SrdZone]);
                PixelsUsed=sum(sum(double(FzZone).*double(mask)+double(FzZone_temp).*double(mask)));
                
                % Convert the resulting grayscale image into a binary image.
                diff_im_FZ = im2bw(subimage,BW_threshold_imdiff);
                diff_im1=diff_im_FZ;
                diffshow=ones(size(diff_im_FZ,1),size(diff_im_FZ,2));
                diffshow(FzZone==1)=0.5;
                
                immob_IM = double(diff_im_FZ).*double(FzZone) - double(image_temp).*double(FzZone_temp);
                % Remove all the objects less large than smaller_object_size
                immob_IM = bwareaopen(immob_IM,smaller_object_size_imdiff);
                diffshow(immob_IM==1)=0.2;
                image_temp=diff_im_FZ;
                FzZone_temp=FzZone;
                
                set(barName,'YData',(sum(sum(((immob_IM).*(immob_IM)))))./PixelsUsed);
                
                figure(hand(1))
                
            else
                diffshow=diff_im;
                image_temp=diff_im;
                FzZone_temp=mask;
                PixelsUsed=SrdZone*SrdZone;
            end
            
            if showfig==1
                subplot(bnw_watchin_FZ)
                imagesc(diffshow), colormap hot, freezeColors
            end
            
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
            image_temp=diff_im;
            FzZone_temp=mask;
            
        end
        if showfig==1
            subplot(bnw_watchin)
            title(strcat('nans since last change :',num2str(double(nannum/totnum))))
        end
        n=n+1;
        
        
        %then see in which zone animal is --> open andclose door
        %accordingly, possibly deliver stimulation, record the stimulation
        %and the positionning in the PosMatmatrix
    end


    function rapport(obj,event)
        shape_ratio = (get(slider_rapport,'value')*typical_rapport);
        set(text(4),'string',num2str(shape_ratio))
        nannum=0;totnum=0;
    end

    function seuil(obj,event)
        BW_threshold = get( slider_seuil, 'value');
        set(text(2),'string',num2str(BW_threshold))
        nannum=0;totnum=0;
    end

    function seuil_Fz(obj,event)
        BW_threshold_imdiff = get( slider_seuil_Fz, 'value');
        set(text(14),'string',num2str(BW_threshold_imdiff))
    end

    function elimination(obj,event)
        smaller_object_size = round(get(slider_small,'value')*typical_size);
        set(text(6),'string',num2str(smaller_object_size))
        nannum=0;totnum=0;
    end

    function elimination_Fz(obj,event)
        smaller_object_size_imdiff = round(get(slider_small_Fz,'value')*typical_size/100);
        set(text(16),'string',num2str(smaller_object_size_imdiff))
    end

    function strelsize(~,~)
        strsz = round(get(slider_strel,'value')*maxsrtsz);
        se = strel('disk',strsz);
        set(text(12),'string',num2str(strsz));
        nannum=0;totnum=0;
    end

    function setsrndsz(~,~)
        SrdZone = round(get(slider_srndsz,'value')*maxsrndsz);
        set(text(18),'string',num2str(SrdZone));
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
        pixratio=eval(distrel{1})/distpix;
        try
            save('InfoTrackingOffline.mat','pixratio','-append')
        catch
            save('InfoTrackingOffline.mat','pixratio')
        end
        delete(ratiofig);
    end



    function GetAllFolders(obj,event)
        FolderNameAllUMaze={};
        DirName=uigetdir('','Choose folder containing the folder with all the frames');
        cd(DirName)
        
        load('behavResources.mat','mask','ref','pixratio')
        save('InfoTrackingOffline.mat','mask','ref','pixratio')
        clear('mask','ref','pixratio')
        FolderNameAllUMaze{1}{1,1}= [cd filesep];
        RawList=dir;
        RawList=RawList([RawList.isdir]);
        FoldNumAllFrames=find(~cellfun(@isempty,(strfind({RawList.name}, 'F'))));
        FolderNameAllUMaze{2}{1,1}= [RawList(FoldNumAllFrames).name];
                set(hand(4),'enable','on')

    end
    

    function SetSessionToTrack(obj,event)
        cd(FolderNameAllUMaze{1}{1,1})
        load('InfoTrackingOffline.mat','ref','pixratio','mask')
        AllSess=strsplit(AllSess,'|');
        set(hand(5),'string',AllSess{get(obj,'value')});
        AllSess=strjoin(AllSess,'|');
        cd(FolderNameAllUMaze{2}{1,1})
        lis=dir;
        index=[];
        for i=1:length(lis)
            NameLis{i}=lis(i).name;
            if strfind(NameLis{i},'frame')
                index=[index,i];
            end
        end
        totframe=length(index);
        datas=load(NameLis{index(1)});datas=struct2array(datas);
        try,t1=datas.time;cach,keyboard;end
        IM=datas.image;
        datas=load(NameLis{index(totframe)});datas=struct2array(datas);
        t2=datas.time;
        MaskStats=regionprops(logical(mask),'Area');
        [l2,l1] = size(ref);
        typical_size = MaskStats.Area/5;
        maxsrndsz=MaskStats.Area/200;
        try,durmax=etime(t2,t1); catch, durmax=t2; end
        fcy=durmax/totframe;
        set(hand(2),'enable','on');
        image_temp=zeros(l2,l1);
        FzZone_temp=zeros(l2,l1);
    end


end


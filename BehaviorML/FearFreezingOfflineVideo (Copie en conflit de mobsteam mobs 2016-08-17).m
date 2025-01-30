function FearFreezingOffline(~,~)
% get in the folder of frameFolder e.g. F03112014-0001
% play start
%
% see FearFreezingOfflineVideo.m for retracking on video
% info:
% OfflineTrackingFinal_V4.m problem pixratio
% Tracking_offline_OnVideo.m and Tracking_offline_OnFrames.m for behavioData except freezing (step for
% Immobility scoring)

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% %%%%%%%%%%%%%%%%%%%%%%% DECLARE VARIABLE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

global BW_threshold2; BW_threshold2=0.4;
global smaller_object_size2; smaller_object_size2=130;
global shape_ratio2; shape_ratio2=4;
global ref2;
global mask;
global th_immob;
global imageRef;
global enableTrack;
global guireg_fig;
global name_folder;
global maxyaxis; maxyaxis=200;
global ymax; ymax=10;
global maxfrvis; maxfrvis=800;
global thimmobline;
global Dodisplay;Dodisplay=1; 
global SaveTracking;
global Ffile;
res=pwd;
if isempty(strfind(res,'/')),mark='\'; else  mark='/';end

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% %%%%%%%%%%%%%%%%%%%%%%%% GENERATE FIGURE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Fig_Odor=figure('units','normalized','position',[0.1 0.1 0.25 0.85],'Color',[ 0 0 0],...
    'numbertitle','off','name','Freezing','menubar','none','tag','FeerFreezingOffline');

maskbutton(1)= uicontrol(Fig_Odor,'style','pushbutton',...
    'units','normalized','position',[0.01 0.89 0.2 0.05],...
    'string','1- INPUTS EXPE','callback', @giv_inputs);

maskbutton(2)= uicontrol(Fig_Odor,'style','pushbutton',...
    'units','normalized','position',[0.01 0.73 0.2 0.05],...
    'string','2- Real Distance','callback', @Real_distance);

maskbutton(3)= uicontrol(Fig_Odor,'style','pushbutton',...
    'units','normalized','position',[0.01 0.63 0.2 0.05],...
    'string','3- ReDo Mask','callback', @Redo_mask);

maskbutton(4)= uicontrol(Fig_Odor,'style','pushbutton',...
    'units','normalized','position',[0.01 0.48 0.2 0.05],...
    'string','4- START tracking','callback', @Track_Freeze);

maskbutton(5)= uicontrol(Fig_Odor,'style','pushbutton',...
    'units','normalized','position',[0.01 0.25 0.2 0.05],...
    'string','DISPLAY ON/OFF','callback', @Do_display);

maskbutton(7)= uicontrol(Fig_Odor,'style','pushbutton',...
    'units','normalized','position',[0.025 0.36 0.15 0.03],...
    'string','Stop Emergency','callback', @stop_Phase);

maskbutton(8)= uicontrol(Fig_Odor,'style','pushbutton',...
    'units','normalized','position',[0.01 0.03 0.2 0.05],...
    'string','CLOSE figure','callback', @quit);
set(maskbutton(8),'enable','on','FontWeight','bold')

chronoshow=uicontrol('style','edit', 'units','normalized','position',[0.01 0.4 0.1 0.05],...
    'string',num2str(floor(0)),'ForegroundColor','g','BackgroundColor','k','FontSize',14);

inputDisplay(1)=uicontrol(Fig_Odor,'style','text','units','normalized','position',[0.25 0.95 0.5 0.02],...
    'string','info = ready','FontSize',12,'BackgroundColor',[0 0 0],'ForegroundColor','w','FontWeight','bold');
for bi=[1:5,7],set(maskbutton(bi),'enable','off');end

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% %%%%%%%%%%%%%%%%%%%%%%%%%% GET FRAMES %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

set(inputDisplay(1),'string','getting Behavior.mat and frame folder... WAIT');
pause(1);
try
    temp=load([res,mark,'Behavior.mat']);
    disp('Loading existing info from Behavior.mat')
    imageRef=temp.imageRef; disp('imageRef loaded...')
    mask=temp.mask; disp('mask loaded...')
    th_immob=temp.th_immob; disp(['th_immob = ',num2str(th_immob)])
    
    BW_threshold2=temp.BW_threshold2;
    smaller_object_size2=temp.smaller_object_size2;
    shape_ratio2=temp.shape_ratio2;
    Ratio_IMAonREAL=temp.Ratio_IMAonREAL;
    %Dodisplay=temp.Dodisplay; 
    try
        Ffile=temp.Ffile;
        try 
                OBJ = mmreader(Ffile);
            catch
                OBJ = VideoReader(Ffile);
        end
        numframe = get(OBJ, 'numberOfFrames');
        fcy=get(OBJ, 'FrameRate');
    end
catch
    
            [Ffile,PathName,FilterIndex] =  uigetfile({'*.avi';'*.mpg';'*.wmv';'*.mov'});
            cd(eval(strcat('''',PathName,'''')))
            disp('loading file, be patient')
            try 
                OBJ = mmreader(Ffile);
            catch
                OBJ = VideoReader(Ffile);
            end
            numframe = get(OBJ, 'numberOfFrames');
            %fcy=1./get(OBJ, 'FrameRate');
            fcy=get(OBJ, 'FrameRate');
            %durmax=fcy*numframe;
            vidFrames = read(OBJ,1);
            IM=uint8(double(vidFrames(:,:,3,1)));
            IM_1=IM;
            disp('file loaded')
            imageRef= max(max(double(IM)))*ones(size(IM));disp('white Ref builf from 1st frame of the video...')
            
            mask=ones(size(IM,1),size(IM,2));
            
end
% 
% % find folder with frames
% list=dir;
% for i=1:length(list)
%     if strcmp(list(i).name(1),'F') && strcmp(list(i).name(end-4:end-1),'-000')
%         Ffile=list(i).name;
%     end
% end
% try disp(['Loading Frame from ',Ffile]), catch, close(Fig_Odor);error('no frame folder found');end
% name_folder=[res,mark,Ffile];


% list=dir(Ffile); 
% i=3;
% if exist('imageRef','var') && ~isempty(imageRef)
%     ref2=double(imageRef);
% else
%     while ~strcmp(list(i).name(1:5),'frame'), i=i+1;end
%     temp=load([Ffile,mark,list(i).name]);
%     ref2=double(temp.datas.image);imageRef=temp.datas.image;
% end

if ~exist('mask','var') || (exist('mask','var') && isempty(mask))
    mask=ones(size(ref2,1),size(ref2,2));
end
mask=double(mask);
ref2=double(imageRef);
subplot(5,1,1:2),imagesc(ref2.*mask);colormap gray,axis image
% saving
try
    save([res,mark,'TempFreezeON.mat'],'-append','name_folder','imageRef','mask',...
        'BW_threshold2','smaller_object_size2','shape_ratio2');
catch
    save([res,mark,'TempFreezeON.mat'],'name_folder','imageRef','mask',...
        'BW_threshold2','smaller_object_size2','shape_ratio2');
end

set(inputDisplay(1),'string',['getting Behavior.mat and frame from ',Ffile]);
set(maskbutton(1),'enable','on','FontWeight','bold')

%if exist('Inputs_for_PainHabData','file')~=0
if exist('Inputs_for_PainData_22souris.mat','file')
    
    Track_Freeze;
end

% -----------------------------------------------------------------
%% function to quit the programm
    function quit(obj,event)
        enableTrack=0;
        try close(guireg_fig);end
        delete(Fig_Odor)
    end

% -----------------------------------------------------------------
%% Ask for all inputs and display
    function giv_inputs(obj,event)
        
        default_answer={'1.5','2','5'};
        
        answer = inputdlg({'Thresh immobility (mm)','Drop intervals (s)','Smooth Factor'},'INFO',1,default_answer);
        
        th_immob=str2num(answer{1});
        thtps_immob=str2num(answer{2});
        SmoothFact=str2num(answer{3});
        set(maskbutton(1),'enable','on','FontWeight','normal')
        if exist('Ratio_IMAonREAL','var') && ~isempty(Ratio_IMAonREAL)
            set(maskbutton(2),'enable','on','FontWeight','normal','string','2- Real Distance (OK)')
            set(maskbutton(3),'enable','on','FontWeight','bold')
            set(maskbutton(4),'enable','on','FontWeight','bold')
        else
            set(maskbutton(2),'enable','on','FontWeight','bold')
        end
        save([res,mark,'TempFreezeON.mat'],'-append','th_immob','thtps_immob','SmoothFact');
    end

% -----------------------------------------------------------------
%% Ask for all inputs and display
    function Real_distance(obj,event)
        
        figure(Fig_Odor), subplot(5,1,3:4),
        
        imagesc(IM_1); colormap gray; axis image
        title('Click on two points to define a distance','Color','w')
        for j=1:2
            [x,y]=ginput(1);
            hold on, plot(x,y,'+r')
            x1(j)=x; y1(j)=y;
        end
        line(x1,y1,'Color','r','Linewidth',2)
        
        answer = inputdlg({'Enter real distance (cm):'},'Define Real distance',1,{'40'});
        text(mean(x1)+10,mean(y1)+10,[answer{1},' cm'],'Color','r')
        
        d_xy=sqrt((diff(x1)^2+diff(y1)^2));
        Ratio_IMAonREAL=d_xy/str2num(answer{1});
        
        title(' do 2-')
        hold on, line([10 20]*Ratio_IMAonREAL,[10 10],'Color','k','Linewidth',3)
        text(15*Ratio_IMAonREAL,15,'10 cm','Color','k')
        
        Ratio_IMAonREAL=Ratio_IMAonREAL;
        save([res,mark,'TempFreezeON.mat'],'-append','Ratio_IMAonREAL');
        set(maskbutton(2),'enable','on','FontWeight','normal','string','2- Real Distance (OK)')
        set(maskbutton(3),'enable','on','FontWeight','bold')
        set(maskbutton(4),'enable','on','FontWeight','bold')
    end

% -----------------------------------------------------------------
%% redo mask if necessary

    function Redo_mask(obj,event)
        ref2=IM_1;
        mask=ones(size(ref2,1),size(ref2,2));
        figure(Fig_Odor), subplot(5,1,3:4), imagesc(ref2),axis image
        [x1,y1,BW,y2]=roipoly(uint8(ref2));
        maskint=uint8(BW);
        mask=double(mask).*double(maskint);
        
        colormap gray
        ref2((find(mask==0)))=0;
        imagesc(ref2),axis image
        save([res,mark,'TempFreezeON.mat'],'-append','mask');
        set(maskbutton(3),'enable','on','FontWeight','normal','string','3- new mask (OK)')
        set(maskbutton(4),'enable','on','FontWeight','bold')
    end


% -----------------------------------------------------------------
%% track mouse
    function Track_Freeze(obj,event)
        
        enableTrack=1;
        SaveTracking=1;
        set(maskbutton(5),'enable','on')
        set(maskbutton(7),'enable','on')
        set(maskbutton(4),'enable','off')
        chrono=0;
        disp('   Begining tracking...')
        guireg_fig=OnlineGuiReglage;
        
        % -------------------
        % reload everything
        tempLoad=load([res,mark,'TempFreezeON.mat']);
        imageRef=tempLoad.imageRef;
        Ratio_IMAonREAL=tempLoad.Ratio_IMAonREAL;
        th_immob=tempLoad.th_immob;
        thtps_immob=tempLoad.thtps_immob;
        name_folder=tempLoad.name_folder;
        mask=tempLoad.mask;
        
        figure(Fig_Odor), subplot(5,1,1:2), hold on,
        htrack = imagesc(imageRef);axis image;
        line([10 20]*Ratio_IMAonREAL,[10 10],'Color','k','Linewidth',3)
        text(15*Ratio_IMAonREAL,15,'10 cm','Color','k')
        title('ACQUISITION ON')
        g=plot(0,0,'m+');axis image;
        
        figure(Fig_Odor), subplot(5,1,3:4),
        htrack2 = imagesc(zeros(size((imageRef))));
        axis image;colormap hot; caxis([0 1])
        xlabel('tracking online','Color','w')
        
        immob_val=0;
        figure(Fig_Odor), subplot(5,1,5)
        hold off, PlotFreez=plot(0,'-b');
        hold on, thimmobline=line([1,2000],[1 1]*th_immob,'Color','r');
        xlim([0,maxfrvis]); xlabel('freezing online','Color','w')
        
        
        % -----------------------------------------------------------------
        % ---------------------- INITIATE TRACKING ------------------------
        n=1;
        num_fr=1;
        vidFrames = read(OBJ,num_fr);
        IM=uint8(double(vidFrames(:,:,3,num_fr)));
        
%         while length(list(num_fr).name)<5 || ~strcmp(list(num_fr).name(1:5),'frame'), 
%             num_fr=num_fr+1;
%         end
        % temp=load([name_folder,mark,list(num_fr).name]);
        %tDeb=temp.datas.time;
        tDeb=0;
        
        num_fin=numframe;
%         while length(list(num_fin).name)<5 || ~strcmp(list(num_fin).name(1:5),'frame'), 
%             num_fin=num_fin-1;
%         end
       % temp=load([name_folder,mark,list(num_fin).name]);
        n_AutoStop=round(num_fin/fcy);
        
        num_fr_f=1;
        diffshow=zeros(size((imageRef)));
        
        PosMat=[];
        clear Movtsd
        
        TimeFreez=0; 
        %tDeb = clock; timeDeb = tDeb(4)*60*60+tDeb(5)*60+tDeb(6);
        clear image_temp
        
        while enableTrack
            
            %temp=load([name_folder,mark,list(num_fr).name]);
            % load frame
            
            
            % ---------------------------------------------------------
            % update chrono
            t1 = num_fr/fcy;
            chrono=t1;
            set(chronoshow,'string',[num2str(floor(chrono)),'/',num2str(n_AutoStop)]);
            
            vidFrames = read(OBJ,num_fr);
            IM=double(vidFrames(:,:,3,1));
            
            
            %IM=getsnapshot(vid);
            if Dodisplay, set(htrack,'Cdata',IM);end
            
            % ---------------------------------------------------------
            % --------------------- TREAT IMAGE -----------------------
            % Substract reference image
            subim = (imageRef-IM);
            subim = uint8(double(subim).*double(mask));
            % Convert the resulting grayscale image into a binary image.
            diff_im = im2bw(subim,BW_threshold2);
            % Remove all the objects less large than smaller_object_size
            diff_im = bwareaopen(diff_im,smaller_object_size2);
            % Label all the connected components in the image.
            bw = logical(diff_im); %CHANGED
            if n==2
                image_temp=bw;
            end
            % ---------------------------------------------------------
            % --------------------- FREEZING -----------------------
            
            % Every five images
            if  mod(n,3)==0
                immob_IM = bw - image_temp;
                diffshow=ones(size(immob_IM,1),size(immob_IM,2));
                diffshow(bw==1)=0;
                %                 immob_IM=imerode(immob_IM,se);
                diffshow(immob_IM==1)=0.4;
                diffshow(immob_IM==-1)=0.7;
                immob_val(num_fr_f,1)=(sum(sum(((immob_IM).*(immob_IM)))))/Ratio_IMAonREAL.^2;
                immob_val(num_fr_f,2)=chrono;
                image_temp=bw;
                num_fr_f=num_fr_f+1;
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
            
            % ---------------------------------------------------------
            % display video, mouse position and save in posmat

            if Dodisplay
                set(htrack2,'Cdata',diffshow);
                %pause(0.1)
            end
            if size(centroids) == [1 2]
                if Dodisplay, set(g,'Xdata',centroids(1),'YData',centroids(2));end
                PosMat(num_fr,1)=chrono;
                PosMat(num_fr,2)=centroids(1)/Ratio_IMAonREAL;
                PosMat(num_fr,3)=centroids(2)/Ratio_IMAonREAL;
                PosMat(num_fr,4)=0;
                
            else
                if Dodisplay, set(g,'Xdata',0,'YData',0);end
                PosMat(num_fr,:)=[chrono;NaN;NaN;NaN];
            end
            
            try set(PlotFreez,'YData',immob_val(max(1,num_fr_f-maxfrvis):end,1)); end
            figure(Fig_Odor), subplot(5,1,5)
            set(gca,'Ylim',[0 max(ymax,1)]);
            
            
            if num_fr==num_fin; enableTrack=0; end
            num_fr=num_fr+1;
            n = n+1;
        end
        
        
        % calculate freezing
        Movtsd=tsd(immob_val(:,2)*1E4',SmoothDec(immob_val(:,1)',1));
        try FreezeEpoch=thresholdIntervals(Movtsd,th_immob,'Direction','Below');
            FreezeEpoch=mergeCloseIntervals(FreezeEpoch,0.3*1E4);
            FreezeEpoch=dropShortIntervals(FreezeEpoch,thtps_immob*1E4);
            Freeze=sum(End(FreezeEpoch)-Start(FreezeEpoch));
        catch
            Freeze=NaN;
            Freeze2=NaN;
        end
        
        
        save TempFreezeON -append PosMat FreezeEpoch Movtsd Freeze
        pause(1)
        if SaveTracking
            msg_box=msgbox('Saving behavioral Information.. WAIT','save','modal');
            disp('Saving in TempFreezeON.mat and new Behavior.mat')
            try
                temp=load('Behavior.mat');
                StimInfo=temp.StimInfo;
                save TempFreezeON -append StimInfo
                disp('StimInfo has been taken from old Behavior.mat')
                pause(1)
            end
            try 
                movefile('Behavior.mat','oldBehavior.mat');
                disp('old Behavior.mat has been renamed oldBehavior.mat')
                pause(1)
            end
            copyfile('TempFreezeON.mat','Behavior.mat')
            pause(1)
            close(msg_box)
        else
            disp('Stop Emergency : variables saved only in TempFreezeON !')
        end
          % display
        try
            close(guireg_fig)
            set(maskbutton(7),'enable','off')
            set(maskbutton(4),'enable','on')
        end
        
        % figure
        figure('Color',[1 1 1]), subplot(2,3,1:3)
        plot(Range(Movtsd,'s'),Data(Movtsd),'k')
        hold on
        for k=1:length(Start(FreezeEpoch))
            plot(Range(Restrict(Movtsd,subset(FreezeEpoch,k)),'s'),Data(Restrict(Movtsd,subset(FreezeEpoch,k))),'c')
        end
        try
            for k=1:length(StimInfo(:,1))-1
                if StimInfo(k,2)==7
                    plot([StimInfo(k,1):StimInfo(k,1)+30],0.5,'b','linewidth',2)
                elseif StimInfo(k,2)==6
                    plot(StimInfo(k,1),0.5,'r.','MarkerSize',20)
                elseif StimInfo(k,2)==5
                    plot([StimInfo(k,1):StimInfo(k,1)+30],0.5,'g')
                end
            end
        end
        title('Raw Data')
        subplot(2,3,4)
        try
            CSplInt=intervalSet(StimInfo(StimInfo(:,2)==7,1)*1e4,(StimInfo(StimInfo(:,2)==7,1)+29)*1e4);
            CSmiInt=intervalSet(StimInfo(StimInfo(:,2)==5,1)*1e4,(StimInfo(StimInfo(:,2)==5,1)+29)*1e4);
            bar([mean(Data(Restrict(Movtsd,CSplInt))),mean(Data(Restrict(Movtsd,CSmiInt)))])
            set(gca,'Xticklabel',{'CS+','CS-'})
            title('Average movement during sounds')
        end
        subplot(2,3,5)
        % percentage of freezing during CS+ and CS-
        try
            bar([length(Data(Restrict(Movtsd,and(FreezeEpoch,CSplInt))))/length(Data(Restrict(Movtsd,CSplInt))),...
                length(Data(Restrict(Movtsd,and(FreezeEpoch,CSmiInt))))/length(Data(Restrict(Movtsd,CSmiInt)))])
            set(gca,'Xticklabel',{'CS-','CS+'})
            title('Freezing during sounds')
        end
        
        try
            if ~isempty(strfind(res,'EXT'))
                subplot(2,3,6)
                CsminPer=intervalSet(0,408*1e4);
                CspluPer1=intervalSet(408*1e4,789*1e4);
                CspluPer2=intervalSet(789*1e4,1117*1e4);
                CspluPer3=intervalSet(1117*1e4,1400*1e4);
                bar([length(Data(Restrict(Movtsd,and(Ep,CsminPer))))/length(Data(Restrict(Movtsd,CsminPer))),...
                    length(Data(Restrict(Movtsd,and(Ep,CspluPer1))))/length(Data(Restrict(Movtsd,CspluPer1))),...
                    length(Data(Restrict(Movtsd,and(Ep,CspluPer2))))/length(Data(Restrict(Movtsd,CspluPer2))),...
                    length(Data(Restrict(Movtsd,and(Ep,CspluPer3))))/length(Data(Restrict(Movtsd,CspluPer3)))])
                set(gca,'Xticklabel',{'CS-','CS+1','CS+2','CS+3'})
                title('Freezing over entire Epochs')
            end
        end
    end

% -----------------------------------------------------------------
%% stop tracking
    function stop_Phase(obj,event)
        figure(Fig_Odor), subplot(5,1,1:2), title('ACQUISITION STOPPED')
        enableTrack=0;
        SaveTracking=0;
        close(guireg_fig)
        set(maskbutton(4),'enable','on')
        set(maskbutton(5),'enable','off')
    end

% -----------------------------------------------------------------
%% stop tracking
    function Do_display(obj,event)
        Dodisplay=abs(Dodisplay-1);
        if Dodisplay
            set(maskbutton(5),'string','DISPLAY ON')
        else
            set(maskbutton(5),'string','DISPLAY OFF')
        end
    end


% -----------------------------------------------------------------
%% OnlineGuiReglage
    function guireg_fig=OnlineGuiReglage(obj,event);
        
        % function guireg_fig=OnlineGuiReglage(obj,event);
        % let online control of paramteres for image treatments
        
        if ~exist('typical_size','var'), typical_size=300;end
        typical_rapport=10;
        
        guireg_fig=figure('units','normalized',...
            'position',[0.1 0.1 0.15 0.6],...
            'numbertitle','off',...
            'name','Online Mouse Tracking : Setting Parameters',...
            'menubar','none',...
            'tag','figure reglage');
        set(guireg_fig,'Color',[0 0 0]);
        
        hand(2)=uicontrol(guireg_fig,'style','pushbutton',...
            'units','normalized',...
            'position',[0.05 0.9 0.9 0.05],...
            'string','Stop for Manual Inputs',...
            'tag','init',...
            'callback', @enterManual);
        
        text1=uicontrol(guireg_fig,'style','text', ...
            'units','normalized',...
            'position',[0.01 0.85 0.20 0.05],...
            'string','seuil couleur');
        
        text2=uicontrol(guireg_fig,'style','text', ...
            'units','normalized',...
            'position',[0.21 0.85 0.20 0.05],...
            'string','seuil objets');
        
        text3=uicontrol(guireg_fig,'style','text', ...
            'units','normalized',...
            'position',[0.41 0.85 0.20 0.05],...
            'string','rapport axes');
        
        text4=uicontrol(guireg_fig,'style','text', ...
            'units','normalized',...
            'position',[0.61 0.85 0.20 0.05],...
            'string','freezing threshold');
        
        text5=uicontrol(guireg_fig,'style','text', ...
            'units','normalized',...
            'position',[0.81 0.85 0.20 0.05],...
            'string','Yaxis');
        
        slider_seuil = uicontrol(guireg_fig,'style','slider',...
            'units','normalized',...
            'position',[0.05 0.1 0.08 0.7],...
            'callback', @seuil);
        set(slider_seuil,'Value',BW_threshold2);
        
        slider_small=uicontrol(guireg_fig,'style','slider',...
            'units','normalized',...
            'position',[0.25 0.1 0.08 0.7],...
            'callback', @elimination);
        set(slider_small,'Value',smaller_object_size2/typical_size);
        
        slider_rapport = uicontrol(guireg_fig,'style','slider',...
            'units','normalized',...
            'position',[0.45 0.1 0.08 0.7],...
            'callback', @rapport);
        set(slider_rapport,'Value',shape_ratio2/typical_rapport);
        
          slider_freeze = uicontrol(guireg_fig,'style','slider',...
            'units','normalized',...
            'position',[0.65 0.1 0.08 0.7],...
            'callback', @freeze_thresh);
        set(slider_freeze,'Value',th_immob/30);
        
        
        slider_yaxis = uicontrol(guireg_fig,'style','slider',...
            'units','normalized',...
            'position',[0.85 0.1 0.08 0.7],...
            'callback', @fixyaxis);
                set(slider_yaxis,'Value',ymax/maxyaxis);

        text6=uicontrol(guireg_fig,'style','text', ...
            'units','normalized',...
            'position',[0.01 0.05 0.20 0.03],...
            'string',num2str(BW_threshold2));
        
        
        text7=uicontrol(guireg_fig,'style','text', ...
            'units','normalized',...
            'position',[0.21 0.05 0.20 0.03],...
            'string',num2str(smaller_object_size2));
        
        
        text8=uicontrol(guireg_fig,'style','text', ...
            'units','normalized',...
            'position',[0.41 0.05 0.20 0.03],...
            'string',num2str(shape_ratio2));
        
        text9=uicontrol(guireg_fig,'style','text', ...
            'units','normalized',...
            'position',[0.61 0.05 0.20 0.03],...
            'string',num2str(th_immob));
        
        text10=uicontrol(guireg_fig,'style','text', ...
            'units','normalized',...
            'position',[0.81 0.05 0.20 0.03],...
            'string',num2str(ymax));
        
        function seuil(obj,event)
            
            BW_threshold2 = get(slider_seuil, 'value');
            set(text6,'string',num2str(BW_threshold2))
            %             disp([' New BW_threshold=',num2str(BW_threshold2)])
        end
        %get threshold value
        function elimination(obj,event)
            smaller_object_size2 = round(get(slider_small,'value')*typical_size);
            set(text7,'string',num2str(smaller_object_size2))
            %             disp(['   New smaller_object_size=',num2str(smaller_object_size2)])
        end
        function rapport(obj,event)
            shape_ratio2 = (get(slider_rapport,'value')*typical_rapport);
            set(text8,'string',num2str(shape_ratio2))
            %             disp(['     New shape_ratio=',num2str(shape_ratio2)])
        end
        
        function freeze_thresh(obj,event)
            th_immob = (get(slider_freeze,'value')*150);
            set(text9,'string',num2str(th_immob))
            %             disp(['     New freezing threshold=',num2str(th_immob)])
            set(thimmobline,'Ydata',[1,1]*th_immob)
        end
        
        function fixyaxis(~,~)
            ymax = round(get(slider_yaxis,'value')*maxyaxis);
            set(text10,'string',num2str(ymax));
        end
        
        function enterManual(obj,event)
            defAns={num2str(BW_threshold2) num2str(smaller_object_size2) num2str(shape_ratio2)};
            prompt = {'BW_threshold','smaller_object_size','shape_ratio'};
            dlg_title = 'Change parameters for offline tracking:';
            answer = inputdlg(prompt,dlg_title,1,defAns);
            BW_threshold2=str2num(answer{1});
            smaller_object_size2=str2num(answer{2});
            shape_ratio2=str2num(answer{3});
            
            set(slider_seuil,'Value',BW_threshold2);
            set(slider_small,'Value',smaller_object_size2/typical_size);
            set(slider_rapport,'Value',shape_ratio2/typical_rapport);
        end
    end
end
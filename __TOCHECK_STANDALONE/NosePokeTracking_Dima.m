function [numF,filename]=NosePokeTracking_Dima(~,~)
% same as FearFreezingOnline but 
%- do not send TTL for CS and shocks
% receive TTL from imetronic
%% INPUTS
% global
clear global name_folder imageRef Ratio_IMAonREAL
clear global enableTrack intermed
global a
global vid
global chrono
global name_folder
global imageRef
global Ratio_IMAonREAL
global DiodMask
global DiodThresh
global enableTrack
global intermed
global maxfrvis
maxfrvis=800;

global BW_threshold;
global smaller_object_size;
global shape_ratio2;
global Count_Freez
global th_immob; th_immob=0.1;
global thimmobline
global TTLOUT
TTLOUT=[];
global maxyaxis
maxyaxis=200;
global ymax
ymax=10;
global PlotFreez

global n_AutoStop
global num_exp
global StartChrono
global tDeb
global guireg_fig
global countDown
global t_ON
global t_OFF
global namePhase
global TTL
global nmouse;
global nameTASK;
global numPhase;
global numAmp;

intermed=load('InfoTrackingTemp.mat');
imageRef=intermed.ref;
% BW_threshold=intermed.BW_threshold;
% smaller_object_size=intermed.smaller_object_size;
% shape_ratio2=intermed.shape_ratio;
b_default=intermed.b_default;
c_default=intermed.c_default;
e_default=intermed.e_default;

nPhase=NaN;
StartChrono=0;
% INITIATE
color_on = [ 0 0 0];
color_off = [1 1 1];
colori={'g','r','c'};
scrsz = get(0,'ScreenSize');
frame_rate = 8;
prefac0=0;
num_exp=0;

% anNoying problems
res=pwd;
if isempty(strfind(res,'/')),mark='\'; else  mark='/';end

t=clock;
jour=num2str(t(3));if length(jour)==1, jour=cat(2,'0',jour);end
mois=num2str(t(2));if length(mois)==1, mois=cat(2,'0',mois);end
annee=num2str(t(1));
TodayIs=[jour mois annee];




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% graphical interface n�1 with all the pushbuttons

Fig_Odor=figure('units','normalized','position',[0.1 0.1 0.4 0.85],...
    'numbertitle','off','name','NosePoke','menubar','none','tag','figure Odor');
set(Fig_Odor,'Color',color_on);

InputButton= uicontrol(Fig_Odor,'style','pushbutton',...
    'units','normalized','position',[0.01 0.9 0.2 0.05],...
    'string','1- INPUTS EXPE','callback', @giv_inputs);
set(InputButton,'enable','on','FontWeight','bold')

DistanceButton= uicontrol(Fig_Odor,'style','pushbutton',...
    'units','normalized','position',[0.01 0.8 0.2 0.05],...
    'string','2- Real Distance','callback', @Real_distance);
set(DistanceButton,'enable','off')

DiodButton= uicontrol(Fig_Odor,'style','pushbutton',...
    'units','normalized','position',[0.01 0.7 0.2 0.05],...
    'string','3-GetLightZone','callback', @GetLightZone);
set(DiodButton,'enable','off')

StartButton= uicontrol(Fig_Odor,'style','pushbutton',...
    'units','normalized','position',[0.01 0.57 0.2 0.05],'string','4- START session');
set(StartButton,'enable','off','callback', @StartSession)

StopButton= uicontrol(Fig_Odor,'style','pushbutton',...
    'units','normalized','position',[0.01 0.15 0.2 0.05],'string','3- STOP session');
set(StopButton,'enable','off','callback', @StopSession)


QuitButton= uicontrol(Fig_Odor,'style','pushbutton',...
    'units','normalized','position',[0.01 0.05 0.2 0.05],...
    'string','CLOSE EXPE','callback', @quit);
set(QuitButton,'enable','on','FontWeight','bold')

inputDisplay(1)=uicontrol(Fig_Odor,'style','text','units','normalized','position',[0.25 0.55 0.5 0.02],'string','Filename = TO DEFINE','FontSize',10);
chronoshow=uicontrol(Fig_Odor,'style','text','units','normalized','position',[0.01 0.02 0.1 0.02],...
    'string',num2str(0),'BackgroundColor','k','ForegroundColor','w');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CALLED FUNCTIONS

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
        
%         strfcts=strjoin(nametypes,'|');
%         u2=uicontrol(Fig_Odor,'Style', 'popup','String', strfcts,'units','normalized',...
%             'Position', [0.01 0.84 0.2 0.05],'Callback', @setprotoc);
%         
%         function setprotoc(obj,event)
%             fctname=get(obj,'value');
%             namePhase='Testing';
%             savProtoc;
%         end
%         
%         function savProtoc(obj,event)
%         
        answer = inputdlg({'NumberMouse','Session Type','SessionNumber', 'Voltage'},'SessionInfo',1,{'0','MFB','1','8'});
        
        nmouse=str2num(answer{1});
        nPhase=1;
        startphase=1;
        countDown=0;
                
        nameTASK=answer{2};
        numPhase=str2num(answer{3});
        numAmp = str2num(answer{4});
        % create folder to save tracking and analysis
        % ----------------------
        prefac=num2str(numPhase);
        if length(prefac)==1, prefac=cat(2,'0',prefac);end
        name_folder=['NosePoke-Mouse-' num2str(nmouse) '-' nameTASK '-' prefac '-' num2str(numAmp) 'V-' TodayIs '-'];
        
        trynumber=1;
        name_foldertemp=[name_folder,'0'];
        while exist(name_foldertemp,'file')
            name_foldertemp=[name_folder,num2str(trynumber,'%02g')];
            trynumber=trynumber+1;
        end
        name_folder=name_foldertemp;
        
        mkdir(name_folder);
        disp(name_folder)
        
        
        if exist('Ratio_IMAonREAL','var') && ~isempty(Ratio_IMAonREAL)
            set(StartButton,'enable','on','FontWeight','bold')
            set(SetVoltSlider,'enable','on','FontWeight','normal','string','2- Real Distance (OK)')
        end
        
        disp(' ');disp('-------------------- New Expe ---------------------');
        save([res,mark,'TempNosePokeInfo.mat'],'nmouse','nameTASK','numPhase');
        set(InputButton,'FontWeight','normal','string','1- INPUTS EXPE (OK)');
        set(DistanceButton,'enable','on');

        end
%     end

% -----------------------------------------------------------------
%% Ask for all inputs and display
    function Real_distance(obj,event)
        
        figure(Fig_Odor), subplot(5,1,1:2),
        imagesc(imageRef); colormap gray; axis image
        title('Click on two points to define a distance','Color','w')
        for j=1:2
            [x,y]=ginput(1);
            hold on, plot(x,y,'+r')
            x1(j)=x; y1(j)=y;
        end
        line(x1,y1,'Color','r','Linewidth',2)
        
        answer = inputdlg({'Enter real distance (cm):'},'Define Real distance',1,{'35'});
        text(mean(x1)+10,mean(y1)+10,[answer{1},' cm'],'Color','r')
        
        d_xy=sqrt((diff(x1)^2+diff(y1)^2));
        Ratio_IMAonREAL=d_xy/str2num(answer{1});
        
        title(' do 2-')
        hold on, line([10 20]*Ratio_IMAonREAL,[10 10],'Color','k','Linewidth',3)
        text(15*Ratio_IMAonREAL,15,'10 cm','Color','k')
        set(DiodButton,'enable','on','FontWeight','bold')
        
        Ratio_IMAonREAL=Ratio_IMAonREAL;
        save([res,mark,'TempNosePokeInfo.mat'],'-append','Ratio_IMAonREAL');
    end    
        
        function GetLightZone(obj,event)
        
        LightZone=figure; subplot(5,1,1:4),
        imagesc(imageRef); colormap gray; axis image
        title('Select Diode Zone','Color','w')
        [~,~,DiodMask,~]=roipoly(imageRef);
        
        DiodMask=uint8(DiodMask);
        fwrite(a,5);
        temp=clock();
        vals=[];
        while etime(clock,temp)<10
            trigger(vid);
            IM=getdata(vid,1,'uint8');
            vals=[vals,sum(sum(IM.*DiodMask))];
        end
        LightZoneFig=figure; subplot(5,1,5),
        plot(vals);
        title('select threshold')
        [~,DiodThresh]=ginput(1);
        close(LightZoneFig)
        close(LightZone);
        save([res,mark,'TempNosePokeInfo.mat'],'-append','DiodMask','DiodThresh');
        set(StartButton,'enable','on','FontWeight','bold')
        end
           
    
% -----------------------------------------------------------------
%% Interface of analysis
    function StartSession(obj,event)
        enableTrack=1;
        fwrite(a,8);
        templaod=load([res,mark,'TempNosePokeInfo.mat']);
        set(StopButton,'enable','on')
        num_exp=0;
        num_phase=templaod.numPhase;
        StartChrono=0;
        prefix=['NosePoke-Mouse-' num2str(templaod.nmouse) '-' templaod.nameTASK '-' num2str(numPhase) '-' TodayIs '-'];
        set(StartButton,'enable','off','FontWeight','normal')
        set(InputButton,'enable','off','FontWeight','normal')
        set(DistanceButton,'enable','off','FontWeight','normal')
        set(DiodButton,'enable','off','FontWeight','normal')
         StartChrono=1;
         tDeb = clock;

        commnum=1;
        chrono=0;
        set(chronoshow,'string',num2str(0));
        num_exp=num_exp+1;
        disp('   Begining tracking...')
        guireg_fig=OnlineGuiReglage;
        % -------------------
        % reload everything
        
        % -------------------
        % display zone
        
        figure(Fig_Odor), subplot(5,1,1:2),
        htrack = imagesc(imageRef);axis image;
        line([10 20]*Ratio_IMAonREAL,[10 10],'Color','k','Linewidth',3)
        text(15*Ratio_IMAonREAL,15,'10 cm','Color','k')
        title('ACQUISITION ON')
        g=plot(0,0,'m+');
        
        figure(Fig_Odor), subplot(5,1,3:4),
        htrack2 = imagesc(zeros(size((imageRef))));axis image;colormap gray; caxis([0 1])
        xlabel('tracking online','Color','w')
        
        im_diff=0;
        figure(Fig_Odor), subplot(5,1,5)
        hold off, PlotFreez=plot(0,'-b');
        hold on, thimmobline=line([1,2000],[1 1]*th_immob,'Color','r');
        xlim([0,maxfrvis]); xlabel('freezing online','Color','w')
        % display chrono
        time_image = 1/frame_rate;
        
        
        % -----------------------------------------------------------------
        % ---------------------- INITIATE TRACKING ------------------------
        n=1;
        num_fr=1; num_fr_f=1;
        diffshow=zeros(size((imageRef)));
        prefac0=char; for ii=1:4-length(num2str(num_exp)), prefac0=cat(2,prefac0,'0'); end
        Fname=['F' TodayIs '-' prefac0 num2str(num_exp)];
        mkdir([name_folder mark Fname]);
        disp(['   ',Fname]);
        
        PosMat=[]; PosMatInt = [];
        PosMatInit=[];im_diff=[];
        Vtsd=[]; FreezeEpoch=[]; ZoneEpoch=[]; ZoneIndices=[]; FreezeTime=[]; Occup=[];
        Xtsd=[];Ytsd=[]; Imdifftsd=[]; x = []; nanx = []; im_diffInt = [];
        
        while enableTrack
            % ---------------------------------------------------------
            % update chrono
            t1 = clock;
            if StartChrono
                chrono=etime(t1,tDeb);
                set(chronoshow,'string',[num2str(floor(chrono)),'/',num2str(n_AutoStop)]);
            end
            % ---------------------------------------------------------
       
            %Active la cam�ra et Envoie l'image dans le workspace
            trigger(vid);
            
            IM=getdata(vid,1,'uint8');
            
            %IM=getsnapshot(vid);
            set(htrack,'Cdata',IM);
            
            % ---------------------------------------------------------
            % --------------------- TREAT IMAGE -----------------------
            % Substract reference image
            subimage = (imageRef-IM);
            subimage = uint8(double(subimage).*double(intermed.mask));
            % Convert the resulting grayscale image into a binary image.
            diff_im = im2bw(subimage,BW_threshold);
            % Remove all the objects less large than smaller_object_size
            diff_im = bwareaopen(diff_im,smaller_object_size);
            % Label all the connected components in the image.
            bw = logical(diff_im); %CHANGED
            if n==2
                image_temp=bw;
            end
            % ---------------------------------------------------------
            % --------------------- Tracking -----------------------
            
            % Every five images
            if  mod(n,3)==0
                immob_IM = bw - image_temp;
                diffshow=ones(size(immob_IM,1),size(immob_IM,2));
                diffshow(bw==1)=0;
                %                 immob_IM=imerode(immob_IM,se);
                diffshow(immob_IM==1)=0.4;
                diffshow(immob_IM==-1)=0.7;
                im_diff(num_fr_f,1)=chrono;
                im_diff(num_fr_f,2)=(sum(sum(((immob_IM).*(immob_IM)))))/Ratio_IMAonREAL.^2;
                image_temp=bw;
                num_fr_f=num_fr_f+1;
            end
            
            % count Freezing
            if Count_Freez
                set(inputDisplay(3),'string',['Time Freezing: ',num2str(floor((TimeFreez+etime(t1,t_ON))*10)/10),' s'])
            end
            % ---------------------------------------------------------
            
            
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
            % --------------------- Get Diod Value ------------------------
            if sum(sum(IM.*DiodMask))>DiodThresh
                set(Fig_Odor,'Color','r');
            else
                set(Fig_Odor,'Color','w');
            end

            % ---------------------------------------------------------
            % display video, mouse position and save in posmat
            set(htrack2,'Cdata',diffshow);
            if StartChrono
                
                
                if size(centroids) == [1 2]
                    set(g,'Xdata',centroids(1),'YData',centroids(2))
                    PosMat(num_fr,1)=chrono;
                    PosMat(num_fr,2)=centroids(1)/Ratio_IMAonREAL;
                    PosMat(num_fr,3)=centroids(2)/Ratio_IMAonREAL;
                    PosMat(num_fr,4)=0;
                    
                else
                    set(g,'Xdata',0,'YData',0)
                    PosMat(num_fr,:)=[chrono;NaN;NaN;NaN];
                end
                
                try set(PlotFreez,'YData',im_diff(max(1,num_fr_f-maxfrvis):end,2)); end
                figure(Fig_Odor), subplot(5,1,5)
                set(gca,'Ylim',[0 max(ymax,1)]);
                num_fr=num_fr+1;
                
                % ---------------------------------------------------------
                % --------------------- SAVE FRAMES -----------------------
                %hold off
                %datas.image = IM;
                datas.image =  uint8(double(IM));
                datas.time = t1;
                
                
                prefac1=char; for ii=1:6-length(num2str(n)), prefac1=cat(2,prefac1,'0');end
                save([ name_folder mark Fname mark 'frame' prefac1 sprintf('%0.5g',n)],'datas');
                n = n+1;
                
                
            end
            
            t2 = clock;
            pause(time_image-etime(t2,t1));
        end
        
%         % if no stopemergency, ready to start next phase
%         try
%             if etime(t2,tDeb)> n_AutoStop+0.5, enableTrack=1;end
%         end
%         try fwrite(a,8);end

    im_diff=im_diff(1:find(im_diff(:,1)>chrono-1,1,'last'),:);
    im_diff(im_diff(:,2)>20,2)=NaN;
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
    im_diffInt=im_diff;
    x=im_diffInt(:,2);
    nanx = isnan(x);
    t    = 1:numel(x);
    x(nanx) = interp1(t(~nanx), x(~nanx), t(nanx));
    x(isnan(x))=nanmean(x);
    im_diffInt(:,2)=x;

    PosMatInit=PosMat;
    PosMat=PosMatInt;
    im_diffInit=im_diff;
    im_diff=im_diffInt;

    Vtsd=tsd(PosMatInt(1:end-1,1)*1e4,sqrt(diff(PosMatInt(:,2)).^2+diff(PosMatInt(:,3)).^2));
    Xtsd=tsd(PosMatInt(:,1)*1e4,(PosMatInt(:,3)));
    Ytsd=tsd(PosMatInt(:,1)*1e4,(PosMatInt(:,2)));
    Imdifftsd=tsd(im_diffInt(:,1)*1e4,SmoothDec(im_diffInt(:,2)',1));

try FreezeEpoch=thresholdIntervals(Imdifftsd,th_immob,'Direction','Below');
    FreezeEpoch=mergeCloseIntervals(FreezeEpoch,0.3*1E4);
    FreezeEpoch=dropShortIntervals(FreezeEpoch,thtps_immob*1E4);
    Freeze=sum(End(FreezeEpoch)-Start(FreezeEpoch));
catch
    Freeze=NaN;
    Freeze2=NaN;
end
ref=imageRef;
mask=intermed.mask;
save([name_folder,mark,'behavResources.mat'],'PosMat','PosMatInit','im_diff','im_diffInit','frame_rate','Vtsd','ref',...
    'BW_threshold','mask','smaller_object_size','Ratio_IMAonREAL','Xtsd',...
    'Ytsd','Imdifftsd');

        
        % save and copy file in save_folder
        msg_box=msgbox('Saving behavioral Information','save','modal');
        mask=intermed.mask;
        
        try set(PlotFreez,'YData',0,'XData',0);end
       

         %% generate figure
        figbilan=figure;
        % raw data : movement over time
        subplot(2,1,1)
        plot(Range(Vtsd,'s'),Data(Vtsd)./prctile(Data(Vtsd),98),'k'), hold on
        plot(Range(Imdifftsd,'s'),Data(Imdifftsd)./prctile(Data(Imdifftsd),98),'b');
%         legend
        subplot(2,1,2)
        plot(PosMat(:,2),PosMat(:,3),'k*')
       
        saveas(figbilan,[name_folder,mark,'FigBilan.fig'])
        saveas(figbilan,[name_folder,mark,'FigBilan.png'])
        close(figbilan)
        %%
        
        % display
        try
            close(guireg_fig)
            set(Fig_Odor,'Color',color_on);
            for bi=[1,3,6:9], set(inputDisplay(bi),'BackgroundColor',color_on);end
            for bit=1:2
                set(maskbutton(bit),'enable','on','FontWeight','bold')
            end
            delete(msg_box)
            set(maskbutton(3),'enable','off','FontWeight','normal')
            set(maskbutton(7),'enable','off','FontWeight','normal')
            set(maskbutton(4),'enable','on','FontWeight','bold')
        end
        
        
        
        % -----------------------------------------------------------------
        % Manual Count freezing
        function Count_Freezing(obj,event)
            Count_Freez=abs(Count_Freez-1);
            if Count_Freez
                t_ON=clock;
                set(maskbutton(3),'BackgroundColor','g','ForegroundColor','k');
            else
                t_OFF=clock;
                TimeFreez=TimeFreez+etime(t_OFF,t_ON);
                set(maskbutton(3),'BackgroundColor','k','ForegroundColor','w');
            end
        end
        
    end

% -----------------------------------------------------------------
% %% StartSession
%     function StartSession(obj,event)
%         %pause (1) % en secondes
%         set(maskbutton(7),'enable','on','FontWeight','bold')
%         set(maskbutton(3),'enable','on','FontWeight','bold')
%         set(maskbutton(4),'enable','off','FontWeight','normal')
%         set(inputDisplay(7),'string','RECORDING');
%         StartChrono=1;
%         tDeb = clock;
%         TTL=[];
%         fwrite(a,8);
%     end

% -----------------------------------------------------------------
%% Stop Session
    function StopSession(obj,event)
        figure(Fig_Odor), subplot(5,1,1:2), title('ACQUISITION STOPPED')
        enableTrack=0;
        set(InputButton,'enable','on','FontWeight','normal')
        set(DistanceButton,'enable','on','FontWeight','bold')
        set(DiodButton,'enable','on','FontWeight','normal')
        set(StartButton,'enable','on','FontWeight','normal')
        fwrite(a,8);disp('Intan OFF');
    end
%% OnlineGuiReglage
    function guireg_fig=OnlineGuiReglage(obj,event);
        
        
        % function guireg_fig=OnlineGuiReglage(obj,event);
        % let online control of paramteres for image treatments
        
        if ~exist('typical_size','var'), typical_size=300;end
        typical_rapport=10;
        
        guireg_fig=figure('units','normalized',...
            'position',[0.1 0.1 0.4 0.6],...
            'numbertitle','off',...
            'name','Online Mouse Tracking : Setting Parameters',...
            'menubar','none',...
            'tag','figure reglage');
        set(guireg_fig,'Color',color_on);
        
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
        set(slider_seuil,'Value',BW_threshold);
        
        slider_small=uicontrol(guireg_fig,'style','slider',...
            'units','normalized',...
            'position',[0.25 0.1 0.08 0.7],...
            'callback', @elimination);
        set(slider_small,'Value',smaller_object_size/typical_size);
        
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
            'string',num2str(BW_threshold));
        
        
        text7=uicontrol(guireg_fig,'style','text', ...
            'units','normalized',...
            'position',[0.21 0.05 0.20 0.03],...
            'string',num2str(smaller_object_size));
        
        
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
            
            BW_threshold = get(slider_seuil, 'value');
            set(text6,'string',num2str(BW_threshold))
            %             disp([' New BW_threshold=',num2str(BW_threshold)])
        end
        %get threshold value
        function elimination(obj,event)
            smaller_object_size = round(get(slider_small,'value')*typical_size);
            set(text7,'string',num2str(smaller_object_size))
            %             disp(['   New smaller_object_size=',num2str(smaller_object_size)])
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
            defAns={num2str(BW_threshold) num2str(smaller_object_size) num2str(shape_ratio2)};
            prompt = {'BW_threshold','smaller_object_size','shape_ratio'};
            dlg_title = 'Change parameters for offline tracking:';
            answer = inputdlg(prompt,dlg_title,1,defAns);
            BW_threshold=str2num(answer{1});
            smaller_object_size=str2num(answer{2});
            shape_ratio2=str2num(answer{3});
            
            set(slider_seuil,'Value',BW_threshold);
            set(slider_small,'Value',smaller_object_size/typical_size);
            set(slider_rapport,'Value',shape_ratio2/typical_rapport);
        end
    end

end

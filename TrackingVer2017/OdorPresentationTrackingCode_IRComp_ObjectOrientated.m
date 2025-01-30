function [numF,filename]=OdorPresentationTrackingCode_IRComp_ObjectOrientated(~,~)
% Get global variables that are common to all codes --> code comes from
% global TrObjLocal % the video object
global TrObj
global TrObjLocal
if iscell(TrObj)
TrObjLocal = TrObj{1};
else
    TrObjLocal = TrObj;
end

global ArdMotor
global ArdImetronic

% Tracking parameters
global BW_threshold; BW_threshold=0.5;
global smaller_object_size; smaller_object_size=30;
global sm_fact; sm_fact=0;
global strsz se; strsz=4; se= strel('disk',strsz);
global SrdZone; SrdZone=20;
global dist_thresh; dist_thresh =2;

%% Variables that are specific to this code
% General thresholds and display
global guireg_fig
global time_image;time_image = 1/TrObjLocal.frame_rate;
global UpdateImage; UpdateImage=ceil(TrObjLocal.frame_rate/5); % update every n frames the picture shown on screen to show at 10Hz
global writerObj  % allows us to save as .avi
global enableTrack % Controls whether the tracking is on or not
global Zone % the Zones in the UMaze - set by the user

% Variables for plotting
global thimmobline % line that shows current freezing threshold
global PlotFreez % the name of the Plot that shows im_diff
global StartChrono, StartChrono=0; % Variable set to one when the tracking begins
% the handle of the chronometer object
global PlotForVideo % the plot that will be saved to .avi if needed
global GuiForOdors % slides with specific values for UMaze
global color_on; color_on=[0 0 0];

global ExpeInfo
% contains
% - nmouse : number of current mouse
% - lengthPhase : duration of current phase
% - nPhase : number of current phase
% - enableTrack
% - name_folder : current folder for saving
% - Fname : current foldre in which individual frames are saved

global KeepTime
KeepTime.t1=clock;
KeepTime.t2=clock;
% contains
% - t1,t2 for tracking time between frames
% - tDeb for tracking length of session ; ...
% - LastStim to recall when last stimulation was given
% - chrono to dsplay passing of time
global ShTN; ShTN =1;
global ShTN2; ShTN2 =1;

% Freezing detection
global th_immob; th_immob=20;
global thtps_immob; thtps_immob=2;
global maxyaxis ymax; maxyaxis=500;ymax=50;
global maxfrvis;maxfrvis=800;
global maxth_immob; maxth_immob=200 ;

% Time/date parameters
t=clock;
jour=num2str(t(3));if length(jour)==1, jour=cat(2,'0',jour);end
mois=num2str(t(2));if length(mois)==1, mois=cat(2,'0',mois);end
annee=num2str(t(1));
ExpeInfo.TodayIs=[jour mois annee];clear t jour mois annee

% arduino
global a % the arduino
global arduinoDictionary % list of numbers to send to arduino for each case
arduinoDictionary.On=1;
arduinoDictionary.ThousandFrames=2;
arduinoDictionary.Off=3;
arduinoDictionary.SoundStim=5;
arduinoDictionary.Sound=7;
arduinoDictionary.SendStim=9;
condition=1; %1=odor, 0=control
if condition==1;
arduinoDictionary.OdorOn=4;
arduinoDictionary.OdorOff=6;
end
if condition==0;
arduinoDictionary.OdorOn=6;
arduinoDictionary.OdorOff=4;
end
%% Task parameters
global nametypes; nametypes={'OdorExposure','OdourAndSoundTest'};
global OdorStartTimeHab; OdorStartTimeHab=[123,199,290,366,462,536,612,688,Inf];
global OdorDuration; OdorDuration= 45;
global OdorStartTimeExt; OdorStartTimeExt=[637,698,Inf];
global OdorStopTime; 
global OdorStartTime
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% graphical interface n???1 with all the pushbuttons

Fig_Odors=figure('units','normalized','position',[0.1 0.1 0.4 0.85],...
    'numbertitle','off','name','OdorProtocol','menubar','none','tag','figure Odor');
set(Fig_Odors,'Color',color_on);

maskbutton(1)= uicontrol(Fig_Odors,'style','pushbutton',...
    'units','normalized','position',[0.01 0.89 0.2 0.05],...
    'string','1- INPUTS EXPE','callback', @giv_inputs);
set(maskbutton(1),'enable','on','FontWeight','bold')

% maskbutton(3)= uicontrol(Fig_Odors,'style','pushbutton',...
%     'units','normalized','position',[0.01 0.70 0.2 0.05],'string','2 - GetBehavZones','callback',@DefineZones);
% set(maskbutton(3),'enable','off')

maskbutton(5)= uicontrol(Fig_Odors,'style','pushbutton',...
    'units','normalized','position',[0.01 0.65 0.2 0.05],...
    'string','3- START EXPE','callback', @start_Expe);
set(maskbutton(5),'enable','off')

maskbutton(4)= uicontrol(Fig_Odors,'style','pushbutton',...
    'units','normalized','position',[0.01 0.48 0.2 0.05],'string','4- START session');
set(maskbutton(4),'enable','off','callback', @StartSession)

maskbutton(7)= uicontrol(Fig_Odors,'style','pushbutton',...
    'units','normalized','position',[0.025 0.36 0.15 0.03],...
    'string','Stop Emergency','callback', @stop_Phase);
set(maskbutton(7),'enable','off')

maskbutton(8)= uicontrol(Fig_Odors,'style','pushbutton',...
    'units','normalized','position',[0.01 0.03 0.2 0.05],...
    'string','CLOSE EXPE','callback', @quit);
set(maskbutton(8),'enable','on','FontWeight','bold')


inputDisplay(1)=uicontrol(Fig_Odors,'style','text','units','normalized','position',[0.25 0.95 0.5 0.02],'string','Filename = TO DEFINE','FontSize',10);
inputDisplay(6)=uicontrol(Fig_Odors,'style','text','units','normalized','position',[0.01 0.59 0.16 0.02],'string','Session','FontSize',12);
inputDisplay(7)=uicontrol(Fig_Odors,'style','text','units','normalized','position',[0.01 0.56 0.16 0.02],'string','WAIT','FontSize',12);
inputDisplay(8)=uicontrol(Fig_Odors,'style','text','units','normalized','position',[0.01 0.95 0.2 0.02],'string','TASK = ?','FontSize',10);
inputDisplay(9)=uicontrol(Fig_Odors,'style','text','units','normalized','position',[0.01 0.81 0.16 0.06],'string','ListOfSession = ?','FontSize',10);

for bi=[1,6:9], set(inputDisplay(bi),'BackgroundColor',color_on,'ForegroundColor','w','FontWeight','bold');end

chronoshow=uicontrol('style','edit', 'units','normalized','position',[0.01 0.4 0.1 0.05],...
    'string',num2str(floor(0)),'ForegroundColor','g','BackgroundColor','k','FontSize',14);
chronostim=uicontrol('style','edit', 'units','normalized','position',[0.15 0.4 0.1 0.05],...
    'string',num2str(floor(0)),'ForegroundColor','k','BackgroundColor','k','FontSize',14);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CALLED FUNCTIONS

% -----------------------------------------------------------------
%% function to quit the programm
    function quit(obj,event)
        enableTrack=0;
        try close(guireg_fig);end
        try close(GuiForOdors);end
        delete(Fig_Odors)
    end

%% Ask for all inputs and display
    function giv_inputs(obj,event)
        
        strfcts=strjoin(nametypes,'|');
        u2=uicontrol(Fig_Odors,'Style', 'popup','String', strfcts,'units','normalized',...
            'Position', [0.01 0.84 0.2 0.05],'Callback', @setprotoc);
        
        function setprotoc(obj,event)
            fctname=get(obj,'value');
            ExpeInfo.namePhase=nametypes(fctname);ExpeInfo.namePhase=ExpeInfo.namePhase{1};
            savProtoc;
        end
        
        function savProtoc(obj,event)
            set(inputDisplay(9),'string',['Sessions:',{' '},ExpeInfo.namePhase]);
            
            if strcmp('OdorExposure',ExpeInfo.namePhase)
                ExpeInfo.lengthPhase=720;
                set(chronostim,'ForegroundColor','k');
                OdorStartTime = OdorStartTimeHab;
                OdorStopTime=OdorStartTime+OdorDuration;
            else
                ExpeInfo.lengthPhase=800;
                set(chronostim,'ForegroundColor','k');
                OdorStartTime = OdorStartTimeExt;
                OdorStopTime=OdorStartTime+OdorDuration;
            end
            
            default_answer{1}='007';
            default_answer{2}=num2str(ExpeInfo.lengthPhase);
            
            answer = inputdlg({'NumberMouse','Session duration (s)'},'INFO',1,default_answer);
            default_answer=answer; save default_answer default_answer
            
            ExpeInfo.nmouse=str2double(answer{1});
            ExpeInfo.lengthPhase=str2double(answer{2});
            ExpeInfo.nPhase=0;
            
            nameTASK='Odors';
            set(inputDisplay(8),'string',['TASK = ',nameTASK]);
            disp(' ');disp('-------------------- New Expe ---------------------');
            set(maskbutton(1),'FontWeight','normal','string','1- INPUTS EXPE (OK)');
            
            % create the motor arduino
            if isempty(ArdMotor)
                poi=inputdlg('What num arduino for motor?'); poi=str2double(poi);
                eval(['ArdMotor = serial(''COM',num2str(poi),''');']);
                try
                    fopen(ArdMotor);
                catch
                    % not very pretty
                    figure,text(0,0.4,'No Arduino motor Started');
                end
            else
                switch ArdMotor.Status
                    case 'closed'
                        try
                            fopen(ArdMotor);
                        catch
                            % not very pretty
                            figure,text(0,0.4,'No Arduino motor Started');
                        end
                        
                end
            end
            
            if strcmp('OdourAndSoundTest',ExpeInfo.namePhase)
                            if isempty(ArdImetronic)
                                poi=inputdlg('What num arduino for imetronic?'); poi=str2double(poi);
                                eval(['ArdImetronic = serial(''COM',num2str(poi),''');']);
                                try
                                    fopen(ArdImetronic);
                                catch
                                    % not very pretty
                                    figure,text(0,0.4,'No Arduino imetronic Started');
                                end
                            else
                                switch ArdImetronic.Status
                                    case 'closed'
                                        try
                                            fopen(ArdImetronic);
                                        catch
                                            % not very pretty
                                            figure,text(0,0.4,'No Arduino imetronic Started');
                                        end
                
                                end
                            end
            end
        end
        %         set(maskbutton(3),'enable','on')
        set(maskbutton(5),'enable','on')
        
    end

% -----------------------------------------------------------------
%% Interface of analysis
    function start_Expe(obj,event)
        KeepTime.t1=clock;
        KeepTime.t2=clock;
        enableTrack=1;
        StartChrono=0;
        ExpeInfo.nPhase=ExpeInfo.nPhase+1;
        ExpeInfo.name_folder=['FEAR-Mouse-' num2str(ExpeInfo.nmouse) '-' ExpeInfo.TodayIs '-' ExpeInfo.namePhase];
        
        set(maskbutton(5),'enable','on','FontWeight','normal','string','3- START EXPE (OK)')
        
        if enableTrack
            set(inputDisplay(6),'string',['Session ',num2str(ExpeInfo.nPhase),' :'])
            set(inputDisplay(7),'string','WAIT for start');
            
            % create folder to save tracking and analysis
            % ----------------------
            trynumber=1;
            name_foldertemp=[ExpeInfo.name_folder,'_00'];
            while exist(name_foldertemp,'file')
                name_foldertemp=[ExpeInfo.name_folder,'_',num2str(trynumber,'%02g')];
                trynumber=trynumber+1;
            end
            ExpeInfo.name_folder=name_foldertemp;
            
            mkdir(ExpeInfo.name_folder);
            disp(ExpeInfo.name_folder)
            
            set(inputDisplay(1),'string',ExpeInfo.name_folder);
            pause(0.1)
            StartChrono=0;
            if size(a.Status,2)==6
                try fopen(a); end
            end
            % do a NUC
            switch TrObjLocal.camera_type
                case 'IRCamera'
                    TrObjLocal.vid.RemoteControl.CameraAction.Nuc
            end
            
            set(maskbutton(4),'enable','on','FontWeight','bold')
            PerformTracking;
        end
    end

% -----------------------------------------------------------------
%% StartSession
    function StartSession(obj,event)
        % Clear the arduino
        if a.BytesAvailable>0
            fread(a,a.BytesAvailable);
        end
        % set the buttons to avoid problems
        set(maskbutton(7),'enable','on','FontWeight','bold')
        set(maskbutton(4),'enable','off','FontWeight','normal')

        %
        if strcmp('OdourAndSoundTest',ExpeInfo.namePhase)
            while ArdImetronic.BytesAvailable>0
                fread(ArdImetronic,ArdImetronic.BytesAvailable);
            end
            
            disp('ready to go')
            while ArdImetronic.BytesAvailable==0
            end

        end
        % Tell the arduino we're starting
        fwrite(a,arduinoDictionary.On);
        % Tell the experimenter we're starting
        set(inputDisplay(7),'string','RECORDING');
        % Initialize time
        KeepTime.tDeb = clock;
        KeepTime.LastStim=clock;
        % Go signal for tracking code
        StartChrono=1;
    end

% -----------------------------------------------------------------
%% track mouse
    function PerformTracking(obj,event)
        
        KeepTime.chrono=0;
        set(chronoshow,'string',num2str(0));
        disp('Begining tracking...')
        guireg_fig=Tracking_OnlineGuiReglage;
        UMaze_OnlineGuiReglage;
        
        % -------------------
        % display zone
        
        figure(Fig_Odors),
        PlotForVideo=subplot(5,1,1:2);
        htrack = imagesc(TrObjLocal.ref);axis image; hold on
        line([10 20]*TrObjLocal.Ratio_IMAonREAL,[10 10],'Color','k','Linewidth',3)
        text(15*TrObjLocal.Ratio_IMAonREAL,15,'10 cm','Color','k')
        title('ACQUISITION ON')
        caxis([0.1 0.9])
        
        figure(Fig_Odors), subplot(5,1,3:4),
        htrack2 = imagesc(zeros(size((TrObjLocal.ref))));axis image; caxis([0 1]); hold on
        xlabel('tracking online','Color','w')
        g=plot(0,0,'m+');
        
        im_diff=0;
        figure(Fig_Odors), subplot(5,5,22:25)
        PlotFreez=plot(0,0,'-b');
        hold on, thimmobline=line([1,2000],[1 1]*th_immob,'Color','r');
        xlim([0,maxfrvis]);
        
        % -----------------------------------------------------------------
        % ---------------------- INITIATE TRACKING ------------------------
        n=1; % number of file that saves frames
        num_fr=1; % number of frames
        diffshow=zeros(size((TrObjLocal.ref)));
        
        % To save individual frames
        prefac0=char; for ii=1:4, prefac0=cat(2,prefac0,'0'); end
        ExpeInfo.Fname=['F' ExpeInfo.TodayIs '-' prefac0];
        disp(['   ',ExpeInfo.Fname]);
        mkdir([ExpeInfo.name_folder filesep ExpeInfo.Fname]);
        
        % To save as a compressed file
        writerObj = VideoWriter([ExpeInfo.name_folder filesep ExpeInfo.Fname '.avi']);
        open(writerObj);
        
        MouseTemp=[]; PosMat=[];im_diff=[];ZoneEpoch=[]; ZoneIndices=[]; FreezeTime=[]; Occup=[];
        GotFrame = [];
        
        IM=TrObjLocal.GetAFrame;
        
        OldIm=TrObjLocal.mask;
        OldZone=TrObjLocal.mask;
        
        while enableTrack
            
            % Activate the camera and send the image to the workspace
            pause(time_image-etime(KeepTime.t2,KeepTime.t1));
            IM=TrObjLocal.GetAFrame;
            IM(IM<0)=0;
            
            % ---------------------------------------------------------
            % update KeepTime.chrono
            KeepTime.t1 = clock;
            if StartChrono
                KeepTime.chrono=etime(KeepTime.t1,KeepTime.tDeb);
                set(chronoshow,'string',[num2str(floor(KeepTime.chrono)),'/',num2str(ExpeInfo.lengthPhase)]);
            end
            
            % display video, mouse position and save in posmat
            if StartChrono
                
                
                % find the mouse and calculate quantity of movement
                [Pos,ImDiff,PixelsUsed,NewIm,FzZone]=Track_ImDiff(IM,TrObjLocal.mask,TrObjLocal.ref,BW_threshold,smaller_object_size,sm_fact,se,SrdZone,...
                    TrObjLocal.Ratio_IMAonREAL,OldIm,OldZone,TrObjLocal.camera_type);
                
                if sum(isnan(Pos))==0
                    PosMat(num_fr,1)=KeepTime.chrono;
                    PosMat(num_fr,2)=Pos(1);
                    PosMat(num_fr,3)=Pos(2);
                    PosMat(num_fr,4)=0;
                    im_diff(num_fr,1)=KeepTime.chrono;
                    im_diff(num_fr,2)=ImDiff;
                    im_diff(num_fr,3)=PixelsUsed;
                    switch TrObjLocal.camera_type
                        case 'IRCamera'
                            MouseTemp(num_fr,1)=KeepTime.chrono;
                            MouseTemp(num_fr,2)=max(max(IM.*FzZone));
                        case 'Webcam'
                            MouseTemp(num_fr,1:2)=[KeepTime.chrono;NaN];
                    end
                else
                    PosMat(num_fr,:)=[KeepTime.chrono;NaN;NaN;NaN];
                    im_diff(num_fr,1:3)=[KeepTime.chrono;NaN;NaN];
                    MouseTemp(num_fr,1:2)=[KeepTime.chrono;NaN];
                end
                
                % Update displays at 5Hz - faster would just be a waste of
                % time
                % For compression the actual picture is updated faster so
                % as to save it
                if strcmp(TrObjLocal.camera_type,'Webcam')
                    if strcmp(TrObjLocal.vid.VideoFormat,'RGB24_320x240')
                        IM = rgb2gray(IM);
                        frame.cdata = cat(3,IM,IM,IM);
                        frame.colormap = [];
                        try,writeVideo(writerObj,frame);GotFrame(num_fr) = 1;catch, GotFrame(num_fr) = 0; disp('missed frame video'),end
                    else
                        frame.cdata = cat(3,IM,IM,IM);
                        frame.colormap = [];
                        try,writeVideo(writerObj,frame);GotFrame(num_fr) = 1;catch, GotFrame(num_fr) = 0; disp('missed frame video'),end
                    end
                else
                    frame.cdata = cat(3,IM,IM,IM);
                    frame.colormap = [];
                    try,writeVideo(writerObj,frame);GotFrame(num_fr) = 1;catch, GotFrame(num_fr) = 0; disp('missed frame video'),end
                end
                num_fr=num_fr+1;
                
                if  mod(num_fr-2,UpdateImage)==0
                    set(g,'Xdata',Pos(1).*TrObjLocal.Ratio_IMAonREAL,'YData',Pos(2).*TrObjLocal.Ratio_IMAonREAL)
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
                    figure(Fig_Odors), subplot(5,5,22:25)
                    set(gca,'Ylim',[0 max(ymax,1e-5)]);
                end
                OldIm=NewIm;
                OldZone=FzZone;
                
                % --------------------- SAVE FRAMES if you want to  -----------------------
                if TrObjLocal.SaveToMatFile==1
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
                
                %% Specific to Odor protocol
                if strcmp('OdorExposure',ExpeInfo.namePhase) | strcmp('OdourAndSoundTest',ExpeInfo.namePhase)
                    
                    if etime(clock,KeepTime.tDeb)>OdorStartTime(ShTN)
                        fwrite(a,arduinoDictionary.OdorOn); % intan ttl
                        fwrite(ArdMotor,arduinoDictionary.OdorOn); % motor control
                        PosMat(end,4)=1;
                        disp('odor on')
                        ShTN=ShTN+1;
                        set(chronostim,'string',num2str(OdorStartTime(ShTN)));
                    end
                    
                    if etime(clock,KeepTime.tDeb)>OdorStopTime(ShTN2)
                        fwrite(a,arduinoDictionary.OdorOff); % intan ttl
                        fwrite(ArdMotor,arduinoDictionary.OdorOff); % motor control
                        PosMat(end,4)=2;
                        disp('odor off')
                        ShTN2=ShTN2+1;
                    end
                    
                end
                
                
                
            end
            
            KeepTime.t2 = clock;
            if StartChrono && etime(KeepTime.t2,KeepTime.tDeb)> ExpeInfo.lengthPhase+0.5
                enableTrack=0;
            end
        end
        
        
        ShTN=1;% reset for next phase
        ShTN2=1;
        fwrite(a,arduinoDictionary.Off); % switch off intan
        
        % Correct for intan trigger time to realign with ephys
        im_diff(:,1)=im_diff(:,1)+1;
        PosMat(:,1)=PosMat(:,1)+1;
        MouseTemp(:,1) = MouseTemp(:,1)+1;
        
        %% This is the strict minimum all codes need to save %%
        [PosMat,PosMatInit,im_diff,im_diffInit,Vtsd,Xtsd,Ytsd,Imdifftsd]=CommonInterpPosMatImDiff(im_diff,KeepTime.chrono,PosMat, dist_thresh);
        ref=TrObjLocal.ref;mask=TrObjLocal.mask;Ratio_IMAonREAL=TrObjLocal.Ratio_IMAonREAL;
        frame_limits=TrObjLocal.frame_limits;
        save([ExpeInfo.name_folder,filesep,'TrObject.mat'],'TrObjLocal');
        
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
        
        ZoneIndices = [];
        ZoneEpoch = {};
        Zone = {};
        Occup = [];
                ZoneLabels = {};

        save([ExpeInfo.name_folder,filesep,'behavResources.mat'],'FreezeEpoch','th_immob','thtps_immob',...
            'Zone','ZoneEpoch','ZoneIndices','FreezeTime','Occup',...
            'OdorDuration','MouseTemp','ZoneLabels','-append');
        
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
        title('Raw Data')
        
        subplot(2,2,3)
        OdorEpoch = intervalSet(OdorStartTime*1e4,(OdorStartTime+OdorDuration)*1e4);
        BefOdorEpoch = intervalSet((OdorStartTime-30)*1e4,(OdorStartTime)*1e4);
        SpeedOdor = [nanmean(Data(Restrict(Vtsd,BefOdorEpoch))),nanmean(Data(Restrict(Vtsd,OdorEpoch)))];
        bar(SpeedOdor)
        hold on
        set(gca,'Xtick',[1,2],'XtickLabel',{'Bef','Dur'})
        colormap copper
        ylabel('mean speed')
        xlim([0.5 2.5])
        box off
        
        saveas(figbilan,'FigBilan.fig')
        saveas(figbilan,[ExpeInfo.name_folder,filesep,'FigBilan.png'])
        close(figbilan)
        
        % update display and button availability
        try
            close(guireg_fig)
            close(GuiForOdors)
            set(Fig_Odors,'Color',color_on);
            delete(msg_box)
            
            set(maskbutton(5),'enable','on','FontWeight','normal')
            set(maskbutton(4),'enable','off','FontWeight','normal')
            set(maskbutton(7),'enable','off','FontWeight','normal')
            set(maskbutton(3),'enable','on','FontWeight','normal')
            set(chronostim,'ForegroundColor','k');
            set(inputDisplay(11),'string','You can relax','ForegroundColor','k','FontSize',8);
        end
    end


%% Define behavioural zones
%     function DefineZones(obj,event)
%         global Zones
%         figtemp=figure();
%         imagesc(TrObjLocal.ref),colormap redblue,hold on
%         if strcmp(ExpeInfo.namePhase,'EPM')
%             disp('OpenArms');[x1,y1,Open,x2,y2]=roipoly; plot(x2,y2)
%             disp('ClosedArms');[x1,y1,Closed,x2,y2]=roipoly(); plot(x2,y2)
%             Centre=zeros(size(TrObjLocal.ref));Centre(Open==1 & Closed==1)=1;
%             Open(Centre==1)=0;Closed(Centre==1)=0;
%             Zone{1}=uint8(Open);Zone{2}=uint8(Closed);Zone{3}=uint8(Centre);
%             ZoneLabels={'OpenArms','ClosedArms','Centre'};
%             set(maskbutton(3),'string','3 - GetBehavZones (OK)')
%         elseif strcmp(ExpeInfo.namePhase,'SoundCnd') | strcmp(ExpeInfo.namePhase,'SoundHab') | strcmp(ExpeInfo.namePhase,'SoundTest') | strcmp(ExpeInfo.namePhase,'Calibration')  | strcmp(ExpeInfo.namePhase,'SleepSession') | strcmp(ExpeInfo.namePhase,'CalibrationEyeshock')
%             stats = regionprops(TrObjLocal.mask, 'Area');
%             tempmask=TrObjLocal.mask;
%             AimArea=stats.Area/2;
%             ActArea=stats.Area;
%             while AimArea<ActArea
%                 tempmask=imerode(tempmask,strel('disk',1));
%                 stats = regionprops(tempmask, 'Area');
%                 ActArea=stats.Area;
%             end
%             Zone{1}=uint8(tempmask); % Inside area
%             Zone{2}=uint8(TrObjLocal.mask-tempmask);% Outside area
%             ZoneLabels={'Inside','Outside'};
%             set(maskbutton(3),'string','3 - GetBehavZones (OK)')
%         else
%             title('Shock');[x1,y1,Shock,x2,y2]=roipoly; Zone{1}=uint8(Shock);plot(x2,y2,'linewidth',2)
%             title('NoShock');[x1,y1,NoShock,x2,y2]=roipoly(); Zone{2}=uint8(NoShock);plot(x2,y2,'linewidth',2)
%             title('Centre');[x1,y1,Centre,x2,y2]=roipoly(); Zone{3}=uint8(Centre);plot(x2,y2,'linewidth',2)
%             title('CentreShock');[x1,y1,CentreShock,x2,y2]=roipoly(); Zone{4}=uint8(CentreShock);plot(x2,y2,'linewidth',2)
%             title('CentreNoShock');[x1,y1,CentreNoShock,x2,y2]=roipoly();    Zone{5}=uint8(CentreNoShock);plot(x2,y2,'linewidth',2)
%             stats = regionprops(TrObjLocal.mask, 'Area');
%             tempmask=TrObjLocal.mask;
%             AimArea=stats.Area/2;
%             ActArea=stats.Area;
%             while AimArea<ActArea
%                 tempmask=imerode(tempmask,strel('disk',1));
%                 stats = regionprops(tempmask, 'Area');
%                 ActArea=stats.Area;
%             end
%             Zone{6}=uint8(tempmask); % Inside area
%             Zone{7}=uint8(TrObjLocal.mask-tempmask);% Outside area
%             ZoneLabels={'Shock','NoShock','Centre','CentreShock','CentreNoShock','Inside','Outside'};
%             set(maskbutton(3),'string','3 - GetBehavZones (OK)')
%         end
%         close(figtemp)
%         set(maskbutton(5),'enable','on')
%     end

% -----------------------------------------------------------------
%% stop tracking
    function stop_Phase(obj,event)
        figure(Fig_Odors), subplot(5,1,1:2), title('ACQUISITION STOPPED')
        enableTrack=0;
        set(maskbutton(4),'enable','on','FontWeight','normal')
        set(maskbutton(7),'enable','off','FontWeight','normal')
        try fwrite(a,arduinoDictionary.Off);disp('Intan OFF');end
        close(writerObj);
        set(maskbutton(5),'enable','off')
        
    end

    function UMaze_OnlineGuiReglage
        % function GuiForOdors=OnlineGuiReglage(obj,event);
        % let online control of paramteres for image treatments
        
        % create figure
        GuiForOdors=figure('units','normalized',...
            'position',[0.1 0.1 0.2 0.6],...
            'numbertitle','off',...
            'name','UMaze Mouse Tracking : Setting Parameters',...
            'menubar','none',...
            'tag','figure reglage');
        set(GuiForOdors,'Color',color_on);
        
        textUM1=uicontrol(GuiForOdors,'style','text', ...
            'units','normalized',...
            'position',[0.22 0.85 0.2 0.05],...
            'string','freezing threshold');
        
        textUM2=uicontrol(GuiForOdors,'style','text', ...
            'units','normalized',...
            'position',[0.62 0.85 0.2 0.05],...
            'string','Yaxis');
        
        % create sliders
        slider_freeze = uicontrol(GuiForOdors,'style','slider',...
            'units','normalized',...
            'position',[0.25 0.1 0.15 0.7],...
            'callback', @freeze_thresh);
        set(slider_freeze,'Value',th_immob/maxth_immob);
        
        slider_yaxis = uicontrol(GuiForOdors,'style','slider',...
            'units','normalized',...
            'position',[0.65 0.1 0.15 0.7],...
            'callback', @fixyaxis);
        set(slider_yaxis,'Value',ymax/maxyaxis);
        
        % create labels with actual values
        textUM3=uicontrol(GuiForOdors,'style','text', ...
            'units','normalized',...
            'position',[0.22 0.05 0.2 0.03],...
            'string',num2str(th_immob));
        
        textUM4=uicontrol(GuiForOdors,'style','text', ...
            'units','normalized',...
            'position',[0.62 0.05 0.2 0.03],...
            'string',num2str(ymax));
        
        %get freezing threshold
        function freeze_thresh(obj,event)
            th_immob = (get(slider_freeze,'value')*maxth_immob);
            set(textUM3,'string',num2str(th_immob))
            set(thimmobline,'Ydata',[1,1]*th_immob)
        end
        
        %get ylims
        function fixyaxis(~,~)
            ymax = (get(slider_yaxis,'value')*maxyaxis);
            set(textUM4,'string',num2str(ymax));
        end
    end
end
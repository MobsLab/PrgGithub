function [numF,filename]=TrackingHeadFixed_IRComp_ObjectOrientated(~,~)

%% This is the simplest possible tracking code - you can use it as a framework to build more personal codes
%% It just tracks a mouse and displays the video in real time
%% The basic set of variables are recorded at the end

% Get global variables that are common to all codes 
% global TrObjLocal % the video object
global Stimulator PulsePalSystem nBytesAvailable
global TrObj
global TrObjLocal
if iscell(TrObj)
TrObjLocal = TrObj{1};
else
    TrObjLocal = TrObj;
end

% Tracking parameters - you need to initalize these to be able to call Tracking_OnlineGuiReglage
global BW_threshold; BW_threshold=0.5; 
global smaller_object_size; smaller_object_size=30; 
global sm_fact; sm_fact=0; 
global strsz se; strsz=4; se= strel('disk',strsz);
global SrdZone; SrdZone=20;
global guireg_fig % the figure that allows you to set these parameters
global dist_thresh; dist_thresh =2;


%% Variables that are specific to this code
% General thresholds and display
global time_image;time_image = 1/TrObjLocal.frame_rate; % coutn time between frames
global UpdateImage; UpdateImage=ceil(TrObjLocal.frame_rate/5); % update every n frames the picture shown on screen to show at 10Hz
global writerObj  % allows us to save as .avi
global enableTrack % Controls whether the tracking is on or not

% Variables for plotting
global thimmobline % line that shows current freezing threshold
global PlotFreez % the name of the Plot that shows im_diff
global StartChrono, StartChrono=0; % Variable set to one when the tracking begins
% the handle of the chronometer object
global PlotForVideo % the plot that will be saved to .avi if needed
global GuiForSleep % slides with specific values for this protocol 
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
% - chrono to dsplay passing of time

% Freezing/sleep detection
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
arduinoDictionary.On=1; % Tells Intan its time to go
arduinoDictionary.Off=3; % switches Intan off
arduinoDictionary.TenFrames=2; % Sync with intan every 1000 frames

%% Task parameters
global nametypes; nametypes={'Sleep'};

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% graphical interface n???1 with all the pushbuttons

Fig_SleepSession=figure('units','normalized','position',[0.1 0.1 0.4 0.85],...
    'numbertitle','off','name','BasicSleepProtocol','menubar','none','tag','figure Odor');
set(Fig_SleepSession,'Color',color_on);

maskbutton.Inputs= uicontrol(Fig_SleepSession,'style','pushbutton',...
    'units','normalized','position',[0.01 0.89 0.2 0.05],...
    'string','1- INPUTS EXPE','callback', @giv_inputs);
set(maskbutton.Inputs,'enable','on','FontWeight','bold')

maskbutton.StartExpe= uicontrol(Fig_SleepSession,'style','pushbutton',...
    'units','normalized','position',[0.01 0.65 0.2 0.05],...
    'string','3- START EXPE','callback', @start_Expe);
set(maskbutton.StartExpe,'enable','off')

maskbutton.StartSession= uicontrol(Fig_SleepSession,'style','pushbutton',...
    'units','normalized','position',[0.01 0.48 0.2 0.05],'string','4- START session');
set(maskbutton.StartSession,'enable','off','callback', @StartSession)

maskbutton.StopSession= uicontrol(Fig_SleepSession,'style','pushbutton',...
    'units','normalized','position',[0.025 0.36 0.15 0.03],...
    'string','Stop Emergency','callback', @stop_Phase);
set(maskbutton.StopSession,'enable','off')

maskbutton.Quit= uicontrol(Fig_SleepSession,'style','pushbutton',...
    'units','normalized','position',[0.01 0.03 0.2 0.05],...
    'string','CLOSE EXPE','callback', @quit);
set(maskbutton.Quit,'enable','on','FontWeight','bold')

inputDisplay.FileName=uicontrol(Fig_SleepSession,'style','text','units','normalized','position',[0.25 0.95 0.5 0.02],'string','Filename = TO DEFINE','FontSize',10,'BackgroundColor',color_on,'ForegroundColor','w','FontWeight','bold');
inputDisplay.SessNum=uicontrol(Fig_SleepSession,'style','text','units','normalized','position',[0.01 0.59 0.16 0.02],'string','Session','FontSize',12,'BackgroundColor',color_on,'ForegroundColor','w','FontWeight','bold');
inputDisplay.Instructions=uicontrol(Fig_SleepSession,'style','text','units','normalized','position',[0.01 0.56 0.16 0.02],'string','WAIT','FontSize',12,'BackgroundColor',color_on,'ForegroundColor','w','FontWeight','bold');

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
        try close(GuiForSleep);end
        delete(Fig_SleepSession)
    end



%% Ask for all inputs and display
    function giv_inputs(obj,event)
        
        strfcts=strjoin(nametypes,'|');
        u2=uicontrol(Fig_SleepSession,'Style', 'popup','String', strfcts,'units','normalized',...
            'Position', [0.01 0.84 0.2 0.05],'Callback', @setprotoc);
        
        % First stimulation output
        if strcmp('New PulsePal',Stimulator)
                    ProgramPulsePalParam(1,'IsBiphasic',1);
                    ProgramPulsePalParam(1,'Phase1Voltage', 2);
                    ProgramPulsePalParam(1,'Phase1Duration', 0.0005);
                    ProgramPulsePalParam(1,'InterPhaseInterval', 0);
                    ProgramPulsePalParam(1,'Phase2Voltage', -2);
                    ProgramPulsePalParam(1,'Phase2Duration', 0.0005);
                    ProgramPulsePalParam(1,'InterPulseInterval', 0.0071);
                    ProgramPulsePalParam(1,'BurstDuration', 0.1);
                    ProgramPulsePalParam(1,'InterBurstInterval', 0);
                    ProgramPulsePalParam(1,'PulseTrainDelay', 0);
                    ProgramPulsePalParam(1,'PulseTrainDuration', 0.1);
                    ProgramPulsePalParam(1,'LinkTriggerChannel1', 1);
                    ProgramPulsePalParam(1,'LinkTriggerChannel2', 0);
                    ProgramPulsePalParam(1,'RestingVoltage', 0);
                    ProgramPulsePalParam(1,'TriggerMode', 0);
                    
                    ProgramPulsePalParam(2,'IsBiphasic',1);
                    ProgramPulsePalParam(2,'Phase1Voltage', 2);
                    ProgramPulsePalParam(2,'Phase1Duration', 0.0005);
                    ProgramPulsePalParam(2,'InterPhaseInterval', 0);
                    ProgramPulsePalParam(2,'Phase2Voltage', -2);
                    ProgramPulsePalParam(2,'Phase2Duration', 0.0005);
                    ProgramPulsePalParam(2,'InterPulseInterval', 0.0071);
                    ProgramPulsePalParam(2,'BurstDuration', 0.1);
                    ProgramPulsePalParam(2,'InterBurstInterval', 0);
                    ProgramPulsePalParam(2,'PulseTrainDelay', 0);
                    ProgramPulsePalParam(2,'PulseTrainDuration', 0.1);
                    ProgramPulsePalParam(2,'LinkTriggerChannel1', 0);
                    ProgramPulsePalParam(2,'LinkTriggerChannel2', 1);
                    ProgramPulsePalParam(2,'RestingVoltage', 0);
                    ProgramPulsePalParam(2,'TriggerMode', 0);
                    
                    ExpeInfo.Voltage = 2;
                    
                    ProgramPulsePalParam(3,'LinkTriggerChannel1', 0);
                    ProgramPulsePalParam(3,'LinkTriggerChannel2', 0);
                    ProgramPulsePalParam(4,'LinkTriggerChannel1', 0);
                    ProgramPulsePalParam(4,'LinkTriggerChannel2', 0);
        
        end
        
        function setprotoc(obj,event)
            fctname=get(obj,'value');
            ExpeInfo.namePhase=nametypes(fctname);ExpeInfo.namePhase=ExpeInfo.namePhase{1};
            savProtoc
        end
        
        function savProtoc(obj,event)
            
            if strcmp('New PulsePal',Stimulator)
                
                default_answer{1}='007';
                default_answer{2}=num2str(99999999);
                default_answer{3}='2';
                
                answer = inputdlg({'NumberMouse','Session duration (s)', 'Voltage'},'INFO',1,default_answer);
                default_answer=answer; save default_answer default_answer
                
                ExpeInfo.nmouse=str2double(answer{1});
                ExpeInfo.lengthPhase=str2double(answer{2});
                ExpeInfo.Voltage = str2double(answer{3});
                ExpeInfo.nPhase=0;
                
                ProgramPulsePalParam(1,'Phase1Voltage', ExpeInfo.Voltage);
                ProgramPulsePalParam(1,'Phase2Voltage', -(ExpeInfo.Voltage));    
            else
                
                default_answer{1}='007';
                default_answer{2}=num2str(99999999);
                
                
                answer = inputdlg({'NumberMouse','Session duration (s)'},'INFO',1,default_answer);
                default_answer=answer; save default_answer default_answer
                
                ExpeInfo.nmouse=str2double(answer{1});
                ExpeInfo.lengthPhase=str2double(answer{2});
                ExpeInfo.nPhase=0;
                
            end
                        
            nameTASK='SleepSession';
            disp(' ');disp('-------------------- New Expe ---------------------');
            set(maskbutton.Inputs,'FontWeight','normal','string','1- INPUTS EXPE (OK)');
        end
        set(maskbutton.StartExpe,'enable','on')
    end

% -----------------------------------------------------------------
%% Interface of analysis
    function start_Expe(obj,event)
        KeepTime.t1=clock;
        KeepTime.t2=clock;
        enableTrack=1;
        StartChrono=0;
        ExpeInfo.nPhase=ExpeInfo.nPhase+1;
        ExpeInfo.name_folder=['SLEEP-Mouse-' num2str(ExpeInfo.nmouse) '-' ExpeInfo.TodayIs '-' ExpeInfo.namePhase];
        
        set(maskbutton.StartExpe,'enable','on','FontWeight','normal','string','3- START EXPE (OK)')
        
        if enableTrack
            set(inputDisplay.SessNum,'string',['Session ',num2str(ExpeInfo.nPhase),' :'])
            set(inputDisplay.Instructions,'string','WAIT for start');
            
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
            set(inputDisplay.FileName,'string',ExpeInfo.name_folder);
            pause(0.1)
            StartChrono=0;
            
            % check arduino is ready
            if size(a.Status,2)==6
                try fopen(a); end
            end
            
            % enable button to start session
            set(maskbutton.StartSession,'enable','on','FontWeight','bold')
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
        set(maskbutton.StopSession,'enable','on','FontWeight','bold')
        set(maskbutton.StartSession,'enable','off','FontWeight','normal')
        % Tell the arduino we're starting
        fwrite(a,arduinoDictionary.On);
        % Tell the experimenter we're starting
        set(inputDisplay.Instructions,'string','RECORDING');
        % Initialize time
        KeepTime.tDeb = clock;
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
        
        figure(Fig_SleepSession),
        PlotForVideo=subplot(5,1,1:2);
        htrack = imagesc(TrObjLocal.ref);axis image; hold on
        line([10 20]*TrObjLocal.Ratio_IMAonREAL,[10 10],'Color','k','Linewidth',3)
        text(15*TrObjLocal.Ratio_IMAonREAL,15,'10 cm','Color','k')
        title('ACQUISITION ON')
        caxis([0.1 0.9])
        % change for comrpession
        colormap(gray)
        
        figure(Fig_SleepSession), subplot(5,1,3:4),
        htrack2 = imagesc(zeros(size((TrObjLocal.ref))));axis image; caxis([0 1]);hold on
        xlabel('tracking online','Color','w')
        g=plot(0,0,'m+');

        im_diff=0;
        figure(Fig_SleepSession), subplot(5,5,22:25)
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
        
        PosMat=[];im_diff=[]; GotFrame = []; MouseTemp=[];
                
        IM=TrObjLocal.GetAFrame;
     
        OldIm=TrObjLocal.mask;
        OldZone=TrObjLocal.mask;
        
        % The code waits here until enableTrack is set to 1 by StartSession
        
        while enableTrack
            disp('start')
            
            % Activate the camera and send the image to the workspace
            pause(time_image-etime(KeepTime.t2,KeepTime.t1));
            
            % update KeepTime.chrono
            KeepTime.t1 = clock;
            IM=TrObjLocal.GetAFrame;
            

            % ---------------------------------------------------------
           
            if StartChrono
                KeepTime.chrono=etime(KeepTime.t1,KeepTime.tDeb);
                set(chronoshow,'string',[num2str(floor(KeepTime.chrono)),'/',num2str(ExpeInfo.lengthPhase)]);
            end
            
            % display video, mouse position and save in posmat
            if StartChrono
                
                
                time(num_fr,1)=KeepTime.chrono; % Time
                   

                % -------------------------------------------------------------------------------
                % -------------------------------- Find the mouse   --------------------------------

                % Update displays at 10Hz - faster would just be a waste of
                % time
                % For compression the actual picture is updated faster so
                % as to save it
                if strcmp(TrObjLocal.camera_type,'Webcam')
                    tic
                    if length(size(IM))==3
                        IM = rgb2gray(IM);
                    end
                    frame.cdata = cat(3,IM,IM,IM);
                    frame.colormap = [];
                    try,writeVideo(writerObj,frame);GotFrame(num_fr) = 1;catch, GotFrame(num_fr) = 0;disp('missed frame video'),end
                    toc
                else
                    frame.cdata = cat(3,IM,IM,IM);
                    frame.colormap = [];
                    try,writeVideo(writerObj,frame);GotFrame(num_fr) = 1;catch, GotFrame(num_fr) = 0; disp('missed frame video'),end
                end

                num_fr=num_fr+1;
                % 
                
                if  mod(num_fr-2,UpdateImage)==0

                    set(htrack,'Cdata',IM);

                end
              
                
                % % -------------------------------------------------------------------------------
                % % -------------------------------- SAVE FRAMES   --------------------------------
                if TrObjLocal.SaveToMatFile==1
                    prefac1=char; for ii=1:6-length(num2str(n)), prefac1=cat(2,prefac1,'0');end
                    tic
                    save([ ExpeInfo.name_folder filesep ExpeInfo.Fname filesep 'frame' prefac1 sprintf('%0.5g',n)],'IM','-v6');
                    toc
                    n = n+1;
                end

               % -------------------------------------------------------------------------------
               % ------------------- Every 10 frames sync with intan  -----------------------
               
               if  mod(num_fr,10)==0
                fwrite(a,arduinoDictionary.TenFrames);
                disp('frame')
                end
                
            KeepTime.t2 = clock;
            
            % Check if we've gone over the decided phase length and end the
            % tracking
            if StartChrono && etime(KeepTime.t2,KeepTime.tDeb)> ExpeInfo.lengthPhase+0.5
                enableTrack=0;
            end
            
            end
        end
                
        fwrite(a,arduinoDictionary.Off); % switch off intan
        
     
        
        save([ExpeInfo.name_folder,filesep,'behavResources.mat'],'time', 'GotFrame');
        clear ref mask Ratio_IMAonREAL

        
        % save and copy file in save_folder
        msg_box=msgbox('Saving behavioral Information','save','modal');
        % Shut the video if compression was being done on the fly
            close(writerObj);
        
        pause(0.5)
        try set(PlotFreez,'YData',0,'XData',0);end
        
        %% generate figure that gives overviewof the tracking session
        
        % update display and button availability
        try
            close(guireg_fig)
            close(GuiForSleep)
            set(Fig_SleepSession,'Color',color_on);
            delete(msg_box)
            
            set(maskbutton.StartExpe,'enable','on','FontWeight','normal')
            set(maskbutton.StartSession,'enable','off','FontWeight','normal')
            set(maskbutton.StopSession,'enable','off','FontWeight','normal')
            set(maskbutton(3),'enable','on','FontWeight','normal')
            set(chronostim,'ForegroundColor','k');
        end
        end
    


%% stop tracking
    function stop_Phase(obj,event)
        figure(Fig_SleepSession), subplot(5,1,1:2), title('ACQUISITION STOPPED')
        enableTrack=0;
        set(maskbutton.StartSession,'enable','on','FontWeight','normal')
        set(maskbutton.StopSession,'enable','off','FontWeight','normal')
        try fwrite(a,arduinoDictionary.Off);disp('Intan OFF');end
        close(writerObj);
        set(maskbutton.StartExpe,'enable','off')
    end

    function UMaze_OnlineGuiReglage
        % function GuiForSleep=OnlineGuiReglage(obj,event);
        % let online control of paramteres for image treatments
        
        % create figure
        GuiForSleep=figure('units','normalized',...
            'position',[0.1 0.1 0.2 0.6],...
            'numbertitle','off',...
            'name','UMaze Mouse Tracking : Setting Parameters',...
            'menubar','none',...
            'tag','figure reglage');
        set(GuiForSleep,'Color',color_on);
        
        textUM1=uicontrol(GuiForSleep,'style','text', ...
            'units','normalized',...
            'position',[0.22 0.85 0.2 0.05],...
            'string','freezing threshold');
        
        textUM2=uicontrol(GuiForSleep,'style','text', ...
            'units','normalized',...
            'position',[0.62 0.85 0.2 0.05],...
            'string','Yaxis');
        
        % create sliders
        slider_freeze = uicontrol(GuiForSleep,'style','slider',...
            'units','normalized',...
            'position',[0.25 0.1 0.15 0.7],...
            'callback', @freeze_thresh);
        set(slider_freeze,'Value',th_immob/maxth_immob);
        
        slider_yaxis = uicontrol(GuiForSleep,'style','slider',...
            'units','normalized',...
            'position',[0.65 0.1 0.15 0.7],...
            'callback', @fixyaxis);
        set(slider_yaxis,'Value',ymax/maxyaxis);
        
        % create labels with actual values
        textUM3=uicontrol(GuiForSleep,'style','text', ...
            'units','normalized',...
            'position',[0.22 0.05 0.2 0.03],...
            'string',num2str(th_immob));
        
        textUM4=uicontrol(GuiForSleep,'style','text', ...
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
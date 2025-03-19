function [numF,filename]=NosePokeTracking_IRComp_ObjectOrientated(~,~)

%%% This is a nosepoke tracking code compatible with IR camera based on earlier nosepoke code
% and compatible with new, standard for whole lab variables
% modified by Dima in February-March 2018
% and then again in October-November2018

% Get global variables that are common to all codes
% global TrObjLocal % the video object
global TrObj
global TrObjLocal
if iscell(TrObj)
TrObjLocal = TrObj{1};
else
    TrObjLocal = TrObj;
end

 global Stimulator PulsePalSystem nBytesAvailable

% Tracking parameters - you need to initalize these to be able to call Tracking_OnlineGuiReglage
global BW_threshold; BW_threshold=0.5;
global smaller_object_size; smaller_object_size=30;
global sm_fact; sm_fact=0;
global strsz se; strsz=4; se= strel('disk',strsz);
global SrdZone; SrdZone=20;
global guireg_fig % the figure that allows you to set these parameters
global dist_thresh; dist_thresh =2;

global DiodMask
global DiodThresh
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
% - Stimulated structure (MFB or MFB/PAG)
% - Voltage of stimulation
% - enableTrack
% - name_folder : current folder for saving
% - Fname : current foldre in which individual frames are saved

global MName; MName='';

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
arduinoDictionary.ThousandFrames=2; % Sync with intan every 1000 frames
arduinoDictionary.FlashingLight=5; % Swith on synchronizing light

%% Task parameters
global nametypes; nametypes={'NosePokeOneStim', 'NosePokeTwoStimSimultan'};

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% graphical interface n???1 with all the pushbuttons

Fig_NosePoke=figure('units','normalized','position',[0.1 0.1 0.4 0.85],...
    'numbertitle','off','name','NosePokeProtocol','menubar','none','tag','figure Odor');
set(Fig_NosePoke,'Color',color_on);

maskbutton.Inputs= uicontrol(Fig_NosePoke,'style','pushbutton',...
    'units','normalized','position',[0.01 0.89 0.2 0.05],...
    'string','1- INPUTS EXPE','callback', @giv_inputs);
set(maskbutton.Inputs,'enable','on','FontWeight','bold')

maskbutton.DiodButton= uicontrol(Fig_NosePoke,'style','pushbutton',...
    'units','normalized','position',[0.01 0.7 0.2 0.05],...
    'string','2-GetLightZone','callback', @GetLightZone);
set(maskbutton.DiodButton,'enable','off')

maskbutton.StartExpe= uicontrol(Fig_NosePoke,'style','pushbutton',...
    'units','normalized','position',[0.01 0.65 0.2 0.05],...
    'string','3- START EXPE','callback', @start_Expe);
set(maskbutton.StartExpe,'enable','off')

maskbutton.StartSession= uicontrol(Fig_NosePoke,'style','pushbutton',...
    'units','normalized','position',[0.01 0.48 0.2 0.05],'string','4- START session');
set(maskbutton.StartSession,'enable','off','callback', @StartSession)

maskbutton.StopSession= uicontrol(Fig_NosePoke,'style','pushbutton',...
    'units','normalized','position',[0.025 0.36 0.15 0.03],...
    'string','Stop Emergency','callback', @stop_Phase);
set(maskbutton.StopSession,'enable','off')

maskbutton.Quit= uicontrol(Fig_NosePoke,'style','pushbutton',...
    'units','normalized','position',[0.01 0.03 0.2 0.05],...
    'string','CLOSE EXPE','callback', @quit);
set(maskbutton.Quit,'enable','on','FontWeight','bold')

inputDisplay.FileName=uicontrol(Fig_NosePoke,'style','text','units','normalized','position',[0.25 0.95 0.5 0.02],'string','Filename = TO DEFINE','FontSize',10,'BackgroundColor',color_on,'ForegroundColor','w','FontWeight','bold');
inputDisplay.SessNum=uicontrol(Fig_NosePoke,'style','text','units','normalized','position',[0.01 0.59 0.16 0.02],'string','Session','FontSize',12,'BackgroundColor',color_on,'ForegroundColor','w','FontWeight','bold');
inputDisplay.Instructions=uicontrol(Fig_NosePoke,'style','text','units','normalized','position',[0.01 0.56 0.16 0.02],'string','WAIT','FontSize',12,'BackgroundColor',color_on,'ForegroundColor','w','FontWeight','bold');

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
        delete(Fig_NosePoke)
    end



%% Ask for all inputs and display
    function giv_inputs(obj,event)
        
        strfcts=strjoin(nametypes,'|');
        u2=uicontrol(Fig_NosePoke,'Style', 'popup','String', strfcts,'units','normalized',...
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
            
            ProgramPulsePalParam(3,'LinkTriggerChannel1', 0);
            ProgramPulsePalParam(4,'LinkTriggerChannel1', 0);
            
            ExpeInfo.voltage = 2;
        end
        
        function setprotoc(obj,event)
            fctname=get(obj,'value');
            ExpeInfo.namePhase=nametypes(fctname);ExpeInfo.namePhase=ExpeInfo.namePhase{1};
            ExpeInfo.lengthPhase = [];
            savProtoc
        end
        
        function savProtoc(obj,event)
            
            if strcmp('NosePokeOneStim',ExpeInfo.namePhase)
                
                if strcmp('New PulsePal',Stimulator)
                    % added 4/4/2019 SL
                    default_answer{1}= MName;
                    %default_answer{1}= '';
                    default_answer{2}='MFB';                    
                    default_answer{3}='1';
                    default_answer{4}='2';
                    
                    % end added 4/42019 SL
                    
                    
                    answer = inputdlg({'NumberMouse','Session Type','SessionNumber', 'Voltage'},'INFO',1,default_answer);
                    default_answer=answer; save default_answer default_answer
                    
                    ExpeInfo.nmouse=str2double(answer{1}); 
                    MName=answer{1}; 
                    ExpeInfo.strtostim=answer{2};
                    ExpeInfo.nPhase=str2double(answer{3});
                    ExpeInfo.Voltage=str2double(answer{4});
                    ProgramPulsePalParam(1,'Phase1Voltage', ExpeInfo.Voltage);
                    ProgramPulsePalParam(1,'Phase2Voltage', -(ExpeInfo.Voltage));
                else
                    default_answer{1}='';
                    default_answer{2}='MFB';
                    default_answer{3}='1';
                    default_answer{4}='2';
                    
                    
                    answer = inputdlg({'NumberMouse','Session Type','SessionNumber', 'Voltage'},'INFO',1,default_answer);
                    default_answer=answer; save default_answer default_answer
                    
                    ExpeInfo.nmouse=str2double(answer{1});
                    ExpeInfo.strtostim=answer{2};
                    ExpeInfo.nPhase=str2double(answer{3});
                    ExpeInfo.voltage=str2double(answer{4});
                end
                
            elseif strcmp('NosePokeTwoStimSimultan',ExpeInfo.namePhase)
                
                
                if strcmp('New PulsePal',Stimulator)
                    default_answer{1}='';
                    default_answer{2}='MFB&PAG';
                    default_answer{3}='1';
                    default_answer{4}='2';
                    default_answer{5}='2';
                    
                    
                    answer = inputdlg({'NumberMouse','Session Type','SessionNumber', 'Voltage1', 'Voltage2'},'INFO',1,default_answer);
                    default_answer=answer; save default_answer default_answer
                    
                    ExpeInfo.nmouse=str2double(answer{1});
                    ExpeInfo.strtostim=answer{2};
                    ExpeInfo.nPhase=str2double(answer{3});
                    ExpeInfo.voltage(1)=str2double(answer{4});
                    ExpeInfo.voltage(2)=str2double(answer{5});
                    ProgramPulsePalParam(1,'Phase1Voltage', ExpeInfo.voltage(1));
                    ProgramPulsePalParam(1,'Phase2Voltage', -(ExpeInfo.voltage(1)));
                    ProgramPulsePalParam(2,'Phase1Voltage', ExpeInfo.voltage(2));
                    ProgramPulsePalParam(2,'Phase2Voltage', -(ExpeInfo.voltage(2)));
                else
                    default_answer{1}='';
                    default_answer{2}='MFB&PAG';
                    default_answer{3}='1';
                    default_answer{4}='2';
                    default_answer{5}='2';
                    
                    
                    answer = inputdlg({'NumberMouse','Session Type','SessionNumber', 'Voltage1', 'Voltage2'},'INFO',1,default_answer);
                    default_answer=answer; save default_answer default_answer
                    
                    ExpeInfo.nmouse=str2double(answer{1});
                    ExpeInfo.strtostim=answer{2};
                    ExpeInfo.nPhase=str2double(answer{3});
                    ExpeInfo.voltage(1)=str2double(answer{4});
                    ExpeInfo.voltage(2)=str2double(answer{5});
                end
                
            end
            nameTASK='NosePoke';
            disp(' ');disp('-------------------- New Expe ---------------------');
            set(maskbutton.Inputs,'FontWeight','normal','string','1- INPUTS EXPE (OK)');
            set(maskbutton.DiodButton,'enable','on')
        end
        
    end
    function GetLightZone(obj,event)
        
        LightZone=figure; subplot(5,1,1:4),
        imagesc(TrObjLocal.ref); colormap gray; axis image
        title('Select Diode Zone','Color','w')
        [~,~,DiodMask,~]=roipoly(TrObjLocal.ref);
        
        DiodMask=double(DiodMask);
        fwrite(a,arduinoDictionary.FlashingLight);
        temp=clock();
        vals=[];
        while etime(clock,temp)<10
            IM=TrObjLocal.GetAFrame;
            vals=squeeze([vals,sum(sum(sum(IM.*DiodMask)))]);
        end
        LightZoneFig=figure; subplot(5,1,5),
        plot(vals);
        title('select threshold')
        [~,DiodThresh]=ginput(1);
        close(LightZoneFig)
        close(LightZone);
        set(maskbutton.StartExpe,'enable','on')
    end


% -----------------------------------------------------------------
%% Interface of analysis
    function start_Expe(obj,event)
        KeepTime.t1=clock;
        KeepTime.t2=clock;
        enableTrack=1;
        StartChrono=0;
        if length(ExpeInfo.voltage)>1
            ExpeInfo.name_folder=['NosePoke-Mouse-' num2str(ExpeInfo.nmouse) '-'...
                ExpeInfo.strtostim '-' num2str(ExpeInfo.nPhase) '-' num2str(ExpeInfo.Voltage) ...
                'V-' ExpeInfo.TodayIs];
        else
            ExpeInfo.name_folder=['NosePoke-Mouse-' num2str(ExpeInfo.nmouse) '-'...
                ExpeInfo.strtostim '-' num2str(ExpeInfo.nPhase) '-' num2str(ExpeInfo.Voltage) 'V-' ExpeInfo.TodayIs];
        end
        
        set(maskbutton.StartExpe,'enable','on','FontWeight','normal','string','3- START EXPE (OK)')
        
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
        
        figure(Fig_NosePoke),
        PlotForVideo=subplot(5,1,1:2);
        htrack = imagesc(TrObjLocal.ref);axis image; hold on
        line([10 20]*TrObjLocal.Ratio_IMAonREAL,[10 10],'Color','k','Linewidth',3)
        text(15*TrObjLocal.Ratio_IMAonREAL,15,'10 cm','Color','k')
        title('ACQUISITION ON')
        caxis([0.1 0.9])
        % change for comrpession
        colormap(gray)
        
        figure(Fig_NosePoke), subplot(5,1,3:4),
        htrack2 = imagesc(zeros(size((TrObjLocal.ref))));axis image; caxis([0 1]);hold on
        xlabel('tracking online','Color','w')
        g=plot(0,0,'m+');
        
        im_diff=0;
        figure(Fig_NosePoke), subplot(5,5,22:25)
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
        
        PosMat=[];im_diff=[]; GotFrame = []; MouseTemp = [];
        
        IM=TrObjLocal.GetAFrame;
        
        OldIm=TrObjLocal.mask;
        OldZone=TrObjLocal.mask;
        
        % The code waits here until enableTrack is set to 1 by StartSession
        
        while enableTrack
            
            % Activate the camera and send the image to the workspace
            pause(time_image-etime(KeepTime.t2,KeepTime.t1));
            IM=TrObjLocal.GetAFrame;
            
            % ---------------------------------------------------------
            % update KeepTime.chrono
            KeepTime.t1 = clock;
            if StartChrono
                KeepTime.chrono=etime(KeepTime.t1,KeepTime.tDeb);
                set(chronoshow,'string',[num2str(floor(KeepTime.chrono)),'/',num2str(ExpeInfo.lengthPhase)]);
            end
            
            
            if StartChrono
                
                % -------------------------------------------------------------------------------
                % -------------------------------- Find the mouse   --------------------------------
                
                % display video, mouse position and save in posmat
                [Pos,ImDiff,PixelsUsed,NewIm,FzZone]=Track_ImDiff(IM,TrObjLocal.mask,TrObjLocal.ref,BW_threshold,smaller_object_size,sm_fact,se,SrdZone,...
                    TrObjLocal.Ratio_IMAonREAL,OldIm,OldZone,TrObjLocal.camera_type);
                
                if sum(isnan(Pos))==0
                    PosMat(num_fr,1)=KeepTime.chrono; % Time
                    PosMat(num_fr,2)=Pos(1); % XPos
                    PosMat(num_fr,3)=Pos(2); % YPose
                    PosMat(num_fr,4)=0; % You can store events here
                    im_diff(num_fr,1)=KeepTime.chrono; % Time
                    im_diff(num_fr,2)=ImDiff; % Number fo pixels changed
                    im_diff(num_fr,3)=PixelsUsed; % Size of zone used to calculate ImDiff
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
                num_fr=num_fr+1;
                
                
                % ---------------------------------------------------------
                % --------------------- Get Diod Value ------------------------
              
                if sum(sum(sum(IM.*DiodMask)))>DiodThresh
                    if first
                        set(Fig_NosePoke,'Color','r');
                        Starttime = KeepTime.chrono;
                        LastStim = KeepTime.chrono;
                        PosMat(num_fr,4)=1;
                        disp('Stim');
                        first=0;
                    else
                        if LastStim-KeepTime.chrono>1
                            LastStim = KeepTime.chrono;
                            PosMat(num_fr,4)=1;
                            disp('Stim');
                        end
                    end
                end
                
                
                % -------------------------------------------------------------------------------
                % -------------------------------- Find the mouse   --------------------------------
                
                % Update displays at 10Hz - faster would just be a waste of
                % time
                % For compression the actual picture is updated faster so
                % as to save it
                if strcmp(TrObjLocal.camera_type,'Webcam')
                    if strcmp(TrObjLocal.vid.VideoFormat,'RGB24_320x240')
                        IM = rgb2gray(IM);
                        frame.cdata = cat(3,IM,IM,IM);
                        frame.colormap = [];
                        try,writeVideo(writerObj,frame);GotFrame(num_fr) = 1;catch, GotFrame(num_fr) = 0;disp('missed frame video'),end
                    else
                        frame.cdata = cat(3,IM,IM,IM);
                        frame.colormap = [];
                        try,writeVideo(writerObj,frame);GotFrame(num_fr) = 1;catch, GotFrame(num_fr) = 0;disp('missed frame video'),end
                    end
                else
                    frame.cdata = cat(3,IM,IM,IM);
                    frame.colormap = [];
                    try,writeVideo(writerObj,frame);GotFrame(num_fr) = 1;catch, GotFrame(num_fr) = 0;disp('missed frame video'),end
                end
                
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
                    figure(Fig_NosePoke), subplot(5,5,22:25)
                    set(gca,'Ylim',[0 max(ymax,1e-5)]);
                end
                OldIm=NewIm;
                OldZone=FzZone;
                
                % -------------------------------------------------------------------------------
                % -------------------------------- SAVE FRAMES   --------------------------------
                if TrObjLocal.SaveToMatFile==1
                    datas.image =IM;
                    datas.time = KeepTime.t1;
                    prefac1=char; for ii=1:6-length(num2str(n)), prefac1=cat(2,prefac1,'0');end
                    save([ ExpeInfo.name_folder filesep ExpeInfo.Fname filesep 'frame' prefac1 sprintf('%0.5g',n)],'datas','-v6');
                    n = n+1;
                    clear datas
                end
                
                % -------------------------------------------------------------------------------
                % ------------------- Every 1000 frames sync with intan  -----------------------
                if  mod(num_fr,1000)==0
                    fwrite(a,arduinoDictionary.ThousandFrames);
                end
                
                
                
                KeepTime.t2 = clock;
                
                % Check if we've gone over the decided phase length and end the
                % tracking
                %             if StartChrono && etime(KeepTime.t2,KeepTime.tDeb)> ExpeInfo.lengthPhase+0.5
                %                 enableTrack=0;
                %             end
            end
        end
        
        
        fwrite(a,arduinoDictionary.Off); % switch off intan
        
        % Correct for intan trigger time to realign with ephys - this is
        % really important!!
        im_diff(:,1)=im_diff(:,1)+1;
        PosMat(:,1)=PosMat(:,1)+1;
        MouseTemp(:,1) = MouseTemp(:,1)+1;
        
        %% This is the strict minimum all codes need to save %%
        [PosMat,PosMatInit,im_diff,im_diffInit,Vtsd,Xtsd,Ytsd,Imdifftsd]=CommonInterpPosMatImDiff(im_diff,KeepTime.chrono,PosMat, dist_thresh);
        ref=TrObjLocal.ref;mask=TrObjLocal.mask;Ratio_IMAonREAL=TrObjLocal.Ratio_IMAonREAL;
        frame_limits=TrObjLocal.frame_limits;
        save([ExpeInfo.name_folder,filesep,'TrObject.mat'],'TrObjLocal');
        
        save([ExpeInfo.name_folder,filesep,'behavResources.mat'],'PosMat','PosMatInit', 'GotFrame', 'im_diff','im_diffInit','Vtsd','Xtsd','Ytsd','Imdifftsd',...
            'ref','mask','Ratio_IMAonREAL','BW_threshold','frame_limits','smaller_object_size','sm_fact','strsz','SrdZone','DiodMask','DiodThresh');
        clear ref mask Ratio_IMAonREAL
        
        
        % Do some extra code-specific calculations
        try FreezeEpoch=thresholdIntervals(Imdifftsd,th_immob,'Direction','Below');
            FreezeEpoch=mergeCloseIntervals(FreezeEpoch,0.3*1E4);
            FreezeEpoch=dropShortIntervals(FreezeEpoch,thtps_immob*1E4);
            Freeze=sum(End(FreezeEpoch)-Start(FreezeEpoch));
        catch
            Freeze=NaN;
            Freeze2=NaN;
        end
        
        save([ExpeInfo.name_folder,filesep,'behavResources.mat'],'FreezeEpoch','th_immob','thtps_immob', 'MouseTemp', '-append');
        
        % save and copy file in save_folder
        msg_box=msgbox('Saving behavioral Information','save','modal');
        % Shut the video if compression was being done on the fly
        close(writerObj);
        
        pause(0.5)
        try set(PlotFreez,'YData',0,'XData',0);end
        
        %% generate figure that gives overviewof the tracking session
        figbilan=figure;
        subplot(2,1,1)
        plot(Range(Vtsd,'s'),Data(Vtsd)./prctile(Data(Vtsd),98),'k'), hold on
        plot(Range(Imdifftsd,'s'),Data(Imdifftsd)./prctile(Data(Imdifftsd),98),'b')
        title('Raw Data')
        
        subplot(2,1,2)
        plot(PosMat(:,2),PosMat(:,3),'k*')
        
        
        saveas(figbilan,[ExpeInfo.name_folder,filesep,'FigBilan.fig'])
        saveas(figbilan,[ExpeInfo.name_folder,filesep,'FigBilan.png'])
        close(figbilan)
        
        % update display and button availability
        try
            close(guireg_fig)
            close(GuiForSleep)
            set(Fig_NosePoke,'Color',color_on);
            delete(msg_box)
            
            set(maskbutton.StartExpe,'enable','on','FontWeight','normal')
            set(maskbutton.DiodButton,'enable','on','FontWeight','normal')
            set(maskbutton.StartSession,'enable','off','FontWeight','normal')
            set(maskbutton.StopSession,'enable','off','FontWeight','normal')
            set(maskbutton(3),'enable','on','FontWeight','normal')
            set(chronostim,'ForegroundColor','k');
            
%         figure(Fig_NosePoke), subplot(5,1,1:2), title('ACQUISITION STOPPED')
%         enableTrack=0;
%         set(maskbutton.StartSession,'enable','on','FontWeight','normal')
%         set(maskbutton.StopSession,'enable','off','FontWeight','normal')
%         fwrite(a,arduinoDictionary.Off);
%         disp('Intan OFF');
%         close(writerObj);
%         set(maskbutton.StartExpe,'enable','off')
            
            
        end
    end


    %% stop tracking
    function stop_Phase(obj,event)
        figure(Fig_NosePoke), subplot(5,1,1:2), title('ACQUISITION STOPPED')
        enableTrack=0;
        set(maskbutton.StartSession,'enable','on','FontWeight','normal')
        set(maskbutton.StopSession,'enable','off','FontWeight','normal')
        fwrite(a,arduinoDictionary.Off);
        disp('Intan OFF');
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
        set(GuiForSleep ,'Color', color_on);
        
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
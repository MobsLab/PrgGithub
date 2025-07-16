function [numF,filename]=TrackingHeadFixed_MFBCalibration_listener(~,~)

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

%% Variables that are specific to this code
% General thresholds and display
global time_image;time_image = 1/TrObjLocal.frame_rate; % coutn time between frames
global UpdateImage; UpdateImage=ceil(TrObjLocal.frame_rate/5); % update every n frames the picture shown on screen to show at 10Hz
global writerObj  % allows us to save as .avi
global enableTrack % Controls whether the tracking is on or not
global StartTrials
global WaitingForRelease
global ArduinoDataRequested
% Variables for plotting
global thimmobline % line that shows current freezing threshold
global PlotTrials % the name of the Plot that shows im_diff
global PlotTrialsSmo
global StartChrono, StartChrono=0; % Variable set to one when the tracking begins
% the handle of the chronometer object
global PlotForVideo % the plot that will be saved to .avi if needed
global GuiForHeadFixed % slides with specific values for this protocol
global color_on; color_on=[0 0 0];
global dataLogIndex;
global dataLog;
global current_L1_state;
global last_L1_change_time_abs;
global current_L2_state;
global last_L2_change_time_abs;
global L1_Status
global L2_Status
global L1_OnDuration
global L2_OnDuration


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
KeepTime.InterTrialStart = clock;
KeepTime.TrialStart = clock;

% contains
% - t1,t2 for tracking time between frames
% - tDeb for tracking length of session ; ...
% - chrono to dsplay passing of time

% Freezing/HeadFixed detection
global th_immob; th_immob=20;
global thtps_immob; thtps_immob=2;
global maxyaxis ymax; maxyaxis=500;ymax=50;
global max_trial_xaxis;max_trial_xaxis=800;
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
arduinoDictionary.On = num2str(1); % Tells Intan its time to go
arduinoDictionary.TenFrames = num2str(2); % Sync with intan every 1000 frames
arduinoDictionary.Off = num2str(3); % switches Intan off
arduinoDictionary.SendMFBStim = num2str(4); % Open window for lever 1
arduinoDictionary.SendPAGStim = num2str(5); % Open window for lever 2
arduinoDictionary.SwicthOnLED = num2str(6); % Open window for lever 2
arduinoDictionary.SwicthOffLED = num2str(7); % Open window for lever 2

global s_port; % arduino
existingPorts = serialportfind(); % Find all active serialport objects

TrialON = 0;
%% Task parameters
global nametypes; nametypes={'MFB Calibration'};

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% graphical interface n???1 with all the pushbuttons

Fig_HeadFixedSession=figure('units','normalized','position',[0.05 0.05 0.9 0.9],...
    'numbertitle','off','name','BasicHeadFixedProtocol','menubar','none','tag','figure Odor');
set(Fig_HeadFixedSession,'Color',color_on);

maskbutton.Inputs= uicontrol(Fig_HeadFixedSession,'style','pushbutton',...
    'units','normalized','position',[0.01 0.9 0.1 0.05],...
    'string','1- INPUTS EXPE','callback', @giv_inputs);
set(maskbutton.Inputs,'enable','on','FontWeight','bold')

if isempty(existingPorts)
    maskbutton.Arduino= uicontrol(Fig_HeadFixedSession,'style','pushbutton',...
        'units','normalized','position',[0.01 0.8 0.1 0.05],...
        'string','2 - Start arduino','callback', @start_ardunio);
    set(maskbutton.Arduino,'enable','on','FontWeight','bold')
else
    maskbutton.Arduino= uicontrol(Fig_HeadFixedSession,'style','pushbutton',...
        'units','normalized','position',[0.01 0.8 0.1 0.05],...
        'string','2 - arduino ON','callback', @start_ardunio);
    set(maskbutton.Arduino,'enable','off','FontWeight','bold')

end

maskbutton.StartExpe= uicontrol(Fig_HeadFixedSession,'style','pushbutton',...
    'units','normalized','position',[0.01 0.7 0.1 0.05],...
    'string','3- START EXPE','callback', @start_Expe);
set(maskbutton.StartExpe,'enable','off')

maskbutton.StartSession= uicontrol(Fig_HeadFixedSession,'style','pushbutton',...
    'units','normalized','position',[0.01 0.6 0.1 0.05],'string','4- START session');
set(maskbutton.StartSession,'enable','off','callback', @StartSession)

maskbutton.StopSession= uicontrol(Fig_HeadFixedSession,'style','pushbutton',...
    'units','normalized','position',[0.01 0.1 0.1 0.05],...
    'string','Stop Emergency','callback', @stop_Phase);
set(maskbutton.StopSession,'enable','off')

maskbutton.Quit= uicontrol(Fig_HeadFixedSession,'style','pushbutton',...
    'units','normalized','position',[0.01 0.03 0.1 0.05],...
    'string','CLOSE EXPE','callback', @quit);
set(maskbutton.Quit,'enable','on','FontWeight','bold')

inputDisplay.FileName=uicontrol(Fig_HeadFixedSession,'style','text','units','normalized','position',[0.25 0.95 0.5 0.02],'string','Filename = TO DEFINE','FontSize',10,'BackgroundColor',color_on,'ForegroundColor','w','FontWeight','bold');
inputDisplay.SessNum=uicontrol(Fig_HeadFixedSession,'style','text','units','normalized','position',[0.01 0.5 0.16 0.02],'string','Session','FontSize',12,'BackgroundColor',color_on,'ForegroundColor','w','FontWeight','bold');


chronoshow=uicontrol('style','edit', 'units','normalized','position',[0.01 0.4 0.05 0.05],...
    'string',num2str(floor(0)),'ForegroundColor','g','BackgroundColor','k','FontSize',12);
chronostim=uicontrol('style','edit', 'units','normalized','position',[0.1 0.4 0.05 0.05],...
    'string',num2str(floor(0)),'ForegroundColor','g','BackgroundColor','k','FontSize',12);


uicontrol('Style', 'text', 'String', 'L1:', ... % Label for the indicator
    'units','normalized','position',[0.01 0.35 0.05 0.02],...
    'ForegroundColor','w','BackgroundColor','k','FontSize',10);
maskbutton.h_L1_radio_button = uicontrol('Style', 'togglebutton', 'String', '', ... % No text, just for color
    'units','normalized','position',[0.01 0.32 0.05 0.02],...
    'Enable', 'off', ... % Make it non-clickable
    'BackgroundColor', [1 1 1]); % Start as white (RGB for white)
maskbutton.L1_duration=uicontrol('Style', 'text', 'units','normalized','position',[0.01 0.26 0.05 0.02],...
    'string',num2str(floor(0)),'ForegroundColor','w','BackgroundColor','k','FontSize',12);

uicontrol('Style', 'text', 'String', 'L2:', ... % Label for the indicator
    'units','normalized','position',[0.1 0.35 0.05 0.02],...
    'ForegroundColor','w','BackgroundColor','k','FontSize',10);
maskbutton.h_L2_radio_button = uicontrol('Style', 'togglebutton', 'String', '', ... % No text, just for color
    'units','normalized','position',[0.1 0.32 0.05 0.02],...
    'Enable', 'off', ... % Make it non-clickable
    'BackgroundColor', [1 1 1]); % Start as white (RGB for white)
maskbutton.L2_duration=uicontrol('Style', 'text', 'units','normalized','position',[0.1 0.26 0.05 0.02],...
    'string',num2str(floor(0)),'ForegroundColor','w','BackgroundColor','k','FontSize',12);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CALLED FUNCTIONS

% -----------------------------------------------------------------
%% function to quit the programm
    function quit(obj,event)
        enableTrack=0;
        try close(guireg_fig);end
        try close(GuiForHeadFixed);end
        delete(Fig_HeadFixedSession)
    end

    function start_ardunio(obj,event)
        poi=inputdlg('What num arduino?'); poi=str2double(poi);
        s_port = serialport(['COM' num2str(poi)], 115500);
        set(maskbutton.Arduino,'string','2 - arduino ON');

    end


%% Ask for all inputs and display
    function giv_inputs(obj,event)

        strfcts=strjoin(nametypes,'|');
        u2=uicontrol(Fig_HeadFixedSession,'Style', 'popup','String', strfcts,'units','normalized',...
            'Position', [0.01 0.84 0.1 0.05],'Callback', @setprotoc);

        % First stimulation output
        if strcmp('New PulsePal',Stimulator)
            % MFB parameters
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
            ProgramPulsePalParam(3,'LinkTriggerChannel2', 0);
            ProgramPulsePalParam(4,'LinkTriggerChannel1', 0);
            ProgramPulsePalParam(4,'LinkTriggerChannel2', 0);

        end

        function setprotoc(obj,event)
            fctname=get(obj,'value');
            ExpeInfo.namePhase=nametypes(fctname);ExpeInfo.namePhase=ExpeInfo.namePhase{1};
            % Save the information
            savProtoc
        end


        function savProtoc(obj,event)

            switch  ExpeInfo.namePhase
                case 'MFB Calibration'

                    default_answer{1}='007'; % Mouse number
                    default_answer{2}=num2str(100); % Trial Number
                    default_answer{3}='2'; % MFB Voltage
                    default_answer{4}='2'; % Trial duration
                    default_answer{5}='4'; % no press period
                    default_answer{6}='0.5'; % min lever press

                    answer = inputdlg({'NumberMouse','TrialNumber', 'VoltageMFB','Trial Duration',',No Pres ITI','Min press Dur'},'INFO',1,default_answer);
                    default_answer=answer; save default_answer default_answer

                    ExpeInfo.nmouse=str2double(answer{1});
                    ExpeInfo.TrialNumber = str2double(answer{2});
                    ExpeInfo.VoltageMFB = str2double(answer{3});
                    ExpeInfo.TrialDuration = str2double(answer{4});
                    ExpeInfo.ITIDuration = str2double(answer{5});
                    ExpeInfo.MinLeverDown = str2double(answer{6});
                    ExpeInfo.nPhase=0;

                    % No Pag, set to 0
                    ExpeInfo.VoltagePAG = 0;

                    % Set up trial structure
                    ExpeInfo.TrialId = ones(ExpeInfo.TrialNumber,1);
                    ExpeInfo.TrialResult = nan(ExpeInfo.TrialNumber,1);
                    ExpeInfo.AllEvents = nan(1,2);

                    if strcmp('New PulsePal',Stimulator)

                        ProgramPulsePalParam(1,'Phase1Voltage', ExpeInfo.VoltageMFB);
                        ProgramPulsePalParam(1,'Phase2Voltage', -(ExpeInfo.VoltageMFB));
                        ProgramPulsePalParam(2,'Phase1Voltage', ExpeInfo.VoltagePAG);
                        ProgramPulsePalParam(2,'Phase2Voltage', -(ExpeInfo.VoltagePAG));

                    end

            end

            nameTASK=['MFB Calibration - ' ExpeInfo.namePhase];
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
        switch  ExpeInfo.namePhase
            case 'MFB Calibration'
                ExpeInfo.name_folder=['HeadFixed-Mouse-' num2str(ExpeInfo.nmouse) '-' ExpeInfo.TodayIs '-' ExpeInfo.namePhase '-' num2str(ExpeInfo.VoltageMFB) 'V'];
        end


        configureCallback(s_port, "terminator", @readPinStatusCallback);
        s_port.Timeout = 0.5;
        dataLogIndex = 0;
        dataLog = {};
        set(maskbutton.StartExpe,'enable','on','FontWeight','normal','string','3- START EXPE (OK)')

        if enableTrack
            set(inputDisplay.SessNum,'string',['Session ',num2str(ExpeInfo.nPhase),' :'])

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


            % enable button to start session
            set(maskbutton.StartSession,'enable','on','FontWeight','bold')

            PerformTracking;
        end
    end

% -----------------------------------------------------------------
%% StartSession
    function StartSession(obj,event)


        % Tell the arduino we're starting
        writeline(s_port,arduinoDictionary.On);

        StartTrials = 0;
        % Open arduino window for firt press
        set(inputDisplay.TrialId,'String','Waiting first press ')

        % set the buttons to avoid problems
        set(maskbutton.StopSession,'enable','on','FontWeight','bold')
        set(maskbutton.StartSession,'enable','off','FontWeight','normal')
        % Tell the experimenter we're starting
        % Initialize time
        KeepTime.tDeb = clock;
        % Go signal for tracking code
        StartChrono=1;
        % First trial starts here
        KeepTime.CurrentTrial = 1;
        KeepTime.EpochStart = clock; % Duration of ITI or trial
        KeepTime.Status = 'Trial'; % trial or ITI

    end

% -----------------------------------------------------------------
%% track mouse
    function PerformTracking(obj,event)

        KeepTime.chrono=0;
        set(chronoshow,'string',num2str(0));
        disp('Begining tracking...')


        % -------------------
        % display zone

        figure(Fig_HeadFixedSession),
        PlotForVideo=subplot(5,1,1:3);
        htrack = imagesc(TrObjLocal.ref);axis image; hold on
        line([10 20]*TrObjLocal.Ratio_IMAonREAL,[10 10],'Color','k','Linewidth',3)
        text(15*TrObjLocal.Ratio_IMAonREAL,15,'10 cm','Color','k')
        title('ACQUISITION ON')
        caxis([0.1 0.9])
        % change for comrpession
        colormap(gray)

        im_diff=0;
        figure(Fig_HeadFixedSession), subplot(5,5,21:25)
        PlotTrials = bar(1:length(ExpeInfo.TrialResult),ExpeInfo.TrialResult);
        hold on
        PlotTrialsSmo = plot(1:length(ExpeInfo.TrialResult),double(ExpeInfo.TrialResult));%,'r','linewidth',3);
        xlim([0,ExpeInfo.TrialNumber]);
        ylim([-0.1 1.2]);

        % Follow TrialNumber and Type
        inputDisplay.TrialId=uicontrol(Fig_HeadFixedSession,'style','text','units','normalized','position',[0.01 0.15 0.1 0.1],'string',...
            'TrialID','FontSize',10,'BackgroundColor',color_on,'ForegroundColor','w','FontWeight','bold');


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
        set(chronostim,'ForegroundColor','g','String',[num2str(0) '/' num2str(ExpeInfo.TrialNumber)]);

        % To save as a compressed file
        writerObj = VideoWriter([ExpeInfo.name_folder filesep ExpeInfo.Fname '.avi']);
        open(writerObj);

        PosMat=[];im_diff=[]; GotFrame = []; MouseTemp=[];
        L1_Status = 1;
        L2_Status = 1;
        L1_OnDuration = 0;
        L2_OnDuration = 0;
        current_L1_state = 1;
        current_L2_state = 1;
        last_L1_change_time_abs = clock;
        last_L2_change_time_abs = clock;
        IM=TrObjLocal.GetAFrame;
        ExpeInfo.TrialId = ones(ExpeInfo.TrialNumber,1);
        ExpeInfo.TrialResult = nan(ExpeInfo.TrialNumber,1);
        ExpeInfo.AllEvents = nan(1,2);

        OldIm=TrObjLocal.mask;
        OldZone=TrObjLocal.mask;

        % The code waits here until enableTrack is set to 1 by StartSession

        while enableTrack

            % Activate the camera and send the image to the workspace
            pause(time_image-etime(KeepTime.t2,KeepTime.t1));

            % update KeepTime.chrono
            KeepTime.t1 = clock;
            IM=TrObjLocal.GetAFrame;


            % ---------------------------------------------------------

            if StartChrono

                % How long since the beginning of the session
                KeepTime.chrono=etime(KeepTime.t1,KeepTime.tDeb);
                set(chronoshow,'string',[num2str(floor(KeepTime.chrono)) ' s']);
                time(num_fr,1)=KeepTime.chrono; % Time


                % -------------------------------------------------------------------------------
                % -------------------------------- Camera display   --------------------------------

                % Update displays at 10Hz - faster would just be a waste of
                % time
                % For compression the actual picture is updated faster so
                % as to save it



                if strcmp(TrObjLocal.camera_type,'Webcam')
                    if length(size(IM))==3
                        IM = rgb2gray(IM);
                    end
                    frame.cdata = cat(3,IM,IM,IM);
                    frame.colormap = [];
                    try,writeVideo(writerObj,frame);GotFrame(num_fr) = 1;catch, GotFrame(num_fr) = 0;disp('missed frame video'),end
                else
                    frame.cdata = cat(3,IM,IM,IM);
                    frame.colormap = [];
                    try,writeVideo(writerObj,frame);GotFrame(num_fr) = 1;catch, GotFrame(num_fr) = 0; disp('missed frame video'),end
                end

                [ImDiff,NewIm]=ImDiffOnly(IM,TrObjLocal.mask,OldIm,TrObjLocal.camera_type);
                im_diff(num_fr,1)=KeepTime.chrono;
                im_diff(num_fr,2)=ImDiff;

                % Update visualizatoin
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

                if mod(num_fr,10) == 0
                    writeline(s_port, arduinoDictionary.TenFrames);

                end


                % -------------------------------------------------------------------------------
                % ------------------- Behaviour  -----------------------
                if StartTrials

                    [L1_Status, L2_Status, L1_OnDuration, L2_OnDuration] = getLeverDataAndStatus(KeepTime.t1);
                    switch KeepTime.Status
                        case       'Trial'
                            if etime(KeepTime.t1,KeepTime.EpochStart) >ExpeInfo.TrialDuration
                                % end of trial, switch to ITI
                                writeline(s_port, arduinoDictionary.SwicthOffLED);
                                KeepTime.Status = 'ITI';
                                KeepTime.EpochStart = clock;
                                set(inputDisplay.TrialId,'String','ITI')
                                ExpeInfo.TrialResult(KeepTime.CurrentTrial) = 0;
                                KeepTime.CurrentTrial = KeepTime.CurrentTrial+1;
                                ExpeInfo.AllEvents = [ExpeInfo.AllEvents;[9,KeepTime.chrono]];% 9 = ITI ON
                            elseif    L1_OnDuration > ExpeInfo.MinLeverDown |  L2_OnDuration > ExpeInfo.MinLeverDown
                                set(inputDisplay.TrialId,'String','Stim')
                                writeline(s_port, arduinoDictionary.SendMFBStim);
                                ExpeInfo.TrialResult(KeepTime.CurrentTrial) = double(L1_OnDuration > ExpeInfo.MinLeverDown)*1+double(L2_OnDuration > ExpeInfo.MinLeverDown)*-1;
                                % end of trial, switch to ITI
                                KeepTime.Status = 'ITI';
                                KeepTime.EpochStart = clock;
                                set(inputDisplay.TrialId,'String','ITI')
                                KeepTime.CurrentTrial = KeepTime.CurrentTrial+1;
                                ExpeInfo.AllEvents = [ExpeInfo.AllEvents;[5,KeepTime.chrono]];% 5 = stim
                                ExpeInfo.AllEvents = [ExpeInfo.AllEvents;[9,KeepTime.chrono]];% 9 = ITI ON

                            end

                        case       'ITI'
                            writeline(s_port, arduinoDictionary.SwicthOffLED);
                            if etime(KeepTime.t1,KeepTime.EpochStart) >ExpeInfo.ITIDuration & L1_Status ==1 & L2_Status == 1 % levers off
                                % end of ITI, switch to Trial
                                writeline(s_port, arduinoDictionary.SwicthOnLED);
                                KeepTime.Status = 'Trial';
                                KeepTime.EpochStart = clock;
                                set(inputDisplay.TrialId,'String','Trial ON')
                                ExpeInfo.AllEvents = [ExpeInfo.AllEvents;[8,KeepTime.chrono]];% 8 = Trial ON
                                set(chronostim,'ForegroundColor','g','String',[num2str(KeepTime.CurrentTrial) '/' num2str(ExpeInfo.TrialNumber)]);
                            elseif L1_Status ==0 | L2_Status == 0
                                % if one lever is pressed, ITI keeps
                                % restarting
                                KeepTime.EpochStart = clock;
                            end
                            PlotTrials.YData = (ExpeInfo.TrialResult)*0.2;
                            PlotTrialsSmo.YData = smooth(double((ExpeInfo.TrialResult)~=0),5).*~isnan(ExpeInfo.TrialResult);


                    end

                    

                else
                    [L1_Status, L2_Status, L1_OnDuration, L2_OnDuration] = getLeverDataAndStatus(KeepTime.t1);
                    if L1_Status==0 | L2_Status==0
                        StartTrials = 1;
                        set(inputDisplay.TrialId,'String','Trial ON')
                    end
                end





                num_fr=num_fr+1;
                KeepTime.t2 = clock;

                % Check if we've gone over the decided phase length and end the
                % tracking
                if StartChrono && KeepTime.CurrentTrial>ExpeInfo.TrialNumber
                    enableTrack=0;
                end
            end
        end

        writeline(s_port, arduinoDictionary.Off); % switch off intan
        save([ExpeInfo.name_folder,filesep,'behavResources.mat'],'time', 'GotFrame','im_diff','ExpeInfo');
        clear ref mask Ratio_IMAonREAL 


        % save and copy file in save_folder
        msg_box=msgbox('Saving behavioral Information','save','modal');
        % Shut the video if compression was being done on the fly
        close(writerObj);

        pause(0.5)
        try 
            set(PlotTrials,'YData',0,'XData',0); delete(PlotTrials);
            set(PlotTrialsSmo,'YData',0,'XData',0); delete(PlotTrialsSmo);
        end

        %% generate figure that gives overviewof the tracking session

        % update display and button availability
        try
            close(guireg_fig)
            close(GuiForHeadFixed)
            set(Fig_HeadFixedSession,'Color',color_on);
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
        figure(Fig_HeadFixedSession), subplot(5,1,1:2), title('ACQUISITION STOPPED')
        enableTrack=0;
        set(maskbutton.StartSession,'enable','on','FontWeight','normal')
        set(maskbutton.StopSession,'enable','off','FontWeight','normal')
        try fwrite(a,arduinoDictionary.Off);disp('Intan OFF');end
        close(writerObj);
        clear PlotTrialsSmo PlotTrials
    end

    function UMaze_OnlineGuiReglage
        % function GuiForHeadFixed=OnlineGuiReglage(obj,event);
        % let online control of paramteres for image treatments

        % create figure
        GuiForHeadFixed=figure('units','normalized',...
            'position',[0.1 0.1 0.2 0.6],...
            'numbertitle','off',...
            'name','UMaze Mouse Tracking : Setting Parameters',...
            'menubar','none',...
            'tag','figure reglage');
        set(GuiForHeadFixed,'Color',color_on);

        textUM1=uicontrol(GuiForHeadFixed,'style','text', ...
            'units','normalized',...
            'position',[0.22 0.85 0.2 0.05],...
            'string','freezing threshold');

        textUM2=uicontrol(GuiForHeadFixed,'style','text', ...
            'units','normalized',...
            'position',[0.62 0.85 0.2 0.05],...
            'string','Yaxis');

        % create sliders
        slider_freeze = uicontrol(GuiForHeadFixed,'style','slider',...
            'units','normalized',...
            'position',[0.25 0.1 0.15 0.7],...
            'callback', @freeze_thresh);
        set(slider_freeze,'Value',th_immob/maxth_immob);

        slider_yaxis = uicontrol(GuiForHeadFixed,'style','slider',...
            'units','normalized',...
            'position',[0.65 0.1 0.15 0.7],...
            'callback', @fixyaxis);
        set(slider_yaxis,'Value',ymax/maxyaxis);

        % create labels with actual values
        textUM3=uicontrol(GuiForHeadFixed,'style','text', ...
            'units','normalized',...
            'position',[0.22 0.05 0.2 0.03],...
            'string',num2str(th_immob));

        textUM4=uicontrol(GuiForHeadFixed,'style','text', ...
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

    function readPinStatusCallback(obj, event)

        try
            data = read(obj,obj.NumBytesAvailable, 'char');
            newTimestamp = clock;

            % deal with really quick presses
            NumPresses = length(findstr(data,':'));
            for press = 1:NumPresses
                dataLogIndex = dataLogIndex + 1;
                dataLog{dataLogIndex, 1} = newTimestamp+(press-1)*0.01;
                dataLog{dataLogIndex, 2} = data(1:4);
                data(1:4) = [];
            end

        catch ME
            fprintf(2, 'Callback Error: %s\n', ME.message);
        end
    end

    function [L1_Status, L2_Status, L1_OnDuration, L2_OnDuration] = getLeverDataAndStatus(current_loop_time_abs)
        % getLeverDataAndStatus - Processes incoming serial data, updates lever states and durations,
        %                         and returns their current status.
        %
        % This function is intended to be called repeatedly within a main loop.
        % It handles:
        %   1. Processing new lines from the global dataLog (populated by serial callback).
        %   2. Parsing lever ID and value.
        %   3. Updating internal global variables for current lever state, last change time,
        %      and trigger flags (though flags are only reset here, not acted upon).
        %   4. Calculating current continuous ON durations.
        %
        % Inputs:
        %   current_loop_time_abs - The current absolute time (datetime object) from the main loop.
        %                           Used for accurate duration calculation.
        %
        % Outputs:
        %   L1_Status    - Current state of Lever 1 (0 for LOW, 1 for HIGH, -1 if unknown/not initialized)
        %   L2_Status    - Current state of Lever 2 (0 for LOW, 1 for HIGH, -1 if unknown/not initialized)
        %   L1_OnDuration - Continuous ON duration of Lever 1 in seconds (0 if LOW or unknown)
        %   L2_OnDuration - Continuous ON duration of Lever 2 in seconds (0 if LOW or unknown)

        % Access Global Variables

       

        if isempty(current_L1_state)
            current_L1_state = 1;
        end
        if isempty(current_L2_state)
            current_L2_state = 1;
        end
        if isempty(last_L1_change_time_abs)
            last_L1_change_time_abs = clock;
        end
        if isempty(last_L2_change_time_abs)
            last_L2_change_time_abs = clock;
        end


        % Initialize outputs in case globals aren't set yet or no data processed
        L1_Status = -1;
        L2_Status = -1;
        L1_OnDuration = 0;
        L2_OnDuration = 0;

        % --- Process data received from Arduino (via dataLog populated by callback) ---
        if ~isempty(dataLog)
            for i = 1:size(dataLog, 1)
                timestamp_received = dataLog{i, 1}; % Absolute time of reception
                data_string = dataLog{i, 2};

                [lever_id, lever_value_str] = strtok(data_string, ':');
                lever_value = str2double(lever_value_str(2:end));

                if ~isnan(lever_value) % Ensure parsing successful and value is 0 or 1

                    if strcmp(lever_id, 'L1')
                        if lever_value ~= current_L1_state % State has changed
                            last_L1_change_time_abs = timestamp_received; % Record time of change
                            current_L1_state = lever_value;
                            ExpeInfo.AllEvents = [ExpeInfo.AllEvents;[(-double(current_L1_state)*2)-1,KeepTime.chrono]];% 1 or -1 lever 1 changes
                        end
                    elseif strcmp(lever_id, 'L2')
                        if lever_value ~= current_L2_state % State has changed
                            last_L2_change_time_abs = timestamp_received; % Record time of change
                            current_L2_state = lever_value;
                            ExpeInfo.AllEvents = [ExpeInfo.AllEvents;[((-double(current_L2_state)*2)-1)*2,KeepTime.chrono]];% 1 or -1 lever 1 changes
                        end
                    end
                end
            end
            dataLog = {}; % Clear after processing all entries
            dataLogIndex = 0;
        end

        % --- Calculate Durations for Output ---
        % L1
        if ~isempty(current_L1_state)
            L1_Status = current_L1_state;
            if L1_Status == 0 % Only calculate duration if currently pressed
                L1_OnDuration = etime(current_loop_time_abs, last_L1_change_time_abs);

            end
        end
        set(maskbutton.L1_duration,'string',num2str(L1_OnDuration))

        % L2
        if ~isempty(current_L2_state)
            L2_Status = current_L2_state;
            if L2_Status == 0 % Only calculate duration if currently pressed
                    L2_OnDuration = etime(current_loop_time_abs, last_L2_change_time_abs);
                
            end
        end
        set(maskbutton.L2_duration,'string',num2str(L2_OnDuration))

        % Optional: Warning if no data has been processed yet
        if isempty(current_L1_state) && isempty(current_L2_state) && isempty(dataLog)
            % This warning might be too frequent if the Arduino isn't sending data yet.
            % Consider if you truly need it.
            % fprintf(2, 'WARNING: No lever data processed yet. Are globals initialized and Arduino sending data?\n');
        end

        % Update radiobutton
        if current_L1_state == 0
            maskbutton.h_L1_radio_button.BackgroundColor = 'g';
        else
            maskbutton.h_L1_radio_button.BackgroundColor = 'w';
        end
        if current_L2_state == 0
            maskbutton.h_L2_radio_button.BackgroundColor = 'g';
        else
            maskbutton.h_L2_radio_button.BackgroundColor = 'w';
        end

    end % End of getLeverDataAndStatus function

end

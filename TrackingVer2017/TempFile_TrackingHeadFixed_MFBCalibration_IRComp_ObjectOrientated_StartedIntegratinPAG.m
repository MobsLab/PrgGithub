function [numF,filename]=TrackingHeadFixed_MFBCalibration_IRComp_ObjectOrientated(~,~)

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

% Variables for plotting
global thimmobline % line that shows current freezing threshold
global PlotTrials % the name of the Plot that shows im_diff
global PlotTrialsSmo
global StartChrono, StartChrono=0; % Variable set to one when the tracking begins
% the handle of the chronometer object
global PlotForVideo % the plot that will be saved to .avi if needed
global GuiForHeadFixed % slides with specific values for this protocol
global color_on; color_on=[0 0 0];
global CalibTimes;  CalibTimes=[50,70,90,110,150,170,Inf]; 

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
arduinoDictionary.On=1; % Tells Intan its time to go
arduinoDictionary.TenFrames=2; % Sync with intan every 1000 frames
arduinoDictionary.Off=3; % switches Intan off
arduinoDictionary.StimulationWindowOpen_Lever1 = 4; % Open window for lever 1
arduinoDictionary.StimulationWindowOpen_Lever2 = 5; % Open window for lever 2
arduinoDictionary.PagStimulation = 8; % Send a PAG stimulation
arduinoDictionary.StimulationWindowClose = 9; % Close which ever window is open
TrialON = 0;
%% Task parameters
global nametypes; nametypes={'MFB Calibration','PAG Calibration'};

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% graphical interface n???1 with all the pushbuttons

Fig_HeadFixedSession=figure('units','normalized','position',[0.1 0.1 0.6 0.85],...
    'numbertitle','off','name','BasicHeadFixedProtocol','menubar','none','tag','figure Odor');
set(Fig_HeadFixedSession,'Color',color_on);

maskbutton.Inputs= uicontrol(Fig_HeadFixedSession,'style','pushbutton',...
    'units','normalized','position',[0.01 0.89 0.2 0.05],...
    'string','1- INPUTS EXPE','callback', @giv_inputs);
set(maskbutton.Inputs,'enable','on','FontWeight','bold')

maskbutton.StartExpe= uicontrol(Fig_HeadFixedSession,'style','pushbutton',...
    'units','normalized','position',[0.01 0.65 0.2 0.05],...
    'string','3- START EXPE','callback', @start_Expe);
set(maskbutton.StartExpe,'enable','off')

maskbutton.StartSession= uicontrol(Fig_HeadFixedSession,'style','pushbutton',...
    'units','normalized','position',[0.01 0.48 0.2 0.05],'string','4- START session');
set(maskbutton.StartSession,'enable','off','callback', @StartSession)

maskbutton.StopSession= uicontrol(Fig_HeadFixedSession,'style','pushbutton',...
    'units','normalized','position',[0.025 0.36 0.15 0.03],...
    'string','Stop Emergency','callback', @stop_Phase);
set(maskbutton.StopSession,'enable','off')

maskbutton.Quit= uicontrol(Fig_HeadFixedSession,'style','pushbutton',...
    'units','normalized','position',[0.01 0.03 0.2 0.05],...
    'string','CLOSE EXPE','callback', @quit);
set(maskbutton.Quit,'enable','on','FontWeight','bold')

inputDisplay.FileName=uicontrol(Fig_HeadFixedSession,'style','text','units','normalized','position',[0.25 0.95 0.5 0.02],'string','Filename = TO DEFINE','FontSize',10,'BackgroundColor',color_on,'ForegroundColor','w','FontWeight','bold');
inputDisplay.SessNum=uicontrol(Fig_HeadFixedSession,'style','text','units','normalized','position',[0.01 0.59 0.16 0.02],'string','Session','FontSize',12,'BackgroundColor',color_on,'ForegroundColor','w','FontWeight','bold');
inputDisplay.Instructions=uicontrol(Fig_HeadFixedSession,'style','text','units','normalized','position',[0.01 0.56 0.16 0.02],'string','WAIT','FontSize',12,'BackgroundColor',color_on,'ForegroundColor','w','FontWeight','bold');

chronoshow=uicontrol('style','edit', 'units','normalized','position',[0.01 0.4 0.1 0.05],...
    'string',num2str(floor(0)),'ForegroundColor','g','BackgroundColor','k','FontSize',14);
chronostim=uicontrol('style','edit', 'units','normalized','position',[0.15 0.4 0.1 0.05],...
    'string',num2str(floor(0)),'ForegroundColor','g','BackgroundColor','k','FontSize',14);

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



%% Ask for all inputs and display
    function giv_inputs(obj,event)

        strfcts=strjoin(nametypes,'|');
        u2=uicontrol(Fig_HeadFixedSession,'Style', 'popup','String', strfcts,'units','normalized',...
            'Position', [0.01 0.84 0.2 0.05],'Callback', @setprotoc);

        % First stimulation output
        if strcmp('New PulsePal',Stimulator)
            % MFB parameters
            ProgramPulsePalParam(1,'IsBiphasic',1);
            ProgramPulsePalParam(1,'Phase1Voltage', 2);
            ProgramPulsePalParam(1,'Phase1Duration', 0.01);
            ProgramPulsePalParam(1,'InterPhaseInterval', 0);
            ProgramPulsePalParam(1,'Phase2Voltage', -2);
            ProgramPulsePalParam(1,'Phase2Duration', 0.01);
            ProgramPulsePalParam(1,'InterPulseInterval', 0);
            ProgramPulsePalParam(1,'BurstDuration', 0.1);
            ProgramPulsePalParam(1,'InterBurstInterval', 0);
            ProgramPulsePalParam(1,'PulseTrainDelay', 0);
            ProgramPulsePalParam(1,'PulseTrainDuration', 0.1);
            ProgramPulsePalParam(1,'LinkTriggerChannel1', 1);
            ProgramPulsePalParam(1,'LinkTriggerChannel2', 0);
            ProgramPulsePalParam(1,'RestingVoltage', 0);
            ProgramPulsePalParam(1,'TriggerMode', 0);
            
            % PAG parameters
            % ProgramPulsePalParam(2,'IsBiphasic',1);
            % ProgramPulsePalParam(2,'Phase1Voltage', 2);
            % ProgramPulsePalParam(2,'Phase1Duration', 0.01);
            % ProgramPulsePalParam(2,'InterPhaseInterval', 0);
            % ProgramPulsePalParam(2,'Phase2Voltage', -2);
            % ProgramPulsePalParam(2,'Phase2Duration', 0.01);
            % ProgramPulsePalParam(2,'InterPulseInterval', 0);
            % ProgramPulsePalParam(2,'BurstDuration', 0.1);
            % ProgramPulsePalParam(2,'InterBurstInterval', 0);
            % ProgramPulsePalParam(2,'PulseTrainDelay', 0);
            % ProgramPulsePalParam(2,'PulseTrainDuration', 0.1);
            % ProgramPulsePalParam(2,'LinkTriggerChannel1', 0);
            % ProgramPulsePalParam(2,'LinkTriggerChannel2', 1);
            % ProgramPulsePalParam(2,'RestingVoltage', 0);
            % ProgramPulsePalParam(2,'TriggerMode', 0);

            % PAG from DB code
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

                    default_answer{1}='007';
                    default_answer{2}=num2str(100);
                    default_answer{3}='2';
                    default_answer{4}='2';
                    default_answer{5}='4';

                    answer = inputdlg({'NumberMouse','TrialNumber', 'VoltageMFB','Trial Duration','InterTrialInterval'},'INFO',1,default_answer);
                    default_answer=answer; save default_answer default_answer

                    ExpeInfo.nmouse=str2double(answer{1});
                    ExpeInfo.TrialNumber = str2double(answer{2});
                    ExpeInfo.VoltageMFB = str2double(answer{3});
                    ExpeInfo.TrialDuration = str2double(answer{4});
                    ExpeInfo.InterTrialInterval = str2double(answer{5});
                    ExpeInfo.nPhase=0;

                    % No Pag, set to 0
                    ExpeInfo.VoltagePAG = 0;

                    % Set up trial structure
                    ExpeInfo.TrialId = ones(ExpeInfo.TrialNumber,1);
                    ExpeInfo.TrialResult = zeros(ExpeInfo.TrialNumber,1);

                    if strcmp('New PulsePal',Stimulator)

                        ProgramPulsePalParam(1,'Phase1Voltage', ExpeInfo.VoltageMFB);
                        ProgramPulsePalParam(1,'Phase2Voltage', -(ExpeInfo.VoltageMFB));
                        ProgramPulsePalParam(2,'Phase1Voltage', ExpeInfo.VoltagePAG);
                        ProgramPulsePalParam(2,'Phase2Voltage', -(ExpeInfo.VoltagePAG));

                    end
                    nameTASK=['MFB Calibration - ' ExpeInfo.namePhase];

                case 'PAG Calibration'
                    default_answer{1}='007';
                    default_answer{2}=num2str(100);
                    default_answer{3}='2';

                    answer = inputdlg({'NumberMouse','TrialNumber', 'VoltagePAG'},'INFO',1,default_answer);
                    default_answer=answer; save default_answer default_answer

                    ExpeInfo.nmouse=str2double(answer{1});
                    ExpeInfo.TrialNumber = str2double(answer{2});
                    ExpeInfo.VoltageMFB = str2double(answer{3});
                    ExpeInfo.nPhase=0;
                    ExpeInfo.lengthPhase=180;

                    % No Pag, set to 0
                    ExpeInfo.VoltageMFB= 0;

                    % Set up trial structure

                    if strcmp('New PulsePal',Stimulator)

                        ProgramPulsePalParam(1,'Phase1Voltage', ExpeInfo.VoltageMFB);
                        ProgramPulsePalParam(1,'Phase2Voltage', -(ExpeInfo.VoltageMFB));
                        ProgramPulsePalParam(2,'Phase1Voltage', ExpeInfo.VoltagePAG);
                        ProgramPulsePalParam(2,'Phase2Voltage', -(ExpeInfo.VoltagePAG));

                    end
                    nameTASK=['PAG Calibration - ' ExpeInfo.namePhase];

            end

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
        ExpeInfo.name_folder=['HeadFixed-Mouse-' num2str(ExpeInfo.nmouse) '-' ExpeInfo.TodayIs '-' ExpeInfo.namePhase];
        
                
        
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
        % First trial starts here
        KeepTime.CurrentTrial = 1;
        KeepTime.TrialStart = clock;

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
        PlotTrialsSmo = plot(1:length(ExpeInfo.TrialResult),runmean(ExpeInfo.TrialResult,5),'r','linewidth',3);
        xlim([0,ExpeInfo.TrialNumber]);
               ylim([0 1.2]);

        % Follow TrialNumber and Type
        inputDisplay.TrialId=uicontrol(Fig_HeadFixedSession,'style','text','units','normalized','position',[0.01 0.26 0.16 0.02],'string',...
            'TrialID','FontSize',12,'BackgroundColor',color_on,'ForegroundColor','w','FontWeight','bold');


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
                    fwrite(a, arduinoDictionary.TenFrames);

                end


                % -------------------------------------------------------------------------------
                % ------------------- Behaviour  -----------------------

                switch ExpeInfo.namePhase
                    case 'MFB Calibration'

                        if TrialON == 0 & etime(KeepTime.t1,KeepTime.InterTrialStart) > ExpeInfo.InterTrialInterval % next trial
                            % Tell adruino to open a new window that stimluates if
                            % lever press within ExpeInfo.TrialDuration seconds
                            fwrite(a,arduinoDictionary.StimulationWindowOpen_Lever1);
                            TrialON = 1;
                            KeepTime.TrialStart = clock;
                            KeepTime.CurrentTrial = KeepTime.CurrentTrial + 1;
                            set(chronostim,'string',[num2str(floor(KeepTime.CurrentTrial)) '/' num2str(ExpeInfo.TrialNumber)]);
                            set(inputDisplay.TrialId,'String','MFB available')
                        elseif TrialON == 1 & etime(KeepTime.t1,KeepTime.TrialStart) > ExpeInfo.TrialDuration % next trial
                            % Tell adruino to close windo and
                            % wait during the ITI
                            fwrite(a,arduinoDictionary.StimulationWindowClose);
                            TrialON = 0;
                            KeepTime.InterTrialStart = clock;
                            set(inputDisplay.TrialId,'String','InterTrial')
                            if a.BytesAvailable>0
                                bytes = a.BytesAvailable;
                                data = fread(a, bytes);
                                ExpeInfo.TrialResult(KeepTime.CurrentTrial) = eval(char(data'));
                            else
                                ExpeInfo.TrialResult(KeepTime.CurrentTrial) = 0;
                            end
                        end
                        set(PlotTrials,'ydata',ExpeInfo.TrialResult);
                        set(PlotTrialsSmo,'ydata',runmean(ExpeInfo.TrialResult,5));


                        % Check if we've gone over the decided phase length and end the
                        % tracking
                        if StartChrono && KeepTime.CurrentTrial>ExpeInfo.TrialNumber
                            enableTrack=0;
                        end


                    case 'PAG Calibration'

                        %% Calibration Protocols
                        if (strcmp('Calibration',ExpeInfo.namePhase))
                            if etime(clock,KeepTime.tDeb)>CalibTimes(KeepTime.CurrentTrial)
                                fwrite(a,arduinoDictionary.PagStimulation);
                                PosMat(end,4)=1;
                                KeepTime.CurrentTrial=KeepTime.CurrentTrial+1;
                                set(chronostim,'string',num2str(CalibTimes(KeepTime.CurrentTrial)));
                            end
                        end

                        % Check if we've gone over the decided phase length and end the
                        % tracking
                        if StartChrono &&  etime(KeepTime.t2,KeepTime.tDeb)> ExpeInfo.lengthPhase+0.5
                            enableTrack=0;
                        end
                end

                num_fr=num_fr+1;
                KeepTime.t2 = clock;


            end
        end

        fwrite(a,arduinoDictionary.Off); % switch off intan
        save([ExpeInfo.name_folder,filesep,'behavResources.mat'],'time', 'GotFrame','im_diff','ExpeInfo');
        clear ref mask Ratio_IMAonREAL


        % save and copy file in save_folder
        msg_box=msgbox('Saving behavioral Information','save','modal');
        % Shut the video if compression was being done on the fly
        close(writerObj);

        pause(0.5)
        try set(PlotTrials,'YData',0,'XData',0);end

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
        set(maskbutton.StartExpe,'enable','off')
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
end
function [numF,filename]=TrackingExploratoryStimulation_IRComp_ObjectOrientated(~,~)

%% This is the code that tracks whether the mouse is falling asleep (using immobility threshold),
%% and sends a signal to arduino about it. Arduino, when receive sleep signal and signal of reactivations
%% stimulates the mouse

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
global BW_threshold; BW_threshold{1}=0.5; BW_threshold{2}=0.5; 
global smaller_object_size; smaller_object_size{1}=30; smaller_object_size{2}=30; 
global sm_fact; sm_fact{1}=0;sm_fact{2}=0; 
global strsz se; strsz{1}=4;strsz{2}=4; se{1}=strel('disk',strsz{1});se{2}=strel('disk',strsz{2});
global SrdZone; SrdZone{1}=20;SrdZone{2}=20;
global guireg_fig % the figure that allows you to set these parameters


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
KeepTime.LastStim = cell(1,2);
% contains 
% - t1,t2 for tracking time between frames 
% - tDeb for tracking length of session 
% - chrono to dsplay passing of time

% Freezing/sleep detection
global th_immob; th_immob{1}=20; th_immob{2}=20; 
global thtps_immob;th_immob{1}=20; th_immob{2}=20; 
global maxyaxis ymax; maxyaxis{1}=500;ymax{1}=50;maxyaxis{2}=500;ymax{2}=50;
global maxfrvis;maxfrvis=800;
global maxth_immob; maxth_immob{1}=200; maxth_immob{2}=200 ;

global delStim; delStim=13;
global delStimreturn; delStimreturn=13;


% Time/date parameters
t=clock;
jour=num2str(t(3));if length(jour)==1, jour=cat(2,'0',jour);end
mois=num2str(t(2));if length(mois)==1, mois=cat(2,'0',mois);end
annee=num2str(t(1));
ExpeInfo.TodayIs=[jour mois annee];clear t jour mois annee

% arduino 
global a % the arduino
global arduinoDictionary % list of numbers to send to arduino for each case
arduinoDictionary.On = 1; % Tells Intan its time to go
arduinoDictionary.Off = 3; % switches Intan off
arduinoDictionary.ThousandFrames = 2; % Sync with intan every 1000 frames
arduinoDictionary.StartSleep{1} = 4; % This is sent when the mouse 1 enters a sleep epoch
arduinoDictionary.StopSleep{1} = 5; % This is sent when the mouse 1 enters a sleep epoch
arduinoDictionary.StartSleep{2} = 6; % This is sent when the mouse 2 enters a sleep epoch
arduinoDictionary.StopSleep{2} = 7; % This is sent when the mouse 2 enters a sleep epoch
arduinoDictionary.SendStim{1}=9; % This will send a stimulation for the mouse 1
arduinoDictionary.SendStim{2}=8; % This will send a stimulation for the mouse 2



%% Task parameters
global nametypes; nametypes={'BaselineSleep_0','StimulatedSleep_0'};
global MinSleepTime  StimOnTime StimOffTime
MinSleepTime=30;StimOnTime=1000;StimOffTime=10;
global  SleepChrono PeriodChrono StimOnOff
SleepChrono{1}=0; PeriodChrono{1}=0; StimOnOff{1}=0;
SleepChrono{2}=0; PeriodChrono{2}=0; StimOnOff{2}=0;
global MouseMask % This allows to readjust the mask to contain one mouse at a time for separate tracking

%% graphical interface n???1 with all the pushbuttons

Fig_SleepSession=figure('units','normalized','position',[0.1 0.1 0.4 0.85],...
    'numbertitle','off','name','SleepStimProtocol','menubar','none','tag','figure Odor');
set(Fig_SleepSession,'Color',color_on);

InterfaceButton.Inputs= uicontrol(Fig_SleepSession,'style','pushbutton',...
    'units','normalized','position',[0.01 0.89 0.2 0.05],...
    'string','1- INPUTS EXPE','callback', @giv_inputs);
set(InterfaceButton.Inputs,'enable','on','FontWeight','bold')

InterfaceButton.StartExpe= uicontrol(Fig_SleepSession,'style','pushbutton',...
    'units','normalized','position',[0.01 0.65 0.2 0.05],...
    'string','3- START EXPE','callback', @start_Expe);
set(InterfaceButton.StartExpe,'enable','off')

InterfaceButton.StartSession= uicontrol(Fig_SleepSession,'style','pushbutton',...
    'units','normalized','position',[0.01 0.48 0.2 0.05],'string','4- START session');
set(InterfaceButton.StartSession,'enable','off','callback', @StartSession)

InterfaceButton.StopSession= uicontrol(Fig_SleepSession,'style','pushbutton',...
    'units','normalized','position',[0.025 0.36 0.15 0.03],...
    'string','Stop Emergency','callback', @stop_Phase);
set(InterfaceButton.StopSession,'enable','off')

InterfaceButton.Quit= uicontrol(Fig_SleepSession,'style','pushbutton',...
    'units','normalized','position',[0.01 0.03 0.2 0.05],...
    'string','CLOSE EXPE','callback', @quit);
set(InterfaceButton.Quit,'enable','on','FontWeight','bold')


inputDisplay.FileName{1}=uicontrol(Fig_SleepSession,'style','text','units','normalized','position',[0.17 0.95 0.3 0.02],'string','Filename = TO DEFINE','FontSize',10,'BackgroundColor',color_on,'ForegroundColor','c','FontWeight','bold');
inputDisplay.FileName{2}=uicontrol(Fig_SleepSession,'style','text','units','normalized','position',[0.6 0.95 0.3 0.02],'string','Filename = TO DEFINE','FontSize',10,'BackgroundColor',color_on,'ForegroundColor','r','FontWeight','bold');
inputDisplay.SessNum=uicontrol(Fig_SleepSession,'style','text','units','normalized','position',[0.01 0.59 0.16 0.02],'string','Session','FontSize',12,'BackgroundColor',color_on,'ForegroundColor','w','FontWeight','bold');
inputDisplay.Instructions=uicontrol(Fig_SleepSession,'style','text','units','normalized','position',[0.01 0.56 0.16 0.02],'string','WAIT','FontSize',12,'BackgroundColor',color_on,'ForegroundColor','w','FontWeight','bold');

chronoshow=uicontrol('style','edit', 'units','normalized','position',[0.01 0.4 0.1 0.05],...
    'string',num2str(floor(0)),'ForegroundColor','g','BackgroundColor','k','FontSize',14);

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
        set(InterfaceButton.Inputs,'enable','off')

        global MouseNum
        MouseNum=1;
        
        nametypes{1}=[nametypes{1}(1:end-2),'_',num2str(MouseNum)];
        nametypes{2}=[nametypes{2}(1:end-2),'_',num2str(MouseNum)];
        
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
            Nm=nametypes(fctname);Nm=Nm{1};
            ExpeInfo.namePhase{1}=Nm(1:end-2);
            ExpeInfo.namePhase{2}=Nm(1:end-2);
            savProtoc
        end
        
        function savProtoc
            
            if strcmp('New PulsePal',Stimulator)
                
                for mm = 1:2
                    default_answer{1}='007';
                    default_answer{2}=num2str(10);
                    default_answer{3}='[0 0.5 1 1.5 2 2.5]';
            
                    answer = inputdlg({'NumberMouse','Session duration (s)', 'Vector of voltages in V'},'INFO',1,default_answer);
                    default_answer=answer; save default_answer default_answer
            
                    ExpeInfo.nmouse{mm}=str2double(answer{1});
                    ExpeInfo.lengthPhase=str2double(answer{2});
                    ExpeInfo.voltages{mm} = str2num(answer{3});
                    ExpeInfo.nPhase=0;
            
                    % get location of mouse's cage
                    TempFigMouseCage=figure;
                    [x1,y1,BW,y2]=roipoly(mat2gray(TrObjLocal.ref));
                    maskint=uint8(BW);
            
                    MouseMask{mm}=maskint;
                    close(TempFigMouseCage)
                    if MouseNum==1
                        MouseNum=2;
                        nametypes{1}=[nametypes{1}(1:end-2),'_',num2str(MouseNum)];
                        nametypes{2}=[nametypes{2}(1:end-2),'_',num2str(MouseNum)];
                        strfcts=strjoin(nametypes,'|');
                        set(u2,'String', strfcts);
                    elseif MouseNum==2
                        disp(' ');disp('-------------------- New Expe ---------------------');
                        set(InterfaceButton.Inputs,'FontWeight','normal','string','1- INPUTS EXPE (OK)');
                        set(InterfaceButton.StartExpe,'enable','on')
                        set(InterfaceButton.Inputs,'enable','on')
                    
                    end

                end
            end
        end
    end
    

% -----------------------------------------------------------------
%% Interface of analysis
    function start_Expe(obj,event)
        KeepTime.t1=clock;
        KeepTime.t2=clock;
        enableTrack=1;
        StartChrono=0;
        ExpeInfo.nPhase=ExpeInfo.nPhase+1;
        ExpeInfo.name_folder=['STIM-Mouse-' num2str(ExpeInfo.nmouse{1}) '&' num2str(ExpeInfo.nmouse{2}) '-' ExpeInfo.TodayIs];
        
        set(InterfaceButton.StartExpe,'enable','on','FontWeight','normal','string','3- START EXPE (OK)')
        
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
            set(inputDisplay.FileName{1},'string',['Mouse' num2str(ExpeInfo.nmouse{1}) '-' ExpeInfo.namePhase{1}]);
            set(inputDisplay.FileName{2},'string',['Mouse' num2str(ExpeInfo.nmouse{2}) '-' ExpeInfo.namePhase{2}]);

            pause(0.1)
            StartChrono=0;
            
            % check arduino is ready
            if size(a.Status,2)==6
                try fopen(a); end
            end
            
            % enable button to start session
            set(InterfaceButton.StartSession,'enable','on','FontWeight','bold')
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
        set(InterfaceButton.StopSession,'enable','on','FontWeight','bold')
        set(InterfaceButton.StartSession,'enable','off','FontWeight','normal')
        % Tell the arduino we're starting
        fwrite(a,arduinoDictionary.On);
        % Tell the experimenter we're starting
        set(inputDisplay.Instructions,'string','RECORDING');
        % Initialize time
        KeepTime.tDeb = clock;
        KeepTime.LastStim{1} = clock;
        KeepTime.LastStim{2} = clock;
        % Go signal for tracking code
        StartChrono=1;
    end

% -----------------------------------------------------------------
%% track mouse
    function PerformTracking(obj,event)
        
        KeepTime.chrono=0;
        set(chronoshow,'string',num2str(0));
        disp('Begining tracking...')
        guireg_fig{1}=OnlineGuiReglage_MultiMouse(1,'b');
        guireg_fig{2}=OnlineGuiReglage_MultiMouse(2,'r');
        GuiForSleep{1}=SleepStim_OnlineGuiReglage(1);
        GuiForSleep{2}=SleepStim_OnlineGuiReglage(2);

        % display zone
        figure(Fig_SleepSession),
        PlotForVideo{1}=subplot(5,2,[1,3]);
        htrack{1} = imagesc(TrObjLocal.ref);axis image; hold on
        line([10 20]*TrObjLocal.Ratio_IMAonREAL,[10 10],'Color','k','Linewidth',3)
        text(15*TrObjLocal.Ratio_IMAonREAL,15,'10 cm','Color','k')
        title('ACQUISITION ON')
        caxis([0.1 0.9])

        PlotForVideo{2}=subplot(5,2,[2,4]);
        htrack{2} = imagesc(TrObjLocal.ref);axis image; hold on
        caxis([0.1 0.9])

        % change for comrpession
        colormap(gray)
        
        figure(Fig_SleepSession), subplot(5,2,[5,7]),
        htrack2{1} = imagesc(zeros(size((TrObjLocal.ref))));axis image; caxis([0 1]);hold on
        xlabel('tracking online','Color','w')
        g{1}=plot(0,0,'c+');
        subplot(5,2,[6,8]),
        htrack2{2} = imagesc(zeros(size((TrObjLocal.ref))));axis image; caxis([0 1]);hold on
        xlabel('tracking online','Color','w')
        g{2}=plot(0,0,'r+');
        
        figure(Fig_SleepSession), 
        subplot(10,5,42:45)
        PlotFreez{1}=plot(0,0,'-b');
        hold on, thimmobline{1}=line([1,2000],[1 1]*th_immob{1},'Color','k');
        xlim([0,maxfrvis]);
        subplot(10,5,47:50)
        PlotFreez{2}=plot(0,0,'-r');
        hold on, thimmobline{2}=line([1,2000],[1 1]*th_immob{2},'Color','k');
        xlim([0,maxfrvis]);
        
        % INITIATE TRACKING
        n=1; % number of file that saves frames
        num_fr=1; % number of frames
        diffshow = zeros(size((TrObjLocal.ref)));

        
        % To save individual frames
        prefac0=char; for ii=1:4, prefac0=cat(2,prefac0,'0'); end
        ExpeInfo.Fname=['F' ExpeInfo.TodayIs '-' prefac0];
        disp(['   ',ExpeInfo.Fname]);
        mkdir([ExpeInfo.name_folder filesep ExpeInfo.Fname]);

        % To save as a compressed file
        writerObj = VideoWriter([ExpeInfo.name_folder filesep ExpeInfo.Fname '.avi']);
        open(writerObj);
        
        PosMatTemp{1}=[];im_diffTemp{1}=[]; MouseTemp{1} = [];
        PosMatTemp{2}=[];im_diffTemp{2}=[]; MouseTemp{2} = [];
        GotFrame = [];

        IM=TrObjLocal.GetAFrame;
        OldIm{1}=TrObjLocal.mask;OldIm{2}=TrObjLocal.mask;
        OldZone{1}=TrObjLocal.mask;OldZone{2}=TrObjLocal.mask;
        
        % The code waits here until enableTrack is set to 1 by StartSession
        
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
                
                for MouseNum=1:2
                % Find the mouse
                [Pos,ImDiff,PixelsUsed,NewIm,FzZone,x_oc,y_oc]=Track_ImDiff(IM,TrObjLocal.mask,TrObjLocal.ref,BW_threshold,smaller_object_size,sm_fact{MouseNum},se,SrdZone,...
                    TrObjLocal.Ratio_IMAonREAL,OldIm,OldZone,TrObjLocal.camera_type);
                
                if sum(isnan(Pos))==0
                    PosMatTemp{MouseNum}(num_fr,1)=KeepTime.chrono; % Time
                    PosMatTemp{MouseNum}(num_fr,2)=Pos(1); % XPos
                    PosMatTemp{MouseNum}(num_fr,3)=Pos(2); % YPose
                    PosMatTemp{MouseNum}(num_fr,4)=NaN; % You can store events here
                    im_diffTemp{MouseNum}(num_fr,1)=KeepTime.chrono; % Time
                    im_diffTemp{MouseNum}(num_fr,2)=ImDiff; % Number fo pixels changed
                    im_diffTemp{MouseNum}(num_fr,3)=PixelsUsed; % Size of zone used to calculate ImDiff
                    switch TrObjLocal.camera_type
                        case 'IRCamera'
                            MouseTemp{MouseNum}(num_fr,1)=KeepTime.chrono;
                            MouseTemp{MouseNum}(num_fr,2)=max(max(IM.*logical(MouseMask{MouseNum})));
                        case 'Webcam'
                            MouseTemp{MouseNum}(num_fr,1:2)=[KeepTime.chrono;NaN];
                    end
                else
                    PosMat{MouseNum}(num_fr,:)=[KeepTime.chrono;NaN;NaN;NaN];
                    im_diff{MouseNum}(num_fr,1:3)=[KeepTime.chrono;NaN;NaN];
                    MouseTemp{MouseNum}(num_fr,1:2)=[KeepTime.chrono;NaN];
                end
                
                
                %% Specific to stimulation protocol
                %% Change the voltages randomly
                Volt = datasample(ExpeInfo.voltages{MouseNum},1);
                ProgramPulsePalParam(MouseNum,'Phase1Voltage', Volt);
                ProgramPulsePalParam(MouseNum,'Phase2Voltage', -Volt);
                if ~isempty(PosMatTemp{MouseNum})
                    PosMatTemp{MouseNum}(end,4)=Volt;
                end
                
                                % Update displays at 10Hz - faster would just be a waste of time
                if  mod(num_fr-2,UpdateImage)==0
                    set(g{MouseNum},'Xdata',Pos(1).*TrObjLocal.Ratio_IMAonREAL,'YData',Pos(2).*TrObjLocal.Ratio_IMAonREAL)
                    diffshow=double(NewIm);
                    diffshow(FzZone==1)=0.4;
                    diffshow(OldZone{MouseNum}==1)=0.4;
                    diffshow(NewIm==1)=0.8;
                    set(htrack2{MouseNum},'Cdata',diffshow);
                    set(htrack{MouseNum},'Cdata',IM);
                    try
                        dattemp=im_diffTemp{MouseNum};
                        dattemp(isnan(im_diffTemp{MouseNum}(:,2)),2)=0;
                        set(PlotFreez{MouseNum},'YData',im_diffTemp{MouseNum}(max(1,num_fr-maxfrvis):end,2),'XData',[1:length(dattemp(max(1,num_fr-maxfrvis):end,2))]')
                    end
                    figure(Fig_SleepSession),   
                    subplot(10,5,42+(MouseNum-1)*5:45+(MouseNum-1)*5)
                    set(gca,'Ylim',[0 max(ymax{MouseNum},1e-5)]);
                end
                OldZone{MouseNum}=FzZone;
                OldIm{MouseNum}=NewIm;
                
                end
                
                %  SAVE FRAMES
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
                
                
                % --------------------- SAVE FRAMES every NumFramesToSave  -----------------------
                if TrObjLocal.SaveToMatFile==1
                    datas.image =IM;
                    datas.time = KeepTime.t1;
                    prefac1=char; for ii=1:6-length(num2str(n)), prefac1=cat(2,prefac1,'0');end
                    save([ ExpeInfo.name_folder filesep ExpeInfo.Fname filesep 'frame' prefac1 sprintf('%0.5g',n)],'datas','-v6');
                    n = n+1;
                    clear datas
                end
                
                %  Every 1000 frames sync with 	
                if  mod(num_fr,1000)==0
                    fwrite(a,arduinoDictionary.ThousandFrames);
                end
                
            
            KeepTime.t2 = clock;
            
            % Check if we've gone over the decided phase length and end the
            % tracking
            if StartChrono && etime(KeepTime.t2,KeepTime.tDeb)> ExpeInfo.lengthPhase+0.5
                enableTrack=0;
            end
            end
        end
        
        % Tell arduino the session is over
        fwrite(a,arduinoDictionary.StopSleep{1}); % put values back to low
        fwrite(a,arduinoDictionary.StopSleep{2}); % put values back to low
        fwrite(a,arduinoDictionary.Off); % switch off intan
        
        % Shut the video if compression was being done on the fly
        close(writerObj);
        
        
        %% Save separate files for the two mice
        
        BW_threshold_temp=BW_threshold;
        smaller_object_size_temp= smaller_object_size;
        sm_fact_temp=sm_fact
        strsz_temp=strsz;
        SrdZone_temp=SrdZone;
        msg_box=msgbox('Saving behavioral Information','save','modal');
        pause(0.5)
        for MouseNum=1:2
            MouseDir=[ExpeInfo.name_folder filesep 'Mouse' num2str(ExpeInfo.nmouse{MouseNum}) '-' ExpeInfo.namePhase{MouseNum}];
            mkdir(MouseDir)
            set(PlotFreez{MouseNum},'YData',0,'XData',0);
            figure(Fig_SleepSession)
            subplot(10,5,42:45), hold off
            subplot(10,5,47:50), hold off

            % Correct for intan trigger time to realign with ephys - this is
            % really important!!
            im_diffTemp{MouseNum}(:,1)=im_diffTemp{MouseNum}(:,1)+1;
            PosMatTemp{MouseNum}(:,1)=PosMatTemp{MouseNum}(:,1)+1;
            MouseTemp{MouseNum}(:,1) = MouseTemp{MouseNum}(:,1)+1;
            
            % This is the strict minimum all codes need to save
            [PosMat,PosMatInit,im_diff,im_diffInit,Vtsd,Xtsd,Ytsd,Imdifftsd]=CommonInterpPosMatImDiff(im_diffTemp{MouseNum},KeepTime.chrono,PosMatTemp{MouseNum});
            ref=TrObjLocal.ref;
            mask=TrObjLocal.mask.*MouseMask{MouseNum}; % this is different to other codes because each mouse has its own mask
            Ratio_IMAonREAL=TrObjLocal.Ratio_IMAonREAL;
            frame_limits=TrObjLocal.frame_limits;
            save([ExpeInfo.name_folder,filesep,'TrObject.mat'],'TrObjLocal');
            
            BW_threshold=BW_threshold_temp{MouseNum};
            smaller_object_size= smaller_object_size_temp{MouseNum};
            sm_fact=sm_fact_temp{MouseNum};
            strsz=strsz_temp{MouseNum};
            SrdZone=SrdZone_temp{MouseNum};
            
            save([MouseDir,filesep,'behavResources.mat'],'PosMat','PosMatInit', 'GotFrame', 'im_diff','im_diffInit','Vtsd','Xtsd','Ytsd','Imdifftsd',...
                'ref','mask','Ratio_IMAonREAL','BW_threshold','frame_limits','smaller_object_size','sm_fact','strsz','SrdZone');
            clear ref mask Ratio_IMAonREAL
            
            % Do some extra code-specific calculations
            try FreezeEpoch=thresholdIntervals(Imdifftsd,th_immob{MouseNum},'Direction','Below');
                FreezeEpoch=mergeCloseIntervals(FreezeEpoch,0.3*1E4);
                FreezeEpoch=dropShortIntervals(FreezeEpoch,thtps_immob*1E4);
            catch
                FreezeEpoch=intervalSet(0,0.01*1e4);
            end
            th_immobtemp=th_immob;
            th_immob=th_immob{MouseNum};
            save([MouseDir,filesep,'behavResources.mat'],'FreezeEpoch','th_immob','thtps_immob', 'MouseTemp', '-append');
            th_immob=th_immobtemp;
            
            %% generate figure that gives overviewof the tracking session
            figbilan=figure;
            plot(Range(Vtsd,'s'),Data(Vtsd)./prctile(Data(Vtsd),98),'k'), hold on
            plot(Range(Imdifftsd,'s'),Data(Imdifftsd)./prctile(Data(Imdifftsd),98),'b')
            if not(isempty(Start(FreezeEpoch)))
            for k=1:length(Start(FreezeEpoch))
                plot(Range(Restrict(Imdifftsd,subset(FreezeEpoch,k)),'s'),Data(Restrict(Imdifftsd,subset(FreezeEpoch,k)))*0+max(ylim)*0.8,'c','linewidth',2)
            end
            end
            title('Raw Data')
            
            saveas(figbilan,[MouseDir,filesep,'FigBilan.fig'])
            saveas(figbilan,[MouseDir,filesep,'FigBilan.png'])
            close(figbilan)
            
            % update display and button availability
            
            close(guireg_fig{MouseNum})
            close(GuiForSleep{MouseNum})
            
        end
        
        BW_threshold=BW_threshold_temp;
        smaller_object_size= smaller_object_size_temp;
        sm_fact=sm_fact_temp;
        strsz=strsz_temp;
        SrdZone=SrdZone_temp;

        
        try
            set(Fig_SleepSession,'Color',color_on);
            figure(Fig_SleepSession), subplot(5,1,1:2), title('ACQUISITION STOPPED')
            delete(msg_box)
            
            set(InterfaceButton.StartExpe,'enable','on','FontWeight','normal')
            set(InterfaceButton.StartSession,'enable','off','FontWeight','normal')
            set(InterfaceButton.StopSession,'enable','off','FontWeight','normal')
            set(InterfaceButton(3),'enable','on','FontWeight','normal')
        end
        
        
    end


%% stop tracking
    function stop_Phase(obj,event)
        enableTrack=0;
        fwrite(a,arduinoDictionary.StopSleep{1}); % put values back to low
        fwrite(a,arduinoDictionary.StopSleep{2}); % put values back to low
        fwrite(a,arduinoDictionary.Off); % switch off intan
    end

    function GuiForSleep=SleepStim_OnlineGuiReglage(MouseNum)
        % function GuiForSleep=OnlineGuiReglage(obj,event);
        % let online control of paramteres for image treatments
        
        % create figure
        GuiForSleep=figure('units','normalized',...
            'position',[0.1 0.1 0.2 0.6],...
            'numbertitle','off',...
            'name','UMaze Mouse Tracking : Setting Parameters',...
            'menubar','none',...
            'tag','figure reglage');
        if MouseNum==1
        set(GuiForSleep,'Color','b');
        else
            set(GuiForSleep,'Color','r');
        end
        
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
        set(slider_freeze,'Value',th_immob{MouseNum}/maxth_immob{MouseNum});
        
        slider_yaxis = uicontrol(GuiForSleep,'style','slider',...
            'units','normalized',...
            'position',[0.65 0.1 0.15 0.7],...
            'callback', @fixyaxis);
        set(slider_yaxis,'Value',ymax{MouseNum}/maxyaxis{MouseNum});
            
        % create labels with actual values
        textUM3=uicontrol(GuiForSleep,'style','text', ...
            'units','normalized',...
            'position',[0.22 0.05 0.2 0.03],...
            'string',num2str(th_immob{MouseNum}));
        
        textUM4=uicontrol(GuiForSleep,'style','text', ...
            'units','normalized',...
            'position',[0.62 0.05 0.2 0.03],...
            'string',num2str(ymax{MouseNum}));
        
        %get freezing threshold
        function freeze_thresh(obj,event)
            th_immob{MouseNum} = (get(slider_freeze,'value')*maxth_immob{MouseNum});
            set(textUM3,'string',num2str(th_immob{MouseNum}))
            set(thimmobline{MouseNum},'Ydata',[1,1]*th_immob{MouseNum})
        end
        
        %get ylims
        function fixyaxis(~,~)
            ymax{MouseNum} = (get(slider_yaxis,'value')*maxyaxis{MouseNum});
            set(textUM4,'string',num2str(ymax{MouseNum}));
        end
    end
end
function [numF,filename]=UMazeTracking_IRComp_ObjectOrientated_DBparam(~,~)

% Get global variables that are common to all codes --> code comes from
global TrObj % the video object
global TrObjLocal
if iscell(TrObj)
    TrObjLocal = TrObj{1};
else
    TrObjLocal = TrObj;
end

global Stimulator PulsePalSystem nBytesAvailable % Stimulator type

% Tracking parameters
global BW_threshold; BW_threshold=0.45;
global smaller_object_size; smaller_object_size=12;
global sm_fact; sm_fact=2;
global strsz se; strsz=7; se= strel('disk',strsz);
global SrdZone; SrdZone=30;
global dist_thresh; dist_thresh =2;

%% Variables that are specific to this code
% General thresholds and display
global guireg_fig
global time_image;time_image = 1/TrObjLocal.frame_rate;
global UpdateImage; UpdateImage=ceil(TrObjLocal.frame_rate/5); % update every n frames the picture shown on screen to show at 10Hz
global writerObj  % allows us to save as .avi
global enableTrack % Controls whether the tracking is on or not
global Zone % the Zones in the UMaze - set by the user
global ZoneLabels % Names of zones
global DoorChangeMat % Matrix of times at which the door was moved
global ShTN; ShTN=1; % Variable that count the shocks
global OPF
global RoomTempBegin

% shortcuts for multi-trials - saves last inputs
global MName; MName='';
global tphase; tphase='240';
global SessionName; SessionName='MFB';
global SessionNum; SessionNum=num2str(1);
global SessionVolt; SessionVolt=num2str(0);
global SessionVolt2; SessionVolt2=num2str(0);
global pfield; pfield='0';

% Variables for plotting
global thimmobline % line that shows current freezing threshold
global PlotFreez % the name of the Plot that shows im_diff
global StartChrono, StartChrono=0; % Variable set to one when the tracking begins
% the handle of the chronometer object
global PlotForVideo % the plot that will be saved to .avi if needed
global GuiForUmaze % slides with specific values for UMaze
global color_on; color_on=[0 0 0];
global FracArea; FracArea=0.85;


% Variables Zones UMaze automatic
global mask_UMaze
global ShockMask
global NoShockMask
global CentreMask
global CentreShockMask
global CentreNoShockMask
global FarShockMask
global FarNoShockMask
% mask_UMaze = [111 193 245 193 245 130 142 132 142 92 245 92 245 29 111 31 111 193];
mask_UMaze = [200 223 200 57 60 57 60 120 163 120 163 161 60 161 60 223 200 223];
% ShockMask = [245 193 245 130 191 130 191 193 245 193];
% NoShockMask = [245 92 245 29 191 29 191 92 245 92];
% CentreMask = [111 130 111 92 143 92 143 130 111 130];
% CentreShockMask = [144 193 144 130 191 130 191 193 144 193];
% CentreNoShockMask = [144 92 144 29 191 29 191 92 144 92];
% FarShockMask = [111 193 111 130 144 130 144 193 111 193];
% FarNoShockMask = [111 29 111 92 144 92 144 29 111 29];

ShockMask = [60 223 125 223 125 161 60 161 60 223];
NoShockMask = [60 57 125 57 125 120 60 120 60 57];
CentreMask = [200 161 200 120 163 120 163 161 200 161];
CentreShockMask = [125 223 163 223 163 161 125 161 125 223];
CentreNoShockMask = [125 57 163 57 163 120 125 120 125 57];
FarShockMask = [200 223 200 161 163 161 163 223 200 223];
FarNoShockMask = [200 57 163 57 163 120 200 120 200 57];

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
% - LastStim to recall when alst stimulation was given
% - chrono to dsplay passing of time


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
arduinoDictionary.Off=3;
arduinoDictionary.ThousandFrames=2;
arduinoDictionary.StartGettingSpikes=4; % Read the spike buffer of Arduino
arduinoDictionary.AutoStimModeON=5;
arduinoDictionary.AutoStimModeOFF=7;
arduinoDictionary.SendStim=9;

arduinoDictionary.StimAnyState=10;
arduinoDictionary.StimSleepState=11;
arduinoDictionary.StimNREM=12;
arduinoDictionary.StimREM=13;
arduinoDictionary.StimWake=14;



%% Task parameters
global nametypes; nametypes={'Hab','TestPre', 'TestPreFakeStim', 'Cond',...
    'CondMFB','CondWallShock','CondWallSafe','TestPost','Ext','BlockedWall',...
    'EPM','SoundHab','SoundCnd','SoundTest',...
    'Calibration','CalibrationEyeshock','SleepSession','SleepStim',...
    'ManualStimulation','BlockedWallShock', 'ExploratoryStimulation'};
global SoundTimesHabTest; SoundTimesHabTest=[122,193,251,351,413,485,636,698,800,874,940,1022,1133,1195,1275,1340,Inf];
global SoundTimesCond;  SoundTimesCond=[122,197,287,362,457,530,640,760,840,930,1010,1095,1185,1285,1365,1430,Inf];
global CalibTimes;  CalibTimes=[50,70,90,110,150,170,Inf];  %% Dima
% global CalibTimes;  CalibTimes=[1:2:179,Inf]; %% test
global CalibTimesEyeshock;  CalibTimesEyeshock=[50,70,90,110,Inf];
global SinglShockTime; SinglShockTime=[45,Inf];
global CondWallShockTime; CondWallShockTime=[60,80,100,120,Inf];
global delStim; delStim=6;  % ISI between stim
global firstentry; firstentry=1;      % boolean var for entry in stim zone
global entry; entry=1;      % boolean var for entry in stim zone
global minisi; minisi=6;    % minimal inter-stimulation interval
global maxisi; maxisi=20;   % maximal inter-stimulation interval
global isi; isi=0;          % inter-stimulation interval
global delStimreturn; delStimreturn=1;
global delStimNow; delStimNow=0.1;
global autostimulate; autostimulate = false;
global StimSleepState; StimSleepState = 'Any';
receivedshock = false;
PCDriven = false;
global speedthresh; speedthresh = 1; % Average speed under which we think that the mouse is still (cm/s)

% Size of the occupation map
nx = 32;
ny = 32;

smo=2;            %smoothing factor

global MinSleepTime StimOnTime StimOffTime
MinSleepTime=3;
global  SleepChrono PeriodChrono
SleepChrono=0; PeriodChrono=0;

%% Initialisation of maps

global occupation       % Occupation map
global carte_spike      % Spike Map
global cell_map         % Firing Map
global RGBoccupation    % Colored occupation
global RGBcarte_spike   % Colored spikes
global RGBcell_map      % Colored firing

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% graphical interface n???1 with all the pushbuttons

Fig_UMaze=figure('units','normalized','position',[0.1 0.1 0.8 0.85],...
    'numbertitle','off','name','UMazeProtocol','menubar','none','tag','figure Odor');
set(Fig_UMaze,'Color',color_on);

maskbutton(1)= uicontrol(Fig_UMaze,'style','pushbutton',...
    'units','normalized','position',[0.01 0.89 0.2 0.05],...
    'string','1- INPUTS EXPE','callback', @giv_inputs);
set(maskbutton(1),'enable','on','FontWeight','bold')

maskbutton(3)= uicontrol(Fig_UMaze,'style','pushbutton',...
    'units','normalized','position',[0.01 0.70 0.2 0.05],'string','2 - GetBehavZones','callback',@DefineZones);
set(maskbutton(3),'enable','off')

maskbutton(5)= uicontrol(Fig_UMaze,'style','pushbutton',...
    'units','normalized','position',[0.01 0.65 0.2 0.05],...
    'string','3- START EXPE','callback', @start_Expe);
set(maskbutton(5),'enable','off')

maskbutton(4)= uicontrol(Fig_UMaze,'style','pushbutton',...
    'units','normalized','position',[0.01 0.48 0.2 0.05],'string','4- START session');
set(maskbutton(4),'enable','off','callback', @StartSession)

maskbutton(7)= uicontrol(Fig_UMaze,'style','pushbutton',...
    'units','normalized','position',[0.025 0.36 0.15 0.03],...
    'string','Stop Emergency','callback', @stop_Phase);
set(maskbutton(7),'enable','off')

maskbutton(8)= uicontrol(Fig_UMaze,'style','pushbutton',...
    'units','normalized','position',[0.01 0.03 0.2 0.05],...
    'string','CLOSE EXPE','callback', @quit);
set(maskbutton(8),'enable','on','FontWeight','bold')

maskbutton(9)= uicontrol(Fig_UMaze,'style','pushbutton',...
    'units','normalized','position',[0.55 0.03 0.2 0.05],...
    'string','DoorChange','callback', @DoorChange);
set(maskbutton(9),'enable','on','FontWeight','bold')

maskbutton(10)= uicontrol(Fig_UMaze,'style','pushbutton',...
    'units','normalized','position',[0.15 0.2 0.10 0.05],...
    'string','Stim (ZAP!)','callback', @ManualStim);
set(maskbutton(10),'enable','off','FontWeight','bold')

% maskbutton(11)= uicontrol(Fig_UMaze,'style','pushbutton',...
%     'units','normalized','position',[0.15 0.13 0.10 0.05],...
%     'string','Sleep Off','callback', @SwitchSleepOff);
% set(maskbutton(11),'enable','off','FontWeight','bold')


inputDisplay(1)=uicontrol(Fig_UMaze,'style','text','units','normalized','position',[0.25 0.95 0.5 0.02],'string','Filename = TO DEFINE','FontSize',10);
inputDisplay(6)=uicontrol(Fig_UMaze,'style','text','units','normalized','position',[0.01 0.59 0.16 0.02],'string','Session','FontSize',12);
inputDisplay(7)=uicontrol(Fig_UMaze,'style','text','units','normalized','position',[0.01 0.56 0.16 0.02],'string','WAIT','FontSize',12);
inputDisplay(8)=uicontrol(Fig_UMaze,'style','text','units','normalized','position',[0.01 0.95 0.2 0.02],'string','TASK = ?','FontSize',10);
inputDisplay(9)=uicontrol(Fig_UMaze,'style','text','units','normalized','position',[0.01 0.81 0.16 0.06],'string','ListOfSession = ?','FontSize',10);
inputDisplay(10)=uicontrol(Fig_UMaze,'style','text','units','normalized','position',[0.15 0.45 0.1 0.02],'string','Shock','FontSize',8);
inputDisplay(11)=uicontrol(Fig_UMaze,'style','text','units','normalized','position',[0.01 0.2 0.12 0.1],'string','Prompt','FontSize',8);

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
        try close(GuiForUmaze);end
        delete(Fig_UMaze)
    end


%% function to register the door has been moved
    function DoorChange(obj,event)
        DoorChangeMat=[DoorChangeMat,PosMat(end,1)];
    end

%% Ask for all inputs and display
    function giv_inputs(obj,event)
        
        strfcts=strjoin(nametypes,'|');
        u2=uicontrol(Fig_UMaze,'Style', 'popup','String', strfcts,'units','normalized',...
            'Position', [0.01 0.84 0.2 0.05],'Callback', @setprotoc);
        
        function setprotoc(obj,event)
            fctname=get(obj,'value');
            ExpeInfo.namePhase=nametypes(fctname);ExpeInfo.namePhase=ExpeInfo.namePhase{1};
            savProtoc;
        end
        
        function setpulsepal(obj,event)
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
            
            ExpeInfo.Voltage = 0.5;
            
            ProgramPulsePalParam(3,'LinkTriggerChannel1', 0);
            ProgramPulsePalParam(3,'LinkTriggerChannel2', 0);
            ProgramPulsePalParam(4,'LinkTriggerChannel1', 0);
            ProgramPulsePalParam(4,'LinkTriggerChannel2', 0);
        end
        
        function savProtoc(obj,event)
            set(inputDisplay(9),'string',['Sessions:',{' '},ExpeInfo.namePhase]);
            
            if strcmp('Hab',ExpeInfo.namePhase)
                ExpeInfo.lengthPhase=900;
                set(inputDisplay(10),'string','No Shock');
                set(chronostim,'ForegroundColor','k');
                set(inputDisplay(11),'string','You can relax','ForegroundColor','k');
            elseif strcmp('BlockedWall',ExpeInfo.namePhase)
                ExpeInfo.lengthPhase=480;
                set(inputDisplay(10),'string','No Shock');
                set(chronostim,'ForegroundColor','k');
                set(inputDisplay(11),'string','You can relax','ForegroundColor','k');
            elseif strcmp('BlockedWallShock',ExpeInfo.namePhase)
                ExpeInfo.lengthPhase=300;
                set(inputDisplay(10),'string','NextShock');
                set(chronostim,'ForegroundColor','r');
                set(chronostim,'string',num2str(SinglShockTime(ShTN)));
                set(inputDisplay(11),'string','You can relax','ForegroundColor','k');
            elseif strcmp('TestPre',ExpeInfo.namePhase)
                ExpeInfo.lengthPhase=240;
                set(inputDisplay(10),'string','No Shock');
                set(chronostim,'ForegroundColor','k');
                set(inputDisplay(11),'string','You can relax','ForegroundColor','k');
            elseif strcmp('TestPreFakeStim',ExpeInfo.namePhase)
                if strcmp('New PulsePal',Stimulator)
                    setpulsepal;
                end
                ExpeInfo.lengthPhase=240;
                set(inputDisplay(10),'string','No Shock');
                set(chronostim,'ForegroundColor','k');
                set(inputDisplay(11),'string','You can relax','ForegroundColor','k');
            elseif strcmp('Cond',ExpeInfo.namePhase)
                anwr=questdlg('Which type of conditioning?','Choose','Location-driven','PlaceCell-driven',...
                    'Location-driven');
                if strcmp(anwr, 'PlaceCell-driven')
                    PCDriven = true;
                end
                if strcmp('New PulsePal',Stimulator)
                    setpulsepal;
                end
                ExpeInfo.lengthPhase=480;
                set(chronostim,'ForegroundColor','r');
                set(inputDisplay(10),'string','TimeInZone');
                set(chronostim,'string',num2str(0));
                set(inputDisplay(11),'string','You can relax','ForegroundColor','k');
            elseif strcmp('CondMFB',ExpeInfo.namePhase)
                if strcmp('New PulsePal',Stimulator)
                    setpulsepal;
                end
                ExpeInfo.lengthPhase=240;
                set(chronostim,'ForegroundColor','r');
                set(inputDisplay(10),'string','TimeInZone');
                set(chronostim,'string',num2str(0));
                set(inputDisplay(11),'string','You can relax','ForegroundColor','k');
            elseif strcmp('CondWallShock',ExpeInfo.namePhase)
                if strcmp('New PulsePal',Stimulator)
                    setpulsepal;
                end
                
                ExpeInfo.lengthPhase=360;
                set(chronostim,'ForegroundColor','r');
                set(inputDisplay(10),'string','NextShock');
                set(chronostim,'string',num2str(CondWallShockTime(ShTN)));
                set(inputDisplay(11),'string','You can relax','ForegroundColor','k');
            elseif strcmp('CondWallSafe',ExpeInfo.namePhase)
                ExpeInfo.lengthPhase=360;
                set(chronostim,'ForegroundColor','r');
                set(inputDisplay(10),'string','TimeInZone');
                set(chronostim,'string',num2str(0));
                set(inputDisplay(11),'string','You can relax','ForegroundColor','k');
            elseif strcmp('TestPost',ExpeInfo.namePhase)
                ExpeInfo.lengthPhase=240;
                set(inputDisplay(10),'string','No Shock');
                set(chronostim,'ForegroundColor','k');
                set(inputDisplay(11),'string','You can relax','ForegroundColor','k');
            elseif strcmp('Ext',ExpeInfo.namePhase)
                ExpeInfo.lengthPhase=900;
                set(inputDisplay(10),'string','No Shock');
                set(chronostim,'ForegroundColor','k');
                set(inputDisplay(11),'string','You can relax','ForegroundColor','k');
            elseif strcmp('EPM',ExpeInfo.namePhase)
                ExpeInfo.lengthPhase=1200;
                set(inputDisplay(10),'string','No Shock');
                set(chronostim,'ForegroundColor','k');
                set(inputDisplay(11),'string','You can relax','ForegroundColor','k');
            elseif strcmp('SoundCnd',ExpeInfo.namePhase)
                ExpeInfo.lengthPhase=1600;
                set(inputDisplay(10),'string','NextSound');
                set(chronostim,'ForegroundColor','r');
                set(chronostim,'string',num2str(SoundTimesCond(ShTN)));
                set(inputDisplay(11),'string','Check Sound is CS+','ForegroundColor','r');
            elseif strcmp('SoundHab',ExpeInfo.namePhase)
                ExpeInfo.lengthPhase=780;
                set(inputDisplay(10),'string','NextSound');
                set(chronostim,'ForegroundColor','g');
                set(chronostim,'string',num2str(SoundTimesHabTest(ShTN)));
                set(inputDisplay(11),'string','Check Sound is CS-','ForegroundColor','g');
            elseif strcmp('SoundTest',ExpeInfo.namePhase)
                ExpeInfo.lengthPhase=1450;
                set(inputDisplay(10),'string','NextSound');
                set(chronostim,'ForegroundColor','g');
                set(chronostim,'string',num2str(SoundTimesHabTest(ShTN)));
                set(inputDisplay(11),'string','Check Sound is CS-','ForegroundColor','g');
            elseif strcmp('Calibration',ExpeInfo.namePhase)
                if strcmp('New PulsePal',Stimulator)
                    setpulsepal;
                end
                ExpeInfo.lengthPhase=180;
                set(inputDisplay(10),'string','NextShock');
                set(chronostim,'ForegroundColor','r');
                set(chronostim,'string',num2str(CalibTimes(ShTN)));
                set(inputDisplay(11),'string','You can relax','ForegroundColor','k');
            elseif strcmp('CalibrationEyeshock',ExpeInfo.namePhase)
                ExpeInfo.lengthPhase=130;
                set(inputDisplay(10),'string','NextShock');
                set(chronostim,'ForegroundColor','r');
                set(chronostim,'string',num2str(CalibTimesEyeshock(ShTN)));
                set(inputDisplay(11),'string','You can relax','ForegroundColor','k');
            elseif strcmp('SleepSession',ExpeInfo.namePhase)
                ExpeInfo.lengthPhase=5400;
                set(inputDisplay(10),'string','No Shock');
                set(chronostim,'ForegroundColor','k');
                set(inputDisplay(11),'string','You can relax','ForegroundColor','k');
                set(maskbutton(10),'enable','on','FontWeight','bold')
            elseif strcmp('SleepStim',ExpeInfo.namePhase)
                if strcmp('New PulsePal',Stimulator)
                    setpulsepal;
                end
                ExpeInfo.lengthPhase=5400;
                set(inputDisplay(10),'string','No Shock');
                set(chronostim,'ForegroundColor','k');
                set(inputDisplay(11),'string','You can relax','ForegroundColor','k');
                set(maskbutton(10),'enable','on','FontWeight','bold')
            elseif strcmp('ManualStimulation',ExpeInfo.namePhase)
                ExpeInfo.lengthPhase=12000;
                set(inputDisplay(10),'string','No Shock');
                set(chronostim,'ForegroundColor','k');
                set(inputDisplay(11),'string','You can relax','ForegroundColor','k');
                set(maskbutton(10),'enable','on','FontWeight','bold')
                if strcmp('New PulsePal',Stimulator)
                    setpulsepal;
                end
            elseif strcmp('ExploratoryStimulation',ExpeInfo.namePhase)
                ExpeInfo.lengthPhase=12000;
                set(inputDisplay(10),'string','SleepStimulation');
                set(chronostim,'ForegroundColor','k');
                set(inputDisplay(11),'string','You can relax','ForegroundColor','k');
                set(maskbutton(10),'enable','on','FontWeight','bold')
                if strcmp('New PulsePal',Stimulator)
                    setpulsepal;
                end
            end
            %%
            % Enter room temperature at the beginning of the session
            try
                load('default_answer.mat', 'ans2');
                def_temp = num2str(ans2{1});
            catch
                def_temp = '21';
            end
            ans2 = inputdlg({'Room temperature'},'INFO',1,{def_temp});
            RoomTempBegin = str2double(ans2);
            
            % Input for the mice
            if strcmp('New PulsePal',Stimulator)
                if strcmp('Cond',ExpeInfo.namePhase) || strcmp('Calibration',ExpeInfo.namePhase) ...
                        || strcmp('ManualStimulation',ExpeInfo.namePhase) || strcmp('CondWallShock',ExpeInfo.namePhase)...
                        || strcmp('SleepStim',ExpeInfo.namePhase) || strcmp('TestPreFakeStim',ExpeInfo.namePhase)...
                        || strcmp('CondMFB',ExpeInfo.namePhase)
                    default_answer{1}= MName;
                    default_answer{2}= tphase;
                    default_answer{3}= SessionVolt;
                    default_answer{4}= pfield;
                    
                    
                    answer = inputdlg({'NumberMouse','Session duration (s)', 'Voltage (V)', 'Online Place Field'},'INFO',1,default_answer);
                    default_answer=answer; save default_answer default_answer ans2
                    
                    
                    ExpeInfo.nmouse=str2double(answer{1});
                    MName=answer{1};
                    ExpeInfo.lengthPhase=str2double(answer{2});
                    tphase=answer{2};
                    ExpeInfo.nPhase=0;  % no phase recorded here for now
                    ExpeInfo.Voltage = str2double(answer{3});
                    SessionVolt=answer{3};
                    OPF = str2num(answer{4});
                    pfield=answer{4};
                    ProgramPulsePalParam(1,'Phase1Voltage', ExpeInfo.Voltage);
                    ProgramPulsePalParam(1,'Phase2Voltage', -(ExpeInfo.Voltage));
                    
                    if strcmp('SleepStim',ExpeInfo.namePhase)
                        StimSleepState = questdlg('Which state do you want to stimulate in? (press "Any" if you use OpenEphys and select appropriate stage there)',...
                            'Global State','Any','Sleep','Wake', 'Any');
                        if strcmp(StimSleepState, 'Sleep')
                            StimSleepState = questdlg('Which sleep stage do you want to stimulate in?','Sleep stage','Sleep','NREM','REM','NREM');
                        end
                    end
                    
                elseif strcmp('ExploratoryStimulation',ExpeInfo.namePhase)
                    default_answer{1}='007';
                    default_answer{2}=num2str(ExpeInfo.lengthPhase);
                    default_answer{3}='[0 0.5 1 1.5 2 2.5]';
                    default_answer{4}='0';
                    answer = inputdlg({'NumberMouse','Session duration (s)', 'Voltages (V)', 'Online Place Field'},'INFO',1,default_answer);
                    default_answer=answer; save default_answer default_answer ans2
                    
                    ExpeInfo.nmouse=str2double(answer{1});
                    ExpeInfo.lengthPhase=str2double(answer{2});
                    ExpeInfo.nPhase=0;
                    ExpeInfo.Voltage = str2num(answer{3});
                    OPF = str2num(answer{4});
                else
                    default_answer{1}= MName;
                    default_answer{2}= tphase;
                    default_answer{3}= pfield;
                    
                    answer = inputdlg({'NumberMouse','Session duration (s)', 'Online Place Field'},'INFO',1,default_answer);
                    default_answer=answer; save default_answer default_answer ans2
                    
                    ExpeInfo.nmouse=str2double(answer{1});
                    MName=answer{1};
                    ExpeInfo.lengthPhase=str2double(answer{2});
                    tphase=answer{2};
                    ExpeInfo.nPhase=0;
                    OPF = str2num(answer{3});
                    pfield=answer{3};
                end
            else
                default_answer{1}='007';
                default_answer{2}=num2str(ExpeInfo.lengthPhase);
                default_answer{3}='0';
                
                answer = inputdlg({'NumberMouse','Session duration (s)', 'Online Place Field'},'INFO',1,default_answer);
                default_answer=answer; save default_answer default_answer ans2
                
                ExpeInfo.nmouse=str2double(answer{1});
                ExpeInfo.lengthPhase=str2double(answer{2});
                ExpeInfo.nPhase=0;
                OPF = str2num(answer{3});
            end
            
            nameTASK='UMaze';
            set(inputDisplay(8),'string',['TASK = ',nameTASK]);
            disp(' ');disp('-------------------- New Expe ---------------------');
            set(maskbutton(1),'FontWeight','normal','string','1- INPUTS EXPE (OK)');
        end
        set(maskbutton(3),'enable','on')
    end

% -----------------------------------------------------------------
%% Interface of analysis
    function start_Expe(obj,event)
        KeepTime.t1=clock;
        KeepTime.t2=clock;
        enableTrack=1;
        StartChrono=0;
        ExpeInfo.nPhase=ExpeInfo.nPhase+1;
        if strcmp('Calibration',ExpeInfo.namePhase)
            ExpeInfo.name_folder=['ERC-Mouse-' num2str(ExpeInfo.nmouse) '-' num2str(ExpeInfo.Voltage) 'V-' ExpeInfo.TodayIs '-' ExpeInfo.namePhase];
        else
            ExpeInfo.name_folder=['ERC-Mouse-' num2str(ExpeInfo.nmouse) '-' ExpeInfo.TodayIs '-' ExpeInfo.namePhase];
        end
        
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
            
            %%%% Initialisation/Setting maps back to zero
            occupation = zeros(nx,ny); % Occupation map
            carte_spike=zeros(size(occupation,1),size(occupation,2)); % Spike Map
            cell_map=zeros(size(carte_spike)); % Firing Map
            RGBoccupation=zeros(size(occupation,1),size(occupation,2),3); % Colored occupation
            RGBcarte_spike=zeros(size(carte_spike,1),size(carte_spike,2),3);% Colored spikes
            RGBcell_map=zeros(size(RGBcarte_spike));% Colored firing
            %%%%%%
            PerformTracking;
        end
    end

% -----------------------------------------------------------------
%% StartSession
    function StartSession(obj,event)
        
        % set the buttons to avoid problems
        set(maskbutton(7),'enable','on','FontWeight','bold')
        set(maskbutton(4),'enable','off','FontWeight','normal')
        % Tell the experimenter we're starting
        set(inputDisplay(7),'string','RECORDING');
        % wait for keypress while experimenter put mouse in Maze
        if strcmp('Cond',ExpeInfo.namePhase) || strcmp('TestPre',ExpeInfo.namePhase) || strcmp('TestPost',ExpeInfo.namePhase) || ...
                strcmp('CondWallShock',ExpeInfo.namePhase) || strcmp('BlockedWall',ExpeInfo.namePhase) ||...
                strcmp('BlockedWallShock',ExpeInfo.namePhase) || strcmp('Hab',ExpeInfo.namePhase) || strcmp('CondWallSafe',ExpeInfo.namePhase) ...
                || strcmp('TestPreFakeStim',ExpeInfo.namePhase) || strcmp('CondMFB',ExpeInfo.namePhase)
            set(inputDisplay(11),'string','Press any button to start','ForegroundColor','r','FontSize',15);
            keydown = waitforbuttonpress;
        end
        if strcmp('Cond',ExpeInfo.namePhase) || strcmp('CondMFB',ExpeInfo.namePhase)
            set(chronostim,'ForegroundColor','r');
            set(inputDisplay(10),'string','TimeInZone');
            set(chronostim,'string',num2str(0));
        end
        
        % Clear the arduino
        if a.BytesAvailable>0
            fread(a,a.BytesAvailable);
        end
        % Tell the arduino we're starting
        fwrite(a,arduinoDictionary.On);
        
        % Initialize time
        KeepTime.tDeb = clock;
        KeepTime.LastStim=clock;
        % Go signal for tracking code
        StartChrono=1;
    end

% -----------------------------------------------------------------
%% track mouse
    function PerformTracking(obj,event)
        
        % Get Mask to plot
        stats = regionprops(TrObjLocal.mask, 'Area');
        tempmask=TrObjLocal.mask;
        AimArea=stats.Area*FracArea;
        ActArea=stats.Area;
        while AimArea<ActArea
            tempmask=imerode(tempmask,strel('disk',1));
            stats = regionprops(tempmask, 'Area');
            ActArea=stats.Area;
        end
        aux=bwboundaries(tempmask);
        new_mask=aux{1}./TrObjLocal.Ratio_IMAonREAL;
        
        [MaskXmin,MaskXmax] = bounds(new_mask(:,2));
        [MaskYmin,MaskYmax] = bounds(new_mask(:,1));
        
        
        KeepTime.chrono=0;
        set(chronoshow,'string',num2str(0));
        disp('Begining tracking...')
        guireg_fig=Tracking_OnlineGuiReglage;
        UMaze_OnlineGuiReglage;
        % set stim nb to 0
        nbstim=0;
        
        % -------------------
        % display zone
        if OPF
            figure(Fig_UMaze),
            PlotForVideo=subplot(20,20,[5:10 25:30 45:50 65:70 85:90 105:110 125:130 145:150]);
            htrack = imagesc(TrObjLocal.ref);axis image; hold on
            line([10 20]*TrObjLocal.Ratio_IMAonREAL,[10 10],'Color','k','Linewidth',3)
            text(15*TrObjLocal.Ratio_IMAonREAL,15,'10 cm','Color','k')
            title('ACQUISITION ON')
            caxis([0.1 0.9])
            hold on
            g=plot(0,0,'m+');
            % change for comrpession
            colormap(gray)
            handles(1)=uicontrol('style','text', ...
                'units','normalized',...
                'position',[0.3 0.928 0.2 0.03],...
                'string','Video',...
                'FontWeight','bold',...
                'FontSize', 14);
            
            figure(Fig_UMaze), subplot(20,20,[15:20 35:40 55:60 75:80 95:100 115:120 135:140 155:160]);,
            htrack2 = imagesc(zeros(ny,ny));axis image; caxis([0 1]);hold on
            caxis([0.1 0.9])
            handles(2)=uicontrol('style','text', ...
                'units','normalized',...
                'position',[0.695 0.928 0.2 0.03],...
                'string','Occupation map',...
                'FontWeight','bold',...
                'FontSize', 14);
            
            figure(Fig_UMaze), subplot(20,20,[225:230 245:250 265:270 285:290 305:310 325:330 345:350 365:370]);,
            htrack3 = imagesc(zeros(ny,ny));axis image; caxis([0 1]);hold on
            caxis([0.1 0.9])
            handles(3)=uicontrol('style','text', ...
                'units','normalized',...
                'position',[0.3 0.47 0.2 0.03],...
                'string','Spike map',...
                'FontWeight','bold',...
                'FontSize', 14);
            
            figure(Fig_UMaze), subplot(20,20,[235:240 255:260 275:280 295:300 315:320 335:340 355:360 375:380]);,
            htrack4 = imagesc(zeros(ny,ny));axis image; caxis([0 1]);hold on
            caxis([0.1 0.9])
            handles(4)=uicontrol('style','text', ...
                'units','normalized',...
                'position',[0.695 0.47 0.2 0.03],...
                'string','Firing rate - place field',...
                'FontWeight','bold',...
                'FontSize', 14);
            
        else
            if strcmp('Cond',ExpeInfo.namePhase) || strcmp('TestPre',ExpeInfo.namePhase) || strcmp('TestPost',ExpeInfo.namePhase) || ...
                    strcmp('CondWallShock',ExpeInfo.namePhase) || strcmp('BlockedWall',ExpeInfo.namePhase) ||...
                    strcmp('BlockedWallShock',ExpeInfo.namePhase) || strcmp('Hab',ExpeInfo.namePhase) || strcmp('CondWallSafe',ExpeInfo.namePhase) ...
                    || strcmp('TestPreFakeStim',ExpeInfo.namePhase) || strcmp('CondMFB',ExpeInfo.namePhase)
                
                
                figure(Fig_UMaze),
                PlotForVideo=subplot(5,5,[2:3 7:8]);
                htrack = imagesc(TrObjLocal.ref); hold on
                line([10 20]*TrObjLocal.Ratio_IMAonREAL,[10 10],'Color','k','Linewidth',3)
                text(15*TrObjLocal.Ratio_IMAonREAL,15,'10   cm','Color','k')
                title('ACQUISITION ON')
                caxis([0.1 0.9])
                
                figure(Fig_UMaze), subplot(5,5,[12:13 17:18]);
                htrack2 = imagesc(zeros(size((TrObjLocal.ref)))); caxis([0 1]); hold on
                title('tracking online','Color','w')
                g=plot(0,0,'m+');
                
                figure(Fig_UMaze), subplot(5,5,[14:15 19:20]);
                cla
                maskplot = plot(new_mask(:,2),new_mask(:,1),'k','LineWidth',2);  xlim([MaskXmin-1 MaskXmax+1]); ylim([[MaskYmin-1 MaskYmax+1]]);
                hold on
                htrack3 = plot(new_mask(:,2),new_mask(:,1),'k','LineWidth',2);  xlim([MaskXmin-1 MaskXmax+1]); ylim([[MaskYmin-1 MaskYmax+1]]);
                axis ij
                title('trajectory online','Color','w')
                u=plot(0,0,'m+');
                
                im_diff=0;
                figure(Fig_UMaze), subplot(5,5,22:25)
                PlotFreez=plot(0,0,'-b');
                hold on, thimmobline=line([1,2000],[1 1]*th_immob,'Color','r');
                xlim([0,maxfrvis]);
            else
                figure(Fig_UMaze),
                PlotForVideo=subplot(5,1,1:2);
                htrack = imagesc(TrObjLocal.ref);axis image; hold on
                line([10 20]*TrObjLocal.Ratio_IMAonREAL,[10 10],'Color','k','Linewidth',3)
                text(15*TrObjLocal.Ratio_IMAonREAL,15,'10 cm','Color','k')
                title('ACQUISITION ON')
                caxis([0.1 0.9])
                
                figure(Fig_UMaze), subplot(5,1,3:4),
                htrack2 = imagesc(zeros(size((TrObjLocal.ref))));axis image; caxis([0 1]); hold on
                xlabel('tracking online','Color','w')
                g=plot(0,0,'m+');
                
                im_diff=0;
                figure(Fig_UMaze), subplot(5,5,22:25)
                PlotFreez=plot(0,0,'-b');
                hold on, thimmobline=line([1,2000],[1 1]*th_immob,'Color','r');
                xlim([0,maxfrvis]);
            end
        end
        
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
        %             writerObj.FrameRate = TrObj.frame_rate;
        open(writerObj);
        
        DoorChangeMat=[]; MouseTemp=[]; PosMat=[];im_diff=[];ZoneEpoch=[]; ZoneIndices=[]; FreezeTime=[]; Occup=[];
        GotFrame = [];
        
        IM=TrObjLocal.GetAFrame;
        
        OldIm=TrObjLocal.mask;
        OldZone=TrObjLocal.mask;
        
        while enableTrack
            
            
            % Activate the camera and send the image to the workspace
            pause(time_image-etime(KeepTime.t2,KeepTime.t1));
            IM=TrObjLocal.GetAFrame;
            %             IM(IM<0)=0;
            
            % ---------------------------------------------------------
            % update KeepTime.chrono
            KeepTime.t1 = clock;
            if StartChrono
                KeepTime.chrono=etime(KeepTime.t1,KeepTime.tDeb);
                set(chronoshow,'string',[num2str(floor(KeepTime.chrono)),'/',num2str(ExpeInfo.lengthPhase)]);
            end
            
            % display video, mouse position and save in posmat
            if StartChrono
                if strcmp('Cond',ExpeInfo.namePhase) || strcmp('TestPre',ExpeInfo.namePhase) || strcmp('TestPost',ExpeInfo.namePhase) || ...
                        strcmp('CondWallShock',ExpeInfo.namePhase) || strcmp('BlockedWall',ExpeInfo.namePhase) ||...
                        strcmp('BlockedWallShock',ExpeInfo.namePhase) || strcmp('Hab',ExpeInfo.namePhase) || strcmp('CondWallSafe',ExpeInfo.namePhase)
                    fwrite(a, arduinoDictionary.AutoStimModeOFF);
                    set(inputDisplay(11),'string','You can relax','ForegroundColor','k','FontSize',12);
                end
                
                % find the mouse and calculate quantity of movement
                [Pos,ImDiff,PixelsUsed,NewIm,FzZone,x_oc,y_oc]=Track_ImDiff(IM,TrObjLocal.mask,TrObjLocal.ref,BW_threshold,smaller_object_size,sm_fact,se,SrdZone,...
                    TrObjLocal.Ratio_IMAonREAL,OldIm,OldZone,TrObjLocal.camera_type,'nx',nx,'ny',ny);
                
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
                    nodetect = 0;
                else
                    PosMat(num_fr,:)=[KeepTime.chrono;NaN;NaN;NaN];
                    im_diff(num_fr,1:3)=[KeepTime.chrono;NaN;NaN];
                    MouseTemp(num_fr,1:2)=[KeepTime.chrono;NaN];
                    nodetect = 1;
                end
                
                if OPF
                    if num_fr > 15
                        % Interpolate x and y to get the correct speed
                        PosMatV = PosMat;
                        x=PosMatV(:,2);
                        nanx = isnan(x);
                        ttt = 1:numel(x);
                        x(nanx) = interp1(ttt(~nanx), x(~nanx), ttt(nanx));
                        y=PosMatV(:,3);
                        nanx = isnan(y);
                        ttt = 1:numel(y);
                        y(nanx) = interp1(ttt(~nanx), y(~nanx), ttt(nanx));
                        % Speed
                        PosMatV(:,2)=x;
                        PosMatV(:,3)=y;
                        
                        if nodetect == 0
                            % If average speed of the mouse in the last 15 frames is higher than 2cm/s
                            if mean(runmean(sqrt(diff(PosMatV(end-15:end,2)).^2+diff(PosMatV(end-15:end,3)).^2)./(diff(PosMatV(end-15:end,1))),7)) > 2
                                occupation(y_oc,x_oc) = occupation(y_oc,x_oc) + 1;
                                occupation_norm=occupation/num_fr;
                                log_occupation_norm=log(1+occupation_norm); % oog scale
                                max_log_oc=max(max(log_occupation_norm));
                                if max_log_oc>0
                                    log_occupation_norm=log_occupation_norm/max_log_oc;
                                else
                                    log_occupation_norm=0;
                                end
                                nopath=(occupation==0); % where the mouse never was
                                RGBoccupation(:,:,3)=nopath;
                                RGBoccupation(:,:,2)=nopath;
                                RGBoccupation(:,:,1)= log_occupation_norm+nopath; % in white locations where the mouse wasn't, in red the opposite
                                
                                %% Spikes and firing map
                                
                                if nodetect
                                    fwrite(a,arduinoDictionary.StartGettingSpikes); % Start reading spikes
                                else
                                    fwrite(a,arduinoDictionary.StartGettingSpikes); % Start reading spikes
                                    
                                    data_temp=fscanf(a);
                                    data_temp2=str2double(data_temp);
                                    nb_ttl(num_fr) = data_temp2;
                                    
                                    carte_spike(y_oc,x_oc)=carte_spike(y_oc,x_oc)+nb_ttl(num_fr);
                                    
                                    carte_spike_norm=carte_spike/num_fr;
                                    log_carte_spike_norm=log(1+carte_spike_norm); % echelle log
                                    max_log_carte_spike=squeeze(max(max(log_carte_spike_norm,[],1),[],2));
                                    
                                    if max_log_carte_spike>0
                                        log_carte_spike_norm(:,:)=log_carte_spike_norm(:,:)/max_log_carte_spike;
                                    end
                                    
                                    carte0= carte_spike(:,:);
                                    nopath_spike=(carte0==0);
                                    RGBcarte_spike(:,:,3)=nopath_spike;
                                    RGBcarte_spike(:,:,2)=nopath_spike;
                                    RGBcarte_spike(:,:,1)= squeeze(log_carte_spike_norm(:,:))+nopath; %en blanc l� o� elle n'a pas d�charg� ; en rouge ailleurs ;
                                    
                                    cell_map(:,:)=carte_spike(:,:)./occupation;
                                    abberation= (occupation<3);
                                    cell_temp=cell_map(:,:);
                                    % cell_temp_norm=cell_temp/n;
                                    cell_temp(abberation)=0;
                                    % log_cell_temp_norm=log(1+cell_temp_norm);
                                    %max_log_cell_temp_norm=max(max(log_cell_temp_norm));
                                    max_cell_temp=max(max(cell_temp));
                                    if max_cell_temp>0
                                        cell_temp_plot=cell_temp/max_cell_temp;
                                    else
                                        cell_temp_plot=cell_temp;
                                    end
                                    RGBcell_map(:,:,3)=nopath_spike;
                                    RGBcell_map(:,:,2)=nopath_spike;
                                    RGBcell_map(:,:,1)=cell_temp_plot+nopath;
                                end
                            end
                        end
                    end
                    
                    % Showing
                    if  mod(num_fr-2,UpdateImage)==0
                        %                     set(g,'Xdata',Pos(1).*TrObjLocal.Ratio_IMAonREAL,'YData',Pos(2).*TrObjLocal.Ratio_IMAonREAL)
                        %                     diffshow=double(NewIm);
                        %                     diffshow(FzZone==1)=0.4;
                        %                     diffshow(OldZone==1)=0.4;
                        %                     diffshow(NewIm==1)=0.8;
                        set(htrack2,'Cdata',RGBoccupation);
                        set(htrack,'Cdata',IM);
                        set(g,'Xdata',Pos(1).*TrObjLocal.Ratio_IMAonREAL,'YData',Pos(2).*TrObjLocal.Ratio_IMAonREAL)
                    end
                    OldIm=NewIm;
                    OldZone=FzZone;
                    
                    subplot(20,20,[225:230 245:250 265:270 285:290 305:310 325:330 345:350 365:370])
                    set(htrack3, 'Cdata', RGBcarte_spike(:,:,:))
                    
                    subplot(20,20,[235:240 255:260 275:280 295:300 315:320 335:340 355:360 375:380])
                    set(htrack4, 'Cdata', RGBcell_map(:,:,:))
                    
                    % -------------------------------------------------------------------------------
                    % -------------------------------- Find the mouse   --------------------------------
                    
                    % Update displays at 5Hz - faster would just be a waste of
                    % time
                    % For compression the actual picture is updated faster so
                    % as to save it
                    if strcmp(TrObjLocal.camera_type,'Webcam')
                        if strcmp(TrObjLocal.vid.VideoFormat,'RGB24_320x240')
                            IM = rgb2gray(IM);
                            frame.cdata = cat(3,IM,IM,IM);
                            frame.cdata(frame.cdata<0) = 1e-5;
                            frame.cdata(frame.cdata>1) = 1;
                            frame.colormap = [];
                            try,writeVideo(writerObj,frame);GotFrame(num_fr) = 1;catch, GotFrame(num_fr) = 0;disp('missed frame video'),end
                        else
                            frame.cdata = cat(3,IM,IM,IM);
                            frame.cdata(frame.cdata<0) = 1e-5;
                            frame.cdata(frame.cdata>1) = 1;
                            frame.colormap = [];
                            try,writeVideo(writerObj,frame);GotFrame(num_fr) = 1;catch, GotFrame(num_fr) = 0; disp('missed frame video'),end
                        end
                    else
                        frame.cdata = cat(3,IM,IM,IM);
                        frame.cdata(frame.cdata<0) = 1e-5;
                        frame.cdata(frame.cdata>1) = 1;
                        frame.colormap = [];
                        try,writeVideo(writerObj,frame);GotFrame(num_fr) = 1;catch, GotFrame(num_fr) = 0; disp('missed frame video'),end
                    end
                    
                    num_fr=num_fr+1;
                    
                else
                    
                    % Update displays at 5Hz - faster would just be a waste of
                    % time
                    % For compression the actual picture is updated faster so
                    % as to save it
                    if strcmp(TrObjLocal.camera_type,'Webcam')
                        if strcmp(TrObjLocal.vid.VideoFormat,'RGB24_320x240')
                            IM = rgb2gray(IM);
                            frame.cdata = cat(3,IM,IM,IM);
                            frame.cdata(frame.cdata<0) = 1e-5;
                            frame.cdata(frame.cdata>1) = 1;
                            frame.colormap = [];
                            try,writeVideo(writerObj,frame);GotFrame(num_fr) = 1;catch, GotFrame(num_fr) = 0; disp('missed frame video'),end
                        else
                            frame.cdata = cat(3,IM,IM,IM);
                            frame.cdata(frame.cdata<0) = 1e-5;
                            frame.cdata(frame.cdata>1) = 1;
                            frame.colormap = [];
                            try,writeVideo(writerObj,frame);GotFrame(num_fr) = 1;catch, GotFrame(num_fr) = 0; disp('missed frame video'),end
                        end
                    else
                        frame.cdata = cat(3,IM,IM,IM);
                        frame.cdata(frame.cdata<0) = 1e-5;
                        frame.cdata(frame.cdata>1) = 1;
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
                        figure(Fig_UMaze), subplot(5,5,22:25)
                        set(gca,'Ylim',[0 max(ymax,1e-5)]);
                        
                        if strcmp('Cond',ExpeInfo.namePhase) || strcmp('TestPre',ExpeInfo.namePhase) ||...
                                strcmp('TestPost',ExpeInfo.namePhase) || ...
                                strcmp('CondWallShock',ExpeInfo.namePhase) || strcmp('BlockedWall',ExpeInfo.namePhase) ||...
                                strcmp('BlockedWallShock',ExpeInfo.namePhase) || strcmp('Hab',ExpeInfo.namePhase) ||...
                                strcmp('CondWallSafe',ExpeInfo.namePhase) || strcmp('TestPreFakeStim',ExpeInfo.namePhase) ||...
                                strcmp('CondMFB',ExpeInfo.namePhase)
                            
                            if sum(~isnan(PosMat(:,2)))>0 && ~OPF
                                set(htrack3,'Xdata',PosMat(1:num_fr-1,2),'YData',PosMat(1:num_fr-1,3))
                                hold on
                                set(maskplot,'XData',new_mask(:,2),'YData',new_mask(:,1),'Color','b','LineWidth',2);
                                hold off
                                set(u,'Xdata',Pos(1),'YData',Pos(2), 'MarkerSize',14)
                            end
                        end
                        
                    end
                    OldIm=NewIm;
                    OldZone=FzZone;
                end
                
                
                % --------------------- SAVE FRAMES every NumFramesToSave  -----------------------
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
                
                %% Specific to UMaze protocol
                if strcmp('Cond',ExpeInfo.namePhase) &&  sum(isnan(Pos))==0
                    %%%%%%%%%%%% Place cell-driven %%%%%%%%%%%%%%%%%%
                    if PCDriven
                        receivedshock = true;
                        if strcmp(StimSleepState, 'Any')
                            fwrite(a,arduinoDictionary.StimAnyState)
                        end
                        where= Zone{1}(max(floor(Pos(2).*TrObjLocal.Ratio_IMAonREAL),1),max(floor(Pos(1).*TrObjLocal.Ratio_IMAonREAL),1));
                        if num_fr > 16
                            coord = arrayfun(@(k) PosMat(end-15:end,k), 1:3, 'UniformOutput', false);
                            time = coord{1}(~isnan(coord{2})); % time
                            xy = arrayfun(@(k) coord{k}(~isnan(coord{k})), 2:3, 'UniformOutput', false);
                            if length(xy{1}) > 6
                                avspeed = mean(sqrt(diff(xy{1}).^2+diff(xy{2}).^2)./(diff(time)));
                            else
                                avspeed = 100; %% Some very high number
                            end
                        else
                            avspeed = 100; %% Some very high number
                        end
                        if where==1
                            fwrite(a, arduinoDictionary.AutoStimModeOFF);
                            set(chronostim,'string',num2str(floor(etime(clock,KeepTime.LastStim))));
                            if etime(clock,KeepTime.LastStim)>1.5*delStim
                                KeepTime.LastStim=clock;
                                KeepTime.LastStim(end)=KeepTime.LastStim(end)-(delStim-delStimreturn); % was 5
                            end
                            if etime(clock,KeepTime.LastStim)>delStim +2*rand
                                KeepTime.LastStim=clock;
                                fwrite(a,arduinoDictionary.SendStim);
                                receivedshock = true;  %% Mouse should get at least one shock to be eligible to reactivation-deriven stimulation
                                PosMat(end,4)=1;
                                disp('stim')
                                nbstim=nbstim+1;
                            end
                        elseif where ~=1 && receivedshock && mean(avspeed) < speedthresh
                            fwrite(a, arduinoDictionary.AutoStimModeON);
                        end
                        %%%%%%%%%%%% Location-driven %%%%%%%%%%%%%%%%%%
                    else
                        where= Zone{1}(max(floor(Pos(2).*TrObjLocal.Ratio_IMAonREAL),1),max(floor(Pos(1).*TrObjLocal.Ratio_IMAonREAL),1));
                        if where==1
                            fwrite(a, arduinoDictionary.AutoStimModeOFF);
                            set(chronostim,'string',num2str(floor(etime(clock,KeepTime.LastStim))));
                            if etime(clock,KeepTime.LastStim)>1.5*delStim
                                KeepTime.LastStim=clock;
                                KeepTime.LastStim(end)=KeepTime.LastStim(end)-(delStim-delStimreturn); % was 5
                            end
                            if etime(clock,KeepTime.LastStim)>delStim +2*rand
                                KeepTime.LastStim=clock;
                                fwrite(a,arduinoDictionary.SendStim);
                                receivedshock = true;
                                PosMat(end,4)=1;
                                disp('stim')
                                nbstim=nbstim+1;
                            end
                        end
                    end
                end
                %----------------------------------------------------------%
                %                 COND for MFB experiment
                %----------------------------------------------------------%
                if strcmp('CondMFB',ExpeInfo.namePhase) &&  sum(isnan(Pos))==0
                    % get zone position of mouse
                    where = Zone{1}(max(floor(Pos(2).*TrObjLocal.Ratio_IMAonREAL),1), ...
                        max(floor(Pos(1).*TrObjLocal.Ratio_IMAonREAL),1));
                    if where==1
                        fwrite(a, arduinoDictionary.AutoStimModeOFF);
                        % If mouse enters stim zone initialize the ISI to a
                        % random number between the min and max time set (see global vars section)                        
                        if entry 
                            isi = minisi + (maxisi-minisi)*rand();
                        end
                        % update countdown clock on screen
                        set(chronostim,'string',num2str(floor(isi-etime(clock,KeepTime.LastStim))));
                        % STIM only if mouse enters the zone OR countdown
                        % for ISI is done AND last stim occured more than a second before 
                        % (this last condition is for instances where the mouse will exit and enter right away) 
                        if (etime(clock,KeepTime.LastStim)>isi) ...
                                 || firstentry
                            KeepTime.LastStim=clock;
                            fwrite(a,arduinoDictionary.SendStim);
                            receivedshock = true;
                            PosMat(end,4)=1;
                            disp('stim')
                            nbstim=nbstim+1;
                            isi = minisi + (maxisi-minisi)*rand();
                            entry=0;firstentry=0;
                        end
                    else
                        entry=1;
                    end    
                end
                if strcmp('TestPreFakeStim',ExpeInfo.namePhase) &&  sum(isnan(Pos))==0
                    fwrite(a,arduinoDictionary.AutoStimModeON);
                    if strcmp(StimSleepState, 'Any')
                        fwrite(a,arduinoDictionary.StimAnyState)
                    end
                    %%%%%%%%%%%% Place cell-driven %%%%%%%%%%%%%%%%%%
                    if num_fr > 16
                        coord = arrayfun(@(k) PosMat(end-15:end,k), 1:3, 'UniformOutput', false);
                        time = coord{1}(~isnan(coord{2})); % time
                        xy = arrayfun(@(k) coord{k}(~isnan(coord{k})), 2:3, 'UniformOutput', false);
                        if length(xy{1}) > 6
                            avspeed = mean(sqrt(diff(xy{1}).^2+diff(xy{2}).^2)./(diff(time)));
                        else
                            avspeed = 0.0001; %% Some very low number
                        end
                    else
                        avspeed = 0.0001; %% Some very low number
                    end
                    if mean(avspeed) > 2.5
                        fwrite(a, arduinoDictionary.AutoStimModeON);
                    else
                        fwrite(a, arduinoDictionary.AutoStimModeOFF);
                    end
                end
                
                if (strcmp('SleepStim',ExpeInfo.namePhase))
                    fwrite(a,arduinoDictionary.AutoStimModeON);
                    if strcmp(StimSleepState, 'Any')
                        fwrite(a,arduinoDictionary.StimAnyState)
                    elseif strcmp(StimSleepState, 'Sleep')
                        fwrite(a,arduinoDictionary.StimSleepState)
                        % Thresholding on movements (stimulate if mouse stys below thresholds more more then MinSleepTime)
                        if im_diff(end,2)<th_immob && size(im_diff,1)>3
                            SleepChrono=SleepChrono+im_diff(end,1)-im_diff(end-1,1);
                            if SleepChrono>MinSleepTime
                                PeriodChrono=PeriodChrono+im_diff(end,1)-im_diff(end-1,1);
                                fwrite(a,arduinoDictionary.AutoStimModeON);
                            else
                                fwrite(a,arduinoDictionary.AutoStimModeOFF);
                            end
                        elseif im_diff(end,2)>th_immob && size(im_diff,1)>3
                            fwrite(a,arduinoDictionary.AutoStimModeOFF);
                            SleepChrono=0;
                        end
                    elseif strcmp(StimSleepState, 'NREM')
                        fwrite(a,arduinoDictionary.StimNREM)
                        % Thresholding on movements (stimulate if mouse stys below thresholds more more then MinSleepTime)
                        if im_diff(end,2)<th_immob && size(im_diff,1)>3
                            SleepChrono=SleepChrono+im_diff(end,1)-im_diff(end-1,1);
                            if SleepChrono>MinSleepTime
                                PeriodChrono=PeriodChrono+im_diff(end,1)-im_diff(end-1,1);
                                fwrite(a,arduinoDictionary.AutoStimModeON);
                            else
                                fwrite(a,arduinoDictionary.AutoStimModeOFF);
                            end
                        elseif im_diff(end,2)>th_immob && size(im_diff,1)>3
                            fwrite(a,arduinoDictionary.AutoStimModeOFF);
                            SleepChrono=0;
                        end
                    elseif strcmp(StimSleepState, 'REM')
                        fwrite(a,arduinoDictionary.StimREM)
                    elseif strcmp(StimSleepState, 'Wake')
                        fwrite(a,arduinoDictionary.StimWake)
                    end
                end
                
                
                if (strcmp('BlockedWallShock',ExpeInfo.namePhase))
                    if etime(clock,KeepTime.tDeb)>SinglShockTime(ShTN)
                        fwrite(a,arduinoDictionary.SendStim);
                        PosMat(end,4)=1;
                        SinglShockTime(ShTN)
                        disp('shock')
                        ShTN=ShTN+1;
                        set(chronostim,'string',num2str(SinglShockTime(ShTN)));
                    end
                end
                
                if (strcmp('CondWallSafe',ExpeInfo.namePhase))
                    if etime(clock,KeepTime.tDeb)>160
                        set(inputDisplay(11),'string','Remove door at 180','ForegroundColor','r','FontSize',15);
                    end
                    if etime(clock,KeepTime.tDeb)>180  &   sum(isnan(Pos))==0
                        where= Zone{1}(max(floor(Pos(2).*TrObjLocal.Ratio_IMAonREAL),1),max(floor(Pos(1).*TrObjLocal.Ratio_IMAonREAL),1));
                        if where==1
                            set(chronostim,'string',num2str(floor(etime(clock,KeepTime.LastStim))));
                            if etime(clock,KeepTime.LastStim)>1.5*delStim %was 2
                                KeepTime.LastStim=clock;
                                KeepTime.LastStim(end)=KeepTime.LastStim(end)-(delStim-delStimreturn); % was 5
                            end
                            if etime(clock,KeepTime.LastStim)>delStim +2*rand
                                KeepTime.LastStim=clock;
                                fwrite(a,arduinoDictionary.SendStim);
                                PosMat(end,4)=1;
                                disp('stim')
                                nbstim=nbstim+1;
                            end
                        end
                    end
                end
                
                if (strcmp('CondWallShock',ExpeInfo.namePhase))
                    if etime(clock,KeepTime.tDeb)>160
                        set(inputDisplay(11),'string','Remove door at 180','ForegroundColor','r','FontSize',15);
                    end
                    if etime(clock,KeepTime.tDeb)>CondWallShockTime(ShTN)
                        fwrite(a,arduinoDictionary.SendStim);
                        PosMat(end,4)=1;
                        CondWallShockTime(ShTN)
                        disp('shock')
                        ShTN=ShTN+1;
                        set(chronostim,'string',num2str(CondWallShockTime(ShTN)));
                    end
                    
                    if etime(clock,KeepTime.tDeb)>180  &  sum(isnan(Pos))==0
                        set(inputDisplay(10),'string','TimeInZone');
                        where= Zone{1}(max(floor(Pos(2).*TrObjLocal.Ratio_IMAonREAL),1),max(floor(Pos(1).*TrObjLocal.Ratio_IMAonREAL),1));
                        if where==1
                            set(chronostim,'string',num2str(floor(etime(clock,KeepTime.LastStim))));
                            if etime(clock,KeepTime.LastStim)>1.5*delStim %was 2
                                KeepTime.LastStim=clock;
                                KeepTime.LastStim(end)=KeepTime.LastStim(end)-(delStim-delStimreturn); % was 5
                            end
                            if etime(clock,KeepTime.LastStim)>delStim +2*rand
                                KeepTime.LastStim=clock;
                                fwrite(a,arduinoDictionary.SendStim);
                                PosMat(end,4)=1;
                                disp('stim')
                                nbstim=nbstim+1;
                            end
                        end
                    end
                end
                
                
                %% Sound Protocols
                if strcmp('SoundCnd',ExpeInfo.namePhase)
                    if etime(clock,KeepTime.tDeb)>SoundTimesCond(ShTN)
                        if rem(ShTN,2)==0
                            fwrite(a,arduinoDictionary.Sound);
                            PosMat(end,4)=2;
                            disp('CS-')
                            set(chronostim,'ForegroundColor','r');
                            set(inputDisplay(11),'string','Change Sound to CS+','ForegroundColor','r');
                        else
                            fwrite(a,arduinoDictionary.SoundStim);
                            PosMat(end,4)=1;
                            disp('CS+ shock')
                            set(chronostim,'ForegroundColor','g');
                            set(inputDisplay(11),'string','Change Sound to CS-','ForegroundColor','g');
                        end
                        ShTN=ShTN+1;
                        set(chronostim,'string',num2str(SoundTimesCond(ShTN)));
                    end
                end
                
                if (strcmp('SoundHab',ExpeInfo.namePhase)|strcmp('SoundTest',ExpeInfo.namePhase))
                    if etime(clock,KeepTime.tDeb)>SoundTimesHabTest(ShTN)
                        fwrite(a,arduinoDictionary.Sound);
                        PosMat(end,4)=2;
                        disp('CS-/CS+')
                        if ShTN<=4
                            disp('CS-')
                        else
                            disp('CS+')
                        end
                        if ShTN==4
                            set(chronostim,'ForegroundColor','r');
                            set(inputDisplay(11),'string','Change Sound to CS+','ForegroundColor','r');
                        end
                        ShTN=ShTN+1;
                        set(chronostim,'string',num2str(SoundTimesHabTest(ShTN)));
                    end
                end
                
                %% Calibration Protocols
                if (strcmp('Calibration',ExpeInfo.namePhase))
                    if etime(clock,KeepTime.tDeb)>CalibTimes(ShTN)
                        fwrite(a,arduinoDictionary.SendStim);
                        PosMat(end,4)=1;
                        CalibTimes(ShTN)
                        disp('shock')
                        ShTN=ShTN+1;
                        set(chronostim,'string',num2str(CalibTimes(ShTN)));
                    end
                end
                
                if (strcmp('CalibrationEyeshock',ExpeInfo.namePhase))
                    if etime(clock,KeepTime.tDeb)>CalibTimesEyeshock(ShTN)
                        fwrite(a,arduinoDictionary.SendStim);
                        PosMat(end,4)=1;
                        CalibTimesEyeshock(ShTN)
                        disp('shock')
                        ShTN=ShTN+1;
                        set(chronostim,'string',num2str(CalibTimesEyeshock(ShTN)));
                    end
                end
                
                if (strcmp('ExploratoryStimulation',ExpeInfo.namePhase))
                    Volt = datasample(ExpeInfo.Voltage,1);
                    ProgramPulsePalParam(1,'Phase1Voltage', Volt);
                    ProgramPulsePalParam(1,'Phase2Voltage', -Volt);
                    if ~isempty(PosMat)
                        PosMat(end,4)=Volt;
                    end
                end
                
            end
            
            KeepTime.t2 = clock;
            if StartChrono && etime(KeepTime.t2,KeepTime.tDeb)> ExpeInfo.lengthPhase+0.5
                enableTrack=0;
            end
        end
        
        
        ShTN=1;% reset for next phase
        fwrite(a,arduinoDictionary.AutoStimModeOFF);
        fwrite(a,arduinoDictionary.Off); % switch off intan
        
        % Correct for intan trigger time to realign with ephys
        im_diff(:,1)=im_diff(:,1)+1;
        PosMat(:,1)=PosMat(:,1)+1;
        MouseTemp(:,1) = MouseTemp(:,1)+1;
        
        %% This is the strict minimum all codes need to save %%
        if sum(~isnan(PosMat(:,2))) > 0
            [PosMat,PosMatInit,im_diff,im_diffInit,Vtsd,Xtsd,Ytsd,Imdifftsd]=CommonInterpPosMatImDiff(im_diff,...
                KeepTime.chrono,PosMat,dist_thresh);
            ref=TrObjLocal.ref;mask=TrObjLocal.mask;Ratio_IMAonREAL=TrObjLocal.Ratio_IMAonREAL;
            frame_limits=TrObjLocal.frame_limits;
            save([ExpeInfo.name_folder,filesep,'TrObject.mat'],'TrObjLocal');
            
            save([ExpeInfo.name_folder,filesep,'behavResources.mat'], 'RoomTempBegin','PosMat','GotFrame','PosMatInit','im_diff','im_diffInit','Vtsd','Xtsd','Ytsd','Imdifftsd',...
                'ref','mask','Ratio_IMAonREAL','BW_threshold','frame_limits','smaller_object_size','sm_fact','strsz','SrdZone');
            clear ref mask Ratio_IMAonREAL frame_limits
            
            %%
            % Do some extra code-specific calculations
            try FreezeEpoch=thresholdIntervals(Imdifftsd,th_immob,'Direction','Below');
                FreezeEpoch=mergeCloseIntervals(FreezeEpoch,0.3*1E4);
                FreezeEpoch=dropShortIntervals(FreezeEpoch,thtps_immob*1E4);
                Freeze=sum(End(FreezeEpoch)-Start(FreezeEpoch));
            catch
                Freeze=NaN;
                Freeze2=NaN;
            end
            
            Xtemp=Data(Xtsd);
            T1=Range(Xtsd);
            if not(isempty('Zone'))
                XXX = floor(Data(Xtsd)*TrObjLocal.Ratio_IMAonREAL);
                XXX(isnan(XXX)) = 240;
                YYY = floor(Data(Ytsd)*TrObjLocal.Ratio_IMAonREAL);
                YYY(isnan(YYY)) = 320;
                for t = 1:length(Zone)
                    try
                        ZoneIndices{t}=find(diag(Zone{t}(XXX,YYY)));
                        Xtemp2=Xtemp*0;
                        Xtemp2(ZoneIndices{t})=1;
                        ZoneEpoch{t}=thresholdIntervals(tsd(T1,Xtemp2),0.5,'Direction','Above');
                        Occup(t)=size(ZoneIndices{t},1)./size(XXX,1);
                        FreezeTime(t)=length(Data(Restrict(Xtsd,and(FreezeEpoch,ZoneEpoch{t}))))./length(Data((Restrict(Xtsd,ZoneEpoch{t}))));
                    catch
                        ZoneIndices{t}=[];
                        ZoneEpoch{t}=intervalSet(0,0);
                        Occup(t)=0;
                        FreezeTime(t)=0;
                    end
                end
            else
                for t=1:2
                    ZoneIndices{t}=[];
                    ZoneEpoch{t}=intervalSet(0,0);
                    Occup(t)=0;
                    FreezeTime(t)=0;
                end
            end
            clear Xtemp T1 XXX YYY
            
            save([ExpeInfo.name_folder,filesep,'behavResources.mat'],'FreezeEpoch','th_immob','thtps_immob',...
                'Zone','ZoneEpoch','ZoneIndices','FreezeTime','Occup','DoorChangeMat',...
                'delStim','delStimreturn','MouseTemp','ZoneLabels','-append');
            
            
            if OPF
                save([ExpeInfo.name_folder,filesep,'behavResources.mat'], 'nb_ttl', 'RGBoccupation', 'RGBcarte_spike', 'RGBcell_map', '-append');
            end
            
            %%
            % save and copy file in save_folder
            msg_box=msgbox('Saving behavioral Information','save','modal');
            % Shut the video if compression was being done on the fly
            close(writerObj);
            
            pause(0.5)
            try set(PlotFreez,'YData',0,'XData',0);end
            
            if (strcmp('Cond',ExpeInfo.namePhase)) || (strcmp('CondMFB',ExpeInfo.namePhase)) ||...
                    (strcmp('CondWallShock',ExpeInfo.namePhase)) || (strcmp('CondWallSafe',ExpeInfo.namePhase))
                disp(['Number of stim in the SZ during last trial: ' num2str(nbstim)]);
            end
            
            %% generate figure that gives overviewof the tracking session
            figbilan=figure;
            subplot(2,3,1:3)
            plot(Range(Vtsd,'s'),Data(Vtsd)./prctile(Data(Vtsd),98),'k'), hold on
            plot(Range(Imdifftsd,'s'),Data(Imdifftsd)./prctile(Data(Imdifftsd),98),'b')
            for k=1:length(Start(FreezeEpoch))
                plot(Range(Restrict(Imdifftsd,subset(FreezeEpoch,k)),'s'),Data(Restrict(Imdifftsd,subset(FreezeEpoch,k)))*0+max(ylim)*0.8,'c','linewidth',2)
            end
            plot(PosMat(PosMat(:,4)==1,1),PosMat(PosMat(:,4)==1,1)*0+max(ylim)*0.9,'k*')
            if exist('ZoneEpoch')
                for k=1:length(Start(ZoneEpoch{1}))
                    plot(Range(Restrict(Imdifftsd,subset(ZoneEpoch{1},k)),'s'),Data(Restrict(Imdifftsd,subset(ZoneEpoch{1},k)))*0+max(ylim)*0.95,'r','linewidth',2)
                end
                for k=1:length(Start(ZoneEpoch{2}))
                    plot(Range(Restrict(Imdifftsd,subset(ZoneEpoch{2},k)),'s'),Data(Restrict(Imdifftsd,subset(ZoneEpoch{2},k)))*0+max(ylim)*0.95,'g','linewidth',2)
                end
            end
            title('Raw Data')
            
            subplot(2,2,3)
            bar(Occup(1:2))
            hold on
            try,set(gca,'Xtick',[1,2],'XtickLabel',{ZoneLabels{1:2}}),end
            colormap copper
            ylabel('% time spent')
            xlim([0.5 2.5])
            box off
            
            subplot(2,2,4)
            bar(FreezeTime(1:2))
            hold on
            try,set(gca,'Xtick',[1,2],'XtickLabel',{ZoneLabels{1:2}}),end
            colormap copper
            ylabel('% time spent freezing')
            xlim([0.5 2.5])
            box off
            
            saveas(figbilan,[ExpeInfo.name_folder,filesep,'FigBilan.fig'])
            saveas(figbilan,[ExpeInfo.name_folder,filesep,'FigBilan.png'])
            close(figbilan)
            
            % Figure2 - figure with heatmap of movements and animal's trajectory
            
            foccup = figure;
            
            XXX = Data(Xtsd);
            XXX(isnan(XXX)) = [];
            YYY = Data(Ytsd);
            YYY(isnan(YYY)) = [];
            [occH, x1, x2] = hist2(XXX, YYY, 240, 320);
            occHS(1:320,1:240) = SmoothDec(occH/TrObjLocal.frame_rate,[smo,smo]);
            x=x1;
            y=x2;
            
            imagesc(x1,x2,occHS)
            caxis([0 .1]) % control color intensity here
            colormap(hot)
            hold on
            % -- trajectories
            p1 = plot(PosMat(:,2),PosMat(:,3), 'w', 'linewidth',.05);
            p1.Color(4) = .3;    %control line color intensity here
            hold on
            set(gca, 'XTickLabel', []);
            set(gca, 'YTickLabel', []);
            set(gca, 'xdir','reverse');
            camroll(90)
            title('Occupancy map');
            
            saveas(foccup,[ExpeInfo.name_folder,filesep,'HeatMap.fig'])
            saveas(foccup,[ExpeInfo.name_folder,filesep,'HeatMap.png'])
            close(foccup)
            clear XXX YYY
            
            % update display and button availability
            try
                close(guireg_fig)
                close(GuiForUmaze)
                set(Fig_UMaze,'Color',color_on);
                delete(msg_box)
                
                set(maskbutton(5),'enable','on','FontWeight','normal')
                set(maskbutton(4),'enable','off','FontWeight','normal')
                set(maskbutton(7),'enable','off','FontWeight','normal')
                set(maskbutton(3),'enable','on','FontWeight','normal')
                set(chronostim,'ForegroundColor','k');
                set(inputDisplay(11),'string','You can relax','ForegroundColor','k','FontSize',8);
            end
            
            % play sound alarm (SL)
            % load handel
            % sound(y,Fs)
        else
            msg_box=msgbox('No mouse was tracked. No data saved','Ok','modal');
            
            close(guireg_fig)
            close(GuiForUmaze)
            set(Fig_UMaze,'Color',color_on);
            
            set(maskbutton(5),'enable','on','FontWeight','normal')
            set(maskbutton(4),'enable','off','FontWeight','normal')
            set(maskbutton(7),'enable','off','FontWeight','normal')
            set(maskbutton(3),'enable','on','FontWeight','normal')
            set(chronostim,'ForegroundColor','k');
            set(inputDisplay(11),'string','You can relax','ForegroundColor','k','FontSize',8);
        end
    end
    

%% Make manual sleep scoring
    function ManualStim(obj,event)
        fwrite(a,arduinoDictionary.SendStim);
    end

%     function SwitchSleepOff(obj,event)
%         fwrite(a,arduinoDictionary.SleepOff);
%         set(maskbutton(11),'enable','off','FontWeight','bold')
%         set(maskbutton(10),'enable','on','FontWeight','bold')
%     end

%% Define behavioural zones
    function DefineZones(obj,event)
        global Zones
        % Automatically or manually
        poi=questdlg('Do you want to define zones automtically?','Yes or No','Yes','No','Yes');
        
        if strcmp(poi,'No')
            figtemp=figure();
            imagesc(TrObjLocal.ref), colormap redblue,hold on
            if strcmp(ExpeInfo.namePhase,'EPM')
                Zone = []; ZoneEpoch = []; ZoneIndices = []; ZoneLabels = [];
                disp('OpenArms');[x1,y1,Open,x2,y2]=roipoly; plot(x2,y2)
                disp('ClosedArms');[x1,y1,Closed,x2,y2]=roipoly(); plot(x2,y2)
                Centre=zeros(size(TrObjLocal.ref));Centre(Open==1 & Closed==1)=1;
                Open(Centre==1)=0;Closed(Centre==1)=0;
                Zone{1}=uint8(Open);Zone{2}=uint8(Closed);Zone{3}=uint8(Centre);
                ZoneLabels={'OpenArms','ClosedArms','Centre'};
                set(maskbutton(3),'string','3 - GetBehavZones (OK)')
            elseif strcmp(ExpeInfo.namePhase,'SoundCnd') || strcmp(ExpeInfo.namePhase,'SoundHab')...
                    || strcmp(ExpeInfo.namePhase,'SoundTest') || strcmp(ExpeInfo.namePhase,'Calibration')...
                    || strcmp(ExpeInfo.namePhase,'SleepSession') || strcmp(ExpeInfo.namePhase,'SleepStim')...
                    || strcmp(ExpeInfo.namePhase,'CalibrationEyeshock') || strcmp(ExpeInfo.namePhase,'ExploratoryStimulation')
                Zone = []; ZoneEpoch = []; ZoneIndices = []; ZoneLabels = [];
                stats = regionprops(TrObjLocal.mask, 'Area');
                tempmask=TrObjLocal.mask;
                AimArea=stats.Area/2;
                ActArea=stats.Area;
                while AimArea<ActArea
                    tempmask=imerode(tempmask,strel('disk',1));
                    stats = regionprops(tempmask, 'Area');
                    ActArea=stats.Area;
                end
                Zone{1}=uint8(tempmask); % Inside area
                Zone{2}=uint8(TrObjLocal.mask-tempmask);% Outside area
                ZoneLabels={'Inside','Outside'};
                set(maskbutton(3),'string','3 - GetBehavZones (OK)')
            else
                % added farshock and farnoshock zones (SL - 23/07/2019)
                Zone = []; ZoneEpoch = []; ZoneIndices = []; ZoneLabels = [];
                title('Shock'); [x1,y1,Shock,x2,y2]=roipoly; Zone{1}=uint8(Shock);plot(x2,y2,'linewidth',2)
                title('NoShock');[x1,y1,NoShock,x2,y2]=roipoly(); Zone{2}=uint8(NoShock);plot(x2,y2,'linewidth',2)
                title('Centre');[x1,y1,Centre,x2,y2]=roipoly(); Zone{3}=uint8(Centre);plot(x2,y2,'linewidth',2)
                title('CentreShock');[x1,y1,CentreShock,x2,y2]=roipoly(); Zone{4}=uint8(CentreShock);plot(x2,y2,'linewidth',2)
                title('CentreNoShock');[x1,y1,CentreNoShock,x2,y2]=roipoly(); Zone{5}=uint8(CentreNoShock);plot(x2,y2,'linewidth',2)
                title('FarShock');[x1,y1,FarShock,x2,y2]=roipoly(); Zone{8}=uint8(FarShock);plot(x2,y2,'linewidth',2)
                title('FarNoShock');[x1,y1,FarNoShock,x2,y2]=roipoly(); Zone{9}=uint8(FarNoShock);plot(x2,y2,'linewidth',2)
                stats = regionprops(TrObjLocal.mask, 'Area');
                tempmask=TrObjLocal.mask;
                AimArea=stats.Area/2;
                ActArea=stats.Area;
                while AimArea<ActArea
                    tempmask=imerode(tempmask,strel('disk',1));
                    stats = regionprops(tempmask, 'Area');
                    ActArea=stats.Area;
                end
                Zone{6}=uint8(tempmask); % I]
                Zone{7}=uint8(TrObjLocal.mask-tempmask);% Outside area
                ZoneLabels={'Shock','NoShock','Centre','CentreShock','CentreNoShock','Inside','Outside','FarShock','FarNoShock'};
                set(maskbutton(3),'string','3 - GetBehavZones (OK)')
                
                % old script - erase if all good
                
                %             Zone = []; ZoneEpoch = []; ZoneIndices = []; ZoneLabels = [];
                %             title('Shock'); [x1,y1,Shock,x2,y2]=roipoly; Zone{1}=uint8(Shock);plot(x2,y2,'linewidth',2)
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
                %             Zone{6}=uint8(tempmask); % I]
                %             Zone{7}=uint8(TrObjLocal.mask-tempmask);% Outside area
                %             ZoneLabels={'Shock','NoShock','Centre','CentreShock','CentreNoShock','Inside','Outside'};
                %             set(maskbutton(3),'string','3 - GetBehavZones (OK)')
                
                
            end
            
        elseif strcmp(poi,'Yes')
            
            % has to be reset everytime you press the button or else it will use the old/changed values
            mask_UMaze = [200 223 200 57 60 57 60 130 155 130 155 151 60 151 60 223 200 223];
            
            % define shock zone
            ShockMask =[60 223 125 223 125 151 60 151 60 223];
            NoShockMask = [60 57 125 57 125 130 60 130 60 57];
            CentreMask = [200 151 200 130 160 130 160 151 200 151];
            CentreShockMask = [125 223 160 223 160 151 125 151 125 223];
            CentreNoShockMask = [125 57 160 57 160 130 125 130 125 57];
            FarShockMask = [200 223 200 151 160 151 160 223 200 223];
            FarNoShockMask = [200 57 160 57 160 130 200 130 200 57];
            zones = [ShockMask;NoShockMask;CentreMask;CentreShockMask;CentreNoShockMask; ...
                FarShockMask;FarNoShockMask];
            
            % rotate umaze if necessary
            [mask_UMaze zone_rot side] = rotate_umaze(mask_UMaze,zones,1);
            
            ShockMask = zone_rot(1,:);
            NoShockMask = zone_rot(2,:);
            CentreMask = zone_rot(3,:);
            CentreShockMask = zone_rot(4,:);
            CentreNoShockMask = zone_rot(5,:);
            FarShockMask = zone_rot(6,:);
            FarNoShockMask = zone_rot(7,:);
            
            figtemp=figure();
            im = insertShape(TrObjLocal.ref,'Polygon',mask_UMaze);
            im = rgb2gray(im);
            imagesc(im), colormap redblue,hold on
            
            Zone = []; ZoneEpoch = []; ZoneIndices = []; ZoneLabels = [];
            
            Shock = roipoly(im,ShockMask(1:2:end),ShockMask(2:2:end)); Zone{1}=uint8(Shock);
            plot(ShockMask(1:2:end),ShockMask(2:2:end),'linewidth',2);
            NoShock = roipoly(im,NoShockMask(1:2:end),NoShockMask(2:2:end)); Zone{2}=uint8(NoShock);
            plot(NoShockMask(1:2:end),NoShockMask(2:2:end),'linewidth',2);
            Centre = roipoly(im,CentreMask(1:2:end),CentreMask(2:2:end)); Zone{3}=uint8(Centre);
            plot(CentreMask(1:2:end),CentreMask(2:2:end),'linewidth',2);
            CentreShock = roipoly(im,CentreShockMask(1:2:end),CentreShockMask(2:2:end)); Zone{4}=uint8(CentreShock);
            plot(CentreShockMask(1:2:end),CentreShockMask(2:2:end),'linewidth',2);
            CentreNoShock = roipoly(im,CentreNoShockMask(1:2:end),CentreNoShockMask(2:2:end)); Zone{5}=uint8(CentreNoShock);
            plot(CentreNoShockMask(1:2:end),CentreNoShockMask(2:2:end),'linewidth',2);
            FarShock = roipoly(im,FarShockMask(1:2:end),FarShockMask(2:2:end)); Zone{8}=uint8(FarShock);
            plot(FarShockMask(1:2:end),FarShockMask(2:2:end),'linewidth',2);
            FarNoShock = roipoly(im,FarNoShockMask(1:2:end),FarNoShockMask(2:2:end)); Zone{9}=uint8(FarNoShock);
            plot(FarNoShockMask(1:2:end),FarNoShockMask(2:2:end),'linewidth',2);
            pause(4);
            stats = regionprops(TrObjLocal.mask, 'Area');
            tempmask=TrObjLocal.mask;
            AimArea=stats.Area/2;
            ActArea=stats.Area;
            while AimArea<ActArea
                tempmask=imerode(tempmask,strel('disk',1));
                stats = regionprops(tempmask, 'Area');
                ActArea=stats.Area;
            end
            Zone{6}=uint8(tempmask); % I]
            Zone{7}=uint8(TrObjLocal.mask-tempmask);% Outside area
            ZoneLabels={'Shock','NoShock','Centre','CentreShock','CentreNoShock','Inside','Outside','FarShock','FarNoShock'};
            set(maskbutton(3),'string','3 - GetBehavZones (OK)')
            
        end
        
        close(figtemp)
        set(maskbutton(5),'enable','on')
    end

% -----------------------------------------------------------------
%% stop tracking
    function stop_Phase(obj,event)
        if OPF
            saveas(Fig_UMaze,[ExpeInfo.name_folder,filesep,'OnlinePlaceField.fig'])
            saveas(Fig_UMaze,[ExpeInfo.name_folder,filesep,'OnlinePlaceField.png'])
        end
        
        figure(Fig_UMaze), title('ACQUISITION STOPPED')
        enableTrack=0;
        set(maskbutton(4),'enable','on','FontWeight','normal')
        set(maskbutton(7),'enable','off','FontWeight','normal')
        set(maskbutton(3),'enable','off','FontWeight','normal')
        try fwrite(a,arduinoDictionary.AutoStimModeOFF); fwrite(a,arduinoDictionary.Off);disp('Intan OFF');end
        close(writerObj);
        set(maskbutton(5),'enable','off')
        
    end

    function UMaze_OnlineGuiReglage
        % function GuiForUmaze=OnlineGuiReglage(obj,event);
        % let online control of paramteres for image treatments
        
        % create figure
        GuiForUmaze=figure('units','normalized',...
            'position',[0.1 0.1 0.2 0.6],...
            'numbertitle','off',...
            'name','UMaze Mouse Tracking : Setting Parameters',...
            'menubar','none',...
            'tag','figure reglage');
        set(GuiForUmaze,'Color',color_on);
        
        textUM1=uicontrol(GuiForUmaze,'style','text', ...
            'units','normalized',...
            'position',[0.22 0.85 0.2 0.05],...
            'string','freezing threshold');
        
        textUM2=uicontrol(GuiForUmaze,'style','text', ...
            'units','normalized',...
            'position',[0.62 0.85 0.2 0.05],...
            'string','Yaxis');
        
        % create sliders
        slider_freeze = uicontrol(GuiForUmaze,'style','slider',...
            'units','normalized',...
            'position',[0.25 0.1 0.15 0.7],...
            'callback', @freeze_thresh);
        set(slider_freeze,'Value',th_immob/maxth_immob);
        
        slider_yaxis = uicontrol(GuiForUmaze,'style','slider',...
            'units','normalized',...
            'position',[0.65 0.1 0.15 0.7],...
            'callback', @fixyaxis);
        set(slider_yaxis,'Value',ymax/maxyaxis);
        
        % create labels with actual values
        textUM3=uicontrol(GuiForUmaze,'style','text', ...
            'units','normalized',...
            'position',[0.22 0.05 0.2 0.03],...
            'string',num2str(th_immob));
        
        textUM4=uicontrol(GuiForUmaze,'style','text', ...
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
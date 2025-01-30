function [numF,filename]=Tracking_OnlinePlaceField2(~,~)

%% This code is modern day (Feb2019) adaptation of OnlinePlaceField tracking code
%% Found in \Dropbox\Kteam\MOBSESPCIStudent\online tracking juin 2013\
%% Moved as an option in UMazeTracking_IRComp_ObjectOrientated_DBparam

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
arduinoDictionary.ThousandFrames=2; % Sync with intan every 1000 frames
arduinoDictionary.StartGettingSpikes=4; % Read the spike buffer of Arduino

%% Task parameters
global nametypes; nametypes={'OPF'};

% Size of the occupation map
nx = 32;
ny = 32;

%% Initialisation of maps

occupation = zeros(nx,ny); % Occupation map
carte_spike=zeros(size(occupation,1),size(occupation,2)); % Spike Map
cell_map=zeros(size(carte_spike)); % Firing Map
RGBoccupation=zeros(size(occupation,1),size(occupation,2),3); % Colored occupation
RGBcarte_spike=zeros(size(carte_spike,1),size(carte_spike,2),3);% Colored spikes
RGBcell_map=zeros(size(RGBcarte_spike));% Colored firing

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% graphical interface n??? with all the pushbuttons

Fig_OPFSession=figure('units','normalized','position',[0.1 0.1 0.8 0.8],...
    'numbertitle','off','name','OnlinePlaceField','menubar','none','tag','Online Place Field');
set(Fig_OPFSession,'Color',color_on);

maskbutton.Inputs= uicontrol(Fig_OPFSession,'style','pushbutton',...
    'units','normalized','position',[0.01 0.89 0.2 0.05],...
    'string','1- INPUTS EXPE','callback', @giv_inputs);
set(maskbutton.Inputs,'enable','on','FontWeight','bold')

maskbutton.StartExpe= uicontrol(Fig_OPFSession,'style','pushbutton',...
    'units','normalized','position',[0.01 0.65 0.2 0.05],...
    'string','3- START EXPE','callback', @start_Expe);
set(maskbutton.StartExpe,'enable','off')

maskbutton.StartSession= uicontrol(Fig_OPFSession,'style','pushbutton',...
    'units','normalized','position',[0.01 0.48 0.2 0.05],'string','4- START session');
set(maskbutton.StartSession,'enable','off','callback', @StartSession)

maskbutton.StopSession= uicontrol(Fig_OPFSession,'style','pushbutton',...
    'units','normalized','position',[0.025 0.36 0.15 0.03],...
    'string','Stop Emergency','callback', @stop_Phase);
set(maskbutton.StopSession,'enable','off')

maskbutton.Quit= uicontrol(Fig_OPFSession,'style','pushbutton',...
    'units','normalized','position',[0.01 0.03 0.2 0.05],...
    'string','CLOSE EXPE','callback', @quit);
set(maskbutton.Quit,'enable','on','FontWeight','bold')


%TEXTES
maskbutton.OccupText=uicontrol('style','text', ...
    'units','normalized',...
    'position',[0.75 0.52 0.1 0.05],...
    'string','Occupation Map');

maskbutton.SpikeText=uicontrol('style','text', ...
    'units','normalized',...
    'position',[0.35 0.04 0.1 0.05],...
    'string','Spike Map');

maskbutton.FiringText=uicontrol('style','text', ...
    'units','normalized',...
    'position', [0.75 0.04 0.1 0.05],...
    'string','Firing Rate Map');

maskbutton.VidText=uicontrol('style','text', ...
    'units','normalized',...
    'position',[0.35 0.52 0.1 0.05],...
    'string', 'Video');
%FIN TEXTES


% Menu choix du canal

% %choix du num�ro de l'exp�rience
% maskbutton.nExp=uicontrol('style','edit', ...
%     'units','normalized',...
%     'position',[0.025 0.2 0.08 0.05],...
%     'string',num2str(num_exp));
% 
% %bouton N�exp
% maskbutton.nExpButton = uicontrol('style','pushbutton', ...
%     'units','normalized',...
%     'position',[0.025 0.25 0.08 0.05],...
%     'string', ' N�exp',...
%     'callback',@numexp);


inputDisplay.FileName=uicontrol(Fig_OPFSession,'style','text','units','normalized','position',[0.25 0.95 0.5 0.02],'string','Filename = TO DEFINE','FontSize',10,'BackgroundColor',color_on,'ForegroundColor','w','FontWeight','bold');
inputDisplay.SessNum=uicontrol(Fig_OPFSession,'style','text','units','normalized','position',[0.01 0.59 0.16 0.02],'string','Session','FontSize',12,'BackgroundColor',color_on,'ForegroundColor','w','FontWeight','bold');
inputDisplay.Instructions=uicontrol(Fig_OPFSession,'style','text','units','normalized','position',[0.01 0.56 0.16 0.02],'string','WAIT','FontSize',12,'BackgroundColor',color_on,'ForegroundColor','w','FontWeight','bold');

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
        delete(Fig_OPFSession)
    end



%% Ask for all inputs and display
    function giv_inputs(obj,event)
        
        strfcts=strjoin(nametypes,'|');
        u2=uicontrol(Fig_OPFSession,'Style', 'popup','String', strfcts,'units','normalized',...
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
                        
            nameTASK='OnlinePlaceField';
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
        ExpeInfo.name_folder=['OPF-Mouse-' num2str(ExpeInfo.nmouse) '-' ExpeInfo.TodayIs '-' ExpeInfo.namePhase];
        
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
                try
                    fopen(a);
                end
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
        
        figure(Fig_OPFSession),
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
        
        figure(Fig_OPFSession), subplot(20,20,[15:20 35:40 55:60 75:80 95:100 115:120 135:140 155:160]);,
        htrack2 = imagesc(zeros(ny,ny));axis image; caxis([0 1]);hold on
        caxis([0.1 0.9])

        figure(Fig_OPFSession), subplot(20,20,[225:230 245:250 265:270 285:290 305:310 325:330 345:350 365:370]);,
        htrack3 = imagesc(zeros(ny,ny));axis image; caxis([0 1]);hold on
        caxis([0.1 0.9])
        
        figure(Fig_OPFSession), subplot(20,20,[235:240 255:260 275:280 295:300 315:320 335:340 355:360 375:380]);,
        htrack4 = imagesc(zeros(ny,ny));axis image; caxis([0 1]);hold on
        caxis([0.1 0.9])
        
        % -----------------------------------------------------------------
        % ---------------------- INITIATE TRACKING ------------------------
        im_diff=0;
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
        [length_line,length_column] = size(IM);
        
        OldIm=TrObjLocal.mask;
        OldZone=TrObjLocal.mask;
        
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
                
                % -------------------------------------------------------------------------------
                % -------------------------------- Find the mouse   --------------------------------
                [Pos,ImDiff,PixelsUsed,NewIm,FzZone,x_oc,y_oc]=Track_ImDiff(IM,TrObjLocal.mask,TrObjLocal.ref,BW_threshold,smaller_object_size,sm_fact,se,SrdZone,...
                    TrObjLocal.Ratio_IMAonREAL,OldIm,OldZone,TrObjLocal.camera_type, 'nx', nx, 'ny', ny);
                
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
                    nodetect = 0;
                else
                    PosMat(num_fr,:)=[KeepTime.chrono;NaN;NaN;NaN];
                    im_diff(num_fr,1:3)=[KeepTime.chrono;NaN;NaN];
                    MouseTemp(num_fr,1:2)=[KeepTime.chrono;NaN];
                    nodetect = 1;
                end
                
                %% Occupation Map
                if nodetect == 0
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
                        try,writeVideo(writerObj,frame);GotFrame(num_fr) = 1;catch, GotFrame(num_fr) = 0; disp('missed frame video'),end
                    end
                else
                    frame.cdata = cat(3,IM,IM,IM);
                    frame.colormap = [];
                    try,writeVideo(writerObj,frame);GotFrame(num_fr) = 1;catch, GotFrame(num_fr) = 0; disp('missed frame video'),end
                end
                
                num_fr=num_fr+1;
                
                %%
                % -------------------------------------------------------------------------------
                % -------------------------------- SAVE FRAMES   --------------------------------
                if TrObjLocal.SaveToMatFile==1
                    datas.image =IM;
                    datas.time = KeepTime.t1;
                    prefac1=char; for ii=1:6-length(num2str(n)), prefac1=cat(2,prefac1,'0');end
                    save([ ExpeInfo.name_folder filesep ExpeInfo.Fname filesep 'frame' prefac1 sprintf('%0.5g',n)],'datas','-v6');
                    n = n+1;
                    clear data
                end
                
                % -------------------------------------------------------------------------------
                % ------------------- Every 1000 frames sync with intan  -----------------------
                if  mod(num_fr,1000)==0
                    fwrite(a,arduinoDictionary.ThousandFrames);
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
        
        % Correct for intan trigger time to realign with ephys - this is
        % really important!!
        im_diff(:,1)=im_diff(:,1)+1;
        PosMat(:,1)=PosMat(:,1)+1;
        MouseTemp(:,1) = MouseTemp(:,1)+1;
        
        %% This is the strict minimum all codes need to save %%
        [PosMat,PosMatInit,im_diff,im_diffInit,Vtsd,Xtsd,Ytsd,Imdifftsd]=CommonInterpPosMatImDiff(im_diff,KeepTime.chrono,PosMat);
        ref=TrObjLocal.ref;mask=TrObjLocal.mask;Ratio_IMAonREAL=TrObjLocal.Ratio_IMAonREAL;
        frame_limits=TrObjLocal.frame_limits;
        save([ExpeInfo.name_folder,filesep,'TrObject.mat'],'TrObjLocal');

        save([ExpeInfo.name_folder,filesep,'behavResources.mat'],'PosMat', 'GotFrame', 'PosMatInit','im_diff','im_diffInit','Vtsd','Xtsd','Ytsd','Imdifftsd',...
            'ref','mask','Ratio_IMAonREAL','BW_threshold','frame_limits','smaller_object_size','sm_fact','strsz','SrdZone');
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
        
        save([ExpeInfo.name_folder,filesep,'behavResources.mat'],'FreezeEpoch','th_immob','thtps_immob','MouseTemp',...
            'nb_ttl', 'RGBoccupation', 'RGBcarte_spike', 'RGBcell_map', '-append');

        % save and copy file in save_folder
        msg_box=msgbox('Saving behavioral Information','save','modal');
        % Shut the video if compression was being done on the fly
            close(writerObj);
        
        pause(0.5)
        try set(PlotFreez,'YData',0,'XData',0);end
        
        %% generate figure that gives overviewof the tracking session
        figbilan=figure;
        plot(Range(Vtsd,'s'),Data(Vtsd)./prctile(Data(Vtsd),98),'k'), hold on
        plot(Range(Imdifftsd,'s'),Data(Imdifftsd)./prctile(Data(Imdifftsd),98),'b')
        for k=1:length(Start(FreezeEpoch))
            plot(Range(Restrict(Imdifftsd,subset(FreezeEpoch,k)),'s'),Data(Restrict(Imdifftsd,subset(FreezeEpoch,k)))*0+max(ylim)*0.8,'c','linewidth',2)
        end
        title('Raw Data')
        
        saveas(figbilan,[ExpeInfo.name_folder,filesep,'FigBilan.fig'])
        saveas(figbilan,[ExpeInfo.name_folder,filesep,'FigBilan.png'])
        close(figbilan)
        
        % update display and button availability
        try
            close(guireg_fig)
            close(GuiForSleep)
            set(Fig_OPFSession,'Color',color_on);
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
        figure(Fig_OPFSession), title('ACQUISITION STOPPED')
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
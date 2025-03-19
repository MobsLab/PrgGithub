function [numF,filename]=UMazeTracking_IRComp(~,~)
%% INPUTS

%% %%%
% Get global variables that are common to all codes --> code comes from
% GetCommonGlobalVariables
clear -global ref Ratio_IMAonREAL mask enableTrack intermed
global a vid frame_rate IRLimits
global PixelsUsed;  % maxsize in pixels
global se;
global intermed
intermed=load('InfoTrackingTemp.mat');
global ref; ref=intermed.ref;
global mask; mask=intermed.mask;
% global Ratio_IMAonREAL; Ratio_IMAonREAL=intermed.Ratio_IMAonREAL;
% global BW_threshold; if isfield(intermed,'BW_threshold'), BW_threshold=intermed.BW_threshold; else, BW_threshold=0.5; end
% global smaller_object_size; if isfield(intermed,'smaller_object_size'), smaller_object_size=intermed.smaller_object_size; else, smaller_object_size=30; end
% global sm_fact; if isfield(intermed,'sm_fact'), sm_fact=intermed.sm_fact; else, sm_fact=0; end
% global strsz; if isfield(intermed,'strsz'), strsz=intermed.strsz; else, strsz=4; end, se= strel('disk',strsz);
% global SrdZone; if isfield(intermed,'SrdZone'), SrdZone=intermed.SrdZone; else, SrdZone=20; end
global th_immob; if isfield(intermed,'th_immob'), th_immob=intermed.th_immob; else, th_immob=20; end
global guireg_fig
global TrackingFunctions
global time_image;time_image = 1/frame_rate;
global UpdateImage; UpdateImage=ceil(frame_rate/5); % update every n frames the picture shown on screen to show at 10Hz
global writerObj PlotForVideo % allows us to save as .avi
%% %%%%%

global thtps_immob
global chrono
global name_folder
global enableTrack
global LastStim
global Zone
global DoorChangeMat
global thimmobline
global PlotFreez
global PosMat
global n_AutoStop
global num_exp
global StartChrono
global tDeb
global countDown
global namePhase
global t1 t2
t1=clock;
t2=clock;


% Display parameters
global maxyaxis ymax; maxyaxis=500;ymax=0.01;
global maxth_immob; maxth_immob=200 ;
color_on = [ 0 0 0];
color_off = [1 1 1];
colori={'g','r','c'};
scrsz = get(0,'ScreenSize');
global maxfrvis;maxfrvis=800;
global GuiForUmaze

% Time/date parameters
res=pwd;
mark=filesep;
t=clock;
jour=num2str(t(3));if length(jour)==1, jour=cat(2,'0',jour);end
mois=num2str(t(2));if length(mois)==1, mois=cat(2,'0',mois);end
annee=num2str(t(1));
TodayIs=[jour mois annee];

%% Initialization
global ShTN; ShTN=1; % Variable that count the shocks
% variabes that count the iteration of the protocol - for the file save name
nPhase=NaN; %incremented every time session is restarted without clickin on start expe
num_exp=0;  % incremented every time the same experiment is done again via start expe
StartChrono=0; % Variable set to one when the tracking begins


%% Task parameters
global nametypes; nametypes={'Hab','TestPre','Cond','CondWallShock','CondWallSafe','TestPost','Ext','BlockedWall',...
    'EPM','SoundHab','SoundCnd','SoundTest',...
    'Calibration','CalibrationEyeshock','SleepSession','BlockedWallShock'};
mat1=ones(1,30);
global SoundTimesHabTest; SoundTimesHabTest=[122,193,251,351,413,485,636,698,800,874,940,1022,1133,1195,1275,1340,Inf];
global SoundTimesCond;  SoundTimesCond=[122,197,287,362,457,530,640,760,840,930,1010,1095,1185,1285,1365,1430,Inf];
global CalibTimes;  CalibTimes=[50,70,90,110,150,155,157,159,Inf];
global CalibTimesEyeshock;  CalibTimesEyeshock=[50,70,90,110,Inf];
global SinglShockTime; SinglShockTime=[45,Inf];
global CondWallShockTime; CondWallShockTime=[120,150,180,210,Inf];
global delStim; delStim=15;%was 12 for PAG
global delStimreturn; delStimreturn=5;%was 12 for PAG


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% graphical interface n�1 with all the pushbuttons

Fig_UMaze=figure('units','normalized','position',[0.1 0.1 0.4 0.85],...
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
            namePhase=nametypes(fctname);
            savProtoc;
        end
        
        function savProtoc(obj,event)
            set(inputDisplay(9),'string',['Sessions:',{' '},namePhase]);
            
            if strcmp('Hab',namePhase)
                lengthPhase=900;
                set(inputDisplay(10),'string','No Shock');
                set(chronostim,'ForegroundColor','k');
                set(inputDisplay(11),'string','You can relax','ForegroundColor','k');
            elseif strcmp('BlockedWall',namePhase)
                lengthPhase=300;
                set(inputDisplay(10),'string','No Shock');
                set(chronostim,'ForegroundColor','k');
                set(inputDisplay(11),'string','You can relax','ForegroundColor','k');
            elseif strcmp('BlockedWallShock',namePhase)
                lengthPhase=300;
                set(inputDisplay(10),'string','NextShock');
                set(chronostim,'ForegroundColor','r');
                set(chronostim,'string',num2str(SinglShockTime(ShTN)));
                set(inputDisplay(11),'string','You can relax','ForegroundColor','k');
            elseif strcmp('TestPre',namePhase)
                lengthPhase=180;
                set(inputDisplay(10),'string','No Shock');
                set(chronostim,'ForegroundColor','k');
                set(inputDisplay(11),'string','You can relax','ForegroundColor','k');
            elseif strcmp('Cond',namePhase)
                lengthPhase=480;
                set(chronostim,'ForegroundColor','r');
                set(inputDisplay(10),'string','TimeInZone');
                set(chronostim,'string',num2str(0));
                set(inputDisplay(11),'string','You can relax','ForegroundColor','k');
            elseif strcmp('CondWallShock',namePhase)
                lengthPhase=480;
                set(chronostim,'ForegroundColor','r');
                set(inputDisplay(10),'string','NextShock');
                set(chronostim,'string',num2str(CondWallShockTime(ShTN)));
                set(inputDisplay(11),'string','Remove door at 300','ForegroundColor','k');
            elseif strcmp('CondWallSafe',namePhase)
                lengthPhase=480;
                set(chronostim,'ForegroundColor','r');
                set(inputDisplay(10),'string','TimeInZone');
                set(chronostim,'string',num2str(0));
                set(inputDisplay(11),'string','Remove door at 300','ForegroundColor','k');
            elseif strcmp('TestPost',namePhase)
                lengthPhase=180;
                set(inputDisplay(10),'string','No Shock');
                set(chronostim,'ForegroundColor','k');
                set(inputDisplay(11),'string','You can relax','ForegroundColor','k');
            elseif strcmp('Ext',namePhase)
                lengthPhase=900;
                set(inputDisplay(10),'string','No Shock');
                set(chronostim,'ForegroundColor','k');
                set(inputDisplay(11),'string','You can relax','ForegroundColor','k');
            elseif strcmp('EPM',namePhase)
                lengthPhase=1200;
                set(inputDisplay(10),'string','No Shock');
                set(chronostim,'ForegroundColor','k');
                set(inputDisplay(11),'string','You can relax','ForegroundColor','k');
            elseif strcmp('SoundCnd',namePhase)
                lengthPhase=1600;
                set(inputDisplay(10),'string','NextSound');
                set(chronostim,'ForegroundColor','r');
                set(chronostim,'string',num2str(SoundTimesCond(ShTN)));
                set(inputDisplay(11),'string','Check Sound is CS+','ForegroundColor','r');
            elseif strcmp('SoundHab',namePhase)
                lengthPhase=780;
                set(inputDisplay(10),'string','NextSound');
                set(chronostim,'ForegroundColor','g');
                set(chronostim,'string',num2str(SoundTimesHabTest(ShTN)));
                set(inputDisplay(11),'string','Check Sound is CS-','ForegroundColor','g');
            elseif strcmp('SoundTest',namePhase)
                lengthPhase=1450;
                set(inputDisplay(10),'string','NextSound');
                set(chronostim,'ForegroundColor','g');
                set(chronostim,'string',num2str(SoundTimesHabTest(ShTN)));
                set(inputDisplay(11),'string','Check Sound is CS-','ForegroundColor','g');
            elseif strcmp('Calibration',namePhase)
                lengthPhase=180;
                set(inputDisplay(10),'string','NextShock');
                set(chronostim,'ForegroundColor','r');
                set(chronostim,'string',num2str(CalibTimes(ShTN)));
                set(inputDisplay(11),'string','You can relax','ForegroundColor','k');
            elseif strcmp('CalibrationEyeshock',namePhase)
                lengthPhase=130;
                set(inputDisplay(10),'string','NextShock');
                set(chronostim,'ForegroundColor','r');
                set(chronostim,'string',num2str(CalibTimesEyeshock(ShTN)));
                set(inputDisplay(11),'string','You can relax','ForegroundColor','k');
            elseif strcmp('SleepSession',namePhase)
                lengthPhase=12000;
                set(inputDisplay(10),'string','No Shock');
                set(chronostim,'ForegroundColor','k');
                set(inputDisplay(11),'string','You can relax','ForegroundColor','k');
            end
            
            try
                temp=load('default_answer.mat','default_answer'); default_answer=temp.default_answer;
                default_answer{2}=num2str(lengthPhase);
            end
            if ~exist('default_answer','var') || (exist('default_answer','var') && length(default_answer)~=5)
                default_answer={'100',num2str(lengthPhase),'0.3','2','5','1'};
            end
            
            answer = inputdlg({'NumberMouse','Session duration (s)','Thresh immobility (mm)','Drop intervals (s)','Smooth Factor'},'INFO',1,default_answer);
            default_answer=answer; save default_answer default_answer
            
            nmouse=str2num(answer{1});
            lengthPhase=str2num(answer{2});
            nPhase=1;
            startphase=1;
            countDown=0;
            
            th_immob=str2num(answer{3});
            thtps_immob=str2num(answer{4});
            SmoothFact=str2num(answer{5});
            
            nameTASK='UMaze';
            
            set(inputDisplay(8),'string',['TASK = ',nameTASK]);
            
            if exist('Ratio_IMAonREAL','var') && ~isempty(Ratio_IMAonREAL)
                set(maskbutton(5),'enable','on','FontWeight','bold')
            end
            
            disp(' ');disp('-------------------- New Expe ---------------------');
            save([res,mark,'TempFreezeON.mat'],'nmouse','nPhase','namePhase','lengthPhase','nameTASK','ref','startphase');
            save([res,mark,'TempFreezeON.mat'],'-append','th_immob','thtps_immob','SmoothFact');
            set(maskbutton(1),'FontWeight','normal','string','1- INPUTS EXPE (OK)');
            
        end
        set(maskbutton(3),'enable','on')
    end

% -----------------------------------------------------------------
%% Interface of analysis
    function start_Expe(obj,event)
        t1=clock;
        t2=clock;
        enableTrack=1;
        templaod=load([res,mark,'TempFreezeON.mat']);
        tempstartphase=templaod.startphase;
        num_exp=0;
        num_phase=tempstartphase-1;
        StartChrono=0;
        prefix=['FEAR-Mouse-' num2str(templaod.nmouse) '-' TodayIs '-'];
        
        set(maskbutton(5),'enable','on','FontWeight','normal','string','3- START EXPE (OK)')
        
        for nn=tempstartphase:templaod.nPhase
            if enableTrack
                num_phase=num_phase+1;
                startphase=num_phase;
                
                n_AutoStop=templaod.lengthPhase;
                set(inputDisplay(6),'string',['Session ',num2str(nn),' :'])
                set(inputDisplay(7),'string','WAIT for start');
                
                % create folder to save tracking and analysis
                % ----------------------
                prefac=num2str(num_phase);
                if length(prefac)==1, prefac=cat(2,'0',prefac);end
                
                try
                    name_folder = [prefix prefac '-' templaod.namePhase{nn}];
                catch
                    name_folder = [prefix prefac '-' templaod.namePhase{nn}];
                end
                
                trynumber=1;
                name_foldertemp=[name_folder,'0'];
                while exist(name_foldertemp,'file')
                    name_foldertemp=[name_folder,num2str(trynumber,'%02g')];
                    trynumber=trynumber+1;
                end
                name_folder=name_foldertemp;
                
                mkdir(name_folder);
                disp(name_folder)
                
                set(inputDisplay(1),'string',name_folder);
                save([res,mark,'TempFreezeON.mat'],'-append','ref','Ratio_IMAonREAL','name_folder','n_AutoStop','startphase')
                pause(0.1)
                StartChrono=0;
                if size(a.Status,2)==6
                    try fopen(a); end
                end
                set(maskbutton(4),'enable','on','FontWeight','bold')
                PerformTracking;
            end
        end
        try
            set(maskbutton(5),'enable','off','FontWeight','normal','string','3- START EXPE')
            set(maskbutton(1),'enable','on','FontWeight','bold','string','1- INPUTS EXPE')
            set(maskbutton(4),'enable','on'),end
        if enableTrack
            set(inputDisplay(6),'string','END of the')
            set(inputDisplay(7),'string','experiment')
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
        % Tell the arduino we're starting
        fwrite(a,1);
        % Tell the experimenter we're starting
        set(inputDisplay(7),'string','RECORDING');
        % Initialize time
        tDeb = clock;
        LastStim=clock;
        % Go signal for tracking code
        StartChrono=1;
    end

% -----------------------------------------------------------------
%% track mouse
    function PerformTracking(obj,event)
        
        chrono=0;
        set(chronoshow,'string',num2str(0));
        num_exp=num_exp+1;
        disp('Begining tracking...')
        guireg_fig=Tracking_OnlineGuiReglage;
        UMaze_OnlineGuiReglage;
        
        % -------------------
        % display zone
        
        figure(Fig_UMaze),
        PlotForVideo=subplot(5,1,1:2);
        keyboard
        htrack = imagesc(ref);axis image; hold on
        line([10 20]*Ratio_IMAonREAL,[10 10],'Color','k','Linewidth',3)
        text(15*Ratio_IMAonREAL,15,'10 cm','Color','k')
        title('ACQUISITION ON')
        g=plot(0,0,'m+');
        caxis([0.1 0.9])
        % change for comrpession
        colormap(gray)
        
        figure(Fig_UMaze), subplot(5,1,3:4),
        htrack2 = imagesc(zeros(size((ref))));axis image; caxis([0 1])
        xlabel('tracking online','Color','w')
        
        im_diff=0;
        figure(Fig_UMaze), subplot(5,5,22:25)
        PlotFreez=plot(0,0,'-b');
        hold on, thimmobline=line([1,2000],[1 1]*th_immob,'Color','r');
        xlim([0,maxfrvis]);
        
        % -----------------------------------------------------------------
        % ---------------------- INITIATE TRACKING ------------------------
        n=1; % number of file that saves frames
        num_fr=1; % number of frames
        diffshow=zeros(size((ref)));
        
        % To save individual frames
        prefac0=char; for ii=1:4-length(num2str(num_exp)), prefac0=cat(2,prefac0,'0'); end
        Fname=['F' TodayIs '-' prefac0 num2str(num_exp)];
        mkdir([name_folder mark Fname]);
        disp(['   ',Fname]);
        
        % To save as a compressed file
        if frame_rate<9
            writerObj = VideoWriter([name_folder mark Fname '.avi']);
            open(writerObj);
        end
        DoorChangeMat=[]; PosMat=[];PosMatInit=[];im_diff=[];im_diffInit=[];
        Vtsd=[]; FreezeEpoch=[]; ZoneEpoch=[]; ZoneIndices=[]; FreezeTime=[]; Occup=[];
        Xtsd=[];Ytsd=[]; Imdifftsd=[];
        
        
        IM=TrackingFunctions.GetFrame(vid,IRLimits);
        
        OldIm=mask;
        OldZone=mask;
        
        while enableTrack
            
            % Activate the camera and send the image to the workspace
            pause(time_image-etime(t2,t1));
            IM=TrackingFunctions.GetFrame(vid,IRLimits);
            
            % ---------------------------------------------------------
            % update chrono
            t1 = clock;
            if StartChrono
                chrono=etime(t1,tDeb);
                set(chronoshow,'string',[num2str(floor(chrono)),'/',num2str(n_AutoStop)]);
            end
            
            % display video, mouse position and save in posmat
            if StartChrono
                
                % find the mouse and calculate quantity of movement
                [Pos,ImDiff,PixelsUsed,NewIm,FzZone]=Track_ImDiff(IM,mask,ref,BW_threshold,smaller_object_size,sm_fact,se,SrdZone,...
                    Ratio_IMAonREAL,OldIm,OldZone,IRLimits);
                
                if sum(isnan(Pos))==0
                    PosMat(num_fr,1)=chrono;
                    PosMat(num_fr,2)=Pos(1);
                    PosMat(num_fr,3)=Pos(2);
                    PosMat(num_fr,4)=0;
                    im_diff(num_fr,1)=chrono;
                    im_diff(num_fr,2)=ImDiff;
                    im_diff(num_fr,3)=PixelsUsed;
                else
                    PosMat(num_fr,:)=[chrono;NaN;NaN;NaN];
                    im_diff(num_fr,1:3)=[chrono;NaN;NaN];
                end
                
                num_fr=num_fr+1;
                % Update displays at 10Hz - faster would just be a waste of
                % time
                % For compression the actual picture is updated faster
                if frame_rate<9
                    set(htrack,'Cdata',IM);
                    set(g,'Xdata',0,'YData',0)
                    writeVideo(writerObj,getframe(PlotForVideo));
                end
                
                if  mod(num_fr-2,UpdateImage)==0
                    set(g,'Xdata',Pos(1).*Ratio_IMAonREAL,'YData',Pos(2).*Ratio_IMAonREAL)
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
                end
                OldIm=NewIm;
                OldZone=FzZone;
                
                
                %% UMaze protocols
                if strcmp('Cond',namePhase) &  sum(isnan(Pos))==0
                    where= Zone{1}(max(floor(Pos(2)),1),max(floor(Pos(1)),1));
                    if where==1
                        set(chronostim,'string',num2str(floor(etime(clock,LastStim))));
                        if etime(clock,LastStim)>1.5*delStim
                            LastStim=clock;
                            LastStim(end)=LastStim(end)-(delStim-delStimreturn); % was 5
                        end
                        if etime(clock,LastStim)>delStim +2*rand
                            LastStim=clock;
                            fwrite(a,9);
                            PosMat(end,4)=1;
                            disp('stim')
                        end
                    end
                end
                
                
                if (strcmp('BlockedWallShock',namePhase))
                    if etime(clock,tDeb)>SinglShockTime(ShTN)
                        fwrite(a,9);
                        PosMat(end,4)=1;
                        SinglShockTime(ShTN)
                        disp('shock')
                        ShTN=ShTN+1;
                        set(chronostim,'string',num2str(SinglShockTime(ShTN)));
                    end
                end
                
                if (strcmp('CondWallSafe',namePhase))
                    if etime(clock,tDeb)>280
                        set(inputDisplay(11),'string','Remove door at 300','ForegroundColor','r','FontSize',15);
                    end
                    if etime(clock,tDeb)>300  &   sum(isnan(Pos))==0
                        where= Zone{1}(max(floor(Pos(2)),1),max(floor(Pos(1)),1));
                        if where==1
                            set(chronostim,'string',num2str(floor(etime(clock,LastStim))));
                            if etime(clock,LastStim)>1.5*delStim %was 2
                                LastStim=clock;
                                LastStim(end)=LastStim(end)-(delStim-delStimreturn); % was 5
                            end
                            if etime(clock,LastStim)>delStim +2*rand
                                LastStim=clock;
                                fwrite(a,9);
                                PosMat(end,4)=1;
                                disp('stim')
                            end
                        end
                    end
                end
                
                if (strcmp('CondWallShock',namePhase))
                    if etime(clock,tDeb)>280
                        set(inputDisplay(11),'string','Remove door at 300','ForegroundColor','r','FontSize',15);
                    end
                    if etime(clock,tDeb)>CondWallShockTime(ShTN)
                        fwrite(a,9);
                        PosMat(end,4)=1;
                        CondWallShockTime(ShTN)
                        disp('shock')
                        ShTN=ShTN+1;
                        set(chronostim,'string',num2str(CondWallShockTime(ShTN)));
                    end
                    
                    if etime(clock,tDeb)>300  &  sum(isnan(Pos))==0
                        set(inputDisplay(10),'string','TimeInZone');
                        where= Zone{1}(max(floor(Pos(2)),1),max(floor(Pos(1)),1));
                        if where==1
                            set(chronostim,'string',num2str(floor(etime(clock,LastStim))));
                            if etime(clock,LastStim)>1.5*delStim %was 2
                                LastStim=clock;
                                LastStim(end)=LastStim(end)-(delStim-delStimreturn); % was 5
                            end
                            if etime(clock,LastStim)>delStim +2*rand
                                LastStim=clock;
                                fwrite(a,9);
                                PosMat(end,4)=1;
                                disp('stim')
                            end
                        end
                    end
                end
                
                
                %% Sound Protocols
                if strcmp('SoundCnd',namePhase)
                    if etime(clock,tDeb)>SoundTimesCond(ShTN)
                        if rem(ShTN,2)==0
                            fwrite(a,7);
                            PosMat(end,4)=2;
                            disp('CS-')
                            set(chronostim,'ForegroundColor','r');
                            set(inputDisplay(11),'string','Change Sound to CS+','ForegroundColor','r');
                        else
                            fwrite(a,5);
                            PosMat(end,4)=1;
                            disp('CS+ shock')
                            set(chronostim,'ForegroundColor','g');
                            set(inputDisplay(11),'string','Change Sound to CS-','ForegroundColor','g');
                        end
                        ShTN=ShTN+1;
                        set(chronostim,'string',num2str(SoundTimesCond(ShTN)));
                    end
                end
                
                if (strcmp('SoundHab',namePhase)|strcmp('SoundTest',namePhase))
                    if etime(clock,tDeb)>SoundTimesHabTest(ShTN)
                        fwrite(a,7);
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
                if (strcmp('Calibration',namePhase))
                    if etime(clock,tDeb)>CalibTimes(ShTN)
                        fwrite(a,9);
                        PosMat(end,4)=1;
                        CalibTimes(ShTN)
                        disp('shock')
                        ShTN=ShTN+1;
                        set(chronostim,'string',num2str(CalibTimes(ShTN)));
                    end
                end
                
                if (strcmp('CalibrationEyeshock',namePhase))
                    if etime(clock,tDeb)>CalibTimesEyeshock(ShTN)
                        fwrite(a,9);
                        PosMat(end,4)=1;
                        CalibTimesEyeshock(ShTN)
                        disp('shock')
                        ShTN=ShTN+1;
                        set(chronostim,'string',num2str(CalibTimesEyeshock(ShTN)));
                    end
                end
                b2=uint8(floor(double(IM)*32));
                datas.image =  (double(b2));
                datas.time = t1;
                
                
                % ---------------------------------------------------------
                % --------------------- SAVE FRAMES every NumFramesToSave  -----------------------
                if frame_rate>=9
                    prefac1=char; for ii=1:6-length(num2str(n)), prefac1=cat(2,prefac1,'0');end
                    save([ name_folder mark Fname mark 'frame' prefac1 sprintf('%0.5g',n)],'datas','-v6');
                    n = n+1;
                    clear datas
                end
            end
            
            t2 = clock;
            if StartChrono && etime(t2,tDeb)> n_AutoStop+0.5
                enableTrack=0;
            end
        end
        
        % if no stopemergency, ready to start next phase
        try
            if etime(t2,tDeb)> n_AutoStop+0.5, enableTrack=1;end
        end
        ShTN=1;% reset for next phase
        fwrite(a,3); % switch off intan
        
        % Correct for intan trigger time to realign with ephys
        im_diff(:,1)=im_diff(:,1)+1;
        PosMat(:,1)=PosMat(:,1)+1;
        
        % As a security save now incase something goes wrong
        save([name_folder,mark,'behavResources.mat'],'PosMat','im_diff','frame_rate','th_immob','ref',...
            'BW_threshold','mask','smaller_object_size','ref','Ratio_IMAonREAL','delStim','delStimreturn');
        
        %% %%%%%%%%%
        %CommonInterpPosMatImDiff
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
        im_diffint=im_diff;
        x=im_diffint(:,2);
        nanx = isnan(x);
        t    = 1:numel(x);
        x(nanx) = interp1(t(~nanx), x(~nanx), t(nanx));
        x(isnan(x))=nanmean(x);
        im_diffint(:,2)=x;
        
        PosMatInit=PosMat;
        PosMat=PosMatInt;
        im_diffInit=im_diff;
        im_diff=im_diffint;
        
        Vtsd=tsd(PosMatInt(1:end-1,1)*1e4,sqrt(diff(PosMatInt(:,2)).^2+diff(PosMatInt(:,1)).^2));
        Xtsd=tsd(PosMatInt(:,1)*1e4,(PosMatInt(:,3)));
        Ytsd=tsd(PosMatInt(:,1)*1e4,(PosMatInt(:,2)));
        Imdifftsd=tsd(im_diffint(:,1)*1e4,SmoothDec(im_diffint(:,2)',1));
        
        %% %%%%%%
        try FreezeEpoch=thresholdIntervals(Imdifftsd,th_immob,'Direction','Below');
            FreezeEpoch=mergeCloseIntervals(FreezeEpoch,0.3*1E4);
            FreezeEpoch=dropShortIntervals(FreezeEpoch,thtps_immob*1E4);
            Freeze=sum(End(FreezeEpoch)-Start(FreezeEpoch));
        catch
            Freeze=NaN;
            Freeze2=NaN;
        end
        save([name_folder,mark,'behavResources.mat'],'PosMat','PosMatInit','im_diff','im_diffInit','frame_rate','Vtsd','ref',...
            'BW_threshold','mask','smaller_object_size','Ratio_IMAonREAL','Xtsd',...
            'Ytsd','Imdifftsd','-append');
        
        % Do some extra code-specific calculations
        Xtemp=Data(Xtsd); Ytemp=Data(Ytsd); T1=Range(Ytsd);
        if not(isempty('Zone'))
            for t=1:length(Zone)
                try
                    ZoneIndices{t}=find(diag(Zone{t}(floor(Data(Xtsd)*Ratio_IMAonREAL),floor(Data(Ytsd)*Ratio_IMAonREAL))));
                    Xtemp2=Xtemp*0;
                    Xtemp2(ZoneIndices{t})=1;
                    ZoneEpoch{t}=thresholdIntervals(tsd(T1,Xtemp2),0.5,'Direction','Above');
                    Occup(t)=size(ZoneIndices{t},1)./size(Data(Xtsd),1);
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
        
        % save and copy file in save_folder
        msg_box=msgbox('Saving behavioral Information','save','modal');
        % Shut the video if compression was being done on the fly
        if frame_rate<9
            close(writerObj);
        end
        save([name_folder,mark,'behavResources.mat'],'FreezeEpoch','th_immob','thtps_immob',...
            'Zone','ZoneEpoch','ZoneIndices','Ratio_IMAonREAL','FreezeTime','Occup','DoorChangeMat',...
            'delStim','delStimreturn','-append');
        
        pause(0.5)
        try set(PlotFreez,'YData',0,'XData',0);end
        
        %% generate figure
        figbilan=figure;
        % raw data : movement over time
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
        
        saveas(figbilan,[name_folder,mark,'FigBilan.fig'])
        saveas(figbilan,[name_folder,mark,'FigBilan.png'])
        close(figbilan)
        %%
        
        % display
        try
            close(guireg_fig)
            set(Fig_UMaze,'Color',color_on);
            for bi=[1,3,6:9], set(inputDisplay(bi),'BackgroundColor',color_on);end
            for bit=1:2
                set(maskbutton(bit),'enable','on','FontWeight','bold')
            end
            delete(msg_box)
            set(maskbutton(3),'enable','off','FontWeight','normal')
            set(maskbutton(7),'enable','off','FontWeight','normal')
            set(maskbutton(4),'enable','on','FontWeight','bold')
        end
        
        
    end


%% Define behavioural zones
    function DefineZones(obj,event)
        global Zones
        figtemp=figure();
        imagesc(ref),colormap gray,hold on
        if strcmp(namePhase,'EPM')
            disp('OpenArms');[x1,y1,Open,x2,y2]=roipoly; plot(x2,y2)
            disp('ClosedArms');[x1,y1,Closed,x2,y2]=roipoly(); plot(x2,y2)
            Centre=zeros(size(ref));Centre(Open==1 & Closed==1)=1;
            Open(Centre==1)=0;Closed(Centre==1)=0;
            Zone{1}=uint8(Open);Zone{2}=uint8(Closed);Zone{3}=uint8(Centre);
            ZoneLabels={'OpenArms','ClosedArms','Centre'};
            set(maskbutton(3),'string','3 - GetBehavZones (OK)')
        elseif strcmp(namePhase,'SoundCnd') | strcmp(namePhase,'SoundHab') | strcmp(namePhase,'SoundTest') | strcmp(namePhase,'Calibration')  | strcmp(namePhase,'SleepSession') | strcmp(namePhase,'CalibrationEyeshock')
            stats = regionprops(mask, 'Area');
            tempmask=mask;
            AimArea=stats.Area/2;
            ActArea=stats.Area;
            while AimArea<ActArea
                tempmask=imerode(tempmask,strel('disk',1));
                stats = regionprops(tempmask, 'Area');
                ActArea=stats.Area;
            end
            Zone{1}=uint8(tempmask); % Inside area
            Zone{2}=uint8(mask-tempmask);% Outside area
            ZoneLabels={'Inside','Outside'};
            set(maskbutton(3),'string','3 - GetBehavZones (OK)')
        else
            title('Shock');[x1,y1,Shock,x2,y2]=roipoly; Zone{1}=uint8(Shock);plot(x2,y2,'linewidth',2)
            title('NoShock');[x1,y1,NoShock,x2,y2]=roipoly(); Zone{2}=uint8(NoShock);plot(x2,y2,'linewidth',2)
            title('Centre');[x1,y1,Centre,x2,y2]=roipoly(); Zone{3}=uint8(Centre);plot(x2,y2,'linewidth',2)
            title('CentreShock');[x1,y1,CentreShock,x2,y2]=roipoly(); Zone{4}=uint8(CentreShock);plot(x2,y2,'linewidth',2)
            title('CentreNoShock');[x1,y1,CentreNoShock,x2,y2]=roipoly();    Zone{5}=uint8(CentreNoShock);plot(x2,y2,'linewidth',2)
            stats = regionprops(mask, 'Area');
            tempmask=mask;
            AimArea=stats.Area/2;
            ActArea=stats.Area;
            while AimArea<ActArea
                tempmask=imerode(tempmask,strel('disk',1));
                stats = regionprops(tempmask, 'Area');
                ActArea=stats.Area;
            end
            Zone{6}=uint8(tempmask); % Inside area
            Zone{7}=uint8(mask-tempmask);% Outside area
            ZoneLabels={'Shock','NoShock','Centre','CentreShock','CentreNoShock','Inside','Outside'};
            set(maskbutton(3),'string','3 - GetBehavZones (OK)')
        end
        close(figtemp)
    end

% -----------------------------------------------------------------
%% stop tracking
    function stop_Phase(obj,event)
        figure(Fig_UMaze), subplot(5,1,1:2), title('ACQUISITION STOPPED')
        enableTrack=0;
        set(maskbutton(4),'enable','on','FontWeight','normal')
        set(maskbutton(7),'enable','off','FontWeight','normal')
        set(maskbutton(3),'enable','off','FontWeight','normal')
        try fwrite(a,3);disp('Intan OFF');end
        close(writerObj);
        
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
        set(slider_freeze,'Value',th_immob/10);
        
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
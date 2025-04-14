function [numF,filename]=TrackTwoMice_IRComp_ObjectOrientated(~,~)

%% This is the simplest possible tracking code - you can use it as a framework to build more personal codes
%% It just tracks a mouse and displays the video in real time
%% The basic set of variables are recorded at the end

% Get global variables that are common to all codes
% global TrObjLocal % the video object
global TrObj
global TrObjLocal
TrObjLocal = TrObj;
global ArdImetronic
global NumberOfMice; NumberOfMice = length(TrObj);


% Tracking parameters - you need to initalize these to be able to call Tracking_OnlineGuiReglage
global BW_threshold;
global smaller_object_size;
global sm_fact; 
global strsz se;
global SrdZone;
global guireg_fig;guireg_fig=cell(1,NumberOfMice); % the figure that allows you to set these parameters
% works for max 4 mice, if you want more, fix it
global guireg_figpos;guireg_figpos = {[0.05 0.55 0.4 0.4],[0.05 0.05 0.4 0.4],[0.55 0.55 0.4 0.4],[0.55 0.05 0.4 0.4]};
global dist_thresh; dist_thresh =2;

for nm = 1:NumberOfMice
    BW_threshold{nm}=0.5;
    smaller_object_size{nm}=30;
    strsz{nm}=4; se{nm}= strel('disk',strsz{nm});
    SrdZone{nm}=20;
    sm_fact{nm}=0;
end

%% Variables that are specific to this code
% General thresholds and display
global time_image;time_image = 1/TrObjLocal{1}.frame_rate; % coutn time between frames
global UpdateImage; UpdateImage=ceil(TrObjLocal{1}.frame_rate/5); % update every n frames the picture shown on screen to show at 10Hz
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
global MiceColors; MiceColors = lines(NumberOfMice);

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
global th_immob;
global thtps_immob; thtps_immob=2;
global maxyaxis ymax; maxyaxis=500;ymax=50;
global maxfrvis;maxfrvis=800;
global maxth_immob; maxth_immob=200 ;
for nm = 1:NumberOfMice
    th_immob{nm}=20;
end

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

%% Task parameters
global nametypes; nametypes={'Habituation','Conditionning'};

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
    'string','2- START EXPE','callback', @start_Expe);
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
        
        strfcts=strjoin(nametypes,'|');
        u2=uicontrol(Fig_SleepSession,'Style', 'popup','String', strfcts,'units','normalized',...
            'Position', [0.01 0.84 0.2 0.05],'Callback', @setprotoc);
        
        function setprotoc(obj,event)
            fctname=get(obj,'value');
            ExpeInfo.namePhase=nametypes(fctname);ExpeInfo.namePhase=ExpeInfo.namePhase{1};
            savProtoc
        end
        
        function savProtoc(obj,event)
            
            for nm = 1:NumberOfMice
                default_answer{nm}='007';
                BoxName{nm} = ['NumberMouse' num2str(nm)];
            end
            default_answer{NumberOfMice+1}=num2str(28800);
            
            answer = inputdlg([BoxName,{'Session duration (s)'}],'INFO',1,default_answer);
            default_answer=answer; save default_answer default_answer
            for nm = 1:NumberOfMice
                ExpeInfo.nmouse{nm}=str2double(answer{nm});
            end
            ExpeInfo.lengthPhase=str2double(answer{NumberOfMice+1});
            ExpeInfo.nPhase=0;
            
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
        
            
            nameTASK='ImetronicFEAR';
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
        ListOfMice = [];
        for nm = 1:NumberOfMice
            ListOfMice = [ListOfMice,[num2str(ExpeInfo.nmouse{nm}) '-']];
        end
        ExpeInfo.name_folder=['SLEEP-Mouse-' ListOfMice ExpeInfo.TodayIs '-' ExpeInfo.namePhase];
        
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
        % wait for imetronic to go
        while ArdImetronic.BytesAvailable>0
            fread(ArdImetronic,ArdImetronic.BytesAvailable);
        end
        
        disp('ready to go')
        while ArdImetronic.BytesAvailable==0
        end
            
        % Tell the arduino we're starting
        fwrite(a,arduinoDictionary.On);
        % Tell the experimenter we're starting
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
        for nm = 1:NumberOfMice
            guireg_fig{nm}=OnlineGuiReglage_MultiMouse(nm,MiceColors(nm,:));
            set(guireg_fig{nm},'Position',guireg_figpos{nm})
        end
        
        UMaze_OnlineGuiReglage;
        
        % -------------------
        % display zone
        
        figure(Fig_SleepSession),
        for nm = 1:NumberOfMice
            PlotForVideo{nm}=subplot(5,2*NumberOfMice+1,[(2:3)+2*(nm-1),(2*NumberOfMice+3:2*NumberOfMice+4)+2*(nm-1)]);
            htrack{nm} = imagesc(TrObjLocal{nm}.ref);axis image; hold on
            line([10 20]*TrObjLocal{nm}.Ratio_IMAonREAL,[10 10],'Color','k','Linewidth',3)
            text(15*TrObjLocal{nm}.Ratio_IMAonREAL,15,'10 cm','Color','k')
            set(gca,'XTick',[],'YTick',[],'Color',MiceColors(nm,:),'Linewidth',2)
            title(num2str(ExpeInfo.nmouse{nm}),'Color','w')
        end
        
        title('ACQUISITION ON')
        caxis([0.1 0.9])
        % change for comrpession
        colormap(gray)
        
        figure(Fig_SleepSession),
        for nm = 1:NumberOfMice
            subplot(5,2*NumberOfMice+1,[(2:3)+2*(nm-1),(2*NumberOfMice+3:2*NumberOfMice+4)+2*(nm-1)]+2*(2*NumberOfMice+1));
            htrack2{nm} = imagesc(zeros(size((TrObjLocal{nm}.ref))));axis image; caxis([0 1]);hold on
            xlabel('tracking online','Color','w')
            g{nm}=plot(0,0,'m+');
            set(gca,'XTick',[],'YTick',[],'Color',MiceColors(nm,:),'Linewidth',2)
        end
        
        im_diff{nm}=0;
        figure(Fig_SleepSession), subplot(5,5,22:25)
        for nm = 1:NumberOfMice
            PlotFreez{nm}=plot(0,0,'-','Color',MiceColors(nm,:));
            hold on, thimmobline{nm}=line([1,2000],[1 1]*th_immob{nm},'Color',MiceColors(nm,:),'linewidth',2);
        end
        xlim([0,maxfrvis]);
        
        % -----------------------------------------------------------------
        % ---------------------- INITIATE TRACKING ------------------------
        n=1; % number of file that saves frames
        num_fr=1; % number of frames
        for nm = 1:NumberOfMice
            diffshow{nm}=zeros(size((TrObjLocal{nm}.ref)));
        end
        
        % To save individual frames

        for nm = 1:NumberOfMice
            
            prefac0=char; for ii=1:4, prefac0=cat(2,prefac0,'0'); end
            ExpeInfo.Fname{nm}=['F' ExpeInfo.TodayIs '-' num2str(ExpeInfo.nmouse{nm}) '-' prefac0];
            disp(['   ',ExpeInfo.Fname{nm}]);
            mkdir([ExpeInfo.name_folder filesep ExpeInfo.Fname{nm}]);
            
            % To save as a compressed file
            writerObj{nm} = VideoWriter([ExpeInfo.name_folder filesep ExpeInfo.Fname{nm} '.avi']);
            open(writerObj{nm});
            
            
            PosMat{nm}=[];im_diff{nm}=[]; GotFrame{nm} = []; MouseTemp{nm} = [];
            
            IM{nm}=TrObjLocal{nm}.GetAFrame;
            
            OldIm{nm}=TrObjLocal{nm}.mask;
            OldZone{nm}=TrObjLocal{nm}.mask;
        end
        % The code waits here until enableTrack is set to 1 by StartSession
        
        while enableTrack
            
            % Activate the camera and send the image to the workspace
            pause(time_image-etime(KeepTime.t2,KeepTime.t1));
            for nm = 1:NumberOfMice
                IM{nm}=TrObjLocal{nm}.GetAFrame;
            end
            
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
                for nm = 1:NumberOfMice
                    [Pos,ImDiff,PixelsUsed,NewIm{nm},FzZone{nm}]=Track_ImDiff(IM{nm},TrObjLocal{nm}.mask,TrObjLocal{nm}.ref,BW_threshold{nm},smaller_object_size{nm},sm_fact{nm},se{nm},SrdZone{nm},...
                        TrObjLocal{nm}.Ratio_IMAonREAL,OldIm{nm},OldZone{nm},TrObjLocal{nm}.camera_type);
                    
                    if sum(isnan(Pos))==0
                        PosMat{nm}(num_fr,1)=KeepTime.chrono; % Time
                        PosMat{nm}(num_fr,2)=Pos(1); % XPos
                        PosMat{nm}(num_fr,3)=Pos(2); % YPose
                        PosMat{nm}(num_fr,4)=0; % You can store events here
                        im_diff{nm}(num_fr,1)=KeepTime.chrono; % Time
                        im_diff{nm}(num_fr,2)=ImDiff; % Number fo pixels changed
                        im_diff{nm}(num_fr,3)=PixelsUsed; % Size of zone used to calculate ImDiff
                        switch TrObjLocal{nm}.camera_type
                            case 'IRCamera'
                                MouseTemp{nm}(num_fr,1)=KeepTime.chrono;
                                MouseTemp{nm}(num_fr,2)=max(max(IM.*FzZone));
                            case 'Webcam'
                                MouseTemp{nm}(num_fr,1:2)=[KeepTime.chrono;NaN];
                        end
                    else
                        PosMat{nm}(num_fr,:)=[KeepTime.chrono;NaN;NaN;NaN];
                        im_diff{nm}(num_fr,1:3)=[KeepTime.chrono;NaN;NaN];
                        MouseTemp{nm}(num_fr,1:2)=[KeepTime.chrono;NaN];
                    end
                end
                
                num_fr=num_fr+1;
                
                % -------------------------------------------------------------------------------
                % -------------------------------- Find the mouse   --------------------------------
                
                % Update displays at 10Hz - faster would just be a waste of
                % time
                % For compression the actual picture is updated faster so
                % as to save it
                for nm = 1:NumberOfMice
                    
                    if strcmp(TrObjLocal{nm}.camera_type,'Webcam')
                        if strcmp(TrObjLocal{nm}.vid.VideoFormat,'RGB24_320x240')
                            IM{nm} = rgb2gray(IM{nm});
                            frame.cdata = cat(3,IM{nm},IM{nm},IM{nm});
                            frame.colormap = [];
                            try,writeVideo(writerObj{nm},frame);GotFrame{nm}(num_fr) = 1;catch, GotFrame{nm}(num_fr) = 0;disp('missed frame video'),end
                        else
                            frame.cdata = cat(3,IM{nm},IM{nm},IM{nm});
                            frame.colormap = [];
                            try,writeVideo(writerObj{nm},frame);GotFrame{nm}(num_fr) = 1;catch, GotFrame{nm}(num_fr) = 0; disp('missed frame video'),end
                        end
                    else
                        frame.cdata = cat(3,IM{nm},IM{nm},IM{nm});
                        frame.colormap = [];
                        try,writeVideo(writerObj{nm},frame);GotFrame{nm}(num_fr) = 1;catch, GotFrame{nm}(num_fr) = 0; disp('missed frame video'),end
                    end
                    
                    if  mod(num_fr-2,UpdateImage)==0
                        set(g{nm},'Xdata',PosMat{nm}(end,2).*TrObjLocal{nm}.Ratio_IMAonREAL,'YData',PosMat{nm}(end,3).*TrObjLocal{nm}.Ratio_IMAonREAL)
                        diffshow{nm}=double(NewIm{nm});
                        diffshow{nm}(FzZone{nm}==1)=0.4;
                        diffshow{nm}(OldZone{nm}==1)=0.4;
                        diffshow{nm}(NewIm{nm}==1)=0.8;
                        set(htrack2{nm},'Cdata',diffshow{nm});
                        set(htrack{nm},'Cdata',IM{nm});
                        try
                            dattemp=im_diff{nm};
                            dattemp(isnan(im_diff{nm}(:,2)),2)=0;
                            set(PlotFreez{nm},'YData',im_diff{nm}(max(1,num_fr-maxfrvis):end,2),'XData',[1:length(dattemp(max(1,num_fr-maxfrvis):end,2))]')
                        end
                        figure(Fig_SleepSession), subplot(5,5,22:25)
                        set(gca,'Ylim',[0 max(ymax,1e-5)]);
                    end
                    OldIm{nm}=NewIm{nm};
                    OldZone{nm}=FzZone{nm};
                end
                
                % -------------------------------------------------------------------------------
                % -------------------------------- SAVE FRAMES   --------------------------------
                if TrObjLocal{nm}.SaveToMatFile==1
                    for nm = 1:NumberOfMice
                        datas.image =IM{nm};
                        datas.time = KeepTime.t1;
                        prefac1=char; for ii=1:6-length(num2str(n)), prefac1=cat(2,prefac1,'0');end
                        save([ ExpeInfo.name_folder filesep ExpeInfo.Fname{nm} filesep 'frame' prefac1 sprintf('%0.5g',n)],'datas','-v6');
                        clear data
                    end
                    n = n+1;
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
        im_diff_Final = im_diff;
        PosMat_Final = PosMat;
        MouseTemp_final = MouseTemp;
        GotFrame_final = GotFrame;

        clear im_diff MouseTemp PosMat
        for nm = 1:NumberOfMice
            im_diff=im_diff_Final{nm};
            PosMat=PosMat_Final{nm};
            MouseTemp = MouseTemp_final{nm};

            im_diff(:,1)=im_diff(:,1)+1;
            PosMat(:,1)=PosMat(:,1)+1;
            MouseTemp(:,1) = MouseTemp(:,1)+1;
            
            %% This is the strict minimum all codes need to save %%
            [PosMat,PosMatInit,im_diff,im_diffInit,Vtsd,Xtsd,Ytsd,Imdifftsd]=CommonInterpPosMatImDiff(im_diff,KeepTime.chrono,PosMat, dist_thresh);
            ref=TrObjLocal{nm}.ref;mask=TrObjLocal{nm}.mask;Ratio_IMAonREAL=TrObjLocal{nm}.Ratio_IMAonREAL;
            frame_limits=TrObjLocal{nm}.frame_limits;
            save([ExpeInfo.name_folder,filesep,'TrObject-' num2str(ExpeInfo.nmouse{nm}) '.mat'],'TrObjLocal');
            GotFrame = GotFrame_final{nm};
            save([ExpeInfo.name_folder,filesep,'behavResources-' num2str(ExpeInfo.nmouse{nm}) '.mat'],'PosMat', 'GotFrame', 'PosMatInit','im_diff','im_diffInit','Vtsd','Xtsd','Ytsd','Imdifftsd',...
                'ref','mask','Ratio_IMAonREAL','BW_threshold','frame_limits','smaller_object_size','sm_fact','strsz','SrdZone');
            clear ref mask Ratio_IMAonREAL
            
            
            % Do some extra code-specific calculations
            try FreezeEpoch=thresholdIntervals(Imdifftsd,th_immob{nm},'Direction','Below');
                FreezeEpoch=mergeCloseIntervals(FreezeEpoch,0.3*1E4);
                FreezeEpoch=dropShortIntervals(FreezeEpoch,thtps_immob*1E4);
                Freeze=sum(End(FreezeEpoch)-Start(FreezeEpoch));
            catch
                Freeze=NaN;
                Freeze2=NaN;
            end
            
            save([ExpeInfo.name_folder,filesep,'behavResources-' num2str(ExpeInfo.nmouse{nm}) '.mat'],'FreezeEpoch','th_immob','thtps_immob','MouseTemp','-append');
            
            % save and copy file in save_folder
            msg_box=msgbox('Saving behavioral Information','save','modal');
            % Shut the video if compression was being done on the fly
            close(writerObj{nm});
            
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
            
            saveas(figbilan,[ExpeInfo.name_folder,filesep,'FigBilan-' num2str(ExpeInfo.nmouse{nm}) '.fig'])
            saveas(figbilan,[ExpeInfo.name_folder,filesep,'FigBilan-' num2str(ExpeInfo.nmouse{nm}) '.png'])
            close(figbilan)
        end
        
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
        global CurrentMouse; CurrentMouse =1;
        
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
        
        MouseList = {};
        for nm = 1:NumberOfMice
        MouseList{nm} = ExpeInfo.nmouse{nm};
        end
        
        ChooseMouse=uicontrol(GuiForSleep,'style','listbox', ...
            'units','normalized',...
            'position',[0.62 0.85 0.2 0.05],...
            'string',MouseList,...
            'callback',@SetMouse);

        % create sliders
        slider_freeze = uicontrol(GuiForSleep,'style','slider',...
            'units','normalized',...
            'position',[0.25 0.1 0.15 0.7],...
            'callback', {@freeze_thresh,CurrentMouse});
        set(slider_freeze,'Value',th_immob{CurrentMouse}/maxth_immob);
        
        slider_yaxis = uicontrol(GuiForSleep,'style','slider',...
            'units','normalized',...
            'position',[0.65 0.1 0.15 0.7],...
            'callback', @fixyaxis);
        set(slider_yaxis,'Value',ymax/maxyaxis);
        
        % create labels with actual values
        textUM3=uicontrol(GuiForSleep,'style','text', ...
            'units','normalized',...
            'position',[0.22 0.05 0.2 0.03],...
            'string',num2str(th_immob{CurrentMouse}));
        
        textUM4=uicontrol(GuiForSleep,'style','text', ...
            'units','normalized',...
            'position',[0.62 0.05 0.2 0.03],...
            'string',num2str(ymax));
        
        %get freezing threshold
        function freeze_thresh(obj,event,CurrentMouse)
            th_immob{CurrentMouse} = (get(slider_freeze,'value')*maxth_immob);
            set(textUM3,'string',num2str(th_immob{CurrentMouse}))
            set(thimmobline{CurrentMouse},'Ydata',[1,1]*th_immob{CurrentMouse})
        end
        
        function SetMouse(obj,event)
            CurrentMouse = ChooseMouse.Value;
        end

        
        %get ylims
        function fixyaxis(~,~)
            ymax = (get(slider_yaxis,'value')*maxyaxis);
            set(textUM4,'string',num2str(ymax));
        end
    end
end
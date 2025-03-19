function [numF,filename]=TrackingSleepSessionMultiMouse_IRComp_ObjectOrientated(~,~)

%% This is code allows to track 4 mice together

% Get global variables that are common to all codes 
global TrObj % the video object

% Tracking parameters - you need to initalize these to be able to call Tracking_OnlineGuiReglage
global BW_threshold;BW_threshold=cell(1,4);
global smaller_object_size ;smaller_object_size=cell(1,4);
global sm_fact;sm_fact=cell(1,4);
global strsz ;strsz=cell(1,4);
global se ;se=cell(1,4);
global SrdZone;SrdZone=cell(1,4);

for mm=1:4
    BW_threshold{mm}=0.5;
    smaller_object_size{mm}=30;
    sm_fact{mm}=0;
    strsz{mm}=2; se{mm}=strel('disk',strsz{mm});
    SrdZone{mm}=20;
end

global guireg_fig;guireg_fig=cell(1,4); % the figure that allows you to set these parameters


%% Variables that are specific to this code
% General thresholds and display
global time_image;time_image = 1/TrObj.frame_rate; % coutn time between frames
global UpdateImage; UpdateImage=ceil(TrObj.frame_rate/5); % update every n frames the picture shown on screen to show at 10Hz
global writerObj  % allows us to save as .avi
global enableTrack % Controls whether the tracking is on or not
global IndivMouseColors;IndivMouseColors = {'r','c','m','b'};
global XCoord;XCoord = [0.17,0.17,0.57,0.57];
global YCoord;YCoord = [0.5 0.28 0.5 0.28];
global SubPlotCoord; SubPlotCoord = {13:15,16:18;19:21,22:24};
global guireg_figpos;guireg_figpos = {[0.05 0.55 0.4 0.4],[0.05 0.05 0.4 0.4],[0.55 0.55 0.4 0.4],[0.55 0.05 0.4 0.4]};

% Variables for plotting
global thimmobline % line that shows current freezing threshold
global PlotFreez % the name of the Plot that shows im_diff
global StartChrono, StartChrono=0; % Variable set to one when the tracking begins
% the handle of the chronometer object
global PlotForVideo % the plot that will be saved to .avi if needed
global GuiForSleep % slides with specific values for this protocol 
global color_on; color_on=[0 0 0];

global ExpeInfo; ExpeInfo = struct;
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
% - tDeb for tracking length of session 
% - chrono to dsplay passing of time

% Freezing/sleep detection
global th_immob;th_immob=cell(1,4);
global thtps_immob;thtps_immob=cell(1,4);
global maxyaxis ;maxyaxis=cell(1,4);
global ymax ;ymax=cell(1,4);
global maxth_immob;maxth_immob=cell(1,4);

global maxfrvis;maxfrvis=800;

for mm=1:4
    th_immob{mm}=20;
    thtps_immob{mm}=2;
    maxyaxis{mm}=500;
    ymax{mm}=50;
    maxth_immob{mm}=200;
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
arduinoDictionary.On = 1; % Tells Intan its time to go
arduinoDictionary.Off = 3; % switches Intan off
arduinoDictionary.ThousandFrames = 2; % Sync with intan every 1000 frames

%% Task parameters
global nametypes; nametypes={'BaselineSleep_0'};
global MinSleepTime  StimOnTime StimOffTime
MinSleepTime=10;StimOnTime=1000;StimOffTime=10;
global MouseMask % This allows to readjust the mask to contain one mouse at a time for separate tracking
global MouseMaskContour
%% graphical interface n???1 with all the pushbuttons

Fig_SleepSession=figure('units','normalized','position',[0.1 0.1 0.4 0.85],...
    'numbertitle','off','name','SleepStimProtocol','menubar','none','tag','figure Odor');
set(Fig_SleepSession,'Color',color_on);

InterfaceButton.Inputs= uicontrol(Fig_SleepSession,'style','pushbutton',...
    'units','normalized','position',[0.01 0.89 0.15 0.05],...
    'string','1- INPUTS EXPE','callback', @giv_inputs);
set(InterfaceButton.Inputs,'enable','on','FontWeight','bold')

InterfaceButton.StartExpe= uicontrol(Fig_SleepSession,'style','pushbutton',...
    'units','normalized','position',[0.01 0.65 0.15 0.05],...
    'string','3- START EXPE','callback', @start_Expe);
set(InterfaceButton.StartExpe,'enable','off')

InterfaceButton.StartSession= uicontrol(Fig_SleepSession,'style','pushbutton',...
    'units','normalized','position',[0.01 0.48 0.15 0.05],'string','4- START session');
set(InterfaceButton.StartSession,'enable','off','callback', @StartSession)

InterfaceButton.StopSession= uicontrol(Fig_SleepSession,'style','pushbutton',...
    'units','normalized','position',[0.025 0.36 0.15 0.03],...
    'string','Stop Emergency','callback', @stop_Phase);
set(InterfaceButton.StopSession,'enable','off')

InterfaceButton.Quit= uicontrol(Fig_SleepSession,'style','pushbutton',...
    'units','normalized','position',[0.01 0.03 0.15 0.05],...
    'string','CLOSE EXPE','callback', @quit);
set(InterfaceButton.Quit,'enable','on','FontWeight','bold')

for mm = 1:4
inputDisplay.FileName{mm}=uicontrol(Fig_SleepSession,'style','text','units','normalized','position',[XCoord(mm) YCoord(mm) 0.3 0.02],'string','Filename = TO DEFINE','FontSize',10,'BackgroundColor',color_on,'ForegroundColor',IndivMouseColors{mm},'FontWeight','bold');
end

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

        default_answer={'10'};
        answer = inputdlg({'Session duration (s)'},'INFO',1,default_answer);
        ExpeInfo.lengthPhase=str2double(answer{1});
                    
        nametypes{1}=[nametypes{1}(1:end-2),'_',num2str(1)];
               
        
       
        savProtoc
        
        
        function savProtoc
            
            default_answer{1}='007';
            
            for mm = 1:4
                answer = inputdlg({'NumberMouse'},'INFO',1,default_answer);
                nametypes{1}=[nametypes{1}(1:end-2),'_',num2str(mm)];
                Nm=nametypes(1);Nm=Nm{1};
                ExpeInfo.namePhase{str2num(Nm(end))}=Nm(1:end-2);
                ExpeInfo.nmouse{mm}=str2double(answer{1});
                ExpeInfo.nPhase=0;
                
                % get location of mouse's cage
                TempFigMouseCage=figure;
                [x1,y1,BW,x2,y2]=roipoly(mat2gray(TrObj.ref));
                maskint=uint8(BW);
                
                MouseMask{mm}=maskint;
                MouseMaskContour{mm} =[x2,y2];
                close(TempFigMouseCage)
            end
            disp(' ');disp('-------------------- New Expe ---------------------');
            set(InterfaceButton.Inputs,'FontWeight','normal','string','1- INPUTS EXPE (OK)');
            set(InterfaceButton.StartExpe,'enable','on')
            set(InterfaceButton.Inputs,'enable','on')
            
            
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
        ExpeInfo.name_folder=['SLEEP-Mouse-' num2str(ExpeInfo.nmouse{1}) '&' num2str(ExpeInfo.nmouse{2}) '&' num2str(ExpeInfo.nmouse{3}) '&' num2str(ExpeInfo.nmouse{4}) '-' ExpeInfo.TodayIs];
        
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
            
            for mm = 1:4
            set(inputDisplay.FileName{mm},'string',['Mouse' num2str(ExpeInfo.nmouse{mm}) '-' ExpeInfo.namePhase{mm}]);
            end
            
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
        % Go signal for tracking code
        StartChrono=1;
    end

% -----------------------------------------------------------------
%% track mouse
    function PerformTracking(obj,event)
        KeepTime.chrono=0;
        set(chronoshow,'string',num2str(0));
        disp('Begining tracking...')
        for mm = 1:4
        guireg_fig{mm}=OnlineGuiReglage_MultiMouse(mm,IndivMouseColors{mm});
        set(guireg_fig{mm},'Position',guireg_figpos{mm})
        end
        

        % display live video feed
        figure(Fig_SleepSession),
        PlotForVideo=subplot(2,4,2:4);
        htrack = imagesc(TrObj.ref);axis image; hold on
        line([10 20]*TrObj.Ratio_IMAonREAL,[10 10],'Color','k','Linewidth',3)
        text(15*TrObj.Ratio_IMAonREAL,15,'10 cm','Color','k')
        title('ACQUISITION ON','Color','w')
        caxis([0.1 0.9])
        for mm = 1 :4
            g{mm}=plot(0,0,'+','color',IndivMouseColors{mm});
            plot(MouseMaskContour{mm}(:,1),MouseMaskContour{mm}(:,2),'color',IndivMouseColors{mm},'linewidth',2);
        end
        % change for comrpession
        colormap(gray)
        
        % display tracking of each animal
        figure(Fig_SleepSession), 
        for mm = 1 :4
        subplot(4,6,SubPlotCoord{mm}),
        htrack2{mm} = imagesc(zeros(size((TrObj.ref))));axis image; caxis([0 1]);hold on
        xlim([min(MouseMaskContour{mm}(:,1)) max(MouseMaskContour{mm}(:,1))])
        ylim([min(MouseMaskContour{mm}(:,2)) max(MouseMaskContour{mm}(:,2))])
        end
        
        % INITIATE TRACKING
        n=1; % number of file that saves frames
        num_fr=1; % number of frames
        diffshow = zeros(size((TrObj.ref)));

        
        % To save individual frames
        prefac0=char; for ii=1:4, prefac0=cat(2,prefac0,'0'); end
        ExpeInfo.Fname=['F' ExpeInfo.TodayIs '-' prefac0];
        disp(['   ',ExpeInfo.Fname]);
        mkdir([ExpeInfo.name_folder filesep ExpeInfo.Fname]);

        % To save as a compressed file
        writerObj = VideoWriter([ExpeInfo.name_folder filesep ExpeInfo.Fname '.avi']);
        open(writerObj);
        
        for mm = 1 :4
        PosMatTemp{mm}=[];im_diffTemp{mm}=[]; 
        MouseTempTemp{mm}=[];
        OldIm{mm}=TrObj.mask;
        OldZone{mm}=TrObj.mask;
        end
        GotFrame = [];TempZone=[];
        IM=TrObj.GetAFrame;
        
        % The code waits here until enableTrack is set to 1 by StartSession
        
        while enableTrack
            
            % Activate the camera and send the image to the workspace
            pause(time_image-etime(KeepTime.t2,KeepTime.t1));
            IM=TrObj.GetAFrame;
            
            % ---------------------------------------------------------
            % update KeepTime.chrono
            KeepTime.t1 = clock;
            if StartChrono
                KeepTime.chrono=etime(KeepTime.t1,KeepTime.tDeb);
                set(chronoshow,'string',[num2str(floor(KeepTime.chrono)),'/',num2str(ExpeInfo.lengthPhase)]);
            end
            
            % display video, mouse position and save in posmat
            if StartChrono
                
                for MouseNum=1:4
                % Find the mouse
                [Pos,ImDiff,PixelsUsed,NewIm,FzZone]=Track_ImDiff(IM,TrObj.mask.*MouseMask{MouseNum},TrObj.ref,BW_threshold{MouseNum},smaller_object_size{MouseNum},sm_fact{MouseNum},...
                    se{MouseNum},SrdZone{MouseNum},TrObj.Ratio_IMAonREAL,OldIm{MouseNum},OldZone{MouseNum},TrObj.camera_type);
                
                if sum(isnan(Pos))==0
                    PosMatTemp{MouseNum}(num_fr,1)=KeepTime.chrono; % Time
                    PosMatTemp{MouseNum}(num_fr,2)=Pos(1); % XPos
                    PosMatTemp{MouseNum}(num_fr,3)=Pos(2); % YPose
                    PosMatTemp{MouseNum}(num_fr,4)=0; % You can store events here
                    im_diffTemp{MouseNum}(num_fr,1)=KeepTime.chrono; % Time
                    im_diffTemp{MouseNum}(num_fr,2)=ImDiff; % Number fo pixels changed
                    im_diffTemp{MouseNum}(num_fr,3)=PixelsUsed; % Size of zone used to calculate ImDiff
                    switch TrObj.camera_type
                        case 'IRCamera'
                            MouseTempTemp{MouseNum}(num_fr,1)=KeepTime.chrono; % Time
                            MouseTempTemp{MouseNum}(num_fr,2)=mean(mean(IM.*MouseMask{MouseNum}));
                        case 'Webcam'
                            MouseTempTemp{MouseNum}(num_fr,1:2)=[KeepTime.chrono;NaN];
                    end
                else
                    PosMatTemp{MouseNum}(num_fr,1:4)=[KeepTime.chrono;NaN;NaN;NaN];
                    im_diffTemp{MouseNum}(num_fr,1:3)=[KeepTime.chrono;NaN;NaN];
                    MouseTempTemp{MouseNum}(num_fr,1:2)=[KeepTime.chrono;NaN];
                end
                
                

                % Update displays at 10Hz - faster would just be a waste of time
                if  mod(num_fr-2,UpdateImage)==0
                    set(g{MouseNum},'Xdata',Pos(1).*TrObj.Ratio_IMAonREAL,'YData',Pos(2).*TrObj.Ratio_IMAonREAL)
                    set(htrack,'Cdata',IM);
                    diffshow=double(NewIm);
                    diffshow(FzZone==1)=0.4;
                    diffshow(OldZone{MouseNum}==1)=0.4;
                    diffshow(NewIm==1)=0.8;
                    set(htrack2{MouseNum},'Cdata',diffshow);
                    figure(Fig_SleepSession),   
                end
                OldZone{MouseNum}=FzZone;
                OldIm{MouseNum}=NewIm;
                
                
                end
                num_fr=num_fr+1;
                

                %  SAVE FRAMES   
                if strcmp(TrObj.camera_type,'Webcam')
                    if strcmp(TrObj.vid.VideoFormat,'RGB24_320x240')
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
                
                
                if TrObj.SaveToMatFile==1
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
        for MouseNum=1:4
            MouseDir=[ExpeInfo.name_folder filesep 'Mouse' num2str(ExpeInfo.nmouse{MouseNum}) '-' ExpeInfo.namePhase{MouseNum}];
            mkdir(MouseDir)
            figure(Fig_SleepSession)

            % Correct for intan trigger time to realign with ephys - this is
            % really important!!
            im_diffTemp{MouseNum}(:,1)=im_diffTemp{MouseNum}(:,1)+1;
            PosMatTemp{MouseNum}(:,1)=PosMatTemp{MouseNum}(:,1)+1;
            MouseTempTemp{MouseNum}(:,1)=MouseTempTemp{MouseNum}(:,1)+1;
            % This is the strict minimum all codes need to save
            [PosMat,PosMatInit,im_diff,im_diffInit,Vtsd,Xtsd,Ytsd,Imdifftsd]=CommonInterpPosMatImDiff(im_diffTemp{MouseNum},KeepTime.chrono,PosMatTemp{MouseNum});
            ref=TrObj.ref;
            mask=TrObj.mask.*MouseMask{MouseNum}; % this is different to other codes because each mouse has its own mask
            Ratio_IMAonREAL=TrObj.Ratio_IMAonREAL;
            frame_limits=TrObj.frame_limits;
            save([ExpeInfo.name_folder,filesep,'TrObject.mat'],'TrObj');
            
            BW_threshold=BW_threshold_temp{MouseNum};
            smaller_object_size= smaller_object_size_temp{MouseNum};
            sm_fact=sm_fact_temp{MouseNum};
            strsz=strsz_temp{MouseNum};
            SrdZone=SrdZone_temp{MouseNum};
            MouseTemp = MouseTempTemp{MouseNum};
            save([MouseDir,filesep,'behavResources.mat'],'PosMat','MouseTemp','GotFrame','PosMatInit','im_diff','im_diffInit','Vtsd','Xtsd','Ytsd','Imdifftsd',...
                'ref','mask','Ratio_IMAonREAL','BW_threshold','frame_limits','smaller_object_size','sm_fact','strsz','SrdZone');
            clear ref mask Ratio_IMAonREAL
            
         
            
            %% generate figure that gives overviewof the tracking session
            figbilan=figure;
            plot(Range(Vtsd,'s'),Data(Vtsd)./prctile(Data(Vtsd),98),'k'), hold on
            plot(Range(Imdifftsd,'s'),Data(Imdifftsd)./prctile(Data(Imdifftsd),98),'b')
            title('Raw Data')
            
            saveas(figbilan,[MouseDir,filesep,'FigBilan.fig'])
            saveas(figbilan,[MouseDir,filesep,'FigBilan.png'])
            close(figbilan)
            
            % update display and button availability
            
            close(guireg_fig{MouseNum})
            
        end
        
        BW_threshold=BW_threshold_temp;
        smaller_object_size= smaller_object_size_temp;
        sm_fact=sm_fact_temp;
        strsz=strsz_temp;
        SrdZone=SrdZone_temp;

        
        try
            set(Fig_SleepSession,'Color',color_on);
            figure(Fig_SleepSession),  subplot(2,4,2:4), title('ACQUISITION STOPPED')
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
    end

end
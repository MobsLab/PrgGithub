function Gen_Track

global vid ref CameraType frame_rate IRLimits mask TrackingFunctions 
CameraType=0; % 1:webcam, 2=IR
color_on = [ 0 0 0]; % background color for tracking window
IRLimits=[]; % This allows for relevant renormalization of IR image after calibration, is set to empty for the webcam
%% initialize variables
num_exp=1;
etat_enregistrement=0;
arreter_ref=1;
arreter_gui=1;
arreter_track=1;
arreter_init=1;
init_fig=[];
ref_fig=[];
guireg_fig=[];
track_fig=[];
var_init=0;
frame_rate=10;

%% create the graphical interface n�1 with all the pushbuttons
close all

hand(1)=figure('units','normalized',...
    'position',[0.05 0.1 0.9 0.8],...
    'numbertitle','off',...
    'name','Menu',...
    'menubar','none',...
    'tag','fenetre depart');

message=uicontrol(hand(1),'style','text',...
    'units','normalized',...
    'position',[0.1 0 1 1],...
    'string','Video window');
color_on=[0.8 0.8 0.8];
set(message,'backgroundcolor',color_on);

% initialisation=> initialise arduino and camera, choose between webcam
% and IR camera, calibrate IR camera if required, choose max frame rate
hand(2)=uicontrol(hand(1),'style','pushbutton',...
    'units','normalized',...
    'position',[0.01 0.85 0.8/9 0.05],...
    'string','initialisation',...
    'tag','init',...
    'callback', @Gen_Track_init_device);

% stop=> stops and closes all cameras and arduino devices
hand(3)=uicontrol(hand(1),'style','pushbutton',...
    'units','normalized',...
    'position',[0.01 0.2 0.8/9 0.05],...
    'string','Stop',...
    'tag','stopping',...
    'callback', @Gen_Track_stop_devices);

% ref=> get a reference image
hand(4)=uicontrol(hand(1),'style','pushbutton',...
    'units','normalized',...
    'position',[0.01 0.75 0.8/9 0.05],...
    'string','ref',...
    'tag','reference',...
    'callback', @Gen_Track_get_reference);

% mask=> get a mask of the environment using the refernce image
hand(5)=uicontrol(hand(1),'style','pushbutton',...
    'units','normalized',...
    'position',[0.01 0.65 0.8/9 0.05],...
    'string','mask',...
    'tag','reference',...
    'callback', @Gen_Track_get_mask);

% pixratio=> define the ratio between pixels and actual cm
hand(6)=uicontrol(hand(1),'style','pushbutton',...
    'units','normalized',...
    'position',[0.01 0.55 0.8/9 0.05],...
    'string','real distance',...
    'tag','reference',...
    'callback', @Gen_Track_real_distance);

% choose tracking=> after this very general script, the tracking script you
% want must be chosen here
hand(9)=uicontrol(hand(1),'style','pushbutton',...
    'units','normalized',...
    'position',[0.01 0.45 0.8/9 0.05],...
    'string','choose tracking',...
    'tag','reglagegui',...
    'callback', @Gen_Track_choose_tracking);

% quit=> close everything after a hard day's science!
hand(8)=uicontrol(hand(1),'style','pushbutton',...
    'units','normalized',...
    'position',[0.01 0.05 0.8/9 0.05],...
    'string','quit',...
    'tag','quitting',...
    'callback', @Gen_Track_quit);

%% only button available are 'initialisation and' 'quit'
for var_boucle=[3,4,5,6,9]
    set(hand(var_boucle),'Enable','off')
end

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% %%
    function Gen_Track_choose_tracking(obj,event)
        %function called by Gen_Track to Choose your tracking script
        
        % When you add new codes, you must add them to this list to be able to
        % acess them
        FctCell={'NosePokeOdor' 'NosePokeSequential' 'MultipleNosePoke'...
            'FreezingOnline' 'FearFreezingOnline' 'NosePokeSB' 'DoubleOnlineTrackingSavFrame' 'DoubleOnlineTracking' 'IntanPrep'  'FearFreezingOffline','FearFreezingOnline2','PainFreezingOnline','UMazeTracking','SleepTrackingOneMouse_IRComp','TrackThreeMiceOnline','UMazeTracking_IRComp'};
        strfcts=strjoin(FctCell,'|');
        uicontrol('Style', 'popup','String', strfcts,'Position', [20 340 100 50],'Callback', @setfct);
        
        function setfct(obj,event)
            fctname=get(obj,'value');
            
            hand(7)=uicontrol(hand(1),'style','pushbutton',...
                'units','normalized',...
                'position',[0.01 0.35 0.8/9 0.05],...
                'string','track',...
                'tag','tracking',...
                'callback',str2func(FctCell{fctname}));
            
        end
    end

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% %%
    function Gen_Track_quit(obj,event)
        %function called by Gen_Track if you want to quit the programm
        
        if var_init==1 % security : you can only quit he video if you've actually started it
            
            %stop video
            
            stop(vid)
            delete(vid)
            vid=[];
            disp('Video Disconnected');
            
            %devices_on = 0;
            disp('Devices off');
            var_init=0;
        end
        
        delete(hand)
        close all
    end


%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% %%
%function to initialize camera and arduino
    function Gen_Track_init_device(obj,event)
        
        if var_init==0 % security : only initalize devices if they are not alread running
            set(hand(2),'enable','off')
            bar = waitbar(0,'Initialisation Progressing');
            textfig=figure('name','Initialisation','Units','Normalized','Position',[0.4 0.1 0.3 0.2],'color','w');
            plot(1,1); xlim([0 1]),ylim([0 1]), box off; set(gca,'visible','off')
            %start video
            CameraType=questdlg('What kind of video input are you using?','Camera choice','IRCamera','Webcam','IRCamera');
            switch CameraType
                case 'Webcam'
                    textfig;
                    text(0,0.8,'Setting up webcam ...');
                    imaqreset;
                    try,vid = videoinput('winvideo',1,'RGB24_320x240'); disp('using RGB');
                    catch,vid = videoinput('winvideo',1,'MJPG_320x240');disp('using MJPG');end
                    src = getselectedsource(vid);
                    disp('Video Object Created');
                    set(vid,'FramesPerTrigger',1); % Acquire only one frame each time
                    set(vid,'TriggerRepeat',Inf); % Go on forever until stopped
                    set(vid,'ReturnedColorSpace','grayscale'); % Get a grayscale image : less computation time
                    disp('Parameters set');
                    info_vid=imaqhwinfo(vid);
                    triggerconfig(vid, 'Manual'); % no external trigger
                    start(vid);
                    TrackingFunctions.GetFrame=str2func('GetAFrame_Webcam');
                    TrackingFunctions.Stop=str2func('ShutDownCamera_Webcam');
                    frame_rate=inputdlg('What frame rate should we use? If <9 : direct compression'); frame_rate=str2double(frame_rate);frame_rate=min([50,frame_rate]);frame_rate=max([5,frame_rate]);
                    IRLimits=[];
                case 'IRCamera'
                    textfig;
                    text(0,0.8,'Setting up IR camera ...');
                    atPath = getenv('FLIR_Atlas_MATLAB');
                    atLive = strcat(atPath,'Flir.Atlas.Live.dll');
                    asmInfo = NET.addAssembly(atLive);
                    test = Flir.Atlas.Live.Discovery.Discovery;
                    % search for cameras for 10 seconds
                    disc = test.Start(10);
                    % put the result in a list box
                    for i =0:disc.Count-1
                        s1 = strcat(char(disc.Item(i).Name),'::');
                        s2 = strcat(s1,char(disc.Item(i).CameraDeviceType));
                        str{i+1} =  s2;
                    end
                    vid = Flir.Atlas.Live.Device.ThermalCamera(true);
                    vid
                    pause(10)
                    vid.Connect(disc.Item(find(~cellfun(@isempty,strfind(str,'Gigabit')))-1));
                    vid
                    pause(10)
                    vid.RemoteControl.Focus.DisableContinuousFocus;
                    TrackingFunctions.GetFrame=str2func('GetAFrame_IRCamera');
                    TrackingFunctions.Stop=str2func('ShutDownCamera_IRCamera');
                    frame_rate=inputdlg('What frame rate should we use?'); frame_rate=str2double(frame_rate);frame_rate=min([50,frame_rate]);frame_rate=max([5,frame_rate]);
                    IRLimits=CalibrationInfraRedCamera(vid);
            end
            
            waitbar(1/2);
            textfig;
            text(0,0.6,'Video Started');
            
            %initialize the arduino
            global a
            poi=inputdlg('What num arduino?'); poi=str2double(poi);
            eval(['a = serial(''COM',num2str(poi),''');']);
            try
                fopen(a);
                okk=1;
                textfig;
                text(0,0.4,['Arduino Started on COM',num2str(poi)]);
            catch
                text(0,0.4,'No Arduino Started');
            end
            
            textfig;
            text(0,0.2,'Initialisation Complete');
            pause(0.5)
            waitbar(1);
            close(bar)
            close(textfig);
            
            %% graphical interface for camera
            init_fig=figure('units','normalized',...
                'position',[0.15 0.1 0.8 0.8],...
                'numbertitle','off',...
                'name','Online Mouse Tracking : Setting Parameters',...
                'menubar','none',...
                'tag','figure init');
            set(init_fig,'Color',color_on);
            
            initbutton=uicontrol(init_fig,'style','pushbutton',...
                'units','normalized',...
                'position',[0.01 0.04 0.08 0.05],...
                'string','Save and Close',...
                'callback', @fermeture_init);
            
            %% initialize varaibles
            arreter_init=0;
            time_image=1/10;
            t2=clock;
            t1=clock;
            
            while(arreter_init == 0)
                %% loop activated
                if etime(t2,t1) > time_image
                    t1=clock;
                    imageinit=TrackingFunctions.GetFrame(vid,IRLimits);
                    figure(init_fig)
                    imagesc(imageinit)
                    axis image
                    colormap gray
                end
                pause(0.001)
                t2=clock;
            end
            
            disp('Acquisition stopped');
            delete(init_fig) %return to graphical interface n�1
            var_init=1; % Everything is initialized
        else
            warndlg('devices already initialised','warning')
        end
        
        for var_boucle=[3,4,9]
            set(hand(var_boucle),'Enable','on')
        end
        
        function fermeture_init(obj,event)
            arreter_init = 1;
        end
    end

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% %%
%function to stop camera and arduino
    function Gen_Track_stop_devices(obj,event)
        %Stop the video and the arduino and clear all the varables
        if var_init==1
            TrackingFunctions.Stop;
            vid=[];
            disp('Video Disconnected');
            try
                fclose(a)
                disp('Arduino off')
            catch
                disp('Couldn''t switch ardino off')
            end
            disp('Devices off');
            var_init=0;
            set(hand(2),'enable','on')
        else
            set(hand(2),'enable','on')
            warndlg('devices already stopped','warning')
        end
        
        for var_boucle=[3,4,5,6,7]
            set(hand(var_boucle),'Enable','off')
        end
    end

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% %%
%function to get a reference image
    function Gen_Track_get_reference(obj,event)
        
        arreter_ref = 0;
        time_image=1/10;
        
        %% graphical interface for the reference image
        ref_fig=figure('units','normalized',...
            'position',[0.15 0.1 0.8 0.8],...
            'numbertitle','off',...
            'name','Online Mouse Tracking : Getting the refernce frame',...
            'menubar','none',...
            'tag','figure ref');
        set(ref_fig,'Color',color_on);
                
      uicontrol(ref_fig,'style','text', ...
            'units','normalized',...
            'position',[0.45 0.02 0.1 0.02],...
            'string','take a picture with no mouse');
        
        uicontrol(ref_fig,'style','pushbutton',...
            'units','normalized',...
            'position',[0.01 0.55 0.08 0.05],...
            'string','Save delay XXs',...
            'callback', @save_refdelay);
        
        uicontrol(ref_fig,'style','pushbutton',...
            'units','normalized',...
            'position',[0.01 0.65 0.08 0.05],...
            'string','Save',...
            'callback', @save_ref);
        
        uicontrol(ref_fig,'style','pushbutton',...
            'units','normalized',...
            'position',[0.01 0.04 0.08 0.05],...
            'string','Close',...
            'callback', @fermeture_ref);
        
        t1=clock;
        t2=clock;
        multiple=0;titleRef=' ';
        %% loop
        
        while(arreter_ref == 0)
            if etime(t2,t1) > time_image
                t1=clock;
                im=TrackingFunctions.GetFrame(vid,IRLimits);
                colormap gray
                figure(ref_fig)
                subplot(1,2,1),imagesc(im)
                title(titleRef,'Color','w')
                axis image
            end
            pause(0.001)
            t2=clock;
        end
        disp('Acquisition stopped');
        delete(ref_fig)
        
        function save_refdelay(obj,event)
            TimeToRef=inputdlg('how many seconds do you need'); TimeToRef=str2double(TimeToRef);
            msg_box=msgbox([num2str(TimeToRef),'s before saving Refence_image'],'save','modal');
            pause(TimeToRef);delete(msg_box)
            save_ref
        end
        
        function save_ref(obj,event) % keep ref in memory
            ref=TrackingFunctions.GetFrame(vid,IRLimits);
            mask=ones(size(ref,1),size(ref,2));
            figure(ref_fig)
            subplot(1,2,2)
            imagesc(ref),axis image
            save('InfoTrackingTemp.mat','ref','-append');
            mask=ones(size(ref,1),size(ref,2));
            set(hand(5),'Enable','on')
            msg_box=msgbox('Refence_image saved','save','modal');
            pause(0.5); delete(msg_box)
        end
        
        function fermeture_ref(obj,event)
            arreter_ref = 1;
            close(ref_fig)
            delete(ref_fig)
        end
        
    end


%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% %%
% function to define mask
    function Gen_Track_get_mask(obj,event)        
        
        %% graphical interface 
        mask_fig=figure('units','normalized',...
            'position',[0.15 0.1 0.8 0.8],...
            'numbertitle','off',...
            'name','Online Mouse Tracking : Setting Parameters',...
            'menubar','none',...
            'tag','figure mask');
        set(mask_fig,'Color',color_on);
        
        uicontrol(mask_fig,'style','text', ...
            'units','normalized',...
            'position',[0.45 0.02 0.1 0.02],...
            'string','click on maze edges');

        maskbutton(1)= uicontrol(mask_fig,'style','pushbutton',...
            'units','normalized',...
            'position',[0.01 0.85 0.08 0.05],...
            'string','Circle',...
            'callback', @Option_Circle);
        
        maskbutton(2)= uicontrol(mask_fig,'style','pushbutton',...
            'units','normalized',...
            'position',[0.01 0.25 0.08 0.05],...s
            'string','save',...
            'callback', @save_mask);
        
        maskbutton(3)=uicontrol(mask_fig,'style','pushbutton',...
            'units','normalized',...
            'position',[0.01 0.65 0.08 0.05],...
            'string','mask IN',...
            'callback', @Do_maskIN);
        
        maskbutton(4)= uicontrol(mask_fig,'style','pushbutton',...
            'units','normalized',...
            'position',[0.01 0.75 0.08 0.05],...
            'string','Reset mask',...
            'callback', @Reset_mask);
        
        maskbutton(5)=uicontrol(mask_fig,'style','pushbutton',...
            'units','normalized',...
            'position',[0.01 0.55 0.08 0.05],...
            'string','mask OUT',...
            'callback', @Do_maskOUT);
        
        maskbutton(6)= uicontrol(mask_fig,'style','pushbutton',...
            'units','normalized',...
            'position',[0.01 0.04 0.08 0.05],...
            'string','Close',...
            'callback', @fermeture_mask);
        
        
        ref2=ref;
        figure(mask_fig),colormap gray
        subplot(1,2,1), imagesc(mat2gray(ref)),axis image
        Docircle=0; title('rectligne shape','Color','w')
        disp('bou')
        function Do_maskIN(obj,event)
            keyboard
            for var_boucle=1:6
                set(maskbutton(var_boucle),'Enable','off')
            end
            figure(mask_fig), subplot(1,2,1)
            if Docircle
                h = imellipse;
                BW = createMask(h);
            else
                [x1,y1,BW,y2]=roipoly(mat2gray(ref));
            end
            maskint=uint8(BW);
            maskint=uint8(-(double(maskint)-1));
            mask=uint8(double(mask).*double(maskint));
            climtemp=clim;
            colormap gray
            ref2((find(mask==0)))=0;
            figure(mask_fig), subplot(1,2,2)
            imagesc((ref2)),axis image,clim(climtemp)

            for var_boucle=1:6
                set(maskbutton(var_boucle),'Enable','on')
            end
        end
        
        function Do_maskOUT(obj,event)
            for var_boucle=1:6
                set(maskbutton(var_boucle),'Enable','off')
            end
            figure(mask_fig), subplot(1,2,1)
            if Docircle
                h = imellipse;
                BW = createMask(h);
            else
                [x1,y1,BW,y2]=roipoly(mat2gray(ref));
            end
            maskint=uint8(BW);
            mask=uint8(double(mask).*double(maskint));
                        climtemp=clim;

            colormap gray
            ref2((find(mask==0)))=0;
            figure(mask_fig), subplot(1,2,2)
            imagesc((ref2)),axis image,clim(climtemp)

            for var_boucle=1:6
                set(maskbutton(var_boucle),'Enable','on')
            end
        end
        
        function Option_Circle(obj,event)
            if Docircle
                Docircle=0;
                subplot(1,2,1), title('rectligne shape','Color','w')
            else
                Docircle=1;
                subplot(1,2,1), title('CIRCLE ACITVATED','Color','w')
            end
            
        end
        
        function Reset_mask(obj,event)
            figure(mask_fig),colormap gray
            subplot(1,2,1), imagesc(ref),axis image
            if Docircle, title('CIRCLE ACITVATED','Color','w'); else, title('rectligne shape','Color','w');end
            mask=ones(size(ref2,1),size(ref2,2));
            ref2=ref;
            subplot(122), imagesc(ref2), axis image
        end
        
        
        function save_mask(obj,event) % keep ref in memory
            save('InfoTrackingTemp.mat','mask','-append');
            disp('mask saved');
            msg_box=msgbox('Mask saved','save','modal');
            pause(0.5); delete(msg_box)
            %waitfor(msg_box);
            set(hand(6),'Enable','on')
            
        end
        
        function fermeture_mask(obj,event)
            delete(mask_fig)
        end
        
        
    end

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% %%
% Define the pixratio
function Gen_Track_real_distance(obj,event)
        
        PixRatioFigure=figure;
        imagesc(ref); colormap gray; axis image
        title('Click on two points to define a distance','Color','w')
        for j=1:2
            [x,y]=ginput(1);
            hold on, plot(x,y,'+r')
            x1(j)=x; y1(j)=y;
        end
        line(x1,y1,'Color','r','Linewidth',2)
        
        answer = inputdlg({'Enter real distance (cm):'},'Define Real distance',1,{'40'});
        text(mean(x1)+10,mean(y1)+10,[answer{1},' cm'],'Color','r')
        
        d_xy=sqrt((diff(x1)^2+diff(y1)^2));
        Ratio_IMAonREAL=d_xy/str2num(answer{1});
        
        if exist('InfoTrackingTemp.mat','file')
            save('InfoTrackingTemp.mat','Ratio_IMAonREAL','-append')
        else
            save('InfoTrackingTemp.mat','Ratio_IMAonREAL') 
        end
        close(PixRatioFigure)
end

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% %%

    function [jour, mois, annee ] = date_today(t)
        jour=num2str(t(3));
        mois=num2str(t(2));
        annee=num2str(t(1));
        %add necessary zeros before the day and the months
        if length(jour)==1
            jour=cat(2,'0',jour);
        end
        if length(mois)==1
            mois=cat(2,'0',mois);
        end
    end

end
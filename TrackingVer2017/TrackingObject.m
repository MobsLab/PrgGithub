classdef TrackingObject
    
    % The video tracking object is created that contains the camera
    % information in order to get the frames and all the information to
    % perform the tracking
    
    properties
        % Values that parametrize the camera
        vid % the actual video object
        frame_rate % This is the frame rate of acquisition
        camera_type % This tracks whether it is an 'Webcam','IRCamera','SurveillanceCam' etc
        frame_limits % This depends on the type of camera and allows to set each frame values between 0 and 1
        tracking_functions % This depends on the type of camera and allows the correct get frame and stop camea functions to be called
        SaveToMatFile % Is one if save to matfile, is 0 if only save to avi
        % Properties that concern the tracking parametrization and execution
        ref
        mask
        Ratio_IMAonREAL
        mask_UMaze
        
        
    end
    
    properties (Constant)
        lim_frame_rate=9; % Above this frame rate .mat files are saved, below this frame rate .avi is saved
        color_on=[0 0 0];
    end
    
    
    methods
        
        %% Constructor : initialise object and start the camera
        function TrObj=TrackingObject(textfig,camnum)
            % Camnum is only applciable for webcams (set to 1 or 2
            % depending on which camera you want to activate)
            % Ask the user to choose between camera types, to set the
            % frame rate and decide whether or not to save mat files
            mask_UMaze = [111 193 245 193 245 130 142 132 142 92 245 92 245 29 111 31 111 193];
            TrObj.camera_type=questdlg('What kind of video input are you using?',['Camera ' num2str(camnum) ' choice'],'IRCamera','Webcam','IRCamera');
            frame_rate_temp=inputdlg('What frame rate should we use? If <9 : direct compression',['Camera ' num2str(camnum)]);
            frame_rate_temp=str2double(frame_rate_temp);frame_rate_temp=min([50,frame_rate_temp]);frame_rate_temp=max([5,frame_rate_temp]);
            TrObj.frame_rate=frame_rate_temp;
            tempanswer=questdlg('How do you want to save?',['Camera ' num2str(camnum) ' Save format'],'AVI only','AVI and MAT','AVI only');
            switch tempanswer
                case 'AVI only'
                    TrObj.SaveToMatFile=0;
                case 'AVI and MAT'
                    TrObj.SaveToMatFile=1;
            end
            
            % Depending on the camera type start the camera
            switch TrObj.camera_type
                case 'Webcam'
                    % Set up video object
                    textfig;
                    text(0,0.8,'Setting up webcam ...');
                    if camnum ==1
                        imaqreset;
                        a = imaqhwinfo('winvideo');
                        if size(a.DeviceInfo,2)==2 % make sure you sue the webcam
                            camnum = find([~isempty(strfind(a.DeviceInfo(1).DeviceName,'HD USB Camera')),~isempty(strfind(a.DeviceInfo(2).DeviceName,'HD USB Camera'))]);
                        end
                    end
                    if isunix
                        VideoAdaptor = "linuxvideo";
                    else
                        VideoAdaptor = "winvideo";
                    end

                    try,TrObj.vid = videoinput(VideoAdaptor,camnum,'RGB24_640x480');text(0,0.8,'Setting up webcam ...using RGB');
                    catch,
                        TrObj.vid = videoinput(VideoAdaptor,camnum,'MJPG_640x480');text(0,0.8,'Setting up webcam ...using MJPG');end

                    src = getselectedsource(TrObj.vid);
                    % temporary SB
                    % src.Exposure = int32(-7);
                    % src.WhiteBalanceMode = 'manual';
                    % src.ExposureMode = 'manual';
                    % src.BacklightCompensation = 'off';
                    % Parametrize and start object
                    set(TrObj.vid,'FramesPerTrigger',1); % Acquire only one frame each time
                    set(TrObj.vid,'TriggerRepeat',Inf); % Go on forever until stopped
                    %1set(TrObj.vid,'ReturnedColorSpace','grayscale'); % Get a grayscale image : less computation time
                    triggerconfig(TrObj.vid, 'Manual'); % no external trigger
                    start(TrObj.vid);
                    
                    % Information about the object to do the tracking
                    TrObj.tracking_functions.GetFrame=str2func('GetAFrame_Webcam');
                    TrObj.tracking_functions.Stop=str2func('ShutDownCamera_Webcam');
                    TrObj.frame_limits=[0,253];
                case 'IRCamera'
                    % Set up video object
                    textfig;
                    text(0,0.8,'Setting up IR camera ...');
                    atPath = getenv('FLIR_Atlas_MATLAB');
                    atLive = strcat(atPath,'Flir.Atlas.Live.dll');
                    asmInfo = NET.addAssembly(atLive);
                    test = Flir.Atlas.Live.Discovery.Discovery;
                    disc = test.Start(10); % search for cameras for 10 seconds
                    for i =0:disc.Count-1 % list the results to get the right camera
                        s1 = strcat(char(disc.Item(i).Name),'::');
                        s2 = strcat(s1,char(disc.Item(i).CameraDeviceType));
                        str{i+1} =  s2;
                    end
                    TrObj.vid = Flir.Atlas.Live.Device.ThermalCamera(true);
                    TrObj.vid, pause(10)
                    
                    % Parametrize and start object
                    TrObj.vid.Connect(disc.Item(find(~cellfun(@isempty,strfind(str,'Gigabit')))-1));
                    TrObj.vid, pause(10)
                    TrObj.vid.RemoteControl.Focus.DisableContinuousFocus;
                    
                    % Information about the object to do the tracking
                    TrObj.tracking_functions.GetFrame=str2func('GetAFrame_IRCamera');
                    TrObj.tracking_functions.Stop=str2func('ShutDownCamera_IRCamera');
                    TrObj.frame_limits=CalibrationInfraRedCamera(TrObj.vid);
            end
            textfig;
            text(0,0.6,'Video Started');
            
            % check the focus and zoom on the camera - this used to be in
            % the Gen_Track code but was moved here so that it could be
            % done one camera at a time
            
            %% graphical interface for camera
            init_fig=figure('units','normalized',...
                'position',[0.15 0.1 0.8 0.8],...
                'numbertitle','off',...
                'name','Online Mouse Tracking : Setting Parameters',...
                'menubar','none',...
                'tag','figure init');
            set(init_fig,'Color',TrObj.color_on);
            
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
                    figure(init_fig)
                    imageinit = TrObj.GetAFrame;
                    imagesc(imageinit)
                    axis image
                    colormap gray
                end
                pause(0.001)
                t2=clock;
            end
            
            disp('Acquisition stopped');
            delete(init_fig) %return to graphical interface n???1
            
            
            function fermeture_init(obj,event)
                arreter_init = 1;
            end
            
        end
        
        %% Methods that get frames - there should be one per camera type.
        % General function that calls the right syntax, the specific
        % cameras are defined below
        function im=GetAFrame(TrObj)
            im=TrObj.(func2str(TrObj.tracking_functions.GetFrame));
        end
        
        %IRCamera
        function im=GetAFrame_IRCamera(TrObj)
            im=double(TrObj.vid.ThermalImage.ImageProcessing.GetPixelsArray);
            im=(im-TrObj.frame_limits(1))./(TrObj.frame_limits(2)-TrObj.frame_limits(1));
        end
        %Webcam
        function im=GetAFrame_Webcam(TrObj)
            trigger(TrObj.vid);
            im=double(getdata(TrObj.vid,1,'uint8'));
            im=(im-TrObj.frame_limits(1))./(TrObj.frame_limits(2)-TrObj.frame_limits(1));
        end
        
        %% Methods to run at the start : get reference, mask, real distance
        function TrObj=Get_Reference(TrObj)
            
%             mask_UMaze = [111 193 245 193 245 130 142 132 142 92 245 92 245 29 111 31 111 193];
%             mask_UMaze = [200 223 200 57 60 57 60 120 163 120 163 161 60 161 60 223 200 223];
            mask_UMaze = [200 223 200 57 60 57 60 130 155 130 155 151 60 151 60 223 200 223];
            UMazeStriatum = 0;
            % Some initial values
            arreter_ref = 0; % 0 if stop refreshing frames and close window
            time_image=1/10; % time between display of frames
            t1=clock;
            t2=clock;
            
            %% graphical interface for the reference image
            ref_fig=figure('units','normalized',...
                'position',[0.15 0.1 0.8 0.8],...
                'numbertitle','off',...
                'name','Online Mouse Tracking : Getting the refernce frame',...
                'menubar','none',...
                'tag','figure ref');
            set(ref_fig,'Color',TrObj.color_on);
            
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
                'position',[0.01 0.45 0.08 0.05],...
                'string','UMazeStriatum',...
                'callback', @PutUMaze);
            
            uicontrol(ref_fig,'style','pushbutton',...
                'units','normalized',...
                'position',[0.01 0.04 0.08 0.05],...
                'string','Close',...
                'callback', @fermeture_ref);
            
            %% loop
            
            while(arreter_ref == 0)
                % Diplay the video
                if etime(t2,t1) > time_image
                    t1=clock;
                    im=TrObj.GetAFrame;
                    colormap gray
                    try,figure(ref_fig);end
                    if UMazeStriatum
                        im = insertShape(im,'Polygon',mask_UMaze);
                        im = rgb2gray(im);
                    end
                    subplot(1,2,1),imagesc(im)
                    title('Ongoing','Color','w')
                    axis image
                end
                pause(0.001)
                t2=clock;
            end
            disp('Acquisition stopped');
            delete(ref_fig)
            
            function save_refdelay(obj,event) % called if you set up a timer before taking the ref
                TimeToRef=inputdlg('how many seconds do you need'); TimeToRef=str2double(TimeToRef);
                msg_box=msgbox([num2str(TimeToRef),'s before saving Refence_image'],'save','modal');
                pause(TimeToRef);delete(msg_box)
                save_ref
            end
            
            function save_ref(obj,event) % save ref to file
                if strcmp(TrObj.camera_type, 'Webcam')
                    while islogging(TrObj.vid)
                        disp('wait');
                    end
                    ref=TrObj.GetAFrame;TrObj.ref=ref;
                    TrObj.mask=ones(size(ref,1),size(ref,2));
                    figure(ref_fig)
                    subplot(1,2,2)
                    imagesc(TrObj.ref),axis image
                    title('Your reference','Color','w')
                    %                     save('InfoTrackingTemp.mat','ref','-append');
                    msg_box=msgbox('Refence_image saved','save','modal');
                    pause(0.5); delete(msg_box)
                elseif strcmp(TrObj.camera_type, 'IRCamera')
                    ref=TrObj.GetAFrame;TrObj.ref=ref;
                    TrObj.mask=ones(size(ref,1),size(ref,2));
                    figure(ref_fig)
                    subplot(1,2,2)
                    imagesc(TrObj.ref),axis image
                    title('Your reference','Color','w')
                    %                     save('InfoTrackingTemp.mat','ref','-append');
                    msg_box=msgbox('Refence_image saved','save','modal');
                    pause(0.5); delete(msg_box)
                end
            end
            
            function PutUMaze(obj,event) % save ref to file
                UMazeStriatum = 1;
                % rotate umaze if necessary
                [mask_UMaze z side] = rotate_umaze(mask_UMaze,0,0);
            end
            
            
            function fermeture_ref(obj,event) % close window and stop display
                arreter_ref = 1;
                close(ref_fig)
                delete(ref_fig)
            end
        end
        
        function TrObj=Get_Mask(TrObj)
            
%             mask_UMaze = [111 193 245 193 245 130 142 132 142 92 245 92 245 29 111 31 111 193];
%            mask_UMaze = [200 223 200 57 60 57 60 120 163 120 163 161 60 161 60 223 200 223];
            mask_UMaze = [200 223 200 57 60 57 60 130 155 130 155 151 60 151 60 223 200 223];
            % So that all the callbacks can us it and redefine it
            ref2=TrObj.ref;
            mask=TrObj.mask;
            WaitForSave=0;
            
            %% graphical interface
            mask_fig=figure('units','normalized',...
                'position',[0.15 0.1 0.8 0.8],...
                'numbertitle','off',...
                'name','Online Mouse Tracking : Setting Parameters',...
                'menubar','none',...
                'tag','figure mask');
            set(mask_fig,'Color',TrObj.color_on);
            
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
            
            maskbutton(7)=uicontrol(mask_fig,'style','pushbutton',...
                'units','normalized',...
                'position',[0.01 0.45 0.08 0.05],...
                'string','UMazeStriatum',...
                'callback', @UmaskStriatum);
            
            maskbutton(6)= uicontrol(mask_fig,'style','pushbutton',...
                'units','normalized',...
                'position',[0.01 0.04 0.08 0.05],...
                'string','Close',...
                'callback', @fermeture_mask);
            
            figure(mask_fig),colormap gray
            subplot(1,2,1), imagesc(mat2gray(TrObj.ref)),axis image
            Docircle=0; title('rectligne shape','Color','w')
            
            while WaitForSave==0
                pause(0.01)
            end
            %             save('InfoTrackingTemp.mat','mask','-append');
            TrObj.mask=mask;
            disp('mask saved');
            msg_box=msgbox('Mask saved','save','modal');
            pause(0.5); delete(msg_box)
            
            function Do_maskIN(obj,event)
                for var_boucle=1:6
                    set(maskbutton(var_boucle),'Enable','off')
                end
                figure(mask_fig), subplot(1,2,1)
                if Docircle
                    h = imellipse;
                    BW = createMask(h);
                else
                    [x1,y1,BW,y2]=roipoly(mat2gray(TrObj.ref));
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
                    [x1,y1,BW,y2]=roipoly(mat2gray(TrObj.ref));
                end
                maskint=uint8(BW);
                mask=uint8(double(mask).*double(maskint));
                climtemp=caxis;
                
                colormap gray
                ref2((find(mask==0)))=0;
                figure(mask_fig), subplot(1,2,2)
                imagesc((ref2)),axis image,clim(climtemp)
                for var_boucle=1:6
                    set(maskbutton(var_boucle),'Enable','on')
                end
            end
            
             function UmaskStriatum(obj,event)
                for var_boucle=1:7
                    set(maskbutton(var_boucle),'Enable','off')
                end
                
                [mask_UMaze z side] = rotate_umaze(mask_UMaze,0,0);
                
                BW = roipoly(TrObj.ref,mask_UMaze(1:2:end),mask_UMaze(2:2:end));
                
                maskint=uint8(BW);
                mask=uint8(double(mask).*double(maskint));
                climtemp=clim;
                
                colormap gray
                ref2((find(mask==0)))=0;
                figure(mask_fig), subplot(1,2,2)
                imagesc((ref2)),axis image,clim(climtemp)
                for var_boucle=1:7
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
                subplot(1,2,1), imagesc(TrObj.ref),axis image
                if Docircle, title('CIRCLE ACITVATED','Color','w'); else, title('rectligne shape','Color','w');end
                mask=ones(size(ref2,1),size(ref2,2));
                ref2=TrObj.ref;
                subplot(122), imagesc(ref2), axis image
            end
            
            
            function save_mask(obj,event) % keep ref in memory
                WaitForSave=1;
            end
            
            function fermeture_mask(obj,event)
                delete(mask_fig)
            end
            
            
        end
        
        function TrObj=Get_RealDistance(TrObj)
            
            PixRatioFigure=figure;
            imagesc(TrObj.ref); colormap gray; axis image
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
            TrObj.Ratio_IMAonREAL=Ratio_IMAonREAL;
            
            %             if exist('InfoTrackingTemp.mat','file')
            %                 save('InfoTrackingTemp.mat','Ratio_IMAonREAL','-append')
            %             else
            %                 save('InfoTrackingTemp.mat','Ratio_IMAonREAL')
            %             end
            close(PixRatioFigure)
        end
        
        %% Methods that stop the camera - there should be one per camera type.
        % General function that calls the right syntax, the specific
        % cameras are defined below
        function TrObj=StopCamera(TrObj)
            TrObj=TrObj.(func2str(TrObj.tracking_functions.Stop));
        end
        
        % IRCamera
        function TrObj=ShutDownCamera_IRCamera(TrObj)
            TrObj.vid.StopGrabbing;
            TrObj.vid.Disconnect();
            TrObj.vid.Dispose();
            TrObj.vid=[];
        end
        % WebCam
        function TrObj=ShutDownCamera_Webcam(TrObj)
            stop(TrObj.vid)
            TrObj.vid=[];
        end
    end
    
    
    
end
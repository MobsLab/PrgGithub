function Gen_Track_ObjectOrientated

%% initialize variables
global a TrObj Stimulator PulsePalSystem nBytesAvailable % the arduino, the stimulator type and the tracking object
arreter_init=1;
init_fig=[];
var_init=0;

%% create the graphical interface n???1 with all the pushbuttons
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
set(message,'backgroundcolor',[0.8 0.8 0.8]);

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
        FctCell={'UMazeTracking_IRComp_ObjectOrientated',...
            'UMazeTracking_IRComp_ObjectOrientated_DBparam',...
            'TrackingSleepSession_IRComp_ObjectOrientated',...
            'TrackingSleepStimulation_IRComp_ObjectOrientated',...
            'TrackingSleepStimulation_ClosedLoopPC_IRComp_ObjectOrientated',...
            'TrackingSleepStimulation_ERP_IRComp_ObjectOrientated',...
            'TrackingSleepSessionMultiMouse_IRComp_ObjectOrientated',...
            'NosePokeTracking_IRComp_ObjectOrientated',...
            'TrackingManualSleepStimulation_IRComp_ObjectOrientated'};
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
        
        if var_init==1
            disp('Use stop button first')
        else
            delete(hand)
            close all
        end
    end


%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% %%
%function to initialize camera and arduino
    function Gen_Track_init_device(obj,event)
        
        if var_init==0 % security : only initalize devices if they are not alread running
            
            set(hand(2),'enable','off')
            textfig=figure('name','Initialisation','Units','Normalized','Position',[0.4 0.1 0.3 0.2],'color','w');
            plot(1,1); xlim([0 1]),ylim([0 1]), box off; set(gca,'visible','off')
            
            %%start video
            TrObj=TrackingObject(textfig);
            
            %%initialize the arduino
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
            
            Stimulator=questdlg('What kind of stimulator you have?','Stimulator choice','Big and old (or nothing)','New PulsePal','Big and old (or nothing)');
            if strcmp('New PulsePal',Stimulator)
                PulsePal;
                textfig;
                text(0,0.24,'PulsePal Initialized');
            end
            
            textfig;
            text(0,0.1,'Initialisation Complete');
            pause(0.5)
            close(textfig);
            
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
                    imageinit=TrObj.GetAFrame;
                    figure(init_fig)
                    imagesc(imageinit)
                    axis image
                    colormap gray
                end
                pause(0.001)
                t2=clock;
            end
            
            disp('Acquisition stopped');
            delete(init_fig) %return to graphical interface n???1
            var_init=1; % Everything is initialized
        else
            warndlg('devices already initialised','warning')
        end
        
        for var_boucle=[3,4]
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
            %% Stop video
            TrObj=TrObj.StopCamera;
            disp('Video Disconnected');
            
            %% Stop arduino
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
        
            if strcmp('New PulsePal',Stimulator)
                EndPulsePal;
                
            end
        
        for var_boucle=[3,4,5,6,7]
            set(hand(var_boucle),'Enable','off')
        end
    end

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% %%
%function to get a reference image
    function Gen_Track_get_reference(obj,event)
        TrObj=TrObj.Get_Reference;
        pause(1)
        set(hand(5),'Enable','on')
    end

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% %%
% function to define mask
    function Gen_Track_get_mask(obj,event)
        TrObj=TrObj.Get_Mask;
        set(hand(6),'Enable','on')
    end

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% %%
% Define the pixratio
    function Gen_Track_real_distance(obj,event)
        TrObj=TrObj.Get_RealDistance;
        set(hand(9),'Enable','on')
    end

end
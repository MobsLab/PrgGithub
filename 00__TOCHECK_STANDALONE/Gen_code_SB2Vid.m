function Gen_code_SB2Vid
%Important note : make sure you work with a blank workspace : be careful of
%videoinput objects ; in case of doubt, restart matlab
global vid

sizeOccMap=5;
close all

%% graphical interface n�1 with all the pushbuttons

hand(1)=figure('units','normalized',...
    'position',[0.05 0.1 0.9 0.8],...
    'numbertitle','off',...
    'name','Menu',...
    'menubar','none',...
    'tag','fenetre depart');
set(hand(1),'CloseRequestFcn',@quit)

hand(2)=uicontrol(hand(1),'style','pushbutton',...
    'units','normalized',...
    'position',[0.01 0.85 0.8/9 0.05],...
    'string','initialisation',...
    'tag','init',...
    'callback', @init_device);

message=uicontrol(hand(1),'style','text',...
    'units','normalized',...
    'position',[0.1 0 1 1],...
    'string','Video window');
color_on=[0.8 0.8 0.8];
set(message,'backgroundcolor',color_on);

hand(3)=uicontrol(hand(1),'style','pushbutton',...
    'units','normalized',...
    'position',[0.01 0.2 0.8/9 0.05],...
    'string','Stop',...
    'tag','stopping',...
    'callback', @stop_devices);

hand(4)=uicontrol(hand(1),'style','pushbutton',...
    'units','normalized',...
    'position',[0.01 0.75 0.8/9 0.05],...
    'string','ref',...
    'tag','reference',...
    'callback', @get_reference_v3);

hand(5)=uicontrol(hand(1),'style','pushbutton',...
    'units','normalized',...
    'position',[0.01 0.65 0.8/9 0.05],...
    'string','mask',...
    'tag','reference',...
    'callback', @Get_mask);

hand(6)=uicontrol(hand(1),'style','pushbutton',...
    'units','normalized',...
    'position',[0.01 0.55 0.8/9 0.05],...
    'string','thresholds',...
    'tag','reglagegui',...
    'callback', @gui_reglage_v4);

hand(9)=uicontrol(hand(1),'style','pushbutton',...
    'units','normalized',...
    'position',[0.01 0.45 0.8/9 0.05],...
    'string','choose tracking',...
    'tag','reglagegui',...
    'callback', @choose_tracking);


hand(8)=uicontrol(hand(1),'style','pushbutton',...
    'units','normalized',...
    'position',[0.01 0.05 0.8/9 0.05],...
    'string','quit',...
    'tag','quitting',...
    'callback', @quit);

for var_boucle=[3,4,5,6,9]
    set(hand(var_boucle),'Enable','off')
end

% 1)initialisation=> initialise arduino and camera, change camera settings
% 2)ref=> get a reference image
% 3)thresholds => set the thresholds
% 4)track=> launch the tracking
% 5)quit=> quit the programm


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Choose your script
    function choose_tracking(obj,event)
        %
        %         try
        %             bla=load('ListofFcts.mat');
        %         catch
        %        try
        %            bla=load('\\NASDELUXE\DataMOBsRAID5\ARDUINO-codeSave\CommunTracking\ListofFcts.mat');
        %        catch
        %            bla=load('C:\Users\samantha\Documents\MATLAB\ListofFcts.mat');
        %        end
        %         end
        %            FctCell=bla.FctCell;
        
        FctCell={'NosePokeOdor' 'NosePokeSequential' 'MultipleNosePoke'...
            'FreezingOnline' 'FearFreezingOnline' 'DoubleOnlineTracking' 'IntanPrep'  'FearFreezingOffline','FearFreezingOnline2','FearFreezingOnlineImetronic2Vid','FearFreezingOnlineImetronic2VidJL','FearFreezingOnlineImetronic2VidSB'};
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


%% only button available are 'initialisation and' 'quit'

%% value of frame rate : 10 Hz : it is not necessary to go faster
frame_rate=10;

%% initialize variables
ref=cell(1,2);
smaller_object_size=cell(1,2);
BW_threshold=cell(1,2);
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
b_default=128;
c_default=32;
e_default=-7;
change_parameter=0;
occupation_x=cell(1,2);
occupation_y=cell(1,2);
vid =[];



%%
%function to quit the programm
    function quit(obj,event)
        
        if var_init==1 % security : not used if the programm is executed corectly
            
            %stop video
            for v=1:2
                stop(vid{v})
                delete(vid{v})
                vid{v}=[];
                disp(['Video', num2str(v), 'Disconnected']);
            end
            
            %devices_on = 0;
            disp('Devices off');
            var_init=0;
        end
        
        delete(hand)
        close all
    end


%function to initialize camera and arduino
    function init_device(obj,event)
        
        if var_init==0 % security : not used if the programm is launched correctly
            set(hand(2),'enable','off')
            bar = waitbar(0,'Initialisation Progressing');
            imaqreset;
            
            for v=1:2
            %start video 1
            vid{v} = videoinput('winvideo',v,'RGB24_320x240');
            src = getselectedsource(vid{v});
            set(src,'Brightness',b_default);
            set(src,'Contrast',c_default);
            set(src,'Exposure',e_default);
            disp('Video Object Created');
            set(vid{v},'FramesPerTrigger',1); % Acquire only one frame each time
            set(vid{v},'TriggerRepeat',Inf); % Go on forever until stopped
            set(vid{v},'ReturnedColorSpace','grayscale'); % Get a grayscale image : less computation time
            disp('Parameters set');
            save('InfoTrackingTemp.mat','b_default','c_default','e_default','-append');
            info_vid{v}=imaqhwinfo(vid{v});
            occupation_x{v}=ceil(info_vid{v}.MaxWidth/sizeOccMap);
            occupation_y{v}=ceil(info_vid{v}.MaxHeight/sizeOccMap);
            
            triggerconfig(vid{v}, 'Manual'); % no external trigger
            disp(['Video', num2str(v), 'Triggerred']);
            start(vid{v});
            
            % Align camera 1
            %% graphical interface n�2
            color_on = [ 0 0 0];
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
            time_image=1/frame_rate;
            t2=clock;
            t1=clock;
            
            while(arreter_init == 0)
                %% loop activated
                if etime(t2,t1) > time_image
                    
                    t1=clock;
                    
                    trigger(vid{v});
                    imageinit=getdata(vid{v},1,'uint8');
                    
                    figure(init_fig)
                    %                     subplot(1,2,1)
                    
                    imagesc(imageinit)
                    axis image
                    colormap gray
                end
                t2=clock;
                %% you go there if you click 'camera settings'
                %restart the vid with new parameters
            end
            delete(init_fig) %return to graphical interface n�1
            end
            
            waitbar(1/2);
            disp('Videos Started');
            
            %Arduino
            %initialize the arduino
            global a
            okk=0;
            poi=inputdlg('What num arduino?'); poi=str2double(poi);
            %for poi=2:20
            if okk==0
                eval(['a = serial(''COM',num2str(poi),''');']);
                try
                    fopen(a);
                    okk=1;
                    disp(['Arduino Started on COM',num2str(poi)]);
                end
            end
            %end
            if okk==0, disp('No Arduino Started');end
            
            waitbar(1);
            close(bar)
            disp('Initialisation Complete');
            
            disp('Acquisition stopped');
            
            var_init=1;
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

%function to stop camera and arduino
    function stop_devices(obj,event)
        %Stop the video and the arduino and clear all the varables
        if var_init==1
            
             for v=1:2
                stop(vid{v})
                delete(vid{v})
                vid{v}=[];
                disp(['Video', num2str(v), 'Disconnected']);
             end
            
            fclose(a);
            delete(a);
            a=[];
         
             
            disp('Devices off');
            msg_box=msgbox('Devices off','Success','modal');
            waitfor(msg_box);
            var_init=0;
            set(hand(2),'enable','on')
        else
            set(hand(2),'enable','on')
            warndlg('devices already stopped','warning')
        end
        
        for var_boucle=[3,4,5,6]
            set(hand(var_boucle),'Enable','off')
        end
        try
            set(hand(7),'Enable','off')
        end
        try
            fclose(a)
            disp('Arduino off')
        end
    end


    function Get_mask(obj,event)
        v=inputdlg('Which cage? 1 or 2');v=eval(v{1});
        global mask
        temp=load('InfoTrackingTemp.mat','ref');
        ref=temp.ref;   
        try
            temp=load('InfoTrackingTemp.mat','mask');
        mask=temp.mask;   
        if not(iscell(mask))
           temp=mask;
            mask=cell(1,1);
           mask{1}=temp;
        end
        catch 
        end
        mask{v}=ones(size(ref{v},1),size(ref{v},2));        
        ref2=ref{v};
            
            color_on = [ 0 0 0];
            
            %% graphical interface n�3
            mask_fig=figure('units','normalized',...
                'position',[0.15 0.1 0.8 0.8],...
                'numbertitle','off',...
                'name','Online Mouse Tracking : Setting Parameters',...
                'menubar','none',...
                'tag','figure mask');
            set(mask_fig,'Color',color_on);
            
            uicontrol(mask_fig,'style','text', ...
                'units','normalized',...
                'position',[0.25 0.02 0.06 0.03],...
                'string','click on maze edges');
            
            uicontrol(mask_fig,'style','text', ...
                'units','normalized',...
                'position',[0.70 0.02 0.06 0.03],...
                'string','satisfied?');
            
            maskbutton(1)= uicontrol(mask_fig,'style','pushbutton',...
                'units','normalized',...
                'position',[0.25 0.85 0.08 0.05],...
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
                'position',[0.01 0.45 0.08 0.05],...
                'string','Load mask',...
                'callback', @Load_mask);
            
            maskbutton(7)= uicontrol(mask_fig,'style','pushbutton',...
                'units','normalized',...
                'position',[0.01 0.04 0.08 0.05],...
                'string','Close',...
                'callback', @fermeture_mask);
            
            figure(mask_fig),colormap gray
        subplot(1,2,1), imagesc(ref{v}),axis image
        Docircle=0; title('rectligne shape','Color','w')
        pause(1)
        mask_save=0;
        
        
        function Do_maskIN(obj,event)
            for var_boucle=1:7
                set(maskbutton(var_boucle),'Enable','off')
            end
            figure(mask_fig), subplot(1,2,1)
            if Docircle
                h = imellipse;
                BW = createMask(h);
            else
                [x1,y1,BW,y2]=roipoly(ref{v});
            end
            maskint=uint8(BW);
            maskint=uint8(-(double(maskint)-1));
            mask{v}=uint8(double(mask{v}).*double(maskint));
            
            colormap gray
            ref2((find(mask{v}==0)))=0;
            figure(mask_fig), subplot(1,2,2)
            imagesc(ref2),axis image
            for var_boucle=1:7
                set(maskbutton(var_boucle),'Enable','on')
            end
            
        end
        
        function Do_maskOUT(obj,event)
            for var_boucle=1:7
                set(maskbutton(var_boucle),'Enable','off')
            end
            figure(mask_fig), subplot(1,2,1)
            if Docircle
                h = imellipse;
                BW = createMask(h);
            else
                [x1,y1,BW,y2]=roipoly(ref{v});
            end
            maskint=uint8(BW);
            mask{v}=uint8(double(mask{v}).*double(maskint));
            
            colormap gray
            ref2((find(mask{v}==0)))=0;
            figure(mask_fig), subplot(1,2,2)
            imagesc(ref2),axis image
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
            subplot(1,2,1), imagesc(ref{v}),axis image
            if Docircle, title('CIRCLE ACITVATED','Color','w'); else, title('rectligne shape','Color','w');end
            mask{v}=ones(size(ref2,1),size(ref2,2));
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
            mask_save=1;
        end
        
        
    end
%function to get a reference image
    function get_reference_v3(obj,event)
        
        for v=1:2
        set(hand(1),'CloseRequestFcn','')
        arreter_ref = 0;
        time_image=1/frame_rate;
        
        trigger(vid{v});
        ref2=getdata(vid{v},1,'uint8');
        
        color_on = [ 0 0 0];
        
        %% graphical interface n�3
        ref_fig=figure('units','normalized',...
            'position',[0.15 0.1 0.8 0.8],...
            'numbertitle','off',...
            'name',['Online Mouse Tracking : Setting Parameters for cam' num2str(v)],...
            'menubar','none',...
            'tag','figure ref');
        set(ref_fig,'Color',color_on);
        set(ref_fig,'CloseRequestFcn',@fermeture_ref)
        
        uicontrol(ref_fig,'style','text', ...
            'units','normalized',...
            'position',[0.25 0.02 0.06 0.03],...
            'string','Online');
        
        uicontrol(ref_fig,'style','text', ...
            'units','normalized',...
            'position',[0.70 0.02 0.06 0.03],...
            'string','Reference');
        
        uicontrol(ref_fig,'style','pushbutton',...
            'units','normalized',...
            'position',[0.01 0.45 0.08 0.05],...
            'string','Multiple Ref',...
            'callback', @MultipleRef);
        
        uicontrol(ref_fig,'style','pushbutton',...
            'units','normalized',...
            'position',[0.01 0.55 0.08 0.05],...
            'string','Save delay 8s',...
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
                trigger(vid{v});
                ref2=getdata(vid{v},1,'uint8');
                
                colormap gray
                figure(ref_fig)
                subplot(1,2,1),imagesc(ref2)
                title(titleRef,'Color','w')
                axis image
            end
            t2=clock;
        end
        disp('Acquisition stopped');
        delete(ref_fig)
        end
        
        function save_refdelay(obj,event)
            for tit=1:2
                msg_box=msgbox([num2str(8-tit+1),'s before saving Refence_image'],'save','modal');
                pause(1);delete(msg_box)
            end
            trigger(vid);
            ref3=getdata(vid,1,'uint8');
            figure(ref_fig)
            subplot(1,2,2)
            imagesc(ref3)
            save_ref;
        end
        
        function save_ref(obj,event) % keep ref in memory
            renum=inputdlg('Which ref? 1 or 2');
            ref=ref2;
            disp('Refence_image saved');
            colormap gray
            figure(ref_fig)
            subplot(1,2,2)
            imagesc(ref)
            axis image
            save(['reference_image_',renum{1},'.mat'],'ref')
            save('InfoTrackingTemp.mat','ref','vid','-append');
            msg_box=msgbox(['ref saved in Refence_image_',renum{1},'.mat'],'save','modal');
            pause(0.5); delete(msg_box)
            set(hand(5),'Enable','on')
        end
        
        function fermeture_ref(obj,event)
            clear ref
            try,temp=load(['reference_image_1.mat'],'ref');ref{1}=temp.ref;end
            try,temp=load(['reference_image_2.mat'],'ref');ref{2}=temp.ref;end
            save('InfoTrackingTemp.mat','ref','-append');
            arreter_ref = 1;
        end
        
    end

%function to set the thresholds
    function gui_reglage_v4(obj,event)
        v=inputdlg('Which cage? 1 or 2');v=eval(v{1});
        global mask
        if size(ref)==0
            errordlg('Reference not found','Get a reference');
            error('Reference not found');
        end
        
        color_on = [ 0 0 0];
        
        arreter_gui = 0;
        
        trigger(vid{v})
        IM=getdata(vid{v},1,'uint8');
        [l1,l2] = size(IM);
        typical_size = sqrt(l1*l2);
        typical_rapport=5;
        BW_threshold2 = 0.4; %initialisation
        smaller_object_size2 = 130; %initialisation
        shape_ratio_2=4;
        %% Graphical interface n�4
        
        guireg_fig=figure('units','normalized',...
            'position',[0.15 0.1 0.8 0.8],...
            'numbertitle','off',...
            'name','Online Mouse Tracking : Setting Parameters',...
            'menubar','none',...
            'tag','figure reglage');
        set(guireg_fig,'Color',color_on);
        
        text1=uicontrol(guireg_fig,'style','text', ...
            'units','normalized',...
            'position',[0.7 0.85 0.05 0.03],...
            'string','seuil couleur');
        
        text2=uicontrol(guireg_fig,'style','text', ...
            'units','normalized',...
            'position',[0.9 0.85 0.05 0.03],...
            'string','seuil objets');
        
        text3=uicontrol(guireg_fig,'style','text', ...
            'units','normalized',...
            'position',[0.8 0.85 0.05 0.03],...
            'string','rapport axes');
        
        handles_gui(2)=uicontrol(guireg_fig,'style','pushbutton',...
            'units','normalized',...
            'position',[0.01 0.65 0.08 0.05],...
            'string','Save',...
            'tag','saving data',...
            'callback', @save_datas);
        
        
        handles_gui(3)=uicontrol(guireg_fig,'style','pushbutton',...
            'units','normalized',...
            'position',[0.01 0.04 0.08 0.05],...
            'string','Close',...
            'tag','fermeture reglage',...
            'callback', @fermeture_reglage);
        
        slider_seuil = uicontrol(guireg_fig,'style','slider',...
            'units','normalized','value',BW_threshold2,...
            'position',[0.7 0.1 0.05 0.7],...
            'callback', @seuil);
        
        slider_rapport = uicontrol(guireg_fig,'style','slider',...
            'units','normalized','value',shape_ratio_2/typical_rapport,...
            'position',[0.8 0.1 0.05 0.7],...
            'callback', @rapport);
        
        slider_small=uicontrol(guireg_fig,'style','slider',...
            'units','normalized','value',smaller_object_size2/typical_size,...
            'position',[0.9 0.1 0.05 0.7],...
            'callback', @elimination);
        
        text5=uicontrol(guireg_fig,'style','text', ...
            'units','normalized',...
            'position',[0.7 0.05 0.05 0.03],...
            'string',num2str(BW_threshold2));
        
        text6=uicontrol(guireg_fig,'style','text', ...
            'units','normalized',...
            'position',[0.9 0.05 0.05 0.03],...
            'string',num2str(smaller_object_size2));
        
        text4=uicontrol(guireg_fig,'style','text', ...
            'units','normalized',...
            'position',[0.8 0.05 0.05 0.03],...
            'string',num2str(shape_ratio_2));
        
        
        
        text8=uicontrol(guireg_fig,'style','text', ...
            'units','normalized',...
            'position',[0.8 0.0 0.05 0.03],...
            'string',num2str(0));
        
        
        time_image = 1/frame_rate;
        
        t1=clock;
        t2=clock;
        %% loop
        while(arreter_gui == 0)
            
            
            
            if etime(t2,t1)>time_image
                t1=clock;
                %Activate camera and take an image
                trigger(vid{v});
                %IM receives the image
                IM=getdata(vid{v},1,'uint8');
                
                %Substract reference image
                subimage = (ref{v}-IM);
                subimage(subimage<0)=0;
                subimage = uint8(double(subimage).*double(mask{v}));
                % Convert the resulting grayscale image into a binary image.
                diff_im = im2bw(subimage,BW_threshold2);
                % Remove all the objects less large than smaller_object_size
                diff_im = bwareaopen(diff_im,smaller_object_size2);
                %                 se = strel('disk',2);
                %                diff_im=imdilate(diff_im,se);
                
                % Label all the connected components in the image.
                bw = bwlabel(diff_im, 8); %
                
                % We get a set of properties for each labeled region.
                stats = regionprops( bw, 'Centroid','MajorAxisLength','MinorAxisLength','Area');
                centroids = cat(1, stats.Centroid);
                maj = cat(1, stats.MajorAxisLength);
                min = cat(1, stats.MinorAxisLength);
                rap=maj./min;
                goodind=find(rap<shape_ratio_2);
                centroids=centroids(goodind,:);
                
                %display video, mouse position and occupation map
                figure(guireg_fig)
                subplot(2,2,3)
                imagesc(bw)
                axis image
                hold on
                if size(centroids) == [1 2] % 1=number of centroids, 2= x and y position
                    plot(centroids(1),centroids(2), '-m+')
                    rapf=maj(goodind)/min(goodind);
                    set(text8,'string',num2str(rapf))
                    
                else
                    centroids = NaN;
                end
                hold off
                colormap gray
                figure(guireg_fig)
                subplot(2,2,1)
                imagesc(IM)
                axis image
                colormap gray
                hold on
                if size(centroids) == [1 2]
                    plot(centroids(1),centroids(2), '-m+')
                    
                else
                    centroids = NaN;
                end
                hold off
            end
            t2=clock;
            
        end
        
        disp('Acquisition stopped');
        delete(guireg_fig)
        
        
        
        
        function fermeture_reglage(obj,event)
            arreter_gui = 1;
            
        end
        
        %get threshold value
        function seuil(obj,event)
            
            BW_threshold2 = get( slider_seuil, 'value');
            set(text5,'string',num2str(BW_threshold2))
        end
        %get threshold value
        function elimination(obj,event)
            smaller_object_size2 = round(get(slider_small,'value')*typical_size);
            set(text6,'string',num2str(smaller_object_size2))
        end
        function rapport(obj,event)
            shape_ratio_2 = (get(slider_rapport,'value')*typical_rapport);
            set(text4,'string',num2str(shape_ratio_2))
        end
        function save_datas(obj,event)
            BW_threshold{v}=BW_threshold2;
            smaller_object_size{v}=smaller_object_size2;
            shape_ratio{v}=shape_ratio_2;
            save('InfoTrackingTemp.mat','BW_threshold','smaller_object_size','shape_ratio','-append');
            disp('thresholds saved')
            msg_box=msgbox('Thresholds saved','save','modal');
            pause(0.5); delete(msg_box)
        end
    end

end

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

%function called before displaying occupation map

function [numF,filename]=MultipleNosePoke(~,~)


%% INPUTS
colori={'g','r','c'};
scrsz = get(0,'ScreenSize');
% global
clear global fctPhase ListOfPhases folder_name 
clear global name_folder tempLoad imageRef MatSum
clear global Ratio_IMAonREAL OdorInfo ObjInfo maskobj
clear global WhereInFrames enableTrack 
global a
global vid
global name_folder
global tempLoad
global imageRef
%global OrderLabel
global Ratio_IMAonREAL
global enableTrack
%global MatSum
global intermed
global BW_threshold2;
global smaller_object_size2;
global shape_ratio2;
global n_AutoStop
global num_exp
global StartChrono
global tDeb
global guireg_fig
global countDown
intermed=load('InfoTrackingTemp.mat');
imageRef=intermed.ref;
vid=intermed.vid;
BW_threshold2=intermed.BW_threshold;
smaller_object_size2=intermed.smaller_object_size;
shape_ratio2=intermed.shape_ratio;
nPhase=NaN;
StartChrono=0;
% INITIATE
CircularObj=1; % 1 if object is circular
color_on = [ 0 0 0];    
color_off = [1 1 1];
frame_rate = 10;
prefac0=0;
num_exp=0;
% anoying problems
res=pwd;
if isempty(strfind(res,'/')),mark='\'; else  mark='/';end

t=clock;
jour=num2str(t(3));if length(jour)==1, jour=cat(2,'0',jour);end
mois=num2str(t(2));if length(mois)==1, mois=cat(2,'0',mois);end
annee=num2str(t(1));
TodayIs=[jour mois annee];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% graphical interface nï¿½1 with all the pushbuttons

 Fig_Odor=figure('units','normalized','position',[0.1 0.1 0.4 0.85],...
            'numbertitle','off','name','NosePOKE','menubar','none','tag','figure Odor');
        set(Fig_Odor,'Color',color_on);
        
        maskbutton(1)= uicontrol(Fig_Odor,'style','pushbutton',...
            'units','normalized','position',[0.01 0.85 0.2 0.05],...
            'string','1- INPUTS EXPE','callback', @giv_inputs);
        set(maskbutton(1),'enable','on','FontWeight','bold')
        
        maskbutton(2)= uicontrol(Fig_Odor,'style','pushbutton',...
            'units','normalized','position',[0.01 0.6 0.2 0.05],...
            'string','2- Real Distance','callback', @Real_distance);
        set(maskbutton(2),'enable','off')
        
        maskbutton(3)= uicontrol(Fig_Odor,'style','pushbutton',...
            'units','normalized','position',[0.85 0.05 0.1 0.05],'string','+1 STIM');
        set(maskbutton(3),'enable','off')
        
        maskbutton(4)= uicontrol(Fig_Odor,'style','pushbutton',...
            'units','normalized','position',[0.01 0.37 0.2 0.05],'string','4- START trial');
        set(maskbutton(4),'enable','off','callback', @StartTrial)
        
        maskbutton(5)= uicontrol(Fig_Odor,'style','pushbutton',...
            'units','normalized','position',[0.01 0.52 0.2 0.05],...
            'string','3- START EXPE','callback', @start_Expe);
        set(maskbutton(5),'enable','off')
  
        maskbutton(6)= uicontrol(Fig_Odor,'style','pushbutton',...
            'units','normalized','position',[0.025 0.21 0.15 0.03],...
            'string','REstart Trial','callback', @Restart_Phase);
        set(maskbutton(6),'enable','off')
        
        maskbutton(7)= uicontrol(Fig_Odor,'style','pushbutton',...
            'units','normalized','position',[0.025 0.26 0.15 0.03],...
            'string','Stop Emergency','callback', @stop_Phase);
        set(maskbutton(7),'enable','off')
        
        maskbutton(8)= uicontrol(Fig_Odor,'style','pushbutton',...
            'units','normalized','position',[0.01 0.1 0.2 0.05],...
            'string','CLOSE EXPE','callback', @quit);
        set(maskbutton(8),'enable','on','FontWeight','bold')
        
        maskbutton(9)= uicontrol(Fig_Odor,'style','pushbutton','units','normalized','position',[0.75 0.95 0.2 0.03],...
            'string','PERMUTATION CONFIG','callback', @PermutConfig);
        set(maskbutton(9),'enable','on','FontWeight','bold')
        
        maskbutton(10)= uicontrol(Fig_Odor,'style','pushbutton',...
            'units','normalized','position',[0.75 0.05 0.05 0.03],'string','-1 !');
        set(maskbutton(10),'enable','off')
        
        inputDisplay(1)=uicontrol(Fig_Odor,'style','text','units','normalized','position',[0.25 0.5 0.5 0.02],'string','Filename = TO DEFINE','FontSize',10);
        inputDisplay(3)=uicontrol(Fig_Odor,'style','text','units','normalized','position',[0.7 0.01 0.3 0.02],'string','Nb stim= 0 ');
        inputDisplay(6)=uicontrol(Fig_Odor,'style','text','units','normalized','position',[0.01 0.47 0.16 0.02],'string','Trial','FontSize',12);
        inputDisplay(7)=uicontrol(Fig_Odor,'style','text','units','normalized','position',[0.01 0.45 0.16 0.02],'string','WAIT','FontSize',12);
        inputDisplay(8)=uicontrol(Fig_Odor,'style','text','units','normalized','position',[0.01 0.92 0.2 0.02],'string','TASK = ?','FontSize',12);
        inputDisplay(9)=uicontrol(Fig_Odor,'style','text','units','normalized','position',[0.01 0.7 0.16 0.12],'string','ListOfTrial = ?','FontSize',10);
        
        for bi=[1,3,6:9], set(inputDisplay(bi),'BackgroundColor',color_on,'ForegroundColor','w','FontWeight','bold');end
        
        chronoshow=uicontrol('style','edit', 'units','normalized','position',[0.01 0.3 0.1 0.05],...
            'string',num2str(floor(0)),'ForegroundColor','g','BackgroundColor','k','FontSize',14);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CALLED FUNCTIONS

% -----------------------------------------------------------------
%% function to quit the programm
    function quit(obj,event)
        enableTrack=0;
        try close(guireg_fig);end
        delete(Fig_Odor)
    end

% -----------------------------------------------------------------
%% function to quit the programm
    function PermutConfig(obj,event)
        Names_config={'A','B','C','D'};
        nb_config=length(Names_config);
        disp('Random Permutations for 4 couples')
        for cc=1:4
            disp(Names_config(randperm(nb_config)))
        end
    end
% -----------------------------------------------------------------
%% Ask for all inputs and display
    function giv_inputs(obj,event)
        try 
            temp=load('default_answer.mat','default_answer'); default_answer=temp.default_answer;
        end
        
        if ~exist('default_answer','var') || (exist('default_answer','var') && length(default_answer)~=6)
            default_answer={'100','ABCD','300','10','4','1'};
        end
        answer = inputdlg({'NumberMouse','Order config','Length Trial (s)','Count down(s)','Nb of Trials','Start at Trial'},'INFO',1,default_answer);
        default_answer=answer; save default_answer default_answer
        lengthPhase=str2num(answer{3});
        nPhase=str2num(answer{5});
        startphase=str2num(answer{6});
        countDown=str2num(answer{4});
        orderRef=[];
        for nn=1:nPhase
            orderRef=[orderRef,{answer{2}(nn)}];
            namePhase{nn}=['Trial',num2str(nn),'-config',answer{2}(nn)];
        end
        nameTASK='MNT1';
        nmouse=str2num(answer{1});
        
        set(inputDisplay(8),'string',['TASK = ',nameTASK]); 
        set(inputDisplay(9),'string',['Trials:',{' '},namePhase]);
        
        if exist('Ratio_IMAonREAL','var') && ~isempty(Ratio_IMAonREAL)
            set(maskbutton(5),'enable','on','FontWeight','bold')
            set(maskbutton(2),'enable','on','FontWeight','normal','string','2- Real Distance (OK)')
        else
            set(maskbutton(2),'enable','on','FontWeight','bold')
        end
        
        disp(' ');disp('-------------------- New Expe ---------------------');
        save([res,mark,'TempNosePokeON.mat'],'nmouse','nPhase','namePhase','lengthPhase','nameTASK','imageRef','orderRef','startphase');
        set(maskbutton(1),'FontWeight','normal','string','1- INPUTS EXPE (OK)');
    end

% -----------------------------------------------------------------
%% Ask for all inputs and display
    function Real_distance(obj,event)
        
        figure(Fig_Odor), subplot(2,1,1), 
        imagesc(imageRef); colormap gray; axis image
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
       
        title(' do 2-')
        hold on, line([10 20]*Ratio_IMAonREAL,[10 10],'Color','k','Linewidth',3)
        text(15*Ratio_IMAonREAL,15,'10 cm','Color','k')
        
        set(maskbutton(5),'enable','on','FontWeight','bold') 
        set(maskbutton(2),'enable','on','FontWeight','normal','string','2- Real Distance (OK)')
        Ratio_IMAonREAL=Ratio_IMAonREAL;
        save([res,mark,'TempNosePokeON.mat'],'-append','Ratio_IMAonREAL');
    end

% -----------------------------------------------------------------
%% Interface of analysis
    function start_Expe(obj,event)
        enableTrack=1;
        templaod=load([res,mark,'TempNosePokeON.mat']);
        orderRef=templaod.orderRef;
        tempstartphase=templaod.startphase;
        num_exp=0;
        num_phase=tempstartphase-1;
        StartChrono=0;
        prefix=['OPTO-Mouse-' num2str(templaod.nmouse) '-' TodayIs '-'];
        
        set(maskbutton(5),'enable','on','FontWeight','normal','string','3- START EXPE (OK)')
        
        for nn=tempstartphase:templaod.nPhase
            if enableTrack
                num_phase=num_phase+1;
                startphase=num_phase;
                
                n_AutoStop=templaod.lengthPhase;
                set(inputDisplay(6),'string',['Trial ',num2str(nn),' :'])
                set(inputDisplay(7),'string','WAIT for start');
                
                % create folder to save tracking and analysis
                % ----------------------
                prefac=num2str(num_phase);
                if length(prefac)==1, prefac=cat(2,'0',prefac);end
  
                try
                    name_folder = [prefix prefac '-' templaod.nameTASK{:} templaod.namePhase{nn}]; 
                catch
                    name_folder = [prefix prefac '-' templaod.nameTASK templaod.namePhase{nn}];
                end
                
                while exist(name_folder,'file')
                    name_folder=[name_folder,'0'];
                end
                mkdir(name_folder);
                disp(name_folder)
                
                set(inputDisplay(1),'string',name_folder);
                tempLoadR=load(['reference_image_',templaod.namePhase{nn}(end),'.mat'],'ref');
                imageRef=tempLoadR.ref;
                % save info in NosePokeON
                % ----------------------
                save([res,mark,'TempNosePokeON.mat'],'-append','imageRef','Ratio_IMAonREAL','name_folder','n_AutoStop','startphase')
                pause(0.1)
                StartChrono=0;
                
                % regler arduino
                button = questdlg({['Arduino bien reglé Config ',orderRef{num_phase},'? - "No"  vous permet de le régler']});
                while size(button,2)==2
                    fclose(a);
                    button = questdlg({['Réglez l''Arduino Config ',orderRef{num_phase},'- Arduino bien reglé? - "No"  vous permet de le régler']});
                end
                button=0;
                if size(a.Status,2)==6
                    fopen(a);
                end
                set(maskbutton(4),'enable','on','FontWeight','bold')
                Track_sniff;
            end
        end
        set(maskbutton(5),'enable','off','FontWeight','normal','string','3- START EXPE')
        set(maskbutton(1),'enable','on','FontWeight','bold','string','1- INPUTS EXPE')
        set(maskbutton(4),'enable','off')
        if enableTrack
            set(inputDisplay(6),'string','END of the')
            set(inputDisplay(7),'string','experiment')
        end
    end

% -----------------------------------------------------------------
%% track mouse
    function Track_sniff(obj,event)
        
        set(chronoshow,'string',num2str(0));
        num_exp=num_exp+1;
        disp('   Begining tracking...')
        guireg_fig=OnlineGuiReglage;
        set(maskbutton(3),'callback',@CountNosePoke);
        set(maskbutton(10),'callback',@CancelCount);
        % -------------------
        % reload everything
        tempLoad=load([res,mark,'TempNosePokeON.mat']);
        %         oneZoneOdor(oneZoneOdor>1)=1;
        imageRef=tempLoad.imageRef;
        Ratio_IMAonREAL=tempLoad.Ratio_IMAonREAL;
        n_AutoStop=tempLoad.n_AutoStop;
        name_folder=tempLoad.name_folder;
        
        % -------------------
        % display zone
        
        figure(Fig_Odor), subplot(2,1,1),
        htrack = imagesc(imageRef);axis image;
        line([10 20]*Ratio_IMAonREAL,[10 10],'Color','k','Linewidth',3)
        text(15*Ratio_IMAonREAL,15,'10 cm','Color','k')
        title('ACQUISITION ON')
        g=plot(0,0,'m+');
        
        figure(Fig_Odor), subplot(2,1,2),
        htrack2 = imagesc(zeros(size((imageRef))));axis image;caxis([0 1])
        xlabel('tracking online','Color','w')
        
        % display chrono
        time_image = 1/frame_rate;
        
        
        % -----------------------------------------------------------------
        % ---------------------- INITIATE TRACKING ------------------------
        n=1;
        num_fr=1;
        
        prefac0=char; for ii=1:4-length(num2str(num_exp)), prefac0=cat(2,prefac0,'0'); end
        Fname=['F' TodayIs '-' prefac0 num2str(num_exp)];
        mkdir([name_folder mark Fname]);
        disp(['   ',Fname]);
        
        PosMat=[];
        NbStim=0; set(inputDisplay(3),'string',['Nb stim = ',num2str(NbStim)])
        %tDeb = clock; timeDeb = tDeb(4)*60*60+tDeb(5)*60+tDeb(6);
        while enableTrack
            % ---------------------------------------------------------
            % update chrono
            t1 = clock;
            if StartChrono
                chrono=etime(t1,tDeb);
                set(chronoshow,'string',[num2str(floor(chrono)),'/',num2str(n_AutoStop)]);
            end
            %Active la camï¿½ra et Envoie l'image dans le workspace
            %trigger(vid);
            IM=getsnapshot(vid);
            set(htrack,'Cdata',IM);
            
            % ---------------------------------------------------------
            % --------------------- TREAT IMAGE -----------------------
            % Substract reference image
            subimage = (imageRef-IM);
            subimage = uint8(double(subimage).*double(intermed.mask));
            
            % Convert the resulting grayscale image into a binary image.
            diff_im = im2bw(subimage,BW_threshold2);
            % Remove all the objects less large than smaller_object_size
            diff_im = bwareaopen(diff_im,smaller_object_size2);
            % Label all the connected components in the image.
            bw = logical(diff_im); %CHANGED
            
            % ---------------------------------------------------------
            % --------------------- FIND MOUSE ------------------------
            % We get a set of properties for each labeled region.
            stats = regionprops( bw, 'Centroid','MajorAxisLength','MinorAxisLength');
            centroids = cat(1, stats.Centroid);
            maj = cat(1, stats.MajorAxisLength);
            mini = cat(1, stats.MinorAxisLength);
            rap=maj./mini;
            centroids=centroids(rap<shape_ratio2,:); %CHANGED
            
            % ---------------------------------------------------------
            % display video, mouse position and save in posmat
            set(htrack2,'Cdata',diff_im);
            if StartChrono
                if size(centroids) == [1 2]
                    set(g,'Xdata',centroids(1),'YData',centroids(2))
                    PosMat(num_fr,1)=chrono;
                    PosMat(num_fr,2)=centroids(1);
                    PosMat(num_fr,3)=centroids(2);
                    
                else
                    set(g,'Xdata',0,'YData',0)
                    PosMat(num_fr,:)=[chrono;NaN;NaN];
                end
                num_fr=num_fr+1;
                % ---------------------------------------------------------
                % --------------------- SAVE FRAMES -----------------------
                %hold off
                %datas.image = IM;
                datas.image =  uint8(double(IM));
                datas.time = t1;
                
                % save frame
                prefac1=char; for ii=1:6-length(num2str(n)), prefac1=cat(2,prefac1,'0');end
                save([ name_folder mark Fname mark 'frame' prefac1 sprintf('%0.5g',n)],'datas');
                n = n+1;
                
                
            end
            % count nosepoke
            
            t2 = clock;
            if StartChrono
                if etime(t2,tDeb)> n_AutoStop+0.5
                    enableTrack=0;
                end
                if (etime(t2,tDeb)> n_AutoStop-10) && (etime(t2,tDeb)< n_AutoStop-10+3*time_image)
                    set(Fig_Odor,'Color','b');
                    for bi=[1,3,6:9], set(inputDisplay(bi),'BackgroundColor','b');end
                end
            end
            pause(time_image-etime(t2,t1));
        end
        
        try 
            if etime(t2,tDeb)> n_AutoStop+0.5, enableTrack=1;end
        end
        disp(['Nb stim =',num2str(floor(NbStim*10)/10)])
        disp(['Length Trial = ',num2str(floor(etime(t2,tDeb))),'s'])
        
        try fwrite(a,6);disp('Arduino OFF');end
        %         %ask number of sniff
        %         answer = inputdlg({'Nb sniff VARIANT','Nb sniff FIXED'},'Enter number of sniffs',1,{'0','0'});
        %         Nsniff=[2,str2num(answer{1}); 3,str2num(answer{2})];
        %
        msg_box=msgbox('Saving NosePoke and InfoTracking','save','modal');
        save([name_folder,mark,Fname,mark,'PosMat.mat'],'PosMat');
        save([res,mark,'InfoTrackingTemp.mat'],'-append','PosMat','frame_rate');
        save([res,mark,'TempNosePokeON.mat'],'-append','NbStim');
        pause(0.5)
        try copyfile([res,mark,'TempNosePokeON.mat'],[name_folder,mark,'NosePokeON.mat']); catch; keyboard;end
        try copyfile([res,mark,'InfoTrackingTemp.mat'],[name_folder,mark,'InfoTracking.mat']); catch; keyboard;end
        pause(0.5)
        try copyfile([name_folder,mark,'InfoTracking.mat'],[name_folder,mark,Fname,mark,'InfoTracking.mat']);end
        try copyfile([name_folder,mark,'NosePokeON.mat'],[name_folder,mark,Fname,mark,'NosePokeON.mat']);end
        
        try
            close(guireg_fig)
            set(Fig_Odor,'Color',color_on);
            for bi=[1,3,6:9], set(inputDisplay(bi),'BackgroundColor',color_on);end
            for bit=1:2
                set(maskbutton(bit),'enable','on','FontWeight','bold')
            end
            delete(msg_box)
            set(maskbutton(3),'enable','off','FontWeight','normal')
            set(maskbutton(10),'enable','off','FontWeight','normal')
            set(maskbutton(7),'enable','off','FontWeight','normal')
            set(maskbutton(4),'enable','on','FontWeight','bold')
        end
        
        % -------------------------------------------------------
        % CountNosePoke
        function CountNosePoke(obj,event)
            NbStim=NbStim+1;
            set(inputDisplay(3),'string',['Nb stim = ',num2str(NbStim)])
            if NbStim==6
                n_AutoStop=floor(etime(t2,tDeb)+5);
                set(maskbutton(3),'enable','off')
                set(Fig_Odor,'Color','b');
                for bi=[1,3,6:9], set(inputDisplay(bi),'BackgroundColor','b');end
            end
        end
        % -------------------------------------------------------
        % CountNosePoke
        function CancelCount(obj,event)
            if NbStim==6
                n_AutoStop=tempLoad.n_AutoStop;
                set(maskbutton(3),'enable','on','FontWeight','bold')
                set(Fig_Odor,'Color',color_on);
                for bi=[1,3,6:9], set(inputDisplay(bi),'BackgroundColor',color_on);end
            end
            NbStim=NbStim-1;
            set(inputDisplay(3),'string',['Nb stim = ',num2str(NbStim)])
            
        end
        
    end

% -----------------------------------------------------------------
%% StartTrial
    function StartTrial(obj,event)
        
        %enableTrack=1;
        set(inputDisplay(7),'string','RECORDING');
        set(maskbutton(7),'enable','on','FontWeight','bold')
        set(maskbutton(3),'enable','on','FontWeight','bold')
        set(maskbutton(10),'enable','on','FontWeight','bold')
        set(maskbutton(4),'enable','off','FontWeight','normal')
        % interface
        msg_box=msgbox([num2str(countDown),'s to place the mouse'],'WAIT','modal');
        pause(countDown)
        try delete(msg_box);end
        fwrite(a,5);disp('Arduino ON');
        StartChrono=1;
        tDeb = clock;
    end

% -----------------------------------------------------------------
%% stop tracking
    function stop_Phase(obj,event)
        figure(Fig_Odor), subplot(2,1,1), title('ACQUISITION STOPPED')
        enableTrack=0;
        set(maskbutton(4),'enable','off','FontWeight','normal')
        set(maskbutton(6),'enable','on','FontWeight','bold')
        set(maskbutton(7),'enable','off','FontWeight','normal')
        set(maskbutton(3),'enable','off','FontWeight','normal')
        set(maskbutton(10),'enable','on','FontWeight','bold')
        try fwrite(a,6);disp('Arduino OFF');end
    end

% -----------------------------------------------------------------
%% stop tracking
    function Restart_Phase(obj,event)
        set(maskbutton(4),'enable','on','FontWeight','bold')
        set(maskbutton(7),'enable','on','FontWeight','bold')
        set(maskbutton(6),'enable','off','FontWeight','normal')
        templaod=load([res,mark,'TempNosePokeON.mat']);
        enableTrack=1;
        start_Expe;
    end



% -----------------------------------------------------------------
%% OnlineGuiReglage
    function guireg_fig=OnlineGuiReglage(obj,event);
        
        % function guireg_fig=OnlineGuiReglage(obj,event);
        % let online control of paramteres for image treatments
        
        if ~exist('typical_size','var'), typical_size=300;end
        typical_rapport=10;
        
        guireg_fig=figure('units','normalized',...
            'position',[0.1 0.1 0.15 0.6],...
            'numbertitle','off',...
            'name','Online Mouse Tracking : Setting Parameters',...
            'menubar','none',...
            'tag','figure reglage');
        set(guireg_fig,'Color',color_on);
        
        hand(2)=uicontrol(guireg_fig,'style','pushbutton',...
            'units','normalized',...
            'position',[0.01 0.9 0.8 0.05],...
            'string','Stop for Manual Inputs',...
            'tag','init',...
            'callback', @enterManual);
        
        text1=uicontrol(guireg_fig,'style','text', ...
            'units','normalized',...
            'position',[0.05 0.85 0.25 0.03],...
            'string','seuil couleur');
        
        text2=uicontrol(guireg_fig,'style','text', ...
            'units','normalized',...
            'position',[0.4 0.85 0.25 0.03],...
            'string','seuil objets');
        
        text3=uicontrol(guireg_fig,'style','text', ...
            'units','normalized',...
            'position',[0.7 0.85 0.25 0.03],...
            'string','rapport axes');
        
        slider_seuil = uicontrol(guireg_fig,'style','slider',...
            'units','normalized',...
            'position',[0.05 0.1 0.15 0.7],...
            'callback', @seuil);
        set(slider_seuil,'Value',BW_threshold2);
        
        slider_small=uicontrol(guireg_fig,'style','slider',...
            'units','normalized',...
            'position',[0.4 0.1 0.15 0.7],...
            'callback', @elimination);
        set(slider_small,'Value',smaller_object_size2/typical_size);
        
        slider_rapport = uicontrol(guireg_fig,'style','slider',...
            'units','normalized',...
            'position',[0.7 0.1 0.15 0.7],...
            'callback', @rapport);
        set(slider_rapport,'Value',shape_ratio2/typical_rapport);
        
        
        text5=uicontrol(guireg_fig,'style','text', ...
            'units','normalized',...
            'position',[0.05 0.05 0.25 0.03],...
            'string',num2str(BW_threshold2));
        
        
        text6=uicontrol(guireg_fig,'style','text', ...
            'units','normalized',...
            'position',[0.4 0.05 0.25 0.03],...
            'string',num2str(smaller_object_size2));
        
        
        text4=uicontrol(guireg_fig,'style','text', ...
            'units','normalized',...
            'position',[0.7 0.05 0.25 0.03],...
            'string',num2str(shape_ratio2));
        
        
        
        function seuil(obj,event)
            
            BW_threshold2 = get(slider_seuil, 'value');
            set(text5,'string',num2str(BW_threshold2))
            disp([' New BW_threshold=',num2str(BW_threshold2)])
        end
        %get threshold value
        function elimination(obj,event)
            smaller_object_size2 = round(get(slider_small,'value')*typical_size);
            set(text6,'string',num2str(smaller_object_size2))
            disp(['   New smaller_object_size=',num2str(smaller_object_size2)])
        end
        function rapport(obj,event)
            shape_ratio2 = (get(slider_rapport,'value')*typical_rapport);
            set(text4,'string',num2str(shape_ratio2))
            disp(['     New shape_ratio=',num2str(shape_ratio2)])
        end
        
        function enterManual(obj,event)
            defAns={num2str(BW_threshold2) num2str(smaller_object_size2) num2str(shape_ratio2)};
            prompt = {'BW_threshold','smaller_object_size','shape_ratio'};
            dlg_title = 'Change parameters for offline tracking:';
            answer = inputdlg(prompt,dlg_title,1,defAns);
            BW_threshold2=str2num(answer{1});
            smaller_object_size2=str2num(answer{2});
            shape_ratio2=str2num(answer{3});
            
            set(slider_seuil,'Value',BW_threshold2);
            set(slider_small,'Value',smaller_object_size2/typical_size);
            set(slider_rapport,'Value',shape_ratio2/typical_rapport);
        end
    end

end

function [numF,filename]=FreezingOnline(~,~)

%% INPUTS
% global
clear global name_folder imageRef Ratio_IMAonREAL 
clear global enableTrack intermed
global a
global vid
global name_folder
global imageRef
global Ratio_IMAonREAL
global enableTrack
global intermed

global BW_threshold2;
global smaller_object_size2;
global shape_ratio2;
global Count_Freez

global n_AutoStop
global num_exp
global StartChrono
global tDeb
global guireg_fig
global countDown
global t_ON
global t_OFF

intermed=load('InfoTrackingTemp.mat');
imageRef=intermed.ref;
vid=intermed.vid;
BW_threshold2=intermed.BW_threshold;
smaller_object_size2=intermed.smaller_object_size;
shape_ratio2=intermed.shape_ratio;
b_default=intermed.b_default;
c_default=intermed.c_default;
e_default=intermed.e_default;

nPhase=NaN;
StartChrono=0;
% INITIATE
color_on = [ 0 0 0];    
color_off = [1 1 1];
colori={'g','r','c'};
scrsz = get(0,'ScreenSize');
frame_rate = 8;
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
%% graphical interface n�1 with all the pushbuttons

 Fig_Odor=figure('units','normalized','position',[0.1 0.1 0.4 0.85],...
            'numbertitle','off','name','NosePOKE','menubar','none','tag','figure Odor');
        set(Fig_Odor,'Color',color_on);
        
        maskbutton(1)= uicontrol(Fig_Odor,'style','pushbutton',...
            'units','normalized','position',[0.01 0.89 0.2 0.05],...
            'string','1- INPUTS EXPE','callback', @giv_inputs);
        set(maskbutton(1),'enable','on','FontWeight','bold')
        
        maskbutton(2)= uicontrol(Fig_Odor,'style','pushbutton',...
            'units','normalized','position',[0.01 0.73 0.2 0.05],...
            'string','2- Real Distance','callback', @Real_distance);
        set(maskbutton(2),'enable','off')
        
        maskbutton(3)= uicontrol(Fig_Odor,'style','pushbutton',...
            'units','normalized','position',[0.85 0.05 0.1 0.05],'string','Freezing');
        set(maskbutton(3),'enable','off')
        
        maskbutton(4)= uicontrol(Fig_Odor,'style','pushbutton',...
            'units','normalized','position',[0.01 0.48 0.2 0.05],'string','4- START session');
        set(maskbutton(4),'enable','off','callback', @StartSession)
        
        maskbutton(5)= uicontrol(Fig_Odor,'style','pushbutton',...
            'units','normalized','position',[0.01 0.64 0.2 0.05],...
            'string','3- START EXPE','callback', @start_Expe);
        set(maskbutton(5),'enable','off')
  
        maskbutton(6)= uicontrol(Fig_Odor,'style','pushbutton',...
            'units','normalized','position',[0.025 0.31 0.15 0.03],...
            'string','REstart Session','callback', @Restart_Phase);
        set(maskbutton(6),'enable','off')
        
        maskbutton(7)= uicontrol(Fig_Odor,'style','pushbutton',...
            'units','normalized','position',[0.025 0.36 0.15 0.03],...
            'string','Stop Emergency','callback', @stop_Phase);
        set(maskbutton(7),'enable','off')
        
        maskbutton(8)= uicontrol(Fig_Odor,'style','pushbutton',...
            'units','normalized','position',[0.01 0.03 0.2 0.05],...
            'string','CLOSE EXPE','callback', @quit);
        set(maskbutton(8),'enable','on','FontWeight','bold')
        
        inputDisplay(1)=uicontrol(Fig_Odor,'style','text','units','normalized','position',[0.25 0.55 0.5 0.02],'string','Filename = TO DEFINE','FontSize',10);
        inputDisplay(3)=uicontrol(Fig_Odor,'style','text','units','normalized','position',[0.7 0.01 0.3 0.02],'string','Time freezing = 0 ');
        inputDisplay(6)=uicontrol(Fig_Odor,'style','text','units','normalized','position',[0.01 0.59 0.16 0.02],'string','Session','FontSize',12);
        inputDisplay(7)=uicontrol(Fig_Odor,'style','text','units','normalized','position',[0.01 0.56 0.16 0.02],'string','WAIT','FontSize',12);
        inputDisplay(8)=uicontrol(Fig_Odor,'style','text','units','normalized','position',[0.01 0.95 0.2 0.02],'string','TASK = ?','FontSize',10);
        inputDisplay(9)=uicontrol(Fig_Odor,'style','text','units','normalized','position',[0.01 0.81 0.16 0.06],'string','ListOfSession = ?','FontSize',10);
        
        for bi=[1,3,6:9], set(inputDisplay(bi),'BackgroundColor',color_on,'ForegroundColor','w','FontWeight','bold');end
        
        chronoshow=uicontrol('style','edit', 'units','normalized','position',[0.01 0.4 0.1 0.05],...
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
%% Ask for all inputs and display
    function giv_inputs(obj,event)
        try 
            temp=load('default_answer.mat','default_answer'); default_answer=temp.default_answer;
        end
        
        if ~exist('default_answer','var') || (exist('default_answer','var') && length(default_answer)~=6)
            default_answer={'100','CS+','15','5','2','1'};
        end
        answer = inputdlg({'NumberMouse','Name Session','Length session (min)','Thresh immobility (mm)','Drop intervals (s)','Smooth Factor'},'INFO',1,default_answer);
        default_answer=answer; save default_answer default_answer
        
        nmouse=str2num(answer{1});
        namePhase=answer(2);
        lengthPhase=str2num(answer{3})*60;
        nPhase=1;
        startphase=1;
        countDown=0;
        
        th_immob=str2num(answer{4});
        thtps_immob=str2num(answer{5});
        SmoothFact=str2num(answer{6});
        
        nameTASK='FearConditioning';
        
        set(inputDisplay(8),'string',['TASK = ',nameTASK]); 
        set(inputDisplay(9),'string',['Sessions:',{' '},namePhase]);
        
        if exist('Ratio_IMAonREAL','var') && ~isempty(Ratio_IMAonREAL)
            set(maskbutton(5),'enable','on','FontWeight','bold')
            set(maskbutton(2),'enable','on','FontWeight','normal','string','2- Real Distance (OK)')
        else
            set(maskbutton(2),'enable','on','FontWeight','bold')
        end
        
        disp(' ');disp('-------------------- New Expe ---------------------');
        save([res,mark,'TempFreezeON.mat'],'nmouse','nPhase','namePhase','lengthPhase','nameTASK','imageRef','startphase');
        save([res,mark,'TempFreezeON.mat'],'-append','th_immob','thtps_immob','SmoothFact');
        set(maskbutton(1),'FontWeight','normal','string','1- INPUTS EXPE (OK)');
    end

% -----------------------------------------------------------------
%% Ask for all inputs and display
    function Real_distance(obj,event)
        
        figure(Fig_Odor), subplot(5,1,1:2), 
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
        save([res,mark,'TempFreezeON.mat'],'-append','Ratio_IMAonREAL');
    end

% -----------------------------------------------------------------
%% Interface of analysis
    function start_Expe(obj,event)
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
                % save info in NosePokeON
                % ----------------------
                save([res,mark,'TempFreezeON.mat'],'-append','imageRef','Ratio_IMAonREAL','name_folder','n_AutoStop','startphase')
                pause(0.1)
                StartChrono=0;
                
                if size(a.Status,2)==6
                    fopen(a);
                end
                set(maskbutton(4),'enable','on','FontWeight','bold')
                Track_Freeze;
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
    function Track_Freeze(obj,event)
        Count_Freez=0; set(chronoshow,'string',num2str(0));
        num_exp=num_exp+1;
        disp('   Begining tracking...')
        guireg_fig=OnlineGuiReglage;
        set(maskbutton(3),'callback',@Count_Freezing);
        % -------------------
        % reload everything
        tempLoad=load([res,mark,'TempFreezeON.mat']);
        imageRef=tempLoad.imageRef;
        Ratio_IMAonREAL=tempLoad.Ratio_IMAonREAL;
        th_immob=tempLoad.th_immob;
        thtps_immob=tempLoad.thtps_immob;
        n_AutoStop=tempLoad.n_AutoStop;
        name_folder=tempLoad.name_folder;
        
        % -------------------
        % display zone
        
        figure(Fig_Odor), subplot(5,1,1:2),
        htrack = imagesc(imageRef);axis image;
        line([10 20]*Ratio_IMAonREAL,[10 10],'Color','k','Linewidth',3)
        text(15*Ratio_IMAonREAL,15,'10 cm','Color','k')
        title('ACQUISITION ON')
        g=plot(0,0,'m+');
        
        figure(Fig_Odor), subplot(5,1,3:4),
        htrack2 = imagesc(zeros(size((imageRef))));axis image;caxis([0 1])
        xlabel('tracking online','Color','w')
        
        immob_val=0; 
        figure(Fig_Odor), subplot(5,1,5)
        PlotFreez=plot(0,0,'-b');
        hold on, line([1,n_AutoStop],[1 1]*th_immob,'Color','r')
        xlim([0,n_AutoStop]); xlabel('freezing online','Color','w')
        
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
        TimeFreez=0; set(inputDisplay(3),'string',['Time Freezing: ',num2str(floor(TimeFreez*10)/10),' s'])
        %tDeb = clock; timeDeb = tDeb(4)*60*60+tDeb(5)*60+tDeb(6);
        clear image_temp
        while enableTrack
            % ---------------------------------------------------------
            % update chrono
            t1 = clock;
            if StartChrono
                chrono=etime(t1,tDeb);
                set(chronoshow,'string',[num2str(floor(chrono)),'/',num2str(n_AutoStop)]);
            end
            %Active la cam�ra et Envoie l'image dans le workspace
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
            % --------------------- FREEZING -----------------------
            
            try
                immob_IM = bw - image_temp;
                immob_val(num_fr)=sqrt(sum(sum(((immob_IM).*(immob_IM)))));
           
            end
            image_temp=bw;
            
            % count Freezing
            if Count_Freez 
                set(inputDisplay(3),'string',['Time Freezing: ',num2str(floor((TimeFreez+etime(t1,t_ON))*10)/10),' s'])
            end
            % ---------------------------------------------------------
            

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
%                 figure(Fig_Odor), subplot(5,1,5), hold on,
%                 plot(chrono,immob_val(num_fr),'.b'); 
                try set(PlotFreez,'Xdata',PosMat(1:num_fr,1),'YData',immob_val(1:num_fr));end
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
            if StartChrono && etime(t2,tDeb)> n_AutoStop+0.5
                enableTrack=0;
                if Count_Freez 
                    Count_Freez=0;
                    t_OFF=clock; 
                    TimeFreez=TimeFreez+etime(t_OFF,t_ON);
                end
            end
%                 if StartChrono && (etime(t2,tDeb)> n_AutoStop-10) && (etime(t2,tDeb)< n_AutoStop-10+3*time_image)
%                     set(Fig_Odor,'Color','b');
%                     for bi=[1,3,6:9], set(inputDisplay(bi),'BackgroundColor','b');end
%                 end
            pause(time_image-etime(t2,t1));
            %pause(0.01)
        end
        
        % if no stopemergency, ready to start next phase
        try 
            if etime(t2,tDeb)> n_AutoStop+0.5, enableTrack=1;end
        end
        try fwrite(a,6);disp('Arduino OFF');end
        
        % calculate freezing
        disp(['Time Freezing =',num2str(floor(TimeFreez*10)/10)])
        immob_time=PosMat(:,1);
        Movtsd=tsd(immob_time*1E4',SmoothDec(immob_val',1));
        Freeze=thresholdIntervals(Movtsd,th_immob,'Direction','Below');
        Freeze2=dropShortIntervals(Freeze,thtps_immob*1E4);
        
        
        % save and copy file in save_folder
        msg_box=msgbox('Saving FreezeON and InfoTracking','save','modal');
        save([name_folder,mark,Fname,mark,'PosMat.mat'],'PosMat');
        save([res,mark,'InfoTrackingTemp.mat'],'-append','PosMat','frame_rate');
        save([res,mark,'TempFreezeON.mat'],'-append','TimeFreez','Movtsd','Freeze','Freeze2');
        pause(0.5)
        try copyfile([res,mark,'TempFreezeON.mat'],[name_folder,mark,'FreezeON.mat']); catch; keyboard;end
        try copyfile([res,mark,'InfoTrackingTemp.mat'],[name_folder,mark,'InfoTracking.mat']); catch; keyboard;end
        pause(0.5)
        try copyfile([name_folder,mark,'InfoTracking.mat'],[name_folder,mark,Fname,mark,'InfoTracking.mat']);end
        try copyfile([name_folder,mark,'FreezeON.mat'],[name_folder,mark,Fname,mark,'FreezeON.mat']);end
        
        
        % display
        try
            close(guireg_fig)
            set(Fig_Odor,'Color',color_on);
            for bi=[1,3,6:9], set(inputDisplay(bi),'BackgroundColor',color_on);end
            for bit=1:2
                set(maskbutton(bit),'enable','on','FontWeight','bold')
            end
            delete(msg_box)
            set(maskbutton(3),'enable','off','FontWeight','normal')
            set(maskbutton(7),'enable','off','FontWeight','normal')
            set(maskbutton(4),'enable','on','FontWeight','bold')
        end
        
        % -----------------------------------------------------------------
        % Manual Count freezing
        function Count_Freezing(obj,event)
             Count_Freez=abs(Count_Freez-1);
            if Count_Freez
                t_ON=clock;
                set(maskbutton(3),'BackgroundColor','g','ForegroundColor','k'); 
            else
                t_OFF=clock;
                TimeFreez=TimeFreez+etime(t_OFF,t_ON);
                set(maskbutton(3),'BackgroundColor','k','ForegroundColor','w');
            end
        end
        
    end

% -----------------------------------------------------------------
%% StartSession
    function StartSession(obj,event)
        
        %enableTrack=1;
        set(inputDisplay(7),'string','RECORDING');
        set(maskbutton(7),'enable','on','FontWeight','bold')
        set(maskbutton(3),'enable','on','FontWeight','bold')
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
        figure(Fig_Odor), subplot(5,1,1:2), title('ACQUISITION STOPPED')
        enableTrack=0;
        set(maskbutton(4),'enable','off','FontWeight','normal')
        set(maskbutton(6),'enable','on','FontWeight','bold')
        set(maskbutton(7),'enable','off','FontWeight','normal')
        set(maskbutton(3),'enable','off','FontWeight','normal')
        try fwrite(a,6);disp('Arduino OFF');end
    end

% -----------------------------------------------------------------
%% stop tracking
    function Restart_Phase(obj,event)
        set(maskbutton(4),'enable','on','FontWeight','bold')
        set(maskbutton(7),'enable','on','FontWeight','bold')
        set(maskbutton(6),'enable','off','FontWeight','normal')
        templaod=load([res,mark,'TempFreezeON.mat']);
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

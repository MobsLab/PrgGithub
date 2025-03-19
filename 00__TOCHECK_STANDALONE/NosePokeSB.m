function [numF,filename]=NosePokeSB(~,~)
% same as FearFreezingOnline but 
%- do not send TTL for CS and shocks
% receive TTL from imetronic
%% INPUTS
% global
clear global name_folder imageRef Ratio_IMAonREAL
clear global enableTrack intermed
global a
        if size(a.Status,2)==6
            try fopen(a); end
        end
global vid
global chrono
global name_folder
global imageRef
global Ratio_IMAonREAL
global DiodMask
global DiodThresh
global enableTrack
global intermed
global maxfrvis
maxfrvis=800;

global BW_threshold2;
global smaller_object_size2;
global shape_ratio2;
global Count_Freez
global th_immob
global thimmobline
global Act
global TTLOUT
TTLOUT=[];
global maxyaxis
maxyaxis=200;
global ymax
ymax=10;
global PlotFreez

global n_AutoStop
global num_exp
global StartChrono
global tDeb
global guireg_fig
global countDown
global t_ON
global t_OFF
global namePhase
global TTL
global stim_Voltage
global nmouse;
global nameTASK;
global numPhase;

intermed=load('InfoTrackingTemp.mat');
imageRef=intermed.ref;
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

% anNoying problems
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
    'numbertitle','off','name','NosePoke','menubar','none','tag','figure Odor');
set(Fig_Odor,'Color',color_on);

InputButton= uicontrol(Fig_Odor,'style','pushbutton',...
    'units','normalized','position',[0.01 0.9 0.2 0.05],...
    'string','1- INPUTS EXPE','callback', @giv_inputs);
set(InputButton,'enable','on','FontWeight','bold')

DistanceButton= uicontrol(Fig_Odor,'style','pushbutton',...
    'units','normalized','position',[0.01 0.8 0.2 0.05],...
    'string','2- Real Distance','callback', @Real_distance);
set(DistanceButton,'enable','off')

DiodButton= uicontrol(Fig_Odor,'style','pushbutton',...
    'units','normalized','position',[0.01 0.7 0.2 0.05],...
    'string','3-GetLightZone','callback', @GetLightZone);
set(DiodButton,'enable','off')

StartButton= uicontrol(Fig_Odor,'style','pushbutton',...
    'units','normalized','position',[0.01 0.57 0.2 0.05],'string','4- START session');
set(StartButton,'enable','off','callback', @StartSession)

StartVoltButton= uicontrol(Fig_Odor,'style','pushbutton',...
    'units','normalized','position',[0.025 0.47 0.15 0.03],...
    'string','Start Voltage','callback', @NewVoltageStart);
set(StartVoltButton,'enable','off')

SetVoltSlider= uicontrol(Fig_Odor,'style','slider',...
    'units','normalized','value',Stim_Voltage,'position',[0.05 0.25 0.05 0.2],...
    'string','Start Voltage','callback', @SetVoltageValue);
set(SetVoltSlider,'enable','off')

ShowVolt=uicontrol(Fig_Odor,'style','text','units','normalized','position',[0.15 0.35 0.1 0.02],...
    'string',num2str(Stim_Voltage),'FontSize',10,'BackgroundColor','w');

StopButton= uicontrol(Fig_Odor,'style','pushbutton',...
    'units','normalized','position',[0.01 0.15 0.2 0.05],'string','3- STOP session');
set(StopButton,'enable','off','callback', @StopSession)


QuitButton= uicontrol(Fig_Odor,'style','pushbutton',...
    'units','normalized','position',[0.01 0.05 0.2 0.05],...
    'string','CLOSE EXPE','callback', @quit);
set(QuitButton,'enable','on','FontWeight','bold')

inputDisplay(1)=uicontrol(Fig_Odor,'style','text','units','normalized','position',[0.25 0.55 0.5 0.02],'string','Filename = TO DEFINE','FontSize',10);
ChronoShow=uicontrol(Fig_Odor,'style','text','units','normalized','position',[0.01 0.02 0.1 0.02],...
    'string',num2str(0),'BackgroundColor','k','ForegroundColor','w')

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
        
        strfcts=strjoin(nametypes,'|');
        u2=uicontrol(Fig_Odor,'Style', 'popup','String', strfcts,'units','normalized',...
            'Position', [0.01 0.84 0.2 0.05],'Callback', @setprotoc);
        
        function setprotoc(obj,event)
            fctname=get(obj,'value');
            namePhase=nametypes(fctname);
            savProtoc;
        end
        
        function savProtoc(obj,event)
        
        answer = inputdlg({'NumberMouse','Session Type','SessionNumber'},'SessionInfo',1,{'0','MFB','1'});
        
        nmouse=str2num(answer{1});
        nPhase=1;
        startphase=1;
        countDown=0;
                
        nameTASK=answer{2};
        numPhase=str2num(answer{3});
                
        if exist('Ratio_IMAonREAL','var') && ~isempty(Ratio_IMAonREAL)
            set(StartButton,'enable','on','FontWeight','bold')
            set(SetVoltSlider,'enable','on','FontWeight','normal','string','2- Real Distance (OK)')
        end
        
        disp(' ');disp('-------------------- New Expe ---------------------');
        save([res,mark,'TempNosePokeInfo.mat'],'nmouse','nameTASK','numPhase');
        set(maskbutton(1),'FontWeight','normal','string','1- INPUTS EXPE (OK)');
    
        end
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
        set(DiodButton,'enable','on','FontWeight','bold')
        
        Ratio_IMAonREAL=Ratio_IMAonREAL;
        save([res,mark,'TempNosePokeInfo.mat'],'-append','Ratio_IMAonREAL');
    end    
        
        function GetLightZone(obj,event)
        
        LightZoneFig=figure; subplot(5,1,1:4),
        imagesc(imageRef); colormap gray; axis image
        title('Select Diode Zone','Color','w')
        [~,~,DiodMask,~]=roipoly(ref);
        
        DiodMask=uint8(DiodMask);
        fwrite(a,5);
        temp=clock();
        vals=[];
        while etime(clock,temp)<20
            trigger(vid);
            IM=getdata(vid,1,'uint8');
            vals=[vals,sum(IM.*DiodMask)];
        end
        LightZoneFig=figure; subplot(5,1,5),
        plot(vals);
        title('select threshold')
        [~,DiodThresh]=ginput(1);
        close(LightZoneFig)
        save([res,mark,'TempNosePokeInfo.mat'],'-append','DiodMask','DiodThresh');
        set(StartButton,'enable','on','FontWeight','bold')
        set(SetVoltSlider,'enable','on')
        end
           
    function SetVoltageValue(~,~)
        Stim_Voltage = get( SetVoltSlider, 'value');
        set(ShowVolt,'string',num2str(Stim_Voltage))
    end
    
    function NewVoltageStart(~,~)
        fwrite(a,9);
        disp('NewVoltage')
    end

% -----------------------------------------------------------------
%% Interface of analysis
    function StartSession(obj,event)
        enableTrack=1;
        templaod=load([res,mark,'TempNosePokeInfo.mat']);
        num_exp=0;
        num_phase=templaod.numPhase;
        StartChrono=0;
        prefix=['NosePoke-Mouse-' num2str(templaod.nmouse) '-' templaod.nameTASK '-' num2str(numPhase) '-' TodayIs '-'];
        set(StartButton,'enable','off','FontWeight','normal')
        set(InputButton,'enable','off','FontWeight','normal')
        set(DistanceButton,'enable','off','FontWeight','normal')
        set(DiodButton,'enable','off','FontWeight','normal')
        set(StartVoltButton,'enable','on','FontWeight','bold')
        set(SetVoltSlider,'enable','on','FontWeight','bold')

        commnum=1;
        chrono=0;
        set(chronoshow,'string',num2str(0));
        num_exp=num_exp+1;
        disp('   Begining tracking...')
        guireg_fig=OnlineGuiReglage;
        % -------------------
        % reload everything
        tempLoad=load([res,mark,'TempFreezeON.mat']);
        imageRef=tempLoad.imageRef;
        Ratio_IMAonREAL=tempLoad.Ratio_IMAonREAL;
        th_immob=tempLoad.th_immob;
        thtps_immob=tempLoad.thtps_immob;
        n_AutoStop=tempLoad.n_AutoStop;
        name_folder=tempLoad.name_folder;
        DiodMask=tempLoad.DiodMask;
        DiodThresh=tempLoad.DiodThresh;

        
        % -------------------
        % display zone
        
        figure(Fig_Odor), subplot(5,1,1:2),
        htrack = imagesc(imageRef);axis image;
        line([10 20]*Ratio_IMAonREAL,[10 10],'Color','k','Linewidth',3)
        text(15*Ratio_IMAonREAL,15,'10 cm','Color','k')
        title('ACQUISITION ON')
        g=plot(0,0,'m+');
        
        figure(Fig_Odor), subplot(5,1,3:4),
        htrack2 = imagesc(zeros(size((imageRef))));axis image;colormap hot; caxis([0 1])
        xlabel('tracking online','Color','w')
        
        immob_val=0;
        figure(Fig_Odor), subplot(5,1,5)
        hold off, PlotFreez=plot(0,'-b');
        hold on, thimmobline=line([1,2000],[1 1]*th_immob,'Color','r');
        xlim([0,maxfrvis]); xlabel('freezing online','Color','w')
        % display chrono
        time_image = 1/frame_rate;
        
        
        % -----------------------------------------------------------------
        % ---------------------- INITIATE TRACKING ------------------------
        n=1;
        num_fr=1; num_fr_f=1;
        diffshow=zeros(size((imageRef)));
        prefac0=char; for ii=1:4-length(num2str(num_exp)), prefac0=cat(2,prefac0,'0'); end
        Fname=['F' TodayIs '-' prefac0 num2str(num_exp)];
        mkdir([name_folder mark Fname]);
        disp(['   ',Fname]);
        
        PosMat=[];
        clear Movtsd
        TimeFreez=0; set(inputDisplay(3),'string',['Time Freezing: ',num2str(floor(TimeFreez*10)/10),' s'])
        %tDeb = clock; timeDeb = tDeb(4)*60*60+tDeb(5)*60+tDeb(6);
        clear image_temp
        
        CLpluTTL=[];
        while enableTrack
            % ---------------------------------------------------------
            % update chrono
            t1 = clock;
            if StartChrono
                chrono=etime(t1,tDeb);
                set(ChronoShow,'string',[num2str(floor(chrono)),'/',num2str(n_AutoStop)]);
            end
            % ---------------------------------------------------------
       
%             
            %Active la cam�ra et Envoie l'image dans le workspace
            trigger(vid);
            
            IM=getdata(vid,1,'uint8');
            
            %IM=getsnapshot(vid);
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
            if n==2
                image_temp=bw;
            end
            % ---------------------------------------------------------
            % --------------------- FREEZING -----------------------
            
            % Every five images
            if  mod(n,3)==0
                immob_IM = bw - image_temp;
                diffshow=ones(size(immob_IM,1),size(immob_IM,2));
                diffshow(bw==1)=0;
                %                 immob_IM=imerode(immob_IM,se);
                diffshow(immob_IM==1)=0.4;
                diffshow(immob_IM==-1)=0.7;
                immob_val(num_fr_f,1)=(sum(sum(((immob_IM).*(immob_IM)))))/Ratio_IMAonREAL.^2;
                immob_val(num_fr_f,2)=chrono;
                image_temp=bw;
                num_fr_f=num_fr_f+1;
            end
            
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
            % --------------------- Get Diod Value ------------------------
            if sum(IM.*DiodMask)>DiodThresh
                set(ShowVolt,'BackgroundColor','r');
            else
                set(ShowVolt,'BackgroundColor','w');
            end

            % ---------------------------------------------------------
            % display video, mouse position and save in posmat
            set(htrack2,'Cdata',diffshow);
            if StartChrono
                
                
                if size(centroids) == [1 2]
                    set(g,'Xdata',centroids(1),'YData',centroids(2))
                    PosMat(num_fr,1)=chrono;
                    PosMat(num_fr,2)=centroids(1)/Ratio_IMAonREAL;
                    PosMat(num_fr,3)=centroids(2)/Ratio_IMAonREAL;
                    PosMat(num_fr,4)=0;
                    
                else
                    set(g,'Xdata',0,'YData',0)
                    PosMat(num_fr,:)=[chrono;NaN;NaN;NaN];
                end
                
                try set(PlotFreez,'YData',immob_val(max(1,num_fr_f-maxfrvis):end,1)); end
                figure(Fig_Odor), subplot(5,1,5)
                set(gca,'Ylim',[0 max(ymax,1)]);
                num_fr=num_fr+1;
                
                % ---------------------------------------------------------
                % --------------------- SAVE FRAMES -----------------------
                %hold off
                %datas.image = IM;
                datas.image =  uint8(double(IM));
                datas.time = t1;
                
                % ---------------------------------------------------------
                % ----------- PERFORM SOUND AND SHOCKS---------------------
                if chrono>acttime
                    action=eval(cell2mat(strcat('TTLOUT.',namePhase,'(',num2str(commnum),',2)')));
                    % fwrite(a,action);
                    PosMat(num_fr-1,4)=action;
                    disp(Act{action})
                    commnum=commnum+1;
                    acttime=eval(cell2mat(strcat('TTLOUT.',namePhase,'(',num2str(commnum),')')));
                end
                % save frame
                
                prefac1=char; for ii=1:6-length(num2str(n)), prefac1=cat(2,prefac1,'0');end
                save([ name_folder mark Fname mark 'frame' prefac1 sprintf('%0.5g',n)],'datas');
                n = n+1;
                
                
            end
            
            t2 = clock;
            if StartChrono && etime(t2,tDeb)> n_AutoStop+0.5
                enableTrack=0;
               try, TTL(end-1,:)=[];, end % last '3' is removed (!ON turn ON number 3 but we don't care)
                if Count_Freez
                    Count_Freez=0;
                    t_OFF=clock;
                    TimeFreez=TimeFreez+etime(t_OFF,t_ON);
                end
            end
            pause(time_image-etime(t2,t1));
        end
        
        % if no stopemergency, ready to start next phase
        try
            if etime(t2,tDeb)> n_AutoStop+0.5, enableTrack=1;end
        end
        % try fwrite(a,8);end
        
        % calculate freezing
        immob_val=immob_val(1:find(immob_val(:,2)>chrono-1,1,'last'),:);
        Movtsd=tsd(immob_val(:,2)*1E4',SmoothDec(immob_val(:,1)',1));
        try FreezeEpoch=thresholdIntervals(Movtsd,th_immob,'Direction','Below');
            FreezeEpoch=mergeCloseIntervals(FreezeEpoch,0.3*1E4);
            FreezeEpoch=dropShortIntervals(FreezeEpoch,thtps_immob*1E4);
            Freeze=sum(End(FreezeEpoch)-Start(FreezeEpoch));
        catch
            Freeze=NaN;
            Freeze2=NaN;
        end
        
        
        % save and copy file in save_folder
        msg_box=msgbox('Saving behavioral Information','save','modal');
        mask=intermed.mask;
        action=eval(cell2mat(strcat('TTLOUT.',namePhase,'(',num2str(commnum),',2)')));
        StimInfo=strcat('TTLOUT.',namePhase);
        StimInfo=eval(StimInfo{1});

        save([name_folder,mark,'Behavior.mat'],'PosMat','frame_rate','FreezeEpoch','StimInfo','Movtsd','th_immob','imageRef','shape_ratio2','BW_threshold2','mask','smaller_object_size2', 'TTL');
        pause(0.5)
        try set(PlotFreez,'YData',0,'XData',0);end
        
        %% generate figure
        figbilan=figure;
        CSplInt=intervalSet(StimInfo(StimInfo(:,2)==7,1)*1e4,(StimInfo(StimInfo(:,2)==7,1)+1)*1e4);
        CSmiInt=intervalSet(StimInfo(StimInfo(:,2)==5,1)*1e4,(StimInfo(StimInfo(:,2)==5,1)+1)*1e4);
%         CSplInt=intervalSet(StimInfo(StimInfo(:,2)==7,1)*1e4,(StimInfo(StimInfo(:,2)==7,1)+29)*1e4);
%         CSmiInt=intervalSet(StimInfo(StimInfo(:,2)==5,1)*1e4,(StimInfo(StimInfo(:,2)==5,1)+29)*1e4);
        % raw data : movement over time
        subplot(2,3,1:3)
        plot(Range(Movtsd,'s'),Data(Movtsd),'k')
        hold on
        for k=1:length(Start(FreezeEpoch))
            plot(Range(Restrict(Movtsd,subset(FreezeEpoch,k)),'s'),Data(Restrict(Movtsd,subset(FreezeEpoch,k))),'c')
        end
        
        plot(StimInfo((StimInfo(:,2)==6),1),0.5*ones(size(StimInfo((StimInfo(:,2)==6),1))),'r.','MarkerSize',20), hold on
        plot(StimInfo((StimInfo(:,2)==7),1),0.5*ones(size(StimInfo((StimInfo(:,2)==7),1))),'b.','linewidth',1)
        plot(StimInfo((StimInfo(:,2)==5),1),0.5*ones(size(StimInfo((StimInfo(:,2)==5),1))),'g.','linewidth',1)
%         for k=1:length(StimInfo(:,1))-1
%             if StimInfo(k,2)==7
%                 plot([StimInfo(k,1):StimInfo(k,1)+30],0.5,'b','linewidth',2)
%             elseif StimInfo(k,2)==6
%                 plot(StimInfo(k,1),0.5,'r.','MarkerSize',20)
%             elseif StimInfo(k,2)==5
%                 plot([StimInfo(k,1):StimInfo(k,1)+30],0.5,'g')
%             end
%         end
        title('Raw Data')
        % Movement during CS- and CS+
        subplot(2,3,4)
        bar([mean(Data(Restrict(Movtsd,CSplInt))),mean(Data(Restrict(Movtsd,CSmiInt)))])
        set(gca,'Xticklabel',{'CS+','CS-'})
        title('Average movement during sounds')
        subplot(2,3,5)
        % percentage of freezing during CS+ and CS-
       try 
       bar([length(Data(Restrict(Movtsd,and(FreezeEpoch,CSplInt))))/length(Data(Restrict(Movtsd,CSplInt))),...
            length(Data(Restrict(Movtsd,and(FreezeEpoch,CSmiInt))))/length(Data(Restrict(Movtsd,CSmiInt)))])
                set(gca,'Xticklabel',{'CS-','CS+'})
        title('Freezing during sounds')
       end
        
       try
        if strcmp(namePhase,'EXT')
            subplot(2,3,6)
            CsminPer=IntervalSet(0,408*1e4);
            CspluPer1=IntervalSet(408*1e4,789*1e4);
            CspluPer2=IntervalSet(789*1e4,1117*1e4);
            CspluPer3=IntervalSet(1117*1e4,1400*1e4);
            bar([length(Data(Restrict(Movtsd,and(Ep,CsminPer))))/length(Data(Restrict(Movtsd,CsminPer))),...
                length(Data(Restrict(Movtsd,and(Ep,CspluPer1))))/length(Data(Restrict(Movtsd,CspluPer1))),...
                length(Data(Restrict(Movtsd,and(Ep,CspluPer2))))/length(Data(Restrict(Movtsd,CspluPer2))),...
                length(Data(Restrict(Movtsd,and(Ep,CspluPer3))))/length(Data(Restrict(Movtsd,CspluPer3)))])
            set(gca,'Xticklabel',{'CS-','CS+1','CS+2','CS+3'})
            title('Freezing over entire Epochs')
        end
       end
       
        saveas(figbilan,[name_folder,mark,'FigBilan.fig'])
        saveas(figbilan,[name_folder,mark,'FigBilan.png'])
        close(figbilan)
        %%
        
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
        %pause (1) % en secondes
        
        if a.BytesAvailable>0
            fread(a,a.BytesAvailable);
        end
        set(maskbutton(7),'enable','on','FontWeight','bold')
        set(maskbutton(3),'enable','on','FontWeight','bold')
        set(maskbutton(4),'enable','off','FontWeight','normal')
        disp('waitin for imetronics TTL')
            while a.BytesAvailable==0
            end
            temp=fscanf(a);
        %enableTrack=1;
        set(inputDisplay(7),'string','RECORDING');
        StartChrono=1;
        tDeb = clock;
        TTL=[];
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
        % try fwrite(a,6);disp('Arduino OFF');end 
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
            'position',[0.1 0.1 0.4 0.6],...
            'numbertitle','off',...
            'name','Online Mouse Tracking : Setting Parameters',...
            'menubar','none',...
            'tag','figure reglage');
        set(guireg_fig,'Color',color_on);
        
        hand(2)=uicontrol(guireg_fig,'style','pushbutton',...
            'units','normalized',...
            'position',[0.05 0.9 0.9 0.05],...
            'string','Stop for Manual Inputs',...
            'tag','init',...
            'callback', @enterManual);
        
        text1=uicontrol(guireg_fig,'style','text', ...
            'units','normalized',...
            'position',[0.01 0.85 0.20 0.05],...
            'string','seuil couleur');
        
        text2=uicontrol(guireg_fig,'style','text', ...
            'units','normalized',...
            'position',[0.21 0.85 0.20 0.05],...
            'string','seuil objets');
        
        text3=uicontrol(guireg_fig,'style','text', ...
            'units','normalized',...
            'position',[0.41 0.85 0.20 0.05],...
            'string','rapport axes');
        
        text4=uicontrol(guireg_fig,'style','text', ...
            'units','normalized',...
            'position',[0.61 0.85 0.20 0.05],...
            'string','freezing threshold');
        
        text5=uicontrol(guireg_fig,'style','text', ...
            'units','normalized',...
            'position',[0.81 0.85 0.20 0.05],...
            'string','Yaxis');
        
        slider_seuil = uicontrol(guireg_fig,'style','slider',...
            'units','normalized',...
            'position',[0.05 0.1 0.08 0.7],...
            'callback', @seuil);
        set(slider_seuil,'Value',BW_threshold2);
        
        slider_small=uicontrol(guireg_fig,'style','slider',...
            'units','normalized',...
            'position',[0.25 0.1 0.08 0.7],...
            'callback', @elimination);
        set(slider_small,'Value',smaller_object_size2/typical_size);
        
        slider_rapport = uicontrol(guireg_fig,'style','slider',...
            'units','normalized',...
            'position',[0.45 0.1 0.08 0.7],...
            'callback', @rapport);
        set(slider_rapport,'Value',shape_ratio2/typical_rapport);
        
          slider_freeze = uicontrol(guireg_fig,'style','slider',...
            'units','normalized',...
            'position',[0.65 0.1 0.08 0.7],...
            'callback', @freeze_thresh);
        set(slider_freeze,'Value',th_immob/30);
        
        
        slider_yaxis = uicontrol(guireg_fig,'style','slider',...
            'units','normalized',...
            'position',[0.85 0.1 0.08 0.7],...
            'callback', @fixyaxis);
                set(slider_yaxis,'Value',ymax/maxyaxis);

        text6=uicontrol(guireg_fig,'style','text', ...
            'units','normalized',...
            'position',[0.01 0.05 0.20 0.03],...
            'string',num2str(BW_threshold2));
        
        
        text7=uicontrol(guireg_fig,'style','text', ...
            'units','normalized',...
            'position',[0.21 0.05 0.20 0.03],...
            'string',num2str(smaller_object_size2));
        
        
        text8=uicontrol(guireg_fig,'style','text', ...
            'units','normalized',...
            'position',[0.41 0.05 0.20 0.03],...
            'string',num2str(shape_ratio2));
        
        text9=uicontrol(guireg_fig,'style','text', ...
            'units','normalized',...
            'position',[0.61 0.05 0.20 0.03],...
            'string',num2str(th_immob));
        
        text10=uicontrol(guireg_fig,'style','text', ...
            'units','normalized',...
            'position',[0.81 0.05 0.20 0.03],...
            'string',num2str(ymax));
        
        function seuil(obj,event)
            
            BW_threshold2 = get(slider_seuil, 'value');
            set(text6,'string',num2str(BW_threshold2))
            %             disp([' New BW_threshold=',num2str(BW_threshold2)])
        end
        %get threshold value
        function elimination(obj,event)
            smaller_object_size2 = round(get(slider_small,'value')*typical_size);
            set(text7,'string',num2str(smaller_object_size2))
            %             disp(['   New smaller_object_size=',num2str(smaller_object_size2)])
        end
        function rapport(obj,event)
            shape_ratio2 = (get(slider_rapport,'value')*typical_rapport);
            set(text8,'string',num2str(shape_ratio2))
            %             disp(['     New shape_ratio=',num2str(shape_ratio2)])
        end
        
        function freeze_thresh(obj,event)
            th_immob = (get(slider_freeze,'value')*150);
            set(text9,'string',num2str(th_immob))
            %             disp(['     New freezing threshold=',num2str(th_immob)])
            set(thimmobline,'Ydata',[1,1]*th_immob)
        end
        
        function fixyaxis(~,~)
            ymax = round(get(slider_yaxis,'value')*maxyaxis);
            set(text10,'string',num2str(ymax));
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

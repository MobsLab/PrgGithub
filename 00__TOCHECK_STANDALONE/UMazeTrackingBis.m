function [numF,filename]=UMazeTracking(~,~)
% same as FearFreezingOnline but 
%- do not send TTL for CS and shocks
% receive TTL from imetronic
%% INPUTS
% global

clear global name_folder imageRef Ratio_IMAonREAL
clear global enableTrack intermed
global a
global vid
global chrono
global name_folder
global imageRef
global Ratio_IMAonREAL
global enableTrack
global intermed
global maxfrvis
maxfrvis=800;
global delStim delFirstStim
delStim=12;
delFirstStim=8;
global LastStim
global Zone
global TurnMat
global BW_threshold2;
global smaller_object_size2;
global shape_ratio2;
global Count_Freez
global th_immob
global thimmobline
global Act
global maxyaxis
maxyaxis=200;
global ymax
ymax=10;
global PlotFreez
global PosMat
global n_AutoStop
global num_exp
global StartChrono
global tDeb
global guireg_fig
global countDown
global t_ON
global t_OFF
global namePhase
global ZoneLabels
global SoundTimesHabTest; SoundTimesHabTest=[122,193,251,351,413,485,636,698,800,874,940,1022,1133,1195,1275,1340,Inf];
global SoundTimesCond;  SoundTimesCond=[122,197,287,362,457,530,640,760,840,930,1010,1095,1185,1285,1365,1430,Inf];
global CalibTimes;  CalibTimes=[50,70,90,110,150,155,157,159,Inf];
global ShTN; ShTN=1;
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


%% Prepare time vestors for different trial types
global nametypes
        nametypes={'Hab','TestPre','Cond','TestPost','Ext','EPM','SoundHab','SoundCnd','SoundTest','Calibration'};
mat1=ones(1,30);



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% graphical interface n�1 with all the pushbuttons

Fig_Odor=figure('units','normalized','position',[0.1 0.1 0.4 0.85],...
    'numbertitle','off','name','ImetronicsFearFreezing','menubar','none','tag','figure Odor');
set(Fig_Odor,'Color',color_on);

maskbutton(1)= uicontrol(Fig_Odor,'style','pushbutton',...
    'units','normalized','position',[0.01 0.89 0.2 0.05],...
    'string','1- INPUTS EXPE','callback', @giv_inputs);
set(maskbutton(1),'enable','on','FontWeight','bold')

maskbutton(2)= uicontrol(Fig_Odor,'style','pushbutton',...
    'units','normalized','position',[0.01 0.75 0.2 0.05],...
    'string','2- Real Distance','callback', @Real_distance);
set(maskbutton(2),'enable','off')

maskbutton(3)= uicontrol(Fig_Odor,'style','pushbutton',...
    'units','normalized','position',[0.01 0.70 0.2 0.05],'string','3 - GetBehavZones','callback',@DefineZones);
set(maskbutton(3),'enable','off')

maskbutton(5)= uicontrol(Fig_Odor,'style','pushbutton',...
    'units','normalized','position',[0.01 0.65 0.2 0.05],...
    'string','4- START EXPE','callback', @start_Expe);
set(maskbutton(5),'enable','off')

maskbutton(4)= uicontrol(Fig_Odor,'style','pushbutton',...
    'units','normalized','position',[0.01 0.48 0.2 0.05],'string','5- START session');
set(maskbutton(4),'enable','off','callback', @StartSession)



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

maskbutton(9)= uicontrol(Fig_Odor,'style','pushbutton',...
    'units','normalized','position',[0.55 0.05 0.2 0.05],...
    'string','Turn','callback', @Turn);
set(maskbutton(9),'enable','on','FontWeight','bold')


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


%% function to register when animal makes a quick turn around
    function Turn(obj,event)
       TurnMat=[TurnMat,PosMat(end,1)]; 
    end 
% -----------------------------------------------------------------
%% Ask for all inputs and display
    function giv_inputs(obj,event)
        
        strfcts=strjoin(nametypes,'|');
%         Fig_protoc=figure('units','normalized','position',[0.2 0.5 0.2 0.2],...
%     'numbertitle','off','name','Protocole','menubar','none','tag','figure Protocole');

        %u1=uicontrol(Fig_Odor,'style','text','units','normalized','position',[0.2 0.5 0.4 0.4],'string','Choose protocol','FontSize',10);
        u2=uicontrol(Fig_Odor,'Style', 'popup','String', strfcts,'units','normalized',...
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
        elseif strcmp('TestPre',namePhase) 
            lengthPhase=180;
        elseif strcmp('Cond',namePhase) 
            lengthPhase=480;
        elseif strcmp('TestPost',namePhase) 
            lengthPhase=180;
        elseif strcmp('Ext',namePhase)
            lengthPhase=900;
        elseif strcmp('EPM',namePhase)
            lengthPhase=1200;
        elseif strcmp('SoundCnd',namePhase)
            lengthPhase=1600;
        elseif strcmp('SoundHab',namePhase)
            lengthPhase=780;
        elseif strcmp('SoundTest',namePhase)
            lengthPhase=1450;
        elseif strcmp('Calibration',namePhase)
            lengthPhase=180;
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
            set(maskbutton(2),'enable','on','FontWeight','normal','string','2- Real Distance (OK)')
        else
            set(maskbutton(2),'enable','on','FontWeight','bold')
        end
        
        disp(' ');disp('-------------------- New Expe ---------------------');
        save([res,mark,'TempFreezeON.mat'],'nmouse','nPhase','namePhase','lengthPhase','nameTASK','imageRef','startphase');
        save([res,mark,'TempFreezeON.mat'],'-append','th_immob','thtps_immob','SmoothFact');
        set(maskbutton(1),'FontWeight','normal','string','1- INPUTS EXPE (OK)');
    
        end
        set(maskbutton(3),'enable','on')
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
                    name_folder = [prefix prefac '-' templaod.namePhase{nn}];
                catch
                    name_folder = [prefix prefac '-' templaod.namePhase{nn}];
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
                    try fopen(a); end
                end
                set(maskbutton(4),'enable','on','FontWeight','bold')
                Track_Freeze;
            end
        end
        try        set(maskbutton(5),'enable','off','FontWeight','normal','string','3- START EXPE')
            set(maskbutton(1),'enable','on','FontWeight','bold','string','1- INPUTS EXPE')
            set(maskbutton(4),'enable','off'),end
        if enableTrack
            set(inputDisplay(6),'string','END of the')
            set(inputDisplay(7),'string','experiment')
        end
    end



% -----------------------------------------------------------------
%% track mouse
    function Track_Freeze(obj,event)
        commnum=1;
        chrono=0;
        Count_Freez=0; set(chronoshow,'string',num2str(0));
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
        
        im_diff=0;
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
                set(chronoshow,'string',[num2str(floor(chrono)),'/',num2str(n_AutoStop)]);
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
                im_diff(num_fr_f,1)=chrono;
                im_diff(num_fr_f,2)=(sum(sum(((immob_IM).*(immob_IM)))))/Ratio_IMAonREAL.^2;
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
                
                try set(PlotFreez,'YData',im_diff(max(1,num_fr_f-maxfrvis):end,2)); end
                figure(Fig_Odor), subplot(5,1,5)
                set(gca,'Ylim',[0 max(ymax,1)]);
                num_fr=num_fr+1;
                
                if strcmp('Cond',namePhase) &  size(centroids) == [1 2]
                    where= Zone{1}(max(floor(centroids(2)),1),max(floor(centroids(1)),1));
                    if where==1
%                         if etime(clock,LastStim)>delFirstStim
%                             LastStim=clock;
%                         end
                        if etime(clock,LastStim)>delStim +rand
                            LastStim=clock;
                            fwrite(a,9);
                            PosMat(end,4)=1;
                            disp('stim')
                        end
                    end
                end

                if strcmp('SoundCnd',namePhase) 
                    if etime(clock,tDeb)>SoundTimesCond(ShTN)
                    if rem(ShTN,2)==0
                        fwrite(a,7);
                        PosMat(end,4)=2;
                        disp('CS-')
                    else
                        fwrite(a,5);
                        PosMat(end,4)=1;
                        disp('CS+ shock')
                    end
                    ShTN=ShTN+1;
                    end
                end
                
                if (strcmp('SoundHab',namePhase)|strcmp('SoundTest',namePhase))
                    if etime(clock,tDeb)>SoundTimesHabTest(ShTN)
                    fwrite(a,7);
                    PosMat(end,4)=2;
                    disp('CS-/CS+')
                    ShTN=ShTN+1;
                    end
                end
                
                if (strcmp('Calibration',namePhase))
                    if etime(clock,tDeb)>CalibTimes(ShTN)
                    fwrite(a,9);
                    PosMat(end,4)=1;
                    CalibTimes(ShTN)
                    disp('shock')
                    ShTN=ShTN+1;
                    end
                end

               % ---------------------------------------------------------
                % --------------------- SAVE fwrite(FRAMES -----------------------
                %hold off
                %datas.image = IM;
                datas.image =  uint8(double(IM));
                datas.time = t1;
                                
                prefac1=char; for ii=1:6-length(num2str(n)), prefac1=cat(2,prefac1,'0');end
                save([ name_folder mark Fname mark 'frame' prefac1 sprintf('%0.5g',n)],'datas');
                n = n+1;
                
                
            end
            
            t2 = clock;
            if StartChrono && etime(t2,tDeb)> n_AutoStop+0.5
                enableTrack=0;
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
        fwrite(a,3);
        
        % Correct for intan trigger time to realign with ephys
        im_diff(:,1)=im_diff(:,1)+1;
        PosMat(:,1)=PosMat(:,1)+1;
                mask=intermed.mask;

        save([name_folder,mark,'Behavior.mat'],'PosMat','im_diff','frame_rate','th_immob','imageRef',...
            'shape_ratio2','BW_threshold2','mask','smaller_object_size2','Ratio_IMAonREAL','delStim','delFirstStim');

        % calculate freezing
        im_diff=im_diff(1:find(im_diff(:,1)>chrono-1,1,'last'),:);
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
        im_diffint(:,2)=x;

        
        Movtsd=tsd(PosMatInt(1:end-1,1)*1e4,sqrt(diff(PosMatInt(:,2)).^2+diff(PosMatInt(:,1)).^2));
        Xtsd=tsd(PosMatInt(:,1)*1e4,(PosMatInt(:,3)));
        Ytsd=tsd(PosMatInt(:,1)*1e4,(PosMatInt(:,2)));
        Imdifftsd=tsd(im_diffint(:,1)*1e4,SmoothDec(im_diffint(:,2)',1));

        try FreezeEpoch=thresholdIntervals(Imdifftsd,th_immob,'Direction','Below');
            FreezeEpoch=mergeCloseIntervals(FreezeEpoch,0.3*1E4);
            FreezeEpoch=dropShortIntervals(FreezeEpoch,thtps_immob*1E4);
            Freeze=sum(End(FreezeEpoch)-Start(FreezeEpoch));
        catch
            Freeze=NaN;
            Freeze2=NaN;
        end
        
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
        ShTN=1;
        % save and copy file in save_folder
        msg_box=msgbox('Saving behavioral Information','save','modal');

        save([name_folder,mark,'Behavior.mat'],'PosMat','im_diff','frame_rate','FreezeEpoch','Movtsd','th_immob','imageRef',...
            'shape_ratio2','BW_threshold2','mask','smaller_object_size2','Zone','ZoneEpoch','ZoneIndices','Ratio_IMAonREAL','FreezeTime','Occup','TurnMat','-append');
        pause(0.5)
        try set(PlotFreez,'YData',0,'XData',0);end
        
        %% generate figure
        figbilan=figure;
       
        % raw data : movement over time
        subplot(2,3,1:3)
        plot(Range(Movtsd,'s'),Data(Movtsd)./prctile(Data(Movtsd),98),'k'), hold on
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
        %enableTrack=1;
        fwrite(a,1);
        set(inputDisplay(7),'string','RECORDING');
        StartChrono=1;
        tDeb = clock;
        LastStim=clock;
    end

%% Define behavioural zones
    function DefineZones(obj,event)
        global Zones
        figtemp=figure();
        imagesc(imageRef),colormap gray,hold on
        if strcmp(namePhase,'EPM')
            disp('OpenArms');[x1,y1,Open,x2,y2]=roipoly; plot(x2,y2)
            disp('ClosedArms');[x1,y1,Closed,x2,y2]=roipoly(); plot(x2,y2)
             Centre=zeros(size(imageRef));Centre(Open==1 & Closed==1)=1;
             Open(Centre==1)=0;Closed(Centre==1)=0;
             Zone{1}=uint8(Open);Zone{2}=uint8(Closed);Zone{3}=uint8(Centre);
            ZoneLabels={'OpenArms','ClosedArms','Centre'};
            set(maskbutton(3),'string','3 - GetBehavZones (OK)')
        elseif strcmp(namePhase,'SoundCnd') | strcmp(namePhase,'SoundHab') | strcmp(namePhase,'SoundTest') | strcmp(namePhase,'Calibration')
            disp('Inside');[x1,y1,InZone,x2,y2]=roipoly; Zone{1}=uint8(InZone);plot(x2,y2)
            disp('Outside');[x1,y1,OutZone,x2,y2]=roipoly(); Zone{2}=uint8(OutZone);plot(x2,y2)
            ZoneLabels={'Inside','Outside'};
            set(maskbutton(3),'string','3 - GetBehavZones (OK)')
        else
            disp('Shock');[x1,y1,Shock,x2,y2]=roipoly; Zone{1}=uint8(Shock);plot(x2,y2)
            disp('NoShock');[x1,y1,NoShock,x2,y2]=roipoly(); Zone{2}=uint8(NoShock);plot(x2,y2)
            disp('Centre');[x1,y1,Centre,x2,y2]=roipoly(); Zone{3}=uint8(Centre);plot(x2,y2)
            disp('CentreShock');[x1,y1,CentreShock,x2,y2]=roipoly(); Zone{4}=uint8(CentreShock);plot(x2,y2)
            disp('CentreNoShock');[x1,y1,CentreNoShock,x2,y2]=roipoly();    Zone{5}=uint8(CentreNoShock);plot(x2,y2)
            ZoneLabels={'Shock','NoShock','Centre','CentreShock','CentreNoShock'};
            set(maskbutton(3),'string','3 - GetBehavZones (OK)')
        end
        close(figtemp)
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
        try fwrite(a,3);disp('Intan OFF');end
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
        set(slider_freeze,'Value',th_immob/10);
        
        
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
            th_immob = (get(slider_freeze,'value')*10);
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

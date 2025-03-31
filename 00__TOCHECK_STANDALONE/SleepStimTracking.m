function [numF,filename]=SleepStimTracking(~,~)
% same as FearFreezingOnline but 
%- do not send TTL for CS and shocks
% receive TTL from imetronic
%% INPUTS

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
global LastStim
global TurnMat
global Count_Freez
global th_immob
global thimmobline
global Act
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
global StimOnTime StimOffTime
global SleepChrono PeriodChrono StimOnOff
SleepChrono=0; PeriodChrono=0; StimOnOff=0;

% Tracking parameters
global maxsrndsz SrdZone; maxsrndsz=80; SrdZone=20;
global maxsrtsz strsz se; maxsrtsz=20; strsz=1; se = strel('disk',strsz);
global maxyaxis ymax; maxyaxis=1000;ymax=200;
global BW_threshold2;
global smaller_object_size2;
global PixelsUsed
intermed=load('InfoTrackingTemp.mat');
imageRef=intermed.ref;
BW_threshold2=intermed.BW_threshold;
smaller_object_size2=intermed.smaller_object_size;
shape_ratio2=intermed.shape_ratio;
frame_rate = 5;

% Display parameters
color_on = [ 0 0 0];
color_off = [1 1 1];
colori={'g','r','c'};
scrsz = get(0,'ScreenSize');
global UpdateImage; UpdateImage=2; % update every n frames the picture shown on screen
global maxfrvis;maxfrvis=800;

% Time/date parameters
res=pwd;
mark=filesep;
t=clock;
jour=num2str(t(3));if length(jour)==1, jour=cat(2,'0',jour);end
mois=num2str(t(2));if length(mois)==1, mois=cat(2,'0',mois);end
annee=num2str(t(1));
TodayIs=[jour mois annee];


%% Task parameters
global nametypes; nametypes={'Ramp','SleepEffect','Baseline'};
mat1=ones(1,30);
global MinSleepTime;MinSleepTime=10; % mouse must be below threshold for more than this time (s) to count as sleep

%% Initialization
global ShTN; ShTN=1;
nPhase=NaN;
StartChrono=0;
num_exp=0;
prefac0=0;


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


maskbutton(5)= uicontrol(Fig_Odor,'style','pushbutton',...
    'units','normalized','position',[0.01 0.65 0.2 0.05],...
    'string','3- START EXPE','callback', @start_Expe);
set(maskbutton(5),'enable','off')

maskbutton(4)= uicontrol(Fig_Odor,'style','pushbutton',...
    'units','normalized','position',[0.01 0.48 0.2 0.05],'string','4- START session');
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
inputDisplay(3)=uicontrol(Fig_Odor,'style','text','units','normalized','position',[0.7 0.01 0.3 0.02],'string','Period duration = 0s ');
inputDisplay(6)=uicontrol(Fig_Odor,'style','text','units','normalized','position',[0.01 0.59 0.16 0.02],'string','Session','FontSize',12);
inputDisplay(7)=uicontrol(Fig_Odor,'style','text','units','normalized','position',[0.01 0.56 0.16 0.02],'string','WAIT','FontSize',12);
inputDisplay(8)=uicontrol(Fig_Odor,'style','text','units','normalized','position',[0.01 0.95 0.2 0.02],'string','TASK = ?','FontSize',10);
inputDisplay(9)=uicontrol(Fig_Odor,'style','text','units','normalized','position',[0.01 0.81 0.16 0.06],'string','ListOfSession = ?','FontSize',10);

for bi=[1,3,6:9], set(inputDisplay(bi),'BackgroundColor',color_on,'ForegroundColor','w','FontWeight','bold');end
set(inputDisplay(3),'ForegroundColor','r')
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
        u2=uicontrol(Fig_Odor,'Style', 'popup','String', strfcts,'units','normalized',...
            'Position', [0.01 0.84 0.2 0.05],'Callback', @setprotoc);
        
        
        function setprotoc(obj,event)
            fctname=get(obj,'value');
            namePhase=nametypes(fctname);
            savProtoc;
        end
        
        function savProtoc(obj,event)
            set(inputDisplay(9),'string',['Sessions:',{' '},namePhase]);
            lengthPhase=Inf;
        
        try
            temp=load('default_answer.mat','default_answer'); default_answer=temp.default_answer;
            default_answer{2}=num2str(lengthPhase);
        end
        if ~exist('default_answer','var') || (exist('default_answer','var') && length(default_answer)~=5)
            default_answer={'100',num2str(lengthPhase),'0.01','600','600'};
        end

        answer = inputdlg({'NumberMouse','Session duration (s)','Thresh immobility (mm)','OnStimDuration(s)','OffStimDuration(s)'},'INFO',1,default_answer);
        default_answer=answer; save default_answer default_answer
        
        nmouse=str2num(answer{1});
        lengthPhase=str2num(answer{2});
        nPhase=1;
        startphase=1;
        countDown=0;
        
        th_immob=str2num(answer{3});
        StimOnTime=str2num(answer{4});
        StimOffTime=str2num(answer{5});

        nameTASK='UMaze';
        
        set(inputDisplay(8),'string',['TASK = ',nameTASK]);
        
        if exist('Ratio_IMAonREAL','var') && ~isempty(Ratio_IMAonREAL)
            set(maskbutton(5),'enable','on','FontWeight','bold')
            set(maskbutton(2),'enable','on','FontWeight','normal','string','2- Real Distance (OK)')
        else
            set(maskbutton(2),'enable','on','FontWeight','bold')
        end
        
        disp(' ');disp('-------------------- New Expe ---------------------');
        keyboard
        save([res,mark,'TempFreezeON.mat'],'nmouse','nPhase','namePhase','lengthPhase','nameTASK','imageRef','startphase');
        save([res,mark,'TempFreezeON.mat'],'-append','th_immob','SmoothFact');
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
        try        
            set(maskbutton(5),'enable','off','FontWeight','normal','string','3- START EXPE')
            set(maskbutton(1),'enable','on','FontWeight','bold','string','1- INPUTS EXPE')
            set(maskbutton(4),'enable','on'),end
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
        hold off, PlotFreez=plot(0,0,'-b');
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
            %Active la camera et envoie l'image dans le workspace
            trigger(vid);
            IM=getdata(vid,1,'uint8');
            
            % ---------------------------------------------------------
            % --------------------- TREAT IMAGE -----------------------            
            % Substract reference image
            subimage = (imageRef-IM);
            % Add the mask
            subimage = uint8(double(subimage).*double(intermed.mask));
            % Convert the resulting grayscale image into a binary image.
            diff_im = im2bw(subimage,BW_threshold2);
            % erode to get rid of fine objects
            diff_im=imerode(diff_im,se);
            % Remove all the objects smaller than smaller_object_size
            diff_im = bwareaopen(diff_im,smaller_object_size2);
            diff_im=imdilate(diff_im,se);

            % ---------------------------------------------------------
            % --------------------- FIND MOUSE ------------------------
            % We get a set of properties for each labeled region.
            bw = logical(diff_im);
            stats = regionprops( bw, 'Centroid','MajorAxisLength','MinorAxisLength');
            centroids = cat(1, stats.Centroid);
            
            % ---------------------------------------------------------
            % --------------------- FREEZING -----------------------
            if n>3 & sum(size(centroids) == [1 2])>1
                FzZone=roipoly([1:320],[1:240],IM,[centroids(1)-SrdZone centroids(1)-SrdZone centroids(1)+SrdZone centroids(1)+SrdZone],...
                    [centroids(2)-SrdZone centroids(2)+SrdZone centroids(2)+SrdZone centroids(2)-SrdZone]);
                PixelsUsed=sum(sum(double(FzZone).*double(intermed.mask)+double(FzZone_temp).*double(intermed.mask)));
                immob_IM = double(diff_im).*double(FzZone) - double(image_temp).*double(FzZone_temp);
                diffshow=ones(size(immob_IM,1),size(immob_IM,2));
                diffshow(FzZone==1)=0.4;
                diffshow(FzZone_temp==1)=0.4;
                diffshow(bw==1)=0;
                image_temp=diff_im;
                FzZone_temp=FzZone;
            elseif n>3 % i deal with frams in which the mouse was't tracked but we still want the qty of movement
                    
                diffshow=diff_im;
                immob_IM = double(diff_im).*double(intermed.mask) - double(image_temp).*double(intermed.mask);
                PixelsUsed=sum(sum(double(intermed.mask).*double(intermed.mask)+double(intermed.mask).*double(intermed.mask)));
                image_temp=diff_im;
                FzZone_temp=intermed.mask;
            else % I deal with the first few frames where no subtraction is possible
                diffshow=diff_im;
                immob_IM=NaN;
                PixelsUsed=1;
                image_temp=diff_im;
                FzZone_temp=intermed.mask;
            end
            
            % display video, mouse position and save in posmat
            % Every 3 images
            if StartChrono
                
                % Update displays every UpdateImage frames
                if  mod(n,UpdateImage)==0
                    set(htrack2,'Cdata',diffshow);
                    set(htrack,'Cdata',IM);
                    try
                        im_diff(isnan(im_diff(:,2)),2)=0;
                        set(PlotFreez,'YData',im_diff(max(1,num_fr-maxfrvis):end,2),'XData',[1:length(im_diff(max(1,num_fr-maxfrvis):end,2))]')
                    end
                    figure(Fig_Odor), subplot(5,1,5)
                    set(gca,'Ylim',[0 max(ymax,1e-6)]);
                end

                if size(centroids) == [1 2]
                    set(g,'Xdata',centroids(1),'YData',centroids(2))
                    PosMat(num_fr,1)=chrono;
                    PosMat(num_fr,2)=centroids(1)/Ratio_IMAonREAL;
                    PosMat(num_fr,3)=centroids(2)/Ratio_IMAonREAL;
                    PosMat(num_fr,4)=0;
                    im_diff(num_fr,1)=chrono;
                    im_diff(num_fr,2)=(sum(sum(((immob_IM).*(immob_IM)))));
                    im_diff(num_fr,3)=(sum(sum(((immob_IM).*(immob_IM)))))./PixelsUsed;
                else
                    set(g,'Xdata',0,'YData',0)
                    PosMat(num_fr,:)=[chrono;NaN;NaN;NaN];
                    im_diff(num_fr,1)=chrono;
                    im_diff(num_fr,2)=(sum(sum(((immob_IM).*(immob_IM)))));
                    im_diff(num_fr,3)=(sum(sum(((immob_IM).*(immob_IM)))))./PixelsUsed;

                end
                
                %% Is the mouse sleeping
                if im_diff(end,2)<th_immob
                    SleepChrono=SleepChrono+im_diff(end,1)-im_diff(end-1,1);
                    if SleepChrono>MinSleepTime
                        PeriodChrono=PeriodChrono+im_diff(end,1)-im_diff(end-1,1);
                        set(inputDisplay(3),'string',['Period duration: ',num2str(floor(PeriodChrono*10)/10),' s'])
                        fwrite(a,StimOnOff);
                    else
                        fwrite(a,0);
                    end
                    if PeriodChrono>StimOnTime & StimOnOff==1
                        StimOnOff=0;
                        PeriodChrono=0;
                         set(inputDisplay(3),'ForegroundColor','r');
                    elseif PeriodChrono>StimOffTime & StimOnOff==0
                        StimOnOff=1;
                        PeriodChrono=0;
                        set(inputDisplay(3),'ForegroundColor','g');
                    end
                    PosMat(num_fr,4)=StimOnOff;
                elseif im_diff(end,2)>th_immob
                   SleepChrono=0; 
                   fwrite(a,0);
                end
                num_fr=num_fr+1;

               % ---------------------------------------------------------
                % --------------------- SAVE fwrite(FRAMES -----------------------
                datas.image =  uint8(double(IM));
                datas.time = t1;
                                
                prefac1=char; for ii=1:6-length(num2str(n)), prefac1=cat(2,prefac1,'0');end
                save([ name_folder mark Fname mark 'frame' prefac1 num2str(n,'%i')],'datas');
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
        PeriodChrono=0;
        % if no stopemergency, ready to start next phase
        try
            if etime(t2,tDeb)> n_AutoStop+0.5, enableTrack=1;end
        end
        fwrite(a,6);
        
        % Correct for intan trigger time to realign with ephys
        im_diff(:,1)=im_diff(:,1)+1;
        PosMat(:,1)=PosMat(:,1)+1;

        mask=intermed.mask;
        ref=imageRef;
        pixratio=1./Ratio_IMAonREAL;
        save([name_folder,mark,'behavResources.mat'],'PosMat','im_diff','frame_rate','th_immob','imageRef',...
            'shape_ratio2','BW_threshold2','mask','smaller_object_size2','ref','pixratio');

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

        try SleepEpoch=thresholdIntervals(Imdifftsd,th_immob,'Direction','Below');
            SleepEpoch=mergeCloseIntervals(SleepEpoch,0.3*1E4);
            SleepEpoch=dropShortIntervals(SleepEpoch,MinSleepTime*1E4);
            Freeze=sum(End(SleepEpoch)-Start(SleepEpoch));
        catch
            Freeze=NaN;
            Freeze2=NaN;
        end
        
        Xtemp=Data(Xtsd); Ytemp=Data(Ytsd); T1=Range(Ytsd);
      
        ShTN=1;
        % save and copy file in save_folder
        msg_box=msgbox('Saving behavioral Information','save','modal');

        save([name_folder,mark,'behavResources.mat'],'PosMat','im_diff','frame_rate','SleepEpoch','Movtsd','th_immob','imageRef',...
            'shape_ratio2','BW_threshold2','mask','smaller_object_size2','StimOnTime','Imdifftsd','MinSleepTime','StimOffTime','Ratio_IMAonREAL','-append');
        pause(0.5)
        try set(PlotFreez,'YData',0,'XData',0);end
        
        %% generate figure
        figbilan=figure;
       
        % raw data : movement over time
        subplot(2,3,1:3)
        plot(Range(Movtsd,'s'),Data(Movtsd)./prctile(Data(Movtsd),98),'k'), hold on
        plot(Range(Imdifftsd,'s'),Data(Imdifftsd)./prctile(Data(Imdifftsd),98),'b')
        for k=1:length(Start(SleepEpoch))
            plot(Range(Restrict(Imdifftsd,subset(SleepEpoch,k)),'s'),Data(Restrict(Imdifftsd,subset(SleepEpoch,k)))*0+max(ylim)*0.8,'c','linewidth',2)
        end
        plot(PosMat(PosMat(:,4)==1,1),PosMat(PosMat(:,4)==1,1)*0+max(ylim)*0.9,'k*')
        title('Raw Data')
        
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
        set(maskbutton(4),'enable','off','FontWeight','normal')
        %enableTrack=1;
        fwrite(a,5);
        set(inputDisplay(7),'string','RECORDING');
        StartChrono=1;
        tDeb = clock;
        LastStim=clock;
    end

% -----------------------------------------------------------------
%% stop tracking
    function stop_Phase(obj,event)
        figure(Fig_Odor), subplot(5,1,1:2), title('ACQUISITION STOPPED')
        enableTrack=0;
        set(maskbutton(4),'enable','on','FontWeight','normal')
        set(maskbutton(6),'enable','on','FontWeight','bold')
        set(maskbutton(7),'enable','off','FontWeight','normal')
        try fwrite(a,6);disp('Intan OFF');end
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
        
        % create figure
        guireg_fig=figure('units','normalized',...
            'position',[0.1 0.1 0.4 0.6],...
            'numbertitle','off',...
            'name','Online Mouse Tracking : Setting Parameters',...
            'menubar','none',...
            'tag','figure reglage');
        set(guireg_fig,'Color',color_on);
        
        % create names of sliders
        text1=uicontrol(guireg_fig,'style','text', ...
            'units','normalized',...
            'position',[0.10 0.85 0.10 0.05],...
            'string','seuil couleur');
        
        text2=uicontrol(guireg_fig,'style','text', ...
            'units','normalized',...
            'position',[0.25 0.85 0.10 0.05],...
            'string','seuil objets');
        
        text3=uicontrol(guireg_fig,'style','text', ...
            'units','normalized',...
            'position',[0.40 0.85 0.10 0.05],...
            'string','obj sz');
        
        text4=uicontrol(guireg_fig,'style','text', ...
            'units','normalized',...
            'position',[0.55 0.85 0.10 0.05],...
            'string','Fz Srnd Sz');
        
        text5=uicontrol(guireg_fig,'style','text', ...
            'units','normalized',...
            'position',[0.70 0.85 0.10 0.05],...
            'string','freezing threshold');
        
        text5=uicontrol(guireg_fig,'style','text', ...
            'units','normalized',...
            'position',[0.85 0.85 0.10 0.05],...
            'string','Yaxis');
        
        % create sliders
        slider_seuil = uicontrol(guireg_fig,'style','slider',...
            'units','normalized',...
            'position',[0.10 0.1 0.08 0.7],...
            'callback', @seuil);
        set(slider_seuil,'Value',BW_threshold2);
        
        slider_small=uicontrol(guireg_fig,'style','slider',...
            'units','normalized',...
            'position',[0.25 0.1 0.08 0.7],...
            'callback', @elimination);
        set(slider_small,'Value',smaller_object_size2/typical_size);
        
        slider_strel = uicontrol(guireg_fig,'style','slider',...
            'units','normalized',...
            'position',[0.40 0.1 0.08 0.7],...
            'callback', @setstrelsize);
        set(slider_strel,'Value',strsz/maxsrtsz);
        
        slider_srndsz = uicontrol(guireg_fig,'style','slider',...
            'units','normalized',...
            'position',[0.55 0.1 0.08 0.7],...
            'callback', @setsrndsz);
        set(slider_srndsz,'Value',SrdZone/maxsrndsz);       
        
        slider_freeze = uicontrol(guireg_fig,'style','slider',...
            'units','normalized',...
            'position',[0.70 0.1 0.08 0.7],...
            'callback', @freeze_thresh);
        set(slider_freeze,'Value',th_immob/50);
        
        slider_yaxis = uicontrol(guireg_fig,'style','slider',...
            'units','normalized',...
            'position',[0.85 0.1 0.08 0.7],...
            'callback', @fixyaxis);
        set(slider_yaxis,'Value',ymax/maxyaxis);

        % create labels with actual values
        text6=uicontrol(guireg_fig,'style','text', ...
            'units','normalized',...
            'position',[0.1 0.05 0.08 0.03],...
            'string',num2str(BW_threshold2)); 
        
        text7=uicontrol(guireg_fig,'style','text', ...
            'units','normalized',...
            'position',[0.25 0.05 0.08 0.03],...
            'string',num2str(smaller_object_size2));

        text8=uicontrol(guireg_fig,'style','text', ...
            'units','normalized',...
            'position',[0.40 0.05 0.08 0.03],...
            'string',num2str(strsz));

        text9=uicontrol(guireg_fig,'style','text', ...
            'units','normalized',...
            'position',[0.55 0.05 0.08 0.03],...
            'string',num2str(SrdZone));
        
        text10=uicontrol(guireg_fig,'style','text', ...
            'units','normalized',...
            'position',[0.70 0.05 0.08 0.03],...
            'string',num2str(th_immob));
        
        text11=uicontrol(guireg_fig,'style','text', ...
            'units','normalized',...
            'position',[0.85 0.05 0.08 0.03],...
            'string',num2str(ymax));
        
        %get threshold value
        function seuil(obj,event)
            BW_threshold2 = get(slider_seuil, 'value');
            set(text6,'string',num2str(BW_threshold2))
        end
        
        %get min object size
        function elimination(obj,event)
            smaller_object_size2 = round(get(slider_small,'value')*typical_size);
            set(text7,'string',num2str(smaller_object_size2))
        end
        
          %get object size for erosion
        function setstrelsize(~,~)
            strsz = round(get(slider_strel,'value')*maxsrtsz);
            se = strel('disk',strsz);
            set(text8,'string',num2str(strsz));
            pause(0.01)
        end
        
        
        %get soround zone size
        function setsrndsz(~,~)
            SrdZone = round(get(slider_srndsz,'value')*maxsrndsz);
            set(text9,'string',num2str(SrdZone));
        end 
    
        %get freezing threshold
        function freeze_thresh(obj,event)
            th_immob = (get(slider_freeze,'value'))/50;
            set(text10,'string',num2str(th_immob))
            set(thimmobline,'Ydata',[1,1]*th_immob)
        end
        
        %get ylims
        function fixyaxis(~,~)
            ymax = (get(slider_yaxis,'value')*maxyaxis);
            set(text11,'string',num2str(ymax));
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

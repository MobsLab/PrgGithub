function [numF,filename]=SleepTrackingOneMouse_IRComp(~,~)
% same as FearFreezingOnline but 
%- do not send TTL for CS and shocks
% receive TTL from imetronic
%% INPUTS
%% %%%
% Get global variables that are common to all codes --> code comes from
% GetCommonGlobalVariables
clear -global ref Ratio_IMAonREAL mask enableTrack intermed
global a vid frame_rate IRLimits
global PixelsUsed;  % maxsize in pixels
global se;
global intermed
intermed=load('InfoTrackingTemp.mat');
global ref; ref=intermed.ref;
global mask; mask=intermed.mask;
global Ratio_IMAonREAL; Ratio_IMAonREAL=intermed.Ratio_IMAonREAL;
global BW_threshold; if isfield(intermed,'BW_threshold'), BW_threshold=intermed.BW_threshold; else, BW_threshold=0.5; end
global smaller_object_size; if isfield(intermed,'smaller_object_size'), smaller_object_size=intermed.smaller_object_size; else, smaller_object_size=30; end
global sm_fact; if isfield(intermed,'sm_fact'), sm_fact=intermed.sm_fact; else, sm_fact=0; end
global strsz; if isfield(intermed,'strsz'), strsz=intermed.strsz; else, strsz=4; end, se= strel('disk',strsz);
global SrdZone; if isfield(intermed,'SrdZone'), SrdZone=intermed.SrdZone; else, SrdZone=20; end
global th_immob; if isfield(intermed,'th_immob'), th_immob=intermed.th_immob; else, th_immob=20; end
global guireg_fig
global TrackingFunctions
global time_image;time_image = 1/frame_rate;
global UpdateImage; UpdateImage=ceil(frame_rate/10); % update every n frames the picture shown on screen to show at 10Hz
global writerObj PlotForVideo % allows us to save as .avi
%% %%%%%

clear global name_folder
clear global enableTrack 
global chrono
global name_folder
global enableTrack
global LastStim
global thimmobline
global PlotFreez
global PosMat
global n_AutoStop
global num_exp
global StartChrono
global tDeb
global countDown
global namePhase
global maxyaxis ymax; maxyaxis=500;ymax=0.01;
global maxth_immob; maxth_immob=200 ;
global t1 t2
t1=clock;
t2=clock;

% Display parameters
color_on = [ 0 0 0];
color_off = [1 1 1];
colori={'g','r','c'};
scrsz = get(0,'ScreenSize');
global maxfrvis;maxfrvis=800;
global GuiForSleep

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
nPhase=NaN;
StartChrono=0;
num_exp=0;
prefac0=0;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% graphical interface n�1 with all the pushbuttons

Fig_Sleep=figure('units','normalized','position',[0.1 0.1 0.4 0.85],...
    'numbertitle','off','name','ImetronicsFearFreezing','menubar','none','tag','figure Odor');
set(Fig_Sleep,'Color',color_on);

maskbutton(1)= uicontrol(Fig_Sleep,'style','pushbutton',...
    'units','normalized','position',[0.01 0.89 0.2 0.05],...
    'string','1- INPUTS EXPE','callback', @giv_inputs);
set(maskbutton(1),'enable','on','FontWeight','bold')


maskbutton(5)= uicontrol(Fig_Sleep,'style','pushbutton',...
    'units','normalized','position',[0.01 0.65 0.2 0.05],...
    'string','3- START EXPE','callback', @start_Expe);
set(maskbutton(5),'enable','off')

maskbutton(4)= uicontrol(Fig_Sleep,'style','pushbutton',...
    'units','normalized','position',[0.01 0.48 0.2 0.05],'string','4- START session');
set(maskbutton(4),'enable','off','callback', @StartSession)


maskbutton(6)= uicontrol(Fig_Sleep,'style','pushbutton',...
    'units','normalized','position',[0.025 0.31 0.15 0.03],...
    'string','REstart Session','callback', @Restart_Phase);
set(maskbutton(6),'enable','off')

maskbutton(7)= uicontrol(Fig_Sleep,'style','pushbutton',...
    'units','normalized','position',[0.025 0.36 0.15 0.03],...
    'string','Stop Emergency','callback', @stop_Phase);
set(maskbutton(7),'enable','off')

maskbutton(8)= uicontrol(Fig_Sleep,'style','pushbutton',...
    'units','normalized','position',[0.01 0.03 0.2 0.05],...
    'string','CLOSE EXPE','callback', @quit);
set(maskbutton(8),'enable','on','FontWeight','bold')


inputDisplay(1)=uicontrol(Fig_Sleep,'style','text','units','normalized','position',[0.25 0.55 0.5 0.02],'string','Filename = TO DEFINE','FontSize',10);
inputDisplay(3)=uicontrol(Fig_Sleep,'style','text','units','normalized','position',[0.7 0.01 0.3 0.02],'string','Period duration = 0s ');
inputDisplay(6)=uicontrol(Fig_Sleep,'style','text','units','normalized','position',[0.01 0.59 0.16 0.02],'string','Session','FontSize',12);
inputDisplay(7)=uicontrol(Fig_Sleep,'style','text','units','normalized','position',[0.01 0.56 0.16 0.02],'string','WAIT','FontSize',12);
inputDisplay(8)=uicontrol(Fig_Sleep,'style','text','units','normalized','position',[0.01 0.95 0.2 0.02],'string','TASK = ?','FontSize',10);
inputDisplay(9)=uicontrol(Fig_Sleep,'style','text','units','normalized','position',[0.01 0.81 0.16 0.06],'string','ListOfSession = ?','FontSize',10);

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
        delete(Fig_Sleep)
    end

% -----------------------------------------------------------------
%% Ask for all inputs and display
    function giv_inputs(obj,event)
        
        strfcts=strjoin(nametypes,'|');
        u2=uicontrol(Fig_Sleep,'Style', 'popup','String', strfcts,'units','normalized',...
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

        answer = inputdlg({'NumberMouse','Session duration (s)'},'INFO',1,default_answer);
        default_answer=answer; save default_answer default_answer
        
        nmouse=str2num(answer{1});
        lengthPhase=str2num(answer{2});
        nPhase=1;
        startphase=1;
        countDown=0;
        
        nameTASK='Sleeping';
        
        set(inputDisplay(8),'string',['TASK = ',nameTASK]);
        
        if exist('Ratio_IMAonREAL','var') && ~isempty(Ratio_IMAonREAL)
            set(maskbutton(5),'enable','on','FontWeight','bold')
            set(maskbutton(2),'enable','on','FontWeight','normal','string','2- Real Distance (OK)')
        else
            set(maskbutton(2),'enable','on','FontWeight','bold')
        end
        
        disp(' ');disp('-------------------- New Expe ---------------------');
        keyboard
        save([res,mark,'TempFreezeON.mat'],'nmouse','nPhase','namePhase','lengthPhase','nameTASK','ref','startphase');
        save([res,mark,'TempFreezeON.mat'],'-append','th_immob','SmoothFact');
        set(maskbutton(1),'FontWeight','normal','string','1- INPUTS EXPE (OK)');
    
        end
    end
% -----------------------------------------------------------------
%% Interface of analysis
    function start_Expe(obj,event)
        enableTrack=1;
        t1=clock;
        t2=clock;
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
                save([res,mark,'TempFreezeON.mat'],'-append','ref','Ratio_IMAonREAL','name_folder','n_AutoStop','startphase')
                
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

        chrono=0;
        set(chronoshow,'string',num2str(0));
        num_exp=num_exp+1;
        disp('   Begining tracking...')
        guireg_fig=Tracking_OnlineGuiReglage;
        Sleeping_OnlineGuiReglage
        
        % -------------------
        % display zone
        
        figure(Fig_Sleep),         
        PlotForVideo=subplot(5,1,1:2);

        htrack = imagesc(ref);axis image;
        line([10 20]*Ratio_IMAonREAL,[10 10],'Color','k','Linewidth',3)
        text(15*Ratio_IMAonREAL,15,'10 cm','Color','k')
        title('ACQUISITION ON')
        g=plot(0,0,'m+');
        
        figure(Fig_Sleep), subplot(5,1,3:4),
        htrack2 = imagesc(zeros(size((ref))));axis image;colormap hot; caxis([0 1])
        xlabel('tracking online','Color','w')
        
        im_diff=0;
        figure(Fig_Sleep), subplot(5,1,5)
        hold off, PlotFreez=plot(0,0,'-b');
        hold on, thimmobline=line([1,2000],[1 1]*th_immob,'Color','r');
        xlim([0,maxfrvis]); xlabel('freezing online','Color','w')        
        
        % -----------------------------------------------------------------
        % ---------------------- INITIATE TRACKING ------------------------
        n=1;
        num_fr=1;
        diffshow=zeros(size((ref)));
        prefac0=char; for ii=1:4-length(num2str(num_exp)), prefac0=cat(2,prefac0,'0'); end
        Fname=['F' TodayIs '-' prefac0 num2str(num_exp)];
        mkdir([name_folder mark Fname]);
        disp(['   ',Fname]);
        
        % To save as a compressed file
        if frame_rate<9
            writerObj = VideoWriter([name_folder mark Fname '.avi']);
            open(writerObj);
        end
        
        PosMat=[];PosMatInit=[];im_diff=[];im_diffInit=[];
        Vtsd=[]; FreezeEpoch=[];
        Xtsd=[];Ytsd=[]; Imdifftsd=[];
        
        IM=TrackingFunctions.GetFrame(vid,IRLimits);
        OldIm=mask;
        OldZone=mask;

        while enableTrack
            
            % Activate the camera and send the image to the workspace
            pause(time_image-etime(t2,t1));
            IM=TrackingFunctions.GetFrame(vid,IRLimits);
            
            % ---------------------------------------------------------
            % update chrono
            t1 = clock;
            if StartChrono
                chrono=etime(t1,tDeb);
                set(chronoshow,'string',[num2str(floor(chrono)),'/',num2str(n_AutoStop)]);
            end
          
            % display video, mouse position and save in posmat
            if StartChrono
                
                % find the mouse and calculate quantity of movement
                [Pos,ImDiff,PixelsUsed,NewIm,FzZone]=Track_ImDiff(IM,mask,ref,BW_threshold,smaller_object_size,sm_fact,se,SrdZone,...
                    Ratio_IMAonREAL,OldIm,OldZone,IRLimits);
                
                if sum(isnan(Pos))==0
                    set(g,'Xdata',Pos(1).*Ratio_IMAonREAL,'YData',Pos(2).*Ratio_IMAonREAL)
                    PosMat(num_fr,1)=chrono;
                    PosMat(num_fr,2)=Pos(1);
                    PosMat(num_fr,3)=Pos(2);
                    PosMat(num_fr,4)=0;
                    im_diff(num_fr,1)=chrono;
                    im_diff(num_fr,2)=ImDiff;
                    im_diff(num_fr,3)=PixelsUsed;
                else
                    set(g,'Xdata',0,'YData',0)
                    PosMat(num_fr,:)=[chrono;NaN;NaN;NaN];
                    im_diff(num_fr,1:3)=[chrono;NaN;NaN];
                end
                
                num_fr=num_fr+1;
               
                % Update displays at 10Hz - faster would just be a waste of
                % time
                % For compression the actual picture is updated faster
                if frame_rate<9
                    set(htrack,'Cdata',IM);
                    set(g,'Xdata',0,'YData',0)
                    writeVideo(writerObj,getframe(PlotForVideo));
                end
                
                % Update displays at 10Hz - faster would just be a waste of
                % time
                if  mod(num_fr-2,UpdateImage)==0
                    diffshow=double(NewIm);
                    diffshow(FzZone==1)=0.4;
                    diffshow(OldZone==1)=0.4;
                    diffshow(NewIm==1)=0.8;
                    set(htrack2,'Cdata',diffshow);
                    set(htrack,'Cdata',IM);
                    
                    try
                        dattemp=im_diff;
                        dattemp(isnan(im_diff(:,2)),2)=0;
                        set(PlotFreez,'YData',im_diff(max(1,num_fr-maxfrvis):end,2),'XData',[1:length(dattemp(max(1,num_fr-maxfrvis):end,2))]')
                    end
                    figure(Fig_Sleep), subplot(5,5,22:25)
                    set(gca,'Ylim',[0 max(ymax,1e-5)]);
                end
                OldIm=NewIm;
                OldZone=FzZone;
                
               
                
                % --------------------------------------------------------------------------------
                % --------------------- SAVE FRAMES every NumFramesToSave  -----------------------
                if frame_rate>=9
                    prefac1=char; for ii=1:6-length(num2str(n)), prefac1=cat(2,prefac1,'0');end
                    save([ name_folder mark Fname mark 'frame' prefac1 sprintf('%0.5g',n)],'datas','-v6');
                    n = n+1;
                    clear datas
                end
            end
            t2 = clock;
            if StartChrono && etime(t2,tDeb)> n_AutoStop+0.5
                enableTrack=0;
            end
        end
        
        % if no stopemergency, ready to start next phase
        try
            if etime(t2,tDeb)> n_AutoStop+0.5, enableTrack=1;end
        end
        fwrite(a,6); % switch off intan
        
        
        % Correct for intan trigger time to realign with ephys
        im_diff(:,1)=im_diff(:,1)+1;
        PosMat(:,1)=PosMat(:,1)+1;
        
        % As a security save now incase something goes wrong
        save([name_folder,mark,'behavResources.mat'],'PosMat','im_diff','frame_rate','th_immob','ref',...
            'BW_threshold','mask','smaller_object_size','ref','Ratio_IMAonREAL','delStim','delStimreturn');

         %% %%%%%%%%%
        %CommonInterpPosMatImDiff
        im_diff=im_diff(1:find(im_diff(:,1)>chrono-1,1,'last'),:);
        im_diff(im_diff(:,2)>20,2)=NaN;
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
        x(isnan(x))=nanmean(x);
        im_diffint(:,2)=x;
        
        PosMatInit=PosMat;
        PosMat=PosMatInt;
        im_diffInit=im_diff;
        im_diff=im_diffint;
        
        Vtsd=tsd(PosMatInt(1:end-1,1)*1e4,sqrt(diff(PosMatInt(:,2)).^2+diff(PosMatInt(:,1)).^2));
        Xtsd=tsd(PosMatInt(:,1)*1e4,(PosMatInt(:,3)));
        Ytsd=tsd(PosMatInt(:,1)*1e4,(PosMatInt(:,2)));
        Imdifftsd=tsd(im_diffint(:,1)*1e4,SmoothDec(im_diffint(:,2)',1));
       
       % Do some extra code-specific calculations
       try SleepEpoch=thresholdIntervals(Imdifftsd,th_immob,'Direction','Below');
           SleepEpoch=mergeCloseIntervals(SleepEpoch,0.3*1E4);
           SleepEpoch=dropShortIntervals(SleepEpoch,MinSleepTime*1E4);
       catch
           SleepEpoch=NaN;
       end
        
      
        % save and copy file in save_folder
        msg_box=msgbox('Saving behavioral Information','save','modal');

        % Shut the video if compression was being done on the fly
         if frame_rate<9
            close(writerObj);
         end
         
        save([name_folder,mark,'behavResources.mat'],'SleepEpoch','th_immob','MinSleepTime','-append');
        pause(0.5)
        
        try set(PlotFreez,'YData',0,'XData',0);end
        
        %% generate figure
        figbilan=figure;
       
        % raw data : movement over time
        subplot(2,3,1:3)
        plot(Range(Vtsd,'s'),Data(Vtsd)./prctile(Data(Vtsd),98),'k'), hold on
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
            set(Fig_Sleep,'Color',color_on);
            for bi=[1,3,6:9], set(inputDisplay(bi),'BackgroundColor',color_on);end
            for bit=1:2
                set(maskbutton(bit),'enable','on','FontWeight','bold')
            end
            delete(msg_box)
            set(maskbutton(7),'enable','off','FontWeight','normal')
            set(maskbutton(4),'enable','on','FontWeight','bold')
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
        figure(Fig_Sleep), subplot(5,1,1:2), title('ACQUISITION STOPPED')
        enableTrack=0;
        set(maskbutton(4),'enable','on','FontWeight','normal')
        set(maskbutton(6),'enable','on','FontWeight','bold')
        set(maskbutton(7),'enable','off','FontWeight','normal')
        try fwrite(a,6);disp('Intan OFF');end
        close(writerObj);
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


    function Sleeping_OnlineGuiReglage
         % function GuiForSleep=OnlineGuiReglage(obj,event);
        % let online control of paramteres for image treatments
                
        % create figure
        GuiForSleep=figure('units','normalized',...
            'position',[0.1 0.1 0.2 0.6],...
            'numbertitle','off',...
            'name','UMaze Mouse Tracking : Setting Parameters',...
            'menubar','none',...
            'tag','figure reglage');
        set(GuiForSleep,'Color',color_on);
        
        textUM1=uicontrol(GuiForSleep,'style','text', ...
            'units','normalized',...
            'position',[0.22 0.85 0.2 0.05],...
            'string','freezing threshold');
        
        textUM2=uicontrol(GuiForSleep,'style','text', ...
            'units','normalized',...
            'position',[0.62 0.85 0.2 0.05],...
            'string','Yaxis');
        
        % create sliders
        slider_freeze = uicontrol(GuiForSleep,'style','slider',...
            'units','normalized',...
            'position',[0.25 0.1 0.15 0.7],...
            'callback', @freeze_thresh);
        set(slider_freeze,'Value',th_immob/10);
        
        slider_yaxis = uicontrol(GuiForSleep,'style','slider',...
            'units','normalized',...
            'position',[0.65 0.1 0.15 0.7],...
            'callback', @fixyaxis);
        set(slider_yaxis,'Value',ymax/maxyaxis);
        
        % create labels with actual values
        textUM3=uicontrol(GuiForSleep,'style','text', ...
            'units','normalized',...
            'position',[0.22 0.05 0.2 0.03],...
            'string',num2str(th_immob));
        
        textUM4=uicontrol(GuiForSleep,'style','text', ...
            'units','normalized',...
            'position',[0.62 0.05 0.2 0.03],...
            'string',num2str(ymax));
                
        %get freezing threshold
        function freeze_thresh(obj,event)
            th_immob = (get(slider_freeze,'value')*maxth_immob);
            set(textUM3,'string',num2str(th_immob))
            set(thimmobline,'Ydata',[1,1]*th_immob)
        end
        
        %get ylims
        function fixyaxis(~,~)
            ymax = (get(slider_yaxis,'value')*maxyaxis);
            set(textUM4,'string',num2str(ymax));
        end
    end
end

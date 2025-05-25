function [numF,filename]=FearFreezingOnlineImetronic2Vid(~,~)
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
global nmouse
global vidtouse
global CSBefAft
global lengthPhase
CSBefAft=1;
vidtouse=1;
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
global arduinoDictionary % list of numbers to send to arduino for each case
arduinoDictionary.On=1; % Tells Intan its time to go
arduinoDictionary.Off=3; % switches Intan off

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
global MouseColors
MouseColors=[1 0 0;0 0 1];
global IsCtxt
global IsCSplus
global IsCSmoins
global n
intermed=load('InfoTrackingTemp.mat');
imageRef=intermed.ref;
BW_threshold2=intermed.BW_threshold;
smaller_object_size2=intermed.smaller_object_size;
shape_ratio2=intermed.shape_ratio;
if isempty(shape_ratio2{1}),shape_ratio2{1}=1;end
if isempty(shape_ratio2{2}),shape_ratio2{2}=1;end

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

maxsm_val=30;
sm_val{1}=4;
sm_val{2}=4;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% graphical interface n�1 with all the pushbuttons

Fig_Fear=figure('units','normalized','position',[0.1 0.1 0.4 0.85],...
    'numbertitle','off','name','ImetronicsFearFreezing','menubar','none','tag','figure Odor');
set(Fig_Fear,'Color',color_on);

maskbutton(1)= uicontrol(Fig_Fear,'style','pushbutton',...
    'units','normalized','position',[0.01 0.89 0.2 0.05],...
    'string','1- INPUTS EXPE','callback', @giv_inputs);
set(maskbutton(1),'enable','on','FontWeight','bold')

maskbutton(2)= uicontrol(Fig_Fear,'style','pushbutton',...
    'units','normalized','position',[0.01 0.73 0.2 0.05],...
    'string','2- Real Distance','callback', @Real_distance);
set(maskbutton(2),'enable','off')

maskbutton(3)= uicontrol(Fig_Fear,'style','pushbutton',...
    'units','normalized','position',[0.85 0.05 0.1 0.05],'string','Freezing');
set(maskbutton(3),'enable','off')

maskbutton(4)= uicontrol(Fig_Fear,'style','pushbutton',...
    'units','normalized','position',[0.01 0.48 0.2 0.05],'string','4- START session');
set(maskbutton(4),'enable','off','callback', @StartSession)

maskbutton(5)= uicontrol(Fig_Fear,'style','pushbutton',...
    'units','normalized','position',[0.01 0.64 0.2 0.05],...
    'string','3- START EXPE','callback', @start_Expe);
set(maskbutton(5),'enable','off')

maskbutton(6)= uicontrol(Fig_Fear,'style','pushbutton',...
    'units','normalized','position',[0.025 0.31 0.15 0.03],...
    'string','REstart Session','callback', @Restart_Phase);
set(maskbutton(6),'enable','off')

maskbutton(7)= uicontrol(Fig_Fear,'style','pushbutton',...
    'units','normalized','position',[0.025 0.36 0.15 0.03],...
    'string','Stop Emergency','callback', @stop_Phase);
set(maskbutton(7),'enable','off')

maskbutton(8)= uicontrol(Fig_Fear,'style','pushbutton',...
    'units','normalized','position',[0.01 0.03 0.2 0.05],...
    'string','CLOSE EXPE','callback', @quit);
set(maskbutton(8),'enable','on','FontWeight','bold')

inputDisplay(1)=uicontrol(Fig_Fear,'style','text','units','normalized','position',[0.25 0.55 0.5 0.04],'string','Filename = TO DEFINE','FontSize',10);
inputDisplay(3)=uicontrol(Fig_Fear,'style','text','units','normalized','position',[0.7 0.01 0.3 0.02],'string','Time freezing = 0 ');
inputDisplay(6)=uicontrol(Fig_Fear,'style','text','units','normalized','position',[0.01 0.59 0.16 0.02],'string','Session','FontSize',12);
inputDisplay(7)=uicontrol(Fig_Fear,'style','text','units','normalized','position',[0.01 0.56 0.16 0.02],'string','WAIT','FontSize',12);
inputDisplay(8)=uicontrol(Fig_Fear,'style','text','units','normalized','position',[0.01 0.95 0.2 0.02],'string','TASK = ?','FontSize',10);
inputDisplay(9)=uicontrol(Fig_Fear,'style','text','units','normalized','position',[0.01 0.81 0.16 0.06],'string','ListOfSession = ?','FontSize',10);

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
        delete(Fig_Fear)
    end

% -----------------------------------------------------------------
%% Ask for all inputs and display
    function giv_inputs(obj,event)
        nametypes={'EXPLO','HABgrille','HABenvtest','TEST','COND','EXT',...
            'CtxtCtrlHab','CondSonCtxt','CtxtCtrlTest','SonTest','CtxtTest',...
            'MTLBTesting'};
        
        strfcts=strjoin(nametypes,'|');
        %         Fig_protoc=figure('units','normalized','position',[0.2 0.5 0.2 0.2],...
        %     'numbertitle','off','name','Protocole','menubar','none','tag','figure Protocole');
        
        %u1=uicontrol(Fig_Fear,'style','text','units','normalized','position',[0.2 0.5 0.4 0.4],'string','Choose protocol','FontSize',10);
        u2=uicontrol(Fig_Fear,'Style', 'popup','String', strfcts,'units','normalized',...
            'Position', [0.01 0.84 0.2 0.05],'Callback', @setprotoc);
        
        
        function setprotoc(obj,event)
            fctname=get(obj,'value');
            namePhase=nametypes(fctname);
            savProtoc;
        end
        
        function savProtoc(obj,event)
            set(inputDisplay(9),'string',['Sessions:',{' '},namePhase]);
            
            
            if strcmp('EXPLO',namePhase)
                lengthPhase=600;%default 600
                IsCtxt=1; IsCSplus=0; IsCSmoins=0;
            elseif strcmp('HABgrille',namePhase) % HAB 10min
                lengthPhase=720;
                IsCtxt=1; IsCSplus=0; IsCSmoins=0;
            elseif strcmp('HABenvtest',namePhase) % HAB 20min
                lengthPhase=1200;
                IsCtxt=1; IsCSplus=1; IsCSmoins=1;
            elseif strcmp('TEST',namePhase) % for debug
                lengthPhase=120;
                IsCtxt=1; IsCSplus=1; IsCSmoins=1;
            elseif strcmp('CONDBasic',namePhase)
                lengthPhase=1500;
                IsCtxt=1; IsCSplus=1; IsCSmoins=1;
            elseif strcmp('EXT',namePhase)
                lengthPhase=1400;
                IsCtxt=1; IsCSplus=1; IsCSmoins=1;
            elseif strcmp('CtxtCtrlHab',namePhase)
                lengthPhase=1200;
                IsCtxt=1; IsCSplus=0; IsCSmoins=0;
            elseif strcmp('CondSonCtxt',namePhase)
                lengthPhase=1687;
                IsCtxt=1; IsCSplus=1; IsCSmoins=0;
            elseif strcmp('CtxtCtrlTest',namePhase)
                lengthPhase=420;
                IsCtxt=1; IsCSplus=0; IsCSmoins=0;
            elseif strcmp('CtxtTest',namePhase)
                lengthPhase=420;
                IsCtxt=1; IsCSplus=0; IsCSmoins=0;
            elseif strcmp('SonTest',namePhase)
                lengthPhase=1200;
                IsCtxt=1; IsCSplus=1; IsCSmoins=1;
            elseif strcmp('MTLBTesting',namePhase)
                lengthPhase=50;
                IsCtxt=1; IsCSplus=1; IsCSmoins=1;
            end
            
            lengthPhase=lengthPhase+10;
            try
                temp=load('default_answer_2mice.mat','default_answer_2mice'); default_answer_2mice=temp.default_answer_2mice;
                default_answer_2mice{2}=num2str(lengthPhase);
            end
            if ~exist('default_answer_2mice','var') || (exist('default_answer_2mice','var') && length(default_answer_2mice)~=5)
                default_answer_2mice={'100','100',num2str(lengthPhase),'1.5','2','5','1'};
            end
            answer = inputdlg({'NumberMouse1','NumberMouse2','Session duration (s)','Thresh immobility (mm)','Drop intervals (s)','Smooth Factor'},'INFO',1,default_answer_2mice);
            default_answer_2mice=answer; save default_answer_2mice default_answer_2mice
            
            nmouse{1}=str2num(answer{1});
            nmouse{2}=str2num(answer{2});
            lengthPhase=str2num(answer{3});
            startphase=1;
            countDown=0;
            
            th_immob=str2num(answer{4});
            thtps_immob=str2num(answer{5});
            SmoothFact=str2num(answer{6});
            
            nameTASK='FearConditioning';
            
            set(inputDisplay(8),'string',['TASK = ',nameTASK]);
            
            if exist('Ratio_IMAonREAL','var') && ~isempty(Ratio_IMAonREAL)
                set(maskbutton(5),'enable','on','FontWeight','bold')
                set(maskbutton(2),'enable','on','FontWeight','normal','string','2- Real Distance (OK)')
            else
                set(maskbutton(2),'enable','on','FontWeight','bold')
            end
            
            disp(' ');disp('-------------------- New Expe ---------------------');
            save([res,mark,'TempFreezeON.mat'],'nmouse','Fig_Fear','namePhase','lengthPhase','nameTASK','imageRef','startphase');
            save([res,mark,'TempFreezeON.mat'],'-append','th_immob','thtps_immob','SmoothFact');
            set(maskbutton(1),'FontWeight','normal','string','1- INPUTS EXPE (OK)');
            
        end
    end

% -----------------------------------------------------------------
%% Ask for all inputs and display
    function Real_distance(obj,event)
        for v=1:2
            figure(Fig_Fear), subplot(5,2,[v,2+v]),
            imagesc(imageRef{v}); colormap gray; axis image
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
            Ratio_IMAonREAL{v}=d_xy/str2num(answer{1});
            
            title(strcat('mouse num ', num2str(nmouse{v}), ' in cage', num2str(v)))
            hold on, line([10 20]*Ratio_IMAonREAL{v},[10 10],'Color','k','Linewidth',3)
            text(15*Ratio_IMAonREAL{v},15,'10 cm','Color','k')
            
        end
        set(maskbutton(5),'enable','on','FontWeight','bold')
        set(maskbutton(2),'enable','on','FontWeight','normal','string','2- Real Distance (OK)')
        save([res,mark,'TempFreezeON.mat'],'-append','Ratio_IMAonREAL');
    end

% -----------------------------------------------------------------
%% Interface of analysis
    function start_Expe(obj,event)
        
        enableTrack=1;
        StartChrono=0;
        templaod=load(['TempFreezeON.mat']);
        tempstartphase=templaod.startphase;
        num_exp=0;
        num_phase=tempstartphase-1;
        for v=1:2,prefix{v}=['FEAR-Mouse-' num2str(templaod.nmouse{v}) '-' TodayIs '-'];end
        
        set(maskbutton(5),'enable','on','FontWeight','normal','string','3- START EXPE (OK)')
        
        num_phase=num_phase+1;
        startphase=num_phase;
        
        n_AutoStop=templaod.lengthPhase;
        %set(inputDisplay(6),'string',['Session ',num2str(nn),' :'])
        set(inputDisplay(7),'string','WAIT for start');
        
        for v=1:2
            % create folder to save tracking and analysis
            % ----------------------
            prefac=num2str(num_phase);
            if length(prefac)==1, prefac=cat(2,'0',prefac);end
            
            name_folder{v} = cell2mat(strcat(prefix{v}, prefac ,'-', templaod.namePhase));
            
            
            while exist(name_folder{v},'file')
                name_folder{v}=[name_folder{v},'0'];
            end
            mkdir(name_folder{v});
            disp(name_folder{v})
            
            % save info in NosePokeON
            % ----------------------
            save([res,mark,'TempFreezeON.mat'],'-append','imageRef','Ratio_IMAonREAL','name_folder','n_AutoStop','startphase')
            
            pause(0.1)
        end
        set(inputDisplay(1),'string',strvcat([name_folder{1} char(10) name_folder{2}]));
        
        if size(a.Status,2)==6
            try fopen(a); end
        end
        set(maskbutton(4),'enable','on','FontWeight','bold')
        
        try
            set(maskbutton(5),'enable','off','FontWeight','normal','string','3- START EXPE')
            set(maskbutton(1),'enable','on','FontWeight','bold','string','1- INPUTS EXPE')
            set(maskbutton(4),'enable','on')
            
        end
        if enableTrack
            set(inputDisplay(6),'string','END of the')
            set(inputDisplay(7),'string','experiment')
        end
        
        Track_Freeze;
    end

% -----------------------------------------------------------------
%% track mouse
    function Track_Freeze(obj,event)
        
        clear htrack htrack2 g
        commnum=1;
        chrono=0;
        %        acttime=eval(cell2mat(strcat('TTLOUT.',namePhase,'(',num2str(commnum),',1)')));
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
        
        figure(Fig_Fear),
        for v=1:2
            subplot(5,2,[v,2+v]),
            htrack{v} = imagesc(double(imageRef{v}));axis image;
            line([10 20]*Ratio_IMAonREAL{v},[10 10],'Color','k','Linewidth',3)
            text(15*Ratio_IMAonREAL{v},15,'10 cm','Color','k')
            title('ACQUISITION ON')
            g{v}=plot(0,0,'m+');
            figure(Fig_Fear), subplot(5,2,[4+v,6+v]),
            htrack2{v} = imagesc(double(zeros(size((imageRef{v})))));axis image;colormap hot; caxis([0 1])
            xlabel('tracking online','Color','w')
            
            
            immob_val{v}=0;
            figure(Fig_Fear), subplot(5,2,9:10)
            if v==1
                hold off
            end
            PlotFreez{v}=plot(0,'-','color',MouseColors(v,:));
            hold on,
            if v==1
                thimmobline=line([1,2000],[1 1]*th_immob,'Color','r');
            end
            xlim([0,maxfrvis]); xlabel('freezing online','Color','w')
            % display chrono
            time_image = 1/frame_rate;
            
            
            % -----------------------------------------------------------------
            % ---------------------- INITIATE TRACKING ------------------------
            
            for v=1:2,n{v}=1; num_fr{v}=1; num_fr_f{v}=1;end
            diffshow{v}=zeros(size((imageRef{v})));
            prefac0=char; for ii=1:4-length(num2str(num_exp)), prefac0=cat(2,prefac0,'0'); end
            
            
            for v=1:2,Fname{v}=['F' TodayIs '-' prefac0 num2str(num_exp)];
                mkdir([name_folder{v} mark Fname{v}]);
                disp(['   ',Fname{v}]);end
        end
        
        PosMat=cell(1,2);
        clear Movtsd
        Movtsd=cell(1,2);
        TimeFreez=cell(1,2); set(inputDisplay(3),'string',strvcat(['Time Freezing: ',num2str(floor(TimeFreez{v}*10)/10),' s' char(10) 'Time Freezing: ',num2str(floor(TimeFreez{v}*10)/10),' s']))
        %tDeb = clock; timeDeb = tDeb(4)*60*60+tDeb(5)*60+tDeb(6);
        clear image_temp
        t1 = clock;
        
        CLpluTTL=[];
        while enableTrack
            t2=clock;
            if (time_image-etime(t2,t1))<0
                
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
                for v=1:2
                    trigger(vid{v});
                    IM=double(getdata(vid{v},1,'uint8'));
                    datas{v}.image =  uint8(double(IM));
                    datas{v}.time = t1;
                    reftracking=double(imageRef{v});
                    if sm_val{v}>0
                        reftracking=runmean(double(imageRef{v}),sm_val{v},2);
                        IM=runmean(double(IM),sm_val{v},2);
                    end
                    %IM=getsnapshot(vid);
                    set(htrack{v},'Cdata',IM);
                    
                    % ---------------------------------------------------------
                    % --------------------- TREAT IMAGE
                    % -----------------------
                    % Substract reference image
                    subimage = (reftracking-IM);
                    subimage = uint8(double(subimage).*double(intermed.mask{v}));
                    % Convert the resulting grayscale image into a binary image.
                    diff_im = im2bw(subimage,BW_threshold2{v});
                    % Remove all the objects less large than smaller_object_size
                    diff_im = bwareaopen(diff_im,smaller_object_size2{v});
                    % Label all the connected components in the image.
                    bw = logical(diff_im); %CHANGED
                    if n{v}==2
                        image_temp{v}=bw;
                    end
                    % ---------------------------------------------------------
                    % --------------------- FREEZING -----------------------
                    
                    % Every five images
                    if  mod(n{v},3)==0
                        immob_IM = bw - image_temp{v};
                        diffshow{v}=ones(size(immob_IM,1),size(immob_IM,2));
                        diffshow{v}(bw==1)=0;
                        %                 immob_IM=imerode(immob_IM,se);
                        diffshow{v}(immob_IM==1)=0.4;
                        diffshow{v}(immob_IM==-1)=0.7;
                        immob_val{v}(num_fr_f{v},1)=(sum(sum(((immob_IM).*(immob_IM)))))/Ratio_IMAonREAL{v}.^2;
                        immob_val{v}(num_fr_f{v},2)=chrono;
                        image_temp{v}=bw;
                        num_fr_f{v}=num_fr_f{v}+1;
                    end
                    
                    % count Freezing
                    if Count_Freez
                        set(inputDisplay(3),'string',strvcat(['Time Freezing: ',num2str(floor(TimeFreez{v}*10)/10),' s' char(10) 'Time Freezing: ',num2str(floor(TimeFreez{v}*10)/10),' s']))
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
                    centroids=centroids(rap<shape_ratio2{v},:); %CHANGED
                    
                    % ---------------------------------------------------------
                    % display video, mouse position and save in posmat
                    set(htrack2{v},'Cdata',diffshow{v});
                    
                    
                    
                    if StartChrono
                        
                        % recuperation des ttl de imetronics
                        if a.BytesAvailable>0
                            
                            TTL=[TTL;chrono eval(fscanf(a))];
                            
                        end
                        if size(centroids) == [1 2]
                            set(g{v},'Xdata',centroids(1),'YData',centroids(2))
                            PosMat{v}(num_fr{v},1)=chrono;
                            PosMat{v}(num_fr{v},2)=centroids(1)/Ratio_IMAonREAL{v};
                            PosMat{v}(num_fr{v},3)=centroids(2)/Ratio_IMAonREAL{v};
                            PosMat{v}(num_fr{v},4)=0;
                            
                        else
                            set(g{v},'Xdata',0,'YData',0)
                            PosMat{v}(num_fr{v},:)=[chrono;NaN;NaN;NaN];
                        end
                        try set(PlotFreez{v},'YData',immob_val{v}(max(1,num_fr_f{v}-maxfrvis):end,1)); end
                        figure(Fig_Fear), subplot(5,1,5)
                        set(gca,'Ylim',[0 max(ymax,1)]);
                        num_fr{v}=num_fr{v}+1;
                        
                        % ---------------------------------------------------------
                        % --------------------- SAVE FRAMES -----------------------
                        %hold off
                        %datas.image = IM;
                        
                        
                        prefac1=char; for ii=1:6-length(num2str(n{v})), prefac1=cat(2,prefac1,'0');end
                        %% added to avoid saving frames twice
                        temp=datas;
                        clear datas
                        datas=temp{v};
                        save([ name_folder{v} mark Fname{v} mark 'frame' prefac1 sprintf('%0.5g',n{v})],'datas');
                        datas=temp;
                        %%
                        n{v} = n{v}+1;
                    end
                    
                    
                    
                    if StartChrono && etime(t2,tDeb)> n_AutoStop+0.5
                        enableTrack=0;
                        StartChrono=0;
                        if Count_Freez
                            Count_Freez=0;
                            t_OFF=clock;
                            TimeFreez{v}=TimeFreez{v}+etime(t_OFF,t_ON);
                        end
                    end
                end
                
            end
        end
        
        fwrite(a,arduinoDictionary.Off);

        
        % if no stopemergency, ready to start next phase
        try
            if etime(t2,tDeb)> n_AutoStop+0.5, enableTrack=1;end
        end
        % try fwrite(a,8);end

        for v=1:2
            % calculate freezing
            immob_val{v}=immob_val{v}(1:find(immob_val{v}(:,2)>chrono-1,1,'last'),:);
            Movtsd{v}=tsd(immob_val{v}(:,2)*1E4',SmoothDec(immob_val{v}(:,1)',1));
            try FreezeEpoch{v}=thresholdIntervals(Movtsd{v},th_immob,'Direction','Below');
                FreezeEpoch{v}=mergeCloseIntervals(FreezeEpoch{v},0.3*1E4);
                FreezeEpoch{v}=dropShortIntervals(FreezeEpoch{v},thtps_immob*1E4);
                Freeze{v}=sum(End(FreezeEpoch{v})-Start(FreezeEpoch{v}));
            catch
                Freeze{v}=NaN;
                Freeze2{v}=NaN;
            end
            
        end
        % save and copy file in save_folder
        msg_box=msgbox('Saving behavioral Information','save','modal');
        try
            save('BehaviorSecours.mat','PosMat','v','frame_rate','FreezeEpoch','StimInfo','Movtsd','th_immob','imageRef','sm_val','shape_ratio2','BW_threshold2','mask','smaller_object_size2', 'TTL');
            disp('BehaviorSecours.mat used. Check saved data')
        catch
            save BehaviorSecoursWorkspace.mat
            disp('BehaviorSecoursWorkspace used. Check saved data')
        end
        for v=1:2
            try
                mask=intermed.mask{v};
                clear temp
                temp.PosMat=PosMat;
                temp.shape_ratio2=shape_ratio2;
                temp.BW_threshold2=BW_threshold2;
                temp.smaller_object_size2=smaller_object_size2;
                temp.Movtsd=Movtsd;
                temp.FreezeEpoch=FreezeEpoch;
                temp.sm_val=sm_val;
                PosMat=PosMat{v};
                shape_ratio2=shape_ratio2{v};
                BW_threshold2=BW_threshold2{v};
                smaller_object_size2=smaller_object_size2{v};
                Movtsd=Movtsd{v};
                FreezeEpoch=FreezeEpoch{v};
                sm_val=sm_val{v};
                try
                    save([name_folder{v},mark,'Behavior.mat'],'PosMat','v','frame_rate','FreezeEpoch','StimInfo','Movtsd','th_immob','imageRef','sm_val','shape_ratio2','BW_threshold2','mask','smaller_object_size2', 'TTL');
                catch% sans StimInfo
                    save([name_folder{v},mark,'Behavior.mat'],'PosMat','v','frame_rate','FreezeEpoch','Movtsd','th_immob','imageRef','sm_val','shape_ratio2','BW_threshold2','mask','smaller_object_size2', 'TTL');
                end
                PosMat=temp.PosMat;
                shape_ratio2=temp.shape_ratio2;
                BW_threshold2=temp.BW_threshold2;
                smaller_object_size2=temp.smaller_object_size2;
                Movtsd=temp.Movtsd;
                FreezeEpoch=temp.FreezeEpoch;
                sm_val=temp.sm_val;

            catch
                disp('Problem Saving')
                keyboard
            end
            pause(0.5)
            try set(PlotFreez,'YData',0,'XData',0);end
        end
        
        for v=1:2
            try
                %% generate figure
                figbilan=figure;
                % raw data : movement over time
                subplot(2,3,1:3)
                plot(Range(Movtsd{v},'s'),Data(Movtsd{v}),'k')
                hold on
                for k=1:length(Start(FreezeEpoch{v}))
                    plot(Range(Restrict(Movtsd{v},subset(FreezeEpoch{v},k)),'s'),Data(Restrict(Movtsd{v},subset(FreezeEpoch{v},k))),'c')
                end
                xlim([0 lengthPhase-15])
                plot(TTL((TTL(:,2)==5),1),1.1*max(ylim)*ones(size(TTL((TTL(:,2)==5),1))),'r.','MarkerSize',20), hold on
                plot(TTL((TTL(:,2)==3),1),1.1*max(ylim)*ones(size(TTL((TTL(:,2)==3),1))),'b.','linewidth',1)
                plot(TTL((TTL(:,2)==4),1),1.1*max(ylim)*ones(size(TTL((TTL(:,2)==4),1))),'g.','linewidth',1)
                title('Raw Data')
                
                % Movement during CS- and CS+
                subplot(2,3,4)
                if IsCtxt
                    bar(1,length(Data(Restrict(Movtsd{v},FreezeEpoch{v})))/length(Data(Movtsd{v})))
                    set(gca,'Xtick',1,'Xticklabel',{'Ctx'})
                    ylabel('%Fz')
                end
                subplot(2,3,5)
                if IsCSplus
                    CSInterval=intervalSet((TTL(TTL(:,2)==4,1)-CSBefAft)*1e4,(TTL(TTL(:,2)==4,1))*1e4);
                    bar(1,length(Data(Restrict(Movtsd{v},And(FreezeEpoch{v},CSInterval))))/length(Data(Restrict(Movtsd{v},CSInterval)))), hold on
                    CSInterval=intervalSet(TTL(TTL(:,2)==4,1)*1e4,(TTL(TTL(:,2)==4,1)+CSBefAft)*1e4);
                    bar(2,length(Data(Restrict(Movtsd{v},And(FreezeEpoch{v},CSInterval))))/length(Data(Restrict(Movtsd{v},CSInterval))))
                    set(gca,'Xtick',[1,2],'Xticklabel',{'Bef CS+','Aft CS+'})
                    ylabel('%Fz')
                end
                subplot(2,3,6)
                if IsCSmoins
                    CSInterval=intervalSet((TTL(TTL(:,2)==3,1)-CSBefAft)*1e4,(TTL(TTL(:,2)==3,1))*1e4);
                    bar(1,length(Data(Restrict(Movtsd{v},And(FreezeEpoch{v},CSInterval))))/length(Data(Restrict(Movtsd{v},CSInterval)))),hold on
                    CSInterval=intervalSet(TTL(TTL(:,2)==3,1)*1e4,(TTL(TTL(:,2)==3,1)+CSBefAft)*1e4);
                    bar(2,length(Data(Restrict(Movtsd{v},And(FreezeEpoch{v},CSInterval))))/length(Data(Restrict(Movtsd{v},CSInterval))))
                    set(gca,'Xtick',[1,2],'Xticklabel',{'Beg CS-','Aft CS-'})
                    ylabel('%Fz')
                end
                
                saveas(figbilan,[name_folder{v},mark,'FigBilan.fig'])
                saveas(figbilan,[name_folder{v},mark,'FigBilan.png'])
                close(figbilan)
                %%
            end
        end
        
        % display
        try
            close(guireg_fig)
            set(Fig_Fear,'Color',color_on);
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
                TimeFreez{v}=TimeFreez{v}+etime(t_OFF,t_ON);
                set(maskbutton(3),'BackgroundColor','k','ForegroundColor','w');
            end
        end
        
    end

% -----------------------------------------------------------------
%% StartSession
    function StartSession(obj,event)
        %pause (1) % en secondes
        
       
        set(maskbutton(7),'enable','on','FontWeight','bold')
        set(maskbutton(3),'enable','on','FontWeight','bold')
        set(maskbutton(4),'enable','off','FontWeight','normal')
        disp('waiting for imetronics TTL')
        
        
        % Clear the arduino
        if a.BytesAvailable>0
            fread(a,a.BytesAvailable);
        end
        fwrite(a,arduinoDictionary.On);

        enableTrack=1;
        set(inputDisplay(7),'string','RECORDING');
        StartChrono=1;
        tDeb = clock;
        
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
        for v=1:2
            trigger(vid{v});
            IM=getdata(vid{v},1,'uint8');
            
            % ---------------------------------------------------------
            % --------------------- TREAT IMAGE -----------------------
            % Substract reference image
            subimage = (imageRef{v}-IM);
            subimage = uint8(double(subimage).*double(intermed.mask{v}));
            % Convert the resulting grayscale image into a binary image.
            diff_im = im2bw(subimage,BW_threshold2{v});
            % Remove all the objects less large than smaller_object_size
            diff_im = bwareaopen(diff_im,smaller_object_size2{v});
            % Label all the connected components in the image.
            bw = logical(diff_im); %CHANGED
            if n{v}==2
                image_temp{v}=bw;
            end
            % ---------------------------------------------------------
            % --------------------- FREEZING -----------------------
            
            % Every five images
            if  mod(n{v},3)==0
                immob_IM = bw - image_temp{v};
                diffshow{v}=ones(size(immob_IM,1),size(immob_IM,2));
                diffshow{v}(bw==1)=0;
                %                 immob_IM=imerode(immob_IM,se);
                diffshow{v}(immob_IM==1)=0.4;
                diffshow{v}(immob_IM==-1)=0.7;
                immob_val{v}(num_fr_f{v},1)=(sum(sum(((immob_IM).*(immob_IM)))))/Ratio_IMAonREAL{v}.^2;
                immob_val{v}(num_fr_f{v},2)=chrono;
                image_temp{v}=bw;
                num_fr_f{v}=num_fr_f{v}+1;
            end
            
            % --------------------- FIND MOUSE ------------------------
            % We get a set of properties for each labeled region.
            stats = regionprops( bw, 'Centroid','MajorAxisLength','MinorAxisLength');
            centroids = cat(1, stats.Centroid);
            maj = cat(1, stats.MajorAxisLength);
            mini = cat(1, stats.MinorAxisLength);
            rap=maj./mini;
            centroids=centroids(rap<shape_ratio2{v},:); %CHANGED
            
            % ---------------------------------------------------------
            % display video, mouse position and save in posmat
        end
        
        TTL=[];
    end

% -----------------------------------------------------------------
%% stop tracking
    function stop_Phase(obj,event)
        figure(Fig_Fear), subplot(5,1,1:2), title('ACQUISITION STOPPED')
        enableTrack=0;
        StartChrono=0;
        fwrite(a,arduinoDictionary.Off);

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
    function guireg_fig=OnlineGuiReglage(obj,event)
        
        % function guireg_fig=OnlineGuiReglage(obj,event);
        % let online control of paramteres for image treatments
        
        if ~exist('typical_size','var'), typical_size=300;end
        typical_rapport=10;
        
        guireg_fig=figure('units','normalized',...
            'position',[0.1 0.1 0.5 0.6],...
            'numbertitle','off',...
            'name','Online Mouse Tracking : Setting Parameters',...
            'menubar','none',...
            'tag','figure reglage');
        set(guireg_fig,'Color',color_on);
        
        hand(3)=uicontrol(guireg_fig,'style','pushbutton',...
            'units','normalized',...
            'position',[0.7 0.93 0.1 0.05],...
            'string',{'toggle vid'},...
            'tag','init',...
            'callback', @ChooseVid);
        
        testchoose=uicontrol(guireg_fig,'style','text', ...
            'units','normalized',...
            'position',[0.85 0.95 0.02 0.02],...
            'string',num2str(vidtouse));
        
        text1=uicontrol(guireg_fig,'style','text', ...
            'units','normalized',...
            'position',[0.01 0.85 0.20 0.05],...
            'string','seuil couleur');
        
        text2=uicontrol(guireg_fig,'style','text', ...
            'units','normalized',...
            'position',[0.16 0.85 0.20 0.05],...
            'string','seuil objets');
        
        text3=uicontrol(guireg_fig,'style','text', ...
            'units','normalized',...
            'position',[0.31 0.85 0.20 0.05],...
            'string','rapport axes');
        
        text4=uicontrol(guireg_fig,'style','text', ...
            'units','normalized',...
            'position',[0.46 0.85 0.20 0.05],...
            'string','freezing threshold');
        
        text5=uicontrol(guireg_fig,'style','text', ...
            'units','normalized',...
            'position',[0.61 0.85 0.20 0.05],...
            'string','SmoothFactor');
        
        text6=uicontrol(guireg_fig,'style','text', ...
            'units','normalized',...
            'position',[0.76 0.85 0.20 0.05],...
            'string','Yaxis');
        
         
        
        slider_seuil = uicontrol(guireg_fig,'style','slider',...
            'units','normalized',...
            'position',[0.08 0.1 0.08 0.7],...
            'callback', @seuil);
        set(slider_seuil,'Value',BW_threshold2{vidtouse});
        
        slider_small=uicontrol(guireg_fig,'style','slider',...
            'units','normalized',...
            'position',[0.23 0.1 0.08 0.7],...
            'callback', @elimination);
        set(slider_small,'Value',smaller_object_size2{vidtouse}/typical_size);
        
        slider_rapport = uicontrol(guireg_fig,'style','slider',...
            'units','normalized',...
            'position',[0.38 0.1 0.08 0.7],...
            'callback', @rapport);
        set(slider_rapport,'Value',shape_ratio2{vidtouse}/typical_rapport);
        
        slider_freeze = uicontrol(guireg_fig,'style','slider',...
            'units','normalized',...
            'position',[0.53 0.1 0.08 0.7],...
            'callback', @freeze_thresh);
        set(slider_freeze,'Value',th_immob/30);
        
         slider_smooth = uicontrol(guireg_fig,'style','slider',...
            'units','normalized',...
            'position',[0.68 0.1 0.08 0.7],...
            'callback', @smooth_factor);
        set(slider_smooth,'Value',sm_val{vidtouse}/maxsm_val);
        
        slider_yaxis = uicontrol(guireg_fig,'style','slider',...
            'units','normalized',...
            'position',[0.83 0.1 0.08 0.7],...
            'callback', @fixyaxis);
        set(slider_yaxis,'Value',ymax/maxyaxis);
        
        
        
        text7=uicontrol(guireg_fig,'style','text', ...
            'units','normalized',...
            'position',[0.01 0.05 0.20 0.03],...
            'string',num2str(BW_threshold2{vidtouse}));
        
        
        text8=uicontrol(guireg_fig,'style','text', ...
            'units','normalized',...
            'position',[0.16 0.05 0.20 0.03],...
            'string',num2str(smaller_object_size2{vidtouse}));
        
        
        text9=uicontrol(guireg_fig,'style','text', ...
            'units','normalized',...
            'position',[0.31 0.05 0.20 0.03],...
            'string',num2str(shape_ratio2{vidtouse}));
        
        text10=uicontrol(guireg_fig,'style','text', ...
            'units','normalized',...
            'position',[0.46 0.05 0.20 0.03],...
            'string',num2str(th_immob));
        
         text11=uicontrol(guireg_fig,'style','text', ...
            'units','normalized',...
            'position',[0.61 0.05 0.20 0.03],...
            'string',num2str(sm_val{vidtouse}));
        
        text12=uicontrol(guireg_fig,'style','text', ...
            'units','normalized',...
            'position',[0.76 0.05 0.20 0.03],...
            'string',num2str(ymax));
        
        
        function seuil(obj,event)
            BW_threshold2{vidtouse} = get(slider_seuil, 'value');
            set(text7,'string',num2str(BW_threshold2{vidtouse}))
        end
        %get threshold value
        function elimination(obj,event)
            smaller_object_size2{vidtouse} = round(get(slider_small,'value')*typical_size);
            set(text8,'string',num2str(smaller_object_size2{vidtouse}))
            %             disp(['   New smaller_object_size=',num2str(smaller_object_size2)])
        end
        function rapport(obj,event)
            shape_ratio2{vidtouse} = (get(slider_rapport,'value')*typical_rapport);
            set(text9,'string',num2str(shape_ratio2{vidtouse}))
            %             disp(['     New shape_ratio=',num2str(shape_ratio2)])
        end
        
        function freeze_thresh(obj,event)
            th_immob = (get(slider_freeze,'value')*150);
            set(text10,'string',num2str(th_immob))
            %             disp(['     New freezing threshold=',num2str(th_immob)])
            set(thimmobline,'Ydata',[1,1]*th_immob)
        end
        
        function smooth_factor(obj,event)
            
            sm_val{vidtouse} = floor((get(slider_smooth,'value')*maxsm_val));
            set(text11,'string',num2str(sm_val{vidtouse}))
        end
        
        function ChooseVid(obj,event)
            if vidtouse==1
                vidtouse=2;
            else
                vidtouse=1;
            end
            set(slider_rapport,'Value',shape_ratio2{vidtouse}/typical_rapport);
            set(slider_seuil,'Value',BW_threshold2{vidtouse});
            set(slider_small,'Value',smaller_object_size2{vidtouse}/typical_size);
            set(text8,'string',num2str(shape_ratio2{vidtouse}))
            set(text7,'string',num2str(smaller_object_size2{vidtouse}))
            set(text6,'string',num2str(BW_threshold2{vidtouse}))
            set(testchoose,'string',num2str(vidtouse));
            
        end
        
        
        function fixyaxis(~,~)
            ymax = round(get(slider_yaxis,'value')*maxyaxis);
            set(text12,'string',num2str(ymax));
        end
        
        
    end

end

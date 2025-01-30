function [numF,filename]=TimeAroundOdor_object_OFFline;

%% INPUTS
colori={'g','r','m'};
scrsz = get(0,'ScreenSize');
% global
clear global fctPhase ListOfPhases folder_name 
clear global folderPhase tempLoad imageRef MatSum
clear global nPhase nCTRL nVARI nFIXE d_obj rad_obj
clear global Ratio_IMAonREAL OdorInfo maskobj
clear global WhereInFrames enableTrack 

global fctPhase
global ListOfPhases
global folder_name
global folderPhase
global tempLoad
global imageRef
global nPhase
global nCTRL
global nVARI 
global nFIXE
global d_obj
global Ratio_IMAonREAL
global OdorInfo
%global ObjInfo
global maskobj
global enableTrack
global CaractSniff
global ZoneOdor
global NameLoadedExpe
global Nsniff
global Timeframe
global PlotTrack

% INITIATE
PlotTrack=1;
color_on = [ 0 0 0];
color_off= [0.5 0.5 0.5];    
nCTRL=0;
nVARI=1;
nFIXE=1;
nPhase=3;
d_obj=[0 0.5 1 1.5 2 2.5 3 3.5]; % distance from odor object to include:
rad_obj=2; % radius circular objets
OrderLabel={'CTRL','VARIANT','FIXED'}; %default {'CTRL','VARIANT','FIXED'}
StepTime=15; % in sec, time for step analysis
% anoying problems
res=pwd;
if isempty(strfind(res,'/')),mark='\'; else  mark='/';end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% graphical interface n�1 with all the pushbuttons

 Fig_Odor=figure('units','normalized','position',[0.15 0.1 0.8 0.8],...
            'numbertitle','off','name','Define Odor Locations','menubar','none','tag','figure Odor');
        set(Fig_Odor,'Color',color_on);
        
        maskbutton(1)= uicontrol(Fig_Odor,'style','pushbutton',...
            'units','normalized','position',[0.25 0.9 0.2 0.05],...
            'string','New Experiment / Reset','callback', @Reset);
        
        maskbutton(2)= uicontrol(Fig_Odor,'style','pushbutton',...
            'units','normalized','position',[0.01 0.75 0.08 0.05],...
            'string','INPUTS','callback', @giv_inputs);
        set(maskbutton(2),'enable','off')
        
        maskbutton(3)= uicontrol(Fig_Odor,'style','pushbutton',...
            'units','normalized','position',[0.01 0.9 0.1 0.05],...
            'string','RUN NightSelection','callback', @RunExpeAllNight);
        
        inputDisplay(1)=uicontrol(Fig_Odor,'style','text','units','normalized','position',[0.01 0.82 0.75 0.02],'string','Filename = TO DEFINE');
        inputDisplay(2)=uicontrol(Fig_Odor,'style','text','units','normalized','position',[0.6 0.95 0.1 0.02],'string',['nb phase = ',num2str(nPhase)]);
        inputDisplay(3)=uicontrol(Fig_Odor,'style','text','units','normalized','position',[0.8 0.95 0.1 0.02],'string',['nCTRL = ',num2str(nCTRL)]);
        inputDisplay(4)=uicontrol(Fig_Odor,'style','text','units','normalized','position',[0.8 0.9 0.1 0.02],'string',['nVARI = ',num2str(nVARI)]);
        inputDisplay(5)=uicontrol(Fig_Odor,'style','text','units','normalized','position',[0.8 0.85 0.1 0.02],'string',['nFIXE = ',num2str(nFIXE)]);        
        inputDisplay(6)=uicontrol(Fig_Odor,'style','text','units','normalized','position',[0.6 0.9 0.1 0.02],'string',['d from obj = ',num2str(d_obj(round(length(d_obj)/2))),'cm']); 
        inputDisplay(7)=uicontrol(Fig_Odor,'style','text','units','normalized','position',[0.6 0.85 0.1 0.02],'string',['size obj = ',num2str(rad_obj),'cm']); 
        inputDisplay(8)=uicontrol(Fig_Odor,'style','text','units','normalized','position',[0.6 0.07 0.3 0.02],'string','Time in recording: set to convenience'); 
        inputDisplay(9)=uicontrol(Fig_Odor,'style','text','units','normalized','position',[0.2 0.75 0.2 0.03],'string','Phase = undefined','FontSize',12);
        
        maskbutton(4)= uicontrol(Fig_Odor,'style','pushbutton',...
            'units','normalized','position',[0.03 0.55 0.06 0.03],...
            'string','START','callback', @start_Phase);
        set(maskbutton(4),'enable','off')
            
        maskbutton(5)= uicontrol(Fig_Odor,'style','pushbutton',...
            'units','normalized','position',[0.1 0.25 0.1 0.05],...
            'string','1- Real Distance','callback', @Real_distance);
        set(maskbutton(5),'enable','off')
        
        maskbutton(6)= uicontrol(Fig_Odor,'style','pushbutton',...
            'units','normalized','position',[0.25 0.25 0.1 0.05],...
            'string','2- Odor Location','callback', @Odor_Location);
        set(maskbutton(6),'enable','off')
        
        
        maskbutton(7)= uicontrol(Fig_Odor,'style','pushbutton',...
            'units','normalized','position',[0.4 0.25 0.1 0.05],...
            'string','3- Track sniff','callback', @Track_sniff);
        set(maskbutton(7),'enable','off')
        
        
        maskbutton(9)= uicontrol(Fig_Odor,'style','pushbutton',...
            'units','normalized','position',[0.65 0.18 0.08 0.05],...
            'string','VARIANT','callback', @VARI_sniff);
        set(maskbutton(9),'enable','off','BackgroundColor',color_on)
        
        maskbutton(10)= uicontrol(Fig_Odor,'style','pushbutton',...
            'units','normalized','position',[0.8 0.18 0.08 0.05],...
            'string','FIXED','callback', @FIXE_sniff);
        set(maskbutton(10),'enable','off','BackgroundColor',color_on)
        
        
       
        maskbutton(11)= uicontrol(Fig_Odor,'style','pushbutton',...
            'units','normalized','position',[0.43 0.2 0.1 0.02],...
            'string','Stop tracking','callback', @stop_Phase);
        set(maskbutton(11),'enable','off')
        
        
        maskbutton(12)= uicontrol(Fig_Odor,'style','pushbutton',...
            'units','normalized','position',[0.01 0.18 0.1 0.05],...
            'string','FIGURE indiv','callback', @Genrat_figure);
        set(maskbutton(12),'enable','off')
        
        maskbutton(13)= uicontrol(Fig_Odor,'style','pushbutton',...
            'units','normalized','position',[0.01 0.11 0.15 0.05],...
            'string','SAVE + FIGURE EXPE','callback', @Genrat_figureALL);
        set(maskbutton(13),'enable','off')
        
        maskbutton(14)= uicontrol(Fig_Odor,'style','pushbutton',...
            'units','normalized','position',[0.01 0.04 0.2 0.05],...
            'string','SAVE + FIGURE ALL LOADED EXPE','callback', @Genrat_figureALLEXPE);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CALLED FUNCTIONS

% -----------------------------------------------------------------
%% start new expe / reset everything
    function Reset(obj,event)

        Ratio_IMAonREAL=[];
        OdorInfo=[];
        imageRef=[];
        set(Fig_Odor,'Color',color_on);
        for i=1:9
            set(inputDisplay(i),'BackgroundColor',color_on,'ForegroundColor','w','FontWeight','bold')
        end
        set(inputDisplay(1),'string','Filename = TO DEFINE');
        set(maskbutton(2),'enable','on','FontWeight','bold')
        for i=[4:7,9:13]
            set(maskbutton(i),'enable','off','FontWeight','normal')
        end
        if exist('imageRef','var') && ~isempty(imageRef), 
            figure(Fig_Odor), subplot(1,2,1), hold off, 
            imagesc(imageRef),axis image, colormap gray;
        end
        
    end

% -----------------------------------------------------------------
%% start new expe / reset everything
    function RunExpeAllNight(obj,event)
        
        set(Fig_Odor,'Color',color_on)
        PlotTrack=0;
        % ------- name of folders - phase 0 --------------------
        try
            tempLoadNames=load([res,mark,'NameExpeToAnalyze.mat']);
            NameExpeToAnalyze=tempLoadNames.NameExpeToAnalyze;
        catch
            morefile=1;
            while morefile~=0
                NameExpeToAnalyze{morefile}= uigetdir(res,'Choose Folder of Phase 0');
                choice=questdlg('Analyze one more Phase0-Fodler ?','more file?','Yes','No','Yes');
                switch choice
                    case 'Yes'
                        morefile=morefile+1;
                    case 'No'
                        morefile=0;
                end
            end
            save([res,mark,'NameExpeToAnalyze.mat'],'NameExpeToAnalyze')
        end
        
        % ---------------- name phases --------------------
        ListOfPhases=[];
        for i=1:nPhase
            ListOfPhases=[ListOfPhases,{['Phase',num2str(i-1)]}];
        end
            
        
        % ---------------------------------------------------------------
        % ---------------- LOOP TO ASK USER FOR INFO --------------------
        for nam=1:length(NameExpeToAnalyze)
            disp(' ')
            folder_name=NameExpeToAnalyze{nam};
            try
                Tempreload=load([folder_name,mark,'TempNightOFF.mat']);
                OdorInfo=Tempreload.OdorInfo;
                disp([folder_name(max(strfind(folder_name,mark))+1:end),'/TempNightOFF already define... skipping this step'])
            catch
                
                disp(['Redo Ratio and Odor location ',folder_name(max(strfind(folder_name,mark))+1:end)]);
                
                fctPhase=1;
                Ratio_IMAonREAL=[];
                OdorInfo=[];
                imageRef=[];
                save([res,mark,'TempAroundOdorOFF.mat'],'-append','Ratio_IMAonREAL','OdorInfo','imageRef');
                pause(1)
                
                start_Phase(obj,event);
                
                % -------- wait for start_Phase to finish -----------
                while ~exist('PhaseOdorDONE','var')
                    pause(1)
                    try
                        waittemp=load([res,mark,'TempDonePhase.mat']);
                        PhaseOdorDONE=waittemp.PhaseOdorDONE;
                    end
                end
                disp('Done')
                clear PhaseOdorDONE;
                WaitforPhaseCompute=1; save([res,mark,'TempDonePhase.mat'],'WaitforPhaseCompute');
                
                save([folder_name,mark,'TempNightOFF.mat'],'ListOfPhases','nPhase','nCTRL','nVARI','nFIXE','d_obj','folder_name','OrderLabel','rad_obj','StepTime')
                save([folder_name,mark,'TempNightOFF.mat'],'-append','imageRef','OdorInfo','Ratio_IMAonREAL')
            end
        end
        
        
         % ---------------------------------------------------------------
        % ---------------- LOOP TO ASK USER FOR INFO --------------------
        for nam=1:length(NameExpeToAnalyze)
            disp(' ')
            folder_name=NameExpeToAnalyze{nam};
            disp(['Loading parameters of ',folder_name(max(strfind(folder_name,mark))+1:end)]);
            
            for ph=1:nPhase
                fctPhase=ph;
                disp(['        ',ListOfPhases{fctPhase}])
                Tempreload=load([folder_name,mark,'TempNightOFF.mat']);
                imageRef=Tempreload.imageRef;
                OdorInfo=Tempreload.OdorInfo;
                Ratio_IMAonREAL=Tempreload.Ratio_IMAonREAL;
                 
                start_Phase(obj,event);
                % -------- wait for start_Phase to finish -----------
                while ~exist('PhaseComputeDONE','var')
                    pause(1)
                    try
                        waittemp=load([res,mark,'TempDonePhase.mat']);
                        PhaseComputeDONE=waittemp.PhaseComputeDONE;
                    end
                end
                
                disp('Processing Tracking ...')
                Track_sniff(obj,event);
                % -------- wait for start_Phase to finish -----------
                while ~exist('PhaseTrackDONE','var')
                    pause(1)
                    try
                        waittemp=load([res,mark,'TempDonePhase.mat']);
                        PhaseTrackDONE=waittemp.PhaseTrackDONE;
                    end
                end
                WaitforPhaseCompute=1; save([res,mark,'TempDonePhase.mat'],'WaitforPhaseCompute');
                disp('Done')
            end
            
        end
        
         set(maskbutton(14),'enable','on')
        
    end



% -----------------------------------------------------------------
%% Ask for all inputs and display
    function giv_inputs(obj,event)
        % choose experiment to analyze
        folder_name = uigetdir(res,'Choose Folder of Phase 0');
        try
            tempLoad=load([folder_name,mark,'AroundOdor.mat']);
            defAns={num2str(tempLoad.nPhase) num2str(tempLoad.nCTRL) num2str(tempLoad.nVARI) num2str(tempLoad.nFIXE) num2str(tempLoad.d_obj) num2str(tempLoad.rad_obj)};
        catch
            defAns={num2str(nPhase) num2str(nCTRL) num2str(nVARI) num2str(nFIXE) num2str(d_obj) num2str(rad_obj)};
        end
        
        prompt = {'nb phase','nCTRL','nVARI','nFIXE','d from obj (cm)','radius obj (cm)'};
        dlg_title = 'Change parameters for Odor Recognition task:';
        answer = inputdlg(prompt,dlg_title,1,defAns);
        set(maskbutton(2),'enable','off','FontWeight','normal')
        
        nPhase = str2num(answer{1});
        nCTRL = str2num(answer{2});
        nVARI = str2num(answer{3});
        nFIXE = str2num(answer{4});
        d_obj = str2num(answer{5});
        rad_obj = str2num(answer{6});
        
        set(inputDisplay(1),'string',['Filename = ',folder_name]);
        set(inputDisplay(2),'string',['nb phase = ',num2str(nPhase)]);
        set(inputDisplay(3),'string',['nCTRL = ',num2str(nCTRL)]);
        set(inputDisplay(4),'string',['nVARI = ',num2str(nVARI)]);
        set(inputDisplay(5),'string',['nFIXE = ',num2str(nFIXE)]);        
        set(inputDisplay(6),'string',['d from obj = ',num2str(d_obj),'cm']); 
        set(inputDisplay(7),'string',['radius obj = ',num2str(rad_obj),'cm']); 
        
        indexPhase1=strfind(folder_name,'Phase');
        nFirstPhase=str2num(folder_name(max(indexPhase1)+5));

        ListOfPhases=[];
        for i=1:nPhase
            if isempty(nFirstPhase)
                NamePhase=NaN;
                ListOfPhases=[ListOfPhases,{'Phase Unique'}];
            else
                NamePhase=nFirstPhase+i-1;
                ListOfPhases=[ListOfPhases,{['Phase',num2str(NamePhase)]}];
            end
        end

        strfcts=strjoin(ListOfPhases,'|');
        maskbutton(3)=uicontrol('Style', 'popup','String', strfcts,'units','normalized','Position', [0.01 0.52 0.08 0.1],'Callback', @setPhase);
        
        % ---------------------------------------
        % function setPhase
        function setPhase(obj,event)
            fctPhase=get(maskbutton(3),'value');
            disp(ListOfPhases{fctPhase})
            set(maskbutton(4),'enable','on','FontWeight','bold')
        end
        % ---------------------------------------
        
        
        % see if the whole expe has been done already...
        try
            for i=1:nPhase 
                clear tempOdorInfo tempMatSum filename
                filename=folder_name; 
                filename(strfind(folder_name,'Phase'):strfind(folder_name,'Phase')+5)=ListOfPhases{i};
                temptempLoad=load([filename,mark,'AroundOdor.mat']);
                tempOdorInfo=temptempLoad.OdorInfo;
                tempMatSum=temptempLoad.MatSum;
            end
             choice=questdlg('The Whole Experiment has been analyzed already, redo anyway?','Redo?','Yes','No','No');
                switch choice
                    case 'No'
                        set(maskbutton(13),'enable','on','FontWeight','bold')
                        set(maskbutton(4),'enable','off','FontWeight','normal')
                end
        catch
            disp('Choose phase then Press START...');
        end
        
        save([res,mark,'TempAroundOdorOFF.mat'],'fctPhase','ListOfPhases','nPhase','nCTRL','nVARI','nFIXE','d_obj','folder_name','OrderLabel','rad_obj','StepTime')

    end
% -----------------------------------------------------------------
%% Interface of analysis
    function start_Phase(obj,event)
        folderPhase=[]; 
        tempLoad=[];
        MatSum={};
        
        % filename from folder_name
        index=strfind(folder_name,mark);
        filenametemp=folder_name(max(index)+1:length(folder_name));

        if strcmp(ListOfPhases{fctPhase},'Phase Unique')
            filename=filenametemp;
        else
            filename=filenametemp;
            filename(strfind(filenametemp,'Phase'):strfind(filenametemp,'Phase')+5)=ListOfPhases{fctPhase};
        end
        
        %load frames from file
        ok=0;n=0;
        length_end=length(filename(max(strfind(filename,'-')):end));
        while n<10 && ok==0
            n=n+1; numRec=['0',num2str(n)];
            filename2=filename;
            filename2(length(filename)-length_end-1:length(filename)-length_end)=numRec;
            try tempn=load([folder_name(1:max(index)),filename2,mark,'InfoTracking.mat']);ok=1;end
        end
        folderPhase=[folder_name(1:max(index)),filename2];
        disp(filename2)
        set(inputDisplay(1),'string',['Filename = ',folderPhase]);  
        set(inputDisplay(9),'string',num2str(ListOfPhases{fctPhase}),'FontSize',12);
        
        lis=dir(folderPhase);
        for li=1:length(lis)
            if strfind(lis(li).name,'-000')
                disp(['Analyzing ',lis(li).name,', discarding rest...'])
                folderPhaseFrames=[folderPhase,mark,lis(li).name];
                list=dir(folderPhaseFrames);
            end
        end
        
        OdorInfo=[]; 
        try
            tempLoad=load([folder_name,mark,'AroundOdor.mat']);
        catch
            tempLoad=load([res,mark,'TempAroundOdorOFF.mat']);
        end
        try
            %imageRef=tempLoad.imageRef;
            OdorInfo=tempLoad.OdorInfo;
        end
        
        clear imageReftemp
        if ~exist('imageRef','var') || (exist('imageRef','var') && isempty(imageRef))
            ili=4;
            while ~exist('imageReftemp','var') && ili<=length(list)
                clear datas
                try
                    temp=load([folderPhaseFrames,mark,list(ili).name]);
                    imageReftemp=temp.datas.image;
                    disp(['Using ',list(ili).name,'.mat']);
                catch
                    ili=ili+1;
                end
            end
        else
            imageReftemp=imageRef;
        end
        
        if ~exist('imageReftemp','var'), error(['No ',folderPhaseFrames]);end
        imageRef=imageReftemp;
        figure(Fig_Odor),colormap gray
        subplot(1,2,1), imagesc(imageRef),axis image
        
        % check if step 1 is done
        try
            Ratio_IMAonREAL=tempLoad.Ratio_IMAonREAL;
            line([10 20]*Ratio_IMAonREAL,[10 10],'Color','k','Linewidth',3)
            text(15*Ratio_IMAonREAL,15,'10 cm','Color','k')
            title(' 1- already done!')
            set(maskbutton(6),'enable','on','FontWeight','bold')
        catch
            title(' do 1- ')
        end
        set(maskbutton(5),'enable','on','FontWeight','bold')
        
        % check if step 2 is done
        if exist('OdorInfo','var') && ~isempty(OdorInfo)
            for i=1:size(OdorInfo,1)
                hold on, plot(OdorInfo(i,1),OdorInfo(i,2),['+',colori{OdorInfo(i,3)}])
                text(OdorInfo(i,1)+2,OdorInfo(i,2)+2,OrderLabel{OdorInfo(i,3)}(1:4),'Color',colori{OdorInfo(i,3)});
                if size(OdorInfo,2)==4
                    circli = rsmak('circle',OdorInfo(i,4),[OdorInfo(i,1),OdorInfo(i,2)]);
                    hold on, fnplt(circli,'Color',colori{OdorInfo(i,3)})
                end
            end
            set(maskbutton(7),'enable','on','FontWeight','bold') 
        end

        save([res,mark,'TempAroundOdorOFF.mat'],'-append','imageRef','OdorInfo','folderPhase','folderPhaseFrames','MatSum','Ratio_IMAonREAL') 
        PhaseComputeDONE=1; save([res,mark,'TempDonePhase.mat'],'PhaseComputeDONE')
    end

% -----------------------------------------------------------------
%% Ask for all inputs and display
    function Real_distance(obj,event)
        
        figure(Fig_Odor), subplot(1,2,1), title('Click on two points to define a distance','Color','w')
        for j=1:2
            [x,y]=ginput(1);
            hold on, plot(x,y,'+r')
            x1(j)=x; y1(j)=y;
        end
        line(x1,y1,'Color','r','Linewidth',2)

        answer = inputdlg({'Enter real distance (cm):'},'Define Real distance',1,{'45'});
        text(mean(x1)+10,mean(y1)+10,[answer{1},' cm'],'Color','r')
        
        d_xy=sqrt((diff(x1)^2+diff(y1)^2));
        Ratio_IMAonREAL=d_xy/str2num(answer{1});
       
        title(' do 2-')
        hold on, line([10 20]*Ratio_IMAonREAL,[10 10],'Color','k','Linewidth',3)
        text(15*Ratio_IMAonREAL,15,'10 cm','Color','k')
        set(maskbutton(6),'enable','on','FontWeight','bold') 
        
        save([res,mark,'TempAroundOdorOFF.mat'],'-append','Ratio_IMAonREAL')
        PhaseRatioDONE=1; save([res,mark,'TempDonePhase.mat'],'-append','PhaseRatioDONE')
    end


% -----------------------------------------------------------------
%% Click on odor locations

    function Odor_Location(obj,event)
        
        figure(Fig_Odor), subplot(1,2,1), imagesc(imageRef),axis image
        line([10 20]*Ratio_IMAonREAL,[10 10],'Color','k','Linewidth',3)
        text(15*Ratio_IMAonREAL,15,'10 cm','Color','k')
        
        % ------------------- LOCATE ODORS -------------------
        OdorInfo=[];
        for OL=1:length(OrderLabel)
            if strcmp(OrderLabel{OL}(1:4),'VARI')
                nbOD=nVARI;
            elseif strcmp(OrderLabel{OL}(1:4),'CTRL')
                nbOD=nCTRL;
            elseif strcmp(OrderLabel{OL}(1:4),'FIXE')
                nbOD=nFIXE;
            end
            
            for i=1:nbOD
                title(['Click on ',OrderLabel{OL},' odor location','Color','w']) 
                temp=ginput(1);
                OdorInfo=[OdorInfo; [temp,OL]];
                hold on, plot(temp(1),temp(2),['+',colori{OL}])
                text(temp(1)+2,temp(2)+2,OrderLabel{OL}(1:4),'Color',colori{OL});
            end
        end
        % range of odor zones 
        for dob=1:length(d_obj)
            OdorInfo(:,3+dob)=ones(size(OdorInfo,1),1)*(d_obj(dob)+rad_obj)*Ratio_IMAonREAL;
        end
        
        % ------------------------------------------------
        % maskIN odor zone for different d_obj
        % and mask obj
        ZoneOdor={};
        maskobj=zeros(size(imageRef));
        for od=1:size(OdorInfo,1)
            figure, imagesc(imageRef);
            %Odor Zones
            for dob=1:length(d_obj)
                hobj = imellipse(gca, [OdorInfo(od,1)-OdorInfo(od,3+dob) OdorInfo(od,2)-OdorInfo(od,3+dob) 2*OdorInfo(od,3+dob) 2*OdorInfo(od,3+dob)]);
                BW = createMask(hobj);
                try ZoneOdor{dob}=ZoneOdor{dob}+BW*od; catch, ZoneOdor{dob}=BW;end
            end
            %maskobj
            hobj = imellipse(gca, [OdorInfo(od,1)-rad_obj*Ratio_IMAonREAL OdorInfo(od,2)-rad_obj*Ratio_IMAonREAL 2*rad_obj*Ratio_IMAonREAL 2*rad_obj*Ratio_IMAonREAL]);
            BW = createMask(hobj);
            maskobj=maskobj+BW;
            close;
        end
        
        set(maskbutton(7),'enable','on','FontWeight','bold') 
        title(' do 3-')
        save([res,mark,'TempAroundOdorOFF.mat'],'-append','OdorInfo','ZoneOdor','maskobj')
        PhaseOdorDONE=1; save([res,mark,'TempDonePhase.mat'],'-append','PhaseOdorDONE')
    end


% -----------------------------------------------------------------
%% track mouse
    function Track_sniff(obj,event)
        
        % initiate
        for i=[1,2,4:7]
            set(maskbutton(i),'enable','off','FontWeight','normal')
        end
        enableTrack=1;
        set(maskbutton(9),'enable','on','FontWeight','bold','BackgroundColor','r')
        set(maskbutton(10),'enable','on','FontWeight','bold','BackgroundColor','m')
        set(maskbutton(11),'enable','on','FontWeight','bold')
        Nsniff=[];
        CaractSniff=[];
        MatSum={};
        save([res,mark,'TempAroundOdorOFF.mat'],'-append','CaractSniff','MatSum')

        % check if MatSum exist already
        try
            tempLoadphase=load([folderPhase,mark,'AroundOdor.mat']);
            MatSum=tempLoadphase.MatSum;
            if ~isempty(MatSum)
                choice=questdlg('Tracking in Odor Zone already done for this phase.. Redo anyway?','Redo?','Yes','No','No');
                switch choice
                    case 'No'
                        enableTrack=0;
                        OdorInfo=tempLoadphase.OdorInfo;
                        ZoneOdor=tempLoadphase.ZoneOdor;
                        disp('Skipping analysis')
                        copyfile([folderPhase,mark,'AroundOdor.mat'],[res,mark,'TempAroundOdorOFF.mat']);
                end
            end
        end
        
        % -------------------
        % RELOAD EVERYTHING
        loadTEMP=load([res,mark,'TempAroundOdorOFF.mat']);
        OdorInfo=loadTEMP.OdorInfo;
        Ratio_IMAonREAL=loadTEMP.Ratio_IMAonREAL;
        d_obj=loadTEMP.d_obj;
        ZoneOdor=loadTEMP.ZoneOdor;
        maskobj=loadTEMP.maskobj;
        folderPhaseFrames=loadTEMP.folderPhaseFrames;
        CaractSniff=loadTEMP.CaractSniff;
        % -------------------
        % display zone
        
        for i=1:2
            figure(Fig_Odor), subplot(1,2,i),
            if i==1
                htrack = imagesc(imageRef);axis image;
                line([10 20]*Ratio_IMAonREAL,[10 10],'Color','k','Linewidth',3)
                text(15*Ratio_IMAonREAL,15,'10 cm','Color','k')
                hold on, g = plot(0,0,'+w');
            else
                htrack2 = imagesc(imageRef);axis image;
            end
            
            for ob=1:size(OdorInfo,1)
                hold on, plot(OdorInfo(ob,1),OdorInfo(ob,2),['+',colori{OdorInfo(ob,3)}])
                if i==1, text(OdorInfo(ob,1)+2,OdorInfo(ob,2)+2,OrderLabel{OdorInfo(ob,3)}(1:4),'Color',colori{OdorInfo(ob,3)});end
                circli = rsmak('circle',OdorInfo(ob,3+round(length(d_obj)/2)),[OdorInfo(ob,1),OdorInfo(ob,2)]);
                hold on, fnplt(circli,'Color',colori{OdorInfo(ob,3)})
            end
        end
        
        % -------------------
        % load tracking infos
        try
            intermed=load([folderPhase,mark,'TrackingOFFline.mat']);
        catch
            try intermed=load([folderPhase,mark,'InfoTracking.mat']);
            catch
                enableTrack=0;
                disp(['No ',filename])
                keyboard
            end
        end
        
        % -------------------
        % Initiate
        list=dir(folderPhaseFrames);
        fr=3; Tstep=1; Tdeb=0;  
        MatSumTemp=zeros(size(imageRef));
        PosMat=NaN(length(list),3);
        
        if enableTrack
            figure(Fig_Odor), subplot(1,2,2), caxis([0 1]);
        end
        
       % -----------------------------------------------------------------
        % ----------------- START LOOP ---------------------
        while fr~=length(list) && enableTrack

            try
                % -----------------------
                % --- initiate ----------
                %ttdeb=clock;
                clear datas IM diff_im frames
                
                frames=load([folderPhaseFrames,mark,list(fr).name]);
                t1=frames.datas.time;
                if Tdeb==0, Tdeb=t1;end
                Timeframe=etime(t1,Tdeb);
                set(inputDisplay(8),'string',['Time in recording = ',num2str(floor(Timeframe)),'s - Frames = ',num2str(fr),'/',num2str(length(list))]);
                
                if Timeframe-Tstep*StepTime >= 0
                    MatSum{Tstep}=MatSumTemp;
                    MatSumTemp=zeros(size(imageRef));
                    Tstep=Tstep+1;
                end
                
                % -----------------------
                % --- get image ---------
                IM=frames.datas.image;
                
                if PlotTrack, set(htrack,'Cdata',IM);end
                %Substract reference image
                subimage = (intermed.ref-IM);
                subimage = uint8(double(subimage).*double(intermed.mask));
                % Convert the resulting grayscale image into a binary image.
                diff_im = im2bw(subimage,intermed.BW_threshold);
                % Remove all the objects less large than smaller_object_size
                diff_im = bwareaopen(diff_im,intermed.smaller_object_size);
                % Label all the connected components in the image.
                bw = logical(diff_im); %CHANGED
                
                stats = regionprops( bw, 'Centroid','MajorAxisLength','MinorAxisLength');
                centroids = cat(1, stats.Centroid);
                maj = cat(1, stats.MajorAxisLength);
                mini = cat(1, stats.MinorAxisLength);
                rap=maj./mini;
                centroids=centroids(rap<intermed.shape_ratio,:); %CHANGED
                
                % ------------------------------------------------
                % ----- display video and mouse position ---------
                %set(htrack2,'Cdata',diff_im);
                if size(centroids) == [1 2]
                     if PlotTrack, set(g,'Xdata',centroids(1),'YData',centroids(2));end
                    
                    PosMat(fr,1)=Timeframe;
                    PosMat(fr,2)=centroids(1);
                    PosMat(fr,3)=centroids(2);
                    
                    if sum( (centroids(1)-OdorInfo(:,1)).*(centroids(1)-OdorInfo(:,1)) + (centroids(2)-OdorInfo(:,2)).*(centroids(2)-OdorInfo(:,2)) <= (rad_obj+1)^2 )
                        centerOnObj=1;
                    else
                        centerOnObj=0;
                        MatSumTemp=MatSumTemp+diff_im;
                    end 
                else
                    if PlotTrack, set(g,'Xdata',0,'YData',0);end
                    PosMat(fr,:)=[Timeframe;NaN;NaN];
                end   
                
                
                % ---------------------------------------------------------
                % ----------------- DETECT SNIFF --------------------------
                Name_CaractSniff={'time','CenterOnObj','d_obj','Odortype','SumInZone','%InZone','SumInZone_minusMaskobj'};
                
                for dob=1:length(d_obj)
                    
                    ZOtemp=ZoneOdor{dob};
                    % define odor zone for particular d_obj
                    tempMat=NaN(length(OdorInfo(:,1)),7);
                    for od=1:length(OdorInfo(:,1))
                        oneZoneOdor=zeros(size(ZOtemp));
                        oneZoneOdor(ZOtemp==od)=1;
                        % time - CenterOnObj - d_obj - Odortype - SumInZone - %InZone - SumInZone_minusMaskobj
                        tempMat(od,1:4)=[Timeframe, centerOnObj, d_obj(dob) , OdorInfo(od,3)];
                        tempMat(od,5:7)= [sum(sum(diff_im.*oneZoneOdor)) , sum(sum(diff_im.*oneZoneOdor))*100/sum(sum(diff_im)) , sum(sum(diff_im.*oneZoneOdor.*abs(maskobj-1)))];
                    end
                    CaractSniff=[CaractSniff;tempMat];

                    
                    if dob==round(length(d_obj)/2) && centerOnObj==0
                        oneZoneOdor=ZOtemp;
                        oneZoneOdor(oneZoneOdor>1)=1;
                        imageTrav=diff_im*0.3+diff_im.*oneZoneOdor*0.7-diff_im.*maskobj;
                    elseif centerOnObj
                        imageTrav=zeros(size(diff_im));
                    end
                end
                % ---------------------------------------------------------
                % ---------------------------------------------------------
                if PlotTrack, set(htrack2,'Cdata',imageTrav);end
                pause(0.002)                
            catch
                %disp(list(fr).name); keyboard;
                if length(list(fr).name)>5 && strcmp(list(fr).name,'frame'), disp(['Problem ',list(fr).name]);end
            end
            
            fr=fr+1; 
            
        end
        
        % time in sniff
        TimeInSniff=tsdArray;
        for od=1:length(OdorInfo(:,3))
            for dob=1:length(d_obj)
                indexTS=find(CaractSniff(:,4)==OdorInfo(od,3) & CaractSniff(:,3)==d_obj(dob));
                TimeInSniff{od,dob}=tsd(CaractSniff(indexTS,1)*1E4,CaractSniff(indexTS,6)); 
            end
        end
        
        
        
        % ---------------------------------------------------------------
        % --------------------- SAVE EVERYTHING ---------------------------
       % save([res,mark,'TempAroundOdorOFF.mat'],'-append','maskobj','OdorInfo','ZoneOdor');
        if enableTrack
            save([res,mark,'TempAroundOdorOFF.mat'],'-append','MatSum','CaractSniff','Nsniff','PosMat','Name_CaractSniff') ;
            disp('All is saved in TempAroundOdorOFF.mat... Copying in :')
            disp(['   -> ',[folderPhase,mark,'AroundOdor.mat']])
            pause(2)
            try copyfile([res,mark,'TempAroundOdorOFF.mat'],[folderPhase,mark,'AroundOdor.mat']); catch, keyboard; end
            disp('     Done!')
        end
        try save([res,mark,'TempAroundOdorOFF.mat'],'-append','TimeInSniff');end
        try save([folderPhase,mark,'AroundOdor.mat'],'-append','TimeInSniff');end
        
        % terminate 
        stop_Phase;
        
        % sumup figure if all is analyzed!
        try
            for i=1:nPhase 
                clear tempOdorInfo tempMatSum filename
                filename=folder_name; 
                filename(strfind(folder_name,'Phase'):strfind(folder_name,'Phase')+5)=ListOfPhases{i};
                temptempLoad=load([filename,mark,'AroundOdor.mat']);
                tempOdorInfo=temptempLoad.OdorInfo;
                tempMatSum=temptempLoad.MatSum;
            end
            set(maskbutton(13),'enable','on','FontWeight','bold')

        catch
            disp('Go on analyzing next phase...')
        end
        PhaseTrackDONE=1; save([res,mark,'TempDonePhase.mat'],'PhaseTrackDONE');
    end


% -----------------------------------------------------------------
%%  sniff at FIXED location
    function FIXE_sniff(obj,event)
        Nsniff=[Nsniff;[Timeframe,3]];
    end

% -----------------------------------------------------------------
%% sniff at VARIANT location
    function VARI_sniff(obj,event)
        Nsniff=[Nsniff;[Timeframe,2]];
    end
% -----------------------------------------------------------------
%% stop tracking
    function stop_Phase(obj,event)
        pause(0.001)
        enableTrack=0;
        set(maskbutton(9),'enable','off','FontWeight','normal','BackgroundColor',color_on)
        set(maskbutton(10),'enable','off','FontWeight','normal','BackgroundColor',color_on)
        set(maskbutton(11),'enable','off','FontWeight','normal')
        for bi=[1,2,4:7,12]
            set(maskbutton(bi),'enable','on','FontWeight','bold')
        end
    end

% -----------------------------------------------------------------
%% display tracking and save figure
    function Genrat_figure(obj,event)
        % -------------------------------------
        % ------ reload everything -------------
        
        tempLoadphase=load([res,mark,'TempAroundOdorOFF.mat']);
        OdorInfo=tempLoadphase.OdorInfo;
        MatSum=tempLoadphase.MatSum;
        ZoneOdor=tempLoadphase.ZoneOdor;
        PosMat=tempLoadphase.PosMat;
        CaractSniff=tempLoadphase.CaractSniff;   
        d_obj=tempLoadphase.d_obj;
        TimeInSniff=tempLoadphase.TimeInSniff;
        
        
        % -----------------------------------------------
        % ------ RECAP GLOBAL (all session) -------------
        
        figure('Color',[1 1 1],'Position',scrsz/2); numF(1)=gcf;
        % recap
        subplot(1,2,1), imagesc(imageRef), colormap gray
        hold on, plot(PosMat(:,2),PosMat(:,3),'-k')
        %for dob=1:length(d_obj)
        dob=ceil(length(d_obj)/2);
            for i=1:size(OdorInfo,1)
                hold on, plot(OdorInfo(i,1),OdorInfo(i,2),['+',colori{OdorInfo(i,3)}])
                circli = rsmak('circle',OdorInfo(i,3+dob),[OdorInfo(i,1),OdorInfo(i,2)]);
                hold on, fnplt(circli,'Color',colori{OdorInfo(i,3)})
            end
        %end
        legend({'Track',OrderLabel{sort([OdorInfo(:,3);OdorInfo(:,3)])}})
        line([10 20]*Ratio_IMAonREAL,[10 10],'Color','k','Linewidth',3)
        text(15*Ratio_IMAonREAL,15,'10 cm','Color','k')
        
        index=strfind(folderPhase,mark);
        filenametemp=folderPhase(max(index)+1:length(folderPhase));
        title(filenametemp)
         xlabel('Odor Location and types')
        
        % occupation in odor zone
        totMatSum=zeros(size(MatSum{1}));
        for mm=1:length(MatSum)
            totMatSum=totMatSum+MatSum{mm};
        end
        subplot(1,2,2), imagesc(totMatSum),
        title('Occupation in odor zones during all recording')
        
        
        % --------------------------------------------
        % ------ Tests all parameters ----------------
        
        % time - CenterOnObj - d_obj - Odortype - SumInZone - %InZone - SumInZone_minusMaskobj
        NStep=floor(max(CaractSniff(:,1))/StepTime);
        
        if 0
            NameParam={'Cumulated presence in Odor zone','Cumulated % time in OdorZone','Cumulated presence in Odor zone -amskobj'};
            
            for param=1:3
                figure('Color',[1 1 1],'Position',scrsz), numF(param+1)=gcf;
                for n_step=1:NStep
                    
                    CumulSniff=NaN(length(OdorInfo(:,1)),length(d_obj));
                    for dob=1:length(d_obj)
                        indexMat=find(CaractSniff(:,3)==d_obj(dob) & CaractSniff(:,2)==0 & CaractSniff(:,1)<StepTime*n_step);
                        % time - Odortype - SumInZone - %InZone - SumInZone_minusMaskobj
                        tempMat=CaractSniff(indexMat,[1,4,4+param]);
                        
                        for od=1:length(OdorInfo(:,1))
                            % SumInZone - %InZone - SumInZone_minusMaskobj
                            CumulSniff(od,dob)=nanmean(tempMat(tempMat(:,2)==OdorInfo(od,3),3));
                            stdCumulSniff(od,dob)=stdError(tempMat(tempMat(:,2)==OdorInfo(od,3),3));
                        end
                    end
                    % display
                    subplot(ceil(NStep/4),4,n_step)
                    bar(CumulSniff')
                    title(['Record 0-',num2str(StepTime*n_step),'s '])
                    set(gca,'XTick',1:2:length(d_obj))
                    set(gca,'XTickLabel',num2str(d_obj(1:2:end)'))
                    if n_step>(ceil(NStep/4)-1)*4, xlabel('Distance from object (cm)');end
                    if rem(n_step,12)==5, ylabel(NameParam{param});end
                    if n_step==2, text(0,1.5*max(ylim),folderPhase(max(strfind(folderPhase,mark))+1:end));end
                end
                legend(OrderLabel(OdorInfo(:,3)))
                
                saveFigure(numF(param),['Figure_Param',num2str(param),'_',folderPhase(max(strfind(folderPhase,mark))+1:end)],[res,mark,'FiguresParam'])
            end
        end
        
        
        
        
        % --------------------------------------------------
        % ------ Time in sniff in odor zone ----------------
        figure('Color',[1 1 1],'Position',scrsz), numF(4)=gcf;
        ylimaz=[];
        for n_step=1:NStep
            Istep=intervalSet(0,StepTime*n_step*1E4);
            for od=1:length(OdorInfo(:,3))
                for dob=1:length(d_obj)
                    
                    tempTSD=TimeInSniff{od,dob};
                    SniffEpoch=thresholdIntervals(tempTSD,10^(-10),'Direction','Above');
                    stepSniffEpoch=and(Istep,SniffEpoch);
                    SniffLast(od,dob)=mean(Stop(stepSniffEpoch,'s')-Start(stepSniffEpoch,'s'));
                    stdSniffLast(od,dob)=stdError(Stop(stepSniffEpoch,'s')-Start(stepSniffEpoch,'s'));
                end
            end
            subplot(ceil(NStep/4),4,n_step)
            bar(SniffLast')
            try hold on, errorbar(sort([[1:size(SniffLast,2)]-0.15,[1:size(SniffLast,2)]+0.15])',SniffLast(:),stdSniffLast(:),'+k');end
            
            title(['Record 0-',num2str(StepTime*n_step),'s '])
            set(gca,'XTick',1:2:length(d_obj))
            set(gca,'XTickLabel',num2str(d_obj(1:2:end)'))
            if n_step>(ceil(NStep/4)-1)*4, xlabel('Distance from object (cm)');end
            if rem(n_step,12)==5, ylabel('Mean time spent at Odor location (s)');end
            
            ylimaz=[ylimaz,ylim];
        end
        legend(OrderLabel(OdorInfo(:,3)))
        
        for n_step=1:NStep
            subplot(ceil(NStep/4),4,n_step)
            ylim([min(ylimaz),max(ylimaz)]);
            if n_step==2, text(0,1.5*max(ylim),folderPhase(max(strfind(folderPhase,mark))+1:end));end
        end
        
        
        
        % --------------------------------------------------
        % -------------- Closing windows -------------------
        
        disp('Wait for you before closing (press any key)!')
        pause;
        for fi=1:4, try close(numF(fi));end;end
        
    end


 % -----------------------------------------------------------------
%% display tracking and save figure for all phases
    function Genrat_figureALL(obj,event)
        
        temptempLoad=load([folder_name,mark,'AroundOdor.mat']);
        OdorInfo=temptempLoad.OdorInfo;
        Ratio_IMAonREAL=temptempLoad.Ratio_IMAonREAL;
        imageRef=temptempLoad.imageRef;
        
        figure('Color',[1 1 1],'Position',scrsz), numF=gcf;
        % recap
        subplot(4,4,[1,2,5,6]), imagesc(imageRef), colormap gray
        line([10 20]*Ratio_IMAonREAL,[10 10],'Color','k','Linewidth',3)
        text(15*Ratio_IMAonREAL,15,'10 cm','Color','k')
        for i=1:size(OdorInfo,1)
            hold on, plot(OdorInfo(i,1),OdorInfo(i,2),['+',colori{OdorInfo(i,3)}])
            text(OdorInfo(i,1)+2,OdorInfo(i,2)+2,OrderLabel{OdorInfo(i,3)}(1:4),'Color',colori{OdorInfo(i,3)});
            circli = rsmak('circle',OdorInfo(i,4),[OdorInfo(i,1),OdorInfo(i,2)]);
            hold on, fnplt(circli,'Color',colori{OdorInfo(i,3)})
        end
        title(folder_name(max(strfind(folder_name,mark))+1:strfind(folder_name,'hase')-2))
        ylabel('Odor Location and types')
        
        % analyze for all phases
        indexplot=[3 4 7 8 8 8];
        timeInZone=NaN(size(OdorInfo,1)*nPhase,3);
        perctime=NaN(size(OdorInfo,1),nPhase);
        AllMatSum={};
        for i=1:nPhase
            clear ZoneOdor MatSum
            filename=folder_name;
            filename(strfind(folder_name,'Phase'):strfind(folder_name,'Phase')+5)=ListOfPhases{i};
            temptempLoad=load([filename,mark,'AroundOdor.mat']);
            ZoneOdor=temptempLoad.ZoneOdor;
            AllMatSum{i}=temptempLoad.MatSum;
            
            % occupation of the whole phase
            oneZoneOdor=ZoneOdor;
            oneZoneOdor(oneZoneOdor>1)=1;
            subplot(4,4,indexplot(i)), imagesc(AllMatSum{i}),
            for j=1:size(OdorInfo,1)
                hold on, plot(OdorInfo(j,1),OdorInfo(j,2),'+w')
            end
            title(ListOfPhases(i))
            % occupation in odor zone
            subplot(4,4,indexplot(i)+8), imagesc(AllMatSum{i}.*oneZoneOdor),
            title(ListOfPhases(i))
            
            % define a mask for each zone
            for od=1:size(OdorInfo,1)
                temp=zeros(size(ZoneOdor));
                temp(ZoneOdor==od)=1;
                Zones{od}=temp;
            end
            
            % quantif
            for od=1:size(OdorInfo,1)
                perctime(od,i)=sum(sum(AllMatSum{i}.*Zones{od}))/sum(sum(AllMatSum{i}.*oneZoneOdor))*100;
                timeInZone((i-1)*nPhase+od,:)=[i,OdorInfo(od,3),perctime(od,i)];
            end
        end
        
        subplot(4,4,[9 10 13 14]), bar(perctime) , ylim([0 100])
        set(gca,'XTick',1:size(OdorInfo,1))
        set(gca,'XTickLabel',OrderLabel(OdorInfo(:,3)))
        ylabel('Percentage time spent in odor zone')
        xlabel('odor location type through phases')
        title(['Exploration of Odor Zones, PHASE ',num2str(folderPhase(strfind(folderPhase,'hase')+4))]);
        legend(ListOfPhases);
        
        disp(['Saving Analysis and Figure of ',folder_name(max(strfind(folder_name,mark))+1:strfind(folder_name,'hase')-2),'...'])
        whereToSave=[folder_name(1:max(strfind(folder_name,mark))),'Analyze_',folder_name(max(strfind(folder_name,mark))+1:strfind(folder_name,'hase')-2)];
        copyfile([folder_name,mark,'AroundOdor.mat'],whereToSave);
        save(whereToSave,'perctime','OdorInfo','AllMatSum','ListOfPhases') 
        saveFigure(numF,['Figure_',folder_name(max(strfind(folder_name,mark))+1:strfind(folder_name,'hase')-2)],folder_name(1:max(strfind(folder_name,mark))-1))
        
        
        if sum(strcmp(NameLoadedExpe,folder_name))==0, NameLoadedExpe=[NameLoadedExpe,{folder_name}];end
        strNameLoaded=strjoin([{'Name Expe'},NameLoadedExpe],'|');
        set(maskbutton(15),'Style', 'popup','String',strNameLoaded);
        if length(NameLoadedExpe)>1
            set(maskbutton(14),'enable','on','FontWeight','bold')
        end
        
    end
        

 % -----------------------------------------------------------------
 %% display tracking and save figure for all phases
    function Genrat_figureALLEXPE(obj,event)
        
        StepTimeImposed=[60 120 180 240]; %time in sec
        d_objImposed=[1 2 3]; % distance to object (cm)
        PercExcluOnObj=50;% remove if 50% of the animal is inside OdorZone
        nPhase=3;
        % --------------------------------------------------
        % -------------- get all experiments --------------
        try
            tempLoadNames=load([res,mark,'NameExpeToAnalyze.mat']);
            NameExpeToAnalyze=tempLoadNames.NameExpeToAnalyze;
        catch
            disp('Run Expe All niht !!!!!!!!!!')
        end
        
        
        % --------------------------------------------------------
        % ------------------ RUN ANALYSIS ----------------------
        
        if exist('NameExpeToAnalyze','var')

            MatExpe={};
            for nam=1:length(NameExpeToAnalyze)
                
                % get info
                folder_name=NameExpeToAnalyze{nam};
                indexN=strfind(folder_name,'-');
                indexN=indexN(indexN>max(strfind(folder_name,'Mouse-')));
                nMouse=str2num(folder_name(indexN(1)+1:indexN(2)-1));
                disp(' ')
                disp([' * * * Mouse ',num2str(nMouse),' * * *']);
                
                % ------------- LOAD DATA from Mouse --------------
                Tempreload=load([folder_name,mark,'AroundOdor.mat']);
                OdorInfo=Tempreload.OdorInfo;
                ListOfPhases=Tempreload.ListOfPhases;
                
                for ph=1:nPhase
                    fctPhase=ph;
                    nPhase=str2num(ListOfPhases{fctPhase}(length(ListOfPhases{fctPhase})));
                    
                    % --------------- load file phase ---------------
                    filename=folder_name;
                    filename(strfind(folder_name,'Phase'):strfind(folder_name,'Phase')+5)=ListOfPhases{fctPhase};
                    ok=0;n=0;
                    length_end=length(filename(max(strfind(filename,'-')):end));
                    while n<9 && ok==0
                        n=n+1; numRec=['0',num2str(n)];
                        folderPhase=filename;
                        folderPhase(length(filename)-length_end-1:length(filename)-length_end)=numRec;
                        try tempn=load([folderPhase,mark,'InfoTracking.mat']);ok=1;end
                    end
                    disp(['        ',ListOfPhases{fctPhase},': ',folderPhase(max(strfind(folderPhase,mark)):end)]);
                    
                    
                    % ------------- LOAD DATA from Phase --------------
                    copyfile([folderPhase,mark,'AroundOdor.mat'],['/media/DataMOBs16/ProjetBULB/AnalyzeOdorRecognition-25062014/Mouse',num2str(nMouse),'-Phase',num2str(nPhase),'-AroundOdor.mat'])
                    Tempreload=load([folderPhase,mark,'AroundOdor.mat']);
                    Name_CaractSniff=Tempreload.Name_CaractSniff;
                    CaractSniff=Tempreload.CaractSniff;
                    TimeInSniff=Tempreload.TimeInSniff;
                    
                    % ----------------------------------------------------
                    % -------------- START LOOP to fill MatExpe ----------
                    for dob=1:length(d_objImposed)
                        
                        for n_step=1:length(StepTimeImposed)
                            
                            MatExpeTemp=[];
                            for od=1:length(OdorInfo(:,3))
                                
                                % restrict to all conditions
                                indexTS=find(CaractSniff(:,1)<StepTimeImposed(n_step) & CaractSniff(:,4)==OdorInfo(od,3) & CaractSniff(:,3)==d_objImposed(dob) & CaractSniff(:,6)<PercExcluOnObj);
                                
                                % Odor Loc
                                MatExpeTemp(od,1:3)=[nMouse, nPhase, OdorInfo(od,3)];
                                
                                % mean Time In Sniff
                                tempTSD=tsd(CaractSniff(indexTS,1)*1E4,CaractSniff(indexTS,6));
                                SniffEpoch=thresholdIntervals(tempTSD,10^(-10),'Direction','Above');
                                MatExpeTemp(od,4)=mean(Stop(SniffEpoch,'s')-Start(SniffEpoch,'s'));
                                
                                % sumPresence
                                MatExpeTemp(od,5)=sum(CaractSniff(indexTS,5));
                            end
                            
                            % Mouse - Phase - OdorLoc - meanTimeInSniff - sumPresence
                            tempMat=MatExpe{dob,n_step};
                            MatExpe{dob,n_step}=[tempMat; MatExpeTemp];
                            
                        end
                        
                    end
                    % --------------------------------------------------
                    disp('-> Done')
                end
                
            end
            
            disp('-> saving in ProjetBULB/AnalyzeOdorRecognition-25062014/MatExpe.mat')
            save('/media/DataMOBs16/ProjetBULB/AnalyzeOdorRecognition-25062014/MatExpe.mat','MatExpe')
            
            
            
            
            
            % --------------------------------------------------
            % ----------- Display Time in sniff in odor zone -----------
            
            figure('Color',[1 1 1],'Position',scrsz), numF(4)=gcf;
            ylimaz=[];
            
            
            
        end
    end
end

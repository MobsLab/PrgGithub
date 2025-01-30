function [numF,filename]=TimeAroundOdor_object;

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
global WhereInFrames
global enableTrack
global MatSum
global ZoneOdor
global freqAcquisition
global NameLoadedExpe

% INITIATE
CircularObj=1; % 1 if object is circular
color_on = [ 0 0 0];
color_off= [0.5 0.5 0.5];    
nCTRL=0;
nVARI=1;
nFIXE=1;
nPhase=1;
d_obj=2; % distance from odor object to include
rad_obj=2; % radius circular objets
OrderLabel={'CTRL','VARIANT','FIXED'}; %default {'CTRL','VARIANT','FIXED'}
PercExclu=[20 35 50 65 80]; % of animal size in odor zone
freqAcquisition=10; % set to 20 Hz to have real time video..
maxspeed=100; % frames/sec
StepTime=15; % in sec, time for step analysis
% anoying problems
res=pwd;
if isempty(strfind(res,'/')),mark='\'; else  mark='/';end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% graphical interface n�1 with all the pushbuttons

 Fig_Odor=figure('units','normalized','position',[0.15 0.1 0.8 0.8],...
            'numbertitle','off','name','Define Odor Locations','menubar','none','tag','figure Odor');
        set(Fig_Odor,'Color',color_off);
        
        maskbutton(1)= uicontrol(Fig_Odor,'style','pushbutton',...
            'units','normalized','position',[0.25 0.9 0.2 0.05],...
            'string','New Experiment / Reset','callback', @Reset);
        
        maskbutton(2)= uicontrol(Fig_Odor,'style','pushbutton',...
            'units','normalized','position',[0.01 0.75 0.08 0.05],...
            'string','INPUTS','callback', @giv_inputs);
        set(maskbutton(2),'enable','off')
        
        inputDisplay(1)=uicontrol(Fig_Odor,'style','text','units','normalized','position',[0.01 0.82 0.75 0.02],'string','Filename = TO DEFINE');
        inputDisplay(2)=uicontrol(Fig_Odor,'style','text','units','normalized','position',[0.6 0.95 0.1 0.02],'string',['nb phase = ',num2str(nPhase)]);
        inputDisplay(3)=uicontrol(Fig_Odor,'style','text','units','normalized','position',[0.8 0.95 0.1 0.02],'string',['nCTRL = ',num2str(nCTRL)]);
        inputDisplay(4)=uicontrol(Fig_Odor,'style','text','units','normalized','position',[0.8 0.9 0.1 0.02],'string',['nVARI = ',num2str(nVARI)]);
        inputDisplay(5)=uicontrol(Fig_Odor,'style','text','units','normalized','position',[0.8 0.85 0.1 0.02],'string',['nFIXE = ',num2str(nFIXE)]);        
        inputDisplay(6)=uicontrol(Fig_Odor,'style','text','units','normalized','position',[0.6 0.9 0.1 0.02],'string',['d from obj = ',num2str(d_obj),'cm']); 
        inputDisplay(7)=uicontrol(Fig_Odor,'style','text','units','normalized','position',[0.6 0.85 0.1 0.02],'string',['size obj = ',num2str(rad_obj),'cm']); 
        inputDisplay(8)=uicontrol(Fig_Odor,'style','text','units','normalized','position',[0.6 0.07 0.3 0.02],'string','Time in recording: set to convenience'); 
        inputDisplay(9)=uicontrol(Fig_Odor,'style','text','units','normalized','position',[0.2 0.75 0.2 0.03],'string','Phase = undefined','FontSize',12);
        inputDisplay(10)=uicontrol(Fig_Odor,'style','text','units','normalized','position',[0.6 0.17 0.3 0.02],'string','Speed display: set to convenience'); 
        
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
            'units','normalized','position',[0.28 0.2 0.1 0.02],...
            'string','Mask Objects','callback', @Mask_object);
        set(maskbutton(7),'enable','off')
        
        maskbutton(8)= uicontrol(Fig_Odor,'style','pushbutton',...
            'units','normalized','position',[0.4 0.25 0.1 0.05],...
            'string','3- Track sniff','callback', @Track_sniff);
        set(maskbutton(8),'enable','off')
        
        maskbutton(9) = uicontrol(Fig_Odor,'style','slider',...
        'units','normalized','position',[0.6 0.1 0.35 0.02],'callback', @AdvancedFrame);
        set(maskbutton(9),'enable','off')
        
        maskbutton(10)= uicontrol(Fig_Odor,'style','pushbutton',...
            'units','normalized','position',[0.43 0.2 0.1 0.02],...
            'string','Stop tracking','callback', @stop_Phase);
        set(maskbutton(10),'enable','off')
        
        maskbutton(11)= uicontrol(Fig_Odor,'style','pushbutton',...
            'units','normalized','position',[0.01 0.18 0.1 0.05],...
            'string','FIGURE indiv','callback', @Genrat_figure);
        set(maskbutton(11),'enable','off')
        
        maskbutton(12) = uicontrol(Fig_Odor,'style','slider',...
        'units','normalized','position',[0.6 0.2 0.35 0.02],'callback', @Speed_display);
        set(maskbutton(12),'enable','off') 
        
        maskbutton(13)= uicontrol(Fig_Odor,'style','pushbutton',...
            'units','normalized','position',[0.01 0.11 0.15 0.05],...
            'string','SAVE + FIGURE EXPE','callback', @Genrat_figureALL);
        set(maskbutton(13),'enable','off')
        
        maskbutton(14)= uicontrol(Fig_Odor,'style','pushbutton',...
            'units','normalized','position',[0.01 0.04 0.2 0.05],...
            'string','SAVE + FIGURE ALL LOADED EXPE','callback', @Genrat_figureALLEXPE);
        set(maskbutton(14),'enable','off')
        
        strNameLoaded=strjoin([{'Name Expe'},NameLoadedExpe],'|');
        maskbutton(15)=uicontrol('Style', 'popup','String',strNameLoaded,'units','normalized','Position', [0.01 0.78 0.75 0.1]);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CALLED FUNCTIONS

% -----------------------------------------------------------------
%% start new expe / reset everything
    function Reset(obj,event)

        Ratio_IMAonREAL=[];
        OdorInfo=[];
        
        set(Fig_Odor,'Color',color_on);
        for i=1:10
            set(inputDisplay(i),'BackgroundColor',color_on,'ForegroundColor','w','FontWeight','bold')
        end
        set(inputDisplay(1),'string','Filename = TO DEFINE');
        set(maskbutton(2),'enable','on','FontWeight','bold')
        for i=4:13
            set(maskbutton(i),'enable','off','FontWeight','normal')
        end
        if exist('imageRef','var') && ~isempty(imageRef), 
            figure(Fig_Odor), subplot(1,2,1), hold off, 
            imagesc(imageRef),axis image, colormap gray;
        end
        
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
        
        save([res,mark,'TempAroundOdorOFF.mat'],'fctPhase','ListOfPhases','nPhase','nCTRL','nVARI','nFIXE','d_obj','folder_name','OrderLabel','PercExclu','rad_obj')

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
        
        % load frames from file
        folderPhase=[folder_name(1:max(index)),filename];
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
            imageRef=tempLoad.imageRef;
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
            set(maskbutton(8),'enable','on','FontWeight','bold') 
        end

        save([res,mark,'TempAroundOdorOFF.mat'],'-append','imageRef','OdorInfo','folderPhase','folderPhaseFrames','MatSum','Ratio_IMAonREAL')
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
    end


% -----------------------------------------------------------------
%% Click on odor locations

    function Odor_Location(obj,event)
        
        figure(Fig_Odor), subplot(1,2,1), imagesc(imageRef),axis image
        line([10 20]*Ratio_IMAonREAL,[10 10],'Color','k','Linewidth',3)
        text(15*Ratio_IMAonREAL,15,'10 cm','Color','k')
        
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
        
        title(' do 3-')
        % mask: set(maskbutton(7),'enable','on','FontWeight','bold')
        set(maskbutton(8),'enable','on','FontWeight','bold') 
        
        save([res,mark,'TempAroundOdorOFF.mat'],'-append','OdorInfo')
    end

% -----------------------------------------------------------------
%% mask objects
%     function Mask_object(obj,event)
%         
%         ref2=imageRef;
%         mask=ones(size(imageRef));
%         % display masked figure
%         figure(Fig_Odor), subplot(1,2,2), hold off, imagesc(ref2),axis image
%         ObjInfo=[];
%         for j=1:(nVARI+nCTRL+nFIXE)
%             title(['Define object ',num2str(j),'to remove mounting on'],'Color','w')
%             if CircularObj
%                 hobj = imellipse;
%                 vert = getVertices(hobj);
%                 ObjInfo(j,1)= min(vert(:,1))+(max(vert(:,1))-min(vert(:,1)))/2;
%                 ObjInfo(j,2)= min(vert(:,2))+(max(vert(:,2))-min(vert(:,2)))/2;
%                 ObjInfo(j,3)= max((max(vert(:,1))-min(vert(:,1))),(max(vert(:,2))-min(vert(:,2))))/2;
%                 BW =  createMask(hobj);
%             else
%                 [x1,y1,BW,y2]=roipoly(ref2);
%                 ObjInfo(j,1)= min(x1)+(max(x1)-min(x1))/2;
%                 ObjInfo(j,2)= min(y1)+(max(y1)-min(y1))/2;
%                 ObjInfo(j,3)= max((max(x1)-min(x1)),(max(y1)-min(y1)))/2;
%             end
%             maskint=uint8(BW);
%             maskint=uint8(-(double(maskint)-1));
%             mask=uint8(double(mask).*double(maskint));
%             ref2((find(mask==0)))=0;
%             figure(Fig_Odor), subplot(1,2,2), imagesc(ref2),axis image
%         end
%         maskobj=zeros(size(imageRef));
%         maskobj((find(mask==0)))=1;
%         
%         % OdorInfo= x y odorType radius
%         loadTEMP=load([res,mark,'TempAroundOdorOFF.mat']);
%         OdorInfo=loadTEMP.OdorInfo;
%         Ratio_IMAonREAL=loadTEMP.Ratio_IMAonREAL;
%         
%         for ob=1:size(ObjInfo,1)   
%             [valminimi,minimi]=min(abs(OdorInfo(:,1)-ObjInfo(ob,1))+abs(OdorInfo(:,2)-ObjInfo(ob,2)));
%             OdorInfo(minimi,4)=ObjInfo(ob,3)+d_obj*Ratio_IMAonREAL;
%         end
%         % harmonise object zones
%         maxdist=max(OdorInfo(:,4)); 
%         OdorInfo(:,4)=ones(length(OdorInfo(:,4)),1)*maxdist;
%         
%         % final display, masked
%         figure(Fig_Odor), subplot(1,2,1), imagesc(imageRef),axis image
%         line([10 20]*Ratio_IMAonREAL,[10 10],'Color','k','Linewidth',3)
%         text(15*Ratio_IMAonREAL,15,'10 cm','Color','k')
%         for i=1:size(OdorInfo,1)
%             hold on, plot(OdorInfo(i,1),OdorInfo(i,2),['+',colori{OdorInfo(i,3)}])
%             text(OdorInfo(i,1)+2,OdorInfo(i,2)+2,OrderLabel{OdorInfo(i,3)}(1:4),'Color',colori{OdorInfo(i,3)});
%             circli = rsmak('circle',OdorInfo(i,4),[OdorInfo(i,1),OdorInfo(i,2)]);
%             hold on, fnplt(circli,'Color',colori{OdorInfo(i,3)})
%         end
%         
%         save([res,mark,'TempAroundOdorOFF.mat'],'-append','OdorInfo','ObjInfo','maskobj')
%     end


% -----------------------------------------------------------------
%% track mouse
    function Track_sniff(obj,event)
        
        for i=[1,2,4:8]
            set(maskbutton(i),'enable','off','FontWeight','normal')
        end
        enableTrack=1;
        set(maskbutton(10),'enable','on','FontWeight','bold')
        
        set(maskbutton(12),'enable','on','FontWeight','bold')
        set(maskbutton(12),'Value',freqAcquisition/maxspeed);
        set(inputDisplay(10),'string',['Speed display: ',num2str(freqAcquisition),' frames/s']);
        
        % -------------------
        % RELOAD EVERYTHING
        loadTEMP=load([res,mark,'TempAroundOdorOFF.mat']);
        rad_obj=loadTEMP.rad_obj;
        OdorInfo=loadTEMP.OdorInfo;
        Ratio_IMAonREAL=loadTEMP.Ratio_IMAonREAL;
        if size(OdorInfo,2)==3
            OdorInfo(:,4)=ones(size(OdorInfo,1),1)*(d_obj+rad_obj)*Ratio_IMAonREAL;
        end   
        
        
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
                end
            end
        end
        
        % maskIN odor zone and mask obj
        ZoneOdor=zeros(size(imageRef));
        maskobj=zeros(size(imageRef));
        for od=1:size(OdorInfo,1)
            figure, imagesc(imageRef);
            %ZoneOdor
            hobj = imellipse(gca, [OdorInfo(od,1)-OdorInfo(od,4) OdorInfo(od,2)-OdorInfo(od,4) 2*OdorInfo(od,4) 2*OdorInfo(od,4)]);
            BW = createMask(hobj);
            ZoneOdor=ZoneOdor+BW*od;
            %maskobj
            hobj = imellipse(gca, [OdorInfo(od,1)-rad_obj*Ratio_IMAonREAL OdorInfo(od,2)-rad_obj*Ratio_IMAonREAL 2*rad_obj*Ratio_IMAonREAL 2*rad_obj*Ratio_IMAonREAL]);
            BW = createMask(hobj);
            maskobj=maskobj+BW;
            close;
        end
        oneZoneOdor=ZoneOdor;
        oneZoneOdor(oneZoneOdor>1)=1;
        
        % -------------------
        % display zone
        
        for i=1:2
            figure(Fig_Odor), subplot(1,2,i),
            if i==1
                htrack = imagesc(imageRef);axis image;tempscaxis=caxis;
                line([10 20]*Ratio_IMAonREAL,[10 10],'Color','k','Linewidth',3)
                text(15*Ratio_IMAonREAL,15,'10 cm','Color','k')
                hold on, g = plot(0,0,'+w');
            else
                htrack2 = imagesc(imageRef);axis image;
            end
            
            for ob=1:size(OdorInfo,1)
                hold on, plot(OdorInfo(ob,1),OdorInfo(ob,2),['+',colori{OdorInfo(ob,3)}])
                if i==1, text(OdorInfo(ob,1)+2,OdorInfo(ob,2)+2,OrderLabel{OdorInfo(ob,3)}(1:4),'Color',colori{OdorInfo(ob,3)});end
                circli = rsmak('circle',OdorInfo(ob,4),[OdorInfo(ob,1),OdorInfo(ob,2)]);
                hold on, fnplt(circli,'Color',colori{OdorInfo(ob,3)})
            end
        end
        
        % -------------------
        % find file of this given Phase
        lis=dir(folderPhase);
        for li=1:length(lis)
            if strfind(lis(li).name,'-000')
                disp(['Analyzing ',lis(li).name,', discarding rest...'])
                folderPhaseFrames=[folderPhase,mark,lis(li).name];
                list=dir(folderPhaseFrames);
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
        set(maskbutton(9),'enable','on','FontWeight','bold') 
        WhereInFrames=0;temp_WhereInFrames=0;
        set(maskbutton(9),'Value',WhereInFrames);
        fr=3;frameDone=0; Tstep=1; Tdeb=0;
        PosMat=NaN(length(list),4);
        
        if enableTrack==0, 
            fr=length(list);
        else
            figure(Fig_Odor), subplot(1,2,2), caxis([0 1]);
        end
        
       % -----------------------------------------------------------------
        % ----------------- START LOOP ---------------------
        while fr~=length(list)
            if enableTrack==0,
                fr=length(list)-1;
            end
            % replay asked by user
            if temp_WhereInFrames~=WhereInFrames
                fr=round(max(WhereInFrames*length(list),3));
                if fr>frameDone, fr=frameDone; WhereInFrames=fr/length(list);end
                temp_WhereInFrames=WhereInFrames;
            end
            
            try
                disp(list(fr).name)
                ttdeb=clock;
                clear datas IM diff_im frames
                
                frames=load([folderPhaseFrames,mark,list(fr).name]);
                t1=frames.datas.time;
                if Tdeb==0, Tdeb=t1;end
                Timeframe=etime(t1,Tdeb);
                set(inputDisplay(8),'string',['Time in recording: ',num2str(fr),'/',num2str(length(list)),'  -  rec ',num2str(frameDone)]); 
                
                %get image
                IM=frames.datas.image;
                
                set(htrack,'Cdata',IM);
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
                
                %display video, mouse position and occupation map
                %set(htrack2,'Cdata',diff_im);
                if size(centroids) == [1 2]
                    set(g,'Xdata',centroids(1),'YData',centroids(2))
                    
                    PosMat(fr,1)=Timeframe;
                    PosMat(fr,2)=centroids(1);
                    PosMat(fr,3)=centroids(2);
                    
                    if sum( (centroids(1)-OdorInfo(:,1)).*(centroids(1)-OdorInfo(:,1)) + (centroids(2)-OdorInfo(:,2)).*(centroids(2)-OdorInfo(:,2)) <= rad_obj^2 )
                        imageTrav=zeros(size(diff_im));
                        PosMat(fr,4)=0;
                    else
                        PosMat(fr,4)=1;
                        imageTrav=diff_im*0.3+diff_im.*oneZoneOdor*0.7-diff_im.*maskobj;
                        
                        % -------------------------------------------------
                        % ----------------- DETECT SNIFF
                        % ----------------------
                        for pep=1:length(PercExclu)
                            if sum(sum(diff_im.*oneZoneOdor)) < sum(sum(diff_im))*PercExclu(pep)/100 && fr>frameDone
                                try
                                    tempMat=MatSumTemp{pep};
                                catch
                                    tempMat=zeros(size(imageRef));
                                end
                                MatSumTemp{pep}=tempMat+diff_im.*abs(maskobj-1);
                            end
                        end
                        % ---------------------
                    end
                else
                    set(g,'Xdata',0,'YData',0)
                    PosMat(fr,:)=[Timeframe;NaN;NaN;NaN];
                end
                set(htrack2,'Cdata',imageTrav);

                if Timeframe-Tstep*StepTime >= 0 && enableTrack
                    answer = inputdlg({'Nb sniff VARIANT','Nb sniff FIXED'},'Enter number of sniffs',1,{'0','0'});
                    Tstep=Tstep+1;
                    MatSum(1:length(PercExclu),Tstep)=MatSumTemp';
                    MatSumTemp={};
                    Nsniff(Tstep,1:2)=[str2num(answer{1}),str2num(answer{2})];
                end
                
                if fr>frameDone && enableTrack, frameDone=fr;end
                
                ttfin=clock;
                pause(1/freqAcquisition - etime(ttfin,ttdeb))
                
            catch
                if length(list(fr).name)>5 && strcmp(list(fr).name,'frame'), disp(['Problem ',list(fr).name]);end
            end
            
            fr=fr+1;
            set(maskbutton(9),'Value',fr/length(list));
            
            
        end
        
        % ---------------------------------------------------------------
        % --------------------- SAVE EVERYTHING ---------------------------
        save([res,mark,'TempAroundOdorOFF.mat'],'-append','maskobj','OdorInfo','ZoneOdor'); 
        if (length(list)-frameDone)<5, 
            save([res,mark,'TempAroundOdorOFF.mat'],'-append','MatSum','Nsniff','PosMat') ;
        end
        disp('All is saved in TempAroundOdorOFF.mat... Copying in :')
        disp(['   -> ',[folderPhase,mark,'AroundOdor.mat']])
        pause(2)
        try copyfile([res,mark,'TempAroundOdorOFF.mat'],[folderPhase,mark,'AroundOdor.mat']); catch, keyboard; end
        disp('     Done!')
        
        set(maskbutton(9),'enable','off','FontWeight','normal') 
        set(maskbutton(10),'enable','off','FontWeight','normal')
        set(maskbutton(12),'enable','off','FontWeight','normal')
        enableTrack=0;
        for i=[1,2,4:8,11]
            set(maskbutton(i),'enable','on','FontWeight','bold')
        end
        
        
        
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
        
    end

% -----------------------------------------------------------------
%% stop tracking
    function stop_Phase(obj,event)
        pause(0.001)
        enableTrack=0;
        WhereInFrames=1;
        set(maskbutton(4),'enable','on','FontWeight','bold')
        set(maskbutton(10),'enable','off','FontWeight','normal')
    end


% -----------------------------------------------------------------
%% adapt to frame
    function AdvancedFrame(obj,event)
        pause(0.2)
        WhereInFrames = (get(maskbutton(9),'value'));
        set(maskbutton(9),'Value',WhereInFrames);
    end

% -----------------------------------------------------------------
%% adapt to frame
    function Speed_display(obj,event)
        pause(0.2)
        freqAcquisition = (get(maskbutton(12),'value'))*maxspeed;
        if freqAcquisition<0.5, freqAcquisition=0.5;end
            set(maskbutton(12),'Value',freqAcquisition/maxspeed);
        set(inputDisplay(10),'string',['Speed display: ',num2str(freqAcquisition),' frames/s']);
    end


% -----------------------------------------------------------------
%% display tracking and save figure
    function Genrat_figure(obj,event)
        
        set(maskbutton(11),'enable','off','FontWeight','normal')
        tempLoadphase=load([folderPhase,mark,'AroundOdor.mat']);
        OdorInfo=tempLoadphase.OdorInfo;
        MatSum=tempLoadphase.MatSum;
        ZoneOdor=tempLoadphase.ZoneOdor;
            
            
        figure('Color',[1 1 1],'Position',scrsz); numF=gcf;
        
        % recap
        subplot(2,2,1), imagesc(imageRef), colormap gray
        line([10 20]*Ratio_IMAonREAL,[10 10],'Color','k','Linewidth',3)
        text(15*Ratio_IMAonREAL,15,'10 cm','Color','k')
        for i=1:size(OdorInfo,1)
            hold on, plot(OdorInfo(i,1),OdorInfo(i,2),['+',colori{OdorInfo(i,3)}])
            text(OdorInfo(i,1)+2,OdorInfo(i,2)+2,OrderLabel{OdorInfo(i,3)}(1:4),'Color',colori{OdorInfo(i,3)});
            circli = rsmak('circle',OdorInfo(i,4),[OdorInfo(i,1),OdorInfo(i,2)]);
            hold on, fnplt(circli,'Color',colori{OdorInfo(i,3)})
        end
        index=strfind(folderPhase,mark);
        filenametemp=folderPhase(max(index)+1:length(folderPhase));
        title(filenametemp)
        xlabel('Odor Location and types')
        
        % occupation in odor zone
        oneZoneOdor=ZoneOdor;
        oneZoneOdor(oneZoneOdor>1)=1;
        subplot(2,2,2), imagesc(MatSum.*(oneZoneOdor)),
        title('Occupation in odor zones')
        
        % define a mask for each zone
        for od=1:size(OdorInfo,1)
            temp=zeros(size(ZoneOdor));
            temp(ZoneOdor==od)=1;
            Zones{od}=temp;
        end
        
        % quantif
        timeInZone=NaN(size(OdorInfo,1),2);
        for od=1:size(OdorInfo,1)
            perctime=sum(sum(MatSum.*Zones{od}))/sum(sum(MatSum.*oneZoneOdor))*100;
            timeInZone(od,:)=[perctime,OdorInfo(od,3)];
        end
        subplot(2,2,3), bar(timeInZone(:,1)) , ylim([0 100])
        set(gca,'XTick',1:size(OdorInfo,1))
        set(gca,'XTickLabel',OrderLabel(OdorInfo(:,3)))
        ylabel('Percentage time spent in odor zone')
        xlim([0 max(5,size(OdorInfo,1))])
        xlabel('odor location type through phases')
        title(['Exploration of Odor Zones, PHASE ',num2str(folderPhase(strfind(folderPhase,'hase')+4))]);
        
        disp(['Saving Figure_',filenametemp])
        saveFigure(numF,['Figure_',filenametemp],folderPhase(1:max(strfind(folderPhase,mark)-1)))

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

        figure('Color',[1 1 1],'Position',scrsz), numF=gcf;
        
        % MATT = expe - phase - odor type - % time around zone
        MATT=[];
        for exp=1:length(NameLoadedExpe)
            clear 
            % load expe analyzis
            fold_expe=NameLoadedExpe{exp};
            whereToSave=[fold_expe(1:max(strfind(fold_expe,mark))),'Analyze_',fold_expe(max(strfind(fold_expe,mark))+1:strfind(fold_expe,'hase')-2)];
            temptempLoad=load(whereToSave);
            perctime=temptempLoad.perctime;
            OdorI=temptempLoad.OdorInfo;
            Phases=temptempLoad.ListOfPhases;
            
            % get info
           
            nMouse=str2num(fold_expe(strfind(fold_expe,'Mouse-')+6));
            
            
            % create big matrice
            MattTemp=[];
            for ph=1:length(Phases)
                numPh=str2num(ListOfPhases{ph}(length(ListOfPhases{ph})));
                MattTemp=[MattTemp ; [zeros(size(OdorI,1),1)+numPh, OdorI(:,3), perctime(:,ph)]];
            end
            MATT=[MATT;[zeros(size(MattTemp,1),1)+nMouse zeros(size(MattTemp,1),1)+exp, MattTemp]];
            
        end
        save(res,'perctime','OdorInfo','AllMatSum','ListOfPhases','NameLoadedExpe') 
        saveFigure(numF,'Figure_Bilan_OdorRecog',res)
        
    end
end

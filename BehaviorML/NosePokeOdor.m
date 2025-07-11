function [numF,filename]=NosePokeOdor(~,~)

%% INPUTS
flashEnd=0;
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
global d_obj
%global OrderLabel
global Ratio_IMAonREAL
global OdorInfo
global enableTrack
%global MatSum
global ZoneOdor
global intermed
global BW_threshold2;
global smaller_object_size2;
global shape_ratio2;
global n_AutoStop
global num_exp
%d_obj=2;
d_obj=[0 0.5 1 1.5 2 2.5 3 3.5]; % distance from odor object to include:
rad_obj=0;
nVARI=1;nCTRL=0;nFIXE=0;

intermed=load('InfoTrackingTemp.mat');
imageRef=intermed.ref;
vid=intermed.vid;
BW_threshold2=intermed.BW_threshold;
smaller_object_size2=intermed.smaller_object_size;
shape_ratio2=intermed.shape_ratio;
b_default=intermed.b_default;
c_default=intermed.c_default;
e_default=intermed.e_default;
namesOdor={'NaN','NaN','NaN'};
nPhase=NaN;

% INITIATE
CircularObj=1; % 1 if object is circular
color_on = [ 0 0 0];    
color_off = [1 1 1];
OrderLabel={'CTRL','VARIANT','FIXED'}; %default {'CTRL','VARIANT','FIXED'}
PercExclu=[20 35 50 65 80]; % of animal size
StepTime=15; % in sec for time step analysis
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
%% graphical interface n�1 with all the pushbuttons

 Fig_Odor=figure('units','normalized','position',[0.15 0.1 0.8 0.8],...
            'numbertitle','off','name','Define Odor Locations','menubar','none','tag','figure Odor');
        set(Fig_Odor,'Color',color_on);
        
        maskbutton(1)= uicontrol(Fig_Odor,'style','pushbutton',...
            'units','normalized','position',[0.01 0.85 0.1 0.05],...
            'string','INPUTS EXPE','callback', @giv_inputs);
        set(maskbutton(1),'enable','on','FontWeight','bold')
        
        maskbutton(2)= uicontrol(Fig_Odor,'style','pushbutton',...
            'units','normalized','position',[0.01 0.7 0.1 0.05],...
            'string','1- Real Distance','callback', @Real_distance);
        set(maskbutton(2),'enable','off')
        
        maskbutton(3)= uicontrol(Fig_Odor,'style','pushbutton',...
            'units','normalized','position',[0.01 0.55 0.1 0.05],...
            'string','2- Odor Location','callback', @Odor_Location);
        set(maskbutton(3),'enable','off')
        
        maskbutton(4)= uicontrol(Fig_Odor,'style','pushbutton',...
            'units','normalized','position',[0.025 0.51 0.08 0.03],...
            'string','Mask Objects','callback', @Mask_object);
        set(maskbutton(4),'enable','off')
        
        maskbutton(5)= uicontrol(Fig_Odor,'style','pushbutton',...
            'units','normalized','position',[0.01 0.4 0.1 0.05],...
            'string','3- Start Expe','callback', @start_Expe);
        set(maskbutton(5),'enable','off')
  
        maskbutton(6)= uicontrol(Fig_Odor,'style','pushbutton',...
            'units','normalized','position',[0.025 0.32 0.08 0.03],...
            'string','Restart Phase','callback', @Restart_Phase);
        set(maskbutton(6),'enable','off')
        
        maskbutton(7)= uicontrol(Fig_Odor,'style','pushbutton',...
            'units','normalized','position',[0.025 0.22 0.08 0.03],...
            'string','Stop emergency','callback', @stop_Phase);
        set(maskbutton(7),'enable','off')
        
        maskbutton(8)= uicontrol(Fig_Odor,'style','pushbutton',...
            'units','normalized','position',[0.01 0.1 0.1 0.05],...
            'string','CLOSE EXPE','callback', @quit);
        set(maskbutton(8),'enable','on','FontWeight','bold')
        
        inputDisplay(1)=uicontrol(Fig_Odor,'style','text','units','normalized','position',[0.15 0.05 0.5 0.02],'string','Filename = TO DEFINE');
        inputDisplay(2)=uicontrol(Fig_Odor,'style','text','units','normalized','position',[0.25 0.95 0.1 0.02],'string',['nb phase = ',num2str(nPhase)]);
        inputDisplay(3)=uicontrol(Fig_Odor,'style','text','units','normalized','position',[0.45 0.95 0.15 0.02],'string',['Odor1 = ',num2str(namesOdor{2})]);
        inputDisplay(4)=uicontrol(Fig_Odor,'style','text','units','normalized','position',[0.45 0.92 0.15 0.02],'string',['Odor2 = ',num2str(namesOdor{3})]);
        inputDisplay(5)=uicontrol(Fig_Odor,'style','text','units','normalized','position',[0.45 0.89 0.15 0.02],'string',['Solvant = ',num2str(namesOdor{1})]);        
        inputDisplay(6)=uicontrol(Fig_Odor,'style','text','units','normalized','position',[0.2 0.87 0.2 0.06],'string',['d from obj = ',num2str(d_obj),'cm']); 
        inputDisplay(7)=uicontrol(Fig_Odor,'style','text','units','normalized','position',[0.01 0.36 0.11 0.03],'string','Phase = ?','FontSize',12);
        inputDisplay(8)=uicontrol(Fig_Odor,'style','text','units','normalized','position',[0.6 0.94 0.2 0.02],'string','TASK = ?','FontSize',12);
        inputDisplay(9)=uicontrol(Fig_Odor,'style','text','units','normalized','position',[0.9 0.55 0.13 0.4],'string','ListOfPhase = ?');
        
        for bi=1:9, set(inputDisplay(bi),'BackgroundColor',color_on,'ForegroundColor','w','FontWeight','bold');end
        
        chronoshow=uicontrol('style','edit', 'units','normalized','position',[0.01 0.26 0.1 0.05],...
            'string',num2str(floor(0)),'ForegroundColor','g','BackgroundColor','k','FontSize',14);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CALLED FUNCTIONS

% -----------------------------------------------------------------
%% function to quit the programm
    function quit(obj,event)
        delete(Fig_Odor)
        %delete(FigGuiReg)
    end

% -----------------------------------------------------------------
%% Ask for all inputs and display
    function giv_inputs(obj,event)
        
        choice = questdlg('Please choose an experiment:','Discrimination/Detection', 'Discrimination','Detection','Discrimination');
        switch choice
            case 'Discrimination'
                namePhase={'Habituation','Solvant','NaN','Odor1','NaN','Odor1','NaN','Odor1','NaN','Odor1','NaN','Odor2','NaN'};
                nPhase=length(namePhase);
                lengthPhase=60*[5,2,5,2,5,2,5,2,5,2,5,2,5]; %time in second
                answer = inputdlg({'NumberMouse','Name of the Solvant','Name of the Odor1','Name of the Odor2','Start at phase'},'Odors',1,{'100','ParaffinOil','Vanillin','Eugenol','1'});
                namesOdor=answer(2:end-1);
                nmouse=str2num(answer{1});
                nameTASK='Discrimination';
                set(inputDisplay(4),'string',['Odor2 = ',num2str(namesOdor{3})]);
                startphase=str2num(answer{end});
            case 'Detection'
                typeDetect=2; % number of concentration
                if typeDetect==2 % 6 concentrations
                    namePhase={'Solvant','Solvant','Solvant','Odor1 C1','Solvant','Odor1 C2','Solvant','Odor1 C3','Solvant','Odor1 C4','Solvant','Odor1 C5','Solvant','Odor1 C6','Solvant'};
                    lengthPhase=60*[6,2,3,2,3,2,3,2,3,2,3,2,3,2,3]; %time in second
                    answer = inputdlg({'NumberMouse','Name of the Solvant','Name of the odor','Concentration C1','C2','C3','C4','C5','C6','Start at phase'},'Odors',1,{'100','Water','Vanillin','10-8','10-7','10-6','10-5','10-4','10-3','1'});
                elseif typeDetect==3 % 5 concentrations
                    namePhase={'Solvant','Solvant','Solvant','Odor1 C1','Solvant','Odor1 C2','Solvant','Odor1 C3','Solvant','Odor1 C4','Solvant','Odor1 C5','Solvant'};
                    lengthPhase=60*[6,2,3,2,3,2,3,2,3,2,3,2,3]; %time in second
                    answer = inputdlg({'NumberMouse','Name of the Solvant','Name of the odor','Concentration C1','C2','C3','C4','C5','Start at phase'},'Odors',1,{'100','Water','Vanillin','10-8','10-7','10-6','10-5','10-4','1'});
                elseif typeDetect==4
                    namePhase={'Habituation','Solvant','NaN','Solvant','NaN','Odor1 C1','NaN','Odor1 C2','NaN','Odor1 C3','NaN','Odor1 C4','NaN'};
                    lengthPhase=60*[5,2,3,2,3,2,3,2,3,2,3,2,3]; %time in second
                    answer = inputdlg({'NumberMouse','Name of the Solvant','Name of the odor','Concentration C1','C2','C3','C4','Start at phase'},'Odors',1,{'100','ParaffinOil','Vanillin','10-6','10-5','10-4','10-3','1'});
                elseif typeDetect==5
                    namePhase={'Habituation','Solvant','NaN','Solvant','NaN','Odor1 C1','NaN','Odor1 C2','NaN','Odor1 C3','NaN','Odor1 C4','NaN','Odor1 C5','NaN'};
                    lengthPhase=60*[5,2,3,2,3,2,3,2,3,2,3,2,3,2,3]; %time in second
                    answer = inputdlg({'NumberMouse','Name of the Solvant','Name of the odor','Concentration C1','C2','C3','C4','C5','Start at phase'},'Odors',1,{'100','ParaffinOil','Vanillin','10-8','10-7','10-6','10-5','10-4','1'});
                end
                nPhase=length(namePhase);
                namesOdor=answer(2:end-1);
                nmouse=str2num(answer{1});
                nameTASK='Detection';
                startphase=str2num(answer{end});
                set(inputDisplay(4),'string',['C1 to C',num2str(typeDetect),' = ',num2str(namesOdor{3}),' to ',num2str(namesOdor{end})]);
        end
        
        set(inputDisplay(2),'string',['nb phase = ',num2str(nPhase)]);
        set(inputDisplay(3),'string',['Odor1 = ',num2str(namesOdor{2})]);
        set(inputDisplay(5),'string',['Solvant = ',num2str(namesOdor{1})]); 
        set(inputDisplay(8),'string',['TASK = ',nameTASK]); 
        set(inputDisplay(9),'string',['ListOfPhase:',{' '},namePhase]);
        
        set(maskbutton(2),'enable','on','FontWeight','bold')
        disp(' ');disp('-------------------- New Expe ---------------------');
        save([res,mark,'TempAroundOdorON.mat'],'nmouse','nPhase','rad_obj','namePhase','lengthPhase','namesOdor','d_obj','nameTASK','OrderLabel','PercExclu','CircularObj','imageRef','startphase');
    end

% -----------------------------------------------------------------
%% Ask for all inputs and display
    function Real_distance(obj,event)
        
        figure(Fig_Odor), subplot(2,2,[1,3]), 
        imagesc(imageRef); colormap gray; axis image
        title('Click on two points to define a distance','Color','w')
        for j=1:2
            [x,y]=ginput(1);
            hold on, plot(x,y,'+r')
            x1(j)=x; y1(j)=y;
        end
        line(x1,y1,'Color','r','Linewidth',2)

        answer = inputdlg({'Enter real distance (cm):'},'Define Real distance',1,{'27'});
        text(mean(x1)+10,mean(y1)+10,[answer{1},' cm'],'Color','r')
        
        d_xy=sqrt((diff(x1)^2+diff(y1)^2));
        Ratio_IMAonREAL=d_xy/str2num(answer{1});
       
        title(' do 2-')
        hold on, line([10 20]*Ratio_IMAonREAL,[10 10],'Color','k','Linewidth',3)
        text(15*Ratio_IMAonREAL,15,'10 cm','Color','k')
        set(maskbutton(3),'enable','on','FontWeight','bold') 
        Ratio_IMAonREAL=Ratio_IMAonREAL;
        save([res,mark,'TempAroundOdorON.mat'],'-append','Ratio_IMAonREAL');
    end


% -----------------------------------------------------------------
%% Click on odor locations

    function Odor_Location(obj,event)
        
        % -------------------
        % Reload everything
        temp=load([res,mark,'TempAroundOdorON.mat']);
        Ratio_IMAonREAL=temp.Ratio_IMAonREAL;
        rad_obj=temp.rad_obj;
        
        figure(Fig_Odor), subplot(2,2,[1,3]), imagesc(imageRef),axis image
        line([10 20]*Ratio_IMAonREAL,[10 10],'Color','k','Linewidth',3)
        text(15*Ratio_IMAonREAL,15,'10 cm','Color','k')
        
        OdorInfo=[];ao=0;
        for OL=1:length(OrderLabel)
            if strcmp(OrderLabel{OL}(1:4),'VARI')
                nbOD=nVARI;
            elseif strcmp(OrderLabel{OL}(1:4),'CTRL')
                nbOD=nCTRL;
            elseif strcmp(OrderLabel{OL}(1:4),'FIXE')
                nbOD=nFIXE;
            end
            
            for od=1:nbOD
                title(['Click on ',OrderLabel{OL},' odor location','Color','w']) 
                temp=ginput(1); ao=ao+1;
                OdorInfo=[OdorInfo; [temp,OL]];
                hold on, plot(temp(1),temp(2),['+',colori{OL}])
                text(temp(1)+2,temp(2)+2,OrderLabel{OL}(1:4),'Color',colori{OL});
                circli = rsmak('circle',d_obj(round(length(d_obj)/2))*Ratio_IMAonREAL,[OdorInfo(ao,1),OdorInfo(ao,2)]);
                hold on, fnplt(circli,'Color',colori{OdorInfo(ao,3)})
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
            
            %Odor Zones
            for dob=1:length(d_obj)
                figure, imagesc(imageRef);
                hobj = imellipse(gca, [OdorInfo(od,1)-OdorInfo(od,3+dob) OdorInfo(od,2)-OdorInfo(od,3+dob) 2*OdorInfo(od,3+dob) 2*OdorInfo(od,3+dob)]);
                BW = createMask(hobj);
                try ZoneOdor{dob}=ZoneOdor{dob}+BW*od; catch, ZoneOdor{dob}=BW;end
                close;
            end            
        end
        
%         OdorInfo(:,4)=ones(size(OdorInfo(:,1)))*(d_obj+rad_obj)*Ratio_IMAonREAL;
%         % odor zone and mask obj
%         ZoneOdor=zeros(size(imageRef));
%         maskobj=zeros(size(imageRef));
%         for od=1:size(OdorInfo,1)
%             figure, imagesc(imageRef);
%             %ZoneOdor
%             hobj = imellipse(gca, [OdorInfo(od,1)-OdorInfo(od,4) OdorInfo(od,2)-OdorInfo(od,4) 2*OdorInfo(od,4) 2*OdorInfo(od,4)]);
%             BW = createMask(hobj);
%             ZoneOdor=ZoneOdor+BW*od;
%             %maskobj
%             hobj = imellipse(gca, [OdorInfo(od,1)-rad_obj*Ratio_IMAonREAL OdorInfo(od,2)-rad_obj*Ratio_IMAonREAL 2*rad_obj*Ratio_IMAonREAL 2*rad_obj*Ratio_IMAonREAL]);
%             BW = createMask(hobj);
%             maskobj=maskobj+BW;
%             close;
%         end
                
        set(maskbutton(5),'enable','on','FontWeight','bold')
        
        OdorInfo=OdorInfo;
        
        save([res,mark,'TempAroundOdorON.mat'],'-append','OdorInfo','ZoneOdor','maskobj');
    end

% -----------------------------------------------------------------
%% mask objects
    function Mask_object(obj,event)
        
        ref2=imageRef;
        mask=ones(size(imageRef));
        % display masked figure
        figure(Fig_Odor), subplot(2,2,2), hold off, imagesc(ref2),axis image
        ObjInfo=[];
        for j=1:(nVARI+nCTRL+nFIXE)
            title(['Define object ',num2str(j),'to remove mounting on'],'Color','w')
            if CircularObj
                hobj = imellipse;
                vert = getVertices(hobj);
                ObjInfo(j,1)= min(vert(:,1))+(max(vert(:,1))-min(vert(:,1)))/2;
                ObjInfo(j,2)= min(vert(:,2))+(max(vert(:,2))-min(vert(:,2)))/2;
                ObjInfo(j,3)= max((max(vert(:,1))-min(vert(:,1))),(max(vert(:,2))-min(vert(:,2))))/2;
                BW =  createMask(hobj);
            else
                [x1,y1,BW,y2]=roipoly(ref2);
                ObjInfo(j,1)= min(x1)+(max(x1)-min(x1))/2;
                ObjInfo(j,2)= min(y1)+(max(y1)-min(y1))/2;
                ObjInfo(j,3)= max((max(x1)-min(x1)),(max(y1)-min(y1)))/2;
            end
            maskint=uint8(BW);
            maskint=uint8(-(double(maskint)-1));
            mask=uint8(double(mask).*double(maskint));
            ref2((find(mask==0)))=0;
            figure(Fig_Odor), subplot(2,2,2), imagesc(ref2),axis image
        end
        maskobj=zeros(size(imageRef));
        maskobj((find(mask==0)))=1;
        
        % OdorInfo= x y odorType radius
        for ob=1:size(ObjInfo,1)   
            [valminimi,minimi]=min(abs(OdorInfo(:,1)-ObjInfo(ob,1))+abs(OdorInfo(:,2)-ObjInfo(ob,2)));
            OdorInfo(minimi,4)=ObjInfo(ob,3)+d_obj*Ratio_IMAonREAL;
        end
        % harmonise object zones
        maxdist=max(OdorInfo(:,4)); 
        OdorInfo(:,4)=ones(length(OdorInfo(:,4)),1)*maxdist;
        
        % final display, masked
        figure(Fig_Odor), subplot(2,2,[1,3]), imagesc(imageRef),axis image
        line([10 20]*Ratio_IMAonREAL,[10 10],'Color','k','Linewidth',3)
        text(15*Ratio_IMAonREAL,15,'10 cm','Color','k')
        for od=1:size(OdorInfo,1)
            hold on, plot(OdorInfo(od,1),OdorInfo(od,2),['+',colori{OdorInfo(od,3)}])
            text(OdorInfo(od,1)+2,OdorInfo(od,2)+2,OrderLabel{OdorInfo(od,3)}(1:4),'Color',colori{OdorInfo(od,3)});
            circli = rsmak('circle',OdorInfo(od,4),[OdorInfo(od,1),OdorInfo(od,2)]);
            hold on, fnplt(circli,'Color',colori{OdorInfo(od,3)})
        end
        OdorInfo=OdorInfo;
        ObjInfo=ObjInfo;
        maskobj=maskobj;
        save([res,mark,'TempAroundOdorON.mat'],'-append','OdorInfo','ObjInfo','maskobj');
    end

% -----------------------------------------------------------------
%% Interface of analysis
    function start_Expe(obj,event)
        enableTrack=1;
        templaod=load([res,mark,'TempAroundOdorON.mat']);
        tempstartphase=templaod.startphase;
        num_exp=0;
        num_phase=tempstartphase-1;
        
        prefix=['BULB-Mouse-' num2str(templaod.nmouse) '-' TodayIs '-'];
        
%         for bit=1:6
%             set(maskbutton(bit),'enable','off','FontWeight','normal')
%         end
        
        for nn=tempstartphase:templaod.nPhase
            if enableTrack
                num_phase=num_phase+1;
                startphase=num_phase;
                n_AutoStop=templaod.lengthPhase(nn);
                set(inputDisplay(7),'string',['Phase ',num2str(nn)]);
                
                % create folder to save tracking and analysis
                % ----------------------
                prefac=num2str(num_phase);
                if length(prefac)==1, prefac=cat(2,'0',prefac);end
                if strcmp(templaod.namePhase{nn},'Habituation') || strcmp(templaod.namePhase{nn},'NaN')
                    nameAdd=templaod.namePhase{nn};
                elseif strcmp(templaod.namePhase{nn},'Solvant')
                    nameAdd=templaod.namesOdor{1};
                elseif strcmp(templaod.namePhase{nn},'Odor1')
                    nameAdd=templaod.namesOdor{2};
                elseif strcmp(templaod.namePhase{nn},'Odor2')
                    nameAdd=templaod.namesOdor{3};
                elseif strcmp(templaod.namePhase{nn}(1:end-1),'Odor1 C')
                    nameAdd=[templaod.namesOdor{2},templaod.namesOdor{2+str2double(templaod.namePhase{nn}(end))}];
                end
                
                try, name_folder = [prefix prefac '-' templaod.nameTASK{:} nameAdd{:}]; catch, name_folder = [prefix prefac '-' templaod.nameTASK nameAdd];end
                while exist(name_folder,'file')
                    name_folder=[name_folder,'0'];
                end
                mkdir(name_folder);
                disp(name_folder)
                
                set(inputDisplay(1),'string',['Filename ',name_folder]);
                
                % save info in AroundOdorON
                % ----------------------
                save([res,mark,'TempAroundOdorON.mat'],'-append','OdorInfo','Ratio_IMAonREAL','ZoneOdor','name_folder','n_AutoStop')
                
                % reset MatSum and else in TempAroundOdorON
                MatSum=[]; Nsniff=[];
                save([res,mark,'TempAroundOdorON.mat'],'-append','MatSum','Nsniff','startphase');
                pause(0.1)
                Track_sniff;
            end
        end

  
    end

% -----------------------------------------------------------------
%% track mouse
    function Track_sniff(obj,event)
        num_exp=num_exp+1;
        disp('   Begining tracking...')
        guireg_fig=OnlineGuiReglage;
        % interface
        try fwrite(a,5);disp('Arduino ON');end
        %enableTrack=1;
        set(maskbutton(7),'enable','on','FontWeight','bold')
        
        % -------------------
        % reload everything
        tempLoad=load([res,mark,'TempAroundOdorON.mat']);
        ZoneOdor=tempLoad.ZoneOdor;
%         oneZoneOdor(oneZoneOdor>1)=1;
        imageRef=tempLoad.imageRef;
        OdorInfo=tempLoad.OdorInfo;
        Ratio_IMAonREAL=tempLoad.Ratio_IMAonREAL;
        maskobj=tempLoad.maskobj;
        n_AutoStop=tempLoad.n_AutoStop;
        name_folder=tempLoad.name_folder;

        % -------------------
        % display zone
        
        figure(Fig_Odor), subplot(2,2,[1,3]),
        htrack = imagesc(imageRef);axis image;
        line([10 20]*Ratio_IMAonREAL,[10 10],'Color','k','Linewidth',3)
        text(15*Ratio_IMAonREAL,15,'10 cm','Color','k')
        title('ACQUISITION ON')
        g=plot(0,0,'m+');
        
        figure(Fig_Odor), subplot(2,2,2),
        htrack2 = imagesc(zeros(size((imageRef))));axis image;caxis([0 1])
        xlabel('tracking online','Color','w')
        
        figure(Fig_Odor), subplot(2,2,4),
        htrack3 = imagesc(zeros(size((imageRef))));axis image;caxis([0 1])
        title('sniff detect','Color','w')
        
        indexsi={[1,3],4};
        for si=1:length(indexsi)
            figure(Fig_Odor), subplot(2,2,indexsi{si}),
            for ob=1:size(OdorInfo,1)
                hold on, plot(OdorInfo(ob,1),OdorInfo(ob,2),['+',colori{OdorInfo(ob,3)}])
                if si==1, text(OdorInfo(ob,1)+2,OdorInfo(ob,2)+2,OrderLabel{OdorInfo(ob,3)}(1:4),'Color',colori{OdorInfo(ob,3)});end
                circli = rsmak('circle',OdorInfo(ob,3+round(length(d_obj)/2)),[OdorInfo(ob,1),OdorInfo(ob,2)]);
                hold on, fnplt(circli,'Color',colori{OdorInfo(ob,3)})
            end
        end
        
        % display chrono
        time_image = 1/frame_rate;

        
        % -----------------------------------------------------------------
        % ---------------------- INITIATE TRACKING ------------------------
        n=1;
        num_fr=1;
        for pep=1:length(PercExclu)
            MatSum{pep}=zeros(size(imageRef));
        end
        
        prefac0=char; for ii=1:4-length(num2str(num_exp)), prefac0=cat(2,prefac0,'0'); end
        Fname=['F' TodayIs '-' prefac0 num2str(num_exp)];
        mkdir([name_folder mark Fname]);
        disp(['   ',Fname]);
        
        tDeb = clock;
        timeDeb = tDeb(4)*60*60+tDeb(5)*60+tDeb(6);
        PosMat=[];CaractSniff=[];
        while enableTrack
                % ---------------------------------------------------------
                % update chrono
                t1 = clock;
                chrono=(t1(4)*60*60+t1(5)*60+t1(6))-timeDeb;
                set(chronoshow,'string',[num2str(floor(chrono)),'/',num2str(n_AutoStop)]);
            
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
                if size(centroids) == [1 2]
                    set(g,'Xdata',centroids(1),'YData',centroids(2))
                    PosMat(num_fr,1)=chrono;
                    PosMat(num_fr,2)=centroids(1);
                    PosMat(num_fr,3)=centroids(2);
                    
                    if sum( (centroids(1)-OdorInfo(:,1)).*(centroids(1)-OdorInfo(:,1)) + (centroids(2)-OdorInfo(:,2)).*(centroids(2)-OdorInfo(:,2)) <= (rad_obj+1)^2 )
                        centerOnObj=1;
                    else
                        centerOnObj=0;
                    end
                    PosMat(num_fr,4)=centerOnObj;
                else
                    set(g,'Xdata',0,'YData',0)
                    PosMat(num_fr,:)=[chrono;NaN;NaN;NaN];
                    centerOnObj=0;
                end
                
                
                % ---------------------------------------------------------
                % --------------------- DETECT SNIFF ----------------------
                % time - CenterOnObj - d_obj - Odortype - SumInZone - %InZone - SumInZone_minusMaskobj
                
                for dob=1:length(d_obj)
                    
                    ZOtemp=ZoneOdor{dob};
                    % define odor zone for particular d_obj
                    tempMat=NaN(length(OdorInfo(:,1)),7);
                    for od=1:length(OdorInfo(:,1))
                        oneZoneOdor=zeros(size(ZOtemp));
                        oneZoneOdor(ZOtemp==od)=1;
                        % time - CenterOnObj - d_obj - Odortype - SumInZone - %InZone - SumInZone_minusMaskobj
                        tempMat(od,1:4)=[chrono, centerOnObj, d_obj(dob) , OdorInfo(od,3)];
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
                
                set(htrack3,'Cdata',imageTrav);
                
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
            t2 = clock; 
            if etime(t2,tDeb)> n_AutoStop+0.99
                enableTrack=0;
            end
            if (etime(t2,tDeb)> n_AutoStop-10) && (etime(t2,tDeb)< n_AutoStop-10+2*time_image)
                set(Fig_Odor,'Color','b'); 
                for bi=1:9, set(inputDisplay(bi),'BackgroundColor','b');end
            end
            pause(time_image-etime(t2,t1));
        end
        if etime(t2,tDeb)> n_AutoStop+0.99, enableTrack=1;end
        set(Fig_Odor,'Color',color_on);
        for bi=1:9, set(inputDisplay(bi),'BackgroundColor',color_on);end
        try fwrite(a,6);disp('Arduino OFF');end
%         %ask number of sniff
%         answer = inputdlg({'Nb sniff VARIANT','Nb sniff FIXED'},'Enter number of sniffs',1,{'0','0'});
%         Nsniff=[2,str2num(answer{1}); 3,str2num(answer{2})];
%         
        msg_box=msgbox('Saving AroundOdor and InfoTracking','save','modal');
        save([name_folder,mark,Fname,mark,'PosMat.mat'],'PosMat');
        save([res,mark,'InfoTrackingTemp.mat'],'-append','PosMat','frame_rate');
        save([res,mark,'TempAroundOdorON.mat'],'-append','CaractSniff') ;
        pause(0.5)
        try copyfile([res,mark,'TempAroundOdorON.mat'],[name_folder,mark,'AroundOdorON.mat']); catch; keyboard;end
        try copyfile([res,mark,'InfoTrackingTemp.mat'],[name_folder,mark,'InfoTracking.mat']); catch; keyboard;end
        pause(0.5)
        try copyfile([name_folder,mark,'InfoTracking.mat'],[name_folder,mark,Fname,mark,'InfoTracking.mat']);end
        try copyfile([name_folder,mark,'AroundOdorON.mat'],[name_folder,mark,Fname,mark,'AroundOdorON.mat']);end
        
        close(guireg_fig)
        for bit=1:5
            set(maskbutton(bit),'enable','on','FontWeight','bold')
        end
        delete(msg_box)
        set(maskbutton(7),'enable','off','FontWeight','normal')
    end

% -----------------------------------------------------------------
%% stop tracking
    function stop_Phase(obj,event)
        figure(Fig_Odor), subplot(2,2,[1 3]), title('ACQUISITION STOPPED')
        enableTrack=0;
        set(maskbutton(6),'enable','on','FontWeight','bold')
        set(maskbutton(7),'enable','off','FontWeight','normal')
    end

% -----------------------------------------------------------------
%% stop tracking
    function Restart_Phase(obj,event)
        set(maskbutton(7),'enable','on','FontWeight','bold')
        set(maskbutton(6),'enable','off','FontWeight','normal')
        templaod=load([res,mark,'TempAroundOdorON.mat']);
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

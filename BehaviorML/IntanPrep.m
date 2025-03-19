function IntanPrep(~,~)

%% INPUTS
% global
clear global name_folder imageRef Ratio_IMAonREAL
clear global enableTrack intermed

global imageRef
global Ratio_IMAonREAL
global enableTrack
global intermed
global maxfrvis
maxfrvis=800;

global BW_threshold2;
global smaller_object_size2;
global shape_ratio2;
global th_immob

global StartChrono
global guireg_fig
        
intermed=load('InfoTrackingTemp.mat');
imageRef=intermed.ref;
BW_threshold2=intermed.BW_threshold;
smaller_object_size2=intermed.smaller_object_size;
shape_ratio2=intermed.shape_ratio;
b_default=intermed.b_default;
c_default=intermed.c_default;
e_default=intermed.e_default;

StartChrono=0;
% INITIATE
color_on = [ 0 0 0];

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

maskbutton(8)= uicontrol(Fig_Odor,'style','pushbutton',...
    'units','normalized','position',[0.01 0.03 0.2 0.05],...
    'string','CLOSE EXPE','callback', @quit);
set(maskbutton(8),'enable','on','FontWeight','bold')
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
            default_answer{2}=num2str(lengthPhase);
        end
        if ~exist('default_answer','var') || (exist('default_answer','var') && length(default_answer)~=3)
            default_answer={'1.5','2','5'};
        end
        
        answer = inputdlg({'Thresh immobility (mm)','Drop intervals (s)','Smooth Factor'},'INFO',1,default_answer);
        default_answer=answer; save default_answer default_answer

        th_immob=str2num(answer{1});
        thtps_immob=str2num(answer{2});
        SmoothFact=str2num(answer{3});

        if exist('Ratio_IMAonREAL','var') && ~isempty(Ratio_IMAonREAL)
            set(maskbutton(2),'enable','on','FontWeight','normal','string','2- Real Distance (OK)')
        else
            set(maskbutton(2),'enable','on','FontWeight','bold')
        end
        
        save([res,mark,'InfoTrackingTemp.mat'],'-append','th_immob','thtps_immob','SmoothFact');
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
        
        set(maskbutton(2),'enable','on','FontWeight','normal','string','2- Real Distance (OK)')
        Ratio_IMAonREAL=Ratio_IMAonREAL;
        save([res,mark,'InfoTrackingTemp.mat'],'-append','Ratio_IMAonREAL');
    end
end
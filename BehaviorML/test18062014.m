function [numF,filename]=test18062014;

clear all; close all;

global test1
global test2
test1=1;
test2=1;
color_off=[0 0 0];
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
        set(maskbutton(2),'enable','on')
        
        
        maskbutton(4)= uicontrol(Fig_Odor,'style','pushbutton',...
            'units','normalized','position',[0.03 0.55 0.06 0.03],...
            'string','START','callback', @start_Phase);
        set(maskbutton(4),'enable','on')
            
        maskbutton(5)= uicontrol(Fig_Odor,'style','pushbutton',...
            'units','normalized','position',[0.1 0.25 0.1 0.05],...
            'string','1- Real Distance','callback', @Real_distance);
        set(maskbutton(5),'enable','on')
        
        maskbutton(6)= uicontrol(Fig_Odor,'style','pushbutton',...
            'units','normalized','position',[0.25 0.25 0.1 0.05],...
            'string','2- Odor Location','callback', @Odor_Location);
        set(maskbutton(6),'enable','on')
        
        maskbutton(7)= uicontrol(Fig_Odor,'style','pushbutton',...
            'units','normalized','position',[0.28 0.2 0.1 0.02],...
            'string','Mask Objects','callback', @Mask_object);
        set(maskbutton(7),'enable','on')
        
        maskbutton(8)= uicontrol(Fig_Odor,'style','pushbutton',...
            'units','normalized','position',[0.4 0.25 0.1 0.05],...
            'string','3- Track sniff','callback', @Track_sniff);
        set(maskbutton(8),'enable','on')
        
        maskbutton(9) = uicontrol(Fig_Odor,'style','slider',...
        'units','normalized','position',[0.6 0.1 0.35 0.02],'callback', @AdvancedFrame);
        set(maskbutton(9),'enable','on')
        
        maskbutton(10)= uicontrol(Fig_Odor,'style','pushbutton',...
            'units','normalized','position',[0.43 0.2 0.1 0.02],...
            'string','Stop tracking','callback', @stop_Phase);
        set(maskbutton(10),'enable','on')
        
        maskbutton(11)= uicontrol(Fig_Odor,'style','pushbutton',...
            'units','normalized','position',[0.01 0.18 0.1 0.05],...
            'string','FIGURE indiv','callback', @Genrat_figure);
        set(maskbutton(11),'enable','on')
        
        maskbutton(12) = uicontrol(Fig_Odor,'style','slider',...
        'units','normalized','position',[0.6 0.2 0.35 0.02],'callback', @Speed_display);
        set(maskbutton(12),'enable','on') 
        
        maskbutton(13)= uicontrol(Fig_Odor,'style','pushbutton',...
            'units','normalized','position',[0.01 0.11 0.15 0.05],...
            'string','SAVE + FIGURE EXPE','callback', @Genrat_figureALL);
        set(maskbutton(13),'enable','on')
        
        maskbutton(14)= uicontrol(Fig_Odor,'style','pushbutton',...
            'units','normalized','position',[0.01 0.04 0.2 0.05],...
            'string','SAVE + FIGURE ALL LOADED EXPE','callback', @Genrat_figureALLEXPE);
        set(maskbutton(14),'enable','on')
        
        strNameLoaded=strjoin([{'Name Expe'},NameLoadedExpe],'|');
        maskbutton(15)=uicontrol('Style', 'popup','String',strNameLoaded,'units','normalized','Position', [0.01 0.78 0.75 0.1]);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CALLED FUNCTIONS

% -----------------------------------------------------------------
%% start new expe / reset everything
    function Reset(obj,event)
        disp(' ')
        disp(num2str(test1))
        test1=2;
        disp(['-> ',num2str(test1)])
    end

% -----------------------------------------------------------------
%% Ask for all inputs and display
    function giv_inputs(obj,event)
       disp(' ')
        disp(num2str(test1))
        test1=3;
        disp(['-> ',num2str(test1)])
    end
% -----------------------------------------------------------------
%% Interface of analysis
    function start_Phase(obj,event)
        disp(' ')
        disp(num2str(test1))
        test1=4;
        disp(['-> ',num2str(test1)])
    end

% -----------------------------------------------------------------
%% Ask for all inputs and display
    function Real_distance(obj,event)
       disp(' ')
        disp(num2str(test1))
        test1=5;
        disp(['-> ',num2str(test1)])
    end


% -----------------------------------------------------------------
%% Click on odor locations

    function Odor_Location(obj,event)
        
        disp(' ')
        disp(num2str(test1))
        test1=6;
        disp(['-> ',num2str(test1)])
    end

% -----------------------------------------------------------------
%% mask objects
    function Mask_object(obj,event)
        
        disp(' ')
        disp(num2str(test1))
        test1=7;
        disp(['-> ',num2str(test1)])
    end


% -----------------------------------------------------------------
%% track mouse
    function Track_sniff(obj,event)
        
        disp(' ')
        disp(num2str(test1))
        test1=8;
        disp(['-> ',num2str(test1)])
        
    end



end

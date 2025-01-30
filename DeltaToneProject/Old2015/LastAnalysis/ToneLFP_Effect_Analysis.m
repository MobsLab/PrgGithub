% <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
% <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
a=0;
a=a+1; Path_Mouse243_Delta{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150416/Breath-Mouse-243-244-16042015/mouse243';  % 16-04-2015 > random tone effect
a=a+1; Path_Mouse243_Delta{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150421/Breath-Mouse-243-21042015';               % 21-04-2015 > delay 140ms
a=a+1; Path_Mouse243_Delta{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150417/Breath-Mouse-243-244-17042015/Mouse243';  % 17-04-2015 > delay 200ms
a=a+1; Path_Mouse243_Delta{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150423/Breath-Mouse-243-23042015';               % 23-04-2015 > delay 320ms
a=a+1; Path_Mouse243_Delta{a}='/media/DataMOBs28/Mice-243-244/20150425/Breath-Mouse-243-25042015';                                          % 25-04-2015 > delay 480ms
a=a+1; Path_Mouse243_Delta{a}='/media/DataMOBs28/Mice-243-244/20150429/Breath-Mouse-243-29042015';                                          % 25-04-2015 > delay 3*140ms

a=0;
a=a+1; Path_Mouse244_Delta{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150417/Breath-Mouse-243-244-17042015/Mouse244';  % 17-04-2015 > random tone effect
a=a+1; Path_Mouse244_Delta{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150422/Breath-Mouse-244-22042015';               % 22-04-2015 > delay 140ms
a=a+1; Path_Mouse244_Delta{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150416/Breath-Mouse-243-244-16042015/Mouse244';  % 16-04-2015 > delay 200ms
a=a+1; Path_Mouse244_Delta{a}='/media/DataMOBs28/Mice-243-244/20150424/Breath-Mouse-244-24042015';                                          % 24-04-2015 > delay 320ms
a=a+1; Path_Mouse244_Delta{a}='/media/DataMOBs28/Mice-243-244/20150426/Breath-Mouse-244-26042015';                                          % 26-04-2015 > delay 480ms
a=a+1; Path_Mouse244_Delta{a}='/media/DataMOBs28/Mice-243-244/20150430/Breath-Mouse-244-30042015';                                          % 25-04-2015 > delay 3*140ms
% <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
% <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>


% <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
% <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
%---------------------------------------------------------------------------------------------------------------------------------------------------
%                                                       LOAD  EPOCH & DELTA for BASAL SLEEP
%---------------------------------------------------------------------------------------------------------------------------------------------------
% <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
% <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>

% <><><><><><><><><><><><><><>  Mouse 243 : delta paradigm <><><><><><><><><><><><><><>
for a=1:length(Path_Mouse243_Delta)
    cd(Path_Mouse243_Delta{a})
    res=pwd;
    
    b=0;
    load([res,'/ChannelsToAnalyse/Bulb_deep']);
    b=b+1;ChanToAnalyse{b,1}=channel;ChanToAnalyse{b,2}='Bulb_deep';
    load([res,'/ChannelsToAnalyse/Bulb_sup']);
    b=b+1;ChanToAnalyse{b,1}=channel;ChanToAnalyse{b,2}='Bulb_sup';
    load([res,'/ChannelsToAnalyse/MoCx_deep']);
    b=b+1;ChanToAnalyse{b,1}=channel;ChanToAnalyse{b,2}='MoCx_deep';
    load([res,'/ChannelsToAnalyse/MoCx_sup']);
    b=b+1;ChanToAnalyse{b,1}=channel;ChanToAnalyse{b,2}='MoCx_sup';
    load([res,'/ChannelsToAnalyse/PaCx_deep']);
    b=b+1;ChanToAnalyse{b,1}=channel;ChanToAnalyse{b,2}='PaCx_deep';
    load([res,'/ChannelsToAnalyse/PaCx_sup']);
    b=b+1;ChanToAnalyse{b,1}=channel;ChanToAnalyse{b,2}='PaCx_sup';
    load([res,'/ChannelsToAnalyse/PFCx_deep']);
    b=b+1;ChanToAnalyse{b,1}=channel;ChanToAnalyse{b,2}='PFCx_deep';
    load([res,'/ChannelsToAnalyse/PFCx_sup']);
    b=b+1;ChanToAnalyse{b,1}=channel;ChanToAnalyse{b,2}='PFCx_sup';
    load([res,'/ChannelsToAnalyse/dHPC_deep']);
    b=b+1;ChanToAnalyse{b,1}=channel;ChanToAnalyse{b,2}='dHPC_deep';
    load([res,'/ChannelsToAnalyse/dHPC_sup']);
    b=b+1;ChanToAnalyse{b,1}=channel;ChanToAnalyse{b,2}='dHPC_sup';
    load([res,'/ChannelsToAnalyse/NRT_deep']);
    b=b+1;ChanToAnalyse{b,1}=channel;ChanToAnalyse{b,2}='NRT_deep';
    load([res,'/ChannelsToAnalyse/NRT_sup']);
    b=b+1;ChanToAnalyse{b,1}=channel;ChanToAnalyse{b,2}='NRT_sup';
    
    
    % raw LFP for Tone triggered by delta 
    try
        load rawLFP_DeltaTone_SWS
    catch
        load DeltaSleepEvent
        load([res,'/LFPData/InfoLFP']);
        for i=1:length(ChanToAnalyse);
            ch=ChanToAnalyse{i};
            clear LFP
            load([res,'/LFPData/LFP',num2str(ch)]);
            rawLFP=PlotRipRaw(LFP,TONEtime1_SWS/1E4,2000); close
            rawLFP_DeltaTone_t1{1,i}=ChanToAnalyse{i,2};
            rawLFP_DeltaTone_t1{2,i}=rawLFP;
            
            rawLFP=PlotRipRaw(LFP,TONEtime2_SWS/1E4,2000); close
            rawLFP_DeltaTone_t2{1,i}=ChanToAnalyse{i,2};
            rawLFP_DeltaTone_t2{2,i}=rawLFP;
            disp(['channel # ',num2str(ch),' > done'])
        end
        save rawLFP_DeltaTone_SWS rawLFP_DeltaTone_t1 rawLFP_DeltaTone_t2
    end
    
    % raw LFP for on line detected delta 
    try
        load rawLFP_DeltaOnline_SWS
    catch
        load DeltaSleepEvent
        load([res,'/LFPData/InfoLFP']);
        for i=1:length(ChanToAnalyse);
            ch=ChanToAnalyse{i};
            clear LFP
            load([res,'/LFPData/LFP',num2str(ch)]);
            rawLFP=PlotRipRaw(LFP,DeltaDetect_SWS/1E4,2000); close
            rawLFP_DeltaOnline{1,i}=ChanToAnalyse{i,2};
            rawLFP_DeltaOnline{2,i}=rawLFP;
            disp(['channel # ',num2str(ch),' > done'])
        end
       save rawLFP_DeltaOnline_SWS  rawLFP_DeltaOnline
    end
    
      
    % raw LFP for off line detected delta   (PaCx)
    try
        load rawLFP_DeltaPaCxOffline
    catch
        load newDeltaPaCx
        load([res,'/LFPData/InfoLFP']);
        for i=1:length(ChanToAnalyse);
            ch=ChanToAnalyse{i};
            clear LFP
            load([res,'/LFPData/LFP',num2str(ch)]);
            rawLFP=PlotRipRaw(LFP,tDelta(1:10:end)/1E4,2000); close
            rawLFP_DeltaPaCxOffline{1,i}=ChanToAnalyse{i,2};
            rawLFP_DeltaPaCxOffline{2,i}=rawLFP;
            disp(['channel # ',num2str(ch),' > done'])
        end
        save rawLFP_DeltaPaCxOffline rawLFP_DeltaPaCxOffline
    end
        
    % raw LFP for off line detected delta   (PFCx)
    try
        load rawLFP_DeltaPFCxOffline
    catch
        load newDeltaPaCx
        load([res,'/LFPData/InfoLFP']);
        for i=1:length(ChanToAnalyse);
            ch=ChanToAnalyse{i};
            clear LFP
            load([res,'/LFPData/LFP',num2str(ch)]);
            rawLFP=PlotRipRaw(LFP,tDelta(1:10:end)/1E4,2000); close
            rawLFP_DeltaPFCxOffline{1,i}=ChanToAnalyse{i,2};
            rawLFP_DeltaPFCxOffline{2,i}=rawLFP;
            disp(['channel # ',num2str(ch),' > done'])
        end
        save rawLFP_DeltaPFCxOffline rawLFP_DeltaPFCxOffline
    end
      
    % raw LFP for off line detected delta   (MoCx)  
    try
        load rawLFP_DeltaMoCxOffline
    catch
        load newDeltaPaCx
        load([res,'/LFPData/InfoLFP']);
        for i=1:length(ChanToAnalyse);
            ch=ChanToAnalyse{i};
            clear LFP
            load([res,'/LFPData/LFP',num2str(ch)]);
            rawLFP=PlotRipRaw(LFP,tDelta(1:10:end)/1E4,2000); close
            rawLFP_DeltaMoCxOffline{1,i}=ChanToAnalyse{i,2};
            rawLFP_DeltaMoCxOffline{2,i}=rawLFP;
            disp(['channel # ',num2str(ch),' > done'])
        end
        save rawLFP_DeltaMoCxOffline rawLFP_DeltaMoCxOffline
    end
    
    
    for i=1:length(ChanToAnalyse);
        rawLFP_M243_DeltaTone_t1{1,i}=rawLFP_DeltaTone_t1{1,i};
        rawLFP_M243_DeltaTone_t2{1,i}=rawLFP_DeltaTone_t1{1,i};
        rawLFP_M243_DeltaOnline{1,i}=rawLFP_DeltaOnline{1,i};
        rawLFP_M243_DeltaPaCxOffline{1,i}=rawLFP_DeltaPaCxOffline{1,i};
        rawLFP_M243_DeltaPFCxOffline{1,i}=rawLFP_DeltaPFCxOffline{1,i};
        rawLFP_M243_DeltaMoCxOffline{1,i}=rawLFP_DeltaMoCxOffline{1,i};
    end
    for i=1:length(ChanToAnalyse);
        rawLFP_M243_DeltaTone_t1{a+1,i}=rawLFP_DeltaTone_t1{2,i};
        rawLFP_M243_DeltaTone_t2{a+1,i}=rawLFP_DeltaTone_t1{2,i};
        rawLFP_M243_DeltaOnline{a+1,i}=rawLFP_DeltaOnline{2,i};
        rawLFP_M243_DeltaPaCxOffline{a+1,i}=rawLFP_DeltaPaCxOffline{2,i};
        rawLFP_M243_DeltaPFCxOffline{a+1,i}=rawLFP_DeltaPFCxOffline{2,i};
        rawLFP_M243_DeltaMoCxOffline{a+1,i}=rawLFP_DeltaMoCxOffline{2,i};
    end
end



% <><><><><><><><><><><><><><>  Mouse 244 : delta paradigm <><><><><><><><><><><><><><>
for a=1:length(Path_Mouse244_Delta)
    cd(Path_Mouse244_Delta{a})
    res=pwd;
    
    b=0;
    load([res,'/ChannelsToAnalyse/Bulb_deep']);
    b=b+1;ChanToAnalyse{b,1}=channel;ChanToAnalyse{b,2}='Bulb_deep';
    load([res,'/ChannelsToAnalyse/Bulb_sup']);
    b=b+1;ChanToAnalyse{b,1}=channel;ChanToAnalyse{b,2}='Bulb_sup';
    load([res,'/ChannelsToAnalyse/MoCx_deep']);
    b=b+1;ChanToAnalyse{b,1}=channel;ChanToAnalyse{b,2}='MoCx_deep';
    load([res,'/ChannelsToAnalyse/MoCx_sup']);
    b=b+1;ChanToAnalyse{b,1}=channel;ChanToAnalyse{b,2}='MoCx_sup';
    load([res,'/ChannelsToAnalyse/PaCx_deep']);
    b=b+1;ChanToAnalyse{b,1}=channel;ChanToAnalyse{b,2}='PaCx_deep';
    load([res,'/ChannelsToAnalyse/PaCx_sup']);
    b=b+1;ChanToAnalyse{b,1}=channel;ChanToAnalyse{b,2}='PaCx_sup';
    load([res,'/ChannelsToAnalyse/PFCx_deep']);
    b=b+1;ChanToAnalyse{b,1}=channel;ChanToAnalyse{b,2}='PFCx_deep';
    load([res,'/ChannelsToAnalyse/PFCx_sup']);
    b=b+1;ChanToAnalyse{b,1}=channel;ChanToAnalyse{b,2}='PFCx_sup';
    load([res,'/ChannelsToAnalyse/dHPC_deep']);
    b=b+1;ChanToAnalyse{b,1}=channel;ChanToAnalyse{b,2}='dHPC_deep';
    load([res,'/ChannelsToAnalyse/dHPC_sup']);
    b=b+1;ChanToAnalyse{b,1}=channel;ChanToAnalyse{b,2}='dHPC_sup';
    load([res,'/ChannelsToAnalyse/NRT_deep']);
    b=b+1;ChanToAnalyse{b,1}=channel;ChanToAnalyse{b,2}='NRT_deep';
    load([res,'/ChannelsToAnalyse/NRT_sup']);
    b=b+1;ChanToAnalyse{b,1}=channel;ChanToAnalyse{b,2}='NRT_sup';
    
    
    % raw LFP for Tone triggered by delta 
    try
        load rawLFP_DeltaTone_SWS
    catch
        load DeltaSleepEvent
        load([res,'/LFPData/InfoLFP']);
        for i=1:length(ChanToAnalyse);
            ch=ChanToAnalyse{i};
            clear LFP
            load([res,'/LFPData/LFP',num2str(ch)]);
            rawLFP=PlotRipRaw(LFP,TONEtime1_SWS/1E4,2000); close
            rawLFP_DeltaTone_t1{1,i}=ChanToAnalyse{i,2};
            rawLFP_DeltaTone_t1{2,i}=rawLFP;
            
            rawLFP=PlotRipRaw(LFP,TONEtime2_SWS/1E4,2000); close
            rawLFP_DeltaTone_t2{1,i}=ChanToAnalyse{i,2};
            rawLFP_DeltaTone_t2{2,i}=rawLFP;
            disp(['channel # ',num2str(ch),' > done'])
        end
        save rawLFP_DeltaTone_SWS rawLFP_DeltaTone_t1 rawLFP_DeltaTone_t2
    end
    
    % raw LFP for on line detected delta 
    try
        load rawLFP_DeltaOnline_SWS
    catch
        load DeltaSleepEvent
        load([res,'/LFPData/InfoLFP']);
        for i=1:length(ChanToAnalyse);
            ch=ChanToAnalyse{i};
            clear LFP
            load([res,'/LFPData/LFP',num2str(ch)]);
            rawLFP=PlotRipRaw(LFP,DeltaDetect_SWS/1E4,2000); close
            rawLFP_DeltaOnline{1,i}=ChanToAnalyse{i,2};
            rawLFP_DeltaOnline{2,i}=rawLFP;
            disp(['channel # ',num2str(ch),' > done'])
        end
       save rawLFP_DeltaOnline_SWS  rawLFP_DeltaOnline
    end
    
      
    % raw LFP for off line detected delta   (PaCx)
    try
        load rawLFP_DeltaPaCxOffline
    catch
        load newDeltaPaCx
        load([res,'/LFPData/InfoLFP']);
        for i=1:length(ChanToAnalyse);
            ch=ChanToAnalyse{i};
            clear LFP
            load([res,'/LFPData/LFP',num2str(ch)]);
            rawLFP=PlotRipRaw(LFP,tDelta(1:10:end)/1E4,2000); close
            rawLFP_DeltaPaCxOffline{1,i}=ChanToAnalyse{i,2};
            rawLFP_DeltaPaCxOffline{2,i}=rawLFP;
            disp(['channel # ',num2str(ch),' > done'])
        end
        save rawLFP_DeltaPaCxOffline rawLFP_DeltaPaCxOffline
    end
        
    % raw LFP for off line detected delta   (PFCx)
    try
        load rawLFP_DeltaPFCxOffline
    catch
        load newDeltaPaCx
        load([res,'/LFPData/InfoLFP']);
        for i=1:length(ChanToAnalyse);
            ch=ChanToAnalyse{i};
            clear LFP
            load([res,'/LFPData/LFP',num2str(ch)]);
            rawLFP=PlotRipRaw(LFP,tDelta(1:10:end)/1E4,2000); close
            rawLFP_DeltaPFCxOffline{1,i}=ChanToAnalyse{i,2};
            rawLFP_DeltaPFCxOffline{2,i}=rawLFP;
            disp(['channel # ',num2str(ch),' > done'])
        end
        save rawLFP_DeltaPFCxOffline rawLFP_DeltaPFCxOffline
    end
      
    % raw LFP for off line detected delta   (MoCx)  
    try
        load rawLFP_DeltaMoCxOffline
    catch
        load newDeltaPaCx
        load([res,'/LFPData/InfoLFP']);
        for i=1:length(ChanToAnalyse);
            ch=ChanToAnalyse{i};
            clear LFP
            load([res,'/LFPData/LFP',num2str(ch)]);
            rawLFP=PlotRipRaw(LFP,tDelta(1:10:end)/1E4,2000); close
            rawLFP_DeltaMoCxOffline{1,i}=ChanToAnalyse{i,2};
            rawLFP_DeltaMoCxOffline{2,i}=rawLFP;
            disp(['channel # ',num2str(ch),' > done'])
        end
        save rawLFP_DeltaMoCxOffline rawLFP_DeltaMoCxOffline
    end
        
    
    for i=1:length(ChanToAnalyse);
        rawLFP_M244_DeltaTone_t1{1,i}=rawLFP_DeltaTone_t1{1,i};
        rawLFP_M244_DeltaTone_t2{1,i}=rawLFP_DeltaTone_t1{1,i};
        rawLFP_M244_DeltaOnline{1,i}=rawLFP_DeltaOnline{1,i};
        rawLFP_M244_DeltaPaCxOffline{1,i}=rawLFP_DeltaPaCxOffline{1,i};
        rawLFP_M244_DeltaPFCxOffline{1,i}=rawLFP_DeltaPFCxOffline{1,i};
        rawLFP_M244_DeltaMoCxOffline{1,i}=rawLFP_DeltaMoCxOffline{1,i};
    end
    for i=1:length(ChanToAnalyse);
        rawLFP_M244_DeltaTone_t1{a+1,i}=rawLFP_DeltaTone_t1{2,i};
        rawLFP_M244_DeltaTone_t2{a+1,i}=rawLFP_DeltaTone_t1{2,i};
        rawLFP_M244_DeltaOnline{a+1,i}=rawLFP_DeltaOnline{2,i};
        rawLFP_M244_DeltaPaCxOffline{a+1,i}=rawLFP_DeltaPaCxOffline{2,i};
        rawLFP_M244_DeltaPFCxOffline{a+1,i}=rawLFP_DeltaPFCxOffline{2,i};
        rawLFP_M244_DeltaMoCxOffline{a+1,i}=rawLFP_DeltaMoCxOffline{2,i};
    end
end


% <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
% <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
%---------------------------------------------------------------------------------------------------------------------------------------------------
%                                                                     PLOT ALL THAT
%---------------------------------------------------------------------------------------------------------------------------------------------------
% <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
% <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>


% <><><><><><><><><><><><><><>  Mouse 243 : delta paradigm <><><><><><><><><><><><><><>

a=0;
a=a+1; structure{a}='Bulb';
a=a+1; structure{a}='dHPC';
a=a+1; structure{a}='MoCx';
a=a+1; structure{a}='NRT';
a=a+1; structure{a}='PaCx';
a=a+1; structure{a}='PFCx';

for KK=1:2:11
    struc=(KK+1)/2;
    figure('color',[1 1 1]),
    j=1;k=2;l=3;m=4;n=5;o=6;
    
    for i=1:length(Path_Mouse243_Delta)
        hold on, subplot(length(Path_Mouse243_Delta),6,j)
        a=rawLFP_M243_DeltaOnline{i+1,KK};
        b=rawLFP_M243_DeltaOnline{i+1,KK+1};
        hold on, plot(a(:,1),a(:,2),'k','linewidth',1)
        hold on, plot(b(:,1),b(:,2),'r','linewidth',1)
        clear a, clear b
        title([structure{struc},' - M243 > Online Detection'])
        
        hold on, subplot(length(Path_Mouse243_Delta),6,k)
        a=rawLFP_M243_DeltaTone_t1{i+1,KK};
        b=rawLFP_M243_DeltaTone_t1{i+1,KK+1};
        hold on, plot(a(:,1),a(:,2),'k','linewidth',1)
        hold on, plot(b(:,1),b(:,2),'r','linewidth',1)
        clear a, clear b
        title([structure{struc},' -M243 - Online Tone triggering'])
        
        hold on, subplot(length(Path_Mouse243_Delta),6,l)
        a=rawLFP_M243_DeltaTone_t2{i+1,KK};
        b=rawLFP_M243_DeltaTone_t2{i+1,KK+1};
        hold on, plot(a(:,1),a(:,2),'k','linewidth',1)
        hold on, plot(b(:,1),b(:,2),'r','linewidth',1)
        clear a, clear b
        title([structure{struc},' -M243 - Online Tone execution'])
        
        hold on, subplot(length(Path_Mouse243_Delta),6,m)
        a=rawLFP_M243_DeltaPaCxOffline{i+1,KK};
        b=rawLFP_M243_DeltaPaCxOffline{i+1,KK+1};
        hold on, plot(a(:,1),a(:,2),'k','linewidth',1)
        hold on, plot(b(:,1),b(:,2),'r','linewidth',1)
        clear a, clear b
        title([structure{struc},' -M243 - Offline PaCx Delta '])
        
        hold on, subplot(length(Path_Mouse243_Delta),6,n)
        a=rawLFP_M243_DeltaPFCxOffline{i+1,KK};
        b=rawLFP_M243_DeltaPFCxOffline{i+1,KK+1};
        hold on, plot(a(:,1),a(:,2),'k','linewidth',1)
        hold on, plot(b(:,1),b(:,2),'r','linewidth',1)
        clear a, clear b
        title([structure{struc},' -M243 - Offline PFCx Delta '])
        
        hold on, subplot(length(Path_Mouse243_Delta),6,o)
        a=rawLFP_M243_DeltaMoCxOffline{i+1,KK};
        b=rawLFP_M243_DeltaMoCxOffline{i+1,KK+1};
        hold on, plot(a(:,1),a(:,2),'k','linewidth',1)
        hold on, plot(b(:,1),b(:,2),'r','linewidth',1)
        clear a, clear b
        title([structure{struc},' -M243 - Offline MoCx Delta '])
        
        
        j=j+6;k=k+6;l=l+6;m=m+6;n=n+6;o=o+6;
    end
end


% <><><><><><><><><><><><><><>  Mouse 244 : delta paradigm <><><><><><><><><><><><><><>
a=0;
a=a+1; structure{a}='Bulb';
a=a+1; structure{a}='dHPC';
a=a+1; structure{a}='MoCx';
a=a+1; structure{a}='NRT';
a=a+1; structure{a}='PaCx';
a=a+1; structure{a}='PFCx';

for KK=1:2:11
    struc=(KK+1)/2;
    figure('color',[1 1 1]),
    j=1;k=2;l=3;m=4;n=5;o=6;
    
    for i=1:length(Path_Mouse244_Delta)
        hold on, subplot(length(Path_Mouse243_Delta),6,j)
        a=rawLFP_M244_DeltaOnline{i+1,KK};
        b=rawLFP_M244_DeltaOnline{i+1,KK+1};
        hold on, plot(a(:,1),a(:,2),'k','linewidth',1)
        hold on, plot(b(:,1),b(:,2),'r','linewidth',1)
        clear a, clear b
        title([structure{struc},' - M243 > Online Detection'])
        
        hold on, subplot(length(Path_Mouse243_Delta),6,k) 
        a=rawLFP_M244_DeltaTone_t1{i+1,KK};
        b=rawLFP_M244_DeltaTone_t1{i+1,KK+1};
        hold on, plot(a(:,1),a(:,2),'k','linewidth',1)
        hold on, plot(b(:,1),b(:,2),'r','linewidth',1)
        clear a, clear b
        title([structure{struc},' -M243 - Online Tone triggering'])
        
        hold on, subplot(length(Path_Mouse243_Delta),6,l)
        a=rawLFP_M244_DeltaTone_t2{i+1,KK};
        b=rawLFP_M244_DeltaTone_t2{i+1,KK+1};
        hold on, plot(a(:,1),a(:,2),'k','linewidth',1)
        hold on, plot(b(:,1),b(:,2),'r','linewidth',1)
        clear a, clear b
        title([structure{struc},' -M243 - Online Tone execution'])
        
        hold on, subplot(length(Path_Mouse243_Delta),6,m)
        a=rawLFP_M244_DeltaPaCxOffline{i+1,KK};
        b=rawLFP_M244_DeltaPaCxOffline{i+1,KK+1};
        hold on, plot(a(:,1),a(:,2),'k','linewidth',1)
        hold on, plot(b(:,1),b(:,2),'r','linewidth',1)
        clear a, clear b
        title([structure{struc},' -M243 - Offline PaCx Delta '])
        
        hold on, subplot(length(Path_Mouse243_Delta),6,n)
        a=rawLFP_M244_DeltaPFCxOffline{i+1,KK};
        b=rawLFP_M244_DeltaPFCxOffline{i+1,KK+1};
        hold on, plot(a(:,1),a(:,2),'k','linewidth',1)
        hold on, plot(b(:,1),b(:,2),'r','linewidth',1)
        clear a, clear b
        title([structure{struc},' -M243 - Offline PFCx Delta '])
        
        hold on, subplot(length(Path_Mouse243_Delta),6,o)
        a=rawLFP_M244_DeltaMoCxOffline{i+1,KK};
        b=rawLFP_M244_DeltaMoCxOffline{i+1,KK+1};
        hold on, plot(a(:,1),a(:,2),'k','linewidth',1)
        hold on, plot(b(:,1),b(:,2),'r','linewidth',1)
        clear a, clear b
        title([structure{struc},' -M243 - Offline MoCx Delta '])
        
        
        j=j+6;k=k+6;l=l+6;m=m+6;n=n+6;o=o+6;
    end
end

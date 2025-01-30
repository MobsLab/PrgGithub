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
    
    try
        load Spk_Analysis
    catch
        
        load SpikeData
        load DeltaSleepEvent
        
        b=0;
        b=b+1;
        load([res,'/SpikesToAnalyse/PFCx_MUA']);
        SpkToAnalyse{b,2}=number;
        load([res,'/SpikesToAnalyse/PFCx_Neurons']);
        SpkToAnalyse{b,3}=number;SpkToAnalyse{b,1}='PFCx';
        b=b+1;
        load([res,'/SpikesToAnalyse/NRT_MUA']);
        SpkToAnalyse{b,2}=number;
        load([res,'/SpikesToAnalyse/NRT_Neurons']);
        SpkToAnalyse{b,3}=number;SpkToAnalyse{b,1}='NRT';
        
        for b=1:2
            Neurons{b}=PoolNeurons(S,[SpkToAnalyse{b,2} SpkToAnalyse{b,3}]);
            clear SS
            SS{1}=Neurons{b};
            SS=tsdArray(SS);
            QMua = MakeQfromS(SS,200);
            
            figure, [fh, rasterAx, histAx, Spk_DeltaTone_t1{b}] = ImagePETH(QMua, ts(TONEtime1_SWS), -10000, +15000,'BinSize',500);
            hold on, title('time1')
            figure, [fh, rasterAx, histAx, Spk_DeltaTone_t2{b}] = ImagePETH(QMua, ts(TONEtime2_SWS), -10000, +15000,'BinSize',500);
            hold on, title('time2')
            figure, [fh, rasterAx, histAx, Spk_DeltaOnline{b}] = ImagePETH(QMua, ts(DeltaDetect_SWS), -10000, +15000,'BinSize',500);
            hold on, title('DeltaDetect')
            load newDeltaPaCx
            figure, [fh, rasterAx, histAx, Spk_DeltaPaCxOffline{b}] = ImagePETH(QMua, ts(tDelta(1:10:end)), -10000, +15000,'BinSize',500);
            hold on, title('Delta PaCx')
            load newDeltaPFCx
            figure, [fh, rasterAx, histAx, Spk_DeltaPFCxOffline{b}] = ImagePETH(QMua, ts(tDelta(1:10:end)), -10000, +15000,'BinSize',500);
            hold on, title('Delta PFCx')
            load newDeltaMoCx
            figure, [fh, rasterAx, histAx, Spk_DeltaMoCxOffline{b}] = ImagePETH(QMua, ts(tDelta(1:10:end)), -10000, +15000,'BinSize',500);
            hold on, title('Delta MoCx')
        end
        save Spk_Analysis Spk_DeltaTone_t1 Spk_DeltaTone_t2 Spk_DeltaOnline Spk_DeltaPaCxOffline Spk_DeltaPFCxOffline Spk_DeltaMoCxOffline
    end
    
end
close all

% <><><><><><><><><><><><><><>  Mouse 244 : delta paradigm <><><><><><><><><><><><><><>
for a=1:length(Path_Mouse244_Delta)
    cd(Path_Mouse244_Delta{a})
    res=pwd;
    
    try
        load Spk_Analysis
    catch
        
        load SpikeData
        load DeltaSleepEvent
        
        b=0;
        b=b+1;
        load([res,'/SpikesToAnalyse/PFCx_MUA']);
        SpkToAnalyse{b,2}=number;
        load([res,'/SpikesToAnalyse/PFCx_Neurons']);
        SpkToAnalyse{b,3}=number;SpkToAnalyse{b,1}='PFCx';
        b=b+1;
        load([res,'/SpikesToAnalyse/NRT_MUA']);
        SpkToAnalyse{b,2}=number;
        load([res,'/SpikesToAnalyse/NRT_Neurons']);
        SpkToAnalyse{b,3}=number;SpkToAnalyse{b,1}='NRT';
        
        for b=1:2
            Neurons{b}=PoolNeurons(S,[SpkToAnalyse{b,2} SpkToAnalyse{b,3}]);
            clear SS
            SS{1}=Neurons{b};
            SS=tsdArray(SS);
            QMua = MakeQfromS(SS,200);
            
            figure, [fh, rasterAx, histAx, Spk_DeltaTone_t1{b}] = ImagePETH(QMua, ts(TONEtime1_SWS), -10000, +15000,'BinSize',500);
            hold on, title('time1')
            figure, [fh, rasterAx, histAx, Spk_DeltaTone_t2{b}] = ImagePETH(QMua, ts(TONEtime2_SWS), -10000, +15000,'BinSize',500);
            hold on, title('time2')
            figure, [fh, rasterAx, histAx, Spk_DeltaOnline{b}] = ImagePETH(QMua, ts(DeltaDetect_SWS), -10000, +15000,'BinSize',500);
            hold on, title('DeltaDetect')
            load newDeltaPaCx
            figure, [fh, rasterAx, histAx, Spk_DeltaPaCxOffline{b}] = ImagePETH(QMua, ts(tDelta(1:10:end)), -10000, +15000,'BinSize',500);
            hold on, title('Delta PaCx')
            load newDeltaPFCx
            figure, [fh, rasterAx, histAx, Spk_DeltaPFCxOffline{b}] = ImagePETH(QMua, ts(tDelta(1:10:end)), -10000, +15000,'BinSize',500);
            hold on, title('Delta PFCx')
            load newDeltaMoCx
            figure, [fh, rasterAx, histAx, Spk_DeltaMoCxOffline{b}] = ImagePETH(QMua, ts(tDelta(1:10:end)), -10000, +15000,'BinSize',500);
            hold on, title('Delta MoCx')
        end
        save Spk_Analysis Spk_DeltaTone_t1 Spk_DeltaTone_t2 Spk_DeltaOnline Spk_DeltaPaCxOffline Spk_DeltaPFCxOffline Spk_DeltaMoCxOffline
    end
    
end




% <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
% <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
%---------------------------------------------------------------------------------------------------------------------------------------------------
%                                                                     PLOT ALL THAT
%---------------------------------------------------------------------------------------------------------------------------------------------------
% <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
% <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>




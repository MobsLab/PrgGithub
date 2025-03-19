a=0;
a=a+1; Dir.pathBasal{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150331/Electrophy/Breath-Mouse-243-244-31032015/Mouse243'; % Mouse 243 - Day 3
a=a+1; Dir.pathBasal{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150409/Breath-Mouse-243-244-09042015/Mouse243';            % Mouse 243 - Day 5

a=a+1; Dir.pathBasal{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150329/Electrophy/Breath-Mouse-243-244-29032015/Mouse244'; % Mouse 244 - Day 2
a=a+1; Dir.pathBasal{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150409/Breath-Mouse-243-244-09042015/Mouse244';            % Mouse 244 - Day 5

a=a+1; Dir.pathBasal{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice251-252/20150518/Breath-Mouse-251-252-18052015/Mouse251'; % Mouse 251 - Day 1
a=a+1; Dir.pathBasal{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice251-252/20150519/Breath-Mouse-251-252-19052015/Mouse251'; % Mouse 251 - Day 2
a=a+1; Dir.pathBasal{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice251-252/20150520/Breath-Mouse-251-252-20052015/Mouse251'; % Mouse 251 - Day 3
a=a+1; Dir.pathBasal{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice251-252/20150521/Breath-Mouse-251-252-21052015/Mouse251'; % Mouse 251 - Day 4
a=a+1; Dir.pathBasal{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice251-252/20150522/Breath-Mouse-251-252-22052015/Mouse251'; % Mouse 251 - Day 5

a=a+1; Dir.pathBasal{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice251-252/20150518/Breath-Mouse-251-252-18052015/Mouse252'; % Mouse 252 - Day 1
a=a+1; Dir.pathBasal{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice251-252/20150519/Breath-Mouse-251-252-19052015/Mouse252'; % Mouse 252 - Day 2
a=a+1; Dir.pathBasal{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice251-252/20150520/Breath-Mouse-251-252-20052015/Mouse252'; % Mouse 252 - Day 3
a=a+1; Dir.pathBasal{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice251-252/20150521/Breath-Mouse-251-252-21052015/Mouse252'; % Mouse 252 - Day 4
a=a+1; Dir.pathBasal{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice251-252/20150522/Breath-Mouse-251-252-22052015/Mouse252'; % Mouse 252 - Day 5

% <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
% <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
%---------------------------------------------------------------------------------------------------------------------------------------------------
%                                                       LOAD  EPOCH & DELTA for BASAL SLEEP
%---------------------------------------------------------------------------------------------------------------------------------------------------
% <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
% <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
binS=10;nbin=1000;smo=0.5;

cd('/media/DataMOBsRAID/ProjetBreathDeltaFeedback')

try load Data_LFPWaveform_Delta_Ripples
    
catch
    
    for a=1:length(Dir.pathBasal)
        cd(Dir.pathBasal{a})
        load EpochToAnalyse
        load StateEpochSB SWSEpoch
        
        load newDeltaMoCx
        tDeltaMoCx=ts(tDelta(:,1));
        load newDeltaPaCx
        tDeltaPaCx=ts(tDelta(:,1));
        load newDeltaPFCx
        tDeltaPFCx=ts(tDelta(:,1));
        load RipplesdHPC25
        rip=ts(dHPCrip(:,2)*1E4);
        
        
        % >>> generate LFP Waveforms during SPW-Rs:
        res=pwd;
        load([res,'/ChannelsToAnalyse/PFCx_deep']); PFCx_deep=channel;
        load([res,'/ChannelsToAnalyse/PFCx_sup']); PFCx_sup=channel;
        load([res,'/ChannelsToAnalyse/PaCx_deep']); PaCx_deep=channel;
        load([res,'/ChannelsToAnalyse/PaCx_sup']); PaCx_sup=channel;
        load([res,'/ChannelsToAnalyse/MoCx_deep']); MoCx_deep=channel;
        load([res,'/ChannelsToAnalyse/MoCx_sup']); MoCx_sup=channel;
        load([res,'/ChannelsToAnalyse/dHPC_rip']); dHPC_rip=channel;
        
    
        clear LFP
        load([res,'/LFPData/LFP',num2str(dHPC_rip)]);
        raw_HPC_rip{a}=PlotRipRaw(LFP,Range(rip)/1E4,1000);close
        raw_HPC_DeltaPFCx{a}=PlotRipRaw(LFP,Range(tDeltaPFCx)/1E4,1000);close
        raw_HPC_DeltaPaCx{a}=PlotRipRaw(LFP,Range(tDeltaPaCx)/1E4,1000);close
        raw_HPC_DeltaMoCx{a}=PlotRipRaw(LFP,Range(tDeltaMoCx)/1E4,1000);close
        raw_HPC_StDown{a}=PlotRipRaw(LFP,StartDown/1E4,1000);close
        
        clear LFP
        load([res,'/LFPData/LFP',num2str(PFCx_deep)]);
        raw_dp_PFCx_rip{a}=PlotRipRaw(LFP,Range(rip)/1E4,1000);close
        raw_dp_PFCx_DeltaPFCx{a}=PlotRipRaw(LFP,Range(tDeltaPFCx)/1E4,1000);close
        raw_dp_PFCx_DeltaPaCx{a}=PlotRipRaw(LFP,Range(tDeltaPaCx)/1E4,1000);close
        raw_dp_PFCx_DeltaMoCx{a}=PlotRipRaw(LFP,Range(tDeltaMoCx)/1E4,1000);close
        raw_dp_PFCx_StDown{a}=PlotRipRaw(LFP,StartDown/1E4,1000);close
        clear LFP
        load([res,'/LFPData/LFP',num2str(PFCx_sup)]);
        raw_sp_PFCx_rip{a}=PlotRipRaw(LFP,Range(rip)/1E4,1000);close
        raw_sp_PFCx_DeltaPFCx{a}=PlotRipRaw(LFP,Range(tDeltaPFCx)/1E4,1000);close
        raw_sp_PFCx_DeltaPaCx{a}=PlotRipRaw(LFP,Range(tDeltaPaCx)/1E4,1000);close
        raw_sp_PFCx_DeltaMoCx{a}=PlotRipRaw(LFP,Range(tDeltaMoCx)/1E4,1000);close
        raw_sp_PFCx_StDown{a}=PlotRipRaw(LFP,StartDown/1E4,1000);close
        
        clear LFP
        load([res,'/LFPData/LFP',num2str(PaCx_deep)]);
        raw_dp_PaCx_rip{a}=PlotRipRaw(LFP,Range(rip)/1E4,1000);close
        raw_dp_PaCx_DeltaPFCx{a}=PlotRipRaw(LFP,Range(tDeltaPFCx)/1E4,1000);close
        raw_dp_PaCx_DeltaPaCx{a}=PlotRipRaw(LFP,Range(tDeltaPaCx)/1E4,1000);close
        raw_dp_PaCx_DeltaMoCx{a}=PlotRipRaw(LFP,Range(tDeltaMoCx)/1E4,1000);close
        raw_dp_PaCx_StDown{a}=PlotRipRaw(LFP,StartDown/1E4,1000);close
        clear LFP
        load([res,'/LFPData/LFP',num2str(PaCx_sup)]);
        raw_sp_PaCx_rip{a}=PlotRipRaw(LFP,Range(rip)/1E4,1000);close
        raw_sp_PaCx_DeltaPFCx{a}=PlotRipRaw(LFP,Range(tDeltaPFCx)/1E4,1000);close
        raw_sp_PaCx_DeltaPaCx{a}=PlotRipRaw(LFP,Range(tDeltaPaCx)/1E4,1000);close
        raw_sp_PaCx_DeltaMoCx{a}=PlotRipRaw(LFP,Range(tDeltaMoCx)/1E4,1000);close
        raw_sp_PaCx_StDown{a}=PlotRipRaw(LFP,StartDown/1E4,1000);close
        
        clear LFP
        load([res,'/LFPData/LFP',num2str(MoCx_deep)]);
        raw_dp_MoCx_rip{a}=PlotRipRaw(LFP,Range(rip)/1E4,1000);close
        raw_dp_MoCx_DeltaPFCx{a}=PlotRipRaw(LFP,Range(tDeltaPFCx)/1E4,1000);close
        raw_dp_MoCx_DeltaPaCx{a}=PlotRipRaw(LFP,Range(tDeltaPaCx)/1E4,1000);close
        raw_dp_MoCx_DeltaMoCx{a}=PlotRipRaw(LFP,Range(tDeltaMoCx)/1E4,1000);close
        raw_dp_MoCx_StDown{a}=PlotRipRaw(LFP,StartDown/1E4,1000);close
        clear LFP
        load([res,'/LFPData/LFP',num2str(MoCx_sup)]);
        raw_sp_MoCx_rip{a}=PlotRipRaw(LFP,Range(rip)/1E4,1000);close
        raw_sp_MoCx_DeltaPFCx{a}=PlotRipRaw(LFP,Range(tDeltaPFCx)/1E4,1000);close
        raw_sp_MoCx_DeltaPaCx{a}=PlotRipRaw(LFP,Range(tDeltaPaCx)/1E4,1000);close
        raw_sp_MoCx_DeltaMoCx{a}=PlotRipRaw(LFP,Range(tDeltaMoCx)/1E4,1000);close
        raw_sp_MoCx_StDown{a}=PlotRipRaw(LFP,StartDown/1E4,1000);close
    end
    
    cd('/media/DataMOBsRAID/ProjetBreathDeltaFeedback')
    save Data_LFPWaveform_Delta_Ripples raw_HPC_rip raw_HPC_DeltaPFCx raw_HPC_DeltaPaCx raw_HPC_DeltaMoCx raw_HPC_StDown
    save Data_LFPWaveform_Delta_Ripples -append raw_dp_MoCx_rip raw_dp_MoCx_DeltaPFCx raw_dp_MoCx_DeltaPaCx raw_dp_MoCx_DeltaMoCx raw_dp_MoCx_StDown
    save Data_LFPWaveform_Delta_Ripples -append raw_dp_PaCx_rip raw_dp_PaCx_DeltaPFCx raw_dp_PaCx_DeltaPaCx raw_dp_PaCx_DeltaMoCx raw_dp_PaCx_StDown
    save Data_LFPWaveform_Delta_Ripples -append raw_dp_PFCx_rip raw_dp_PFCx_DeltaPFCx raw_dp_PFCx_DeltaPaCx raw_dp_PFCx_DeltaMoCx raw_dp_PFCx_StDown
    save Data_LFPWaveform_Delta_Ripples -append raw_sp_MoCx_rip raw_sp_MoCx_DeltaPFCx raw_sp_MoCx_DeltaPaCx raw_sp_MoCx_DeltaMoCx raw_sp_MoCx_StDown
    save Data_LFPWaveform_Delta_Ripples -append raw_sp_PaCx_rip raw_sp_PaCx_DeltaPFCx raw_sp_PaCx_DeltaPaCx raw_sp_PaCx_DeltaMoCx raw_sp_PaCx_StDown
    save Data_LFPWaveform_Delta_Ripples -append raw_sp_PFCx_rip raw_sp_PFCx_DeltaPFCx raw_sp_PFCx_DeltaPaCx raw_sp_PFCx_DeltaMoCx raw_sp_PFCx_StDown
end

% <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
% <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
%---------------------------------------------------------------------------------------------------------------------------------------------------
%                                                       LOAD  EPOCH & DELTA for BASAL SLEEP
%---------------------------------------------------------------------------------------------------------------------------------------------------
% <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
% <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>

for i=1:length(Dir.pathBasal)
    rawLFP=raw_HPC_rip{i};        raw_HPC_rip_A(:,i)=rawLFP(:,1);raw_HPC_rip_B(:,i)=rawLFP(:,2);
    rawLFP=raw_dp_PFCx_rip{i};    raw_dp_PFCx_rip_A(:,i)=rawLFP(:,1);raw_dp_PFCx_rip_B(:,i)=rawLFP(:,2);
    rawLFP=raw_sp_PFCx_rip{i};    raw_sp_PFCx_rip_A(:,i)=rawLFP(:,1);raw_sp_PFCx_rip_B(:,i)=rawLFP(:,2);
    rawLFP=raw_dp_PaCx_rip{i};    raw_dp_PaCx_rip_A(:,i)=rawLFP(:,1);raw_dp_PaCx_rip_B(:,i)=rawLFP(:,2);
    rawLFP=raw_sp_PaCx_rip{i};    raw_sp_PaCx_rip_A(:,i)=rawLFP(:,1);raw_sp_PaCx_rip_B(:,i)=rawLFP(:,2);
    rawLFP=raw_dp_MoCx_rip{i};    raw_dp_MoCx_rip_A(:,i)=rawLFP(:,1);raw_dp_MoCx_rip_B(:,i)=rawLFP(:,2);
    rawLFP=raw_sp_MoCx_rip{i};    raw_sp_MoCx_rip_A(:,i)=rawLFP(:,1);raw_sp_MoCx_rip_B(:,i)=rawLFP(:,2);
    
    rawLFP=raw_HPC_DeltaPFCx{i};raw_HPC_DeltaPFCx_A(:,i)=rawLFP(:,1);raw_HPC_DeltaPFCx_B(:,i)=rawLFP(:,2);
    rawLFP=raw_dp_PFCx_DeltaPFCx{i};raw_dp_PFCx_DeltaPFCx_A(:,i)=rawLFP(:,1);raw_dp_PFCx_DeltaPFCx_B(:,i)=rawLFP(:,2);
    rawLFP=raw_sp_PFCx_DeltaPFCx{i};raw_sp_PFCx_DeltaPFCx_A(:,i)=rawLFP(:,1);raw_sp_PFCx_DeltaPFCx_B(:,i)=rawLFP(:,2);
    rawLFP=raw_dp_PaCx_DeltaPFCx{i};raw_dp_PaCx_DeltaPFCx_A(:,i)=rawLFP(:,1);raw_dp_PaCx_DeltaPFCx_B(:,i)=rawLFP(:,2);
    rawLFP=raw_sp_PaCx_DeltaPFCx{i};raw_sp_PaCx_DeltaPFCx_A(:,i)=rawLFP(:,1);raw_sp_PaCx_DeltaPFCx_B(:,i)=rawLFP(:,2);
    rawLFP=raw_dp_MoCx_DeltaPFCx{i};raw_dp_MoCx_DeltaPFCx_A(:,i)=rawLFP(:,1);raw_dp_MoCx_DeltaPFCx_B(:,i)=rawLFP(:,2);
    rawLFP=raw_sp_MoCx_DeltaPFCx{i};raw_sp_MoCx_DeltaPFCx_A(:,i)=rawLFP(:,1);raw_sp_MoCx_DeltaPFCx_B(:,i)=rawLFP(:,2);
    
    rawLFP=raw_HPC_DeltaPaCx{i};raw_HPC_DeltaPaCx_A(:,i)=rawLFP(:,1);raw_HPC_DeltaPaCx_B(:,i)=rawLFP(:,2);
    rawLFP=raw_dp_PFCx_DeltaPaCx{i};raw_dp_PFCx_DeltaPaCx_A(:,i)=rawLFP(:,1);raw_dp_PFCx_DeltaPaCx_B(:,i)=rawLFP(:,2);
    rawLFP=raw_sp_PFCx_DeltaPaCx{i};raw_sp_PFCx_DeltaPaCx_A(:,i)=rawLFP(:,1);raw_sp_PFCx_DeltaPaCx_B(:,i)=rawLFP(:,2);
    rawLFP=raw_dp_PaCx_DeltaPaCx{i};raw_dp_PaCx_DeltaPaCx_A(:,i)=rawLFP(:,1);raw_dp_PaCx_DeltaPaCx_B(:,i)=rawLFP(:,2);
    rawLFP=raw_sp_PaCx_DeltaPaCx{i};raw_sp_PaCx_DeltaPaCx_A(:,i)=rawLFP(:,1);raw_sp_PaCx_DeltaPaCx_B(:,i)=rawLFP(:,2);
    rawLFP=raw_dp_MoCx_DeltaPaCx{i};raw_dp_MoCx_DeltaPaCx_A(:,i)=rawLFP(:,1);raw_dp_MoCx_DeltaPaCx_B(:,i)=rawLFP(:,2);
    rawLFP=raw_sp_MoCx_DeltaPaCx{i};raw_sp_MoCx_DeltaPaCx_A(:,i)=rawLFP(:,1);raw_sp_MoCx_DeltaPaCx_B(:,i)=rawLFP(:,2);
    
    rawLFP=raw_HPC_DeltaMoCx{i};raw_HPC_DeltaMoCx_A(:,i)=rawLFP(:,1);raw_HPC_DeltaMoCx_B(:,i)=rawLFP(:,2);
    rawLFP=raw_dp_PFCx_DeltaMoCx{i};raw_dp_PFCx_DeltaMoCx_A(:,i)=rawLFP(:,1);raw_dp_PFCx_DeltaMoCx_B(:,i)=rawLFP(:,2);
    rawLFP=raw_sp_PFCx_DeltaMoCx{i};raw_sp_PFCx_DeltaMoCx_A(:,i)=rawLFP(:,1);raw_sp_PFCx_DeltaMoCx_B(:,i)=rawLFP(:,2);
    rawLFP=raw_dp_PaCx_DeltaMoCx{i};raw_dp_PaCx_DeltaMoCx_A(:,i)=rawLFP(:,1);raw_dp_PaCx_DeltaMoCx_B(:,i)=rawLFP(:,2);
    rawLFP=raw_sp_PaCx_DeltaMoCx{i};raw_sp_PaCx_DeltaMoCx_A(:,i)=rawLFP(:,1);raw_sp_PaCx_DeltaMoCx_B(:,i)=rawLFP(:,2);
    rawLFP=raw_dp_MoCx_DeltaMoCx{i};raw_dp_MoCx_DeltaMoCx_A(:,i)=rawLFP(:,1);raw_dp_MoCx_DeltaMoCx_B(:,i)=rawLFP(:,2);
    rawLFP=raw_sp_MoCx_DeltaMoCx{i};raw_sp_MoCx_DeltaMoCx_A(:,i)=rawLFP(:,1);raw_sp_MoCx_DeltaMoCx_B(:,i)=rawLFP(:,2);
end

for i=1:length(Dir.pathBasal)-1
    rawLFP=raw_HPC_StDown{i};        raw_HPC_StDown_A(:,i)=rawLFP(:,1);raw_HPC_StDown_B(:,i)=rawLFP(:,2);
    rawLFP=raw_dp_PFCx_StDown{i};    raw_dp_PFCx_StDown_A(:,i)=rawLFP(:,1);raw_dp_PFCx_StDown_B(:,i)=rawLFP(:,2);
    rawLFP=raw_sp_PFCx_StDown{i};    raw_sp_PFCx_StDown_A(:,i)=rawLFP(:,1);raw_sp_PFCx_StDown_B(:,i)=rawLFP(:,2);
    rawLFP=raw_dp_PaCx_StDown{i};    raw_dp_PaCx_StDown_A(:,i)=rawLFP(:,1);raw_dp_PaCx_StDown_B(:,i)=rawLFP(:,2);
    rawLFP=raw_sp_PaCx_StDown{i};    raw_sp_PaCx_StDown_A(:,i)=rawLFP(:,1);raw_sp_PaCx_StDown_B(:,i)=rawLFP(:,2);
    rawLFP=raw_dp_MoCx_StDown{i};    raw_dp_MoCx_StDown_A(:,i)=rawLFP(:,1);raw_dp_MoCx_StDown_B(:,i)=rawLFP(:,2);
    rawLFP=raw_sp_MoCx_StDown{i};    raw_sp_MoCx_StDown_A(:,i)=rawLFP(:,1);raw_sp_MoCx_StDown_B(:,i)=rawLFP(:,2);
end
% <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
Mouse243=[1 2];
Mouse244=[3 4];
Mouse251=[5 6 7 8 9];
Mouse252=[10 11 12 13 14];
% <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>

% <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
%---------------------------------------------------------------------------------------------------------------------------------------------------
%                                                      All structure during SPW-Rs
%---------------------------------------------------------------------------------------------------------------------------------------------------
% <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>

timevalues=mean([raw_HPC_rip_A(:,1),raw_HPC_rip_A(:,2)],2);

M243_HPC_rip_B=mean([raw_HPC_rip_B(:,1),raw_HPC_rip_B(:,2)],2);
M244_HPC_rip_B=mean([raw_HPC_rip_B(:,3),raw_HPC_rip_B(:,4)],2);
M251_HPC_rip_B=mean([raw_HPC_rip_B(:,5),raw_HPC_rip_B(:,6),raw_HPC_rip_B(:,7),raw_HPC_rip_B(:,8),raw_HPC_rip_B(:,9)],2);
M252_HPC_rip_B=mean([raw_HPC_rip_B(:,10),raw_HPC_rip_B(:,11),raw_HPC_rip_B(:,12),raw_HPC_rip_B(:,13),raw_HPC_rip_B(:,14)],2);

M243_dp_PFCx_rip_B=mean([raw_dp_PFCx_rip_B(:,1),raw_dp_PFCx_rip_B(:,2)],2);
M244_dp_PFCx_rip_B=mean([raw_dp_PFCx_rip_B(:,3),raw_dp_PFCx_rip_B(:,4)],2);
M251_dp_PFCx_rip_B=mean([raw_dp_PFCx_rip_B(:,5),raw_dp_PFCx_rip_B(:,6),raw_dp_PFCx_rip_B(:,7),raw_dp_PFCx_rip_B(:,8),raw_dp_PFCx_rip_B(:,9)],2);
M252_dp_PFCx_rip_B=mean([raw_dp_PFCx_rip_B(:,10),raw_dp_PFCx_rip_B(:,11),raw_dp_PFCx_rip_B(:,12),raw_dp_PFCx_rip_B(:,13),raw_dp_PFCx_rip_B(:,14)],2);

M243_sp_PFCx_rip_B=mean([raw_sp_PFCx_rip_B(:,1),raw_sp_PFCx_rip_B(:,2)],2);
M244_sp_PFCx_rip_B=mean([raw_sp_PFCx_rip_B(:,3),raw_sp_PFCx_rip_B(:,4)],2);
M251_sp_PFCx_rip_B=mean([raw_sp_PFCx_rip_B(:,5),raw_sp_PFCx_rip_B(:,6),raw_sp_PFCx_rip_B(:,7),raw_sp_PFCx_rip_B(:,8),raw_sp_PFCx_rip_B(:,9)],2);
M252_sp_PFCx_rip_B=mean([raw_sp_PFCx_rip_B(:,10),raw_sp_PFCx_rip_B(:,11),raw_sp_PFCx_rip_B(:,12),raw_sp_PFCx_rip_B(:,13),raw_sp_PFCx_rip_B(:,14)],2);

M243_dp_PaCx_rip_B=mean([raw_dp_PaCx_rip_B(:,1),raw_dp_PaCx_rip_B(:,2)],2);
M244_dp_PaCx_rip_B=mean([raw_dp_PaCx_rip_B(:,3),raw_dp_PaCx_rip_B(:,4)],2);
M251_dp_PaCx_rip_B=mean([raw_dp_PaCx_rip_B(:,5),raw_dp_PaCx_rip_B(:,6),raw_dp_PaCx_rip_B(:,7),raw_dp_PaCx_rip_B(:,8),raw_dp_PaCx_rip_B(:,9)],2);
M252_dp_PaCx_rip_B=mean([raw_dp_PaCx_rip_B(:,10),raw_dp_PaCx_rip_B(:,11),raw_dp_PaCx_rip_B(:,12),raw_dp_PaCx_rip_B(:,13),raw_dp_PaCx_rip_B(:,14)],2);

M243_sp_PaCx_rip_B=mean([raw_sp_PaCx_rip_B(:,1),raw_sp_PaCx_rip_B(:,2)],2);
M244_sp_PaCx_rip_B=mean([raw_sp_PaCx_rip_B(:,3),raw_sp_PaCx_rip_B(:,4)],2);
M251_sp_PaCx_rip_B=mean([raw_sp_PaCx_rip_B(:,5),raw_sp_PaCx_rip_B(:,6),raw_sp_PaCx_rip_B(:,7),raw_sp_PaCx_rip_B(:,8),raw_sp_PaCx_rip_B(:,9)],2);
M252_sp_PaCx_rip_B=mean([raw_sp_PaCx_rip_B(:,10),raw_sp_PaCx_rip_B(:,11),raw_sp_PaCx_rip_B(:,12),raw_sp_PaCx_rip_B(:,13),raw_sp_PaCx_rip_B(:,14)],2);    

M243_dp_MoCx_rip_B=mean([raw_dp_MoCx_rip_B(:,1),raw_dp_MoCx_rip_B(:,2)],2);
M244_dp_MoCx_rip_B=mean([raw_dp_MoCx_rip_B(:,3),raw_dp_MoCx_rip_B(:,4)],2);
M251_dp_MoCx_rip_B=mean([raw_dp_MoCx_rip_B(:,5),raw_dp_MoCx_rip_B(:,6),raw_dp_MoCx_rip_B(:,7),raw_dp_MoCx_rip_B(:,8),raw_dp_MoCx_rip_B(:,9)],2);
M252_dp_MoCx_rip_B=mean([raw_dp_MoCx_rip_B(:,10),raw_dp_MoCx_rip_B(:,11),raw_dp_MoCx_rip_B(:,12),raw_dp_MoCx_rip_B(:,13),raw_dp_MoCx_rip_B(:,14)],2);

M243_sp_MoCx_rip_B=mean([raw_sp_MoCx_rip_B(:,1),raw_sp_MoCx_rip_B(:,2)],2);
M244_sp_MoCx_rip_B=mean([raw_sp_MoCx_rip_B(:,3),raw_sp_MoCx_rip_B(:,4)],2);
M251_sp_MoCx_rip_B=mean([raw_sp_MoCx_rip_B(:,5),raw_sp_MoCx_rip_B(:,6),raw_sp_MoCx_rip_B(:,7),raw_sp_MoCx_rip_B(:,8),raw_sp_MoCx_rip_B(:,9)],2);
M252_sp_MoCx_rip_B=mean([raw_sp_MoCx_rip_B(:,10),raw_sp_MoCx_rip_B(:,11),raw_sp_MoCx_rip_B(:,12),raw_sp_MoCx_rip_B(:,13),raw_sp_MoCx_rip_B(:,14)],2);

% <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
%---------------------------------------------------------------------------------------------------------------------------------------------------
%                                                      All structure during PFCx Down States
%---------------------------------------------------------------------------------------------------------------------------------------------------
% <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>

M243_HPC_StDown_B=mean([raw_HPC_StDown_B(:,1),raw_HPC_StDown_B(:,2)],2);
M244_HPC_StDown_B=mean([raw_HPC_StDown_B(:,3),raw_HPC_StDown_B(:,4)],2);
M251_HPC_StDown_B=mean([raw_HPC_StDown_B(:,5),raw_HPC_StDown_B(:,6),raw_HPC_StDown_B(:,7),raw_HPC_StDown_B(:,8),raw_HPC_StDown_B(:,9)],2);
M252_HPC_StDown_B=mean([raw_HPC_StDown_B(:,10),raw_HPC_StDown_B(:,11),raw_HPC_StDown_B(:,12),raw_HPC_StDown_B(:,13)],2);

M243_dp_PFCx_StDown_B=mean([raw_dp_PFCx_StDown_B(:,1),raw_dp_PFCx_StDown_B(:,2)],2);
M244_dp_PFCx_StDown_B=mean([raw_dp_PFCx_StDown_B(:,3),raw_dp_PFCx_StDown_B(:,4)],2);
M251_dp_PFCx_StDown_B=mean([raw_dp_PFCx_StDown_B(:,5),raw_dp_PFCx_StDown_B(:,6),raw_dp_PFCx_StDown_B(:,7),raw_dp_PFCx_StDown_B(:,8),raw_dp_PFCx_StDown_B(:,9)],2);
M252_dp_PFCx_StDown_B=mean([raw_dp_PFCx_StDown_B(:,10),raw_dp_PFCx_StDown_B(:,11),raw_dp_PFCx_StDown_B(:,12),raw_dp_PFCx_StDown_B(:,13)],2);

M243_sp_PFCx_StDown_B=mean([raw_sp_PFCx_StDown_B(:,1),raw_sp_PFCx_StDown_B(:,2)],2);
M244_sp_PFCx_StDown_B=mean([raw_sp_PFCx_StDown_B(:,3),raw_sp_PFCx_StDown_B(:,4)],2);
M251_sp_PFCx_StDown_B=mean([raw_sp_PFCx_StDown_B(:,5),raw_sp_PFCx_StDown_B(:,6),raw_sp_PFCx_StDown_B(:,7),raw_sp_PFCx_StDown_B(:,8),raw_sp_PFCx_StDown_B(:,9)],2);
M252_sp_PFCx_StDown_B=mean([raw_sp_PFCx_StDown_B(:,10),raw_sp_PFCx_StDown_B(:,11),raw_sp_PFCx_StDown_B(:,12),raw_sp_PFCx_StDown_B(:,13)],2);

M243_dp_PaCx_StDown_B=mean([raw_dp_PaCx_StDown_B(:,1),raw_dp_PaCx_StDown_B(:,2)],2);
M244_dp_PaCx_StDown_B=mean([raw_dp_PaCx_StDown_B(:,3),raw_dp_PaCx_StDown_B(:,4)],2);
M251_dp_PaCx_StDown_B=mean([raw_dp_PaCx_StDown_B(:,5),raw_dp_PaCx_StDown_B(:,6),raw_dp_PaCx_StDown_B(:,7),raw_dp_PaCx_StDown_B(:,8),raw_dp_PaCx_StDown_B(:,9)],2);
M252_dp_PaCx_StDown_B=mean([raw_dp_PaCx_StDown_B(:,10),raw_dp_PaCx_StDown_B(:,11),raw_dp_PaCx_StDown_B(:,12),raw_dp_PaCx_StDown_B(:,13)],2);

M243_sp_PaCx_StDown_B=mean([raw_sp_PaCx_StDown_B(:,1),raw_sp_PaCx_StDown_B(:,2)],2);
M244_sp_PaCx_StDown_B=mean([raw_sp_PaCx_StDown_B(:,3),raw_sp_PaCx_StDown_B(:,4)],2);
M251_sp_PaCx_StDown_B=mean([raw_sp_PaCx_StDown_B(:,5),raw_sp_PaCx_StDown_B(:,6),raw_sp_PaCx_StDown_B(:,7),raw_sp_PaCx_StDown_B(:,8),raw_sp_PaCx_StDown_B(:,9)],2);
M252_sp_PaCx_StDown_B=mean([raw_sp_PaCx_StDown_B(:,10),raw_sp_PaCx_StDown_B(:,11),raw_sp_PaCx_StDown_B(:,12),raw_sp_PaCx_StDown_B(:,13)],2);    

M243_dp_MoCx_StDown_B=mean([raw_dp_MoCx_StDown_B(:,1),raw_dp_MoCx_StDown_B(:,2)],2);
M244_dp_MoCx_StDown_B=mean([raw_dp_MoCx_StDown_B(:,3),raw_dp_MoCx_StDown_B(:,4)],2);
M251_dp_MoCx_StDown_B=mean([raw_dp_MoCx_StDown_B(:,5),raw_dp_MoCx_StDown_B(:,6),raw_dp_MoCx_StDown_B(:,7),raw_dp_MoCx_StDown_B(:,8),raw_dp_MoCx_StDown_B(:,9)],2);
M252_dp_MoCx_StDown_B=mean([raw_dp_MoCx_StDown_B(:,10),raw_dp_MoCx_StDown_B(:,11),raw_dp_MoCx_StDown_B(:,12),raw_dp_MoCx_StDown_B(:,13)],2);

M243_sp_MoCx_StDown_B=mean([raw_sp_MoCx_StDown_B(:,1),raw_sp_MoCx_StDown_B(:,2)],2);
M244_sp_MoCx_StDown_B=mean([raw_sp_MoCx_StDown_B(:,3),raw_sp_MoCx_StDown_B(:,4)],2);
M251_sp_MoCx_StDown_B=mean([raw_sp_MoCx_StDown_B(:,5),raw_sp_MoCx_StDown_B(:,6),raw_sp_MoCx_StDown_B(:,7),raw_sp_MoCx_StDown_B(:,8),raw_sp_MoCx_StDown_B(:,9)],2);
M252_sp_MoCx_StDown_B=mean([raw_sp_MoCx_StDown_B(:,10),raw_sp_MoCx_StDown_B(:,11),raw_sp_MoCx_StDown_B(:,12),raw_sp_MoCx_StDown_B(:,13)],2);

% <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
%---------------------------------------------------------------------------------------------------------------------------------------------------
%                                                      All structure during PFCx Delta Waves
%---------------------------------------------------------------------------------------------------------------------------------------------------
% <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>

M243_HPC_DeltaPFCx_B=mean([raw_HPC_DeltaPFCx_B(:,1),raw_HPC_DeltaPFCx_B(:,2)],2);
M244_HPC_DeltaPFCx_B=mean([raw_HPC_DeltaPFCx_B(:,3),raw_HPC_DeltaPFCx_B(:,4)],2);
M251_HPC_DeltaPFCx_B=mean([raw_HPC_DeltaPFCx_B(:,5),raw_HPC_DeltaPFCx_B(:,6),raw_HPC_DeltaPFCx_B(:,7),raw_HPC_DeltaPFCx_B(:,8),raw_HPC_DeltaPFCx_B(:,9)],2);
M252_HPC_DeltaPFCx_B=mean([raw_HPC_DeltaPFCx_B(:,10),raw_HPC_DeltaPFCx_B(:,11),raw_HPC_DeltaPFCx_B(:,12),raw_HPC_DeltaPFCx_B(:,13),raw_HPC_DeltaPFCx_B(:,14)],2);

M243_dp_PFCx_DeltaPFCx_B=mean([raw_dp_PFCx_DeltaPFCx_B(:,1),raw_dp_PFCx_DeltaPFCx_B(:,2)],2);
M244_dp_PFCx_DeltaPFCx_B=mean([raw_dp_PFCx_DeltaPFCx_B(:,3),raw_dp_PFCx_DeltaPFCx_B(:,4)],2);
M251_dp_PFCx_DeltaPFCx_B=mean([raw_dp_PFCx_DeltaPFCx_B(:,5),raw_dp_PFCx_DeltaPFCx_B(:,6),raw_dp_PFCx_DeltaPFCx_B(:,7),raw_dp_PFCx_DeltaPFCx_B(:,8),raw_dp_PFCx_DeltaPFCx_B(:,9)],2);
M252_dp_PFCx_DeltaPFCx_B=mean([raw_dp_PFCx_DeltaPFCx_B(:,10),raw_dp_PFCx_DeltaPFCx_B(:,11),raw_dp_PFCx_DeltaPFCx_B(:,12),raw_dp_PFCx_DeltaPFCx_B(:,13),raw_dp_PFCx_DeltaPFCx_B(:,14)],2);

M243_sp_PFCx_DeltaPFCx_B=mean([raw_sp_PFCx_DeltaPFCx_B(:,1),raw_sp_PFCx_DeltaPFCx_B(:,2)],2);
M244_sp_PFCx_DeltaPFCx_B=mean([raw_sp_PFCx_DeltaPFCx_B(:,3),raw_sp_PFCx_DeltaPFCx_B(:,4)],2);
M251_sp_PFCx_DeltaPFCx_B=mean([raw_sp_PFCx_DeltaPFCx_B(:,5),raw_sp_PFCx_DeltaPFCx_B(:,6),raw_sp_PFCx_DeltaPFCx_B(:,7),raw_sp_PFCx_DeltaPFCx_B(:,8),raw_sp_PFCx_DeltaPFCx_B(:,9)],2);
M252_sp_PFCx_DeltaPFCx_B=mean([raw_sp_PFCx_DeltaPFCx_B(:,10),raw_sp_PFCx_DeltaPFCx_B(:,11),raw_sp_PFCx_DeltaPFCx_B(:,12),raw_sp_PFCx_DeltaPFCx_B(:,13),raw_sp_PFCx_DeltaPFCx_B(:,14)],2);

M243_dp_PaCx_DeltaPFCx_B=mean([raw_dp_PaCx_DeltaPFCx_B(:,1),raw_dp_PaCx_DeltaPFCx_B(:,2)],2);
M244_dp_PaCx_DeltaPFCx_B=mean([raw_dp_PaCx_DeltaPFCx_B(:,3),raw_dp_PaCx_DeltaPFCx_B(:,4)],2);
M251_dp_PaCx_DeltaPFCx_B=mean([raw_dp_PaCx_DeltaPFCx_B(:,5),raw_dp_PaCx_DeltaPFCx_B(:,6),raw_dp_PaCx_DeltaPFCx_B(:,7),raw_dp_PaCx_DeltaPFCx_B(:,8),raw_dp_PaCx_DeltaPFCx_B(:,9)],2);
M252_dp_PaCx_DeltaPFCx_B=mean([raw_dp_PaCx_DeltaPFCx_B(:,10),raw_dp_PaCx_DeltaPFCx_B(:,11),raw_dp_PaCx_DeltaPFCx_B(:,12),raw_dp_PaCx_DeltaPFCx_B(:,13),raw_dp_PaCx_DeltaPFCx_B(:,14)],2);

M243_sp_PaCx_DeltaPFCx_B=mean([raw_sp_PaCx_DeltaPFCx_B(:,1),raw_sp_PaCx_DeltaPFCx_B(:,2)],2);
M244_sp_PaCx_DeltaPFCx_B=mean([raw_sp_PaCx_DeltaPFCx_B(:,3),raw_sp_PaCx_DeltaPFCx_B(:,4)],2);
M251_sp_PaCx_DeltaPFCx_B=mean([raw_sp_PaCx_DeltaPFCx_B(:,5),raw_sp_PaCx_DeltaPFCx_B(:,6),raw_sp_PaCx_DeltaPFCx_B(:,7),raw_sp_PaCx_DeltaPFCx_B(:,8),raw_sp_PaCx_DeltaPFCx_B(:,9)],2);
M252_sp_PaCx_DeltaPFCx_B=mean([raw_sp_PaCx_DeltaPFCx_B(:,10),raw_sp_PaCx_DeltaPFCx_B(:,11),raw_sp_PaCx_DeltaPFCx_B(:,12),raw_sp_PaCx_DeltaPFCx_B(:,13),raw_sp_PaCx_DeltaPFCx_B(:,14)],2);  

M243_dp_MoCx_DeltaPFCx_B=mean([raw_dp_MoCx_DeltaPFCx_B(:,1),raw_dp_MoCx_DeltaPFCx_B(:,2)],2);
M244_dp_MoCx_DeltaPFCx_B=mean([raw_dp_MoCx_DeltaPFCx_B(:,3),raw_dp_MoCx_DeltaPFCx_B(:,4)],2);
M251_dp_MoCx_DeltaPFCx_B=mean([raw_dp_MoCx_DeltaPFCx_B(:,5),raw_dp_MoCx_DeltaPFCx_B(:,6),raw_dp_MoCx_DeltaPFCx_B(:,7),raw_dp_MoCx_DeltaPFCx_B(:,8),raw_dp_MoCx_DeltaPFCx_B(:,9)],2);
M252_dp_MoCx_DeltaPFCx_B=mean([raw_dp_MoCx_DeltaPFCx_B(:,10),raw_dp_MoCx_DeltaPFCx_B(:,11),raw_dp_MoCx_DeltaPFCx_B(:,12),raw_dp_MoCx_DeltaPFCx_B(:,13),raw_dp_MoCx_DeltaPFCx_B(:,14)],2);

M243_sp_MoCx_DeltaPFCx_B=mean([raw_sp_MoCx_DeltaPFCx_B(:,1),raw_sp_MoCx_DeltaPFCx_B(:,2)],2);
M244_sp_MoCx_DeltaPFCx_B=mean([raw_sp_MoCx_DeltaPFCx_B(:,3),raw_sp_MoCx_DeltaPFCx_B(:,4)],2);
M251_sp_MoCx_DeltaPFCx_B=mean([raw_sp_MoCx_DeltaPFCx_B(:,5),raw_sp_MoCx_DeltaPFCx_B(:,6),raw_sp_MoCx_DeltaPFCx_B(:,7),raw_sp_MoCx_DeltaPFCx_B(:,8),raw_sp_MoCx_DeltaPFCx_B(:,9)],2);
M252_sp_MoCx_DeltaPFCx_B=mean([raw_sp_MoCx_DeltaPFCx_B(:,10),raw_sp_MoCx_DeltaPFCx_B(:,11),raw_sp_MoCx_DeltaPFCx_B(:,12),raw_sp_MoCx_DeltaPFCx_B(:,13),raw_sp_MoCx_DeltaPFCx_B(:,14)],2);

% <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
%---------------------------------------------------------------------------------------------------------------------------------------------------
%                                                      All structure during PFCx Delta Waves
%---------------------------------------------------------------------------------------------------------------------------------------------------
% <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
M243_HPC_DeltaPaCx_B=mean([raw_HPC_DeltaPaCx_B(:,1),raw_HPC_DeltaPaCx_B(:,2)],2);
M244_HPC_DeltaPaCx_B=mean([raw_HPC_DeltaPaCx_B(:,3),raw_HPC_DeltaPaCx_B(:,4)],2);
M251_HPC_DeltaPaCx_B=mean([raw_HPC_DeltaPaCx_B(:,5),raw_HPC_DeltaPaCx_B(:,6),raw_HPC_DeltaPaCx_B(:,7),raw_HPC_DeltaPaCx_B(:,8),raw_HPC_DeltaPaCx_B(:,9)],2);
M252_HPC_DeltaPaCx_B=mean([raw_HPC_DeltaPaCx_B(:,10),raw_HPC_DeltaPaCx_B(:,11),raw_HPC_DeltaPaCx_B(:,12),raw_HPC_DeltaPaCx_B(:,13),raw_HPC_DeltaPaCx_B(:,14)],2);

M243_dp_PFCx_DeltaPaCx_B=mean([raw_dp_PFCx_DeltaPaCx_B(:,1),raw_dp_PFCx_DeltaPaCx_B(:,2)],2);
M244_dp_PFCx_DeltaPaCx_B=mean([raw_dp_PFCx_DeltaPaCx_B(:,3),raw_dp_PFCx_DeltaPaCx_B(:,4)],2);
M251_dp_PFCx_DeltaPaCx_B=mean([raw_dp_PFCx_DeltaPaCx_B(:,5),raw_dp_PFCx_DeltaPaCx_B(:,6),raw_dp_PFCx_DeltaPaCx_B(:,7),raw_dp_PFCx_DeltaPaCx_B(:,8),raw_dp_PFCx_DeltaPaCx_B(:,9)],2);
M252_dp_PFCx_DeltaPaCx_B=mean([raw_dp_PFCx_DeltaPaCx_B(:,10),raw_dp_PFCx_DeltaPaCx_B(:,11),raw_dp_PFCx_DeltaPaCx_B(:,12),raw_dp_PFCx_DeltaPaCx_B(:,13),raw_dp_PFCx_DeltaPaCx_B(:,14)],2);

M243_sp_PFCx_DeltaPaCx_B=mean([raw_sp_PFCx_DeltaPaCx_B(:,1),raw_sp_PFCx_DeltaPaCx_B(:,2)],2);
M244_sp_PFCx_DeltaPaCx_B=mean([raw_sp_PFCx_DeltaPaCx_B(:,3),raw_sp_PFCx_DeltaPaCx_B(:,4)],2);
M251_sp_PFCx_DeltaPaCx_B=mean([raw_sp_PFCx_DeltaPaCx_B(:,5),raw_sp_PFCx_DeltaPaCx_B(:,6),raw_sp_PFCx_DeltaPaCx_B(:,7),raw_sp_PFCx_DeltaPaCx_B(:,8),raw_sp_PFCx_DeltaPaCx_B(:,9)],2);
M252_sp_PFCx_DeltaPaCx_B=mean([raw_sp_PFCx_DeltaPaCx_B(:,10),raw_sp_PFCx_DeltaPaCx_B(:,11),raw_sp_PFCx_DeltaPaCx_B(:,12),raw_sp_PFCx_DeltaPaCx_B(:,13),raw_sp_PFCx_DeltaPaCx_B(:,14)],2);

M243_dp_PaCx_DeltaPaCx_B=mean([raw_dp_PaCx_DeltaPaCx_B(:,1),raw_dp_PaCx_DeltaPaCx_B(:,2)],2);
M244_dp_PaCx_DeltaPaCx_B=mean([raw_dp_PaCx_DeltaPaCx_B(:,3),raw_dp_PaCx_DeltaPaCx_B(:,4)],2);
M251_dp_PaCx_DeltaPaCx_B=mean([raw_dp_PaCx_DeltaPaCx_B(:,5),raw_dp_PaCx_DeltaPaCx_B(:,6),raw_dp_PaCx_DeltaPaCx_B(:,7),raw_dp_PaCx_DeltaPaCx_B(:,8),raw_dp_PaCx_DeltaPaCx_B(:,9)],2);
M252_dp_PaCx_DeltaPaCx_B=mean([raw_dp_PaCx_DeltaPaCx_B(:,10),raw_dp_PaCx_DeltaPaCx_B(:,11),raw_dp_PaCx_DeltaPaCx_B(:,12),raw_dp_PaCx_DeltaPaCx_B(:,13),raw_dp_PaCx_DeltaPaCx_B(:,14)],2);

M243_sp_PaCx_DeltaPaCx_B=mean([raw_sp_PaCx_DeltaPaCx_B(:,1),raw_sp_PaCx_DeltaPaCx_B(:,2)],2);
M244_sp_PaCx_DeltaPaCx_B=mean([raw_sp_PaCx_DeltaPaCx_B(:,3),raw_sp_PaCx_DeltaPaCx_B(:,4)],2);
M251_sp_PaCx_DeltaPaCx_B=mean([raw_sp_PaCx_DeltaPaCx_B(:,5),raw_sp_PaCx_DeltaPaCx_B(:,6),raw_sp_PaCx_DeltaPaCx_B(:,7),raw_sp_PaCx_DeltaPaCx_B(:,8),raw_sp_PaCx_DeltaPaCx_B(:,9)],2);
M252_sp_PaCx_DeltaPaCx_B=mean([raw_sp_PaCx_DeltaPaCx_B(:,10),raw_sp_PaCx_DeltaPaCx_B(:,11),raw_sp_PaCx_DeltaPaCx_B(:,12),raw_sp_PaCx_DeltaPaCx_B(:,13),raw_sp_PaCx_DeltaPaCx_B(:,14)],2);    

M243_dp_MoCx_DeltaPaCx_B=mean([raw_dp_MoCx_DeltaPaCx_B(:,1),raw_dp_MoCx_DeltaPaCx_B(:,2)],2);
M244_dp_MoCx_DeltaPaCx_B=mean([raw_dp_MoCx_DeltaPaCx_B(:,3),raw_dp_MoCx_DeltaPaCx_B(:,4)],2);
M251_dp_MoCx_DeltaPaCx_B=mean([raw_dp_MoCx_DeltaPaCx_B(:,5),raw_dp_MoCx_DeltaPaCx_B(:,6),raw_dp_MoCx_DeltaPaCx_B(:,7),raw_dp_MoCx_DeltaPaCx_B(:,8),raw_dp_MoCx_DeltaPaCx_B(:,9)],2);
M252_dp_MoCx_DeltaPaCx_B=mean([raw_dp_MoCx_DeltaPaCx_B(:,10),raw_dp_MoCx_DeltaPaCx_B(:,11),raw_dp_MoCx_DeltaPaCx_B(:,12),raw_dp_MoCx_DeltaPaCx_B(:,13),raw_dp_MoCx_DeltaPaCx_B(:,14)],2);

M243_sp_MoCx_DeltaPaCx_B=mean([raw_sp_MoCx_DeltaPaCx_B(:,1),raw_sp_MoCx_DeltaPaCx_B(:,2)],2);
M244_sp_MoCx_DeltaPaCx_B=mean([raw_sp_MoCx_DeltaPaCx_B(:,3),raw_sp_MoCx_DeltaPaCx_B(:,4)],2);
M251_sp_MoCx_DeltaPaCx_B=mean([raw_sp_MoCx_DeltaPaCx_B(:,5),raw_sp_MoCx_DeltaPaCx_B(:,6),raw_sp_MoCx_DeltaPaCx_B(:,7),raw_sp_MoCx_DeltaPaCx_B(:,8),raw_sp_MoCx_DeltaPaCx_B(:,9)],2);
M252_sp_MoCx_DeltaPaCx_B=mean([raw_sp_MoCx_DeltaPaCx_B(:,10),raw_sp_MoCx_DeltaPaCx_B(:,11),raw_sp_MoCx_DeltaPaCx_B(:,12),raw_sp_MoCx_DeltaPaCx_B(:,13),raw_sp_MoCx_DeltaPaCx_B(:,14)],2);

% <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
%---------------------------------------------------------------------------------------------------------------------------------------------------
%                                                      All structure during MoCx Delta Waves
%---------------------------------------------------------------------------------------------------------------------------------------------------
% <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
M243_HPC_DeltaMoCx_B=mean([raw_HPC_DeltaMoCx_B(:,1),raw_HPC_DeltaMoCx_B(:,2)],2);
M244_HPC_DeltaMoCx_B=mean([raw_HPC_DeltaMoCx_B(:,3),raw_HPC_DeltaMoCx_B(:,4)],2);
M251_HPC_DeltaMoCx_B=mean([raw_HPC_DeltaMoCx_B(:,5),raw_HPC_DeltaMoCx_B(:,6),raw_HPC_DeltaMoCx_B(:,7),raw_HPC_DeltaMoCx_B(:,8),raw_HPC_DeltaMoCx_B(:,9)],2);
M252_HPC_DeltaMoCx_B=mean([raw_HPC_DeltaMoCx_B(:,10),raw_HPC_DeltaMoCx_B(:,11),raw_HPC_DeltaMoCx_B(:,12),raw_HPC_DeltaMoCx_B(:,13),raw_HPC_DeltaMoCx_B(:,14)],2);

M243_dp_PFCx_DeltaMoCx_B=mean([raw_dp_PFCx_DeltaMoCx_B(:,1),raw_dp_PFCx_DeltaMoCx_B(:,2)],2);
M244_dp_PFCx_DeltaMoCx_B=mean([raw_dp_PFCx_DeltaMoCx_B(:,3),raw_dp_PFCx_DeltaMoCx_B(:,4)],2);
M251_dp_PFCx_DeltaMoCx_B=mean([raw_dp_PFCx_DeltaMoCx_B(:,5),raw_dp_PFCx_DeltaMoCx_B(:,6),raw_dp_PFCx_DeltaMoCx_B(:,7),raw_dp_PFCx_DeltaMoCx_B(:,8),raw_dp_PFCx_DeltaMoCx_B(:,9)],2);
M252_dp_PFCx_DeltaMoCx_B=mean([raw_dp_PFCx_DeltaMoCx_B(:,10),raw_dp_PFCx_DeltaMoCx_B(:,11),raw_dp_PFCx_DeltaMoCx_B(:,12),raw_dp_PFCx_DeltaMoCx_B(:,13),raw_dp_PFCx_DeltaMoCx_B(:,14)],2);

M243_sp_PFCx_DeltaMoCx_B=mean([raw_sp_PFCx_DeltaMoCx_B(:,1),raw_sp_PFCx_DeltaMoCx_B(:,2)],2);
M244_sp_PFCx_DeltaMoCx_B=mean([raw_sp_PFCx_DeltaMoCx_B(:,3),raw_sp_PFCx_DeltaMoCx_B(:,4)],2);
M251_sp_PFCx_DeltaMoCx_B=mean([raw_sp_PFCx_DeltaMoCx_B(:,5),raw_sp_PFCx_DeltaMoCx_B(:,6),raw_sp_PFCx_DeltaMoCx_B(:,7),raw_sp_PFCx_DeltaMoCx_B(:,8),raw_sp_PFCx_DeltaMoCx_B(:,9)],2);
M252_sp_PFCx_DeltaMoCx_B=mean([raw_sp_PFCx_DeltaMoCx_B(:,10),raw_sp_PFCx_DeltaMoCx_B(:,11),raw_sp_PFCx_DeltaMoCx_B(:,12),raw_sp_PFCx_DeltaMoCx_B(:,13),raw_sp_PFCx_DeltaMoCx_B(:,14)],2);

M243_dp_PaCx_DeltaMoCx_B=mean([raw_dp_PaCx_DeltaMoCx_B(:,1),raw_dp_PaCx_DeltaMoCx_B(:,2)],2);
M244_dp_PaCx_DeltaMoCx_B=mean([raw_dp_PaCx_DeltaMoCx_B(:,3),raw_dp_PaCx_DeltaMoCx_B(:,4)],2);
M251_dp_PaCx_DeltaMoCx_B=mean([raw_dp_PaCx_DeltaMoCx_B(:,5),raw_dp_PaCx_DeltaMoCx_B(:,6),raw_dp_PaCx_DeltaMoCx_B(:,7),raw_dp_PaCx_DeltaMoCx_B(:,8),raw_dp_PaCx_DeltaMoCx_B(:,9)],2);
M252_dp_PaCx_DeltaMoCx_B=mean([raw_dp_PaCx_DeltaMoCx_B(:,10),raw_dp_PaCx_DeltaMoCx_B(:,11),raw_dp_PaCx_DeltaMoCx_B(:,12),raw_dp_PaCx_DeltaMoCx_B(:,13),raw_dp_PaCx_DeltaMoCx_B(:,14)],2);

M243_sp_PaCx_DeltaMoCx_B=mean([raw_sp_PaCx_DeltaMoCx_B(:,1),raw_sp_PaCx_DeltaMoCx_B(:,2)],2);
M244_sp_PaCx_DeltaMoCx_B=mean([raw_sp_PaCx_DeltaMoCx_B(:,3),raw_sp_PaCx_DeltaMoCx_B(:,4)],2);
M251_sp_PaCx_DeltaMoCx_B=mean([raw_sp_PaCx_DeltaMoCx_B(:,5),raw_sp_PaCx_DeltaMoCx_B(:,6),raw_sp_PaCx_DeltaMoCx_B(:,7),raw_sp_PaCx_DeltaMoCx_B(:,8),raw_sp_PaCx_DeltaMoCx_B(:,9)],2);
M252_sp_PaCx_DeltaMoCx_B=mean([raw_sp_PaCx_DeltaMoCx_B(:,10),raw_sp_PaCx_DeltaMoCx_B(:,11),raw_sp_PaCx_DeltaMoCx_B(:,12),raw_sp_PaCx_DeltaMoCx_B(:,13),raw_sp_PaCx_DeltaMoCx_B(:,14)],2);    

M243_dp_MoCx_DeltaMoCx_B=mean([raw_dp_MoCx_DeltaMoCx_B(:,1),raw_dp_MoCx_DeltaMoCx_B(:,2)],2);
M244_dp_MoCx_DeltaMoCx_B=mean([raw_dp_MoCx_DeltaMoCx_B(:,3),raw_dp_MoCx_DeltaMoCx_B(:,4)],2);
M251_dp_MoCx_DeltaMoCx_B=mean([raw_dp_MoCx_DeltaMoCx_B(:,5),raw_dp_MoCx_DeltaMoCx_B(:,6),raw_dp_MoCx_DeltaMoCx_B(:,7),raw_dp_MoCx_DeltaMoCx_B(:,8),raw_dp_MoCx_DeltaMoCx_B(:,9)],2);
M252_dp_MoCx_DeltaMoCx_B=mean([raw_dp_MoCx_DeltaMoCx_B(:,10),raw_dp_MoCx_DeltaMoCx_B(:,11),raw_dp_MoCx_DeltaMoCx_B(:,12),raw_dp_MoCx_DeltaMoCx_B(:,13),raw_dp_MoCx_DeltaMoCx_B(:,14)],2);

M243_sp_MoCx_DeltaMoCx_B=mean([raw_sp_MoCx_DeltaMoCx_B(:,1),raw_sp_MoCx_DeltaMoCx_B(:,2)],2);
M244_sp_MoCx_DeltaMoCx_B=mean([raw_sp_MoCx_DeltaMoCx_B(:,3),raw_sp_MoCx_DeltaMoCx_B(:,4)],2);
M251_sp_MoCx_DeltaMoCx_B=mean([raw_sp_MoCx_DeltaMoCx_B(:,5),raw_sp_MoCx_DeltaMoCx_B(:,6),raw_sp_MoCx_DeltaMoCx_B(:,7),raw_sp_MoCx_DeltaMoCx_B(:,8),raw_sp_MoCx_DeltaMoCx_B(:,9)],2);
M252_sp_MoCx_DeltaMoCx_B=mean([raw_sp_MoCx_DeltaMoCx_B(:,10),raw_sp_MoCx_DeltaMoCx_B(:,11),raw_sp_MoCx_DeltaMoCx_B(:,12),raw_sp_MoCx_DeltaMoCx_B(:,13),raw_sp_MoCx_DeltaMoCx_B(:,14)],2);

% <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
%---------------------------------------------------------------------------------------------------------------------------------------------------
%                                                                  Plot all that
%---------------------------------------------------------------------------------------------------------------------------------------------------
% <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>


figure('color',[1 1 1]),
hold on, subplot(5,4,1)
hold on, plot(timevalues,M243_HPC_rip_B,'k','linewidth',1)
hold on, xlim([-0.05 0.05])
hold on, ylabel('Ripples occurence')
hold on, subplot(5,4,2)
hold on, plot(timevalues,M243_dp_PFCx_rip_B,'b','linewidth',1)
hold on, plot(timevalues,M243_sp_PFCx_rip_B,'r','linewidth',1)
hold on, title('prefrontal LFP')
hold on, subplot(5,4,3)
hold on, plot(timevalues,M243_dp_PaCx_rip_B,'b','linewidth',1)
hold on, plot(timevalues,M243_sp_PaCx_rip_B,'r','linewidth',1)
hold on, title('parietal LFP')
hold on, subplot(5,4,4)
hold on, plot(timevalues,M243_dp_MoCx_rip_B,'b','linewidth',1)
hold on, plot(timevalues,M243_sp_MoCx_rip_B,'r','linewidth',1)
hold on, title('motor LFP')

hold on, subplot(5,4,5)
hold on, plot(timevalues,M243_HPC_DeltaPFCx_B,'k','linewidth',1)
hold on, ylabel('Prefrontal Cx Delta ')
hold on, subplot(5,4,6)
hold on, plot(timevalues,M243_dp_PFCx_DeltaPFCx_B,'b','linewidth',1)
hold on, plot(timevalues,M243_sp_PFCx_DeltaPFCx_B,'r','linewidth',1)
hold on, title('prefrontal LFP')
hold on, subplot(5,4,7)
hold on, plot(timevalues,M243_dp_PaCx_DeltaPFCx_B,'b','linewidth',1)
hold on, plot(timevalues,M243_sp_PaCx_DeltaPFCx_B,'r','linewidth',1)
hold on, title('parietal LFP')
hold on, subplot(5,4,8)
hold on, plot(timevalues,M243_dp_MoCx_DeltaPFCx_B,'b','linewidth',1)
hold on, plot(timevalues,M243_sp_MoCx_DeltaPFCx_B,'r','linewidth',1)
hold on, title('motor LFP')

hold on, subplot(5,4,9)
hold on, plot(timevalues,M243_HPC_StDown_B,'k','linewidth',1)
hold on, ylabel('Prefrontal Down State ')
hold on, subplot(5,4,10)
hold on, plot(timevalues,M243_dp_PFCx_StDown_B,'b','linewidth',1)
hold on, plot(timevalues,M243_sp_PFCx_StDown_B,'r','linewidth',1)
hold on, title('prefrontal LFP')
hold on, subplot(5,4,11)
hold on, plot(timevalues,M243_dp_PaCx_StDown_B,'b','linewidth',1)
hold on, plot(timevalues,M243_sp_PaCx_StDown_B,'r','linewidth',1)
hold on, title('parietal LFP')
hold on, subplot(5,4,12)
hold on, plot(timevalues,M243_dp_MoCx_StDown_B,'b','linewidth',1)
hold on, plot(timevalues,M243_sp_MoCx_StDown_B,'r','linewidth',1)
hold on, title('motor LFP')

hold on, subplot(5,4,13)
hold on, plot(timevalues,M243_HPC_DeltaPaCx_B,'k','linewidth',1)
hold on, ylabel('Parietal Cx Delta ')
hold on, subplot(5,4,14)
hold on, plot(timevalues,M243_dp_PFCx_DeltaPaCx_B,'b','linewidth',1)
hold on, plot(timevalues,M243_sp_PFCx_DeltaPaCx_B,'r','linewidth',1)
hold on, title('prefrontal LFP')
hold on, subplot(5,4,15)
hold on, plot(timevalues,M243_dp_PaCx_DeltaPaCx_B,'b','linewidth',1)
hold on, plot(timevalues,M243_sp_PaCx_DeltaPaCx_B,'r','linewidth',1)
hold on, title('parietal LFP')
hold on, subplot(5,4,16)
hold on, plot(timevalues,M243_dp_MoCx_DeltaPaCx_B,'b','linewidth',1)
hold on, plot(timevalues,M243_sp_MoCx_DeltaPaCx_B,'r','linewidth',1)
hold on, title('motor LFP')

hold on, subplot(5,4,17)
hold on, plot(timevalues,M243_HPC_DeltaMoCx_B,'k','linewidth',1)
hold on, ylabel('Motor Cx Delta ')
hold on, subplot(5,4,18)
hold on, plot(timevalues,M243_dp_PFCx_DeltaMoCx_B,'b','linewidth',1)
hold on, plot(timevalues,M243_sp_PFCx_DeltaMoCx_B,'r','linewidth',1)
hold on, title('prefrontal LFP')
hold on, subplot(5,4,19)
hold on, plot(timevalues,M243_dp_PaCx_DeltaMoCx_B,'b','linewidth',1)
hold on, plot(timevalues,M243_sp_PaCx_DeltaMoCx_B,'r','linewidth',1)
hold on, title('parietal LFP')
hold on, subplot(5,4,20)
hold on, plot(timevalues,M243_dp_MoCx_DeltaMoCx_B,'b','linewidth',1)
hold on, plot(timevalues,M243_sp_MoCx_DeltaMoCx_B,'r','linewidth',1)
hold on, title('motor LFP')
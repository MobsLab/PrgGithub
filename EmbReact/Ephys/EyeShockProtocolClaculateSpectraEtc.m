% Calculate Spectra : B,P,H Low and H very high
% Find H ripples
% EKG if its recorded
% Ripplle detection info
InputInfo.thresh=[3,5];
InputInfo.duration=[0.015,0.02,0.2];
InputInfo.MakeEventFile=1;
InputInfo.EventFileName='HPCRipples';
InputInfo.SaveRipples=1;
% EKG detection info
Options.TemplateThreshStd=3;
Options.BeatThreshStd=0.5;
smootime=3;


SessNames={ 'UMazeCond_EyeShock' 'UMazeCondBlockedShock_EyeShock' 'UMazeCondBlockedSafe_EyeShock',...
    'TestPost_EyeShock' 'Extinction_EyeShock' 'ExtinctionBlockedShock_EyeShock' 'ExtinctionBlockedSafe_EyeShock'};



for ss=1:length(SessNames)
    Dir=PathForExperimentsEmbReact(SessNames{ss});
    disp(SessNames{ss})
    for d=1:length(Dir.path)
        for dd=1:length(Dir.path{d})
            try
                if not(Dir.ExpeInfo{d}{dd}.nmouse==117)
                    cd(Dir.path{d}{dd})
                    
                    %                     %Ripples
                    %                     if exist('ChannelsToAnalyse/dHPC_rip.mat')>0
                    %
                    %                         load('ExpeInfo.mat')
                    %                         load('ChannelsToAnalyse/dHPC_rip.mat')
                    %                         load(['LFPData/LFP',num2str(channel),'.mat'])
                    %                         load('StateEpochSB.mat','TotalNoiseEpoch')
                    %
                    %                         if ExpeInfo.SleepSession==0
                    %                             load('behavResources.mat')
                    %                             if isempty(Behav.FreezeAccEpoch)
                    %                                 InputInfo.Epoch=Behav.FreezeEpoch-TotalNoiseEpoch;
                    %                             else
                    %                                 InputInfo.Epoch=Behav.FreezeAccEpoch-TotalNoiseEpoch;
                    %                             end
                    %                         else
                    %                             load('StateEpochSB.mat','SWSEpoch')
                    %                             InputInfo.Epoch=SWSEpoch-TotalNoiseEpoch;
                    %                         end
                    %
                    %
                    %
                    %                         %Get Ripple lims from sleep
                    %                         FileName=FindSleepFile(ExpeInfo.nmouse,ExpeInfo.date);
                    %                         cd(FileName.UMazeDay)
                    %                         load('StateEpochSB.mat','SWSEpoch')
                    %                         if sum(Stop(SWSEpoch,'s')-Start(SWSEpoch,'s'))>600
                    %                             load('Ripples.mat','MeanVal','StdVal')
                    %                             InputInfo.MeanStdVals=[MeanVal,StdVal];
                    %                         elseif ExpeInfo.nmouse==569
                    %                             cd /media/DataMOBsRAIDN/ProjectEmbReact/Mouse569/20170817/ProjectEmbReact_M569_20170817_SleepPre
                    %                             load('Ripples.mat','MeanVal','StdVal')
                    %                             InputInfo.MeanStdVals=[MeanVal,StdVal];
                    %                         else
                    %                             keyboard
                    %                         end
                    %                         clear SWSEpoch
                    %                         cd(Dir.path{d}{dd})
                    %                         if not(isempty(Start(InputInfo.Epoch)))
                    %                             FindRipplesSB(LFP,InputInfo);
                    %                         end
                    %                         clear LFP
                    %
                    %                         InputInfo=rmfield(InputInfo,'Epoch');
                    %                         InputInfo=rmfield(InputInfo,'MeanStdVals');
                    %
                    %
                    %
                    %                         if exist('H_VHigh_Spectrum.mat')==0
                    %                             VeryHighSpectrum([cd filesep],channel,'H')
                    %                         end
                    %
                    %                         %                         load('Ripples.mat')
                    %                         %                         load('ChannelsToAnalyse/dHPC_rip.mat')
                    %                         %                         load(['LFPData/LFP',num2str(channel),'.mat']);
                    %                         %                         FilLFP=FilterLFP(LFP,[120 220],1024);clear LFP
                    %                         %                         sqred=Data(FilLFP).^2;
                    %                         %                         sqred=(sqred-mean(sqred))./std(sqred);
                    %                         %                         SqredTsd=tsd(Range(FilLFP),sqred);
                    %                         %                         ripples=Rip;
                    %                         %
                    %                         %                         for rr=1:size(Rip,1)
                    %                         %                             Rip(rr,4)=max(Data(Restrict(SqredTsd,intervalSet(Rip(rr,1)*1e4,Rip(rr,3)*1e4))));
                    %                         %                         end
                    %                         %                         [maps,data,stats] = RippleStats([Range(FilLFP,'s'),Data(FilLFP)],Rip);
                    %                         %                         try,[stats.acg.data,stats.acg.t] = CCG(ripples(:,2)*20000,1,corrBinSize,nCorrBins/2,20000);stats.acg.t = stats.acg.t/1000;end
                    %                         %                         [C, B] = CrossCorr(Rip(:,1),Rip(:,1),0.001,200);
                    %                         %                         stats.acg.data=C;
                    %                         %                         stats.acg.t=B*10;
                    %                         %
                    %                         %                         save('Ripples.mat','maps','data','stats','-append')
                    %                         %                         clear  maps data stats Rip ripples FilLFP sqred SqredTsd C B
                    %
                    %                     end
                    % %                     cd(Dir.path{d}{dd})
                    
                    %                     load('ChannelsToAnalyse/Bulb_deep.mat')
                    %                     chB=channel;
                    %                     smootime=3;
                    %                     HighSpectrum([cd filesep],chB,'B');
                    %                     disp('Bulb Spectrum done')
                    clear smooth_ghi
                    load('StateEpochSB.mat','smooth_ghi')
                    if not(exist('smooth_ghi'))
                         disp(Dir.path{d}{dd})
                        load('ChannelsToAnalyse/Bulb_deep.mat')
                        chB=channel;
                        load(['LFPData/LFP',num2str(chB),'.mat'])
                        % find gamma epochs
                        disp(' ');
                        disp('... Creating Gamma Epochs ');
                        FilGamma=FilterLFP(LFP,[50 70],1024);
                        HilGamma=hilbert(Data(FilGamma));
                        H=abs(HilGamma);
                        tot_ghi=(tsd(Range(LFP),H));
                        smooth_ghi=tsd(Range(tot_ghi),runmean(Data(tot_ghi),ceil(smootime/median(diff(Range(tot_ghi,'s'))))));
                        
                        save('StateEpochSB','smootime','chB','smooth_ghi','-v7.3','-append');
                        clear chB smooth_ghi LFP
                        disp('Gamma done')
                    end
                    
                    %                     % Low Spectra
                                        if exist('B_Low_Spectrum.mat')==0
                                            clear channel
                                            load('ChannelsToAnalyse/Bulb_deep.mat')
                                            channel;
                                            LowSpectrumSB([cd filesep],channel,'B',0)
                                        end
                    %
                    %                     if exist('H_Low_Spectrum.mat')==0
                    %                         clear channel
                    %                         try,load('ChannelsToAnalyse/dHPC_rip.mat'), catch, load('ChannelsToAnalyse/dHPC_deep.mat'), end
                    %                         channel;
                    %                         LowSpectrumSB([cd filesep],channel,'H',0)
                    %                     end
                    %
                    %                     if exist('PFCx_Low_Spectrum.mat')==0
                    %                         clear channel
                    %                         load('ChannelsToAnalyse/PFCx_deep.mat')
                    %                         channel;
                    %                         LowSpectrumSB([cd filesep],channel,'PFCx',0)
                    %                     end
                    %
                    %
                    %                     % EKG if it is there
                    %                     if exist('ChannelsToAnalyse/EKG.mat')
                    %                         load('ChannelsToAnalyse/EKG.mat')
                    %                         load(['LFPData/LFP',num2str(channel),'.mat'])
                    %                         load('StateEpochSB.mat','TotalNoiseEpoch')
                    %                         load('behavResources.mat','TTLInfo')
                    %                         try,  TTLInfo;
                    %                             NoiseEpoch=or(TotalNoiseEpoch,intervalSet(Start(TTLInfo.StimEpoch),Start(TTLInfo.StimEpoch)+2*1e4));
                    %                         catch
                    %                             NoiseEpoch=TotalNoiseEpoch;
                    %                         end
                    %                         clf
                    %                         [Times,Template,HearRate]=DetectHeartBeats(LFP,NoiseEpoch,Options,1);
                    %                         EKG.HBTimes=ts(Times);
                    %                         EKG.HBShape=Template;
                    %                         EKG.DetectionOptions=Options;
                    %                         EKG.HBRate=HearRate;
                    %
                    %                         save('HeartBeatInfo.mat','EKG')
                    %                         saveas(1,'EKGCheck.fig')
                    %                         clear EKG NoiseEpoch TotalNoiseEpoch TTLInfo LFP EKG HearRate Template Times
                    %                     end
                    %
                    %                     % make .pos
                    %                     try
                    %                         SubName=dir('*.lfp');
                    %                         SubName=SubName.name(1:end-4);
                    %                         load('behavResources.mat')
                    %                         fileIDT = fopen('pos.txt','w');
                    %                         XDat=Data(Behav.Xtsd);
                    %                         YDat=Data(Behav.Ytsd);
                    %                         TDat=Range(Behav.Ytsd,'s');
                    %                         XDat=interp1(TDat,XDat,[min(TDat):0.05:max(TDat)])';
                    %                         YDat=interp1(TDat,YDat,[min(TDat):0.05:max(TDat)])';
                    %                         fprintf(fileIDT,'%3.3f %3.3f\n',[XDat,YDat]'*10);
                    %                         fclose(fileIDT);
                    %                         movefile('pos.txt',[SubName,'.pos'])
                    %                         clear XDat YDat TDat fileIDT
                    %                     end
                end
            end
        end
    end
end
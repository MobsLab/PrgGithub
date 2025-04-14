GetNicotineSessions_CH

Name = {'SalineOF','NicotineOF','NicotineLowOF','SalineHC','NicotineHC','DiazepamHC'};
EpochName = {'HCPre','HCPost'};
Session_type = {'OFPre','OFPost'};

Mouse_names_Nic = {'M1500','M1531','M1532','M1686','M1687','M1685'};
Mouse_names_Sal = {'M1685','M1686','M1612','M1641','M1644','M1687'};
Mouse_names_NicLow = {'M1614','M1644','M1688','M1641'};
Mouse_names_SalHC = {'M1411','M1412','M1414','M1416','M1417','M1418','M1207','M1224','M1225','M1227','M1252','M1253','M1254'};
Mouse_names_NicHC = {'M1411','M1412','M1413','M1414','M1415','M1416','M1417','M1418','M1385','M1393'};
Mouse_names_DzpHC = {'M1207','M1224','M1225','M1226','M1227','M1199','M1203','M1251','M1252'};
Mouse_names_NicHC = {'M1411','M1412','M1413','M1414','M1415','M1416','M1417','M1418','M1385','M1393','M1386','M1394','M1376','M1377'};


for group = 4:6
    if group == 4
        Mouse_names = Mouse_names_SalHC;
    elseif group == 5
        Mouse_names = Mouse_names_NicHC;
    elseif group == 6
        Mouse_names = Mouse_names_DzpHC;
    end
    for mouse=1:length(Mouse_names)
        path = sprintf('%s{%d}', Name{group}, mouse);
        
        folder_path = eval(path);
        cd(folder_path);
        disp(folder_path);
        clear AlignedXtsd AlignedYtsd Xtsd Ytsd x y
        load('behavResources.mat')
        load('SleepScoring_OBGamma.mat','Sleep','SmoothGamma')
        
        [gamma_thresh2,~,~,~,~,~] = GetGammaThresh(Data(SmoothGamma), 1);
        gamma_thresh2 = exp(gamma_thresh2);
        minduration = 3;
        GammaThreshCH = thresholdIntervals(SmoothGamma, gamma_thresh2, 'Direction','Below');
        GammaThreshCH = mergeCloseIntervals(GammaThreshCH, minduration*1e4);
        GammaThreshCH = dropShortIntervals(GammaThreshCH, minduration*1e4);
        save('behavResources.mat','GammaThreshCH','gamma_thresh2','-append')
        
        if not(exist('B_Low_Spectrum.mat'))
            load('ChannelsToAnalyse/Bulb_deep.mat')
            channel;
            LowSpectrumSB([cd filesep],channel,'B')
        end
        if not(exist('StateEpochSB.mat'))
            load('ChannelsToAnalyse/Bulb_deep.mat')
            channel;
            FindNoiseEpoch_BM([cd filesep],channel,0);
            
            load('StateEpochSB.mat')
            load('SleepScoring_OBGamma.mat','SWSEpoch','Wake')
            
            SleepyEpoch = intervalSet([],[]);
            save('StateEpochSB','SleepyEpoch','SWSEpoch','Wake','-append')
            load('ExpeInfo.mat')
            CreateRipplesSleep('stim',0,'restrict',0,'sleep',0,'plotavg',0)
        end
        
        thtps_immob=2;
        smoofact_Acc = 30;
        th_immob_Acc = 1.7e7;
        
        NewMovAcctsd=tsd(Range(MovAcctsd),runmean(Data(MovAcctsd),smoofact_Acc));
        FreezeAccEpoch=thresholdIntervals(NewMovAcctsd,th_immob_Acc,'Direction','Below');
        FreezeAccEpoch=mergeCloseIntervals(FreezeAccEpoch,0.3*1e4);
        FreezeAccEpoch=dropShortIntervals(FreezeAccEpoch,thtps_immob*1e4);
        FreezeAccEpoch = FreezeAccEpoch - Sleep;
        
        save('behavResources.mat', 'FreezeAccEpoch','-append');
        
        clear channel
    end
    if not(exist('HeartBeatInfo.mat'))
        try
            clear EKG channel
            Options.TemplateThreshStd=3;
            Options.BeatThreshStd=0.05;
            load('ChannelsToAnalyse/EKG.mat')
            load(['LFPData/LFP',num2str(channel),'.mat'])
            load('StateEpochSB.mat','TotalNoiseEpoch')
            load('ExpeInfo.mat')
            load('behavResources.mat')
            NoiseEpoch=TotalNoiseEpoch;
            [Times,Template,HeartRate,GoodEpoch]=DetectHeartBeats_EmbReact_SB(LFP,NoiseEpoch,Options,1);
            EKG.HBTimes=ts(Times);
            EKG.HBShape=Template;
            EKG.DetectionOptions=Options;
            EKG.HBRate=HeartRate;
            EKG.GoodEpoch=GoodEpoch;
            
            save('HeartBeatInfo.mat','EKG')
            saveas(1,'EKGCheck.fig'),
            saveas(1,'EKGCheck.png')
            close all
            clear EKG NoiseEpoch TotalNoiseEpoch TTLInfo LFP EKG HearRate Template Times
        end
    end
end



figure
for group = 5
    if group == 4
        Mouse_names = Mouse_names_SalHC;
    elseif group == 5
        Mouse_names = Mouse_names_NicHC;
    elseif group == 6
        Mouse_names = Mouse_names_DzpHC;
    end
    for mouse=1:length(Mouse_names)
        path = sprintf('%s{%d}', Name{group}, mouse);
        
        folder_path = eval(path);
        cd(folder_path);
        disp(folder_path);
        clear AlignedXtsd AlignedYtsd Xtsd Ytsd x y
        load('behavResources.mat')
        if exist('AlignedXtsd','var') == 0
            satisfied = 0;
            while satisfied ==0
                
                polygon = GetCageEdgesWithoutVideo(Data(Ytsd),Data(Xtsd));
                x = polygon.Position(:,2);
                y = polygon.Position(:,1);
                turn = input('cage vertical? (0/1)');
                if turn == 1
                    Coord1 = [x(1)-x(2),y(1)-y(2)];
                    Coord2 = [x(3)-x(2),y(3)-y(2)];
                elseif turn ==0
                    Coord2 = [x(1)-x(2),y(1)-y(2)];
                    Coord1 = [x(3)-x(2),y(3)-y(2)];
                end
                TranssMat = [Coord1',Coord2'];
                XInit = Data(Xtsd)-x(2);
                YInit = Data(Ytsd)-y(2);
                
                The Xtsd and Ytsd in new coordinates
                A = ((pinv(TranssMat)*[XInit,YInit]')');
                AlignedXtsd = tsd(Range(Xtsd),40*A(:,1));
                AlignedYtsd = tsd(Range(Ytsd),20*A(:,2));
                clf
                
                plot(Data(AlignedXtsd),Data(AlignedYtsd))
                xlim([0 40])
                ylim([0 40])
                
                satisfied = input('happy?');
                clf
            end
            close all
            save('behavResources.mat', 'AlignedXtsd', 'AlignedYtsd','-append');
        end
    end
end


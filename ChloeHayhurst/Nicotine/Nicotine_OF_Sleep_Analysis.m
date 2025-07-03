clear all, close all

GetNicotineSessions_CH

Name = {'NicotineOFSleep'};
Session_type = {'Pre','Post'};


Mouse_names_Nic_Sleep = {'M1500','M1531','M1742','M173','M1745','M1746','M1747'};

sizeMap = 100;
sizeMap2 = 1000;


clear ActiveEpoch

disp('Fetching data...')

for group = 1:length(Name)
    if group == 1
        Mouse_names = Mouse_names_Nic_Sleep;
    elseif group == 2
        Mouse_names = Mouse_names_Saline_Sleep;
    end
    for mouse=1:length(Mouse_names)
        for sess=1:2
            
            path = sprintf('%s.%s{%d}', Name{group}, Session_type{sess}, mouse);
            folder_path = eval(path);
            cd(folder_path);
            disp(folder_path);
            clear AlignedXtsd AlignedYtsd FreezeAccEpoch Wake WakeWiNoise REMEpoch REMEpochWiNoise SWSEpoch SWSEpochWiNoise SleepWiNoise
            load('behavResources.mat'), 
            try
                load('SleepScoring_OBGamma.mat');
            catch
                load('SleepScoring_Accelero.mat');
            end
            
            Epoch = intervalSet(0,max(Range(MovAcctsd)));
            Accelero.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) = MovAcctsd;
            Speed.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) = Vtsd;
            
            TotalEpoch.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) = Epoch;
            
            WakeNoNoise.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) = Wake;
            WakeWithNoise.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) = WakeWiNoise;
            
            REMNoNoise.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) = REMEpoch;
            REMWithNoise.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) = REMEpochWiNoise;
            
            SWSNoNoise.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) = SWSEpoch;
            SWSWithNoise.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) = SWSEpochWiNoise;
            
            SleepWithNoise.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) = SleepWiNoise;
            
            SpeedWake.(Name{group}).(Session_type{sess}).(Mouse_names{mouse})  = Restrict(Vtsd,WakeWiNoise);
            
            %             try
            %                 load('H_Low_Spectrum.mat')
            %                 OB_Sp_tsd2 = tsd(Spectro{2}*1e4 , Spectro{1});
            %                 SpectroHPCWake.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) = Restrict(OB_Sp_tsd2,WakeNoNoise.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}));
            %                 MeanSpectroHPCWake.(Name{group}).(Session_type{sess})(mouse,:) = nanmean(Data(SpectroHPCWake.(Name{group}).(Session_type{sess}).(Mouse_names{mouse})));
            %
            %                 SpectroHPCREM.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) = Restrict(OB_Sp_tsd2,REMNoNoise.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}));
            %                 MeanSpectroHPCREM.(Name{group}).(Session_type{sess})(mouse,:) = nanmean(Data(SpectroHPCREM.(Name{group}).(Session_type{sess}).(Mouse_names{mouse})));
            %
            %                 SpectroHPCSWS.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) = Restrict(OB_Sp_tsd2,SWSNoNoise.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}));
            %                 MeanSpectroHPCSWS.(Name{group}).(Session_type{sess})(mouse,:) = nanmean(Data(SpectroHPCSWS.(Name{group}).(Session_type{sess}).(Mouse_names{mouse})));
            %
            %             end
            try
                load('HeartBeatInfo.mat')
                HeartRate.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) = EKG.HBRate;
                
                HeartRateVar.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) = tsd(Range(EKG.HBRate),movstd(Data(EKG.HBRate),5));
                
                HRWake.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) = Restrict(EKG.HBRate,WakeNoNoise.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}));
                MeanHRWake.(Name{group}).(Session_type{sess})(mouse) = nanmean(Data(HRWake.(Name{group}).(Session_type{sess}).(Mouse_names{mouse})));
                HRVarWake.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) = Restrict(HeartRateVar.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}),WakeNoNoise.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}));
                MeanHRVarWake.(Name{group}).(Session_type{sess})(mouse) = nanmean(Data(HRVarWake.(Name{group}).(Session_type{sess}).(Mouse_names{mouse})));
                
                
                
                HRREM.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) = Restrict(EKG.HBRate,REMNoNoise.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}));
                MeanHRREM.(Name{group}).(Session_type{sess})(mouse) = nanmean(Data(HRREM.(Name{group}).(Session_type{sess}).(Mouse_names{mouse})));
                HRVarREM.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) = Restrict(HeartRateVar.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}),REMNoNoise.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}));
                MeanHRVarREM.(Name{group}).(Session_type{sess})(mouse) = nanmean(Data(HRVarREM.(Name{group}).(Session_type{sess}).(Mouse_names{mouse})));
                
                
                
                HRSWS.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) = Restrict(EKG.HBRate,SWSNoNoise.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}));
                MeanHRSWS.(Name{group}).(Session_type{sess})(mouse) = nanmean(Data(HRSWS.(Name{group}).(Session_type{sess}).(Mouse_names{mouse})));
                HRVarSWS.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) = Restrict(HeartRateVar.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}),SWSNoNoise.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}));
                MeanHRVarSWS.(Name{group}).(Session_type{sess})(mouse) = nanmean(Data(HRVarSWS.(Name{group}).(Session_type{sess}).(Mouse_names{mouse})));
                
                
                HRSleep.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) = Restrict(EKG.HBRate,SleepWithNoise.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}));

                
            catch
                MeanHRWake.(Name{group}).(Session_type{sess})(mouse) = NaN;
                MeanHRREM.(Name{group}).(Session_type{sess})(mouse) = NaN;
                MeanHRSWS.(Name{group}).(Session_type{sess})(mouse) = NaN;
                MeanHRVarWake.(Name{group}).(Session_type{sess})(mouse) = NaN;
                MeanHRVarREM.(Name{group}).(Session_type{sess})(mouse) = NaN;
                MeanHRVarSWS.(Name{group}).(Session_type{sess})(mouse) = NaN;
            end
            
            try
                load('SWR.mat', 'RipplesEpoch','tRipples','RipDens_tsd')
                %
                %                 Ripts.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) = tRipples;
                %
                %                 Rg_Acc = Range(MovAcctsd);
                %                 i=1; bin_length = ceil(2/median(diff(Range(MovAcctsd,'s')))); % in 2s
                %                 for bin=1:bin_length:length(Rg_Acc)-bin_length
                %                     SmallEpoch=intervalSet(Rg_Acc(bin),Rg_Acc(bin+bin_length));
                %                     RipDensity_temp(i) = length(Start(and(RipplesEpoch , SmallEpoch)));
                %                     TimeRange(i) = Rg_Acc(bin);
                %                     i=i+1;
                %                 end
                
                RipDensity_tsd.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) = RipDens_tsd;
                
                RipDensity_Wake.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) = Restrict(RipDensity_tsd.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}), WakeNoNoise.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}));
                MeanRipDensity_Wake.(Name{group}).(Session_type{sess})(mouse) = length(Restrict(tRipples,WakeNoNoise.(Name{group}).(Session_type{sess}).(Mouse_names{mouse})))/sum(DurationEpoch(WakeNoNoise.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}),'s'));
                
                RipDensity_REM.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) = Restrict(RipDensity_tsd.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}), REMNoNoise.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}));
                MeanRipDensity_REM.(Name{group}).(Session_type{sess})(mouse) = length(Restrict(tRipples,REMNoNoise.(Name{group}).(Session_type{sess}).(Mouse_names{mouse})))/sum(DurationEpoch(REMNoNoise.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}),'s'));
                
                RipDensity_SWS.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) = Restrict(RipDensity_tsd.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}), SWSNoNoise.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}));
                MeanRipDensity_SWS.(Name{group}).(Session_type{sess})(mouse) = length(Restrict(tRipples,SWSNoNoise.(Name{group}).(Session_type{sess}).(Mouse_names{mouse})))/sum(DurationEpoch(SWSNoNoise.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}),'s'));
                
            catch
                
                MeanRipDensity_Wake.(Name{group}).(Session_type{sess})(mouse) = NaN;
                MeanRipDensity_REM.(Name{group}).(Session_type{sess})(mouse) = NaN;
                MeanRipDensity_SWS.(Name{group}).(Session_type{sess})(mouse) = NaN;
            
            end
            
        end
        
        try
            HRnorm_Wake.(Name{group}).(Mouse_names{mouse}) = tsd(Range(HRWake.(Name{group}).Post.(Mouse_names{mouse})), ...
                Data(HRWake.(Name{group}).Post.(Mouse_names{mouse})) - MeanHRWake.(Name{group}).Pre(mouse));
            HRnorm_REM.(Name{group}).(Mouse_names{mouse}) = tsd(Range(HRREM.(Name{group}).Post.(Mouse_names{mouse})), ...
                Data(HRREM.(Name{group}).Post.(Mouse_names{mouse})) - MeanHRREM.(Name{group}).Pre(mouse));
            HRnorm_SWS.(Name{group}).(Mouse_names{mouse}) = tsd(Range(HRSWS.(Name{group}).Post.(Mouse_names{mouse})), ...
                Data(HRSWS.(Name{group}).Post.(Mouse_names{mouse})) - MeanHRSWS.(Name{group}).Pre(mouse));
            HRnorm_Wake_mean.(Name{group})(mouse) = nanmean(Data(HRnorm_Wake.(Name{group}).(Mouse_names{mouse})));
            HRnorm_REM_mean.(Name{group})(mouse) = nanmean(Data(HRnorm_REM.(Name{group}).(Mouse_names{mouse})));
            HRnorm_SWS_mean.(Name{group})(mouse) = nanmean(Data(HRnorm_SWS.(Name{group}).(Mouse_names{mouse})));
        catch
            HRnorm_Wake_mean.(Name{group})(mouse) = NaN;
            HRnorm_REM_mean.(Name{group})(mouse) = NaN;
            HRnorm_SWS_mean.(Name{group})(mouse) = NaN;
        end
        
        clear RipplesEpoch tRipples
    end
end


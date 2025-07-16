clear all, close all

GetNicotineSessions_Sleep

Name = {'NicotineOFSleep','SalineOFSleep','NicotineOF','SalineOF'};
Session_type = {'Pre','Post'};


Mouse_names_Nic = {'M1500','M1531','M1742','M1743','M1745','M1746','M1747','M1775'};
Mouse_names_Sal = {'M1746','M1747','M1776'};


sizeMap = 100;
sizeMap2 = 1000;


clear ActiveEpoch

disp('Fetching data...')

for group = 1:2
    if group == 1
        Mouse_names = Mouse_names_Nic;
    elseif group == 2
        Mouse_names = Mouse_names_Sal;
    end
    for mouse=1:length(Mouse_names)
        for sess=1:2
            
            path = sprintf('%s.%s{%d}', Name{group}, Session_type{sess}, mouse);
            folder_path = eval(path);
            cd(folder_path);
            disp(folder_path);
            clear AlignedXtsd AlignedYtsd FreezeAccEpoch Wake WakeWiNoise REMEpoch REMEpochWiNoise SWSEpoch SWSEpochWiNoise SleepWiNoise
            load('behavResources.mat');
            
            try
                load('SleepScoring_Accelero.mat');
            catch
                load('SleepScoring_OBGamma.mat');
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
            
            PropWake.(Name{group}).(Session_type{sess})(mouse) = sum(DurationEpoch(WakeWiNoise))/sum(DurationEpoch(Epoch));
            PropREM.(Name{group}).(Session_type{sess})(mouse) = sum(DurationEpoch(REMEpochWiNoise))/sum(DurationEpoch(Epoch));
            PropNREM.(Name{group}).(Session_type{sess})(mouse) = sum(DurationEpoch(SWSEpochWiNoise))/sum(DurationEpoch(Epoch));
            
            
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
    
        clear RipplesEpoch tRipples
    end
end

for group = 3:4
    if group == 3
        Mouse_names = Mouse_names_Nic;
    elseif group == 4
        Mouse_names = Mouse_names_Sal;
    end
    for mouse=1:length(Mouse_names)
        for sess=1:2
            
            path = sprintf('%s.%s{%d}', Name{group}, Session_type{sess}, mouse);
            folder_path = eval(path);
            cd(folder_path);
            disp(folder_path);
            clear AlignedXtsd AlignedYtsd FreezeAccEpoch
            load('behavResources.mat'), load('StateEpochSB.mat','smooth_ghi')
            
            Epoch = intervalSet(0,max(Range(MovAcctsd)));
            Accelero.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) = MovAcctsd;
            Speed.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) = Vtsd;
            GammaPower.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) = smooth_ghi;
            
            TotalEpoch.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) = intervalSet(0,max(Range(MovAcctsd)));
            
            FreezeEpochAcc.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) = FreezeAccEpoch;
            
            Groom.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) = GroomingInfo;
            GroomProp.(Name{group}).(Session_type{sess})(mouse) = sum(DurationEpoch(GroomingInfo,'s'))/sum(DurationEpoch(TotalEpoch.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}),'s'));
            
            FreezeTimeAcc.(Name{group}).(Session_type{sess})(mouse) = sum(DurationEpoch(FreezeEpochAcc.(Name{group}).(Session_type{sess}).(Mouse_names{mouse})))/1e4;
            
            FreezeProp.(Name{group}).(Session_type{sess})(mouse) = FreezeTimeAcc.(Name{group}).(Session_type{sess})(mouse)./sum(DurationEpoch(TotalEpoch.(Name{group}).(Session_type{sess}).(Mouse_names{mouse})));
            ActiveEpoch.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) = Epoch - FreezeAccEpoch;
            
            XtsdAligned.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) = AlignedXtsd;
            YtsdAligned.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) = AlignedYtsd;
            
            try
                load('B_Low_Spectrum.mat')
                load('BreathingRate.mat')
                OB_Sp_tsd2 = tsd(Spectro{2}*1e4 , Spectro{1});
                SpectroBulbFz.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) = Restrict(OB_Sp_tsd2,FreezeEpochAcc.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}));
                MeanSpectroFz.(Name{group}).(Session_type{sess})(mouse,:) = nanmean(Data(SpectroBulbFz.(Name{group}).(Session_type{sess}).(Mouse_names{mouse})));
                SpectroBulbFzCam.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) = Restrict(OB_Sp_tsd2,FreezeEpochCam.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}));
                MeanSpectroFzCam.(Name{group}).(Session_type{sess})(mouse,:) = nanmean(Data(SpectroBulbFzCam.(Name{group}).(Session_type{sess}).(Mouse_names{mouse})));
                BreathingSpec.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) = Spec;
                BreathingPT.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) = PT;
                BreathingWV.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) = WV;
                
                MeanSpectro.(Name{group}).(Session_type{sess})(mouse,:) = nanmean(Data(OB_Sp_tsd2));
                RespiFz.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) = Restrict(BreathingSpec.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}),FreezeEpochAcc.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}));
                RespiFzPT.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) = Restrict(BreathingPT.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}),FreezeEpochAcc.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}));
                RespiFzWV.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) = Restrict(BreathingWV.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}),FreezeEpochAcc.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}));
                
                MeanRespiFz.(Name{group}).(Session_type{sess})(mouse) = nanmean(Data(RespiFz.(Name{group}).(Session_type{sess}).(Mouse_names{mouse})));
                SpectroBulbActive.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) = Restrict(OB_Sp_tsd2,ActiveEpoch.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}));
                MeanSpectroActive.(Name{group}).(Session_type{sess})(mouse,:) = nanmean(Data(SpectroBulbActive.(Name{group}).(Session_type{sess}).(Mouse_names{mouse})));
                
            end
            
            clear H H2
            if exist('HeartBeatInfo.mat', 'file') == 2
                load('HeartBeatInfo.mat');
                HeartRate.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) = EKG.HBRate;
                HR_Var = tsd(Range(EKG.HBRate),movstd(Data(EKG.HBRate),5));
                HeartRateVar.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) = HR_Var;
                H = Physio_Norm_by_Speed(Vtsd,EKG.HBRate,'HR');
                HeartRate_Norm.(Name{group}).(Session_type{sess})(mouse,:) = H;
                H2 = Physio_Norm_by_Speed(Vtsd,HR_Var,'HRVar');
                HeartRateVar_Norm.(Name{group}).(Session_type{sess})(mouse,:) = H2;
            else
                disp('No HR for this mouse')
                HeartRate_Norm.(Name{group}).(Session_type{sess})(mouse,1:100) = NaN;
                HeartRateVar_Norm.(Name{group}).(Session_type{sess})(mouse,1:100) = NaN;
            end
            try
                HRFz.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) = Restrict(EKG.HBRate,FreezeEpochAcc.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}));
                MeanHRFz.(Name{group}).(Session_type{sess})(mouse) = nanmean(Data(HRFz.(Name{group}).(Session_type{sess}).(Mouse_names{mouse})));
                HRVarFz.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) = Restrict(HeartRateVar.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}),FreezeEpochAcc.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}));
                MeanHRVarFz.(Name{group}).(Session_type{sess})(mouse) = nanmean(Data(HRVarFz.(Name{group}).(Session_type{sess}).(Mouse_names{mouse})));
                
            catch
                MeanHRFz.(Name{group}).(Session_type{sess})(mouse) = NaN;
                MeanHRVarFz.(Name{group}).(Session_type{sess})(mouse) = NaN;
                
            end
            try
                load('SWR.mat', 'RipplesEpoch','tRipples','RipDens_tsd')
                Ripts.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) = tRipples;
                RipDens_Fz.(Name{group}).(Session_type{sess})(mouse) = length(tRipples)/sum(DurationEpoch(FreezeAccEpoch));
                RipDensity_tsd.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) = RipDens_tsd;
                RipDensity_tsd_Fz.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) = Restrict(RipDensity_tsd.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}), FreezeEpochAcc.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}));
            end
            clear RipplesEpoch tRipples RipDens_tsd
        end
    end
end

disp('Making Distance to Center')
for group = 3:4
    if group == 3
        Mouse_names = Mouse_names_Nic;
    elseif group == 4
        Mouse_names = Mouse_names_Sal;

    end
    disp(Name{group})
    for sess=1:2
        disp(Session_type{sess})
        for mouse=1:length(Mouse_names)
            Epoch = intervalSet(0,900e4);
            Epoch2=intervalSet(1500e4,1800e4);
            Epoch3=intervalSet(0,1800e4);
            ActEpoch = Epoch - FreezeEpochAcc.(Name{group}).(Session_type{sess}).(Mouse_names{mouse});
            [~,Distance,~,~,~] = Thigmotaxis_OF_CH(XtsdAligned.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}), YtsdAligned.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}),'OF','figure',0,'percent_inner',0.7,'tsdata',1);
            DistanceToCenter.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) = Distance;
            DistanceToCenter_mean.(Name{group}).(Session_type{sess})(mouse)=nanmean(Data(Distance));
            DistanceToCenterAll_mean.(Name{group}).(Session_type{sess})(mouse)=nanmean(Data(Restrict(Distance,Epoch3)));
            
            try
                DistanceToCenterActive_mean.(Name{group}).(Session_type{sess})(mouse)=nanmean(Data(Restrict(Distance,ActEpoch)));
            catch
                DistanceToCenterActive_mean.(Name{group}).(Session_type{sess})(mouse) = NaN;
            end
            try
                DistanceToCenterBasis_mean.(Name{group}).(Session_type{sess})(mouse)=nanmean(Data(Restrict(Distance,Epoch2)));
            catch
                DistanceToCenterBasis_mean.(Name{group}).(Session_type{sess})(mouse) = NaN;
            end
            
            try
                DistanceToCenterBeginning_mean.(Name{group}).(Session_type{sess})(mouse)=nanmean(Data(Restrict(Distance,Epoch)));
            catch
                DistanceToCenterBeginning_mean.(Name{group}).(Session_type{sess})(mouse) = NaN;
            end
            
            
%             clear AlignedXtsd_Epoch AlignedYtsd_Epoch AlignedXtsdActive_Epoch AlignedYtsdActive_Epoch ActEpoch
%             a = 0;
%             for i = 1:60
%                 try
%                     SmallEpoch = intervalSet(a,a+30e4);
%                     ActEpoch = SmallEpoch - FreezeEpochAcc.(Name{group}).(Session_type{sess}).(Mouse_names{mouse});
%                     SmallFreezeEpoch = and(SmallEpoch,FreezeEpochAcc.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}));
%                     AlignedXtsd_Epoch = Restrict(XtsdAligned.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}),SmallEpoch);
%                     AlignedYtsd_Epoch = Restrict(YtsdAligned.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}),SmallEpoch);
%                     AlignedXtsdActive_Epoch = Restrict(XtsdAligned.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}),ActEpoch);
%                     AlignedYtsdActive_Epoch = Restrict(YtsdAligned.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}),ActEpoch);
%                     AlignedXtsdFreezing_Epoch = Restrict(XtsdAligned.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}),SmallFreezeEpoch);
%                     AlignedYtsdFreezing_Epoch = Restrict(YtsdAligned.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}),SmallFreezeEpoch);
% 
%                     
%                     if length(AlignedXtsd_Epoch) > 1
%                         DistanceToCenter2.(Name{group}).(Session_type{sess})(mouse,i) = nanmean(Data(Restrict(Distance,SmallEpoch)));
%                     else
%                         DistanceToCenter2.(Name{group}).(Session_type{sess})(mouse,i) = NaN;
%                     end
%                     
%                     if length(AlignedXtsdActive_Epoch) > 1
%                         DistanceToCenterActive.(Name{group}).(Session_type{sess})(mouse,i) = nanmean(Data(Restrict(Distance,ActEpoch)));
%                     else
%                         DistanceToCenterActive.(Name{group}).(Session_type{sess})(mouse,i) = NaN;
%                     end
%                     
%                     if length(AlignedXtsdFreezing_Epoch) > 1
%                         DistanceToCenterFz.(Name{group}).(Session_type{sess})(mouse,i) = nanmean(Data(Restrict(Distance,SmallFreezeEpoch)));
%                     else
%                         DistanceToCenterFz.(Name{group}).(Session_type{sess})(mouse,i) = NaN;
%                     end
%                 catch
%                     DistanceToCenterFz.(Name{group}).(Session_type{sess})(mouse,i) = NaN;
%                     DistanceToCenterActive.(Name{group}).(Session_type{sess})(mouse,i) = NaN;
%                     DistanceToCenter2.(Name{group}).(Session_type{sess})(mouse,i) = NaN;
%                 end
%                 a = a+30e4;
%                 
%             end
        end
    end
end



for group = 1:2
    if group == 1
        Mouse_names = Mouse_names_Nic;
    elseif group == 2
        Mouse_names = Mouse_names_Sal;
    end
    for mouse=1:length(Mouse_names)
        for sess=1
            
            j = max(End(TotalEpoch.(Name{group}).(Session_type{sess}).(Mouse_names{mouse})));
            
            for i = 1:10
                Epoch = intervalSet(j-18000e4, j);
                Acctemp = Restrict(Accelero.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}),Epoch);
                if length(Range(Acctemp))>1
                    
                    SleepEpochTemp = and(SleepWithNoise.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}),Epoch);
                    SleepPropTemp.(Name{group}).(Session_type{sess})(mouse,i) = sum(Stop(SleepEpochTemp)-Start(SleepEpochTemp))/sum(Stop(Epoch)-Start(Epoch));
                    
                    REMEpochTemp = and(REMWithNoise.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}),Epoch);
                    REMPropTemp.(Name{group}).(Session_type{sess})(mouse,i) = sum(Stop(REMEpochTemp)-Start(REMEpochTemp))/sum(Stop(Epoch)-Start(Epoch));
                    REMPropTemp2.(Name{group}).(Session_type{sess})(mouse,i) = sum(Stop(REMEpochTemp)-Start(REMEpochTemp))/sum(Stop(SleepEpochTemp)-Start(SleepEpochTemp));
                    
                    NREMEpochTemp = and(SWSWithNoise.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}),Epoch);
                    NREMPropTemp.(Name{group}).(Session_type{sess})(mouse,i) = sum(Stop(NREMEpochTemp)-Start(NREMEpochTemp))/sum(Stop(Epoch)-Start(Epoch));
                    NREMPropTemp2.(Name{group}).(Session_type{sess})(mouse,i) = sum(Stop(NREMEpochTemp)-Start(NREMEpochTemp))/sum(Stop(SleepEpochTemp)-Start(SleepEpochTemp));
                    
                    WakeEpochTemp = and(WakeWithNoise.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}),Epoch);
                    WakePropTemp.(Name{group}).(Session_type{sess})(mouse,i) = sum(Stop(WakeEpochTemp)-Start(WakeEpochTemp))/sum(Stop(Epoch)-Start(Epoch));
                
                else
                    SleepPropTemp.(Name{group}).(Session_type{sess})(mouse,i) = NaN;
                    NREMPropTemp.(Name{group}).(Session_type{sess})(mouse,i) = NaN;
                    REMPropTemp.(Name{group}).(Session_type{sess})(mouse,i) = NaN;
                    WakePropTemp.(Name{group}).(Session_type{sess})(mouse,i) = NaN;

                end
                
                j = j+1800e4;
                clear REMEpochTemp  NREMEpochTemp
            end
        end
    end
end

clear j
for group = 1:2
    if group == 1
        Mouse_names = Mouse_names_Nic;
    elseif group == 2
        Mouse_names = Mouse_names_Sal;
    end
    for mouse=1:length(Mouse_names)
        for sess=2
            
            j = 0;
            
            for i = 1:10
                Epoch = intervalSet(j, j+1800e4);
                Acctemp = Restrict(Accelero.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}),Epoch);
                if length(Range(Acctemp))>1
                    
                    SleepEpochTemp = and(SleepWithNoise.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}),Epoch);
                    SleepPropTemp.(Name{group}).(Session_type{sess})(mouse,i) = sum(Stop(SleepEpochTemp)-Start(SleepEpochTemp))/sum(Stop(Epoch)-Start(Epoch));
                    
                    REMEpochTemp = and(REMWithNoise.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}),Epoch);
                    REMPropTemp.(Name{group}).(Session_type{sess})(mouse,i) = sum(Stop(REMEpochTemp)-Start(REMEpochTemp))/sum(Stop(Epoch)-Start(Epoch));
                    REMPropTemp2.(Name{group}).(Session_type{sess})(mouse,i) = sum(Stop(REMEpochTemp)-Start(REMEpochTemp))/sum(Stop(SleepEpochTemp)-Start(SleepEpochTemp));
                    
                    NREMEpochTemp = and(SWSWithNoise.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}),Epoch);
                    NREMPropTemp.(Name{group}).(Session_type{sess})(mouse,i) = sum(Stop(NREMEpochTemp)-Start(NREMEpochTemp))/sum(Stop(Epoch)-Start(Epoch));
                    NREMPropTemp2.(Name{group}).(Session_type{sess})(mouse,i) = sum(Stop(NREMEpochTemp)-Start(NREMEpochTemp))/sum(Stop(SleepEpochTemp)-Start(SleepEpochTemp));
                    
                    WakeEpochTemp = and(WakeWithNoise.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}),Epoch);
                    WakePropTemp.(Name{group}).(Session_type{sess})(mouse,i) = sum(Stop(WakeEpochTemp)-Start(WakeEpochTemp))/sum(Stop(Epoch)-Start(Epoch));
                
                else
                    SleepPropTemp.(Name{group}).(Session_type{sess})(mouse,i) = NaN;
                    NREMPropTemp.(Name{group}).(Session_type{sess})(mouse,i) = NaN;
                    REMPropTemp.(Name{group}).(Session_type{sess})(mouse,i) = NaN;
                    WakePropTemp.(Name{group}).(Session_type{sess})(mouse,i) = NaN;

                end
                
                j = j+1800e4;
                clear REMEpochTemp  NREMEpochTemp WakeEpochTemp
            end
        end
    end
end



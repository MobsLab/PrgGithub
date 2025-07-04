
clear all, close all

GetNicotineSessions_CH

Name = {'SalineOF','NicotineOF','NicotineLowOF','SalineHC','NicotineHC'};
EpochName = {'HCPre','HCPost'};
% Session_type = {'Pre','Post','Post0to7','Post7toEnd'};
Session_type = {'Pre','Post'};


Mouse_names_Nic = {'M1500','M1531','M1532','M1686','M1687','M1685','M1713','M1714','M1747','M1742','M1743','M1745','M1746'};

Mouse_names_Sal = {'M1685','M1686','M1612','M1641','M1644','M1687','M1688','M1742','M1747'};
Mouse_names_NicLow = {'M1614','M1644','M1688','M1641','M1612'};
Mouse_names_SalHC = {'M1411','M1412','M1414','M1416','M1417','M1418','M1207','M1224','M1225','M1227','M1252','M1253','M1254'};
Mouse_names_NicHC = {'M1411','M1412','M1613','M1414','M1415','M1416','M1417','M1418','M1385','M1391','M1393'};


sizeMap = 100;
sizeMap2 = 1000;


clear ActiveEpoch

disp('Fetching data...')
figure
for group = 1:2
    if group == 2
        Mouse_names = Mouse_names_Nic;
    elseif group == 1
        Mouse_names = Mouse_names_Sal;
    elseif group == 3
        Mouse_names = Mouse_names_NicLow;
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
            
            AcceleroAll.(Name{group}).(Session_type{sess})(mouse,:) = interp1(linspace(0,1000,length(Accelero.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}))),Data(Accelero.(Name{group}).(Session_type{sess}).(Mouse_names{mouse})), linspace(0,1000,1000));
            
            TotalEpoch.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) = intervalSet(0,max(Range(MovAcctsd)));
          
            FreezeEpochAcc.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) = FreezeAccEpoch;
            FreezeEpochCam.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) = FreezeEpoch;
            
            Groom.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) = GroomingInfo;
            GroomTime.(Name{group}).(Session_type{sess})(mouse) = sum(DurationEpoch(GroomingInfo,'s'));
            GroomInfo.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) = GroomingInfo;

            
            FreezeTimeAcc.(Name{group}).(Session_type{sess})(mouse) = sum(DurationEpoch(FreezeEpochAcc.(Name{group}).(Session_type{sess}).(Mouse_names{mouse})))/1e4;
            FreezeTimeCam.(Name{group}).(Session_type{sess})(mouse) = sum(DurationEpoch(FreezeEpochCam.(Name{group}).(Session_type{sess}).(Mouse_names{mouse})))/1e4;
            
            FreezeProp.(Name{group}).(Session_type{sess})(mouse) = FreezeTimeAcc.(Name{group}).(Session_type{sess})(mouse)./sum(DurationEpoch(TotalEpoch.(Name{group}).(Session_type{sess}).(Mouse_names{mouse})));
            ActiveEpoch.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) = Epoch - FreezeAccEpoch;
            ActiveEpochCam.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) = Epoch - FreezeEpoch;
            
            XtsdAligned.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) = AlignedXtsd;
            YtsdAligned.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) = AlignedYtsd;
            
            XtsdAlignedFz = Restrict(XtsdAligned.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}),FreezeEpochAcc.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}));
            YtsdAlignedFz = Restrict(YtsdAligned.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}),FreezeEpochAcc.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}));
            
            subplot(1,2,sess)
            clear h
            h = histogram2(Data(YtsdAligned.(Name{group}).(Session_type{sess}).(Mouse_names{mouse})),Data(XtsdAligned.(Name{group}).(Session_type{sess}).(Mouse_names{mouse})),[0.01:0.01:1],[0.01:0.01:1]);
            OccupMap.(Name{group}).(Session_type{sess})(:,:,mouse) = (h.Values)./nansum(h.Values(:));
            clf
            clear h
            h = histogram2(Data(YtsdAlignedFz),Data(XtsdAlignedFz),[0.01:0.01:1],[0.01:0.01:1]);
            OccupMapFz.(Name{group}).(Session_type{sess})(:,:,mouse) = (h.Values)./nansum(h.Values(:));         
            clf
            
            map = OccupMap.(Name{group}).(Session_type{sess})(:,:,mouse);
            clear minVal maxVal totaltime
            minVal = min(map(:));
            maxVal = max(map(:));
            totaltime = sum(map(:));
            
            OccupMapNorm.(Name{group}).(Session_type{sess})(:,:,mouse) = (map - minVal) / (maxVal - minVal); % normalized between 0 and 1
            OccupMapNorm2.(Name{group}).(Session_type{sess})(:,:,mouse) = map / totaltime; % normalized by proportion of time
            
            mapfz = OccupMapFz.(Name{group}).(Session_type{sess})(:,:,mouse);
            clear minVal maxVal totaltime
            minVal = min(mapfz(:));
            maxVal = max(mapfz(:));
            totaltime = sum(mapfz(:));
            
            OccupMapNormFz.(Name{group}).(Session_type{sess})(:,:,mouse) = (mapfz - minVal) / (maxVal - minVal); % normalized between 0 and 1
            OccupMapNormFz2.(Name{group}).(Session_type{sess})(:,:,mouse) = mapfz / totaltime; % normalized by proportion of time
            
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
                
                RespiFzCam.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) = Restrict(BreathingSpec.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}),FreezeEpochCam.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}));
                % we changed RespiSpec into BreathingSpec lines 113 and 114
                MeanRespiFz.(Name{group}).(Session_type{sess})(mouse) = nanmean(Data(RespiFz.(Name{group}).(Session_type{sess}).(Mouse_names{mouse})));
                SpectroBulbActive.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) = Restrict(OB_Sp_tsd2,ActiveEpoch.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}));
                MeanSpectroActive.(Name{group}).(Session_type{sess})(mouse,:) = nanmean(Data(SpectroBulbActive.(Name{group}).(Session_type{sess}).(Mouse_names{mouse})));
                
                [~,OBPowerTemp] = ConvertSpectrum_in_Frequencies_BM(Spectro{3} , Spectro{2}*1e4 , Spectro{1},'frequency_band',[2 6]);
                OBPower.(Name{group}).(Session_type{sess}).(Mouse_names{mouse})=OBPowerTemp;
                OBPowerFz.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) = Restrict(OBPower.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}),FreezeEpochAcc.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}));
                
            end
            try
                load('HeartBeatInfo.mat')
                HeartRate.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) = EKG.HBRate;
                HRFz.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) = Restrict(EKG.HBRate,FreezeEpochAcc.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}));
                MeanHRFz.(Name{group}).(Session_type{sess})(mouse) = nanmean(Data(HRFz.(Name{group}).(Session_type{sess}).(Mouse_names{mouse})));
                HRFzCam.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) = Restrict(EKG.HBRate,FreezeEpochCam.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}));
                MeanHRFzCam.(Name{group}).(Session_type{sess})(mouse) = nanmean(Data(HRFzCam.(Name{group}).(Session_type{sess}).(Mouse_names{mouse})));
                HeartRateVar.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) = tsd(Range(EKG.HBRate),movstd(Data(EKG.HBRate),5));
                HRVarFz.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) = Restrict(HeartRateVar.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}),FreezeEpochAcc.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}));
                MeanHRVarFz.(Name{group}).(Session_type{sess})(mouse) = nanmean(Data(HRVarFz.(Name{group}).(Session_type{sess}).(Mouse_names{mouse})));
                HRVarFzCam.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) = Restrict(HeartRateVar.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}),FreezeEpochCam.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}));
                MeanHRVarFzCam.(Name{group}).(Session_type{sess})(mouse) = nanmean(Data(HRVarFzCam.(Name{group}).(Session_type{sess}).(Mouse_names{mouse})));
            
            catch
                MeanHRFz.(Name{group}).(Session_type{sess})(mouse) = NaN;
                MeanHRFzCam.(Name{group}).(Session_type{sess})(mouse) = NaN;
                MeanHRVarFz.(Name{group}).(Session_type{sess})(mouse) = NaN;
                MeanHRVarFzCam.(Name{group}).(Session_type{sess})(mouse) = NaN;
                
            end
            try
                load('SWR.mat', 'RipplesEpoch','tRipples','RipDens_tsd')
                Ripts.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) = tRipples;
                NumbRip_Fz.(Name{group}).(Session_type{sess})(mouse) = length(tRipples);
                RipDensity_tsd.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) = RipDens_tsd;
                RipDensity_Fz.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) = Restrict(RipDensity_tsd.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}), FreezeEpochAcc.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}));
            end
            clear RipplesEpoch tRipples RipDens_tsd
        end
    end
end


disp('Making Distance to Center')
for group = 1:2
    if group == 2
        Mouse_names = Mouse_names_Nic;
    elseif group == 1
        Mouse_names = Mouse_names_Sal;
    elseif group == 3
        Mouse_names = Mouse_names_NicLow;
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
            
            
            clear AlignedXtsd_Epoch AlignedYtsd_Epoch AlignedXtsdActive_Epoch AlignedYtsdActive_Epoch ActEpoch
            a = 0;
            for i = 1:60
                try
                    SmallEpoch = intervalSet(a,a+30e4);
                    ActEpoch = SmallEpoch - FreezeEpochAcc.(Name{group}).(Session_type{sess}).(Mouse_names{mouse});
                    SmallFreezeEpoch = and(SmallEpoch,FreezeEpochAcc.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}));
                    AlignedXtsd_Epoch = Restrict(XtsdAligned.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}),SmallEpoch);
                    AlignedYtsd_Epoch = Restrict(YtsdAligned.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}),SmallEpoch);
                    AlignedXtsdActive_Epoch = Restrict(XtsdAligned.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}),ActEpoch);
                    AlignedYtsdActive_Epoch = Restrict(YtsdAligned.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}),ActEpoch);
                    AlignedXtsdFreezing_Epoch = Restrict(XtsdAligned.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}),SmallFreezeEpoch);
                    AlignedYtsdFreezing_Epoch = Restrict(YtsdAligned.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}),SmallFreezeEpoch);

                    
                    if length(AlignedXtsd_Epoch) > 1
                        DistanceToCenter2.(Name{group}).(Session_type{sess})(mouse,i) = nanmean(Data(Restrict(Distance,SmallEpoch)));
                    else
                        DistanceToCenter2.(Name{group}).(Session_type{sess})(mouse,i) = NaN;
                    end
                    
                    if length(AlignedXtsdActive_Epoch) > 1
                        DistanceToCenterActive.(Name{group}).(Session_type{sess})(mouse,i) = nanmean(Data(Restrict(Distance,ActEpoch)));
                    else
                        DistanceToCenterActive.(Name{group}).(Session_type{sess})(mouse,i) = NaN;
                    end
                    
                    if length(AlignedXtsdFreezing_Epoch) > 1
                        DistanceToCenterFz.(Name{group}).(Session_type{sess})(mouse,i) = nanmean(Data(Restrict(Distance,SmallFreezeEpoch)));
                    else
                        DistanceToCenterFz.(Name{group}).(Session_type{sess})(mouse,i) = NaN;
                    end
                catch
                    DistanceToCenterFz.(Name{group}).(Session_type{sess})(mouse,i) = NaN;
                    DistanceToCenterActive.(Name{group}).(Session_type{sess})(mouse,i) = NaN;
                    DistanceToCenter2.(Name{group}).(Session_type{sess})(mouse,i) = NaN;
                end
                a = a+30e4;
                
            end
        end
    end
end

Mouse_names = Mouse_names_Nic;
disp('Making spectro respi')
RangeLow = linspace(0.1526,20,261);
for mouse = 1:length(Mouse_names_Nic)
    j = 0;
    disp(Mouse_names_Nic{mouse})
    for i = 1:60
        Epoch = intervalSet(0+j, 30e4+j);
        clear mtemp
        try
            SpectroTemp{i,mouse} = Restrict(SpectroBulbFz.NicotineOF.Post.(Mouse_names{mouse}),Epoch);
            MeanSpectroTemp{i}(mouse,:) = nanmean(Data(SpectroTemp{i,mouse}));
            [~,mtemp]= max(MeanSpectroTemp{i}(mouse,18:end));
            mtemp = RangeLow(mtemp+17);
            m(mouse,i) = mtemp;
            if or(not(MeanSpectroTemp{i}(mouse,1) >1.6), mtemp <1.6)
                m(mouse,i) = NaN;
            end
        end
        try
            SpectroTempCam{i,mouse} = Restrict(SpectroBulbFzCam.NicotineOF.Post.(Mouse_names{mouse}),Epoch);
            MeanSpectroTempCam{i}(mouse,:) = nanmean(Data(SpectroTempCam{i,mouse}));
           [~,mtemp]= max(MeanSpectroTemp{i}(mouse,18:end));
            mtemp = RangeLow(mtemp+17);
            mcam(mouse,i) = mtempcam;
            if or(not(MeanSpectroTempCam{i}(mouse,1) >1.6), mtempcam <1.6)
                mcam(mouse,i) = NaN;
            end
        end

%         plot(RangeLow,MeanSpectroTemp{i}(mouse,:))
%         keyboard
        j = j+30e4;
    end
end




for group = 1:2
    if group == 2
        Mouse_names = Mouse_names_Nic;
    elseif group == 1
        Mouse_names = Mouse_names_Sal;
    elseif group == 3
        Mouse_names = Mouse_names_NicLow;
    end
    for sess=1:2
        for mouse=1:length(Mouse_names)
            disp(Mouse_names(mouse))
            a = 0;
            for i = 1:60
                Epoch = intervalSet(a,a+30e4);
                clear Fztemp riptemp riptemp riptemp2
                
                Fztemp = and(FreezeEpochAcc.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}),Epoch);
                Acttemp = and(ActiveEpoch.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}),Epoch);
                Fztimetemp.(Name{group}).(Session_type{sess})(mouse,i) = sum(DurationEpoch(Fztemp))/1e4;
                MeanDurFzTemp.(Name{group}).(Session_type{sess})(mouse,i) = nanmean(DurationEpoch(Fztemp))/1e4;
                FzEpNumbTemp.(Name{group}).(Session_type{sess})(mouse,i) = length(Start(Fztemp));
                
                FztempCam = and(FreezeEpochCam.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}),Epoch);
                FztimetempCam.(Name{group}).(Session_type{sess})(mouse,i) = sum(DurationEpoch(FztempCam))/1e4;
                
                
                Acctemp = Restrict(Accelero.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}),Fztemp);
                MeanAccFzTemp.(Name{group}).(Session_type{sess})(mouse,i) = nanmean(Data(Acctemp));
                
                gammatemp = Restrict(GammaPower.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}),Fztemp);
                GammaFzTemp.(Name{group}).(Session_type{sess})(mouse,i) = nanmean(Data(gammatemp));
                
                if Fztimetemp.(Name{group}).(Session_type{sess})(mouse,i) > 0
                    FzOnOff.(Name{group}).(Session_type{sess})(mouse,i) = 1;
                else
                    FzOnOff.(Name{group}).(Session_type{sess})(mouse,i) = 0;
                end
                
                try
                    riptemp = Restrict(Ripts.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}),Epoch);
                    NumberRipTemp.(Name{group}).(Session_type{sess})(mouse,i) = length(riptemp);
                catch
                    NumberRipTemp.(Name{group}).(Session_type{sess})(mouse,i) = NaN;
                end
                
                try
                    riptemp2 = Restrict(Ripts.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}),Fztemp);
                    RipDensTemp.(Name{group}).(Session_type{sess})(mouse,i) = length(riptemp2)/Fztimetemp.(Name{group}).(Session_type{sess})(mouse,i);
                catch
                    if Fztimetemp.(Name{group}).(Session_type{sess})(mouse,i)>0
                        RipDensTemp.(Name{group}).(Session_type{sess})(mouse,i) = 0;
                    else
                        RipDensTemp.(Name{group}).(Session_type{sess})(mouse,i) = NaN;
                        
                    end
                end
                try
                    riptempcam = Restrict(Ripts.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}),FztempCam);
                    RipDensTempCam.(Name{group}).(Session_type{sess})(mouse,i) = length(riptempcam)/FztimetempCam.(Name{group}).(Session_type{sess})(mouse,i);
                catch
                    if FztimetempCam.(Name{group}).(Session_type{sess})(mouse,i)>0
                        RipDensTempCam.(Name{group}).(Session_type{sess})(mouse,i) = 0;
                    else
                        RipDensTempCam.(Name{group}).(Session_type{sess})(mouse,i) = NaN;
                        
                    end
                end
                
                 try
                    hrtemp = Restrict(HRFz.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}),Epoch);
                    hrtempAct = Restrict(HRFz.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}),Acttemp);
                    HRFzTemp.(Name{group}).(Session_type{sess})(mouse,i) = nanmean(Data(hrtemp));
                    hrVartemp = Restrict(HRVarFz.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}),Epoch);
                    hrVarActtemp = Restrict(HRVarFz.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}),Acttemp);
                    HRVarFzTemp.(Name{group}).(Session_type{sess})(mouse,i) = nanmean(Data(hrVartemp));
                    HRActTemp.(Name{group}).(Session_type{sess})(mouse,i) = nanmean(Data(hrtempAct));
                    HRVarActTemp.(Name{group}).(Session_type{sess})(mouse,i) = nanmean(Data(hrVarActtemp));
                    
                    
                catch
                    HRFzTemp.(Name{group}).(Session_type{sess})(mouse,i) = NaN;
                    HRVarFzTemp.(Name{group}).(Session_type{sess})(mouse,i) = NaN;
                    HRActTemp.(Name{group}).(Session_type{sess})(mouse,i) = NaN;
                    HRVarActTemp.(Name{group}).(Session_type{sess})(mouse,i) = NaN;
                    
                 end
                
                 try
                    hrtempcam = Restrict(HRFzCam.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}),Epoch);
                    HRFzTempCam.(Name{group}).(Session_type{sess})(mouse,i) = nanmean(Data(hrtempcam));
                    hrVartempcam = Restrict(HRVarFzCam.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}),Epoch);
                    HRVarFzTempCam.(Name{group}).(Session_type{sess})(mouse,i) = nanmean(Data(hrVartempcam));
                    
                catch
                    HRFzTempCam.(Name{group}).(Session_type{sess})(mouse,i) = NaN;
                    HRVarFzTempCam.(Name{group}).(Session_type{sess})(mouse,i) = NaN;
                 end
                 
                 try
                     respitemp = Restrict(RespiFz.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}),Epoch);
                     RespiFzTemp.(Name{group}).(Session_type{sess})(mouse,i) = nanmean(Data(respitemp));
                     powertemp = Restrict(OBPowerFz.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}),Epoch);
                     PowerFzTemp.(Name{group}).(Session_type{sess})(mouse,i) = nanmean(Data(powertemp));
                 catch
                     RespiFzTemp.(Name{group}).(Session_type{sess})(mouse,i) = NaN;
                     PowerFzTemp.(Name{group}).(Session_type{sess})(mouse,i) = NaN;
                     
                 end
                 
                 try
                     SpeedTemp.(Name{group}).(Session_type{sess})(mouse,i) = nanmean(Data(Restrict(Speed.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}),Epoch)));
                 catch
                     SpeedTemp.(Name{group}).(Session_type{sess})(mouse,i) = NaN;
                 end
                 
                 try       
                     RespiTemp.(Name{group}).(Session_type{sess})(mouse,i) = nanmean(Data(Restrict(BreathingSpec.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}),Acttemp)));
                 catch
                     RespiTemp.(Name{group}).(Session_type{sess})(mouse,i) = NaN;
                 end
                 a = a+30e4;
            end
        end
    end
end


NumberRipTemp.NicotineOF.Post(7,:)=NaN;

NumberRipTemp.NicotineOF.Post(8,:)=NaN;

for mouse = 1:length(Mouse_names_Nic)
    a = 0;
    for i = 1:2
        clear y valid x x_valid y_valid tau pval
        y = m(mouse,1+a:15+a);
        valid = ~isnan(y);
        x = linspace(0, 7.5, length(y));
        
        valid = ~isnan(y);
       
        try
            [tau, pval] = corr(x(valid)', y(valid)', 'type', 'Kendall');
            Evol{i}(mouse) = tau;
            EvolPval{i}(mouse) = pval;
            fprintf('Kendall tau = %.3f, p = %.4f\n', tau, pval);
        catch
            Evol{i}(mouse) = NaN;
            EvolPval{i}(mouse) = NaN;
        end
        a = 15;
    end
end



%% Basic boxplots with Nicotine Low

figure('color',[1 1 1])

Cols={[0.7 0.7 0.7],[0.3 0.3 0.3],[0.7 0.7 0.7],[0.3 0.3 0.3],[1 0.6 1],[1 0 1]};
X=[1:6];
Legends={'Saline Pre','Saline Post','NicotineLow Pre','NicotineLow Post','Nicotine Pre','Nicotine Post'};

subplot(121)
MakeSpreadAndBoxPlot3_SB({FreezeTimeAcc.SalineOF.Pre/60 FreezeTimeAcc.SalineOF.Post/60 FreezeTimeAcc.NicotineLowOF.Pre/60 FreezeTimeAcc.NicotineLowOF.Post/60 FreezeTimeAcc.NicotineOF.Pre/60 FreezeTimeAcc.NicotineOF.Post/60},Cols,X,Legends,'showpoints',1,'paired',0);
ylabel('time freezing (minutes)');
makepretty_CH


subplot(122)
MakeSpreadAndBoxPlot3_SB({DistanceToCenter_mean.SalineOF.Pre DistanceToCenter_mean.SalineOF.Post DistanceToCenter_mean.NicotineLowOF.Pre DistanceToCenter_mean.NicotineLowOF.Post DistanceToCenter_mean.NicotineOF.Pre DistanceToCenter_mean.NicotineOF.Post},Cols,X,Legends,'showpoints',1,'paired',0)
ylabel('Thigmotaxis');
makepretty_CH
mtitle('OF');

%% Basic boxplots without Nicotine Low

figure('color',[1 1 1])

Cols={[0.7 0.7 0.7],[0.3 0.3 0.3],[1 0.6 1],[1 0 1]};
X=[1:4];
Legends={'Saline Pre','Saline Post','Nicotine Pre','Nicotine Post'};

subplot(121)
MakeSpreadAndBoxPlot3_SB({FreezeTimeAcc.SalineOF.Pre/60 FreezeTimeAcc.SalineOF.Post/60 FreezeTimeAcc.NicotineOF.Pre/60 FreezeTimeAcc.NicotineOF.Post/60},Cols,X,Legends,'showpoints',1,'paired',0);
ylabel('time freezing (minutes)');
makepretty_CH
subplot(122)

Cols={[0.7 0.7 0.7],[0.3 0.3 0.3],[1 0.6 1],[1 0 1],[0 0 0]};
X=[1:5];
Legends={'Saline Pre','Saline Post','Nicotine Pre','Nicotine Post','Stable'};
Basis = [DistanceToCenterBasis_mean.SalineOF.Pre DistanceToCenterBasis_mean.NicotineOF.Pre];


% MakeSpreadAndBoxPlot3_SB({DistanceToCenter_mean.SalineOF.Pre DistanceToCenter_mean.SalineOF.Post DistanceToCenter_mean.NicotineOF.Pre DistanceToCenter_mean.NicotineOF.Post Basis},Cols,X,Legends,'showpoints',1,'paired',0)
MakeSpreadAndBoxPlot3_SB({DistanceToCenterBeginning_mean.SalineOF.Pre DistanceToCenterBeginning_mean.SalineOF.Post DistanceToCenterBeginning_mean.NicotineOF.Pre DistanceToCenterBeginning_mean.NicotineOF.Post Basis},Cols,X,Legends,'showpoints',1,'paired',0)

ylabel('Thigmotaxis');
makepretty_CH
mtitle('OF');


%%
% Time evolution index :

Cols={[0.7 0.7 0.7],[0.3 0.3 0.3]};
X=[1:2];
Legends={'First7','Last7'};
figure('color',[1 1 1])
MakeSpreadAndBoxPlot3_SB({Evol{1} Evol{2}},Cols,X,Legends,'showpoints',1,'paired',1);
hline(0,'k--')
ylabel('Breathing evolution Index (Kendalls tau)');
makepretty_CH

%%

time = linspace(0,15,30);
x = time
y1 = RespiFzTemp.NicotineOF.Post(:,1:30);
y2 = DistanceToCenter2.NicotineOF.Post(:,1:30); 
y3 = NumberRipTemp.NicotineOF.Post(:,1:30);
% y3 = Fztimetemp.NicotineOF.Post(:,1:30);

label{1}={'Breathing frequency'};
label{2}={'Thigmotaxis'};
label{3}={'Number of ripples / minute'};
Cols = {[0 0.3 1],[1 0 0],[0 0.7 0]};
Cols = {[0 0.3 1],[1 0 0],[0 1 0]};



[ax, hlines] = multiploty_Shaded_CH({x, y1}, {x, y2}, {x, y3},'time',label,'color',Cols,'smooth',1);
mtitle('OF, freezing accelero')

%%

time = linspace(0,15,30);
x = time(:,1:30); 
y1 = m(:,1:30);
y3 = HRVarFzTemp.NicotineOF.Post(:,1:30); 
y2 = HRFzTemp.NicotineOF.Post(:,1:30);
% y3 = NumberRipTemp.NicotineOF.Post(:,1:30);

labelx={'time'};
labely = {'Breathing frequency', 'Heart Rate', 'Heart Rate Var'};
Cols = {[0 0.3 1],[1 0.4 0],[1 0.8 0]};

[ax, hlines] = multiploty_Shaded_CH({x, y1}, {x, y2}, {x, y3},labelx,labely,'color',Cols,'smooth',1);
mtitle('OF, freezing accelero')

%%

time = linspace(1,15,30);
x = time(:,1:30); 
y1 = m(:,1:30);
y3 = HRVarFzTemp.NicotineOF.Post(:,1:30); 
y2 = HRFzTemp.NicotineOF.Post(:,1:30);
% y3 = NumberRipTemp.NicotineOF.Post(:,1:30);

labelx={'time'};
labely = {'Breathing frequency', 'Heart Rate', 'Heart Rate Var'};
Cols = {[0 0 1],[1 0.4 0],[1 0.8 0]};

[ax, hlines] = multiploty_Shaded_CH({x, y1}, {x, y2}, {x, y3},labelx,labely,'color',Cols);
mtitle('OF, freezing accelero')

%%

time = linspace(1,15,30);
x = time(:,1:30); 
y1 = mcam(:,1:30);
y2 = DistanceToCenter2.NicotineOF.Post(:,1:30); 
y3 = RipDensTempCam.NicotineOF.Post(:,1:30);
% y3 = NumberRipTemp.NicotineOF.Post(:,1:30);

label{1}={'Breathing frequency'};
label{2}={'Thigmotaxis'};
label{3}={'Ripples density'};

[ax, hlines] = multiploty_Shaded_CH({x, y1}, {x, y2}, {x, y3},'time',label);
mtitle('OF, freezing camera')


figure
Bar = bar(time, mean(Fztimetemp.NicotineOF.Post(:,1:60)), 'FaceAlpha', 0.3, 'FaceColor', [0.5 0.5 0.5],'EdgeColor','none');
Bar = bar(time, sum(FzOnOff.NicotineOF.Post(:,1:60)), 'FaceAlpha', 0.3, 'FaceColor', [0.5 0.5 0.5],'EdgeColor','none');


%%

figure('color',[1 1 1])
a = 1;
for group = 1:2
    subplot(2,2,a)
    b = movmean(nanmean(OccupMapNormFz2.(Name{group}).Pre,3),1,1);
    imagesc(movmean(b,1,2))
    colorbar
    title('Pre')
    ylabel(Name{group})
    caxis([0 0.0002])
    makepretty_CH
    
    a = a+1;
    subplot(2,2,a)
    clear b
    b = movmean(nanmean(OccupMapNormFz2.(Name{group}).Post,3),1,1);
    imagesc(movmean(b,1,2))
    colorbar
    title('Post')
    caxis([0 0.0002])
    a = a+1;
    makepretty_CH
end




%%

Col1=[0.7 0.7 0.7];
Col2=[0.3 0.3 0.3];
Col3=[0 0 1];

figure('color',[1 1 1])
hold on
a = 1;
for group  = [1 2]
    subplot(1,2,a)
    
    a1 = Plot_MeanSpectrumForMice_BM(MeanSpectroActive.(Name{group}).Pre,'color',Col1);
    a1.mainLine.LineWidth = 2;
    a2 = Plot_MeanSpectrumForMice_BM(MeanSpectroActive.(Name{group}).Post,'color',Col2);
    makepretty_CH
    a2.mainLine.LineWidth = 2;
    xlim([1 12])
    ylim([0 1.1])
    title(Name{group})
    legend([a1.mainLine a2.mainLine],'Pre','Post');
    a = a+1;
end
a3 = Plot_MeanSpectrumForMice_BM(MeanSpectroFz.(Name{group}).Post,'color',Col3);
makepretty_CH
a3.mainLine.LineWidth = 2;
legend([a1.mainLine a2.mainLine a3.mainLine],'Pre','Post','Freezing');


%%

n_colors = 30;
start_color = [1, 0, 0];
end_color = [0, 0, 1];
Cols = [linspace(start_color(1), end_color(1), n_colors)', ...
    linspace(start_color(2), end_color(2), n_colors)', ...
    linspace(start_color(3), end_color(3), n_colors)'];
Cols_cell = mat2cell(Cols, ones(1, n_colors), 3);

RangeLow = linspace(0.1526,20,261);

figure, hold on
clear a
for i = 1:30
    a(i) = plot(RangeLow,nanmean(MeanSpectroTemp{1,i}));
    a(i).Color = Cols_cell{i,1};
    a(i).LineWidth = 2;
    [~,ind] = max(nanmean(MeanSpectroTemp{1,i}));
    clear x
    x = vline(RangeLow(ind),'--r');
    x.Color = Cols_cell{i,1};
    x.LineWidth = 1;
    xlim([1 10])
end
legend([a(1),a(15)],'1st min','30th min')
xlabel('Frequency (Hz)')
ylabel('Power')
title('Mean Spectro OB along time')
makepretty_CH

%%

figure, hold on, clear a
for i = 1:30
    a(i) = Plot_MeanSpectrumForMice_BM(MeanSpectroTemp{1,i},'color',Cols_cell{i,1});
    a(i).mainLine.LineWidth = 5; a(i).edge(1).Color = 'none'; a(i).edge(2).Color = 'none'; a(i).patch.FaceAlpha = 0.08;

    makepretty_CH
    xlim([0 8])
end
legend([a(1).mainLine,a(30).mainLine],'1st min','30th min')
title('OB freezing mean spectrums along time, Nicotine OF')
makepretty_CH

%%

Cols={[0.7 0.7 0.7],[0.7 0.7 0.7],[0.7 0.7 0.7],[0.7 0.7 0.7],[0.7 0.7 0.7],[0.7 0.7 0.7],[0.7 0.7 0.7],[0.7 0.7 0.7],[0.7 0.7 0.7],[0.7 0.7 0.7],[0.7 0.7 0.7],[0.7 0.7 0.7],[0.7 0.7 0.7],[0.7 0.7 0.7],[0.7 0.7 0.7],[0.7 0.7 0.7],[0.7 0.7 0.7],[0.7 0.7 0.7],[0.7 0.7 0.7]};
X=[1:19];
Legends={'510','1015','1520','2025','2530','3035','3540','4045','4550','5055','5560','6065','6570','7075','7580','8085','8590','9095','95100'};

figure
MakeSpreadAndBoxPlot3_SB({FreezeTime2.Nicotine.Post.FreezeEpoch510/1e4/60 FreezeTime2.Nicotine.Post.FreezeEpoch1015/1e4/60 FreezeTime2.Nicotine.Post.FreezeEpoch1520/1e4/60 FreezeTime2.Nicotine.Post.FreezeEpoch2025/1e4/60 FreezeTime2.Nicotine.Post.FreezeEpoch2530/1e4/60 FreezeTime2.Nicotine.Post.FreezeEpoch3035/1e4/60 FreezeTime2.Nicotine.Post.FreezeEpoch3540/1e4/60 FreezeTime2.Nicotine.Post.FreezeEpoch4045/1e4/60 FreezeTime2.Nicotine.Post.FreezeEpoch4550/1e4/60 FreezeTime2.Nicotine.Post.FreezeEpoch5055/1e4/60 FreezeTime2.Nicotine.Post.FreezeEpoch5560/1e4/60 FreezeTime2.Nicotine.Post.FreezeEpoch6065/1e4/60 FreezeTime2.Nicotine.Post.FreezeEpoch6570/1e4/60 FreezeTime2.Nicotine.Post.FreezeEpoch7075/1e4/60 FreezeTime2.Nicotine.Post.FreezeEpoch7580/1e4/60 FreezeTime2.Nicotine.Post.FreezeEpoch8085/1e4/60 FreezeTime2.Nicotine.Post.FreezeEpoch8590/1e4/60 FreezeTime2.Nicotine.Post.FreezeEpoch9095/1e4/60 FreezeTime2.Nicotine.Post.FreezeEpoch95100/1e4/60},Cols,X,Legends,'showpoints',1,'paired',1)
makepretty_CH
title('Freeze Time')

%%

Cols={[0.7 0.7 0.7],[0.7 0.7 0.7],[0.7 0.7 0.7],[0.7 0.7 0.7],[0.7 0.7 0.7],[0.7 0.7 0.7],[0.7 0.7 0.7],[0.7 0.7 0.7],[0.7 0.7 0.7],[0.7 0.7 0.7],[0.7 0.7 0.7],[0.7 0.7 0.7],[0.7 0.7 0.7],[0.7 0.7 0.7],[0.7 0.7 0.7],[0.7 0.7 0.7],[0.7 0.7 0.7],[0.7 0.7 0.7],[0.7 0.7 0.7]};
X=[1:19];
Legends={'510','1015','1520','2025','2530','3035','3540','4045','4550','5055','5560','6065','6570','7075','7580','8085','8590','9095','95100'};

figure
MakeSpreadAndBoxPlot3_SB({FreezePropInner.Nicotine.Post.FreezeEpoch510/1e4/60 FreezePropInner.Nicotine.Post.FreezeEpoch1015/1e4/60 FreezePropInner.Nicotine.Post.FreezeEpoch1520/1e4/60 FreezePropInner.Nicotine.Post.FreezeEpoch2025/1e4/60 FreezePropInner.Nicotine.Post.FreezeEpoch2530/1e4/60 FreezePropInner.Nicotine.Post.FreezeEpoch3035/1e4/60 FreezePropInner.Nicotine.Post.FreezeEpoch3540/1e4/60 FreezePropInner.Nicotine.Post.FreezeEpoch4045/1e4/60 FreezePropInner.Nicotine.Post.FreezeEpoch4550/1e4/60 FreezePropInner.Nicotine.Post.FreezeEpoch5055/1e4/60 FreezePropInner.Nicotine.Post.FreezeEpoch5560/1e4/60 FreezePropInner.Nicotine.Post.FreezeEpoch6065/1e4/60 FreezePropInner.Nicotine.Post.FreezeEpoch6570/1e4/60 FreezePropInner.Nicotine.Post.FreezeEpoch7075/1e4/60 FreezePropInner.Nicotine.Post.FreezeEpoch7580/1e4/60 FreezePropInner.Nicotine.Post.FreezeEpoch8085/1e4/60 FreezePropInner.Nicotine.Post.FreezeEpoch8590/1e4/60 FreezePropInner.Nicotine.Post.FreezeEpoch9095/1e4/60 FreezePropInner.Nicotine.Post.FreezeEpoch95100/1e4/60},Cols,X,Legends,'showpoints',1,'paired',1)
makepretty_CH
title('Freeze Prop (proportion of total freezing)')

%%

n_colors = 19;
start_color = [1, 0, 0]; % Rouge
end_color = [0, 0, 1]; % Bleu
Cols = [linspace(start_color(1), end_color(1), n_colors)', ...
    linspace(start_color(2), end_color(2), n_colors)', ...
    linspace(start_color(3), end_color(3), n_colors)'];
Cols_cell = mat2cell(Cols, ones(1, n_colors), 3);

X=[1:19];
Legends={'510','1015','1520','2025','2530','3035','3540','4045','4550','5055','5560','6065','6570','7075','7580','8085','8590','9095','95100'};

figure
MakeSpreadAndBoxPlot3_SB({MeanRespiFzSpe.Nicotine.Post.FreezeEpoch510 MeanRespiFzSpe.Nicotine.Post.FreezeEpoch1015 MeanRespiFzSpe.Nicotine.Post.FreezeEpoch1520 MeanRespiFzSpe.Nicotine.Post.FreezeEpoch2025 MeanRespiFzSpe.Nicotine.Post.FreezeEpoch2530 MeanRespiFzSpe.Nicotine.Post.FreezeEpoch3035 MeanRespiFzSpe.Nicotine.Post.FreezeEpoch3540 MeanRespiFzSpe.Nicotine.Post.FreezeEpoch4045 MeanRespiFzSpe.Nicotine.Post.FreezeEpoch4550 MeanRespiFzSpe.Nicotine.Post.FreezeEpoch5055 MeanRespiFzSpe.Nicotine.Post.FreezeEpoch5560 MeanRespiFzSpe.Nicotine.Post.FreezeEpoch6065 MeanRespiFzSpe.Nicotine.Post.FreezeEpoch6570 MeanRespiFzSpe.Nicotine.Post.FreezeEpoch7075 MeanRespiFzSpe.Nicotine.Post.FreezeEpoch7580 MeanRespiFzSpe.Nicotine.Post.FreezeEpoch8085 MeanRespiFzSpe.Nicotine.Post.FreezeEpoch8590 MeanRespiFzSpe.Nicotine.Post.FreezeEpoch9095 MeanRespiFzSpe.Nicotine.Post.FreezeEpoch95100},Cols_cell,X,Legends,'showpoints',1,'paired',1)
makepretty_CH
title('Mean Respi')


%%

Col1=[0.7 0.7 0.7];
Col2=[0.3 0.3 0.3];
time = [1:30];
figure('color', [1 1 1]), hold on

j = 1;
for group = 1:3
    
    subplot(3,4,j:j+2), hold on
    errorbar(time, nanmean(ThigmoTemp.(Name{group}).Pre),stdError(ThigmoTemp.(Name{group}).Pre),'color',Col1);
    errorbar(time, nanmean(ThigmoTemp.(Name{group}).Post),stdError(ThigmoTemp.(Name{group}).Post),'color',Col2);
    makepretty_CH
    ylim([0 1]);
    title(strcat(Name{group}, ' n = ', num2str(length(ThigmoTemp.(Name{group}).Post(:,1)))));
    
    p_values.(Name{group}) = zeros(1, 30);
    A = ThigmoTemp.(Name{group}).Pre;
    B = ThigmoTemp.(Name{group}).Post;
    
    for i = 1:30
        p_values.(Name{group})(i) = ranksum(A(:,i), B(:,i));
    end
    
    subplot(3,4,j+3)
    Cols={[0.7 0.7 0.7],[0.3 0.3 0.3]};
    X=[1:2];
    Legends={'OF Pre','OF Post'};
    MakeSpreadAndBoxPlot3_SB({Thigmo.(Name{group}).Pre Thigmo.(Name{group}).Post},Cols,X,Legends,'showpoints',1,'paired',0);
    makepretty_CH
    ylim([0 1.1]);
    j = j+4;
end


% sigstar_MC({[0.8 1.2]},adj_p(1),0,'LineWigth',16,'StarSize',24,'plotbar',0)


%%
Col1=[0.7 0.7 0.7];
Col2=[0.3 0.3 0.3];
Col3=[1 0.6 1];
Col4=[1 0 1];
time = linspace(1,30,60);
figure('color',[1 1 1])
subplot(1,4,1:3), hold on
Data_to_use = DistanceToCenter2.SalineOF.Pre;
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use, 1));
h1=shadedErrorBar(time,nanmean(Data_to_use),Conf_Inter,'g',1);
h1.mainLine.Color=Col1; h1.patch.FaceColor=Col1; h1.edge(1).Color=Col1; h1.edge(2).Color=Col1; h1.mainLine.LineWidth=2;

Data_to_use = DistanceToCenter2.SalineOF.Post;
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use, 1));
h2=shadedErrorBar(time,nanmean(Data_to_use),Conf_Inter,'g',1);
h2.mainLine.Color=Col2; h2.patch.FaceColor=Col2; h2.edge(1).Color=Col2; h2.edge(2).Color=Col2; h2.mainLine.LineWidth=2;

Data_to_use = DistanceToCenter2.NicotineOF.Pre;
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use, 1));
h3=shadedErrorBar(time,nanmean(Data_to_use),Conf_Inter,'g',1);
h3.mainLine.Color=Col3; h3.patch.FaceColor=Col3; h3.edge(1).Color=Col3; h3.edge(2).Color=Col3; h3.mainLine.LineWidth=2;

Data_to_use = DistanceToCenter2.NicotineOF.Post;
Conf_Inter=nanstd(Data_to_use)/sqrt(length(Data_to_use));
h4=shadedErrorBar(time,nanmean(Data_to_use),Conf_Inter,'g',1);
h4.mainLine.Color=Col4; h4.patch.FaceColor=Col4; h4.edge(1).Color=Col4; h4.edge(2).Color=Col4; h4.mainLine.LineWidth=2;

legend([h1.mainLine h2.mainLine h3.mainLine h4.mainLine],'Saline Pre','Saline Post','Nicotine Pre','Nicotine Post')

makepretty_CH
subplot(144)
 All = [DistanceToCenterBasis_mean.NicotineOF.Pre DistanceToCenterBasis_mean.SalineOF.Post DistanceToCenterBasis_mean.SalineOF.Pre];
Cols={[0.7 0.7 0.7],[0.3 0.3 0.3],[1 0.6 1],[1 0 1],[0 0 0]};
X=[1:5];
Legends={'Saline Pre','Saline Post','Nicotine Pre','Nicotine Post','Steady state'};
MakeSpreadAndBoxPlot3_SB({DistanceToCenter_mean.SalineOF.Pre DistanceToCenter_mean.SalineOF.Post DistanceToCenter_mean.NicotineOF.Pre DistanceToCenter_mean.NicotineOF.Post All},Cols,X,Legends,'showpoints',1,'paired',0)
makepretty_CH

mtitle('OF, Distance to the center (all)');

%%

GetNicotineSessions_CH

Mouse_names = {'M1500','M1531','M1532','M1686','M1687','M1685','M1713'};

for mouse=1:length(Mouse_names)
    path = sprintf('%s.%s{%d}', 'NicotineOF', 'Post', mouse);
    folder_path = eval(path);
    cd(folder_path);
    disp(folder_path);
    
    
    load('behavResources.mat')
    load('B_Low_Spectrum.mat')
    
    Epoch = intervalSet(0,12000000);
    
    Spectrum_Frequency=ConvertSpectrum_in_Frequencies_BM(Spectro{3} , Spectro{2}*1e4 , Spectro{1});
    Respi = tsd(Range(Spectrum_Frequency),runmean_BM(Data(Spectrum_Frequency),ceil(1/median(diff(Range(Spectrum_Frequency,'s'))))));
    Respi = Restrict(Respi, Epoch);
    FreezeAccEpochArray = [Start(FreezeAccEpoch), End(FreezeAccEpoch)];
    
    respiValues = Data(Respi);
    isFreeze = InIntervals(Range(Respi), FreezeAccEpochArray);
    respiValues(~isFreeze) = NaN;
    RespiNaN = tsd(Range(Respi), respiValues);
    
    [~,Distance,~,~] = Thigmotaxis_OF_CH(AlignedXtsd, AlignedYtsd,'figure',0,'percent_inner',0.7);
    DistanceToCenter = tsd(Range(AlignedXtsd),Distance);
    DistanceToCenter = Restrict(DistanceToCenter,Epoch);
    DistanceToCenterValues = Data(DistanceToCenter);
    isFreeze2 = InIntervals(Range(DistanceToCenter), FreezeAccEpochArray);
    DistanceToCenterValues(~isFreeze2) = NaN;
    DistanceToCenterNaNtemp = tsd(Range(DistanceToCenter),DistanceToCenterValues);
    DistanceToCenterNaN = Restrict(DistanceToCenterNaNtemp,RespiNaN);
    
    
    %         figure
    % %     subplot(2,3,mouse)
    %         scatter(Range(RespiNaN)/1e4/60,Data(RespiNaN),15,Data(DistanceToCenterNaN),'filled')
    % %     scatter(Data(DistanceToCenterNaN),Data(RespiNaN),15,Range(RespiNaN)/1e4/60,'filled')
    %
    %         xlim([0 20])
    % %     xlim([0.34 0.53])
    %
    %     ylim([0 6.5])
    %     if mouse == 1 | mouse == 4
    %         ylabel('breathing frequency');
    %     end
    %     if mouse == 4 | mouse == 5 | mouse == 6
    %         %             xlabel('time (minutes)');
    %         xlabel('distance to center')
    %     end
    %     %     caxis([0.35 0.53])
    %     c = colorbar;
    %     %     c.Label.String = 'DTC';
    %     c.Label.String = 'Time';
    %     title(Mouse_names{mouse})
    %
    %     makepretty_CH
    %     colormap autumn
    
    inputData=[Range(RespiNaN)/1e4/60,Data(DistanceToCenterNaN)];
%     inputData=[Range(RespiNaN)/1e4/60,Data(DistanceToCenterNaN).*Range(RespiNaN)/1e4/60];
    %inputData=[Data(DistanceToCenterNaN),Data(DistanceToCenterNaN).*Range(RespiNaN)/1e4/60];
    %inputData=[Data(DistanceToCenterNaN),Data(DistanceToCenterNaN).*Range(RespiNaN)/1e4/60];
    %inputData=[Data(DistanceToCenterNaN),Range(RespiNaN)/1e4/60,Data(DistanceToCenterNaN).*Range(RespiNaN)/1e4/60];
    outputData=Data(RespiNaN);
    
    inputData=inputData(1:2000,:);
    outputData=outputData(1:2000,:);
    
    glmModels = fitglm(inputData, outputData,'Distribution', 'normal', 'Link', 'reciprocal');
    predictions = predict(glmModels, inputData);
    
    figure,
    subplot(121);
    plot(outputData,'k.'), hold on, plot(predictions,'r*'),
    glm_results.Coefficients_pvalue(:,mouse) = glmModels.Coefficients{:,'pValue'};
    glm_results.Coefficients_estimate(:,mouse) = glmModels.Coefficients{:,'Estimate'};
    makepretty_CH
    subplot(122)
    [r,p] = PlotCorrelations_BM(Range(RespiNaN)/1e4/60,Data(DistanceToCenterNaN));
%     PlotCorrelations_BM(Data(DistanceToCenterNaN),Data(RespiNaN));
    R(mouse) = r;
    P(mouse) = p;
    makepretty_CH
    mtitle(Mouse_names{mouse});
    
    
    
end

Threshold = [2.5 3 3.5 4 4.5 5];

figure('Color',[1 1 1])
for group = 2
    if group == 2
        Mouse_names = Mouse_names_Nic;
    elseif group == 1
        Mouse_names = Mouse_names_Sal;
    elseif group == 3
        Mouse_names = Mouse_names_NicLow;
    end
    for sess=2
        for thresh = 1:length(Threshold)
            for mouse=1:length(Mouse_names)
                NewRespiFz = tsd(Range(RespiFz.(Name{group}).(Session_type{sess}).(Mouse_names{mouse})),runmean_BM(Data(RespiFz.(Name{group}).(Session_type{sess}).(Mouse_names{mouse})),5));
                NewEpoch = intervalSet(0,900e4);
                NewRespiFz = Restrict(NewRespiFz,NewEpoch);
                OverBreathing.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) = thresholdIntervals(NewRespiFz,Threshold(thresh),'Direction','Above');
                OverBreathing.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) = mergeCloseIntervals(OverBreathing.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}),0.3*1e4);
                TimeOver.(Name{group}).(Session_type{sess})(mouse) = sum(DurationEpoch(OverBreathing.(Name{group}).(Session_type{sess}).(Mouse_names{mouse})))/1e4;
                UnderBreathing.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) = FreezeEpochAcc.(Name{group}).(Session_type{sess}).(Mouse_names{mouse})-OverBreathing.(Name{group}).(Session_type{sess}).(Mouse_names{mouse});
                TimeUnder.(Name{group}).(Session_type{sess})(mouse) = sum(DurationEpoch(UnderBreathing.(Name{group}).(Session_type{sess}).(Mouse_names{mouse})))/1e4;
                Ratio.(Name{group}).(Session_type{sess})(mouse) = TimeUnder.(Name{group}).(Session_type{sess})(mouse)/TimeOver.(Name{group}).(Session_type{sess})(mouse);
            end
            subplot(2,3,thresh)
            %             PlotCorrelations_BM(Thigmo.(Name{group}).(Session_type{sess}),TimeOver.(Name{group}).(Session_type{sess}),'colortouse','r');
%                                     PlotCorrelations_BM(DistanceToCenter_mean.(Name{group}).(Session_type{sess}),Ratio.(Name{group}).(Session_type{sess}),'colortouse','k');
%             PlotCorrelations_BM(DistanceToCenterTempActive_mean.(Name{group}).(Session_type{sess}),TimeUnder.(Name{group}).(Session_type{sess}),'colortouse','k');
%             PlotCorrelations_BM(TimeOver.(Name{group}).(Session_type{sess})(1:6)/60,TimeUnder.(Name{group}).(Session_type{sess})(1:6)/60,'colortouse','k');
            
            %                         PlotCorrelations_BM(FreezeTimeAcc.(Name{group}).(Session_type{sess})/1e4,TimeOver.(Name{group}).(Session_type{sess}),'colortouse','k');
                        PlotCorrelations_BM(DistanceToCenter_mean.(Name{group}).(Session_type{sess}),Ratio.(Name{group}).(Session_type{sess}),'colortouse','k');
            makepretty
            xlabel(['Time Over ',num2str(Threshold(thresh)),' (minutes)'])
            ylabel(['Time Under ',num2str(Threshold(thresh)),' (minutes)'])

            
            %             ylabel(['Ratio Under/Over ',num2str(Threshold(thresh))])
            
            title(num2str(Threshold(thresh)))
        end
    end
end


Saline_Pre = DistanceToCenter2.SalineOF.Pre;      % 7x60
Saline_Post = DistanceToCenter2.SalineOF.Post;    % 7x60
Nicotine_Pre = DistanceToCenter2.NicotineOF.Pre;  % 7x60
Nicotine_Post = DistanceToCenter2.NicotineOF.Post;% 7x60

% Nombre de points de temps
n_timepoints = size(Saline_Pre, 2);

% Initialisation des p-values (6 comparaisons x 60 points de temps)
p_values = zeros(6, n_timepoints);

% Boucle sur chaque point de temps
for t = 1:n_timepoints
    % Comparaison des distributions (7 souris) à chaque instant t
    p_values(1, t) = ranksum(Saline_Pre(:, t), Saline_Post(:, t));   % Saline Pre vs Saline Post
    p_values(2, t) = ranksum(Saline_Pre(:, t), Nicotine_Pre(:, t));  % Saline Pre vs Nicotine Pre
    p_values(3, t) = ranksum(Saline_Pre(:, t), Nicotine_Post(:, t)); % Saline Pre vs Nicotine Post
    p_values(4, t) = ranksum(Saline_Post(:, t), Nicotine_Pre(:, t)); % Saline Post vs Nicotine Pre
    p_values(5, t) = ranksum(Saline_Post(:, t), Nicotine_Post(:, t));% Saline Post vs Nicotine Post
    p_values(6, t) = ranksum(Nicotine_Pre(:, t), Nicotine_Post(:, t)); % Nicotine Pre vs Nicotine Post
end

% Affichage des p-values
disp('P-values pour chaque point de temps :');
disp(p_values);


%%
 
% 
% Per = [0.05 0.1 0.15 0.2 0.25 0.3 0.35 0.4 0.45 0.5 0.55 0.6 0.65 0.7 0.75 0.8 0.85 0.9 0.95 1];
% Num = [5 10 15 20 25 30 35 40 45 50 55 60 65 70 75 80 85 90 95 100];
% Num1 = [05 510 1015 1520 2025 2530 3035 3540 4045 4550 5055 5560 6065 6570 7075 7580 8085 8590 9095 95100];
% 
% 
% for group = 1:3
%     if group == 2
%         Mouse_names = Mouse_names_Nic;
%     elseif group == 1
%         Mouse_names = Mouse_names_Sal;
%     elseif group == 3
%         Mouse_names = Mouse_names_NicLow;
%     end
%     for sess=1:2
%         for mouse=1:length(Mouse_names)
%             path = sprintf('%s.%s{%d}', Name{group}, Session_type{sess}, mouse);
%             folder_path = eval(path);
%             cd(folder_path);
%             disp(folder_path);
%             NumA = 0;
%             
%             clear AlignedXtsd AlignedYtsd Spectro
%             load('behavResources.mat')
%             TotalEpoch.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) = intervalSet(0, max(Range(MovAcctsd)));
%             FreezeEpochAcc.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) = FreezeAccEpoch;
%             FreezeTimeAcc.(Name{group}).(Session_type{sess})(mouse) = sum(DurationEpoch(FreezeEpochAcc.(Name{group}).(Session_type{sess}).(Mouse_names{mouse})));
%             FreezeProp.(Name{group}).(Session_type{sess})(mouse) = FreezeTimeAcc.(Name{group}).(Session_type{sess})(mouse) ./ sum(DurationEpoch(TotalEpoch.(Name{group}).(Session_type{sess}).(Mouse_names{mouse})));
%             
%             try
%                 load('B_Low_Spectrum.mat')
%             end
%             
%             for i = 1:length(Num)
%                 [~,~, ZoneEpoch_Inner, ZoneEpoch_Outer, ZoneEpoch_Specific] = Thigmotaxis_OF_CH(AlignedXtsd, AlignedYtsd, 'percent_inner', Per(i),'ring', [NumA NumA+0.05]);
%                 
%                 fieldname = strcat('FreezeEpoch', num2str(Num(i)));
%                 fieldname2 = strcat('FreezeEpoch', num2str(Num1(i)));
%                 ZoneEpochInner.(Name{group}).(Session_type{sess}).(fieldname).(Mouse_names{mouse}) = ZoneEpoch_Inner;
%                 ZoneEpochOuter.(Name{group}).(Session_type{sess}).(fieldname).(Mouse_names{mouse}) = ZoneEpoch_Outer;
%                 ZoneEpochSpe.(Name{group}).(Session_type{sess}).(fieldname2).(Mouse_names{mouse}) = ZoneEpoch_Specific;
%                 
%                 FreezeEpochsInner.(Name{group}).(Session_type{sess}).(fieldname).(Mouse_names{mouse}) = and(FreezeEpochAcc.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}), ZoneEpoch_Inner);
%                 FreezeEpochsSpe.(Name{group}).(Session_type{sess}).(fieldname2).(Mouse_names{mouse}) = and(FreezeEpochAcc.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}), ZoneEpoch_Specific);
%                 FreezeEpochsOuter.(Name{group}).(Session_type{sess}).(fieldname).(Mouse_names{mouse}) = FreezeEpochAcc.(Name{group}).(Session_type{sess}).(Mouse_names{mouse})- FreezeEpochsInner.(Name{group}).(Session_type{sess}).(fieldname).(Mouse_names{mouse});
%                 
%                 FreezeTimeAcc.(Name{group}).(Session_type{sess})(mouse) = sum(DurationEpoch(FreezeEpochsInner.(Name{group}).(Session_type{sess}).(fieldname).(Mouse_names{mouse})));
%                 
%                 NumA = NumA+0.05;
%                 
%             end
%             
%             try
%                 OB_Sp_tsd.(Name{group}).(Session_type{sess}){mouse} = tsd(Spectro{2}*1e4 , Spectro{1});
%                 SpectroBulbFz.(Name{group}).(Session_type{sess}){mouse} = Restrict(OB_Sp_tsd.(Name{group}).(Session_type{sess}){mouse},FreezeEpochAcc.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}));
%                 MeanSpectroFz.(Name{group}).(Session_type{sess})(mouse,:) = nanmean(Data(SpectroBulbFz.(Name{group}).(Session_type{sess}){mouse}));
%             end
%             
%             for i = 1:length(Num)
%                 fieldname1 = strcat('FreezeEpoch', num2str(Num(i)));
%                 
%                 XtsdAlignedInner.(Name{group}).(Session_type{sess}).(fieldname1).(Mouse_names{mouse}) = Restrict(XtsdAligned.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}),ZoneEpochInner.(Name{group}).(Session_type{sess}).(fieldname1).(Mouse_names{mouse}));
%                 YtsdAlignedInner.(Name{group}).(Session_type{sess}).(fieldname1).(Mouse_names{mouse}) = Restrict(YtsdAligned.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}),ZoneEpochInner.(Name{group}).(Session_type{sess}).(fieldname1).(Mouse_names{mouse}));
%                 XtsdAlignedOuter.(Name{group}).(Session_type{sess}).(fieldname1).(Mouse_names{mouse}) = Restrict(XtsdAligned.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}),ZoneEpochOuter.(Name{group}).(Session_type{sess}).(fieldname1).(Mouse_names{mouse}));
%                 YtsdAlignedOuter.(Name{group}).(Session_type{sess}).(fieldname1).(Mouse_names{mouse}) = Restrict(YtsdAligned.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}),ZoneEpochOuter.(Name{group}).(Session_type{sess}).(fieldname1).(Mouse_names{mouse}));
%                 
%                 try
%                     FreezeTimeInner.(Name{group}).(Session_type{sess}).(fieldname1)(mouse) = sum(DurationEpoch(FreezeEpochsInner.(Name{group}).(Session_type{sess}).(fieldname1).(Mouse_names{mouse})));
%                     FreezePropInner.(Name{group}).(Session_type{sess}).(fieldname1)(mouse) = FreezeTimeInner.(Name{group}).(Session_type{sess}).(fieldname1)(mouse)./FreezeTimeAcc.(Name{group}).(Session_type{sess})(mouse);
%                  
%                     SpectroBulbInner.(Name{group}).(Session_type{sess}).(fieldname1).(Mouse_names{mouse}) = Restrict(OB_Sp_tsd.(Name{group}).(Session_type{sess}){mouse},FreezeEpochsInner.(Name{group}).(Session_type{sess}).(fieldname1).(Mouse_names{mouse}));
%                     MeanSpectroBulbInner.(Name{group}).(Session_type{sess}).(fieldname1)(mouse,:) = nanmean(Data(SpectroBulbInner.(Name{group}).(Session_type{sess}).(fieldname1).(Mouse_names{mouse})));
%                     MeanSpectroBulbInner_Corrected.(Name{group}).(Session_type{sess}).(fieldname1)(mouse,:) = nanmean(Data(SpectroBulbInner.(Name{group}).(Session_type{sess}).(fieldname1).(Mouse_names{mouse}))).*RangeLow;
%                     
%                     SpectroBulbOuter.(Name{group}).(Session_type{sess}).(fieldname1).(Mouse_names{mouse}) = Restrict(OB_Sp_tsd.(Name{group}).(Session_type{sess}){mouse},FreezeEpochsOuter.(Name{group}).(Session_type{sess}).(fieldname1).(Mouse_names{mouse}));
%                     MeanSpectroBulbOuter.(Name{group}).(Session_type{sess}).(fieldname1)(mouse,:) = nanmean(Data(SpectroBulbOuter.(Name{group}).(Session_type{sess}).(fieldname1).(Mouse_names{mouse})));
%                     MeanSpectroBulbOuter_Corrected.(Name{group}).(Session_type{sess}).(fieldname1)(mouse,:) = nanmean(Data(SpectroBulbOuter.(Name{group}).(Session_type{sess}).(fieldname1).(Mouse_names{mouse}))).*RangeLow;
%                     
%                     XtsdAlignedFzInner.(Name{group}).(Session_type{sess}).(fieldname1).(Mouse_names{mouse}) = Restrict(XtsdAligned.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}),FreezeEpochsInner.(Name{group}).(Session_type{sess}).(fieldname1).(Mouse_names{mouse}));
%                     YtsdAlignedFzInner.(Name{group}).(Session_type{sess}).(fieldname1).(Mouse_names{mouse}) = Restrict(YtsdAligned.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}),FreezeEpochsInner.(Name{group}).(Session_type{sess}).(fieldname1).(Mouse_names{mouse}));
%                     XtsdAlignedFzOuter.(Name{group}).(Session_type{sess}).(fieldname1).(Mouse_names{mouse}) = Restrict(XtsdAligned.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}),FreezeEpochsOuter.(Name{group}).(Session_type{sess}).(fieldname1).(Mouse_names{mouse}));
%                     YtsdAlignedFzOuter.(Name{group}).(Session_type{sess}).(fieldname1).(Mouse_names{mouse}) = Restrict(YtsdAligned.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}),FreezeEpochsOuter.(Name{group}).(Session_type{sess}).(fieldname1).(Mouse_names{mouse}));
%                     RespiFzInner.(Name{group}).(Session_type{sess}).(fieldname1).(Mouse_names{mouse}) = Restrict(Respi.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}),FreezeEpochsInner.(Name{group}).(Session_type{sess}).(fieldname1).(Mouse_names{mouse}));
%                     RespiFzOuter.(Name{group}).(Session_type{sess}).(fieldname1).(Mouse_names{mouse}) = Restrict(Respi.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}),FreezeEpochsOuter.(Name{group}).(Session_type{sess}).(fieldname1).(Mouse_names{mouse}));
%                     MeanRespiFzInner.(Name{group}).(Session_type{sess}).(fieldname1)(mouse) = nanmean(Data(RespiFzInner.(Name{group}).(Session_type{sess}).(fieldname1).(Mouse_names{mouse})));
%                     MeanRespiFzOuter.(Name{group}).(Session_type{sess}).(fieldname1)(mouse) = nanmean(Data(RespiFzOuter.(Name{group}).(Session_type{sess}).(fieldname1).(Mouse_names{mouse})));
%                     
%                 end
%             end
%             
%             for i = 1:length(Num1)
%                 try
%                     fieldname2 = strcat('FreezeEpoch', num2str(Num1(i)));
%                     FreezeTimeSpe.(Name{group}).(Session_type{sess}).(fieldname2)(mouse) = sum(DurationEpoch(FreezeEpochsSpe.(Name{group}).(Session_type{sess}).(fieldname2).(Mouse_names{mouse})));
%                     FreezePropSpe.(Name{group}).(Session_type{sess}).(fieldname2)(mouse) = FreezeTimeSpe.(Name{group}).(Session_type{sess}).(fieldname2)(mouse)./FreezeTimeAcc.(Name{group}).(Session_type{sess})(mouse);
%                     SpectroBulbSpe.(Name{group}).(Session_type{sess}).(fieldname2).(Mouse_names{mouse}) = Restrict(OB_Sp_tsd.(Name{group}).(Session_type{sess}){mouse},FreezeEpochsSpe.(Name{group}).(Session_type{sess}).(fieldname2).(Mouse_names{mouse}));
%                     MeanSpectroBulbSpe.(Name{group}).(Session_type{sess}).(fieldname2)(mouse,:) = nanmean(Data(SpectroBulbSpe.(Name{group}).(Session_type{sess}).(fieldname2).(Mouse_names{mouse})));
%                     RespiFzSpe.(Name{group}).(Session_type{sess}).(fieldname2).(Mouse_names{mouse}) = Restrict(Respi.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}),FreezeEpochsSpe.(Name{group}).(Session_type{sess}).(fieldname2).(Mouse_names{mouse}));
%                     MeanRespiFzSpe.(Name{group}).(Session_type{sess}).(fieldname2)(mouse) = nanmean(Data(RespiFzSpe.(Name{group}).(Session_type{sess}).(fieldname2).(Mouse_names{mouse})));
%                     
%                 end
%             end
%         end
%     end
% end


%%
% 
% RangeLow = linspace(0.1526,20,261);
% 
% diameter = 1;
% radius = diameter / 2;
% center = [0.5, 0.5];
% theta = linspace(0, 2*pi, 100);
% outer_circle_x = center(1) + radius * cos(theta);
% outer_circle_y = center(2) + radius * sin(theta);
% 
% Col1 = [1 0 0];
% Col2 = [0 0 1];
% Mouse_names = Mouse_names_Nic;
% 
% Index = [17 18 19];
% for i = Index
%     figure('color',[1 1 1]), hold on
%     fieldname = strcat('FreezeEpoch', num2str(Num(i)));
%     for mouse = 1:length(Mouse_names)
%         subplot(222), hold on
%         plot(RangeLow,MeanSpectroBulbInner.NicotineOF.Post.(fieldname)(mouse,:),'r');
%         plot(RangeLow,MeanSpectroBulbOuter.NicotineOF.Post.(fieldname)(mouse,:),'b');
%         a = plot(RangeLow,nanmean(MeanSpectroBulbInner.NicotineOF.Post.(fieldname)),'r');
%         [~,y] = max(nanmean(MeanSpectroBulbInner.NicotineOF.Post.(fieldname)));
%         ybis = RangeLow(y);
%         vline(ybis,'--r')
%         a.LineWidth = 2;
%         a = plot(RangeLow,nanmean(MeanSpectroBulbOuter.NicotineOF.Post.(fieldname)),'b');
%         [~,y] = max(nanmean(MeanSpectroBulbOuter.NicotineOF.Post.(fieldname)));
%         ybis = RangeLow(y);
%         vline(ybis,'--b')
%         a.LineWidth = 2;
%         xlim([0 10]);
%         makepretty_CH
%         
%     end
%     
%     subplot(224), hold on
%     a1 = Plot_MeanSpectrumForMice_BM(MeanSpectroBulbInner.NicotineOF.Post.(fieldname),'color',Col1);
%     a1.mainLine.LineWidth = 2;
%     a2 = Plot_MeanSpectrumForMice_BM(MeanSpectroBulbOuter.NicotineOF.Post.(fieldname),'color',Col2);
%     a2.mainLine.LineWidth = 2;
%     xlim([0 10]);
%     makepretty_CH
%     legend([a1.mainLine a2.mainLine],'Int','Ext')
%     
%     subplot(221), hold on
%     for mouse = 1:length(Mouse_names)
%         plot(Data(XtsdAlignedFzInner.NicotineOF.Post.(fieldname).(Mouse_names{mouse})),Data(YtsdAlignedFzInner.NicotineOF.Post.(fieldname).(Mouse_names{mouse})),'.r');
%         plot(Data(XtsdAlignedFzOuter.NicotineOF.Post.(fieldname).(Mouse_names{mouse})),Data(YtsdAlignedFzOuter.NicotineOF.Post.(fieldname).(Mouse_names{mouse})),'.b');
%         plot(outer_circle_x,outer_circle_y,'k-', 'LineWidth', 2)
%     end
%     makepretty_CH
%     
%     subplot(245), hold on
%     Cols={[0 0 1],[1 0 0]};
%     X=[1:2];
%     Legends={'Ext','Int'};
%     
%     MakeSpreadAndBoxPlot3_SB({1-FreezePropInner.NicotineOF.Post.(fieldname) FreezePropInner.NicotineOF.Post.(fieldname)},Cols,X,Legends,'showpoints',1,'paired',1);
%     ylabel('Freeze Prop');
%     makepretty_CH
%     
%     
%     subplot(246), hold on
%     Cols={[0 0 1],[1 0 0]};
%     X=[1:2];
%     Legends={'Ext','Int'};
%     
%     MakeSpreadAndBoxPlot3_SB({MeanRespiFzOuter.NicotineOF.Post.(fieldname) MeanRespiFzInner.NicotineOF.Post.(fieldname)},Cols,X,Legends,'showpoints',1,'paired',1,'optiontest','ttest');
%     ylabel('Respi freezing');
%     makepretty_CH
%     
%     mtitle(num2str(Num(i)));
% end
% 
% %%


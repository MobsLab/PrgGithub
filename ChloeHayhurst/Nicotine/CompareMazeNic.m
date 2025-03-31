clear all
close all
cd('/media/nas8-2/ProjetEmbReact/transfer')
load('AllSessions.mat');
Session_type={'Cond','Habituation'};

RangeLow = linspace(0.1526,20,261);
RangeHigh = linspace(22,98,32);
RangeVHigh = linspace(22,249,94);
RangeLow2 = linspace(1.0681,20,249);

Name = {'Clean','WithSham'};

% UMaze
for group = 1:2
    if group == 1
        Mouse=[1500,1686,1687,1685,1385,1393];
    elseif group == 2
        Mouse=[1500,1686,1687,1685,1385,1393,41531,1412,1415,1416];
    end
    
    disp (Name{group})
    for sess=1:length(Session_type)
        Sessions_List_ForLoop_BM
        disp(Session_type{sess})
        for mouse=1:length(Mouse)
            Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
            disp(Mouse_names{mouse})
            % variables
            Speed.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}) , 'speed');
            SpectroBulb.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}) , 'spectrum','prefix','B_Low');
            HeartRate.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}) , 'heartrate');
            HeartRateVar.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}) , 'heartratevar');
            Ripples.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}) , 'ripples');
            Respi.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}) , 'respi_freq_bm');
            
            % epochs
            TotEpoch.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) = intervalSet(0,max(Range(Speed.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}))));
            FreezingEpoch.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}) , 'epoch' , 'epochname' , 'freezeepoch');
            ZoneEpoch.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}) , 'epoch' , 'epochname' , 'zoneepoch');
            BlockedEpoch.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}) , 'epoch' , 'epochname' , 'blockedepoch');
            UnblockedEpoch.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) = TotEpoch.(Name{group}).(Session_type{sess}).(Mouse_names{mouse})-BlockedEpoch.(Name{group}).(Session_type{sess}).(Mouse_names{mouse});
            ShockZoneEpoch.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) = ZoneEpoch.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}){1};
            SafeZoneEpoch.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) = ZoneEpoch.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}){2};
            ShockCornerEpoch.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) = ZoneEpoch.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}){4};
            SafeCornerEpoch.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) = ZoneEpoch.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}){5};
            MiddleZoneEpoch.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) = ZoneEpoch.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}){3};
            SafeZoneEpoch_freezing.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) = or(ZoneEpoch.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}){2} , ZoneEpoch.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}){5});
            FreezeShockEpoch.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) = and(FreezingEpoch.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) , ShockZoneEpoch.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}));
            FreezeSafeEpoch.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) = and(FreezingEpoch.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) , SafeZoneEpoch_freezing.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}));
            FreezeSafe2Epoch.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) = and(FreezingEpoch.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) , SafeZoneEpoch.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}));
            FreezeMiddleEpoch.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) = and(FreezingEpoch.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) , MiddleZoneEpoch.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}));
            FreezeSafeCornerEpoch.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) = and(FreezingEpoch.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) , SafeCornerEpoch.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}));
            FreezeShockCornerEpoch.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) = and(FreezingEpoch.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) , ShockCornerEpoch.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}));
            
            OBtsdFzShock = Restrict(SpectroBulb.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}),FreezeShockEpoch.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}));
            OBtsdFzSafe = Restrict(SpectroBulb.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}),FreezeSafeEpoch.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}));
            MeanSpectroBulb.(Name{group}).(Session_type{sess})(mouse,:)=nanmean(Data(SpectroBulb.(Name{group}).(Session_type{sess}).(Mouse_names{mouse})));
            MeanSpectroBulbFzShock.(Name{group}).(Session_type{sess})(mouse,:)=nanmean(Data(OBtsdFzShock));
            MeanSpectroBulbFzSafe.(Name{group}).(Session_type{sess})(mouse,:)=nanmean(Data(OBtsdFzSafe));
            
            Respi_Fz_Shock.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) = Restrict(Respi.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}),FreezeShockEpoch.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}));
            Respi_Fz_Safe.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) = Restrict(Respi.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}),FreezeSafeEpoch.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}));
            
            Respi_Fz_Shock_mean.(Name{group}).(Session_type{sess})(mouse) = nanmean(Data(Respi_Fz_Shock.(Name{group}).(Session_type{sess}).(Mouse_names{mouse})));
            Respi_Fz_Safe_mean.(Name{group}).(Session_type{sess})(mouse) = nanmean(Data(Respi_Fz_Safe.(Name{group}).(Session_type{sess}).(Mouse_names{mouse})));
            
            HR_Fz_Shock.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) = Restrict(HeartRate.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}),FreezeShockEpoch.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}));
            HR_Fz_Safe.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) = Restrict(HeartRate.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}),FreezeSafeEpoch.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}));
            
            HR_Fz_Shock_mean.(Name{group}).(Session_type{sess})(mouse) = nanmean(Data(HR_Fz_Shock.(Name{group}).(Session_type{sess}).(Mouse_names{mouse})));
            HR_Fz_Safe_mean.(Name{group}).(Session_type{sess})(mouse) = nanmean(Data(HR_Fz_Safe.(Name{group}).(Session_type{sess}).(Mouse_names{mouse})));
            
            HRVar_Fz_Shock.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) = Restrict(HeartRateVar.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}),FreezeShockEpoch.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}));
            HRVar_Fz_Safe.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) = Restrict(HeartRateVar.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}),FreezeSafeEpoch.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}));
            
            HRVar_Fz_Shock_mean.(Name{group}).(Session_type{sess})(mouse) = nanmean(Data(HRVar_Fz_Shock.(Name{group}).(Session_type{sess}).(Mouse_names{mouse})));
            HRVar_Fz_Safe_mean.(Name{group}).(Session_type{sess})(mouse) = nanmean(Data(HRVar_Fz_Safe.(Name{group}).(Session_type{sess}).(Mouse_names{mouse})));
            
            if length(Ripples.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}))>2;
                Ripples_Fz_Shock.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) = Restrict(Ripples.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}),FreezeShockEpoch.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}));
                Ripples_Fz_Safe.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) = Restrict(Ripples.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}),FreezeSafeEpoch.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}));
                
                Ripples_Fz_Shock_density.(Name{group}).(Session_type{sess})(mouse) = length(Ripples_Fz_Shock.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}))/sum(DurationEpoch(FreezeShockEpoch.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}))/1e4);
                Ripples_Fz_Safe_density.(Name{group}).(Session_type{sess})(mouse) = length(Ripples_Fz_Safe.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}))/sum(DurationEpoch(FreezeSafeEpoch.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}))/1e4);
            else
                Ripples_Fz_Shock_density.(Name{group}).(Session_type{sess})(mouse) = NaN;
                Ripples_Fz_Safe_density.(Name{group}).(Session_type{sess})(mouse) = NaN;
            end
        end
    end
end



GetNicotineSessions_CH
Name = {'SalineOF','NicotineOF','NicotineLowOF','SalineHC','NicotineHC','DiazepamHC'};

Session_type = {'Pre','Post'};

Mouse_names_Nic = {'M1500','M1531','M1532','M1686','M1687','M1685'};
Mouse_names_Sal = {'M1685','M1686','M1612','M1641','M1644','M1687'};
Mouse_names_NicLow = {'M1614','M1644','M1688','M1641'};
Mouse_names_SalHC = {'M1411','M1412','M1414','M1416','M1417','M1418','M1207','M1224','M1225','M1227','M1252','M1253','M1254'};
Mouse_names_NicHC = {'M1411','M1412','M1413','M1414','M1415','M1416','M1417','M1418','M1385','M1393'};
Mouse_names_DzpHC = {'M1207','M1224','M1225','M1226','M1227','M1199','M1203','M1251','M1252'};

smootime = 1;
interp_value = 100;
sizeMap = 100;
sizeMap2 = 1000;
RangeLow = linspace(0.1526,20,261);

% HC
for group = 4:5
    if group == 2
        Mouse_names = Mouse_names_Nic;
    elseif group == 1
        Mouse_names = Mouse_names_Sal;
    elseif group == 3
        Mouse_names = Mouse_names_NicLow;
    elseif group == 4
        Mouse_names = Mouse_names_SalHC;
    elseif group == 5
        Mouse_names = Mouse_names_NicHC;
    elseif group == 6
        Mouse_names = Mouse_names_DzpHC;
    end
    %     k = 1;
    for mouse = 1:length(Mouse_names)
        path = sprintf('%s{%d}', Name{group}, mouse);
        folder_path = eval(path);
        cd(folder_path);
        disp(folder_path);
        clear Fifteen_Bef_Inj Fifteen_Aft_Inj OBtsd Epoch_Drugs Sleep Wake FreezeAccEpoch AlignedXtsd AlignedYtsd SmoothGamma Info tRipples EKG
        load('behavResources.mat')
        load('SleepScoring_OBGamma.mat', 'Epoch_Drugs', 'SmoothGamma', 'Sleep','Wake','Info')
        load('B_Low_Spectrum.mat')
        OBtsd = tsd(Spectro{2}*1e4 , Spectro{1});
        
        try
            load('SWR.mat','tRipples')
        catch
            disp('No ripples detected')
        end
        try
            load('HeartBeatInfo.mat')
        catch
            disp('No EKG')
        end
        
        EpochDrugs1.(Name{group})(mouse) = Stop(Epoch_Drugs{1});
        EpochDrugs2.(Name{group})(mouse) = Start(Epoch_Drugs{2});
        
        Fifteen_Bef_Inj = intervalSet(EpochDrugs1.(Name{group})(mouse)-900e4 , EpochDrugs1.(Name{group})(mouse));
        Fifteen_Aft_Inj = intervalSet(EpochDrugs2.(Name{group})(mouse) , EpochDrugs2.(Name{group})(mouse)+900e4);
        
        for sess = 1:length(Session_type)
            if sess==1; Epoch_to_use = Fifteen_Bef_Inj;
            elseif sess==2; Epoch_to_use = Fifteen_Aft_Inj;
            end
            
            FreezeEpochAcc.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) = and(FreezeAccEpoch,Epoch_to_use);
            FreezeTimeAcc.(Name{group}).(Session_type{sess})(mouse) = sum(DurationEpoch(FreezeEpochAcc.(Name{group}).(Session_type{sess}).(Mouse_names{mouse})));
            Speed.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) = Restrict(Vtsd,Epoch_to_use);
            OB_Sp_tsd2 = Restrict(OBtsd,Epoch_to_use);
            SpectroBulbFz.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) = Restrict(OB_Sp_tsd2, FreezeEpochAcc.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}));
            MeanSpectroFz.(Name{group}).(Session_type{sess})(mouse,:) = nanmean(Data(SpectroBulbFz.(Name{group}).(Session_type{sess}).(Mouse_names{mouse})));
            Respi2 = ConvertSpectrum_in_Frequencies_BM(RangeLow, Range(OB_Sp_tsd2), Data(OB_Sp_tsd2));
            RespiFz.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) = Restrict(Respi2,FreezeEpochAcc.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}));
            MeanRespiFz.(Name{group}).(Session_type{sess})(mouse) = nanmean(Data(RespiFz.(Name{group}).(Session_type{sess}).(Mouse_names{mouse})));
            
            Ripples.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) = tRipples;
            try
                RipplesFz.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) = Restrict(tRipples,FreezeEpochAcc.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}));
                if length(RipplesFz.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}))>2
                    Ripples_density.(Name{group}).(Session_type{sess})(mouse) = length(RipplesFz.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}))/(FreezeTimeAcc.(Name{group}).(Session_type{sess})(mouse)/1e4);
                else
                    Ripples_density.(Name{group}).(Session_type{sess})(mouse) = NaN;
                end
            catch
                Ripples_density.(Name{group}).(Session_type{sess})(mouse) = NaN;
            end
            
            try
                HeartRate.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) = Restrict(EKG.HBRate,Epoch_to_use);
                HRFz.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) = Restrict(HeartRate.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}),FreezeEpochAcc.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}));
                MeanHRFz.(Name{group}).(Session_type{sess})(mouse) = nanmean(Data(HRFz.(Name{group}).(Session_type{sess}).(Mouse_names{mouse})));
                MeanHR.(Name{group}).(Session_type{sess})(mouse) = nanmean(Data(HeartRate.(Name{group}).(Session_type{sess}).(Mouse_names{mouse})));
                HeartRateVar.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) = tsd(Range(HeartRate.(Name{group}).(Session_type{sess}).(Mouse_names{mouse})),movstd(Data(HeartRate.(Name{group}).(Session_type{sess}).(Mouse_names{mouse})),5));
                HRVarFz.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) = Restrict(HeartRateVar.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}),FreezeEpochAcc.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}));
                MeanHRVarFz.(Name{group}).(Session_type{sess})(mouse) = nanmean(Data(HRVarFz.(Name{group}).(Session_type{sess}).(Mouse_names{mouse})));
                MeanHRVar.(Name{group}).(Session_type{sess})(mouse) = nanmean(Data(HeartRateVar.(Name{group}).(Session_type{sess}).(Mouse_names{mouse})));
            catch
                MeanHRFz.(Name{group}).(Session_type{sess})(mouse) = NaN;
                MeanHRVarFz.(Name{group}).(Session_type{sess})(mouse) = NaN;
                MeanHR.(Name{group}).(Session_type{sess})(mouse) = NaN;
                MeanHRVar.(Name{group}).(Session_type{sess})(mouse) = NaN;
                
            end
        end
    end
end

no = [1 6 7];
for i = no
    MeanSpectroFz.NicotineHC.Post(i,:) = NaN;
    MeanHRFz.NicotineHC.Post(i) = NaN;
    MeanHRVarFz.NicotineHC.Post(i) = NaN;
    Ripples_density.NicotineHC.Post(i) = NaN;
end

% OF

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
            path = sprintf('%s.%s{%d}', Name{group}, Session_type{sess}, mouse);
            folder_path = eval(path);
            cd(folder_path);
            disp(folder_path);
            clear AlignedXtsd AlignedYtsd
            load('behavResources.mat')
            
            Epoch = intervalSet(0,max(Range(MovAcctsd)));
            
            TotalEpoch.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) = intervalSet(0,max(Range(MovAcctsd)));
            FreezeEpochAcc.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) = FreezeAccEpoch;
            FreezeTimeAcc.(Name{group}).(Session_type{sess})(mouse) = sum(DurationEpoch(FreezeEpochAcc.(Name{group}).(Session_type{sess}).(Mouse_names{mouse})));
            Speed.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) = Vtsd;
            
            try
                load('B_Low_Spectrum.mat')
                OB_Sp_tsd2 = tsd(Spectro{2}*1e4 , Spectro{1});
                SpectroBulbFz.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) = Restrict(OB_Sp_tsd2,FreezeEpochAcc.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}));
                MeanSpectroFz.(Name{group}).(Session_type{sess})(mouse,:) = nanmean(Data(SpectroBulbFz.(Name{group}).(Session_type{sess}).(Mouse_names{mouse})));
                Respi2 = ConvertSpectrum_in_Frequencies_BM(RangeLow, Range(OB_Sp_tsd2), Data(OB_Sp_tsd2));
                RespiFz.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) = Restrict(Respi2,FreezeEpochAcc.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}));
                MeanRespiFz.(Name{group}).(Session_type{sess})(mouse) = nanmean(Data(RespiFz.(Name{group}).(Session_type{sess}).(Mouse_names{mouse})));
            end
            try
                load('HeartBeatInfo.mat')
                HeartRate.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) = EKG.HBRate;
                HRFz.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) = Restrict(EKG.HBRate,FreezeEpochAcc.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}));
                MeanHRFz.(Name{group}).(Session_type{sess})(mouse) = nanmean(Data(HRFz.(Name{group}).(Session_type{sess}).(Mouse_names{mouse})));
                MeanHR.(Name{group}).(Session_type{sess})(mouse) = nanmean(Data(HeartRate.(Name{group}).(Session_type{sess}).(Mouse_names{mouse})));
                HeartRateVar.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) = tsd(Range(HeartRate.(Name{group}).(Session_type{sess}).(Mouse_names{mouse})),movstd(Data(HeartRate.(Name{group}).(Session_type{sess}).(Mouse_names{mouse})),5));
                MeanHRVar.(Name{group}).(Session_type{sess})(mouse) = nanmean(Data(HeartRateVar.(Name{group}).(Session_type{sess}).(Mouse_names{mouse})));
                HRVarFz.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) = Restrict(HeartRateVar.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}),FreezeEpochAcc.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}));
                MeanHRVarFz.(Name{group}).(Session_type{sess})(mouse) = nanmean(Data(HRVarFz.(Name{group}).(Session_type{sess}).(Mouse_names{mouse})));
            catch
                MeanHRFz.(Name{group}).(Session_type{sess})(mouse) = NaN;
                MeanHRVarFz.(Name{group}).(Session_type{sess})(mouse) = NaN;
                MeanHR.(Name{group}).(Session_type{sess})(mouse) = NaN;
                MeanHRVar.(Name{group}).(Session_type{sess})(mouse) = NaN;
                
            end
            try
                load('SWR.mat','tripples')
                Ripples.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) = tRipples;
                try
                    RipplesFz.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) = Restrict(tRipples,FreezeEpochAcc.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}));
                    Ripples_density.(Name{group}).(Session_type{sess})(mouse) = length(RipplesFz.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}))/(FreezeTimeAcc.(Name{group}).(Session_type{sess})(mouse)/1e4);
                catch
                    Ripples_density.(Name{group}).(Session_type{sess})(mouse) = NaN;
                end
            end
        end
    end
end

Mouse_names = Mouse_names_Nic;
for mouse = 1:length(Mouse_names)
    [~,mtemp]= max(MeanSpectroFz.NicotineOF.Post(mouse,:));
    mtemp = RangeLow(mtemp);
    m.NicotineOF(mouse) = mtemp;
    
    if or(not(m.NicotineOF(1,mouse) >1), mtemp <1)
        m.NicotineOF(mouse) = NaN;
    end
end

% Mouse_names = Mouse_names_NicHC;
% Careful, here I only do quantifications on the mice that did at least 1
% min of freezing, so Mouse_names_NicHC = {'M1412','M1413','M1414','M1415','M1418','M1385','M1393'};
Mouse_names = {'M1412','M1413','M1414','M1415','M1418','M1385','M1393'};
Mouse = [2 3 4 5 8 9 10];
k = 1;
for mouse = Mouse
    [~,mtemp]= max(MeanSpectroFz.NicotineHC.Post(mouse,:));
    mtemp = RangeLow(mtemp);
    m.NicotineHC(k) = mtemp;
    
    if or(not(m.NicotineHC(1,k) >1), mtemp <1)
        m.NicotineHC(k) = NaN;
    end
    k = k+1;
end


Mouse=[1500,1686,1687,1685,1385,1393];
for mouse = 1:length(Mouse)
    [~,mtemp]= max(MeanSpectroBulbFzShock.Clean.Fear(mouse,:));
    mtemp = RangeLow(mtemp);
    m.Shock(mouse) = mtemp;
    
    if or(not(m.Shock(1,mouse) >1), mtemp <1)
        m.Shock(mouse) = NaN;
    end
    
    [~,mtemp]= max(MeanSpectroBulbFzSafe.Clean.Fear(mouse,:));
    mtemp = RangeLow(mtemp);
    m.Safe(mouse) = mtemp;
    
    if or(not(m.Safe(1,mouse) >1), mtemp <1)
        m.Safe(mouse) = NaN;
    end
end

Group2 = {'SalineOF','NicotineOF','SalineHC','NicotineHC','Clean'};
Param={'HeartRate','HeartRateVar'};
size_map = 100;

for group = 1:5
    if group == 1
        Mouse_names = {'M1685','M1612','M1641','M1644','M1687'};
        Sess2 = {'Pre','Post'};
    elseif group == 2
        Mouse_names = {'M1531','M1532','M1687','M1685'};
    elseif group == 3
        Mouse_names = {'M1411','M1412','M1414','M1417','M1418','M1207','M1224','M1225','M1227','M1254'};
    elseif group == 4
        Mouse_names = {'M1411','M1412','M1413','M1414','M1416','M1417','M1418','M1385'};
    elseif group == 5
        Mouse_names = {'M1687','M1685','M1685','M1393'};
        Sess2 = {'Fear'};
    end
    
    for sess = 1:length(Sess2)
        for mouse = 1:length(Mouse_names)
            disp(Mouse_names{mouse})
            for param = 1:length(Param)
                
                if param == 1
                    thr_physio1 = 9; thr_physio2 = 14.5;
                    DATA = HeartRate.(Group2{group}).(Sess2{sess}).(Mouse_names{mouse});
                elseif param == 2
                    thr_physio1 = 0; thr_physio2 = .35;
                    DATA = HeartRateVar.(Group2{group}).(Sess2{sess}).(Mouse_names{mouse});
                end
                
                clear DATA_Active_Free DATA_interp SPEED Data_speed Data_physio ind_speed ind_physio Data_speed_corr Data_physio_corr h
                thr_speed = 25;
                SPEED = Speed.(Group2{group}).(Sess2{sess}).(Mouse_names{mouse});
                DATA_interp = Restrict(DATA , SPEED);
                
                Data_speed = runmean_BM(Data(SPEED) , ceil(.3/median(diff(Range(SPEED,'s')))));
                Data_physio = runmean_BM(Data(DATA_interp) , ceil(.3/median(diff(Range(SPEED,'s')))));
                
                ind_speed = Data_speed<thr_speed;
                ind_physio = (Data_physio>thr_physio1 & Data_physio<thr_physio2);
                
                Data_speed_corr = Data_speed(ind_speed & ind_physio);
                Data_physio_corr = Data_physio(ind_speed & ind_physio);
                
                % hist2d step
                Corr_Speed_Physio.(Param{param}).(Group2{group}).(Sess2{sess}).(Mouse_names{mouse}) = hist2d([Data_speed_corr ; 0; 0; thr_speed ; thr_speed] , [Data_physio_corr; thr_physio1 ; thr_physio2; thr_physio1 ; thr_physio2] , size_map , size_map);
                Corr_Speed_Physio.(Param{param}).(Group2{group}).(Sess2{sess}).(Mouse_names{mouse}) = Corr_Speed_Physio.(Param{param}).(Group2{group}).(Sess2{sess}).(Mouse_names{mouse})/sum(Corr_Speed_Physio.(Param{param}).(Group2{group}).(Sess2{sess}).(Mouse_names{mouse})(:));
                Corr_Speed_Physio.(Param{param}).(Group2{group}).(Sess2{sess}).(Mouse_names{mouse}) = Corr_Speed_Physio.(Param{param}).(Group2{group}).(Sess2{sess}).(Mouse_names{mouse})';
                
                Corr_Speed_Physio_log.(Param{param}).(Group2{group}).(Sess2{sess}).(Mouse_names{mouse}) = log(Corr_Speed_Physio.(Param{param}).(Group2{group}).(Sess2{sess}).(Mouse_names{mouse}));
                Corr_Speed_Physio_log.(Param{param}).(Group2{group}).(Sess2{sess}).(Mouse_names{mouse})(Corr_Speed_Physio_log.(Param{param}).(Group2{group}).(Sess2{sess}).(Mouse_names{mouse})==-Inf) = -1e4;
                
                h=histogram(Data_physio_corr,'NumBins',144,'BinLimits',[thr_physio1 thr_physio2]);
                HistData_Physio.(Param{param}).(Group2{group}).(Sess2{sess}).(Mouse_names{mouse}) = h.Values;
                
                h=histogram(Data_physio_corr,'NumBins',144,'BinLimits',[thr_physio1 thr_physio2]);
                HistData_Physio.(Param{param}).(Group2{group}).(Sess2{sess}).(Mouse_names{mouse}) = h.Values;
                
                H.(Param{param}).(Group2{group}).(Sess2{sess})(mouse,:) = ...
                    sum(Corr_Speed_Physio.(Param{param}).(Group2{group}).(Sess2{sess}).(Mouse_names{mouse})./...
                    nansum(Corr_Speed_Physio.(Param{param}).(Group2{group}).(Sess2{sess}).(Mouse_names{mouse})).*(linspace(thr_physio1,thr_physio2,100)'));
                
            end
        end
    end
end

%% Figures

Col1=[1 0 1];
Col2=[1 .5 .5];
Col3=[.5 .5 1];
Col4=[0.13, 0.55, 0.13];

% close all
figure, 
subplot(1,4,1:3)
a1 = Plot_MeanSpectrumForMice_BM(MeanSpectroFz.NicotineOF.Post,'color',Col1);
makepretty
a1.mainLine.LineWidth = 2;
a2 = Plot_MeanSpectrumForMice_BM(MeanSpectroBulbFzShock.Clean.Fear,'color',Col2);
makepretty
a2.mainLine.LineWidth = 2;
a3 = Plot_MeanSpectrumForMice_BM(MeanSpectroBulbFzSafe.Clean.Fear,'color',Col3);
makepretty
a3.mainLine.LineWidth = 2;
a4 = Plot_MeanSpectrumForMice_BM(MeanSpectroFz.NicotineHC.Post,'color',Col4);
makepretty
a4.mainLine.LineWidth = 2;
legend([a1.mainLine a4.mainLine a2.mainLine a3.mainLine],'Nicotine OF','NicotineHC','Shock','Safe')
xlim([0 12])
ylim([0 1.2])

subplot(244)
Cols = {[1 .5 .5],[.5 .5 1],[1, 0, 1],[0.13, 0.55, 0.13]};
X=[1:4];
Legends={'Shock','Safe','OF Nicotine','HC Nicotine'};
MakeSpreadAndBoxPlot3_SB({m.Shock m.Safe m.NicotineOF, m.NicotineHC},Cols,X,Legends,'showpoints',1,'paired',0)
% MakeSpreadAndBoxPlot3_SB({Respi_Fz_Shock_mean.Clean.Fear Respi_Fz_Safe_mean.Clean.Fear MeanRespiFz.NicotineOF.Post, MeanRespiFz.NicotineHC.Post},Cols,X,Legends,'showpoints',1,'paired',0)

ylabel('Peak of OB spectrum');
makepretty_CH
title('Breathing frequency')

subplot(248)
Cols = {[1,0.6,1],[1,0, 1],[0.56, 0.93, 0.56],[0.13, 0.55, 0.13]};
X=[1:4];
Legends={'OF Saline','OF Nicotine','HC Saline','HC Nicotine'};

MakeSpreadAndBoxPlot3_SB({FreezeTimeAcc.SalineOF.Post/1e4/60 FreezeTimeAcc.NicotineOF.Post/1e4/60 FreezeTimeAcc.SalineHC.Post/1e4/60 FreezeTimeAcc.NicotineHC.Post/1e4/60},Cols,X,Legends,'showpoints',1,'paired',0)
ylabel('time freezing (minutes)');
makepretty_CH
title('Time freezing')

%%

figure
Cols = {[1 .5 .5],[.5 .5 1],[1, 0, 1],[0.13, 0.55, 0.13]};
X=[1:4];
Legends={'Shock','Safe','OF Nicotine','HC Nicotine'};
subplot(223)
MakeSpreadAndBoxPlot3_SB({HR_Fz_Shock_mean.Clean.Fear HR_Fz_Safe_mean.Clean.Fear MeanHRFz.NicotineOF.Post MeanHRFz.NicotineHC.Post},Cols,X,Legends,'showpoints',1,'paired',0)
ylabel('Heart Rate (Hz)');
makepretty_CH
title('Heart rate freezing')

subplot(224)
MakeSpreadAndBoxPlot3_SB({HRVar_Fz_Shock_mean.Clean.Fear HRVar_Fz_Safe_mean.Clean.Fear MeanHRVarFz.NicotineOF.Post MeanHRVarFz.NicotineHC.Post},Cols,X,Legends,'showpoints',1,'paired',0)
ylabel('Heart Rate Variability');
makepretty_CH
title('Heart rate var freezing')

subplot(222)

MakeSpreadAndBoxPlot3_SB({Ripples_Fz_Shock_density.Clean.Fear Ripples_Fz_Safe_density.Clean.Fear Ripples_density.NicotineOF.Post Ripples_density.NicotineHC.Post},Cols,X,Legends,'showpoints',1,'paired',0)
ylabel('density (ripples/second)');
makepretty_CH
title('Ripples density freezing')

subplot(221)
MakeSpreadAndBoxPlot3_SB({m.Shock m.Safe m.NicotineOF, m.NicotineHC},Cols,X,Legends,'showpoints',1,'paired',0)
ylabel('Peak of OB spectrum');
makepretty_CH
title('Breathing frequency freezing')



% 
% figure, hold on
% subplot(121)
% plot(RangeLow,MeanSpectroFz.NicotineHC.Post,'k')
% xlim([0 12])
% ylim([0 2e6])
% makepretty
% 
% subplot(122)
% 
% Cols = {[1 .5 .5],[.5 .5 1],[0.54, 0.27, 0.07],[0.13, 0.55, 0.13]};
% X=[1:4];
% Legends={'Shock','Safe','OF Nicotine','HC Nicotine'};
% MakeSpreadAndBoxPlot3_SB({m.Shock m.Safe m.NicotineOF, m.NicotineHC},Cols,X,Legends,'showpoints',1,'paired',0)
% ylabel('Peak of OB spectrum');
% makepretty_CH
% title('Breathing frequency')


Cols1=[1 0 1];
Cols2=[0.13, 0.55, 0.13];
Cols3=[1 0.6 1];
Cols4=[0.56, 0.93, 0.56];
Cols5=[0.7 0.7 0.7];

figure('Color',[1 1 1])

Data_to_use = H.HeartRate.NicotineOF.Post; Data_to_use(Data_to_use==0)=NaN;
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
h1=shadedErrorBar(linspace(0,15,100) , movmean(nanmean(Data_to_use),5,'omitnan') , movmean(Conf_Inter,5,'omitnan'),'b',1);
h1.mainLine.Color=Cols1; h1.patch.FaceColor=Cols1; h1.edge(1).Color=Cols1; h1.edge(2).Color=Cols1;
hold on;
Data_to_use = H.HeartRate.NicotineHC.Post; Data_to_use(Data_to_use==0)=NaN;
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
h2=shadedErrorBar(linspace(0,15,100) , movmean(nanmean(Data_to_use),5,'omitnan') , movmean(Conf_Inter,5,'omitnan'),'b',1);
h2.mainLine.Color=Cols2; h2.patch.FaceColor=Cols2; h2.edge(1).Color=Cols2; h2.edge(2).Color=Cols2;

Data_to_use = H.HeartRate.SalineOF.Post; Data_to_use(Data_to_use==0)=NaN;
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
h3=shadedErrorBar(linspace(0,15,100) , movmean(nanmean(Data_to_use),5,'omitnan') , movmean(Conf_Inter,5,'omitnan'),'b',1);
h3.mainLine.Color=Cols3; h3.patch.FaceColor=Cols3; h3.edge(1).Color=Cols3; h3.edge(2).Color=Cols3;

Data_to_use = H.HeartRate.SalineHC.Post; Data_to_use(Data_to_use==0)=NaN;
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
h4=shadedErrorBar(linspace(0,15,100) , movmean(nanmean(Data_to_use),5,'omitnan') , movmean(Conf_Inter,5,'omitnan'),'b',1);
h4.mainLine.Color=Cols4; h4.patch.FaceColor=Cols4; h4.edge(1).Color=Cols4; h4.edge(2).Color=Cols4;

Data_to_use = H.HeartRate.Clean.Fear; Data_to_use(Data_to_use==0)=NaN;
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
h5=shadedErrorBar(linspace(0,15,100) , movmean(nanmean(Data_to_use),5,'omitnan') , movmean(Conf_Inter,5,'omitnan'),'b',1);
h5.mainLine.Color=Cols5; h5.patch.FaceColor=Cols5; h5.edge(1).Color=Cols5; h5.edge(2).Color=Cols5;

makepretty
xlabel('Speed (cm/s)')
ylabel('Heart Rate, Hz')
% xlim([0 10])
legend([h3.mainLine h1.mainLine h4.mainLine h2.mainLine h5.mainLine],'OF Saline','OF Nicotine','HC Saline','HC Nicotine','UMaze')

a=suptitle('Heart Rate corrected by speed'); a.FontSize=20;



Cols1=[1 0 1];
Cols2=[0.13, 0.55, 0.13];
Cols3=[1 0.6 1];
Cols4=[0.56, 0.93, 0.56];
Cols5=[0.7 0.7 0.7];

figure('Color',[1 1 1])

Data_to_use = H.HeartRateVar.NicotineOF.Post; Data_to_use(Data_to_use==0)=NaN;
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
h1=shadedErrorBar(linspace(0,15,100) , movmean(nanmean(Data_to_use),5,'omitnan') , movmean(Conf_Inter,5,'omitnan'),'b',1);
h1.mainLine.Color=Cols1; h1.patch.FaceColor=Cols1; h1.edge(1).Color=Cols1; h1.edge(2).Color=Cols1;
hold on;
Data_to_use = H.HeartRateVar.NicotineHC.Post; Data_to_use(Data_to_use==0)=NaN;
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
h2=shadedErrorBar(linspace(0,15,100) , movmean(nanmean(Data_to_use),5,'omitnan') , movmean(Conf_Inter,5,'omitnan'),'b',1);
h2.mainLine.Color=Cols2; h2.patch.FaceColor=Cols2; h2.edge(1).Color=Cols2; h2.edge(2).Color=Cols2;

Data_to_use = H.HeartRateVar.SalineOF.Post; Data_to_use(Data_to_use==0)=NaN;
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
h3=shadedErrorBar(linspace(0,15,100) , movmean(nanmean(Data_to_use),5,'omitnan') , movmean(Conf_Inter,5,'omitnan'),'b',1);
h3.mainLine.Color=Cols3; h3.patch.FaceColor=Cols3; h3.edge(1).Color=Cols3; h3.edge(2).Color=Cols3;

Data_to_use = H.HeartRateVar.SalineHC.Post; Data_to_use(Data_to_use==0)=NaN;
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
h4=shadedErrorBar(linspace(0,15,100) , movmean(nanmean(Data_to_use),5,'omitnan') , movmean(Conf_Inter,5,'omitnan'),'b',1);
h4.mainLine.Color=Cols4; h4.patch.FaceColor=Cols4; h4.edge(1).Color=Cols4; h4.edge(2).Color=Cols4;

Data_to_use = H.HeartRateVar.Clean.Fear; Data_to_use(Data_to_use==0)=NaN;
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
h5=shadedErrorBar(linspace(0,15,100) , movmean(nanmean(Data_to_use),5,'omitnan') , movmean(Conf_Inter,5,'omitnan'),'b',1);
h5.mainLine.Color=Cols5; h5.patch.FaceColor=Cols5; h5.edge(1).Color=Cols5; h5.edge(2).Color=Cols5;

makepretty
xlabel('Speed (cm/s)')
ylabel('Heart Rate Variability')
xlim([0 10])
legend([h3.mainLine h1.mainLine h4.mainLine h2.mainLine h5.mainLine],'OF Saline','OF Nicotine','HC Saline','HC Nicotine','UMaze')

a=suptitle('Heart Rate Variability corrected by speed'); a.FontSize=20;







%% Temporary

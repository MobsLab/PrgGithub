
clear all
close all

GetNicotineSessions_CH

Name = {'SalineOF','NicotineOF','NicotineLowOF','SalineHC','NicotineHC','DiazepamHC'};
Session_type = {'Pre','Post'};


Mouse_names_Nic = {'M1500','M1531','M1532','M1686','M1687','M1685'};
Mouse_names_Sal = {'M1685','M1686','M1612','M1641','M1644','M1687'};
Mouse_names_NicLow = {'M1614','M1644','M1688','M1641'};
Mouse_names_SalHC = {'M1411','M1412','M1414','M1416','M1417','M1418','M1207','M1224','M1225','M1227','M1252','M1253','M1254'};
Mouse_names_NicHC = {'M1411','M1412','M1413','M1414','M1415','M1416','M1417','M1418','M1385','M1393'};
Mouse_names_DzpHC = {'M1207','M1224','M1225','M1226','M1227','M1199','M1203','M1251','M1252'};
% Mouse_names_NicHC = {'M1411','M1412','M1413','M1414','M1415','M1416','M1417','M1418','M1385','M1393','M1386','M1394','M1376','M1377'};


smootime = 1;
interp_value = 100;

sizeMap = 100;
sizeMap2 = 1000;
RangeLow = linspace(0.1526,20,261);


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
    for mouse = 1:length(Mouse_names)
        path = sprintf('%s{%d}', Name{group}, mouse);
        folder_path = eval(path);
        cd(folder_path);
        disp(folder_path);
        clear Fifteen_Bef_Inj Fifteen_Aft_Inj OBtsd Epoch_Drugs Sleep Wake FreezeAccEpoch AlignedXtsd AlignedYtsd SmoothGamma Info
        
        load('behavResources.mat')
        load('SleepScoring_OBGamma.mat', 'Epoch_Drugs', 'SmoothGamma', 'Sleep','Wake','Info')
        
        load('B_Low_Spectrum.mat')
        OBtsd = tsd(Spectro{2}*1e4 , Spectro{1});

        load('SWR.mat','tRipples')
        
        EpochDrugs1.(Name{group})(mouse) = min(Range(AlignedXtsd));
        EpochDrugs2.(Name{group})(mouse) = Start(Epoch_Drugs{2});
        
        Fifteen_Bef_Inj = intervalSet(EpochDrugs1.(Name{group})(mouse) , EpochDrugs1.(Name{group})(mouse)+900e4);
        Fifteen_Aft_Inj = intervalSet(EpochDrugs2.(Name{group})(mouse) , EpochDrugs2.(Name{group})(mouse)+900e4);
        
      
        %         figure
        
        for sess = 1:length(Session_type)
            
            if sess==1; Epoch_to_use = Fifteen_Bef_Inj;
            elseif sess==2; Epoch_to_use = Fifteen_Aft_Inj;
            end
            
            Accelero.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) = Restrict(MovAcctsd,Epoch_to_use);
            Speed.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) = Restrict(Vtsd,Epoch_to_use);
            FreezeEpochAcc.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) = and(FreezeAccEpoch,Epoch_to_use);
            ActiveEpoch.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) = Epoch_to_use-Sleep;
            
            
            FreezeTimeAcc.(Name{group}).(Session_type{sess})(mouse) = sum(DurationEpoch(FreezeEpochAcc.(Name{group}).(Session_type{sess}).(Mouse_names{mouse})))/1e4;
            FreezeProp.(Name{group}).(Session_type{sess})(mouse) = FreezeTimeAcc.(Name{group}).(Session_type{sess})(mouse)./DurationEpoch(Epoch_to_use);
            SleepEpoch.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) = and(Epoch_to_use,Sleep);
           
            clear OB_Sp_tsd2 SpectroBulbActive
            OB_Sp_tsd2 = Restrict(OBtsd,Epoch_to_use);
            SpectroBulbFz.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) = Restrict(OB_Sp_tsd2, FreezeEpochAcc.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}));
            MeanSpectroFz.(Name{group}).(Session_type{sess})(mouse,:) = nanmean(Data(SpectroBulbFz.(Name{group}).(Session_type{sess}).(Mouse_names{mouse})));
            MeanSpectro.(Name{group}).(Session_type{sess})(mouse,:) = nanmean(Data(OB_Sp_tsd2));
            Respi.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) = ConvertSpectrum_in_Frequencies_BM(RangeLow, Range(OB_Sp_tsd2), Data(OB_Sp_tsd2));
            RespiFz.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) = Restrict(Respi.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}),FreezeEpochAcc.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}));
            MeanRespiFz.(Name{group}).(Session_type{sess})(mouse) = nanmean(Data(RespiFz.(Name{group}).(Session_type{sess}).(Mouse_names{mouse})));
            SpectroBulbActive = Restrict(OB_Sp_tsd2, ActiveEpoch.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}));
            MeanSpectroActive.(Name{group}).(Session_type{sess})(mouse,:) = nanmean(Data(SpectroBulbActive));
            
            Ripts.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) = Restrict(tRipples, Epoch_to_use);
            RiptsFz.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) = Restrict(Ripts.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}), FreezeEpochAcc.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}));
            NumbRipFz.(Name{group}).(Session_type{sess})(mouse) = length(RiptsFz.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}));
            RipDensFz.(Name{group}).(Session_type{sess})(mouse) = NumbRipFz.(Name{group}).(Session_type{sess})(mouse)/FreezeTimeAcc.(Name{group}).(Session_type{sess})(mouse);
            
            XtsdAligned.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) = Restrict(AlignedXtsd,Epoch_to_use);
            YtsdAligned.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) = Restrict(AlignedYtsd,Epoch_to_use);
            
            ActiveXtsdAligned.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) = Restrict(XtsdAligned.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}),ActiveEpoch.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}));
            ActiveYtsdAligned.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) = Restrict(YtsdAligned.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}),ActiveEpoch.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}));
            
            try
                load('HeartBeatInfo.mat', 'EKG')
                HR.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) = Restrict(EKG.HBRate,Epoch_to_use);
                HRFz.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) = Restrict(HR.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}),FreezeEpochAcc.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}));
                MeanHRFz.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) = nanmean(HRFz.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}));
            end
            
%             subplot(1,2,sess)
%             clear h
%             h = histogram2(Data(YtsdAligned.(Name{group}).(Session_type{sess}).(Mouse_names{mouse})),Data(XtsdAligned.(Name{group}).(Session_type{sess}).(Mouse_names{mouse})),[-5:25],[-5:45]);
%             OccupMap.(Name{group}).(Session_type{sess})(:,:,mouse) = (h.Values)./nansum(h.Values(:));

        end
    end
end

group = 5;
sess = 2;
Mouse_names = Mouse_names_NicHC;
Mouse = [5 8 9 10]; % These are the mice that freeze more than a few seconds and have good ripples

k = 1;

for mouse = Mouse
    Fifteen_Aft_Inj = intervalSet(EpochDrugs2.(Name{group})(mouse) , EpochDrugs2.(Name{group})(mouse)+900e4);
    Epoch_to_use = Fifteen_Aft_Inj;
    
    disp(Mouse_names(mouse));
    
    RipDensFzClean.(Name{group}).(Session_type{sess})(k) = RipDensFz.(Name{group}).(Session_type{sess})(mouse);
    
    a = Start(Epoch_to_use);
    for i = 1:30
        
        Epoch = intervalSet(a,a+30e4);
        clear Fztemp riptemp riptemp2 riptempFz
        
        Fztemp = and(FreezeEpochAcc.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}),Epoch);
        Fztimetemp.(Name{group}).(Session_type{sess})(k,i) = sum(DurationEpoch(Fztemp,'s'));
        
        if Fztimetemp.(Name{group}).(Session_type{sess})(k,i) > 0
            FzOnOff.(Name{group}).(Session_type{sess})(k,i) = 1;
        else
            FzOnOff.(Name{group}).(Session_type{sess})(k,i) = 0;
        end
        
        riptemp = Restrict(Ripts.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}),Epoch);
        NumberRipTemp.(Name{group}).(Session_type{sess})(k,i) = length(riptemp);
        
        try
            riptemp2 = Restrict(Ripts.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}),Fztemp);
            RipDensTempFz.(Name{group}).(Session_type{sess})(k,i) = length(riptemp2)/Fztimetemp.(Name{group}).(Session_type{sess})(k,i);
            NumberRipFzTemp.(Name{group}).(Session_type{sess})(k,i) = length(riptemp2);
        catch
            if Fztimetemp.(Name{group}).(Session_type{sess})(k,i)>0
                RipDensTempFz.(Name{group}).(Session_type{sess})(k,i) = 0;
                NumberRipFzTemp.(Name{group}).(Session_type{sess})(k,i) = 0;
            else
                RipDensTempFz.(Name{group}).(Session_type{sess})(k,i) = NaN;
                NumberRipFzTemp.(Name{group}).(Session_type{sess})(k,i) = NaN;
            end
        end
        a = a+30e4;
    end
    k = k+1;
end




disp('Making Distance to Center')
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
    for mouse = 1:length(Mouse_names)
        Fifteen_Bef_Inj = intervalSet(EpochDrugs1.(Name{group})(mouse), EpochDrugs1.(Name{group})(mouse)+900e4);
        Fifteen_Aft_Inj = intervalSet(EpochDrugs2.(Name{group})(mouse) , EpochDrugs2.(Name{group})(mouse)+900e4);
        for sess = 1:length(Session_type)
            if sess==1; Epoch_to_use = Fifteen_Bef_Inj;
            elseif sess==2; Epoch_to_use = Fifteen_Aft_Inj;
            end
            clear AlignedXtsd_Epoch AlignedYtsd_Epoch
            disp(Mouse_names(mouse));
            disp(sess);
            XtsdAlignedActive = Restrict(XtsdAligned.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}),Epoch_to_use-SleepEpoch.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}));
            YtsdAlignedActive = Restrict(YtsdAligned.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}),Epoch_to_use-SleepEpoch.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}));
            
            [~,Distance,~,~,~] = Thigmotaxis_OF_CH(XtsdAligned.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}), YtsdAligned.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}),'HC','figure',0,'percent_inner',0.7);
            [~,DistanceActive,~,~,~] = Thigmotaxis_OF_CH(XtsdAlignedActive, YtsdAlignedActive,'HC','figure',0,'percent_inner',0.7);
            
            
            a = Start(Epoch_to_use);
            for i = 1:30
                SmallEpoch = intervalSet(a,a+30e4);
                AlignedXtsd_Epoch = Restrict(XtsdAligned.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}),SmallEpoch);
                AlignedYtsd_Epoch = Restrict(YtsdAligned.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}),SmallEpoch);
                
                [~,Distance2,~,~,~] = Thigmotaxis_OF_CH(AlignedXtsd_Epoch, AlignedYtsd_Epoch,'HC','figure',0,'percent_inner',0.7);
                
                DistanceToCenter2.(Name{group}).(Session_type{sess})(mouse,i) = nanmean(Distance2);
                try
                    ActiveEpoch = SmallEpoch-SleepEpoch.(Name{group}).(Session_type{sess}).(Mouse_names{mouse});
                    AlignedXtsd_Epoch2 = Restrict(XtsdAligned.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}),ActiveEpoch);
                    AlignedYtsd_Epoch2 = Restrict(YtsdAligned.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}),ActiveEpoch);
                    
                    [~,Distance3,~,~,~] = Thigmotaxis_OF_CH(AlignedXtsd_Epoch2, AlignedYtsd_Epoch2,'HC','figure',0,'percent_inner',0.7);
                    
                    DistanceToCenterActive.(Name{group}).(Session_type{sess})(mouse,i) = nanmean(Distance3);
                catch
                    DistanceToCenterActive.(Name{group}).(Session_type{sess})(mouse,i) = NaN;
                end
                
                a = a+30e4;
            end
            DistanceToCenterTemp_mean.(Name{group}).(Session_type{sess})(mouse) = nanmean(DistanceToCenter2.(Name{group}).(Session_type{sess})(mouse));
            DistanceToCenterActiveTemp_mean.(Name{group}).(Session_type{sess})(mouse) = nanmean(DistanceToCenterActive.(Name{group}).(Session_type{sess})(mouse));
            DistanceToCenter_mean.(Name{group}).(Session_type{sess})(mouse)=nanmean(Distance);
            DistanceToCenterActive_mean.(Name{group}).(Session_type{sess})(mouse)=nanmean(DistanceActive);
            
        end
    end
end



RangeLow = linspace(0.1526,20,261);
Mouse_names = Mouse_names_NicHC;
Mouse = [2 3 4 5 8 9 10]; % These are the mice that freeze more than a few seconds
k = 1;
for mouse = Mouse
    Fifteen_Aft_Inj = intervalSet(EpochDrugs2.NicotineHC(mouse) , EpochDrugs2.NicotineHC(mouse)+900e4);
    Epoch_to_use = Fifteen_Aft_Inj;
    disp(Mouse_names(k));
    disp(sess);
    a = Start(Epoch_to_use);
    for i = 1:30
        Epoch = intervalSet(a, a+30e4);
        clear mtemp
%         try
            SpectroTemp{i,k} = Restrict(SpectroBulbFz.NicotineHC.Post.(Mouse_names{mouse}),Epoch);
            MeanSpectroTemp{i}(k,:) = nanmean(Data(SpectroTemp{i,k}));
            [~,mtemp]= max(MeanSpectroTemp{i}(k,:));
            mtemp = RangeLow(mtemp);
            m(k,i) = mtemp;
            if or(not(MeanSpectroTemp{i}(k,1) >1), mtemp <1)
                m(k,i) = NaN;
            end
            
%         catch
%             m(k,i) = NaN;
%         end
        a = a+30e4;
    end
    k = k+1;
end


%% Figures

figure('color', [1 1 1])
subplot(121), hold on
Cols={[0.7 0.7 0.7],[0.3 0.3 0.3],[0.56, 0.93, 0.56],[0.13, 0.55, 0.13]};
X=[1:4];
Legends={'Saline Pre','Saline Post','Nicotine Pre','Nicotine Post'};
MakeSpreadAndBoxPlot3_SB({FreezeTimeAcc.SalineHC.Pre/1e4/60 FreezeTimeAcc.SalineHC.Post/1e4/60 FreezeTimeAcc.NicotineHC.Pre/1e4/60 FreezeTimeAcc.NicotineHC.Post/1e4/60},Cols,X,Legends,'showpoints',1,'paired',0)
makepretty_CH
ylabel('Time spent freezing')
subplot(122), hold on
MakeSpreadAndBoxPlot3_SB({DistanceToCenterActive_mean.SalineHC.Pre/2 DistanceToCenterActive_mean.SalineHC.Post/2 DistanceToCenterActive_mean.NicotineHC.Pre/2 DistanceToCenterActive_mean.NicotineHC.Post/2},Cols,X,Legends,'showpoints',1,'paired',0)
makepretty_CH
ylabel('Distance to center')


time = linspace(1,15,30);
% time=[1:15]
x = time; 
y1 = m(:,1:30);
y2 = DistanceToCenterActive.NicotineHC.Post(:,1:30); 
y3 = RipDensTempFz.NicotineHC.Post(:,1:30);

label{1}={'Breathing frequency'};
label{2}={'Thigmotaxis'};
label{3}={'Ripples density'};

[ax, hlines] = multiploty_Shaded_CH({x, y1}, {x, y2}, {x, y3},'time',label);
mtitle('HC')

figure
Bar = bar(time, mean(Fztimetemp.NicotineHC.Post(:,1:30))/1e4, 'FaceAlpha', 0.3, 'FaceColor', [0.5 0.5 0.5],'EdgeColor','none');
title('mean')

figure
Bar2 = bar(time, median(Fztimetemp.NicotineHC.Post(:,1:30))/1e4, 'FaceAlpha', 0.3, 'FaceColor', [0.5 0.5 0.5],'EdgeColor','none');
title('median')

%%

Col1=[0.7 0.7 0.7];
Col2=[0.3 0.3 0.3];
Col3=[0.56, 0.93, 0.56];
Col4=[0.13, 0.55, 0.13];
time = linspace(1,15,30);
figure('color',[1 1 1])
subplot(1,4,1:3), hold on
Data_to_use = DistanceToCenter2.SalineHC.Pre/2;
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use, 1));
h1=shadedErrorBar(time,nanmean(Data_to_use),Conf_Inter,'g',1);
h1.mainLine.Color=Col1; h1.patch.FaceColor=Col1; h1.edge(1).Color=Col1; h1.edge(2).Color=Col1; h1.mainLine.LineWidth=2;

Data_to_use = DistanceToCenter2.SalineHC.Post/2;
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use, 1));
h2=shadedErrorBar(time,nanmean(Data_to_use),Conf_Inter,'g',1);
h2.mainLine.Color=Col2; h2.patch.FaceColor=Col2; h2.edge(1).Color=Col2; h2.edge(2).Color=Col2; h2.mainLine.LineWidth=2;

Data_to_use = DistanceToCenter2.NicotineHC.Pre/2;
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use, 1));
h3=shadedErrorBar(time,nanmean(Data_to_use),Conf_Inter,'g',1);
h3.mainLine.Color=Col3; h3.patch.FaceColor=Col3; h3.edge(1).Color=Col3; h3.edge(2).Color=Col3; h3.mainLine.LineWidth=2;

Data_to_use = DistanceToCenter2.NicotineHC.Post/2;
Conf_Inter=nanstd(Data_to_use)/sqrt(length(Data_to_use));
h4=shadedErrorBar(time,nanmean(Data_to_use),Conf_Inter,'g',1);
h4.mainLine.Color=Col4; h4.patch.FaceColor=Col4; h4.edge(1).Color=Col4; h4.edge(2).Color=Col4; h4.mainLine.LineWidth=2;

legend([h1.mainLine h2.mainLine h3.mainLine h4.mainLine],'Saline Pre','Saline Post','Nicotine Pre','Nicotine Post')

makepretty_CH
subplot(144)

Cols={[0.7 0.7 0.7],[0.3 0.3 0.3],[0.56, 0.93, 0.56],[0.13, 0.55, 0.13]};
X=[1:4];
Legends={'Saline Pre','Saline Post','Nicotine Pre','Nicotine Post'};
MakeSpreadAndBoxPlot3_SB({DistanceToCenter_mean.SalineHC.Pre/2 DistanceToCenter_mean.SalineHC.Post/2 DistanceToCenter_mean.NicotineHC.Pre/2 DistanceToCenter_mean.NicotineHC.Post/2},Cols,X,Legends,'showpoints',1,'paired',0)
makepretty_CH

mtitle('HC, Distance to the center');

%%

Mouse_names = Mouse_names_NicHC;
Mouse = [2 3 4 5 8 9 10];
k = 1;

Threshold = [2.5 3 3.5 4 4.5 5];

figure('Color',[1 1 1]), hold on

for thresh = 1:6    
    k = 1;

    for mouse = Mouse
        
        NewRespiFz = tsd(Range(RespiFz.NicotineHC.Post.(Mouse_names{mouse})),runmean_BM(Data(RespiFz.NicotineHC.Post.(Mouse_names{mouse})),5));
        OverBreathing.NicotineHC.Post.(Mouse_names{mouse}) = thresholdIntervals(NewRespiFz,Threshold(thresh),'Direction','Above');
        OverBreathing.NicotineHC.Post.(Mouse_names{mouse}) = mergeCloseIntervals(OverBreathing.NicotineHC.Post.(Mouse_names{mouse}),0.3*1e4);
        TimeOver.NicotineHC.Post(k) = sum(DurationEpoch(OverBreathing.NicotineHC.Post.(Mouse_names{mouse})))/1e4;
        UnderBreathing.NicotineHC.Post.(Mouse_names{mouse}) = FreezeEpochAcc.NicotineHC.Post.(Mouse_names{mouse})-OverBreathing.NicotineHC.Post.(Mouse_names{mouse});
        TimeUnder.NicotineHC.Post(k) = sum(DurationEpoch(UnderBreathing.NicotineHC.Post.(Mouse_names{mouse})))/1e4;
        Ratio.NicotineHC.Post(k) = TimeUnder.NicotineHC.Post(k)/TimeOver.NicotineHC.Post(k);
        DTC_temp(k)=DistanceToCenterActive_mean.NicotineHC.Post(mouse);
        k = k+1;
        
    end
    subplot(2,3,thresh)
    %             PlotCorrelations_BM(Thigmo.(Name{group}).(Session_type{sess}),TimeOver.(Name{group}).(Session_type{sess}),'colortouse','r');
    %                         PlotCorrelations_BM(DistanceToCenter_mean.(Name{group}).(Session_type{sess}),TimeOver.(Name{group}).(Session_type{sess}),'colortouse','k');
    PlotCorrelations_BM(TimeUnder.NicotineHC.Post,TimeOver.NicotineHC.Post,'colortouse','k');
    %                         PlotCorrelations_BM(FreezeTimeAcc.(Name{group}).(Session_type{sess})/1e4,TimeOver.(Name{group}).(Session_type{sess}),'colortouse','k');
    %             PlotCorrelations_BM(DistanceToCenter_mean.(Name{group}).(Session_type{sess}),Ratio.(Name{group}).(Session_type{sess}),'colortouse','k');
    makepretty
    xlabel(['Time Breathing under ',num2str(Threshold(thresh))])
    ylabel(['Time Breathing over ',num2str(Threshold(thresh))])
    %             ylabel(['Ratio Under/Over ',num2str(Threshold(thresh))])
    
    title(num2str(Threshold(thresh)))
end





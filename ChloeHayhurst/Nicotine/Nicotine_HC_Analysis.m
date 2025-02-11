

GetNicotineSessions_CH

Name = {'SalineOF','NicotineOF','NicotineLowOF','SalineHC','NicotineHC'};
EpochName = {'HCPre','HCPost'};
Session_type = {'OFPre','OFPost'};

Mouse_names_Nic = {'M1500','M1531','M1532','M1686','M1687','M1685'};
Mouse_names_Sal = {'M1685','M1686','M1612','M1641','M1644','M1687'};
Mouse_names_NicLow = {'M1614','M1644','M1688','M1641'};
Mouse_names_SalHC = {'M1411','M1412','M1414','M1416','M1417','M1418','M1207','M1224','M1225','M1227','M1252','M1253','M1254'};
Mouse_names_NicHC = {'M1411','M1412','M1613','M1414','M1415','M1416','M1417','M1418','M1385','M1391','M1393'};

smootime = 1;
interp_value = 100;


% 
% for group = 4:5
%     if group == 4
%         Mouse_names = Mouse_names_SalHC;
%     elseif group == 5
%         Mouse_names = Mouse_names_NicHC;
%     end
%     for mouse=1:length(Mouse_names)
%         path = sprintf('%s{%d}', Name{group}, mouse);
%         
%         folder_path = eval(path);
%         cd(folder_path);
%         disp(folder_path);
%         clear AlignedXtsd AlignedYtsd Xtsd Ytsd x y
%         load('behavResources.mat')
%         try
%         load('SleepScoring_OBGamma.mat','Sleep')
%         catch
%         load('SleepScoringAcceleroOBGamma.mat','Sleep')
%         end
%         
%         if not(exist('B_Low_Spectrum.mat'))
%             load('ChannelsToAnalyse/Bulb_deep.mat')
%             channel;
%             LowSpectrumSB([cd filesep],channel,'B')
%         end
%         if not(exist('StateEpochSB.mat'))
%             load('ChannelsToAnalyse/Bulb_deep.mat')
%             channel;
%             FindNoiseEpoch_BM([cd filesep],channel,0);
%             
%             load('StateEpochSB.mat')
%             load('SleepScoring_OBGamma.mat','SWSEpoch','Wake')
%             
%             SleepyEpoch = intervalSet([],[]);
%             save('StateEpochSB','SleepyEpoch','SWSEpoch','Wake','-append')
%             %                 load('ExpeInfo.mat')
%             %                 CreateRipplesSleep('stim',0,'restrict',0,'sleep',0,'plotavg',0)
%         end
%         
%         thtps_immob=2;
%         smoofact_Acc = 30;
%         th_immob_Acc = 1.7e7;
%         
%         NewMovAcctsd=tsd(Range(MovAcctsd),runmean(Data(MovAcctsd),smoofact_Acc));
%         FreezeAccEpoch=thresholdIntervals(NewMovAcctsd,th_immob_Acc,'Direction','Below');
%         FreezeAccEpoch=mergeCloseIntervals(FreezeAccEpoch,0.3*1e4);
%         FreezeAccEpoch=dropShortIntervals(FreezeAccEpoch,thtps_immob*1e4);
%         FreezeAccEpoch = FreezeAccEpoch - Sleep;
%         
%         save('behavResources.mat', 'FreezeAccEpoch','-append');
%         
%         %             clear channel
%         %             end
%         %             if not(exist('HeartBeatInfo.mat'))
%         %                 try
%         %                     clear EKG channel
%         %                     Options.TemplateThreshStd=3;
%         %                     Options.BeatThreshStd=0.05;
%         %                     load('ChannelsToAnalyse/EKG.mat')
%         %                     load(['LFPData/LFP',num2str(channel),'.mat'])
%         %                     load('StateEpochSB.mat','TotalNoiseEpoch')
%         %                     load('ExpeInfo.mat')
%         %                     load('behavResources.mat')
%         %                     NoiseEpoch=TotalNoiseEpoch;
%         %                     [Times,Template,HeartRate,GoodEpoch]=DetectHeartBeats_EmbReact_SB(LFP,NoiseEpoch,Options,1);
%         %                     EKG.HBTimes=ts(Times);
%         %                     EKG.HBShape=Template;
%         %                     EKG.DetectionOptions=Options;
%         %                     EKG.HBRate=HeartRate;
%         %                     EKG.GoodEpoch=GoodEpoch;
%         %
%         %                     save('HeartBeatInfo.mat','EKG')
%         %                     saveas(1,'EKGCheck.fig'),
%         %                     saveas(1,'EKGCheck.png')
%         %                     close all
%         %                     clear EKG NoiseEpoch TotalNoiseEpoch TTLInfo LFP EKG HearRate Template Times
%         %                 end
%     end
% end


% 
% figure
% for group = 4:5
%     if group == 4
%         Mouse_names = Mouse_names_SalHC;
%     elseif group == 5
%         Mouse_names = Mouse_names_NicHC;
%     end
%     for mouse=1:length(Mouse_names)
%         path = sprintf('%s{%d}', Name{group}, mouse);
%         
%         folder_path = eval(path);
%         cd(folder_path);
%         disp(folder_path);
%         clear AlignedXtsd AlignedYtsd Xtsd Ytsd x y
%         load('behavResources.mat')
%         
%         satisfied = 0;
%         while satisfied ==0
%             
%             polygon = GetCageEdgesWithoutVideo(Data(Ytsd),Data(Xtsd));
%             x = polygon.Position(:,2);
%             y = polygon.Position(:,1);
%             turn = input('cage vertical? (0/1)');
%             if turn == 1
%             Coord1 = [x(1)-x(2),y(1)-y(2)];
%             Coord2 = [x(3)-x(2),y(3)-y(2)];
%             elseif turn ==0
%                 Coord2 = [x(1)-x(2),y(1)-y(2)];
%                 Coord1 = [x(3)-x(2),y(3)-y(2)];
%             end
%             TranssMat = [Coord1',Coord2'];
%             XInit = Data(Xtsd)-x(2);
%             YInit = Data(Ytsd)-y(2);
%             
%             % The Xtsd and Ytsd in new coordinates
%             A = ((pinv(TranssMat)*[XInit,YInit]')');
%             AlignedXtsd = tsd(Range(Xtsd),40*A(:,1));
%             AlignedYtsd = tsd(Range(Ytsd),20*A(:,2));
%             clf
%             %
%             plot(Data(AlignedXtsd),Data(AlignedYtsd))
%             xlim([0 40])
%             ylim([0 40])
%             
%             satisfied = input('happy?');
%             clf
%         end
%         close all
%         save('behavResources.mat', 'AlignedXtsd', 'AlignedYtsd','-append');
%         
%     end
% end


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
    end
    for mouse = 1:length(Mouse_names)
        path = sprintf('%s{%d}', Name{group}, mouse);
        folder_path = eval(path);
        cd(folder_path);
        disp(folder_path);
        
        load('behavResources.mat')
        
        load('SleepScoring_OBGamma.mat', 'Epoch_Drugs', 'SmoothGamma', 'Sleep','Wake')
        %         load('ChannelsToAnalyse/Bulb_deep.mat'); load(['LFPData/LFP' num2str(channel) '.mat'])
        %         FilGamma=FilterLFP(LFP,[50 70],1024);
        %         HilGamma=abs(hilbert(Data(FilGamma)));
        %         smooth_ghi=tsd(Range(FilGamma),runmean_BM(HilGamma,ceil(smootime/median(diff(Range(FilGamma,'s'))))));
        load('B_Low_Spectrum.mat')
        OBtsd = tsd(Spectro{2}*1e4 , Spectro{1});
        
        EpochDrugs1.(Name{group})(mouse) = Stop(Epoch_Drugs{1});
        EpochDrugs2.(Name{group})(mouse) = Start(Epoch_Drugs{2});
        
        Fifteen_Bef_Inj = intervalSet(EpochDrugs1.(Name{group})(mouse)-900e4 , EpochDrugs1.(Name{group})(mouse));
        Fifteen_Aft_Inj = intervalSet(EpochDrugs2.(Name{group})(mouse) , EpochDrugs2.(Name{group})(mouse)+900e4);
        
        for epoch = 1:length(EpochName)
            
            if epoch==1; Epoch_to_use = Fifteen_Bef_Inj;
            elseif epoch==2; Epoch_to_use = Fifteen_Aft_Inj;
            end
            
            Accelero.(Name{group}).(EpochName{epoch}).(Mouse_names{mouse}) = Restrict(MovAcctsd,Epoch_to_use);
            Speed.(Name{group}).(EpochName{epoch}).(Mouse_names{mouse}) = Restrict(Vtsd,Epoch_to_use);
            TotalEpoch.(Name{group}).(EpochName{epoch}).(Mouse_names{mouse}) = intervalSet(0,max(Range(MovAcctsd)));
            FreezeEpochAcc.(Name{group}).(EpochName{epoch}).(Mouse_names{mouse}) = and(FreezeAccEpoch,Epoch_to_use);
            FreezeTimeAcc.(Name{group}).(EpochName{epoch})(mouse) = sum(DurationEpoch(FreezeEpochAcc.(Name{group}).(EpochName{epoch}).(Mouse_names{mouse})));
            FreezeProp.(Name{group}).(EpochName{epoch})(mouse) = FreezeTimeAcc.(Name{group}).(EpochName{epoch})(mouse)./sum(DurationEpoch(TotalEpoch.(Name{group}).(EpochName{epoch}).(Mouse_names{mouse})));
            
            
            OB_Sp_tsd.(Name{group}).(EpochName{epoch}).(Mouse_names{mouse}) = Restrict(OBtsd,Epoch_to_use);
            SpectroBulbFz.(Name{group}).(EpochName{epoch}){mouse} = Restrict(OB_Sp_tsd.(Name{group}).(EpochName{epoch}).(Mouse_names{mouse}), FreezeEpochAcc.(Name{group}).(EpochName{epoch}).(Mouse_names{mouse}));
            MeanSpectroFz.(Name{group}).(EpochName{epoch})(mouse,:) = nanmean(Data(SpectroBulbFz.(Name{group}).(EpochName{epoch}){mouse}));
            %                         MeanSpectro.(Name{group}).(EpochName{epoch})(mouse,:) = nanmean(Data(OB_Sp_tsd.(Name{group}).(EpochName{epoch}){mouse}));
            Respi.(Name{group}).(EpochName{epoch}).(Mouse_names{mouse}) = ConvertSpectrum_in_Frequencies_BM(Spectro{3} , Spectro{2}*1e4 , Spectro{1});
            RespiFz.(Name{group}).(EpochName{epoch}).(Mouse_names{mouse}) = Restrict(Respi.(Name{group}).(EpochName{epoch}).(Mouse_names{mouse}),FreezeEpochAcc.(Name{group}).(EpochName{epoch}).(Mouse_names{mouse}));
            MeanRespiFz.(Name{group}).(EpochName{epoch})(mouse) = nanmean(Data(RespiFz.(Name{group}).(EpochName{epoch}).(Mouse_names{mouse})));
            XtsdAligned.(Name{group}).(EpochName{epoch}).(Mouse_names{mouse}) = Restrict(AlignedXtsd,Epoch_to_use);
            YtsdAligned.(Name{group}).(EpochName{epoch}).(Mouse_names{mouse}) = Restrict(AlignedYtsd,Epoch_to_use);
            
            PositionX.(Name{group}).(EpochName{epoch}).(Mouse_names{mouse}) = Data(XtsdAligned.(Name{group}).(EpochName{epoch}).(Mouse_names{mouse}));
            PositionY.(Name{group}).(EpochName{epoch}).(Mouse_names{mouse})  = Data(YtsdAligned.(Name{group}).(EpochName{epoch}).(Mouse_names{mouse}));
            PositionX.(Name{group}).(EpochName{epoch}).(Mouse_names{mouse})((PositionX.(Name{group}).(EpochName{epoch}).(Mouse_names{mouse})<0) | (PositionX.(Name{group}).(EpochName{epoch}).(Mouse_names{mouse})>20)) = NaN;
            PositionY.(Name{group}).(EpochName{epoch}).(Mouse_names{mouse})((PositionY.(Name{group}).(EpochName{epoch}).(Mouse_names{mouse})<0) | (PositionY.(Name{group}).(EpochName{epoch}).(Mouse_names{mouse})>40)) = NaN;
                        
            OccupMaptemp.(Name{group}).(EpochName{epoch}).(Mouse_names{mouse}) = hist2d([PositionX.(Name{group}).(EpochName{epoch}).(Mouse_names{mouse}) ;0; 0; 1; 1] , [PositionY.(Name{group}).(EpochName{epoch}).(Mouse_names{mouse});0;1;0;1] , sizeMap , sizeMap);
            
            OccupMap_log.(Name{group}).(EpochName{epoch}).(Mouse_names{mouse}) = log(OccupMaptemp.(Name{group}).(EpochName{epoch}).(Mouse_names{mouse}));
            OccupMap_log.(Name{group}).(EpochName{epoch}).(Mouse_names{mouse})(OccupMap_log.(Name{group}).(EpochName{epoch}).(Mouse_names{mouse})==-Inf) = -1e4;
            
            
            try
                OccupMap.(Name{group}).(EpochName{epoch})(mouse,:,:) = OccupMaptemp.(Name{group}).(EpochName{epoch}).(Mouse_names{mouse});
            catch
                OccupMap.(Name{group}).(EpochName{epoch})(mouse,:,:) = NaN(sizeMap,sizeMap);
            end
            
            OccupMap_squeeze.(Name{group}).(EpochName{epoch}) = squeeze(nanmean(OccupMap.(Name{group}).(EpochName{epoch})));
            OccupMap_log_squeeze.(Name{group}).(EpochName{epoch}) = log(OccupMap_squeeze.(Name{group}).(EpochName{epoch}));
            OccupMap_log_squeeze.(Name{group}).(EpochName{epoch})(OccupMap_log_squeeze.(Name{group}).(EpochName{epoch})==-Inf) = -1e4;
            
        end
        clear Fifteen_Bef_Inj Fifteen_Aft_Inj OBtsd Epoch_Drugs Sleep Wake FreezeAccEpoch AlignedXtsd AlignedYtsd
    end
    close all
end


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
    end
    for mouse = 1:length(Mouse_names)
        Fifteen_Bef_Inj = intervalSet(EpochDrugs1.(Name{group})(mouse)-900e4 , EpochDrugs1.(Name{group})(mouse));
        Fifteen_Aft_Inj = intervalSet(EpochDrugs2.(Name{group})(mouse) , EpochDrugs2.(Name{group})(mouse)+900e4);
        for epoch = 1:length(EpochName)
            if epoch==1; Epoch_to_use = Fifteen_Bef_Inj;
            elseif epoch==2; Epoch_to_use = Fifteen_Aft_Inj;
            end
            
            disp(Mouse_names(mouse));
            AlignedXtsd_Epoch = Restrict(XtsdAligned.(Name{group}).(EpochName{epoch}).(Mouse_names{mouse}),Epoch_to_use);
            AlignedYtsd_Epoch = Restrict(YtsdAligned.(Name{group}).(EpochName{epoch}).(Mouse_names{mouse}),Epoch_to_use);
            
            ActiveEpoch = Epoch_to_use-FreezeEpochAcc.(Name{group}).(EpochName{epoch}).(Mouse_names{mouse});
            AlignedXtsd_active = Restrict(XtsdAligned.(Name{group}).(EpochName{epoch}).(Mouse_names{mouse}), ActiveEpoch);
            AlignedYtsd_active = Restrict(YtsdAligned.(Name{group}).(EpochName{epoch}).(Mouse_names{mouse}), ActiveEpoch);
            
            [Thigmotaxis,~,ZoneEpochInner,ZoneEpochOuter,~] = Thigmotaxis_OF_CH(AlignedXtsd_Epoch, AlignedYtsd_Epoch,'HC','figure',0,'percent_inner',0.8);
            Thigmo.(Name{group}).(EpochName{epoch})(mouse) = Thigmotaxis;
            InnerEpoch.(Name{group}).(EpochName{epoch}).(Mouse_names{mouse}) = ZoneEpochInner;
            OuterEpoch.(Name{group}).(EpochName{epoch}).(Mouse_names{mouse}) = ZoneEpochOuter;
            [Thigmotaxis2,~,~,~,~] = Thigmotaxis_OF_CH(AlignedXtsd_active, AlignedYtsd_active,'HC','figure',0,'percent_inner',0.8);
            Thigmo2.(Name{group}).(EpochName{epoch})(mouse) = Thigmotaxis2;
                
                AlignedXtsd_freezing = Restrict(XtsdAligned.(Name{group}).(EpochName{epoch}).(Mouse_names{mouse}), FreezeEpochAcc.(Name{group}).(EpochName{epoch}).(Mouse_names{mouse}));
                AlignedYtsd_freezing = Restrict(YtsdAligned.(Name{group}).(EpochName{epoch}).(Mouse_names{mouse}), FreezeEpochAcc.(Name{group}).(EpochName{epoch}).(Mouse_names{mouse}));
                
                try
                [Thigmotaxis3,~,~,~,~] = Thigmotaxis_OF_CH(AlignedXtsd_freezing, AlignedYtsd_freezing,'HC','figure',0,'percent_inner',0.8);
                Thigmo3.(Name{group}).(EpochName{epoch})(mouse) = Thigmotaxis3;
                catch
                    disp('No freezing')
                    Thigmo3.(Name{group}).(EpochName{epoch})(mouse) = NaN;
                end
            clear ActiveEPoch
        end
    end
end


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
    end
    for mouse = 1:length(Mouse_names)
        disp(Mouse_names(mouse));
        Fifteen_Bef_Inj = intervalSet(EpochDrugs1.(Name{group})(mouse)-900e4 , EpochDrugs1.(Name{group})(mouse));
        Fifteen_Aft_Inj = intervalSet(EpochDrugs2.(Name{group})(mouse) , EpochDrugs2.(Name{group})(mouse)+900e4);
        for epoch = 1:length(EpochName)
            if epoch==1; Epoch_to_use = Fifteen_Bef_Inj;
            elseif epoch==2; Epoch_to_use = Fifteen_Aft_Inj;
            end
            a = Start(Epoch_to_use);
            for i = 1:15
                try
                    Epoch = intervalSet(a,a+60e4);
                    AlignedXtsd_Epoch = Restrict(XtsdAligned.(Name{group}).(EpochName{epoch}).(Mouse_names{mouse}),Epoch);
                    AlignedYtsd_Epoch = Restrict(YtsdAligned.(Name{group}).(EpochName{epoch}).(Mouse_names{mouse}),Epoch);
                    
                    
                    [ThigmotaxisTemp,~,~,~] = Thigmotaxis_OF_CH(AlignedXtsd_Epoch, AlignedYtsd_Epoch,'HC','figure',0,'percent_inner',0.8);
                    
                    ThigmoTemp.(Name{group}).(EpochName{epoch})(mouse,i) = ThigmotaxisTemp;
                    a = a+60e4;
                catch
                    ThigmoTemp.(Name{group}).(EpochName{epoch})(mouse,i) = NaN;
                    a = a+60e4;
                end
            end
        end
    end
end


Col1=[0.7 0.7 0.7];
Col2=[0.3 0.3 0.3];
Col3=[1, 0.6, 0.6];
Col4=[0.6, 0, 0];
time = [1:15];
figure('color', [1 1 1]), hold on
subplot(1,4,1:3), hold on
e1 = errorbar(time, nanmean(ThigmoTemp.SalineHC.HCPre),stdError(ThigmoTemp.SalineHC.HCPre),'color',Col1);
e2 = errorbar(time, nanmean(ThigmoTemp.SalineHC.HCPost),stdError(ThigmoTemp.SalineHC.HCPost),'color',Col2);

e3 = errorbar(time, nanmean(ThigmoTemp.NicotineHC.HCPre),stdError(ThigmoTemp.NicotineHC.HCPre),'color',Col3);
e4 = errorbar(time, nanmean(ThigmoTemp.NicotineHC.HCPost),stdError(ThigmoTemp.NicotineHC.HCPost),'color',Col4);

legend([e1 e2 e3 e4],'Saline Pre','Saline Post','Nicotine Pre','Nicotine Low')


makepretty_CH
ylim([0 1]);
p_valuesPre = zeros(1, 15);
A = ThigmoTemp.(Name{group}).HCPre;
B = ThigmoTemp.(Name{group}).HCPost;
for i = 1:15
    p_valuesPre(i) = ranksum(A(:,i), B(:,i));
end
p_valuesPost = zeros(1, 15);
A = ThigmoTemp.(Name{group}).HCPre;
B = ThigmoTemp.(Name{group}).HCPost;
for i = 1:15
    p_valuesPost(i) = ranksum(A(:,i), B(:,i));
end

subplot(144)
Cols={[0.7 0.7 0.7],[0.3 0.3 0.3],[1, 0.6, 0.6],[0.6, 0, 0]};
X=[1:4];
Legends={'Saline Pre','Saline Post','Nicotine Pre','Nicotine Post'};
MakeSpreadAndBoxPlot3_SB({Thigmo.SalineHC.HCPre Thigmo.SalineHC.HCPost Thigmo.NicotineHC.HCPre Thigmo.NicotineHC.HCPost},Cols,X,Legends,'showpoints',1,'paired',0)
ylim([0 1])
makepretty_CH

mtitle('Homecage thigmotaxis')











    


GetEmbReactMiceFolderList_BM
Mouse = [688 739 777 849 893 1171 9184 1189 1391 1392 1394];
Session_type={'Habituation','Cond'};
Epoch={'FzCam','FzCamMoving','FzAcc'};

for sess=1:length(Session_type)
    Sessions_List_ForLoop_BM
    for mouse = 1:length(Mouse)
        Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
        %         Fz_Cam.(Session_type{sess}).(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}),'epoch','epochname','freeze_epoch_camera');
        %         Fz_Acc.(Session_type{sess}).(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}),'epoch','epochname','freezeepoch');
        %         Acc.(Session_type{sess}).(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}),'accelero');
        %         Mov.(Session_type{sess}).(Mouse_names{mouse}) = tsd(Range(Acc.(Session_type{sess}).(Mouse_names{mouse})) , runmean(Data(Acc.(Session_type{sess}).(Mouse_names{mouse})),30));
        %         Mov_FzCam.(Session_type{sess}).(Mouse_names{mouse}) = tsd(Range(Restrict(Mov.(Session_type{sess}).(Mouse_names{mouse}) , Fz_Cam.(Session_type{sess}).(Mouse_names{mouse}))) , runmean(Data(Restrict(Mov.(Session_type{sess}).(Mouse_names{mouse}) , Fz_Cam.(Session_type{sess}).(Mouse_names{mouse}))),30));
        
        %         if mouse<6
        %             Fz_CamMoving.(Session_type{sess}).(Mouse_names{mouse}) = thresholdIntervals(Mov_FzCam.(Session_type{sess}).(Mouse_names{mouse}),10^(7.1));
        %         else
        %             Fz_CamMoving.(Session_type{sess}).(Mouse_names{mouse}) = thresholdIntervals(Mov_FzCam.(Session_type{sess}).(Mouse_names{mouse}),10^(7.4));
        %         end
        %         try
        %             Mov_FzAcc.(Session_type{sess}).(Mouse_names{mouse}) = tsd(Range(Restrict(Mov.(Session_type{sess}).(Mouse_names{mouse}) , Fz_Acc.(Session_type{sess}).(Mouse_names{mouse}))) , runmean(Data(Restrict(Mov.(Session_type{sess}).(Mouse_names{mouse}) , Fz_Acc.(Session_type{sess}).(Mouse_names{mouse}))),30));
        %         catch
        %             Mov_FzAcc.(Session_type{sess}).(Mouse_names{mouse}) = tsd([],[]);
        %         end
        
        %         Acc.(Session_type{sess}).(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}),'accelero');
        %         Respi.(Session_type{sess}).(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}),'respi_freq_bm');
        %         OB_Low.(Session_type{sess}).(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}),'spectrum','prefix','B_Low');
        %         HR.(Session_type{sess}).(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}),'heartrate');
        %         HRVar.(Session_type{sess}).(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}),'heartratevar');
        %         TailTemperature.(Session_type{sess}).(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}),'tailtemperature');
                Ripples.(Session_type{sess}).(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}),'ripples');
        
        chan = Get_chan_numb_BM(FolderList.(Mouse_names{mouse}){1},'bulb_deep');
        LFP_OB.(Session_type{sess}).(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}),'lfp','channumber',chan);
        
        for ep=1:length(Epoch)
            if ep==1
                Epoch_to_use = Fz_Cam.(Session_type{sess}).(Mouse_names{mouse});
            elseif ep==2
                Epoch_to_use = Fz_CamMoving.(Session_type{sess}).(Mouse_names{mouse});
            elseif ep==3
                Epoch_to_use = Fz_Acc.(Session_type{sess}).(Mouse_names{mouse});
            end
            %             Acc.(Epoch{ep}).(Session_type{sess}).(Mouse_names{mouse}) = Restrict(Acc.(Session_type{sess}).(Mouse_names{mouse}) , Epoch_to_use);
            %             OBSpec.(Epoch{ep}).(Session_type{sess}).(Mouse_names{mouse}) = Restrict(OB_Low.(Session_type{sess}).(Mouse_names{mouse}) , Epoch_to_use);
            %             HR.(Epoch{ep}).(Session_type{sess}).(Mouse_names{mouse}) = Restrict(HR.(Session_type{sess}).(Mouse_names{mouse}) , Epoch_to_use);
            %             HRVar.(Epoch{ep}).(Session_type{sess}).(Mouse_names{mouse}) = Restrict(HRVar.(Session_type{sess}).(Mouse_names{mouse}) , Epoch_to_use);
            %             TailTemperature.(Epoch{ep}).(Session_type{sess}).(Mouse_names{mouse}) = Restrict(TailTemperature.(Session_type{sess}).(Mouse_names{mouse}) , Epoch_to_use);
            Ripples.(Epoch{ep}).(Session_type{sess}).(Mouse_names{mouse}) = Restrict(Ripples.(Session_type{sess}).(Mouse_names{mouse}) , Epoch_to_use);
            LFP_OB.(Epoch{ep}).(Session_type{sess}).(Mouse_names{mouse}) = Restrict(LFP_OB.(Session_type{sess}).(Mouse_names{mouse}) , Epoch_to_use);
            
            Duration_Epoch.(Session_type{sess}){ep}(mouse) = sum(DurationEpoch(Epoch_to_use))/1e4;
            Acc_Data.(Session_type{sess}){ep}(mouse) = nanmean(Data(Acc.(Epoch{ep}).(Session_type{sess}).(Mouse_names{mouse})));
            OBSpec_Data.(Session_type{sess}){ep}(mouse,:) = nanmean(Data(OBSpec.(Epoch{ep}).(Session_type{sess}).(Mouse_names{mouse})));
            HR_Data.(Session_type{sess}){ep}(mouse) = nanmean(Data(HR.(Epoch{ep}).(Session_type{sess}).(Mouse_names{mouse})));
            HRVar_Data.(Session_type{sess}){ep}(mouse) = nanmean(Data(HRVar.(Epoch{ep}).(Session_type{sess}).(Mouse_names{mouse})));
            TailTemperature_Data.(Session_type{sess}){ep}(mouse) = nanmean(Data(TailTemperature.(Epoch{ep}).(Session_type{sess}).(Mouse_names{mouse})));
            Ripples_Data.(Session_type{sess}){ep}(mouse) = length();
        end
        
        Mov_FzAcc_proportion.(Session_type{sess})(mouse) = sum(DurationEpoch(Fz_CamMoving.(Session_type{sess}).(Mouse_names{mouse})))/sum(DurationEpoch(Fz_Cam.(Session_type{sess}).(Mouse_names{mouse})));
        
        disp(Mouse_names{mouse})
    end
end

for sess=1:length(Session_type)
    figure
    for mouse = 1:length(Mouse)
        subplot(3,4,mouse)
        histogram(log10(Data(Mov.(Session_type{sess}).(Mouse_names{mouse}))),'BinLimits',[6.5 8.5],'NumBins',100,'FaceColor',[.3 .3 .3]);
        hold on
        histogram(log10(Data(Mov_FzCam.(Session_type{sess}).(Mouse_names{mouse}))),'BinLimits',[6.5 8.5],'NumBins',100,'FaceColor',[.67 .41 .77]);
        histogram(log10(Data(Mov_FzAcc.(Session_type{sess}).(Mouse_names{mouse}))),'BinLimits',[6.5 8.5],'NumBins',100,'FaceColor',[.4 .69 .42]);
    if mouse<6; vline(7.1); else vline(7.4); end
    end
end

Cols={[.51 .88 .76],[.88 .59 .35]};
Legends={'Habituation','Cond'};
X=1:2;

Cols2={[.67 .41 .77],[.45 .38 .71],[.4 .69 .42]};
Legends2={'FzCam','FzCamMoving','FzAcc'};
X2=1:3;


figure
subplot(121)
MakeSpreadAndBoxPlot3_SB(Duration_Epoch.Habituation,Cols2,X2,Legends2,'showpoints',0,'paired',1);
ylim([0 3e3]), ylabel('time (s)')
title('Habituation')

subplot(122)
MakeSpreadAndBoxPlot3_SB(Duration_Epoch.Cond,Cols2,X2,Legends2,'showpoints',0,'paired',1);
ylim([0 3e3])
title('Cond')

a=suptitle('Identification of differents freezing types'); a.FontSize=20;


figure
sess=1;
subplot(121)
histogram(log10(Data(Mov.(Session_type{sess}).(Mouse_names{mouse}))),'BinLimits',[6.5 8.5],'NumBins',100,'FaceColor',[.3 .3 .3]);
hold on
histogram(log10(Data(Mov_FzCam.(Session_type{sess}).(Mouse_names{mouse}))),'BinLimits',[6.5 8.5],'NumBins',100,'FaceColor',[.67 .41 .77]);
histogram(log10(Data(Mov_FzAcc.(Session_type{sess}).(Mouse_names{mouse}))),'BinLimits',[6.5 8.5],'NumBins',100,'FaceColor',[.4 .69 .42]);
legend(Legends2)
vline(7.4)
xlabel('accelero values (log scale)'), ylabel('#')
box off
title('Habituation')

sess=2;
subplot(122)
histogram(log10(Data(Mov.(Session_type{sess}).(Mouse_names{mouse}))),'BinLimits',[6.5 8.5],'NumBins',100,'FaceColor',[.3 .3 .3]);
hold on
histogram(log10(Data(Mov_FzCam.(Session_type{sess}).(Mouse_names{mouse}))),'BinLimits',[6.5 8.5],'NumBins',100,'FaceColor',[.67 .41 .77]);
histogram(log10(Data(Mov_FzAcc.(Session_type{sess}).(Mouse_names{mouse}))),'BinLimits',[6.5 8.5],'NumBins',100,'FaceColor',[.4 .69 .42]);
vline(7.4)
xlabel('accelero values (log scale)')
box off
title('Cond')

a=suptitle('Accelerometer values in differents sessions, Mouse #1394'); a.FontSize=20;


figure
for sess=1:2
    subplot(2,6,1+(sess-1)*6:2+(sess-1)*6)
    for ep=1:3
        %         Data_to_use = OBSpec_Data.(Session_type{sess}){ep};
        %         Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
        %         clear Mean_All_Sp; Mean_All_Sp=nanmean(Data_to_use);
        %         h=shadedErrorBar(Spectro{3} , Mean_All_Sp , Conf_Inter , '-k' ,1); hold on;
        %         h.mainLine.Color=Cols2{ep}; h.patch.FaceColor=Cols2{ep}; h.edge(1).Color=Cols2{ep}; h.edge(2).Color=Cols2{ep};
        [h , MaxPowerValues.(Session_type{sess}){ep} , Freq_Max.(Session_type{sess}){ep}] = Plot_MeanSpectrumForMice_BM(OBSpec_Data.(Session_type{sess}){ep},'color',Cols2{ep},'threshold',26);
    end
    if sess==1; f=get(gca,'Children'); l=legend([f(4),f(8),f(12)],'FzCam','FzCamMoving','FzAcc'); title('OB mean spectrum'); end
    u=text(-2,.3,Session_type{sess},'FontSize',18,'FontWeight','bold'); set(u,'Rotation',90);
    xlim([0 10]), xlabel('Frequency (Hz)'), ylabel('Power (a.u.)')
    ylim([0 1])
    grid on
    box off
    vline(5.417)
    
    subplot(2,6,3+(sess-1)*6)
    MakeSpreadAndBoxPlot3_SB(MaxPowerValues.(Session_type{sess}),Cols2,X2,Legends2,'showpoints',0,'paired',1);
    ylabel('OB max power (a.u.)')
    ylim([0 1e6])
    set(gca , 'Yscale','log')
    
    subplot(2,6,4+(sess-1)*6)
    MakeSpreadAndBoxPlot3_SB(Freq_Max.(Session_type{sess}),Cols2,X2,Legends2,'showpoints',0,'paired',1);
    ylabel('OB frequency (Hz)')
    ylim([1.5 8])
    
    subplot(2,6,5+(sess-1)*6)
    MakeSpreadAndBoxPlot3_SB(HR_Data.(Session_type{sess}),Cols2,X2,Legends2,'showpoints',0,'paired',1);
    ylabel('Heart rate (Hz)')
    ylim([9.5 13.5])
    hline(12.3)
    
    subplot(2,6,6+(sess-1)*6)
    MakeSpreadAndBoxPlot3_SB(HRVar_Data.(Session_type{sess}),Cols2,X2,Legends2,'showpoints',0,'paired',1);
    ylabel('Heart rate variability (a.u.)')
    ylim([0 .4])
    hline(.07)
end









figure
MakeSpreadAndBoxPlot3_SB({Mov_FzAcc_proportion.Habituation Mov_FzAcc_proportion.Cond},Cols,X,Legends,'showpoints',0,'paired',1);
ylabel('immobility score (a.u.)')



figure
subplot(151)
MakeSpreadAndBoxPlot3_SB(Acc_Data.Cond,Cols2,X2,Legends2,'showpoints',0,'paired',1);
ylabel('immobility score (a.u.)')

subplot(152)
for ep=1:3; Plot_MeanSpectrumForMice_BM(OBSpec_Data.Cond{ep},'color',Cols2{ep}); end
xlim([0 15])

subplot(153)
MakeSpreadAndBoxPlot3_SB(HR_Data.Cond,Cols2,X2,Legends2,'showpoints',0,'paired',1);
ylabel('immobility score (a.u.)')

subplot(154)
MakeSpreadAndBoxPlot3_SB(HRVar_Data.Cond,Cols2,X2,Legends2,'showpoints',0,'paired',1);
ylabel('immobility score (a.u.)')

subplot(155)
MakeSpreadAndBoxPlot3_SB(TailTemperature_Data.Cond,Cols2,X2,Legends2,'showpoints',0,'paired',1);
ylabel('immobility score (a.u.)')






figure
subplot(151)
MakeSpreadAndBoxPlot3_SB(Acc_Data.Habituation,Cols2,X2,Legends2,'showpoints',0,'paired',1);
ylabel('immobility score (a.u.)')

subplot(152)
for ep=1:3; Plot_MeanSpectrumForMice_BM(OBSpec_Data.Habituation{ep},'color',Cols2{ep}); end
xlim([0 15])

subplot(153)
MakeSpreadAndBoxPlot3_SB(HR_Data.Habituation,Cols2,X2,Legends2,'showpoints',0,'paired',1);
ylabel('immobility score (a.u.)')

subplot(154)
MakeSpreadAndBoxPlot3_SB(HRVar_Data.Habituation,Cols2,X2,Legends2,'showpoints',0,'paired',1);
ylabel('immobility score (a.u.)')

subplot(155)
MakeSpreadAndBoxPlot3_SB(TailTemperature_Data.Habituation,Cols2,X2,Legends2,'showpoints',0,'paired',1);
ylabel('immobility score (a.u.)')



figure
clf
plot(Spectro{3} , OBSpec_Data.Cond{1}(mouse,:))
hold on
plot(Spectro{3} , OBSpec_Data.Cond{2}(mouse,:))
plot(Spectro{3} , OBSpec_Data.Cond{3}(mouse,:))
mouse=mouse+1;




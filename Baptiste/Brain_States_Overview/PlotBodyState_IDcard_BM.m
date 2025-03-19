
for sess=1:length(Session_type)
    for mouse=1:length(Mouse)
        for ind=5:6
            OutPutData.(Session_type{sess}).heartrate.var(mouse,ind) = OutPutData.(Session_type{sess}).heartratevar.mean(mouse,ind);
            OutPutData.(Session_type{sess}).respi_freq_bm.var(mouse,ind) = OutPutData.(Session_type{sess}).respivar.mean(mouse,ind);
            try
                OutPutData.(Session_type{sess}).tailtemperature.var(mouse,ind) = nanmean(movstd(Data(OutPutData.(Session_type{sess}).tailtemperature.tsd{mouse,ind}),ind));
            end
            try
                OutPutData.(Session_type{sess}).masktemperature.var(mouse,ind) = nanmean(movstd(Data(OutPutData.(Session_type{sess}).masktemperature.tsd{mouse,ind}),ind));
            end
            try
                OutPutData.(Session_type{sess}).emg.var(mouse,ind) = nanmean(movstd(Data(OutPutData.(Session_type{sess}).emg.tsd{mouse,ind}),ind));
            end
            OutPutData.(Session_type{sess}).accelero.var(mouse,ind) = nanmean(movstd(log10(Data(OutPutData.(Session_type{sess}).accelero.tsd{mouse,ind})),ind));
        end
    end
end
    

for sess=1:length(Session_type)
    for mouse=1:length(Mouse)
        OutPutData.(Session_type{sess}).heartrate.mean(OutPutData.(Session_type{sess}).heartrate.mean==0)=NaN;
        OutPutData.(Session_type{sess}).heartrate.var(OutPutData.(Session_type{sess}).heartrate.var==0)=NaN;
        OutPutData.(Session_type{sess}).emg.mean(OutPutData.(Session_type{sess}).emg.mean==0)=NaN;
        OutPutData.(Session_type{sess}).emg.var(OutPutData.(Session_type{sess}).emg.var==0)=NaN;
        OutPutData.(Session_type{sess}).tailtemperature.mean(OutPutData.(Session_type{sess}).tailtemperature.mean==0)=NaN;
        OutPutData.(Session_type{sess}).tailtemperature.var(OutPutData.(Session_type{sess}).tailtemperature.var==0)=NaN;
        OutPutData.(Session_type{sess}).masktemperature.mean(OutPutData.(Session_type{sess}).masktemperature.mean==0)=NaN;
        OutPutData.(Session_type{sess}).masktemperature.var(OutPutData.(Session_type{sess}).masktemperature.var==0)=NaN;   
    end
end


for sess=1:length(Session_type)
    
    %% 1) Plot mean values
    figure
    subplot(261)
    MakeSpreadAndBoxPlot2_SB(OutPutData.(Session_type{sess}).heartrate.mean(:,5:6),Cols,X,Legends,'showpoints',0,'paired',1);
    ylabel('Frequency (Hz)'); title('Heart rate')
    
    subplot(262)
    MakeSpreadAndBoxPlot2_SB(OutPutData.(Session_type{sess}).respi_freq_bm.mean(:,5:6),Cols,X,Legends,'showpoints',0,'paired',1);
    ylabel('Frequency (Hz)'); title('Respiratory rate')
    
    subplot(263)
    MakeSpreadAndBoxPlot2_SB(OutPutData.(Session_type{sess}).tailtemperature.mean(:,5:6),Cols,X,Legends,'showpoints',0,'paired',1);
    ylabel('Temperature (°C)'); title('Tail temperature')
    
    subplot(264)
    MakeSpreadAndBoxPlot2_SB(OutPutData.(Session_type{sess}).masktemperature.mean(:,5:6),Cols,X,Legends,'showpoints',0,'paired',1);
    ylabel('Temperature (°C)'); title('Mask temperature')
    
    subplot(265)
    MakeSpreadAndBoxPlot2_SB(log(abs(OutPutData.(Session_type{sess}).emg.mean(:,5:6))),Cols,X,Legends,'showpoints',0,'paired',1);
    ylabel('(a.u.)'); title('EMG Power')
    
    subplot(266)
    MakeSpreadAndBoxPlot2_SB(log10(OutPutData.(Session_type{sess}).accelero.mean(:,5:6)),Cols,X,Legends,'showpoints',0,'paired',1);
    ylabel('(a.u.)'); title('Accelerometer')
    
    
    %% 2) Plot variability
    subplot(267)
    MakeSpreadAndBoxPlot2_SB(OutPutData.(Session_type{sess}).heartrate.var(:,5:6),Cols,X,Legends,'showpoints',0,'paired',1);
    ylabel('Variability'); ylim([0 0.4])
    
    subplot(268)
    MakeSpreadAndBoxPlot2_SB(OutPutData.(Session_type{sess}).respi_freq_bm.var(:,5:6),Cols,X,Legends,'showpoints',0,'paired',1);
    
    subplot(269)
    MakeSpreadAndBoxPlot2_SB(OutPutData.(Session_type{sess}).tailtemperature.var(:,5:6),Cols,X,Legends,'showpoints',0,'paired',1);
    
    OutPutData.(Session_type{sess}).masktemperature.var(6,5:6)=NaN;
    subplot(2,6,10)
    MakeSpreadAndBoxPlot2_SB(OutPutData.(Session_type{sess}).masktemperature.var(:,5:6),Cols,X,Legends,'showpoints',0,'paired',1);
    
    subplot(2,6,11)
    MakeSpreadAndBoxPlot2_SB(log(OutPutData.(Session_type{sess}).emg.var(:,5:6)),Cols,X,Legends,'showpoints',0,'paired',1);
    
    subplot(2,6,12)
    MakeSpreadAndBoxPlot2_SB(OutPutData.(Session_type{sess}).accelero.var(:,5:6),Cols,X,Legends,'showpoints',0,'paired',1);
    
    a=suptitle(['Somatic characterization, Saline, '  Session_type{sess} 'sessions, n = ' num2str(length(Mouse)) ]); a.FontSize=20;
end



%% spider chart
% for sess=1:length(Session_type)
%     for mouse=1:length(Mouse)
%         for states=5:6
%             try clear EMG_Filtered_Pre DataEMG_Filtered
%                 EMG_Filtered_Pre = FilterLFP(OutPutData.(Session_type{sess}).emg.tsd{mouse,states} , [50 300] , 1024);
%                 DataEMG_Filtered = log10(runmean(Data((EMG_Filtered_Pre)).^2,ceil(3/median(diff(Range(EMG_Filtered_Pre,'s'))))));
%                 EMG_Filtered.(Session_type{sess}){mouse,states} = tsd(Range(OutPutData.(Session_type{sess}).emg.tsd{mouse,states}) , DataEMG_Filtered);
%                 EMG_Filtered_Mean.(Session_type{sess})(mouse,states) = nanmean(Data(EMG_Filtered.(Session_type{sess}){mouse,states}));
%             end
%         end
%     end
%     EMG_Filtered_Mean.(Session_type{sess})(EMG_Filtered_Mean.(Session_type{sess})==0)=NaN;
%     EMG_Filtered_Mean.(Session_type{sess})(6,states)=NaN;
% end

OutPutData.(Session_type{sess}).tailtemperature.mean(length(Mouse),[5 6]) = NaN;
OutPutData.(Session_type{sess}).tailtemperature.mean(OutPutData.(Session_type{sess}).tailtemperature.mean==0)=NaN;
OutPutData.(Session_type{sess}).masktemperature.mean(length(Mouse),[5 6]) = NaN;
OutPutData.(Session_type{sess}).masktemperature.mean(OutPutData.(Session_type{sess}).masktemperature.mean==0)=NaN;

Var = {'heartrate','heartratevar','tailtemperature','emg_pect','accelero'};
for sess=3%1:length(Session_type)
    DATA_TO_PLOT.(Session_type{sess})(1,1,:) = (Freq_Max1-min([Freq_Max1 Freq_Max2]))/(max([Freq_Max1 Freq_Max2])-min([Freq_Max1 Freq_Max2]));
    DATA_TO_PLOT.(Session_type{sess})(1,2,:) = (Freq_Max2-min([Freq_Max1 Freq_Max2]))/(max([Freq_Max1 Freq_Max2])-min([Freq_Max1 Freq_Max2]));
    
    for var=1:length(Var)
        clear d; d=[OutPutData.(Session_type{sess}).(Var{var}).mean(:,5) OutPutData.(Session_type{sess}).(Var{var}).mean(:,6)];
        DATA_TO_PLOT.(Session_type{sess})(var+1,1,:) = (OutPutData.(Session_type{sess}).(Var{var}).mean(:,5)-min(d))/(max(d)-min(d));
        DATA_TO_PLOT.(Session_type{sess})(var+1,2,:) = (OutPutData.(Session_type{sess}).(Var{var}).mean(:,6)-min(d))/(max(d)-min(d));
    end
    DATA_TO_PLOT.(Session_type{sess})(DATA_TO_PLOT.(Session_type{sess})==0)=NaN;
end



opt_axes.Labels={'Heart rate','Respiratory rate','Tail temperature','Body temperature','Accelero','EMG power'};
opt_lines.Color = [1 .5 .5 ; .5 .5 1];
opt_lines.LineWidth = 2;
opt_area.err = 'sem';
opt_area.FaceAlpha=.35;
opt_area.Color = [1 .5 .5 ; .5 .5 1];

figure
subplot(221)
polygonplot_BM(DATA_TO_PLOT.Cond,opt_axes,opt_lines,opt_area);
makepretty
t=title('Cond'); t.Position=[0 1 0];
u=text(-1.5,-.7,'Mean values'); set(u,'FontSize',20,'FontWeight','bold','Rotation',90)
subplot(222)
polygonplot_BM(DATA_TO_PLOT.Ext,opt_axes,opt_lines,opt_area);
makepretty
t=title('Ext'); t.Position=[0 1 0];

subplot(223)
polygonplot_BM(DATA_TO_PLOT_var.Cond,opt_axes,opt_lines,opt_area);
makepretty
u=text(-1.5,-.7,'Variability'); set(u,'FontSize',20,'FontWeight','bold','Rotation',90)
subplot(224)
polygonplot_BM(DATA_TO_PLOT_var.Ext,opt_axes,opt_lines,opt_area);
makepretty

u=text(-2,-1.5,'---------------------------------------------------------------------------------------'); set(u,'FontSize',20,'Rotation',90)
u=text(-6,1.3,'----------------------------------------------------------------------------------------------------------------------------------------------------------'); set(u,'FontSize',20)




%% old method
for sess=1:length(Session_type)
    DATA_TO_PLOT_var.(Session_type{sess})(1,1,:) = (OutPutData.(Session_type{sess}).heartrate.var(:,5)-max(max(OutPutData.(Session_type{sess}).heartrate.var(:,5:6))))/nanstd([OutPutData.(Session_type{sess}).heartrate.var(:,5) ; OutPutData.(Session_type{sess}).heartrate.var(:,6)]);
    DATA_TO_PLOT_var.(Session_type{sess})(2,1,:) = (OutPutData.(Session_type{sess}).respi_freq_bm.var(:,5)-max(max(OutPutData.(Session_type{sess}).respi_freq_bm.var(:,5:6))))/nanstd([OutPutData.(Session_type{sess}).respi_freq_bm.var(:,5) ; OutPutData.(Session_type{sess}).respi_freq_bm.var(:,6)]);
    DATA_TO_PLOT_var.(Session_type{sess})(3,1,:) = (OutPutData.(Session_type{sess}).tailtemperature.var(:,5)-max(max(OutPutData.(Session_type{sess}).tailtemperature.var(:,5:6))))/nanstd([OutPutData.(Session_type{sess}).tailtemperature.var(:,5) ; OutPutData.(Session_type{sess}).tailtemperature.var(:,6)]);
    DATA_TO_PLOT_var.(Session_type{sess})(4,1,:) = (OutPutData.(Session_type{sess}).masktemperature.var(:,5)-max(max(OutPutData.(Session_type{sess}).masktemperature.var(:,5:6))))/nanstd([OutPutData.(Session_type{sess}).masktemperature.var(:,5) ; OutPutData.(Session_type{sess}).masktemperature.var(:,6)]);
    DATA_TO_PLOT_var.(Session_type{sess})(5,1,:) = (log(OutPutData.(Session_type{sess}).emg.var(:,5))-max(max(log(OutPutData.(Session_type{sess}).emg.var(:,5:6)))))/nanstd([log(OutPutData.(Session_type{sess}).emg.var(:,5)) ; log(OutPutData.(Session_type{sess}).emg.var(:,6))]);
    DATA_TO_PLOT_var.(Session_type{sess})(6,1,:) = (OutPutData.(Session_type{sess}).accelero.var(:,5)-max(max(OutPutData.(Session_type{sess}).accelero.var(:,5:6))))/nanstd([OutPutData.(Session_type{sess}).accelero.var(:,5) ; OutPutData.(Session_type{sess}).accelero.var(:,6)]);
    
    DATA_TO_PLOT_var.(Session_type{sess})(1,2,:) = (OutPutData.(Session_type{sess}).heartrate.var(:,6)-max(max(OutPutData.(Session_type{sess}).heartrate.var(:,5:6))))/nanstd([OutPutData.(Session_type{sess}).heartrate.var(:,5) ; OutPutData.(Session_type{sess}).heartrate.var(:,6)]);
    DATA_TO_PLOT_var.(Session_type{sess})(2,2,:) = (OutPutData.(Session_type{sess}).respi_freq_bm.var(:,6)-max(max(OutPutData.(Session_type{sess}).respi_freq_bm.var(:,5:6))))/nanstd([OutPutData.(Session_type{sess}).respi_freq_bm.var(:,5) ; OutPutData.(Session_type{sess}).respi_freq_bm.var(:,6)]);
    DATA_TO_PLOT_var.(Session_type{sess})(3,2,:) = (OutPutData.(Session_type{sess}).tailtemperature.var(:,6)-max(max(OutPutData.(Session_type{sess}).tailtemperature.var(:,5:6))))/nanstd([OutPutData.(Session_type{sess}).tailtemperature.var(:,5) ; OutPutData.(Session_type{sess}).tailtemperature.var(:,6)]);
    DATA_TO_PLOT_var.(Session_type{sess})(4,2,:) = (OutPutData.(Session_type{sess}).masktemperature.var(:,6)-max(max(OutPutData.(Session_type{sess}).masktemperature.var(:,5:6))))/nanstd([OutPutData.(Session_type{sess}).masktemperature.var(:,5) ; OutPutData.(Session_type{sess}).masktemperature.var(:,6)]);
    DATA_TO_PLOT_var.(Session_type{sess})(5,2,:) = (log(OutPutData.(Session_type{sess}).emg.var(:,6))-max(max(log(OutPutData.(Session_type{sess}).emg.var(:,5:6)))))/nanstd([log(OutPutData.(Session_type{sess}).emg.var(:,5)) ; log(OutPutData.(Session_type{sess}).emg.var(:,6))]);
    DATA_TO_PLOT_var.(Session_type{sess})(6,2,:) = (OutPutData.(Session_type{sess}).accelero.var(:,6)-max(max(OutPutData.(Session_type{sess}).accelero.var(:,5:6))))/nanstd([OutPutData.(Session_type{sess}).accelero.var(:,5) ; OutPutData.(Session_type{sess}).accelero.var(:,6)]);
    
    DATA_TO_PLOT_var.(Session_type{sess})(DATA_TO_PLOT_var.(Session_type{sess})==0)=NaN;
end

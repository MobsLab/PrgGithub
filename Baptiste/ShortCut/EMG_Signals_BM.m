
figure; mouse=3; state=1; sess=1;
subplot(311)
plot(DataEMG.(Session_type{sess}).(State1{state}).(Mouse_names{mouse}))
xlim([9e5 9.03e5]);
ylabel('amplitude (a.u.)'); title('raw signal'); makepretty
subplot(312)
plot(runmean_BM((DataEMG.(Session_type{sess}).(State1{state}).(Mouse_names{mouse})).^2,30));
xlim([9e5 9.03e5]);
ylabel('amplitude (a.u.)'); xlabel('time (a.u.)'); title('signal^2'); makepretty
subplot(313)
plot(runmean_BM((DataEMG.(Session_type{sess}).(State1{state}).(Mouse_names{mouse})).^2,30));
xlim([9e5 9.03e5]);
ylabel('amplitude (a.u.)'); xlabel('time (a.u.)'); title('log(signal^2)'); makepretty; set(gca, 'YScale', 'log');

for mouse=1:length(Mouse_names)
    for sess=1
        for state=1:length(State1)
            smooth_fact1 = ceil(0.025/median(diff(Range(EMG_Filtered_Pre.(Session_type{sess}).(State1{state}).(Mouse_names{mouse}),'s'))));
            smooth_fact2 = ceil(0.1/median(diff(Range(EMG_Filtered_Pre.(Session_type{sess}).(State1{state}).(Mouse_names{mouse}),'s'))));
            smooth_fact3 = ceil(1/median(diff(Range(EMG_Filtered_Pre.(Session_type{sess}).(State1{state}).(Mouse_names{mouse}),'s'))));
            smooth_fact4 = ceil(3/median(diff(Range(EMG_Filtered_Pre.(Session_type{sess}).(State1{state}).(Mouse_names{mouse}),'s'))));

            DataEMG_Filtered.(Session_type{sess}).(State1{state}).(Mouse_names{mouse})=runmean(Data((EMG_Filtered_Pre.(Session_type{sess}).(State1{state}).(Mouse_names{mouse}))).^2,smooth_fact1);
            DataEMG_Filtered2.(Session_type{sess}).(State1{state}).(Mouse_names{mouse})=runmean(Data((EMG_Filtered_Pre.(Session_type{sess}).(State1{state}).(Mouse_names{mouse}))).^2,smooth_fact2);
            DataEMG_Filtered3.(Session_type{sess}).(State1{state}).(Mouse_names{mouse})=runmean(Data((EMG_Filtered_Pre.(Session_type{sess}).(State1{state}).(Mouse_names{mouse}))).^2,smooth_fact3);
            DataEMG_Filtered4.(Session_type{sess}).(State1{state}).(Mouse_names{mouse})=runmean(Data((EMG_Filtered_Pre.(Session_type{sess}).(State1{state}).(Mouse_names{mouse}))).^2,smooth_fact4);            
        end
    end
end

figure; mouse=3; state=1; sess=1;
subplot(311)
plot(Range(EMG_Filtered_Pre.(Session_type{sess}).(State1{state}).(Mouse_names{mouse}),'s') , DataEMG.(Session_type{sess}).(State1{state}).(Mouse_names{mouse})); hold on
plot(Range(EMG_Filtered_Pre.(Session_type{sess}).(State1{state}).(Mouse_names{mouse}),'s') , Data(EMG_Filtered_Pre.(Session_type{sess}).(State1{state}).(Mouse_names{mouse}))); hold on
xlim([3e3 3.001e3]); makepretty
ylabel('amplitude (a.u.)'); legend('raw signal','filtered signal')
subplot(312)
plot(Range(EMG_Filtered_Pre.(Session_type{sess}).(State1{state}).(Mouse_names{mouse}),'s') , 1.5e3+DataEMG.(Session_type{sess}).(State1{state}).(Mouse_names{mouse})); hold on
plot(Range(EMG_Filtered_Pre.(Session_type{sess}).(State1{state}).(Mouse_names{mouse}),'s') , 1.5e3+Data(EMG_Filtered_Pre.(Session_type{sess}).(State1{state}).(Mouse_names{mouse}))); hold on
plot(Range(EMG_Filtered_Pre.(Session_type{sess}).(State1{state}).(Mouse_names{mouse}),'s') , Data((EMG_Filtered_Pre.(Session_type{sess}).(State1{state}).(Mouse_names{mouse}))).^2); hold on
xlim([3e3 3.005e3]); set(gca, 'YScale', 'log'); legend('raw signal','filtered signal','(filtered signal)^2')
ylabel('amplitude (a.u.)'); 
subplot(313)
plot(Range(EMG_Filtered_Pre.(Session_type{sess}).(State1{state}).(Mouse_names{mouse}),'s') , Data((EMG_Filtered_Pre.(Session_type{sess}).(State1{state}).(Mouse_names{mouse}))).^2); hold on
plot(Range(EMG_Filtered_Pre.(Session_type{sess}).(State1{state}).(Mouse_names{mouse}),'s') , DataEMG_Filtered.(Session_type{sess}).(State1{state}).(Mouse_names{mouse})); hold on
plot(Range(EMG_Filtered_Pre.(Session_type{sess}).(State1{state}).(Mouse_names{mouse}),'s') , DataEMG_Filtered2.(Session_type{sess}).(State1{state}).(Mouse_names{mouse})); hold on
plot(Range(EMG_Filtered_Pre.(Session_type{sess}).(State1{state}).(Mouse_names{mouse}),'s') , DataEMG_Filtered3.(Session_type{sess}).(State1{state}).(Mouse_names{mouse})); hold on
xlim([3e3 3.02e3]); makepretty; xlabel('time (s)')
legend('(filtered signal)^2','sliding window = 0.025s','sliding window = 0.1s','sliding window = 1s')
ylabel('power (a.u.)'); 


Prc=0; figure
for mouse=1%:length(Mouse) % if you want beautiful distrib figures make state=3:4
    %figure
    W1 = prctile(log10(DataEMG_Filtered.Fear.Fz.(Mouse_names{mouse})),Prc);
    W2 = prctile(log10(DataEMG_Filtered.Fear.Fz.(Mouse_names{mouse})),100-Prc);
    X1 = prctile(log10(DataEMG_Filtered2.Fear.Fz.(Mouse_names{mouse})),Prc);
    X2 = prctile(log10(DataEMG_Filtered2.Fear.Fz.(Mouse_names{mouse})),100-Prc);
    Y1 = prctile(log10(DataEMG_Filtered3.Fear.Fz.(Mouse_names{mouse})),Prc);
    Y2 = prctile(log10(DataEMG_Filtered3.Fear.Fz.(Mouse_names{mouse})),100-Prc);
    Z1 = prctile(log10(DataEMG_Filtered4.Fear.Fz.(Mouse_names{mouse})),Prc);
    Z2 = prctile(log10(DataEMG_Filtered4.Fear.Fz.(Mouse_names{mouse})),100-Prc);
    try
        subplot(511)
        for state=2:length(State1)
            h=histogram(log10(Data((EMG_Filtered_Pre.(Session_type{sess}).(State1{state}).(Mouse_names{mouse}))).^2),'BinLimits',[2 W2],'NumBins',200); hold on
        end
        subplot(512)
        for state=2:length(State1)
            h=histogram(log10(DataEMG_Filtered.Fear.(State1{state}).(Mouse_names{mouse})),'BinLimits',[W1 W2],'NumBins',200); hold on
        end
        subplot(513)
        for state=2:length(State1)
            h=histogram(log10(DataEMG_Filtered2.Fear.(State1{state}).(Mouse_names{mouse})),'BinLimits',[W1 W2],'NumBins',100); hold on
        end
        subplot(514)
        for state=2:length(State1)
            h=histogram(log10(DataEMG_Filtered3.Fear.(State1{state}).(Mouse_names{mouse})),'BinLimits',[W1 W2],'NumBins',100); hold on
        end
        subplot(515)
        for state=2:length(State1)
            h=histogram(log10(DataEMG_Filtered4.Fear.(State1{state}).(Mouse_names{mouse})),'BinLimits',[W1 W2],'NumBins',100); hold on
        end
    end
end



for mouse=1:length(Mouse_names)
    for sess=1
        for state=1:length(State1)
            
            clear DataToUse
            DataToUse = EMG_Filtered_Pre.(Session_type{sess}).(State1{state}).(Mouse_names{mouse});
            
            X_filt=Range(DataToUse); Y_filt=Data(DataToUse);
            t_smooth=1; %in seconds
            
            %Extract envelope
            f_filt = 1/(X_filt(2)-X_filt(1));
            [Y_env_up,~] = envelope(Y_filt);
            
            %Gaussian smoothing
            n = max(round(t_smooth*f_filt),1);
            Y_env = conv(Y_env_up,gausswin(n)/n,'same');
            
            % Subsampling envelope
            ftemp = 5/t_smooth;
            if ftemp < f_filt
                X_power = (X_filt(1):1/ftemp:X_filt(end))';
                Y_power = interp1(X_filt,Y_env,X_power);
            else
                X_power = X_filt;
                Y_power = Y_env;
            end
            
            Signal_Enveloppe.(Session_type{sess}).(State1{state}).(Mouse_names{mouse}) = Y_power;
        end
    end
end



figure
plot(Range(EMG_Filtered_Pre.(Session_type{sess}).(State1{state}).(Mouse_names{mouse}),'s') , Data((EMG_Filtered_Pre.(Session_type{sess}).(State1{state}).(Mouse_names{mouse}))).^2); hold on
plot(Range(EMG_Filtered_Pre.(Session_type{sess}).(State1{state}).(Mouse_names{mouse}),'s') , DataEMG_Filtered.(Session_type{sess}).(State1{state}).(Mouse_names{mouse})); hold on
plot(Range(EMG_Filtered_Pre.(Session_type{sess}).(State1{state}).(Mouse_names{mouse}),'s') , runmean(Signal_Enveloppe.(Session_type{sess}).(State1{state}).(Mouse_names{mouse}).^2,smooth_fact1)); hold on
xlim([3e3 3.02e3]); makepretty; xlabel('time (s)')
legend('(filtered signal)^2','sliding window = 0.025s','enveloppe')
ylabel('power (a.u.)');

figure
for mouse=1%:length(Mouse) % if you want beautiful distrib figures make state=3:4
    W1 = prctile(log10(runmean(Signal_Enveloppe.(Session_type{sess}).(State1{state}).(Mouse_names{mouse}).^2,smooth_fact1)),Prc);
    W2 = prctile(log10(runmean(Signal_Enveloppe.(Session_type{sess}).(State1{state}).(Mouse_names{mouse}).^2,smooth_fact1)),100-Prc);
    X1 = prctile(log10(DataEMG_Filtered.Fear.Fz.(Mouse_names{mouse})),Prc);
    X2 = prctile(log10(DataEMG_Filtered.Fear.Fz.(Mouse_names{mouse})),100-Prc);try
        subplot(211)
        for state=2:length(State1)
            h=histogram(log10(runmean(Signal_Enveloppe.(Session_type{sess}).(State1{state}).(Mouse_names{mouse}).^2,smooth_fact1)),'BinLimits',[W1 W2],'NumBins',200); hold on
            %h=histogram(log10(Data((EMG_Filtered_Pre.(Session_type{sess}).(State1{state}).(Mouse_names{mouse}))).^2),'BinLimits',[2 W2],'NumBins',200); hold on
        end
                subplot(212)
        for state=2:length(State1)
            h=histogram(log10(DataEMG_Filtered.Fear.(State1{state}).(Mouse_names{mouse})),'BinLimits',[X1 X2],'NumBins',200); hold on
        end
    end
end






%% Accelero values
clear all

cd(FearSess.(Mouse_names{mouse}){1})
load('B_Low_Spectrum.mat')
Session_type={'Fear','Cond','Ext','Sleep'};
State1={'Active','Fz','Fz_Shock','Fz_Safe'};
State2={'Active','Sleep','NREM','REM'};

Mouse=[829 851 858 859 1006 777 849];
% Mouse=[1184 1205 1224 1225 1226 1227];
[Data_to_use.Fear , Epoch1 , NameEpoch]=MeanValuesPhysiologicalParameters_BM(Mouse,'fear','emg','accelero','ob_low');
[Data_to_use.Sleep , Epoch2 , NameEpoch2]=MeanValuesPhysiologicalParameters_BM(Mouse,'slmz','emg','accelero','ob_low');

for mouse=1:length(Mouse)
    Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
end

ind=[4 3 5 6]; ind2=[2:5]; % indices for corresponding Epoch, cf NameEpoch and NameEpoch2
% Calculating data for each mouse
for mouse=1:length(Mouse_names)
    sess=1;
    for state=1:length(State1)
        DataEMG.(Session_type{sess}).(State1{state}).(Mouse_names{mouse})=Data(Data_to_use.(Session_type{sess}).emg.tsd{mouse,ind(state)}); DataEMG.(Session_type{sess}).(State1{state}).(Mouse_names{mouse})(DataEMG.(Session_type{sess}).(State1{state}).(Mouse_names{mouse})==0)=NaN;
        DataAcc.(Session_type{sess}).(State1{state}).(Mouse_names{mouse})=Data(Data_to_use.(Session_type{sess}).accelero.tsd{mouse,ind(state)}); DataAcc.(Session_type{sess}).(State1{state}).(Mouse_names{mouse})(DataAcc.(Session_type{sess}).(State1{state}).(Mouse_names{mouse})==0)=NaN;
        Respi_Rythm.(Session_type{sess}).(State1{state}).(Mouse_names{mouse})=ConvertSpectrum_in_Frequencies_BM(Spectro{3} , Range(Data_to_use.(Session_type{sess}).ob_low.tsd{mouse,ind(state)}) , Data(Data_to_use.(Session_type{sess}).ob_low.tsd{mouse,ind(state)}));
        Respi_Rythm2.(Session_type{sess}).(State1{state}).(Mouse_names{mouse})=interp1(Range(Respi_Rythm.(Session_type{sess}).(State1{state}).(Mouse_names{mouse})) , Data(Respi_Rythm.(Session_type{sess}).(State1{state}).(Mouse_names{mouse})) , Range(Data_to_use.(Session_type{sess}).emg.tsd{mouse,ind(state)}));
    end
    sess=4;
    for state=1:length(State2)
        DataEMG.(Session_type{sess}).(State2{state}).(Mouse_names{mouse})=Data(Data_to_use.Sleep.emg.tsd{mouse,ind2(state)}); DataEMG.(Session_type{sess}).(State2{state}).(Mouse_names{mouse})(DataEMG.(Session_type{sess}).(State2{state}).(Mouse_names{mouse})==0)=NaN;
        DataAcc.(Session_type{sess}).(State2{state}).(Mouse_names{mouse})=Data(Data_to_use.Sleep.accelero.tsd{mouse,ind2(state)}); DataAcc.(Session_type{sess}).(State2{state}).(Mouse_names{mouse})(DataAcc.(Session_type{sess}).(State2{state}).(Mouse_names{mouse})==0)=NaN;
        Respi_Rythm.(Session_type{sess}).(State2{state}).(Mouse_names{mouse})=ConvertSpectrum_in_Frequencies_BM(Spectro{3} , Range(Data_to_use.(Session_type{sess}).ob_low.tsd{mouse,ind2(state)}) , Data(Data_to_use.(Session_type{sess}).ob_low.tsd{mouse,ind2(state)}));
        Respi_Rythm2.(Session_type{sess}).(State2{state}).(Mouse_names{mouse})=interp1(Range(Respi_Rythm.(Session_type{sess}).(State2{state}).(Mouse_names{mouse})) , Data(Respi_Rythm.(Session_type{sess}).(State2{state}).(Mouse_names{mouse})) , Range(Data_to_use.(Session_type{sess}).emg.tsd{mouse,ind2(state)}));
    end
    disp(Mouse_names{mouse})
end



%% Gathering data
% Unfiltered data
for mouse=1:length(Mouse)
    for sess=1
        Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
        for state=1:length(State1)
            try
                MeanAcc.(Session_type{sess}).(State1{state})(mouse)=nanmean((DataAcc.(Session_type{sess}).(State1{state}).(Mouse_names{mouse})));
            catch
                MeanAcc.(Session_type{sess}).(State1{state})(mouse)=NaN;
            end
        end
    end
    for sess=4
        for state=1:length(State2)
            try
                MeanAcc.(Session_type{sess}).(State2{state})(mouse)=nanmean((DataAcc.(Session_type{sess}).(State2{state}).(Mouse_names{mouse})));
            catch
                MeanAcc.(Session_type{sess}).(State2{state})(mouse)=NaN;
            end
        end
    end
end


%% Figures
%Differents signals aspect
Cols = {[0.3 0.3 0.3],[0.7 0.7 0.7],[0 0 0],[1 0.5 0.5],[0.5 0.5 1]};
X = [1,2,3,4,5];
Legends = {'Active','Sleep','Freezing','Shock','Safe'};
NoLegends = {'','','','',''};
%Mean
figure
subplot(121)
MakeSpreadAndBoxPlot2_SB({MeanAcc.Fear.Active , MeanAcc.Sleep.Sleep , MeanAcc.Fear.Fz , MeanAcc.Fear.Fz_Shock , MeanAcc.Fear.Fz_Safe},Cols,X,Legends,'showpoints',0,'paired',1); makepretty; xtickangle(45);
ylabel('Movement quantity (a.u.)'); a=text(-1,2e5,'Raw data','FontSize',20,'FontWeight','bold'); set(a,'Rotation',90)
set(gca, 'YScale', 'log'); ylim([3e6 1e8]); title('UMaze analysis')
subplot(122)
MakeSpreadAndBoxPlot2_SB({MeanAcc.Sleep.Active , MeanAcc.Sleep.Sleep , MeanAcc.Sleep.NREM , MeanAcc.Sleep.REM},{[0 0 1],[0.3 0.3 0.3],[1 0 0],[0 1 0]},[1:4],{'Wake','Sleep','NREM','REM'},'showpoints',0,'paired',1); makepretty; xtickangle(45);
set(gca, 'YScale', 'log'); ylim([3e6 1e8]); title('Sleep analysis')

a=suptitle('Mean accelero values analysis'); a.FontSize=20;

colo_multi = {[0.3 0.3 0.3],[0 0 0],[1 0.5 0.5],[0.5 0.5 1],[0 0 1],[0.3 0.3 0.3],[1 0 0],[0 1 0]};
figure; clear MeanAcc_All MeanEMG_Filtered_All; MeanAcc_All=[]; MeanEMG_Filtered_All=[];
for state=1:4
   plot(MeanAcc.Fear.(State1{state}) , MeanEMG_Filtered.Fear.(State1{state}), 'LineStyle','none','Marker','.','Color',colo_multi{state},'MarkerSize',20); hold on
   MeanAcc_All = [MeanAcc_All ; MeanAcc.Fear.(State1{state})']; MeanEMG_Filtered_All = [MeanEMG_Filtered_All ; MeanEMG_Filtered.Fear.(State1{state})'];
end
for state=1:4
   plot(MeanAcc.Sleep.(State2{state}) , MeanEMG_Filtered.Sleep.(State2{state}), 'LineStyle','none', 'Marker','.','Color',colo_multi{state+4},'MarkerSize',20); hold on
   MeanAcc_All = [MeanAcc_All ; MeanAcc.Sleep.(State2{state})']; MeanEMG_Filtered_All = [MeanEMG_Filtered_All ; MeanEMG_Filtered.Sleep.(State2{state})'];
end
set(gca, 'YScale', 'log'); set(gca, 'XScale', 'log');
makepretty; xlabel('accelero values'); ylabel('emg filtered values')
legend('Active','Freezing','Shock','Safe','Wake','Sleep','NREM','REM')
p=polyfit( log(MeanAcc_All) , log(MeanEMG_Filtered_All) ,1);
x=[2e6:1e6:1e8]; y=exp(log(x).*p(1)+p(2)); plot(x,y,'r','LineWidth',2)



sess=1; % correct where respi is nan
for mouse=1:length(Mouse) 
    for state=2:length(State1)
        Log_to_use = ~isnan(Respi_Rythm_Acc.Fear.(State1{state}).(Mouse_names{mouse}));
        Respi_Rythm_Acc.Fear.(State1{state}).(Mouse_names{mouse}) = Respi_Rythm_Acc.Fear.(State1{state}).(Mouse_names{mouse})(Log_to_use);
        DataAcc.Fear.(State1{state}).(Mouse_names{mouse})=DataAcc.Fear.(State1{state}).(Mouse_names{mouse})(Log_to_use);
    end
end

Prc=1; 
for mouse=1:length(Mouse) % if you want beautiful distrib figures make state=3:4
    %figure
    Y1 = prctile(log10(DataAcc.Fear.Fz.(Mouse_names{mouse})),Prc);
    Y2 = prctile(log10(DataAcc.Fear.Fz.(Mouse_names{mouse})),100-Prc);
    Z1 = prctile(Respi_Rythm_Acc.Fear.Fz.(Mouse_names{mouse}),Prc);
    Z2 = prctile(Respi_Rythm_Acc.Fear.Fz.(Mouse_names{mouse}),100-Prc);
    try
        for state=2:length(State1)
            h=histogram(log10(DataAcc.Fear.(State1{state}).(Mouse_names{mouse})),'BinLimits',[Y1 Y2],'NumBins',100); hold on
            HistData_Acc.(Session_type{sess}).(State1{state}).(Mouse_names{mouse})=h.Values;
            Logical_to_use = and(and(log10(DataAcc.Fear.(State1{state}).(Mouse_names{mouse}))<Y2 , log10(DataAcc.Fear.(State1{state}).(Mouse_names{mouse}))>Y1) , and(Respi_Rythm_Acc.Fear.(State1{state}).(Mouse_names{mouse})<Z2 , Respi_Rythm_Acc.Fear.(State1{state}).(Mouse_names{mouse})>Z1));
            
            Clean_DataAcc.(Session_type{sess}).(State1{state}).(Mouse_names{mouse})=DataAcc.Fear.(State1{state}).(Mouse_names{mouse})(Logical_to_use);
            Clean_Respi_Rythm_Acc.(Session_type{sess}).(State1{state}).(Mouse_names{mouse})=Respi_Rythm_Acc.Fear.(State1{state}).(Mouse_names{mouse})(Logical_to_use);
        end
    end
end

Mouse=[829 851 858 859 1006 777 849];
for mouse=1:length(Mouse)
        for state=2:length(State1)
        Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
        
        HistData_Acc_All.(Session_type{sess}).(State1{state})(mouse,:) = HistData_Acc.(Session_type{sess}).(State1{state}).(Mouse_names{mouse})/sum(HistData_Acc.(Session_type{sess}).(State1{state}).(Mouse_names{mouse}));
    end
end


figure
Conf_Inter=nanstd(HistData_Acc_All.Fear.Fz)/sqrt(size(HistData_Acc_All.Fear.Fz,1));
shadedErrorBar([1:100],runmean(nanmean(HistData_Acc_All.Fear.Fz),3)*2,Conf_Inter,'k',1); hold on;
Conf_Inter=nanstd(HistData_Acc_All.Fear.Fz_Shock)/sqrt(size(HistData_Acc_All.Fear.Fz_Shock,1));
shadedErrorBar([1:100],runmean(nanmean(HistData_Acc_All.Fear.Fz_Shock),3),Conf_Inter,'r',1);
Conf_Inter=nanstd(HistData_Acc_All.Fear.Fz_Safe)/sqrt(size(HistData_Acc_All.Fear.Fz_Safe,1));
shadedErrorBar([1:100],runmean(nanmean(HistData_Acc_All.Fear.Fz_Safe),3),Conf_Inter,'b',1);
makepretty;
f=get(gca,'Children'); legend([f(9),f(5),f(1)],'All fz','Fz shock','Fz safe');
xlabel('accelero values (a.u.)'); ylabel('%');
title('Accelero values distribution, UMaze, saline-like, n=7')



%% Correlation OB frequency - EMG values
for mouse=1:length(Mouse) % zscoring from data all freezing
    for state=2:4
        LogZscoredClean_DataAcc.Fear.(State1{state}).(Mouse_names{mouse}) = (log10(Clean_DataAcc.Fear.(State1{state}).(Mouse_names{mouse}))-nanmean(log10(Clean_DataAcc.Fear.(State1{2}).(Mouse_names{mouse}))))/nanstd(log10(Clean_DataAcc.Fear.(State1{2}).(Mouse_names{mouse})));
    end
end

bin=50; mouse=1;
colo={'.r','.b'}; colo2={'r','b'}; 

figure
plot(LogZscoredClean_DataAcc.Fear.(State1{2}).(Mouse_names{mouse})(bin:bin:end) , Clean_Respi_Rythm_Acc.Fear.(State1{2}).(Mouse_names{mouse})(bin:bin:end),'.k','MarkerSize',10)
hold on; makepretty
xlabel('Accelero power (a.u.)'); 
ylabel('OB frequency (Hz)')
[R , P]=corrcoef_BM(LogZscoredClean_DataAcc.Fear.(State1{2}).(Mouse_names{mouse}) , Clean_Respi_Rythm_Acc.Fear.(State1{2}).(Mouse_names{mouse}));
p=polyfit( LogZscoredClean_DataAcc.Fear.(State1{2}).(Mouse_names{mouse})(bin:bin:end) , Clean_Respi_Rythm_Acc.Fear.(State1{2}).(Mouse_names{mouse})(bin:bin:end) ,1);
x=[-1.8:0.2:1.8]; y=x.*p(1)+p(2); plot(x,y,'r','LineWidth',2)
t=text(-3,8,['R = ' num2str(R(2,1)) '     P = ' num2str(P(2,1))]); t.FontSize=20;
title('OB frequency and accelero values relations during freezing')

bin=5;
for mouse=1:length(Mouse)
    %figure
    for state=2:4
        X_to_use = LogZscoredClean_DataAcc.Fear.(State1{state}).(Mouse_names{mouse})(bin:bin:end);
        Y_to_use = Clean_Respi_Rythm_Acc.Fear.(State1{state}).(Mouse_names{mouse})(bin:bin:end);
        %plot(X_to_use,Y_to_use,colo{state-2})
        hold on
        Ellipse.(State1{state}).(Mouse_names{mouse}) = Ellipse_From_Data_BM(X_to_use,Y_to_use);
    end
%     makepretty
%     title(Mouse_names{mouse})
%     xlabel('EMG power (a.u.)'); %ylim([0 8])
%     ylabel('OB frequency (Hz)')
%     legend('Shock side freezing','Safe side freezing')
end

figure
for mouse=1:length(Mouse)
    for state=3:4
        plot(Ellipse.(State1{state}).(Mouse_names{mouse})(:,1),Ellipse.(State1{state}).(Mouse_names{mouse})(:,2),colo2{state-2},'LineWidth',5)
        hold on
        EllipseX_All.(State1{state})(mouse,:) = Ellipse.(State1{state}).(Mouse_names{mouse})(:,1);
        EllipseY_All.(State1{state})(mouse,:) = Ellipse.(State1{state}).(Mouse_names{mouse})(:,2);        
    end
    makepretty
    title('n=7')
    xlabel('Accelero values (a.u.)'); %ylim([0 8])
    ylabel('OB frequency (Hz)')
    legend('Shock side freezing','Safe side freezing')
end


figure
for state=3:4
    Conf_Inter=nanstd(EllipseY_All.(State1{state}))/sqrt(size(EllipseY_All.(State1{state}),1));
    shadedErrorBar(nanmean(EllipseX_All.(State1{state})) , nanmean(EllipseY_All.(State1{state})),Conf_Inter,colo2{state-2},1); hold on;
end
xlabel('EMG power (a.u.)'); ylabel('OB frequency (Hz)')
makepretty
f=get(gca,'Children'); legend([f(5),f(1)],'Fz shock','Fz safe');
















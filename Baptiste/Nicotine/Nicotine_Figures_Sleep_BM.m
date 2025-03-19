
EpochName = {'Beginning','Just_Bef_Inj','Just_Aft_Inj','SleepPre','SleepPost','First_Sleep_Aft_Inj','FreezeAccEpoch','MovingEpoch'};

% plot parameters
Cols = {[.4 .4 .4],[.2 .8 .2]};
X = [1 2];
Legends = {'Saline','Nicotine'};
NoLegends = {'',''};

Cols2={'k','g'};

% corrections
RipDensity_mean.Just_Aft_Inj(1,3) = NaN;
for epoch=1:length(EpochName)
    Mean_Ripples.(EpochName{epoch})(2,5,:)=NaN;
end

HPC_VHigh_OnRipples.(EpochName{3}){2}(5,:)=NaN;
HPC_VHigh_OnRipples.(EpochName{3}){1}(3,:)=NaN;

%% Figures
% nicotine induces freezing
figure
subplot(161)
bar([sum(FreezeTime.Just_Aft_Inj{1}~=0)/length(FreezeTime.Just_Aft_Inj{1}) sum(FreezeTime.Just_Aft_Inj{4}~=0)/length(FreezeTime.Just_Aft_Inj{4})])
xticklabels(Legends), xtickangle(45)
ylabel('mice proportion')
title('mice freezing after injection')
ylim([0 1.1])
box off

subplot(162)
MakeSpreadAndBoxPlot3_SB({FreezeTime.Just_Aft_Inj{1}*60 FreezeTime.Just_Aft_Inj{4}*60},Cols,X,Legends,'showpoints',1,'paired',0);
ylabel('time (s)')
title('time spent freezing')

subplot(1,6,3:5)
[h , MaxPowerValues] = Plot_MeanSpectrumForMice_BM(squeeze(OB_Low.(EpochName{7}){4}) , 'color',[0 .8 0]);
% Plot_MeanSpectrumForMice_BM(squeeze(OB_Low.(EpochName{7}){1}) , 'color',[.3 .3 .3])
xlim([0 10])
f=get(gca,'Children'); l=legend([f(4)],'Nicotine');
box off
title('Mean OB spectrum during freezing')

subplot(166)
MakeSpreadAndBoxPlot4_SB(RipDensity_mean.FreezeAccEpoch(4),{[0 .8 0]},1,{'Nicotine'},'showpoints',1,'paired',0);
ylim([0 .5]), ylabel('ripples occurency (#/s)')
title('Ripples density during freezing')

a=suptitle('Freezing features after nicotine injction, n=8'); a.FontSize=20;


%% Mean spectrum
figure; ep=7;
% OB Low
subplot(151)
Plot_MeanSpectrumForMice_BM(squeeze(OB_Low.(EpochName{ep}){1}) , 'color','k');
Plot_MeanSpectrumForMice_BM(squeeze(OB_Low.(EpochName{ep}){4}) , 'color','g','threshold',26);
f=get(gca,'Children'); legend([f(8),f(4)],'Saline','Nicotine');
xlim([0 12]), ylabel('Power (a.u.)'), ylim([0 1.6]), xlabel('Frequency (Hz)')
title('OB Low')

% HPC Low
subplot(152)
Plot_MeanSpectrumForMice_BM(squeeze(HPC_Low.(EpochName{ep}){1}) , 'color','k','threshold',52);
Plot_MeanSpectrumForMice_BM(squeeze(HPC_Low.(EpochName{ep}){4}) , 'color','g','threshold',52);
xlim([0 12]), ylim([0 1.6]), xlabel('Frequency (Hz)')
title('HPC Low')

% PFC Low
subplot(153)
Plot_MeanSpectrumForMice_BM(squeeze(PFC_Low.(EpochName{ep}){1}) , 'color','k','threshold',26);
Plot_MeanSpectrumForMice_BM(squeeze(PFC_Low.(EpochName{ep}){4}) , 'color','g','threshold',26);
xlim([0 12]), ylim([0 1.6]), xlabel('Frequency (Hz)')
title('PFC Low')

% HPC VHigh
subplot(154)
Plot_MeanSpectrumForMice_BM(squeeze(HPC_VHigh_OnRipples.(EpochName{ep}){1}) , 'color','k');
Plot_MeanSpectrumForMice_BM(squeeze(HPC_VHigh_OnRipples.(EpochName{ep}){4}) , 'color','g');
xlim([60 250]), ylim([0 1.6]), xlabel('Frequency (Hz)')
title('HPC VHigh')

% OB High
subplot(155)
Plot_MeanSpectrumForMice_BM(squeeze(OB_High.(EpochName{ep}){1}) , 'color','k');
Plot_MeanSpectrumForMice_BM(squeeze(OB_High.(EpochName{ep}){4}) , 'color','g');
xlim([20 100]), ylim([0 1.6]), xlabel('Frequency (Hz)')
title('OB High')

a=suptitle('Mean spectrums, +15min'); a.FontSize=20;



%% Physio temporal evolution
Cols={'-k','','','-g'};

figure, epoch=3;
for var = 1:5
    if var==1; DATA = Speed_evol;
    elseif var==2; DATA = Acc_evol;
    elseif var==3; DATA = HR_evol;
    elseif var==4; DATA = EMG_evol;
    elseif var==5; DATA = Respi_evol;
    end
    
    subplot(2,3,var)
    for drug=[1 4]
        Data_to_use = squeeze(DATA.(EpochName{epoch}){drug});
        Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
        shadedErrorBar(linspace(0,time_aft_inj,interp_value) , runmean(nanmean(Data_to_use),10) , runmean(Conf_Inter,10) , Cols2{drug} , 1); hold on;
    end
    xlim([0 time_aft_inj]); xlabel('time (min)');
    
    if and(var==1,epoch==3); ylabel('speed (cm/s)'); title('Speed'); f=get(gca,'Children'); legend([f(8),f(4)],'Saline','Nicotine'); end
    if and(var==2,epoch==3); ylabel('movement quantity (a.u.)'); title('Accelerometer'); end
    if and(var==3,epoch==3); ylabel('frequency (Hz)'); title('Heart rate'); end
    if and(var==4,epoch==3); ylabel('power (a.u.)'); title('EMG activity'); end
    if and(var==5,epoch==3); title('Speed');  end
end


figure
for var = 1:5
    for epoch = 3%1:4
        if var==1; DATA = Speed_evol;
        elseif var==2; DATA = Acc_evol;
        elseif var==3; DATA = HR_evol;
        elseif var==4; DATA = EMG_evol;
        elseif var==5; DATA = Respi_evol;
        end            
        
        subplot(1,5,var)
        for drug=1:2
            Data_to_use = squeeze(DATA.(EpochName{epoch})(drug,:,:));
            Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
            shadedErrorBar(linspace(0,time_aft_inj,1000) , runmean(nanmean(Data_to_use),10) , runmean(Conf_Inter,10) , Cols2{drug} , 1); hold on;
        end
%         if var==1; ylim([5.2 7.3]);
%         elseif var==2; ylim([15.4 19]);
%         elseif var==3; ylim([0 5]);
%         elseif var==4; ylim([5 13.5]);
%         elseif var==5; ylim([0 1]); end
        if and(var==1,epoch==1); title('evolution after injection'); f=get(gca,'Children'); legend([f(8),f(4)],'Saline','Nicotine'); end
        if and(var==1,epoch==1); ylabel('power (a.u.)'); t=text(-2,5.2,'OB gamma power'); set(t,'FontSize',15,'Rotation',90,'FontWeight','bold'); end
        if and(var==2,epoch==1); ylabel('movement quantity (log scale)'); t=text(-2,15.4,'Accelerometer'); set(t,'FontSize',15,'Rotation',90,'FontWeight','bold'); end
        if and(var==1,epoch==3); ylabel('speed (cm/s)'); t=text(-2,1,'Speed'); set(t,'FontSize',15,'Rotation',90,'FontWeight','bold'); end
        if and(var==4,epoch==1); ylabel('frequency (Hz)'); t=text(-2,6,'Heart rate'); set(t,'FontSize',15,'Rotation',90,'FontWeight','bold'); end
        if and(var==5,epoch==1); ylabel('density (#/s)'); t=text(-2,.1,'Rip density'); set(t,'FontSize',15,'Rotation',90,'FontWeight','bold'); end
%         if and(var==1,epoch==1); title('5 min Wake'); end
%         if and(var==1,epoch==2); title('5 min Sleep'); end
%         if and(var==1,epoch==3); title('Before injection'); end
%         if and(var==1,epoch==4); title('After injection'); end
        if var==5; xlabel('time (min)'); end
    end
end



figure, epoch=3;
for var = 1:2
    if var==1; DATA = Gamma_evol;
    elseif var==2; DATA = RipDensity_evol;
    end
    
    subplot(1,2,var)
    for drug=1:2
        Data_to_use = squeeze(DATA.(EpochName{epoch}){drug});
        Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
        shadedErrorBar(linspace(0,time_aft_inj,interp_value) , runmean(nanmean(Data_to_use),10) , runmean(Conf_Inter,10) , Cols2{drug} , 1); hold on;
    end
    xlim([0 time_aft_inj]); xlabel('time (min)');
    
    if and(var==1,epoch==3); ylabel('power (log scale)'); title('Gamma'); f=get(gca,'Children'); legend([f(8),f(4)],'Saline','Nicotine'); end
    if and(var==2,epoch==3); ylabel('density (#/s)'); title('Rip density'); end
end




%% For KB
% Figure 1: Nicotine increase ripples 
figure
subplot(131)
a=PlotErrorBarN_KJ(RipDensity_mean.Just_Aft_Inj','barcolors',Cols,'newfig',0,'showPoints',0); makepretty
xticks([1 2]), xticklabels({'Saline','Nicotine'}), xtickangle(45)
ylabel('#/s')
a=title('Ripples density'); a.FontSize=12;
ylim([0 .2])


subplot(243)
Data_to_use = squeeze(Mean_Ripples.(EpochName{4})(1,:,:));
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
h=shadedErrorBar(linspace(-50,50,size(Data_to_use,2)) , nanmean(Data_to_use) , Conf_Inter , 'k' , 1); hold on;
ylim([-1500 1500])
ylabel('amplitude (a.u.)'), a=title('Sleep Pre'); a.FontSize=12;
t=text(-100,-5e2,'Saline'); set(t,'FontSize',15,'Rotation',90,'FontWeight','bold');

subplot(244)
Data_to_use = squeeze(Mean_Ripples.(EpochName{5})(1,:,:));
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
h=shadedErrorBar(linspace(-50,50,size(Data_to_use,2)) , nanmean(Data_to_use) , Conf_Inter , 'k' , 1); hold on;
ylim([-1500 1500]), a=title('Sleep Post'); a.FontSize=12;

% nic
subplot(247)
Data_to_use = [squeeze(Mean_Ripples.(EpochName{4})(2,[1 3],:)) ; squeeze(Mean_Ripples.(EpochName{4})(1,1,:))'];
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
h=shadedErrorBar(linspace(-50,50,size(Data_to_use,2)) , nanmean(Data_to_use) , Conf_Inter , 'g' , 1); hold on;
ylim([-2000 500])
ylabel('amplitude (a.u.)'), xlabel('time (ms)')
t=text(-100,-1.5e3,'Nicotine'); set(t,'FontSize',15,'Rotation',90,'FontWeight','bold');

subplot(248)
Data_to_use = squeeze(Mean_Ripples.(EpochName{5})(2,:,:));
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
h=shadedErrorBar(linspace(-50,50,size(Data_to_use,2)) , nanmean(Data_to_use) , Conf_Inter , 'g' , 1); hold on;
ylim([-2000 500])
xlabel('time (ms)')

a=suptitle('Nicotine increases ripples density, +15 min, Wake, IP injection'); a.FontSize=20;



% Figure 2: Nicotine induces safe side freezing
figure
subplot(141)
a=PlotErrorBarN_KJ(FreezeTime.Just_Aft_Inj','barcolors',Cols,'newfig',0,'showPoints',0); makepretty
xticks([1 2]), xticklabels({'Saline','Nicotine'}), xtickangle(45), ylim([-.1 4.5])
ylabel('time (min)')
a=title('Time spent freezing'); a.FontSize=12;

Mouse_List=[1385 1386 1391 1393 1394];
[OB_Low_Spec] = Get_Freezing_MeanSpectrums_BM(Mouse_List);
cd('/media/nas6/ProjetEmbReact/Mouse1161/20210126/ProjectEmbReact_M1161_20210126_Habituation_PreDrug/Hab1')
load('B_Low_Spectrum.mat')

[Respi.Ext , Epoch1.Ext , NameEpoch] = MeanValuesPhysiologicalParameters_BM(Mouse_List,'ext','respi_freq_bm');
A=[2.899 4.196 4.807 4.883 3.891 ; 2.899 2.747 3.815 2.518 2.823 ; 3.357 NaN 4.807 2.823 2.594];

subplot(242)
Plot_MeanSpectrumForMice_BM(OB_Low_Spec.Shock.Nicotine.Ext , 'color' , 'r')
Plot_MeanSpectrumForMice_BM(OB_Low_Spec.Safe.Nicotine.Ext , 'color' , 'b')
xlim([0 8]), ylim([0 1.2]), xticks([1:8])
xlabel('Frequency (Hz)'), ylabel('Power (a.u.)')
f=get(gca,'Children'); a=legend([f(8),f(4)],'Shock Freezing','Safe Freezing'); a.FontSize=12;
a=title('Mean spectrum'); a.FontSize=12;
makepretty

subplot(243)
Plot_MeanSpectrumForMice_BM(squeeze(OB_Low.(EpochName{3})(2,[1 3:5],:)) , 'color' , 'g' , 'thr',26)
xlim([0 8]), ylim([0 1.2]), xticks([1:8]), makepretty, xlabel('Frequency (Hz)')
vline(2.824,'--g'), vline(3.053,'--b'), vline(4.351,'--r')
f=get(gca,'Children'); a=legend(f(4),'Nicotine freezing'); a.FontSize=12;
a=title('OB mean spectrum'), a.FontSize=12;

subplot(244)
PlotErrorBarN_KJ(A','barcolors',{[1 .5 .5],[.5 .5 1],[.2 .8 .2]},'newfig',0,'showPoints',0); makepretty
xticks([1 2 3]), xticklabels({'Shock freezing','Shock freezing','Nicotine freezing'}), xtickangle(45), ylim([2.6 4.5])
ylabel('Frequency (Hz)')
a=title('Mean OB frequency'), a.FontSize=12;

subplot(246)
PlotErrorBarN_KJ(FreezeTime.Just_Aft_Inj'./15,'barcolors',Cols,'newfig',0,'showPoints',0); makepretty
xticks([1 2]), xticklabels({'Saline','Nicotine'}), xtickangle(45), ylim([-.1 .6]), ylabel('proportion')
a=title('Freezing proportion'), a.FontSize=12;

subplot(247)
PlotErrorBarN_KJ((RipDensity_numb.FreezeAccEpoch./RipDensity_numb.Just_Aft_Inj)','barcolors',Cols,'newfig',0,'showPoints',0); makepretty
xticks([1 2]), xticklabels({'Saline','Nicotine'}), xtickangle(45), ylim([-.1 .6])
a=title('Ripples proportion during freezing'), a.FontSize=12;


a=suptitle('Nicotine induces freezing, +15 min, Wake, IP injection'); a.FontSize=20;



%% Saline injection effect, SB


figure, drug=1;
subplot(321)
epoch=2;
Data_to_use = squeeze(Acc_evol.(EpochName{epoch}){drug});
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
shadedErrorBar(linspace(0,time_aft_inj,interp_value) , runmean(nanmean(Data_to_use),10) , runmean(Conf_Inter,10) , Cols2{drug} , 1); hold on;
ylim([15.5 18.8])
ylabel('Movement quantity (a.u.)'), title('Before injection')
t=text(-2,16,'Accelerometer'); set(t,'FontSize',15,'Rotation',90,'FontWeight','bold');

subplot(322)
epoch=3;
Data_to_use = squeeze(Acc_evol.(EpochName{epoch}){drug});
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
shadedErrorBar(linspace(0,time_aft_inj,interp_value) , runmean(nanmean(Data_to_use),10) , runmean(Conf_Inter,10) , Cols2{drug} , 1); hold on;
ylim([15.5 18.8])


subplot(323)
epoch=2;
Data_to_use = squeeze(HR_evol.(EpochName{epoch}){drug});
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
shadedErrorBar(linspace(0,time_aft_inj,interp_value) , runmean(nanmean(Data_to_use),10) , runmean(Conf_Inter,10) , Cols2{drug} , 1); hold on;
ylim([7 12.5])
ylabel('Frequency (Hz)'), title('After injection')
t=text(-2,8,'Heart rate'); set(t,'FontSize',15,'Rotation',90,'FontWeight','bold');

subplot(324)
epoch=3;
Data_to_use = squeeze(HR_evol.(EpochName{epoch}){drug});
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
shadedErrorBar(linspace(0,time_aft_inj,interp_value) , runmean(nanmean(Data_to_use),10) , runmean(Conf_Inter,10) , Cols2{drug} , 1); hold on;
ylim([7 12.5])


subplot(325)
epoch=2;
Data_to_use = squeeze(Respi_evol.(EpochName{epoch}){drug});
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
shadedErrorBar(linspace(0,time_aft_inj,interp_value) , runmean(nanmean(Data_to_use),10) , runmean(Conf_Inter,10) , Cols2{drug} , 1); hold on;
ylim([3 8.5])
xlabel('time (s)'), ylabel('Frequency (Hz)')
t=text(-2,4,'Breathing'); set(t,'FontSize',15,'Rotation',90,'FontWeight','bold');

subplot(326)
epoch=3;
Data_to_use = squeeze(Respi_evol.(EpochName{epoch}){drug});
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
shadedErrorBar(linspace(0,time_aft_inj,interp_value) , runmean(nanmean(Data_to_use),10) , runmean(Conf_Inter,10) , Cols2{drug} , 1); hold on;
ylim([3 8.5])
xlabel('time (s)')




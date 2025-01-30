

Mouse = [666 668 688 739 777 779 849 893 1096 875 876 877 1001 1002 1095 740 750 775 778 794 829 851 856 857 858 859 1005 1006 1147 1184 1189 1200 1204 1205 11147 11184 11189 11200 11204 11205 11207 1144 1146 1170 1171 1172 1174 1161 1162];
[OutPutData , Epoch , NameEpoch , OutPutTSD] = MeanValuesPhysiologicalParameters_BM(Mouse,'exti','ob_low','heartrate');


Drug_Group={'Saline','ChronicFlx','AcuteFlx','Midazolam','Diazepam','NewSal'};

for group=1:length(Drug_Group)
    
    if group==1 % saline mice
        ind=3:9;
    elseif group==2 % chronic flx mice
        ind=10:15;
    elseif group==3 % Acute Flx
        ind=16:20;
    elseif group==4 % midazolam mice
        ind=21:28;
    elseif group==5 % diazepam mice
        ind=35:41;
    elseif group==6 % new saline mice
        ind=[29:31 33:34 42:43 45];
    end
    
    for i=1:length(ind)
    AllSpectrum.(Drug_Group{group}).Shock(i,:) = squeeze(OutPutData.ob_low.norm(ind(i),5,:));
    AllSpectrum.(Drug_Group{group}).Safe(i,:) = squeeze(OutPutData.ob_low.norm(ind(i),6,:));
    end
    
end
load('B_Low_Spectrum.mat')

% Mean spectrum shaded
figure; group=1;
subplot(231)
Conf_Inter=nanstd(AllSpectrum.(Drug_Group{group}).Shock)/sqrt(size(AllSpectrum.(Drug_Group{group}).Shock,1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(AllSpectrum.(Drug_Group{group}).Shock);
shadedErrorBar(Spectro{3},Mean_All_Sp/max(Mean_All_Sp(15:end)),Conf_Inter/max(Mean_All_Sp(15:end)),'-r',1); hold on;
Conf_Inter=nanstd(AllSpectrum.(Drug_Group{group}).Safe)/sqrt(size(AllSpectrum.(Drug_Group{group}).Safe,1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(AllSpectrum.(Drug_Group{group}).Safe);
h=shadedErrorBar(Spectro{3},Mean_All_Sp/max(Mean_All_Sp(15:end)),Conf_Inter/max(Mean_All_Sp(15:end)),'-b',1); hold on;
makepretty;
xlabel('Frequency (Hz)'); ylabel('Power (A.U.)'); xlim([0 10]);
[c,d]=max(nanmean(AllSpectrum.(Drug_Group{group}).Shock));
vline(Spectro{3}(d),'--r')
[c,d]=max(nanmean(AllSpectrum.(Drug_Group{group}).Safe(:,26:end)));
vline(Spectro{3}(d+25),'--b')
f=get(gca,'Children');
legend([f(5),f(1)],'Shock side freezing','Safe side freezing')
title('Saline')

subplot(232); group=2;
Conf_Inter=nanstd(AllSpectrum.(Drug_Group{group}).Shock)/sqrt(size(AllSpectrum.(Drug_Group{group}).Shock,1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(AllSpectrum.(Drug_Group{group}).Shock);
shadedErrorBar(Spectro{3},Mean_All_Sp/max(Mean_All_Sp(15:end)),Conf_Inter/max(Mean_All_Sp(15:end)),'-r',1); hold on;
Conf_Inter=nanstd(AllSpectrum.(Drug_Group{group}).Safe)/sqrt(size(AllSpectrum.(Drug_Group{group}).Safe,1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(AllSpectrum.(Drug_Group{group}).Safe);
h=shadedErrorBar(Spectro{3},Mean_All_Sp/max(Mean_All_Sp(15:end)),Conf_Inter/max(Mean_All_Sp(15:end)),'-b',1); hold on;
makepretty;
xlabel('Frequency (Hz)'); xlim([0 10]);
[c,d]=max(nanmean(AllSpectrum.(Drug_Group{group}).Shock));
vline(Spectro{3}(d),'--r')
[c,d]=max(nanmean(AllSpectrum.(Drug_Group{group}).Safe(:,26:end)));
vline(Spectro{3}(d+25),'--b')
title('Chronic Flx')

subplot(233); group=3;
Conf_Inter=nanstd(AllSpectrum.(Drug_Group{group}).Shock)/sqrt(size(AllSpectrum.(Drug_Group{group}).Shock,1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(AllSpectrum.(Drug_Group{group}).Shock);
shadedErrorBar(Spectro{3},Mean_All_Sp/max(Mean_All_Sp(15:end)),Conf_Inter/max(Mean_All_Sp(15:end)),'-r',1); hold on;
Conf_Inter=nanstd(AllSpectrum.(Drug_Group{group}).Safe)/sqrt(size(AllSpectrum.(Drug_Group{group}).Safe,1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(AllSpectrum.(Drug_Group{group}).Safe);
h=shadedErrorBar(Spectro{3},Mean_All_Sp/max(Mean_All_Sp(15:end)),Conf_Inter/max(Mean_All_Sp(15:end)),'-b',1); hold on;
makepretty;
xlabel('Frequency (Hz)'); xlim([0 10]);
[c,d]=max(nanmean(AllSpectrum.(Drug_Group{group}).Shock));
vline(Spectro{3}(d),'--r')
[c,d]=max(nanmean(AllSpectrum.(Drug_Group{group}).Safe(:,26:end)));
vline(Spectro{3}(d+25),'--b')
title('Acute Flx')

subplot(234); group=4;
Conf_Inter=nanstd(AllSpectrum.(Drug_Group{group}).Shock)/sqrt(size(AllSpectrum.(Drug_Group{group}).Shock,1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(AllSpectrum.(Drug_Group{group}).Shock);
shadedErrorBar(Spectro{3},Mean_All_Sp/max(Mean_All_Sp(15:end)),Conf_Inter/max(Mean_All_Sp(15:end)),'-r',1); hold on;
Conf_Inter=nanstd(AllSpectrum.(Drug_Group{group}).Safe)/sqrt(size(AllSpectrum.(Drug_Group{group}).Safe,1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(AllSpectrum.(Drug_Group{group}).Safe);
h=shadedErrorBar(Spectro{3},Mean_All_Sp/max(Mean_All_Sp(15:end)),Conf_Inter/max(Mean_All_Sp(15:end)),'-b',1); hold on;
makepretty; ylabel('Power (A.U.)')
xlabel('Frequency (Hz)'); xlim([0 10]);
[c,d]=max(nanmean(AllSpectrum.(Drug_Group{group}).Shock));
vline(Spectro{3}(d),'--r')
[c,d]=max(nanmean(AllSpectrum.(Drug_Group{group}).Safe(:,26:end)));
vline(Spectro{3}(d+25),'--b')
title('Midazolam')

subplot(235); group=5;
Conf_Inter=nanstd(AllSpectrum.(Drug_Group{group}).Shock)/sqrt(size(AllSpectrum.(Drug_Group{group}).Shock,1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(AllSpectrum.(Drug_Group{group}).Shock);
shadedErrorBar(Spectro{3},Mean_All_Sp/max(Mean_All_Sp(15:end)),Conf_Inter/max(Mean_All_Sp(15:end)),'-r',1); hold on;
Conf_Inter=nanstd(AllSpectrum.(Drug_Group{group}).Safe)/sqrt(size(AllSpectrum.(Drug_Group{group}).Safe,1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(AllSpectrum.(Drug_Group{group}).Safe);
h=shadedErrorBar(Spectro{3},Mean_All_Sp/max(Mean_All_Sp(15:end)),Conf_Inter/max(Mean_All_Sp(15:end)),'-b',1); hold on;
makepretty;
xlabel('Frequency (Hz)'); xlim([0 10]);
[c,d]=max(nanmean(AllSpectrum.(Drug_Group{group}).Shock(:,26:end)));
vline(Spectro{3}(d+25),'--r')
[c,d]=max(nanmean(AllSpectrum.(Drug_Group{group}).Safe(:,26:end)));
vline(Spectro{3}(d+25),'--b')
title('Diazepam')

subplot(236); group=6;
Conf_Inter=nanstd(AllSpectrum.(Drug_Group{group}).Shock)/sqrt(size(AllSpectrum.(Drug_Group{group}).Shock,1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(AllSpectrum.(Drug_Group{group}).Shock);
shadedErrorBar(Spectro{3},Mean_All_Sp/max(Mean_All_Sp(15:end)),Conf_Inter/max(Mean_All_Sp(15:end)),'-r',1); hold on;
Conf_Inter=nanstd(AllSpectrum.(Drug_Group{group}).Safe)/sqrt(size(AllSpectrum.(Drug_Group{group}).Safe,1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(AllSpectrum.(Drug_Group{group}).Safe);
h=shadedErrorBar(Spectro{3},Mean_All_Sp/max(Mean_All_Sp(15:end)),Conf_Inter/max(Mean_All_Sp(15:end)),'-b',1); hold on;
makepretty;
xlabel('Frequency (Hz)'); xlim([0 10]);
[c,d]=max(nanmean(AllSpectrum.(Drug_Group{group}).Shock(:,26:end)));
vline(Spectro{3}(d+25),'--r')
[c,d]=max(nanmean(AllSpectrum.(Drug_Group{group}).Safe(:,26:end)));
vline(Spectro{3}(d+25),'--b')
title('New saline')

a=suptitle('OB Low mean spectrums, Fear sessions'); a.FontSize=20;



% Mean spectrums details
figure
subplot(221)
plot(Spectro{3},AllSpectrum.(Drug_Group{5}).Shock','r'); makepretty; xlim([0 10]); vline(4,'-k')
ylabel('DZP');
subplot(222)
plot(Spectro{3},AllSpectrum.(Drug_Group{5}).Safe','b'); makepretty; xlim([0 10]); vline(4,'-k')
subplot(223)
plot(Spectro{3},AllSpectrum.(Drug_Group{6}).Shock','r'); makepretty; xlim([0 10]); vline(4,'-k')
xlabel('Frequency (Hz)'); ylabel('Saline')
subplot(224)
plot(Spectro{3},AllSpectrum.(Drug_Group{6}).Safe','b'); makepretty; xlim([0 10]); vline(4,'-k')
xlabel('Frequency (Hz)');

a=suptitle('OB Low mean spectrums, Cond sessions'); a.FontSize=20;

%% Mean spectrums max
% Fear corrections
OutPutData.ob_low.max_freq(9 , 5)=2.747; OutPutData.ob_low.max_freq(9 , 6)=3.357; OutPutData.ob_low.max_freq(39 , 5)=3.738; OutPutData.ob_low.max_freq(39 , 6)=2.594;
OutPutData.ob_low.max_freq(6,6)=2.823; OutPutData.ob_low.max_freq(19,6)=2.365; OutPutData.ob_low.max_freq(21,6)=1.678; OutPutData.ob_low.max_freq(27,6)=3.128; 
OutPutData.ob_low.max_freq(36,6)=3.891; OutPutData.ob_low.max_freq(41,6)=3.204; OutPutData.ob_low.max_freq(29,6)=6.104; OutPutData.ob_low.max_freq(44,6)=6.104;

% Cond corrections
OutPutData.ob_low.max_freq(13:15,5)=NaN; OutPutData.ob_low.max_freq(20,5)=NaN; OutPutData.ob_low.max_freq(19,6)=2.365;
OutPutData.ob_low.max_freq(21,6)=1.602; OutPutData.ob_low.max_freq(41,5)=3.891; OutPutData.ob_low.max_freq(29,5)=NaN;

% Ext corrections
OutPutData.ob_low.max_freq(6,6)=2.823; OutPutData.ob_low.max_freq(8,6)=2.365; OutPutData.ob_low.max_freq(9,6)=2.594; OutPutData.ob_low.max_freq(9,5)=2.67;
OutPutData.ob_low.max_freq(19,6)=2.365; OutPutData.ob_low.max_freq(18,6)=NaN; OutPutData.ob_low.max_freq(27,6)=2.441;
OutPutData.ob_low.max_freq(38,5)=4.425; OutPutData.ob_low.max_freq(39,6)=5.035; OutPutData.ob_low.max_freq(38,6)=2.975; 
OutPutData.ob_low.max_freq(39,6)=NaN; OutPutData.ob_low.max_freq(33,5)=NaN; OutPutData.ob_low.max_freq(9,5)=NaN; 
OutPutData.ob_low.max_freq(41,6)=2.136;

figure
for group=1:length(Drug_Group)
    
    if group==1 % saline mice
        ind=3:9;
    elseif group==2 % chronic flx mice
        ind=10:15;
    elseif group==3 % Acute Flx
        ind=16:20;
    elseif group==4 % midazolam mice
        ind=21:28;
    elseif group==5 % diazepam mice
        ind=35:41;
    elseif group==6 % new saline mice
        ind=[29:31 33:34 42:43 45];
    end
    
    subplot(1,6,group)
    MakeSpreadAndBoxPlot2_SB({OutPutData.ob_low.max_freq(ind , 5) OutPutData.ob_low.max_freq(ind , 6)} , {[1, 0.5, 0.5],[0.5 0.5 1]},[1,2], {'Shock side freezing','Safe side freezing'},'showpoints',0,'paired',1);
    title(Drug_Group{group})
    ylim([1 6])
    
    if group==1; ylabel('Frequency (Hz)'); end
        
end

a=suptitle('OB Low max frequency, Fear sessions'); a.FontSize=20;


% check signals
ind=10:15;
OutPutData.ob_low.max_freq(ind , 6)
figure
plot(Spectro{3} , squeeze(OutPutData.ob_low.raw(9,6,:)))

%% Heart rate
OutPutData.heartrate(OutPutData.heartrate==0)=NaN;

% Cond corrections
OutPutData.heartrate(11,5)=NaN;

% Ext corrections
OutPutData.heartrate(8,5)=NaN;

% Ext corrections
OutPutData.heartrate(8,6)=NaN; OutPutData.heartrate(11,5)=NaN;

figure
for group=1:length(Drug_Group)
    
    if group==1 % saline mice
        ind=3:9;
    elseif group==2 % chronic flx mice
        ind=10:15;
    elseif group==3 % Acute Flx
        ind=16:20;
    elseif group==4 % midazolam mice
        ind=21:28;
    elseif group==5 % diazepam mice
        ind=35:41;
    elseif group==6 % new saline mice
        ind=[29:31 33:34 42:43 45];
    end
    
    subplot(1,6,group)
    MakeSpreadAndBoxPlot2_SB({OutPutData.heartrate(ind , 5) OutPutData.heartrate(ind , 6)} , {[1, 0.5, 0.5],[0.5 0.5 1]},[1,2], {'Shock side freezing','Safe side freezing'},'showpoints',0,'paired',1);
    title(Drug_Group{group})
    ylim([7.8 13])
    
        if group==1; ylabel('Frequency (Hz)'); end
    
end

a=suptitle('HR during Fz, Cond sessions'); a.FontSize=20;

%% Paired analysis
OutPutData.ob_low.max_freq(32 , 5)=NaN; OutPutData.ob_low.max_freq(32 , 6)=NaN;

figure
subplot(121)
ind1=29:34; ind2=35:40;
MakeSpreadAndBoxPlot2_SB({OutPutData.ob_low.max_freq(ind1 , 5) OutPutData.ob_low.max_freq(ind2 , 5)} , {[1, 0.5, 0.5],[1, 0.7, 0.7]},[1,2], {'New Sal','DZP'},'showpoints',0,'paired',1);
ylim([1 6]); ylabel('Frequency (Hz)'); title('Shock side freezing')
subplot(122)
MakeSpreadAndBoxPlot2_SB({OutPutData.ob_low.max_freq(ind1 , 6) OutPutData.ob_low.max_freq(ind2 , 6)} , {[0.5 0.5 1],[0.7 0.7 1]},[1,2], {'New Sal','DZP'},'showpoints',0,'paired',1);
ylim([1 6]); title('Safe side freezing')

a=suptitle('OB max Freq, Cond sessions'); a.FontSize=20;


%% Ripples


Mouse = [666 668 688 739 777 779 849 893 1096 875 876 877 1001 1002 1095 740 750 775 778 794 829 851 856 857 858 859 1005 1006 1147 1184 1189 1200 1204 1205 11147 11184 11189 11200 11204 11205 11207 1144 1146 1170 1171 1172 1174 1161 1162];
[OutPutData , Epoch , NameEpoch , OutPutTSD] = MeanValuesPhysiologicalParameters_BM(Mouse,'fear','mean_ripples');

Drug_Group={'Saline','ChronicFlx','AcuteFlx','Midazolam','Diazepam','NewSal'};
OutPutData.ripples_numb(OutPutData.ripples_numb==0)=NaN;
for j=5:6
    for mouse=1:length(Mouse)
        try
            RipplesDensity(mouse,j)=OutPutData.ripples_numb(mouse,j)/(sum(Stop(Epoch{mouse,j})-Start(Epoch{mouse,j}))*1e-4);
        end
    end
end

RipplesDensity(12 , 5)=NaN;

figure
for group=1:length(Drug_Group)
    
    if group==1 % saline mice
        ind=1:9;
    elseif group==2 % chronic flx mice
        ind=10:15;
    elseif group==3 % Acute Flx
        ind=16:20;
    elseif group==4 % midazolam mice
        ind=21:28;
    elseif group==5 % diazepam mice
        ind=35:41;
    elseif group==6 % new saline mice
        ind=[29:31 33:34 42:44];
    end
    
    subplot(1,6,group)
    MakeSpreadAndBoxPlot2_SB({RipplesDensity(ind , 5) RipplesDensity(ind , 6)} , {[1, 0.5, 0.5],[0.5 0.5 1]},[1,2], {'Shock side freezing','Safe side freezing'},'showpoints',0,'paired',1);
    title(Drug_Group{group})
    ylim([0 0.6])
    
end



%% InstFreq distrib

Mouse = [666 668 688 739 777 779 849 893 1096 875 876 877 1001 1002 1095 740 750 775 778 794 829 851 856 857 858 859 1005 1006 1147 1184 1189 1200 1204 1205 11147 11184 11189 11200 11204 11205 11207 1144 1146 1170 1171 1172 1174 1161 1162];
[OutPutData2 , Epoch2 , NameEpoch , OutPutTSD2] = MeanValuesPhysiologicalParameters_BM(Mouse,'fear','respi');



[t, Hist_Of_Peak.Shock.(Drug_Group{group}), X1] = nhist(Spc_Max.Shock.(Drug_Group{group}) , 'minbins', 20 , 'maxbins', 20, 'minx', 0, 'maxx', 6); close
[t, Hist_Of_Peak.Safe.(Drug_Group{group}), X] = nhist(Spc_Max.Safe.(Drug_Group{group}) , 'minbins', 20 , 'maxbins', 20, 'minx', 0, 'maxx', 6); close

clear A1 A2; A1=[]; A2=[];
for mouse= 1:length(Mouse_names)
    A1=[A1 ; Hist_Of_Peak.Shock.(Drug_Group{group}){mouse}];
    A2=[A2 ; Hist_Of_Peak.Safe.(Drug_Group{group}){mouse}];
end
Hist_Of_Peak_Mean.Shock.(Drug_Group{group})=round(nanmean(A1));
Hist_Of_Peak_Mean.Safe.(Drug_Group{group})=round(nanmean(A2));

end


figure
plot(Hist_Of_Peak_Mean.Shock.Saline);
hold on
plot(Hist_Of_Peak_Mean.Safe.Saline);




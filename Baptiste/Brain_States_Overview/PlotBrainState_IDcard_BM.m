
sess=1; %group=;

try
    if saline_SB==1
        if sess==1
            OutPutData.(Session_type{sess}).pfc_low.max_freq([6 7],5)=[5.035 4.27]; OutPutData.(Session_type{sess}).pfc_low.power([6 7],5)=[3.057e4 2.329e4];
            OutPutData.(Session_type{sess}).pfc_low.max_freq([1 2 4 6 7],6)=[2.136 4.501 2.365 3.738 3.815]; OutPutData.(Session_type{sess}).pfc_low.power([1 2 4 6 7],6)=[2.515e4 3.165e4 2.341e4 2.354e4 2.513e4];
            
            OutPutData.(Session_type{sess}).h_vhigh.max_freq(2,5) = 178.2; OutPutData.(Session_type{sess}).h_vhigh.power(2,5) = 311.7;
            OutPutData.(Session_type{sess}).h_vhigh.max_freq([1 2],6) = 183.1; OutPutData.(Session_type{sess}).h_vhigh.power([1 2],6) = [247.9 407.7];
        else
            OutPutData.(Session_type{sess}).ob_low.max_freq(7,5)=3.662; OutPutData.(Session_type{sess}).ob_low.power(7,5)=5.479e4;
            OutPutData.(Session_type{sess}).ob_low.max_freq([4 6 7],6)=[2.823 NaN 2.594]; OutPutData.(Session_type{sess}).ob_low.power([4 6 7],6)=[3.533e4 NaN 1.202e5];
           
            OutPutData.(Session_type{sess}).ob_middle.max_freq([1 5 7],6)=[57.37 54.93 59.81]; OutPutData.(Session_type{sess}).ob_middle.power([1 5 7],6)=[2427 4456 1458];

            OutPutData.(Session_type{sess}).pfc_low.max_freq([2 4 6 7],5)=[4.12 3.204 4.349 2.67]; OutPutData.(Session_type{sess}).pfc_low.power([2 4 6 7],5)=[2.4e4 1.88e4 3.096e4 2.804e4];
            OutPutData.(Session_type{sess}).pfc_low.max_freq(:,6)=[2.06 5.646 NaN 2.518 2.365 4.349 2.67]; OutPutData.(Session_type{sess}).pfc_low.power(:,6)=[5.131e4 1.714e4 NaN 3.659e4 3.773e4 1.636e4 2.993e4];
            
            OutPutData.(Session_type{sess}).h_vhigh.max_freq([1 2],5) = [185.5 190.4]; OutPutData.(Session_type{sess}).h_vhigh.power([1 2],5) = [162.2 246.1];
            OutPutData.(Session_type{sess}).h_vhigh.max_freq([1 2],6) = [168.5 188]; OutPutData.(Session_type{sess}).h_vhigh.power([1 2],6) = [381.3 431.1];
        end
    end
        if Chronic_flx==1
        if sess==1
            OutPutData.(Session_type{sess}).ob_low.max_freq([4:6],5)=NaN; OutPutData.(Session_type{sess}).pfc_low.power(4:6,5)=NaN;

            OutPutData.(Session_type{sess}).ob_middle.max_freq([4:6],5)=NaN; OutPutData.(Session_type{sess}).ob_middle.power(4:6,5)=NaN;

            OutPutData.(Session_type{sess}).pfc_low.max_freq(:,5)=[4.501 4.044 4.196 NaN NaN NaN]; OutPutData.(Session_type{sess}).pfc_low.power(:,5)=[6.718e4 4.71e4 3.103e4 NaN NaN NaN];
            OutPutData.(Session_type{sess}).pfc_low.max_freq(:,6)=[3.433 3.357 3.357 2.289 3.891 2.136]; OutPutData.(Session_type{sess}).pfc_low.power(:,6)=[3.696e4 3.399e4 3.13e4 2.794e4 2.138e4 2.713e4];
            
            OutPutData.(Session_type{sess}).h_vhigh.max_freq(:,5) = NaN; OutPutData.(Session_type{sess}).h_vhigh.power(:,5) = NaN;
            OutPutData.(Session_type{sess}).h_vhigh.max_freq(5,6) = NaN; OutPutData.(Session_type{sess}).h_vhigh.power(5,6) = NaN;
        else
            OutPutData.(Session_type{sess}).pfc_low.max_freq(:,5)=[5.035 4.044 NaN 2.899 2.823 2.213]; OutPutData.(Session_type{sess}).pfc_low.power(:,5)=[5.94e4 2.516e4 NaN 2.328e4 3.828e4 3.423e4];
            OutPutData.(Session_type{sess}).pfc_low.max_freq(:,6)=[3.738 2.823 3.891 NaN NaN 2.289]; OutPutData.(Session_type{sess}).pfc_low.power(:,6)=[3.636e4 2.539e4 2.211e4 NaN NaN 3.521e4];
            
            OutPutData.(Session_type{sess}).h_vhigh.max_freq(6,5) = NaN; OutPutData.(Session_type{sess}).h_vhigh.power(6,5) = NaN;
            OutPutData.(Session_type{sess}).h_vhigh.max_freq(6,6) = NaN; OutPutData.(Session_type{sess}).h_vhigh.power(6,6) = NaN;
        end
    end
        if Acute_flx==1
        if sess==1
            OutPutData.(Session_type{sess}).ob_low.max_freq(5,5)=NaN; OutPutData.(Session_type{sess}).ob_low.power(5,5)=NaN;
            OutPutData.(Session_type{sess}).ob_low.max_freq(4,6)=2.441; OutPutData.(Session_type{sess}).ob_low.power(4,6)=7.58e4;

            OutPutData.(Session_type{sess}).ob_middle.max_freq(5,5)=NaN; OutPutData.(Session_type{sess}).ob_middle.power(5,5)=NaN;
            OutPutData.(Session_type{sess}).ob_middle.max_freq(3,6)=59.81; OutPutData.(Session_type{sess}).ob_middle.power(3,6)=1799;

            OutPutData.(Session_type{sess}).pfc_low.max_freq([4 5],5)=[4.654 NaN]; OutPutData.(Session_type{sess}).pfc_low.power([4 5],5)=[1.495e5 NaN];
            OutPutData.(Session_type{sess}).pfc_low.max_freq(4,6)=3.128; OutPutData.(Session_type{sess}).pfc_low.power(4,6)=1.021e5;
            
            OutPutData.(Session_type{sess}).h_vhigh.max_freq(5,5) = NaN; OutPutData.(Session_type{sess}).h_vhigh.power(5,5) = NaN;
            OutPutData.(Session_type{sess}).h_vhigh.max_freq(2,6) = 183.1; OutPutData.(Session_type{sess}).h_vhigh.power(2,6) = 280.9;
        else
            OutPutData.(Session_type{sess}).ob_low.max_freq(4,6)=2.213; OutPutData.(Session_type{sess}).ob_low.power(4,6)=8.179e4;
           
            OutPutData.(Session_type{sess}).ob_middle.max_freq([3 4],6)=[59.81 56.15]; OutPutData.(Session_type{sess}).ob_middle.power([3 4],6)=[1363 793.6];

            OutPutData.(Session_type{sess}).pfc_low.max_freq(4,5)=4.12; OutPutData.(Session_type{sess}).pfc_low.power(4,5)=1.514e5;
            OutPutData.(Session_type{sess}).pfc_low.max_freq([1 4],6)=[NaN 2.441]; OutPutData.(Session_type{sess}).pfc_low.power([1 4],6)=[NaN 8.9e4];
            
            OutPutData.(Session_type{sess}).h_vhigh.max_freq(2,5) = 183.1; OutPutData.(Session_type{sess}).h_vhigh.power(2,5) = 246.4;
            OutPutData.(Session_type{sess}).h_vhigh.max_freq(2,6) = 168.5; OutPutData.(Session_type{sess}).h_vhigh.power(3,6) = 241.5;
        end
    end
    if MDZ==1
        if sess==1;
            OutPutData.(Session_type{sess}).ob_low.max_freq([1],6)=[1.602]; OutPutData.(Session_type{sess}).ob_low.power([1],6)=[3.687e5];
            
            OutPutData.(Session_type{sess}).pfc_low.max_freq(:,5)=[NaN 4.349 4.501 5.951 5.264 5.112 4.654]; OutPutData.(Session_type{sess}).pfc_low.power(:,5)=[NaN 3.543e4 2.033e4 1.837e4 2.409e4 6.416e4 3.288e4];
            OutPutData.(Session_type{sess}).pfc_low.max_freq(:,6)=[NaN 3.357 2.975 2.67 NaN 3.738 3.052]; OutPutData.(Session_type{sess}).pfc_low.power(:,6)=[NaN 2.861e4 2.504e4 2.391e4 NaN 3.602e4 5.846e4];
            
             OutPutData.(Session_type{sess}).h_vhigh.max_freq(4,6) = [173.3]; OutPutData.(Session_type{sess}).h_vhigh.power(4,6) = [276.3]';
        else
             OutPutData.(Session_type{sess}).ob_middle.max_freq(5,6)=[57.37]; OutPutData.(Session_type{sess}).ob_middle.power(4,6)=2140;
            
            OutPutData.(Session_type{sess}).pfc_low.max_freq(:,5)=[4.578 3.662 3.51 3.586 4.501 3.586 4.349]; OutPutData.(Session_type{sess}).pfc_low.power(:,5)=[2.321e4 2.766e4 3.183e4 2.452e4 2.455e4 3.647e4 3.307e4];
            OutPutData.(Session_type{sess}).pfc_low.max_freq(:,6)=[3.204 NaN 3.281 2.136 NaN 2.518 2.441]; OutPutData.(Session_type{sess}).pfc_low.power(:,6)=[3.632e4 NaN 3.431e4 3.914e4 NaN 3.334e4 5.96e4];
            
             OutPutData.(Session_type{sess}).h_vhigh.max_freq([1 4],5) = [175.8 173.3]; OutPutData.(Session_type{sess}).h_vhigh.power([1 4],5) = [265.5 266.4];
             OutPutData.(Session_type{sess}).h_vhigh.max_freq(4,6) = 173.3; OutPutData.(Session_type{sess}).h_vhigh.power(4,6) = 283.6;
        end
    end
        if Saline_short==1
        if sess==1;
            OutPutData.(Session_type{sess}).ob_low.max_freq(3,5)=NaN; OutPutData.(Session_type{sess}).ob_low.power(3,5)=NaN;
            OutPutData.(Session_type{sess}).ob_low.max_freq(4,6)=NaN; OutPutData.(Session_type{sess}).ob_low.power(4,6)=NaN;
            
            OutPutData.(Session_type{sess}).ob_middle.max_freq([1 3],5)=NaN; OutPutData.(Session_type{sess}).ob_middle.power([1 3],5)=NaN;
            OutPutData.(Session_type{sess}).ob_middle.max_freq(1,6)=NaN; OutPutData.(Session_type{sess}).ob_middle.power(1,6)=NaN;
            
            OutPutData.(Session_type{sess}).pfc_low.max_freq([1 3 8],5)=[NaN]; OutPutData.(Session_type{sess}).h_vhigh.power([1 3 8],5)=[NaN ];
            OutPutData.(Session_type{sess}).pfc_low.max_freq([1 3 8],6)=[NaN]; OutPutData.(Session_type{sess}).h_vhigh.power([1 3 8],5)=[NaN ];
%         else
%             OutPutData.(Session_type{sess}).ob_low.max_freq([4 5],5)=[NaN 5.112]; OutPutData.(Session_type{sess}).ob_low.power([4 5],5)=[NaN 2.868e5];
%             OutPutData.(Session_type{sess}).ob_low.max_freq([4 5 7 8 9],6)=[NaN NaN 3.357 2.06 NaN]; OutPutData.(Session_type{sess}).ob_low.power([4 5 7 8 9],6)=[NaN NaN 3.462e5 4.484e5 NaN];
%             
%             OutPutData.(Session_type{sess}).ob_low.max_freq([4 5],6)=[NaN NaN]; OutPutData.(Session_type{sess}).ob_low.power([4 5],5)=[NaN NaN];
%             OutPutData.(Session_type{sess}).ob_low.max_freq([4 5 7 8],6)=[57.37 54.93]; OutPutData.(Session_type{sess}).ob_low.power([3 7],6)=[2427 4456];
%             
%             OutPutData.(Session_type{sess}).ob_middle.max_freq([3 7],6)=[57.37 54.93]; OutPutData.(Session_type{sess}).ob_middle.power([3 7],6)=[2427 4456];
        end
        
    end
    if DZP_short==1
        if sess==1;
            OutPutData.(Session_type{sess}).ob_low.max_freq([8],5)=[3.891]; OutPutData.(Session_type{sess}).ob_low.power([8],5)=[2.36e5];
            
            OutPutData.(Session_type{sess}).ob_middle.max_freq([6 11 12],5)=[NaN 59.81 57.37]; OutPutData.(Session_type{sess}).ob_middle.power([6 11 12],5)=[NaN 2096 2341];
            OutPutData.(Session_type{sess}).ob_middle.max_freq([6 12],6)=[NaN 57.31]; OutPutData.(Session_type{sess}).ob_middle.power([6 12],6)=[NaN 2614];

            OutPutData.(Session_type{sess}).pfc_low.max_freq(:,5)=[NaN NaN NaN NaN NaN NaN NaN 3.51 3.967 5.035 5.035 5.035]; OutPutData.(Session_type{sess}).ob_middle.power(:,5)=[NaN NaN NaN NaN NaN NaN NaN 3e4 3.25e4 2.81e4 1.38e4 1.425e4];
            OutPutData.(Session_type{sess}).pfc_low.max_freq(:,6)=[NaN NaN NaN NaN NaN NaN NaN 3.204 4.349 4.044 5.493 6.104]; OutPutData.(Session_type{sess}).ob_middle.power(:,6)=[NaN NaN NaN NaN NaN NaN NaN 3e4 2.737e4 1.557e4 1.21e4 1.269e4];

            OutPutData.(Session_type{sess}).h_vhigh.max_freq([1 3 8],5)=NaN; OutPutData.(Session_type{sess}).h_vhigh.power([1 3 8],5)=[NaN ];
            OutPutData.(Session_type{sess}).h_vhigh.max_freq([1 3 8],6)=[NaN NaN 183.1]; OutPutData.(Session_type{sess}).h_vhigh.power([1 3 8],6)=[NaN NaN 309];
        else
            OutPutData.(Session_type{sess}).ob_low.max_freq([4 5],5)=[NaN 5.112]; OutPutData.(Session_type{sess}).ob_low.power([4 5],5)=[NaN 2.868e5];
            OutPutData.(Session_type{sess}).ob_low.max_freq([4 5 7 8 9],6)=[NaN NaN 3.357 2.06 NaN]; OutPutData.(Session_type{sess}).ob_low.power([4 5 7 8 9],6)=[NaN NaN 3.462e5 4.484e5 NaN];
            
            OutPutData.(Session_type{sess}).ob_middle.max_freq(12,5)=57.37; OutPutData.(Session_type{sess}).ob_middle.power(12,5)=2341;
            OutPutData.(Session_type{sess}).ob_middle.max_freq([5 6 9],6)=[NaN 52.49 NaN]; OutPutData.(Session_type{sess}).ob_middle.power([5 6 9],6)=[NaN 3162 NaN];
            
            OutPutData.(Session_type{sess}).pfc_low.max_freq(:,5)=[NaN NaN NaN NaN NaN NaN NaN 3.357 4.578 2.823 3.128 6.18]; OutPutData.(Session_type{sess}).ob_middle.power(:,5)=[NaN NaN NaN NaN NaN NaN NaN 3.801e4 1.911e4 2.135e4 1.602e4 1.236e4];
            OutPutData.(Session_type{sess}).pfc_low.max_freq(:,6)=[NaN NaN NaN NaN NaN NaN NaN NaN NaN 3.967 5.722 6.18]; OutPutData.(Session_type{sess}).ob_middle.power(:,6)=[NaN NaN NaN NaN NaN NaN NaN NaN NaN 1.388e4 1.034e4 1.432e4];
            
            OutPutData.(Session_type{sess}).h_vhigh.max_freq([1 3 10],5)=[NaN NaN 185.5]; OutPutData.(Session_type{sess}).h_vhigh.power([1 3 10],5)=[NaN NaN 221.7];
            OutPutData.(Session_type{sess}).h_vhigh.max_freq([1 3 5 8:10],6)=[NaN NaN NaN 170.9 NaN NaN]; OutPutData.(Session_type{sess}).h_vhigh.power([1 3 5 8:10],6)=[NaN NaN NaN 463.4 NaN NaN];
        end
    end
end

%% 1) Plot mean spectrum
figure
subplot(351); thr=25;
Data_to_use = squeeze(OutPutData.(Session_type{sess}).ob_low.mean(:,5,:))./max([OutPutData.(Session_type{sess}).ob_low.power(:,5) OutPutData.(Session_type{sess}).ob_low.power(:,6)]')';
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(Data_to_use);
shadedErrorBar(RangeLow , Mean_All_Sp,Conf_Inter,'-r',1); hold on;
[c,d]=max(Mean_All_Sp(thr+1:end));
vline(RangeLow(d+thr),'--r')
Data_to_use = squeeze(OutPutData.(Session_type{sess}).ob_low.mean(:,6,:))./max([OutPutData.(Session_type{sess}).ob_low.power(:,5) OutPutData.(Session_type{sess}).ob_low.power(:,6)]')';
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(Data_to_use);
shadedErrorBar(RangeLow , Mean_All_Sp,Conf_Inter,'-b',1); hold on;
[c,d]=max(Mean_All_Sp(:,thr+1:end));
vline(RangeLow(d+thr),'--b')
f=get(gca,'Children');
a=legend([f(8),f(4)],'Shock side freezing','Safe side freezing');
makepretty; xlabel('Frequency (Hz)'); ylabel('Power (a.u.)'); xticks([0:2:10]); xlim([0 10]); ylim([0 1])
title('OB Low')

subplot(352); thr=21;
Data_to_use = squeeze(OutPutData.(Session_type{sess}).ob_middle.mean(:,5,:))./max([OutPutData.(Session_type{sess}).ob_middle.power(:,5) OutPutData.(Session_type{sess}).ob_middle.power(:,6)]')';
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(Data_to_use);
shadedErrorBar(RangeMiddle , Mean_All_Sp,Conf_Inter,'-r',1); hold on;
[c,d]=max(Mean_All_Sp(thr+1:end));
vline(RangeMiddle(d+thr),'--r')
Data_to_use = squeeze(OutPutData.(Session_type{sess}).ob_middle.mean(:,6,:))./max([OutPutData.(Session_type{sess}).ob_middle.power(:,5) OutPutData.(Session_type{sess}).ob_middle.power(:,6)]')';
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(Data_to_use);
shadedErrorBar(RangeMiddle , Mean_All_Sp,Conf_Inter,'-b',1); hold on;
[c,d]=max(Mean_All_Sp(:,thr+1:end));
vline(RangeMiddle(d+thr),'--b')
makepretty; xlabel('Frequency (Hz)'); xlim([30 100]); ylim([.1 1])
title('OB High')

subplot(353); thr= 25;
Data_to_use = squeeze(OutPutData.(Session_type{sess}).hpc_low.mean(:,5,:))./max([OutPutData.(Session_type{sess}).hpc_low.power(:,5) OutPutData.(Session_type{sess}).hpc_low.power(:,6)]')';
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(Data_to_use);
shadedErrorBar(RangeLow , Mean_All_Sp , Conf_Inter,'-r',1); hold on;
Data_to_use = squeeze(OutPutData.(Session_type{sess}).hpc_low.mean(:,6,:))./max([OutPutData.(Session_type{sess}).hpc_low.power(:,5) OutPutData.(Session_type{sess}).hpc_low.power(:,6)]')';
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(Data_to_use);
shadedErrorBar(RangeLow , Mean_All_Sp,Conf_Inter,'-b',1); hold on;
makepretty; xlabel('Frequency (Hz)'); xlim([0 15]); ylim([0 1.3])
title('HPC Low')

subplot(354); thr= 30;
Data_to_use = squeeze(OutPutData.(Session_type{sess}).h_vhigh.mean(:,5,:))./max([OutPutData.(Session_type{sess}).h_vhigh.power(:,5) OutPutData.(Session_type{sess}).h_vhigh.power(:,6)]')';
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(Data_to_use);
shadedErrorBar(RangeVHigh , Mean_All_Sp , Conf_Inter,'-r',1); hold on;
[c,d]=max(Mean_All_Sp(:,thr+1:end));
vline(RangeVHigh(d+thr),'--r')
Data_to_use = squeeze(OutPutData.(Session_type{sess}).h_vhigh.mean(:,6,:))./max([OutPutData.(Session_type{sess}).h_vhigh.power(:,5) OutPutData.(Session_type{sess}).h_vhigh.power(:,6)]')';
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(Data_to_use);
shadedErrorBar(RangeVHigh , Mean_All_Sp , Conf_Inter,'-b',1); hold on;
[c,d]=max(Mean_All_Sp(:,thr+1:end));
vline(RangeVHigh(d+thr),'--b')
makepretty; xlabel('Frequency (Hz)'); xlim([120 250]); ylim([0 1]);
title('HPC VHigh')

subplot(355)
Data_to_use = squeeze(OutPutData.(Session_type{sess}).pfc_low.mean(:,5,:))./max([OutPutData.(Session_type{sess}).pfc_low.power(:,5) OutPutData.(Session_type{sess}).pfc_low.power(:,6)]')';
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(Data_to_use);
shadedErrorBar(RangeLow , Mean_All_Sp,Conf_Inter,'-r',1); hold on;
[c,d]=max(Mean_All_Sp(:,thr+1:end));
vline(RangeLow(d+thr),'--r')
Data_to_use = squeeze(OutPutData.(Session_type{sess}).pfc_low.mean(:,6,:))./max([OutPutData.(Session_type{sess}).pfc_low.power(:,5) OutPutData.(Session_type{sess}).pfc_low.power(:,6)]')';
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(Data_to_use);
shadedErrorBar(RangeLow , Mean_All_Sp,Conf_Inter,'-b',1); hold on;
[c,d]=max(Mean_All_Sp(:,thr+1:end));
vline(RangeLow(d+thr),'--b')
makepretty; xlabel('Frequency (Hz)'); xlim([0 10]); ylim([0 .95])
title('PFC Low')


%% 2) Plot data paired MakeSpreadAndBoxPlot2_SB
subplot(3,10,11)
MakeSpreadAndBoxPlot2_SB(OutPutData.(Session_type{sess}).ob_low.max_freq(:,5:6),Cols,X,Legends,'showpoints',0,'paired',1);
ylabel('Frequency (Hz)'); title('Frequency')
subplot(3,10,12)
MakeSpreadAndBoxPlot2_SB(log10(OutPutData.(Session_type{sess}).ob_low.power(:,5:6)),Cols,X,Legends,'showpoints',0,'paired',1);
ylabel('Power (a.u.)'); title('Power'); 

subplot(3,10,13)
MakeSpreadAndBoxPlot2_SB(OutPutData.(Session_type{sess}).ob_middle.max_freq(:,5:6),Cols,X,Legends,'showpoints',0,'paired',1);
ylabel('Frequency (Hz)'); title('Frequency')
subplot(3,10,14)
MakeSpreadAndBoxPlot2_SB(log10(OutPutData.(Session_type{sess}).ob_middle.power(:,5:6)),Cols,X,Legends,'showpoints',0,'paired',1);
ylabel('Power (a.u.)'); title('Power')

subplot(3,10,15)
% MakeSpreadAndBoxPlot2_SB(OutPutData.(Session_type{sess}).hpc_low.max_freq(:,5:6),Cols,X,Legends,'showpoints',0,'paired',1);
% ylabel('Frequency (Hz)'); title('Frequency')
% subplot(3,10,16)
% MakeSpreadAndBoxPlot2_SB(log10(OutPutData.(Session_type{sess}).hpc_low.power(:,5:6)),Cols,X,Legends,'showpoints',0,'paired',1);
% ylabel('Power (a.u.)'); title('Power')

% ratio of area under cruve between 1.5-4.9Hz & 4.9-9Hz, the 2 detected rythm
Ratio_shock = nanmean(squeeze(OutPutData.(Session_type{sess}).hpc_low.mean(:,5,64:117))')./nanmean(squeeze(OutPutData.(Session_type{sess}).hpc_low.mean(:,5,19:63))');
Ratio_safe = nanmean(squeeze(OutPutData.(Session_type{sess}).hpc_low.mean(:,6,64:117))')./nanmean(squeeze(OutPutData.(Session_type{sess}).hpc_low.mean(:,6,19:63))');

MakeSpreadAndBoxPlot2_SB([Ratio_shock' Ratio_safe'],Cols,X,Legends,'showpoints',0,'paired',1);
title('Ratio θ/δ')

subplot(3,10,16)
MakeSpreadAndBoxPlot2_SB([log10(nanmean(squeeze(OutPutData.(Session_type{sess}).hpc_low.mean(:,5,64:117))')') log10(nanmean(squeeze(OutPutData.(Session_type{sess}).hpc_low.mean(:,6,64:117))')')],Cols,X,Legends,'showpoints',0,'paired',1);
title('θ mean power')

subplot(3,10,17)
MakeSpreadAndBoxPlot2_SB(OutPutData.(Session_type{sess}).h_vhigh.max_freq(:,5:6),Cols,X,Legends,'showpoints',0,'paired',1);
ylabel('Frequency (Hz)'); title('Frequency')
subplot(3,10,18)
MakeSpreadAndBoxPlot2_SB(log10(OutPutData.(Session_type{sess}).h_vhigh.power(:,5:6)),Cols,X,Legends,'showpoints',0,'paired',1);
ylabel('Power (a.u.)'); title('Power')

subplot(3,10,19)
MakeSpreadAndBoxPlot2_SB(OutPutData.(Session_type{sess}).pfc_low.max_freq(:,5:6),Cols,X,Legends,'showpoints',0,'paired',1);
ylabel('Frequency (Hz)'); title('Frequency')
subplot(3,10,20)
MakeSpreadAndBoxPlot2_SB(log10(OutPutData.(Session_type{sess}).pfc_low.power(:,5:6)),Cols,X,Legends,'showpoints',0,'paired',1);
ylabel('Power (a.u.)'); title('Power')


[a,b] = max(squeeze(OutPutData.(Session_type{sess}).pfc_low.mean(:,5,39:end))'); b=b(b>1); a=a(b>1); a(a<1)=NaN;
[c,d] = max(squeeze(OutPutData.(Session_type{sess}).pfc_low.mean(:,6,39:end))'); d=d(d>1); c=c(d>1);

subplot(3,10,19)
MakeSpreadAndBoxPlot2_SB({RangeLow(b+38) RangeLow(d+38)},Cols,X,Legends,'showpoints',1,'paired',0);
subplot(3,10,20)
MakeSpreadAndBoxPlot2_SB({a c},Cols,X,Legends,'showpoints',1,'paired',0);

%% 3) Funny things
% OB mean waveform
subplot(3,5,11)
Data_to_use = squeeze(OutPutData.(Session_type{sess}).respi_meanwaveform(:,5,:));
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(Data_to_use); max_Respi = max([max(nanmean(squeeze(OutPutData.(Session_type{sess}).respi_meanwaveform(:,5,:)))) max(nanmean(squeeze(OutPutData.(Session_type{sess}).respi_meanwaveform(:,6,:))))]);
shadedErrorBar([1:751] , Mean_All_Sp/max_Respi,Conf_Inter/max_Respi,'-r',1); hold on;
Data_to_use = squeeze(OutPutData.(Session_type{sess}).respi_meanwaveform(:,6,:));
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(Data_to_use);
shadedErrorBar([1:751] , Mean_All_Sp/max_Respi,Conf_Inter/max_Respi,'-b',1); hold on;
makepretty; ylabel('Amplitude (a.u.)'); xlabel('time (ms)'); xlim([0 751]); ylim([-1.1 1.2])
xticks([0 376 751]); xticklabels({'-300','0','+300'})
title('Mean OB waveform')


% Phase Pref
for mouse=1:length(Mouse)
    PhasePref_Shock(mouse,:,:) = OutPutData.(Session_type{sess}).phase_pref.PhasePref{mouse, 5}'./max([max(OutPutData.(Session_type{sess}).phase_pref.PhasePref{mouse, 5}(:,21:end)) max(OutPutData.(Session_type{sess}).phase_pref.PhasePref{mouse, 6}(:,21:end))]);
    PhasePref_Safe(mouse,:,:) = OutPutData.(Session_type{sess}).phase_pref.PhasePref{mouse, 6}'./max([max(OutPutData.(Session_type{sess}).phase_pref.PhasePref{mouse, 5}(:,21:end)) max(OutPutData.(Session_type{sess}).phase_pref.PhasePref{mouse, 6}(:,21:end))]);
end

PhasePref_Shock_Averaged = squeeze(nanmean(PhasePref_Shock));
PhasePref_Safe_Averaged = squeeze(nanmean(PhasePref_Safe));

subplot(3,5,12)
imagesc([OutPutData.(Session_type{sess}).phase_pref.BinnedPhase OutPutData.(Session_type{sess}).phase_pref.BinnedPhase+354] , OutPutData.(Session_type{sess}).phase_pref.Frequency , [PhasePref_Shock_Averaged PhasePref_Shock_Averaged]);
axis xy; caxis([0 0.8]); ylim([20 100])
makepretty; ylabel('Frequency (Hz)');
title('Shock'); xlabel('Phase (°)')
subplot(3,5,13)
imagesc([OutPutData.(Session_type{sess}).phase_pref.BinnedPhase OutPutData.(Session_type{sess}).phase_pref.BinnedPhase+354], OutPutData.(Session_type{sess}).phase_pref.Frequency , [PhasePref_Safe_Averaged PhasePref_Safe_Averaged]);
axis xy; caxis([0 0.8]); ylim([20 100])
makepretty;
title('Safe'); xlabel('Phase (°)')
u=text(-300,115,'Gamma preference'); set(u,'FontSize',20,'FontWeight','bold');
colormap jet

% HPC around ripples
% subplot(3,5,13)
%
% if sess==1;
%     cd('/media/nas4/ProjetEmbReact/Mouse777/20180828/ProjectEmbReact_M777_20180828_UMazeCondBlockedShock_PostDrug/Cond2')
%     load('RipplesSleepThresh.mat')
%     load('behavResources_SB.mat')
%
%     Fz_shock = and(Behav.FreezeAccEpoch , Behav.ZoneEpoch{1});
%     Fz_safe = and(Behav.FreezeAccEpoch , or(Behav.ZoneEpoch{5} , Behav.ZoneEpoch{2}));
%
%     AroundRipples = intervalSet(Start(RipplesEpochR)-.3e4 , Stop(RipplesEpochR)+.3e4);
%
%     load('H_Low_Spectrum_deep.mat')
%     HPC_Low_tsd = tsd(Spectro{2}*1e4 , Spectro{1});
%
%     HPC_Low_AroundRipples_FzShock = Restrict(HPC_Low_tsd , and(Fz_shock , AroundRipples));
%     HPC_Low_FzShock = Restrict(HPC_Low_tsd , Fz_shock);
%     HPC_Low_AroundRipples_FzSafe = Restrict(HPC_Low_tsd , and(Fz_safe , AroundRipples));
%     HPC_Low_FzSafe = Restrict(HPC_Low_tsd , Fz_safe);
%
%     plot(RangeLow , nanmean(Data(HPC_Low_AroundRipples_FzShock)) , 'r' , 'LineWidth' , 2)
%     hold on
%     plot(RangeLow , nanmean(Data(HPC_Low_AroundRipples_FzSafe)) , 'b' , 'LineWidth' , 2)
%     makepretty;
%     title('HPC Low around ripples'); ylabel('Power (a.u.)'); xlabel('Frequency (Hz)')
%
%     cd('/media/nas4/ProjetEmbReact/Mouse777/20180828/ProjectEmbReact_M777_20180828_SleepPost_PreDrug')
%     load('IdFigureData2.mat', 'ripples_curves')
%     axes('Position',[.53 .24 .05 .07]); box on
%     plot(ripples_curves{1, 1}(:,2),'k')
%     hold on
%     plot(ripples_curves{1, 3}(:,2),'g')
%     xlim([200 801]); ylim([-2.5e3 2e3]); makepretty
%
% else
%
%     cd('/media/nas4/ProjetEmbReact/Mouse777/20180828/ProjectEmbReact_M777_20180828_ExtinctionBlockedShock_PostDrug/Ext2/')
%     load('RipplesSleepThresh.mat')
%     load('behavResources_SB.mat')
%
%     Fz_shock = and(Behav.FreezeAccEpoch , Behav.ZoneEpoch{1});
%
%     AroundRipples = intervalSet(Start(RipplesEpochR)-.3e4 , Stop(RipplesEpochR)+.3e4);
%
%     load('H_Low_Spectrum_deep.mat')
%     HPC_Low_tsd_Sk = tsd(Spectro{2}*1e4 , Spectro{1});
%     HPC_Low_AroundRipples_FzShock = Restrict(HPC_Low_tsd , and(Fz_shock , AroundRipples));
%
%     cd('/media/nas4/ProjetEmbReact/Mouse777/20180828/ProjectEmbReact_M777_20180828_ExtinctionBlockedSafe_PostDrug/Ext2/')
%     load('RipplesSleepThresh.mat')
%     load('behavResources_SB.mat')
%
%     Fz_safe = and(Behav.FreezeAccEpoch , or(Behav.ZoneEpoch{5} , Behav.ZoneEpoch{2}));
%
%     AroundRipples = intervalSet(Start(RipplesEpochR)-.3e4 , Stop(RipplesEpochR)+.3e4);
%
%     load('H_Low_Spectrum_deep.mat')
%     HPC_Low_tsd_Sf = tsd(Spectro{2}*1e4 , Spectro{1});
%     HPC_Low_AroundRipples_FzSafe = Restrict(HPC_Low_tsd , and(Fz_safe , AroundRipples));
%
%     plot(RangeLow , nanmean(Data(HPC_Low_AroundRipples_FzShock)) , 'r' , 'LineWidth' , 2)
%     hold on
%     plot(RangeLow , nanmean(Data(HPC_Low_AroundRipples_FzSafe)) , 'b' , 'LineWidth' , 2)
%     makepretty;
%     title('HPC Low around ripples'); ylabel('Power (a.u.)'); xlabel('Frequency (Hz)'); ylim([0 3e5])
%
%     cd('/media/nas4/ProjetEmbReact/Mouse777/20180828/ProjectEmbReact_M777_20180828_SleepPost_PreDrug')
%     load('IdFigureData2.mat', 'ripples_curves')
%     axes('Position',[.53 .24 .05 .07]); box on
%     plot(ripples_curves{1, 1}(:,2),'k')
%     hold on
%     plot(ripples_curves{1, 3}(:,2),'g')
%     xlim([200 801]); ylim([-2.5e3 2e3]); makepretty
%
% end


% OB-PFC coherence
subplot(3,5,14); thr=1;
f = linspace(0,20,size(OutPutData.Cond.ob_pfc_coherence.mean,3));
Data_to_use = squeeze(OutPutData.(Session_type{sess}).ob_pfc_coherence.mean(:,5,:));
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(Data_to_use);
shadedErrorBar(f , Mean_All_Sp , Conf_Inter,'-r',1); hold on;
[c,d]=max(Mean_All_Sp(:,thr+1:end)); vline(f(d+thr),'--r')
Data_to_use = squeeze(OutPutData.(Session_type{sess}).ob_pfc_coherence.mean(:,6,:));
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(Data_to_use);
shadedErrorBar(f , Mean_All_Sp , Conf_Inter,'-b',1); hold on;
[c,d]=max(Mean_All_Sp(:,thr+1:end)); vline(f(d+thr),'--b')
makepretty; xlim([0 20]);
xlabel('Frequency (Hz)'); ylabel('Power (a.u.)')
title('OB-PFC coherence')


% Ripples
subplot(3,5,15)
OutPutData.(Session_type{sess}).ripples.mean(OutPutData.(Session_type{sess}).ripples.mean==0)=NaN;
MakeSpreadAndBoxPlot2_SB(OutPutData.(Session_type{sess}).ripples.mean(:,5:6),Cols,X,Legends,'showpoints',0,'paired',1);
ylabel('Density (#/s)'); title('Ripples density')



if sess==1
    a=suptitle('Brain characterization, saline SB, Cond sessions, n=7'); a.FontSize=20;
else
    a=suptitle('Brain characterization, saline SB, Ext sessions, n=7'); a.FontSize=20;
end





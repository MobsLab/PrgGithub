%% To plot the figure you need to load data : 
Get_sleep_data_post_SDS_MC
Get_raw_data_short_long_REM_examples_MC

%% FIGURE 3
figure

col_ctrl = [.7 .7 .7];
col_SD = [1 .4 0];
col_mCherry_cno = [1 .2 0];
col_dreadd_cno = [0 .4 .4];

isparam=0;
iscorr=1;


subplot(4,7,1,'align')
MakeSpreadAndBoxPlot2_MC({(num_moyen_rem_short_ctrl_1./sum(data_num_REM_ctrl,2)')*100,...
    (num_moyen_rem_short_SD_1./sum(data_num_REM_SD,2)')*100,...
    (num_moyen_rem_short_SD_mCherry_cno_1./sum(data_num_REM_SD_mCherry_cno,2)')*100,...
    (num_moyen_rem_short_SD_dreadd_cno_1./sum(data_num_REM_SD_dreadd_cno,2)')*100},...
    {col_ctrl,col_SD,col_mCherry_cno,col_dreadd_cno},[1:4],{},'paired',0,'showsigstar','none')
ylabel('Short REM percentage')
makeprettyMC
%test stat
[p_1_2 ,h_1_2] = ranksum((num_moyen_rem_short_ctrl_1./sum(data_num_REM_ctrl,2)')*100, (num_moyen_rem_short_SD_1./sum(data_num_REM_SD,2)')*100);
[p_1_3, h_1_3] = ranksum((num_moyen_rem_short_ctrl_1./sum(data_num_REM_ctrl,2)')*100, (num_moyen_rem_short_SD_mCherry_cno_1./sum(data_num_REM_SD_mCherry_cno,2)')*100);
[p_1_4 ,h_1_4] = ranksum((num_moyen_rem_short_ctrl_1./sum(data_num_REM_ctrl,2)')*100, (num_moyen_rem_short_SD_dreadd_cno_1./sum(data_num_REM_SD_dreadd_cno,2)')*100);
[p_2_3, h_2_3] = ranksum((num_moyen_rem_short_SD_mCherry_cno_1./sum(data_num_REM_SD_mCherry_cno,2)')*100, (num_moyen_rem_short_SD_1./sum(data_num_REM_SD,2)')*100);
[p_2_4, h_2_4] = ranksum((num_moyen_rem_short_SD_1./sum(data_num_REM_SD,2)')*100, (num_moyen_rem_short_SD_dreadd_cno_1./sum(data_num_REM_SD_dreadd_cno,2)')*100);
[p_3_4, h_3_4] = ranksum((num_moyen_rem_short_SD_mCherry_cno_1./sum(data_num_REM_SD_mCherry_cno,2)')*100, (num_moyen_rem_short_SD_dreadd_cno_1./sum(data_num_REM_SD_dreadd_cno,2)')*100);
%add corrections for multiple comparisons
p_values = [p_1_2 p_1_3 p_1_4 p_2_3 p_2_4 p_3_4];
[h, crit_p, adj_ci_cvrg, adj_p] = fdr_bh(p_values);
if adj_p(1)<0.05; sigstar_MC({[1 2]},adj_p(1),0,'LineWigth',16,'StarSize',24);end
if adj_p(2)<0.05; sigstar_MC({[1 3]},adj_p(2),0,'LineWigth',16,'StarSize',24);end
if adj_p(3)<0.05; sigstar_MC({[1 4]},adj_p(3),0,'LineWigth',16,'StarSize',24);end
if adj_p(4)<0.05; sigstar_MC({[2 3]},adj_p(4),0,'LineWigth',16,'StarSize',24);end
if adj_p(5)<0.05; sigstar_MC({[2 4]},adj_p(5),0,'LineWigth',16,'StarSize',24);end
if adj_p(6)<0.05; sigstar_MC({[3 4]},adj_p(6),0,'LineWigth',16,'StarSize',24);end


subplot(4,7,2,'align')
MakeSpreadAndBoxPlot2_MC({(num_moyen_rem_long_ctrl./sum(data_num_REM_ctrl,2)')*100,...
    (num_moyen_rem_long_SD./sum(data_num_REM_SD,2)')*100,...
    (num_moyen_rem_long_SD_mCherry_cno./sum(data_num_REM_SD_mCherry_cno,2)')*100,...
    (num_moyen_rem_long_SD_dreadd_cno./sum(data_num_REM_SD_dreadd_cno,2)')*100},...
    {col_ctrl,col_SD,col_mCherry_cno,col_dreadd_cno},[1:4],{},'paired',0,'showsigstar','none')
ylabel('long REM percentage')
makeprettyMC
%test stat
[p_1_2 ,h_1_2] = ranksum((num_moyen_rem_long_ctrl./sum(data_num_REM_ctrl,2)')*100, (num_moyen_rem_long_SD./sum(data_num_REM_SD,2)')*100);
[p_1_3, h_1_3] = ranksum((num_moyen_rem_long_ctrl./sum(data_num_REM_ctrl,2)')*100, (num_moyen_rem_long_SD_mCherry_cno./sum(data_num_REM_SD_mCherry_cno,2)')*100);
[p_1_4 ,h_1_4] = ranksum((num_moyen_rem_long_ctrl./sum(data_num_REM_ctrl,2)')*100, (num_moyen_rem_long_SD_dreadd_cno./sum(data_num_REM_SD_dreadd_cno,2)')*100);
[p_2_3, h_2_3] = ranksum((num_moyen_rem_long_SD_mCherry_cno./sum(data_num_REM_SD_mCherry_cno,2)')*100, (num_moyen_rem_long_SD./sum(data_num_REM_SD,2)')*100);
[p_2_4, h_2_4] = ranksum((num_moyen_rem_long_SD./sum(data_num_REM_SD,2)')*100, (num_moyen_rem_long_SD_dreadd_cno./sum(data_num_REM_SD_dreadd_cno,2)')*100);
[p_3_4, h_3_4] = ranksum((num_moyen_rem_long_SD_mCherry_cno./sum(data_num_REM_SD_mCherry_cno,2)')*100, (num_moyen_rem_long_SD_dreadd_cno./sum(data_num_REM_SD_dreadd_cno,2)')*100);
%add correction for multiple comparisons
p_values = [p_1_2 p_1_3 p_1_4 p_2_3 p_2_4 p_3_4];
[h, crit_p, adj_ci_cvrg, adj_p] = fdr_bh(p_values);
if adj_p(1)<0.05; sigstar_MC({[1 2]},adj_p(1),0,'LineWigth',16,'StarSize',24);end
if adj_p(2)<0.05; sigstar_MC({[1 3]},adj_p(2),0,'LineWigth',16,'StarSize',24);end
if adj_p(3)<0.05; sigstar_MC({[1 4]},adj_p(3),0,'LineWigth',16,'StarSize',24);end
if adj_p(4)<0.05; sigstar_MC({[2 3]},adj_p(4),0,'LineWigth',16,'StarSize',24);end
if adj_p(5)<0.05; sigstar_MC({[2 4]},adj_p(5),0,'LineWigth',16,'StarSize',24);end
if adj_p(6)<0.05; sigstar_MC({[3 4]},adj_p(6),0,'LineWigth',16,'StarSize',24);end


subplot(4,7,3,'align')
MakeSpreadAndBoxPlot2_MC({(num_moyen_rem_mid_ctrl./sum(data_num_REM_ctrl,2)')*100,...
    (num_moyen_rem_mid_SD./sum(data_num_REM_SD,2)')*100,...
    (num_moyen_rem_mid_SD_mCherry_cno./sum(data_num_REM_SD_mCherry_cno,2)')*100,...
    (num_moyen_rem_mid_SD_dreadd_cno./sum(data_num_REM_SD_dreadd_cno,2)')*100},...
    {col_ctrl,col_SD,col_mCherry_cno,col_dreadd_cno},[1:4],{},'paired',0,'showsigstar','none')
ylabel('mid REM percentage')
makeprettyMC
%test stat
[p_1_2 ,h_1_2] = ranksum((num_moyen_rem_mid_ctrl./sum(data_num_REM_ctrl,2)')*100, (num_moyen_rem_mid_SD./sum(data_num_REM_SD,2)')*100);
[p_1_3, h_1_3] = ranksum((num_moyen_rem_mid_ctrl./sum(data_num_REM_ctrl,2)')*100, (num_moyen_rem_mid_SD_mCherry_cno./sum(data_num_REM_SD_mCherry_cno,2)')*100);
[p_1_4 ,h_1_4] = ranksum((num_moyen_rem_mid_ctrl./sum(data_num_REM_ctrl,2)')*100, (num_moyen_rem_mid_SD_dreadd_cno./sum(data_num_REM_SD_dreadd_cno,2)')*100);
[p_2_3, h_2_3] = ranksum((num_moyen_rem_mid_SD_mCherry_cno./sum(data_num_REM_SD_mCherry_cno,2)')*100, (num_moyen_rem_mid_SD./sum(data_num_REM_SD,2)')*100);
[p_2_4, h_2_4] = ranksum((num_moyen_rem_mid_SD./sum(data_num_REM_SD,2)')*100, (num_moyen_rem_mid_SD_dreadd_cno./sum(data_num_REM_SD_dreadd_cno,2)')*100);
[p_3_4, h_3_4] = ranksum((num_moyen_rem_mid_SD_mCherry_cno./sum(data_num_REM_SD_mCherry_cno,2)')*100, (num_moyen_rem_mid_SD_dreadd_cno./sum(data_num_REM_SD_dreadd_cno,2)')*100);
%add correction for multiple comparison
p_values = [p_1_2 p_1_3 p_1_4 p_2_3 p_2_4 p_3_4];
[h, crit_p, adj_ci_cvrg, adj_p] = fdr_bh(p_values);
if adj_p(1)<0.05; sigstar_MC({[1 2]},adj_p(1),0,'LineWigth',16,'StarSize',24);end
if adj_p(2)<0.05; sigstar_MC({[1 3]},adj_p(2),0,'LineWigth',16,'StarSize',24);end
if adj_p(3)<0.05; sigstar_MC({[1 4]},adj_p(3),0,'LineWigth',16,'StarSize',24);end
if adj_p(4)<0.05; sigstar_MC({[2 3]},adj_p(4),0,'LineWigth',16,'StarSize',24);end
if adj_p(5)<0.05; sigstar_MC({[2 4]},adj_p(5),0,'LineWigth',16,'StarSize',24);end
if adj_p(6)<0.05; sigstar_MC({[3 4]},adj_p(6),0,'LineWigth',16,'StarSize',24);end



%% exmaple short REM
subplot(4,8,[1:2],'align')
imagesc(Range(sptsdH)/1E4/60, freqH, 10*log10(SpectroH.Spectro{1}')), axis xy, ylabel('Frequency (Hz)'), caxis([30 50]), colormap jet
caxis([30 42])
xlim([323 325]) %d=data_theta(:,1); xlim([d(1)/60 d(end)/60]);
line([1.94142e4/60 1.94142e4/60],ylim,'color','w')
line([en(idx_short_rem(i_short))/60 en(idx_short_rem(i_short))/60],ylim,'color','w')
set(gca,'fontsize',16)
xlim([323 324.8])

%%exmaple long REM
subplot(4,8,[17:18],'align')
imagesc(Range(sptsdH)/1E4/60, freqH, 10*log10(SpectroH.Spectro{1}')), axis xy, ylabel('Frequency (Hz)'), caxis([30 50]), colormap jet
caxis([30 42])
xlim([456 458])%d=data_theta(:,1); xlim([d(1)/60 d(end)/60]);
line([2.73954e4/60 2.73954e4/60],ylim,'color','w')
line([2.7459e4/60 2.7459e4/60],ylim,'color','w')
set(gca,'fontsize',16)
xlim([456.2 458])

subplot(4,8,[9:10],'align')
plot(data_theta_short(:,1)/60, data_theta_short(:,2),'color',[.4 .4 .4]), hold on
plot(Range(filter_emg_short)/60, Data(filter_emg_short)-4000, 'color', [0 0 0])
title(['dur REM = ', num2str(dur_REM(idx_short_rem(i_short)))]);
xlim([323 325]) %xlim([d(1)/60 d(end)/60]);
% ylim([-5500 3500])
line([1.94142e4/60 1.94142e4/60],ylim,'color','r')
line([en(idx_short_rem(i_short))/60 en(idx_short_rem(i_short))/60],ylim,'color','r')
set(gca,'fontsize',16)
xlim([323 324.8])
line([323.28 323.28],ylim,'color','b')
% line([323.33 323.33],ylim,'color','b')
line([323.31 323.31],ylim,'color','b')

line([323.645 323.645],ylim,'color','k')
% line([323.695 323.695],ylim,'color','k')
line([323.675 323.675],ylim,'color','k')


subplot(4,8,[25:26],'align')
plot(data_theta_long(:,1)/60, data_theta_long(:,2),'color',[.4 .4 .4]), hold on
plot(Range(filter_emg_long)/60, Data(filter_emg_long)-4000, 'color', [0 0 0])
xlim([456 458])%xlim([d(1)/60 d(end)/60]);
% ylim([-5500 3500])
title(['dur REM = ', num2str(dur_REM(idx_long_rem(i_long)))]); %title(['dur REM = 63.59s'])
line([2.73954e4/60 2.73954e4/60],ylim,'color','r')
line([2.7459e4/60 2.7459e4/60],ylim,'color','r')
set(gca,'fontsize',16)
xlim([456.2 458])
line([456.27 456.27],ylim,'color','b')
% line([456.32 456.32],ylim,'color','b')
line([456.3 456.3],ylim,'color','b')
line([457.07 457.07],ylim,'color','k')
% line([457.12 457.12],ylim,'color','k')
line([457.1 457.1],ylim,'color','k')

subplot(4,8,[4],'align')
plot(data_hpc_sws_short(:,1)/60, data_hpc_sws_short(:,2),'color',[.4 .4 .4]), hold on
plot(data_emg_short(:,1)/60, data_emg_short(:,2)-4000,'color',[0 0 0]), hold on
a=323.28; xlim([a a+0.03]) 
ylim([-5000 2000])

subplot(4,8,[12],'align')
plot(data_theta_short(:,1)/60, data_theta_short(:,2),'color',[.4 .4 .4]), hold on
plot(data_emg_short(:,1)/60, data_emg_short(:,2)-4000,'color',[0 0 0]), hold on
a=323.645; xlim([a a+0.03]) 
ylim([-5000 2000])

subplot(4,8,[20],'align')
plot(data_hpc_sws_long(:,1)/60, data_hpc_sws_long(:,2),'color',[.4 .4 .4]), hold on
plot(data_emg_long(:,1)/60, data_emg_long(:,2)-4000,'color',[0 0 0]), hold on
a=456.27; xlim([a a+0.03]) 
ylim([-5000 2000])

subplot(4,8,[28],'align')
plot(data_theta_long(:,1)/60, data_theta_long(:,2),'color',[.4 .4 .4]), hold on
plot(data_emg_long(:,1)/60, data_emg_long(:,2)-4000,'color',[0 0 0]), hold on
a=457.07; xlim([a a+0.03]) 
ylim([-5000 2000])








%%



col_short_rem = [1 .8 .6];
col_long_rem = [1 .4 .0];


figure


subplot(4,8,6,'align')
MakeSpreadAndBoxPlot2_MC({(num_moyen_rem_short_ctrl_1./sum(data_num_REM_ctrl,2)')*100,...
    (num_moyen_rem_short_SD_1./sum(data_num_REM_SD,2)')*100,...
    (num_moyen_rem_short_SD_mCherry_cno_1./sum(data_num_REM_SD_mCherry_cno,2)')*100,...
    (num_moyen_rem_short_SD_dreadd_cno_1./sum(data_num_REM_SD_dreadd_cno,2)')*100},...
    {col_ctrl,col_SD,col_mCherry_cno,col_dreadd_cno},[1:4],{},'paired',0,'showsigstar','none')
ylabel('Short REM percentage')
makeprettyMC
%test stat
[p_1_2 ,h_1_2] = ranksum((num_moyen_rem_short_ctrl_1./sum(data_num_REM_ctrl,2)')*100, (num_moyen_rem_short_SD_1./sum(data_num_REM_SD,2)')*100);
[p_1_3, h_1_3] = ranksum((num_moyen_rem_short_ctrl_1./sum(data_num_REM_ctrl,2)')*100, (num_moyen_rem_short_SD_mCherry_cno_1./sum(data_num_REM_SD_mCherry_cno,2)')*100);
[p_1_4 ,h_1_4] = ranksum((num_moyen_rem_short_ctrl_1./sum(data_num_REM_ctrl,2)')*100, (num_moyen_rem_short_SD_dreadd_cno_1./sum(data_num_REM_SD_dreadd_cno,2)')*100);
[p_2_3, h_2_3] = ranksum((num_moyen_rem_short_SD_mCherry_cno_1./sum(data_num_REM_SD_mCherry_cno,2)')*100, (num_moyen_rem_short_SD_1./sum(data_num_REM_SD,2)')*100);
[p_2_4, h_2_4] = ranksum((num_moyen_rem_short_SD_1./sum(data_num_REM_SD,2)')*100, (num_moyen_rem_short_SD_dreadd_cno_1./sum(data_num_REM_SD_dreadd_cno,2)')*100);
[p_3_4, h_3_4] = ranksum((num_moyen_rem_short_SD_mCherry_cno_1./sum(data_num_REM_SD_mCherry_cno,2)')*100, (num_moyen_rem_short_SD_dreadd_cno_1./sum(data_num_REM_SD_dreadd_cno,2)')*100);
%add corrections for multiple comparisons
p_values = [p_1_2 p_1_3 p_1_4 p_2_3 p_2_4 p_3_4];
[h, crit_p, adj_ci_cvrg, adj_p] = fdr_bh(p_values);
if adj_p(1)<0.05; sigstar_MC({[1 2]},adj_p(1),0,'LineWigth',16,'StarSize',24);end
if adj_p(2)<0.05; sigstar_MC({[1 3]},adj_p(2),0,'LineWigth',16,'StarSize',24);end
if adj_p(3)<0.05; sigstar_MC({[1 4]},adj_p(3),0,'LineWigth',16,'StarSize',24);end
if adj_p(4)<0.05; sigstar_MC({[2 3]},adj_p(4),0,'LineWigth',16,'StarSize',24);end
if adj_p(5)<0.05; sigstar_MC({[2 4]},adj_p(5),0,'LineWigth',16,'StarSize',24);end
if adj_p(6)<0.05; sigstar_MC({[3 4]},adj_p(6),0,'LineWigth',16,'StarSize',24);end



subplot(4,8,[7,8],'align'), hold on
s2=shadedErrorBar(freqH, runmean(nanmean(log10(Data(Restrict(sptsdH,long_REMEpoch)))),5), sp_HPC_long_REM_SEM_norm, 'k', 1); 
line([freqH(xmax_long.loc(2)) freqH(xmax_long.loc(2))],ylim,'color',col_long_rem,'linestyle','-','linewidth',0.5)
makeprettyMC
set(s2.edge, 'linewidth', 0.1, 'color', 'none');
s2.mainLine.Color=col_long_rem; s2.mainLine.LineWidth=2;
s2.patch.FaceColor=col_long_rem;

s1=shadedErrorBar(freqH, runmean(nanmean(log10(Data(Restrict(sptsdH,short_REMEpoch)))),5), sp_HPC_short_REM_SEM_norm, 'r', 1); 
line([freqH(xmax_short.loc(2)) freqH(xmax_short.loc(2))],ylim,'color',col_short_rem,'linestyle','-','linewidth',0.5)
set(s1.edge, 'linewidth', 0.1, 'color', 'none');
s1.mainLine.Color=col_short_rem; s1.mainLine.LineWidth=2;
s1.patch.FaceColor=col_short_rem;

ylim([2.5 4.2])
xlabel('Frequency (Hz)')
ylabel('Power (a.u. log scale)')



subplot(4,8,[1:3],'align')
imagesc(Range(sptsdH)/1E4/60, freqH, log10(SpectroH.Spectro{1}')), axis xy, ylabel('Frequency (Hz)'), colormap jet
caxis([3 4.2])
xlim([323 325]) 
line([1.94142e4/60 1.94142e4/60],ylim,'color','w')
line([en(idx_short_rem(i_short))/60 en(idx_short_rem(i_short))/60],ylim,'color','w')
set(gca,'fontsize',16)
xlim([323 324.8])

%%exmaple long REM
subplot(4,8,[17:19],'align')
imagesc(Range(sptsdH)/1E4/60, freqH, log10(SpectroH.Spectro{1}')), axis xy, ylabel('Frequency (Hz)'), colormap jet
caxis([3 4.2])
xlim([456 458])
line([2.73954e4/60 2.73954e4/60],ylim,'color','w')
line([2.7459e4/60 2.7459e4/60],ylim,'color','w')
set(gca,'fontsize',16)
xlim([456.2 458])


subplot(4,8,[9:11],'align')
plot(data_theta_short(:,1)/60, data_theta_short(:,2),'color',[.4 .4 .4]), hold on
plot(Range(filter_emg_short)/60, Data(filter_emg_short)-4000, 'color', [0 0 0])
title(['dur REM = ', num2str(dur_REM(idx_short_rem(i_short)))]);
xlim([323 325])
line([1.94142e4/60 1.94142e4/60],ylim,'color','r')
line([en(idx_short_rem(i_short))/60 en(idx_short_rem(i_short))/60],ylim,'color','r')
set(gca,'fontsize',16)
xlim([323 324.8])
ylim([-1.5e4 1.5e4])

line([323.28 323.28],ylim,'color','b')
line([323.33 323.33],ylim,'color','b')
line([323.645 323.645],ylim,'color','k')
line([323.695 323.695],ylim,'color','k')


subplot(4,8,[25:27],'align')
plot(data_theta_long(:,1)/60, data_theta_long(:,2),'color',[.4 .4 .4]), hold on
plot(Range(filter_emg_long)/60, Data(filter_emg_long)-4000, 'color', [0 0 0])
xlim([456 458])
title(['dur REM = ', num2str(dur_REM(idx_long_rem(i_long)))]);
line([2.73954e4/60 2.73954e4/60],ylim,'color','r')
line([2.7459e4/60 2.7459e4/60],ylim,'color','r')
set(gca,'fontsize',16)
xlim([456.2 458])
ylim([-1.5e4 1.5e4])

line([456.27 456.27],ylim,'color','b')
line([456.32 456.32],ylim,'color','b')
line([457.07 457.07],ylim,'color','k')
line([457.12 457.12],ylim,'color','k')


subplot(4,8,[4,5],'align')
plot(data_hpc_sws_short(:,1)/60, data_hpc_sws_short(:,2),'color',[.4 .4 .4]), hold on
plot(data_emg_short(:,1)/60, data_emg_short(:,2)-4000,'color',[0 0 0]), hold on
a=323.28; xlim([a a+0.05]) 
ylim([-5000 2000])
ylim([-1.5e4 1.5e4])

subplot(4,8,[12,13],'align')
plot(data_theta_short(:,1)/60, data_theta_short(:,2),'color',[.4 .4 .4]), hold on
plot(data_emg_short(:,1)/60, data_emg_short(:,2)-4000,'color',[0 0 0]), hold on
a=323.645; xlim([a a+0.05]) 
ylim([-5000 2000])
ylim([-1.5e4 1.5e4])

subplot(4,8,[20,21],'align')
plot(data_hpc_sws_long(:,1)/60, data_hpc_sws_long(:,2),'color',[.4 .4 .4]), hold on
plot(data_emg_long(:,1)/60, data_emg_long(:,2)-4000,'color',[0 0 0]), hold on
a=456.27; xlim([a a+0.05]) 
ylim([-5000 2000])
ylim([-1.5e4 1.5e4])

subplot(4,8,[28,29],'align')
plot(data_theta_long(:,1)/60, data_theta_long(:,2),'color',[.4 .4 .4]), hold on
plot(data_emg_long(:,1)/60, data_emg_long(:,2)-4000,'color',[0 0 0]), hold on
a=457.07; xlim([a a+0.05]) 
ylim([-5000 2000])
ylim([-1.5e4 1.5e4])


subplot(4,8,[14:16],'align'), SleepStages=PlotSleepStage(Wake,SWSEpoch,REMEpoch,0,[1 4]); xlim([323*60 324.8*60]);
subplot(4,8,[22:24],'align'), SleepStages=PlotSleepStage(Wake,SWSEpoch,REMEpoch,0,[1 4]); xlim([456.2*60 458*60]);


%%
% figure
% iwake=50; subplot(4,8,[9:11],'align'), plot(Range(Restrict(SqurdEMG,subset(Wake,iwake)))/1e4/60, Data(Restrict(SqurdEMG,subset(Wake,iwake)))); ylim([-1.5e4 1.5e4])

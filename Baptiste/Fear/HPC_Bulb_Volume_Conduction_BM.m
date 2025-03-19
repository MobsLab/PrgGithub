

Mouse=[666 667 668 669 688 739 777 779 849 893];
Mouse=[666];

[OutPutData , Epoch , NameEpoch , OutPutTSD]=MeanValuesPhysiologicalParameters_BM(Mouse,'cond','ob_low','hpc_low');


Cols = {[1, 0.8, 0.8],[1, 0.5, 0.5],[0.5 0.5 1],[0.8 0.8 1]};
X = [1,2,3,4];
Legends = {'Active shock','Freezing shock','Freezing safe','Active safe'};



figure
MakeSpreadAndBoxPlot2_SB(OutPutData.ob_low.max_freq(:,[7 5 6 8]) ,Cols,X,Legends,'showpoints',0,'paired',1); makepretty; xtickangle(45);
ylabel('Frequency (Hz)'); 


figure
for i=1:8
    subplot(1,8,i)
    
    Conf_Inter=nanstd(squeeze(OutPutData.hpc_low.norm(:,i,:)))/sqrt(size(squeeze(OutPutData.hpc_low.norm),1));
    shadedErrorBar(Spectro{3},nanmean(squeeze(OutPutData.hpc_low.norm(:,i,:))),Conf_Inter,'-b',1); hold on;
    ylim([-1 3]); xlim([0 15])
    title(NameEpoch{i})
    [c,d]=max(nanmean(squeeze(OutPutData.hpc_low.norm(:,i,52:end))));
    vline(Spectro{3}(d+51),'--r')
    
end


figure
Conf_Inter=nanstd(squeeze(OutPutData.hpc_low.norm(:,5,:)))/sqrt(size(squeeze(OutPutData.hpc_low.norm),1));
shadedErrorBar(Spectro{3},nanmean(squeeze(OutPutData.hpc_low.norm(:,5,:))),Conf_Inter,'-r',1); hold on;
Conf_Inter=nanstd(squeeze(OutPutData.hpc_low.norm(:,6,:)))/sqrt(size(squeeze(OutPutData.hpc_low.norm),1));
shadedErrorBar(Spectro{3},nanmean(squeeze(OutPutData.hpc_low.norm(:,6,:))),Conf_Inter,'-b',1); hold on;
ylim([-1 3])
xlim([0 12])
makepretty
xlabel('Frequency (Hz)')
ylabel('Power (A.U.)')
f=get(gca,'Children');
legend([f(8),f(4)],'Shock side freezing','Safe side freezing')
title('Low HPC mean spectrum')
vline(3,'--r'); vline(8,'--r')

figure
Conf_Inter=nanstd(squeeze(OutPutData.hpc_low.norm(:,5,:)))/sqrt(size(squeeze(OutPutData.hpc_low.norm),1));
shadedErrorBar(Spectro{3},nanmean(squeeze(OutPutData.hpc_low.norm(:,5,:))),Conf_Inter,'-g',1); hold on;
Conf_Inter=nanstd(squeeze(OutPutData.ob_low.norm(:,5,:)))/sqrt(size(squeeze(OutPutData.ob_low.norm),1));
shadedErrorBar(Spectro{3},nanmean(squeeze(OutPutData.ob_low.norm(:,5,:))),Conf_Inter,'-r',1); hold on;
ylim([-1 3])
xlim([0 12])
makepretty
xlabel('Frequency (Hz)')
ylabel('Power (A.U.)')
f=get(gca,'Children');
legend([f(8),f(4)],'HPC','OB')
title('Low mean spectrum during shock side freezing, n=10')
vline(3,'--r'); vline(8,'--r')



Cols = {[1, 0.8, 0.8],[1, 0.5, 0.5],[0.5 0.5 1],[0.8 0.8 1],[1, 0.8, 0.8],[1, 0.5, 0.5],[0.5 0.5 1],[0.8 0.8 1]};

figure
MakeSpreadAndBoxPlot2_SB(OutPutData.hpc_low.max_freq(:,[1:8]) ,Cols,[1:8],NameEpoch,'showpoints',0,'paired',1); xtickangle(45);
ylabel('Frequency (Hz)'); 
figure
plot(squeeze(OutPutData.ob_low.norm(:,5,:))')




[u,v]=max(squeeze(OutPutData.hpc_low.norm(:,5,21:end))');
v2=v+20;
figure
MakeSpreadAndBoxPlot2_SB([OutPutData.ob_low.max_freq(:,5) Spectro{3}(v2)'],{[0, 0.4470, 0.7410],[0.4660, 0.6740, 0.1880]},[1,2],{'OB','HPC'},'showpoints',0,'paired',1)
ylabel('Frequency (Hz)')




%% Phase preference HPC/Bulb Shock side freezing

Mouse=[667];

[OutPutData2 , Epoch2 , NameEpoch2 , OutPutTSD2]=MeanValuesPhysiologicalParameters_BM(Mouse,'cond','hpc_low','lfp',29);


LFP_OB_Shock_Fz=Restrict(OutPutTSD2.lfp{1, 1}  , Epoch2{1, 5}  );

figure
plot(Data(LFP_OB_Shock_Fz))



[P,f,VBinnedPhase]=PrefPhaseSpectrum( LFP_OB_Shock_Fz , Data(OutPutData2.hpc_low.spectrogram{1, 5}) , Range(OutPutData2.hpc_low.spectrogram{1, 5})/1e4 , Spectro{3} , [3 8] , 30)
caxis([0 1e5])
a=suptitle('Low HPC spectro on Low OB phase, Shock side freezing'); a.FontSize=20;



%% Coherence HPC/Bulb Shock side freezing

[OutPutData3 , Epoch3 , NameEpoch3 , OutPutTSD3]=MeanValuesPhysiologicalParameters_BM(Mouse,'cond','lfp',29,'lfp',8);

params.Fs=1/median(diff(Range(OutPutTSD3.lfp{1, 1},'s')));
% params.tapers=[3,5];
params.tapers=[5,9];
params.fpass=[0 25];
params.err=[2,0.05];
params.pad=0;


LFP_OB_Shock_Fz=Restrict(OutPutTSD3.lfp{1, 1} , Epoch2{1, 5});
LFP_HPC_Shock_Fz=Restrict(OutPutTSD3.lfp{3, 1} , Epoch2{1, 5});


[C,phi,S12,S1,S2,f,confC,phistd,Cerr]=coherencyc(Data(LFP_OB_Shock_Fz),Data(LFP_HPC_Shock_Fz),params);

params.tapers=[3,5];
movingwin=[3,0.5];
[Ctemp,phi,S12,S1temp,S2temp,t,f,confC,phitemp,Cerr]=cohgramc( Data(LFP_OB_Shock_Fz) , Data(LFP_HPC_Shock_Fz) , movingwin,params);

pas=1;
smo=1;


figure('color',[1 1 1]),
%  subplot(2,2,1), plot(f(1:pas:end),10*log10(SmoothDec(S1(1:pas:end),5)))
%  subplot(2,2,3), plot(f(1:pas:end),10*log10(SmoothDec(S2(1:pas:end),5)))
subplot(2,2,1), plot(f(1:pas:end),(SmoothDec(S1(1:pas:end),smo)),'k','linewidth',2),title(['HPC vs. OB']),xlim([params.fpass(1) params.fpass(2)])

subplot(2,2,3), plot(f(1:pas:end),(SmoothDec(S2(1:pas:end),smo)),'k','linewidth',2),xlim([params.fpass(1) params.fpass(2)])
subplot(2,2,2),























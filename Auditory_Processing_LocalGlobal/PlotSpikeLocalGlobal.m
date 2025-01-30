%PlotSpikeLocalGlobal
load SpikeData S
load SpkLocalGlobal
%---------------------------------------------------------------------------------------------------------------------------------------------

for i=1:length(S)
%<><><><><><><><><><><><><><><><><><><><><><>   Local Effect   <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
figure,subplot(4,1,1)
hold on, plot(SmoothDec(mean((Data(Spk_Local_std(i))/length(Spk_Local_std(i)))),smo),'k','linewidth',1);
hold on, plot(SmoothDec(mean((Data(Spk_Local_dvt(i))/length(Spk_Local_dvt(i)))),smo),'r','linewidth',1);
maxAxis=max(mean((Data(Spk_Local_std(i))/length(Spk_Local_std(i)))));
for a=0:150:600; hold on, plot(a,0:0.1:maxAxis,'b','linewidth',1); end
xlim([0 1200])
ylabel(['Local effect - neuron#',num2str(i)])
%<><><><><><><><><><><><><><><><><><><><><><>   Global effect (local std)   <><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
hold on,subplot(4,1,2)
hold on, plot(SmoothDec(mean((Data(Spk_GlobaLstd_std(i))/length(Spk_GlobaLstd_std(i)))),smo),'k','linewidth',1);
hold on, plot(SmoothDec(mean((Data(Spk_GlobaLstd_dvt(i))/length(Spk_GlobaLstd_dvt(i)))),smo),'r','linewidth',1);
for a=0:150:600; hold on, plot(a,0:0.1:maxAxis,'b','linewidth',1); end
xlim([0 1200])
ylabel(['Global effect (local std) - neuron#',num2str(i)])
%<><><><><><><><><><><><><><><><><><><><><><>   Global effect (local dvt)   <><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
hold on,subplot(4,1,3)
hold on, plot(SmoothDec(mean((Data(Spk_GlobaLdvt_std(i))/length(Spk_GlobaLdvt_std(i)))),smo),'k','linewidth',1);
hold on, plot(SmoothDec(mean((Data(Spk_GlobaLdvt_dvt(i))/length(Spk_GlobaLdvt_dvt(i)))),smo),'r','linewidth',1);
for a=0:150:600; hold on, plot(a,0:0.1:maxAxis,'b','linewidth',1); end
xlim([0 1200])
ylabel(['Global effect (local dvt) - neuron#',num2str(i)])
%<><><><><><><><><><><><><><><><><><><><><><>   omission   <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
hold on,subplot(4,1,4)
hold on, plot(SmoothDec(mean((Data(Spk_Omission_std(i))/length(Spk_Omission_std(i)))),smo),'k','linewidth',1);
hold on, plot(SmoothDec(mean((Data(Spk_Omission_dvt(i))/length(Spk_Omission_dvt(i)))),smo),'r','linewidth',1);
for a=0:150:600; hold on, plot(a,0:0.1:maxAxis,'b','linewidth',1); end
xlim([0 1200])
ylabel(['Omission effect - neuron#',num2str(i)])
end

%---------------------------------------------------------------------------------------------------------------------------------------------

%---------------------------------------------------------------------------------------------------------------------------------------------

% for i=1:length(S)
% %<><><><><><><><><><><><><><><><><><><><><><>   Local Effect   <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
% figure(1),
% hold on, plot((Range(sq_Spk_Local_std{i}, 'ms')), SmoothDec((Data(sq_Spk_Local_std{i})/length(sw_Spk_Local_std{i})),smo),'k','linewidth',1);
% hold on, plot((Range(sq_Spk_Local_dvt{i}, 'ms')), SmoothDec((Data(sq_Spk_Local_dvt{i})/length(sw_Spk_Local_dvt{i})),smo),'r','linewidth',1);
% for a=0:150:600; hold on, plot(a,0:0.1:30,'b','linewidth',1); end
% xlim([-200 1200])
% ylabel(['Local effect - neuron#',num2str(i)])
% %<><><><><><><><><><><><><><><><><><><><><><>   Global effect (local std)   <><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
% figure,
% hold on, plot((Range(sq_Spk_GlobaLstd_std{i}, 'ms')), SmoothDec((Data(sq_Spk_GlobaLstd_std{i})/length(sw_Spk_GlobaLstd_std{i})),smo),'k','linewidth',1);
% hold on, plot((Range(sq_Spk_GlobaLstd_dvt{i}, 'ms')), SmoothDec((Data(sq_Spk_GlobaLstd_dvt{i})/length(sw_Spk_Omission_dvt{i})),smo),'r','linewidth',1);
% for a=0:150:600; hold on, plot(a,0:0.1:30,'b','linewidth',1); end
% xlim([-200 1200])
% ylabel(['Global effect (local std) - neuron#',num2str(i)])
% %<><><><><><><><><><><><><><><><><><><><><><>   Global effect (local dvt)   <><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
% figure,
% hold on, plot((Range(sq_Spk_GlobaLdvt_std{i}, 'ms')), SmoothDec((Data(sq_Spk_GlobaLdvt_std{i})/length(sw_Spk_GlobaLdvt_std{i})),smo),'k','linewidth',1);
% hold on, plot((Range(sq_Spk_GlobaLdvt_dvt{i}, 'ms')), SmoothDec((Data(sq_Spk_GlobaLdvt_dvt{i})/length(sw_Spk_GlobaLdvt_dvt{i})),smo),'r','linewidth',1);
% for a=0:150:600; hold on, plot(a,0:0.1:30,'b','linewidth',1); end
% xlim([-200 1200])
% ylabel(['Global effect (local dvt) - neuron#',num2str(i)])
% %<><><><><><><><><><><><><><><><><><><><><><>   omission   <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
% figure,
% hold on, plot((Range(sq_Spk_Omission_std{i}, 'ms')), SmoothDec((Data(sq_Spk_Omission_std{i})/length(sw_Spk_Omission_std{i})),smo),'k','linewidth',1);
% hold on, plot((Range(sq_Spk_Omission_dvt{i}, 'ms')), SmoothDec((Data(sq_Spk_Omission_dvt{i})/length(sw_Spk_Omission_dvt{i})),smo),'r','linewidth',1);
% for a=0:150:600; hold on, plot(a,0:0.1:30,'b','linewidth',1); end
% xlim([-200 1200])
% ylabel(['Omission effect - neuron#',num2str(i)])
% end



% %---------------------------------------------------------------------------------------------------------------------------------------------
% for i=1:length(S)
%     
%     ValLocStd=Data(Spk_Local_std(i))';
%     reponseValLocStd=ValLocStd(:,12);
%     ValLocDvt=Data(Spk_Local_dvt(i))';
%     reponseValLocDvt=ValLocDvt(:,12);
%     figure, subplot(4,1,1)
%     hold on, plot(sort(reponseValLocStd),'k','linewidth',2); 
%     hold on, plot(sort(reponseValLocDvt),'r','linewidth',2);
%     hold on, title(['Local Std(k) vs Local Dvt(r) - Neuron',num2str(i)])
%         
%     ValGlobStd_Lstd=Data(Spk_GlobaLstd_std(i))';
%     reponseValGlobStd_Lstd=ValGlobStd_Lstd(:,12);
%     ValGlobDvt_Lstd=Data(Spk_GlobaLstd_dvt(i))';
%     reponseValGlobDvt_Lstd=ValGlobDvt_Lstd(:,12);
%     hold on, subplot(4,1,2) 
%     hold on, plot(sort(reponseValGlobStd_Lstd),'k','linewidth',2); 
%     hold on, plot(sort(reponseValGlobDvt_Lstd),'r','linewidth',2);
%     hold on, title(['Global Std(k) vs Global Dvt(r) (local standard) - Neuron',num2str(i)])
%        
%     ValGlobStd_Ldvt=Data(Spk_GlobaLdvt_std(i))';
%     reponseValGlobStd_Ldvt=ValGlobStd_Lstd(:,12);
%     ValGlobDvt_Ldvt=Data(Spk_GlobaLdvt_dvt(i))';
%     reponseValGlobDvt_Ldvt=ValGlobDvt_Ldvt(:,12);
%     hold on, subplot(4,1,3)  
%     hold on, plot(sort(reponseValGlobStd_Ldvt),'k','linewidth',2);
%     hold on, plot(sort(reponseValGlobDvt_Ldvt),'r','linewidth',2);
%     hold on, title(['Global Std(k) vs Global Dvt(r) (local deviant) - Neuron',num2str(i)])
%     
%     ValOmiFreq=Data(Spk_Omission_std(i))';
%     reponseValOmiFreq=ValOmiFreq(:,12);
%     ValOmiRare=Data(Spk_Omission_dvt(i))';
%     reponseValOmiRare=ValOmiRare(:,12);
%     hold on, subplot(4,1,4) 
%     hold on, plot(sort(reponseValOmiFreq),'k','linewidth',2)
%     hold on, plot(sort(reponseValOmiRare),'r','linewidth',2);
%     hold on, title(['Global Std(k) vs Global Dvt(r) (local deviant) - Neuron',num2str(i)])
%     
% end
% 
% 
% clear HighSpkLocStd
% HighSpkLocStd=[];
% for a=1:length(LocalEffect_std);
%     if reponseValLocStd(a)>1;
%         HighSpkLocStd(a)=LocalEffect_std(a);
%     end
% end
% b=1;
% while b<=length(HighSpkLocStd);
%     if HighSpkLocStd(b)==0;
%         HighSpkLocStd(b)=[];
%     end
%     b=b+1;
% end
% 
% 
% %---------------------------------------------------------------------------
% %<><><><><><><><><> LFP ERPs triggered by High Spiking activity <><><><><><>
% %---------------------------------------------------------------------------
% 
% res=pwd;
% smo=2;
% load([res,'/LFPData/InfoLFP']);
% 
% J1=-2000;
% J2=+13000;
% 
% for num=1:length(InfoLFP.structure);
%     clear LFP
%     clear i;
%     load([res,'/LFPData/LFP',num2str(num)]);
%     LFP2=ResampleTSD(LFP,500);
%     i=num+1;
%         figure, [fh, rasterAx, histAx, MLstd1(i)]=ImagePETH(LFP2, ts(sort([HighSpkLocStd])), J1, J2,'BinSize',800);
% end
% 

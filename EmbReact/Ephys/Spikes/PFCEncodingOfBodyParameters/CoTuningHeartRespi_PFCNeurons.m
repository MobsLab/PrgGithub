cd /media/DataMOBsRAIDN/SophieFigures
HR = load('HRTuning_PFC.mat');
OB = load('OBTuning_PFC.mat');

SharedNeurons = ismember(OB.MouseID,unique(HR.MouseID));
OB.AllSpkAn = OB.AllSpkAn(SharedNeurons,:);

plim = 0.05/(length(HR.AllPAnova));
ResponsiveNeurons = HR.AllPAnova<plim & OB.AllPAnova(SharedNeurons)<plim;

ZScSp_Hr = smooth2a(nanzscore(HR.AllSpkAn(ResponsiveNeurons,1:25)')',0,2);
[val_hr,bestHRfreq]= max(ZScSp_Hr');
[~,ind_HR]= sort(bestHRfreq);

ZScSp_RR = smooth2a(nanzscore(OB.AllSpkAn(ResponsiveNeurons,1:25)')',0,2);
[val_rr,bestOBfreq]= max(ZScSp_RR');
[~,ind_RR]= sort(bestOBfreq);

FreqLims_HR =[8:0.2:13];
FreqLims_RR =[2.5:0.3:11];
plot(FreqLims_RR(bestOBfreq),FreqLims_HR(bestHRfreq),'.')

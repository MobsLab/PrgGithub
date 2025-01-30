function [Res,numfig]=PlotNewAnalysisMitral(nom,m)

% 
% 
% m: maud si =2
% 
% 
% 
% output : Res
% ----------------------------------
% nbspk/temps 
% maxAuto
% Skew 
% Kurto 
% Indice 
% PBimod 
% PUnimod 
% nbspkUp/DureeUpTotal 
% (nbspk-nbspkUp)/DureeDownTotal
% nbupStates/temps 
% DureeUp 
% DureeDown 
% amplUp 
% DureeDownTotal 
% percS 
% percE];

try
    m;
catch
    m=1;
end

le=length(nom);
nomL=nom(1:le-4);

if m==1
eval(['load DataPlotVM',nomL])
eval(['load DataVM',nomL, ' tps dEeg dEeg2'])
yy=dEeg-dEeg2;
else if m==2
eval(['load DataPlotVMmaud',nomL])
eval(['load DataVM',nomL, ' tps dEeg dEeg2'])
yy=dEeg;
    else
eval(['load DataFinalPlot',nomL])
eval(['load DataFinal',nomL, ' tps dEeg dEeg2'])
yy=dEeg;
    end
        
end





figure('Color',[1 1 1])
numfig=gcf;
subplot(4,4,[1:2]), hold on
plot(tps,yy,'k')
line([tps(1) tps(end)],[th th],'Color','r')
ylim([min(yy)-1 max(yy)+3])

smo=6;
subplot(4,4,3), hold on

hold on, A1=area(smooth(h2,smo),x2,'FaceColor','r');
set(A1,'LineStyle','none')
hold on, A2=area(smooth(h1,smo),x1,'FaceColor','g');
set(A2,'LineStyle','none')
hold on, plot(smooth(j1,smo),Bins,'Color',[0.5 0.5 0.5])
hold on, plot(smooth(j4,smo),Bins,'b','linewidth',2)
hold on, plot(smooth(j3+j2,smo),Bins,'k','linewidth',2)
ylim([min(yy)-1 max(yy)+3])

subplot(4,4,[1:2]), hold on
plot(DebutUp,0*DebutUp+max(yy)+1.1,'r<');
plot(FinUp,0*FinUp+max(yy)+1.1,'r>');
line([tps(1) tps(end)],[th th],'Color','c');
hold on, plot(spikes(spikes>tps(1)&spikes<tps(end)) ,0*spikes(spikes>tps(1)&spikes<tps(end))+2.1+max(yy),'ko','MarkerFaceColor','k');
ylim([min(yy)-1 max(yy)+3])
title(['Neurone ',nomL])
xlim([tps(1) tps(end)])


subplot(4,4,4), hold on,
plot(Bs,Cs,'linewidth',2)
plot(Be,Ce,'r','linewidth',2)
xlim([-nBinns/200 nBinns/200])
% title(['Up->Down ',num2str(percE),'s & Down->Up ',num2str(percS),'s'])





Skew;
% Skewness is a measure of the asymmetry of the data around the sample
% mean. 
if Skew<-0.5
    texte1=' The data are spread out more to the left of the mean than to the right';
else if Skew>0.5
    texte1=' The data are spread out more to the right of the mean than to the left';
    else texte1=' The distribution is symetrical';
    end
end

Kurto;
% Kurtosis is a measure of how outlier-prone a distribution is. 
if Kurto>0.5
    texte2=' The distribution is more outlier-prone than the normal distribution'; 
else if Kurto<-0.5
    texte2=' The distribution is less outlier-prone than the normal distribution';  
    else texte2=' The distribution is normal';
    end
end


modality=0;

if PBimod>0.05&PUnimod<0.05
    texte3=' The distribution is bimodal';
    modality=1;
else if PUnimod>0.05
        texte3=' The distribution is unimodal -- Pas de Up-states';
    else 
    texte3=' No clear bi ou unimodality -- Pas de Up-states';
    end
end

try
subplot(4,4,5), bar(Bcross1,Cross1,'k')
xlim([Bcross1(1) Bcross1(end)])

subplot(4,4,6), hold on,
plot(f1,pow1,'Color',[0.8 0.8 0.8]) 
plot(f1,smooth(pow1,NFFT1/20),'r','linewidth',2) 
xlabel('Frequency (Hz)')
ylabel('Vm power')
xlim([0 f1(end)-10])


subplot(4,4,7), bar(Bcross,Cross,'k')
xlim([Bcross(1) Bcross(end)])
end

% Plot single-sided amplitude spectrum.
subplot(4,4,8), hold on,
plot(f,pow,'Color',[0.8 0.8 0.8]) 
plot(f,smooth(pow,NFFT/50),'r','linewidth',2) 
xlabel('Frequency (Hz)')
ylabel('Vm power')
xlim([0 f(end)-10])

    nbspkUp(isnan(nbspkUp))=0;
    nbupStates(isnan(nbupStates))=0;
    DureeUp(isnan(DureeUp))=0;
    amplUp(isnan(amplUp))=0;
    DureeDown(isnan(DureeDown))=0;
    DureeDownTotal(isnan(DureeDownTotal))=0;
    percS(isnan(percS))=0;
    percE(isnan(percE))=0;
try
    shortUpStates(isnan(shortUpStates))=0;
end

% if modality==0
%     nbspkUp=0;
%     nbupStates=0;
%     DureeUp=0;
%     amplUp=0;
%     DureeDown=0;
%     DureeUpTotal=0;
%     DureeDownTotal=0;
%     percS=0;
%     percE=0;
%     shortUpStates=0;
%     Delai=0;
% end


l=1;
subplot(4,4,[9:16])
text(-0.05,1-0.05*l,['Bilan  ',nomL]);l=l+1;
text(-0.05,1-0.05*l,'-------------------------------------------------------- ');l=l+1;
text(0.05,1-0.05*l,['Frequence du neurone : ',num2str(nbspk/temps),' Hz']);l=l+1;
text(0.05,1-0.05*l,['Amplitude du potentiel d''action du neurone : ',num2str(AmpSpk),' mV']);l=l+1;
text(0.05,1-0.05*l,['AHP du neurone : ',num2str(AhpSpk),' mV']);l=l+1;
text(0.05,1-0.05*l,['Frequence max de l''autocorrelogramme du neurone : ',num2str(maxAuto),' Hz']);l=l+1;
try
text(0.05,1-0.05*l,['Frequence max de l''autocorrelogramme du neurone (short) : ',num2str(maxAutoShort),' Hz']);l=l+1;
end
text(0.05,1-0.05*l,['Skewness du neurone : ',num2str(Skew),', ',texte1]);l=l+1;
text(0.05,1-0.05*l,['Kurtosis du neurone : ',num2str(Kurto),', ',texte2]);l=l+1;
text(0.05,1-0.05*l,['Indice du neurone : ',num2str(Indice),', ',texte3]);l=l+1;
text(0.05,1-0.05*l,['Potentiel de membrane moyen du neurone (up-state) : ',num2str(PotUp),' mV']);l=l+1;
text(0.05,1-0.05*l,['Potentiel de membrane moyen du neurone (down-state) : ',num2str(PotDown),' mV']);l=l+1;
text(0.05,1-0.05*l,['Delai du 1er spike pendant les Up-states : ',num2str(Delai*1000),' ms']);l=l+1;
text(0.05,1-0.05*l,['Frequence du neurone pendant les Up-states : ',num2str(nbspkUp/DureeUpTotal),' Hz']);l=l+1;
text(0.05,1-0.05*l,['Frequence du neurone pendant les Down-states : ',num2str((nbspk-nbspkUp)/DureeDownTotal),' Hz']);l=l+1;
text(0.05,1-0.05*l,['Frequence des Up-states : ',num2str(nbupStates/temps),' Hz']);l=l+1;
text(0.05,1-0.05*l,['Nombre d''Up-states : ',num2str(nbupStates)]);l=l+1;
try
    text(0.05,1-0.05*l,['Nombre d''Up-states courts : ',num2str(shortUpStates)]);l=l+1;
end
text(0.05,1-0.05*l,['Duree moyenne des Up-states : ',num2str(DureeUp),' s']);l=l+1;
text(0.05,1-0.05*l,['Duree des Down-states : ',num2str(DureeDown),' s']);l=l+1;
text(0.05,1-0.05*l,['Amplitude des Up-states : ',num2str(amplUp),' mV']);l=l+1;
text(0.05,1-0.05*l,['Duree des transitions Down->Up : ',num2str(percS*1000),' ms']);l=l+1;
text(0.05,1-0.05*l,['Duree des transitions Up->Down : ',num2str(percE*1000),' ms']);l=l+1;

set(gca,'ytick',0)
set(gca,'yticklabel',' ')
set(gca,'xtick',0)
set(gca,'xticklabel',' ')
set(gca,'XColor',[1 1 1])
set(gca,'YColor',[1 1 1])

% set(numfig,'Position',[45 166 1538 1049])
set(numfig,'Position',[20 -300 1200 800])


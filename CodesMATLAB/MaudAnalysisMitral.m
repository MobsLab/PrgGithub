function [Res,numfig]=MaudAnalysisMitral(nom,fig)

% 
% 
% 
% 
%
% 
% output : Res
% ----------------------------------
% nbspk/temps 
% maxAuto
% maxAutoShort
% Skew 
% Kurto 
% Indice 
% PBimod 
% PUnimod 
% Delai
% nbspkUp/DureeUpTotal 
% (nbspk-nbspkUp)/DureeDownTotal
% nbupStates/temps 
% DureeUp 
% DureeDown 
% amplUp 
% DureeUpTotal 
% DureeDownTotal 
% percS 
% percE
%  MembPot
%  PotUp
%  PotDown
% AmpSpk
% AhpSpk


l=0;
l=l+1;labels{l}='nbspk/temps';
l=l+1;labels{l}='maxAuto';
l=l+1;labels{l}='maxAutoShort';
l=l+1;labels{l}='Skew';
l=l+1;labels{l}='Kurto';
l=l+1;labels{l}='Indice';
l=l+1;labels{l}='PBimod';
l=l+1;labels{l}='PUnimod';
l=l+1;labels{l}='Delai';
l=l+1;labels{l}='nbspkUp/DureeUpTotal';
l=l+1;labels{l}='(nbspk-nbspkUp)/DureeDownTotal';
l=l+1;labels{l}='nbupStates/temps';
l=l+1;labels{l}='DureeUp';
l=l+1;labels{l}='DureeDown';
l=l+1;labels{l}='amplUp';
l=l+1;labels{l}='DureeUpTotal';
l=l+1;labels{l}='DureeDownTotal';
l=l+1;labels{l}='percS';
l=l+1;labels{l}='percE';
l=l+1;labels{l}='MembPot';
l=l+1;labels{l}='PotUp';
l=l+1;labels{l}='PotDown';
l=l+1;labels{l}='AmpSpk';
l=l+1;labels{l}='AhpSpk';


ploti=0;

try
    fig;
catch
    fig=0;
end

le=length(nom);
nomL=nom(1:le-4);

try 
    eval(['load DataVMmaud',nomL,' f dw spikes spk'])
catch
    
    data=abfloadKB(nom);

    figure('Color',[1 1 1])
    numfig=gcf;
%     set(numfig,'Position',[45 66 938 749])
    
    subplot(3,4,[9:12])
    [dat, f, dw] = plotMaudsFromData(data(:,2), 10000, 1, 0, data(1,1), data(end-1,1), data(1,1), 1, 0);
    close
    raw=tsd(data(:,1),data(:,2));
    ii=thresholdIntervals(raw,-10,'Direction','Above');
    spikes=Start(ii);
    spk=tsd(spikes,spikes);

    ploti=1;

eval(['save DataVMmaud',nomL,' data dat f dw spikes spk'])

end


    
%     eval(['load DataVM',nomL,' VM Vm tps'])

eval(['load DataPlotVM',nomL,' labels Res spikes Bins nBinns th Bcross Cross Bcross1 Cross1 Csp Bsp pow pow1 f1 NFFT1 f NFFT h1 h2 x1 x2 j1 j2 j3 j4  nbspk temps maxAuto maxAutoShort Skew Kurto Indice MembPot AmpSpk AhpSpk PBimod PUnimod'])

eval(['load DataVM',nomL,' dEeg dEeg2 data tps'])


% yy=dEeg-dEeg2;

yy=dEeg;

  
    
try
    tinit;
    tps=tps(tps>tinit&tps>tfin);
    yy=yy(tps>tinit&yy>tfin);
    spikes=spikes(spikes>tinit&spikes>tfin);
    Epoch=intervalSet(tinit, tfin);
end


if fig==1
    try
        numfig;
    catch
            figure('Color',[1 1 1])
            numfig=gcf;
%             set(numfig,'Position',[45 66 938 749])
    end
    

    subplot(3,4,[1:2]), hold on
    plot(tps,yy,'k')
    line([tps(1) tps(end)],[th th],'Color','r')
    % ylim([Bins(1) Bins(end)])
    ylim([min(yy)-1 max(yy)+3])

    smo=6;
    subplot(3,4,3), hold on
    hold on, area(smooth(h2,smo),x2,'FaceColor','r')
    hold on, area(smooth(h1,smo),x1,'FaceColor','g')
    % ylim([Bins(1) Bins(end)])
    hold on, plot(smooth(j1,smo),Bins,'Color',[0.5 0.5 0.5])
    %  hold on, plot(Bins,j2,'r','linewidth',2)
    %  hold on, plot(Bins,j3,'g','linewidth',2)
    hold on, plot(smooth(j4,smo),Bins,'b','linewidth',2)
    hold on, plot(smooth(j3+j2,smo),Bins,'k','linewidth',2)
    ylim([min(yy)-1 max(yy)+3])

end

DebutUp=dw(:,2)/1E4;
FinUp=dw(:,1)/1E4;

if FinUp(1)<DebutUp(1)
    
    FinUp=FinUp(2:end);
    DebutUp=DebutUp(1:end-1);
    
end

ide=find(FinUp-DebutUp<0.3);

Upav=length(DebutUp);
DebutUp(ide)=[];
FinUp(ide)=[];
Upap=length(DebutUp);

shortUpStates=Upav-Upap;

for i=1:length(DebutUp)
try
MoyUp(i)=mean(yy(find(tps>DebutUp(i)&tps<FinUp(i))));
MoyDown(i)=mean(yy(find(tps>FinUp(i)&tps<DebutUp(i+1))));
end

end

try
PotUp=mean(MoyUp);
PotDown=mean(MoyDown);
amplUp=PotUp-PotDown;
catch
PotUp=nan;
PotDown=nan;
amplUp=nan;
    
end


if ploti==0
    
    colorUp=[207 35 35]/255;
    colorDown=[32 215 28]/255;
    colorBox=[205 225 255]/255; %[197 246 255]/255;
    boxbottom = min(data(:,2));
    boxhight = max(data(:,2)) - boxbottom+10;

    subplot(3,4,[9:12]), hold on
    for i=1:length(DebutUp)
    rectangle('Position', [DebutUp(i) boxbottom FinUp(i)-DebutUp(i) boxhight], 'LineStyle', 'none', 'FaceColor', colorBox);
    end
    hold on, plot(data(:,1),data(:,2),'Color',[0.6 0.6 0.6])
        hold on, plot(tps,dEeg,'r','linewidth',2)
    ylim([boxbottom boxhight+boxbottom])

end

clear data


nBinns=15;
[Cs,Bs]=ETAverage(DebutUp,tps,dEeg-dEeg2,0.01,nBinns);
[Ce,Be]=ETAverage(FinUp,tps,dEeg-dEeg2,0.01,nBinns);

percS=fitsigmoid(Bs,Cs);
percE=fitsigmoid(Be,Ce);

spk=tsd(spikes,spikes);


Epoch=intervalSet(tps(1), tps(end));


spk=Restrict(spk,Epoch);
UpStates=intervalSet(DebutUp,FinUp);


b=1;
for i=1:length(DebutUp)
    try
    FirstSipke=spikes(spikes>DebutUp(i)&spikes<FinUp(i));
    delai(b)=FirstSipke(1)-DebutUp(i);
    b=b+1;
    end
end

try
Delai=mean(delai);
catch
    Delai=nan;
end

DureeUp=mean(FinUp-DebutUp);
DureeUpTotal=sum(FinUp-DebutUp);

DureeDown=mean(DebutUp(2:end)-FinUp(1:end-1));
DureeDownTotal=sum(DebutUp(2:end)-FinUp(1:end-1));

spkUp=Restrict(spk,UpStates);
nbspk=length(Data(spk));
nbspkUp=length(Data(spkUp));
nbupStates=length(DebutUp);

if fig==1
    
    subplot(3,4,[1:2]), hold on
    plot(DebutUp,0*DebutUp+max(yy)+1.1,'r<');
    plot(FinUp,0*FinUp+max(yy)+1.1,'r>');
    line([tps(1) tps(end)],[th th],'Color','c');
    hold on, plot(spikes(spikes>tps(1)&spikes<tps(end)) ,0*spikes(spikes>tps(1)&spikes<tps(end))+2.1+max(yy),'ko','MarkerFaceColor','k');
    ylim([min(yy)-1 max(yy)+3])
    title(['Number of up-States ',num2str(length(DebutUp))])
    xlim([tps(1) tps(end)])

    subplot(3,4,4), hold on,
    plot(Bs,Cs,'linewidth',2)
    plot(Be,Ce,'r','linewidth',2)
    xlim([-nBinns/200 nBinns/200])
    title(['Up->Down ',num2str(percE*1000),'ms & Down->Up ',num2str(percS*1000),'ms'])

end



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
binsizeC1;
nombreBinsC1;
catch
binsizeC1=5;
nombreBinsC1=200;
end


if fig==1

    subplot(3,4,5), bar(Bcross1,Cross1,'k')
    xlim([-binsizeC1*nombreBinsC1/2 binsizeC1*nombreBinsC1/2])

end


if fig==1
    % Plot single-sided amplitude spectrum.
    subplot(3,4,6), hold on,
    plot(f1,pow1,'Color',[0.8 0.8 0.8]) 
    plot(f1,smooth(pow1,NFFT1/20),'r','linewidth',2) 
    xlabel('Frequency (Hz)')
    ylabel('Vm power')
try
    xlim([0 f1(end)-10])
end
end


%-------------------------------------------------------------------------
%-------------------------------------------------------------------------



try
binsize;
nombreBins;
catch
binsize=5;
nombreBins=700;
end

if fig==1

    subplot(3,4,7), bar(Bcross,Cross,'k')
    xlim([-binsize*nombreBins/2 binsize*nombreBins/2])

end



if fig==1
    % Plot single-sided amplitude spectrum.
    subplot(3,4,8), hold on,
    plot(f,pow,'Color',[0.8 0.8 0.8]) 
    plot(f,smooth(pow,NFFT/50),'r','linewidth',2) 
    xlabel('Frequency (Hz)')
    ylabel('Vm power')
    try
    xlim([0 f(end)-10])
    end
end



%----------------------------------------------------


temps=tps(end)-tps(1);


if isempty(percS)
    percS=nan;
end

if isempty(percE)
    percE=nan;
end

Res=[nbspk/temps maxAuto maxAutoShort Skew Kurto Indice PBimod PUnimod Delai nbspkUp/DureeUpTotal (nbspk-nbspkUp)/DureeDownTotal nbupStates/temps DureeUp DureeDown amplUp DureeUpTotal DureeDownTotal percS percE MembPot PotUp PotDown AmpSpk AhpSpk];

try
    numfig;
catch
    numfig=0;
end


eval(['save DataVMmaud',nomL,' -Append labels DebutUp FinUp'])

disp(' ')
disp(['Bilan  ',nomL])
disp('------- ')
disp(' ')
disp(['Frequence du neurone : ',num2str(nbspk/temps),' Hz'])
disp(['Amplitude du potentiel d''action du neurone : ',num2str(AmpSpk),' mV'])
disp(['AHP du neurone : ',num2str(AhpSpk),' mV'])
disp(['Frequence max de l''autocorrelogramme du neurone : ',num2str(maxAuto),' Hz'])
disp(['Frequence max de l''autocorrelogramme du neurone (short) : ',num2str(maxAutoShort),' Hz'])
disp(['Skewness du neurone : ',num2str(Skew),' , ',texte1])
disp(['Kurtosis du neurone : ',num2str(Kurto),' , ',texte2])
disp(['Indice du neurone : ',num2str(Indice),' , ',texte3])
disp(' ')
disp(['Potentiel de membrane moyen du neurone (up-state) : ',num2str(PotUp),' mV'])
disp(['Potentiel de membrane moyen du neurone (down-state) : ',num2str(PotDown),' mV'])
disp(['Delai du 1er spike pendant les Up-states : ',num2str(Delai*1000),' ms'])
disp(['Frequence du neurone pendant les Up-states : ',num2str(nbspkUp/DureeUpTotal),' Hz'])
disp(['Frequence du neurone pendant les Down-states : ',num2str((nbspk-nbspkUp)/DureeDownTotal),' Hz'])
disp(['Frequence des Up-states : ',num2str(nbupStates/temps),' Hz'])
disp(['Nombre d''Up-states : ',num2str(nbupStates)])
disp(['Nombre d''Up-states courts : ',num2str(shortUpStates)])
disp(['Duree moyenne des Up-states : ',num2str(DureeUp),' s'])
disp(['Duree des Down-states : ',num2str(DureeDown),' s'])
disp(['Amplitude des Up-states : ',num2str(amplUp),' mV'])
disp(' ')
disp(['Duree des transitions Down->Up : ',num2str(percS*1000),' ms'])
disp(['Duree des transitions Up->Down : ',num2str(percE*1000),' ms'])


eval(['save DataPlotVMmaud',nomL,' labels Res spikes Delai Bins nBinns th Csp Bsp Bs Be Cs Ce pow pow1 f1 NFFT1 f NFFT Bcross1 Cross1 Bcross Cross h1 h2 x1 x2 j1 j2 j3 j4 DebutUp FinUp nbspk temps maxAuto maxAutoShort Skew Kurto Indice nbspkUp DureeUpTotal DureeDownTotal nbupStates shortUpStates DureeUp DureeDown amplUp percS percE PBimod PUnimod MembPot PotUp PotDown AmpSpk AhpSpk'])

function [Res,numfig]=LastAnalysisMitral(nom,fig)

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
l=l+1;labels{l}='FreqSO';
l=l+1;labels{l}='cont';

try
    fig;
catch
    fig=0;
end

le=length(nom);
nomL=nom(1:le-4);

try

    eval(['load DataFinal',nomL])

catch
    
    ChechUpstates(nom)
    close
    eval(['load DataFinal',nomL])

end

%     yy=dEeg-dEeg2;

    raw=tsd(data(:,1),data(:,2));
    raw=Restrict(raw,Epoch);
        
    [Csp,Vsp,Bsp]=ETAverage(spikes*1E4,Range(raw)*1E4,Data(raw),0.1,300);
    AmpSpk=max(Csp)-mean(Csp);
    AhpSpk=abs(min(Csp)-mean(Csp));

    yy=dEeg;

Skew=skewness(yy);
% Skewness is a measure of the asymmetry of the data around the sample
% mean. If skewness is negative, the data are spread out more to the left of
% the mean than to the right. If skewness is positive, the data are spread out
% more to the right. The skewness of the normal distribution (or any perfectly
% symmetric distribution) is zero.

Kurto=kurtosis(yy)-3;
% Kurtosis is a measure of how outlier-prone a distribution is. The kurtosis
% of the normal distribution is 0. Distributions that are more outlier-prone
% than the normal distribution have kurtosis greater than 0; distributions that
% are less outlier-prone have kurtosis less than 0.

[c,s]=kmeans(yy,2);

amplUp=abs(c(1)-c(2));
MembPot=mean(dEeg);    
PotUp=max(c(1),c(2));%+MembPot;
PotDown=min(c(1),c(2));%+MembPot;
        
Bins=[-15:0.1:15]+mean(yy);

[h,x]=hist(yy,Bins);
[h2,x2]=hist(yy(s==2),Bins);
[h1,x1]=hist(yy(s==1),Bins);

if min(x2(h2>0))>min(x1(h1>0))
    th=min(x2(h2>0));
    else
    th=min(x1(h1>0));
end

y = normrnd(mean(yy(s==1)),std(yy(s==1)),length(find(s==1)),1);
y2 = normrnd(mean(yy(s==2)),std(yy(s==2)),length(find(s==2)),1);
y3 = normrnd(mean(yy),std(yy),length(yy),1);

j1=hist(yy,Bins); % distribution reelle
j2=hist(y,Bins); % 1ere distribution
j3=hist(y2,Bins); % 2eme distribution
j4=hist(y3,Bins); % distribution theorique

Indice=sum(abs(j3+j2-j1))/sum(abs(j4-j1));

[HBimod,PBimod]=kstest2(j1,j2+j3);
[HUnimod,PUnimod]=kstest2(j1,j4);

% figure
% hold on, area(x2,h2,'FaceColor','r')
% hold on, area(x1,h1,'FaceColor','g')
% xlim([Bins(1) Bins(end)])
% hold on, plot(Bins,j1)
% %  hold on, plot(Bins,j2,'r','linewidth',2)
% %  hold on, plot(Bins,j3,'g','linewidth',2)
% hold on, plot(Bins,j4,'b','linewidth',2)
% hold on, plot(Bins,j3+j2,'k','linewidth',2)

if fig==1
    
    figure('Color',[1 1 1])
    numfig=gcf;
    set(numfig,'Position',[45 66 938 749])
%     subplot(2,4,[1:2]), hold on
%     plot(tps,yy,'k')
%     line([tps(1) tps(end)],[th th],'Color','r')
%     % ylim([Bins(1) Bins(end)])
%     ylim([min(yy)-1 max(yy)+3])

    smo=6;
    subplot(2,4,3), hold on
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


nBinns=200;
[Cs,Vs,Bs]=ETAverage(DebutUp*1E4,tps*1E4,yy,10,nBinns);
[Ce,Ve,Be]=ETAverage(FinUp*1E4,tps*1E4,yy,10,nBinns);

% [Ce,Ve,Be]=ETAverage(FinUp,tps,yy,0.01,nBinns);

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
    
            colorUp=[207 35 35]/255;
            colorDown=[32 215 28]/255;
            colorBox=[205 225 255]/255; %[197 246 255]/255;
            boxbottom = min(data(:,2));
            boxhight = max(data(:,2)) - boxbottom+10;
              
            subplot(2,4,[1:2]), hold on
               
                    for i=1:length(DebutUp)
                    rectangle('Position', [DebutUp(i) boxbottom FinUp(i)-DebutUp(i) boxhight], 'LineStyle', 'none', 'FaceColor', colorBox);
                    end
                    plot(data(:,1),data(:,2),'Color',[0.6 0.6 0.6])
                    plot(tps,dEeg,'r','linewidth',2)
                    ylim([boxbottom boxhight+boxbottom])

                    
                    
%     subplot(2,4,[1:2]), hold on
%     plot(DebutUp,0*DebutUp+max(yy)+1.1,'r<');
%     plot(FinUp,0*FinUp+max(yy)+1.1,'r>');
%     line([tps(1) tps(end)],[th th],'Color','c');
%     hold on, plot(spikes(spikes>tps(1)&spikes<tps(end)) ,0*spikes(spikes>tps(1)&spikes<tps(end))+2.1+max(yy),'ko','MarkerFaceColor','k');
%     ylim([min(yy)-1 max(yy)+3])
    title(['Number of up-States ',num2str(length(DebutUp))])
    xlim([tps(1) tps(end)])

    subplot(2,4,4), hold on,
    plot(Bs,Cs,'linewidth',2)
    plot(Bs,Cs-sqrt(Vs),'--c')
    plot(Bs,Cs+sqrt(Vs),'--c')
    plot(Be,Ce,'r','linewidth',2)
    plot(Be,Ce-sqrt(Ve),'--m')
    plot(Be,Ce+sqrt(Ve),'--m')
%     xlim([-nBinns/200 nBinns/200])
%     title(['Up->Down ',num2str(percE*1000),'ms & Down->Up ',num2str(percS*1000),'ms'])
    title(['Up->Down ',num2str(percE),'ms & Down->Up ',num2str(percS),'ms'])

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


[HBimod,PBimod]=kstest2(j1,j2+j3);
[HUnimod,PUnimod]=kstest2(j1,j4);

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


binsize=100;
nombreBins=500;

[Cross, Bcross] = CrossCorr2(spikes*1E4, spikes*1E4, binsize,nombreBins);
Cross(Bcross==0)=0;

if fig==1

    subplot(2,4,7), bar(Bcross/1E3,Cross,'k')
    xlim([-binsize*nombreBins/2 binsize*nombreBins/2]/1E3)

end


Fs=nombreBins/1E3*binsize;%Hz
L = length(Cross);                     % Length of signal

% NFFT=1024;


NFFT = 2^nextpow2(L); % Next power of 2 from length of y
%     NFFT=1024;
%     NFFT=512;

clear Y
fact=5;
cdeb=1;
cfin=length(Cross);

    y=smooth(Cross(cdeb:cfin),fact);
    Y = fft(y,NFFT)/L;
    f = Fs/2*linspace(0,1,NFFT/2);

pow=f'.*abs(Y(1:NFFT/2)*2);

if fig==1
    % Plot single-sided amplitude spectrum.
    try
        subplot(2,4,8), hold on,
        plot(f,pow,'Color',[0.8 0.8 0.8]) 
        plot(f,smooth(pow,NFFT/50),'r','linewidth',2) 
        xlabel('Frequency (Hz)')
        ylabel('Vm power')
        xlim([0 f(end)-10])
    end
end

try
powF=smooth(pow,NFFT/20);
[hj,idf]=max(powF(f<100));
maxAuto=f(idf);
catch
powF=nan;
maxAuto=nan;
end

%----------------------------------------------------


%spectrogtamme

        Fpass=[0.05 2.5];
        movingwin=[50,5];
        
        params.trialave = 0;
        params.err = [1 0.05];
        params.tapers=[10 19];
        params.pad=0;
        params.Fs=100;
        params.fpass=Fpass;
        
        [Spect,freq]=mtspectrumc(yy,params);
        
        Spect2=Spect(freq>0.1);
        freq2=freq(freq>0.1);
        
        [mSpect,idmax]=max(Spect2);
        FreqS0=freq2(idmax);
        
        numfig=gcf;
        
%         [SpecG,tG,fG]=mtspecgramc(yy,movingwin,params);
% 
%         subplot(2,4,[5:6]), imagesc(tG,fG,log(SpecG)'), axis xy

        VmTsd=tsd(tps*1e4,yy);
        deb=find(DebutUp>2.5);
        fin=find(FinUp+16.5<tps(end));

        figure, [fh, rasterAx, histAx, matVal] = ImagePETH(VmTsd, ts(DebutUp(deb(1):fin(end))*1E4), -20000, +160000,'BinSize',500);
        close

        
        M=Data(matVal)';
        [V,L] = pcacov(M(:,400:end)');
        pc1=V(:,1);
        [BE,idt]=sort(pc1);

        figure(numfig)

        subplot(2,4,5), plot(freq,freq'.*Spect,'linewidth',1,'Color','k')
        subplot(2,4,5), hold on, plot(freq,smooth(freq'.*Spect,20),'linewidth',2,'Color','r')

        xlim([0 max(freq)])
        
      
        
        subplot(2,4,6), imagesc(M(idt,:))



%----------------------------------------------------
        
        
        
        
temps=tps(end)-tps(1);

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

if isempty(percS)
    percS=nan;
end

if isempty(percE)
    percE=nan;
end

try
    numfig;
catch
    numfig=0;
end

Res=[nbspk/temps maxAuto Skew Kurto Indice PBimod PUnimod Delai nbspkUp/DureeUpTotal (nbspk-nbspkUp)/DureeDownTotal nbupStates/temps DureeUp DureeDown amplUp DureeUpTotal DureeDownTotal percS percE MembPot PotUp PotDown AmpSpk AhpSpk FreqS0 cont];



disp(' ')
disp(['Bilan  ',nomL])
disp('------- ')
disp(' ')
disp(['Frequence du neurone : ',num2str(nbspk/temps),' Hz'])
disp(['Potentiel de membrane moyen du neurone : ',num2str(MembPot),' mV'])
disp(['Amplitude du potentiel d''action du neurone : ',num2str(AmpSpk),' mV'])
disp(['AHP du neurone : ',num2str(AhpSpk),' mV'])
disp(['Frequence max de l''autocorrelogramme du neurone : ',num2str(maxAuto),' Hz'])
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
disp(['Duree moyenne des Up-states : ',num2str(DureeUp),' s'])
disp(['Duree des Down-states : ',num2str(DureeDown),' s'])
disp(['Amplitude des Up-states : ',num2str(amplUp),' mV'])
disp(['Frequence Slow Oscillation : ',num2str(FreqS0),' Hz'])
disp(' ')
% disp(['Duree des transitions Down->Up : ',num2str(percS*1000),' ms'])
% disp(['Duree des transitions Up->Down : ',num2str(percE*1000),' ms'])
disp(['Duree des transitions Down->Up : ',num2str(percS),' ms'])
disp(['Duree des transitions Up->Down : ',num2str(percE),' ms'])



eval(['save DataFinalPlot',nomL,' labels Res spikes Delai Bins nBinns th Csp Bsp Bs Be Cs Ce pow f NFFT Bcross Cross h1 h2 x1 x2 j1 j2 j3 j4 DebutUp FinUp nbspk temps maxAuto Skew Kurto Indice nbspkUp DureeUpTotal DureeDownTotal nbupStates DureeUp DureeDown amplUp percS percE PBimod PUnimod MembPot PotUp PotDown AmpSpk AhpSpk FreqS0 freq Spect M idt pc1 cont'])




function [Res,numfig]=NewAnalysisMitral(nom,fig)

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



try
    fig;
catch
    fig=0;
end

le=length(nom);
nomL=nom(1:le-4);

try 
    eval(['load DataVM',nomL])
catch
    
        data=abfloadKB(nom);
        
    raw=tsd(data(:,1),data(:,2));
    ii=thresholdIntervals(raw,-10,'Direction','Above');
    spikes=Start(ii);
    spk=tsd(spikes,spikes);

   
    clear raw
    Vm=data(:,1:2);
    h = waitbar(0,'Please wait...');

    for i=1:length(spikes)
        ix(i)=find(data(:,1)==spikes(i));

    if ix(i)+100<length(data)&ix(i)-50>1
        Vm(ix(i)-50:ix(i)+100,:)=RemoveSpike(data(ix(i)-50:ix(i)+100,:));
    else if ix(i)+100<length(data)&ix(i)-50<1
        Vm(1:ix(i)+100,:)=RemoveSpike(data(1:ix(i)+100,:));
        else if ix(i)+100>length(data)
        Vm(ix(i)-50:end,:)=RemoveSpike(data(ix(i)-50:end,:));
        
        end
        end
        
    end

%     if ix(i)+250<length(data)
%         Vm(ix(i)-100:ix(i)+250,:)=RemoveSpike(data(ix(i)-100:ix(i)+250,:));
%     else
%         Vm(ix(i)-100:end,:)=RemoveSpike(data(ix(i)-100:end,:));
%     end

    
        waitbar(i/length(spikes),h)

    end

    close(h)


    % tps=data(1:10:end,1);
    temp=[Vm(1,2)*ones(500000,1); Vm(:,2); Vm(end,2)*ones(500000,1)];
    VM=resample(temp,1,100);
    VM=VM(5001:end-5000);
    
    tps=data(1:100:end,1);

    [b,a]=butterlow1(2/100);
    dEeg = filtfilt(b,a,[VM(1)*ones(5000,1); VM; VM(end)*ones(5000,1)]);

                %pour virer la baseline
                %filtre passe bas (0,005Hz)
                if tps(end)>500
                [b,a]=butterlow1(0.05/100);
                else if tps(end)>100&tps(end)<500
                        [b,a]=butterlow1(0.5/100);
                    else
                        [b,a]=butterlow1(1/100);
                    end
                end

                dEeg2 = filtfilt(b,a,dEeg);
                %valeurs filtrées: dEeg

                %échelle de temps recalculée


dEeg=dEeg(5001:end-5000);
dEeg2=dEeg2(5001:end-5000);

    eval(['save DataVM',nomL,' VM Vm data tps spikes dEeg2 dEeg'])

end

% limite=5000;
% tps=tps(limite:end-limite);
% yy=dEeg(limite:end-limite)-dEeg2(limite:end-limite);

yy=dEeg-dEeg2;
Epoch=intervalSet(tps(1), tps(end));

try
    tinit;
    tps=tps(tps>tinit&tps>tfin);
    yy=yy(tps>tinit&yy>tfin);
    spikes=spikes(spikes>tinit&spikes>tfin);
    Epoch=intervalSet(tinit, tfin);
end

    raw=tsd(data(:,1),data(:,2));
    raw=Restrict(raw,Epoch);
    
        if length(spikes>2)
    try
            [Csp,Bsp]=ETAverage(spikes*1E4,Range(raw)*1E4,Data(raw),0.1,300);
   
            AmpSpk=max(Csp)-mean(Csp);
            AhpSpk=abs(min(Csp)-mean(Csp));
    catch
    Csp=nan;
    Bsp=nan;
    AmpSpk=nan;
    AhpSpk=nan;        
    end
    
        else
    Csp=nan;
    Bsp=nan;
    AmpSpk=nan;
    AhpSpk=nan;
    end
    
    
% yy=dEeg(limite:end-limite);

% tps=tps(2.5E4:end-limite);
% yy=dEeg(2.5E4:end-limite);


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
        MembPot=mean(VM);    
        PotUp=max(c(1),c(2))+MembPot;
        PotDown=min(c(1),c(2))+MembPot;
        
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
    subplot(2,4,[1:2]), hold on
    plot(tps,yy,'k')
    line([tps(1) tps(end)],[th th],'Color','r')
    % ylim([Bins(1) Bins(end)])
    ylim([min(yy)-1 max(yy)+3])

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

% 
% ss=find(data(:,1)>297.6);
% figure, plot(data(ss(1)-2000:ss(1)+3000,1),data(ss(1)-2000:ss(1)+3000,2))
% 
% VM=smooth(Vm(:,2),100);
% hold on, plot(Vm(ss(1)-2000:ss(1)+3000,1),VM(ss(1)-2000:ss(1)+3000),'r','linewidth',3)
% 
% figure, plot(VM)
% hold on, plot(data(2976996+500,1),-30,'ko')
% hold on, plot(data(2976996+500,1),-30,'ko')
% hold on, plot(data(2976996+1000,1),-30,'ko')


bi = burstinfo(tps(find(yy>th)), 0.1, tps(end));

DebutUp=bi.t_start;
FinUp=bi.t_end;

ide=find(FinUp-DebutUp<0.3);

Upav=length(DebutUp);
DebutUp(ide)=[];
FinUp(ide)=[];
Upap=length(DebutUp);

shortUpStates=Upav-Upap;

nBinns=15;
[Cs,Bs]=ETAverage(DebutUp,tps,yy,0.01,nBinns);
[Ce,Be]=ETAverage(FinUp,tps,yy,0.01,nBinns);
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
    
    subplot(2,4,[1:2]), hold on
    plot(DebutUp,0*DebutUp+max(yy)+1.1,'r<');
    plot(FinUp,0*FinUp+max(yy)+1.1,'r>');
    line([tps(1) tps(end)],[th th],'Color','c');
    hold on, plot(spikes(spikes>tps(1)&spikes<tps(end)) ,0*spikes(spikes>tps(1)&spikes<tps(end))+2.1+max(yy),'ko','MarkerFaceColor','k');
    ylim([min(yy)-1 max(yy)+3])
    title(['Number of up-States ',num2str(length(DebutUp))])
    xlim([tps(1) tps(end)])

    subplot(2,4,4), hold on,
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

binsize=5;
nombreBins=200;

try
[Cross1, Bcross1] = CrossCorr2(spikes(spikes>tps(1)&spikes<tps(end))*10000, spikes(spikes>tps(1)&spikes<tps(end))*10000, binsize, nombreBins); Cross1(Bcross1==0)=0; Cross1=smooth(Cross1,4); Cross1(Bcross1==0)=0;
catch
Cross1=nan;
Bcross1=nan;
end

if fig==1

    subplot(2,4,5), bar(Bcross1,Cross1,'k')
    xlim([-binsize*nombreBins/2 binsize*nombreBins/2])

end

Fs=nombreBins;%Hz
L = length(Cross1);                     % Length of signal

% NFFT1=1024;

if length(Cross1)>1

NFFT1 = 2^nextpow2(L); % Next power of 2 from length of y
%     NFFT1=1024;
%     NFFT1=512;

clear Y1
fact=5;
cdeb=1;
cfin=length(Cross1);

    y=smooth(Cross1(cdeb:cfin),fact);
    Y1 = fft(y,NFFT1)/L;
    f1 = Fs/2*linspace(0,1,NFFT1/2);

pow1=f1'.*abs(Y1(1:NFFT1/2)*2);



if fig==1
    % Plot single-sided amplitude spectrum.
    subplot(2,4,6), hold on,
    plot(f1,pow1,'Color',[0.8 0.8 0.8]) 
    plot(f1,smooth(pow1,NFFT1/20),'r','linewidth',2) 
    xlabel('Frequency (Hz)')
    ylabel('Vm power')
    xlim([0 f1(end)-10])
end

powF1=smooth(pow1,NFFT1/20);
[hj,idf]=max(powF1(f1<40));
maxAutoShort=f1(idf);



else
f1=nan;   
pow1=nan;
powF1=nan;
maxAutoShort=nan;
NFFT1=nan;
end

%-------------------------------------------------------------------------
%-------------------------------------------------------------------------

binsize=5;
nombreBins=700;


[Cross, Bcross] = CrossCorr2(spikes(spikes>tps(1)&spikes<tps(end))*10000, spikes(spikes>tps(1)&spikes<tps(end))*10000, binsize, nombreBins); Cross(Bcross==0)=0; Cross=smooth(Cross,4); Cross(Bcross==0)=0;

if fig==1

    subplot(2,4,7), bar(Bcross,Cross,'k')
    xlim([-binsize*nombreBins/2 binsize*nombreBins/2])

end


Fs=nombreBins;%Hz
L = length(Cross);                     % Length of signal

% NFFT=1024;


if length(Cross)>1
    
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
    subplot(2,4,8), hold on,
    plot(f,pow,'Color',[0.8 0.8 0.8]) 
    plot(f,smooth(pow,NFFT/50),'r','linewidth',2) 
    xlabel('Frequency (Hz)')
    ylabel('Vm power')
    xlim([0 f(end)-10])
end

powF=smooth(pow,NFFT/20);
[hj,idf]=max(powF(f<100));
maxAuto=f(idf);

else
    
f=nan;   
pow=nan;
powF=nan;
maxAuto=nan;
NFFT=nan;
end
    
   

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

Res=[nbspk/temps maxAuto maxAutoShort Skew Kurto Indice PBimod PUnimod Delai nbspkUp/DureeUpTotal (nbspk-nbspkUp)/DureeDownTotal nbupStates/temps DureeUp DureeDown amplUp DureeUpTotal DureeDownTotal percS percE MembPot PotUp PotDown AmpSpk AhpSpk];

eval(['save DataVM',nomL,' -Append labels DebutUp FinUp'])


disp(' ')
disp(['Bilan  ',nomL])
disp('------- ')
disp(' ')
disp(['Frequence du neurone : ',num2str(nbspk/temps),' Hz'])
disp(['Potentiel de membrane moyen du neurone : ',num2str(MembPot),' mV'])
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



eval(['save DataPlotVM',nomL,' labels Res spikes Delai Bins nBinns th Csp Bsp Bs Be Cs Ce pow pow1 f1 NFFT1 f NFFT Bcross1 Cross1 Bcross Cross h1 h2 x1 x2 j1 j2 j3 j4 DebutUp FinUp nbspk temps maxAuto maxAutoShort Skew Kurto Indice nbspkUp DureeUpTotal DureeDownTotal nbupStates shortUpStates DureeUp DureeDown amplUp percS percE PBimod PUnimod MembPot PotUp PotDown AmpSpk AhpSpk'])

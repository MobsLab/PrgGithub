function [H,HS,Ph,ModTheta, EpochSelected]=RayleighFreq2(lfp,S,sig,maxfreq,fi,method,nBins,inter, varargin)

% 
% [H,HS,Ph,ModTheta, EpochSelected]=RayleighFreq2(lfp,S,sig,maxfreq,fi,method,nBins,inter, varargin)
% ex: [H,HS,Ph,ModTheta, EpochSelected]=RayleighFreq2(LFP,S{3},0.05,100,1024,'H',25,2);
%
% plot the distribution of phases for
% LFP filtered in 2Hz (inter Hz) band windows from 2 Hz to 42 Hz (maxfreq  Hz)
% 
% INPUTS:
% lfp : unfiltered local field potential (must be in tsd format)
% S : time of spikes (must be in tsd or tsdArray format)
% fi : nb points used to compute the phase (default=512). be careful for low frequencies
% method : can be 'L' or 'H' (default)
% nBins : nb bins between 0 and 2pi
% inter: width of the band windows 
% 
% OUTPUT:
% HS: Matrix of Phases distribution for frequencies ranging from 2 to 42 Hz
% Ph: cell Array of phases of spikes for each frequency
% ModTheta: Von Misses parameters for each frequencies
    % theta: the mean direction
    % Kappa; the concentration factor to be used with Von Mises distribution
    % pval: the signficance of the mean direction against an uniformity null
    % Rmean: the mean resultant length
    % delta: the sample ciricualr dispersion
% hypothesis (with a Rayleigh test) 
% see Fisher N.I. Analysis of Circular Data p. 30-35

% copyright (c) 2009 Karim Benchenane
% This software is released under the GNU GPL
% www.gnu.org/copyleft/gpl.html


% ab : frequence moyenne de la bande
% Fr : neuron frequency
% Filt : band ex [0.5  2.5]

freq=[];

try 
    inter;
catch
    inter=2;
end

try
    sig;
catch
    sig=0.05;
end

try
    nBins;
catch
    
    nBins=10;
end

try
    fi;
catch
    fi=512;
end

try
    method;
catch
    method='H';
end


try
    S=tsdArray(S);
end

% default value 
strongosc='quantile'; % compabovebelow
for i = 1:2:length(varargin),
	switch(lower(varargin{i})),
		case 'strongosc',
			strongosc = varargin{i+1};
	end
end

for i=1:maxfreq
    Filt=[-0.5+i inter+0.5+i];
    ab(i)=mean(Filt); 
    Fil=FilterLFP(lfp,Filt,fi);
    
    [ph,phasesandtimes,powerTsd]=CalCulPrefPhase(S,Fil,method);  
    
    
    
    if strcmp(strongosc, 'compabovebelow')
        
        FiltAbove=[max(Filt)+1 max(Filt)+3];
        FiltBelow=[max(0.1, min(Filt)-3) max(0.1, min(Filt)-1)];

        FilA=FilterLFP(lfp,FiltAbove,fi);
        FilB=FilterLFP(lfp,FiltBelow,fi);

        PowAb=abs(hilbert(Data(FilA)));
        PowBe=abs(hilbert(Data(FilB)));

        fact=[1 3]; % weights given for frequencies below and above

        rgg=Range(lfp);
        id=find(Data(powerTsd)>fact(1)*PowBe&Data(powerTsd)>fact(2)*PowAb);

        if length(id)==0
          id=find(Data(powerTsd)>max(fact(1)*PowBe,fact(2)*PowAb));    
        end

        temp=zeros(length(rgg),1);
        temp(id)=1;
        periodTsd=tsd(rgg,temp);

        EpochOK=thresholdIntervals(periodTsd,0.5,'Direction','Above'); 
        EpochOK=mergeCloseIntervals(EpochOK,15000);
        EpochOK=dropShortIntervals(EpochOK,10000);
        EpochSelected{i}=EpochOK;
    
    elseif strcmp(strongosc,'quantile')
        
        
        seuil=0.5;
        th=quantile(Data(powerTsd),seuil);
        EpochOK=thresholdIntervals(powerTsd,th,'Direction','Above'); 
        EpochOK=mergeCloseIntervals(EpochOK,15000);
        EpochOK=dropShortIntervals(EpochOK,10000);
        EpochSelected{i}=EpochOK;
        
    elseif strcmp(strongosc,'no')
        A=Range(lfp);
        AcquisitionFq=1/median(diff(A));   
        EpochOK=intervalset(1,length(A)/AcquisitionFq);
        EpochSelected{i}=EpochOK;
    end
    
    
    
    Ph{i}=Data(Restrict(phasesandtimes{1},EpochOK));
    Ph{i}( Ph{i}>2*pi)=[];
    Ph{i}( Ph{i}<0)=[];
    NbSpk(i)=length(Data(Restrict(phasesandtimes{1},EpochOK)));
    Fr(i)=length(Data(Restrict(phasesandtimes{1},EpochOK)))/sum(End(EpochOK,'s')-Start(EpochOK,'s')); % neuron frequency
    Dur(i)=sum(End(EpochOK,'s')-Start(EpochOK,'s'));
    
%     [phTsd, ph] = firingPhaseHilbert(Fil, S) ;
%     he=hist(Data(ph{1}),20);
%     h{i}=[he he]; 
%     Ph{i}=Data(ph{1});
%     
%     [ph, thpeaks] = ThetaPhase2(S, Fil);
%     Pht=Data(ph{1});
%     Ph{i}=Pht(:,1)*2*pi;
    

    dB = 2*pi/nBins;
	B = [dB/2:dB:2*pi-dB/2];
    
    he=hist(Ph{i},B);
    h{i}=[2*nBins*he/sum(he) 2*nBins*he/sum(he)];
%     keyboard
try
    [mu(i), Kappa(i), pval(i), Rmean(i)] = CircularMean(Ph{i});
catch
    mu(i)=nan;
    Kappa(i)=nan;
    pval(i)=nan;
    Rmean(i)=nan;
end

    freq=[freq;Filt];
    
    clear ph1
    clear he
end

clear H

for i=1:maxfreq
    H(i,:)=h{i};
end

% Hs=SmoothDec(H,[0.001,0.8]);
% Hs=SmoothDec([[H H H];[H H H];[H H H]],[0.001,0.8]);
% HS=Hs(21:40,41:80);

Hs=SmoothDec(H,[0.001,0.8]);
HS=Hs;
HS(:,2*nBins)=(Hs(:,nBins)+HS(:,2*nBins-1))/2;
HS(:,1)=(Hs(:,nBins+1)+HS(:,2))/2;

%  figure, imagesc([0:4*pi],ab,H), axis xy
% ylabel('Frequence (Hz)')
% xlabel('Phase (rad)')

figure('color',[1 1 1]),
subplot(1,5,1:2), imagesc([4*pi/19/2:4*pi/19:4*pi-4*pi/19/2],ab,HS), axis xy
ylabel('Frequency (Hz)')
xlabel('Phase (rad)')
ca=caxis;
title(['scale: ',num2str(floor(ca(1)*100)/100),', ', num2str(floor(ca(2)*100)/100)])
%title([ sprintf('%.0f', tot_length(EpochOK, 's')) ' sec'])
mu=mu';
Kappa=Kappa';
pval=pval;
Rmean=Rmean';
ab=ab';
NbSpk=NbSpk';
Fr=Fr';
Dur=Dur';
%ModTheta=[mu', Kappa', pval',Rmean',ab',freq,NbSpk',Fr',Dur'];
%ModTheta = struct([]);
ModTheta.mu=mu;
ModTheta.Kappa=Kappa;
ModTheta.pval=pval;
ModTheta.Rmean=Rmean;
ModTheta.ab=ab;
ModTheta.NbSpk=NbSpk;
ModTheta.Fr=Fr;
ModTheta.Dur=Dur;

FigArrow([mu(pval<sig),ab(pval<sig)], Kappa(pval<sig),mu(pval<sig),0.8)
FigArrow([mu(pval<sig)+2*pi,ab(pval<sig)], Kappa(pval<sig),mu(pval<sig),0.8)
% pourquoi +1 ?
% FigArrow([ModTheta(ModTheta(:,3)<sig,1),ModTheta(ModTheta(:,3)<sig,5)+1], ModTheta(ModTheta(:,3)<sig,2),ModTheta(ModTheta(:,3)<sig,1),0.8)
% FigArrow([ModTheta(ModTheta(:,3)<sig,1)+2*pi,ModTheta(ModTheta(:,3)<sig,5)+1], ModTheta(ModTheta(:,3)<sig,2),ModTheta(ModTheta(:,3)<sig,1),0.8)

% hold on, plot(ModTheta(ModTheta(:,3)<0.05,1),1+2*find(ModTheta(:,3)<0.05),'ko','MarkerFaceColor','w')
% hold on, plot(ModTheta(ModTheta(:,3)<0.05,1)+2*pi,1+2*find(ModTheta(:,3)<0.05),'ko','MarkerFaceColor','w')
%ca=caxis;
%caxis([ca(1) ca(2)+ca(2)/10]);
ylim([min(ab)-0.5 max(ab)+0.5])
set(gca,'YTick',[0:2:maxfreq])

subplot(1,5,3),  hold on
plot(Kappa,ab,'r','linewidth',2)
plot(Kappa(find(pval<0.05)),ab(find(pval<0.05)),'ko','markerfacecolor','k')
ylim([min(ab)-0.5 max(ab)+0.5]) 
if ~isnan(Kappa), xlim([0 max(Kappa)+0.1]),end
xlabel ('Kappa')

subplot(1,5,4),  hold on
plot(Fr,ab,'k','linewidth',2)
%plot(NbSpk/max(NbSpk)*max(Fr),ab,'r') % firing rate of the neuron
ylim([min(ab)-0.5 max(ab)+0.5]) 
xlim([0 max(Fr)+3])
title(['MaxFr:',num2str(floor(max(Fr)*10)/10), ', NbSpk:',num2str(min(NbSpk)),' ',num2str(max(NbSpk))])
xlabel ('neuron rate')

subplot(1,5,5),  hold on
plot(Dur,ab,'b','linewidth',2)% duration of epochs
ylim([min(ab)-0.5 max(ab)+0.5]) 
xlim([0 max(Dur)+50])
xlabel ('selected epoch duration')
%title(['MaxFr:',num2str(floor(max(Fr)*10)/10), ', NbSpk:',num2str(min(NbSpk)),' ',num2str(max(NbSpk))])


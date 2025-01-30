function [H,HS,Ph,ModTheta]=RayleighFreq(lfp,S,sig,fre,fi)


% [HS,Ph,ModTheta]=RayleighFreq(lfp,S) plot the distribution of phases for
% LFP filtered in 2Hz band windows from 2 to 42 Hz
% 
% INPUTS:
% lfp: unfiltered local field potential (must be in tsd format)
% S: time of sipkes (must be in tsd or tsdArray format)
% 
% OUTPUT:
% HS: Matrix of Phases distribution for frequencies ranging from 2 to 42 Hz
% Ph: cell Array of phases of spikes for each frequencies
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


fac=300;
try
    fi;
catch
fi=1024;
end

try
    fre;
catch
fre=60; %defaut 20
end

try
    sig;
catch
    sig=0.01;
end

try
    S=tsdArray(S);
end

for i=1:fre/2
    Filt=[0+2*i 2+2*i];
    ab(i)=mean(Filt);
    Fil=FilterLFP(lfp,Filt,fi);
    [phTsd, ph] = firingPhaseHilbert(Fil, S) ;
    he=hist(Data(ph{1}),20);
    h{i}=[he he]; 
    Ph{i}=Data(ph{1});
    [mu(i), Kappa(i), pval(i), Rmean(i)] = CircularMean(Ph{i});
    clear ph1
    clear he
end

for i=1:fre
    H(i,:)=h{i};
end

Hs=SmoothDec(H,[0.001,0.8]);
HS=Hs;
HS(:,40)=Hs(:,20);
HS(:,1)=Hs(:,21);



figure, imagesc([0:4*pi],ab,HS), axis xy
ylabel('Frequence (Hz)')
xlabel('Phase (rad)')

ModTheta=[mu', Kappa', pval',Rmean',ab'];
FigArrow([ModTheta(ModTheta(:,3)<0.05,1),1+2*find(ModTheta(:,3)<0.05)], ModTheta(ModTheta(:,3)<0.05,2)/fac,ModTheta(ModTheta(:,3)<0.05,1),sig)
FigArrow([ModTheta(ModTheta(:,3)<0.05,1)+2*pi,1+2*find(ModTheta(:,3)<0.05)], ModTheta(ModTheta(:,3)<0.05,2)/fac,ModTheta(ModTheta(:,3)<0.05,1),sig)

% hold on, plot(ModTheta(ModTheta(:,3)<0.05,1),1+2*find(ModTheta(:,3)<0.05),'ko','MarkerFaceColor','w')
% hold on, plot(ModTheta(ModTheta(:,3)<0.05,1)+2*pi,1+2*find(ModTheta(:,3)<0.05),'ko','MarkerFaceColor','w')
ca=caxis;
caxis([ca(1) ca(2)+ca(2)/10]);

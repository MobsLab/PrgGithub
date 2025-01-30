function [HS,Ph,ModTheta,phasectrl]=RayleighFreq(lfp,S,scal)


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



%---------------------------------------------------------------
% option
%---------------------------------------------------------------

try 
    scal;
catch
    scal=0.01;
end

plotCtrl=1;
fi=512;
%fi=96;

%---------------------------------------------------------------

try
    S=tsdArray(S);
end


phasectrl=[];


for i=1:20
    
    Filt=[0+2*i 2+2*i];
    Fil=FilterLFP(lfp,Filt,fi);

    zr = hilbert(Data(Fil));
    phzr = atan2(imag(zr), real(zr));
    phzr(phzr < 0) = phzr(phzr < 0) + 2 * pi;
   
    [histphzr,echel]=hist(phzr,[2*pi/40:2*pi/20:2*pi-2*pi/40]);
    phasectrl=[phasectrl;histphzr];
    
    
    [phTsd, ph] = firingPhaseHilbert(Fil, S) ;

    he=hist(Data(ph{1}),20);
    h{i}=[he he]; 
    Ph{i}=Data(ph{1});
    [mu(i), Kappa(i), pval(i), Rmean(i)] = CircularMean(Ph{i});
    clear ph1
    clear he
end

for i=1:20
    H(i,:)=h{i};
end

Hs=SmoothDec(H,[0.001,0.8]);
HS=Hs;
HS(:,40)=Hs(:,20);
HS(:,1)=Hs(:,21);

figure, imagesc([0:4*pi],[3:41],HS), axis xy
ylabel('Frequence (Hz)')
xlabel('Phase (rad)')

ModTheta=[mu', Kappa', pval',Rmean'];
FigArrow([ModTheta(ModTheta(:,3)<0.05,1),1+2*find(ModTheta(:,3)<0.05)], ModTheta(ModTheta(:,3)<0.05,2),ModTheta(ModTheta(:,3)<0.05,1),scal)
FigArrow([ModTheta(ModTheta(:,3)<0.05,1)+2*pi,1+2*find(ModTheta(:,3)<0.05)], ModTheta(ModTheta(:,3)<0.05,2),ModTheta(ModTheta(:,3)<0.05,1),scal)

% hold on, plot(ModTheta(ModTheta(:,3)<0.05,1),1+2*find(ModTheta(:,3)<0.05),'ko','MarkerFaceColor','w')
% hold on, plot(ModTheta(ModTheta(:,3)<0.05,1)+2*pi,1+2*find(ModTheta(:,3)<0.05),'ko','MarkerFaceColor','w')
ca=caxis;
caxis([ca(1) ca(2)+ca(2)/10]);

if plotCtrl
figure, imagesc(echel,[3:41],phasectrl), axis xy
caxis([max(max(phasectrl))/1.25 max(max(phasectrl))])
ylabel('Frequence (Hz)')
xlabel('Phase (rad)')
end
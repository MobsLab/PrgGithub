function [dz,vdz,Adz]=MakeTwoGroupTestCoherence(data1,data2,E1,E2,win,p,tapers,nfft,Fs,plo)

% datasp1(1,n)  c'est le lfp1 pour l'essai n
% 
% datasp2(1,1)  c'est le lfp2 pour l'essai 1
% datasp2(1,2)  c'est le lfp2 pour l'essai 2
% etc...
% datasp2(1,m)  c'est le lfp2 pour l'essai m
%
%,C,phi,S12,S1,S2,f,confC,Cb,phib,S12b,S1b,S2b,fb,confCb
%

try
    plo;
catch
    plo=0;
end

params.Fs= Fs;
params.tapers= tapers;
params.fpass=  [0 80];
params.err=  [1 0.05];
[C,phi,S12,S1,S2,f,confC]=coherencytrigc(data1,data2,E1,win,params);
[Cb,phib,S12b,S1b,S2b,fb,confCb]=coherencytrigc(data1,data2,E2,win,params);

if plo
    
    figure('color',[1 1 1]), 
    subplot(3,2,1),plot(f,C,'k','linewidth',2),
    hold on, line([params.fpass(1) params.fpass(end)],[confC confC],'color','r')
    subplot(3,2,2),scatter(f,phi,30,phi,'filled'),ylim([-3.14 3.14]),caxis([-3.14 3.14])
    subplot(3,2,3),plot(f,S1,'b','linewidth',2)
    subplot(3,2,4),plot(f,S2,'r','linewidth',2)
    subplot(3,2,5),plot(f,10*log10(S1),'b','linewidth',2)
    subplot(3,2,6),plot(f,10*log10(S2),'r','linewidth',2)
    % subplot(2,2,3),plot(f,f'.*S1,'b','linewidth',2)
    % subplot(2,2,4),plot(f,f'.*S2,'b','linewidth',2)

    figure('color',[1 1 1]), 
    subplot(3,2,1),plot(fb,Cb,'k','linewidth',2),hold on, plot(f,C,'color',[0.7 0.7 0.7],'linewidth',1),
    hold on, line([params.fpass(1) params.fpass(end)],[confCb confCb],'color','r')
    subplot(3,2,2),scatter(fb,phib,30,phib,'filled'),ylim([-3.14 3.14]),caxis([-3.14 3.14])
    subplot(3,2,3),plot(fb,S1b,'b','linewidth',2)
    subplot(3,2,4),plot(fb,S2b,'r','linewidth',2)
    subplot(3,2,5),plot(fb,10*log10(S1b),'b','linewidth',2),hold on, plot(f,10*log10(S1),'color',[0.7 0.7 0.7],'linewidth',1),
    subplot(3,2,6),plot(fb,10*log10(S2b),'r','linewidth',2),hold on, plot(f,10*log10(S2),'color',[0.7 0.7 0.7],'linewidth',1),
    % subplot(2,2,3),plot(fb,fb'.*S1b,'r','linewidth',2)
    % subplot(2,2,4),plot(fb,fb'.*S2b,'r','linewidth',2)

end

data1a=createdatamatc(data1,E1,Fs,win); % segmented data 1
data1b=createdatamatc(data2,E1,Fs,win); % segmented data 2
data2a=createdatamatc(data1,E2,Fs,win); % segmented data 1
data2b=createdatamatc(data2,E2,Fs,win); % segmented data 2

N1a=size(data1a,1);
tapers1a=dpsschk(tapers,N1a,Fs); % check tapers
N2a=size(data2a,1);
tapers2a=dpsschk(tapers,N2a,Fs); % check tapers
N1b=size(data1b,1);
tapers1b=dpsschk(tapers,N1b,Fs); % check tapers
N2b=size(data2b,1);
tapers2b=dpsschk(tapers,N2b,Fs); % check tapers


%J1c1=mtfftc(data1a,tapers1a,nfft,Fs); 
%J2c1=mtfftc(data2a,tapers2a,nfft,Fs);
%J1c2=mtfftc(data1b,tapers1b,nfft,Fs); 
%J2c2=mtfftc(data2b,tapers2b,nfft,Fs);

J1c1=mtfftc(data1a,tapers1a,nfft,Fs); 
J1c2=mtfftc(data2a,tapers2a,nfft,Fs);
J2c1=mtfftc(data1b,tapers1b,nfft,Fs); 
J2c2=mtfftc(data2b,tapers2b,nfft,Fs);


J1c1=reshape(J1c1,[size(J1c1,1) size(J1c1,2)*size(J1c1,3)]);
J2c1=reshape(J2c1,[size(J2c1,1) size(J2c1,2)*size(J2c1,3)]);
J1c2=reshape(J1c2,[size(J1c2,1) size(J1c2,2)*size(J1c2,3)]);
J2c2=reshape(J2c2,[size(J2c2,1) size(J2c2,2)*size(J2c2,3)]);

f=[0:Fs/2/(nfft-1):Fs/2]*2;

%et enfin
%p=0.05;


figure('color',[1 1 1]);
[dz,vdz,Adz]=two_group_test_coherence(J1c1,J2c1,J1c2,J2c2,p,'y',f);  % p c'est la valeur du p que tu veux, f les fr�quences (cf plus haut)
position_figure

subplot(3,1,1),xlim([0 80])
subplot(3,1,2),xlim([0 80])
subplot(3,1,3),xlim([0 80])

set(gcf,'position',[0.0317708333333333        0.0657407407407407         0.124479166666667         0.835185185185185])
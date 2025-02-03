

load behavResources
load LFPBulb.mat

LFPt=LFP;

load LFPAuCx.mat
%test

LFPt{15}=LFP{1};
LFPt{16}=LFP{2};
LFPt{17}=LFP{3};


load LFPPFCx.mat

LFPt{18}=LFP{1};
try
LFPt{19}=LFP{2};
    LFPt{20}=LFP{3};
catch
    LFPt{19}=LFP{1};
    LFPt{20}=LFP{1};

end


load LFPdHPC

LFPt{21}=LFP{1};
LFPt{22}=LFP{2};
try
LFPt{23}=LFP{3};
end

load StateEpoch

%  Fil1=FilterLFP(LFPt{16},[4 10],1024);
% % rgFil=Range(Fil1,'s');
% % filtered=[rgFil-rgFil(1) Data(Fil1)];
% % 
% % 
%  Fil2=FilterLFP(LFPt{16},[10 15],1024);
% % rgFil=Range(Fil2,'s');
% % filtered2=[rgFil-rgFil(1) Data(Fil2)];
% % 
% % 
% 
% 
% [ripples,stdev,noise] = FindRipples(filtered,'durations',[1000 1000 6000]);
% [maps,data,stats] = RippleStats(filtered,ripples);
% %PlotRippleStats(ripples,maps,data,stats);
% M=PlotRipRaw(LFPt{16},ripples,1000);
% 

%a=5180;

% 
% a=0;
% params.Fs=1250;
% params.fpass = [0 40];
% params.err = [2, 0.95];
% params.trialave = 0;
% 
% params.pad=1;
% params.tapers=[3,5];
% movingwin = [1, 0.05];
% % a=a+30; Epoch=intervalSet(a*1E4,(a+30)*1E4); 
% % [S,t,f,Serr]=mtspecgramc(Data(Restrict(LFPt{18},Epoch)),movingwin,params);
% % clf, imagesc(t+Start(Epoch,'s'),rescale(f,-3*1E4,5.5*1E4),10*log10(S)'), axis xy, hold on, plot(Range(Restrict(LFP{1},Epoch),'s'),Data(Restrict(LFPt{22},Epoch))), hold on, plot(Range(Restrict(LFP{1},Epoch),'s'),Data(Restrict(LFPt{19},Epoch))+4*1E4,'k'),plot(Range(Restrict(LFP{1},Epoch),'s'),Data(Restrict(LFPt{18},Epoch))+5*1E4,'k'),hold on, plot(Range(Restrict(LFP{1},Epoch),'s'),Data(Restrict(LFPt{1},Epoch))+2.5*1E4,'k'), hold on, plot(Range(Restrict(Fil2,Epoch),'s'),2*Data(Restrict(Fil2,Epoch))+1E4,'k'), plot(Range(Restrict(Fil2,Epoch),'s'),Data(Restrict(Fil1,Epoch))-1E4,'k'), plot(Range(Restrict(V,Epoch),'s'),Data(Restrict(V,Epoch))*1E2-3E4,'color',[0.7 0.7 0.7]), ylim([-3E4 5.5E4])
% %a=a+30; Epoch=intervalSet(a*1E4,(a+30)*1E4); clf, plot(Range(Restrict(LFP{1},Epoch),'s'),Data(Restrict(LFPt{16},Epoch))), hold on, plot(Range(Restrict(LFP{1},Epoch),'s'),Data(Restrict(LFPt{19},Epoch))+4.5*1E4,'b'),hold on, plot(Range(Restrict(LFP{1},Epoch),'s'),Data(Restrict(LFPt{1},Epoch))+2.5*1E4,'r'), hold on, plot(Range(Restrict(Fil2,Epoch),'s'),2*Data(Restrict(Fil2,Epoch))+1E4,'k'),, plot(Range(Restrict(Fil2,Epoch),'s'),Data(Restrict(Fil1,Epoch))-1E4,'k')
% 
% nu=21;
% a=a+30; Epoch=intervalSet(a*1E4,(a+30)*1E4);
% [S,t,f,Serr]=mtspecgramc(Data(Restrict(LFPt{18},Epoch)),movingwin,params);
% Fil1=FilterLFP(Restrict(LFPt{16},Epoch),[4 10],1024);
% Fil2=FilterLFP(Restrict(LFPt{16},Epoch),[10 15],1024);
% clf, imagesc(t+Start(Epoch,'s'),rescale(f,-3*1E4,5.5*1E4),10*log10(S)'), axis xy, hold on, plot(Range(Restrict(LFP{1},Epoch),'s'),Data(Restrict(LFPt{nu},Epoch))), hold on, plot(Range(Restrict(LFP{1},Epoch),'s'),Data(Restrict(LFPt{19},Epoch))+4*1E4,'k'),plot(Range(Restrict(LFP{1},Epoch),'s'),Data(Restrict(LFPt{18},Epoch))+5*1E4,'k'),hold on, plot(Range(Restrict(LFP{1},Epoch),'s'),Data(Restrict(LFPt{1},Epoch))+2.5*1E4,'k'), hold on, plot(Range(Restrict(Fil2,Epoch),'s'),2*Data(Restrict(Fil2,Epoch))+1E4,'k'), plot(Range(Restrict(Fil2,Epoch),'s'),Data(Restrict(Fil1,Epoch))-1E4,'k'), plot(Range(Restrict(V,Epoch),'s'),Data(Restrict(V,Epoch))*2E2-3E4,'color',[0.3 0.3 0.3]), ylim([-3E4 5.5E4]), caxis([10 60]), hold on, plot(Range(Restrict(LFP{1},and(Epoch,MovEpoch)),'s'),Data(Restrict(LFPt{1},and(Epoch,MovEpoch)))+2.5*1E4,'color',[0.4 0.4 0.4]),plot(Range(Restrict(Movtsd,Epoch),'s'),Data(Restrict(Movtsd,Epoch))*5E2-3E4,'color','k')
% 
% % \\NASDELUXE\DataMOBs\ProjetCannabinoids\Mouse051\20130110\BULB-Mouse-51-10012013
% %4470
% %4680
% %8550 K complexe
% %8760
% 
% 
% 
% 
%  Fil1=FilterLFP(LFPt{16},[4 10],1024);
% % rgFil=Range(Fil1,'s');
% % filtered=[rgFil-rgFil(1) Data(Fil1)];
% % 
% % 
%  Fil2=FilterLFP(LFPt{16},[10 15],1024);
% % rgFil=Range(Fil2,'s');
% % filtered2=[rgFil-rgFil(1) Data(Fil2)];
% % 
% % 
% % 
% % 
% % [ripples,stdev,noise] = FindRipples(filtered,'durations',[1000 1000 6000]);
% % [maps,data,stats] = RippleStats(filtered,ripples);
% % %PlotRippleStats(ripples,maps,data,stats);
% % M=PlotRipRaw(LFPt{16},ripples,1000);
% % 


% 2 auditory cortex 15-17
% 3 Pfc 18 -20 
% 4 Hpc 21 23
% 1 bulb 1 14



LFPa{1}=LFPt{16}; %auditory cortex
LFPa{2}=LFPt{18}; % Pfc
LFPa{3}=LFPt{21}; % hpc
LFPa{4}=LFPt{22}; % hpc
LFPa{5}=LFPt{5}; %bulb
LFPa{6}=LFPt{19}; %pfc 
clear LFPt
clear LFP
clear Spectro

LFPt=LFPa;
clear LFPa



if 0
a=5180;
params.Fs=1250;
params.fpass = [0 40];
params.err = [2, 0.95];
params.trialave = 0;
params.pad=1;
movingwin = [1, 0.05];
params.tapers=[1,2];

figure,
nu=3;a=a+30; Epoch=intervalSet(a*1E4,(a+30)*1E4);[S,t,f,Serr]=mtspecgramc(Data(Restrict(LFPt{2},Epoch)),movingwin,params);Fil1=FilterLFP(Restrict(LFPt{2},Epoch),[4 10],1024);Fil2=FilterLFP(Restrict(LFPt{2},Epoch),[10 15],1024);clf, imagesc(t+Start(Epoch,'s'),rescale(f,-3*1E4,5.5*1E4),10*log10(S)'), axis xy, hold on, plot(Range(Restrict(LFPt{nu},Epoch),'s'),Data(Restrict(LFPt{nu},Epoch))), hold on, plot(Range(Restrict(LFPt{2},Epoch),'s'),Data(Restrict(LFPt{2},Epoch))+4*1E4,'k'),plot(Range(Restrict(LFPt{6},Epoch),'s'),Data(Restrict(LFPt{6},Epoch))+5*1E4,'k'),hold on, plot(Range(Restrict(LFPt{5},Epoch),'s'),Data(Restrict(LFPt{5},Epoch))+2.5*1E4,'k'), hold on, plot(Range(Restrict(Fil2,Epoch),'s'),2*Data(Restrict(Fil2,Epoch))+1E4,'k'),plot(Range(Restrict(Fil1,Epoch),'s'),Data(Restrict(Fil1,Epoch))-1E4,'k'), plot(Range(Restrict(V,Epoch),'s'),Data(Restrict(V,Epoch))*2E2-3E4,'color',[0.3 0.3 0.3]), ylim([-3E4 5.5E4]), caxis([10 60]),hold on, plot(Range(Restrict(LFPt{1},and(Epoch,MovEpoch)),'s'),Data(Restrict(LFPt{5},and(Epoch,MovEpoch)))+2.5*1E4,'color',[0.4 0.4 0.4]),plot(Range(Restrict(Movtsd,Epoch),'s'),Data(Restrict(Movtsd,Epoch))*5E2-3E4,'color','k')

end


% 
% params.tapers=[3,5];
% nu=3;Epoch=intervalSet(a*1E4,(a+30)*1E4);[S,t,f,Serr]=mtspecgramc(Data(Restrict(LFPt{2},Epoch)),movingwin,params);Fil1=FilterLFP(Restrict(LFPt{2},Epoch),[4 10],1024);Fil2=FilterLFP(Restrict(LFPt{2},Epoch),[10 15],1024);clf, imagesc(t+Start(Epoch,'s'),rescale(f,-3*1E4,5.5*1E4),10*log10(SmoothDec(S,[1 1]))'), axis xy, hold on, plot(Range(Restrict(LFPt{nu},Epoch),'s'),Data(Restrict(LFPt{nu},Epoch))), hold on, plot(Range(Restrict(LFPt{2},Epoch),'s'),Data(Restrict(LFPt{2},Epoch))+5*1E4,'k'),plot(Range(Restrict(LFPt{6},Epoch),'s'),Data(Restrict(LFPt{6},Epoch))+4*1E4,'k'),hold on, plot(Range(Restrict(LFPt{5},Epoch),'s'),Data(Restrict(LFPt{5},Epoch))+2.5*1E4,'k'), hold on, plot(Range(Restrict(Fil2,Epoch),'s'),2*Data(Restrict(Fil2,Epoch))+1E4,'k'),plot(Range(Restrict(Fil1,Epoch),'s'),Data(Restrict(Fil1,Epoch))-1E4,'k'), plot(Range(Restrict(V,Epoch),'s'),Data(Restrict(V,Epoch))*2E2-3E4,'color',[0.3 0.3 0.3]), ylim([-3E4 5.5E4]), caxis([10 60]),hold on, plot(Range(Restrict(LFPt{1},and(Epoch,MovEpoch)),'s'),Data(Restrict(LFPt{5},and(Epoch,MovEpoch)))+2.5*1E4,'color',[0.4 0.4 0.4]),plot(Range(Restrict(Movtsd,Epoch),'s'),Data(Restrict(Movtsd,Epoch))*5E2-3E4,'color','k')
% 
% Y=Data(Restrict(LFPt{2},Epoch));
% fac=5;
% L = length(Y);
% NFFT = 2^nextpow2(L); % Next power of 2 from length of y
% yf  = fft(Y,NFFT)/L;
% f1 = 1250*1/2*linspace(0,1,NFFT/2+1);
% spe=abs(yf(1:NFFT/2+1));
% [S2,f2,Serr2]=mtspectrumc(Data(Restrict(LFPt{2},Epoch)),params);
% 
% figure, hold on
% plot(f, mean(S),'linewidth',2)
% plot(f2, S2,'r')
% yl=ylim;
% plot(f1,rescale(spe,yl(1),yl(2)),'k'), xlim([0 40])
% plot(f2, S2,'r')
% plot(f, mean(S),'linewidth',2)
% 
% figure
% params.tapers=[1,2];
% nu=3;Epoch=intervalSet(a*1E4,(a+30)*1E4);[S,t,f,Serr]=mtspecgramc(Data(Restrict(LFPt{2},Epoch)),movingwin,params);Fil1=FilterLFP(Restrict(LFPt{2},Epoch),[4 10],1024);Fil2=FilterLFP(Restrict(LFPt{2},Epoch),[10 15],1024);clf, imagesc(t+Start(Epoch,'s'),rescale(f,-3*1E4,5.5*1E4),10*log10(SmoothDec(S,[1 1]))'), axis xy, hold on, plot(Range(Restrict(LFPt{nu},Epoch),'s'),Data(Restrict(LFPt{nu},Epoch))), hold on, plot(Range(Restrict(LFPt{2},Epoch),'s'),Data(Restrict(LFPt{2},Epoch))+5*1E4,'k'),plot(Range(Restrict(LFPt{6},Epoch),'s'),Data(Restrict(LFPt{6},Epoch))+4*1E4,'k'),hold on, plot(Range(Restrict(LFPt{5},Epoch),'s'),Data(Restrict(LFPt{5},Epoch))+2.5*1E4,'k'), hold on, plot(Range(Restrict(Fil2,Epoch),'s'),2*Data(Restrict(Fil2,Epoch))+1E4,'k'),plot(Range(Restrict(Fil1,Epoch),'s'),Data(Restrict(Fil1,Epoch))-1E4,'k'), plot(Range(Restrict(V,Epoch),'s'),Data(Restrict(V,Epoch))*2E2-3E4,'color',[0.3 0.3 0.3]), ylim([-3E4 5.5E4]), caxis([10 60]),hold on, plot(Range(Restrict(LFPt{1},and(Epoch,MovEpoch)),'s'),Data(Restrict(LFPt{5},and(Epoch,MovEpoch)))+2.5*1E4,'color',[0.4 0.4 0.4]),plot(Range(Restrict(Movtsd,Epoch),'s'),Data(Restrict(Movtsd,Epoch))*5E2-3E4,'color','k')
% 
% Y=Data(Restrict(LFPt{2},Epoch));
% fac=5;
% L = length(Y);
% NFFT = 2^nextpow2(L); % Next power of 2 from length of y
% yf  = fft(Y,NFFT)/L;
% f1 = 1250*1/2*linspace(0,1,NFFT/2+1);
% spe=abs(yf(1:NFFT/2+1));
% [S2,f2,Serr2]=mtspectrumc(Data(Restrict(LFPt{2},Epoch)),params);
% 
% figure, hold on
% plot(f, mean(S),'linewidth',2)
% plot(f2, S2,'r')
% yl=ylim;
% plot(f1,rescale(spe,yl(1),yl(2)),'k'), xlim([0 40])
% plot(f2, S2,'r')
% plot(f, mean(S),'linewidth',2)

% a=a+30; Epoch=intervalSet(a*1E4,(a+30)*1E4); 
% [S,t,f,Serr]=mtspecgramc(Data(Restrict(LFPt{18},Epoch)),movingwin,params);
% clf, imagesc(t+Start(Epoch,'s'),rescale(f,-3*1E4,5.5*1E4),10*log10(S)'), axis xy, hold on, plot(Range(Restrict(LFP{1},Epoch),'s'),Data(Restrict(LFPt{22},Epoch))), hold on, plot(Range(Restrict(LFP{1},Epoch),'s'),Data(Restrict(LFPt{19},Epoch))+4*1E4,'k'),plot(Range(Restrict(LFP{1},Epoch),'s'),Data(Restrict(LFPt{18},Epoch))+5*1E4,'k'),hold on, plot(Range(Restrict(LFP{1},Epoch),'s'),Data(Restrict(LFPt{1},Epoch))+2.5*1E4,'k'), hold on, plot(Range(Restrict(Fil2,Epoch),'s'),2*Data(Restrict(Fil2,Epoch))+1E4,'k'), plot(Range(Restrict(Fil2,Epoch),'s'),Data(Restrict(Fil1,Epoch))-1E4,'k'), plot(Range(Restrict(V,Epoch),'s'),Data(Restrict(V,Epoch))*1E2-3E4,'color',[0.7 0.7 0.7]), ylim([-3E4 5.5E4])
%a=a+30; Epoch=intervalSet(a*1E4,(a+30)*1E4); clf, plot(Range(Restrict(LFP{1},Epoch),'s'),Data(Restrict(LFPt{16},Epoch))), hold on, plot(Range(Restrict(LFP{1},Epoch),'s'),Data(Restrict(LFPt{19},Epoch))+4.5*1E4,'b'),hold on, plot(Range(Restrict(LFP{1},Epoch),'s'),Data(Restrict(LFPt{1},Epoch))+2.5*1E4,'r'), hold on, plot(Range(Restrict(Fil2,Epoch),'s'),2*Data(Restrict(Fil2,Epoch))+1E4,'k'),, plot(Range(Restrict(Fil2,Epoch),'s'),Data(Restrict(Fil1,Epoch))-1E4,'k')




% \\NASDELUXE\






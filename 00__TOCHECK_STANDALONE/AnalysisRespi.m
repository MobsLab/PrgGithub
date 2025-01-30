%AnalysisRespi


% filename='BULB_Mouse_54_03052013_01_RestCx_';
% eval(['respi=',filename,'respiration_Ch25.values;'])
% eval(['intRespi=',filename,'respiration_Ch25.interval;'])
% tpsRespi=([1:length(respi)]-1)*intRespi;
% 
% 
% filename='BULB_Mouse_54_03052013_02_RestBO_';
% eval(['respi=',filename,'respiration_Ch25.values;'])
% %respi=SmoothDec(respi,20);
% eval(['intRespi=',filename,'respiration_Ch25.interval;'])
% tpsRespi=([1:length(respi)]-1)*intRespi;


filename='BULB_Mouse_60_14052013_03_Rest_';
eval(['respi=',filename,'respiration_Ch25.values;'])
%respi=SmoothDec(respi,20);
eval(['intRespi=',filename,'respiration_Ch25.interval;'])
tpsRespi=([1:length(respi)]-1)*intRespi;




for i=1:35
    try
eval(['ch',num2str(i),'=',filename,'wideband_Ch',num2str(i),'.values;'])
    end
end
eval(['intCh=',filename,'wideband_Ch3.interval;'])
tpsCh=([1:length(ch3)]-1)*intCh;

try
tpsMov=([1:length(Range(Movtsd,'s'))]-1)*tpsRespi(end)/length(Range(Movtsd,'s'));
end

i=0;a=0; 
figure('color',[1 1 1]), hold on, plot(tpsRespi,respi*2,'k', 'linewidth',2)
for id=[3 4 6 8 10 100 7 100 9 1 12 100 5 14 16 100 11 13 15]
    try
eval(['plot(tpsCh,',num2str(i),'*0.01+ ch',num2str(id),'*30,''color'',[',num2str(i),'/20 0 (20-',num2str(i),')/20])'])
    end
    i=i+1;
 
end
ylim([-0.05 0.2])
try
hold on, plot(tpsMov,Data(Movtsd)/50,'k','linewidth',2)
end
a=a+10; xlim([a a+10])

%channels
% 8 10 : bulb superficial
% 3 4 6  : bulb deep
% 7 14 16 : Pfc (7 ECoG)
% 5: EEG Ctx auditif
% 1 12 9: Cts Parietal (9 ECoG)
% 11 13 15: Hpc (11 Ripples)

movingwin=[4,1];
params.tapers=[3 5];
params.Fs=1000;
params.fpass=[0 70];
[C,phi,S12,S1,S2,t,f]=cohgramc(ch6,respi(1:length(ch6)),movingwin,params);
[Cb,phib,S12b,S1b,S2b,tb,fb]=cohgramc(ch6,ch7,movingwin,params);
[Cc,phic,S12c,S1c,S2c,tc,fc]=cohgramc(ch6,ch14,movingwin,params);
[Cd,phid,S12d,S1d,S2d,td,fd]=cohgramc(ch6,ch12,movingwin,params);

[Ce,phie,S12e,S1e,S2e,te,fe]=cohgramc(respi(1:length(ch6)),ch7,movingwin,params);
[Cf,phif,S12f,S1f,S2f,tf,ff]=cohgramc(respi(1:length(ch6)),ch14,movingwin,params);
[Cg,phig,S12g,S1g,S2g,tg,fg]=cohgramc(respi(1:length(ch6)),ch12,movingwin,params);


[Ch,phih,S12h,S1h,S2h,th,fh]=cohgramc(ch6,ch11,movingwin,params);
[Ci,phii,S12i,S1i,S2i,ti,fi]=cohgramc(respi(1:length(ch6)),ch11,movingwin,params);

% 
% figure('color',[1 1 1]),
% subplot(4,1,1),imagesc(t,f,C'), axis xy
% subplot(4,1,2),imagesc(t,f,Cb'), axis xy
% subplot(4,1,3),imagesc(t,f,Cc'), axis xy
% subplot(4,1,4),imagesc(t,f,Cd'), axis xy
% 


figure('color',[1 1 1]),
subplot(5,2,1),imagesc(t,f,SmoothDec(C',[2 2])), axis xy
subplot(5,2,3),imagesc(t,f,SmoothDec(Cb',[2 2])), axis xy
subplot(5,2,4),imagesc(t,f,SmoothDec(Ce',[2 2])), axis xy
subplot(5,2,5),imagesc(t,f,SmoothDec(Cc',[2 2])), axis xy
subplot(5,2,6),imagesc(t,f,SmoothDec(Cf',[2 2])), axis xy
subplot(5,2,7),imagesc(t,f,SmoothDec(Cd',[2 2])), axis xy
subplot(5,2,8),imagesc(t,f,SmoothDec(Cg',[2 2])), axis xy
subplot(5,2,9),imagesc(t,f,SmoothDec(Ch',[2 2])), axis xy
subplot(5,2,10),imagesc(t,f,SmoothDec(Ci',[2 2])), axis xy


figure, plot(tpsRespi,respi*200,'k', 'linewidth',2)
hold on, plot(tpsMov,Data(Movtsd)+30,'b','linewidth',1)

plot(tpsCh,ch3*1E4-60,'k')
plot(tpsCh,ch14*1E4-20,'r')
plot(tpsCh,ch1*1E4-40,'b')
plot(tpsCh,ch15*1E4+20,'r')



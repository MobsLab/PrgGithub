%testSpecAnalysis

sav=0;

cd /Users/karimbenchenane/Dropbox/
load DataSpectAnalysisdata03MMN
% load('/Users/karimbenchenane/Dropbox/LFPDatadata03MMN.mat')

try
    load LFPData
catch
    load('/Users/karimbenchenane/Dropbox/LFPDatadata03MMN.mat')
end

ch=1;

EEGsleep=LFP{ch};

st = StartTime(EEGsleep);
FsOrig = 1 / median(diff(Range(EEGsleep, 's')));
times = Range(EEGsleep);
dp = Data(EEGsleep);
%clear EEGsleep
deeg = resample(dp, 600, 3000);
tps=[1:length(deeg)]/FsOrig/600*3000;
%clear dp
display 'b'
params.Fs = 200;
params.Fs =FsOrig*600/3000;


% %param spindles
% params.fpass = [0 40];
% params.err = [2, 0.95];
% params.trialave = 0;
% params.tapers=[3,5];
% movingwin = [0.8, 0.01];
% params.pad=1;

% %param theta
% params.fpass = [0 40];
% params.err = [2, 0.95];
% params.trialave = 0;
% params.tapers=[1,2];
% movingwin = [3, 0.2];
% params.pad=2;

%param Delta
params.fpass = [0 40];
params.err = [2, 0.95];
params.trialave = 0;
params.tapers=[1,2];
movingwin = [1, 0.05];
params.pad=2;

try
    S;
    t;
    f;
catch
    [S,t,f,Serr]=mtspecgramc(deeg,movingwin,params);
end
display 'c'
%clear deeg
sleepSpecgramFreq = f(:);


PowSpindles=mean(S(:,find(f>10&f<14))');
PowDelta=mean(S(:,find(f>2&f<4))');


%all this fuss is necessary to accommodate for EEG recordigns with possible
%gaps in them
t1 = 0:(1/FsOrig):((1/FsOrig)*(length(times)-1));
[t2, ix] = Restrict(ts(t1), t-movingwin(1)/2);
times = times(ix);

fac=2;



figure('color',[1 1 1]),
% figure(1), clf

imagesc(times/10000, sleepSpecgramFreq, log10(abs(S')+eps));
set(gcf, 'position', [54   532   917   380]);
axis xy
drawnow
display 'd'

hold on
% plot(Range(EEGsleep,'s')-movingwin(1)/2,Data(EEGsleep)/1000+5,'k')



if 1
    
    plot(times/10000,rescale(PowSpindles,0,30),'r','linewidth',2)
    plot(times/10000,rescale(PowDelta,0,150),'w','linewidth',2)
end



%plot(Range(LFP{13},'s')-movingwin(1)/2,Data(LFP{13})/1000+5,'k')
for i=1:15
plot(Range(LFP{i},'s')-movingwin(1)/2,fac*Data(LFP{i})/1000+fac*i+fac*2.5,'k')
end

plot(Range(LFP{10},'s')-movingwin(1)/2,fac*Data(LFP{10})/1000+fac*10+fac*2.5,'k','linewidth',2)
plot(Range(LFP{5},'s')-movingwin(1)/2,fac*Data(LFP{5})/1000+fac*5+fac*2.5,'k','linewidth',2)

plot(tps-movingwin(1)/2,fac*deeg/1000+fac*2.5,'b','linewidth',1)
ylim([0 fac*20])
a=0;
caxis([0 6.2])
a=a+6; xlim([a a+6])




%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%--------------------------------------------------------------

if 1

%lfp=CleanLFP(EEGsleep,[-2500 2500]);

badEpoch1=thresholdIntervals(EEGsleep,3000,'Direction','Above');
badEpoch2=thresholdIntervals(EEGsleep,-3000,'Direction','Below');

badEpoch=or(badEpoch1,badEpoch2);
badEpoch=dropShortIntervals(badEpoch,0.01E4);
badEpoch=mergeCloseIntervals(badEpoch,4E4);
badEpoch=dropShortIntervals(badEpoch,4E4);

rg=Range(EEGsleep);
Epoch=intervalSet(rg(1),rg(end));
deb=rg(1);
goodEpoch=Epoch-badEpoch;


%  figure, plot(Range(EEGsleep,'s'),Data(EEGsleep))
%  hold on, plot(Range(Restrict(EEGsleep,badEpoch),'s'),Data(Restrict(EEGsleep,badEpoch)),'r.')
% 
% hold on, plot(Range(Restrict(EEGsleep,goodEpoch),'s'),Data(Restrict(EEGsleep,goodEpoch)),'g.')

thspindles1=3;
thspindles2=1.5;

try
    spiPeaks;
    lfp;
    
catch
        

    clear spiPeaks
    spiPeaks=[];

    for i=1:length(Start(goodEpoch))
        try
            lfp=Restrict(EEGsleep,subset(goodEpoch,i));
            % [spiStarts, spiEnds, spiPeakstemp] = findSpindles(lfp, thspindles1, thspindles2);
            [spiPeakstemp] = findSpindles2(lfp, thspindles1,thspindles2);

            % length(Range(spiPeakstemp))
            spiPeaks=[spiPeaks; Range(spiPeakstemp)];
        end
    end
    spiPeaks=ts(sort(spiPeaks));
end


det=Range(spiPeaks,'s')-movingwin(1)/2;
try
    line([det det],[0 fac*20],'color','k','linewidth',1)
end
%plot(Range(spiPeaks,'s')-movingwin(1)/2,3.5*ones(length(Range(spiPeaks)),1),'ko','markerfacecolor','k')

num=gcf;


% figure, hold on, plot(Range(EEGsleep,'s'),Data(EEGsleep))
% plot(Range(spiPeaks,'s'),3.5*ones(length(Range(spiPeaks)),1),'ko','markerfacecolor','y')

% tbins=4;nbbins=300;
% [ma,sa,tpsa]=mETAverage(Range(spiPeaks), Range(EEGsleep),Data(EEGsleep),tbins,nbbins);
% figure('color',[1 1 1]),plot(tpsa,smooth(ma,3),'k')
% yl=ylim;
% line([0 0],[yl(1) yl(2)],'color','r')


% figure('color',[1 1 1]),ImagePETH(EEGsleep, spiPeaks, -10000, +10000,'BinSize',10);
% figure('color',[1 1 1]),ImagePETH(tsd(t*1E4,PowSpindles'), spiPeaks, -80000, +80000,'BinSize',50);



%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%--------------------------------------------------------------


thD=2.5;


try

    tDeltaT;
    tDeltaP;
    
catch
    
    clear tDelta
    tDeltaP=[];
    tDeltaT=[];
    for i=1:length(Start(goodEpoch))
        try
    lfp=Restrict(EEGsleep,subset(goodEpoch,i));

    Filt_EEGd = FilterLFP(lfp, [1 5], 1024);

    eegd=Data(Filt_EEGd)';
    td=Range(Filt_EEGd,'s')';

     de = diff(eegd);
      de1 = [de 0];
      de2 = [0 de];


      %finding peaks
      upPeaksIdx = find(de1 < 0 & de2 > 0);
      downPeaksIdx = find(de1 > 0 & de2 < 0);

      PeaksIdx = [upPeaksIdx downPeaksIdx];
      PeaksIdx = sort(PeaksIdx);

      Peaks = eegd(PeaksIdx);
    %   Peaks = abs(Peaks);

     tDeltatemp=td(PeaksIdx);


    DetectThresholdP=+mean(Data(Filt_EEGd))+thD*std(Data(Filt_EEGd));
    DetectThresholdT=mean(Data(Filt_EEGd))-thD*std(Data(Filt_EEGd));

    % length(tDeltatemp)

    idsT=find((Peaks<DetectThresholdT));
    idsP=find((Peaks>DetectThresholdP));

    tDeltatempT=tDeltatemp(idsT);
    tDeltatempP=tDeltatemp(idsP);

    tDeltaT=[tDeltaT,tDeltatempT];
    tDeltaP=[tDeltaP,tDeltatempP];
        end
    end


tDeltaT=ts(sort(tDeltaT)*1E4);
tDeltaP=ts(sort(tDeltaP)*1E4);

end

% tbins=4;nbbins=300;
% [ma,sa,tpsa]=mETAverage(Range(tDeltaT), Range(EEGsleep),Data(EEGsleep),tbins,nbbins);
% figure('color',[1 1 1]),plot(tpsa,smooth(ma,3),'k')
% yl=ylim;
% line([0 0],[yl(1) yl(2)],'color','r')

tdeltaT=Range(tDeltaT);
tdeltaP=Range(tDeltaP);



idd=find(tdeltaT+1E4<rg(end)&tdeltaT-1E4>0);
tDeltaT2=tdeltaT(idd);
tDeltaT2=ts(tDeltaT2);

% figure('color',[1 1 1]),ImagePETH(EEGsleep, tDeltaT2, -10000, +10000,'BinSize',10);


idd=find(tdeltaP+1E4<rg(end)&tdeltaP-1E4>0);
tDeltaP2=tdeltaP(idd);
tDeltaP2=ts(tDeltaP2);

% figure('color',[1 1 1]),ImagePETH(EEGsleep, tDeltaP2, -10000, +10000,'BinSize',10);



%figure('color',[1 1 1]),ImagePETH(tsd(t*1E4,PowSpindles'), tDealta, -80000, +80000,'BinSize',50);




% close 
% for i=1:15
% figure('color',[1 1 1]),ImagePETH(LFP{i}, tDeltaT2, -10000, +10000,'BinSize',10);title(num2str(i)), caxis([-3000 3000])
% end
% 







figure(num)
detDT=Range(tDeltaT,'s')-movingwin(1)/2;
detDP=Range(tDeltaP,'s')-movingwin(1)/2;
line([detDT detDT],[0 fac*20],'color',[1 0.7 0.7],'linewidth',2)
% line([detDP detDP],[0 fac*20],'color',[0.7 0.7 1],'linewidth',2)
a=a+6; xlim([a a+6])





%%
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------



figure('color',[1 1 1]), 

% figure(2), clf

subplot(3,1,1), hold on
tbins=4;nbbins=300;
try
    ma;
catch
    
for i=1:15
[ma{i},sa{i},tpsa{i}]=mETAverage(Range(tDeltaT2), Range(LFP{i}),Data(LFP{i}),tbins,nbbins);
end
end

for i=1:15
plot(tpsa{i},smooth(ma{i},3),'color',[i/15 0 (15-i)/15])
end
% i=5; [ma{i},sa{i},tpsa{i}]=mETAverage(Range(tDeltaT2), Range(LFP{i}),Data(LFP{i}),tbins,nbbins);
i=5;plot(tpsa{i},smooth(ma{i},3),'color',[i/15 0 (15-i)/15],'linewidth',2)
% i=10; [ma{i},sa{i},tpsa{i}]=mETAverage(Range(tDeltaT2), Range(LFP{i}),Data(LFP{i}),tbins,nbbins);
i=10;plot(tpsa{i},smooth(ma{i},3),'color',[i/15 0 (15-i)/15],'linewidth',2)
yl=ylim;
line([0 0],[yl(1) yl(2)],'color','k')




subplot(3,1,2), hold on
tbins=4;nbbins=300;
try
    mb;
catch
for i=1:15
[mb{i},sb{i},tpsb{i}]=mETAverage(Range(tDeltaP2), Range(LFP{i}),Data(LFP{i}),tbins,nbbins);
end
end
for i=1:15
plot(tpsb{i},smooth(mb{i},3),'color',[i/15 0 (15-i)/15])
end
% i=5; [ma,sa,tpsa]=mETAverage(Range(tDeltaP2), Range(LFP{i}),Data(LFP{i}),tbins,nbbins); plot(tpsa,smooth(ma,3),'color',[i/15 0 (15-i)/15],'linewidth',2)
% i=10; [ma,sa,tpsa]=mETAverage(Range(tDeltaP2), Range(LFP{i}),Data(LFP{i}),tbins,nbbins);plot(tpsa,smooth(ma,3),'color',[i/15 0 (15-i)/15],'linewidth',2)
i=5; plot(tpsb{i},smooth(mb{i},3),'color',[i/15 0 (15-i)/15],'linewidth',2)
i=10; plot(tpsb{i},smooth(mb{i},3),'color',[i/15 0 (15-i)/15],'linewidth',2)
yl=ylim;
line([0 0],[yl(1) yl(2)],'color','k')


subplot(3,1,3), hold on
tbins=4;nbbins=300;
try
    mc;
catch
for i=1:15
[mc{i},sc{i},tpsc{i}]=mETAverage(Range(spiPeaks), Range(LFP{i}),Data(LFP{i}),tbins,nbbins);
end

end
for i=1:15
    plot(tpsc{i},smooth(mc{i},3),'color',[i/15 0 (15-i)/15])
end

% i=5; [ma,sa,tpsa]=mETAverage(Range(spiPeaks), Range(LFP{i}),Data(LFP{i}),tbins,nbbins);plot(tpsa,smooth(ma,3),'color',[i/15 0 (15-i)/15],'linewidth',2)
% i=10; [ma,sa,tpsa]=mETAverage(Range(spiPeaks), Range(LFP{i}),Data(LFP{i}),tbins,nbbins);plot(tpsa,smooth(ma,3),'color',[i/15 0 (15-i)/15],'linewidth',2)
i=5; plot(tpsc{i},smooth(mc{i},3),'color',[i/15 0 (15-i)/15],'linewidth',2)
i=10; plot(tpsc{i},smooth(mc{i},3),'color',[i/15 0 (15-i)/15],'linewidth',2)
yl=ylim;
line([0 0],[yl(1) yl(2)],'color','k')

xlim([-250 250])


%%
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------

figure('color',[1 1 1]), 

subplot(2,4,1:3), plot(Range(LFP{9},'s'),Data(LFP{10}))
hold on, plot(Range(LFP{9},'s'),Data(LFP{11}),'k')
hold on, plot(Range(LFP{9},'s'),Data(LFP{15}),'r')
hold on, plot(Range(LFP{9},'s'),Data(LFP{13}),'m')
line([0 rg(end)/1E4],[0 0],'color','k')
title('blue: EEG, black: EcoG, red: LFP superficial, magenta: LFP deep')
ylim([-2000 2000])

subplot(2,4,5:7), 
% plot(Range(LFP{9},'s'),Data(LFP{10})-Data(LFP{11}),'k')
hold on, plot(Range(LFP{9},'s'),Data(LFP{15})-Data(LFP{13}),'r')
plot(Range(LFP{9},'s'),Data(LFP{10})-Data(LFP{15}),'b')
% ylim([-2000 2000])
line([0 rg(end)/1E4],[0 0],'color','k')
title('black: EEG-ECoG, red: LFP superficial - LFP deep, blue: EEG-LFP superficial')

subplot(2,4,4), plot(Data(LFP{10})-Data(LFP{11}),Data(LFP{15})-Data(LFP{13}),'k.')
subplot(2,4,8), plot(Data(LFP{10})-Data(LFP{15}),Data(LFP{15})-Data(LFP{13}),'k.')

% [h1,bin1]=hist(Data(LFP{11}),500);
% [h2,bin2]=hist(Data(LFP{10}),500);
% subplot(2,4,8),  plot(bin1,h1,'k')
% hold on, plot(bin2,h2,'b')

a=a+4; subplot(2,4,1:3), xlim([a a+4]),subplot(2,4,5:7), xlim([a a+4])


%%

figure(num)
detDT=Range(tDeltaT,'s')-movingwin(1)/2;
detDP=Range(tDeltaP,'s')-movingwin(1)/2;
line([detDT detDT],[0 fac*20],'color',[1 0.7 0.7],'linewidth',2)
% line([detDP detDP],[0 fac*20],'color',[0.7 0.7 1],'linewidth',2)
a=a+6; xlim([a a+6])




%%
                if 0



                            params.fpass = [0 20];
                            params.err = [2, 0.95];
                            params.trialave = 0;
                            params.tapers=[1,2];
                            movingwin = [0.5, 0.05];
                            params.pad=1;

                            FsOrig = 1 / median(diff(Range(EEGsleep, 's')));

                            dpA = Data(LFP{15})-Data(LFP{13});
                            deegA = resample(dpA, 600, 3000);
                            dpB = Data(LFP{10})-Data(LFP{15});
                            deegB = resample(dpB, 600, 3000);

                            tps=[1:length(deegA)]/FsOrig/600*3000;

                            params.Fs =FsOrig*600/3000;

                            Atsd=tsd(tps*1E4,deegA); 
                            Btsd=tsd(tps*1E4,deegB);

                            atsd=tsd(Range(LFP{9}),Data(LFP{15})-Data(LFP{13})); 
                            btsd=tsd(Range(LFP{9}),Data(LFP{10})-Data(LFP{15})); 


                            [C,phi,S12,S1,S2,tps,freq,confC,phierr]=cohgramc(Data(Atsd),Data(Btsd),movingwin,params);

                            Phi=phi;
                            phi=mod(phi+pi,2*pi);

                            smo1=0.7;
                            smo2=0.7;

                            figure('color',[1 1 1]), 
                            subplot(5,3,1:2), hold on
                            hold on, plot(Range(Atsd,'s')-movingwin(1)/2,Data(Atsd),'k')
                            plot(Range(Btsd,'s')-movingwin(1)/2,Data(Btsd),'r')
                            ylim([-2000 2000])
                            subplot(5,3,4:5), imagesc(tps,freq,SmoothDec(C',[smo1,smo2])), axis xy
                            subplot(5,3,7:8), imagesc(tps,freq,10*log10(S1')), axis xy
                            subplot(5,3,10:11), imagesc(tps,freq,10*log10(S2')), axis xy
                            subplot(5,3,13:14), imagesc(tps,freq,SmoothDec(phi',[smo1,smo2])), axis xy


                            Cbis=SmoothDec(C,[smo1,smo2]);
                            phibis=SmoothDec(phi,[smo1,smo2]);

                            a=a+4; 
                            for i=1:5, 
                            subplot(5,3,1:2), xlim([a a+4]) 
                            subplot(5,3,4:5), xlim([a a+4]) 
                            subplot(5,3,7:8), xlim([a a+4]) 
                            subplot(5,3,10:11), xlim([a a+4]) 
                            subplot(5,3,13:14), xlim([a a+4]) 
                            end

                            subplot(5,3,6), plot(freq,mean(Cbis(find(tps>a&tps<a+4),:)),'k')
                            subplot(5,3,9), plot(freq,mean(S1(find(tps>a&tps<a+4),:)),'k')
                            subplot(5,3,12), plot(freq,mean(S2(find(tps>a&tps<a+4),:)),'k')
                            subplot(5,3,15), 
                            hold on, plot(freq,mu,'wo','markerfacecolor','w'), ylim([0 12.5])
                            plot(freq,mu+2*pi,'wo','markerfacecolor','w'), ylim([0 12.5])

                            for i=1:length(freq)
                                Ph=mod(phibis(find(tps>a&tps<a+4),i),2*pi);
                            [mu(i), Kappa, pval] = CircularMean(Ph);
                            end
                            subplot(5,3,15), 
                            hold on% rose(2*pi*Ph)
                            plot(freq,mu,'ko','markerfacecolor','k'), ylim([0 12.5])
                            plot(freq,mu+2*pi,'ko','markerfacecolor','k'), ylim([0 12.5])










                            figure('color',[1 1 1]), 
                            for i=1:length(freq)
                            %     MPh=mod(phi(:,i)+pi,2*i);
                            [muT(i), Kappa(i), pval(i)] = CircularMean(phi(:,i));
                            end
                            subplot(3,1,1), hold on,
                            plot(freq,muT,'k','linewidth',2), ylim([0 6])
                            plot(freq(pval<0.05),muT(pval<0.05),'ro','markerfacecolor','r')
                            subplot(3,1,2), hold on
                            plot(freq,log(Kappa),'k','linewidth',2)
                            plot(freq(pval<0.05),log(Kappa(pval<0.05)),'ro','markerfacecolor','r')
                            subplot(3,1,3), plot(freq,pval,'k','linewidth',2)


                end

%%


end


% 
% 
% tbins=5;
% nbbins=200;
% [ma,sa,tpsa]=mETAverage(Range(spiPeaks)/10, Range(EEGsleep)/10,Data(EEGsleep),tbins,nbbins);
% [mb,sb,tpsb]=mETAverage(Range(spiPeaks)/10, Range(LFP{10})/10,Data(LFP{10}),tbins,nbbins);
% [mc,sc,tpsc]=mETAverage(Range(spiPeaks)/10, Range(LFP{5})/10,Data(LFP{5}),tbins,nbbins);
% [md,sd,tpsd]=mETAverage(Range(spiPeaks)/10, Range(LFP{15})/10,Data(LFP{15}),tbins,nbbins);
% 
% 
% 
% 
% figure('color',[1 1 1])
% subplot(2,1,1), hold on
% plot(tpsa,ma,'k')
% plot(tpsb,mb,'b')
% yl=ylim;
% line([0 0],[yl(1) yl(2)],'color','r')
% % xlim([tps1(1) tps1(end)])
% %xlim([-500 500])
% title('LFP vs Spindles peaks')
% 
% subplot(2,1,2), hold on
% plot(tpsc,mc,'k')
% plot(tpsd,md,'b')
% yl=ylim;
% line([0 0],[yl(1) yl(2)],'color','r')
% % xlim([tps1(1) tps1(end)])
% %xlim([-500 500])
% title('LFP vs Delta waves')


% 
% figure('color',[1 1 1]), hold on
% plot(Range(Restrict(LfpS,Epoch),'s'),Data(Restrict(LfpS,Epoch)),'k')
% plot(Range(Restrict(LfpS,Epoch),'s'),Data(Restrict(LfpD,Epoch)),'r')
% plot(tPeaks/1E4,ones(length(tPeaks),1),'ko','markerfacecolor','g')
% plot(tDelta/1E4,ones(length(tDelta),1),'ko','markerfacecolor','y')


a=86.5; xlim([a a+6])


if sav
cd /Users/karimbenchenane/Dropbox/
save DataSpectAnalysisdata03MMN
end
function AnalyBulb(LFP2,chCortexLFP,chCortexEEG,chBulb,chTh)

%
%LFP2,chCortexLFP,chCortexEEG,chBulb,chTh)
%
%

%%
 if 0

    try
    cd /Users/karimbenchenane/Documents/Data/DataEnCours/Lisa/DatainVivo/Mouse047/20120921
    catch

    cd /media/GeorgeBackUp/DataDisk2/DataBULB/Mouse047/20120921/BULB-Mouse-47-21092012
    end

    try
        LFP;
    catch
        load LFPData
    end

    load behavResources

    Epoch=intervalSet(tpsEvt{2}*1E4,tpsEvt{3}*1E4);

    %Epoch=intervalSet(900*1E4, 1200*1E4);


    listLFPOK=[[1:5],7,10,11,12,13,14,[16:24]];
    a=tpsEvt{2};

    % 
    % fac=1;
    % 
    % figure('color',[1 1 1]), hold on
    % for i=1:length(LFP)
    %     
    % plot(Range(LFP{i},'s'),fac*Data(LFP{i})/1000+fac*i+fac*2.5,'k')
    % 
    % end
    % 
    % i=6; plot(Range(LFP{i},'s'),fac*Data(LFP{i})/1000+fac*i+fac*2.5,'g')
    % i=8; plot(Range(LFP{i},'s'),fac*Data(LFP{i})/1000+fac*i+fac*2.5,'g')
    % i=9; plot(Range(LFP{i},'s'),fac*Data(LFP{i})/1000+fac*i+fac*2.5,'g')
    % i=12; plot(Range(LFP{i},'s'),fac*Data(LFP{i})/1000+fac*i+fac*2.5,'g')



    try
        listLFPOK;
    catch

        listLFPOK=[1:length(LFP)];
    end

    LFP2=LFP(listLFPOK);

    LFP3=LFP2;


    try
        Epoch;
    catch
        Epoch=intervalSet(0,10E4);
    end


    LFP2=Restrict(LFP2,Epoch);

 end

 %%

 
 
 rg=Range(LFP2{1});
 Epoch=intervalSet(rg(1),rg(end));
 
 
 
 
fac=1;

figure('color',[1 1 1]), hold on
for i=1:length(LFP2)
    
plot(Range(LFP2{i},'s'),fac*Data(LFP2{i})/1000+fac*i+fac*2.5,'k')

end

numfig=gcf;


i=chCortexLFP; plot(Range(LFP2{i},'s'),fac*Data(LFP2{i})/1000+fac*i+fac*2.5,'b','linewidth',2)
try
    i=chCortexEEG; plot(Range(LFP2{i},'s'),fac*Data(LFP2{i})/1000+fac*i+fac*2.5,'r','linewidth',2)
end
i=chTh; plot(Range(LFP2{i},'s'),fac*Data(LFP2{i})/1000+fac*i+fac*2.5,'k','linewidth',2)
set(gcf,'Position',[75 556 1382 351])


if 1


        [Dt1,Dp1,Sp1,Ri1,ma1,sa1,tpsa1,mb1,sb1,tpsb1,mc1,sc1,tpsc1,md1,sd1,tpsd1,me1,se1,tpse1]=IdentifyDeltaSpindlesRipples(LFP2,chCortexLFP,chCortexEEG,3000,1);%ploTot);
        %[Dt2,Dp2,Sp2,Ri2,ma2,sa2,tpsa2,mb2,sb2,tpsb2,mc2,sc2,tpsc2,md2,sd2,tpsd2,me2,se2,tpse2]=IdentifyDeltaSpindlesRipples(LFP2,16,[],3000,1);%ploTot);







        thD=4; %2.5

        clear tDelta
        clear tDeltaT
        clear tDeltaP
        clear tDeltaT2
        clear tDeltaP2
        tDeltaP=[];
        tDeltaT=[];

        Filt_EEGd = FilterLFP(LFP2{chTh}, [2 20], 1024);
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


        tDeltaT=ts(sort(tDeltaT)*1E4);
        tDeltaP=ts(sort(tDeltaP)*1E4);


        tdeltaT2=Range(tDeltaT);
        tdeltaP2=Range(tDeltaP);

        rg=Range(LFP2{1});


        idd=find(tdeltaT2+1E4<rg(end)&tdeltaT2-1E4>0);
        tDeltaT2=tdeltaT2(idd);
        tDeltaT2=ts(tDeltaT2);

        idd=find(tdeltaP2+1E4<rg(end)&tdeltaP2-1E4>0);
        tDeltaP2=tdeltaP2(idd);
        tDeltaP2=ts(tDeltaP2);

        % 
        % Epoch=intervalSet(0,10E4);
        % tDeltaT2=Restrict(tDeltaT2,Epoch);
        % tDeltaP2=Restrict(tDeltaP2,Epoch);

        yl=ylim;
        line([Range(tDeltaT,'s') Range(tDeltaT,'s')],yl,'color','g','linewidth',2)

        if 1

            for i=1:length(LFP2)
            figure, [fh, rasterAx, histAx, matVal] = ImagePETH(LFP2{i}, tDeltaT2, -25000, +25000,'BinSize',500);title(['Deflection Thalamus, ',num2str(i)])
            end

        end







        EEGf=FilterLFP(LFP2{chBulb},[1 4],1024);
        nBins=15;

        figure('color',[1 1 1])
        try
        [phaseTsd, ph] = firingPhaseHilbert(EEGf, {Restrict(Dp1, Epoch)}) ;
        subplot(1,5,1), [muSD(1,2), KappaSD(1,2), pvalSD(1,2)]=JustPoltMod(Data(ph{1}),nBins);
        ylabel('Delta P vs 3Hz oscillation Bulb')
        end
        try
        [phaseTsd, ph] = firingPhaseHilbert(EEGf, {Restrict(Dt1, Epoch)}) ;
        subplot(1,5,2), [muSD(2,2), KappaSD(2,2), pvalSD(2,2)]=JustPoltMod(Data(ph{1}),nBins);
        end
        ylabel('Delta T vs 3Hz oscillation Bulb')
        
        try
        [phaseTsd, ph] = firingPhaseHilbert(EEGf, {Restrict(Sp1, Epoch)}) ;
        subplot(1,5,3), [muSD(2,2), KappaSD(2,2), pvalSD(2,2)]=JustPoltMod(Data(ph{1}),nBins);
        end
        ylabel('Spindles vs 3Hz oscillation Bulb')
        
        try
        [phaseTsd, ph] = firingPhaseHilbert(EEGf, {Restrict(Ri1, Epoch)}) ;
        subplot(1,5,4), [muSD(2,2), KappaSD(2,2), pvalSD(2,2)]=JustPoltMod(Data(ph{1}),nBins);
        end
        ylabel('HFO vs 3Hz oscillation Bulb')
      
        
        try
        [phaseTsd, ph] = firingPhaseHilbert(EEGf, {Restrict(tDeltaT2, Epoch)}) ;
        subplot(1,5,5), [muSD(2,2), KappaSD(2,2), pvalSD(2,2)]=JustPoltMod(Data(ph{1}),nBins);
        end
        ylabel('Thalamic Depol vs 3Hz oscillation Bulb')
        set(gcf,'Position',[73 533 1450 390])

        if 0
        i=1;
        [HS,Ph,ModTheta]=RayleighFreq(LFP2{i},{Restrict(Dp1, Epoch)});title([num2str(i),' delta'])
        [HS,Ph,ModTheta]=RayleighFreq(LFP2{i},{Restrict(Sp1, Epoch)});title([num2str(i),' spindles'])
        i=15;
        [HS,Ph,ModTheta]=RayleighFreq(LFP2{i},{Restrict(Dp1, Epoch)});title([num2str(i),' delta'])
        [HS,Ph,ModTheta]=RayleighFreq(LFP2{i},{Restrict(Sp1, Epoch)});title([num2str(i),' spindles'])
        i=14;
        [HS,Ph,ModTheta]=RayleighFreq(LFP2{i},{Restrict(Dp1, Epoch)});title([num2str(i),' delta'])
        [HS,Ph,ModTheta]=RayleighFreq(LFP2{i},{Restrict(Sp1, Epoch)});title([num2str(i),' spindles'])
        i=18;
        [HS,Ph,ModTheta]=RayleighFreq(LFP2{i},{Restrict(Dp1, Epoch)});title([num2str(i),' delta'])
        [HS,Ph,ModTheta]=RayleighFreq(LFP2{i},{Restrict(Sp1, Epoch)});title([num2str(i),' spindles'])
        i=13;
        [HS,Ph,ModTheta]=RayleighFreq(LFP2{i},{Restrict(Dp1, Epoch)});title([num2str(i),' delta'])
        [HS,Ph,ModTheta]=RayleighFreq(LFP2{i},{Restrict(Sp1, Epoch)});title([num2str(i),' spindles'])
        i=12;
        [HS,Ph,ModTheta]=RayleighFreq(LFP2{i},{Restrict(Dp1, Epoch)});title([num2str(i),' delta'])
        [HS,Ph,ModTheta]=RayleighFreq(LFP2{i},{Restrict(Sp1, Epoch)});title([num2str(i),' spindles'])

        end




        figure(numfig)

        yl=ylim;
        yl=[0 length(LFP2)+5];
        ylim(yl)


        line([Range(Dt1,'s') Range(Dt1,'s')],yl,'color','c','linewidth',1)
        line([Range(Dp1,'s') Range(Dp1,'s')],yl,'color','b','linewidth',2)
        line([Range(Sp1,'s') Range(Sp1,'s')],yl,'color','k','linewidth',2)
        line([Range(Ri1,'s') Range(Ri1,'s')],yl,'color','m','linewidth',2)
        line([Range(tDeltaT2,'s') Range(tDeltaT2,'s')],yl,'color','g','linewidth',2)
        % 
        % line([Range(Dt2,'s') Range(Dt2,'s')],yl,'color','r','linewidth',1)
        % line([Range(Dp2,'s') Range(Dp2,'s')],yl,'color','r','linewidth',2)
        % line([Range(Sp2,'s') Range(Sp2,'s')],yl,'color','m','linewidth',2)
        % line([Range(Ri2,'s') Range(Ri2,'s')],yl,'color','g','linewidth',2)


        a=Start(Epoch,'s');
        a=a+4; xlim([a a+4])







end










% 
% 
% ch=1;
% 
% EEGsleep=LFP{ch};
% 
% st = StartTime(EEGsleep);
% FsOrig = 1 / median(diff(Range(EEGsleep, 's')));
% times = Range(EEGsleep);
% dp = Data(EEGsleep);
% %clear EEGsleep
% deeg = resample(dp, 600, 3000);
% tps=[1:length(deeg)]/FsOrig/600*3000;
% %clear dp
% display 'b'
% 
% params.Fs =FsOrig*600/3000;


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

%EpochSpec=intervalSet(1000*1E4,1200*1E4);

ch=chBulb;

enn=End(Epoch);
stt=Start(Epoch);
Epoch=intervalSet(stt,stt+(enn-stt)/5);
EEGsleep=Restrict(LFP2{ch},Epoch);

params.tapers=[3,2];

Fh=70;
params.Fs =1250;
params.fpass = [0 Fh];
params.err = [2, 0.95];
params.trialave = 0;

movingwin = [2, 0.05];
params.pad=2;

[S,t,f,Serr]=mtspecgramc(Data(EEGsleep),movingwin,params);


fac=2;
movingwin = [0.5, 0.01];
params.pad=1;

[S2,t2,f2,Serr2]=mtspecgramc(Data(EEGsleep),movingwin,params);


times = Range(EEGsleep);

figure('color',[1 1 1]), hold on
% figure(1), clf

subplot(2,1,1), hold on
imagesc(t+times(1)/1E4, f, 10*log10(abs(S')));axis xy,caxis([-10 60])

for i=1:5
hold on, plot(Range(LFP2{i},'s')-movingwin(1)/2,20+fac*Data(LFP2{i})/1000+fac*i+fac*2.5,'k')
end
xlim([Start(Epoch,'s') End(Epoch,'s')])
ylim([0 Fh])

subplot(2,1,2), hold on
imagesc(t2+times(1)/1E4, f2, 10*log10(abs(S2')+eps));axis xy,caxis([-10 60])
set(gcf, 'position', [54   532   917   380]);
axis xy

for i=1:5
hold on, plot(Range(LFP2{i},'s')-movingwin(1)/2,20+fac*Data(LFP2{i})/1000+fac*i+fac*2.5,'k')
end

xlim([Start(Epoch,'s') End(Epoch,'s')])
ylim([0 Fh])
a=Start(Epoch,'s');
a=a+3;subplot(2,1,1), xlim([a a+30]),subplot(2,1,2), xlim([a a+3])






ch=chBulb+1;

EEGsleep=Restrict(LFP2{ch},Epoch);

params.tapers=[3,2];

Fh=70;
params.Fs =1250;
params.fpass = [0 Fh];
params.err = [2, 0.95];
params.trialave = 0;

movingwin = [2, 0.05];
params.pad=2;

[S,t,f,Serr]=mtspecgramc(Data(EEGsleep),movingwin,params);


fac=2;
movingwin = [0.5, 0.01];
params.pad=1;

[S2,t2,f2,Serr2]=mtspecgramc(Data(EEGsleep),movingwin,params);


times = Range(EEGsleep);

figure('color',[1 1 1]), hold on
% figure(1), clf

subplot(2,1,1), hold on
imagesc(t+times(1)/1E4, f, 10*log10(abs(S')+eps));axis xy,caxis([-10 60])

for i=1:5
hold on, plot(Range(LFP2{i},'s')-movingwin(1)/2,20+fac*Data(LFP2{i})/1000+fac*i+fac*2.5,'k')
end
xlim([Start(Epoch,'s') End(Epoch,'s')])
ylim([0 Fh])

subplot(2,1,2), hold on
imagesc(t2+times(1)/1E4, f2, 10*log10(abs(S2')+eps));axis xy,caxis([-10 60])
set(gcf, 'position', [54   532   917   380]);
axis xy

for i=1:5
hold on, plot(Range(LFP2{i},'s')-movingwin(1)/2,20+fac*Data(LFP2{i})/1000+fac*i+fac*2.5,'k')
end

xlim([Start(Epoch,'s') End(Epoch,'s')])
ylim([0 Fh])
a=Start(Epoch,'s');
a=a+3;subplot(2,1,1), xlim([a a+30]),subplot(2,1,2), xlim([a a+3])


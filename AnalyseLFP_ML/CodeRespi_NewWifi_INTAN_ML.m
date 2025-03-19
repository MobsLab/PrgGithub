% CodeRespi_NewWifi_INTAN_ML.m
%cd /media/DataMOBsRAID/ProjetAstro-DataPlethysmo/Mouse241-newwifi/20150228/RESPI-Mouse-241-28022015
%% loading Respi LFP
clear filRespi
try
    load('Respiration.mat')
    filRespi;
    disp('filRespi already exists...')
catch
    clear LFP InfoLFP Resp
    
    disp('Loading data Respi')
    load('LFPData/InfoLFP.mat')
    Resp=InfoLFP.channel(strcmp(InfoLFP.structure,'Respi'));
    
    disp(['      loading LFP',num2str(Resp),'...'])
    eval(['load(''LFPData/LFP',num2str(Resp),'.mat'',''LFP'');'])
    RespiTSD=LFP;
    
    disp('      filtering in [0.1-20]Hz...')
    filRespi=FilterLFP(RespiTSD,[2 20],96);
    filRespi=tsd(Range(filRespi),Data(filRespi)-mean(Data(filRespi)));
    save Respiration filRespi
end

clear LFP smo fac nbcal multCalib
% -------------------------------------------------------------------------
%% Calibration.smr

% load LFPcalib after ndm_start
disp(' ');disp('Calibration of breathing signal')
try
    load('LFPcalib.mat')
    LFP; smo;
    disp('      LFPcalib exists...')
catch
    disp('Do ndm_start in Calibration folder, then return')
    keyboard
    SetCurrentSession
    LFP_temp=GetLFP(0);
    smo=10;
    
    figure, plot(LFP_temp(:,1),LFP_temp(:,2));
    hold on, plot(LFP_temp(:,1),SmoothDec(LFP_temp(:,2),smo),'r');
    
    LFP=tsd(LFP_temp(:,1)*1E4,LFP_temp(:,2));
    save('LFPcalib','LFP','smo');
end
CalibrationTSD=LFP;


%% breathing volume of CalibrationTSD
try
    nbcal; multCalib; fac;
    disp(['      calibration exists for ',num2str(nbcal(1,:))])
catch
    % param
    figure('Color',[1 1 1]), hist(Data(filRespi),1000);
    xlabel('distribution of RespiTSD values'); title('click on the value of the histogram between the two peaks');
    disp('click on the value of the histogram between the two peaks');
    fac=ginput(1); close; fac=fac(1);
    disp('saving fac in LFPcalib.mat')
    save LFPcalib -append fac
    
    % CalibrationTSD
    eegd=SmoothDec(Data(CalibrationTSD),smo)'-fac;
    td=Range(CalibrationTSD);
    
    eegdplus1=[0 eegd];
    eegdplus0=[eegd 0];
    zeroCrossIdx = [find(eegdplus0<0 & eegdplus1>0) find(eegdplus0>0 & eegdplus1<0)];
    zeroCrossIdx = sort(zeroCrossIdx);
    
    IntegerBetwZC=zeros(1,length(zeroCrossIdx)-1);
    for ii=1:length(zeroCrossIdx)-1
        IntegerBetwZC(ii)=trapz(eegd(zeroCrossIdx(ii):zeroCrossIdx(ii+1)));
    end
    AmpInteger=tsd(td(zeroCrossIdx(1:end-1)),IntegerBetwZC');
    
    ok='n';
    while ok~='y'
        figure('Color',[1 1 1]), plot(Range(AmpInteger,'s'),Data(AmpInteger))
        nbcal=input('Enter calibration volumes (mL), e.g. [0.3 0.3 0.1 0.1 0.2 0.2]): ');
        disp('Follow instructions on figure..');
        for j=1:length(nbcal)
            title(['Click min of the ',num2str(nbcal(1,j)),'mL period for tidal volume'])
            A=ginput(1);
            nbcal(2,j)=A(2);
            hold on, line([A(1) A(1)],[nbcal(2,j) 0],'color','r','linewidth',2)
            text(A(1),A(2)*1.1,[num2str(nbcal(1,j)),'mL'])
        end
        multCalib=mean(nbcal(1,:)./abs(nbcal(2,:)));
        title(['multcalib = ',num2str(multCalib)]);
        
        ok=input('Are you satisfied with calibration (y/n)? ','s');
        close
    end
    disp('saving nbcal multCalib in LFPcalib.mat')
    save LFPcalib -append nbcal multCalib
end

%% zerocross of DataRespi

disp(' '); disp('Extracting TidalVolume and Frequency from breathing signal')
try
    TidalVolume; Frequency; NormRespiTSD;
    disp('       TidalVolume and Frequency already exists in Respiration.mat')
    
catch
    
    
    
    clear eegd td
    eegd=SmoothDec(Data(filRespi),smo)'-fac;
    td=Range(filRespi);
    
    eegdplus1=[0 eegd];
    eegdplus0=[eegd 0];
    zeroCross1=find(eegdplus0<0 & eegdplus1>0);
    zeroCross2=find(eegdplus0>0 & eegdplus1<0);
    zeroCrossIdx = [zeroCross1 zeroCross2];
    zeroCrossIdx = sort(zeroCrossIdx);
    
    
    % TidalVolume & Frequency
    
    if length(zeroCrossIdx)<1
        disp('Problem')
        TidalVolume=nan;
        Frequency=nan;
        zeroCrossTsd=nan;
    else
        
        % ZeroCross tsd
        zeroCrossTsd=tsd(td(zeroCrossIdx),zeros(1,length(zeroCrossIdx))'+fac);
        
        
        % integer between two zerocross
        IntegerBetwZC=zeros(1,length(zeroCrossIdx)-1);
        for ii=1:length(zeroCrossIdx)-1
            IntegerBetwZC(ii)=trapz(eegd(zeroCrossIdx(ii):zeroCrossIdx(ii+1)));
        end
        
        
        % remove aberent detected zerocross
        
        nAbZC = hist(abs(IntegerBetwZC),100);
        if nAbZC(1)<0.1*sum(nAbZC)
            temp= sort(abs(IntegerBetwZC));
            
            nAbZC=temp(nAbZC(1));
            
            CorrectedzeroCrossIdx=zeroCrossIdx(1:end-1);
            CorrectedzeroCrossIdx(find(abs(IntegerBetwZC)<nAbZC))=[];
            
            CorrectedIntegerBetwZC=zeros(1,length(CorrectedzeroCrossIdx)-1);
            for ii=1:length(CorrectedzeroCrossIdx)-1
                CorrectedIntegerBetwZC(ii)=trapz(eegd(CorrectedzeroCrossIdx(ii):CorrectedzeroCrossIdx(ii+1)));
            end
            CorrectedzeroCrossTsd=tsd(td(CorrectedzeroCrossIdx),zeros(1,length(CorrectedzeroCrossIdx))'+fac);
        else
            nAbZC=0;
            CorrectedzeroCrossIdx=zeroCrossIdx;
            CorrectedIntegerBetwZC=IntegerBetwZC;
            CorrectedzeroCrossTsd=zeroCrossTsd;
        end
        
        
        
        % TidalVolume
        TidalVolume=tsd(td(CorrectedzeroCrossIdx(find(CorrectedIntegerBetwZC<0))),-multCalib*CorrectedIntegerBetwZC(find(CorrectedIntegerBetwZC<0))');
        
        
        % instaneous frequency
        TempRange=Range(TidalVolume);
        Frequency=tsd(TempRange(1:end-1),1E4./diff(TempRange)); %Hz
        
        
        % display computed values
        figure('Color',[1 1 1]),
        subplot(2,1,1),
        plot(Range(filRespi,'s'),Data(filRespi),'k')
        hold on, plot(Range(zeroCrossTsd,'s'),Data(zeroCrossTsd),'m.')
        hold on, plot(Range(CorrectedzeroCrossTsd,'s'),Data(CorrectedzeroCrossTsd),'r.')
        hold on, plot(Range(TidalVolume,'s'),Data(TidalVolume)*mean(abs(Data(filRespi)))/mean(Data(TidalVolume)),'g.')
        legend('RespiTSD','ZeroCross','CorrectedZeroCross','TidalVolume (au)')
        
        subplot(2,1,2),
        DTV=Data(TidalVolume);
        scatter(Range(Frequency,'s'),DTV(1:end-1),2,Data(Frequency))
        colorbar; title('TidalVolume (mL) colored by Frequency');
        
        ok=input('Are you satisfied with the calculated signal integer and amplitude? (y/n) ','s');
        if ok~='y'; keyboard; else close;end
        
    end
    
    NormRespiTSD=tsd(Range(filRespi),multCalib*Data(filRespi));
    
    disp('       TidalVolume, Frequency and NormRespiTSD in Respiration.mat')
    save Respiration TidalVolume Frequency filRespi zeroCrossTsd CorrectedzeroCrossTsd NormRespiTSD
    
end

%% look at spikes
try
disp('Loading data spikes')
load('SpikeData.mat','S')
end
%% load epochs
disp('Loading State Epochs')
clear SWSEpoch MovEpoch REMEpoch NoiseEpoch GndNoiseEpoch WeirdNoiseEpoch
load StateEpoch SWSEpoch MovEpoch REMEpoch NoiseEpoch GndNoiseEpoch WeirdNoiseEpoch

BasalI=[1,4];
SniffI=[6,13];

disp('Defining Sniff/Basal breathing epochs')
UndefEp=thresholdIntervals(Frequency,SniffI(2),'Direction','Above');
ApneaEp=thresholdIntervals(Frequency,BasalI(1),'Direction','Below');

temp=thresholdIntervals(Frequency,SniffI(2),'Direction','Below');
SniffEp=and(temp,thresholdIntervals(Frequency,SniffI(1),'Direction','Above'));

temp=thresholdIntervals(Frequency,BasalI(2),'Direction','Below');
BasalEp=and(temp,thresholdIntervals(Frequency,BasalI(1),'Direction','Above'));


%% Respi and spikes

res=pwd;
NameEpochs={'and(SWSEpoch,BasalEp)','and(REMEpoch,BasalEp)',...
    'and(MovEpoch,BasalEp)','and(MovEpoch,SniffEp)'};

useNameEpochs={'SWSEpoch','REMEpoch','MovEpoch-Basal','MovEpoch-Sniff'};
if 0
    for nn=1:length(NameEpochs)
        if ~isempty(strfind(NameEpochs{nn},'Sniff'))
            ZapBasalI=[7 10];
            fact=[-4000 5000 80];
        else
            ZapBasalI=[2.5 3.5];
            fact=[-8000 10000 400];
        end
        eval(['tempEp=',NameEpochs{nn},';'])
        temp=thresholdIntervals(Frequency,ZapBasalI(2),'Direction','Below');
        strictBasalEp=and(temp,thresholdIntervals(Frequency,ZapBasalI(1),'Direction','Above'));
        epoch{nn}=and(tempEp,strictBasalEp)-NoiseEpoch-GndNoiseEpoch-WeirdNoiseEpoch;
        testTimes=Range(Restrict(Frequency,epoch{nn}));
        
        
        for i=1:length(S)
            Nneuron=i;
            figure('Color',[1 1 1],'Position',[1500 160 380 800])
            [fh,sq,sweeps, rasterAx] = RasterPETH(S{Nneuron}, ts(testTimes), fact(1), fact(2),'BinSize',fact(3));
            [m,s,tps]=mETAverage(testTimes,Range(filRespi),Data(filRespi),10,1000);
            pause(1)
            tempx=xlim;tempy=ylim;
            ind=find(tps<tempx(2) & tps>tempx(1));
            hold on, plot(tps(ind),rescale(m(ind),tempy(1),tempy(2)),'r','linewidth',2)
            % for info, type "edit Raster"
            % BinSize,Avant,Apres : en ms!!!!!!
            title(['neuron ',num2str(Nneuron),', ',useNameEpochs{nn},',  Breathing ',num2str(ZapBasalI(1)),'-',num2str(ZapBasalI(2)),'Hz'])
            saveFigure(gcf,['Raster_S',num2str(Nneuron),'_',useNameEpochs{nn}],[res,'/RespiSpikes'])
        end
    end
end

%%

if 0
    for nn=1:length(NameEpochs)
        eval(['epoch=',NameEpochs{nn},'-NoiseEpoch-GndNoiseEpoch-WeirdNoiseEpoch;'])
        for i=1:length(S)
            for j=1:length(S)
                if i~=j
                    [A,B]=mjPETH(Range(S{i}),Range(S{j}),testTimes{nn},5,400,1.7);
                    title(['mjPETH(S{',num2str(i),'},S{',num2str(j),'},',NameEpochs{nn},',5,400,1.7)'])
                    saveFigure(gcf,['mjPETH_S',num2str(i),'_S',num2str(j),'_',NameEpochs{nn}],[res,'/RespiSpikes'])
                    
                    %'/media/DataMOBsRAID/ProjetAstro-DataPlethysmo/Mouse241-newwifi/20150228/RESPI-Mouse-241-28022015'
                    % interest: NameEpochs{nn}='SWSEpoch';[A,B]=mjPETH(Range(S{3}),Range(S{1}),testTimes,5,400,1.7);
                end
            end
        end
    end
end

%%
if 0
    figure('Color',[1 1 1])
    for i=1:length(S)
        for nn=1:length(NameEpochs)%NameEpochs)
            subplot(length(S),length(NameEpochs),(i-1)*length(NameEpochs)+nn)
            testTimes=Range(Restrict(Frequency,epoch{nn}));
            [C,B]=CrossCorr(Range(S{i}),testTimes,20,100);
            % interest:
            % NameEpochs{nn}='SWSEpoch';[C,B]=CrossCorr(Range(S{3}),testTimes,20,100);
            Ctsd=tsd(B*10,zscore(C));
            plot(B/1E3,SmoothDec(zscore(C),0.9),'k')
            if isempty(strfind(NameEpochs{nn},'Sniff'))
                fil=FilterLFP(Ctsd,[2 4],24);
                hold on, plot(Range(fil,'s'),Data(fil), 'r','linewidth',2)
            else
                fil2=FilterLFP(Ctsd,[7 9],24);
                hold on, plot(Range(fil2,'s'),Data(fil2), 'b','linewidth',2)            
            end
            title(['S{',num2str(i),'}, ',useNameEpochs{nn},' (',num2str(floor(sum(Stop(epoch{nn},'s')-Start(epoch{nn},'s')))),'s)'])
            if nn==1; ylabel('CountSpike (zscore)');end
            if i==length(S) && nn==2; xlabel('Time from Inspiration (s)');end
        end
    end
    xlabel('Time(s)')
    subplot(length(S),length(NameEpochs),1), legend({'smooth','filter 2-4Hz'})
    text(min(xlim),1.5*max(ylim),res)
    subplot(length(S),length(NameEpochs),length(NameEpochs)), legend({'smooth','filter 7-9Hz'})
    saveFigure(gcf,'CrossCorr_AllNeurons_AllEpochs',[res,'/RespiSpikes'])
    
end

%% PETH neuron with zap
if 1
    % see ZAPRespiML.m
    RespiF=1:12; % Hz
    MAT={};leg=[];
    optionReverse=0;
    rg=Range(Restrict(Frequency,MovEpoch));
    dt=Data(Restrict(Frequency,MovEpoch));
    h = waitbar(0,'ZAP PETH neuron, computing...');
    for r=1:length(RespiF)-1
        % epoch at given breathing frequency
        clear ind ta m
        ind=find(dt>=RespiF(r) & dt<RespiF(r+1) );
        
        %         ep1=thresholdIntervals(Frequency,RespiF(r+1),'Direction','Below');
        %         ep2=thresholdIntervals(Frequency,RespiP(r),'Direction','Above');
        %         freqEp=and(ep1,ep2);
        %         %freqEp=freqEp-SWSEpoch-REMEpoch;
        %         rg=Range(Restrict(Frequency,freqEp));
        %
        if optionReverse
            fact=[-10000 8000 40];
            ind(find(ind==length(rg)))=[]; ta=rg(ind+1);
        else
            fact=[-8000 10000 40];
            ta=rg(ind);
        end
        % filRespi
        [m,s,tps]=mETAverage(ta,Range(filRespi),-Data(filRespi),1,2000);
        MAT{r,1}=m;
        % autocorr freq
        figure,[fh,sq] = RasterPETH(ts(ta), ts(ta), fact(1), fact(2),'BinSize',fact(3));
        MAT{r,2}=Data(sq);
        
        
        %if ~isempty(Start(freqEp))
            for i=1:length(S)
                figure,
                [fh,sq] = RasterPETH(S{i}, ts(ta), fact(1), fact(2),'BinSize',fact(3));
                title(sprintf('Neuron %d, respi period T=%d-%dms',i,RespiF(r),RespiF(r+1)))
                MAT{r,i+2}=Data(sq);
                waitbar(((r-1)*length(S)+i)/(length(S)*(length(RespiF)-1)))
            end
            leg=[leg,{sprintf('%d-%dHz (n=%d)',RespiF(r),RespiF(r+1),length(ta))}];
        %end
    end
    close(h)
    disp(['... saving in Analysis_ZAPspikeML_',num2str(optionReverse),'.mat'])
    eval(['save(''Analysis_ZAPspikeML_',num2str(optionReverse),'.mat'',''MAT'',''RespiF'',''fact'',''Frequency'',''leg'');'])

    %% plot
    smo=3; 
    figure('Color',[1 1 1]);
    for r=1:length(RespiF)-1
        tempColo=[ r/length(RespiF) 0 (length(RespiF)-r)/length(RespiF)];
        for i=1:size(MAT,2)
            subplot(1,size(MAT,2),i), hold on,
            if i==1
                plot(tps/1E3,(length(RespiF)-1-r)*200+MAT{r,i}-mean(MAT{r,i}),'color',tempColo,'linewidth',2)
                %plot(tps/1E3,(length(RespiF)-1-r)*200+rescale(MAT{r,i},-100,100),'color',tempColo,'linewidth',2)
            elseif i==2
                plot(Range(sq,'s'),(length(RespiF)-1-r)*200+MAT{r,i}/50-mean(MAT{r,i})/50,'color',tempColo,'linewidth',2)
                %plot(Range(sq,'s'),(length(RespiF)-1-r)*200+rescale(MAT{r,i},-100,100),'color',tempColo,'linewidth',2)
            else 
                plot(Range(sq,'s'),(length(RespiF)-1-r)*200+SmoothDec(MAT{r,i},smo)/8-mean(SmoothDec(MAT{r,i},smo))/8,'color',tempColo,'linewidth',2)
                %plot(Range(sq,'s'),(length(RespiF)-1-r)*200+rescale(SmoothDec(MAT{r,i},smo),-100,100),'color',tempColo,'linewidth',2)
            end
        end
    end
    
    for r=1:length(RespiF)-1
        for i=1:size(MAT,2)
            if r==length(RespiF)-1
                subplot(1,size(MAT,2),i), hold on,
                if i==1, title('filRespi'),elseif i==2, title('Inspiration Count'), else,title(sprintf('Neuron %d',i-2));end
                if optionReverse
                    if i~=2,line([0 0],[0 2300],'color',[0.7 0.7 0.7]);end
                    plot(-1./RespiF,200*[12:-1:1]-300,'k','linewidth',2)
                    %line([0 -max(RespiF)/1E3],[0 5*180-80],'color','k','linewidth',2);
                    xlim([-0.9 0.75]); ylim([-200 2300]);
                else
                    if i~=2,line([0 0],[0 2300],'color',[0.7 0.7 0.7]);end
                    plot(1./RespiF,200*[12:-1:1]-300,'k','linewidth',2)
                    %line([0 max(RespiF)/1E3],[0 5*180-80],'color','k','linewidth',2);
                    xlim([-0.75 0.9]); ylim([-200 2300]);
                end
                set(gca,'YTickLabel',[])
            end
            
        end
    end
    subplot(1,size(MAT,2),1),
    set(gca,'YTick',(RespiF(1:end-1)-1)*200)
    set(gca,'YTickLabel',leg(end:-1:1))
    subplot(1,size(MAT,2),3), xlabel('Time (s)')
	set(gcf,'Unit','Normalized','Position',[0.1 0.1 0.4 0.6])
    
    %% plot quantification
    
    figure('Color',[1 1 1]);
    params=SpectrumParametersML('low');
	params.Fs=size(MAT{r,i},1)*1E4/(fact(2)-fact(1));
    params.fpass=[0.1 12]; params.tapers=[1 2];
    
    for i=2:size(MAT,2)
        for r=1:length(RespiF)-1
            tempColo=[ r/length(RespiF) 0 (length(RespiF)-r)/length(RespiF)];
            [meanSpi,freqfi]=mtspectrumc(MAT{r,i},params);
            
            subplot(1,size(MAT,2)-1,i-1), hold on,
            plot(freqfi,(length(RespiF)-r-1)*15+10*log10(meanSpi)-mean(10*log10(freqfi'.*meanSpi)),'color',tempColo,'linewidth',2)
        end
        title(sprintf('Neuron %d',i-2));
        xlim([0 12])
        set(gca,'YTickLabel',[])
    end
    subplot(1,size(MAT,2)-1,1),
    set(gca,'YTick',RespiF(1:end-1)*15-15)
    set(gca,'YTickLabel',leg(end:-1:1))
    subplot(1,size(MAT,2)-1,3), xlabel('Fequency (Hz)')
    
end

%% mtspectrumpt instead of PFCx Neurons autocorr
[params,movingwin]=SpectrumParametersML('low');
params.trialave=1;
%tempS={}; for i=1:length(S),  tempS{i}=Data(S{i});end
[dS,t,f]=mtdspecgrampt(Data(Restrict(S{i},intervalSet(0,100*1E4))),movingwin,[0,pi/2],params);
figure, imagesc(t,f,dS); axis xy


%% autocorr neuron ATTENTION PROBLEM DE BORDS
if 0
    zapFreq=[0:2:12];
    figure('Color',[1 1 1])
    dt=Data(Frequency); rg=Range(Frequency);
    colori=colormap('jet');
    for i=1:length(S)
        subplot(1,length(S),i)
        leg=[];
        hold on,
        %mat=[];
        for z=1:length(zapFreq)-1
            ind=find(dt>=zapFreq(z) & dt<zapFreq(z+1));
            ind(ind==length(rg))=[];
            ep=intervalSet(rg(ind),rg(ind+1));
            
            [C, B] = CrossCorr(Range(Restrict(S{i},ep)), Range(Restrict(S{i},ep)), 20 , 300);
            C(B==0)=0;
            %mat=[mat,SmoothDec(zscore(C),20)];
            plot(B/1E3,z+SmoothDec(zscore(C),1),'Color',colori(floor(64*z/length(zapFreq)),:),'Linewidth',2)
            leg=[leg,{sprintf('%d-%dHz (%.1fs)',zapFreq(z) ,zapFreq(z+1),sum(Stop(ep,'s')-Start(ep,'s')))}];
        end
        ylim([0 10])
        xlabel('Time (s)')
        title(['AutoCorr Neuron ',num2str(i),', zap'])
        %xlabel('Time (s)')
        %imagesc(B,1:length(zapFreq)-1,mat'), axis xy
    end
    legend(leg,'Location','BestOutside')
    subplot(1,length(S),2), xlabel({'Time (s)',pwd})
    
    FolderToSave='/home/mobsyoda/Dropbox/MOBS-ProjetAstro/FIGURES/PrelimBULBspikesPFC/';
    saveFigure(gcf,['AutoCorrZAP_',date],FolderToSave)
end


%% autocorr PFCx neurons dpt OB LFP
if 1
    [params,movingwin,suffix]=SpectrumParametersML('newlow');
    [Sp,t,f]=mtspecgramc(Data(LFP),movingwin,params);
    
    ind=nan(length(t),1);
    tSp=10*log10(Sp);
    tf=f(f>1);
    ind=nan(length(t),1);
    for tps=1:length(t)
        try
            ind(tps)=find(tSp(tps,f>1)==max(tSp(tps,f>1)));
        end
    end
    zapTsd=tsd(double(t(~isnan(ind))*1E4)',double(tf(ind(~isnan(ind))))');
    figure, imagesc(t,f,10*log10(Sp)'), axis xy; caxis([20,65])
    %hold on, plot(t(~isnan(ind)),tf(ind(~isnan(ind))),'k')
    hold on, plot(Range(zapTsd,'s'),Data(zapTsd),'k')
    %
    figure,
    zapFreq=[1:0.5:6];
    for i=1:length(S)
        subplot(1,length(S),i), hold on,
        for z=1:length(zapFreq)-1
            ZAPep1=thresholdIntervals(zapTsd,zapFreq(z),'Direction','Above');
            ZAPep2=thresholdIntervals(zapTsd,zapFreq(z+1),'Direction','Below');
            ep=and(ZAPep1,ZAPep2);
            [C, B] = CrossCorr(Range(Restrict(S{i},ep)), Range(Restrict(S{i},ep)), 20 , 300);
            plot(B/1E3,z+SmoothDec(zscore(C),1),'Color',colori(floor(64*z/length(zapFreq)),:),'Linewidth',2)
        end
    end
end

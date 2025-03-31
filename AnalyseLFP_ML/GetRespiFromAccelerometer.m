% GetRespiFromAccelerometer.m

%% INPUTS
NameSave='RespiAccelero';
RespiFilter=[1 4]; % Rappel: sommeil !!
PeriodT=0.32; % in s, period for 1 respiration cycle during sleep
refractPeriod=0.02;
DownSampling=0;
ploLFP=1;
ploSpike=1;
useRipRaw=1;
AnalyComodulo=0;


%% INITIATE

clear Acc SleepEp timeMin


%% LOAD ACCELEROMETER DATA

disp(' '); disp('Loading accelerometer data ')
try
    if ~exist('Acc','var')
        try load([NameSave,'.mat']);end
    end
    try 
        Range(Acc);
        disp(['... Acc has been loaded from ',NameSave,'.mat'])
    catch
        load('behavResources.mat','MovAcctsd')
        Acc=MovAcctsd;
        Range(Acc);
        disp('... Acc has been loaded from behavResources.mat')
    end
catch
    ok=0;
    while ok~=1
        
        load LFPData/InfoLFP.mat
        cha=InfoLFP.channel(strcmp(InfoLFP.structure,'Accelero'));
        if ~isempty(cha)
            namepath=[pwd,'/LFPData/'];
            for cc=1:3, namefiles{cc}=['LFP',num2str(cha(cc)),'.mat'];end
        else
            disp('... Get LFP files X Y and Z (no order)')
            [namefiles,namepath]=uigetfile(pwd,'Get LFP files X Y and Z','MultiSelect','on');
        end
        clear X Y Z
        disp('... Loading LFP.mat (wait!)')
        X=load([namepath,namefiles{1}],'LFP');
        Y=load([namepath,namefiles{2}],'LFP');
        Z=load([namepath,namefiles{3}],'LFP');
        
        try
            disp('... Creating movement Vector')
            MX=Data(X.LFP);
            MY=Data(Y.LFP);
            MZ=Data(Z.LFP);
            Acc2=tsd(Range(X.LFP),MX.*MX+MY.*MY+MZ.*MZ);
            %Acc3=tsd(Range(X.LFP),sqrt(MX.*MX+MY.*MY+MZ.*MZ));
            
            disp(['... Filtering between ',num2str(RespiFilter(1)),'-',num2str(RespiFilter(2)),'Hz (wait!)'])
            FilAcc=FilterLFP(Acc2,RespiFilter);
            %FilAcc=FilterLFP(Acc3,RespiFilter);
            
            if DownSampling
                disp('... DownSampling at 50Hz');
                Rg=Range(FilAcc);
                Dt=Data(FilAcc);
                Acc=tsd(Rg(1:25:end),Dt(1:25:end));
            else
                Acc=FilAcc;
            end
            
            disp(['... Saving in ',NameSave])
            save(NameSave,'namefiles','namepath','Acc','RespiFilter','DownSampling');
            ok=1;
            clear X Y Z FilAcc Acc3 Acc2
        catch
            disp('Problem ! Reselect good LFPs.mat');
        end
    end
end

%% LOAD SLEEP EPOCHS

disp(' '); disp('Respi only when mouse sleeping. Loading sleep epochs')
if ~exist('SleepEp','var')
    disp('... Get StateEpoch.mat')
    [namefileEp,namepathEp]=uigetfile(pwd,'Get good StateEpoch.mat');
    
    TempEp=load([namepathEp,namefileEp],'SWSEpoch','REMEpoch','WeirdNoiseEpoch','GndNoiseEpoch','NoiseEpoch');
    if ~exist('TempEp.WeirdNoiseEpoch','var');TempEp.WeirdNoiseEpoch=intervalSet([],[]);end
    
    SleepEp=or(TempEp.SWSEpoch,TempEp.REMEpoch)-TempEp.WeirdNoiseEpoch-TempEp.GndNoiseEpoch-TempEp.NoiseEpoch;
   
    save(NameSave,'-append','SleepEp','namefileEp','namepathEp');
   
else
    disp(['... Using SleepEp from ',NameSave,'.mat'])
end


%% DETECT LOCAL MINIMA

disp(' '); disp('Getting Respiration time');
%clear timeMin

if ~exist('timeMin','var')
    disp('... Detecting local minima for sleep periods');
    h = waitbar(0,'Detecting local minima for sleep periods');
    timeMin=[];
    for ep=1:length(Start(SleepEp))
        waitbar(ep / length(Start(SleepEp)))
        
        subep=subset(SleepEp,ep);
        Rg=Range(Restrict(Acc,subep),'s');
        Dt=Data(Restrict(Acc,subep));
        
%         figure, plot(Rg,Dt)
        
        sto=Stop(subep,'s');
        sta=Start(subep,'s');
        
        temp=nan(ceil((sto-sta)/PeriodT)+1,2);
        a=sta;
        i=1;
        while sto-a > PeriodT
            index=find(Rg > a & Rg < a+1.3*PeriodT);
            Ri=Rg(index);
            Di=Dt(index);
            temp(i,1:2)=[Ri(Di==min(Di)),min(Di)];
            a=Ri(Di==min(Di))+refractPeriod;
            
%             hold on, plot(Ri(Di==min(Di)),min(Di),'or')
%             xlim([Rg(index(1))-2 Rg(index(1))+3]); ytemp=ylim;
%             line([a a],ytemp,'Color','g')
%             line([a+1.5*PeriodT a+1.5*PeriodT],ytemp,'Color','c')
            
            i=i+1;
        end
        timeMin=[timeMin;temp(~isnan(temp(:,1)),:)];
        
%         close
    end
    close(h) 
    
    disp('... Generating and saving RespiFreq and RespiTimes');
    RespiTimes=tsd(timeMin(:,1)*1E4,timeMin(:,2));
    RespiFreq=tsd(timeMin(1:end-1,1)*1E4,1./diff(timeMin(:,1)));
    
    save(NameSave,'-append','PeriodT','timeMin','RespiFreq','RespiTimes');
    
    
%     figure, plot(Range(Acc,'s'),Data(Acc))
%     xlim([1190 1200])
%     hold on, plot(timeMin(:,1),timeMin(:,2),'or')

else
    disp('... timeMin has been loaded from RespiAccelero.mat');
end



%% VISUALIZE LFP

if ploLFP
    disp(' ');disp('Loading LFP Bulb')
    % get LFP Bulb
    clear InfoLFP
    load LFPData/InfoLFP.mat
    chans=InfoLFP.channel(strcmp(InfoLFP.structure,'Bulb'));
    
    % ImagePETH diff(Acc)
    Rg=Range(RespiFreq);
    disp('... Generating ImagePETH for diff(Acc)');
    
    if useRipRaw
        figure('Color',[1 1 1]),
        difAcc=tsd(Range(Acc),[0;diff(Data(Acc))]);
        [MAcc,TAcc]=PlotRipRaw(difAcc,Rg(1:50:end)/1E4,1000);
    else
        figure('Color',[1 1 1]),
        ImagePETH(tsd(Range(Acc),[0;diff(Data(Acc))]),ts(Rg(1:50:end)) , -5000, +5000);
        caxis([-3 6]*1E4)
        title({'ImagePETH(diff(Acc),RespiFreq(1:50:end))',pwd})
    end
    
    figure('Color',[1 1 1]); numF=gcf;
    colori={'r','k','b','g','m','c'};
    leg=[];
    
    for cc=1:length(chans)
        
        clear temp
        eval(['temp=load(''LFPData/LFP',num2str(chans(cc)),'.mat'',''LFP'');']);
        
        if useRipRaw
            figure('Color',[1 1 1]),
            [M,T]=PlotRipRaw(temp.LFP,Rg(1:50:end)/1E4,1000);
            %figure, averagePETH(Data(temp.LFP),Range(RespiFreq),1000)
            
            if AnalyComodulo
                I=intervalSet(100E4,200E4);
                [VFreq0,VFreq1,Comodulo]=comodulo(Restrict(difAcc,I),Restrict(temp.LFP,I),[1,15],2);
                title({['Comodulo difAcc-LFP',num2str(chans(cc)),' (t=',num2str(Start(I,'s')),'-',num2str(Stop(I,'s')),'s)'],pwd})
                
                [VFreq2,VFreq3,Comodulo2]=comodulo(Restrict(temp.LFP,I),Restrict(temp.LFP,I),[1,15],2);
                title({['Comodulo LFP',num2str(chans(cc)),'-LFP',num2str(chans(cc)),' (t=',num2str(Start(I,'s')),'-',num2str(Stop(I,'s')),'s)'],pwd})
            end
        else
            figure('Color',[1 1 1]);
            [fh, A, h, m] = ImagePETH(temp.LFP,ts(Rg(1:50:end)) , -5000, +5000);
            title({['ImagePETH(LFP',num2str(chans(cc)),',RespiFreq(1:50:end))'],pwd})
        end
        
        [m,s,tps]=mETAverage(Range(RespiFreq),Range(temp.LFP),Data(temp.LFP),10,400);
        figure(numF), hold on, plot(tps,m,'Color',colori{cc});
        leg=[leg {['LFP',num2str(chans(cc))]}];
    end
    legend(leg); Yt=ylim;
    hold on, line([0 0],Yt,'Color',[0.5 0.5 0.5])
end



%% VISUALIZE Spike

if ploSpike
    disp(' ');disp('Loading SpikeData')
    
    % get LFP Bulb
    if ~exist('InfoLFP','var') 
        load LFPData/InfoLFP.mat
    end
    chans=InfoLFP.channel(strcmp(InfoLFP.structure,'PFCx'));
    
    if ~exist('S','var')
        load SpikeData.mat
    end
    
    numtt=[]; 
    for cc=1:length(chans)
        for tt=1:length(tetrodeChannels)
            if ~isempty(find(tetrodeChannels{tt}==chans(cc)))
                numtt=[numtt,tt];
            end
        end
    end
    numNeurons=[];
    for i=1:length(S);
        if ismember(TT{i}(1),numtt)
          numNeurons=[numNeurons,i];  
        end
    end
    %numNeurons=1:length(S);
    
    
    fact=[-8000 10000 400];
    testFreq=[2.5,3 ;3.2,3.7];
    
    for ff=1:size(testFreq,1)
        
        ZapRestrict1=thresholdIntervals(RespiFreq,testFreq(ff,1),'Direction','Above');
        ZapRestrict2=thresholdIntervals(RespiFreq,testFreq(ff,2),'Direction','Below');
        ZapRestrict=and(ZapRestrict1,ZapRestrict2);
        Rg=Range(Restrict(RespiFreq,ZapRestrict));
        
        figure('Color',[1 1 1]);
        for i=1:length(numNeurons)
            subplot(ceil(sqrt(length(numNeurons))),ceil(sqrt(length(numNeurons))),i)
            [C, B] = CrossCorr(Rg,Range(S{numNeurons(i)}),1,2000);
            hold on, plot(B,C); title(['Neuron ',num2str(numNeurons(i))]);
            hold on, plot(B,SmoothDec(C,20),'r','Linewidth',2)
        end
        subplot(ceil(sqrt(length(numNeurons))),ceil(sqrt(length(numNeurons))),ceil(sqrt(length(numNeurons))/2))
        yl=ylim; text(0,2*yl(2),{['RespiFreq ',num2str(testFreq(ff,1)),'-',num2str(testFreq(ff,2)),'Hz'],pwd})
        
        % choose neurons for RasterPETH
        disp('Identify neurons to do analyse on')
        SelecNeurons=input('Enter list of neuron for RasterPETH analysis (0 if all): ');
        if SelecNeurons==0, SelecNeurons=numNeurons;end
        
        [m,s,tps]=mETAverage(Rg,Range(Acc),Data(Acc),10,1000);
        pause(1)
        for i=1:length(SelecNeurons)
            figure('Color',[1 1 1]);
            [fh,sq,sweeps, rasterAx, histAx,dArea] =RasterPETH(S{SelecNeurons(i)}, ts(Rg(1:10:end)),fact(1),fact(2),'BinSize',fact(3));
            title(['Neuron ',num2str(SelecNeurons(i))]);tempx=xlim;tempy=ylim;
            ind=find(tps<tempx(2) & tps>tempx(1));
            hold on, plot(tps(ind),rescale(m(ind),tempy(1),tempy(2)),'r','linewidth',2)
        end
        
    end
    
    if AnalyComodulo
        
        a=1;
        I=subset(ZapRestrict,1);
        while sum(Stop(I,'s')-Start(I,'s'))<100
            a=a+1;
            I=subset(ZapRestrict,1:a);
        end
        
        
        for tt=unique(numtt)
            cc=tetrodeChannels{tt}(1);
            
            clear tempt
            disp(['Loading LFP',num2str(cc),'.mat'])
            eval(['tempt=load(''LFPData/LFP',num2str(cc),'.mat'',''LFP'');']);
            
            [VFreq0,VFreq1,Comodulo]=comodulo(Restrict(difAcc,I),Restrict(tempt.LFP,I),[1,15],2);
            title({['Comodulo difAcc-LFP',num2str(cc),' (',num2str(floor(sum(Stop(I,'s')-Start(I,'s')))),'s)'],pwd})
            
            [VFreq2,VFreq3,Comodulo2]=comodulo(Restrict(tempt.LFP,I),Restrict(tempt.LFP,I),[1,15],2);
            title({['Comodulo LFP',num2str(cc),'-LFP',num2str(cc),' (',num2str(floor(sum(Stop(I,'s')-Start(I,'s')))),'s)'],pwd})
        end
    end
end


%% VISUALIZE Spike modulation by respi

filA=FilterLFP(Acc,[1 7],2048);
[ph,mu,Kappa, pval,B,C,nmbBin,Cc,dB,vm]=ModulationThetaCorrection(S{numNeurons(1)},filA,SleepEp,100);
%[ph,mu, Kappa, pval,B,C]=ModulationTheta(S{numNeurons(1)},filA,SleepEp,100,1);

fil=FilterLFP(LFP,[1 7],2048);
[ph,mu, Kappa, pval,B,C]=ModulationTheta(S{numNeurons(1)},fil,SleepEp,100,1);

% verification
zr = hilbert(Data(filA));
phzr = atan2(imag(zr), real(zr));
phzr(phzr < 0) = phzr(phzr < 0) + 2 * pi;
figure, hist(phzr,30)


ModulationThetaCorrection;



%% Compare With LFP Bulb modulation of PFCx spikes

chans=InfoLFP.channel(strcmp(InfoLFP.structure,'Bulb'));
eval(['tempB=load(''LFPData/LFP',num2str(chans(1)),'.mat'');'])
filB=FilterLFP(tempB.LFP,[2 4],2048);
load StateEpochSB SWSEpoch

a=1;
I=subset(SWSEpoch,1);
while sum(Stop(I,'s')-Start(I,'s'))<100
    a=a+1;
    I=subset(SWSEpoch,1:a);
end

[ph,mu,Kappa, pval,B,C,nmbBin,Cc,dB,vm]=ModulationThetaCorrection(S{numNeurons(1)},filB,I,30);      
        
[Epoch,val,val2]=FindSlowOscBulb(Sp,t,f,SWSEpoch,1);

I9=Epoch{9};
numNeurons=[34 37 46 47 65 71];
for nn=1:length(numNeurons);
    [C,B]=CrossCorr(Range(Restrict(S{numNeurons(nn)},I9)),Range(Restrict(S{numNeurons(nn)},I9)),30,100);
    C(B==0)=0;
    figure('Color',[1 1 1]),
    plot(B,C,'k'); title(['Neuron ',num2str(numNeurons(nn))]);
    [C,B]=CrossCorr(Range(Restrict(S{numNeurons(nn)},I9)),Range(Restrict(S{numNeurons(nn)},I9)),10,500);
    C(B==0)=0;
    hold on, plot(B/1E3,SmoothDec(C,4));
    Ctsd=tsd(B*1E4,C);fi=FilterLFP(Ctsd,[1 3]);
    plot(B,Data(fi)+mean(C),'r','linewidth',2);title('Smoothed');
    xlim([-1.6,1.6]); legend({'step30','smoothed','Filter'})
    
end

%% comodulo cross structures
eval(['tempP=load(''LFPData/LFP',num2str(min(InfoLFP.channel(strcmp(InfoLFP.structure,'PFCx')))),'.mat'');'])
[VFreq0,VFreq1,Comodulo]=comodulo(Restrict(tempP.LFP,I),Restrict(tempB.LFP,I9),[1,15],2);


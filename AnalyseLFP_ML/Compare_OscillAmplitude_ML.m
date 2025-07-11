function Compare_OscillAmplitude_ML(NameDir,nameStructure,depthstructure,plo)

% Compare_OscillAmplitude_ML(NameDir,nameStructure,depthstructure,plo)
% Compare_OscillAmplitude_ML('BASAL','Bulb','deep',1);


%% INITIALIZATION

nameEpoch={'SWSEpoch','REMEpoch','MovEpoch'};
pasDelta=100;
FreqRien=[15 20];
FreqDelta=[1 4];
removeNoisyEpochs=1;

% strains and mice name
Dir=PathForExperimentsML(NameDir);
Ugroup=Unique(Dir.group);
scrsz = get(0,'ScreenSize');
res=pwd;


%% CHECK INPUTS

if ~exist('NameDir','var') || ~exist('nameStructure','var')
    error('Not enough input arguments')
end
if ~exist('depthstructure','var')
    depthstructure='deep';
end

if ~exist('plo','var')
    plo=0;
end


%% FOLDER TO SAVE EXPE AND RELOAD
% choose place to save
disp('Choose directory to save Analysis')
folder_tosaveExpe = uigetdir(res,'Choose directory to save Expe');
if folder_tosaveExpe==0, error('Aborted');end
file_tosaveExpe=[folder_tosaveExpe,'/CompareOscillationAmplitude_',nameStructure,'_',depthstructure];

try 
    tempMatData=load(file_tosaveExpe,'MatrixData','ALLepoch');   
    MatrixData=tempMatData.MatrixData; ALLepoch=tempMatData.ALLepoch;  
catch
    MatrixData=tsdArray;
end
WTconcatTsd=tsd([],[]);

%% SAVE HILBERT OF DELTA BAND

for man=1:length(Dir.path)
    Mangroup{man}=Dir.group{man};
    % ---------------------------------------------------------------------
    % ---------------- Name expe / mouse ----------------------------------
    nameMan=Dir.path{man}(strfind(Dir.path{man},'BULB'):strfind(Dir.path{man},'BULB')+21);
    disp(' '); disp(['* * * ',nameMan,' * * *'])
   
    % ---------------------------------------------------------------------
    % --------------- load InfoLFP channel to analyze ---------------------
    
    load([Dir.path{man},'/LFPData/InfoLFP.mat'],'InfoLFP')
    clear num_channel
    if strcmp(nameStructure,'Bulb')
        try
            load([Dir.path{man},'/SpectrumDataL/UniqueChannelBulb'],'channelToAnalyse');
            num_channel=channelToAnalyse;
            disp(['Analyzing channel ',num2str(num_channel),' (found in SpectrumDataL/UniqueChannelBulb.mat)'])
        end
    end
    
    if ~exist('num_channel','var')
        try
            load([Dir.path{man},'/ChannelsToAnalyse/',nameStructure,'_',depthstructure],'channel');
            num_channel=channel;
            disp(['Analyzing channel ',num2str(num_channel),' (found in ChannelsToAnalyse/',nameStructure,'_',depthstructure,'.mat)'])
        catch
            disp(['No ',nameStructure,'_',depthstructure,' found in ChannelsToAnalyse'])
        end
    end
    
    
    % ---------------------------------------------------------------------
    % ----------------------- Compute -----------------------------
    
    if exist('num_channel','var') && ~isempty(num_channel)
        
        % clear all
        clear temp LFPcorrec FilRien FilDelta DeltaRatioTSD
        
        try
            DeltaRatioTSD=MatrixData{man};
            Range(DeltaRatioTSD);
            disp(['... Reloading from CompareOscillationAmplitude_',nameStructure,'_',depthstructure,'.mat'])
            
        catch
            
            disp(['... Loading LFP',num2str(num_channel)])
            temp=load([Dir.path{man},'/LFPData/LFP',num2str(num_channel),'.mat'],'LFP');
            LFPcorrec=tsd(Range(temp.LFP),Dir.CorrecAmpli(man)*Data(temp.LFP));
            if Dir.CorrecAmpli(man)~=1, disp('    ->  Correcting for amplification !');end
            
            disp(['... Filtering in Rien band (',num2str(FreqRien(1)),'-',num2str(FreqRien(2)),'Hz) + Hilbert transform'])
            FilRien=FilterLFP(LFPcorrec,FreqRien,1024);
            HilRien=hilbert(Data(FilRien));
            
            disp(['... Filtering in Delta band (',num2str(FreqDelta(1)),'-',num2str(FreqDelta(2)),'Hz) + Hilbert transform'])
            FilDelta=FilterLFP(LFPcorrec,FreqDelta,1024);
            HilDelta=hilbert(Data(FilDelta));
            
            H=abs(HilRien);
            H(H<100)=100;
            
            DeltaRatio=abs(HilDelta)./H;
            rgDeltaRatio=Range(FilDelta,'s');
            
            DeltaRatio=SmoothDec(DeltaRatio(1:pasDelta:end),50);
            rgDeltaRatio=rgDeltaRatio(1:pasDelta:end);
            DeltaRatioTSD=tsd(rgDeltaRatio*1E4,DeltaRatio);
         
            % save and store
            MatrixData{man}=DeltaRatioTSD;
            try save(file_tosaveExpe,'-append','MatrixData'); catch, save(file_tosaveExpe,'MatrixData','NameDir','FreqRien','FreqDelta');end
        end
        
        if strcmp(Mangroup{man},'WT')
            WTconcatTsd=tsd([Range(WTconcatTsd);max([0;Range(WTconcatTsd)])+Range(DeltaRatioTSD)],[Data(WTconcatTsd);Data(DeltaRatioTSD)]);
        end
        
        % ---------------------------------------------------------------------
        % ---------------- load epoch -----------------------------------
        try
            epoch=ALLepoch{man,1};
        catch
            load([Dir.path{man},'/StateEpoch.mat'],'NoiseEpoch','GndNoiseEpoch','WeirdNoiseEpoch')
            for nn=1:length(nameEpoch)
                load([Dir.path{man},'/StateEpoch.mat'],nameEpoch{nn})
                if removeNoisyEpochs
                    eval(['epoch=',nameEpoch{nn},'-NoiseEpoch-GndNoiseEpoch-WeirdNoiseEpoch;'])
                else
                    disp('problem NoiseEpochs')
                    eval(['epoch=',nameEpoch{nn},';'])
                end
                ALLepoch{man,nn}=epoch;
            end
        end
        
        % display spectrum and amplitude in chosen band
        if plo
            disp('... Loading spectrum and display')
            disp(['from ',Dir.path{man},'/SpectrumDataL/Spectrum',num2str(num_channel),'.mat']);
            
            temp=load([Dir.path{man},'/SpectrumDataL/Spectrum',num2str(num_channel),'.mat'],'Sp','t','f');
            
            figure('color',[1 1 1],'Position',[2 scrsz(4) scrsz(3) scrsz(4)/2]),
            subplot(5,1,1:2),imagesc(temp.t,temp.f,10*log10(temp.Sp)'), axis xy, caxis([20 65]);
            title([nameMan,'Spectrogramm']); xl=xlim;
            
            indexf=find(temp.f>FreqRien(1) & temp.f<FreqRien(2));
            subplot(5,1,3),imagesc(temp.t,temp.f(indexf),10*log10(temp.Sp(:,indexf))'), axis xy, caxis([20 65]);
            title('Spectrogram in Rien band'); xlim(xl);
            
            indexf=find(temp.f>FreqDelta(1) & temp.f<FreqDelta(2));
            subplot(5,1,4),imagesc(temp.t,temp.f(indexf),10*log10(temp.Sp(:,indexf))'), axis xy, caxis([20 65]);
            title('Spectrogram in Delta band'); xlim(xl);
            
            subplot(5,1,5), plot(Range(DeltaRatioTSD,'s'),Data(DeltaRatioTSD))
            title('Amplitude ratio Delta/Rien'); xlim(xl);
            
            disp('Enter to go on next expe...')
            pause
        end
        
    else
        disp(['Problem for ',nameStructure,'_',depthstructure,' in ',Dir.path{man}])
    end
    
end
save(file_tosaveExpe,'-append','WTconcatTsd','Mangroup','ALLepoch')


%% FIND PERCENTILE FROM WT FILL MAT FOR EACH EXPE
disp('  ');
try
    load(file_tosaveExpe,'ValuePercentile','MatPercEpoch')
    MatPercEpoch(1,1);
    disp('... Reloading MatPercEpoch')
catch
    disp('... calculating MatPercEpoch')
    ValuePercentile=[0.90,0.75,0.25,0.10];
    for i=1:length(ValuePercentile)
        Perc(i)=percentile(Data(WTconcatTsd),ValuePercentile(i));
    end
    
    MatPercEpoch=[];
    for man=1:length(Dir.path)
        clear DeltaRatioTSD epoch
        numMouse=str2num(Dir.name{man}(6:end));
        numGroup=find(strcmp(Ugroup,Dir.group{man}));
        
        try
            DeltaRatioTSD=MatrixData{man};
            RecLength=max(Range(DeltaRatioTSD,'s'));
            
            for nn=1:length(nameEpoch)
                epoch=ALLepoch{man,nn};
                epochTSD=Restrict(DeltaRatioTSD,epoch);
                
                Mattemp=[numMouse,numGroup,nn,NaN(1,length(ValuePercentile))];
                for i=1:length(ValuePercentile)
                    tempEp=thresholdIntervals(epochTSD,Perc(i),'Direction','Above');
                    tempEp=mergeCloseIntervals(tempEp,1E4);
                    tempEp=dropShortIntervals(tempEp,1E4);
                    
                    Mattemp(i+3)=100*sum(Stop(tempEp,'s')-Start(tempEp,'s'))/RecLength;
                end
                MatPercEpoch=[MatPercEpoch;Mattemp];
            end
        end
    end
    save(file_tosaveExpe,'-append','ValuePercentile','MatPercEpoch')
end

%% BAR PLOT
Umice1=unique(MatPercEpoch(MatPercEpoch(:,2)==1,1));
Umice2=unique(MatPercEpoch(MatPercEpoch(:,2)==2,1));

for nn=1:length(nameEpoch)
    MatPerc1=NaN(length(Umice1),length(MatPercEpoch));
    MatPerc2=NaN(length(Umice2),length(MatPercEpoch));
    for mi=1:length(Umice1)
        MatPerc1(mi,:)=nanmean(MatPercEpoch(MatPercEpoch(:,1)==Umice1(mi) & MatPercEpoch(:,3)==nn,:),1);
    end
    for mi=1:length(Umice2)
        MatPerc2(mi,:)=nanmean(MatPercEpoch(MatPercEpoch(:,1)==Umice2(mi) & MatPercEpoch(:,3)==nn,:),1);
    end
end

for nn=1:length(nameEpoch)
    MatBar1=MatPerc(:,nn,:);
    dKO
    PlotErrorBar2
end


%% DISPLAY

figure('color',[1 1 1],'Position',[2 scrsz(4) scrsz(3)/2 scrsz(4)/2]), numF=gcf;
figure('color',[1 1 1],'Position',[2 scrsz(4) scrsz(3) scrsz(4)/2]), numG=gcf;

leg=[];a=0;
for man=1:length(Dir.path)
    clear DeltaRatioTSD epoch
    DeltaRatioTSD=MatrixData{man};
    
    figure(numF)
    try
        hold on, plot(Range(DeltaRatioTSD,'s'),Data(DeltaRatioTSD)-10*a,'Color',[0.5 man/length(Dir.path) 0.5])
        leg=[leg,{[Dir.name{man},' - ',Dir.group{man}]}]; a=a+1;
        
        % ---------------- for epochs -----------------------------------
        freqRatioTSD=1/mean(diff(Range(DeltaRatioTSD,'s')));
        figure(numG), 
        for nn=1:length(nameEpoch)
            epoch=ALLepoch{man,nn};
            epochTSD=Restrict(DeltaRatioTSD,epoch);
            tepochTSD=[1:length(Data(epochTSD))]/freqRatioTSD;
            subplot(ceil(length(nameEpoch)/3),3,nn), hold on,
            plot(tepochTSD,Data(Restrict(DeltaRatioTSD,epoch))-10*a,'Color',[0.5 man/length(Dir.path) 0.5])
            xlabel('Time (s)'); ylabel([nameEpoch{nn},'Amplitude']); ylim([-10*a,20]); xlim([0 10000]);
            title(nameEpoch{nn})
        end
    end
end


figure(numF),
title(['Ratio Delta/Rien for all expe.  function: Compare-OscillAmplitude-ML(',NameDir,',',nameStructure,',',depthstructure,',',num2str(plo),')'])
xlabel('Time (s)'); ylabel('Amplitude'); ylim([-10*a,20]);
legend(leg)

figure(numG), subplot(ceil(length(nameEpoch)/3),3,2),
legend(leg)

keyboard

saveFigure(numF,['Figure_OscillAmplitude_',nameStructure,'_',depthstructure],folder_tosaveExpe)
saveFigure(numG,['Figure_OscillAmplitude_',nameStructure,'_',depthstructure,'_Epochs'],folder_tosaveExpe)



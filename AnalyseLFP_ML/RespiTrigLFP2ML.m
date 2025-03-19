% script RespiTrigLFP2ML(NameDir,NameStructure,NbBin_ETaverage,plotPETH,Freq)

%% define inputs

NameDir='PLETHYSMO';
NameStructure='Bulb';
NameChanInterest='Bulb_deep';
NbBin_ETaverage=100;
plotPETH=0;

Freq=[1 15; 30 40; 60 90];
disp('Using default frequencies: [1-15; 30-40; 60-90]')

NameEpoch={'SWSEpoch','MovEpoch','REMEpoch'};
fBasal=[1.5 4.5];
fSniff=[5 10];

%% initialisation variables
% load paths of experiments
Dir=PathForExperimentsML(NameDir);
strains=unique(Dir.group);
MiceNames=unique(Dir.name);

% initiate display
colori={[0.5 0.5 0.5],'k','r','m','b','c','g','y','r','m','b','c','g','y','r','m','b','c','g','y'};
scrsz = get(0,'ScreenSize');

% name of file to save
res='/media/DataMOBsRAID/ProjetAstro-DataPlethysmo/AnalyseInspirationTrigLFP2/';
FileName_save=['InspirationTrigLFP',NameStructure,'andRespi'];
folderTosave=[res,'/',NameStructure];
if ~exist(folderTosave,'dir')
    mkdir(folderTosave)
end

%% compute Respi trig lfp

try
    load([folderTosave,'/',FileName_save,'.mat'])
    MatrixLFPbasal;  MatrixRespibasal; lengthEpoch; MatrixDataInfo;
    
    disp(' '); disp(['Using data from ',FileName_save,'.mat ...'])
catch
    % ------------------------------------------
    % initiate Matrix
    MatrixLFPbasal=nan(length(Dir.path),NbBin_ETaverage+1,length(NameEpoch),size(Freq,1),20);
    MatrixLFPsniff=MatrixLFPbasal;
    MatrixRespibasal=nan(length(Dir.path),NbBin_ETaverage+1,length(NameEpoch));
    MatrixRespisniff=MatrixRespibasal;
    
    lengthEpoch=nan(length(Dir.path),3,length(NameEpoch));
    MatrixDataInfo=nan(length(Dir.path),4);
    
    for man=1:length(Dir.path)
        disp(' ')
        disp([Dir.group{man},'-',Dir.name{man}(6:end)])
        % ---------------------------------------------------------------------
        % load respi info
        clear  TidalVolume Frequency RespiTSD 
        load([Dir.path{man},'/LFPData.mat'],'TidalVolume','Frequency','NormRespiTSD')
        RespiTSD=NormRespiTSD;
        
        % -----------------------------------------------------------------
        % channels all Bulb
        clear channelToAnalyse InfoLFP channel
        load([Dir.path{man},'/LFPData/InfoLFP.mat'],'InfoLFP')
        channelToAnalyse=InfoLFP.channel(strcmp(InfoLFP.structure,NameStructure));
            
        if ~isempty(channelToAnalyse)
            
            % -----------------------------------------------------------------
            % ChannelsToAnalyse Bulb_deep
            channel=[];ch=nan;
            try
                eval(['load([''',Dir.path{man},'/ChannelsToAnalyse/',NameChanInterest,'.mat'']);']); 
                ch=find(channelToAnalyse==channel);
            end
            
            % -----------------------------------------------------------------
            % load epoch
            clear MovEpoch REMEpoch SWSEpoch NoiseEpoch GndNoiseEpoch WeirdEpoch TimeEndRec tp
            load([Dir.path{man},'/StateEpoch.mat'],'REMEpoch','SWSEpoch','MovEpoch','NoiseEpoch','GndNoiseEpoch','WeirdNoiseEpoch')
            
            % -----------------------------------------------------------------
            % load TimeEndRec
            load([Dir.path{man},'/behavResources.mat'],'TimeEndRec');
            if ~exist('TimeEndRec','var') 
                disp('Getting TimeEndRec from TimeRec.mat and saving in behavResources.mat')
                load([Dir.path{man},'/TimeRec.mat'],'TimeEndRec');
                if exist('TimeEndRec','var') 
                    save([Dir.path{man},'/behavResources.mat'],'-append','TimeEndRec');
                else
                    disp('Keyboard, run GetTimeOfDataRecording.m');keyboard;
                end
            end
            MatrixDataInfo(man,1:4)=[find(strcmp(Dir.group{man},strains)),str2num(Dir.name{man}(6:end)),TimeEndRec(1,:)*[3600 60 1]',ch];
            
            
            % -----------------------------------------------------------------
            % Respiration frequency
            
            clear epochFreq_temp1 epochFreq_temp2 epochFreqBasal
            epochFreq_temp1=thresholdIntervals(Frequency,fBasal(1),'Direction','Above');
            epochFreq_temp2=thresholdIntervals(Frequency,fBasal(2),'Direction','Below');
            epochFreqBasal=and(epochFreq_temp1,epochFreq_temp2);
            
            clear epochFreq_temp1 epochFreq_temp2 epochFreqSniff
            epochFreq_temp1=thresholdIntervals(Frequency,fSniff(1),'Direction','Above');
            epochFreq_temp2=thresholdIntervals(Frequency,fSniff(2),'Direction','Below');
            epochFreqSniff=and(epochFreq_temp1,epochFreq_temp2);
            
            for cc=1:length(channelToAnalyse)
                % -----------------------------------------------------------------
                % load LFP
                clear LFP
                eval(['load([''',Dir.path{man},'/LFPData/LFP',num2str(channelToAnalyse(cc)),'.mat''],''LFP'');']); LFP;
                disp(['     channel',num2str(channelToAnalyse(cc)),' (',NameStructure,')'])
                
                
                for ep=1:length(NameEpoch)
                    disp(NameEpoch{ep}) 
                    % -----------------------------------------------------------------
                    % construct epochs
                    clear epoch epBasal epSniff
                    eval(['epoch=',NameEpoch{ep},'-NoiseEpoch-GndNoiseEpoch-WeirdNoiseEpoch;'])
                    epBasal=mergeCloseIntervals(and(epoch,epochFreqBasal),3*1E4);
                    epSniff=mergeCloseIntervals(and(epoch,epochFreqSniff),3*1E4);
                    
                    % -----------------------------------------------------------------
                    % Get Respi MetAverage
                    if cc==1
                        clear m0 m1 m2
                        lengthEpoch(man,1,ep)=ceil(sum(Stop(epBasal,'s')-Start(epBasal,'s')));
                        lengthEpoch(man,2,ep)=ceil(sum(Stop(epSniff,'s')-Start(epSniff,'s')));
                        lengthEpoch(man,3,ep)=ceil(sum(Stop(epoch,'s')-Start(epoch,'s')));
                        
                        %m0=mETAverage(tp,Range(RespiTSD),Data(RespiTSD),10,NbBin_ETaverage);
                        tpB=Range(Restrict(TidalVolume,epBasal));
                        tpS=Range(Restrict(TidalVolume,epSniff));
                        [m1,t1,e1]=mETAverage(tpB,Range(Restrict(RespiTSD,epBasal)),Data(Restrict(RespiTSD,epBasal)),10,NbBin_ETaverage);
                        m2=mETAverage(tpS,Range(Restrict(RespiTSD,epSniff)),Data(Restrict(RespiTSD,epSniff)),10,NbBin_ETaverage);
                        
                        MatrixRespibasal(man,:,ep)=m1';
                        MatrixRespisniff(man,:,ep)=m2';
                        %MatrixRespi(man,:,ep,3)=m0';
                    end
                    
                    for fr=1:size(Freq,1)
                        % -----------------------------------------------------------------
                        % filterLFP
                        %disp(['      - filter ',num2str(Freq(fr,1)),'-',num2str(Freq(fr,2)),'Hz'])
                        filLFP=FilterLFP(LFP,Freq(fr,:),1056);
                        
                        % -----------------------------------------------------------------
                        % mETAverage
                        clear m1 m2
                        %m0=mETAverage(tp,Range(filLFP),Data(filLFP),10,NbBin_ETaverage);
                        if fr==1
                            m1=mETAverage(tpB,Range(Restrict(filLFP,epBasal)),Data(Restrict(filLFP,epBasal)),10,NbBin_ETaverage);
                            m2=mETAverage(tpS,Range(Restrict(filLFP,epSniff)),Data(Restrict(filLFP,epSniff)),10,NbBin_ETaverage);
                        else
                            HilL=hilbert(Data(filLFP));
                            H=abs(HilL);
                            %H(H<100)=100;
                            Hiltsd=tsd(Range(filLFP),H);
                            m1=mETAverage(tpB,Range(Restrict(Hiltsd,epBasal)),Data(Restrict(Hiltsd,epBasal)),10,NbBin_ETaverage);
                            m2=mETAverage(tpS,Range(Restrict(Hiltsd,epSniff)),Data(Restrict(Hiltsd,epSniff)),10,NbBin_ETaverage);
                        end
                        % -----------------------------------------------------------------
                        % Save matrix
                        MatrixLFPbasal(man,:,ep,fr,cc)=m1';
                        MatrixLFPsniff(man,:,ep,fr,cc)=m2';
                    end
                    figure,hold on, for fr=1:size(Freq,1), plot(e1,MatrixLFPbasal(man,:,ep,fr,cc),'k');plot(e1,MatrixLFPsniff(man,:,ep,fr,cc),'b');end
                    close
                end
            end
            
        else
            disp([': no Channel',NameStructure])
            %keyboard
        end
        
        
    end
    save([folderTosave,'/',FileName_save],'MatrixLFPbasal','MatrixLFPsniff','MatrixRespibasal','MatrixRespisniff','e1')
    save([folderTosave,'/',FileName_save],'MatrixDataInfo','lengthEpoch','-append')

end


%% display individual Data
ampBO=nan(length(Dir.path),length(NameEpoch)+1,size(Freq,1),20);
phaBO=ampBO;
for man=1:length(Dir.path)
    if ~isnan(MatrixDataInfo(man,1))
    figure('Color',[1 1 1],'Position',[2 scrsz(4)/2 scrsz(3)/3 2*scrsz(4)/3]), numF(man)=gcf;
    %try
        mResB=squeeze(MatrixRespibasal(man,:,:));%Restrict(RespiTSD,epBasal)
        mResS=squeeze(MatrixRespisniff(man,:,:));%Restrict(RespiTSD,epSniff)
        for ep=1:length(NameEpoch)
            RB=mResB(:,ep)';
            ampResp(man,ep)=max(RB)-min(RB);
            
            for fr=1:size(Freq,1)
                mLfpB=squeeze(MatrixLFPbasal(man,:,ep,fr,:));%Restrict(filLFP,epBasal)
                
                subplot(size(Freq,1),length(NameEpoch)+1,(length(NameEpoch)+1)*(fr-1)+ep)
                
                for cc=1:sum(~isnan(mLfpB(1,:)))
                    hold on, plot(e1/1E3,(10^(fr-1))*mLfpB(:,cc)',colori{2+cc})
                    ampBO(man,ep,fr,cc)=max(mLfpB(:,cc))-min(mLfpB(:,cc));
                    try phaBO(man,ep,fr,cc)=e1(find(mLfpB(:,cc)==max(mLfpB(:,cc))))-e1(find(RB==max(RB)));end
                end
                
                plot(e1/1E3,RB,'Color',colori{1},'Linewidth',2)
                hold on, plot(e1/1E3,(10^(fr-1))*mLfpB(:,MatrixDataInfo(man,4))',colori{2},'Linewidth',2)
                
                if fr==1, title([NameEpoch{ep},' (',num2str(floor(lengthEpoch(man,1,ep))),'s)']);end
                if ep==1, ylabel(['Filter ',num2str(Freq(fr,1)),'-',num2str(Freq(fr,2)),'Hz']);end
                if fr==size(Freq,1) && ep==2, xlabel('Time (s)');end
                ylim([-1 1]*5/1E4)
            end
        end
        
        
       RS=mResS(:,2)';
       ampResp(man,length(NameEpoch)+1)=max(RS)-min(RS);
        for fr=1:size(Freq,1)
            mLfpS=squeeze(MatrixLFPsniff(man,:,2,fr,:));%Restrict(filLFP,epSniff)
            
            subplot(size(Freq,1),length(NameEpoch)+1,(length(NameEpoch)+1)*fr)
            plot(e1/1E3,RS,'Color',colori{1},'Linewidth',2)
                for cc=1:sum(~isnan(mLfpS(1,:)))
                    if cc==MatrixDataInfo(man,4)
                        hold on, plot(e1/1E3,(10^(fr-1))*mLfpS(:,cc)',colori{2},'Linewidth',2)
                    else
                        hold on, plot(e1/1E3,(10^(fr-1))*mLfpB(:,cc)',colori{2+cc})
                    end
                    ampBO(man,length(NameEpoch)+1,fr,cc)=max(mLfpS(:,cc))-min(mLfpS(:,cc));
                    phaBO(man,length(NameEpoch)+1,fr,cc)=e1(find(mLfpS(:,cc)==max(mLfpS(:,cc))))-e1(find(RS==max(RS)));
                end
            if fr==1, title(['MovEpoch-Sniff (',num2str(floor(lengthEpoch(man,2,2))),'s)']);end
            ylim([-1 1]*5/1E4)
        end
        subplot(size(Freq,1),length(NameEpoch)+1,2)
        text(0,8/1E4,[strains{MatrixDataInfo(man,1)},'-M',num2str(MatrixDataInfo(man,2)),', rec at ',num2str(floor(MatrixDataInfo(man,3)/3600)),'h'])
        
    end
end

%% plot ampResp ampBO phaBO in function of ZT
newNameEpoch=[NameEpoch,'MovEpoch-Sniff'];
figure('Color',[1 1 1],'Position',[2 scrsz(4)/2 scrsz(3)/3 scrsz(4)/4]), numResp=gcf;
figure('Color',[1 1 1],'Position',[2 scrsz(4)/2 scrsz(3)/3 2*scrsz(4)/3]), numampBO=gcf;
figure('Color',[1 1 1],'Position',[2 scrsz(4)/2 scrsz(3)/3 2*scrsz(4)/3]), numphaBO=gcf;
colorst={'k','r'};
for ep=1:length(newNameEpoch)
    
    for man=1:length(Dir.path)
        TRec=MatrixDataInfo(man,3)/3600;
        
        if ~isnan(TRec)
        % plot ampRespi
        figure(numResp), subplot(1,length(newNameEpoch),ep)
        hold on, plot(TRec,ampResp(man,ep),'o','Color',colorst{MatrixDataInfo(man,1)},'MarkerFaceColor',colorst{MatrixDataInfo(man,1)})
        if ep<=length(NameEpoch), title([newNameEpoch{ep},' (',num2str(floor(lengthEpoch(man,1,ep))),'s)']);
         else, title([newNameEpoch{ep},' (',num2str(floor(lengthEpoch(man,2,2))),'s)']); end
        if ep==1, ylabel('Amp Respi');end
        
        % plot ampBO
        figure(numampBO), 
        for fr=1:size(Freq,1)
            subplot(size(Freq,1),length(newNameEpoch),(length(newNameEpoch))*(fr-1)+ep)
            for cc=1:20
                hold on, plot(TRec,ampBO(man,ep,fr,cc),'o','Color',colorst{MatrixDataInfo(man,1)},'MarkerFaceColor',colorst{MatrixDataInfo(man,1)})
            end
            
            if fr==1, 
                if ep<=length(NameEpoch), title([newNameEpoch{ep},' (',num2str(floor(lengthEpoch(man,1,ep))),'s)']);
                else, title([newNameEpoch{ep},' (',num2str(floor(lengthEpoch(man,2,2))),'s)']); end
            end
            if ep==1, ylabel(['Amp BO',num2str(Freq(fr,1)),'-',num2str(Freq(fr,2)),'Hz']);end
            if fr==size(Freq,1) && ep==2, xlabel('Time (s)');end
            ylim([0 1/1E3])
        end
        
        % plot phaBO
        figure(numphaBO), 
        for fr=1:size(Freq,1)
            subplot(size(Freq,1),length(newNameEpoch),(length(newNameEpoch))*(fr-1)+ep)
            for cc=1:20
                hold on, plot(TRec,phaBO(man,ep,fr,cc),'o','Color',colorst{MatrixDataInfo(man,1)},'MarkerFaceColor',colorst{MatrixDataInfo(man,1)})
            end
            if fr==1, 
                if ep<=length(NameEpoch), title([newNameEpoch{ep},' (',num2str(floor(lengthEpoch(man,1,ep))),'s)']);
                else, title([newNameEpoch{ep},' (',num2str(floor(lengthEpoch(man,2,2))),'s)']);end
            end
            if ep==1, ylabel(['Ph BO-respi ',num2str(Freq(fr,1)),'-',num2str(Freq(fr,2)),'Hz']);end
            if fr==size(Freq,1) && ep==2, xlabel('Time (s)');end
            ylim([-800 800])
        end
        end
    end
end









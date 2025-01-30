function [numFig,MatrixLFP,MatrixLFP_inf,MatrixLFP_sup,MatrixRespi,MatrixRespi_inf,MatrixRespi_sup,MatrixDataInfo,lengthEpoch]=RespiTrigLFPML(NameDir,NameStructure,NameEpoch,NbBin_ETaverage,plotPETH,Freq)

% function RespiTrigLFPML(NameDir,NameStructure,NameEpoch,NbBin_ETaverage,plotPETH,Freq)
%
% inputs:
% - NameDir = (see PathForExperimentsML.m)
% - NameStructure = see InfoLFP.mat, e.g. 'Bulb_deep'
% - NameEpoch = see sleepscoringML.m  (SWSEpoch, REMEpoch, MovEpoch, ImmobEpoch)
% - NbBin_ETaverage= number of bins (argument for mETAverage.m, default=100)
% - plotPETH = 1 if display for every single experiment, or 0 
% - Freq = default [1.5 5; 6 10];
% 
% outputs:
% - numFig = number of figure
% - [MatrixLFP MatrixLFP_inf MatrixLFP_sup]= for all experiment in Dir,
%       mean of LFP trigged on Inspiration for all Freq_inf and Freq_sup
% - [MatrixRespi MatrixRespi_inf MatrixRespi_sup]= for all experiment in Dir,
%       mean of Respi trigged on Inspiration for all Freq_inf and Freq_sup
% - MatrixDataInfo = for all experiment in Dir, mouse name and strain.
% - lengthEpoch
%
% !!! Papier Lisa !!!
% numF=RespiTrigLFPML('PLETHYSMO',500);



%% Verifications of inputs

if ~exist('NameDir','var') || ~exist('NameStructure','var') || ~exist('NameEpoch','var')
    error('Not enough input arguments')
end

if ~exist('NbBin_ETaverage','var')
    NbBin_ETaverage=100;
end

if ~exist('plotPETH','var')
    plotPETH=0;
end

if ~exist('Freq','var') || ~isequal(size(Freq),[2,2])
    FreqInf=[1.5 5];
    FreqSup=[6 10];
    disp(['Using default frequencies: ',num2str(FreqInf),'Hz and ',num2str(FreqSup),'Hz.'])
else
    FreqInf=Freq(1,:);
    FreqSup=Freq(2,:);
end

%% initialisation variables

% load paths of experiments
Dir=PathForExperimentsML(NameDir);
strains=unique(Dir.group);
MiceNames=unique(Dir.name);

% initiate display
colori={'b','r','k','g','c','m','b','r','k','g','c','m','b','r','k','g','c','m'};
typo={ '-','-','-','-','-','-','--','--','--','--','--','--','-.','-.','-.','-.','-.','-.'};
scrsz = get(0,'ScreenSize');

% name of file to save
res=pwd;
FileName_save=['AnalyseInspirationTrigLFP/',NameStructure,'/',NameEpoch,'/AnalyseInspirationTrigLFP',NameStructure,'andRespi',NameEpoch];
folderTosave=[res,'/AnalyseInspirationTrigLFP/',NameStructure,'/',NameEpoch];
if ~exist(folderTosave,'dir')
    mkdir(folderTosave)
end

%% compute Respi trig lfp

try
    load([FileName_save,'.mat'],'MatrixLFP','MatrixLFPinf','MatrixLFPsup')
    MatrixLFP; MatrixLFP_inf; MatrixLFP_sup;
    
    load([FileName_save,'.mat'],'MatrixRespi','MatrixRespiinf','MatrixRespisup')
    MatrixRespi; MatrixRespi_inf; MatrixRespi_sup;
    
    load([FileName_save,'.mat'],'MatrixDataInfo','lengthEpoch')
    lengthEpoch; MatrixDataInfo;
    
    disp(' '); disp(['Using data from ',FileName_save,'.mat ...'])
catch
    % ------------------------------------------
    % initiate Matrix
    MatrixLFP=nan(length(Dir.path),NbBin_ETaverage+1);
    MatrixLFP_inf=MatrixLFP;
    MatrixLFP_sup=MatrixLFP;
    
    MatrixRespi=MatrixLFP;
    MatrixRespi_inf=MatrixLFP;
    MatrixRespi_sup=MatrixLFP;
    lengthEpoch=nan(length(Dir.path),2);
    
    for man=1:length(Dir.path)
        
        % ---------------------------------------------------------------------
        % load respi info
        clear  TidalVolume Frequency RespiTSD indexInf indexSup channelToAnalyse LFP
        load([Dir.path{man},'/LFPData.mat'],'TidalVolume','Frequency','NormRespiTSD')
        RespiTSD=NormRespiTSD;
        try
            %load([Dir.path{man},'/SpectrumDataL/UniqueChannel',NameStructure],'channelToAnalyse')
            load([Dir.path{man},'/ChannelsToAnalyse/',NameStructure,'.mat']);channelToAnalyse=channel;
            load([Dir.path{man},'/LFPData/LFP',num2str(channelToAnalyse),'.mat'],'LFP'); LFP;
            disp([Dir.group{man},Dir.name{man}(strfind(Dir.name{man},'Mouse')+6:end),': analysing channel',num2str(channelToAnalyse),' (',NameStructure,')'])
            
            % -----------------------------------------------------------------
            % load epoch
            clear MovEpoch REMEpoch SWSEpoch NoiseEpoch GndNoiseEpoch WeirdEpoch epoch
            load([Dir.path{man},'/StateEpoch.mat'],'REMEpoch','SWSEpoch','MovEpoch','NoiseEpoch','GndNoiseEpoch','WeirdNoiseEpoch')
            eval(['epoch=',NameEpoch,'-NoiseEpoch-GndNoiseEpoch-WeirdNoiseEpoch;'])
            
            
            % -----------------------------------------------------------------
            % epoch frequency
            clear epochFreqInf_temp1 epochFreqInf_temp2 epochFreqInf
            epochFreqInf_temp1=thresholdIntervals(Frequency,FreqInf(1),'Direction','Above');
            epochFreqInf_temp2=thresholdIntervals(Frequency,FreqInf(2),'Direction','Below');
            epochFreqInf=and(and(epochFreqInf_temp1,epochFreqInf_temp2),epoch);
            epochFreqInf=mergeCloseIntervals(epochFreqInf,3*1E4);
            
            clear epochFreqSup_temp1 epochFreqSup_temp2 epochFreqSup
            epochFreqSup_temp1=thresholdIntervals(Frequency,FreqSup(1),'Direction','Above');
            epochFreqSup_temp2=thresholdIntervals(Frequency,FreqSup(2),'Direction','Below');
            epochFreqSup=and(and(epochFreqSup_temp1,epochFreqSup_temp2),epoch);
            epochFreqSup=mergeCloseIntervals(epochFreqSup,3*1E4);
            
            % -----------------------------------------------------------------
            % construct vectors of each parameters
            clear DataTV DataFrequency RangeFrequency
            
            DataTV=Data(Restrict(TidalVolume,epoch));
            DataFrequency=Data(Restrict(Frequency,epoch));
            RangeFrequency=Range(Restrict(Frequency,epoch));
            MatrixDataInfo(man,:)={Dir.group{man},Dir.name{man}(strfind(Dir.name{man},'Mouse')+6:end)};
            
            lengthEpoch(man,1)=ceil(sum(Stop(epoch,'s')-Start(epoch,'s')));
            lengthEpoch(man,2)=ceil(sum(Stop(epochFreqInf,'s')-Start(epochFreqInf,'s')));
            lengthEpoch(man,3)=ceil(sum(Stop(epochFreqSup,'s')-Start(epochFreqSup,'s')));
            % -----------------------------------------------------------------
            % mETAverage
            
            % all
            clear tp m1 e1 m2 e2
            tp=Range(Restrict(TidalVolume,epoch));
            [m1,t1,e1]=mETAverage(tp,Range(LFP),Data(LFP),10,NbBin_ETaverage);
            [m2,t2,e2]=mETAverage(tp,Range(RespiTSD),Data(RespiTSD),10,NbBin_ETaverage);
            
            
            % freq inf
            clear tp_inf m1_inf e1_inf m2_inf e2_inf
            tp_inf=Range(Restrict(TidalVolume,epochFreqInf));
            [m1_inf,t1_inf,e1_inf]=mETAverage(tp_inf,Range(LFP),Data(LFP),10,NbBin_ETaverage);
            [m2_inf,t2_inf,e2_inf]=mETAverage(tp_inf,Range(RespiTSD),Data(RespiTSD),10,NbBin_ETaverage);
            
           
            % freq sup
            clear tp_sup m1_sup e1_sup m2_sup e2_sup
            tp_sup=Range(Restrict(TidalVolume,epochFreqSup));
            [m1_sup,t1_sup,e1_sup]=mETAverage(tp_sup,Range(LFP),Data(LFP),10,NbBin_ETaverage);
            [m2_sup,t2_sup,e2_sup]=mETAverage(tp_sup,Range(RespiTSD),Data(RespiTSD),10,NbBin_ETaverage);
            
           
            % -----------------------------------------------------------------
            % Save matrix
            MatrixLFP(man,:)=m1';
            MatrixLFP_inf(man,:)=m1_inf';
            MatrixLFP_sup(man,:)=m1_sup';
            
            MatrixRespi(man,:)=m2;
            MatrixRespi_inf(man,:)=m2_inf';
            MatrixRespi_sup(man,:)=m2_sup';
            
            
            % -----------------------------------------------------------------
            if plotPETH
                % PETH LFP
                figure('Color',[1 1 1]), FigurePETHLFP=gcf;
                [fh, rasterAx, histAx, matVal] = ImagePETH(LFP,ts(tp(20:end-20)), -10000, +15000,'BinSize',1000);
                title([MatrixDataInfo{man,1},MatrixDataInfo{man,2},' LFP triggered by inspiration (',NameStructure,')'])
                caxis([-0.5 0.8]/1E3)
                
                % PETH respi
                figure('Color',[1 1 1]), FigurePETHrespi=gcf;
                [fh, rasterAx, histAx, matVal] = ImagePETH(RespiTSD,ts(tp(20:end-20)), -10000, +15000,'BinSize',1000);
                title([MatrixDataInfo{man,1},MatrixDataInfo{man,2},' Respi triggered by inspiration (',NameStructure,')'])
                caxis([-0.5 0.8]/1E3)
            end
            
            
        catch
            %keyboard
            disp([Dir.group{man},Dir.name{man}(strfind(Dir.name{man},'Mouse')+6:end),': no UniqueChannel',NameStructure])
        end
        
        
    end
    save(FileName_save,'MatrixLFP','MatrixLFP_inf','MatrixLFP_sup')
    save(FileName_save,'MatrixRespi','MatrixRespi_inf','MatrixRespi_sup','-append')
    save(FileName_save,'MatrixDataInfo','lengthEpoch','-append')

end


%% display individual Data
figure('Color',[1 1 1],'Position',[2 scrsz(4)/2 scrsz(3)/2 scrsz(4)/2]), numF=gcf;
figure('Color',[1 1 1],'Position',[2 scrsz(4)/2 scrsz(3)/2 scrsz(4)/2]), numF_inf=gcf;
figure('Color',[1 1 1],'Position',[2 scrsz(4)/2 scrsz(3)/2 scrsz(4)/2]), numF_sup=gcf;

xxxx=0;
for man=1:length(Dir.path)
    
    if sum(isnan(MatrixLFP(man,:)))==0
        
        if xxxx==0 && ~exist('tp','var')
            load([Dir.path{man},'/LFPData.mat'],'TidalVolume')
            load([Dir.path{man},'/SpectrumDataL/UniqueChannel',NameStructure],'channelToAnalyse')
            load([Dir.path{man},'/LFPData/LFP',num2str(channelToAnalyse),'.mat'],'LFP');
            load([Dir.path{man},'/StateEpoch.mat'],'SWSEpoch','REMEpoch','MovEpoch','NoiseEpoch','GndNoiseEpoch','WeirdNoiseEpoch')
            
            eval(['epoch=',NameEpoch,'-NoiseEpoch-GndNoiseEpoch-WeirdNoiseEpoch;'])
            tLFP=Range(LFP);
            tp=Range(Restrict(TidalVolume,epoch));
            
            I=intervalSet(tLFP(1),tLFP(100));
            [m1,t1,e1]=mETAverage(tp,Range(Restrict(LFP,I)),Data(Restrict(LFP,I)),10,size(MatrixLFP(man,:),2)-1);
            
            xxxx=1;
        end
        
        figure(numF),
        subplot(3,ceil(length(Dir.path)/3),man)
        hold on, plot(e1/1E3,MatrixLFP(man,:),'k','Linewidth',2)
        hold on, plot(e1/1E3,MatrixRespi(man,:),'b','Linewidth',2)
        title([MatrixDataInfo{man,1},' - ',MatrixDataInfo{man,2},' - ',NameEpoch])
        xlabel(['epoch = ',num2str(lengthEpoch(man,1)),'s'])
        % xlim([-0.5 0.5])
        
        figure(numF_inf),
        subplot(3,ceil(length(Dir.path)/3),man)
        hold on, plot(e1/1E3,MatrixLFP_inf(man,:),'k','Linewidth',2)
        hold on, plot(e1/1E3,MatrixRespi_inf(man,:),'b','Linewidth',2)
        title([MatrixDataInfo{man,1},' - ',MatrixDataInfo{man,2},' - freq [',num2str(FreqInf),']Hz'])
        xlabel(['epoch = ',num2str(lengthEpoch(man,2)),'s'])
        %xlim([-0.5 0.5])
        
        figure(numF_sup),
        subplot(3,ceil(length(Dir.path)/3),man)
        hold on, plot(e1/1E3,MatrixLFP_sup(man,:),'k','Linewidth',2)
        hold on, plot(e1/1E3,MatrixRespi_sup(man,:),'b','Linewidth',2)
        title([MatrixDataInfo{man,1},' - ',MatrixDataInfo{man,2},' - freq [',num2str(FreqSup),']Hz'])
        xlabel(['epoch = ',num2str(lengthEpoch(man,3)),'s'])
        %xlim([-0.5 0.5])
        
    end
end
figure(numF), legend({['LFP ',NameStructure] 'Respiration'})
figure(numF_inf), legend({['LFP ',NameStructure] 'Respiration'})
figure(numF_sup), legend({['LFP ',NameStructure] 'Respiration'})

%% pool data from same mice

% MatrixData_temp=nan(length(MiceNames),size(MatrixData,2));
% for uu=1:length(MiceNames)
%     index=find(strcmp(MatrixDataInfo(:,2),MiceNames{uu}(strfind(MiceNames{uu},'Mouse')+6:end)));
%     MatrixData_temp(uu,:)=mean(MatrixData(index,:),1);
%     MatrixDataInfo_temp(uu)=unique(MatrixDataInfo(index,1));
%     clear index
% end
% MatrixDataInfo=MatrixDataInfo_temp;
% MatrixData=MatrixData_temp;


%% compute difference between strains

% -------------------------------------------------------------------------
% initialisation matrix
LFP_mean=nan(length(strains),size(MatrixLFP,2));
LFPinf_mean=LFP_mean;
LFPsup_mean=LFP_mean;
Respi_mean=LFP_mean;
Respiinf_mean=LFP_mean;
Respisup_mean=LFP_mean;
LFP_std=LFP_mean;
LFPinf_std=LFP_mean;
LFPsup_std=LFP_mean;
Respi_std=LFP_mean;
Respiinf_std=LFP_mean;
Respisup_std=LFP_mean;
Strains_legend=[];

for ss=1:length(strains)
    gg=find(strcmp(MatrixDataInfo(:,1),strains(ss)) & ~isnan(MatrixLFP(:,1)));
    
    LFP_mean(ss,:)=nanmean(MatrixLFP(gg,:),1);
    LFPinf_mean(ss,:)=nanmean(MatrixLFP_inf(gg,:),1);
    LFPsup_mean(ss,:)=nanmean(MatrixLFP_sup(gg,:),1);
    
    Respi_mean(ss,:)=nanmean(MatrixRespi(gg,:),1);
    Respiinf_mean(ss,:)=nanmean(MatrixRespi_inf(gg,:),1);
    Respisup_mean(ss,:)=nanmean(MatrixRespi_sup(gg,:),1);
    
    LFP_std(ss,:)=stdError(MatrixLFP(gg,:));
    LFPinf_std(ss,:)=stdError(MatrixLFP_inf(gg,:));
    LFPsup_std(ss,:)=stdError(MatrixLFP_sup(gg,:));
    
    Respi_std(ss,:)=stdError(MatrixRespi(gg,:));
    Respiinf_std(ss,:)=stdError(MatrixRespi_inf(gg,:));
    Respisup_std(ss,:)=stdError(MatrixRespi_sup(gg,:));
    
    Strains_legend=[Strains_legend;{[strains{ss},' (n=',num2str(length(gg)),')']}];
end

%% Display LFP+Respi difference between strains

figure('Color',[1 1 1],'Position',[2 scrsz(4)/2 scrsz(3)/2 scrsz(4)/2]), numFig=gcf;

% ---------
% All

% dKO
subplot(2,3,1),
hold on, plot(e1/1E3,LFP_mean(1,:),'k','Linewidth',2)
hold on, plot(e1/1E3,Respi_mean(1,:),'b','Linewidth',2)
legend({['LFP ',NameStructure] 'Respiration'})

[RHO,PVAL] = corr([LFP_mean(1,:)',Respi_mean(1,:)']);
text(-0.45,0.03,['Corr=',num2str(floor(1000*RHO(2,1))/1000),' (p=',num2str(floor(10000*PVAL(2,1))/10000),')'],'Color','r')

hold on, plot(e1/1E3,LFP_mean(1,:)+LFP_std(1,:),'k')
hold on, plot(e1/1E3,LFP_mean(1,:)-LFP_std(1,:),'k')
hold on, plot(e1/1E3,Respi_mean(1,:)+Respi_std(1,:),'b')
hold on, plot(e1/1E3,Respi_mean(1,:)-Respi_std(1,:),'b')
title([strains{1},' - ',NameEpoch])
xlim([-0.5 0.5]); ylim([-2.5 4]/1E4)

% WT
subplot(2,3,4),
hold on, plot(e1/1E3,LFP_mean(2,:),'k','Linewidth',2)
hold on, plot(e1/1E3,LFP_mean(2,:)+LFP_std(2,:),'k')
hold on, plot(e1/1E3,LFP_mean(2,:)-LFP_std(2,:),'k')
hold on, plot(e1/1E3,Respi_mean(2,:),'b','Linewidth',2)
hold on, plot(e1/1E3,Respi_mean(2,:)+Respi_std(2,:),'b')
hold on, plot(e1/1E3,Respi_mean(2,:)-Respi_std(2,:),'b')

[RHO,PVAL] = corr([LFP_mean(2,:)',Respi_mean(2,:)']);
text(-0.45,0.03,['Corr=',num2str(floor(1000*RHO(2,1))/1000),' (p=',num2str(floor(10000*PVAL(2,1))/10000),')'],'Color','r')
title([strains{2},' - ',NameEpoch])
xlim([-0.5 0.5]); ylim([-2.5 4]/1E4)


% ---------
%  Freq inf

% dKO
subplot(2,3,2),
hold on, plot(e1/1E3,LFPinf_mean(1,:),'k','Linewidth',2)
hold on, plot(e1/1E3,LFPinf_mean(1,:)+LFPinf_std(1,:),'k')
hold on, plot(e1/1E3,LFPinf_mean(1,:)-LFPinf_std(1,:),'k')
hold on, plot(e1/1E3,Respiinf_mean(1,:),'b','Linewidth',2)
hold on, plot(e1/1E3,Respiinf_mean(1,:)+Respiinf_std(1,:),'b')
hold on, plot(e1/1E3,Respiinf_mean(1,:)-Respiinf_std(1,:),'b')
title([strains{1},' Freq [',num2str(FreqInf),']Hz'])
xlim([-0.5 0.5]); ylim([-2.5 4]/1E4)

% WT
subplot(2,3,5),
hold on, plot(e1/1E3,LFPinf_mean(2,:),'k','Linewidth',2)
hold on, plot(e1/1E3,LFPinf_mean(2,:)+LFPinf_std(2,:),'k')
hold on, plot(e1/1E3,LFPinf_mean(2,:)-LFPinf_std(2,:),'k')
hold on, plot(e1/1E3,Respiinf_mean(2,:),'b','Linewidth',2)
hold on, plot(e1/1E3,Respiinf_mean(2,:)+Respiinf_std(2,:),'b')
hold on, plot(e1/1E3,Respiinf_mean(2,:)-Respiinf_std(2,:),'b')
title([strains{2},' Freq [',num2str(FreqInf),']Hz'])
xlim([-0.5 0.5]); ylim([-2.5 4]/1E4)



% ---------
% Freq sup
subplot(2,3,3),
hold on, plot(e1/1E3,LFPsup_mean(1,:),'k','Linewidth',2)
hold on, plot(e1/1E3,LFPsup_mean(1,:)+LFPsup_std(1,:),'k')
hold on, plot(e1/1E3,LFPsup_mean(1,:)-LFPsup_std(1,:),'k')
hold on, plot(e1/1E3,Respisup_mean(1,:),'b','Linewidth',2)
hold on, plot(e1/1E3,Respisup_mean(1,:)+Respisup_std(1,:),'b','Linewidth',2)
hold on, plot(e1/1E3,Respisup_mean(1,:)-Respisup_std(1,:),'b','Linewidth',2)
title([strains{1},' Freq [',num2str(FreqSup),']Hz'])
xlim([-0.5 0.5]); ylim([-2.5 4]/1E4)

% WT
subplot(2,3,6),
hold on, plot(e1/1E3,LFPsup_mean(2,:),'k','Linewidth',2)
hold on, plot(e1/1E3,LFPsup_mean(2,:)+LFPsup_std(2,:),'k')
hold on, plot(e1/1E3,LFPsup_mean(2,:)-LFPsup_std(2,:),'k')
hold on, plot(e1/1E3,Respisup_mean(2,:),'b','Linewidth',2)
hold on, plot(e1/1E3,Respisup_mean(2,:)+Respisup_std(2,:),'b')
hold on, plot(e1/1E3,Respisup_mean(2,:)-Respisup_std(2,:),'b')
title([strains{2},' Freq [',num2str(FreqSup),']Hz'])
xlim([-0.5 0.5]); ylim([-2.5 4]/1E4)







%% Display Respi, difference between strains 
figure('Color',[1 1 1],'Position',[2 scrsz(4)/2 scrsz(3)/2 scrsz(4)/2]), numFig2=gcf;


% All
% LFP
subplot(2,3,1)
hold on, plot(e1/1E3,LFP_mean(1,:),'k','Linewidth',2)
hold on, plot(e1/1E3,LFP_mean(2,:),'r','Linewidth',2)
legend(Strains_legend)

hold on, plot(e1/1E3,LFP_mean(1,:)+LFP_std(1,:),'k')
hold on, plot(e1/1E3,LFP_mean(1,:)-LFP_std(1,:),'k')
hold on, plot(e1/1E3,LFP_mean(2,:)+LFP_std(2,:),'r')
hold on, plot(e1/1E3,LFP_mean(2,:)-LFP_std(2,:),'r')
title(['LFP',NameStructure,' - ',NameEpoch])
xlim([-0.5 0.5]); ylim([-2.5 4]/1E4)

% Respi
subplot(2,3,4)
hold on, plot(e1/1E3,Respi_mean(1,:),'b','Linewidth',2)
hold on, plot(e1/1E3,Respi_mean(2,:),'r','Linewidth',2)
legend(Strains_legend)

hold on, plot(e1/1E3,Respi_mean(1,:)+Respi_std(1,:),'b')
hold on, plot(e1/1E3,Respi_mean(1,:)-Respi_std(1,:),'b')
hold on, plot(e1/1E3,Respi_mean(2,:)+Respi_std(2,:),'r')
hold on, plot(e1/1E3,Respi_mean(2,:)-Respi_std(2,:),'r')

title(['Respi - ',NameEpoch])
xlim([-0.5 0.5]); ylim([-2.5 4]/1E4)


% freq inf
% LFP
subplot(2,3,2)
hold on, plot(e1/1E3,LFPinf_mean(1,:),'k','Linewidth',2)
hold on, plot(e1/1E3,LFPinf_mean(1,:)+LFPinf_std(1,:),'k')
hold on, plot(e1/1E3,LFPinf_mean(1,:)-LFPinf_std(1,:),'k')

hold on, plot(e1/1E3,LFPinf_mean(2,:),'r','Linewidth',2)
hold on, plot(e1/1E3,LFPinf_mean(2,:)+LFPinf_std(2,:),'r')
hold on, plot(e1/1E3,LFPinf_mean(2,:)-LFPinf_std(2,:),'r')
title(['LFP - Freq [',num2str(FreqInf),']Hz'])
xlim([-0.5 0.5]); ylim([-2.5 4]/1E4)

% Respi
subplot(2,3,5)
hold on, plot(e1/1E3,Respiinf_mean(1,:),'b','Linewidth',2)
hold on, plot(e1/1E3,Respiinf_mean(1,:)+Respiinf_std(1,:),'b')
hold on, plot(e1/1E3,Respiinf_mean(1,:)-Respiinf_std(1,:),'b')

hold on, plot(e1/1E3,Respiinf_mean(2,:),'r','Linewidth',2)
hold on, plot(e1/1E3,Respiinf_mean(2,:)+Respiinf_std(2,:),'r')
hold on, plot(e1/1E3,Respiinf_mean(2,:)-Respiinf_std(2,:),'r')
title(['Respi - Freq [',num2str(FreqInf),']Hz'])
xlim([-0.5 0.5]); ylim([-2.5 4]/1E4)



% freq sup

% LFP
subplot(2,3,3)
hold on, plot(e1/1E3,LFPsup_mean(1,:),'k','Linewidth',2)
hold on, plot(e1/1E3,LFPsup_mean(1,:)+LFPsup_std(1,:),'k')
hold on, plot(e1/1E3,LFPsup_mean(1,:)-LFPsup_std(1,:),'k')

hold on, plot(e1/1E3,LFPsup_mean(2,:),'r','Linewidth',2)
hold on, plot(e1/1E3,LFPsup_mean(2,:)+LFPsup_std(2,:),'r')
hold on, plot(e1/1E3,LFPsup_mean(2,:)-LFPsup_std(2,:),'r')
title(['LFP- Freq [',num2str(FreqSup),']Hz'])
xlim([-0.5 0.5]); ylim([-2.5 4]/1E4)

% Respi
subplot(2,3,6)
hold on, plot(e1/1E3,Respisup_mean(1,:),'b','Linewidth',2)
hold on, plot(e1/1E3,Respisup_mean(1,:)+Respisup_std(1,:),'b')
hold on, plot(e1/1E3,Respisup_mean(1,:)-Respisup_std(1,:),'b')

hold on, plot(e1/1E3,Respisup_mean(2,:),'r','Linewidth',2)
hold on, plot(e1/1E3,Respisup_mean(2,:)+Respisup_std(2,:),'r')
hold on, plot(e1/1E3,Respisup_mean(2,:)-Respisup_std(2,:),'r')
title(['Respi - Freq [',num2str(FreqSup),']Hz'])
xlim([-0.5 0.5]); ylim([-2.5 4]/1E4)


%% Display correlation respi-LFP, for each strain

%% save figures

folderTosave=[res,'/Analyse_Inspiration_Trig_LFP/',NameStructure,'/',NameEpoch];
if exist(['InspirationTrig_RespiAndLFP',NameStructure,'_',NameEpoch],'file')
    disp(['Warning:   figures in Inspiration_Trig_LFP/',NameStructure,'/',NameEpoch,' already exists'])
end
disp('keyboard for modifying figures before saving')
keyboard

saveFigure(numF,['InspirationTrigRespiAndLFP',NameStructure,NameEpoch],folderTosave);
saveFigure(numF_inf,['InspirationTrigRespiAndLFP',NameStructure,'FreqInf',NameEpoch],folderTosave);
saveFigure(numF_sup,['InspirationTrigRespiAndLFP',NameStructure,'FreqSup',NameEpoch],folderTosave);
saveFigure(numFig,['BILANInspirationTrigRespiAndLFP',NameStructure,NameEpoch],folderTosave);
saveFigure(numFig2,['BILANInspirationTrig',NameStructure,'strains',NameEpoch],folderTosave);



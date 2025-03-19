%SpectroFearML.m


% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% %%%%%%%%%%%%%%%%%%  INPUTS  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

experiment= 'Fear-electrophy';
%experiment='ManipFeb15Bulbectomie';

plo=0;
mean_or_med='mean';
SpPplot=0;

params.Fs=1250;
params.tapers=[3 5];
movingwin=[3 0.2];
params.fpass=[0 50];

th_immob=2; % default 1
thtps_immob=2; % minimum 2 sec of immobility
Rogne=2; % rognage des evenementde freezing
thtps_immob_for_rogne=4; % a ajuster en fonction de 'Rogne'
Ylimits_raw=[0 5E4];
Ylimits_norm=[20 60];

% define frequency bands
freq1=3;
freq2=4;
freq3=6;
freq4=9;
structlist={'PFCx_deep','Bulb_deep','dHPC','PiCx','Amyg'};

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% %%%%%%%%%%%%%%%%%%  INITIALIZATION  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Dir=PathForExperimentFEAR(experiment);
%nameSession=unique(Dir.Session);
nameMice=unique(Dir.name);
nameGroups=unique(Dir.group);
nameGroups=[nameGroups(~strcmp(nameGroups,'CTRL')),nameGroups(strcmp(nameGroups,'CTRL'))];


MatSpF=nan(length(Dir.path),length(structlist),164);
MatSpNoF= MatSpF;   MatInfo=nan(length(Dir.path),length(structlist),4);  
for i=1:length(structlist), allfig(i)=figure('Color',[1 1 1],'Position', [100 10 1600 900]);end
try
    load('TestMLSpectroFreezing.mat');MatInfo;
    disp('Loading existing data from TestMLSpectroFreezing.mat');
catch
    for man=1:length(Dir.path)
        
        disp(' '),disp(' '), disp(Dir.path{man})
        mousename=Dir.name{man};
        FRatioTable=[];
        NoFRatioTable=[];
        FRatioTableLog=[];
        NoFRatioTableLog=[];
        LowF=[];
        HighF=[];
        LowHighRatio=[];
        LowFLog=[];
        HighFLog=[];
        LowHighRatioLog=[];
        LowF_md=[];
        HighF_md=[];
        LowHighRatio_md=[];
        %hRfig=figure('Color', [1 1 1], 'Position', [800 300 900 600]);
        
        for i=1:length(structlist)
            disp(['    ',structlist{i}])
            clear Sp t Stsd
            
            %%%%%%%% load and plot spectrogram // load LFP and compute spectrogram
            try
                if strcmp(structlist{i},'dHPC')
                    try tempt=load([Dir.path{man},'/ChannelsToAnalyse/dHPC_sup.mat']); if ~isempty(tempt.channel);temp=tempt;end;end 
                    try tempt=load([Dir.path{man},'/ChannelsToAnalyse/dHPC_deep.mat']); if ~isempty(tempt.channel);temp=tempt;end;end   
                    try tempt=load([Dir.path{man},'/ChannelsToAnalyse/dHPC_rip.mat']); if ~isempty(tempt.channel);temp=tempt;end;end 
                else
                    temp=load([Dir.path{man},'/ChannelsToAnalyse/',structlist{i},'.mat']);
                end
                %disp(num2str(temp.channel))
                if isempty(temp.channel) || isnan(temp.channel),error;end
                
                
                try
                    load([Dir.path{man},'/SpectrumDataL/Spectrum' num2str(temp.channel),'.mat'],'Sp', 't', 'f') % t en secondes
                    disp(['SpectrumDataL/Spectrum' num2str(temp.channel),'... loaded'])
                catch
                    if ~exist([Dir.path{man},'/SpectrumDataL'],'dir'), mkdir([Dir.path{man},'/SpectrumDataL']);end
                    eval(['temp2=load(''',Dir.path{man},'/LFPData/LFP',num2str(temp.channel),'.mat'');'])
                    disp(['Computing SpectrumDataL/Spectrum' num2str(temp.channel),'... '])
                    [Sp,t,f]=mtspecgramc(Data(temp2.LFP),movingwin,params);
                    eval(['save(''',Dir.path{man},'/SpectrumDataL/Spectrum',num2str(temp.channel),'.mat'',','''Sp'',','''t'',','''f'');'])
                end
                Stsd=tsd(t*1E4,Sp);
            catch
                disp(['No or empty ChannelsToAnalyse/',structlist{i},'... skip'])
            end
            
            
                %%%%%%%%%% For wake data (fear conditioning protocol
                % define TotEpoch
            try
                tps=Range(Stsd); %tps est en 10-4sec
                TotEpoch=intervalSet(tps(1),tps(end));
                TotEpoch_length1=sum(End(TotEpoch,'s')-Start(TotEpoch,'s'));
                clear temp2
                try
                    temp2=load([Dir.path{man},'/StateEpoch.mat'],'NoiseEpoch','GndNoiseEpoch','WeirdNoiseEpoch');
                    NoiseEpoch=temp2.NoiseEpoch; GndNoiseEpoch=temp2.GndNoiseEpoch; WeirdNoiseEpoch=temp2.WeirdNoiseEpoch;
                    TotEpoch=TotEpoch-NoiseEpoch-GndNoiseEpoch-WeirdNoiseEpoch;
                catch
                    disp('NoiseEpoch / GndNoiseEpoch / WeirdNoiseEpoch not removed...')
                end
                TotEpoch_length2=sum(End(TotEpoch,'s')-Start(TotEpoch,'s'));% after noise removal
                
                clear temp2
                eval(['temp2=load(''',Dir.path{man},'/behavResources.mat'',''FreezeEpoch'',''Movtsd'');']);
                Movtsd=temp2.Movtsd; %, attention valable seulement pour file comportment car fichier sleep= doubletracking=pixratio pas appliqué
                FreezeEpoch=thresholdIntervals(Movtsd,th_immob,'Direction','Below');
                FreezeEpoch=mergeCloseIntervals(FreezeEpoch,0.3*1E4);
                FreezeEpoch=dropShortIntervals(FreezeEpoch,thtps_immob*1E4);
                
                % remove noise epochs
                FreezeEpoch=and(FreezeEpoch, TotEpoch);
                FreezeEpoch_length1=sum(End(FreezeEpoch,'s')-Start(FreezeEpoch,'s'));
                %FreezeEpoch=FreezeEpoch-NoiseEpoch-GndNoiseEpoch-WeirdNoiseEpoch;
                NoFreezeEpoch_length=sum(End(TotEpoch-FreezeEpoch,'s')-Start(TotEpoch-FreezeEpoch,'s'));
                
                % restriction of period just before and just after each freezing event to clean up the spectrum
                FreezeEpochL=dropShortIntervals(FreezeEpoch, thtps_immob_for_rogne*1E4);
                St=Start(FreezeEpochL);
                En=End(FreezeEpochL);
                FreezeEpochL=intervalset(St+Rogne*1E4, En-Rogne*1E4);
                FreezeEpoch_length2=sum(End(FreezeEpochL,'s')-Start(FreezeEpochL,'s'));% after rognage
            catch
                if exist('Stsd','var'), disp('Problem FreezeEpoch');keyboard; end
            end
            
            if plo
                try
                    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% frequency spectrum
                    hfig=figure('Color', [1 1 1], 'Position', [70 700 1800 500]);
                    h_sp=subplot(2,4,1:4); imagesc(t,f,10*log10(Sp')), axis xy
                    title([Dir.name{man} ' ' structlist{i} ' (ch' num2str(temp.channel) ')'])
                    ylim([0 30]);caxis([15 65])
                    
                    line([Start(FreezeEpoch,'s') End(FreezeEpoch,'s')],[15 15],'color','k','linewidth',4)
                    line([Start(FreezeEpochL,'s') End(FreezeEpochL,'s')],[15 15],'color','b','linewidth',4)
                    
                    %%%%%%% Drop intervals <2sec
                    % raw spectrogram
                    subplot(2,4,5), hold on
                    plot(f,mean(Data(Restrict(Stsd,FreezeEpoch))),'c')
                    plot(f,mean(Data(Restrict(Stsd,TotEpoch-FreezeEpoch))),'k')
                    plot(f,median(Data(Restrict(Stsd,FreezeEpoch))),'c','LineStyle','--')
                    plot(f,median(Data(Restrict(Stsd,TotEpoch-FreezeEpoch))),'k','LineStyle','--')
                    xlim([0 30]), ylim(Ylimits_raw)
                    ylabel('raw')
                    title('drop period <2sec')
                    
                    % spetrogram normaliszed by 10 log10
                    subplot(2,4,6), hold on
                    plot(f,mean(10*log10(Data(Restrict(Stsd,FreezeEpoch)))),'c')
                    plot(f,mean(10*log10(Data(Restrict(Stsd,TotEpoch-FreezeEpoch)))),'k')
                    plot(f,median(10*log10(Data(Restrict(Stsd,FreezeEpoch)))),'c','LineStyle','--')
                    plot(f,median(10*log10(Data(Restrict(Stsd,TotEpoch-FreezeEpoch)))),'k','LineStyle','--')
                    xlim([0 30]), ylim(Ylimits_norm)
                    ylabel('normalised 10log10')
                    
                    %%%%%%% Drop intervals <5sec  / ou rogne 2 sec before & after
                    % raw spectrogram
                    subplot(2,4,7), hold on
                    plot(f,mean(Data(Restrict(Stsd,FreezeEpochL))),'c')
                    plot(f,mean(Data(Restrict(Stsd,TotEpoch-FreezeEpochL))),'k')
                    plot(f,median(Data(Restrict(Stsd,FreezeEpochL))),'c','LineStyle','--')
                    plot(f,median(Data(Restrict(Stsd,TotEpoch-FreezeEpochL))),'k','LineStyle','--')
                    xlim([0 30]), ylim(Ylimits_raw)
                    ylabel('raw')
                    title(['rogne ' num2str(Rogne) ' sec before & after'])
                    
                    % spetrogram normaliszed by 10 log10
                    subplot(2,4,8), hold on
                    plot(f,mean(10*log10(Data(Restrict(Stsd,FreezeEpochL)))),'c')
                    plot(f,mean(10*log10(Data(Restrict(Stsd,TotEpoch-FreezeEpochL)))),'k')
                    plot(f,median(10*log10(Data(Restrict(Stsd,FreezeEpochL)))),'c','LineStyle','--')
                    plot(f,median(10*log10(Data(Restrict(Stsd,TotEpoch-FreezeEpochL)))),'k','LineStyle','--')
                    xlim([0 30]), ylim(Ylimits_norm)
                    legend(['Freeze ' sprintf('%0.0f',FreezeEpoch_length1) 's/ ' sprintf('%0.0f',FreezeEpoch_length2) 's'],['No Freeze ' sprintf('%0.0f',NoFreezeEpoch_length) 's'] )
                    ylabel('normalised 10log10')
                catch
                    if exist('Stsd','var')&&exist('FreezeEpoch','var'), disp('Problem plot figure');end
                end
            end
            try
                % spetrum restricted on FreezeEpoch
                [tEpoch, SpEpoch]=SpectroEpochML(Sp,t,f,FreezeEpoch,0);
                
%                 figure(hRfig), nn=ceil(sqrt(length(structlist)));
%                 subplot(nn,ceil(length(structlist)/nn),i);ylim([0 20]); 
%                 if i==1, text(0,26,[Dir.group{man},'   ',Dir.path{man}]);end; 
%                 imagesc(tEpoch,f,10*log10(SpEpoch')), axis xy, caxis([15 65])
%                 title(structlist{i}), ylabel('Frequency (Hz)'); xlabel('Time (s)');
%                 ylim([0 20]); if i==1, text(0,26,[Dir.group{man},'   ',Dir.path{man}]);end;  xlim([0 200])
                
                % regroup by structures for all mice
                figure(allfig(i)), subplot(ceil(sqrt(length(Dir.path))),floor(sqrt(length(Dir.path))),man)
                imagesc(tEpoch,f,10*log10(SpEpoch')), axis xy, caxis([15 65])
                title([Dir.group{man},' ',Dir.path{man}(end-30:end)]), ylabel('Frequency (Hz)'); xlabel('Time (s)')
                ylim([0 20]); if man==1, text(0,26,structlist{i});end;  xlim([0 200])
                hold on, line([0 200],[5 5],'Color',[0.5 0.5 0.5])
                
                % save in matrice
                MatSpF(man,i,1:length(f))=mean(Data(Restrict(Stsd,FreezeEpoch)));
                MatSpNoF(man,i,1:length(f))=mean(Data(Restrict(Stsd,TotEpoch-FreezeEpoch)));
                MatInfo(man,i,1:4)=[find(strcmp(Dir.group{man},nameGroups)),...
                    find(strcmp(Dir.name{man},nameMice)),tot_length(FreezeEpoch,'s'),tot_length(TotEpoch-FreezeEpoch,'s')];
                
                %%%%%% compute mean spectro for 2-4 Hz and 6-9 Hz
                % raw
                FreqRang={'low F= ' num2str(freq1) '-' num2str(freq2) 'Hz';...
                    'low F= ' num2str(freq3) '-' num2str(freq4) 'Hz'};
                
                
                Columns={'No Freeze';'Freeze'};
                a=mean(Data(Restrict(Stsd,FreezeEpoch))); % F
                Fratio=mean(a(f>freq1&f<freq2))/mean(a(f>freq3&f<freq4));
                b=mean(Data(Restrict(Stsd,TotEpoch-FreezeEpoch))); % No F
                NoFratio=mean(b(f>freq1&f<freq2))/mean(b(f>freq3&f<freq4));
                % median
                a_md=median(Data(Restrict(Stsd,FreezeEpoch))); % F
                NoFratio_md=median(b(f>freq1&f<freq2))/median(b(f>freq3&f<freq4));
                b_md=median(Data(Restrict(Stsd,TotEpoch-FreezeEpoch))); % No F
                Fratio_md=median(a(f>freq1&f<freq2))/median(a(f>freq3&f<freq4));
                
                NoFRatioTable=[NoFRatioTable; mean(b(f>freq1&f<freq2))  mean(b(f>freq3&f<freq4))  NoFratio ];
                FRatioTable=[FRatioTable; mean(a(f>freq1&f<freq2))  mean(a(f>freq3&f<freq4))  Fratio ];
                
                LowF=[LowF; mean(b(f>freq1&f<freq2)) mean(a(f>freq1&f<freq2)) ];
                HighF=[HighF; mean(b(f>freq3&f<freq4)) mean(a(f>freq3&f<freq4))];
                LowHighRatio=[LowHighRatio; NoFratio Fratio];
                
                LowF_md=[LowF_md; median(b_md(f>freq1&f<freq2)) median(a_md(f>freq1&f<freq2)) ];
                HighF_md=[HighF_md; median(b_md(f>freq3&f<freq4)) median(a_md(f>freq3&f<freq4))];
                LowHighRatio_md=[LowHighRatio_md; NoFratio_md Fratio_md];
                
                % 10 log 10
                c=mean(10*log10(Data(Restrict(Stsd,FreezeEpoch)))); % F
                d=mean(10*log10(Data(Restrict(Stsd,TotEpoch-FreezeEpoch)))); % No F
                FratioLog=mean(c(f>freq1&f<freq2))/mean(c(f>freq3&f<freq4));
                NoFratioLog=mean(d(f>freq1&f<freq2))/mean(d(f>freq3&f<freq4));
                FRatioTableLog=[FRatioTableLog; mean(c(f>freq1&f<freq2))  mean(c(f>freq3&f<freq4))  FratioLog ];
                NoFRatioTableLog=[NoFRatioTableLog; mean(d(f>freq1&f<freq2))  mean(d(f>freq3&f<freq4))  NoFratioLog ];
                
                LowFLog=[LowFLog; mean(d(f>freq1&f<freq2)) mean(c(f>freq1&f<freq2))];
                HighFLog=[HighFLog; mean(d(f>freq3&f<freq4)) mean(c(f>freq3&f<freq4))];
                LowHighRatioLog=[LowHighRatioLog; FratioLog NoFratioLog];
            catch
                if exist('Stsd','var'), disp('Problem saving matrices'); end
            end
            
        end
        %save Ratio FreqRang structlist FRatioTable NoFRatioTable FRatioTableLog NoFRatioTableLog  LowF HighF  LowHighRatio  LowFLog HighFLog  LowHighRatioLog  LowF_md HighF_md  LowHighRatio_md
        
        %%%%%%%%%%%%%%%  quantify ratio btw low and high freqency bands
        %%%%%%%%%%%%%%%  for  each mouse
        if SpPplot
            try
                figure('Color',[1 1 1], 'Position', [100 100 500 900])
                subplot(3,1,1)
                bar(LowF)
                set(gca, 'XTickLabel', structlist)
                title([num2str(freq1) '-' num2str(freq2) ' Hz'])
                ymaxi=Ylim;
                text(0.1, ymaxi(2)*1.1, mousename)
                text(0.1, ymaxi(2), 'mean')
                
                subplot(3,1,2)
                bar(HighF)
                set(gca, 'XTickLabel', structlist)
                title([num2str(freq3) '-' num2str(freq4) 'Hz'])
                
                subplot(3,1,3)
                bar(10*log10(LowHighRatio))
                set(gca, 'XTickLabel', structlist)
                title([num2str(freq1) '-' num2str(freq2) 'Hz / ' num2str(freq3) '-' num2str(freq4) 'Hz ratio'])
                
                legend('No Freeze', 'Freeze');
                res=pwd;
                saveas(gcf, [mousename 'Ratio_mean.fig'])
                saveFigure(gcf,[mousename 'Ratio_mean'], res)
            catch
                close;
            end
        end
        
    end
    disp('Saving data in local path, TestMLSpectroFreezing.mat');
    save TestMLSpectroFreezing MatInfo MatSpF MatSpNoF params structlist nameMice nameGroups Dir f
end
for i=1:length(structlist), saveFigure(allfig(i),['BilanFreezing_',structlist{i}],pwd);end



% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% %%%%%%%%%%%%%%%%%%%%  MEAN SPECTRA  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% superpose group spectra for conditions
figure('Color',[1 1 1],'Position', [100 10 1600 900])
colori={'r','b','k','m','g','c','y'};
namecolmn={'Freezing','No Freezing','Freezing','No Freezing'};
% name MatInfo: nGroup nMice duration(FreezeEpoch) duration(TotEpoch-FreezeEpoch);
clear SpF SpNoF SpInfo

for i=1:length(structlist)
    if strcmp(structlist{i},'Bulb_deep'), yl=[0 6E5]; else, yl=[0 6E4];end
    SpF=squeeze(MatSpF(:,i,:));
    SpNoF=squeeze(MatSpNoF(:,i,:));
    SpInfo=squeeze(MatInfo(:,i,:));
    legF=[];legNoF=[];
    for man=1:length(Dir.path)
        try
            subplot(length(structlist),6,6*(i-1)+[1:2]),hold on,
            plot(f,SpF(man,:),'Color',colori{SpInfo(man,2)});
            ylabel(structlist{i}); ylim(yl);xlim([0 20]);
            legF=[legF,{[Dir.name{man}([1,6:8]),' ',num2str(floor(SpInfo(man,3))),'s']}];
        end
        try
            subplot(length(structlist),6,6*(i-1)+[3:4]),hold on,
            plot(f,SpNoF(man,:),'Color',colori{SpInfo(man,2)});
            ylim(yl);xlim([0 20]);
            legNoF=[legNoF,{[Dir.name{man}([1,6:8]),' ',num2str(floor(SpInfo(man,4))),'s']}];
        end
    end

    subplot(length(structlist),6,6*(i-1)+[1:2]), legend(legF,'Location','EastOutside');
    if i==1,title(namecolmn{1});end;if i==length(structlist), xlabel('Frequency (Hz)');end
    subplot(length(structlist),6,6*(i-1)+[3:4]), legend(legNoF,'Location','EastOutside');
    if i==1,title(namecolmn{2});end;if i==length(structlist), xlabel('Frequency (Hz)');end

end

clear SpF SpNoF SpInfo tempSpF temp tempSpNoF 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%%%%%%%%%%%%%%%%%% pool mice before pooling groups %%%%%%%%%%%%%%%%%%%%
for mi=1:length(nameMice)
    for i=1:length(structlist)
        ind=find(strcmp(Dir.name,nameMice{mi}));
        try
            temp=squeeze(MatSpF(ind,i,:)); if length(ind)==1,temp=temp';end
            tempSpF(mi,i,1:length(f))=nanmean(temp,1);
            temp=squeeze(MatSpNoF(ind,i,:)); if length(ind)==1,temp=temp';end
            tempSpNoF(mi,i,1:length(f))=nanmean(temp,1);
            infoG(mi,i)=unique(Dir.group(ind));
        end
    end
end

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%%%%%%%%%%%%%%%%%% pool mice in groups %%%%%%%%%%%%%%%%%%%%
for gg=1:length(nameGroups),
    ind=Dir.name(find(strcmp(Dir.group,nameGroups{gg})));
    namecolmn=[namecolmn,{[nameGroups{gg},' (n=',num2str(sum(strcmp(infoG(:,1),nameGroups{gg}))),')']}];
end

for i=1:length(structlist)
    if strcmp(structlist{i},'Bulb_deep'), yl=[0 6E5]; else, yl=[0 6E4];end
    for gg=1:length(nameGroups)
        ind=find(strcmp(infoG(:,i),nameGroups{gg}));
        SpF=squeeze(tempSpF(ind,i,:)); if length(ind)==1,SpF=SpF';end
        SpNoF=squeeze(tempSpNoF(ind,i,:)); if length(ind)==1,SpNoF=SpNoF';end
        
        subplot(length(structlist),6,6*(i-1)+5),hold on,
        plot(f,nanmean(SpF,1),'Color',colori{gg},'Linewidth',2);ylim(yl);xlim([0 20]);
        subplot(length(structlist),6,6*i),hold on,
        plot(f,nanmean(SpNoF,1),'Color',colori{gg},'Linewidth',2);
        legend(nameGroups); ylim(yl);xlim([0 20]);
    end
end
for si=5:6,  subplot(length(structlist),6,si), title(namecolmn{si-4});end;
for si=5:6,  subplot(length(structlist),6,(length(structlist)-1)*6+si), xlabel('Frequency (Hz)');end;

if 0
%%%%%%%%%%%%%%%%%% comparison between sham and bulb
compfig=1;
if compfig
    if strcmp(mean_or_med, 'mean')
        load /media/DataMOBs14/ProjetAversion/ManipFeb15Bulbectomie/M230/FEAR-Mouse230-EXTenvC-_150212_132714/Ratio.mat
        LowF230=LowF;
        HighF230=HighF;
        LowHighRatio230=LowHighRatio;
        load /media/DataMOBs14/ProjetAversion/ManipFeb15Bulbectomie/M231/FEAR-Mouse231-EXTenvC-_150212_140054/Ratio.mat
        LowF231=LowF;
        HighF231=HighF;
        LowHighRatio231=LowHighRatio;
        
    elseif strcmp(mean_or_med, 'median')
        load /media/DataMOBs14/ProjetAversion/ManipFeb15Bulbectomie/M230/FEAR-Mouse230-EXTenvC-_150212_132714/Ratio.mat
        LowF230=LowF_md;
        HighF230=HighF_md;
        LowHighRatio230=LowHighRatio_md;
        load /media/DataMOBs14/ProjetAversion/ManipFeb15Bulbectomie/M231/FEAR-Mouse231-EXTenvC-_150212_140054/Ratio.mat
        LowF231=LowF_md;
        HighF231=HighF_md;
        LowHighRatio231=LowHighRatio_md;
    end
    
    
    figure('Color',[1 1 1], 'Position', [100 100 500 900])
    subplot(3,1,1)
    bar([LowF231 LowF230])
    set(gca, 'XTickLabel', structlist)
    title([num2str(freq1) '-' num2str(freq2) ' Hz'])
    ymaxi=Ylim;
    text(0.1, 1.1*ymaxi(2), mean_or_med)
    
    subplot(3,1,2)
    bar([HighF231 HighF230])
    set(gca, 'XTickLabel', structlist)
    title([num2str(freq3) '-' num2str(freq4) 'Hz'])
    
    subplot(3,1,3)
    bar(10*log10([LowHighRatio231 LowHighRatio230]))
    set(gca, 'XTickLabel', structlist)
    title([num2str(freq1) '-' num2str(freq2) 'Hz / ' num2str(freq3) '-' num2str(freq4) 'Hz ratio (10log10)'])
    legend('No Freeze Sham', 'Freeze Sham','No Freeze Bulb', 'Freeze Bulb');
    
    saveas(gcf, ['M231-230_Ratiocomp_' mean_or_med '.fig'])
    res=pwd;
    SaveFigure(gcf,[mousename 'Ratio_mean'],res)
    
end
end
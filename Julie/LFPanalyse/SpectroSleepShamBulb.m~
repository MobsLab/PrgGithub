function SpectroFearShamBulb2(SpPplot, mean_or_med, SessionName, Expe)

% choose Channel to analyse from .dat file  -> indicate it in ChannelsToLookAt folder
% faire touner sleepscoringML pour avoir les NoiseEpoch, GndNoiseEpoch, WeirdNoiseEpoch;

% INPUTS
% SpPplot : if =1, it quantifies ratio btw low and high freqency bands   for  each mouse
% mean_or_med : can be 'mean or 'median'. Parameter used for the ratio quantification
% SessionName : used fot the title of specrogram ex : 'EXTenvC' 'SleepPre'
% Expe : can be 'Sleep' or 'Fear'

params.Fs=1250;
params.tapers=[3 5];
movingwin=[3 0.2];
params.fpass=[0 50];

th_immob=1; % 
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

% mouselist= { 'M231';'M230'};
% DataPath = {'/media/DataMOBs14/ProjetAversion/ManipFeb15Bulbectomie/M231/FEAR-Mouse231-EXTenvC-_150212_140054/FEAR-Mouse-231-12022015-EXTenvC';
%     '/media/DataMOBs14/ProjetAversion/ManipFeb15Bulbectomie/M230/FEAR-Mouse230-EXTenvC-_150212_132714/FEAR-Mouse-230-12022015-EXTenvC'};
% mouselist= { 'M230'};
% DataPath = {'/media/DataMOBsRAID/ProjetAversion/SLEEPM230-231/M230/20150213/FEAR-Mouse-230-231-13022015'};
% structlist={'PFCx_deep'};%;'PFCx_sup';'dHPC_deep'};
% structlist={'PFCx_deep';'PiCx';'dHPC';'Amyg'};
mouselist= { 'M248'};
DataPath = {'/media/DataMOBS23/M248/20150327/FEAR-Mouse-248-27032015-EXTenvB_150327_160117/FEAR-Mouse-248-27032015'};
%DataPath = {'/media/DataMOBS23/M248/20150326/FEAR-Mouse-248-26032015-EXTenvC_150326_155513'};
structlist={'PFCx_EcoG';'PFCx';'PiCx';'dHPC';'Amyg';'OB_deep';'OB_mid';'OB_EcoG';'EMG'};
% mouselist= { 'M247'};
% DataPath = {'/media/DataMOBsRAID/ProjetAversion/DATA-Fear/Mouse247/20150326-EXT-24h-EnvC'};
% structlist={'PFCx_EcoG';'PFCx';'PiCx';'EMG'};%;   % 'Accelero1';'Accelero2';'Accelero3'}; ;'Amyg' ;'dHPC'


file2load= 'behavResources';
nameEpoch{1}='FreezeEpoch';
nameEpoch{2}='NoFreezeEpoch';
PColor={'c', 'k'} ;


for m=1:size(mouselist,1)
    
    mousename=mouselist{m};
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


    for i=1:size(structlist,1)
        filename=[structlist{i} '.mat'];
        cd(DataPath{m})
        
        
        %%%%%%%% load and plot spectrogram // load LFP and compute spectrogram
        channelname=structlist{i};
        channelname(strfind(channelname, '_'))=' ';
        load (['ChannelsToLookAt/' filename])
        k=channel; 
        try 
            load(['SpectrumDataL/Spectrum' num2str(k)],'Sp', 't', 'f') % t en secondes
        catch
            eval(['load LFPData/LFP',num2str(k)])
            [Sp,t,f]=mtspecgramc(Data(LFP),movingwin,params);
            eval(['save SpectrumDataL/Spectrum',num2str(k),' Sp t f']) 
        end
        Stsd=tsd(t*1E4,Sp);

        hfig=figure('Color', [1 1 1], 'Position', [70 700 1800 500]); 
        h_sp=subplot(2,4,1:4); imagesc(t,f,10*log10(Sp')), axis xy
        title([mousename ' ' SessionName ' ' channelname])
        ylim([0 30])
        
        %%%%%%%%%% load epochs of interest
        cd(DataPath{m})

        eval(['load ' file2load ' '  nameEpoch{1} ])
        try
            load StateEpoch MovEpoch NoiseEpoch GndNoiseEpoch WeirdNoiseEpoch
        catch
            NoiseEpoch=intervalSet(0,1);
            GndNoiseEpoch=intervalSet(0,1);
            WeirdNoiseEpoch=intervalSet(0,1);
        end
        eval(['Epoch1=' nameEpoch{1} ]);
        
        % define TotEpoch
        tps=Range(Stsd); %tps est en 10-4sec
        TotEpoch=intervalSet(tps(1),tps(end));
        TotEpoch_length1=sum(End(TotEpoch,'s')-Start(TotEpoch,'s'));
        TotEpoch=TotEpoch-NoiseEpoch-GndNoiseEpoch-WeirdNoiseEpoch;
        TotEpoch_length2=sum(End(TotEpoch,'s')-Start(TotEpoch,'s'));% after noise removal

        % remove noise epochs
        Epoch1=and(Epoch1, TotEpoch);
        Epoch1_length1=sum(End(Epoch1,'s')-Start(Epoch1,'s'));

        Epoch2=TotEpoch-Epoch1;
        Epoch2_length=sum(End(Epoch2,'s')-Start(Epoch2,'s'));
        
        line([Start(subset(Epoch1,1),'s') End(subset(Epoch1,1),'s')],[15 15],'Color',PColor{1},'linewidth',4)
        line([Start(subset(Epoch2,1),'s') End(subset(Epoch2,1),'s')],[16 16],'Color',PColor{2},'linewidth',4)
        legend (nameEpoch{1}(1:end-5),nameEpoch{2}(1:end-5))
        line([Start(sEpoch1,'s') End(Epoch1,'s')],[15 15],'Color',PColor{1},'linewidth',4)
        line([Start(Epoch2,'s') End(Epoch2,'s')],[16 16],'Color',PColor{2},'linewidth',4)

        % restriction of period just before and just after each freezing event to clean up the spectrum
        % if Rogne>0
            Epoch1L=dropShortIntervals(Epoch1, thtps_immob_for_rogne*1E4);
            St=Start(Epoch1L);
            En=End(Epoch1L);
            Epoch1L=Intervalset(St+Rogne*1E4, En-Rogne*1E4); 
            line([Start(Epoch1-Epoch1L,'s') End(Epoch1-Epoch1L,'s')],[15 15],'color','w','linewidth',4)
            Epoch1_length2=sum(End(Epoch1L,'s')-Start(Epoch1L,'s'));% after rognage
        % end
        

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% frequency spectrum 
        figure(hfig) 
        %%%%%%% Drop intervals <2sec
        % raw spectrogram
        subplot(2,4,5), hold on
        for j=1:length(nameEpoch)
            eval(['plot(f,mean(Data(Restrict(Stsd,' nameEpoch{j} '))),PColor{j})'])
            eval(['plot(f,median(Data(Restrict(Stsd,' nameEpoch{j} '))),PColor{j},''LineStyle'',''--'')'])
        end
               
        xlim([0 30]), ylim(Ylimits_raw)
        ylabel('raw')
        title('drop period <2sec')

        % spetrogram normaliszed by 10 log10
        subplot(2,4,6), hold on
        for j=1:length(nameEpoch)
            eval(['plot(f,mean(10*log10(Data(Restrict(Stsd,' nameEpoch{j} ')))),PColor{j})'])
        end
        if strcmp(lower(Expe), 'sleep')
            legend([nameEpoch{1}(1:end-5) ' ' sprintf('%0.0f',Epoch1_length1) 's/ ' sprintf('%0.0f',Epoch1_length2) 's'],[nameEpoch{2}(1:end-5) ' ' sprintf('%0.0f',Epoch2_length) 's'] ,nameEpoch{3}(1:end-5))
        else
            legend([nameEpoch{1}(1:end-5) ' ' sprintf('%0.0f',Epoch1_length1) 's/ ' sprintf('%0.0f',Epoch1_length2) 's'],[nameEpoch{2}(1:end-5) ' ' sprintf('%0.0f',Epoch2_length) 's'] )
        end
        for j=1:length(nameEpoch)
            eval(['plot(f,median(10*log10(Data(Restrict(Stsd,' nameEpoch{j} ')))),PColor{j},''LineStyle'',''--'')'])
        end
        xlim([0 30]), ylim(Ylimits_norm)
        ylabel('normalised 10log10')
        
        
        %%%%%%% Drop intervals <5sec  / ou rogne 2 sec before & after
        % raw spectrogram
        subplot(2,4,7), hold on
        plot(f,mean(Data(Restrict(Stsd,Epoch1L))),PColor{1})
        plot(f,mean(Data(Restrict(Stsd,Epoch2))),PColor{2})
        plot(f,median(Data(Restrict(Stsd,Epoch1L))),PColor{1},'LineStyle','--')
        plot(f,median(Data(Restrict(Stsd,Epoch2))),PColor{2},'LineStyle','--')
        xlim([0 30]), ylim(Ylimits_raw) 
        ylabel('raw')
        title(['rogne ' num2str(Rogne) ' sec before & after']) 
        
        % spetrogram normaliszed by 10 log10
        subplot(2,4,8), hold on
        plot(f,mean(10*log10(Data(Restrict(Stsd,Epoch1L)))),PColor{1})
        plot(f,mean(10*log10(Data(Restrict(Stsd,Epoch2)))),PColor{2})
        plot(f,median(10*log10(Data(Restrict(Stsd,Epoch1L)))),PColor{1},'LineStyle','--')
        plot(f,median(10*log10(Data(Restrict(Stsd,Epoch2)))),PColor{2},'LineStyle','--')
        xlim([0 30]), ylim(Ylimits_norm)
        
        ylabel('normalised 10log10')
        

        %%%%%% compute mean spectro for 2-4 Hz and 6-9 Hz
        % raw
        FreqRang={'low F= ' num2str(freq1) '-' num2str(freq2) 'Hz';'low F= ' num2str(freq3) '-' num2str(freq4) 'Hz'};
        Columns={'No Freeze';'Freeze'};
        a=mean(Data(Restrict(Stsd,Epoch1))); % F
        b=mean(Data(Restrict(Stsd,Epoch2))); % No F        
        NoFratio=mean(b(f>freq1&f<freq2))/mean(b(f>freq3&f<freq4));
        Fratio=mean(a(f>freq1&f<freq2))/mean(a(f>freq3&f<freq4));
        % median
        a_md=median(Data(Restrict(Stsd,Epoch1))); % F
        b_md=median(Data(Restrict(Stsd,Epoch2))); % No F
        NoFratio_md=median(b(f>freq1&f<freq2))/median(b(f>freq3&f<freq4));
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
        c=mean(10*log10(Data(Restrict(Stsd,Epoch1)))); % F
        d=mean(10*log10(Data(Restrict(Stsd,Epoch2)))); % No F
        FratioLog=mean(c(f>freq1&f<freq2))/mean(c(f>freq3&f<freq4));
        NoFratioLog=mean(d(f>freq1&f<freq2))/mean(d(f>freq3&f<freq4));
        FRatioTableLog=[FRatioTableLog; mean(c(f>freq1&f<freq2))  mean(c(f>freq3&f<freq4))  FratioLog ];
        NoFRatioTableLog=[NoFRatioTableLog; mean(d(f>freq1&f<freq2))  mean(d(f>freq3&f<freq4))  NoFratioLog ];

        LowFLog=[LowFLog; mean(d(f>freq1&f<freq2)) mean(c(f>freq1&f<freq2))];
        HighFLog=[HighFLog; mean(d(f>freq3&f<freq4)) mean(c(f>freq3&f<freq4))];
        LowHighRatioLog=[LowHighRatioLog; FratioLog NoFratioLog];


        cd ..
        res=pwd;
        saveas(gcf, [mousename '_' filename(1:end-4) '_Sp_.fig'])
        saveFigure(gcf,[mousename '_' filename(1:end-4) '_Sp_'], res)
    end


    save Ratio FreqRang structlist FRatioTable NoFRatioTable FRatioTableLog NoFRatioTableLog  LowF HighF  LowHighRatio  LowFLog HighFLog  LowHighRatioLog  LowF_md HighF_md  LowHighRatio_md

    %%%%%%%%%%%%%%%  quantify ratio btw low and high freqency bands 
    %%%%%%%%%%%%%%%  for  each mouse
    if SpPplot
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
    end

end

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
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%%%%%%%%%%%%%%% For Sleep Data : spectrogram for wake/ SWS/ REM
% 
% 
% load StateEpoch SWSEpoch MovEpoch REMEpoch NoiseEpoch GndNoiseEpoch WeirdNoiseEpoch
%         % define TotEpoch
%         tps=Range(Stsd); %tps est en 10-4sec
%         TotEpoch=intervalSet(tps(1),tps(end));
%         TotEpoch_length1=sum(End(TotEpoch,'s')-Start(TotEpoch,'s'));
%         TotEpoch=TotEpoch-NoiseEpoch-GndNoiseEpoch-WeirdNoiseEpoch;
%         TotEpoch_length2=sum(End(TotEpoch,'s')-Start(TotEpoch,'s'));% after noise removal
%         
% load StateEpoch SWSEpoch MovEpoch REMEpoch NoiseEpoch GndNoiseEpoch WeirdNoiseEpoch
% SWSEpoch=SWSEpoch-NoiseEpoch-GndNoiseEpoch-WeirdNoiseEpoch;
% REMEpoch=REMEpoch-NoiseEpoch-GndNoiseEpoch-WeirdNoiseEpoch;
% MovEpoch=MovEpoch-NoiseEpoch-GndNoiseEpoch-WeirdNoiseEpoch;
% figure('color',[1 1 1]), 
% % raw spectrogram
% subplot(1,2,1), hold on
% plot(f,mean(Data(Restrict(Stsd,MovEpoch))),PColor{2})
% plot(f,mean(Data(Restrict(Stsd,SWSEpoch))),'b')
% plot(f,mean(Data(Restrict(Stsd,REMEpoch))),'r')
% % spetrogram normaliszed by 10 log10
% subplot(1,2,2), hold on
% plot(f,mean(10*log10(Data(Restrict(Stsd,MovEpoch)))),PColor{2}), xlim([0 50])
% plot(f,mean(10*log10(Data(Restrict(Stsd,SWSEpoch)))),'b'), xlim([0 50])
% plot(f,mean(10*log10(Data(Restrict(Stsd,REMEpoch)))),'r'), xlim([0 50])
% legend('Mov', 'SWS','REM')
% 
% % 
% % % compute coherogram
% [C,phi,S12,S1,S2,t,f]=cohgramc(Data(LFP0),Data(LFP3),movingwin,params);

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   lignes code Karim à
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   reprendre propre
% 
% load behavResources FreezEpoch
% Warning: Variable 'FreezEpoch' not found. 
% load behavResources FreezeEpoch
% figure, plot(f,mean(C),PColor{2})
% hold on, plot(f,mean(Data(Restrict(Ctsd,FreezeEpoch))),'r')
% figure, imagesc(t,f,SmoothDec(C',[1 1]))
% params.tapers=[1 2];
% [C,phi,S12,S1,S2,t,f]=cohgramc(Data(LFP0),Data(LFP3),movingwin,params);
% figure, imagesc(t,f,SmoothDec(C',[1 1])), axis xy
% params.tapers=[5 9];
% [C,phi,S12,S1,S2,t,f]=cohgramc(Data(LFP0),Data(LFP3),movingwin,params);
% figure, imagesc(t,f,SmoothDec(C',[1 1])), axis xy
% figure, plot(f,mean(C),PColor{2})
% hold on, plot(f,mean(Data(Restrict(Ctsd,FreezeEpoch))),'r')
% load('/media/DataMOBs14/ProjetAversion/ManipFeb15Bulbectomie/M230/FEAR-Mouse230-EXTenvC-_150212_132714/FEAR-Mouse-230-12022015-EXTenvC/LFPData/LFP7.mat')
% [C,phi,S12,S1,S2,t,f]=cohgramc(Data(LFP0),Data(LFP),movingwin,params);
% figure, imagesc(t,f,SmoothDec(C',[1 1])), axis xy
% figure, plot(f,mean(C),PColor{2})
% hold on, plot(f,mean(Data(Restrict(Ctsd,FreezeEpoch))),'r')
% figure, plot(f,mean(C),PColor{2})
% Ctsd=tsd(t*1E4,C);
% hold on, plot(f,mean(Data(Restrict(Ctsd,FreezeEpoch))),'r')
% line([Start(FreezeEpoch,'s') End(FreezeEpoch,'s')],[30 30],'color',PColor{2},'linewidth',8)
% figure, imagesc(t,f,SmoothDec(phi',[1 1])), axis xy
% colormap(hsv)
% hold on
% line([Start(FreezeEpoch,'s') End(FreezeEpoch,'s')],[30 30],'color',PColor{2},'linewidth',8)
% 
% 

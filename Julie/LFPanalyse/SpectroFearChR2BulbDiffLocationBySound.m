% SpectroFearChR2BulbDiffLocationsBySound.m
% 23.08.016
% from SpectroFearChR2 but aims at evaluating the efficiency of laser stim
% in the different bulb location

% from SpectroFearML_JL.m
% for mouse 363 and 367 (fear EXT 24 48 72 + laser stim)

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% %%%%%%%%%%%%%%%%%%  INPUTS  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear
close all

cd /media/DataMOBsRAID/ProjetAversion/DATA-Fear

experiment= 'Fear-electrophy';

plo=0;
mean_or_med='mean';
SpPplot=0;

[params,movingwin,suffix]=SpectrumParametersML('low'); % low or high

th_immob=1; % default 1
thtps_immob=2; % minimum 2 sec of immobility
Rogne=2; % rognage des evenementde freezing
thtps_immob_for_rogne=4; % a ajuster en fonction de 'Rogne'
Ylimits_raw=[0 5E4];
Ylimits_norm=[20 60];
th_for_plot=2; %Spectrogram is not plotted if computed for less than 30sec 
% define frequency bands
freq1=3;
freq2=4;
freq3=6;
freq4=9;
%structlist={'PFCx_deep','Bulb_deep','dHPC_deep'};%,'Amyg'%,'PiCx'
structlist={'Bulb_right','Bulb_1-3_right','Bulb_ventral_right','Bulb_sup_left','Bulb_left','Bulb_ventral_left'};%,'Amyg'%,'PiCx' Bulb_left'PFCx_right'

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% %%%%%%%%%%%%%%%%%%  INITIALIZATION  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Dir=PathForExperimentFEAR(experiment);
Dir = RestrictPathForExperiment(Dir,'nMice',[363]);
Treatment='laser4';%'laser4'
if ~isempty(Treatment)
    Dir=RestrictPathForExperiment(Dir,'Treatment',Treatment);
end
[nameMice, IXnameMice]=unique(Dir.name);
%LaserState={'ON', 'OFF'};
nameGroups={'OBX', 'CTRL'};

TotalStimNb=8;
MatSpFON=nan(TotalStimNb,length(structlist),67); % avant 164
MatSpNoFON= MatSpFON;   MatInfoON=nan(TotalStimNb,length(structlist),4); 

MatSpFOFF=nan(TotalStimNb,length(structlist),67); % avant 164
MatSpNoFOFF= MatSpFOFF;   MatInfoOFF=nan(TotalStimNb,length(structlist),4); 

try
    load(['DataSpectro_ChR2_BulbDiffLoc_BySound_' Treatment ]);MatInfo;
    disp(['Loading existing data from DataSpectro_ChR2_BulbDiffLoc_BySound_' Treatment '.mat']);
    [B,IX] = sort(Dir.group);
    Dir.path=Dir.path(IX);
    Dir.name=Dir.name(IX);
    Dir.manipe=Dir.manipe(IX);
    Dir.group=B;
    Dir.Session=Dir.Session(IX);
    [nameMice, IXnameMice]=unique(Dir.name);
    IX2=sort(IXnameMice);
    nameMice=nameMice(IX_IX2);

catch
    for i=1:length(structlist), allfig(i)=figure('Color',[1 1 1],'Position', [100 10 1600 900]);end
        StrucListTitle=zeros(size(structlist));
        for man=1:length(Dir.path)
            if ~isempty(strfind(Dir.path{man},'EXT'))


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

                    temp=load([Dir.path{man},'/ChannelsToAnalyse/',structlist{i},'.mat']);
                    if isempty(temp.channel) || isnan(temp.channel),error;end


                    try
                        load([Dir.path{man},'/SpectrumDataL/Spectrum' num2str(temp.channel),'.mat'],'Sp', 't', 'f') % t en secondes
                        disp(['SpectrumDataL/Spectrum' num2str(temp.channel),'... loaded'])
                    catch
                        if ~exist([Dir.path{man},'/SpectrumDataL'],'dir'), mkdir([Dir.path{man},'/SpectrumDataL']);end
                        eval(['temp2=load(''',Dir.path{man},'/LFPData/LFP',num2str(temp.channel),'.mat'');'])
                        disp(['Computing SpectrumDataL/Spectrum' num2str(temp.channel),'... '])
                        [Sp,t,f]=mtspecgramc(Data(temp2.LFP),movingwin,params);
                        eval(['save(''',Dir.path{man},'/SpectrumDataL/Spectrum',num2str(temp.channel),'.mat'',','''Sp'',','''t'',','''f'',','''params'',','''movingwin'');'])
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
                    eval(['temp2=load(''',Dir.path{man},'/behavResources.mat'',''FreezeEpoch'',''Movtsd'',''StimLaserON'',''StimLaserOFF'',''TTL'');']);
                    Movtsd=temp2.Movtsd; %, attention valable seulement pour file comportment car fichier sleep= doubletracking=pixratio pas appliqué 
                    StimLaserON=temp2.StimLaserON;
                    StimLaserOFF=temp2.StimLaserOFF;
                    FreezeEpoch=thresholdIntervals(Movtsd,th_immob,'Direction','Below');
                    FreezeEpoch=mergeCloseIntervals(FreezeEpoch,0.3*1E4);
                    FreezeEpoch=dropShortIntervals(FreezeEpoch,thtps_immob*1E4);
                    FreezeEpochStimON=And(FreezeEpoch,StimLaserON);
                    FreezeEpochStimOFF=And(FreezeEpoch,StimLaserOFF);

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


               % try
                    % spetrum restricted on FreezeEpoch
                    [tEpoch, SpEpoch]=SpectroEpochML(Sp,t,f,FreezeEpoch,0);


                    % regroup by structures for all mice
                    figure(allfig(i)), subplot(ceil(sqrt(length(Dir.path))),ceil(sqrt(length(Dir.path))),man)
                    imagesc(tEpoch,f,10*log10(SpEpoch')), axis xy, caxis([15 65])
                    title([Dir.group{man},' ',Dir.path{man}(end-31:end)]), ylabel('Frequency (Hz)'); xlabel('Time (s)')
                    ylim([0 20]);  xlim([0 200])
                    %%%%%%%%% A FAIRE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                    % ploter les epoch où le laser est ON
                    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                    %if man==1, text(0,26,structlist{i});ylabel([structlist{i} ' ' Treatment]);end; 

                    while StrucListTitle(i)==0
                        X=xlim;Y=ylim;
                        text(X(1)-0.3*(X(2)-X(1)),Y(2)+0.2*(Y(2)-Y(1)),structlist{i})
                        StrucListTitle(i)=1;
                    end
                    xlabel([ sprintf('%0.0f',tot_length(FreezeEpoch,'s')) ' s']);
                    hold on, line([0 200],[5 5],'Color',[0.5 0.5 0.5])

                    % save in matrice
                    if length(f)>67%164
                        load f_0-20;
                        for StimNb=2:length(Start(StimLaserON))-1

                            %MatSpF(man,i,1:length(f1))= interp1(f,mean(Data(Restrict(Stsd,FreezeEpoch))),f1);
                            %MatSpNoF(man,i,1:length(f1))=interp1(f,mean(Data(Restrict(Stsd,TotEpoch-FreezeEpoch))),f1);
                            MatSpFON(StimNb,i,:)= interp1(f,mean(Data(Restrict(Stsd,And(FreezeEpoch,subset(StimLaserON,StimNb))))),f1);
                            MatSpNoFON(StimNb,i,:)=interp1(f,mean(Data(Restrict(Stsd,And(TotEpoch-FreezeEpoch,subset(StimLaserON,StimNb))))),f1);
                            MatSpFOFF(StimNb,i,:)= interp1(f,mean(Data(Restrict(Stsd,And(FreezeEpoch,subset(StimLaserOFF,StimNb))))),f1);
                            MatSpNoFOFF(StimNb,i,:)=interp1(f,mean(Data(Restrict(Stsd,And(TotEpoch-FreezeEpoch,subset(StimLaserOFF,StimNb))))),f1);
                            
                        end
                        f=f1;
                    else
                        for StimNb=2:length(Start(StimLaserON))-1
                            MatSpFON(StimNb,i,1:length(f))=mean(Data(Restrict(Stsd,And(FreezeEpoch,subset(StimLaserON,StimNb)))));
                            MatSpNoFON(StimNb,i,1:length(f))=mean(Data(Restrict(Stsd,And(TotEpoch-FreezeEpoch,subset(StimLaserON,StimNb)))));
                            MatSpFOFF(StimNb,i,1:length(f))=mean(Data(Restrict(Stsd,And(FreezeEpoch,subset(StimLaserOFF,StimNb)))));
                            MatSpNoFOFF(StimNb,i,1:length(f))=mean(Data(Restrict(Stsd,And(TotEpoch-FreezeEpoch,subset(StimLaserOFF,StimNb)))));
                            disp(Dir.path{man})
                        end
                    end
                    for StimNb=2:length(Start(StimLaserON))-1

                        MatInfoON(StimNb-1,i,1:4)=[find(strcmp(Dir.group{man},nameGroups)),...
                            find(strcmp(Dir.name{man},nameMice)),tot_length(subset(StimLaserON,StimNb),'s'),tot_length(And(TotEpoch-FreezeEpoch,subset(StimLaserON,StimNb)),'s')];
                        MatInfoOFF(StimNb-1,i,1:4)=[find(strcmp(Dir.group{man},nameGroups)),...
                            find(strcmp(Dir.name{man},nameMice)),tot_length(subset(StimLaserOFF,StimNb),'s'),tot_length(And(TotEpoch-FreezeEpoch,subset(StimLaserOFF,StimNb)),'s')];
                    end

                    %%%%%% compute mean spectro for 2-4 Hz and 6-9 Hz
                    % raw
                    if 0
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
                    end
%                 catch
%                     if exist('Stsd','var'), disp('Problem saving matrices'); end
%                 end

            end
            %save Ratio FreqRang structlist FRatioTable NoFRatioTable FRatioTableLog NoFRatioTableLog  LowF HighF  LowHighRatio  LowFLog HighFLog  LowHighRatioLog  LowF_md HighF_md  LowHighRatio_md

            %%%%%%%%%%%%%%%  quantify ratio btw low and high freqency bands
            %%%%%%%%%%%%%%%  for  each mouse
            if SpPplot
                try
                    figure('Color',[1 1 1], 'Position', [100 100 500 900]);
                    subplot(3,1,1);
                    bar(LowF);
                    set(gca, 'XTickLabel', structlist)
                    title([num2str(freq1) '-' num2str(freq2) ' Hz']);
                    ymaxi=Ylim;
                    text(0.1, ymaxi(2)*1.1, mousename)
                    text(0.1, ymaxi(2), 'mean')

                    subplot(3,1,2);
                    bar(HighF);
                    set(gca, 'XTickLabel', structlist)
                    title([num2str(freq3) '-' num2str(freq4) 'Hz'])

                    subplot(3,1,3);
                    bar(10*log10(LowHighRatio));
                    set(gca, 'XTickLabel', structlist)
                    title([num2str(freq1) '-' num2str(freq2) 'Hz / ' num2str(freq3) '-' num2str(freq4) 'Hz ratio']);

                    legend('No Freeze', 'Freeze');
                    res=pwd;
                    saveas(gcf, [mousename 'Ratio_mean.fig'])
                    saveFigure(gcf,[mousename 'Ratio_mean'], res)
                catch
                    close;
                end
            end
            size(MatSpFON);
        end
    end
    disp(['Saving data in local path, DataSpectro_ChR2_BulbDiffLoc_BySound_' Treatment ]);
    save (['DataSpectro_ChR2_BulbDiffLoc_BySound_' Treatment ], 'MatInfoON','MatSpFON','MatSpNoFON', 'MatInfoOFF','MatSpFOFF','MatSpNoFOFF','params','structlist','nameMice','nameGroups','Dir','f','th_immob','thtps_immob','Rogne','thtps_immob_for_rogne')
    for i=1:length(structlist), saveas (allfig(i), [pwd '/SpFreez_363_',structlist{i},'_',Treatment]),saveFigure(allfig(i),['SpFreez_allMice_',structlist{i},'_',Treatment],pwd);end

end

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% %%%%%%%%%%%%%%%%%%%%  MEAN SPECTRA  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% remove data for Epoch below th_for plot (mimimum time window to take into consideration) : transform into NaN
for i=1:length(structlist)
    SpInfoON=squeeze(MatInfoON(:,i,:));
    SpInfoOFF=squeeze(MatInfoOFF(:,i,:));
    for StimNb=1:TotalStimNb
        if SpInfoON(StimNb,3)<th_for_plot
            MatSpFON(StimNb,i,1:length(f))=NaN;
            MatSpFOFF(StimNb,i,1:length(f))=NaN;
        end
        if SpInfoON(StimNb,4)<th_for_plot
            MatSpNoFON(StimNb,i,1:length(f))=NaN;
            MatSpNoFOFF(StimNb,i,1:length(f))=NaN;
        end        
    end
end

%% superpose group spectra for conditions
figure('Color',[1 1 1],'Position', [100 10 1600 900])
%colori=jet(length(nameMice));
%colori=jet(length(Dir.path));
colori=jet(TotalStimNb);
colori=colori-0.1;
colori(colori<0)=0;
namecolmn={'Freezing','No Freezing','Freezing','No Freezing'};
% name MatInfo: nGroup nMice duration(FreezeEpoch) duration(TotEpoch-FreezeEpoch);
clear SpF SpNoF SpInfo

%%%% RIGHT STIM 1->4
for i=1:length(structlist)
    if ~isempty(strfind(structlist{i},'Bulb')), yl=[0 5E5];elseif strcmp(structlist{i},'dHPC'), yl=[0 2E5]; else, yl=[0 6E4];end
    SpFON=squeeze(MatSpFON(:,i,:));
    SpNoFON=squeeze(MatSpNoFON(:,i,:));
    SpInfoON=squeeze(MatInfoON(:,i,:));
    SpFOFF=squeeze(MatSpFOFF(:,i,:));
    SpNoFOFF=squeeze(MatSpNoFOFF(:,i,:));
    SpInfoOFF=squeeze(MatInfoOFF(:,i,:));
    legF=[];legNoF=[];
    for StimNb=1:4
        try
            if SpInfoON(StimNb,3)>th_for_plot  
                try subplot(a1),catch,a1=subplot(length(structlist),4,4*(i-1)+1);hold on,end
                %plot(f,SpFON(StimNb,:),'Color',colori(SpInfoON(StimNb,2),:),'LineStyle','--');
                plot(f,SpFON(StimNb+1,:),'Color',colori(StimNb,:),'LineStyle','--','LineWidth',2);
                ylabel(structlist{i});% ylim(yl);xlim([0 20]);
                legF=[legF,{[Dir.name{man}([1,6:8]),' ',num2str(floor(SpInfoON(StimNb,3))),'s']}];
            end
            if SpInfoOFF(StimNb,3)>th_for_plot          
                subplot(length(structlist),4,4*(i-1)+1),hold on,
                %plot(f,SpFOFF(StimNb,:),'Color',colori(SpInfoOFF(StimNb,2),:),'LineStyle','-');
                plot(f,SpFOFF(StimNb+1,:),'Color',colori(StimNb,:),'LineStyle','-','LineWidth',2);
                ylabel(structlist{i}); 
                %ylim(yl);xlim([0 20]);
                legF=[legF,{[Dir.name{man}([1,6:8]),' ',num2str(floor(SpInfoOFF(StimNb,3))),'s']}];
            end
        end
        try
            if SpInfoON(StimNb,4)>th_for_plot  
                subplot(length(structlist),4,4*(i-1)+2),hold on,
                %plot(f,SpNoFON(StimNb,:),'Color',colori(SpInfoON(StimNb,2),:),'LineStyle','--');
                plot(f,SpNoFON(StimNb+1,:),'Color',colori(StimNb,:),'LineStyle','--','LineWidth',2);
                %ylim(yl);xlim([0 20]);
                legNoF=[legNoF,{[Dir.name{man}([1,6:8]),' ',num2str(floor(SpInfoON(StimNb,4))),'s']}];
            end
            if SpInfoOFF(StimNb,4)>th_for_plot  
                subplot(length(structlist),4,4*(i-1)+2),hold on,
                %plot(f,SpNoFOFF(StimNb,:),'Color',colori(SpInfoOFF(StimNb,2),:),'LineStyle','-');
                plot(f,SpNoFOFF(StimNb+1,:),'Color',colori(StimNb,:),'LineStyle','-','LineWidth',2);
                %ylim(yl);xlim([0 20]);
                legNoF=[legNoF,{[Dir.name{man}([1,6:8]),' ',num2str(floor(SpInfoOFF(StimNb,4))),'s']}];
            end
        end
    end
    subplot(length(structlist),6,6*(i-1)+[1:2]), legend(legF,'Location','EastOutside');
    title(namecolmn{1})
    if i==length(structlist), 
        xlabel('Frequency (Hz)');
        Y=ylim;
        text(0,Y(1)-0.5*(Y(2)-Y(1)), ['minimum time to take into account an epoch : ' num2str(th_for_plot) ' sec'])
    end
    if i==1
        X=xlim;Y=ylim;
        text(X(1)-0.5*(X(2)-X(1)),Y(2)+0.2*(Y(2)-Y(1)), Treatment)
    end
    subplot(length(structlist),6,6*(i-1)+[3:4]), legend(legNoF,'Location','EastOutside');
    title(namecolmn{2})
    if i==length(structlist), 
        xlabel('Frequency (Hz)');
    end


end


%%%% RIGHT STIM 4-> 8
for i=1:length(structlist)
    if ~isempty(strfind(structlist{i},'Bulb')), yl=[0 5E5];elseif strcmp(structlist{i},'dHPC'), yl=[0 2E5]; else, yl=[0 6E4];end
    SpFON=squeeze(MatSpFON(:,i,:));
    SpNoFON=squeeze(MatSpNoFON(:,i,:));
    SpInfoON=squeeze(MatInfoON(:,i,:));
    SpFOFF=squeeze(MatSpFOFF(:,i,:));
    SpNoFOFF=squeeze(MatSpNoFOFF(:,i,:));
    SpInfoOFF=squeeze(MatInfoOFF(:,i,:));
    legF=[];legNoF=[];
    for StimNb=5:TotalStimNb
        try
            if SpInfoON(StimNb,3)>th_for_plot          
                subplot(length(structlist),4,4*(i-1)+3),hold on,
                %plot(f,SpFON(StimNb,:),'Color',colori(SpInfoON(StimNb,2),:),'LineStyle','--');
                plot(f,SpFON(StimNb+1,:),'Color',colori(StimNb,:),'LineStyle','--','LineWidth',2);
                ylabel(structlist{i}); ylim(yl);xlim([0 20]);
                legF=[legF,{[Dir.name{man}([1,6:8]),' ',num2str(floor(SpInfoON(StimNb,3))),'s']}];
            end
            if SpInfoOFF(StimNb,3)>th_for_plot          
                subplot(length(structlist),4,4*(i-1)+3),hold on,
                %plot(f,SpFOFF(StimNb,:),'Color',colori(SpInfoOFF(StimNb,2),:),'LineStyle','-');
                plot(f,SpFOFF(StimNb+1,:),'Color',colori(StimNb,:),'LineStyle','-','LineWidth',2);
                ylabel(structlist{i}); ylim(yl);xlim([0 20]);
                legF=[legF,{[Dir.name{man}([1,6:8]),' ',num2str(floor(SpInfoOFF(StimNb,3))),'s']}];
            end
        end
        try
            if SpInfoON(StimNb,4)>th_for_plot  
                subplot(length(structlist),4,4*(i-1)+4),hold on,
                %plot(f,SpNoFON(StimNb,:),'Color',colori(SpInfoON(StimNb,2),:),'LineStyle','--');
                plot(f,SpNoFON(StimNb+1,:),'Color',colori(StimNb,:),'LineStyle','--','LineWidth',2);
                ylim(yl);xlim([0 20]);
                legNoF=[legNoF,{[Dir.name{man}([1,6:8]),' ',num2str(floor(SpInfoON(StimNb,4))),'s']}];
            end
            if SpInfoOFF(StimNb,4)>th_for_plot  
                subplot(length(structlist),4,4*(i-1)+4),hold on,
                %plot(f,SpNoFOFF(StimNb,:),'Color',colori(SpInfoOFF(StimNb,2),:),'LineStyle','-');
                plot(f,SpNoFOFF(StimNb+1,:),'Color',colori(StimNb,:),'LineStyle','-','LineWidth',2);
                ylim(yl);xlim([0 20]);
                legNoF=[legNoF,{[Dir.name{man}([1,6:8]),' ',num2str(floor(SpInfoOFF(StimNb,4))),'s']}];
            end
        end
    end
    subplot(length(structlist),6,6*(i-1)+[1:2]), legend(legF,'Location','EastOutside');
    title(namecolmn{1})
    if i==length(structlist), 
        xlabel('Frequency (Hz)');
        Y=ylim;
        text(0,Y(1)-0.5*(Y(2)-Y(1)), ['minimum time to take into account an epoch : ' num2str(th_for_plot) ' sec'])
    end
    if i==1
        X=xlim;Y=ylim;
        text(X(1)-0.5*(X(2)-X(1)),Y(2)+0.2*(Y(2)-Y(1)), Treatment)
    end
    subplot(length(structlist),6,6*(i-1)+[3:4]), legend(legNoF,'Location','EastOutside');
    title(namecolmn{2})
    if i==length(structlist), 
        xlabel('Frequency (Hz)');
    end


end

clear SpF SpNoF  tempSpF temp tempSpNoF 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%%%%%%%%%%%%%%%%%% pool mice before pooling groups %%%%%%%%%%%%%%%%%%%%
for mi=1:length(nameMice)
    for i=1:length(structlist)
        ind=find(strcmp(Dir.name,nameMice{mi}));
        %try
            temp=squeeze(MatSpFON(ind,i,:)); if length(ind)==1,temp=temp';end
            tempSpFON(mi,i,1:length(f))=nanmean(temp,1);
            temp=squeeze(MatSpNoFON(ind,i,:)); if length(ind)==1,temp=temp';end
            tempSpNoFON(mi,i,1:length(f))=nanmean(temp,1);
            infoG(mi,i)=unique(Dir.group(ind));
            
            temp=squeeze(MatSpFOFF(ind,i,:)); if length(ind)==1,temp=temp';end
            tempSpFOFF(mi,i,1:length(f))=nanmean(temp,1);
            temp=squeeze(MatSpNoFOFF(ind,i,:)); if length(ind)==1,temp=temp';end
            tempSpNoFOFF(mi,i,1:length(f))=nanmean(temp,1);
            infoG(mi,i)=unique(Dir.group(ind));
        %end
    end
end

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%%%%%%%%%%%%%%%%%% pool mice in groups %%%%%%%%%%%%%%%%%%%%
for gg=1:length(nameGroups),
    ind=Dir.name(find(strcmp(Dir.group,nameGroups{gg})));
    namecolmn=[namecolmn,{[nameGroups{gg},' (n=',num2str(sum(strcmp(infoG(:,1),nameGroups{gg}))),')']}];
end

colorG={'r', 'b', 'k'};
for i=1:length(structlist)
    NmiceF=nan(1,length(nameGroups));
    NmiceNoF=nan(1,length(nameGroups));
    if ~isempty(strfind(structlist{i},'Bulb')), yl=[0 3E5];elseif strcmp(structlist{i},'dHPC'), yl=[0 2E5]; else, yl=[0 6E4];end
    for gg=1:length(nameGroups)
        ind=find(strcmp(infoG(:,i),nameGroups{gg}));
        if ~isempty(ind)
            SpFON=squeeze(tempSpFON(ind,i,:)); if length(ind)==1,SpFON=SpFON';end
            SpNoFON=squeeze(tempSpNoFON(ind,i,:)); if length(ind)==1,SpNoFON=SpNoFON';end
            NmiceF(gg)=sum(~isnan(SpFON(:,2)),1);
            NmiceNoF(gg)=sum(~isnan(SpNoFON(:,2)),1);

            ind=find(strcmp(infoG(:,i),nameGroups{gg}));
            SpFOFF=squeeze(tempSpFOFF(ind,i,:)); if length(ind)==1,SpFOFF=SpFOFF';end
            SpNoFOFF=squeeze(tempSpNoFOFF(ind,i,:)); if length(ind)==1,SpNoFOFF=SpNoFOFF';end
            NmiceF(gg)=sum(~isnan(SpFOFF(:,2)),1);
            NmiceNoF(gg)=sum(~isnan(SpNoFOFF(:,2)),1);

            subplot(length(structlist),6,6*(i-1)+5),hold on,
            %plot(f,nanmean(SpF,1),'Color',colorG{gg},'Linewidth',2);ylim(yl);xlim([0 20]);
            %plot(f,nanmedian(SpFON,1),':','Color',colorG{gg},'Linewidth',1);
            if length(nanstd(SpFON,1))>1
                H=shadedErrorBar(f,nanmean(SpFON,1),nanstd(SpFON,1)./sqrt(sum(~isnan(SpFON(:,2)))),{'Color','r','Linewidth',2},1);
                H=shadedErrorBar(f,nanmean(SpFOFF,1),nanstd(SpFOFF,1)./sqrt(sum(~isnan(SpFOFF(:,2)))),{'Color','b','Linewidth',2},1);
                set(get(get(H.mainLine,'Annotation'),'LegendInformation'),'IconDisplayStyle','off');
                set(get(get(H.patch,'Annotation'),'LegendInformation'),'IconDisplayStyle','off');
                set(get(get(H.edge(1),'Annotation'),'LegendInformation'),'IconDisplayStyle','off');
                set(get(get(H.edge(2),'Annotation'),'LegendInformation'),'IconDisplayStyle','off');
            else
                H=plot(f,nanmean(SpFON,1),'Color','r','Linewidth',2);
                H=plot(f,nanmean(SpFOFF,1),'Color','b','Linewidth',2);
            end
            

            subplot(length(structlist),6,6*i),hold on,
            %plot(f,nanmean(SpNoF,1),'Color',colorG{gg},'Linewidth',2);
            %plot(f,nanmedian(SpNoFON,1),'--','Color',colorG{gg},'Linewidth',1);
            if length(nanstd(SpNoFON,1))>1
                H=shadedErrorBar(f,nanmean(SpNoFON,1),nanstd(SpNoFON,1)./sqrt(sum(~isnan(SpNoFON(:,2)))),{'Color','r','Linewidth',2},1);
                H=shadedErrorBar(f,nanmean(SpNoFOFF,1),nanstd(SpNoFOFF,1)./sqrt(sum(~isnan(SpNoFOFF(:,2)))),{'Color','b','Linewidth',2},1);
                set(get(get(H.mainLine,'Annotation'),'LegendInformation'),'IconDisplayStyle','off');
                set(get(get(H.patch,'Annotation'),'LegendInformation'),'IconDisplayStyle','off');
                set(get(get(H.edge(1),'Annotation'),'LegendInformation'),'IconDisplayStyle','off');
                set(get(get(H.edge(2),'Annotation'),'LegendInformation'),'IconDisplayStyle','off');
            else
                H=plot(f,nanmean(SpNoFON,1),'Color','r','Linewidth',2);
                H=plot(f,nanmean(SpNoFOFF,1),'Color','b','Linewidth',2);
            end
        end
    end
    
    ylim(yl);xlim([0 20]); %legend(nameGroups);
    subplot(length(structlist),6,6*(i-1)+5),hold on,
    ylim(yl);xlim([0 20]); 
    xlabel([ num2str(NmiceNoF(2)) ' mice'])
    subplot(length(structlist),6,6*i),hold on,
    ylim(yl);xlim([0 20]); 
    if i==length(structlist), 
        xlabel([ num2str(NmiceF(2)) ' mice, red ON blue OFF'])
    else
        xlabel([ num2str(NmiceNoF(2)) ' mice'])
    end
end
for si=5:6,  subplot(length(structlist),6,si), title(namecolmn{si-4});end;
%for si=5:6,  subplot(length(structlist),6,(length(structlist)-1)*6+si), xlabel('Frequency (Hz)');end;
saveas (gcf, [pwd '/Sp_AllStt_laserON-OFF_' Treatment '.fig'])
saveFigure(gcf, ['Sp_AllStt_laserON-OFF_' Treatment ],pwd)

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
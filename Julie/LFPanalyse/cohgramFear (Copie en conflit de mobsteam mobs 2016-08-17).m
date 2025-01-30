%cohgramFear.m


% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% %%%%%%%%%%%%%%%%%%  INPUTS  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

experiment= 'Fear-electrophy';
%experiment='ManipFeb15Bulbectomie';

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
th_for_plot=10; %Spectrogram is not plotted if computed for less than 30sec 
fqmax_for_plot=10;
timemax_for_plot=400;
cohmin_for_plot=0.4;
% define frequency bands
freq1=3;
freq2=4;
freq3=6;
freq4=9;
% struct2comp='PFCx_deep';
% structlist={'Bulb_deep','dHPC_rip','PiCx','Amyg'};
% struct2comp='Bulb_deep';
% structlist={'PFCx_deep','dHPC_rip','PiCx','Amyg'};
struct2comp='PFCx_deep';
structlist={'PiCx','Bulb_deep','dHPC_rip','Amyg'};

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% %%%%%%%%%%%%%%%%%%  INITIALIZATION  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Dir=PathForExperimentFEAR(experiment);
%nameSession=unique(Dir.Session);

% nameGroups=unique(Dir.group);
% nameGroups=[nameGroups(~strcmp(nameGroups,'CTRL')),nameGroups(strcmp(nameGroups,'CTRL'))];
nameGroups={'OBX', 'CTRL'};

Dir.path=Dir.path(strcmp(Dir.group, 'OBX') |strcmp(Dir.group, 'CTRL'));
Dir.name=Dir.name(strcmp(Dir.group, 'OBX') |strcmp(Dir.group, 'CTRL'));
Dir.manipe=Dir.manipe(strcmp(Dir.group, 'OBX') |strcmp(Dir.group, 'CTRL'));
Dir.group=Dir.group(strcmp(Dir.group, 'OBX') |strcmp(Dir.group, 'CTRL'));
Dir.Session=Dir.Session(strcmp(Dir.group, 'OBX') |strcmp(Dir.group, 'CTRL'));

% sort Dir by group
[B,IX] = sort(Dir.group);
Dir.path=Dir.path(IX);
Dir.name=Dir.name(IX);
Dir.manipe=Dir.manipe(IX);
Dir.group=B;
Dir.Session=Dir.Session(IX);

% obtain nameMice in the same order as Dir.name (which is sorted by group)
[nameMice, IXnameMice]=unique(Dir.name);
[IX2, IX_IX2]=sort(IXnameMice);
nameMice=nameMice(IX_IX2);

first=1;
   MatInfo=nan(length(Dir.path),length(structlist),4);  

try
    load(['CohgramcFreezing' suffix '_' struct2comp]);MatInfo;
    disp(['Loading existing data from Cohgramc' suffix 'Freezing.mat']);
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
        % load LFP of PFCx_deep
        try
        ch2comp=load([Dir.path{man},'/ChannelsToAnalyse/',struct2comp,'.mat']);
        if ~size(ch2comp.channel,1)==0

            LFP1=load([Dir.path{man},'/LFPData/LFP' num2str(ch2comp.channel),'.mat']);
            LFP1=LFP1.LFP;

            for i=1:length(structlist)
                disp(['    ',structlist{i}])
                clear C t Ctsd phi
                titleok(i,man)=1;

                %%%%%%%% load and plot spectrogram // load LFP and compute spectrogram
                try
                    if strcmp(structlist{i},'dHPC')
                        %try tempt=load([Dir.path{man},'/ChannelsToAnalyse/dHPC_sup.mat']); if ~isempty(tempt.channel);temp=tempt;end;end 
                        %try tempt=load([Dir.path{man},'/ChannelsToAnalyse/dHPC_deep.mat']); if ~isempty(tempt.channel);temp=tempt;end;end   
                        try tempt=load([Dir.path{man},'/ChannelsToAnalyse/dHPC_rip.mat']); if ~isempty(tempt.channel);temp=tempt;end;end 
                    else
                        temp=load([Dir.path{man},'/ChannelsToAnalyse/',structlist{i},'.mat']);
                    end
                    %disp(num2str(temp.channel))
                    if isempty(temp.channel) || isnan(temp.channel),error;end


                    try
                        try
                            Ctemp=load([Dir.path{man},'/CohgramcData' suffix '/Cohgram_' num2str(ch2comp.channel),'_', num2str(temp.channel) '.mat']);
                        catch
                            Ctemp=load([Dir.path{man},'/CohgramcData' suffix '/Cohgram_' num2str(temp.channel),'_', num2str(ch2comp.channel) '.mat']);
                        end
                        disp(['CohgramcData' suffix '/Cohgram_' num2str(ch2comp.channel),'_', num2str(temp.channel) ,'... loaded'])
                        t=Ctemp.t;
                        f=Ctemp.f;
                        C=Ctemp.C;
                        phi=Ctemp.phi;
                        confC=Ctemp.confC;
                    catch
                        if ~exist([Dir.path{man},'/CohgramcData' suffix ],'dir'), mkdir([Dir.path{man},'/CohgramcData' suffix ]);end
                        eval(['LFP2=load(''',Dir.path{man},'/LFPData/LFP', num2str(temp.channel),'.mat'');'])
                        LFP2=LFP2.LFP;
                        disp(['Computing CohgramcData' suffix '/Cohgram_' num2str(ch2comp.channel),'_', num2str(temp.channel),'... '])
                        [C,phi,S12,S1,S2,t,f,confC,phistd]=cohgramc(Data(LFP1),Data(LFP2),movingwin,params);
                        eval(['save(''',Dir.path{man},'/CohgramcData' suffix '/Cohgram_', num2str(ch2comp.channel),'_', num2str(temp.channel),'.mat'',','''C'',','''phi'',','''S12'',','''confC'',','''t'',','''f'');'])
                    end
                    Ctsd=tsd(t*1E4,C);
                catch
                    disp(['No or empty ChannelsToAnalyse/',structlist{i},'... skip'])
                end


                    %%%%%%%%%% For wake data (fear conditioning protocol
                    % define TotEpoch
                try
                    tps=Range(Ctsd); %tps est en 10-4sec
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
                    if exist('Ctsd','var'), disp('Problem FreezeEpoch');keyboard; end
                end


                try
                    % spetrum restricted on FreezeEpoch
                    [tEpoch, CEpoch]=SpectroEpochML(C,t,f,FreezeEpoch,0);

                    % regroup by structures for all mice
                    figure(allfig(i)), subplot(ceil(sqrt(length(Dir.path))),floor(sqrt(length(Dir.path))),man)
                    imagesc(tEpoch,f,CEpoch'), axis xy, %caxis([15 65])
                    title([Dir.group{man},' ',Dir.path{man}(end-30:end)]), ylabel('Frequency (Hz)'); xlabel('Time (s)')
                    ylim(params.fpass); 
                    titleF1=structlist{i};titleF1(strfind(structlist{i}, '_'))=' ';
                    titleF2=struct2comp;titleF2(strfind(struct2comp, '_'))=' ';
                    if titleok(i,1)==1, text(0,params.fpass(2)*1.3,[titleF1 ' / ' titleF2]), titleok(i,1)=0;end;  xlim([0 timemax_for_plot])
                    hold on, line([0 timemax_for_plot],[5 5],'Color',[0.5 0.5 0.5])

                    % save in matrice
                    if first, MatSpF=nan(length(Dir.path),length(structlist),length(f)); MatSpNoF= MatSpF;first=0;end
                    MatSpF(man,i,1:length(f))=mean(Data(Restrict(Ctsd,FreezeEpoch)));
                    MatSpNoF(man,i,1:length(f))=mean(Data(Restrict(Ctsd,TotEpoch-FreezeEpoch)));
                    MatInfo(man,i,1:4)=[find(strcmp(Dir.group{man},nameGroups)),...
                        find(strcmp(Dir.name{man},nameMice)),tot_length(FreezeEpoch,'s'),tot_length(TotEpoch-FreezeEpoch,'s')];

                    %%%%%% compute mean spectro for 2-4 Hz and 6-9 Hz
                    % raw
                    FreqRang={'low F= ' num2str(freq1) '-' num2str(freq2) 'Hz';...
                        'low F= ' num2str(freq3) '-' num2str(freq4) 'Hz'};


                    Columns={'No Freeze';'Freeze'};
                    a=mean(Data(Restrict(Ctsd,FreezeEpoch))); % F
                    Fratio=mean(a(f>freq1&f<freq2))/mean(a(f>freq3&f<freq4));
                    b=mean(Data(Restrict(Ctsd,TotEpoch-FreezeEpoch))); % No F
                    NoFratio=mean(b(f>freq1&f<freq2))/mean(b(f>freq3&f<freq4));
                    % median
                    a_md=median(Data(Restrict(Ctsd,FreezeEpoch))); % F
                    NoFratio_md=median(b(f>freq1&f<freq2))/median(b(f>freq3&f<freq4));
                    b_md=median(Data(Restrict(Ctsd,TotEpoch-FreezeEpoch))); % No F
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
                    c=mean(10*log10(Data(Restrict(Ctsd,FreezeEpoch)))); % F
                    d=mean(10*log10(Data(Restrict(Ctsd,TotEpoch-FreezeEpoch)))); % No F
                    FratioLog=mean(c(f>freq1&f<freq2))/mean(c(f>freq3&f<freq4));
                    NoFratioLog=mean(d(f>freq1&f<freq2))/mean(d(f>freq3&f<freq4));
                    FRatioTableLog=[FRatioTableLog; mean(c(f>freq1&f<freq2))  mean(c(f>freq3&f<freq4))  FratioLog ];
                    NoFRatioTableLog=[NoFRatioTableLog; mean(d(f>freq1&f<freq2))  mean(d(f>freq3&f<freq4))  NoFratioLog ];

                    LowFLog=[LowFLog; mean(d(f>freq1&f<freq2)) mean(c(f>freq1&f<freq2))];
                    HighFLog=[HighFLog; mean(d(f>freq3&f<freq4)) mean(c(f>freq3&f<freq4))];
                    LowHighRatioLog=[LowHighRatioLog; FratioLog NoFratioLog];
                catch
                    if exist('Ctsd','var'), disp('Problem saving matrices'); end
                end

            end
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
    disp(['Saving data in local path, Cohgramc' suffix 'Freezing.mat']);
    save (['CohgramcFreezing' suffix '_' struct2comp],'struct2comp','structlist','MatInfo','MatSpF','MatSpNoF','params','nameMice','nameGroups','Dir','f','th_immob','thtps_immob','Rogne','thtps_immob_for_rogne')
    for i=1:length(structlist), 
        saveas (allfig(i), [pwd '/Coh' suffix 'Freez_',struct2comp, '_',structlist{i}]),
        saveFigure(allfig(i),['Coh' suffix 'Freez_',struct2comp, '_'  structlist{i}],pwd);
    end

end

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% %%%%%%%%%%%%%%%%%%%%  MEAN SPECTRA  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% remove data for Epoch below th_for plot (mimimum time window to take into consideration) : transform into NaN
for i=1:length(structlist)
    SpInfo=squeeze(MatInfo(:,i,:));
    for man=1:length(Dir.path)
        if SpInfo(man,3)<th_for_plot
            MatSpF(man,i,1:length(f))=NaN;
        end
        if SpInfo(man,4)<th_for_plot
            MatSpNoF(man,i,1:length(f))=NaN;
        end        
    end
end

% superpose group spectra for conditions
figure('Color',[1 1 1],'Position', [100 10 1600 900])
%colori={'r','b','k','m','g','c','y'};
%colori={[0 0 0];[0 0 1];[0 1 0];[0 0.7 0];[0.5 0.5 1];         [1 0 0.5];[1 0 0];[1 0 1];[1 0.8 0];[1 0.5 0];[0.5 0 0]};
colori=jet(length(nameMice));
colori=colori-0.1;
colori(colori<0)=0;
namecolmn={'Freezing','No Freezing','Freezing','No Freezing'};
% name MatInfo: nGroup nMice duration(FreezeEpoch) duration(TotEpoch-FreezeEpoch);
clear SpF SpNoF SpInfo

for i=1:length(structlist)
    
    SpF=squeeze(MatSpF(:,i,:));
    SpNoF=squeeze(MatSpNoF(:,i,:));
    SpInfo=squeeze(MatInfo(:,i,:));
    legF=[];legNoF=[];
    for man=1:length(Dir.path)
        try
            if SpInfo(man,3)>th_for_plot           
                subplot(length(structlist),6,6*(i-1)+[1:2]),hold on,
                plot(f,SpF(man,:),'Color',colori(SpInfo(man,2),:));
                %plot(f,SpF(man,:),'Color',colori{SpInfo(man,2)});
                ylabel(structlist{i});xlim([params.fpass]);ylim([cohmin_for_plot 1]);

                legF=[legF,{[Dir.name{man}([1,6:8]),' ',num2str(floor(SpInfo(man,3))),'s']}];
            end
        end
        
        try
            if SpInfo(man,4)>th_for_plot     
                subplot(length(structlist),6,6*(i-1)+[3:4]),hold on,
                %plot(f,SpNoF(man,:),'Color',colori{SpInfo(man,2)});
                plot(f,SpNoF(man,:),'Color',colori(SpInfo(man,2),:));
                xlim([params.fpass]);ylim([cohmin_for_plot 1]);
                legNoF=[legNoF,{[Dir.name{man}([1,6:8]),' ',num2str(floor(SpInfo(man,4))),'s']}];
            end
        end
    end
    
    subplot(length(structlist),6,6*(i-1)+[1:2]),
    aa=1;
    while ~exist('confC')
        list=dir([Dir.path{aa} '/CohgramcData']);
        confCtemp=load([Dir.path{aa},'/CohgramcData' suffix '/' list(end).name], 'confC');
        confC=confCtemp.confC;
        aa=aa+1;
    end
    plot([params.fpass], [confC confC], ':', 'Color', [0.7 0.7 0.7])
    if i==1 
           title(namecolmn{1})
           titleF2=struct2comp;titleF2(strfind(struct2comp, '_'))=' ';
           text(-0.5,1.15, titleF2)
    end
    legend(legF,'Location','EastOutside');
    if i==length(structlist), 
    xlabel('Frequency (Hz)');
    Y=ylim;
    text(0,Y(1)-0.5*(Y(2)-Y(1)), ['minimum time to take into account an epoch : ' num2str(th_for_plot) ' sec'])
    end
   
    subplot(length(structlist),6,6*(i-1)+[3:4]),
    plot([params.fpass], [confC confC], ':', 'Color', [0.7 0.7 0.7])
    if i==1
        title(namecolmn{2})
    end
    legend(legNoF,'Location','EastOutside');
    if i==length(structlist), xlabel('Frequency (Hz)');end
    

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

colorG={'r', 'b', 'k'};
for i=1:length(structlist)
    NmiceF=nan(1,length(nameGroups));
    NmiceNoF=nan(1,length(nameGroups));
    for gg=1:length(nameGroups)
        ind=find(strcmp(infoG(:,i),nameGroups{gg}));
        SpF=squeeze(tempSpF(ind,i,:)); if length(ind)==1,SpF=SpF';end
        SpNoF=squeeze(tempSpNoF(ind,i,:)); if length(ind)==1,SpNoF=SpNoF';end
        NmiceF(gg)=sum(~isnan(SpF(:,1)),1);
        NmiceNoF(gg)=sum(~isnan(SpNoF(:,1)),1);
        subplot(length(structlist),6,6*(i-1)+5),hold on,
        plot(f,nanmean(SpF,1),'Color',colorG{gg},'Linewidth',2);
        plot(f,nanmedian(SpF,1),'--','Color',colorG{gg},'Linewidth',1);
        xlim([params.fpass]);ylim([cohmin_for_plot 1]);
        subplot(length(structlist),6,6*i),hold on,
        plot(f,nanmean(SpNoF,1),'Color',colorG{gg},'Linewidth',2);
        plot(f,nanmedian(SpNoF,1),'--','Color',colorG{gg},'Linewidth',1);
        ylim([cohmin_for_plot 1]);
        xlim([params.fpass]);
        
    end
    
    if i==length(structlist), legend('OBX', 'OBX med', 'CTRL', 'CTRL med');end
    subplot(length(structlist),6,6*(i-1)+5),hold on,
    plot([params.fpass], [confC confC], ':', 'Color', [0.5 0.5 0.5])
    xlabel([ num2str(NmiceNoF(2)) ' CTRL ' num2str(NmiceNoF(1)) ' OBX '])
    subplot(length(structlist),6,6*i),hold on,
    plot([params.fpass], [confC confC], ':', 'Color', [0.5 0.5 0.5])
    xlabel([ num2str(NmiceF(2)) ' CTRL ' num2str(NmiceF(1)) ' OBX '])
end
for si=5:6,  subplot(length(structlist),6,si), title(namecolmn{si-4});end;
%for si=5:6,  subplot(length(structlist),6,(length(structlist)-1)*6+si), xlabel('Frequency (Hz)');end;
saveas (gcf, [pwd '/Coh' suffix '_' struct2comp '_AllStt.fig'])
saveFigure(gcf,['Coh' suffix '_' struct2comp '_AllStt'],pwd)


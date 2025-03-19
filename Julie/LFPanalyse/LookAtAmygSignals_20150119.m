%LookAtAmygSignals.m
% for data from OBX and SHAM sophie Dec 2015

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% %%%%%%%%%%%%%%%%%%  INPUTS  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

experiment= 'Fear-electrophy';
%experiment='ManipFeb15Bulbectomie';
ManipName='Mar15filtered';%  'DataDec15 'May15' 'Jul15'May15Marie

plo=0;
mean_or_med='mean';
SpPplot=0;
%NoFreezColor=[0.5 0.5 0.5];
NoFreezColor='g';
FreezColor='k';
[params,movingwin,suffix]=SpectrumParametersML('low'); % low or high

th_immob=1; % default 1
thtps_immob=2; % minimum 2 sec of immobility
Rogne=2; % rognage des evenementde freezing
thtps_immob_for_rogne=4; % a ajuster en fonction de 'Rogne'
Ylimits_raw=[0 5E4];
Ylimits_norm=[20 60];
th_for_plot=30; %Spectrogram is not plotted if computed for less than 30sec 
fqmax_for_plot=20;
intensitymax_for_plot=[20 60];
timemax_for_plot=1400;
cohmin_for_plot=0.4;
% define frequency bands
freq1=3;
freq2=4;
freq3=6;
freq4=9;
struct2comp='PFCx_deep';
%structlist={'Amyg_right_sup','Amyg_right_deep','Amyg_left_sup','Amyg_left_deep'};
structlist={'PFCx_deep','Bulb_deep','dHPC_rip'};%,'Amyg'%'PiCx'



% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% %%%%%%%%%%%%%%%%%%  INITIALIZATION  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Dir=PathForExperimentFEAR(experiment);
%nameSession=unique(Dir.Session);

%%%% Take only OBX and CTRL mice, and sort them
% nameGroups=unique(Dir.group);
% nameGroups=[nameGroups(~strcmp(nameGroups,'CTRL')),nameGroups(strcmp(nameGroups,'CTRL'))];
nameGroups={'OBX', 'CTRL'};

Dir=RestrictPathForExperiment(Dir,'nMice',[248]);%[ 258 259 299]

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

% % take only mice with several amygdala implantation sites
% Dir.path=Dir.path(strcmp(Dir.name, 'Mouse249') |strcmp(Dir.name, 'Mouse250'));
% Dir.manipe=Dir.manipe(strcmp(Dir.name, 'Mouse249') |strcmp(Dir.name, 'Mouse250'));
% Dir.group=Dir.group(strcmp(Dir.name, 'Mouse249') |strcmp(Dir.name, 'Mouse250'));
% Dir.Session=Dir.Session(strcmp(Dir.name, 'Mouse249') |strcmp(Dir.name, 'Mouse250'));
% Dir.name=Dir.name(strcmp(Dir.name, 'Mouse249') |strcmp(Dir.name, 'Mouse250'));

% obtain nameMice in the same order as Dir.name (which is sorted by group)
[nameMice, IXnameMice]=unique(Dir.name);
[IX2, IX_IX2]=sort(IXnameMice);
nameMice=nameMice(IX_IX2);

first=1;
MatInfo=nan(length(Dir.path),length(structlist),4);  

try
    load(['AmyFreezing' suffix '_' struct2comp]);MatInfo;
    disp(['Loading existing data from Amy' suffix 'Freezing.mat']);
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
    for m=1:length(nameMice)

            DirM.path=Dir.path(strcmp(Dir.name, nameMice(m)));
            DirM.manipe=Dir.manipe(strcmp(Dir.name, nameMice(m)));
            DirM.group=Dir.group(strcmp(Dir.name, nameMice(m)));
            DirM.Session=Dir.Session(strcmp(Dir.name, nameMice(m)) );
            DirM.name=Dir.name(strcmp(Dir.name, nameMice(m)) );
        for man=1:length(DirM.path)
            allfig(m,man)=figure('Color',[1 1 1],'Position', [100 10 1600 900]);


            disp(' '),disp(' '), disp(DirM.path{man})
            %%%%%%%%%% define FreezeEpoch
            %try

                clear temp2
                eval(['temp2=load(''',DirM.path{man},'/behavResources.mat'',''FreezeEpoch'',''Movtsd'');']);
                Movtsd=temp2.Movtsd; %, attention valable seulement pour file comportment car fichier sleep= doubletracking=pixratio pas appliqué
                if strcmp(DirM.path{man}, '/media/DataMOBsRAID/ProjetAversion/DATA-Fear/Mouse258/20151205-EXT-48h-envB')
                    FreezeEpoch=thresholdIntervals(Movtsd,th_immob+1,'Direction','Below');
                    disp('special threshold for Mouse258/20151205-EXT-48h-envB')
                else
                    FreezeEpoch=thresholdIntervals(Movtsd,th_immob,'Direction','Below');
                end
                FreezeEpoch=mergeCloseIntervals(FreezeEpoch,0.3*1E4);
                FreezeEpoch=dropShortIntervals(FreezeEpoch,thtps_immob*1E4);
                
                tps=Range(Movtsd); %tps est en 10-4sec
                TotEpoch=intervalSet(tps(1),tps(end));
                TotEpoch_length1=sum(End(TotEpoch,'s')-Start(TotEpoch,'s'));
                clear temp2
                try
                    temp2=load([DirM.path{man},'/StateEpoch.mat'],'NoiseEpoch','GndNoiseEpoch','WeirdNoiseEpoch');
                    NoiseEpoch=temp2.NoiseEpoch; GndNoiseEpoch=temp2.GndNoiseEpoch; WeirdNoiseEpoch=temp2.WeirdNoiseEpoch;
                    TotEpoch=TotEpoch-NoiseEpoch-GndNoiseEpoch-WeirdNoiseEpoch;
                catch
                    disp('NoiseEpoch / GndNoiseEpoch / WeirdNoiseEpoch not removed...')
                end
                TotEpoch_length2=sum(End(TotEpoch,'s')-Start(TotEpoch,'s'));% after noise removal

                % remove noise epochs
                FreezeEpoch=FreezeEpoch-NoiseEpoch-GndNoiseEpoch-WeirdNoiseEpoch;
                FreezeEpoch_length1=sum(End(FreezeEpoch,'s')-Start(FreezeEpoch,'s'));
                NoFreezeEpoch_length=sum(End(TotEpoch-FreezeEpoch,'s')-Start(TotEpoch-FreezeEpoch,'s'));

                % restriction of period just before and just after each freezing event to clean up the spectrum
                FreezeEpochL=dropShortIntervals(FreezeEpoch, thtps_immob_for_rogne*1E4);
                St=Start(FreezeEpochL);
                En=End(FreezeEpochL);
                FreezeEpochL=intervalset(St+Rogne*1E4, En-Rogne*1E4);
                FreezeEpoch_length2=sum(End(FreezeEpochL,'s')-Start(FreezeEpochL,'s'));% after rognage
%             catch
%                 if exist('Stsd','var'), disp('Problem FreezeEpoch');keyboard; end
%             end
            
            %%%%%%%%%%%%%  Spectrogram
                for i=1:length(structlist)
                    disp(['    ',structlist{i}])
                    clear S t Stsd 
                    

                    %%%%%%%% load and plot spectrogram // load LFP and compute spectrogram
                    try
                        
                        temp=load([DirM.path{man},'/ChannelsToAnalyse/',structlist{i},'.mat']);
                        if isempty(temp.channel) || isnan(temp.channel),error;end

                        try
                            load([DirM.path{man},'/SpectrumDataL/Spectrum' num2str(temp.channel),'.mat'],'Sp', 't', 'f') % t en secondes
                            disp(['SpectrumDataL/Spectrum' num2str(temp.channel),'... loaded'])
                        catch
                            if ~exist([DirM.path{man},'/SpectrumDataL'],'dir'), mkdir([DirM.path{man},'/SpectrumDataL']);end
                            eval(['temp2=load(''',DirM.path{man},'/LFPData/LFP',num2str(temp.channel),'.mat'');'])
                            temp2.LFP=FilterLFP(temp2.LFP,[1 100],2048);
                            disp(['Computing SpectrumDataL/Spectrum' num2str(temp.channel),'... '])
                            [Sp,t,f]=mtspecgramc(Data(temp2.LFP),movingwin,params);
                            eval(['save(''',DirM.path{man},'/SpectrumDataL/Spectrum',num2str(temp.channel),'.mat'',','''Sp'',','''t'',','''f'');'])
                        end
                        Stsd=tsd(t*1E4,Sp);
                    

                    %try
                        % spetrum restricted on FreezeEpoch
                        %[tEpoch, SpEpoch]=SpectroEpochML(Sp,t,f,FreezeEpoch,0);

                        % regroup by structures for all mice
                        figure(allfig(m,man)), subplot(length(structlist), 6, 6*(i-1)+[1:5])%subplot(ceil(sqrt(length(Dir.path))),floor(sqrt(length(Dir.path))),man)
                        %imagesc(tEpoch,f,SpEpoch'), axis xy, %caxis([15 65])
                        imagesc(t,f,10*log10(Sp')), axis xy, caxis([10 60]), hold on
                        line([Start(FreezeEpoch,'s') End(FreezeEpoch,'s')],[15 15],'color',FreezColor,'linewidth',4)
                        
%                         hold on, plot(Range(Movtsd,'s'),Data(Movtsd)/3+10,'Color',NoFreezColor)
%                         for ni=1:length(Start(FreezeEpoch))
%                             plot(Range(Restrict(Movtsd,subset(FreezeEpoch,ni)),'s'),Data(Restrict(Movtsd,subset(FreezeEpoch,ni)))/3+10,FreezColor, 'LineWidth',2);
%                         end
                        
                        title([DirM.group{man},' ',DirM.path{man}(end-30:end)]), ylabel('Frequency (Hz)'); xlabel('Time (s)')
                        ylim(params.fpass);
                        titleF=structlist{i};titleF(strfind(structlist{i}, '_'))=' ';
                        text(0,params.fpass(2)*1.25,titleF)
                        hold on, line([0 timemax_for_plot],[5 5],'Color',[0.5 0.5 0.5])

                        % save in matrice
                        if first, MatSpF=nan(length(DirM.path),length(structlist),length(f)); MatSpNoF= MatSpF;first=0;end
                        MatSpF(man,i,1:length(f))=mean(Data(Restrict(Stsd,FreezeEpoch)));
                        MatSpNoF(man,i,1:length(f))=mean(Data(Restrict(Stsd,TotEpoch-FreezeEpoch)));
                        MatInfo(man,i,1:4)=[find(strcmp(DirM.group{man},nameGroups)),...
                            find(strcmp(DirM.name{man},nameMice)),tot_length(FreezeEpoch,'s'),tot_length(TotEpoch-FreezeEpoch,'s')];

                        subplot(length(structlist), 6, 6*i)
                        plot(f,10*log10(nanmean(Data(Restrict(Stsd, FreezeEpochL)))), 'Color', FreezColor,'LineWidth',2), hold on
                        plot(f,10*log10(nanmean(Data(Restrict(Stsd, TotEpoch-FreezeEpoch)))), 'Color', NoFreezColor,'LineWidth',2), 
                        plot(f,10*log10(nanmedian(Data(Restrict(Stsd, FreezeEpochL)))), '--','Color', FreezColor,'LineWidth',1),
                        plot(f,10*log10(nanmedian(Data(Restrict(Stsd, TotEpoch-FreezeEpoch)))), '--','Color', NoFreezColor,'LineWidth',1)
                        
                        if i==length(structlist), legend({'Freeze';'No Freeze'}); end
                        title(titleF); ylim([intensitymax_for_plot]);xlim([0 fqmax_for_plot])
                        
%                     catch
%                         if exist('Stsd','var'), disp('Problem saving matrices'); end
%                     end

                    catch
                        disp(['No or empty ChannelsToAnalyse/',structlist{i},'... skip'])
                    end

                end
            %save Ratio FreqRang structlist FRatioTable NoFRatioTable FRatioTableLog NoFRatioTableLog  LowF HighF  LowHighRatio  LowFLog HighFLog  LowHighRatioLog  LowF_md HighF_md  LowHighRatio_md
            disp(['Saving data in local path, ' ManipName '_' suffix '_' nameMice{m} 'Freezing.mat']);
            save ([pwd '/IndivFigSpectro' ManipName '/Freezing' suffix '_' nameMice{m}],'MatInfo','MatSpF','MatSpNoF','params','structlist','nameMice','nameGroups','Dir','f','th_immob','thtps_immob','Rogne','thtps_immob_for_rogne')
            saveas (allfig(m,man), [pwd '/IndivFigSpectro' ManipName '/' ManipName '_' suffix 'Freez',nameMice{m}, '_',num2str(man)]),
            saveFigure(allfig(m,man),[pwd '/IndivFigSpectro' ManipName '/' ManipName '_' suffix 'Freez',nameMice{m}, '_',num2str(man)],pwd);


        end
        
    end % end of mouse loop
end

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% %%%%%%%%%%%%%%%%%%%%  MEAN SPECTRA  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% superpose group spectra for conditions
figure('Color',[1 1 1],'Position', [100 10 1600 900])
%colori={'r','b','k','m','g','c','y'};
%colori={[0 0 0];[0 0 1];[0 1 0];[0 0.7 0];[0.5 0.5 1];         [1 0 0.5];[1 0 0];[1 0 1];[1 0.8 0];[1 0.5 0];[0.5 0 0]};
colori=jet(length(nameMice));
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
                ylabel(structlist{i});xlim([0 fqmax_for_plot]);ylim([cohmin_for_plot 1]);

                legF=[legF,{[Dir.name{man}([1,6:8]),' ',num2str(floor(SpInfo(man,3))),'s']}];
            end
        end
        
        try
            if SpInfo(man,4)>th_for_plot     
                subplot(length(structlist),6,6*(i-1)+[3:4]),hold on,
                %plot(f,SpNoF(man,:),'Color',colori{SpInfo(man,2)});
                plot(f,SpNoF(man,:),'Color',colori(SpInfo(man,2),:));
                xlim([0 fqmax_for_plot]);ylim([cohmin_for_plot 1]);
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
    end
    legend(legF,'Location','EastOutside');
    if i==length(structlist), xlabel('Frequency (Hz)');end
    
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
    for gg=1:length(nameGroups)
        ind=find(strcmp(infoG(:,i),nameGroups{gg}));
        SpF=squeeze(tempSpF(ind,i,:)); if length(ind)==1,SpF=SpF';end
        SpNoF=squeeze(tempSpNoF(ind,i,:)); if length(ind)==1,SpNoF=SpNoF';end
        
        subplot(length(structlist),6,6*(i-1)+5),hold on,
        plot(f,nanmean(SpF,1),'Color',colorG{gg},'Linewidth',2);
        plot(f,nanmedian(SpF,1),'--','Color',colorG{gg},'Linewidth',1);
        xlim([0 fqmax_for_plot]);ylim([cohmin_for_plot 1]);
        subplot(length(structlist),6,6*i),hold on,
        plot(f,nanmean(SpNoF,1),'Color',colorG{gg},'Linewidth',2);
        plot(f,nanmedian(SpNoF,1),'--','Color',colorG{gg},'Linewidth',1);
        ylim([cohmin_for_plot 1]);
        xlim([params.fpass]);
        
    end
    if i==length(structlist), legend('OBX', 'OBX med', 'CTRL', 'CTRL med');end
    subplot(length(structlist),6,6*(i-1)+5),hold on,
    plot([params.fpass], [confC confC], ':', 'Color', [0.7 0.7 0.7])
    subplot(length(structlist),6,6*i),hold on,
    plot([params.fpass], [confC confC], ':', 'Color', [0.7 0.7 0.7])
end
for si=5:6,  subplot(length(structlist),6,si), title(namecolmn{si-4});end;
for si=5:6,  subplot(length(structlist),6,(length(structlist)-1)*6+si), xlabel('Frequency (Hz)');end;
saveas (gcf, [pwd '/IndivFigSpectro' ManipName '/' ManipName '_' suffix '_' struct2comp '_AllStt.fig'])
saveFigure(gcf,[ ManipName '_' suffix '_' struct2comp '_AllStt'],[pwd '/IndivFigSpectro' ManipName ])


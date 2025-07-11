%SpectroFearDREADD.m


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
% define frequency bands
freq1=3;
freq2=4;
freq3=6;
freq4=9;
structlist={'PFCx_deep','Bulb_deep','dHPC_rip','PiCx','Amyg'};

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% %%%%%%%%%%%%%%%%%%  INITIALIZATION  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Dir=PathForExperimentFEAR(experiment);
Dir = RestrictPathForExperiment(Dir,'nMice',[253 254]);
%nameSession=unique(Dir.Session);

% nameGroups=unique(Dir.group);
% nameGroups=[nameGroups(~strcmp(nameGroups,'CTRL')),nameGroups(strcmp(nameGroups,'CTRL'))];
nameGroups={'OBX', 'CTRL'};

 Dir=RestrictPathForExperiment(Dir,'Group',{'OBX','CTRL'});

[B,IX] = sort(Dir.group);
Dir.path=Dir.path(IX);
Dir.name=Dir.name(IX);
Dir.manipe=Dir.manipe(IX);
Dir.group=B;
Dir.Session=Dir.Session(IX);
% 
%restrict to CNO experiments
%Treatment='CNO2';%'control' 'CNO1
Treatment={'CNO2'};%'control' 'CNO1
if ~isempty(Treatment)
    Dir=RestrictPathForExperiment(Dir,'Treatment',Treatment);
end
if length(Treatment)>1
    Treatmentname='';
    for ll=1:length(Treatment)
        Treatmentname=[Treatmentname Treatment{ll}];
    end
end
Condition='24h';%'48h
ConditionArray=strfind(Dir.path, Condition);%'control'
for i=1:length(ConditionArray),
    ConditionInd(i)=~isempty(ConditionArray{i});
end
Dir.name=Dir.name(ConditionInd);
Dir.manipe=Dir.manipe(ConditionInd);
Dir.group=Dir.group(ConditionInd);
Dir.Session=Dir.Session(ConditionInd);
Dir.path=Dir.path(ConditionInd);
Dir.Treatment=Dir.Treatment(ConditionInd);

% obtain nameMice in the same order as Dir.name (which is sorted by group)
[nameMice, IXnameMice]=unique(Dir.name);
[IX2, IX_IX2]=sort(IXnameMice);
nameMice=nameMice(IX_IX2);

MatSpF=nan(length(Dir.path),length(structlist),164);
MatSpNoF= MatSpF;   MatInfo=nan(length(Dir.path),length(structlist),4);  

try
    load(['DataSpectroFreezing_' Treatmentname ]);MatInfo;
    disp(['Loading existing data from DataSpectroFreezing_' Treatmentname '.mat']);
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
        %hRfig=figure('Color', [1 1 1], 'Position', [800 300 900 600]);
        
        StrucListTitle=zeros(size(structlist));
        for i=1:length(structlist)
            disp(['    ',structlist{i}])
            clear Sp t Stsd
            
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
            
            
            try
                % spetrum restricted on FreezeEpoch
                [tEpoch, SpEpoch]=SpectroEpochML(Sp,t,f,FreezeEpoch,0);
                
                
                % regroup by structures for all mice
                figure(allfig(i)), subplot(ceil(sqrt(length(Dir.path))),floor(sqrt(length(Dir.path))),man)
                imagesc(tEpoch,f,10*log10(SpEpoch')), axis xy, caxis([15 65])
                title([Dir.group{man},' ',Dir.path{man}(end-31:end)]), ylabel('Frequency (Hz)'); xlabel('Time (s)')
                ylim([0 20]);  xlim([0 200])
                
                if man==1, text(0,26,structlist{i});ylabel([structlist{i} ' ' Treatmentname]);end; 
                
                while StrucListTitle(i)==0
                    X=xlim;Y=ylim;
                    text(X(1)-0.3*(X(2)-X(1)),Y(2)+0.2*(Y(2)-Y(1)),structlist{i})
                    StrucListTitle(i)=1;
                end
                
                xlabel([ sprintf('%0.0f',tot_length(FreezeEpoch,'s')) ' s']);
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
    disp(['Saving data in local path, DataSpectroFreezing_' Treatmentname ]);
    save (['DataSpectroFreezing_' Treatmentname ], 'MatInfo','MatSpF','MatSpNoF','params','structlist','nameMice','nameGroups','Dir','f','th_immob','thtps_immob','Rogne','thtps_immob_for_rogne')
    for i=1:length(structlist), saveas (allfig(i), [pwd '/SpFreez_allMice_',structlist{i},'_',Treatmentname]),saveFigure(allfig(i),['SpFreez_allMice_',structlist{i},'_',Treatmentname],pwd);end

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

%% superpose group spectra for conditions
figure('Color',[1 1 1],'Position', [100 10 1600 900])
colori=jet(length(nameMice));
%LineStyleman={':','--','-',':','--','-'};
LineStyleman={':',':','-','-'};
namecolmn={'Freezing','No Freezing','Freezing','No Freezing'};
% name MatInfo: nGroup nMice duration(FreezeEpoch) duration(TotEpoch-FreezeEpoch);
clear SpF SpNoF SpInfo

for i=1:length(structlist)
    if strcmp(structlist{i},'Bulb_deep'), yl=[0 4E5];elseif strcmp(structlist{i},'dHPC'), yl=[0 2E5]; else yl=[0 6E4];end
    SpF=squeeze(MatSpF(:,i,:));
    SpNoF=squeeze(MatSpNoF(:,i,:));
    SpInfo=squeeze(MatInfo(:,i,:));
    legF=[];legNoF=[];
    for man=1:length(Dir.path)
        try
            if SpInfo(man,3)>th_for_plot          
                subplot(length(structlist),6,6*(i-1)+[1:2]),hold on,
                plot(f,SpF(man,:),'Color',colori(SpInfo(man,2),:),'LineWidth',2, 'LineStyle',LineStyleman{man});
                ylabel(structlist{i}); ylim(yl);xlim([0 20]);
                legF=[legF,{[Dir.name{man}([1,6:8]),' ',num2str(floor(SpInfo(man,3))),'s']}];
            end
        end
        try
            if SpInfo(man,4)>th_for_plot  
                subplot(length(structlist),6,6*(i-1)+[3:4]),hold on,
                plot(f,SpNoF(man,:),'Color',colori(SpInfo(man,2),:),'LineWidth',2, 'LineStyle',LineStyleman{man});
                ylim(yl);xlim([0 20]);
                legNoF=[legNoF,{[Dir.name{man}([1,6:8]),' ',num2str(floor(SpInfo(man,4))),'s']}];
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
        text(X(1)-0.5*(X(2)-X(1)),Y(2)+0.2*(Y(2)-Y(1)), Treatmentname)
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
    if strcmp(structlist{i},'Bulb_deep'), yl=[0 4E5];elseif strcmp(structlist{i},'dHPC'), yl=[0 2E5]; else, yl=[0 6E4];end
    for gg=1:length(nameGroups)
        ind=find(strcmp(infoG(:,i),nameGroups{gg}));
        SpF=squeeze(tempSpF(ind,i,:)); if length(ind)==1,SpF=SpF';end
        SpNoF=squeeze(tempSpNoF(ind,i,:)); if length(ind)==1,SpNoF=SpNoF';end
        NmiceF(gg)=sum(~isnan(SpF(:,1)),1);
        NmiceNoF(gg)=sum(~isnan(SpNoF(:,1)),1);
        subplot(length(structlist),6,6*(i-1)+5),hold on,
        plot(f,nanmean(SpF,1),'Color',colorG{gg},'Linewidth',2);ylim(yl);xlim([0 20]);
        plot(f,nanmedian(SpF,1),'--','Color',colorG{gg},'Linewidth',1);
        subplot(length(structlist),6,6*i),hold on,
        plot(f,nanmean(SpNoF,1),'Color',colorG{gg},'Linewidth',2);
        plot(f,nanmedian(SpNoF,1),'--','Color',colorG{gg},'Linewidth',1);
    end
    if i==length(structlist), legend('OBX', 'OBX med', 'CTRL', 'CTRL med');end
    ylim(yl);xlim([0 20]); %legend(nameGroups);
    subplot(length(structlist),6,6*(i-1)+5),hold on,
    xlabel([ num2str(NmiceNoF(2)) ' CTRL ' num2str(NmiceNoF(1)) ' OBX '])
    subplot(length(structlist),6,6*i),hold on,
    xlabel([ num2str(NmiceF(2)) ' CTRL ' num2str(NmiceF(1)) ' OBX '])
end
for si=5:6,  subplot(length(structlist),6,si), title(namecolmn{si-4});end;
%for si=5:6,  subplot(length(structlist),6,(length(structlist)-1)*6+si), xlabel('Frequency (Hz)');end;
saveas (gcf, [pwd '/Sp_AllStt_Ctrl-OBX' Treatmentname '.fig'])
saveFigure(gcf, ['Sp_AllStt_Ctrl-OBX_' Treatmentname ],pwd)


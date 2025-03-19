% RespiFear.m

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% %%%%%%%%%%%%%%%%%%  INPUTS  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%experiment= 'Fear-electrophy';
experiment= 'ManipDec14Bulbectomie';
%experiment='ManipFeb15Bulbectomie';

plo=0;
mean_or_med='mean';
SpPplot=1;

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
%structlist={'PFCx_deep','Bulb_deep','dHPC_rip','PiCx','Amyg'};
structlist={'Respi'};

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

Dir.path=Dir.path(strcmp(Dir.Session, 'EXTpleth'));
Dir.name=Dir.name(strcmp(Dir.Session, 'EXTpleth'));
Dir.manipe=Dir.manipe(strcmp(Dir.Session, 'EXTpleth'));
Dir.group=Dir.group(strcmp(Dir.Session, 'EXTpleth'));
Dir.Session=Dir.Session(strcmp(Dir.Session, 'EXTpleth'));


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

MatSpF=nan(length(Dir.path),length(structlist),164);
MatSpNoF= MatSpF;   MatInfo=nan(length(Dir.path),length(structlist),4);  



try
    load('RespiFreezing.mat');MatInfo;
    disp('Loading existing data from RespiFreezing.mat');
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
        if strcmp(Dir.path{man}(end), '/')
            Dir.path{man}(end)=[];
        end
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
        
        for i=1:length(structlist)
            disp(['    ',structlist{i}])
            clear Sp t Stsd
            
            %%%%%%%% load and plot spectrogram // load LFP and compute spectrogram
            try
                
                %try
                    Spec=load([Dir.path{man},'/Respi_Low_Spectrum.mat'],'Spectro');
                    t=Spec.Spectro{1,2};
                    f=Spec.Spectro{1,3};
                    Sp=Spec.Spectro{1,1};
                    disp(['Respi_Low_Spectrum.mat ... loaded'])
%                 catch
%                     if ~exist([Dir.path{man},'/SpectrumDataL'],'dir'), mkdir([Dir.path{man},'/SpectrumDataL']);end
%                     eval(['temp2=load(''',Dir.path{man},'/LFPData/LFP',num2str(temp.channel),'.mat'');'])
%                     disp(['Computing SpectrumDataL/Spectrum' num2str(temp.channel),'... '])
%                     [Sp,t,f]=mtspecgramc(Data(temp2.LFP),movingwin,params);
%                     eval(['save(''',Dir.path{man},'/SpectrumDataL/Spectrum',num2str(temp.channel),'.mat'',','''Sp'',','''t'',','''f'');'])
%                 end
                Stsd=tsd(t*1E4,Sp);
            catch
                disp(['No Respi_Low_Spectrum.mat ... skip'])
            end
            
            
                %%%%%%%%%% For wake data (fear conditioning protocol
                % define TotEpoch
            try
                tps=Range(Stsd); %tps est en 10-4sec
                TotEpoch=intervalSet(tps(1),tps(end));
                TotEpoch_length1=sum(End(TotEpoch,'s')-Start(TotEpoch,'s'));
                clear temp2
%                 try
%                     temp2=load([Dir.path{man},'/StateEpoch.mat'],'NoiseEpoch','GndNoiseEpoch','WeirdNoiseEpoch');
%                     NoiseEpoch=temp2.NoiseEpoch; GndNoiseEpoch=temp2.GndNoiseEpoch; WeirdNoiseEpoch=temp2.WeirdNoiseEpoch;
%                     TotEpoch=TotEpoch-NoiseEpoch-GndNoiseEpoch-WeirdNoiseEpoch;
%                 catch
%                     disp('NoiseEpoch / GndNoiseEpoch / WeirdNoiseEpoch not removed...')
%                 end
                TotEpoch_length2=sum(End(TotEpoch,'s')-Start(TotEpoch,'s'));% after noise removal
                
                clear temp2
                try 
                    eval(['temp2=load(''',Dir.path{man},'/behavResources.mat'',''FreezeEpoch'',''Movtsd'');']);
                    Movtsd=temp2.Movtsd; %, attention valable seulement pour file comportment car fichier sleep= doubletracking=pixratio pas appliqué
                    FreezeEpoch=thresholdIntervals(Movtsd,th_immob,'Direction','Below');
                    FreezeEpoch=mergeCloseIntervals(FreezeEpoch,0.3*1E4);
                    FreezeEpoch=dropShortIntervals(FreezeEpoch,thtps_immob*1E4);
                catch
                    eval(['load(''',Dir.path{man},'/Behavior.mat'',''PosMat'',''Movtsd'',''StimInfo'',''imageRef'');']);
                    Pos=PosMat;
                    Pos(:,4)=[];
                    X=tsd(Pos(:,1)*1E4, Pos(:,2));
                    Y=tsd(Pos(:,1)*1E4, Pos(:,3));
                    CSplus=ts(StimInfo(StimInfo(:,2)==5,1)*1E4);
                    CSminus=ts(StimInfo(StimInfo(:,2)==7,1)*1E4);
                    Shocks=ts(StimInfo(StimInfo(:,2)==6,1)*1E4);

                    FreezeEpoch=thresholdIntervals(Movtsd,th_immob,'Direction','Below');
                    FreezeEpoch=mergeCloseIntervals(FreezeEpoch,0.3*1E4);
                    FreezeEpoch=dropShortIntervals(FreezeEpoch,thtps_immob*1E4);

                    save ([Dir.path{man} '/behavResources'],  'Movtsd','Pos','X','Y','CSplus','CSminus','Shocks','imageRef','FreezeEpoch','th_immob','thtps_immob') 
                end
                
                    
                    
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
            %try
                % spetrum restricted on FreezeEpoch
                [tEpoch, SpEpoch]=SpectroEpochML(Sp,t,f,FreezeEpoch,0);
                
%                 figure(hRfig), nn=ceil(sqrt(length(structlist)));
%                 subplot(nn,ceil(length(structlist)/nn),i);ylim([0 20]); 
%                 if i==1, text(0,26,[Dir.group{man},'   ',Dir.path{man}]);end; 
%                 imagesc(tEpoch,f,10*log10(SpEpoch')), axis xy, caxis([15 65])
%                 title(structlist{i}), ylabel('Frequency (Hz)'); xlabel('Time (s)');
%                 ylim([0 20]); if i==1, text(0,26,[Dir.group{man},'   ',Dir.path{man}]);end;  xlim([0 200])
                
                % regroup by structures for all mice
                figure(allfig(i)), subplot(ceil(sqrt(length(Dir.path))),ceil(sqrt(length(Dir.path))),man)
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
%             catch
%                 if exist('Stsd','var'), disp('Problem saving matrices'); end
%             end
            
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
    disp('Saving data in local path, RespiFreezing.mat');
    save RespiFreezing MatInfo MatSpF MatSpNoF params structlist nameMice nameGroups Dir f th_immob thtps_immob Rogne thtps_immob_for_rogne
    for i=1:length(structlist), saveas (allfig(i), [pwd '/SpFreez_allMice_',structlist{i}]),saveFigure(allfig(i),['SpFreez_allMice_',structlist{i}],pwd);end

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
namecolmn={'Freezing','No Freezing','Freezing','No Freezing'};
% name MatInfo: nGroup nMice duration(FreezeEpoch) duration(TotEpoch-FreezeEpoch);
clear SpF SpNoF SpInfo

for i=1:length(structlist)
    if strcmp(structlist{i},'Bulb_deep'), yl=[0 8E5];elseif strcmp(structlist{i},'dHPC'), yl=[0 2E5]; else, yl=[0 4E3];end
    SpF=squeeze(MatSpF(:,i,:));
    SpNoF=squeeze(MatSpNoF(:,i,:));
    SpInfo=squeeze(MatInfo(:,i,:));
    legF=[];legNoF=[];
    for man=1:length(Dir.path)
        try
            if SpInfo(man,3)>th_for_plot          
                subplot(length(structlist),6,6*(i-1)+[1:2]),hold on,
                plot(f,SpF(man,:),'Color',colori(SpInfo(man,2),:), 'LineWidth', 2);
                ylabel(structlist{i}); ylim(yl);xlim([0 20]);
                legF=[legF,{[Dir.name{man}([1,6:8]),' ',num2str(floor(SpInfo(man,3))),'s']}];
            end
        end
        try
            if SpInfo(man,4)>th_for_plot  
                subplot(length(structlist),6,6*(i-1)+[3:4]),hold on,
                plot(f,SpNoF(man,:),'Color',colori(SpInfo(man,2),:), 'LineWidth', 2);
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
            temp=squeeze(MatSpF(ind,i,:)); 
            if length(ind)==1,
                temp=temp';
                tempSpF(mi,i,1:length(f))=temp;
            else
               tempSpF(mi,i,1:length(f))=nanmean(temp,1); 
            end
            
            temp=squeeze(MatSpNoF(ind,i,:)); 
            if length(ind)==1,
                temp=temp';
                tempSpNoF(mi,i,1:length(f))=temp;
            else
                tempSpNoF(mi,i,1:length(f))=nanmean(temp,1);
            end
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
    if strcmp(structlist{i},'Bulb_deep'), yl=[0 8E5];elseif strcmp(structlist{i},'dHPC'), yl=[0 2E5]; else, yl=[0 4E3];end
    for gg=1:length(nameGroups)
        ind=find(strcmp(infoG(:,i),nameGroups{gg}));
        SpF=squeeze(tempSpF(ind,i,:)); if length(ind)==1,SpF=SpF';end
        SpNoF=squeeze(tempSpNoF(ind,i,:)); if length(ind)==1,SpNoF=SpNoF';end
        NmiceF(gg)=sum(~isnan(SpF(:,1)),1);
        NmiceNoF(gg)=sum(~isnan(SpNoF(:,1)),1);
        subplot(length(structlist),6,6*(i-1)+5),hold on,
        plot(f,nanmean(SpF),'Color',colorG{gg},'Linewidth',2);ylim(yl);xlim([0 20]);
        plot(f,nanmedian(SpF),'--','Color',colorG{gg},'Linewidth',1);
        subplot(length(structlist),6,6*i),hold on,
        plot(f,nanmean(SpNoF),'Color',colorG{gg},'Linewidth',2);
        plot(f,nanmedian(SpNoF),'--','Color',colorG{gg},'Linewidth',1);
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
saveas (gcf, [pwd '/Sp_AllStt_Ctrl-OBX.fig'])
saveFigure(gcf,'Sp_AllStt_Ctrl-OBX',pwd)

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


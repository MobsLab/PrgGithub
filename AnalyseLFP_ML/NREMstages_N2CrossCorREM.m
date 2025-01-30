%NREMstages_N2CrossCorREM
%
% list of related scripts in NREMstages_scripts.m

% -------------------------------------------------------------------------
%% manual input
FolderTOsave='/media/DataMOBsRAIDN/ProjetNREM/Figures/AnalyNREMsubstages_N2andREM';
analyName='/media/DataMOBsRAIDN/ProjetNREM/AnalysisNREM/AnalyNREMsubstages_N2CrossCorREM';
if ~exist(analyName,'file'), save(analyName,'FolderTOsave');end
DataSet='miceSD24h';
%DataSet='miceSD6h';
%DataSet='miceBSL';
savFig=0;
t_step=1*60;%second


% -------------------------------------------------------------------------
%% load analysis
clear durEp nameSes Cros
try
    eval(['load(analyName,''',sprintf(['durEp_',DataSet,'step%ds'],t_step),''');'])
    eval(['durEp=',sprintf(['durEp_',DataSet,'step%ds'],t_step),...
        '; nameSes=nameSes_',DataSet,'; Cros=Cros_',DataSet,'; nameMouse=nameMouse_',DataSet,';'])
catch
    
    % -------------------------------------------------------------------------
    % load path
    if strcmp(DataSet,'miceSD24h'),
        load('/media/DataMOBsRAIDN/ProjetNREM/AnalysisNREM/AnalyNREMsubstagesSD24h_2hStep_Wnz',...
            'Stages','Epochs','h_deb','nameMouse','Dir');
        nameSes={'BSL','SD24h','24+1d'};
        NameEpochs=Stages;
        
    elseif strcmp(DataSet,'miceSD6h'),
        load('/media/DataMOBsRAIDN/ProjetNREM/AnalysisNREM/AnalyNREMsubstagesSD6h_2hStep_Wnz',...
            'Stages','Epochs','h_deb','nameMouse','Dir');
        NameEpochs=Stages;
        nameSes={'BSL','SD6h','6h+1d'};
        
    elseif strcmp(DataSet,'miceBSL'),
        load('/media/DataMOBsRAID/ProjetAstro/AnalyseTempEvolutionSlow/AnalyseNREMsubstages/AnalySubstagesTrioTransition',...
            'NameEpochs','Epochs','Dir','h_deb');
        nameSes={'BSL'};
        temp=Epochs; Epochs={};
        for man=1:size(temp,1), Epochs{man,1}=temp(man,:); end
        nameMouse=Dir.name;
    end
    
    % -------------------------------------------------------------------------
    % get REM and NREM episodes
    durEp=[]; Cros=[];
    for man=1:size(Epochs,1)
        for ses=1:length(nameSes)
            
            clear DurPost Ep REM
            Ep=Epochs{man,ses};
            
            % <<<<<<<<<<<<<<<<<< Prepare ZT timesteps <<<<<<<<<<<<<<<<<<<<<
            delay_rec=(h_deb(man,ses)-9)*3600; % starts at 9am
            n_nan=floor(delay_rec/t_step);
            sta=zeros(1,n_nan);sto=zeros(1,n_nan); % empty blocks
            sta=[sta,max(0,n_nan*t_step-delay_rec)]; % first block start
            sto=[sto,min(t_step,t_step+n_nan*t_step-delay_rec)]; %first block end
            
            num_step=ceil((max(Stop(Ep{7},'s'))-sto(end))/ t_step);
            sta=[sta,sto(end)+[0:1:num_step-1]*t_step];
            sto=[sto,sto(end)+[1:num_step]*t_step];
            
            % <<<<<<<<<<<<<<< Stages on ZT timesteps <<<<<<<<<<<<<<<<
            N=length(NameEpochs);
            L=min(length(sta),24/(t_step/3600));
            tempDur=nan(N,3+24/(t_step/3600));
            tempDur(:,1:3)=[ones(N,1)*[man,ses],[1:N]'];
            for e=1:L % 24h max
                I=intervalSet(sta(e)*1E4,sto(e)*1E4);
                for n=1:N
                    s_Ep=and(Ep{n},I);
                    tempDur(n,3+e)=sum(Stop(s_Ep,'s')-Start(s_Ep,'s'));
                end
                if tempDur(7,3+e)< 30 % total rec (without noise) <30s
                    tempDur(:,3+e)=nan(N,1);
                end
            end
            durEp=[durEp;tempDur];
            tempCross=[];
            for n=1:6
                for n2=1:6
                    try
                        [C,B]=CrossCorrKB(Start(Ep{n}),Start(Ep{n2}),100,100);
                        tempCross=[tempCross;[man,ses,n,n2,C]]; bt=B;
                    end
                end
            end
            Cros=[Cros,tempCross];
        end
    end
    % save
    eval([sprintf(['durEp_',DataSet,'step%ds'],t_step),'=durEp; nameSes_',DataSet,'=nameSes;',...
        ' Cros_',DataSet,'=Cros; nameMouse_',DataSet,'=nameMouse;'])
    eval(['save(analyName,''-append'',''',sprintf(['durEp_',DataSet,'step%ds'],t_step),...
        ''',''nameSes_',DataSet,''',''Cros_',DataSet,''',''nameMouse_',DataSet,''');'])
end

% -------------------------------------------------------------------------
%% Display
N=length(NameEpochs);
colori=[0.5 0.2 0.1;0 0.6 0 ;0.6 0.2 0.9 ;1 0.7 1 ; 0.8 0.2 0.8; 0 0 0.5; 0 0 0.5; 0 0 1;0.5 0.2 0.1];
figure('Color',[1 1 1],'Unit','Normalized','Position',[0.05 0.1 0.7 0.7])
%option='s';
%option='%sleep';
option='%tot';
for n=1:N
    subplot(3,3,n), hold on,
    for ses=1:length(nameSes)
        if ses==1, colo=[0 0 0]; elseif ses==2, colo=colori(n,:);  else, colo=[0.5 0.5 0.5]; end
        Ms=durEp(find(durEp(:,2)==ses & durEp(:,3)==n),4:end);
        Msleep=durEp(find(durEp(:,2)==ses & durEp(:,3)==8),4:end);
        Mtot=durEp(find(durEp(:,2)==ses & durEp(:,3)==7),4:end);
        if strcmp(option,'%sleep'), Ms=100*Ms./Msleep;elseif strcmp(option,'%tot'), Ms=100*Ms./Mtot;end
        plot([1:24/(t_step/3600)]*t_step/3600,nanmean(Ms,1),'Linewidth',2,'Color',colo);
    end
    title(NameEpochs{n},'Color',colori(n,:))
    %ylim([0 100]); if ismember(n,[2,3,5]), ylim([0 40]); elseif n==4, ylim([40 80]);elseif n==6, ylim([60 100]);end
    line([12.5 12.5],ylim,'Color',[0.5 0.5 0.5])
    if rem(n,3)==1, ylabel({sprintf('%ds Step',t_step),['stage Duration (',option,')']});end
end

% -------------------------------------------------------------------------
%% Display
params.tapers=[3 5];
mice=unique(durEp(:,1));
Oscill=nan(length(nameSes),max(mice),6,6);
dozscore=0;
for ses=1:length(nameSes)
    for man=1:max(mice)
        Tot=durEp(find(durEp(:,1)==man & durEp(:,2)==ses & durEp(:,3)==7),4:end);
        figure('Color',[1 1 1],'Unit','Normalized','Position',[0.05 0.05 0.9 0.9]),numF=gcf;
        for n=1:6
            for n2=1:6
                ep=100*durEp(find(durEp(:,1)==man & durEp(:,2)==ses & durEp(:,3)==n),4:end)./Tot;
                ep2=100*durEp(find(durEp(:,1)==man & durEp(:,2)==ses & durEp(:,3)==n2),4:end)./Tot;
                
                if dozscore
                    option='z'; 
                    scaled = (ep - nanmean(ep)) / nanstd(ep);
                    scaled(isnan(ep)) = 0;
                    scaled2 = (ep2 - nanmean(ep2)) / nanstd(ep2);
                    scaled2(isnan(ep2)) = 0; 
                else
                    option='';
                    iNan=[0,find(isnan(ep) | isnan(ep2)),length(ep)+1];
                    [m,di]=max(diff(iNan));
                    scaled=zscore(ep(iNan(di)+1:iNan(di+1)-1));
                    scaled2=zscore(ep2(iNan(di)+1:iNan(di+1)-1));
                end
                [c,lags] = xcorr(scaled,scaled2);
                subplot(6,6,MatXY(n,n2,6)),
                if n==n2
                    plot(scaled,'Color',colori(n,:));%ylabel([NameEpochs{n},' dur (%tot)'])
                     ylim([-2 3]);text(0,max(ylim),NameEpochs{n},'Color',colori(n,:))
                else
                    plot(lags,c,'Color',colori(n,:),'Linewidth',2);%ylabel('CrossCorr')
                    line([0 0],[-100 150],'Color',colori(n2,:)); xlim([-50 50]); ylim([-100 150]);
                    %figure,plot(f,S), hold on, plot(f,smooth(S,5)); line([m m],ylim,'Color','r');
                    %text(m*1.1, 0.9*max(ylim),sprintf('period = %1.1f min',(1/m)*t_step/60),'Color','r'); keyboard; close
                end
                [S,f]=mtspectrumc(c(find(lags>-50 & lags<50)),params);
                m=f(find(smooth(S,5)==max(smooth(S,5))));
                Oscill(ses,man,n,n2)=(1/m)*t_step/60;
                
            end
        end
        subplot(6,6,3), title({DataSet,[nameMouse{man},' ',nameSes{ses}]})
        FigName=[FolderTOsave,'/IndivCrossCorr'];
        if savFig,saveFigure(numF.Number,['IndivCrossCorr_',DataSet,'_',nameMouse{man},nameSes{ses},option],FigName); end
    end
end
%%
figure('Color',[1 1 1],'Unit','Normalized','Position',[0.05 0.05 0.8 0.8]),numG=gcf;
for n=1:6
    for n2=1:6 
        if n<=n2
            subplot(6,6,MatXY(n,n2,6)),
            M=squeeze(Oscill(:,:,n,n2))/60;
            M(abs(M)>10)=NaN; %6h
            %M(abs(M)==Inf)=NaN; %6h
            PlotErrorBarN(M',0,1); ylim([0 8])
            set(gca,'Xtick',1:length(nameSes))
            set(gca,'XtickLabel',nameSes)
            text(0.8-0.2*length(NameEpochs{n}),max(ylim),NameEpochs{n},'Color',colori(n,:))
            text(1,max(ylim),['by ',NameEpochs{n2}],'Color',colori(n2,:))
            if n==n2, ylabel('cyclic period (h)');end
        end
    end
end
subplot(6,6,MatXY(1,3,6)), title({['CrossCorr dynamic ', DataSet],' '})

if savFig,saveFigure(numG.Number,['CrossCorrDynamic_',DataSet,option],FolderTOsave); end


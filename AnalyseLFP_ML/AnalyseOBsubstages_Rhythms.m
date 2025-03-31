% AnalyseOBsubstages_Rhythms.m
% 
% see also
% 1. AnalyseOBsubstages_Bilan.m
% 2. AnalyseOBsubstages_BilanRespi.m
% 3. AnalyseOBsubstages_NREMsubstages.m
% 4. AnalyseOBsubstages_NREMsubstagesPlethysmo.m
% 5. AnalyseOBsubstages_Rhythms.m

% PATHs
Dir1=PathForExperimentsDeltaSleepNew('BASAL');
Dir1=RestrictPathForExperiment(Dir1,'nMice',[243 244 251 252]);
Dir2=PathForExperimentsML('BASAL');
Dir2=RestrictPathForExperiment(Dir2,'Group','WT');
Dir=MergePathForExperiment(Dir1,Dir2);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% %%%%%%%%%%%%%%%%% Modulation Delta waves by OB %%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
colori=[0.6 0.2 1 ;1 0.7 1 ;0.8 0 0.7 ];
freq=[2 5];
nameEp={'N1','N2','N3'};
NamParam={'mu','Kappa','pval'};
res='/media/DataMOBsRAID/ProjetAstro/AnalyseOBsubstages/AnalysesOB';

try
    load([res,'/AnalyOBModulatesDelta.mat']);
    Dir;
    disp('AnalyOBModulatesDelta.mat already exists... loading...')
    
catch
    
    MatParam=nan(length(Dir.path),length(nameEp),3);
    MatModu=nan(length(Dir.path),length(nameEp),25);
    for man=1:length(Dir.path)
        %
        disp(' '); disp(Dir.path{man})
        cd(Dir.path{man})
        
        % get substages
        clear WAKE REM N1 N2 N3
        disp('- RunSubstages.m')
        try [WAKE,REM,N1,N2,N3]=RunSubstages;close; end
        
        % get Delta waves
        clear Dpfc tDelta
        tDelta=GetDeltaML;
        Dpfc=ts(tDelta);
        
        % get BO
        clear channel LFP EEGf LFP2
        load ChannelsToAnalyse/Bulb_deep.mat
        
        if ~isempty(tDelta) && exist('WAKE','var') && ~isempty(channel)
            % load and filter LFP Bulb
            disp('Loading and filtering LFP Bulb_deep... WAIT!')
            eval(['load(''LFPData/LFP',num2str(channel),'.mat'');'])
            EEGf=FilterLFP(LFP,freq,1024);
            LFP2=ResampleTSD(LFP,100);
            
            disp('Calculating Modulation Delta waves by OB slow... WAIT!')
            for n=1:length(nameEp)
                eval(['epoch=',nameEp{n},';'])
                disp(nameEp{n})
                try
                    % Modulation Delta by lowOB
                    [ph,mu, Kappa, pval,B,C]=ModulationTheta(Dpfc,EEGf,epoch,25,1);
                    
                    if 0
                        % look at RayleighFreq3
                        [H,HS,Ph,ModTheta]=RayleighFreq3(LFP2,Restrict(Dpfc,epoch),0.05,20);
                    end
                    
                    % save
                    MatParam(man,n,:)=[mu,Kappa,pval];
                    MatModu(man,n,:)=C;
                    close;
                end
            end
        else
            disp('Problem. Skip')
        end
    end
    disp('Saving in AnalyOBModulatesDelta.mat')
    %MATOSCI=tsdArray(MATOSCI);
    save([res,'/AnalyOBModulatesDelta.mat'],'Dir','MatParam','nameEp','MatModu','freq','B','NamParam')
end

% pool mice
mice=unique(Dir.name);
MiModu=nan(length(mice),size(MatModu,2),size(MatModu,3));
MiParam=nan(length(mice),length(nameEp),3);
for n=1:length(nameEp)
    temp=squeeze(MatModu(:,n,:));
    tempP=squeeze(MatParam(:,n,:));
    for mi=1:length(mice)
        id=find(strcmp(mice{mi},Dir.name));
        MiModu(mi,n,:)=nanmean(temp(id,:),1);
        MiParam(mi,n,:)=nanmean(tempP(id,:),1);
    end
end

% Plot all
figure('Color',[1 1 1])
for n=1:length(nameEp)
    temp=squeeze(MiModu(:,n,:));
    %temp(isnan(nanmean(temp,2)),:)=[];
    AA=[temp,temp];
    BB=[B,2*pi+B];
    subplot(2,length(nameEp),n), imagesc(BB,1:length(temp),AA)
    title(nameEp{n})
    %
    subplot(2,length(nameEp),length(nameEp)+n), hold on,
    plot(BB,AA), errorbar(BB,nanmean(AA,1),stdError(AA),'Linewidth',2)
    title(nameEp{n})
end

% Plot Resume
figure('Color',[1 1 1],'Unit','Normalized','Position',[0.2 0.2 0.25 0.5]),
subplot(2,3,1:2), hold on,
leg={};
for n=1:length(nameEp)
    temp=squeeze(MiModu(:,n,:));
    AA=[temp,temp];
    BB=[B,2*pi+B];
    plot(BB,nanmean(AA,1),'Color',colori(n,:),'Linewidth',3)
    plot(BB,nanmean(AA,1)+stdError(AA),'Color',colori(n,:))
    plot(BB,nanmean(AA,1)-stdError(AA),'Color',colori(n,:))
    set(gca,'Xtick',[0 pi 2*pi 3*pi 4*pi])
    set(gca,'XtickLabel',{'0','pi','2pi','pi','2pi'})
    leg=[leg,nameEp{n},'std',' '];
end
legend(leg,'Location','EastOutside'); xlim([0 4*pi])
line([2*pi 2*pi],ylim,'Color',[0.5 0.5 0.5])
title('OB 2-5Hz modulates Delta wave')

for n=1:length(nameEp)
    subplot(2,3,3+n), hold on,
    temp=squeeze(MatParam(:,n,:));
    pcol=zeros(length(temp(:,3)),1)-2;
    pcol(temp(:,3)<0.05)=1;
    pcol(temp(:,3)<0.01)=2;
    pcol(temp(:,3)<0.001)=3;
    
    scatter(temp(:,1),temp(:,2),30,pcol,'fill')
    caxis([-2 3])
    xlabel('mu (av phase of Delta)')
    ylabel('kappa (modu strength)')
    title([nameEp{n},'    color = pval'])
end
subplot(2,3,3), scatter(temp(:,1),temp(:,2),30,pcol,'fill');caxis([-2 3])
colorbar('YTick',[-2:3],'YTickLabel',{'NS',' ',' ','p<0.05','p<0.01','p<0.001'})
title([nameEp{n},'    with colorbar'])
saveFigure(gcf,'OBmodulatesDelta-NREMSubStages','/home/mobsyoda/Dropbox/MOBs_ProjetBulbe/FIGURES/FigureOBstages')
 
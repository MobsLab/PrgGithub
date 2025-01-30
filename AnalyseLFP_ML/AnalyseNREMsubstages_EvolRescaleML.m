% AnalyseNREMsubstages_EvolRescaleML.m
%
% list of related scripts in NREMstages_scripts.m 

% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
% <<<<<<<<<<<<<<<<<<<<< DIRECTORIES OF EXPE <<<<<<<<<<<<<<<<<<<<<<<<<<<
Dir1=PathForExperimentsDeltaSleepNew('BASAL');
Dir2=PathForExperimentsML('BASAL');
Dir2=RestrictPathForExperiment(Dir2,'Group','WT');
Dir=MergePathForExperiment(Dir1,Dir2);

% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
% <<<<<<<<<<<<<<<<<<<<<<<<<<< INPUTS <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
res='/media/DataMOBsRAID/ProjetAstro/AnalyseTempEvolutionSlow/AnalyseNREMsubstages';
FolderToSave='/media/DataMOBsRAID/ProjetAstro/AnalyseNREMsubstages';
savFig=0;
analyname='AnalySubstagesEvolRescale';

dodKO=0;
if dodKO
    Dir=PathForExperimentsML('BASAL');
    Dir=RestrictPathForExperiment(Dir,'Group','dKO');
    analyname='AnalySubstagesEvolRescale_dKO';
end

L=5; % look at WAKE REM N1 N2 N3
frq=[2 4]; % look PFCx spectrum at this freq
tps=0:0.01:1; % sample on rescales spectrum
colori=[0.5 0.2 0.1;0.1 0.7 0 ;0.7 0.2 1;1 0.6 1 ;0.8 0 0.7 ];

nameStructure='PFCx_deep';
%nameStructure='Bulb_deep';
analyname=[analyname,'_',nameStructure,'.mat'];
% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%% <<<<<<<<<<<<<<<<<<<<<<<<<<< INITIATE <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
try
    load([res,'/',analyname]);
    ReNorm;
    disp([analyname,' already exists... loading'])
    
catch
    MAT={}; MATz={};Mtrio={};
    ReNorm=nan(length(Dir.path),L,length(tps));
    
    for man=1:length(Dir.path)
        disp(' '); disp(Dir.path{man})
        cd(Dir.path{man})
        
        % -----------------------------------------------------------------
        % -----------------------------------------------------------------
        % get substages and PFCx spectrum
        clear WAKE REM N1 N2 N3 Sptsd
        try
            [WAKE,REM,N1,N2,N3,NamesStages]=RunSubstages;close
            
            % load PFCx Channel and spectrum
            disp(['Loading ',nameStructure,' SpectrumDataL, WAIT...'])
            clear channel Sp t f
            load(['ChannelsToAnalyse/',nameStructure,'.mat'],'channel');
            eval(['load(''SpectrumDataL/Spectrum',num2str(channel),'.mat'',''Sp'',''t'',''f'')'])
            Sptsd=tsd(t*1E4,mean(Sp(:,f>=frq(1) & f<frq(2)),2));
            Sptsdz=tsd(t*1E4,zscore(mean(Sp(:,f>=frq(1) & f<frq(2)),2)));
        end
        
        % -----------------------------------------------------------------
        % -----------------------------------------------------------------
        % rescale spectro
        if exist('Sptsd','var')
            disp('Rescale and align spectrum')
            for n=1:L
                disp(['     - ',NamesStages{n}])
                % get spectrum restricted on epoch
                clear epoch
                eval(['epoch=',NamesStages{n},';'])
                rg=Range(Restrict(Sptsd,epoch));
                RSp=tsd(0:1/(length(rg)-1):1,Data(Restrict(Sptsd,epoch)));
                %figure, imagesc(Range(RSp),f,10*log10(Data(RSp)'));axis xy;caxis([15 60])
                
                % rescale all spectrum betw [0 1]
                ReNorm(man,n,:)=Data(Restrict(RSp,tps));
                
                % ---------------------------------------------------------
                % rescale each episod
                disp('       Rescale and aligne single episode')
                sta=Start(epoch);
                temp=nan(length(sta),length(tps)+1);
                tempz=nan(length(sta),length(tps)+1);
                for s=1:length(sta)
                    if Stop(subset(epoch,s),'s')-Start(subset(epoch,s),'s')>3
                        ep=intervalSet(Start(subset(epoch,s))+1.5*1E4,Stop(subset(epoch,s))-1.5*1E4); % remove window of spectrum
                        durEp=Stop(ep,'s')-Start(ep,'s');
                        RSp=Restrict(Sptsd,ep);
                        RSp=tsd(0:1/(length(Range(RSp))-1):1,Data(RSp));
                        RSpz=Restrict(Sptsdz,ep);
                        RSpz=tsd(0:1/(length(Range(RSpz))-1):1,Data(RSpz));
                        try
                            temp(s,:)=[durEp ,Data(Restrict(RSp,tps))'];
                            tempz(s,:)=[durEp ,Data(Restrict(RSpz,tps))'];
                        end
                    end
                end
                
                MATz{man,n}=tempz;
                MAT{man,n}=temp;
            end
        end
        
        % -----------------------------------------------------------------
        % -----------------------------------------------------------------
        disp('Look at each trio of transition.. WAIT..')
        if exist('Sptsd','var')
            % look at transition
            SleepStages=[];
            for n=1:L
                eval(['epoch=',NamesStages{n},';'])
                SleepStages=[SleepStages; [ Start(epoch,'s'),Stop(epoch,'s'),n*ones(length(Start(epoch)),1)]];
            end
            SleepStages=sortrows(SleepStages,1);
            s_mat=[SleepStages,[0;SleepStages(1:end-1,3)],[0;0;SleepStages(1:end-2,3)]];
            
            for n_i=1:L
                for n_j=1:L
                    for n_k=1:L
                        if n_i~=n_j && n_k~=n_j
                            ind=find(s_mat(:,5)==n_i & s_mat(:,4)==n_j & s_mat(:,3)==n_k);
                            
                            % get time of small episod
                            Ii=intervalSet(s_mat(ind-2,1)*1E4,s_mat(ind-2,2)*1E4);
                            Ij=intervalSet(s_mat(ind-1,1)*1E4,s_mat(ind-1,2)*1E4);
                            Ik=intervalSet(s_mat(ind,1)*1E4,s_mat(ind,2)*1E4);
                            
                            dur_i=Stop(Ii,'s')-Start(Ii,'s');
                            dur_j=Stop(Ij,'s')-Start(Ij,'s');
                            dur_k=Stop(Ik,'s')-Start(Ik,'s');
                            
                            % get spectrum of each trio of episods
                            temp=nan(length(ind),length(tps)*3+3);
                            tempz=nan(length(ind),length(tps)*3+3);
                            for i=1:length(ind)
                                % Ii
                                rg=Range(Restrict(Sptsd,subset(Ii,i)));
                                RSp=tsd(0:1/(length(rg)-1):1,Data(Restrict(Sptsd,subset(Ii,i))));
                                RSpz=tsd(0:1/(length(rg)-1):1,Data(Restrict(Sptsdz,subset(Ii,i))));
                                try temp(i,1:length(tps))=Data(Restrict(RSp,tps));end
                                try tempz(i,1:length(tps))=Data(Restrict(RSpz,tps));end
                                % Ij
                                rg=Range(Restrict(Sptsd,subset(Ij,i)));
                                RSp=tsd(0:1/(length(rg)-1):1,Data(Restrict(Sptsd,subset(Ij,i))));
                                RSpz=tsd(0:1/(length(rg)-1):1,Data(Restrict(Sptsdz,subset(Ij,i))));
                                try temp(i,length(tps)+1:2*length(tps))=Data(Restrict(RSp,tps));end
                                try tempz(i,length(tps)+1:2*length(tps))=Data(Restrict(RSpz,tps));end
                                % Ik
                                rg=Range(Restrict(Sptsd,subset(Ik,i)));
                                RSp=tsd(0:1/(length(rg)-1):1,Data(Restrict(Sptsd,subset(Ik,i))));
                                RSpz=tsd(0:1/(length(rg)-1):1,Data(Restrict(Sptsdz,subset(Ik,i))));
                                try temp(i,2*length(tps)+1:3*length(tps))=Data(Restrict(RSp,tps));end
                                try tempz(i,2*length(tps)+1:3*length(tps))=Data(Restrict(RSpz,tps));end
                            end
                            
                            Mtrio{man,n_i,n_j,n_k}=[dur_i,dur_j,dur_k,temp];
                            Mtrioz{man,n_i,n_j,n_k}=[dur_i,dur_j,dur_k,tempz];
                        end
                    end
                end
            end
        end
    end
    
    save([res,'/',analyname],'MAT','MATz','ReNorm','Dir','frq','L','tps','NamesStages','Mtrio','Mtrioz');
end
% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%% <<<<<<<<<<<<<<<<<<<<<< DISPLAY Global decrease <<<<<<<<<<<<<<<<<<<<<
zscoreAll=1;
% zscore across all stages
if zscoreAll
    yl=[-1 2];
    temp=[];
    for n=1:L
        temp=[temp,[n*ones(1,size(ReNorm,3));squeeze(ReNorm(:,n,:))]];
    end
    ind=find(~isnan(nanmean(temp,2)));
    temp=[temp(1,:);zscore(temp(ind(2:end),:),0,2)];
    for n=1:L
        Matemp{n}=temp(2:end,find(temp(1,:)==n));
    end
else
    yl=[-0.8 0.8];
    for n=1:L
        temp=squeeze(ReNorm(:,n,:)); 
        Matemp{n}=zscore(temp(~isnan(mean(temp,2)),:),0,2);
    end
end
    

% plot rescaled total epochs
figure('color',[1 1 1],'Unit','Normalized','Position',[0.3 0.1 0.5 0.6]), 
for n=1:L
    subplot(2,5,n), hold on
    y=Matemp{n}; py= polyfit(tps,mean(y),1);
    errorbar(tps,mean(y),std(y)/size(y,1),'Color',colori(n,:),'Linewidth',2);
    xlim([0 1]);ylim(yl);title(NamesStages{n}); 
    if n==1, ylabel(sprintf(['mean zscore ',nameStructure(1:4),' spectrum %d-%dHz'],frq(1),frq(2)));end
    line([min(tps),max(tps)],py(2)+[min(tps),max(tps)]*py(1),'Color',[0.5 0.5 0.5])
    [r,p]=corrcoef(tps,mean(y));
    text(0.2, 1.5, sprintf('r=%0.1f, p=%0.3f, slope=%0.1f',r(1,2),p(1,2),py(1)),'Color',colori(n,:))
    xlabel('normed total period');  
end

for n=1:L
    subplot(2,5,n+5), hold on
    y=Matemp{n}; 
    errorbar(tps,median(y),std(y)/size(y,1),'Color',colori(n,:),'Linewidth',2);
    xlim([0 1]);ylim(yl);title(NamesStages{n}); 
    if n==1, ylabel(sprintf(['median zscore ',nameStructure(1:4),' spectrum %d-%dHz'],frq(1),frq(2)));end
    xlabel('normed total period');  
end
% svae figure
if savFig, saveFigure(gcf,['NREMsubstages_EvolRescaleGlobalDecrease',nameStructure(1:4),'-Z',num2str(zscoreAll)],FolderToSave);end

% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%% <<<<<<<<<<<<<<<<<<<<<< superimposed plot <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

% superimposed plot
figure('color',[1 1 1],'Unit','Normalized','Position',[0.2 0.1 0.25 0.8]), 
for n=1:L
    subplot(3,3,[1:2,4:5,7:8]),hold on
    y=Matemp{n};smo=7;
    plot(tps,mean(y),'Color',colori(n,:),'Linewidth',2)
    if n==1
        ylabel(sprintf(['mean zscore ',nameStructure(1:4),' spectrum %d-%dHz'],frq(1),frq(2)));title(NamesStages{n});
        xlim([0 1]);ylim(yl);xlabel('normed total period');
    end
end
legend(NamesStages); 
for n=1:L
    subplot(3,3,[1:2,4:5,7:8]),hold on
    y=Matemp{n}; py= polyfit(tps,mean(y),1);
    line([min(tps),max(tps)],py(2)+[min(tps),max(tps)]*py(1),'Color',[0.5 0.5 0.5])
    plot(tps,mean(y)+stdError(y),'Color',colori(n,:));
    plot(tps,mean(y)-stdError(y),'Color',colori(n,:));
    [r,p]=corrcoef(tps,mean(y));
    subplot(3,3,3),
    text(0.1, 0.3+0.1*n, sprintf('r=%0.1f, p=%0.3f, slope=%0.1f',r(1,2),p(1,2),py(1)),'Color',colori(n,:))
end
axis off;
subplot(3,3,[1:2,4:5,7:8]), xlim([0 1]);ylim(yl);xlabel('normed total period'); 

%  QUANTIF GLOBAL decrease 
MatBarS = nan(size(Matemp{1},1),L); %slope
MatBarP = nan(size(Matemp{1},1),L); %pval
MatBarR = nan(size(Matemp{1},1),L); %r
for n=1:L
    yAll=Matemp{n};
    for man=1:size(yAll,1)
        y=yAll(man,:); 
        py= polyfit(tps,y,1);
        [r,p]=corrcoef(tps,y);
        MatBarS(man,n)=py(1);
        if p(1,2)<0.05, MatBarP(man,n)=r(1,2);end
        MatBarR(man,n)=r(1,2);
    end
    MatPerc(n)=100*sum(~isnan(MatBarP(:,n)))/size(MatBarP,1);
end

nmouse=length(unique(Dir.name(isnan(nanmean(MatBarS,2))==0)));
nexpe=sum(isnan(nanmean(MatBarS,2))==0);

subplot(3,3,6), PlotErrorBarN(MatBarR,0,0);
title(sprintf('Correlation Coefficient (n=%d, N=%d)',nexpe,nmouse))
set(gca,'Xtick',1:L),set(gca,'XtickLabel',NamesStages(1:L))
ylabel(sprintf([nameStructure(1:4),' %d-%dHz decrease'],frq(1),frq(2)));
%bar(nanmean(MatBarS,1)); 
% hold on, errorbar(1:L,nanmean(MatBarS,1),nanstd(MatBarS)/sqrt(nexpe),'+k')
% 
% subplot(3,3,9), PlotErrorBarN(MatBarP,0,0);
% title('Correlation Coefficient when p<0.05')
% set(gca,'Xtick',1:L),set(gca,'XtickLabel',NamesStages(1:L))
% ylabel(sprintf([nameStructure(1:4),' %d-%dHz decrease'],frq(1),frq(2)));

subplot(3,3,9), bar([MatPerc',100-MatPerc'],'Stacked');
title('% corrcoeff p<0.05'); colormap gray
set(gca,'Xtick',1:L),set(gca,'XtickLabel',NamesStages(1:L))


% subplot(3,2,6),PlotErrorBarN(MatBarS,0,0);
% title(sprintf('Slope of correlation (n=%d, N=%d)',nexpe,nmouse))
% set(gca,'Xtick',1:L),set(gca,'XtickLabel',NamesStages(1:L))


% save figure
if savFig, saveFigure(gcf,['NREMsubstages_EvolRescalGlobalDecrease',nameStructure(1:4),'-superimposedQuantif'],FolderToSave);end



% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%% <<<<<<<<<<<<<<<<<<<<<< DISPLAY Local decrease <<<<<<<<<<<<<<<<<<<<<<

if 0
    for man=1:length(Dir.path)
        figure('color',[1 1 1],'Unit','Normalized','Position',[0.1 0.1 0.4 0.7]),
        for n=1:L
            subplot(2,L,n), imagesc(tps,1:size(MAT{man,n},1),zscore(MAT{man,n}(:,2:end),0,2))
            title(NamesStages{n});
            if n==3, title({Dir.path{man},NamesStages{n}}); end
            
            temp=sortrows(MAT{man,n},1);
            subplot(2,L,L+n), imagesc(tps,1:size(temp,1),zscore(temp(:,2:end),0,2))
            title(NamesStages{n});xlabel('normed time on episod');
        end
    end
end
%
figure('color',[1 1 1],'Unit','Normalized','Position',[0.1 0.1 0.3 0.7]),
for n=1:L
    Ep_shrt=nan(length(Dir.path),length(tps));
    Ep_long=nan(length(Dir.path),length(tps));
    
    for man=1:length(Dir.path)
        try
            temp=sortrows(MAT{man,n},1);
            temp=zscore(temp(:,2:end),0,2);
            % first quarter
            Ep_shrt(man,:)=nanmean(temp(1:ceil(size(temp,1)/4),:));
            % last quarter
            Ep_long(man,:)=nanmean(temp(floor(3*size(temp,1)/4):end,:));
        end
    end
    
    subplot(2,L,n), hold on,
    Num=sum(~isnan(mean(Ep_shrt,2)));
    errorbar(tps,smooth(nanmean(Ep_shrt),3),nanstd(Ep_shrt)/sqrt(Num),'Color',colori(n,:));
    errorbar(tps,smooth(nanmean(Ep_long),3),nanstd(Ep_long)/sqrt(Num),'Color',colori(n,:),'Linewidth',2);
    title([NamesStages(n),{sprintf('(n=%d)',Num)}],'Color',colori(n,:)); ylim([-0.5 1]); xlim([0 1])
    if n==1, ylabel(sprintf('zscore PFCx spectrum %d-%dHz',frq(1),frq(2)));end
    
    subplot(2,L,L+1:L+2), hold on,
    errorbar(tps,smooth(nanmean(Ep_shrt),3),nanstd(Ep_shrt)/sqrt(Num),'Color',colori(n,:));
    title('25% shorter episods'); ylim([-0.5 1]); xlim([0 1]);xlabel('normed time on episod');
    ylabel(sprintf('zscore PFCx spectrum %d-%dHz',frq(1),frq(2)))
    
    subplot(2,L,L+3:L+4), hold on,
    errorbar(tps,smooth(nanmean(Ep_long),3),nanstd(Ep_long)/sqrt(Num),'Color',colori(n,:),'Linewidth',2);
    title('25% longer episods');ylim([-0.5 1]); xlim([0 1]);
    
end
legend(NamesStages);xlabel('normed time on episod');

if savFig, saveFigure(gcf,['NREMsubstages_EvolRescalLOCALDecrease',nameStructure(1:4),'-ErrBar'],FolderToSave);end


% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%% <<<<<<<<<<<<< DISPLAY Local according to transition <<<<<<<<<<<<<<<
totZscore=1;
plo_indiv=0;

Mshrt={}; Mlong={};numTrio=[];
for n_i=1:L
    for n_j=1:L
        for n_k=1:L
            if n_i~=n_j && n_k~=n_j
                
                disp(['Transition : ',NamesStages{n_i},'-',NamesStages{n_j},'-',NamesStages{n_k}])
                temp1=nan(length(Dir.path),3*length(tps));
                temp2=nan(length(Dir.path),3*length(tps));
                
                for man=1:length(Dir.path)
                    clear t_i
                    try
                        if totZscore, Mt=Mtrioz; else Mt=Mtrio;end
                        t_i=Mt{man,n_i,n_j,n_k}(:,1);
                        numTrio(man,n_i,n_j,n_k)=length(t_i);
                        if length(t_i)< 5, error;end
                        
                        t_j=Mt{man,n_i,n_j,n_k}(:,2);
                        t_k=Mt{man,n_i,n_j,n_k}(:,3);
                        [S,ind]=sortrows(t_j); % sort according to length of central episod
                        
                        if totZscore, 
                            temp=Mt{man,n_i,n_j,n_k}(:,4:3+3*length(tps));
                        else
                            temp=zscore(Mt{man,n_i,n_j,n_k}(:,4:3+3*length(tps)),0,2);
                        end
                        S_i=temp(ind,1:length(tps));
                        S_j=temp(ind,1+length(tps):2*length(tps));
                        S_k=temp(ind,1+2*length(tps):3*length(tps));
                        
                        
                        if plo_indiv
                            figure('color',[1 1 1],'Unit','Normalized','Position',[0.2 0.4 0.25 0.5]),
                            % n_i
                            subplot(2,3,1), imagesc(tps,1:length(t_i),S_i),title(NamesStages(n_i),'Color',colori(n_i,:));
                            ylabel(sprintf('zscore PFCx spectrum %d-%dHz',frq(1),frq(2)))
                            subplot(2,3,4), errorbar(tps(1:5:end),smooth(mean(S_i(:,1:5:end)),3),std(S_i(:,1:5:end))/sqrt(length(t_i)),'Color',colori(n_i,:),'Linewidth',2)
                            ylabel(sprintf('zscore PFCx spectrum %d-%dHz',frq(1),frq(2))); xlim([0 1]);ylim([-1.5 2])
                            % n_j
                            subplot(2,3,2), imagesc(tps,1:length(t_i),zscore(S_j,0,2)),
                            title({NamesStages{n_j},' ordered by duration'},'Color',colori(n_j,:));
                            subplot(2,3,5), errorbar(tps(1:5:end),smooth(mean(S_j(:,1:5:end)),3),std(S_j(:,1:5:end))/sqrt(length(t_i)),'Color',colori(n_j,:),'Linewidth',2);
                            title(Dir.path{man});xlim([0 1]);xlabel('rescaled time on episod');ylim([-1.5 2])
                            % n_k
                            subplot(2,3,3), imagesc(tps,1:length(t_i),zscore(S_k,0,2)),
                            title(NamesStages(n_k),'Color',colori(n_k,:));
                            subplot(2,3,6), errorbar(tps(1:5:end),smooth(mean(S_k(:,1:5:end)),3),std(S_k(:,1:5:end))/sqrt(length(t_i)),'Color',colori(n_k,:),'Linewidth',2);
                            xlim([0 1]);ylim([-1.5 2])
                        end
                        
                        temp1(man,:)=[mean(S_i(1:ceil(length(t_i)/4),:)),mean(S_j(1:ceil(length(t_i)/4),:)),mean(S_k(1:ceil(length(t_i)/4),:))];
                        temp2(man,:)=[mean(S_i(floor(3*length(t_i)/4):end,:)),mean(S_j(floor(3*length(t_i)/4):end,:)),mean(S_k(floor(3*length(t_i)/4):end,:))];
                        
                    catch
                        if exist('t_i','var') && length(t_i)>4, keyboard ;disp('Problem');end
                    end
                end
                Mshrt{n_i,n_j,n_k}=temp1;
                Mlong{n_i,n_j,n_k}=temp2;
            end
        end
    end
end

%% plot pooled data

figure('color',[1 1 1]); a=0;
for n_i=1:L
    for n_j=1:L
        for n_k=1:L
            if n_i~=n_j && n_k~=n_j
                temp1=Mlong{n_i,n_j,n_k};
                if ~isempty(temp1) && ~isnan(nanmean(nanmean(temp1)))
                    temp1=temp1(~isnan(nanmean(temp1,2)),:);
                    if size(temp1,1)>4
                        a=a+1;
                        subplot(6,8,a), hold on,
                        %keyboard
                        do=temp1(:,1:5:length(tps));
                        errorbar(tps(1:5:end)-1,nanmean(do),nanstd(do)/size(do,1),'Color',colori(n_i,:),'Linewidth',2)
                        do=temp1(:,length(tps)+1:5:2*length(tps));
                        errorbar(tps(1:5:end),nanmean(do),nanstd(do)/size(do,1),'Color',colori(n_j,:),'Linewidth',2)
                        do=temp1(:,2*length(tps)+1:5:3*length(tps));
                        errorbar(tps(1:5:end)+1,nanmean(do),nanstd(do)/size(do,1),'Color',colori(n_k,:),'Linewidth',2)
                        line([0 0],[-1.5 2],'Color',[0.5 0.5 0.5]); xlim([-1 2]); 
                        line([1 1],[-1.5 2],'Color',[0.5 0.5 0.5]);ylim([-1.5 2]);
                        title([NamesStages{n_i},'-',NamesStages{n_j},'-',NamesStages{n_k}])
                    end
                end
            end
        end
    end
end
xlabel('rescaled time on episod')

%% compare history
figure('color',[1 1 1],'Unit','Normalized','Position',[0.2 0.02 0.35 0.9]);
for n_i=1:L
    for n_j=1:L
        subplot(L,L,L*(n_j-1)+n_i), hold on,
        a=0;
        for n_k=1:L
            if n_i~=n_j && n_k~=n_j
                temp1=Mlong{n_i,n_j,n_k};
                if ~isempty(temp1) && ~isnan(nanmean(nanmean(temp1)))
                    temp1=temp1(~isnan(nanmean(temp1,2)),:);
                    if size(temp1,1)>4
                        %keyboard
                        if a==0,
                            line([0 0],[-1.5 2],'Color',[0.5 0.5 0.5]); 
                            line([1 1],[-1.5 2],'Color',[0.5 0.5 0.5]);
                            line([-1 2],[0 0],'Color',[0.8 0.8 0.8]);
                            a=1;
                        end
                        do=temp1(:,1:5:length(tps));
                        errorbar(tps(1:5:end)-1,nanmean(do),nanstd(do)/size(do,1),'Color',colori(n_i,:),'Linewidth',2)
                        do=temp1(:,length(tps)+1:5:2*length(tps));
                        errorbar(tps(1:5:end),nanmean(do),nanstd(do)/size(do,1),'Color',colori(n_j,:),'Linewidth',2)
                        do=temp1(:,2*length(tps)+1:5:3*length(tps));
                        errorbar(tps(1:5:end)+1,nanmean(do),nanstd(do)/size(do,1),'Color',colori(n_k,:),'Linewidth',2)
                    end
                end
            end
        end
        title([NamesStages{n_i},'-',NamesStages{n_j},'...']);
        xlim([-1 2]);ylim([-1.5 1.5]);
        if n_i==n_j, title([NamesStages{n_i},'-',NamesStages{n_j},'...'],'Color',colori(n_i,:)); end
    end
end
if savFig, saveFigure(gcf,['NREMsubstages_EvolRescal',nameStructure(1:4),'-TRIO'],FolderToSave);end

        

%% quantify number of transitions
figure('color',[1 1 1],'Unit','Normalized','Position',[0.1 0.05 0.5 0.9]);
for n_i=1:L
    for n_j=1:L
        subplot(L,L,L*(n_i-1)+n_j);
        MA=nan(1,L);SA=nan(1,L);
        for n_k=1:L
            if n_i~=n_j && n_k~=n_j
                A=squeeze(numTrio(:,n_i,n_j,n_k));
                MA(n_k)=nanmean(A);
                SA(n_k)=nanstd(A)/sqrt(sum(~isnan(A)));
            end
        end
            errorbar(1:5,100*MA/(nansum(nansum(MA))),SA,'+k');
            hold on, bar(100*MA/(nansum(nansum(MA))));
            set(gca,'Xtick',1:5); xlim([0 6]); ylim([0 100])
            set(gca,'XtickLabel',NamesStages); 
        title([NamesStages{n_i},'->',NamesStages{n_j},'-> ... (n=',num2str(ceil(nansum(nansum(MA)))),')'])
    end
end



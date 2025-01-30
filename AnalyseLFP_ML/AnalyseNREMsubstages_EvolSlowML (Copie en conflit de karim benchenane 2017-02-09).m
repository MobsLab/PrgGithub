% AnalyseNREMsubstages_EvolSlowML.m
%got from TempEvolutionSlowBulbML.m
%
% see also
% 1. AnalyseNREMsubstagesML.m
% 2. AnalyseNREMsubstages_transitionML.m
% 3. AnalyseNREMsubstages_transitionprobML.m
% 4. AnalyseNREMsubstages_EvolRescaleML.m
% 5. AnalyseNREMsubstages_OBslowOscML.m
% 6. AnalyseNREMsubstages_EvolSlowML.m
% 7. AnalyseNREMsubstages_mergeDropML.m
% 8. AnalyseNREMsubstages_SpikesML.m
% 9. AnalyseNREMsubstages_MultiParamMatrix.m
% 10. AnalyseNREMsubstages_SpikesAndRhythms.m
% 11. AnalyseNREMsubstages_SpectrumML.m
% 12. AnalyseNREMsubstages_Rhythms.m
% 13. AnalyseNREMsubstages_N1evalML.m
% 14. AnalyseNREMsubstages_TrioTransitionML.m
% 15. AnalyseNREMsubstages_TrioTransRescaleML.m
% 16. AnalyseNREMsubstages_OBX.m
% 17. AnalyseNREMsubstages_SpikesInterPyrML.m
% 18. AnalyseNREMsubstagesdKOML.m
% 19. AnalyseNREMsubstages_SD.m
% 20. AnalyseNREMsubstages_SWA.m
% 21. AnalyseNREMsubstages_OR.m
% CaracteristicsSubstagesML.m


% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
% <<<<<<<<<<<<<<<<<<<<< DIRECTORIES OF EXPE <<<<<<<<<<<<<<<<<<<<<<<<<<<
Dir1=PathForExperimentsDeltaSleepNew('BASAL');
Dir1=RestrictPathForExperiment(Dir1,'nMice',[243 244 251 252]);
Dir2=PathForExperimentsML('BASAL');
Dir2=RestrictPathForExperiment(Dir2,'Group','WT');
Dir=MergePathForExperiment(Dir1,Dir2);


% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
% <<<<<<<<<<<<<<<<<<<<<<<<<<< INPUTS <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
res='/media/DataMOBsRAID/ProjetAstro/AnalyseTempEvolutionSlow/AnalyseNREMsubstages';
FolderToSave='/media/DataMOBsRAID/ProjetAstro/AnalyseNREMsubstages/EvolSlow';
analyname='AnalySubstagesEvolSlow';

do_ko=0;
if do_ko
    Dir=PathForExperimentsML('BASAL');
    Dir=RestrictPathForExperiment(Dir,'Group','dKO');
    analyname='AnalySubstagesEvolSlow_dKO';
end

%nameStructure='PFCx_deep';
nameStructure='Bulb_deep';
savFig=1;
NamesEp={'WAKE','SLEEP','NREM','REM','N1','N2','N3'}; 
frq=[2 4]; % look PFCx spectrum at this freq
ZTh=[10 :1/6: 18]*3600; % time of the day (s), step of 10min
ZTm=[10 :1/60: 18]*3600; % time of the day (s), step of 1min
ZTanaly=[11,12.5,16.5,18];
Fsamp=0.5:0.05:20;

colori=[0.5 0.2 0.1;0.5 0.5 0.5; 0 0 0; 0.1 0.7 0 ;0.7 0.2 1;1 0.6 1 ;0.8 0 0.7 ];
analyname=[analyname,'_',nameStructure,'.mat'];

% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%% <<<<<<<<<<<<<<<<<<<<<<<<<<< INITIATE <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
try
    clear MATz; 
    load([res,'/',analyname]);
    MATz;
    disp([analyname,' already exists... loading'])
    
catch
    % initiate
    MAT=nan(length(Dir.path),length(NamesEp),length(ZTh)-1); 
    MATz=MAT; DurEpZT=MAT;
    Matm=nan(length(Dir.path),length(NamesEp),length(ZTm)-1); 
    MATsp=nan(length(Dir.path),length(NamesEp),2,length(Fsamp));
    %
    for man=1:length(Dir.path)
        disp(' '); disp(Dir.path{man})
        cd(Dir.path{man})
        
        try
            % -------------------------------------------------------------
            % ------------------------ get substages ----------------------
            clear WAKE SLEEP NREM REM N1 N2 N3
            disp('... loading RunSubstages')
            [WAKE,REM,N1,N2,N3,NamesStages]=RunSubstages;close
            
            % define SLEEP and NREM
            NREM=or(or(N1,N2),N3);
            NREM=mergeCloseIntervals(NREM,10);
            SLEEP=or(NREM,REM);
            SLEEP=mergeCloseIntervals(SLEEP,10);
            
            % -------------------------------------------------------------
            % ---------------- get PFCx or OB spectrum --------------------
            clear Sptsd Sptsdz tsSp
            % load PFCx Channel and spectrum
            disp(['... loading ',nameStructure,' SpectrumDataL, WAIT!'])
            clear channel Sp t f
            load(['ChannelsToAnalyse/',nameStructure,'.mat'],'channel');
            eval(['load(''SpectrumDataL/Spectrum',num2str(channel),'.mat'',''Sp'',''t'',''f'')'])
            % define var and zscore var
            Sptsd=tsd(t*1E4,mean(Sp(:,f>=frq(1) & f<frq(2)),2));
            Sptsdz=tsd(t*1E4,zscore(mean(Sp(:,f>=frq(1) & f<frq(2)),2)));
            tsSp=tsd(t*1E4,Sp);
            % -------------------------------------------------------------
            % ----------------------- get ZT ------------------------------
            clear NewtsdZT rgZT
            disp('... loading rec time with GetZT_ML.m')
            NewtsdZT=GetZT_ML(Dir.path{man});
            rgZT=Range(NewtsdZT);
            
        end
        
        % -----------------------------------------------------------------
        % ---- get spectrum restricted on epoch, for each ZT point --------
        if exist('WAKE','var') && exist('Sptsd','var') && exist('NewtsdZT','var')
            
            disp('... restricting 2-4Hz mean spectrum on epochs')
            for n=1:length(NamesEp)
                % epoch
                disp(['     - ',NamesEp{n}])
                clear epoch
                eval(['epoch=',NamesEp{n},';'])
                
                for zt=1:length(ZTh)-1
                    % define epoch n ZT
                    st1=rgZT(min((find(Data(NewtsdZT)-ZTh(zt)*1E4>0))));
                    st2=rgZT(min((find(Data(NewtsdZT)-ZTh(zt+1)*1E4>0))));
                    if ~isempty(st1) && isempty(st2),st2=max(rgZT);end
                    epochZT=and(epoch,intervalSet(st1,st2));
                    
                    % get slow oscillation on this epochZT
                    dEZT=sum(Stop(epochZT,'s')-Start(epochZT,'s'));
                    DurEpZT(man,n,zt)=dEZT;
                    if dEZT~=0
                        MAT(man,n,zt)=nanmean(Data(Restrict(Sptsd,epochZT)));
                        MATz(man,n,zt)=nanmean(Data(Restrict(Sptsdz,epochZT)));
                    end
                end
                
                % other method using restrict on ts
                tempSp=Restrict(Sptsd,epoch);
                tempt=Range(tempSp);
                dZT=Data(Restrict(NewtsdZT,ts(tempt)))/1E4; % in second
                temptsd=tsd(dZT,Data(tempSp));
                [tr,xdeb]=min(abs(ZTm-dZT(1)));
                [tr,xfin]=min(abs(ZTm-dZT(end)));
                Matm(man,n,xdeb:xfin)=Data(Restrict(temptsd,ts(ZTm(xdeb:xfin))));
                
                % restrict spectrum on ZT and epoch
                st1=rgZT(min((find(Data(NewtsdZT)-ZTanaly(1)*3600E4>0))));
                st2=rgZT(min((find(Data(NewtsdZT)-ZTanaly(2)*3600E4>0))));
                if ~isempty(st1) && isempty(st2),st2=max(rgZT);end
                epochZT1=and(epoch,intervalSet(st1,st2));
                
                st1=rgZT(min((find(Data(NewtsdZT)-ZTanaly(3)*3600E4>0))));
                st2=rgZT(min((find(Data(NewtsdZT)-ZTanaly(4)*3600E4>0))));
                if ~isempty(st1) && isempty(st2),st2=max(rgZT);end
                epochZT2=and(epoch,intervalSet(st1,st2));
                
                if sum(Stop(epochZT1,'s')-Start(epochZT1,'s'))>0
                    MATsp(man,n,1,:)=interp1(f,nanmean(Data(Restrict(tsSp,epochZT1))),Fsamp); 
                end
                if sum(Stop(epochZT2,'s')-Start(epochZT2,'s'))>0
                    MATsp(man,n,2,:)=interp1(f,nanmean(Data(Restrict(tsSp,epochZT2))),Fsamp); 
                end
            end
        else
            disp('Skip - No Substages or no spectrum for this experiment');
        end
    end
    % saving
    save([res,'/',analyname],'MAT','MATz','Dir','frq','ZTh','ZTm','NamesEp','DurEpZT','Matm','Fsamp','MATsp','ZTanaly');
end

%% zscore and smooth
yl=[0 2E5]; 
if strcmp(nameStructure,'Bulb_deep');yl=[0 1.5E6];end

mice=unique(Dir.name);
%MatA=Matm; ZTA=ZTm;   
%MatA=MAT; ZTA=ZTh(1:end-1);
MatA=MATz;yl=[-1 1.5];ZTA=ZTh(1:end-1);
if 0 % zscore
    yl=[-1 2];
    for man=1:length(Dir.path)
        temp=squeeze(MatA(man,:,:));
        MatA(man,:,:)=nanzscore(temp);
    end
end
id1=find(ZTA>=ZTanaly(1)*3600 & ZTA<ZTanaly(2)*3600);
id2=find(ZTA>=ZTanaly(3)*3600 & ZTA<ZTanaly(4)*3600);

figure('Color',[1 1 1],'Unit','Normalized','Position',[0.3 0.3 0.3 0.3]), numF2=gcf;
for f=1:2
    if f==2 % plot mice
        Mmi=nan(length(mice),size(MatA,2),size(MatA,3));
        for mi=1:length(mice)
            for n=1:length(NamesEp)
                id=find(strcmp(mice{mi},Dir.name));
                if length(id)>1
                    temp=squeeze(MatA(id,n,:));
                else
                    temp=squeeze(MatA(id,n,:))';
                end
                Mmi(mi,n,:)=nanmean(temp,1);
            end
        end
        MatA=Mmi;
    end
    %
    figure('Color',[1 1 1],'Unit','Normalized','Position',[0.1 0.1 0.4 0.4])
    
    clear Matbar
    for n=1:length(NamesEp)
        temp=squeeze(MatA(:,n,:));
        nexpe=sum(isnan(nanmean(temp(:,1:end-1),2))==0);
        subplot(2,length(NamesEp),n), hold on,
        plot(ZTA/3600,smooth(nanmean(temp,1),3),'Color',colori(n,:),'Linewidth',2)
        plot(ZTA/3600,smooth(nanmean(temp,1)+stdError(temp),3),'Color',colori(n,:))
        plot(ZTA/3600,smooth(nanmean(temp,1)-stdError(temp),3),'Color',colori(n,:))
        title(NamesEp{n},'Color',colori(n,:)); xlim([11 18]); ylim(yl)
        if n==1, ylabel([unique(Dir.group),' 2-4Hz ',nameStructure]);end
        
        A=[nanmean(temp(:,id1),2),nanmean(temp(:,id2),2)];
        Matbar(n,1:2)=[nanmean(A(:,1)),nanmean(A(:,2))];
        Matbar(n,3:4)=[nanstd(A(:,1)),nanstd(A(:,2))]./sqrt(nexpe);
        a=find(~isnan(A(:,1)) & ~isnan(A(:,2)));
        %[h,Matbar(n,5)]= ttest2(A(a,1),A(a,2));
        [Matbar(n,5),h]= signrank(A(a,1),A(a,2));
        
        subplot(2,length(NamesEp),length(NamesEp)+n), hold on,
        PlotErrorBarN(A,0,1); %ylim([0 2E5]);
        set(gca,'Xtick',1:2);set(gca,'XtickLabel',{'ZT1','ZT2'})
        if n==4, xlabel(sprintf('n=%d   ZT1 = %1.1fh-%1.1fh, ZT2 = %1.1fh-%1.1fh',nexpe,ZTanaly(1),ZTanaly(2),ZTanaly(3),ZTanaly(4)));end
        title(NamesEp{n},'Color',colori(n,:)); ylim(yl)
    end
    % saveFigure(gcf,['NREMSubStagesEvolSlow',num2str(f)],FolderToSave);
    %
    % only bar plot
    figure(numF2), subplot(1,2,f)
    hold on, bar(Matbar(:,1:2))
    hold on, errorbar([(1:length(NamesEp))-0.15;(1:length(NamesEp))+0.15],Matbar(:,1:2)',Matbar(:,3:4)','+k')
    legend({sprintf('%1.1fh-%1.1fh',ZTanaly(1),ZTanaly(2)),sprintf('%1.1fh-%1.1fh',ZTanaly(3),ZTanaly(4))})
    set(gca,'Xtick',1:length(NamesEp)),set(gca,'XtickLabel',NamesEp)
    for n=1:length(NamesEp)
        if Matbar(n,5)<0.05 && Matbar(n,5)>=0.01
            text(n,1.1*max(Matbar(n,1:2)),'*','Color','r')
        elseif Matbar(n,5)<0.01 && Matbar(n,5)>=0.001
            text(n,1.1*max(Matbar(n,1:2)),'**','Color','r')
        elseif Matbar(n,5)<0.001
            text(n,1.1*max(Matbar(n,1:2)),'***','Color','r')
        else
            text(n,1.1*max(Matbar(n,1:2)),'NS','Color','k')
        end
    end
    title({sprintf('ranksum, n=%d',nexpe),'*p<0.05, **p<0.01, **p<0.001'}) 
    ylim(yl);ylabel([unique(Dir.group),' 2-4Hz ',nameStructure])
end
%saveFigure(gcf,'NREMSubStagesEvolSlowBars',FolderToSave)


%% plot Spectrum
figure('Color',[1 1 1],'Unit','Normalized','Position',[0.1 0.1 0.4 0.6])
for n=1:length(NamesEp)
    temp1=squeeze(MATsp(:,n,1,:));
    temp2=squeeze(MATsp(:,n,2,:));
    for f=1:2
        subplot(2,length(NamesEp),(f-1)*length(NamesEp)+n), hold on,
        % ZT1 ZT2
        plot(Fsamp,10*log10(nanmean(temp1,1)),'Color',colori(n,:),'Linewidth',2)
        plot(Fsamp,10*log10(nanmean(temp2,1)),'Color',colori(n,:),'Linewidth',1)
        nexpe1=sum(isnan(nanmean(temp1,2))==0);
        nexpe2=sum(isnan(nanmean(temp2,2))==0);
        title(sprintf([NamesEp{n},' (n=%d/n=%d)'],nexpe1,nexpe2),'Color',colori(n,:))
    end
    % std
    plot(Fsamp,10*log10(nanmean(temp1,1)+nanstd(temp1)/sqrt(nexpe1)),'Color',colori(n,:),'Linewidth',0.5)
    plot(Fsamp,10*log10(nanmean(temp1,1)-nanstd(temp1)/sqrt(nexpe1)),'Color',colori(n,:),'Linewidth',0.5)
    plot(Fsamp,10*log10(nanmean(temp2,1)+nanstd(temp2)/sqrt(nexpe2)),'Color',colori(n,:),'Linewidth',0.5)
    plot(Fsamp,10*log10(nanmean(temp2,1)-nanstd(temp2)/sqrt(nexpe2)),'Color',colori(n,:),'Linewidth',0.5)
    xlim([0 10])
    if n==4, xlabel('Frequency (Hz)');end
end
legend({sprintf('%1.1fh-%1.1fh',ZTanaly(1),ZTanaly(2)),sprintf('%1.1fh-%1.1fh',ZTanaly(3),ZTanaly(4))})
saveFigure(gcf,'NREMSubStagesEvolSlowSpectrum',FolderToSave)



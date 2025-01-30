% AnalyseOBsubstages_NREMsubstages.m
%
% see also
% 1. AnalyseOBsubstages_Bilan.m
% 2. AnalyseOBsubstages_BilanRespi.m
% 3. AnalyseOBsubstages_NREMsubstages.m
% 4. AnalyseOBsubstages_NREMsubstagesPlethysmo.m
% 5. AnalyseOBsubstages_Rhythms.m
% 6. AnalyseOBsubstages_SleepCycle.m

%<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%% <<<<<<<<<<<<<<<<<<<<<<<<< GENERAL INPUTS <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

FolderToSave='/media/DataMOBsRAID/ProjetAstro/AnalyseOBsubstages/FiguresOBslowDistribSubstages';
res='/media/DataMOBsRAID/ProjetAstro/AnalyseOBsubstages/AnalysesOB';

ZTh=[11,12.5; 16.5,18]*3600;%en second
freq=[2 4];

SavFig=1;

colori=[0.5 0.2 0.1;0.1 0.7 0 ;0.5 0.5 0.5 ;0 0 0;1 0 1 ];
Dir1=PathForExperimentsDeltaSleepNew('BASAL');
Dir1=RestrictPathForExperiment(Dir1,'nMice',[243 244 251 252]);
Dir2=PathForExperimentsML('BASAL');
Dir2=RestrictPathForExperiment(Dir2,'Group','WT');
Dir=MergePathForExperiment(Dir1,Dir2);

strains=unique(Dir.group);
NamesStages={'WAKE','REM','N1','N2','N3'};


%<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%% <<<<<<<<<<<<<<<<<<<< Distrib OBslow on Substages <<<<<<<<<<<<<<<<<<<<<<<
%<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
% ---------------------- INPUTS ---------------------------
Analyname='AnalyseOBsubstages-DistribOBslowSubstages.mat';
cleanFreq1=[1 2];
cleanFreq2=[4 6];
% xbin for histograms, 1001 values
Xbin=0:2E3:2E6;
Xbinz=-2:7/1000:5;
Xbin1=-1:16/1000:15;
Xbin2=-2:17/1000:15;
ploIndiv=1;

% ---------------------- compute ---------------------------
clear MatBAR
try 
    load([res,'/',Analyname]); MatBAR;
    disp([Analyname,' already exists. Loaded.'])
   
catch
    
    MatBAR=nan(6,length(Dir.path),length(NamesStages),3);
    MatSP=nan(6,length(Dir.path),length(NamesStages),length(Xbin));
    MatSpZT=nan(4,length(Dir.path),length(NamesStages),length(Xbin));
    %
    for man=1:length(Dir.path)
        %
        disp(' '); disp(Dir.path{man})
        cd(Dir.path{man})
        %%%%%%%%%%%%%%%%%%%% GET SUBSTAGES %%%%%%%%%%%%%%%%%%%%%%%%
        clear WAKE REM N1 N2 N3 noise
        disp('- RunSubstages.m')
        try  [WAKE,REM,N1,N2,N3,~,~,noise]=RunSubstages;close; end
        if exist('WAKE','var')
            
            %%%%%%%%%%%%%%%%%%%%%%%%% GET ZT %%%%%%%%%%%%%%%%%%%%%%%%%%
            clear NewtsdZT rgZT
            disp('... loading rec time with GetZT_ML.m')
            NewtsdZT=GetZT_ML(Dir.path{man});
            rgZT=Range(NewtsdZT);
            GoodEpoch=intervalSet(rgZT(1),rgZT(end))-noise;
            
            %%%%%%%%%%%%%%%%%% GET OB spectrum 2-4z %%%%%%%%%%%%%%%%%%%
            clear SpOBz SpOB SpOBn1z SpOBn1 SpOBn2 SpOBn2z channel Sp t f
            disp('... loading low Spectrum Bulb_deep')
            load ChannelsToAnalyse/Bulb_deep.mat channel
            eval(['load SpectrumDataL/Spectrum',num2str(channel),'.mat Sp t f'])
            SpOB=tsd(t*1E4,mean(Sp(:,f>freq(1) & f<freq(2)),2));
            SpOB=Restrict(SpOB,GoodEpoch);
            SpOBz=tsd(Range(SpOB),zscore(Data(SpOB)));
            %cleanFreq1
            SpOBn1=tsd(t*1E4,mean(Sp(:,f>freq(1) & f<freq(2)),2)./mean(Sp(:,f>cleanFreq1(1) & f<cleanFreq1(2)),2));
            SpOBn1=Restrict(SpOBn1,GoodEpoch);
            SpOBn1z=tsd(Range(SpOBn1),zscore(Data(SpOBn1)));
            %cleanFreq2
            SpOBn2=tsd(t*1E4,mean(Sp(:,f>freq(1) & f<freq(2)),2)./mean(Sp(:,f>cleanFreq2(1) & f<cleanFreq2(2)),2));
            SpOBn2=Restrict(SpOBn2,GoodEpoch);
            SpOBn2z=tsd(Range(SpOBn2),zscore(Data(SpOBn2)));
            
            %%%%%%%%%%%%%%%%% REPARTITION on Zeitgeber Time %%%%%%%%%%%%%%%%%
            % distrib spOB on epoch early and late sleep
            for i=1:2
                st1=rgZT(min((find(Data(NewtsdZT)-ZTh(i,1)*1E4>0))));
                st2=rgZT(min((find(Data(NewtsdZT)-ZTh(i,2)*1E4>0))));
                if ~isempty(st1) && isempty(st2),st2=max(rgZT);end
                ZTEp1=intervalSet(st1,st2);
                if sum(Stop(ZTEp1,'s')-Start(ZTEp1,'s'))>60*60
                    for nn=1:length(NamesStages)
                        eval(['epoch=',NamesStages{nn},';'])
                        % SpOB
                        [y,x]=hist(Data(Restrict(SpOB,epoch)),Xbin);
                        MatSpZT(i,man,nn,:)=y/sum(y);
                        % SpOBz
                        [yz,x]=hist(Data(Restrict(SpOBz,epoch)),Xbinz);
                        MatSpZT(2+i,man,nn,:)=yz/sum(yz);
                    end
                end
            end
            %
            %%%%%%%%%%%%%%%%%% PLOT INDIV REPARTITION %%%%%%%%%%%%%%%%%%%
            for f=1:2
                dozscore=f-1;
                
                if ploIndiv,figure('Color',[1 1 1],'Unit','Normalized','Position',[0.1 0.2 0.3 0.7]);end
                clear Matbar Matbar2
                for i=1:3
                    % get spectrum and legend
                    if i==1
                        if dozscore, doSp=SpOBz;leg='zscore'; doBin=Xbinz; else, doSp=SpOB;leg=''; doBin=Xbin; end
                        leg={pwd,' ',sprintf([leg,' OB slow %d-%dHz'],freq(1),freq(2))};
                    elseif i==2
                        if dozscore, doSp=SpOBn1;leg='zscore'; else, doSp=SpOBn1z; leg='';end; doBin=Xbin1;
                        leg=sprintf([leg,' normed OB slow %d-%dHz / %d-%dHz'],freq(1),freq(2),cleanFreq1(1),cleanFreq1(2));
                    elseif i==3
                        if dozscore, doSp=SpOBn2; leg='zscore';else, doSp=SpOBn2z; leg='';end; doBin=Xbin2;
                        leg=sprintf([leg,' normed OB slow %d-%dHz / %d-%dHz'],freq(1),freq(2),cleanFreq2(1),cleanFreq2(2));
                    end
                    
                    for nn=1:length(NamesStages)
                        eval(['epoch=',NamesStages{nn},';'])
                        durEp=sum(Stop(epoch,'s')-Start(epoch,'s'));
                        % plot spectrum
                        [y,x]=hist(Data(Restrict(doSp,epoch)),doBin);
                        MatSP(3*(f-1)+i,man,nn,:)=y/sum(y);
                        
                        Matbar(nn,i)=nanmean(Data(Restrict(doSp,epoch)));
                        Matbar1(nn,i)=stdError(Data(Restrict(doSp,epoch)));
                        Matbar2(nn,i)=nanmedian(Data(Restrict(doSp,epoch)));
                        if ploIndiv
                            subplot(3,4,(i-1)*4+(1:2)),hold on,
                            plot(x,SmoothDec(y/sum(y),1),'Color',colori(nn,:),'Linewidth',2)
                            title(leg);
                            ylabel('% values');xlim([1.05*doBin(1),0.95*doBin(end)]);
                        end
                    end
                    if ploIndiv
                        legend(NamesStages)
                        % plot bar
                        subplot(3,4,4*(i-1)+3), bar(Matbar(:,i)) ;
                        hold on, errorbar(1:length(NamesStages),Matbar(:,i),Matbar1(:,i),'+k')
                        set(gca,'Xtick',1:length(NamesStages)); set(gca,'XtickLabel',NamesStages)
                        title('mean')
                        subplot(3,4,4*(i-1)+4), bar(Matbar2(:,i)) ;
                        hold on, errorbar(1:length(NamesStages),Matbar2(:,i),Matbar1(:,i),'+k')
                        set(gca,'Xtick',1:length(NamesStages)); set(gca,'XtickLabel',NamesStages)
                        title('median')
                    end
                end
                MatBAR(3*(f-1)+1,man,:,:)=Matbar;
                MatBAR(3*(f-1)+2,man,:,:)=Matbar1;
                MatBAR(3*(f-1)+3,man,:,:)=Matbar2;
                if SavFig && ploIndiv, saveFigure(gcf,sprintf('AnalyseOB-DistribOBslow%dSubstages%d',dozscore,man),FolderToSave);end
            end
        else
            disp('PROBLEM. No NREM substages in this experiment')
        end
    end
    % saving
    save([res,'/',Analyname],'Dir','MatBAR','MatSP','MatSpZT','freq','cleanFreq1','cleanFreq2','NamesStages','Xbin','Xbinz','Xbin1','Xbin2','ZTh');
end


% display and stats
% cramer test
figure('Color',[1 1 1],'Unit','Normalized','Position',[0.1 0.1 0.4 0.7])
for i=1:2
    if i==1
        doBin=Xbin+2; leg='SpOB';
    else
        doBin=Xbinz+2;leg='zscore SpOB';
    end
    
    clear matbar matspMN matspSD
    Leg={};
    for nn=1:length(NamesStages)
        % mean, std and medians
        temp=squeeze(MatBAR(3*(i-1)+1,:,nn,1));
        matbar(nn,1)=nanmean(temp);
        matbar(nn,2)=stdError(temp);
        matbar(nn,3)=nanmedian(temp);
        % spectrum
        temp=squeeze(MatSP(3*(i-1)+1,:,nn,:));
        subplot(2,5,(i-1)*5+[1:2]), hold on,
        plot(doBin,SmoothDec(nanmean(temp,1),1),'Color',colori(nn,:),'Linewidth',2);
        % cramer stats
        for n2=nn+1:length(NamesStages)
            temp2=squeeze(MatSP(3*(i-1)+1,:,n2,:));
            try [h,p] = kstest2(nanmean(temp,1),nanmean(temp2,1)); catch, p=NaN;end
            Leg=[Leg,sprintf([NamesStages{nn},' vs ',NamesStages{n2},': n=%d, p=%1.4f'],sum(~isnan(nanmean([temp,temp2],2))),p)];
        end
    end
    legend(NamesStages);
    % add error bars
    for nn=1:length(NamesStages)
        temp=squeeze(MatSP(3*(i-1)+1,:,nn,:));
        subplot(2,5,(i-1)*5+[1:2]), hold on,
        plot(doBin,SmoothDec(nanmean(temp,1)+stdError(temp),1),'Color',colori(nn,:));
        plot(doBin,SmoothDec(nanmean(temp,1)-stdError(temp),1),'Color',colori(nn,:));
    end
    xlim([1.05*doBin(1),0.95*doBin(end)]); ylim([0 0.012]);
    set(gca,'xscale','log'); if i==1, xlim([1E3 1E6]);else, xlim([0.3 6]);end
    title(sprintf(['Distribution ',leg,', n=%d, N=%d'],sum(~isnan(nanmean(temp,2))),length(unique(Dir.name(~isnan(nanmean(temp,2)))))))
    xlabel(leg); ylabel('density')
    % display stats Cramer
    subplot(2,5,5*(i-1)+3)
    text(0.1,0.5,Leg ); title('Cramer test')
    % plot bar
    subplot(2,5,5*(i-1)+4), bar(matbar(:,1)) ;
    hold on, errorbar(1:length(NamesStages),matbar(:,1),matbar(:,2),'+k')
    set(gca,'Xtick',1:length(NamesStages)); set(gca,'XtickLabel',NamesStages)
    title('mean')
    subplot(2,5,5*(i-1)+5), bar(matbar(:,3)) ;
    hold on, errorbar(1:length(NamesStages),matbar(:,3),matbar(:,2),'+k')
    set(gca,'Xtick',1:length(NamesStages)); set(gca,'XtickLabel',NamesStages)
    title('median')
end

if SavFig saveFigure(gcf,'AnalyseOB-DistribOBslowPool',FolderToSave);end


% display between ZT1-ZT2
figure('Color',[1 1 1],'Unit','Normalized','Position',[0.1 0.1 0.4 0.6])
for i=1:2
    if i==1, doBin=Xbin; leg='SpOB';else, doBin=Xbinz;leg='zscore SpOB';end
    for nn=1:length(NamesStages)
        subplot(2,length(NamesStages),(i-1)*length(NamesStages)+nn), hold on,
        tempZT1=squeeze(MatSpZT(2*(i-1)+1,:,nn,:));
        tempZT2=squeeze(MatSpZT(2*(i-1)+2,:,nn,:));    
        plot(doBin,SmoothDec(nanmean(tempZT1,1),1),'Color',colori(nn,:),'Linewidth',2)  
        plot(doBin,SmoothDec(nanmean(tempZT2,1),1),'Color',colori(nn,:))    
        xlim([1.05*doBin(1),0.7*doBin(end)]); ylim([0 0.012]);
        title([leg,' during ',NamesStages{nn}])
    end
    legend({sprintf('%1.1f-%1.1fh',ZTh(1,1)/3600,ZTh(1,2)/3600),sprintf('%1.1f-%1.1fh',ZTh(2,1)/3600,ZTh(2,2)/3600)})
end

if SavFig saveFigure(gcf,'AnalyseOB-DistribOBslowZTdecrease',FolderToSave);end

%<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%% <<<<<<<<<<<<<<<< Distrib OBslow on ZT & substages <<<<<<<<<<<<<<<<<<<<<<
%<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
% ---------------------- INPUTS ---------------------------
Analyname='AnalyseOBsubstages-DistribOBslowSubstagesZT.mat';
% xbin for histograms, 1001 values
Xbin=0:2E3:2E6;
Xbinz=-2:7/1000:5;
ploIndiv=1;

% ---------------------- compute ---------------------------
clear MatSpZT
try 
    load([res,'/',Analyname]); MatSpZT;
    disp([Analyname,' already exists. Loaded.'])
catch
    MatSpZT=nan(length(Dir.path),length(NamesStages),size(ZTh,1),length(Xbin));
    MatSpzZT=nan(length(Dir.path),length(NamesStages),size(ZTh,1),length(Xbin));
    %
    for man=1:length(Dir.path)
        %
        disp(' '); disp(Dir.path{man})
        cd(Dir.path{man})
        %%%%%%%%%%%%%%%%%%%% GET SUBSTAGES %%%%%%%%%%%%%%%%%%%%%%%%
        clear WAKE REM N1 N2 N3 GoodEpoch
        disp('- RunSubstages.m')
        try  [WAKE,REM,N1,N2,N3]=RunSubstages;close; end
        if exist('WAKE','var')
            GoodEpoch=or(or(WAKE,REM),or(or(N1,N2),N3));
            GoodEpoch=mergeCloseIntervals(GoodEpoch,10);
           
            %%%%%%%%%%%%%%%%%%%%%%%%% GET ZT %%%%%%%%%%%%%%%%%%%%%%%%%%
            clear NewtsdZT rgZT
            disp('... loading rec time with GetZT_ML.m')
            NewtsdZT=GetZT_ML(Dir.path{man});
            rgZT=Range(NewtsdZT);
            
            %%%%%%%%%%%%%%%%%% GET OB spectrum 2-4z %%%%%%%%%%%%%%%%%%%
            clear SpOBz SpOB channel Sp t f
            disp('... loading low Spectrum Bulb_deep')
            load ChannelsToAnalyse/Bulb_deep.mat channel
            eval(['load SpectrumDataL/Spectrum',num2str(channel),'.mat Sp t f'])
            SpOB=tsd(t*1E4,mean(Sp(:,f>freq(1) & f<freq(2)),2));
            SpOB=Restrict(SpOB,GoodEpoch);
            SpOBz=tsd(Range(SpOB),zscore(Data(SpOB)));
            
            
            %%%%%%%%%%%%%%%%% REPARTITION on Zeitgeber Time %%%%%%%%%%%%%%%%%
            % distrib spOB on epoch early and late sleep
            if ploIndiv,figure('Color',[1 1 1],'Unit','Normalized','Position',[0.1 0.2 0.3 0.5]);end
            leg=sprintf('OB slow %d-%dHz',freq(1),freq(2));
            for i=1:size(ZTh,1)
                st1=rgZT(min((find(Data(NewtsdZT)-ZTh(i,1)*1E4>0))));
                st2=rgZT(min((find(Data(NewtsdZT)-ZTh(i,2)*1E4>0))));
                if ~isempty(st1) && isempty(st2),st2=max(rgZT);end
                ZTEp1=intervalSet(st1,st2);
                if sum(Stop(ZTEp1,'s')-Start(ZTEp1,'s'))>60*60
                    for nn=1:length(NamesStages)
                        eval(['epoch=and(ZTEp1,',NamesStages{nn},');'])
                        % SpOB
                        [y,x]=hist(Data(Restrict(SpOB,epoch)),Xbin);
                        MatSpZT(man,nn,i,:)=y/sum(y);
                        % SpOBz
                        [yz,x]=hist(Data(Restrict(SpOBz,epoch)),Xbinz);
                        MatSpzZT(man,nn,i,:)=yz/sum(yz);
                        
                        % plot indiv repartition
                        if ploIndiv
                            subplot(2,2,i),hold on,
                            plot(Xbin,SmoothDec(y/sum(y),5),'Color',colori(nn,:),'Linewidth',2)
                            if nn==1, xlabel(leg); title(sprintf('Distrib at %1.1fh,%1.1fh',ZTh(i,1)/3600,ZTh(i,2)/3600));end
                            subplot(2,2,2+i),hold on,
                            plot(Xbinz,SmoothDec(yz/sum(yz),5),'Color',colori(nn,:),'Linewidth',2)
                            if nn==1, xlabel(['zscore ',leg]);title(sprintf('zscore Distrib at %1.1fh,%1.1fh',ZTh(i,1)/3600,ZTh(i,2)/3600));end
                        end
                    end
                end
            end
            subplot(2,2,1),text(min(xlim)+diff(xlim)*0.3,1.15*max(ylim),pwd)
            % savFigure
            if SavFig && ploIndiv, saveFigure(gcf,sprintf('AnalyseOB-DistribOBslowZTSubstages%d',man),FolderToSave);end
        else
            disp('PROBLEM. No NREM substages in this experiment')
        end
    end
    % saving
    save([res,'/',Analyname],'Dir','MatSpzZT','MatSpZT','freq','NamesStages','Xbin','Xbinz','ZTh');
end


%% display pool zscore between ZT1-ZT2

colori=[0.5 0.2 0.1;0.1 0.7 0 ;0.6 0.2 1 ;1 0.5 1 ;0.8 0 0.7 ];
figure('Color',[1 1 1],'Unit','Normalized','Position',[0.1 0.1 0.4 0.6])
%MatSpzZT=nan(length(Dir.path),length(NamesStages),size(ZTh,1),length(Xbin));
for nn=1:length(NamesStages)
    tempZT1=squeeze(MatSpzZT(:,nn,1,:));
    tempZT2=squeeze(MatSpzZT(:,nn,2,:));
    
    subplot(3,length(NamesStages),nn), hold on,
    plot(Xbinz,SmoothDec(nanmean(tempZT1,1),5),'Color',colori(nn,:),'Linewidth',2)
    plot(Xbinz,SmoothDec(nanmean(tempZT2,1),5),'Color',[0.5 0.5 0.5],'Linewidth',2)
    
    subplot(3,length(NamesStages),[6,7,11,12]), hold on,
    plot(Xbinz,SmoothDec(nanmean(tempZT1,1),5),'Color',colori(nn,:),'Linewidth',2)
    
    subplot(3,length(NamesStages),[8,9,13,14]), hold on,
    plot(Xbinz,SmoothDec(nanmean(tempZT2,1),5),'Color',colori(nn,:),'Linewidth',2)
end
legend(NamesStages)
subplot(3,length(NamesStages),nn),
legend({sprintf('%1.1f-%1.1fh',ZTh(1,1)/3600,ZTh(1,2)/3600),sprintf('%1.1f-%1.1fh',ZTh(2,1)/3600,ZTh(2,2)/3600)})

for nn=1:length(NamesStages)
    tempZT1=squeeze(MatSpzZT(:,nn,1,:));
    tempZT2=squeeze(MatSpzZT(:,nn,2,:));
    subplot(3,length(NamesStages),nn), hold on,
    plot(Xbinz,SmoothDec(nanmean(tempZT1,1)-stdError(tempZT1),5),'Color',colori(nn,:))
    plot(Xbinz,SmoothDec(nanmean(tempZT1,1)+stdError(tempZT1),5),'Color',colori(nn,:))
    plot(Xbinz,SmoothDec(nanmean(tempZT2,1)-stdError(tempZT2),5),'Color',[0.5 0.5 0.5])
    plot(Xbinz,SmoothDec(nanmean(tempZT2,1)+stdError(tempZT2),5),'Color',[0.5 0.5 0.5])
    xlim([1.05*Xbinz(1),0.7*Xbinz(end)]); ylim([0 0.01]);
    title(sprintf([NamesStages{nn},'  zscore OB slow %d-%dHz'],freq(1),freq(2)),'Color',colori(nn,:))
    
    subplot(3,length(NamesStages),[6,7,11,12]), hold on,
    plot(Xbinz,SmoothDec(nanmean(tempZT1,1)-stdError(tempZT1),5),'Color',colori(nn,:))
    plot(Xbinz,SmoothDec(nanmean(tempZT1,1)+stdError(tempZT1),5),'Color',colori(nn,:))
    xlim([1.05*Xbinz(1),0.7*Xbinz(end)]); ylim([0 0.01]);
    if nn==1, title(sprintf('zscore OB slow %1.1f-%1.1fh',ZTh(1,1)/3600,ZTh(1,2)/3600));end
    
    subplot(3,length(NamesStages),[8,9,13,14]), hold on,
    plot(Xbinz,SmoothDec(nanmean(tempZT2,1)-stdError(tempZT2),5),'Color',colori(nn,:))
    plot(Xbinz,SmoothDec(nanmean(tempZT2,1)+stdError(tempZT2),5),'Color',colori(nn,:))
    xlim([1.05*Xbinz(1),0.7*Xbinz(end)]); ylim([0 0.01]);
    if nn==1; title(sprintf('zscore OB slow %1.1f-%1.1fh',ZTh(2,1)/3600,ZTh(2,2)/3600));end
end


if SavFig saveFigure(gcf,'AnalyseOB-DistribOBslowZTAll','/home/mobsyoda/Dropbox/MOBs_ProjetBulbe/FIGURES/FigureOBstages');end






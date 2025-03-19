% Parcours_EvolutionSlow.m
% called in FiguresGaetan01072015.m
% needs TempEvolutionSlowML.m


% see TempEvolutionSlowBulbML.m
% TempEvolutionSlowBulb.m code Karim
% GenerateDeltaSpindlesRipplesML.m

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%% Give inputs %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% StructureDelta='Bulb';
StructureDelta='PaCx';
% StructureDelta='PFCx'; 

freqSlow=[2 4];
freqUSlow=[0.5 1.5];

clearBadData=1;
fac=1.5;% default = 1
RescaleAndSmooth=0;
useSleepScoringSB=0;
removeNoisyEpochs=1;

ZeitTime0=8; % time of the begining of the lighthase / 24h
nbBins=1E3; % default : 1000 points
ZTrange=[0 12];
ZTmat=min(ZTrange)+(max(ZTrange)-min(ZTrange))*[1:nbBins]/nbBins;

opt='GL';% '' for ZT epochs 'GL' for epochsToAnalyse

nameEpochs={'Wake','SWSEpoch','REMEpoch'}; 
nameEpochsGL={'Epoch1','Epoch2','Epoch3','Epoch4','Epoch5'}; 


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% %%%%%%%%%%%%%%%%%%%%%%%% Get all Data sleep Basal %%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% Dir1=PathForExperimentsBULB('SLEEPBasal');
% Dir1=RestrictPathForExperiment(Dir1,'Group','CTRL');
% Dir2=PathForExperimentsML('BASAL');%'BASAL','PLETHYSMO','DPCPX', 'LPS', 'CANAB';
% Dir2=RestrictPathForExperiment(Dir2,'Group',{'WT','C57'});
% Dir=MergePathForExperiment(Dir1,Dir2);

if strcmp(opt,'GL');
    Dir=PathForExperimentsDeltaSleepNew('BASAL');
    Dir=RestrictPathForExperiment(Dir,'nMice',[244 243 251 252]);
else
    Dir=PathForExperimentsML('BASAL');
    Dir=RestrictPathForExperiment(Dir,'Group','WT');   
end

strains=unique(Dir.group);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% %%%%%%%%%%%%%% compare Sp for all mice %%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
FileSuffix=[StructureDelta,'_',num2str(freqSlow(1)),'-',num2str(freqSlow(2)),'Hz_',opt];
for i=1:length(strains), FileSuffix=[FileSuffix,strains{i}];end
res='/media/DataMOBsRAID/ProjetAstro/AnalyseTempEvolutionSlow/';
FileToSave=['AnalyseSlow',FileSuffix];
mkdir([res,FileToSave])
clear MatSpL MatEpochs MatInfo

% Spectrum Params
[paramsL,movingwinL]=SpectrumParametersML('low',0);
FL=paramsL.fpass(1):diff(paramsL.fpass)/200:paramsL.fpass(2);

try
    load([res,FileToSave,'/',FileToSave]);
    MatSpL{1}; AllZT_sta(1);
    disp('Loading existing data, Dir has been reloaded')
    
catch
    MatEpochs={}; EpAnaly={};
    MatInfo=[];
    for ep=1:length(nameEpochs),MatSpL{ep}=nan(length(Dir.path),length(FL));end
    AllZT_sta=nan(length(Dir.path),length(ZTmat));AllZT_sto=AllZT_sta;
    SpSlow={}; SpSlow=tsdArray(SpSlow);
    SpUSlow={}; SpUSlow=tsdArray(SpUSlow);
    DeltaTS={}; DeltaTS=tsdArray(DeltaTS);
end

for man=1:length(Dir.path)
    
    cd(Dir.path{man})
        disp('  ')
        disp([Dir.group{man},' ',Dir.path{man}])
        temp1=MatSpL{1};
        
    if sum(isnan(temp1(man,:)))==length(FL)
        
        % save MatInfo = [group strains, nb mouse]
        MatInfo(man,1)=find(strcmp(strains,Dir.group{man}));
        MatInfo(man,2)=str2double(Dir.name{man}(strfind(Dir.name{man},'Mouse')+5:end));
        
        h = waitbar(0,'Analysing TempEvolutionSlowML');

        try
            % %%%%%%%%%%%%%%%%%%%%% TempEvolutionSlowML.m %%%%%%%%%%%%%%%%%
            [SpL,fL,temp_Epochs,temp_Slow,temp_USlow,temp_ZT]=TempEvolutionSlowML(...
                    'Structure',[StructureDelta,'_deep'],...
                    'movingwin',movingwinL,'params',paramsL,...
                    'SOfreq',freqSlow,'uSOfreq',freqUSlow);
            waitbar(1/5)    
                
            % %%%%%%%%%%%%%%%%%% save Spectra & epochs %%%%%%%%%%%%%%%%%%%%
            % save spectra restricted to epochs
            SpSlow{man} = temp_Slow;
            % save Uslow to clean spectra
            SpUSlow{man} = temp_USlow;
            % save Epochs 
            n=length(temp_Epochs);
            MatEpochs(man,1:n) = temp_Epochs;
                
            
            % %%%%%%%%%%%%%%%%%%%%% Restrict on epochs %%%%%%%%%%%%%%%%%%%%
            for ep=1:n
                tempSpL=MatSpL{ep};
                tempSpL(man,:)=interp1(fL,mean(Data(Restrict(SpL,temp_Epochs{ep})),1),FL);
                if ep==1 && sum(isnan(tempSpL(man,:)))==length(FL)
                    tempSpL(man,1)=0;
                end
                MatSpL{ep}=tempSpL;
            end
            waitbar(2/5)
            % %%%%%%%%%%%%%%%%%%%%% ZT intervalsets %%%%%%%%%%%%%%%%%%%%%%%
            disp('...Calculating ZT intervalSets')
            invZTtsd=tsd(Data(temp_ZT),Range(temp_ZT));
            for a=1:length(ZTmat)-1
                dt=Data(Restrict(invZTtsd,intervalSet((ZTmat(a)+ZeitTime0)*3600E4,(ZTmat(a+1)+ZeitTime0)*3600E4)));
                try
                    AllZT_sta(man,a)=min(dt);
                    AllZT_sto(man,a)=max(dt);
                end
            end
            waitbar(3/5)
            % %%%%%%%%%%%%%%%%%%%%%  epochs Gaetan %%%%%%%%%%%%%%%%%%%%%%%%
            if strcmp(opt,'GL');
                disp('...Loading EpochToAnalyse.mat')
                
                clear EpochToAnalyse 
                load EpochToAnalyse EpochToAnalyse 
                % save EpochToAnalyse
                EpAnaly(man,1:length(EpochToAnalyse)) = EpochToAnalyse;
            else
                EpAnaly{man}=intervalSet([],[]);
            end
            
            % %%%%%%%%%%%%%%%%%%%%%%%% time Delta %%%%%%%%%%%%%%%%%%%%%%%%%
            if strcmp(StructureDelta,'PaCx') || strcmp(StructureDelta,'PFCx')
                try
                    disp('Loading Delta times')
                    eval(['temp1=load(''newDelta',StructureDelta,'.mat'',''tDelta'');']);
                    DeltaTS{man}=ts(temp1.tDelta);
                catch
                    disp('Problem loading delta... skip')
                end
            end
            waitbar(4/5)
            
            % %%%%%%%%%%%%%%%%%%%%%%%%% SAVE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            disp('saving...')            
            save([res,FileToSave,'/',FileToSave],'-v7.3','MatSpL','SpSlow','SpUSlow','MatEpochs',...
                'AllZT_sta','AllZT_sto','EpAnaly','Dir','FL','freqSlow',...
                'DeltaTS','freqUSlow','MatInfo','paramsL','movingwinL','ZTmat')
            waitbar(5/5)
            close(h)
        catch
            disp('problem'); close(h); keyboard
        end
        
    else
        if sum(isnan(temp1(man,:)))==length(FL)-1; 
            temp1(man,1)=nan;
            MatSpL{1}=temp1;
        end
        disp('Defined already for this expe. skip...')
    end
end
%save(FileToSave,'MatSpL','MatEpochs','MatInfo','FL','Dir','freqSlow','AllZT','SpSlow','SpUSlow');
cd(res)


%% ------------------------ CLEAR SPECTRA ---------------------------------
% -------------------------------------------------------------------------

if clearBadData
    disp('Cleaning data when UltraSlow above slow')
    for man=1:length(Dir.path)
            temp1=Data(SpSlow{man});
            temp2=Data(SpUSlow{man});
            rg=Range(SpSlow{man});

            ind=find(temp2<=fac*temp1);
            SpSlow{man}=tsd(rg(ind),temp1(ind));
            SpUSlow{man}=tsd(rg(ind),temp2(ind));
    end
end


%% ------------------------ RESCALE 0 - 1 ---------------------------------
% -------------------------------------------------------------------------
if RescaleAndSmooth
    disp('Rescaling btw 0 and 1')
    for man=1:length(Dir.path)
        try
            temp=Data(SpSlow{man});
            rg=Range(SpSlow{man});
            SpSlow{man}=tsd(rg,SmoothDec(rescale(temp,0,1),200));
        end
        
    end
end


%% ------------------------- POOL SAME MICE -------------------------------
% -------------------------------------------------------------------------
mice=unique(MatInfo(:,2));
%mice([find(mice==147),find(mice==148),find(mice==161)])=[];

figure('Color',[1 1 1])
set(gcf,'Units','normalized','Position',[0.1 0.3 0.4 0.6])
colori=colormap('jet');

for ep=1:length(nameEpochs)
    temp1=MatSpL{ep};
    tempMATL=nan(length(mice),length(FL));
    
    for mi=1:length(mice)
        index=find(MatInfo(:,2)==mice(mi));
        tempMATL(mi,:)=nanmean([nan(1,size(temp1,2));temp1(index,:)]);
        subplot(2,length(nameEpochs),ep), hold on,
        plot(FL,10*log10(tempMATL(mi,:)),'Color',colori(floor(64*mi/length(mice)),:))
        title([nameEpochs{ep},'  - Low frequency mean spectrum']); ylabel([StructureDelta,' Power']), ylim([30 70])
        
        subplot(2,length(nameEpochs),length(nameEpochs)+ep), hold on,
        for i=1:length(index)
            plot(FL,10*log10(temp1(index(i),:)),'Color',colori(floor(64*mi/length(mice)),:))
        end
        title([nameEpochs{ep},'  - Low frequency ALL spectrum']); ylabel([StructureDelta,' Power']), ylim([30 70])
        if ep==2, xlabel('Frequency (Hz)');end
    end
    MATL{ep}=tempMATL;
end
subplot(2,length(nameEpochs),length(nameEpochs));legend(num2str(mice))
saveFigure(gcf,['MeanSpecL_allmice',FileSuffix],[res,FileToSave])



%% ------------------------ PLOT SPECTRA PER ZT ---------------------------
%--------------------------------------------------------------------------
figure('Color',[1 1 1]),
set(gcf,'Units','normalized','Position',[0.2 0.2 0.2 0.7])
try
    MAT{1}(1,2);
    MATdelta{1}(1,2);
    disp('MAT (restricted Spectra per ZT epochs) exists...');
    for et=1:length(nameEpochs)
        tempMat=MAT{et};
        subplot(length(nameEpochs),1,et), hold on
        for man=1:length(Dir.path)
            plot(ZTmat(1:nbBins-1),tempMat(man,:),'k');
        end
        if strcmp(StructureDelta,'Bulb'), ylim([0 2]*1E6) ; else, ylim([0 2]*1E5) ;end
        ylabel([StructureDelta,' Slow Amp'])
        title([StructureDelta,' - Single experiment Evolution slow (',num2str(freqSlow(1)),'-',num2str(freqSlow(2)),'Hz) - ',nameEpochs{et}])
    end
        
catch
    
    disp('Restricting Spectra per ZT epochs (takes some time)...');
    
    for et=1:length(nameEpochs)
        subplot(length(nameEpochs),1,et), hold on
        h = waitbar(0,[nameEpochs{et},': Restricting Spectra per ZT']);
        
        tempMat=nan(length(Dir.path),nbBins-1);
        tempDeltaMat=tempMat;
        for man=1:length(Dir.path)
            waitbar(man/length(Dir.path));
            clear tDelta
            if strcmp(StructureDelta,'PaCx') || strcmp(StructureDelta,'PFCx'), tDelta=DeltaTS{man}; end
            
            ind=find(~isnan(AllZT_sta(man,:)));
            for a=ind
                I=intervalSet(AllZT_sta(man,a),AllZT_sto(man,a));
                try tempMat(man,a)=nanmean(Data(Restrict(SpSlow{man},and(I,MatEpochs{man,et}))));end
                try tempDeltaMat(man,a)=length(Data(Restrict(tDelta,and(I,MatEpochs{man,et}))));end
            end
            plot(ZTmat(1:nbBins-1),tempMat(man,:),'k');
            
        end
        
        MAT{et}=tempMat;
        MATdelta{et}=tempDeltaMat;
        if strcmp(StructureDelta,'Bulb'), ylim([0 2]*1E6) ; else, ylim([0 2]*1E5) ;end
        ylabel([StructureDelta,' Slow Amp'])
        title([StructureDelta,' - Single experiment Evolution slow (',num2str(freqSlow(1)),'-',num2str(freqSlow(2)),'Hz) - ',nameEpochs{et}])
        
        close(h)
    end
    
    save([res,FileToSave,'/',FileToSave],'-append','MAT','MATdelta')
end
xlabel('ZeitGeber Time')


%%
figure('Color',[1 1 1]),
set(gcf,'Units','normalized','Position',[0.2 0.1 0.2 0.7])

for et=1:length(nameEpochs)
    subplot(length(nameEpochs),1,et)
    ind_wt=[find(MatInfo(:,1)==1);find(MatInfo(:,1)==2)];
    plot(ZTmat(1:nbBins-1), nanmean(MAT{et}(ind_wt,:)),'k','Linewidth',2)
    hold on, plot(ZTmat(1:nbBins-1), nanmean(MAT{et}(ind_wt,:))+stdError(MAT{et}(ind_wt,:)),'k')
    hold on, plot(ZTmat(1:nbBins-1), nanmean(MAT{et}(ind_wt,:))-stdError(MAT{et}(ind_wt,:)),'k')
    if strcmp(StructureDelta,'Bulb'), ylim([0 2]*1E6) ; else, ylim([0 2]*1E5) ;end
    ylabel([StructureDelta,' Slow Amp'])
    title([StructureDelta,' - Evolution slow (',num2str(freqSlow(1)),'-',num2str(freqSlow(2)),'Hz) - ',nameEpochs{et}])
end
legend({strains{1},['(n=',num2str(length(ind_wt)),')']})
xlabel('ZeitTime')
saveFigure(gcf,['SlowEvolution_allmice',FileSuffix],[res,FileToSave])

%% Figure Smoothed
figure('Color',[1 1 1]),
set(gcf,'Units','normalized','Position',[0.2 0.1 0.2 0.7])

for et=1:length(nameEpochs)
    subplot(length(nameEpochs),1,et)
    ind_wt=[find(MatInfo(:,1)==1);find(MatInfo(:,1)==2)];
    
    % get rid of nans
    tps=ZTmat(1:nbBins-1);
    Medval=nanmedian(MAT{et}(ind_wt,:));
    Stdval=stdError(MAT{et}(ind_wt,:));
    indok=find(~isnan(Medval));
    
    
    plot(tps(indok), SmoothDec(Medval(indok),2),'k','Linewidth',2)
    hold on, plot(tps(indok), SmoothDec(Medval(indok)+Stdval(indok),2),'k')
    hold on, plot(tps(indok), SmoothDec(Medval(indok)-Stdval(indok),2),'k')
    
    if strcmp(StructureDelta,'Bulb'), ylim([0 2]*1E6) ; else, ylim([0 1]*1E5) ;end
    ylabel([StructureDelta,' Slow Amp'])
    title([StructureDelta,' - Evolution slow (',num2str(freqSlow(1)),'-',num2str(freqSlow(2)),'Hz) - ',nameEpochs{et}])
end
legend({strains{1},['(n=',num2str(length(ind_wt)),')']})
xlabel('ZeitTime')
saveFigure(gcf,['SlowEvolution_allmiceSmoothed',FileSuffix],[res,FileToSave])


%% ------------------------ PLOT RATIO SPECTRA ZT1/ZT2 ---------------------------
%--------------------------------------------------------------------------
ZTall=[1:12];
ZT1=[3 4.5]; % early sleep period
ZT2=[8.5 10]; % late sleep period
a1=find(ZTmat>=(ZT1(1)) & ZTmat<(ZT1(2)));
a2=find(ZTmat>=(ZT2(1)) & ZTmat<(ZT2(2)));
clear MATT
disp('Computing RATIO SPECTRA ZT1/ZT2')
h = waitbar(0,'Computing RATIO SPECTRA ZT1/ZT2');
for et=1:length(nameEpochs)
	tempMat=nan(length(Dir.path),length(ZTall)+1);
    
    for man=1:length(Dir.path)
        % allZT
        for a=1:length(ZTall)-1
            a_all=find(ZTmat>=(ZTall(a)) & ZTmat<(ZTall(a+1)));
            I=intervalSet(min(AllZT_sta(man,a_all)),max(AllZT_sto(man,a_all)));
            tempMat(man,a)=nanmean(Data(Restrict(SpSlow{man},and(I,MatEpochs{man,et}))));
        end
        % ZT1 et ZT2
        I1=intervalSet(min(AllZT_sta(man,a1)),max(AllZT_sto(man,a1)));
        I2=intervalSet(min(AllZT_sta(man,a2)),max(AllZT_sto(man,a2)));
        tempMat(man,length(ZTall))=nanmean(Data(Restrict(SpSlow{man},and(I1,MatEpochs{man,et}))));
        tempMat(man,length(ZTall)+1)=nanmean(Data(Restrict(SpSlow{man},and(I2,MatEpochs{man,et}))));
        waitbar(((et-1)*length(Dir.path)+man)/(length(nameEpochs)*length(Dir.path)))
    end
    MATT{et}=tempMat;
end
close(h)

%% --------------------------------------
% plot all data, differentiate mice
Uwt=unique(MatInfo(:,2));
figure('Color',[1 1 1]),
set(gcf,'Units','normalized','Position',[0.2 0.1 0.2 0.7])
yl=[];
for et=1:length(nameEpochs)
    a=zeros(1,length(Uwt))-2;
    for man=1:length(Dir.path)
        subplot(length(nameEpochs),1,et), hold on,
        n=find(Uwt==MatInfo(man,2));
        a(n)=a(n)+1;
        line([1 1]+n+0.1*a(n),[MATT{et}(man,end-1),MATT{et}(man,end)],'Color',[0.5 0.5 0.5])
        plot(1+n+0.1*a(n),MATT{et}(man,end-1),'ok','MarkerFaceColor','k')
        plot(1+n+0.1*a(n),MATT{et}(man,end),'ob','MarkerFaceColor','b')
        yl=max([yl,ylim]);
    end
end

leg=[];
for uu=1:length(Uwt), leg=[leg,{num2str(Uwt(uu))}];end
for et=1:length(nameEpochs)
    subplot(length(nameEpochs),1,et), hold on,
    xlim([1,length(Uwt)+2])
    set(gca,'xtick',2:length(Uwt)+1)
    set(gca,'xticklabel',leg)
    ylim([0 yl])
    ylabel([StructureDelta,' Amp slow']);
    if et==1
        title([nameEpochs{et},' - ',StructureDelta,' slow (',num2str(freqSlow(1)),'-',num2str(freqSlow(2)),'Hz), early and later in the day']);
    end
    if et==length(nameEpochs), 
        xlabel(['# ',strains{1},'Mouse']);
        legend({'Same day',['ZT ',num2str(ZT1(1)),'-',num2str(ZT1(2)),'h'],['ZT ',num2str(ZT2(1)),'-',num2str(ZT2(2)),'h']})
    end
end
saveFigure(gcf,['SlowDiff_allmice',FileSuffix],[res,FileToSave])

%% BAR PLOTS
clear diffMATT ratioMATT
for man=1:length(Dir.path)
    for et=1:length(nameEpochs)
        diffMATT(man,et)=MATT{et}(man,end-1)-MATT{et}(man,end);
        ratioMATT(man,et)=MATT{et}(man,end-1)./MATT{et}(man,end);
    end
end

colori={'r','m','b','c','g','k','y'};
Umice=unique(MatInfo(:,2));

for f=1:2
    
    figure('Color',[1 1 1]),
    set(gcf,'Units','normalized','Position',[0.1 0.1 0.4 0.8])
    
    clear MATTbar diffMATTbar ratioMATTbar MatInfobar temp
    if f==2
        % ----------- POOL MICE ------------
        for et=1:length(nameEpochs)
            for mi=1:length(Umice)
                    ind=find(MatInfo(:,2)==Umice(mi));
                    temp(mi,:)=nanmean(MATT{et}(ind,:));
                    diffMATTbar(mi,et)=nanmean(diffMATT(ind,et));
                    ratioMATTbar(mi,et)=nanmean(diffMATT(ind,et));
                    if et==1, MatInfobar(mi,:)=MatInfo(ind(1),:);end
            end
            MATTbar{et}=temp;
        end
    else
        MATTbar=MATT;
        diffMATTbar=diffMATT;
        ratioMATTbar=ratioMATT;
        MatInfobar=MatInfo;
    end
    
    % ------- plot -------
    for et=1:length(nameEpochs)
        % all ZT
        subplot(length(nameEpochs),8,8*(et-1)+[1:4])
        PlotErrorBar(MATTbar{et}(:,1:end-2),0)
        for mi=1:length(Umice)
            ind=find(MatInfobar(:,2)==Umice(mi));
            for i=1:length(ind)
                hold on, plot(MATTbar{et}(ind(i),1:end-2),'Color',colori{mi})
            end
        end
        set(gca,'xtick',1:11)
        set(gca,'xticklabel',1:11)
        ylabel([StructureDelta,' ',nameEpochs{et}]); 
        if et==length(nameEpochs), xlabel('All ZT (hr)');end
        
        % ZT1 and ZT2
        subplot(length(nameEpochs),8,4+8*(et-1)+[1 2])
        p=PlotErrorBarN([MATTbar{et}(:,end-1),MATTbar{et}(:,end)],0,1);
        set(gca,'xtick',[1 2])
        set(gca,'xticklabel',{'ZT1 ','ZT2'})
        title([strains{1},' (p=',num2str(floor(1E3*p)/1E3),')'])
        if et==length(nameEpochs), xlabel(['ZT1 ',num2str(ZT1(1)),'-',num2str(ZT1(2)),', ',...
                'ZT2 ',num2str(ZT2(1)),'-',num2str(ZT2(2))]);end
        
        % difference pooled
        subplot(length(nameEpochs),8,4+8*(et-1)+length(nameEpochs))
        PlotErrorBarN(diffMATTbar(:,et),0,1);
        set(gca,'xtick',1)
        set(gca,'xticklabel',{[strains{1},' (n=',num2str(length(ind_wt)),')']})
        title(' ZT1-ZT2 ')
        
        % ratio
        subplot(length(nameEpochs),8,4+8*(et-1)+4)
        PlotErrorBarN(10*log10(ratioMATTbar(:,et)),0,1);
        set(gca,'xtick',1)
        set(gca,'xticklabel',{[strains{1},' (n=',num2str(length(ind_wt)),')']})
        title(' log(ZT1/ZT2) ')
    end
    
    if f==2
        subplot(length(nameEpochs),8,8*(et-1)+[1:4]), legend( ['std','mean',unique(Dir.name)]);
        saveFigure(gcf,['SlowBars_allmice',FileSuffix],[res,FileToSave])
    else
        saveFigure(gcf,['SlowBars_allExpe',FileSuffix],[res,FileToSave])
    end
end


%% -------------------- Correlation slow et nb delta -------------------
%--------------------------------------------------------------------------
if strcmp(opt,'GL');
    
    figure('Color',[1 1 1]),
    set(gcf,'Units','normalized','Position',[0.1 0.4 0.2 0.8])
    
    et=find(strcmp(nameEpochs,'SWSEpoch'));
    tempMat=MAT{et};
    tempDeltaMat=MATdelta{et};
    
    for mi=1:length(Umice)
        subplot(length(Umice),1,mi), hold on,
        ind=find(MatInfo(:,2)==Umice(mi));
        leg=[];
        for i=1:length(ind)
            X=tempMat(ind(i),:); X=X(:);
            Y=tempDeltaMat(ind(i),:);Y=Y(:);
            plot(X,Y,'.','Color',colori{i})
            
            index=find(~isnan(X) & ~isnan(Y));
            [RHO,PVAL] = corr(X(index),Y(index));
            [a, b] = regression_line(X(index), Y(index));
            line([2 12]*1E4,[2 12]*b*1E4+a,'Color',colori{i},'Linewidth',2)
            leg=[leg,{['exp ',num2str(i)],['r=',num2str(floor(1E2*RHO)/1E2),', p=',num2str(PVAL)]}];
        end
        title([StructureDelta,' Mouse',num2str(Umice(mi)),' - ',nameEpochs{et}])
        xlim([0 15E4]), if mi==length(Umice), xlabel('Amp slow');end
        ylabel('Nb Delta'), ylim([0 60]);
        legend(leg,'Location','EastOutside')
    end
    saveFigure(gcf,['SlowDeltaCorrelation_allExpe',FileSuffix],[res,FileToSave])
    
    %% evol with ZT
    ploall=1;
    if ploall
        figure('Color',[1 1 1]),
        set(gcf,'Units','normalized','Position',[0.1 0.1 0.4 0.5])
    end
    
    zt_int=[0:1/10:1]*nbBins;
    MatCor_r=nan(length(Dir.path),length(zt_int)-1);
    MatCor_p=MatCor_r;MatCor_y=MatCor_r;
    count=0;
    for mi=1:length(Umice)
        ind=find(MatInfo(:,2)==Umice(mi));
        for i=1:length(ind)
            count=count+1;
            for zt=1:length(zt_int)-1
                if ploall, subplot(length(Umice),10,(mi-1)*10+zt), hold on;end
                
                X=tempMat(ind(i),zt_int(zt)+1:zt_int(zt+1)-1); X=X(:);
                Y=tempDeltaMat(ind(i),zt_int(zt)+1:zt_int(zt+1)-1);Y=Y(:);
                if ploall, plot(X,Y,'.','Color',colori{i});end
                try
                    index=find(~isnan(X) & ~isnan(Y));
                    [RHO,PVAL] = corr(X(index),Y(index));
                    [a, b] = regression_line(X(index), Y(index));
                    MatCor_r(count,zt)=RHO;
                    MatCor_p(count,zt)=PVAL;
                    MatCor_y(count,zt)=b;
                end
            end
            if ploall, xlim([0 15E4]), ylabel('Nb Delta'), ylim([0 60]);end
        end
    end
    
    if ploall, saveFigure(gcf,['SlowDeltaCorrelation_allExpeZT',FileSuffix],[res,FileToSave]);end
        
    figure('Color',[1 1 1]),set(gcf,'Units','normalized','Position',[0.1 0.2 0.4 0.4])
    subplot(1,3,1), PlotErrorBarN(MatCor_r,0,1); title('Corr coeff'), xlabel('ZT (h)')
    subplot(1,3,2), PlotErrorBarN(MatCor_p,0,1);  title('p val'), xlabel('ZT (h)')
    subplot(1,3,3), PlotErrorBarN(MatCor_y,0,1); title('slop'), xlabel('ZT (h)')
    saveFigure(gcf,['SlowDeltaCorrelation_allExpe_ZTBAR',FileSuffix],[res,FileToSave])
end

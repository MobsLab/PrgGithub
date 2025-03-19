% AnalyseNREMsubstages_OBslowOscML.m
%
% list of related scripts in NREMstages_scripts.m 


% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
% <<<<<<<<<<<<<<<<<<<<<<<<<<<<< INPUTS <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
res='/media/DataMOBsRAID/ProjetAstro/AnalyseTempEvolutionSlow/AnalyseNREMsubstages';
FolderToSave='/media/DataMOBsRAID/ProjetAstro/AnalyseNREMsubstages/swaOBrepartition/';

[params]=SpectrumParametersML('newlow');
Fsamp=0.5:0.05:10;
colori=[0.5 0.2 0.1;0.1 0.7 0 ; 0.8 0 0.7 ; 1 0 1 ;0.7 0.2 0.8];

% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
% <<<<<<<<<<<<<<<<<<<<< DIRECTORIES OF EXPE <<<<<<<<<<<<<<<<<<<<<<<<<<<
Dir1=PathForExperimentsDeltaSleepNew('BASAL');
Dir1=RestrictPathForExperiment(Dir1,'nMice',[243 244 251 252]);
Dir2=PathForExperimentsML('BASAL');
Dir2=RestrictPathForExperiment(Dir2,'Group','WT');
Dir=MergePathForExperiment(Dir1,Dir2);

[mice,a,b]=unique(Dir.name);
orderind=sortrows([1:length(Dir.path);b']',2);
orderind=orderind(:,1)';

% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%% <<<<<<<<<<<<<<<<<<< LOAD DATA FROM AnalySubStagesML <<<<<<<<<<<<<<<<<<<<
disp('loading AnalySubStagesML.mat')
load([res,'/AnalySubStagesML.mat'])

clr=colormap('jet');close
colorman=clr(floor(b*64/max(b)),:);
% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%% <<<<<<<<<<<<< QUANTIFY REPARTITION OF swaOB EPISOD DURATION <<<<<<<<<<<<

indx=[0.5:0.4:25];
M=nan(length(Dir.path),length(indx)); 
val=nan(length(Dir.path),2);
AllVal=[];
for man=1:length(Dir.path)
    eOB=MATEP{man,8};
    if ~isempty(eOB);
        eOB=mergeCloseIntervals(eOB,2E4);
        eOB=dropShortIntervals(eOB,1E4);
        dOB=Stop(eOB,'s')-Start(eOB,'s');
        AllVal=[AllVal;dOB];
        m=hist(dOB,indx);
        M(man,:)=m;
        val(man,:)=[mean(dOB),median(dOB)];
    end
end

figure('Color',[1 1 1]),
for i=1:3
    subplot(3,1,i), hold on,
    if i==1
        bar(indx(1:end-1),M(:,1:end-1)','stacked')
        title('Repartition of swaOB epoch duration (all mice cumulated)')
    elseif i==2
        bar(indx(1:end-1),M(:,1:end-1)')
        title('Repartition of swaOB epoch duration (all mice compared)')
    else
        m=hist(AllVal,indx); bar(indx(1:end-1),m(1:end-1))
        title('Repartition of swaOB epoch duration (pooled all mice episod)')
        m1=nanmean(AllVal); m2=nanmedian(AllVal);
    end
    if i<3
        m1=nanmean(val(:,1)); m2=nanmean(val(:,2));
    end
    line(m1*[1 1],ylim,'Color','r','Linewidth',2)
    text(m1,0.7*max(ylim),sprintf(' mean=%1.1fs',m1),'Color','r')
    line(m2*[1 1],ylim,'Color','m','Linewidth',2)
    text(m2,0.8*max(ylim),sprintf(' median=%1.1fs',m2),'Color','m')
    xlabel('episod duration (s)'); ylabel('#');
end



% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%% <<<<<<<<<<<<<<< QUANTIFY RELATION btw NREMsubstages & swaOB <<<<<<<<<<<<
%nameEpochs={'N1','N2','N3','REM','WAKE','SWS','swaPF','swaOB','TOTSleep'};
L=5;
MAT1=nan(length(Dir.path),L); MAT2=MAT1; MAT3=MAT1; 
MAT4=MAT1; MAT5=MAT1; MAT6=MAT1; MAT7=MAT1; MAT8=MAT1;

for man=1:length(Dir.path)
    eOB=MATEP{man,8};%swaOB
    if ~isempty(MATEP{man,9}) && ~isempty(MATEP{man,5})
        Tot=or(MATEP{man,9},MATEP{man,5});%TOTduration
        dTot=sum(Stop(Tot,'s')-Start(Tot,'s'));
    end
    if ~isempty(eOB)
        eOB=mergeCloseIntervals(eOB,2E4);
        eOB=dropShortIntervals(eOB,1E4);
        dOB=sum(Stop(eOB,'s')-Start(eOB,'s')); % total eOB duration
        for ep=1:L
            E=MATEP{man,ep};
            dE=sum(Stop(E,'s')-Start(E,'s')); % total stage duration
            
            % ep with swaOB
            A=and(eOB,E);
            MAT1(man,ep)=sum(Stop(A,'s')-Start(A,'s')); % raw
            MAT2(man,ep)=100*MAT1(man,ep)/dE; % percent of ep
            MAT3(man,ep)=100*MAT1(man,ep)/dOB; % percent of swaOB
            
            % ep without swaOB
            A=E-and(eOB,E);
            MAT4(man,ep)=sum(Stop(A,'s')-Start(A,'s')); % raw
            MAT5(man,ep)=100*MAT4(man,ep)/dE; % percent of ep
            try MAT6(man,ep)=100*MAT4(man,ep)/(dTot-dOB);end % percent of no swaOB
            
            % ratio ep and swaOB on tot
            try MAT7(man,ep)=100*dE/dTot;end
            try MAT8(man,ep)=100*dOB/dTot;end
        end
    end
end

%% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
% display PlotErrorBarN
figure('Color',[1 1 1],'Unit','Normalized','Position',[0.1 0.1 0.5 0.6])
for i=1:2
    if i==1, A=MAT2; B=MAT5;leg='%'; else, A=MAT1; B=MAT4; leg='s'; end
    %     for ep=1:L
    %         subplot(3,3,ep), PlotErrorBarN([A(:,ep),B(:,ep)],0,1);
    %         title(nameEpochs{ep}); ylabel(['duration (',leg,')'])
    %         set(gca,'Xtick',1:2), set(gca,'XtickLabel',{'swaOB','no swaOB'})
    %     end
    
    subplot(2,4,i), PlotErrorBarN(A,0,1); title(['swaOB ',leg]); ylabel(['duration (',leg,')'])
    set(gca,'Xtick',1:L), set(gca,'XtickLabel',nameEpochs(1:L))
    
    subplot(2,4,4+i), PlotErrorBarN(B,0,1); title(['no swaOB ',leg]);ylabel(['duration (',leg,')'])
    set(gca,'Xtick',1:L), set(gca,'XtickLabel',nameEpochs(1:L))
    
    % pool mice and display PlotErrorBarN
    Ai=nan(length(mice),L);Bi=Ai;
    for mi=1:length(mice)
        ind=find(strcmp(mice{mi},Dir.name));
        Ai(mi,:)=nanmean(A(ind,:),1);
        Bi(mi,:)=nanmean(B(ind,:),1);
    end
    
    subplot(2,4,2+i), PlotErrorBarN(Ai,0,1); ylabel(['duration (',leg,')'])
    title(sprintf('swaOB (pooledMice, N=%d)',sum(~isnan(nanmean(Ai,2)))));
    set(gca,'Xtick',1:L), set(gca,'XtickLabel',nameEpochs(1:L))
    
    subplot(2,4,6+i), PlotErrorBarN(Bi,0,1); ylabel(['duration (',leg,')'])
    title(sprintf('no swaOB (pooledMice, N=%d)',sum(~isnan(nanmean(Bi,2)))));
    set(gca,'Xtick',1:L), set(gca,'XtickLabel',nameEpochs(1:L))
    
end
% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%% display individual data
ploindiv=1;
if ploindiv
    for i=1:4,
        figure('Color',[1 1 1],'Unit','Normalized','Position',[0.1 0.1 0.5 0.7]);
        numF(i)=gcf;colormap pink;
    end
    for man=1:length(orderind)
        % plot repartition of swaOB
        figure(numF(1)), subplot(4,ceil(length(Dir.path)/4),man)
        bar([MAT1(orderind(man),:);MAT4(orderind(man),:)]'/60,'stacked')
        set(gca,'Xtick',1:L), set(gca,'XtickLabel',nameEpochs(1:L))
        title(Dir.name{orderind(man)},'Color',colorman(orderind(man),:));xlim([0.5 L+0.5])
        if rem(man,ceil(length(Dir.path)/4))==1, ylabel('duration (min)');end
        if man==length(Dir.path), legend({'swaOB','no swaOB'}); end
        if man==2, text(0, 1.2*max(ylim),'repartition of swaOB across NREMepisods (raw)');end
        
        figure(numF(2)), subplot(4,ceil(length(Dir.path)/4),man)
        bar([MAT2(orderind(man),:);MAT5(orderind(man),:)]','stacked')
        title(Dir.name{orderind(man)},'Color',colorman(orderind(man),:)); 
        ylim([0 102]); xlim([0.5 L+0.5]);
        if rem(man,ceil(length(Dir.path)/4))==1, ylabel('duration (%)');end
        set(gca,'Xtick',1:L), set(gca,'XtickLabel',nameEpochs(1:L))
        if man==length(Dir.path), legend({'swaOB','no swaOB'}); end
        if man==2, text(0, 1.2*max(ylim),'repartition of swaOB across NREMepisods (%substage)');end
        
        % plot proportion of substages
        figure(numF(3)), subplot(3,ceil(length(Dir.path)/3),man)
        bar([MAT1(orderind(man),:);MAT4(orderind(man),:)]/60,'stacked');
        set(gca,'Xtick',1:2), set(gca,'XtickLabel',{'swa','no'})
        title(Dir.name{orderind(man)},'Color',colorman(orderind(man),:)); xlim([0.5 2.5]);
        if rem(man,ceil(length(Dir.path)/4))==1, ylabel('duration (min)'); end
        if man==length(Dir.path), legend(nameEpochs(1:L)); end
        if man==2, text(0, 1.2*max(ylim),'repartition of NREMepisods depending on swaOB');end
        
        figure(numF(4)), subplot(3,ceil(length(Dir.path)/3),man)
        bar([MAT3(orderind(man),:);MAT6(orderind(man),:)],'stacked');
        set(gca,'Xtick',1:2), set(gca,'XtickLabel',{'swa','no'})
        title(Dir.name{orderind(man)},'Color',colorman(orderind(man),:)); 
        ylim([0 102]); xlim([0.5 2.5]); 
        if rem(man,ceil(length(Dir.path)/4))==1, ylabel('duration (%)');end
        if man==length(Dir.path), legend(nameEpochs(1:L));end
        if man==2, text(0, 1.2*max(ylim),'repartition of NREMepisods depending on swaOB (%OBstate)');end
    end
end


% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%% <<<<<<<<<<<<<<<<<<<<<<<< EVOLUTION ACROSS ZT <<<<<<<<<<<<<<<<<<<<<<<<<<<
HourDay=9:1:20;
MAT1=nan(length(Dir.path),L,length(HourDay)-1);
MAT2=MAT1;MAT3=MAT1;MAT4=MAT1;

for man=orderind
    deb=MATZT(man,1);
    eOB=MATEP{man,8};%swaOB
    
    if ~isempty(eOB)
        eOB=mergeCloseIntervals(eOB,2E4);
        eOB=dropShortIntervals(eOB,1E4);
        
        for ep=1:L
            % ep
            E=MATEP{man,ep};
            % ep with swaOB
            Eob=and(E,eOB);
            % ep without swaOB
            Enob=E-and(E,eOB);
            
            for h=1:length(HourDay)-1
                if diff(MATZT(man,:))>HourDay(h)*3600-deb && HourDay(h+1)*3600-deb>0
                    
                    I=intervalSet(1E4*max(0,HourDay(h)*3600-deb),1E4*min(diff(MATZT(man,:)),HourDay(h+1)*3600-deb));
                    dI=Stop(I,'s')-Start(I,'s');
                    if dI>60*10 % only rec>10min
                        % duration
                        IOB=and(eOB,I);
                        dOB=sum(Stop(IOB,'s')-Start(IOB,'s')); % eOB duration
                        IB=I-IOB;
                        dB=sum(Stop(IB,'s')-Start(IB,'s')); % eOB duration
                        
                        IE=and(E,I);
                        dE=sum(Stop(IE,'s')-Start(IE,'s')); % E duration
                        
                        % ep with swaOB
                        A=and(Eob,I);
                        d=sum(Stop(A,'s')-Start(A,'s'));
                        MAT1(man,ep,h)=100*d/dE;% percent of ep
                        MAT2(man,ep,h)=100*d/dOB;% percent of swaOB
                        
                        % ep without swaOB
                        B=and(Enob,I);
                        d=sum(Stop(B,'s')-Start(B,'s'));
                        MAT3(man,ep,h)=100*d/dE;% percent of ep
                        MAT4(man,ep,h)=100*d/dB;% percent of swaOB
                    end
                end
            end
        end
    end
end

%% display all expe,
ploindiv=1;
leg={'swaOB (%ep)','ep (%swaOB)','no swaOB (%ep)','ep (%noswaOB)'};
if ploindiv
    for i=1:4
        figure('Color',[1 1 1],'Unit','Normalized','Position',[0.1 0.1 0.5 0.7]);
        for man=1:length(orderind)
            subplot(4,ceil(length(Dir.path)/4),man), hold on,
            eval(['temp1=squeeze(MAT',num2str(i),'(',num2str(orderind(man)),',:,:));']);
            for ep=1:L
                plot(HourDay(1:end-1),temp1(ep,:),'Color',colori(ep,:),'Linewidth',2)
            end
            title(Dir.name{orderind(man)},'Color',colorman(orderind(man),:));
            xlim([HourDay(1)-0.5, HourDay(end)]); 
        end
        legend(nameEpochs(1:L))
        subplot(4,ceil(length(Dir.path)/4),2), text(0,max(ylim)*1.3,leg{i})
    end
end


%% display all expe, evolution of repartition, lines
figure('Color',[1 1 1])
for i=1:2
    for ep=1:L
        subplot(2,L,L*(i-1)+ep), hold on,
        eval(['temp1=squeeze(MAT',num2str(i),'(:,',num2str(ep),',:));']);
        eval(['temp2=squeeze(MAT',num2str(i+2),'(:,',num2str(ep),',:));']);
        plot(HourDay(1:end-1),temp1,'Color',[0.5 0.5 0.5])
        errorbar(HourDay(1:end-1),nanmean(temp1,1),nanstd(temp1)./sqrt(sum(~isnan(temp1))),...
            'color',colori(ep,:),'Linewidth',3)
        xlim([HourDay(1)-0.5, HourDay(end)]); if ep==1,ylabel('mean duration');end
        title([nameEpochs{ep},' ',leg{i}]); xlim(HourDay([1,end])+[-0.5 0])
    end
end

%% pool mice and plot

Mi1=nan(length(mice),L,length(HourDay)-1);
Mi2=Mi1; Mi3=Mi1; Mi4=Mi1; 
for mi=1:length(mice)
    ind=find(strcmp(mice(mi),Dir.name(orderind)));
    for ep=1:L
        for i=1:4
            eval(['Mi',num2str(i),'(mi,',num2str(ep),',:)=nanmean(squeeze(MAT',num2str(i),'(ind,',num2str(ep),',:)),1);']);
        end
    end
end

% display
plotpooledmice=1;
figure('Color',[1 1 1])
%leg={'swaOB duration (%stage)','swaOB duration (%swaOB)','no swaOB duration (%stage)','no swaOB duration (%swaOB)'};
leg={'(%stage)','(%swaOB)'};

for i=1:2
    TEMP=nan(L,length(HourDay)-1);
    for ep=1:L
        subplot(3,L,L*(i-1)+ep), hold on,
        if plotpooledmice
        	eval(['temp1=squeeze(Mi',num2str(i),'(:,',num2str(ep),',:));']);
        	eval(['temp2=squeeze(Mi',num2str(i+2),'(:,',num2str(ep),',:));']);
        else
            eval(['temp1=squeeze(MAT',num2str(i),'(:,',num2str(ep),',:));']);
            eval(['temp2=squeeze(MAT',num2str(i+2),'(:,',num2str(ep),',:));']);
        end
        %temp1=temp1./[nanmean(temp1,2)*ones(1,length(HourDay)-1)];
        %temp2=temp2./[nanmean(temp2,2)*ones(1,length(HourDay)-1)];
        
        %PlotErrorBarN(temp,0,0);
        %set(gca,'Xtick',1:length(HourDay)-1), set(gca,'XtickLabel',HourDay(1:end-1))
        
        %errorbar(HourDay(1:end-1),nanmean(temp),nanstd(temp)./sqrt(sum(~isnan(temp))),'+k')
        %bar(HourDay(1:end-1),nanmean(temp)); xlim([HourDay(1)-1,HourDay(end)])
        %title([nameEpochs{ep},' ',leg{i}]); 
        bar(HourDay(1:end-1),[nanmean(temp1);nanmean(temp2)]','stacked'); if i==1, ylim([0 105]);end
        title([nameEpochs{ep},' mean duration ',leg{i}]); xlim(HourDay([1,end])+[-0.5 0])
        if ep==L,legend({'swaOB','no swaOB'}); end
        TEMP(ep,:)=nanmean(temp1);
        TEMP(L+ep,:)=nanmean(temp2);
    end
    subplot(3,L,2*L+i*2-1), hold on,
    bar(HourDay(1:end-1),TEMP(1:L,:)','stacked'); 
    title(['swaOB ',leg{i}]); xlim(HourDay([1,end])+[-0.5 0])
    if i==2, ylim([0 105]);end
    
    subplot(3,L,2*L+i*2), hold on, 
    bar(HourDay(1:end-1),TEMP(L+1:2*L,:)','stacked'); 
    title(['no swaOB ',leg{i}]);xlim(HourDay([1,end])+[-0.5 0])
    if i==2, ylim([0 105]);legend(nameEpochs(1:L));end
    
end
colormap pink


% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%% <<<<<<<< epoch duration, all expe and pooled mice <<<<<<<<<<<
% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
leg={'min','% swaOB','% total','% sleep','% NREM'};
colori=[0.7 0.2 0.8; 1 0.5 1; 0.8 0 0.7; 0.1 0.7 0 ;0.5 0.2 0.1 ; 0 0 1];
numEp=[1:5,8];
MAT1=nan(length(Dir.path),length(numEp));
for man=1:length(Dir.path)    
    % ep
    for ep=1:length(numEp)
        E=MATEP{man,numEp(ep)};
        if ~isempty(E)
            if numEp(ep)==8, E=mergeCloseIntervals(E,2E4); E=dropShortIntervals(E,1E4);end
            d=sum(Stop(E,'s')-Start(E,'s'));
            MAT1(man,ep)=d;
        end
    end
end
        
figure('Color',[1 1 1],'Units','normalized','Position',[0.06 0.1 0.5 0.6]);
for mi=1:length(mice)
    ind=find(strcmp(Dir.name,mice{mi}));
    for s=1:5
        if s==1
            temp=MAT1;
        elseif s==2
            temp=100*MAT1./(MAT1(:,length(numEp))*ones(1,length(numEp)));
        else
            temp=100*MAT1./(sum(MAT1(:,1:length(numEp)-s+2),2)*ones(1,length(numEp)));
        end
        subplot(5,1,s), hold on,
        for ep=1:length(numEp)
            plot(2*mi-0.5+0.2*ep,temp(ind,ep),'ok','MarkerFaceColor',colori(ep,:))
        end
        title(['total epoch duration (',leg{s},')']);
    end
    legmi{mi}=mice{mi}(end-2:end);
end

for s=1:5, subplot(5,1,s), set(gca,'Xtick',2*[1:length(mice)]),set(gca,'XtickLabel',legmi);end
legend(nameEpochs(numEp))

%if optionSave, saveFigure(gcf,['SleepStagesProportion_IntraIndivVariability'],FolderToSave);end



% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%% <<<<<<<<<<<<<<<<<<< Amplitude OBslow continuum <<<<<<<<<<<<<<<<<<<<<<<<<
% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
plo=0;
lim1=[2 2.5]; % band of interest
lim2=[0.5 1.5]; % lower band
lim3=[4 6]; % upper band
% see FindNREMepochsML.m -> function FindSlowOscML
try
    load([res,'/AnalyseOBslow.mat'],'lim1','lim2','lim3','Dir')
    disp('AnalyseOBslow.mat already exists. Loaded.')
catch
    
    save([res,'/AnalyseOBslow.mat'],'lim1','lim2','lim3','Dir')
    
    MAT={};
    for man=1:length(Dir.path)
        disp(' '); disp(Dir.path{man})
        cd(Dir.path{man})
        
        clear temp Sp t f Sp1 Sp2 Sp3
        try
            % Bulb_deep
            disp('- ChannelsToAnalyse/Bulb_deep')
            temp=load('ChannelsToAnalyse/Bulb_deep.mat');
            disp(sprintf('   ... Loading Spectrum%d.mat',temp.channel))
            eval(sprintf('load(''SpectrumDataL/Spectrum%d.mat'')',temp.channel));
            
            % get amplitude in different bands
            Sp1=mean(Sp(:,find(f>lim1(1) & f<lim1(2))),2);
            Sp2=mean(Sp(:,find(f>lim2(1) & f<lim2(2))),2);
            Sp3=mean(Sp(:,find(f>lim3(1) & f<lim3(2))),2);
            
            % fill results matrice
            MAT{man,1}=tsd(t*1E4,Sp1);
            MAT{man,2}=tsd(t*1E4,Sp2);
            MAT{man,3}=tsd(t*1E4,Sp3);
            
            % display
            if plo
                figure('Color',[1 1 1]), hold on,
                imagesc(t,f,[f'*ones(1,length(t))].*Sp'); axis xy; caxis([0 5E6])
                plot(t,rescale(SmoothDec(Sp1,10),0,20),'k','Linewidth',2);
                title(Dir.path{man})
            end
            disp('Saving in AnalyseOBslow.mat')
            save([res,'/AnalyseOBslow.mat'],'-append','MAT')
        catch
            disp('Problem'); keyboard;
        end
    end
end
    
    
    
    
    
    
    
    
    
    
    
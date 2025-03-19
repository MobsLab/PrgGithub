%% PARTIE RESULTATS 2 : LES SOUS ETATS DE NREM
% 
% list of related scripts in NREMstages_scripts.m 

%% PARTIE RESULTATS 3 : LES RYTHMES DU BO

% >> ok, important <<
% 1. AnalyseOBsubstages_Bilan.m
% 2. AnalyseOBsubstages_BilanRespi.m
% 3. AnalyseOBsubstages_NREMsubstages.m
% 4. AnalyseOBsubstages_NREMsubstagesPlethysmo.m
% 5. AnalyseOBsubstages_Rhythms.m
% 6. AnalyseOBsubstages_SleepCycle.m
% 7. AnalyseOBsubstages_PFCneuronModulation.m
% 7. FiguresDataCulb8juin2015.m
% 8. RunFuctions_ML.m


% >> autres, ordre chronologique <<
% OBXHemiOcclu.m
% TempProportionSlowBulbML.m
% TempProportionSlowBulbML2.m
% SlowOscillationsML.m
% Compute_RatioSleepML.m (manipe DPCPX..)

% Compare_OscillAmplitude_ML.m
% RespiModulatesGamma_ML.m
% RespiModulatesEvents_ML.m
% CodeBulbMLDisplayArticle.m
% CodeBulbMLDisplay.m
% CodeBulbML.m
% CodeBulbMarie1.m

%%
FolderToSave='/home/mobsyoda/Dropbox/MOBs_ProjetBulbe/FIGURES/FigureThese';
% <<<<<<<<<<<<<<<<<<<<< DIRECTORIES OF EXPE <<<<<<<<<<<<<<<<<<<<<<<<<<<
Dir1=PathForExperimentsDeltaSleepNew('BASAL');
Dir1=RestrictPathForExperiment(Dir1,'nMice',[243 244 251 252]);
Dir2=PathForExperimentsML('BASAL');
Dir2=RestrictPathForExperiment(Dir2,'Group','WT');
Dir=MergePathForExperiment(Dir1,Dir2);

%--------------------------------------------------------------------------
%AnalyseNREMsubstagesML; 
%FindNREMepochsML.m
% -> FindSleepStageML.m
% -> -> FindOsciEpochs.m
% figure global stage duration
% figure global occurance of delta, spindles, ripples
% figure coordination Ripples/Delta/spindles

%% ------------------------------------------------------------------------
% ------------------------------------------------------------------------
% figure distribution of movement quantity
%(FindSleepStageML.m)
figure('Color',[1 1 1])
man{1}='/media/DataMOBsRAID5/ProjetAstro/ProjetDPCPX/Mouse083/20130730/BULB-Mouse-83-30072013';
man{2}='/media/DataMOBsRAID5/ProjetAstro/ProjetDPCPX/Mouse061/20130422/BULB-Mouse-61-22042013';
man{3}='/media/DataMOBsRAID5/ProjetAstro/ProjetDPCPX/Mouse060/20130415/BULB-Mouse-60-15042013';
for i=1:3
    cd(man{i}); clear Mmov ThetaRatioTSD ThetaThresh
    load StateEpoch.mat Mmov ThetaRatioTSD ThetaThresh
    for j=1:2
        if j==1 
            [Y,X]=hist(log(Data(Mmov)),1000);
        else
            [Y,X]=hist(Data(ThetaRatioTSD),1000);
        end
        [cf2,goodness2]=createFit2gauss(X,Y,[]);
        a= coeffvalues(cf2);
        b=intersect_gaussians(a(2), a(5), a(3), a(6));
        [~,ind]=max(Y); gamma_thresh=b(b>X(ind));
        
        subplot(2,3,3*(j-1)+i), plot(X,Y,'k'), hold on
        h_ = plot(cf2,'fit',0.95);
        set(h_(1),'Color','b', 'LineWidth',2,'Marker','none', 'MarkerSize',6);
        if j==1 
            line([(gamma_thresh) (gamma_thresh)],[0 max(Y)],'linewidth',3,'color','r')
            xlabel('log(movement)'); 
        else
            line([ThetaThresh ThetaThresh],[0 max(Y)],'linewidth',3,'color','r')
            xlabel('log(theta/delta)');
        end
        ylabel('number of values');
        legend({'Distribution','2 gaussians fit','threshold'})
        title(man{i}(max(strfind(man{i},'/'))-8:end))
    end
end
%saveFigure(gcf,'DistributionMovtAndRatio',FolderToSave)
%% ------------------------------------------------------------------------
% ------------------------------------------------------------------------
% figure indiv récap delta spindles ripples 
% (voir /media/DataMOBsRAID/ProjetAstro/Figures/BilanRipplesSpindlesDelta/)
for man=1:length(Dir.path)
    disp('  ');disp(Dir.path{man})
    cd(Dir.path{man})
    PETHSpindlesRipplesMLv2;
end
%% ------------------------------------------------------------------------
%smoothed poly somno

fac=[4 3 2 1.5 1];
colori=[0.5 0.2 0.1; 0.1 0.7 0 ; 0.8 0 0.7 ; 1 0 1 ; 0.7 0.2 0.8; ]; %1 0.5 1;
cd('/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice251-252/20150521/Breath-Mouse-251-252-21052015/Mouse251')
[WAKE,REM,N1,N2,N3,NamesStages]=RunSubstages;

try
    % bidouille 10s windows
    REM=mergeCloseIntervals(REM,15*1E4);
    REM=dropShortIntervals(REM,10*1E4);
    WAKE=mergeCloseIntervals(WAKE,15*1E4);WAKE=WAKE-REM;
    WAKE=dropShortIntervals(WAKE,10*1E4);
    N3=mergeCloseIntervals(N3,10*1E4);
    N3=dropShortIntervals(N3,10*1E4);
    N1=mergeCloseIntervals(N1,10*1E4);N1=N1-N3;
    N1=dropShortIntervals(N1,10*1E4);
    N2=mergeCloseIntervals(N2,10*1E4);N2=N2-N1-N3;
    N2=dropShortIntervals(N2,10*1E4);
    
    % replace lost epoch, continuous hypothesis
    minsta=min([Start(WAKE);Start(REM);Start(N1);Start(N2);Start(N3)]);
    sto=[];
    for n=1:length(NamesStages)
        eval(['temp=Stop(',NamesStages{n},');'])
        sto=[sto;[temp,n*ones(size(temp))]];
    end
    TOTepoch=intervalSet(minsta,max(sto(:,1)));
    lostEpoch=TOTepoch-WAKE-REM-N1-N2-N3;
    lostEpoch=CleanUpEpoch(lostEpoch);
    lostEpoch=mergeCloseIntervals(lostEpoch,1);
    
    sta=Start(lostEpoch);n=0;
    disp(sprintf(' ! %d lost epoch',length(sta)))
    for s=1:length(sta)
        try
            m=max(sto(sto(:,1)<=sta(s),1));% stop time before begining of lostEpoch
            n(s)=max(sto(sto(:,1)==m,2));% put in wakeNoise if ambiguous
            eval([NamesStages{n(s)},'=or(',NamesStages{n(s)},',subset(lostEpoch,',num2str(s),'));'])
        end
    end
    disp(['lostEpoch found for :', sprintf(' %s',NamesStages{unique(n)})])
    
    for n=1:length(NamesStages)
        eval([NamesStages{n},'=CleanUpEpoch(',NamesStages{n},');'])
        eval([NamesStages{n},'=mergeCloseIntervals(',NamesStages{n},',1);'])
    end
end

Epochs={WAKE,REM,N1,N2,N3};
Rec=or(or(or(N1,REM),or(N2,N3)),WAKE);
indtime=min(Start(Rec)):5E4:max(Stop(Rec));%s
timeTsd=tsd(indtime,zeros(length(indtime),1));
SleepStages=zeros(1,length(Range(timeTsd)));
rg=Range(timeTsd);

for ep=1:length(Epochs)
    id=find(ismember(rg,Range(Restrict(timeTsd,Epochs{ep})))==1);
    SleepStages(id)=fac(ep);
end
SleepStages=tsd(rg,SleepStages');

figure('color',[1 1 1]);
hold on, plot(Range(SleepStages,'s'),Data(SleepStages),'k')
for ep=1:length(Epochs)
    plot(Range(Restrict(SleepStages,Epochs{ep}),'s'),Data(Restrict(SleepStages,Epochs{ep})),'.','Color',colori(ep,:));
end
legend([{'SleepStages'},NamesStages]);title(pwd)
xlim([0 max(Range(SleepStages,'s'))]); ylim([0 4.5]); set(gca,'Ytick',[]);



%% Exemple des spectro PFC - dHPC - OB: Mouse 160
% /media/DataMOBsRAID/ProjetAstro/Mouse160/20141223/BULB-Mouse-160-23122014
% 
colori=[0.5 0.2 0.1; 0.1 0.7 0 ; 0.8 0 0.7 ; 1 0 1 ; 0.7 0.2 0.8; ];
for man=1:length(Dir.path)
    cd(Dir.path{man})
    disp(Dir.path{man})
    
    clear temp1 temp2 temp3 tp1 tp2 tp3
    figure('color',[1 1 1],'Unit','normalized','Position',[0.1 0.1 0.6 0.7]),
    try
        % load PFCx spectrum
        tp1=load('ChannelsToAnalyse/PFCx_deep.mat');
        temp1=eval(sprintf('load(''SpectrumDataL/Spectrum%d.mat'')',tp1.channel));
        % load sHPC spectrum
        tp2=load('ChannelsToAnalyse/dHPC_deep.mat');
        temp2=eval(sprintf('load(''SpectrumDataL/Spectrum%d.mat'')',tp2.channel));
        % load OB spectrum
        tp3=load('ChannelsToAnalyse/Bulb_deep.mat');
        temp3=eval(sprintf('load(''SpectrumDataL/Spectrum%d.mat'')',tp3.channel));
        
        % plot
        subplot(3,1,1),imagesc(temp1.t,temp1.f,10*log10(temp1.Sp)'), axis xy, caxis([10 57])
        title({Dir.path{man},' ','PFCx Spectrogramm'});xlim([1.5 2]*1E4)
        subplot(3,1,2),hold off,imagesc(temp2.t,temp2.f,10*log10(temp2.Sp)'), axis xy, 
        title('dHPC Spectrogramm');caxis([25 62]);xlim([1.5 2]*1E4)
        subplot(3,1,3),hold off,imagesc(temp3.t,temp3.f,10*log10(temp3.Sp)'), axis xy, caxis([25 62])
        title('Bulb Spectrogramm');caxis([25 62]);xlim([1.5 2]*1E4)
        % save
        saveFigure(gcf,sprintf('SpectrumHpcPfc%d',man),'/media/DataMOBsRAID/ProjetAstro/AnalyseNREMsubstages/SpectrumNREMStages/HPC-PFCxSpectrum/');
    catch
        close;
    end
    
    if 0
        [WAKE,REM,N1,N2,N3,NamesStages,SleepStages]=RunSubstages;close
        load('StateEpoch.mat','Mmov','ThetaRatioTSD');
        hold on, plot(Range(ThetaRatioTSD,'s'),rescale(Data(ThetaRatioTSD),0,5),'k','linewidth',2);
        plot(Range(Mmov,'s'),rescale(Data(Mmov),15,20),'k','linewidth',2);
        title({pwd,' ','HPC Spectrogramm'});xlim([1.5 2]*1E4); ylim([0 20])
        for ep=1:length(NamesStages)
            eval(['epo=and(',NamesStages{ep},',intervalSet(1.5E4*1E4,2E4*1E4));']);
            epo=mergeCloseIntervals(epo,10E4);epo=dropShortIntervals(epo,10E4);
            sta=Start(epo,'s');sto=Stop(epo,'s');
            for s=1:length(sta)
                line([sta(s) sto(s)],[0 0]+20-0.4*ep,'Linewidth',5,'Color',colori(ep,:))
            end
        end
    end
end
%% cumulated sum of substages duration
colori=[0.7 0.2 0.8; 1 0.8 0.8; 1 0 1 ;0.1 0.7 0; 0.5 0.2 0.1];
load('AnalySubStagesML.mat')
%
Hday=[max(MATZT(MATZT(:,1)/3600<11,1)) min(MATZT(MATZT(:,2)/3600>17,2))];% in second
figure('color',[1 1 1],'Unit','normalized','Position',[0.1 0.1 0.6 0.7]),numF=gcf;
figure('color',[1 1 1],'Unit','normalized','Position',[0.1 0.1 0.6 0.7]),numF2=gcf;
a=1;
for man=1:length(Dir.path)
    disp(Dir.path{man})
    try
        op=MATEP(man,:);
        if MATZT(man,1)/3600<11 && MATZT(man,2)/3600>17
            delayBeg=Hday(1)-MATZT(man,1);% in second
            delayEnd=MATZT(man,2)-Hday(2);% in second
            tps=ts(delayBeg*1E4:1E4:(diff(MATZT(man,1:2))-delayEnd)*1E4);%TotEpoch 1Hz
            disp(sprintf('dur=%dh',floor(length(Range(tps))/3600)))
            for n=1:5
                tmat=[Range(tps,'s'),zeros(length(Range(tps)),1)];
                tn=Range(Restrict(tps,op{n}),'s');
                tmat(ismember(tmat(:,1),tn),2)=1;
                % plot per stage
                figure(numF),subplot(2,5,n),hold on, 
                plot(tmat(:,1)-delayBeg,cumsum(tmat(:,2)),'Color',colori(n,:),'Linewidth',2)
                subplot(2,5,5+n),hold on, 
                plot(tmat(:,1)-delayBeg,100*cumsum(tmat(:,2))/max(cumsum(tmat(:,2))),'Color',colori(n,:))
                % plot per expe
                figure(numF2),
                subplot(3,8,a),hold on, 
                plot(tmat(:,1)-delayBeg,100*cumsum(tmat(:,2))/max(cumsum(tmat(:,2))),'Color',colori(n,:),'Linewidth',2)
            end
            a=a+1; xlim([min(tmat(:,1)),max(tmat(:,1))]-delayBeg)
            title(sprintf(['%d- ',Dir.name{man}],man))
        end
    end
end
    
%%
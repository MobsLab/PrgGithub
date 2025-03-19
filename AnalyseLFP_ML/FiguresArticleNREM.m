% FiguresArticleNREM.m
%
% list of related scripts in NREMstages_scripts.m 

FolderToSave='/home/mobsyoda/Dropbox/MOBs_ProjetBulbe/FIGURES/FigureArticleNREM';
 savFig=0;
 % <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%% <<<<<<<<<<<<<<<<<<<<<<< SUBSTAGES DURATION <<<<<<<<<<<<<<<<<<<<<<<<<<<<<
% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

res='/media/DataMOBsRAIDN/ProjetAstro/AnalyseTempEvolutionSlow/AnalyseNREMsubstages';

load([res,'/AnalySubStagesML_all.mat']);
%load([res,'/AnalySubStagesML.mat']);
%load([res,'/AnalySubStagesML_New.mat']);
%load([res,'/AnalySubStagesNewML']);

disp(' '); disp('...Calculating Stage duration')
% compare with sws
isws=find(strcmp('SWS',nameEpochs));
is=find(strcmp('TOTSleep',nameEpochs));
indsws=[]; 
for op=1:length(nameEpochs)
    if sum(strcmp({'N','R'},nameEpochs{op}(1))), indsws=[indsws,op];end
end

% length of substage epochs
MATDUR=nan(length(Dir.path),length(nameEpochs));
MATDURsws=MATDUR; MATDURs=MATDUR;
for man=1:length(Dir.path)
    clear tempsws temp temptot temps
    try
        tempsws=sum(Stop(MATEP{man,isws},'s')-Start(MATEP{man,isws},'s'));
        temps=sum(Stop(MATEP{man,is},'s')-Start(MATEP{man,is},'s'));
        for op=1:length(nameEpochs)
            temp=sum(Stop(MATEP{man,op},'s')-Start(MATEP{man,op},'s'));
            
            temptot=MATZT(man,2)-MATZT(man,1);
            if temptot>0
                MATDUR(man,op)=100*temp/temptot;
                if tempsws>0, MATDURsws(man,op)=100*temp/tempsws;end
                if temps>0, MATDURs(man,op)=100*temp/temps;end
            end
        end
    end
end
% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
disp(' '); disp('...Count and coordination of sleep Rhythms')

MATDELT=nan(length(Dir.path),length(nameEpochs)); 
MATRIP=MATDELT; 
MATSPIND=MATDELT;
n_osci=nan(length(Dir.path),length(nameEpochs),3);
for i=1:length(nameEpochs), for io=1:6, MatCoord{i,io}=nan(length(Dir.path),51);end;end
sizeWindow=0.5;%s 20s, 5s, 0.5s or 0.25s
clear bt
for man=1:length(Dir.path)
    disp(Dir.path{man})
    clear rip Dpfc spiHf
    try
        op=MATEP(man,:);
        
        Dpfc=MATOSCI{man,1};
        rip=MATOSCI{man,2};
        spiHf=MATOSCI{man,3};
        
        %fill results matrices
        for i=1:length(op)
            EpLength=sum(Stop(op{i},'s')-Start(op{i},'s'));
            if EpLength>3
                % delta
                if ~isempty(Range(Dpfc))
                    tdpf_op=Restrict(Dpfc,op{i});
                    MATDELT(man,i)=length(Range(tdpf_op))/EpLength;
                end
                % ripples
                if ~isempty(Range(rip))
                    trip_op=Restrict(rip,op{i});
                    MATRIP(man,i)=length(Range(trip_op))/EpLength;
                end
                % spindles
                if ~isempty(Range(spiHf))
                    tspi_op=Restrict(spiHf,op{i});
                    MATSPIND(man,i)=length(Range(tspi_op))/EpLength;
                end
              
            end
        end
    catch
        disp('Problem'); %keyboard
    end
end
disp('Done');warning on

% <<<<<<<<<<<<<<<<<<<<<<<< POOL SAME MICE EXPE <<<<<<<<<<<<<<<<<<<<<<<<<<<
mice=unique(Dir.name);
disp('...Pool same mice')

MiDELT=nan(length(mice),length(nameEpochs));
MiSPIND=MiDELT; MiRIP=MiDELT; MiEP=MiDELT; MiEPs=MiDELT; MiEPsws=MiDELT;
for mi=1:length(mice)
    ind=find(strcmp(Dir.name,mice{mi}));
    MiDELT(mi,:)=nanmean(MATDELT(ind,:),1);
    MiSPIND(mi,:)=nanmean(MATSPIND(ind,:),1);
    MiRIP(mi,:)=nanmean(MATRIP(ind,:),1);
    MiEP(mi,:)=nanmean(MATDUR(ind,:),1);
    MiEPsws(mi,:)=nanmean(MATDURsws(ind,:),1);
    MiEPs(mi,:)=nanmean(MATDURs(ind,:),1);
end

%% <<<<<<<<<<<<<<<<<< QUANTIFIACTION OF RYTHMS ON NREMSubStages <<<<<<<<<<<<<<<<<<
disp('...Plot QUANTIFIACTION OF RYTHMS')
%change order of plot
%idchange=[1,2,3,4,6,5];
%idchange=1:size(MATDELT,2);
%
idchange=[1,2,3,6];

figure('Color',[1 1 1],'unit','Normalized','Position', [0.05 0.05 0.5 0.4]); numF=gcf;
subplot(2,3,1), plotSpread(MATDELT(:,idchange),'distributionColors','k');
for i=1:length(idchange), line(i+[-0.2 0.2],nanmean(MATDELT(:,idchange(i)))+[0 0],'Color','k','Linewidth',2);end
n=sum(~isnan(nanmean(MATDELT(:,idchange),2))); N=sum(~isnan(nanmean(MiDELT(:,idchange),2)));
title(sprintf('Delta (n=%d, N=%d)',n,N)); ylabel('Occurance (Hz)');
fprintf('\nDelta (n=%d, N=%d)\n',n,N);
for i=1:length(idchange),fprintf([nameEpochs{idchange(i)},': %1.2f Hz +- %1.2f\n'],nanmean(MATDELT(:,idchange(i))),nanstd(MATDELT(:,idchange(i))));end


subplot(2,3,2), plotSpread(MATSPIND(:,idchange),'distributionColors','k'); 
for i=1:length(idchange), line(i+[-0.2 0.2],nanmean(MATSPIND(:,idchange(i)))+[0 0],'Color','k','Linewidth',2);end
n=sum(~isnan(nanmean(MATSPIND(:,idchange),2))); N=sum(~isnan(nanmean(MiSPIND(:,idchange),2)));
title(sprintf('Spindles (n=%d, N=%d)',n,N));
fprintf('\nSpindles (n=%d, N=%d)\n',n,N);
for i=1:length(idchange),fprintf([nameEpochs{idchange(i)},': %1.2f Hz +- %1.2f\n'],nanmean(MATSPIND(:,idchange(i))),nanstd(MATSPIND(:,idchange(i))));end

subplot(2,3,3), plotSpread(MATRIP(:,idchange),'distributionColors','k'); 
for i=1:length(idchange), line(i+[-0.2 0.2],nanmean(MATRIP(:,idchange(i)))+[0 0],'Color','k','Linewidth',2);end
n=sum(~isnan(nanmean(MATRIP(:,idchange),2))); N=sum(~isnan(nanmean(MATRIP(:,idchange),2)));
title(sprintf('Ripples (n=%d, N=%d)',n,N)); ylabel('Occurance (Hz)');
fprintf('\nRipples (n=%d, N=%d)\n',n,N);
for i=1:length(idchange),fprintf([nameEpochs{idchange(i)},': %1.2f Hz +- %1.2f\n'],nanmean(MATRIP(:,idchange(i))),nanstd(MATRIP(:,idchange(i))));end

subplot(2,3,4), plotSpread(MiDELT(:,idchange),'distributionColors','k'); 
for i=1:length(idchange), line(i+[-0.2 0.2],nanmean(MiDELT(:,idchange(i)))+[0 0],'Color','k','Linewidth',2);end
N=sum(~isnan(nanmean(MiDELT(:,idchange),2)));
title(sprintf('Delta (N=%d)',N)); ylabel('Occurance (Hz)');
fprintf('\nDelta (N=%d)\n',N);
for i=1:length(idchange),fprintf([nameEpochs{idchange(i)},': %1.2f Hz +- %1.2f\n'],nanmean(MiDELT(:,idchange(i))),nanstd(MiDELT(:,idchange(i))));end

subplot(2,3,5), plotSpread(MiSPIND(:,idchange),'distributionColors','k'); 
for i=1:length(idchange), line(i+[-0.2 0.2],nanmean(MiSPIND(:,idchange(i)))+[0 0],'Color','k','Linewidth',2);end
N=sum(~isnan(nanmean(MiSPIND(:,idchange),2)));
title(sprintf('Spindles (N=%d)',N)); ylabel('Occurance (Hz)');
fprintf('\nSpindles (N=%d)\n',N);
for i=1:length(idchange),fprintf([nameEpochs{idchange(i)},': %1.2f Hz +- %1.2f\n'],nanmean(MiSPIND(:,idchange(i))),nanstd(MiSPIND(:,idchange(i))));end

subplot(2,3,6), plotSpread(MiRIP(:,idchange),'distributionColors','k');
for i=1:length(idchange), line(i+[-0.2 0.2],nanmean(MiRIP(:,idchange(i)))+[0 0],'Color','k','Linewidth',2);end
title(sprintf('Ripples (N=%d)',N)); ylabel('Occurance (Hz)');
fprintf('\nRipples (N=%d)\n',N);
for i=1:length(idchange),fprintf([nameEpochs{idchange(i)},': %1.2f Hz +- %1.2f\n'],nanmean(MiRIP(:,idchange(i))),nanstd(MiRIP(:,idchange(i))));end

for s=1:6
    subplot(2,3,s), set(gca,'Xtick',1:length(nameEpochs(idchange)));
        set(gca,'XtickLabel',nameEpochs(idchange));
end

if savFig, saveFigure(numF.Number,'NREMRyhtmQuantif',FolderToSave);end


%% <<<<<<<<<<<<<<<<<<<<< QUANTIFIACTION OF NREMSubStages <<<<<<<<<<<<<<<<<<
disp('...Plot QUANTIFIACTION OF NREMSubStages')
% duration tot

idchange=1:4;

figure('Color',[1 1 1],'unit','Normalized','Position', [0.05 0.05 0.5 0.4]); numF=gcf;

subplot(2,3,1), PlotErrorBarN(MATDUR(:,idchange),0,1); 
n=sum(~isnan(nanmean(MATDUR(:,idchange),2))); N=sum(~isnan(nanmean(MiEP(:,idchange),2)));
title({'Duration (%tot)',sprintf('n=%d, N=%d',n,N)})
subplot(2,3,2), PlotErrorBarN(MATDURsws(:,idchange),0,1); 
n=sum(~isnan(nanmean(MATDURsws(:,idchange),2))); N=sum(~isnan(nanmean(MiEPsws(:,idchange),2)));
title({'Duration (%NREM)',sprintf('n=%d, N=%d',n,N)}); 
subplot(2,3,3), PlotErrorBarN(MATDURs(:,idchange),0,1); 
n=sum(~isnan(nanmean(MATDURs(:,idchange),2))); N=sum(~isnan(nanmean(MiEPs(:,idchange),2)));
title({'Duration (%sleep)',sprintf('n=%d, N=%d',n,N)})

subplot(2,3,4), PlotErrorBarN(MiEP(:,idchange),0,1); 
N=sum(~isnan(nanmean(MiEP(:,idchange),2)));
title({'Duration (%tot)',sprintf('N=%d',N)})
subplot(2,3,5), PlotErrorBarN(MiEPsws(:,idchange),0,1); 
N=sum(~isnan(nanmean(MiEPsws(:,idchange),2)));
title({'Duration (%NREM)',sprintf('N=%d',N)})
subplot(2,3,6), PlotErrorBarN(MiEPs(:,idchange),0,1); 
N=sum(~isnan(nanmean(MiEPs(:,idchange),2)));
title({'Duration (%sleep)',sprintf('N=%d',N)})

for s=1:6
    subplot(2,3,s),set(gca,'Xtick',1:length(nameEpochs(idchange)));
    set(gca,'XtickLabel',nameEpochs(idchange));
end
if savFig, saveFigure(numF.Number,'NREMStagesDurationQuantif',FolderToSave);end

%% correlation inter/intra
figure('Color',[1 1 1],'unit','Normalized','Position', [0.05 0.05 0.6 0.3]); numF=gcf;

idchange=1:4;
colo=[0.4 0 1; 1 0 1; 1 0 0;0 0 0];
for i=1:3
    subplot(1,3,i),
    if i==1, M=MATDUR; M2=MiEP; tit='Duration (%tot)';end
    if i==2, M=MATDURsws; M2=MiEPsws; tit='Duration (%NREM)';end
    if i==3, M=MATDURs; M2=MiEPs; tit='Duration (%sleep)';end
    for n=1:4
        inter=std(M2(isnan(M2(:,n))==0,n));
        for mi=1:length(mice)
            id=find(strcmp(mice{mi},Dir.name));
            intra=M(id,n); intra(isnan(intra))=[];
            if length(intra)>2
                hold on,plot(inter,std(intra),'ko','MarkerFaceColor',colo(n,:))
            end
        end
        text(inter,10+0.3*n,nameEpochs{n},'Color',colo(n,:))
    end
    xlim([0 13]); ylim([0 13]); title(tit)
    line([0 12],[0,12],'Color',[0.5 0.5 0.5])
end

if savFig, saveFigure(numF.Number,'NREMStagesInterIntraVar',FolderToSave);end
%{} []

%% probability to be in stage across day duration
t_step=30;%s

for man=1:length(Dir.path)
    clear tempsws temp temptot temps
    try
        tempsws=sum(Stop(MATEP{man,isws},'s')-Start(MATEP{man,isws},'s'));
        temps=sum(Stop(MATEP{man,is},'s')-Start(MATEP{man,is},'s'));
        for op=1:length(nameEpochs)
            temp=sum(Stop(MATEP{man,op},'s')-Start(MATEP{man,op},'s'));
        end
    end
end


%%

[MatZT1,MatZT2,DurEpZT,NewtsdZT,timeZT]=GetEvolutionAcrossZT(Valtsd,Epochs,NewtsdZT,plo,timeZT,Windo)



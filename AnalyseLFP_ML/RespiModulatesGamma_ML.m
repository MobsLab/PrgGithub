function [MatrixRespi,Matrixlow,Matrixhigh,tps,MatrixGroup]=RespiModulatesGamma_ML(NameStructure,NameEpoch,ch,saveFig)

% function RespiModulatesGamma_ML(NameStructure,NameEpoch,ch)


%% check inputs
if ~exist('NameStructure','var') || ~exist('NameEpoch','var')
    error('Not enough input arguments')
end

if ~exist('ch','var')
    ch=8;
end

if ~exist('saveFig','var')
    saveFig=0;
end

%% initialization

Dir=PathForExperimentsML('PLETHYSMO');
MiceNames=unique(Dir.name);
Strains=unique(Dir.group);
res='/media/DataMOBsRAID5/ProjetAstro/DataPlethysmo';

ANALYNAME=['AnalyGammaRespi_',NameStructure,'_',NameEpoch];
saveFolder='/media/DataMOBsRAID5/ProjetAstro/DataPlethysmo/Analyse_GammaRespi';

MatrixRespi=[];
Matrixhigh=[];
Matrixlow=[];
MatrixGroup=nan(length(Dir.path),1);


%% compute
try
    load([saveFolder,'/',ANALYNAME])
    MatrixRespi; Matrixlow; Matrixhigh; tps; MatrixGroup;
    disp(['Loading ',ANALYNAME])
catch
    for man=1:length(Dir.path)
        disp(' ')
        disp(Dir.name{man})
        cd(Dir.path{man});
        clear Mrespi Mlow Mhigh
        try
            [Mrespi, Mlow, Mhigh]=RespiGammaMarie(NameStructure,NameEpoch,ch);
            close;
            MatrixRespi(man,:)=Mrespi(:,2)';
            Matrixlow(man,:)=Mlow(:,2)';
            Matrixhigh(man,:)=Mhigh(:,2)';
            tps=Mrespi(:,1)';
            if sum(isnan(Mrespi(:,2)))==0
                MatrixGroup(man)=find(strcmp(Strains,Dir.group{man}));
            end
        end
    end
    save([saveFolder,'/',ANALYNAME],'MatrixRespi','Matrixlow','Matrixhigh','tps','MatrixGroup','Dir')
end
cd(res)


%% pool data from same mice
MatrixGroup_temp=nan(length(MiceNames),1);
MatrixRespi_temp=nan(length(MiceNames),size(MatrixRespi,2));
Matrixlow_temp=MatrixRespi_temp;
Matrixhigh_temp=MatrixRespi_temp;

for uu=1:length(MiceNames)
    index=find(strcmp(Dir.name,MiceNames{uu}));
    if ~isempty(index) 
        try
            MatrixGroup_temp(uu)=unique(MatrixGroup(index));
            MatrixRespi_temp(uu,:)=nanmean(MatrixRespi(index,:),1);
            Matrixlow_temp(uu,:)=nanmean(Matrixlow(index,:),1);
            Matrixhigh_temp(uu,:)=nanmean(Matrixhigh(index,:),1);
        end
    end
end
MatrixRespi=MatrixRespi_temp;
Matrixlow=Matrixlow_temp;
Matrixhigh=Matrixhigh_temp;
MatrixGroup=MatrixGroup_temp;


%% display

figure('Color',[1 1 1]), numF=gcf;
smo=50;
colori={'b' 'r'};
for gg=1:length(Strains)
    
    M=nanmean(MatrixRespi(MatrixGroup==gg,:),1);
    M2=smooth(nanmean(Matrixlow(MatrixGroup==gg,:),1),smo);
    M3=smooth(nanmean(Matrixhigh(MatrixGroup==gg,:),1),smo);

    subplot(2,2,2*gg-1), plot(tps,M,'k','linewidth',3),
    hold on,plot(tps,rescale(M2,-0.005,0.015),colori{gg},'linewidth',2),
    title([Strains{gg},' (n=',num2str(sum((MatrixGroup==gg))),')'])
    xlabel(['Time (s)    - Respi [',num2str(floor(1E4./([ch,ch-1]*50))/10),']Hz'])
    ylabel('Low Gammma [30-60]Hz')
    ylim([-10 20]/1E3)
    
    subplot(2,2,2*gg), plot(tps,M,'k','linewidth',3),
    hold on, plot(tps,rescale(M3,-0.005,0.015),colori{gg},'linewidth',2)
    title([Strains{gg},' (n=',num2str(sum((MatrixGroup==gg))),')'])
    ylabel('High Gammma [60-90]Hz')
    xlabel(['Time (s)    - Respi [',num2str(floor(1E4./([ch,ch-1]*50))/10),']Hz'])
    ylim([-10 20]/1E3)
end

%% saveFigures

if saveFig
    saveFigure(numF,ANALYNAME,saveFolder);
end
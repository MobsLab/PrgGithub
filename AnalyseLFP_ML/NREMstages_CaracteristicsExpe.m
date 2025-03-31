%NREMstages_CaracteristicsExpe.m
%
% list of related scripts in NREMstages_scripts.m 
%% initiate
res='/media/DataMOBsRAIDN/ProjetNREM/AnalyseNREMsubstagesNew';
Analyname='NREMstages_CaracteristicsExpe';

DoNew=2;
if DoNew==1
    Dir=PathForExperimentsMLnew('BASALlongSleep');
    Analyname=[Analyname,'New'];
elseif DoNew==2
    Dir=PathForExperimentsMLnew('Spikes');
    Analyname=[Analyname,'Spikes'];
else
    Dir0=PathForExperimentsMLnew('BASAL');
    Dir1=PathForExperimentsDeltaSleepNew('BASAL');
    Dir1=RestrictPathForExperiment(Dir1,'nMice',[243 244 251 252]);
    Dir2=PathForExperimentsML('BASAL');
    Dir2=RestrictPathForExperiment(Dir2,'Group','WT');
    Dir=MergePathForExperiment(Dir0,Dir1);
    Dir=MergePathForExperiment(Dir,Dir2);
end
hLigthOn=8*ones(1,length(Dir.path));
if ~DoNew, hLigthOn(1:length(Dir0.path))=9;end

colori=[0.8 0.8 0.8;0 0 0; 0.6 0.2 1 ; 1 0.8 1 ;1 0 0; 0 0 1;0.5 0.5 0.8;0 1 0];
FolderToSave='/home/mobsyoda/Dropbox/NREMsubstages-Manuscrit/FigureArticleNREM';

%% compute
try
    load([res,'/',Analyname,'.mat']);
    Epochs;
catch
    for man=1:length(Dir.path)
        
        disp(' '); disp(Dir.path{man})
        cd(Dir.path{man})
        manDate(man)=str2num(Dir.path{man}(strfind(Dir.path{man},'/201')+[1:8]));
        
        % %%%%%%%%%%%%%%%%%%%%%%% get substages %%%%%%%%%%%%%%%%%%%%%%%%%%%
        clear WAKE REM N1 N2 N3 NREM SLEEP
        [WAKE,REM,N1,N2,N3,NamesStages]=RunSubstages;close
        Epochs(man,1:5)={WAKE,REM,N1,N2,N3};
        
        % %%%%%%%%%%%%%%%%%%%%%%%%% GET ZT %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        NewtsdZT=GetZT_ML(Dir.path{man});
        hdeb(man)=mod(min(Data(NewtsdZT))/1E4/3600,24);
        
    end
    save([res,'/',Analyname],'Dir','Epochs','NamesStages','hdeb','hLigthOn','manDate');
    disp('Done')
end

%% Display

figure('Color',[1 1 1],'Unit','Normalized','Position',[0.1 0.1 0.8 0.8])

for man=1:length(Dir.path)
    if manDate(man)>20160701, deb=hdeb(man)-9; else, deb=hdeb(man)-8;end
    for n=1:5
        epoch=Epochs{man,n};
        hold on, line(deb+[Start(epoch,'h'),Stop(epoch,'h')],[man-1 man-1]-n*0.05,...
            'Color',colori(n,:),'linewidth',4)
    end
end
xlabel('ZT (h) - light on at 0'); ylim([-1 length(Dir.path)])
set(gca,'Ytick',0:length(Dir.path)-1), set(gca,'YtickLabel',Dir.name)
xlim([-1 12])
%saveFigure(numF.Number,'BilanManipe','/home/mobsyoda/Dropbox/NREMsubstages-Manuscrit/FigureArticleNREM')



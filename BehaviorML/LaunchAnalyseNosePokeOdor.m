%LaunchAnalyseNosePokeOdor

%% INITIALIZATION
res=pwd;
scrsz = get(0,'ScreenSize');
if isempty(strfind(res,'/')), mark='\'; else, mark='/'; end

experiment='Vanillin'; % or 'Discrimination' or 'Eugenol'
disp(['    * * * Analysing Experiment ',experiment,' * * *']);


%% PATH FOR EXPERIMENTS
dKOmice={'Mouse146' 'Mouse149' 'Mouse158' 'Mouse159' 'Mouse163' 'Mouse164'};
WTmice={'Mouse148' 'Mouse160' 'Mouse161' 'Mouse162'};
C57mice={'Mouse113' 'Mouse115' 'Mouse119' 'Mouse130' 'Mouse133' 'Mouse142' 'Mouse144'};

FileTOAnalyse=pwd;
% if  strcmp(mark,'\'), FileTOAnalyse='\\NASDELUXE\DataMOBsRAID5\ProjetAstro\OdorDetectionDiscrination';end
% if  strcmp(mark,'/'), FileTOAnalyse='/media/DataMOBsRAID5/ProjetAstro/OdorDetectionDiscrination';end
% FileTOAnalyse='C:\Users\Karim\Desktop\Data-Electrophy\ProjetBO-Depression\Olfaction-dKO';

%paths
lis=dir(FileTOAnalyse);
a=0;
for i=3:length(lis)
    if ~isempty(strfind(lis(i).name,experiment)) && isempty(strfind(lis(i).name,'Old'))
        a=a+1; Dir.path{a}=[FileTOAnalyse,mark,lis(i).name];
    end
end

%names
for i=1:length(Dir.path)
    Dir.manipe{i}=experiment;
    Dir.name{i}=Dir.path{i}(max(strfind(Dir.path{i},'Mouse')):max(strfind(Dir.path{i},'Mouse'))+7);
end

% Strain
for i=1:length(Dir.path)
    if sum(strcmp(Dir.name{i},WTmice))
        Dir.group{i}='WT';
    elseif sum(strcmp(Dir.name{i},dKOmice))
        Dir.group{i}='dKO';
    elseif sum(strcmp(Dir.name{i},C57mice))
        Dir.group{i}='C57';
    else
        Dir.group{i}=nan;
    end
end

%% 
Ustrains=unique(Dir.group); 
parameters={'Nb NosePokes','% time in NosePoke','Zscore % NosePoke','% Time in NosePoke Zone','% NosePoke when in Zone'};
   
MATTT=[];
    
for man=1:length(Dir.path)
    disp(Dir.path{man});
    clear tempload MATT
    
    try
        tempload=load([Dir.path{man},mark,'TrackSniffData.mat'],'namePhase');
        namePhase=tempload.namePhase;
    catch
       cd(Dir.path{man})
       disp('Run AnalyseNosePokeOdor.m'); keyboard;  
       cd(res)
       tempload=load([Dir.path{man},mark,'TrackSniffData.mat'],'namePhase');
       namePhase=tempload.namePhase;
    end
    tempload=load([Dir.path{man},mark,'MATTsave.mat'],'MATT','parameters');
    MATTT=[MATTT;[ones(size(tempload.MATT,1),1)*find(strcmp(Dir.group{man},Ustrains)),tempload.MATT]];
end

%% DISPLAY ALL RESULTS
indexSelect=2:2:length(namePhase);
namePhaseOdor={'-','0','-','10-8','-','10-7','-','10-6','-','10-5','-','10-4','-','10-3','-'};
for pp=1:length(parameters)
    figure('Color',[1 1 1],'Position',scrsz), numF=gcf;
    % ---------------------------------------------------------------------
    % ------------------------------- WT ----------------------------------
    subplot(3,3,1:2)
    Umice=unique(MATTT(MATTT(:,1)==1,2));
    Usession=unique(MATTT(:,4));
    WTpp=nan(length(Umice),length(Usession));
    for mi=1:length(Umice)
        for ll=1:length(Usession)
            indexWTpp=find(MATTT(:,1)==1 & MATTT(:,2)==Umice(mi) & MATTT(:,3)==pp &  MATTT(:,4)==Usession(ll));
            try WTpp(mi,ll)=MATTT(indexWTpp,5);end
        end
    end
    PlotErrorBarN(WTpp,0,1,'ranksum',2); text(1.6,max(ylim),'COMP','Color','b')
    set(gca,'XTick',1:size(WTpp,2))
    set(gca,'XTickLabel',namePhaseOdor)
    title([Ustrains{1},' ALL sessions'])
    ylabel(parameters{pp})
     
    % -----------------
    subplot(3,3,3)
    PlotErrorBarN(WTpp(:,indexSelect),0)
    set(gca,'XTick',1:size(WTpp(:,indexSelect),2))
    set(gca,'XTickLabel',namePhaseOdor(indexSelect))
    title([Ustrains{1},' ODOR sessions'])
    
    
    % ---------------------------------------------------------------------
    % ------------------------------- dKO ---------------------------------
   try
    subplot(3,3,4:5)
    Umice=unique(MATTT(MATTT(:,1)==2,2));
    Usession=unique(MATTT(:,4));
    KOpp=nan(length(Umice),length(Usession));
    for mi=1:length(Umice)
        for ll=1:length(Usession)
            indexKOpp=find(MATTT(:,1)==2 & MATTT(:,2)==Umice(mi) & MATTT(:,3)==pp &  MATTT(:,4)==Usession(ll));
            try KOpp(mi,ll)=MATTT(indexKOpp,5);end
        end
    end
    PlotErrorBarN(KOpp,0,1,'ranksum',2); text(1.6,max(ylim),'COMP','Color','b')
    set(gca,'XTick',1:size(KOpp,2))
    set(gca,'XTickLabel',namePhaseOdor)
    title([Ustrains{2},' ALL sessions'])
    ylabel(parameters{pp})
     
    % -----------------
    subplot(3,3,6)
    PlotErrorBarN(KOpp(:,indexSelect),0)
    set(gca,'XTick',1:size(KOpp(:,indexSelect),2))
    set(gca,'XTickLabel',namePhaseOdor(indexSelect))
    title([Ustrains{2},' ODOR sessions'])
   end
    % ---------------------------------------------------------------------
    % ------------------------ compare strains ----------------------------
    try
    meanWTpp=nanmean(WTpp,1);
    stdWTpp=stdError(WTpp);
    meanKOpp=nanmean(KOpp,1);
    stdKOpp=stdError(KOpp);
    end
    
    subplot(3,3,7:8), hold on, 
    plot(1:length(meanWTpp),meanWTpp,'-k','LineWidth',2)
    try plot(1:length(meanKOpp),meanKOpp,'-r','LineWidth',2);end
    legend(Ustrains)
    errorbar(meanWTpp,stdWTpp,'+k')
    try 
        errorbar(meanKOpp,stdKOpp,'+r')
    for ll=1:length(meanWTpp)
        [p,h]=ranksum(KOpp(:,ll),WTpp(:,ll));
        if p<0.05
            text(ll,1.1*max(meanWTpp(ll),meanKOpp(ll)),num2str(floor(p*1E4)/1E4),'Color','b')
            indexpval(ll)=1;
        else
            text(ll,1.1*max(meanWTpp(ll),meanKOpp(ll)),num2str(floor(p*1E4)/1E4),'Color',[0.5 0.5 0.5])
            indexpval(ll)=0;
        end
        
    end
    end
    set(gca,'XTick',1:length(meanKOpp))
    set(gca,'XTickLabel',namePhaseOdor)
    ylabel(parameters{pp})
    title('ALL sessions')
    
     
    % -----------------
    subplot(3,3,9), hold on, 
    plot(1:length(meanWTpp(indexSelect)),meanWTpp(indexSelect),'-k','LineWidth',2)
    try plot(1:length(meanKOpp(indexSelect)),meanKOpp(indexSelect),'-r','LineWidth',2);end
    errorbar(meanWTpp(indexSelect),stdWTpp(indexSelect),'+k')
    try errorbar(meanKOpp(indexSelect),stdKOpp(indexSelect),'+r');
    indexpval=indexpval(indexSelect);
    for ll=1:length(indexpval)
        if indexpval(ll)==1, text(ll,max(ylim),'* S','Color','b')
        end
    end
    end
    set(gca,'XTick',1:size(KOpp(:,indexSelect),2))
    set(gca,'XTickLabel',namePhaseOdor(indexSelect))
    title('ODOR sessions')
    
    
    
    
    % ---------------------------------------------------------------------
    % ------------------------ Save figures  ------------------------------
    
    if ~exist('FolderTosave','var')
        FolderTosave=uigetdir(res,'Save figures in folder');
    end
    if FolderTosave~=0, 
        tempnamepp=parameters{pp};tempnamepp(strfind(tempnamepp,' '))='_';
        tempnamepp(strfind(tempnamepp,'%'))='P';
        saveFigure(numF,['WtVSdKO',tempnamepp],FolderTosave);
    end
    
    
    
end



if 0
for pp=1:length(parameters)
    tempMAT=MATTT(MATTT(:,2)==pp,3:end);
    %subplot(length(parameters),1,pp), 
    PlotErrorBarN(tempMAT,1,1,2);
    ylabel(parameters{pp}), title(experiment),
    set(gca,'XTick',1:size(tempMAT,2))
    set(gca,'XTickLabel',namePhase)
end

for pp=1:length(parameters)
    tempMAT=MATTT(MATTT(:,2)==pp,indexSelect+2);
    %subplot(length(parameters),1,pp), 
    PlotErrorBarN(tempMAT,1,1,1);
    ylabel(parameters{pp}), title(experiment),
    set(gca,'XTick',1:size(tempMAT,2))
    set(gca,'XTickLabel',namePhase(indexSelect))
end
end


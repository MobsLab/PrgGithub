% AnalyseEvolutionDeltaML.m

ZeitTime0=8; % time of the begining of the lighthase / 24h
res='/media/DataMOBsRAID/ProjetAstro/AnalyseTempEvolutionSlow';
cd(res)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% %%%%%%%%%%%%%% Detect evol delta all mice %%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Dir1=PathForExperimentsBULB('SLEEPBasal');
% Dir1=RestrictPathForExperiment(Dir1,'Group','CTRL');
% Dir2=PathForExperimentsML('BASAL');
% Dir2=RestrictPathForExperiment(Dir2,'Group','WT');
% Dir=MergePathForExperiment(Dir1,Dir2);
% % 

manip=4;
if manip==1
    Dir=PathForExperimentsDeltaSleepNew('BASAL');
    suffix='';
elseif manip==2
    Dir=PathForExperimentsML('BASAL');
    Dir=RestrictPathForExperiment(Dir,'Group','WT');
    suffix='';
elseif manip==3
    Dir=PathForExperimentsDeltaSleepNew('DeltaTone');
    suffix='DeltaTone';
elseif manip==4
    Dir1=PathForExperimentsDeltaSleepNew('BASAL');
    Dir2=PathForExperimentsML('BASAL');
    Dir2=RestrictPathForExperiment(Dir2,'Group','WT');
    Dir=MergePathForExperiment(Dir1,Dir2);
    suffix='All';
end

strains=unique(Dir.group);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% %%%%%%%%%%%%%%%% GenerateDeltaSpindlesRipplesML.m %%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if 0
    for man=1:length(Dir.path)
        GenerateDeltaSpindlesRipplesML(Dir.path{man})
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% %%%%%%%%%%%%%%%% MatDeltaPFCx and MatDeltaPaCx %%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

I_ZT=intervalSet([0:1:12]*3600E4,[1:13]*3600E4); % en heure
nameFileSave=['AnalyseRhythmsZT',strains{1},suffix];
mkdir(nameFileSave)

% Zeitgeber time intervals to analyse
try
    load([nameFileSave,'/',nameFileSave])
    MatDeltaPFCx(1,1);
    disp(['Loading from ',nameFileSave])
catch
    MatRecZT = nan(length(Dir.path),length(Start(I_ZT)));
    MatDeltaPFCx = MatRecZT;
    MatDeltaPaCx= MatRecZT;
    MatRip = MatRecZT;
    MatSpinPaCx = MatRecZT;
    MatSpinPFCx = MatRecZT;
    
    for man=1:length(Dir.path)
        
        disp(Dir.path{man})
        h = waitbar(0,'Analysing Rhythms');
        
        cd(Dir.path{man})
        pause(0.2);waitbar(1/5)
        
        
        %---------------  SWSEpoch -------------------
        clear tempLoad SWS
        try
            tempLoad=load('StateEpoch.mat','SWSEpoch','NoiseEpoch','GndNoiseEpoch','WeirdNoiseEpoch');
            tempLoad.SWSEpoch;tempLoad.GndNoiseEpoch;tempLoad.NoiseEpoch;
        catch
            tempLoad=load('StateEpochSB.mat','SWSEpoch','NoiseEpoch','GndNoiseEpoch','WeirdNoiseEpoch');
        end
        SWS=tempLoad.SWSEpoch-tempLoad.GndNoiseEpoch;
        SWS=SWS-tempLoad.NoiseEpoch;
        if exist('tempLoad.WeirdNoiseEpoch','var'),SWS=SWS-tempLoad.WeirdNoiseEpoch;end
        
        %------------------------------------------------------------------
        %---------------  load ZT  ----------------------------------------
        
        NewtsdZT=GetZT_ML(Dir.path{man});

        try  NewtsdZT=tsd(Range(NewtsdZT),Data(NewtsdZT)-ZeitTime0*3600E4);end
        pause(0.2);waitbar(2/5)
        %------------------------------------------------------------------
        %------------------------------------------------------------------
        
        
        clear temp1 temp2 DeltaPFCx DeltaPaCx ZTDeltaPFCx ZTDeltaPaCx
        
        %---------------  DeltaPFCx  -------------------
        try
            temp1=load('newDeltaPFCx.mat','tDelta','DeltaEpoch');
            DeltaPFCx=ts(temp1.tDelta);
            ZTDeltaPFCx=ts(Data(Restrict(NewtsdZT,DeltaPFCx)));  % ZT
        end
        pause(0.2);waitbar(3/5)
        
        %---------------  DeltaPaCx  -------------------
        try
            temp2=load('newDeltaPaCx.mat','tDelta','DeltaEpoch');
            DeltaPaCx=ts(temp2.tDelta);
            ZTDeltaPaCx=ts(Data(Restrict(NewtsdZT,DeltaPaCx))); % ZT
        end
        
        %---------------  Ripples  -------------------
        clear temp3 Rip ZTRip
        try
            temp3=load('RipplesdHPC25.mat','dHPCrip');
            Rip=ts(temp3.dHPCrip(:,2)*1E4);
            ZTRip=ts(Data(Restrict(NewtsdZT,Rip)));
        end
        
         %---------------  SpindlesPFCx  -------------------
        clear temp4 SpiTot ZTSpindPFCx
        try
            try temp4=load('SpindlesPFCxDeep.mat','SpiTot');end
            try temp4=load('SpindlesPFCxSup.mat','SpiTot');end
            spindPFCx=ts(temp4.SpiTot(:,2)*1E4);
            ZTSpindPFCx=ts(Data(Restrict(NewtsdZT,spindPFCx)));
        end
        
        %---------------  SpindlesPaCx  -------------------
        clear temp5 SpiTot ZTSpindPaCx
        try
            try temp5=load('SpindlesPaCxDeep.mat','SpiTot');end
            try temp5=load('SpindlesPaCxSup.mat','SpiTot');end
            spindPaCx=ts(temp5.SpiTot(:,2)*1E4);
            ZTSpindPaCx=ts(Data(Restrict(NewtsdZT,spindPaCx)));
        end
        
       

        pause(0.2);waitbar(4/5)
        
        tsZT=ts(Data(Restrict(NewtsdZT,SWS)));
        for i=1:length(Start(I_ZT))
            try MatRecZT(man,i)=length(Restrict(tsZT,subset(I_ZT,i)))/1250;end
            if MatRecZT(man,i)>10*60
                try MatDeltaPFCx(man,i)=length(Range(Restrict(ZTDeltaPFCx,subset(I_ZT,i))));end
                try MatDeltaPaCx(man,i)=length(Range(Restrict(ZTDeltaPaCx,subset(I_ZT,i))));end
                try MatRip(man,i)=length(Range(Restrict(ZTRip,subset(I_ZT,i))));end
                try MatSpinPaCx(man,i)=length(Range(Restrict(ZTSpindPaCx,subset(I_ZT,i))));end
                try MatSpinPFCx(man,i)=length(Range(Restrict(ZTSpindPFCx,subset(I_ZT,i))));end
            end
        end
        pause(0.2);waitbar(5/5)
        close(h)
    end
    cd(res)
    save([nameFileSave,'/',nameFileSave],'MatDeltaPFCx','MatDeltaPaCx','MatRecZT','I_ZT',...
        'ZeitTime0','Dir','MatRip','MatSpinPaCx','MatSpinPFCx')
end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% %%%%%%%%%%%%%%%% Display PlotErrorBarN All mice %%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

minLength=15*60; %in sec
indNo=find(MatRecZT<minLength);
MatRecZT(indNo)=nan;
MatDeltaPFCx(indNo)=nan;
MatDeltaPaCx(indNo)=nan;
MatRip(indNo)=nan;
MatSpinPaCx(indNo)=nan;
MatSpinPFCx(indNo)=nan;
    
figure('Color',[1 1 1]),
set(gcf,'Units','normalized','Position',[0.1 0.2 0.3 0.6])

subplot(2,3,1)
PlotErrorBarN(MatDeltaPFCx./MatRecZT,0,0);
ylabel('Occurance Delta PFCx')
ntemp=find(~isnan(nanmean(MatDeltaPFCx')));
title(['PFCx (n=',num2str(length(ntemp)),' N=',num2str(length(unique(Dir.name(ntemp)))),')'])

subplot(2,3,4)
PlotErrorBarN(MatDeltaPaCx./MatRecZT,0,0);
ylabel('Occurance Delta PaCx')
ntemp=find(~isnan(nanmean(MatDeltaPaCx')));
title(['PaCx (n=',num2str(length(ntemp)),', N=',num2str(length(unique(Dir.name(ntemp)))),')'])
xlabel('ZT (h)')

subplot(2,3,2)
PlotErrorBarN(MatSpinPFCx./MatRecZT,0,0);
ylabel('Occurance Spindles PFCx')
ntemp=find(~isnan(nanmean(MatSpinPFCx')));
title(['PFCx (n=',num2str(length(ntemp)),', N=',num2str(length(unique(Dir.name(ntemp)))),')'])

subplot(2,3,5)
PlotErrorBarN(MatSpinPaCx./MatRecZT,0,0);
ylabel('Occurance Spindles PaCx')
ntemp=find(~isnan(nanmean(MatSpinPaCx')));
title(['PaCx (n=',num2str(length(ntemp)),', N=',num2str(length(unique(Dir.name(ntemp)))),')'])

subplot(2,3,3)
PlotErrorBarN(MatRip./MatRecZT,0,0);
ylabel('Occurance Ripples')
ntemp=find(~isnan(nanmean(MatRip'))); 
title(['Ripples HPC (n=',num2str(length(ntemp)),', N=',num2str(length(unique(Dir.name(ntemp)))),')'])

subplot(2,3,6)
PlotErrorBarN(MatRecZT,0,0);
ylabel('Length SWS')
ntemp=find(~isnan(nanmean(MatRecZT'))); 
title(['(n=',num2str(length(ntemp)),', N=',num2str(length(unique(Dir.name(ntemp)))),')'])

saveFigure(gcf,'EvolRhythm_allExpe',['/media/DataMOBsRAID/ProjetAstro/AnalyseTempEvolutionSlow/',nameFileSave])

% ---------------------------------------------------
%% ----------- PlotErrorBarN Pool mice --------------
% ---------------------------------------------------
mice=unique(Dir.name);
MiDeltaPFCx=nan(length(mice),length(Start(I_ZT)));
MiDeltaPaCx=MiDeltaPFCx;
MiSpinPFCx=MiDeltaPFCx;
MiSpinPaCx=MiDeltaPFCx;
MiRip=MiDeltaPFCx;
MiRecZT=MiDeltaPFCx;

for mi=1:length(mice)
    ind= find(strcmp(Dir.name,mice{mi}));
    temp1=MatRecZT(ind,:);
    temp2=MatDeltaPFCx(ind,:);
    temp3=MatDeltaPaCx(ind,:);
    temp4=MatSpinPFCx(ind,:);
    temp5=MatSpinPaCx(ind,:);
    temp6=MatRip(ind,:);
    
    indNo=find(temp1<minLength);
    temp1(indNo)=nan;
    temp2(indNo)=nan;
    temp3(indNo)=nan;
    temp4(indNo)=nan;
    temp5(indNo)=nan;
    temp6(indNo)=nan;
    
    
    if length(ind)>1
        MiRecZT(mi,:)=nanmean(temp1);
        MiDeltaPFCx(mi,:)=nanmean(temp2);
        MiDeltaPaCx(mi,:)=nanmean(temp3);
        MiSpinPFCx(mi,:)=nanmean(temp4);
        MiSpinPaCx(mi,:)=nanmean(temp5);
        MiRip(mi,:)=nanmean(temp6);
    else
        MiRecZT(mi,:)=temp1;
        MiDeltaPFCx(mi,:)=temp2;
        MiDeltaPaCx(mi,:)=temp3;
        MiSpinPFCx(mi,:)=temp4;
        MiSpinPaCx(mi,:)=temp5;
        MiRip(mi,:)=temp6;
    end
end

% ------------- display -----------------
figure('Color',[1 1 1]),
set(gcf,'Units','normalized','Position',[0.1 0.1 0.3 0.6])

subplot(2,3,1)
PlotErrorBarN(MiDeltaPFCx./MiRecZT,0,1);
ylabel('Occurance Delta PFCx')
title(['Delta PFCx (n=',num2str(sum(~isnan(nanmean(MiDeltaPFCx')))),')'])

subplot(2,3,4)
PlotErrorBarN(MiDeltaPaCx./MiRecZT,0,1);
ylabel('Occurance Delta PaCx')
title(['Delta PaCx (n=',num2str(sum(~isnan(nanmean(MiDeltaPaCx')))),')'])
xlabel('ZT (h)')

subplot(2,3,2)
PlotErrorBarN(MiSpinPFCx./MiRecZT,0,1);
ylabel('Occurance Spindles PFCx')
title(['Spindles PFCx (n=',num2str(sum(~isnan(nanmean(MiSpinPFCx')))),')'])

subplot(2,3,5)
PlotErrorBarN(MiSpinPaCx./MiRecZT,0,1);
ylabel('Occurance Spindles PaCx')
title(['Spindles PaCx (n=',num2str(sum(~isnan(nanmean(MiSpinPaCx')))),')'])

subplot(2,3,3)
PlotErrorBarN(MiRip./MiRecZT,0,1);
ylabel('Occurance Ripples')
title(['dHPC Ripples (n=',num2str(sum(~isnan(nanmean(MiRip')))),')'])

subplot(2,3,6)
PlotErrorBarN(MiRecZT,0,1);
ylabel('Length SWS')
title(['SWS duration(n=',num2str(sum(~isnan(nanmean(MiRecZT')))),')'])
legend(['sem','mean',mice],'Location','SouthEast')

saveFigure(gcf,'EvolRhythm_MicePooled',['/media/DataMOBsRAID/ProjetAstro/AnalyseTempEvolutionSlow/',nameFileSave])

% ---------------------------------------------------
%%
% ------------------- colored -------------------
% ---------------------------------------------------
MZT=ones(size(MatRecZT,1),1)*[0:1:12]; % 13 values, but before 9h, after 19h very poor data -> 11 values
MiZT=ones(size(MiRecZT,1),1)*[0:1:12];
for h=1:11, hTag{h}=sprintf('%d',h+8);end

colori=colormap('jet'); close
for mi=1:length(mice), fac{mi}=colori(floor((mi-1)*size(colori,1)/length(mice))+1,:);end
figure('Color',[1 1 1]), colormap('Gray'), numF(1)=gcf;
set(gcf,'Units','normalized','Position',[0.1 0.2 0.3 0.7])

figure('Color',[1 1 1]), colormap('Gray'),  numF(2)=gcf;
set(gcf,'Units','normalized','Position',[0.1 0.2 0.3 0.7])
% subplot(2,3,1), bar([0:1:12],nanmean(MatDeltaPFCx./MatRecZT))
% subplot(2,3,2), bar([0:1:12],nanmean(MatDeltaPaCx./MatRecZT))
% subplot(2,3,3), bar([0:1:12],nanmean(MatRecZT))
% subplot(2,3,4), bar([0:1:12],nanmean(MiDeltaPFCx./MiRecZT))
% subplot(2,3,5), bar([0:1:12],nanmean(MiDeltaPaCx./MiRecZT))
% subplot(2,3,6), bar([0:1:12],nanmean(MiRecZT))

for f=1:2
    figure(numF(f)),
    if f==1
        subplot(2,3,1), PlotErrorBar(MatDeltaPFCx./MatRecZT,0)
        subplot(2,3,4), PlotErrorBar(MatDeltaPaCx./MatRecZT,0)
        subplot(2,3,2), PlotErrorBar(MatSpinPFCx./MatRecZT,0)
        subplot(2,3,5), PlotErrorBar(MatSpinPaCx./MatRecZT,0)
        subplot(2,3,3), PlotErrorBar(MatRip./MatRecZT,0)
        subplot(2,3,6), PlotErrorBar(MatRecZT,0)
    else
        subplot(2,3,1), PlotErrorBar(MiDeltaPFCx./MiRecZT,0)
        subplot(2,3,4), PlotErrorBar(MiDeltaPaCx./MiRecZT,0)
        subplot(2,3,2), PlotErrorBar(MiSpinPFCx./MiRecZT,0)
        subplot(2,3,5), PlotErrorBar(MiSpinPaCx./MiRecZT,0)
        subplot(2,3,3), PlotErrorBar(MiRip./MiRecZT,0)
        subplot(2,3,6), PlotErrorBar(MiRecZT,0)
    end
    
    for mi=1:length(mice)
        ind= find(strcmp(Dir.name,mice{mi}));
        
        try
            if f==1
                for i=1:length(ind)
                    
                    temp1=MZT(ind(i),:);
                    temp2=MatRecZT(ind(i),:);
                    
                    temp3=MatDeltaPFCx(ind(i),:);
                    subplot(2,3,1), hold on,
                    plot(1+temp1(:),temp3(:)./temp2(:),'-','Color',fac{mi})
                    
                    temp4=MatDeltaPaCx(ind(i),:);
                    subplot(2,3,4), hold on,
                    plot(1+temp1(:),temp4(:)./temp2(:),'-','Color',fac{mi})
                    
                    temp5=MatSpinPFCx(ind(i),:);
                    subplot(2,3,2), hold on,
                    plot(1+temp1(:),temp5(:)./temp2(:),'-','Color',fac{mi})
                    
                    temp6=MatSpinPaCx(ind(i),:);
                    subplot(2,3,5), hold on,
                    plot(1+temp1(:),temp6(:)./temp2(:),'-','Color',fac{mi})
                    
                    temp7=MatRip(ind(i),:);
                    subplot(2,3,3), hold on,
                    plot(1+temp1(:),temp7(:)./temp2(:),'-','Color',fac{mi})
                    
                    subplot(2,3,6), hold on,
                    plot(1+temp1(:),temp2(:),'-','Color',fac{mi})
                    
                end
            else
                subplot(2,3,1), hold on,
                plot(1+MiZT(mi,:),MiDeltaPFCx(mi,:)./MiRecZT(mi,:),'-','Color',fac{mi})
                
                subplot(2,3,4), hold on,
                plot(1+MiZT(mi,:),MiDeltaPaCx(mi,:)./MiRecZT(mi,:),'-','Color',fac{mi})
                
                subplot(2,3,2), hold on,
                plot(1+MiZT(mi,:),MiSpinPFCx(mi,:)./MiRecZT(mi,:),'-','Color',fac{mi})
                
                subplot(2,3,5), hold on,
                plot(1+MiZT(mi,:),MiSpinPaCx(mi,:)./MiRecZT(mi,:),'-','Color',fac{mi})
                
                subplot(2,3,3), hold on,
                plot(1+MiZT(mi,:),MiRip(mi,:)./MiRecZT(mi,:),'-','Color',fac{mi})
                
                subplot(2,3,6), hold on,
                plot(1+MiZT(mi,:),MiRecZT(mi,:),'-','Color',fac{mi})
            end
        end
    end
    if f==1,
        strn=['n=',num2str(length(~isnan(nanmean(MatRecZT'))))]; Expetag='all expe';
    else
        strn=['N=',num2str(length(~isnan(nanmean(MiRecZT'))))]; Expetag='Pooled';
    end
        
    subplot(2,3,1), title(['PFCx Delta (',strn,')']); xlabel('start time (h)'); ylabel('Delta occurance'); xlim([1 13])
            set(gca,'Xtick',2:12), set(gca,'XtickLabel',hTag)
    subplot(2,3,4), title(['PaCx Delta (',strn,')']); xlabel('start time (h)'); ylabel('Delta occurance'); xlim([1 13])
            set(gca,'Xtick',2:12), set(gca,'XtickLabel',hTag)
    subplot(2,3,2), title(['PFCx Spindles (',strn,')']); xlabel('start time (h)'); ylabel('Spindles occurance'); xlim([1 13])
            set(gca,'Xtick',2:12), set(gca,'XtickLabel',hTag)
    subplot(2,3,5), title(['PaCx Spindles (',strn,')']); xlabel('start time (h)'); ylabel('Spindles occurance'); xlim([1 13])
            set(gca,'Xtick',2:12), set(gca,'XtickLabel',hTag)
    subplot(2,3,3), title(['dHPC Ripples (',strn,')']); xlabel('start time (h)'); ylabel('Ripples occurance'); xlim([1 13])
            set(gca,'Xtick',2:12), set(gca,'XtickLabel',hTag)
    subplot(2,3,6), title(['SWS duration - ',Expetag]); xlabel('start time (h)'); ylabel('duration (s)'); xlim([1 13])
            set(gca,'Xtick',2:12), set(gca,'XtickLabel',hTag)

    if f==2, legend(['mean','sem',mice],'Location','SouthEast'); subplot(2,3,6), title('SWS duration - pooled');end
    
    saveFigure(gcf,['EvolRhythm_Colored',num2str(f),'_',date],['/media/DataMOBsRAID/ProjetAstro/AnalyseTempEvolutionSlow/',nameFileSave])
end

% see TempEvolutionSlowBulb.m
% code Karim






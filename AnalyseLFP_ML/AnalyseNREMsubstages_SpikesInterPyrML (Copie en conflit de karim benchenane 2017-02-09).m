%AnalyseNREMsubstages_SpikesInterPyrML.m

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
% 22. AnalyseNREMsubstages_SD24h.m
% 23. AnalyseNREMsubstages_ORspikes.m
% CaracteristicsSubstagesML.m


% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%% <<<<<<<<<<<<<<<<<<<<<<<<<<<<< LOAD ANALY <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
nameAnaly='Analyse_SpikesNREMStages_3s.mat';
res='/media/DataMOBsRAID/ProjetAstro/AnalyseTempEvolutionSlow/AnalyseNREMsubstages';
FolderToSave='/media/DataMOBsRAID/ProjetAstro/AnalyseNREMsubstages/NeuronFiringRate';
savFig=0;
colori=[0.5 0.5 0.5;0 0 0 ;0.5 0.2 0.1;0.1 0.7 0 ;0.7 0.2 0.8 ; 1 0.5 0.8 ;1 0 1  ];
clear AllZTz NeurTyp
try
    load([res,'/',nameAnaly]);
    AllZTz;
    disp([nameAnaly,' has been loaded.'])
catch
    disp('ERROR ! Run AnalyseNREMsubstages_SpikesML.m');
    error('ERROR ! Run AnalyseNREMsubstages_SpikesML.m');
end


% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%% <<<<<<<<<<<<<<<<<<< Get interneuron / pyramidal <<<<<<<<<<<<<<<<<<<<<<<<
% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
ForceRedo=0;

if ~exist('NeurTyp','var') || ForceRedo
    % order mice
    [mice,a,b]=unique(Dir.name);
    orderind=sortrows([1:length(Dir.path);b']',2);
    orderind=orderind(:,1)';
    
    NeurTyp=nan(size(AllN,1),1);
    LNZT=0;
    for man=1:length(Dir.path)
        fol=Dir.path{orderind(man)};
        try cd(fol); catch, fol(strfind(fol,'/Electrophy')+[0:10])=[];end
        disp(' '); disp(fol); cd(fol)
        
        % %%%%%%%%%%%%%%%%%%%%%% GET SPIKES %%%%%%%%%%%%%%%%%%%%%%%%%%%
        clear S numNeurons
        % Get PFCx Spikes
        [S,numNeurons,numtt,TT]=GetSpikesFromStructure('PFCx');
        % remove MUA from the analysis
        nN=numNeurons;
        for s=1:length(numNeurons)
            if TT{numNeurons(s)}(2)==1
                nN(nN==numNeurons(s))=[];
            end
        end
        
        %keyboard
        if ~exist('MeanWaveform.mat','file')
            [FilenameXml,PathName]=uigetfile('*.xml','Select FilenameXml');
            GetWFInfo(pwd,[PathName,FilenameXml])
        end
        
        WfId=IdentifyWaveforms(pwd,'/home/mobsyoda',1,1:length(numNeurons));
        WfId(abs(WfId)==0.5)=NaN;
        
        
        NeurTyp(LNZT+[1:length(nN)])=WfId(find(ismember(numNeurons,nN)));
        LNZT=LNZT+length(nN);
    end
    save([res,'/',nameAnaly],'-append','NeurTyp');
end

% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%% <<<<<<<<<<<<<<<<<<<<<< ZT evol, REM or Wake neurons <<<<<<<<<<<<<<<<<<<<
% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

valZT=[11,12.5;16.5,18];
idZT=find(ismember(timeZT,valZT));
indEp=3:7;
tempName=NamesEp(indEp);
for i=1:3
    if i==1,
        indNeu=1:length(NeurTyp); nameNeur='ALL NEURONS';
    elseif i==2
        indNeu=find(NeurTyp==1); nameNeur='PYRAMIDAL NEURONS';
    else
        indNeu=find(NeurTyp==-1); nameNeur='INTERNEURONS';
    end
    
    [BE,idx]=max(AllNz(:,indEp)');
    nEp=[tempName,{'All'}];
    for n=1:5
        temp=find(idx==n);
        lis{i,n}=temp(ismember(temp,indNeu));
    end
    lis{i,n+1}=indNeu;
    
    
    figure('Color',[1 1 1],'Unit','Normalized','Position',[0.1*i 0.2 0.2 0.67]),
    clear matbar matbarSD
    for Nn=1:size(lis,2)
        idN=lis{i,Nn};
        if ~isempty(idN)
            clear matbar matbarSD
            if length(idN)>15, leg={'Ttest2: '};else, leg={'RankSum: '};end
            for n=1:length(tempName)
                
                AA=squeeze(AllZTz(idN,indEp(n),:));
                tempZT1=nanmean(AA(:,idZT(1):idZT(2)-1),2);
                tempZT2=nanmean(AA(:,idZT(3):idZT(4)-1),2);
                matbar(1,n)=nanmean(tempZT1);
                matbarSD(1,n)=stdError(tempZT1);
                matbar(2,n)=nanmean(tempZT2);
                matbarSD(2,n)=stdError(tempZT2);
                
                %tempChg(n,:)=tempZT2-tempZT1;
                
                subplot(length(nEp),3,3*Nn-2),hold on,
                errorbar(timeZT(1:end-1),nanmean(AA),stdError(AA),'Color',colori(indEp(n),:),'Linewidth',3)
                ylabel('zscore FR'); xlabel('ZT Time (h)'); xlim([min(timeZT),max(timeZT)])
                ylim([-0.3 0.5])
                % stats
                [H,p]=ttest2(tempZT1,tempZT2);
                if length(idN)<=15, p=ranksum(tempZT1,tempZT2);end
                leg=[leg,sprintf([tempName{n},' : p=%1.3f, '],p)];
                
            end
            %Chg{i,Nn}=
            
            if Nn==1, title(nameNeur); if i==1, legend(tempName);end; end
            subplot(length(nEp),3,3*Nn-1), hold on,
            bar(matbar');ylabel('zscore FR');
            errorbar([[1:length(tempName)]-0.15;[1:length(tempName)]+0.15]',matbar',matbarSD','+k')
            ylim([-0.2 0.4])
            set(gca,'Xtick',1:length(tempName)),set(gca,'XtickLabel',tempName)
            if Nn==1 && i==1, legend({sprintf('%1.1f-%1.1fh',timeZT(idZT(1)),timeZT(idZT(2))),...
                    sprintf('%1.1f-%1.1fh',timeZT(idZT(3)),timeZT(idZT(4)))}); end
            subplot(length(nEp),3,3*Nn),text(0,0.5,leg); axis off
        end
        subplot(length(nEp),3,3*Nn-1),title(sprintf(['FR zscore ',nEp{Nn},' (n=%d)'],length(idN)))
    end
    colormap gray
    if savFig, saveFigure(gcf,['AnalyseNREM-ZTEvolFRzPerGroups-',nameNeur(1:3)],FolderToSave);end
end

%% quantify repartition of neuron types

clear matbar matbar2
for Nn=1:5
    matbar(Nn,1:2)=100*[length(lis{2,Nn}),length(lis{3,Nn})]/length(lis{1,Nn});
    matbar(Nn,3)=100-sum(matbar(Nn,1:2));
    matbar2(1,Nn)=length(lis{2,Nn}); % pyr
    matbar2(2,Nn)=length(lis{3,Nn}); % interneurons
end
figure('Color',[1 1 1])
subplot(1,2,1)
bar(matbar,'stacked'); colormap gray
set(gca,'Xtick',1:5); set(gca,'XtickLabel',tempName)
legend({'Pyr','Int','?'})
subplot(1,2,2); 
bar(100*matbar2./(sum(matbar2,2)*ones(1,5)),'stacked'); colormap gray
set(gca,'Xtick',1:2); set(gca,'XtickLabel',{'PyrN','IntN'})
legend(tempName,'Location','BestOutside'); title('% neurons')



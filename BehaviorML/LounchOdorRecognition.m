% LounchOdorRecognition
%be in /media/DataMOBs16/ProjetBULB
colori={'g','r','m'};
scrsz = get(0,'ScreenSize');
%% INPUTS
res=pwd;
nameExpe='OdorRecognition';
% toujours construire : ProjetBULB\PlusMaze
erasePreviousA=0; % 0 to keep existing files, 1 otherwise
TypeExpe='OdorMOM';
OrderLabel={'CTRL','VARIANT','FIXED'}; %default {'CTRL','VARIANT','FIXED'}
nPhase=3;
ListOfPhases={'Phase0','Phase1','Phase2','Phase3','Phase4'};
PercentExclu=50;% choose between[20,35,50,65,80]
%% initiate
if sum(strfind(res,'/'))==0
    mark='\';
else
    mark='/';
end

lis=dir(res);
try
    MATT;
catch
    MATT=[];
    for pi=3:length(lis)
        
        if length(lis(pi).name)>4 && strcmp(lis(pi).name(1:5),'Mouse')
            
            % number of the mouse
            nameMouse=lis(pi).name(7:end);
            k=1; numMouse=[];
            while isempty(numMouse),
                try
                    numMouse=str2num(nameMouse(k:end));
                    k=k+1;
                end
            end
            
            disp(' ')
            disp(['           * * * Mouse ',nameMouse,' * * *'])
            listi=dir([res,mark,lis(pi).name]);
            
            for j=3:length(listi)
                
                if strcmp(listi(j).name,nameExpe)
                    listiji=dir([res,mark,lis(pi).name,mark,listi(j).name]);
                    
                    for k=3:length(listiji)
                        
                        if ~isempty(strfind(listiji(k).name,TypeExpe)) && strcmp(listiji(k).name(1:4),'BULB') && ~isempty(strfind(listiji(k).name,'hase0'))
                            disp(listiji(k).name)
                            
                            filename=[res,mark,lis(pi).name,mark,listi(j).name,mark,listiji(k).name];
                            
                            %---------------------------------------------------------------
                            % get infos
                            index=strfind(listiji(k).name,'-');
                            length_end=length(listiji(k).name(index(4):end));
                            index=index(index>strfind(listiji(k).name,'Mouse-'));
                            n_mouse=str2num(listiji(k).name(index(1)+1:index(2)-1));
                            n_day=str2num(listiji(k).name(strfind(listiji(k).name,'Day')+3));
                            %n_session=str2num(listiji(k).name(strfind(listiji(k).name,'Session')+7));
                            
                            
                            
                            clear ZoneOdor MatSum Nsniff
                            %-----------------
                            try
                                AnalyOk=1;
                                try
                                    load([filename,mark,'AroundOdor.mat']);
                                catch
                                    load([filename,mark,'AroundOdorON.mat']);
                                end
                            catch
                                AnalyOk=input('PROBLEM ! Enter 0 to abort analysis, 1 to continue : ');
                            end
                            
                            if AnalyOk
                                figure('Color',[1 1 1],'Position',scrsz), numF=gcf;
                                % recap
                                for i=[1,5]
                                    subplot(4,4,i), imagesc(imageRef), colormap gray
                                    line([10 20]*Ratio_IMAonREAL,[10 10],'Color','k','Linewidth',3)
                                    text(15*Ratio_IMAonREAL,15,'10 cm','Color','k')
                                    for oi=1:size(OdorInfo,1)
                                        hold on, plot(OdorInfo(oi,1),OdorInfo(oi,2),['+',colori{OdorInfo(oi,3)}])
                                        text(OdorInfo(oi,1)+2,OdorInfo(oi,2)+2,OrderLabel{OdorInfo(oi,3)}(1:4),'Color',colori{OdorInfo(oi,3)});
                                        circli = rsmak('circle',OdorInfo(oi,4),[OdorInfo(oi,1),OdorInfo(oi,2)]);
                                        hold on, fnplt(circli,'Color',colori{OdorInfo(oi,3)})
                                    end
                                    title(filename(max(strfind(filename,mark))+1:strfind(filename,'hase')-2))
                                    ylabel('Odor Location and types')
                                end
                                % analyze for all phases
                                timeInZone=NaN(size(OdorInfo,1)*nPhase,3);
                                perctime=NaN(size(OdorInfo,1),nPhase);
                                AllMatSum={};
                                SniffNum=NaN(size(OdorInfo,1),nPhase);
                                
                                for i=1:nPhase
                                    clear ZoneOdor MatSum
                                    n=0; ok=0;
                                    while n<100 && ok==0
                                        n=n+1; if n<10, numRec=['0',num2str(n)]; else, numRec=num2str(n);end
                                        filename2=filename;
                                        filename2(end-length_end+2:end-length_end+3)=numRec;
                                        filename2(strfind(filename,'Phase'):strfind(filename,'Phase')+5)=ListOfPhases{i};
                                        
                                        try load([filename2,mark,'AroundOdor.mat'],'ZoneOdor','MatSum','Nsniff');ok=1;end
                                        try load([filename2,mark,'AroundOdorON.mat'],'ZoneOdor','MatSum','Nsniff');ok=1;end
                                        
                                    end
                                    
                                    AllMatSum{i}=MatSum{PercExclu==PercentExclu};
                                    
                                    % occupation of the whole phase
                                    oneZoneOdor=ZoneOdor;
                                    oneZoneOdor(oneZoneOdor>1)=1;
                                    subplot(4,4,i+1), imagesc(AllMatSum{i}),
                                    for oj=1:size(OdorInfo,1)
                                        hold on, plot(OdorInfo(oj,1),OdorInfo(oj,2),'+w')
                                    end
                                    title(ListOfPhases(i))
                                    % occupation in odor zone
                                    subplot(4,4,i+5), imagesc(AllMatSum{i}.*oneZoneOdor),
                                    title(ListOfPhases(i))
                                    
                                    % define a mask for each zone
                                    for od=1:size(OdorInfo,1)
                                        temp=zeros(size(ZoneOdor));
                                        temp(ZoneOdor==od)=1;
                                        Zones{od}=temp;
                                    end
                                    
                                    % quantif
                                    for od=1:size(OdorInfo,1)
                                        perctime(od,i)=sum(sum(AllMatSum{i}.*Zones{od}))/sum(sum(AllMatSum{i}.*oneZoneOdor))*100;
                                        timeInZone((i-1)*nPhase+od,:)=[i,OdorInfo(od,3),perctime(od,i)];
                                        SniffNum(od,i)=Nsniff(od,2);
                                        MATT=[MATT;[n_mouse n_day str2num(ListOfPhases{i}(6)) OdorInfo(od,3) perctime(od,i) SniffNum(od,i)]];
                                    end
                                    
                                    
                                end
                                
                                % --------------------- TIME IN ODOR ZONE --------
                                subplot(4,4,[9 13]), bar(perctime) , ylim([0 100])
                                set(gca,'XTick',1:size(OdorInfo,1))
                                set(gca,'XTickLabel',OrderLabel(OdorInfo(:,3)))
                                ylabel('Percentage time spent in odor zone')
                                xlabel('odor location type through phases')
                                %title(['Exploration of Odor Zones, PHASE ',num2str(folderPhase(strfind(folderPhase,'hase')+4))]);
                                legend(ListOfPhases);
                                
                                perctimeNorm=NaN(size(perctime));
                                for i=1:nPhase
                                    perctimeNorm(:,i)=[perctime(:,i)./perctime(:,1)];
                                end
                                subplot(4,4,[10 14]), bar(perctimeNorm)
                                set(gca,'XTick',1:size(OdorInfo,1))
                                set(gca,'XTickLabel',OrderLabel(OdorInfo(:,3)))
                                ylabel('normalized time in odor zone')
                                title('Comparison with Phase 0')
                                xlabel('odor location type through phases')
                                %title(['Exploration of Odor Zones, PHASE ',num2str(folderPhase(strfind(folderPhase,'hase')+4))]);
                                legend(ListOfPhases);
                                
                                
                                % --------------------- SNIFF AT ODOR ZONE --------
                                subplot(4,4,[11 15]), bar(SniffNum) , ylim([0 30])
                                set(gca,'XTick',1:size(OdorInfo,1))
                                set(gca,'XTickLabel',OrderLabel(OdorInfo(:,3)))
                                ylabel('Sniff number')
                                xlabel('odor location type through phases')
                                %title(['Exploration of Odor Zones, PHASE ',num2str(folderPhase(strfind(folderPhase,'hase')+4))]);
                                legend(ListOfPhases);
                                
                                SniffNumNorm=NaN(size(SniffNum));
                                for i=1:nPhase
                                    SniffNumNorm(:,i)=[SniffNum(:,i)./SniffNum(:,1)];
                                end
                                subplot(4,4,[12 16]), bar(SniffNumNorm), ylim([0 2])
                                set(gca,'XTick',1:size(OdorInfo,1))
                                set(gca,'XTickLabel',OrderLabel(OdorInfo(:,3)))
                                ylabel('Normalized sniff number')
                                xlabel('odor location type through phases')
                                title('Comparison with Phase 0')
                                %title(['Exploration of Odor Zones, PHASE ',num2str(folderPhase(strfind(folderPhase,'hase')+4))]);
                                legend(ListOfPhases)
                                
                                
                                %
                                %                         disp(['Saving Analysis and Figure of ',filename(max(strfind(filename,mark))+1:strfind(filename,'hase')-2),'...'])
                                %                         whereToSave=[filename(1:max(strfind(filename,mark))),'Analyze_',filename(max(strfind(filename,mark))+1:strfind(filename,'hase')-2)];
                                %                         copyfile([filename,mark,'AroundOdor.mat'],whereToSave);
                                %                         save(whereToSave,'perctime','OdorInfo','AllMatSum','ListOfPhases')
                                %                         saveFigure(numF,['Figure_',filename(max(strfind(filename,mark))+1:strfind(filename,'hase')-2)],filename(1:max(strfind(filename,mark))-1))
                                %
                                %----------------
                                
                                
                                %                             disp('Done.. press enter to continue')
                                %                             pause;
                                %close;
                            end
                        end
                    end
                end
                
            end
        end
    end
    
end



%% ANALYZE MATT

U_mice=unique(MATT(:,1));
U_days=unique(MATT(:,2));
U_phase=unique(MATT(:,3));
U_odor=unique(MATT(:,4));
colori={'k','r','m','b','c','g','y'};

figure('Color',[1 1 1], 'Position',scrsz);numF(1)=gcf;
figure('Color',[1 1 1], 'Position',scrsz/2);numF(2)=gcf;
leg=[];
for mi=1:length(U_mice)
    temp1=NaN(length(U_phase),length(U_odor));
    temp2=NaN(length(U_phase),length(U_odor));
    for od=1:length(U_odor)
        for ph=1:length(U_phase)
            indexMat=find(MATT(:,1)==U_mice(mi) & MATT(:,3)==U_phase(ph) & MATT(:,4)==U_odor(od));
            temp1(ph,od)=mean(MATT(indexMat,5));
            temp2(ph,od)=mean(MATT(indexMat,6));
        end
        
        figure(numF(1)),subplot(2,length(U_odor),length(U_odor)*(od-1)+1), hold on,
        plot(1:length(U_phase),temp1(:,od)','.-','Color',colori{mi},'LineWidth',2)
        xlim([0.5 length(U_phase)+0.5])
        set(gca,'XTick',1:length(U_phase))
        set(gca,'XTickLabel',ListOfPhases)
        title(['ZONE ',OrderLabel{U_odor(od)}])
        ylabel('% time in Odor Zone')
        
        subplot(2,length(U_odor),length(U_odor)*(od-1)+2), hold on,
        plot(1:length(U_phase),temp2(:,od)','.-','Color',colori{mi},'LineWidth',2)
        xlim([0.5 length(U_phase)+0.5])
        set(gca,'XTick',1:length(U_phase))
        set(gca,'XTickLabel',ListOfPhases)
        title(['ZONE ',OrderLabel{U_odor(od)}])
        ylabel('Number of Sniff')
        
    end
    
    
    figure(numF(2)),subplot(1,length(U_odor),1), hold on,
    plot(1:length(U_phase),(temp1(:,U_odor==2)./temp1(:,U_odor==3))','.-','Color',colori{mi},'LineWidth',2)
    xlim([0.5 length(U_phase)+0.5])
    set(gca,'XTick',1:length(U_phase))
    set(gca,'XTickLabel',ListOfPhases)
    title('Ratio % time in VARIANT ZONE COMPARED TO FIXED')
    ylabel('%time in VARIANT / %time in FIXED')
    
    subplot(1,length(U_odor),2), hold on,
    plot(1:length(U_phase),(temp2(:,U_odor==2)./temp2(:,U_odor==3))','.-','Color',colori{mi},'LineWidth',2)
    xlim([0.5 length(U_phase)+0.5])
    set(gca,'XTick',1:length(U_phase))
    set(gca,'XTickLabel',ListOfPhases)
    title('Ratio number of sniff in VARIANT ZONE COMPARED TO FIXED')
    ylabel('Number of Sniff')
    
    leg=[leg,{['Mouse ',num2str(U_mice(mi))]}];
end
legend(leg)
subplot(1,length(U_odor),1),line([0.5 length(U_phase)+0.5],[1 1],'LineStyle','--','Color',[0.5 0.5 0.5])
subplot(1,length(U_odor),2),line([0.5 length(U_phase)+0.5],[1 1],'LineStyle','--','Color',[0.5 0.5 0.5])

figure(numF(1)),legend(leg)


%
%
% figure('Color',[1 1 1],'Position',scrsz), numF=gcf;
%
% % MATT = expe - phase - odor type - % time around zone
% MATT=[];
% for exp=1:length(NameLoadedExpe)
%     clear
%     % load expe analyzis
%     fold_expe=NameLoadedExpe{exp};
%     whereToSave=[fold_expe(1:max(strfind(fold_expe,mark))),'Analyze_',fold_expe(max(strfind(fold_expe,mark))+1:strfind(fold_expe,'hase')-2)];
%     temptempLoad=load(whereToSave);
%     perctime=temptempLoad.perctime;
%     OdorI=temptempLoad.OdorInfo;
%     Phases=temptempLoad.ListOfPhases;
%
%     % get info
%
%     nMouse=str2num(fold_expe(strfind(fold_expe,'Mouse-')+6));
%
%
%     % create big matrice
%     MattTemp=[];
%     for ph=1:length(Phases)
%         numPh=str2num(ListOfPhases{ph}(length(ListOfPhases{ph})));
%         MattTemp=[MattTemp ; [zeros(size(OdorI,1),1)+numPh, OdorI(:,3), perctime(:,ph)]];
%     end
%     MATT=[MATT;[zeros(size(MattTemp,1),1)+nMouse zeros(size(MattTemp,1),1)+exp, MattTemp]];
%
% end
% save(res,'perctime','OdorInfo','AllMatSum','ListOfPhases','NameLoadedExpe')
% saveFigure(numF,'Figure_Bilan_OdorRecog',res)
%
%
%














% %% INPUTS
%
% erasePreviousA=0; % 0 to keep existing files, 1 otherwise
% OrderLabel={'CTRL','VARIANT','FIXED'}; % default {'CTRL','VARIANT','FIXED'}
% MatName = {'numMouse' 'nPhase' 'Tctrl' 'Tvari' 'Tfixa' 'dRun'}; %default {'numMouse' 'nPhase' 'Tctrl' 'Tvari' 'Tfixa' 'dRun'}
% AnalyTimeRestrict=180; %time in seconde, default 180s (3min)
% NameExperimentFolder='OdorRecognition'; % default 'OdorRecognition'
% NameInFiles='OFOCalib'; % exemple 'MNTOdor'
%
% %% INITIALISATION
% res=pwd;
% lis=dir(res);
% scrsz = get(0,'ScreenSize');
%
% if isempty(strfind(res,'/')),mark='\'; else mark='/';end
%
%
% %% SCREEN FOR UNDONE OFFLINE TRACKING
% MATData=[];
% for i=3:length(lis)
%
%     if length(lis(i).name)>4 && strcmp(lis(i).name(1:5),'Mouse')
%         % number of the mouse
%         nameMouse=lis(i).name(7:end);
%         k=1; numMouse=[];
%         while isempty(numMouse),
%             try
%                 numMouse=str2num(nameMouse(k:end));
%                 k=k+1;
%             end
%         end
%
%         disp(' ')
%         disp(['           * * * Mouse ',nameMouse,' * * *'])
%         listi=dir([res,mark,lis(i).name]);
%
%         for j=3:length(listi)
%
%             if strcmp(listi(j).name,NameExperimentFolder)
%                 listiji=dir([res,mark,lis(i).name,mark,listi(j).name]);
%
%                 for k=3:length(listiji)
%                     if ~isempty(strfind(listiji(k).name,NameInFiles))
%                         disp(listiji(k).name)
%                         filename=[res,mark,lis(i).name,mark,listi(j).name,mark,listiji(k).name];
%
%                         % -------------------------------------------------
%                         % If not done, run AnalyzeOdorRecognition
%                         clear MatOdor Distance BlockTime numF
%                         DoAnalysis=1;
%                         try
%                             load([filename,mark,'OdorAnalysis.mat'],'MatOdor','Distance','BlockTime')
%                             MatOdor; Distance;BlockTime;
%                             if exist([filename,mark,'Figure_OdorAnalysis.eps'],'file'),DoAnalysis=0;end
%                         end
%
%                         if DoAnalysis || erasePreviousA
%                             [numF,Distance,MatOdor,BlockTime]=AnalyzeOdorRecognition(filename);
%                         end
%                         disp('  -> done')
%                         % -------------------------------------------------
%
%                         %index AnalyTimeRestrict
%                         if AnalyTimeRestrict<BlockTime, disp(['PROBLEM! AnalyTimeRestrict is shorter than BlockTime=',num2str(BlockTime),'s']);end
%                         indexATR=2:round(AnalyTimeRestrict/BlockTime)+1;
%                         if max(indexATR)>=size(MatOdor,2)
%                             indexATR=2:size(MatOdor,2);
%                             disp(['PROBLEM! AnalyTimeRestrict is too big for this recording, limit at ',num2str(BlockTime*length(indexATR)),'s !'])
%                         end
%
%                         % Analyze time within Odor Zone
%                         clear nPhase Tctrl Tvari Tfixa dRun
%                         nPhase = str2num(filename(strfind(filename,'Phase')+5));
%                         Tctrl = sum(sum(MatOdor(MatOdor(:,1)==1,indexATR)))/length(indexATR);
%                         Tvari = sum(sum(MatOdor(MatOdor(:,1)==2,indexATR)))/length(indexATR);
%                         Tfixa = sum(sum(MatOdor(MatOdor(:,1)==3,indexATR)))/length(indexATR);
%
%
%                         % Analyze distance
%                         dRun=sum(Distance(indexATR-1));
%
%                         % MatName = {numMouse nPhase Tctrl Tvari Tfixa dRun}
%                         MATData=[MATData; [numMouse nPhase Tctrl Tvari Tfixa dRun] ];
%
%                         % save Individual Figures
%                         if ~exist(['Temp_',NameExperimentFolder,'_',NameInFiles],'dir')
%                             mkdir(['Temp_',NameExperimentFolder,'_',NameInFiles])
%                         end
%                         try
%                             saveFigure(numF,['Mouse',nameMouse,'_Phase',num2str(nPhase),'_OdorAnalysis'],['Temp_',NameExperimentFolder,'_',NameInFiles]);
%                             disp(['saving figure in Temp_',NameExperimentFolder,'_',NameInFiles])
%                         catch
%                             copyfile([filename,mark,'Figure_OdorAnalysis.eps'],['Temp_',NameExperimentFolder,'_',NameInFiles,mark,'Mouse',nameMouse,'_Phase',num2str(nPhase),'_OdorAnalysis.eps'])
%                             disp(['copying existing figure into Temp_',NameExperimentFolder,'_',NameInFiles])
%                         end
%                     end
%                 end
%
%             end
%         end
%     end
% end
%
%
% %% DISPLAY TIME IN ODOR ZONE FOR MICE AND PHASES
%
% figure('Color',[1 1 1],'Position',scrsz); numF=gcf;
%
% AllMouse=unique(MATData(:,1));
% Allphase=unique(MATData(:,2));
%
% labelX=[];
% for mi=1:length(AllMouse)
%     labelX=[labelX;MATData(MATData(:,1)==AllMouse(mi),2)+(mi-1)*(length(Allphase)+1)];
% end
%
% % ------------------------------------------------------------------------
% % stacked bar for every mouse and phase
% subplot(2,3,1:2)
% bar(labelX ,MATData(:,3:5),'stacked')
% ylim([0 100]); colormap bone
% legend(OrderLabel,'Location','NorthWest')
% ylabel('% time around odor')
% title(['Exploration of odor locations (first ',num2str(AnalyTimeRestrict),'s)'])
%
% nameMi=[];
% for i=1:length(MATData(:,1))
%     if ~sum(strcmp(nameMi,num2str(MATData(i,1))))
%         nameMi=[nameMi,{num2str(MATData(i,1))}];
%         text((length(Allphase)+1)*(length(nameMi)-1)+1,-10,num2str(MATData(i,1)));
%     end
% end
% text(-length(AllMouse)/2,-10,'Mouse');
% text(-length(AllMouse)/2,-3,'Phase');
%
% for ph=1:length(Allphase)
%     PhaseLabelShort(ph)={num2str(Allphase(ph))};
% end
% set(gca,'XTick',labelX)
% set(gca,'XTickLabel',PhaseLabelShort)
%
% % ------------------------------------------------------------------------
% % bar plot for each phase, mice pooled
% PhaseLabel={};
% for ph=1:length(Allphase)
%     PhaseLabel=[PhaseLabel,['Phase ',num2str(Allphase(ph))]];
%     for od=1:length(OrderLabel)
%         MeanMatOdor(od,ph)=nanmean(MATData(MATData(:,2)==Allphase(ph),od+2));
%         stdMatOdor(od,ph)=stdError(MATData(MATData(:,2)==Allphase(ph),od+2));
%     end
%     indexph=find(MATData(:,2)==Allphase(ph) &  MATData(:,5)~=0);
%     MeanVarOnFix(ph)=nanmean(MATData(indexph,4)./MATData(indexph,5));
%     stdVarOnFix(ph)=stdError(MATData(indexph,4)./MATData(indexph,5));
% end
%
% % % time around each type of odor
% labelX=[(1:length(OrderLabel))-0.2;(1:length(OrderLabel));(1:length(OrderLabel))+0.2]';
% subplot(2,3,4)
% bar(MeanMatOdor), colormap bone
% legend(PhaseLabel,'Location','NorthWest')
% hold on, errorbar(labelX,MeanMatOdor,stdMatOdor,'+k')
% set(gca,'XTick',[1:length(OrderLabel)])
% set(gca,'XTickLabel',OrderLabel)
% ylabel('% time around odor')
% title(['Exploration of odor locations (n=',num2str(length(AllMouse)),')'])
%
% % ratio VAR/FIX, bar plot for each phase, mice pooled
% subplot(2,3,5), bar(MeanVarOnFix),
% hold on, errorbar(1:length(Allphase),MeanVarOnFix,stdVarOnFix,'+k')
% set(gca,'XTick',[1:length(Allphase)])
% set(gca,'XTickLabel',PhaseLabel)
% title(['Ratio VARIANT/FIXED (n=',num2str(length(AllMouse)),')'])
% line([0,length(Allphase)+1],[1 1],'Color','r')
%
% %% DISPLAY DISTANCE TRAVELED
%
% Matd=NaN(length(AllMouse),length(Allphase));
% for ph=1:length(Allphase)
%     for mi=1:length(AllMouse)
%         try Matd(mi,ph)=MATData(MATData(:,2)==Allphase(ph) & MATData(:,1)==AllMouse(mi),6);end
%         nameMi{mi}=num2str(AllMouse(mi));
%     end
%     MeanMatd(ph)=nanmean(Matd(mi,ph));
%     stdMatd(ph)=stdError(Matd(mi,ph));
% end
%
% % ------------------------------------------------------------------------
% % stacked bar for every mouse and phase
% subplot(2,3,6)
% bar(1:length(AllMouse) ,Matd,'stacked')
% ylim([0 3*max(max(Matd))])
% legend(PhaseLabel,'Location','NorthEast')
% ylabel('% time around odor')
% title(['Traveled distance (first ',num2str(AnalyTimeRestrict),'s)'])
% set(gca,'XTick',[1:length(AllMouse)])
% set(gca,'XTickLabel',nameMi)
% xlabel('Mouse number')
%
% % -------------------------------------------------------------------------
% % distance plot for each phase, mice pooled
% subplot(2,3,3)
% bar(MeanMatd), colormap bone
% hold on, errorbar(1:length(Allphase),MeanMatd,stdMatd,'+k')
% set(gca,'XTick',1:length(Allphase))
% set(gca,'XTickLabel',PhaseLabel)
% ylabel('distance (ua)')
% title(['Traveled distance (first ',num2str(AnalyTimeRestrict),'s) (n=',num2str(length(AllMouse)),')'])
%
%
%
% %% SAVE ANALYSIS AND FIGURES
%
% choice=questdlg('Do you want to save Analysis and Figures? ','SAVE','Yes','No','Yes');
% switch choice
%     case 'Yes'
%         defAns={['Analysis_',NameExperimentFolder,num2str(AnalyTimeRestrict),'s_',NameInFiles]};
%         prompt = {'Name of the folder to create in this path'};
%         dlg_title = 'Save in...';
%         options.resize='on';
%         answer = inputdlg(prompt,dlg_title,1,defAns,options);
%
%         while exist(answer{1},'dir')
%             temp=answer{1};
%             answer{1}=[temp,'A'];
%         end
%         try
%             rename(['Temp_',NameExperimentFolder,'_',NameInFiles],answer{1})
%         catch
%             mkdir(answer{1});
%         end
%         saveFigure(numF,['Figure_',NameExperimentFolder,num2str(AnalyTimeRestrict),'s_',NameInFiles],answer{1})
%         save([answer{1},mark,'OdorAnalysis_',NameExperimentFolder,num2str(AnalyTimeRestrict),'s_',NameInFiles],'MATData','OrderLabel','MatName','AnalyTimeRestrict','NameExperimentFolder','NameInFiles');
%
%     case 'No'
%         savetemp=1;
%         rmdir(['Temp_',NameExperimentFolder,'_',NameInFiles],'s');
% end
%
%
%
%
%

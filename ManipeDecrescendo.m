% ManipeDecrescendo.m


% to analyse manipe decrescendo:
% run makeData.m
% run AnalysisPlacePreferenceDecrescendo.m
% 
% You need to have copied NosePoke data into a 4culumn matrix NosePokeMat 
% NosePokeMat_name={'Voltage','%time','Session','PRE/ICSS/POST'};
% for exemple: save('ICSS-Mouse-107-13012014/NosePoke107.mat','NosePokeMat','NosePokeMat_name') 
%
%

%% path definition: ADD NEW EXPERIMENT HERE

a=0;
a=a+1; pathDef{a}='/media/DataMOBsRAID5/ProjetSommeil/ManipeManual/Mouse107/20140113/ICSS-Mouse-107-13012014';
a=a+1; pathDef{a}='/media/DataMOBsRAID5/ProjetSommeil/ManipeManual/Mouse109/20140113/ICSS-Mouse-109-13012014';
a=a+1; pathDef{a}='/media/DataMOBsRAID5/ProjetSommeil/ManipeManual/Mouse111/20140120/ICSS-Mouse-111-20012014';
a=a+1; pathDef{a}='/media/DataMOBsRAID5/ProjetSommeil/ManipeManual/Mouse113/20140213/ICSS-Mouse-113-13022014';
a=a+1; pathDef{a}='/media/DataMOBsRAID5/ProjetSommeil/ManipeManual/Mouse114/20140212/ICSS-Mouse-114-12022014';
a=a+1; pathDef{a}='/media/DataMOBsRAID5/ProjetSommeil/ManipeManual/Mouse116/20140214/ICSS-Mouse-116-14022014';

%% other inputs and definition

FolderToSave='/home/karim/Dropbox/MOBS_workingON/PROJETSommeil/ManipePlacePreferenceDecrescendo';
FigureIndividual=1;
savFigure=1;

res=pwd;
scrz=get(0,'ScreenSize');


%% try load existing file

if exist([FolderToSave,'/Bilan_PlacePref_Decrescendo.mat'],'file')
   load([FolderToSave,'/Bilan_PlacePref_Decrescendo'])
   if exist('Mat','var') && exist('pathDef','var')
      ok=input('Bilan_PlacePref_Decrescendo.mat already exists. Erase it? (y/n): ','s'); 
   end
else
    ok='y';
end

%% collect data for each experiment and put them into Mat and Mat_all

if ok=='y'
    Mat=[];
    Mat_all=[];
    Name_Mouse={};
    %----------------------------------------------------------------------
    % this is what each column of Mat_all and Mat is for
    MatName={'Mouse','Voltage','%NosePoke','%ppPRE','%ppICSS','%ppPOST','%ppPREnorm','%ppICSSnorm','%ppPOSTnorm'};
    %----------------------------------------------------------------------

    for i=1:length(pathDef)
        clear Mat_allTemp MatTemp NumMouse NosePokeMat PercIn NosePokeMat PercPF
        
        % goes to the path and load data
        cd(pathDef{i});
        NumMouse=pathDef{i}(max(strfind(pathDef{i},'Mouse'))+6:max(strfind(pathDef{i},'Mouse'))+8);
        
        load([pathDef{i},'/NosePoke',NumMouse,'.mat'],'NosePokeMat')
        load([pathDef{i},'/Analy_PlacePref_Decrescendo/AllEpochs.mat'],'Manual')
        load([pathDef{i},'/Analy_PlacePref_Decrescendo/AnalysisPercentage.mat'],'PercIn','PercPF')
        
        % data from nosepoke [voltage,%NosePoke]
        Mat_allTemp=NosePokeMat(NosePokeMat(:,4)==2,1:2);
        
        % data from decrescendo expe, repeated for each NosePoke session
        Mat_allTemp(:,3:8)=NaN(size(Mat_allTemp,1),6);
        for j=1:size(Mat_allTemp,1)
            if sum(Manual.voltage==Mat_allTemp(j,1))
                %[ppPRE,ppICSS,ppPOST]
                Mat_allTemp(j,3:5)=PercIn(Manual.voltage==Mat_allTemp(j,1),:);
                %[ppPREnorm,ppICSSnorm,ppPOSTnorm]
                Mat_allTemp(j,6:8)=PercIn(Manual.voltage==Mat_allTemp(j,1),:)./mean(PercPF(:,1));
            end
        end
        
        % data from decrescendo expe, averaged on each nosepoke voltage
        MatTemp=nan(length(Manual.voltage),8);
        for vv=1:length(Manual.voltage)
            MatTemp(vv,:)=nanmean(Mat_allTemp(Mat_allTemp(:,1)==Manual.voltage(vv),:),1);
        end
        
        % save individual figure 
        if FigureIndividual
            % plot intermediate
            figure('Color',[1 1 1],'position',scrz/3),
            subplot(1,2,1), scatter(MatTemp(:,4),MatTemp(:,5),100,MatTemp(:,2),'filled')
            title(['Efficiency Place preference Mouse',NumMouse,' (color = % NosePoke)']);colorbar 
            xlabel('% time in stim Area during ICSS')
            ylabel('% time in stim Area during POST')
            
            subplot(1,2,2), text(0.3,0.5,num2str(floor(MatTemp')))
            hold on, text(0,0.5,MatName(2:end)); axis off
            saveFigure(gcf,['EfficiencyPPmouse',NumMouse],FolderToSave)
            delete([FolderToSave,'/EfficiencyPPmouse',NumMouse,'.png']) % keep only .eps
            close
        end
        
        % Add the number of mouse and stock into final matrices
        Mat_all=[Mat_all;[zeros(size(Mat_allTemp,1),1)+i,Mat_allTemp]];
        Mat=[Mat;[zeros(size(MatTemp,1),1)+i,MatTemp]];
        
        Name_Mouse{i}=['Mouse',NumMouse];
    end
    
end


%% save data

cd(res)
if ok=='y'
    disp(['Saving in ' ,FolderToSave,'/Bilan_PlacePref_Decrescendo.mat'])
    save([FolderToSave,'/Bilan_PlacePref_Decrescendo.mat'],'Mat','Mat_all','pathDef','Name_Mouse','MatName')
end

%% calculate correlation coefficient for Mat_all
index=~isnan(Mat_all(:,3)) & ~isnan(Mat_all(:,5));
disp('       * one point for each nosepoke session *')

% Nose Poke (N) VS decrescendo ICSS (I)
[rNI_all,pNI_all]=corrcoef(Mat_all(index,3),Mat_all(index,5));
varNI_all=polyfit(Mat_all(index,3),Mat_all(index,5),1);
disp(['Nose Poke versus decrescendo ICSS: ',num2str(['r²=',num2str(rNI_all(2,1)),', p=',num2str(pNI_all(2,1))])])

% Nose Poke (N) VS decrescendo POST (P)
[rNP_all,pNP_all]=corrcoef(Mat_all(index,3),Mat_all(index,6));
varNP_all=polyfit(Mat_all(index,3),Mat_all(index,6),1);
disp(['Nose Poke versus decrescendo POST: ',num2str(['r²=',num2str(rNP_all(2,1)),', p=',num2str(pNP_all(2,1))])])

%  decresendo ICSS (I) VS decrescendo POST (P)
[rIP_all,pIP_all]=corrcoef(Mat_all(index,5),Mat_all(index,6));
varIP_all=polyfit(Mat_all(index,5),Mat_all(index,6),1);
disp(['decresendo ICSS versus decrescendo POST: ',num2str(['r²=',num2str(rIP_all(2,1)),', p=',num2str(pIP_all(2,1))])])


%% calculate correlation coefficient for Mat
index=~isnan(Mat(:,3)) & ~isnan(Mat(:,5));
disp('       * one point for averaged nosepoke on voltage *')

% Nose Poke (N) VS decrescendo ICSS (I)
[rNI,pNI]=corrcoef(Mat(index,3),Mat(index,5));
varNI=polyfit(Mat(index,3),Mat(index,5),1);
disp(['Nose Poke versus decrescendo ICSS: ',num2str(['r²=',num2str(rNI(2,1)),', p=',num2str(pNI(2,1))])])

% Nose Poke (N) VS decrescendo POST (P)
[rNP,pNP]=corrcoef(Mat(index,3),Mat(index,6));
varNP=polyfit(Mat(index,3),Mat(index,6),1);
disp(['Nose Poke versus decrescendo POST: ',num2str(['r²=',num2str(rNP(2,1)),', p=',num2str(pNP(2,1))])])

%  decresendo ICSS (I) VS decrescendo POST (P)
[rIP,pIP]=corrcoef(Mat(index,5),Mat(index,6));
varIP=polyfit(Mat(index,5),Mat(index,6),1);
disp(['decresendo ICSS versus decrescendo POST: ',num2str(['r²=',num2str(rIP(2,1)),', p=',num2str(pIP(2,1))])])






%% Display Mat_all = one point for each nosepoke session
% remember MatName={'Mouse','Voltage','%NosePoke','%ppPRE','%ppICSS','%ppPOST','%ppPREnorm','%ppICSSnorm','%ppPOSTnorm'};

figure('Color',[1 1 1],'position',scrz), FigMat_all=gcf;

for i=1:length(pathDef)
    index=find(Mat_all(:,1)==i);
    
    % Nose Poke (N) VS decrescendo ICSS (I)
    subplot(2,2,1), hold on,
    plot(Mat_all(index,3),Mat_all(index,5),'k.','MarkerSize',20,'Color',[0.1*i 0.1*i 0.1*i])
    hold on, line([0 100],[0 100]*varNI_all(1)+varNI_all(2)); ylim([0 100]); xlim([0 100]);
    hold on, line([0 100],[0 100],'Color',[0.5 0.5 0.5],'LineStyle',':')
    text(50,50,['r2=',num2str(rNI_all(2,1)),' ,p=',num2str(pNI_all(2,1))],'Color','b')
    title('Correlation Nose Poke vs ICSS decrescendo (ALL session)')
    xlabel('% Time in NosePoke'); ylabel('% Time in Stim Area')
    
    % Nose Poke (N) VS decrescendo POST (P)
    subplot(2,2,2), hold on,
    plot(Mat_all(index,3),Mat_all(index,6),'r.','MarkerSize',20,'Color',[0.1*i 0.1*i 0.1*i])
    hold on, line([0 100],[0 100]*varNP_all(1)+varNP_all(2)); ylim([0 100]); xlim([0 100]);
    hold on, line([0 100],[0 100],'Color',[0.5 0.5 0.5],'LineStyle',':')
    text(50,50,['r2=',num2str(rNP_all(2,1)),' ,p=',num2str(pNP_all(2,1))],'Color','b')
    title('Correlation Nose Poke vs POST decrescendo (ALL session)')
    xlabel('% Time in NosePoke'); ylabel('% Time in Stim Area')
    
    % Nose Poke (N) VS decrescendo ICSS (I) normalized
    subplot(2,2,3), hold on,
    plot(Mat_all(index,3),Mat_all(index,8),'k.','MarkerSize',20,'Color',[0.1*i 0.1*i 0.1*i])
    title('Correlation Nose Poke vs ICSS decrescendo (ALL session)')
    xlabel('% Time in NosePoke'); ylabel('Increase of time in stim Area')
    
    % Nose Poke (N) VS decrescendo POST (P) normalized
    subplot(2,2,4), hold on,
    plot(Mat_all(index,3),Mat_all(index,9),'r.','MarkerSize',20,'Color',[0.1*i 0.1*i 0.1*i])
    title('Correlation Nose Poke vs POST decrescendo (ALL session)')
    xlabel('% Time in NosePoke'); ylabel('Increase of time in stim Area')
    
end
legend(Name_Mouse)


%% Display Mat = one point for averaged nosepoke on voltage
% remember MatName={'Mouse','Voltage','%NosePoke','%ppPRE','%ppICSS','%ppPOST','%ppPREnorm','%ppICSSnorm','%ppPOSTnorm'};

figure('Color',[1 1 1],'position',scrz), FigMat=gcf;

for i=1:length(pathDef)
    index=find(Mat(:,1)==i);
    
    % Nose Poke (N) VS decrescendo ICSS (I)
    subplot(2,2,1), hold on,
    plot(Mat(index,3),Mat(index,5),'k.','MarkerSize',20,'Color',[0.1*i 0.1*i 0.1*i])
    hold on, line([0 100],[0 100]*varNI(1)+varNI(2)); ylim([0 100]); xlim([0 100]);
    hold on, line([0 100],[0 100],'Color',[0.5 0.5 0.5],'LineStyle',':')
    text(50,50,['r2=',num2str(rNI(2,1)),' ,p=',num2str(pNI(2,1))],'Color','b')
    title('Correlation Nose Poke vs ICSS decrescendo')
    xlabel('% Time in NosePoke'); ylabel('% Time in Stim Area')
    
    % Nose Poke (N) VS decrescendo POST (P)
    subplot(2,2,2), hold on,
    plot(Mat(index,3),Mat(index,6),'r.','MarkerSize',20,'Color',[0.1*i 0.1*i 0.1*i])
    hold on, line([0 100],[0 100]*varNP(1)+varNP(2)); ylim([0 100]); xlim([0 100]);
    hold on, line([0 100],[0 100],'Color',[0.5 0.5 0.5],'LineStyle',':')
    text(50,50,['r2=',num2str(rNP(2,1)),' ,p=',num2str(pNP(2,1))],'Color','b')
    title('Correlation Nose Poke vs POST decrescendo')
    xlabel('% Time in NosePoke'); ylabel('% Time in Stim Area')
    
    % Nose Poke (N) VS decrescendo ICSS (I) normalized
    subplot(2,2,3), hold on,
    plot(Mat(index,3),Mat(index,8),'k.','MarkerSize',20,'Color',[0.1*i 0.1*i 0.1*i])
    title('Correlation Nose Poke vs ICSS decrescendo')
    xlabel('% Time in NosePoke'); ylabel('Increase of time in stim Area')
    
    % Nose Poke (N) VS decrescendo POST (P) normalized
    subplot(2,2,4), hold on,
    plot(Mat(index,3),Mat(index,9),'r.','MarkerSize',20,'Color',[0.1*i 0.1*i 0.1*i])
    title('Correlation Nose Poke vs POST decrescendo')
    xlabel('% Time in NosePoke'); ylabel('Increase of time in stim Area')
    
    legend(Name_Mouse{i})
    %keyboard
end
legend(Name_Mouse)


%% Display PP PRE/ PP POST/ NosePoke

figure('Color',[1 1 1]), Fig3D=gcf;
scatter(Mat(:,5),Mat(:,6),100,Mat(:,3),'filled')
hold on, line([0 100],[0 100]*varIP(1)+varIP(2)); ylim([0 100]); xlim([0 100]);
hold on, line([0 100],[0 100],'Color',[0.5 0.5 0.5],'LineStyle',':')
text(50,50,['r2=',num2str(rIP(2,1)),' ,p=',num2str(pIP(2,1))],'Color','b')
colorbar;
xlabel('% time in stim Area during ICSS')
ylabel('% time in stim Area during POST')
title('Efficiency Place preference (color = % NosePoke)')


%% save figures

if savFigure
    disp(['Saving figures in ',FolderToSave])
    saveFigure(Fig3D,'EfficiencyPP_Bilan',FolderToSave)
    delete([FolderToSave,'/EfficiencyPP_Bilan.png']);

    saveFigure(FigMat,'EfficiencyPP_Mat',FolderToSave)
    delete([FolderToSave,'/EfficiencyPP_Mat.png']);
    
    saveFigure(FigMat_all,'EfficiencyPP_Mat_all',FolderToSave)
    delete([FolderToSave,'/EfficiencyPP_Mat_all.png']);
end

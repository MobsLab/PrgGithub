%CorrHyperActivityPain
% 20.02.2017 (from CorrFreezingPain)

% 13.01.2016 (from CorrFreezingActivity)
% can correlate pain with
% - the total nb of jump
% - the nb of jumps at a Temperature (i.e. during a minute ex between 43 and 44°)
% - the latency to reach a nb of jump
% default : (Pearson 

% run on /media/DataMOBsRAID/ProjetAversion/PAIN/manip22souris_sham-obx
sav=0;

%%%%%%%%%%%%%%%%% PARAMETERS
% define parameter to correlate with freezing
%Param2corr='totJumpNb';
%Param2corr='JumpNbPerMin';
%Param2corr='TempToReachXJump';
Param2corr='JumpNbRangeT';
% parametric or non parametric correlation
type='Spearman';
% type='Pearson';

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  Nov15
manipname='ManipNov15Bulbectomie';
hab='grille';
period='FullPeriod'; % SoundOnly ou FullPeriod
freezTh=1.5;


%%%%%%%%%%%%%%%%% load pain data
cd (['/media/DataMOBsRAID/ProjetAversion/PAIN/manip22souris_sham-obx']);
%load (['PainData_22souris_rampe15.mat'])
load (['PainData_22souris_rampe90.mat'])
%StepNamePain=StepName;
StepNamePain={'pain'};

% %%%%%%%%%%%%%%%%% load freezing data
% cd (['/media/DataMOBsRAID/ProjetAversion/' manipname '/Freezing' period])
% load(['shamAllMiceBilan_' num2str(freezTh) '_' hab '.mat'])
% bilanSham=bilan;
% load(['bulbAllMiceBilan_' num2str(freezTh) '_' hab '.mat'])
% bilanBulb=bilan;
% StepNameFreeze=StepName; % HAB COND EXTenvC EXTenvB


%%%%%%%%%%%%%%%%% load hyperactivity data
CorrWidth=5;
cd (['/media/DataMOBsRAID/ProjetAversion/' manipname '/Hyperactivity'])
load([ 'Hyperactivity_' num2str(CorrWidth) '.mat'])
StepNameH=StepName;

Gpcolor={[0.7 0.7 0.7], 'k'};
period='FullPeriod';%need to put it here again since bulbAllMiceBilan_1.5_grille.mat contains a  variable called period

cd (['/media/DataMOBsRAID/ProjetAversion/PAIN/manip22souris_sham-obx']);

% ParamList={'JumpNb'};
%ParamList={'totJumpNb', 'JumpNbPerMin','TempToReachXJump'};
ParamList={'JumpNbRangeT', 'JumpNbPerMin','TempToReachXJump'};
% ParamList={'TempToReachXJump'};
% ParamList={'JumpNbPerMin'};


%% PLOT CORRELATIONS

degree=13; % degree of interest for the param 'JumpNbPerMin'
%for degree=10:14

% initialize matrix of corr coeff and R
R={};
P={};
% R{1}=[];R{2}=[];R{3}=[];
% P{1}=[];P{2}=[];P{3}=[];
JumpThresh=[];% matrix of JumpTh

HyperActivityParam=TotalDistanceTable;
figure('Position', [ 1999 339  1828 300*length(ParamList)])

JumpTh=5;
%for JumpTh=[1 5 10:10:90];

    for k=1:length(ParamList)
        
        % Build Pa1 and Pa2 (pain parameter)    
        %figure('Position', [ 1999 339  1828 300*length(StepNamePain)])
        Pa1=JumpNb{1,1};
        Pa2=JumpNb{1,2};
        
        switch ParamList{k}
            case 'totJumpNb';
                ParamName='totJumpNb';
                Pa1=sum(Pa1,2);
                Pa2=sum(Pa2,2);
            case 'JumpNbPerMin'
                ParamName=['JumpNb-' num2str(30+degree) '-' num2str(30+degree+1) 'deg'];
                DegOfInterest=(Temperature>=30+degree)&(Temperature<30+degree+1);
                Pa1=mean(Pa1(:,DegOfInterest),2);
                Pa2=mean(Pa2(:,DegOfInterest),2);
            case 'JumpNbRangeT'
                rangeT=[41 45];
                ParamName=['JumpNb-' num2str(rangeT(1)) '-' num2str(rangeT(end)) 'deg'];
                DegOfInterest=(Temperature>=rangeT(1))&(Temperature<rangeT(end));
                Pa1=mean(Pa1(:,DegOfInterest),2);
                Pa2=mean(Pa2(:,DegOfInterest),2);
            case 'TempToReachXJump'
                
                ParamName=['TempToReach' num2str(JumpTh) 'jump'];
                Cum1=cumsum(Pa1,2);
                Cum2=cumsum(Pa2,2);      
                PainTPa1=NaN(11,1);
                PainTPa2=NaN(11,1);
                for mn=1:11;
                    if ~isempty(find(Cum1(mn,:)>JumpTh))
                        PainTPa1(mn)=Temperature(find(Cum1(mn,:)>JumpTh,1));
                    else
                        PainTPa1(mn)=45;
                    end
                    if ~isempty(find(Cum2(mn,:)>JumpTh))
                        PainTPa2(mn)=Temperature(find(Cum2(mn,:)>JumpTh,1));
                    else
                        PainTPa2(mn)=45;
                    end
                end
                Pa1=PainTPa1;
                Pa2=PainTPa2;
        end

        % % Build Pa1 and Pa2 (pain parameter)  
        j=k;

        for i=1:length(StepNameH) % COND EXTenvC EXTenvB
                stepH=StepNameH{i};

                
                H1=HyperActivityParam{1,1}(:,i); % 4 = end of the COND session
                H2=HyperActivityParam{1,2}(:,i); disp(['correlate with freezing during first bloc of CS+'])
                
                
                subplot(length(ParamList),length(StepNameH),length(StepNameH)*(j-1)+i)
                scatter(Pa1,H1, 'MarkerFaceColor', Gpcolor{1},'MarkerEdgeColor', 'k'), hold on
                scatter(Pa2, H2,'MarkerFaceColor', Gpcolor{2},'MarkerEdgeColor', 'k')

                xlabel(ParamName)
                ylabel(stepH )

                if j==1 &&i==1% if j==2 &&i==2
                    XL=xlim;
                    YL=ylim;
                    text(-0.4, 1, type, 'units', 'normalized')
                    text(-0.4, 1.2, 'TotalDist', 'units', 'normalized')
                end

                [r1,p1]=corr(Pa1,H1,'type',type);
                [r2,p2]=corr(Pa2,H2,'type',type);
                [r,p]=corr([Pa1;Pa2],[H1;H2],'type',type);

                title([ 'sham p ' sprintf('%.2f',(p1)) ' / bulb p ' sprintf('%.2f',(p2)) '/ all p ' sprintf('%.2f',(p))]);
                %ylim([0 35])

               
                pf1= polyfit(Pa1,H1,1);
                pf2= polyfit(Pa2,H2,1);
                pf3= polyfit([Pa1;Pa2],[H1;H2],1);
                
               
                if p1<0.05
                    line([min(Pa1),max(Pa1)],pf1(2)+[min(Pa1),max(Pa1)]*pf1(1),'Color',Gpcolor{1},'Linewidth',2)
                elseif p1<0.1
                    line([min(Pa1),max(Pa1)],pf1(2)+[min(Pa1),max(Pa1)]*pf1(1),'Color',Gpcolor{1},'Linewidth',1)
                end
                if p2<0.05
                    line([min(Pa2),max(Pa2)],pf2(2)+[min(Pa2),max(Pa2)]*pf2(1),'Color',Gpcolor{2},'Linewidth',2)
                elseif p2<0.1
                    line([min(Pa2),max(Pa2)],pf2(2)+[min(Pa2),max(Pa2)]*pf2(1),'Color',Gpcolor{2},'Linewidth',1)
                end
                if p<0.05
                    line([min([Pa1;Pa2]),max([Pa1;Pa2])],pf3(2)+[min([Pa1;Pa2]),max([Pa1;Pa2])]*pf3(1),'Color',Gpcolor{2},'Linewidth',1,'LineStyle',':')
                end

                
                
                set(gcf, 'Name', ParamName)

                R{i}=[r1,r2,r];%R{i}=[R{i};r1,r2,r];
                P{i}=[p1,p2,p];%P{i}=[P{i};p1,p2,p];

            end
        

        legend('sham', 'bulb')
        if sav
            saveFigure (gcf,['Corr_' ParamName '-TotalDist'], ['/media/DataMOBsRAID/ProjetAversion/PAIN/manip22souris_sham-obx' ])
            saveas (gcf, ['/media/DataMOBsRAID/ProjetAversion/PAIN/manip22souris_sham-obx/Corr_' ParamName '-TotalDist.fig'])
        end
    end
   % JumpThresh=[JumpThresh;JumpTh];
%end % end of JumpTh loop
if sav
    save (['CorrCoef_' Param2corr '_TotalDist_' type ],'R','P','JumpThresh')
end
% 
% %% Plot R and p in function of JumpThreshold
% 
% for i=1:length(StepNameH)
%     figure('Position', [2061    534   794  308]), hold on
%     colori={[0.5 0.5 0.5],[0 0 0],[0 0 0]};
%     styli={'-','-',':'};
%     subplot(1,2,1)
%     for nn=1:3
%         plot(JumpThresh,R{i}(:,nn),'Color',colori{nn},'LineStyle',styli{nn},'LineWidth',2),hold on
%     end
%     xlabel('JumpThresh'),title(type)
%     if strcmp(type, 'Pearson'), ylabel('R'),elseif strcmp(type, 'Spearman'), ylabel('Rho'),end
%     Y=ylim;
%     text(-30,Y(2),StepNameH{i})
%     subplot(1,2,2)
% 
%     for nn=1:3
%         plot(JumpThresh,P{i}(:,nn),'Color',colori{nn},'LineStyle',styli{nn},'LineWidth',2),hold on
%     end
%     xlabel('JumpThresh'),ylabel('p'), title(type)
%     legend({'sham','bulb'});
%     plot([JumpThresh(1) JumpThresh(end)],[0.05 0.05],':r')
%     
%     if sav
%     saveas (gcf, ['/media/DataMOBsRAID/ProjetAversion/PAIN/manip22souris_sham-obx/CorrCoef_Temp_' Param2corr '_' type '_' StepNameH{i} '.fig'])
%     saveFigure(gcf,['CorrCoef_TotalDist_' Param2corr '_' type '_' StepNameH{i}], ['/media/DataMOBsRAID/ProjetAversion/PAIN/manip22souris_sham-obx' ])
%     end
% end

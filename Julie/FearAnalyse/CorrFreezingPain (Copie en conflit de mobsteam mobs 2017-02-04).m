%CorrFreezingPain

% 13.01.2016 (from CorrFreezingActivity)
% can correlate pain with
% - the total nb of jump
% - the nb of jumps at a Temperature (i.e. during a minute ex between 43 and 44°)
% - the latency to reach a nb of jump
% default : (Pearson 

% run on /media/DataMOBsRAID/ProjetAversion/PAIN/manip22souris_sham-obx

%%%%%%%%%%%%%%%%% PARAMETERS
% define parameter to correlate with freezing
%Param2corr='totJumpNb';
%Param2corr='JumpNbPerMin';
Param2corr='TempToReachXJump';
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
%StepNameHyp=StepName;
StepNameHyp={'pain'};

%%%%%%%%%%%%%%%%% load freezing data
cd (['/media/DataMOBsRAID/ProjetAversion/' manipname '/Freezing' period])
load(['shamAllMiceBilan_' num2str(freezTh) '_' hab '.mat'])
bilanSham=bilan;
load(['bulbAllMiceBilan_' num2str(freezTh) '_' hab '.mat'])
bilanBulb=bilan;
StepNameFreeze=StepName; % HAB COND EXTenvC EXTenvB

Gpcolor={[0.7 0.7 0.7], 'k'};
period='FullPeriod';%need to put it here again since bulbAllMiceBilan_1.5_grille.mat contains a  variable called period

cd (['/media/DataMOBsRAID/ProjetAversion/PAIN/manip22souris_sham-obx']);

ParamList={'JumpNb'};




degree=13;
%for degree=10:15


% initialize matrix of corr coeff and R
R{1}=[];R{2}=[];R{3}=[];
P{1}=[];P{2}=[];P{3}=[];
JumpThresh=[];
for JumpTh=[1 5 10:10:90];
%for JumpTh=10;


    for k=1:length(ParamList)

        figure('Position', [2300 500 1200 300*length(StepNameHyp)])
        eval(['H1=',ParamList{k},'{1,1};']);
        eval(['H2=',ParamList{k},'{1,2};']);

        switch Param2corr
            case 'totJumpNb';
                ParamName='totJumpNb';
                H1=sum(H1,2);
                H2=sum(H2,2);
            case 'JumpNbPerMin'
                ParamName=['JumpNb' num2str(30+degree) '-44deg'];
                H1=mean(H1(:,degree:degree+1),2);
                H2=mean(H2(:,degree:degree+1),2);
            case 'TempToReachXJump'
                ParamName=['TempToReach' num2str(JumpTh) 'jump'];
                Cum1=cumsum(H1,2);
                Cum2=cumsum(H2,2);      
                PainTh1=NaN(11,1);
                PainTh2=NaN(11,1);
                for mn=1:11;
                    if ~isempty(find(Cum1(mn,:)>JumpTh))
                        PainTh1(mn)=Temperature(find(Cum1(mn,:)>JumpTh,1));
                    else
                        PainTh1(mn)=45;
                    end
                    if ~isempty(find(Cum2(mn,:)>JumpTh))
                        PainTh2(mn)=Temperature(find(Cum2(mn,:)>JumpTh,1));
                    else
                        PainTh2(mn)=45;
                    end
                end
                H1=PainTh1;
                H2=PainTh2;
        end




            j=1;
            stepH=StepNameHyp;

            for i=2:length(StepNameFreeze) % COND EXTenvC EXTenvB
                stepF=StepNameFreeze{i};
                %F1=mean(bilanSham{1,i}, 2); % mean on columns : one value for the coditioning session (alternative :derniere(s) colonne(s)
                F1=bilanSham{1,i}(:,3); % 4 = end of the COND session

                %F2=mean(bilanBulb{1,i}, 2); disp(['correlate with freezing during whole session'])
                F2=bilanBulb{1,i}(:,3);  disp(['correlate with freezing during first bloc of CS+'])

                subplot(length(StepNameHyp),3,3*(j-1)+i-1)
                scatter(H1,F1, 'MarkerFaceColor', Gpcolor{1},'MarkerEdgeColor', 'k'), hold on
                scatter(H2, F2,'MarkerFaceColor', Gpcolor{2},'MarkerEdgeColor', 'k')

                xlabel(ParamName)
                ylabel([stepF '  CS+1'])
                
                if j==1 &&i==2% if j==2 &&i==2
                    XL=xlim;
                    YL=ylim;
                    %text((XL(1)-(XL(2)-XL(1))*0.4), (YL(1)+(YL(2)-YL(1))*1.2), type)
                    text((XL(1)-(XL(2)-XL(1))*0.4), YL(2), type)
                end

                [r1,p1]=corr(H1,F1,'type',type);
                [r2,p2]=corr(H2,F2,'type',type);
                [r,p]=corr([H1;H2],[F1;F2],'type',type);

                title([ 'sham p ' sprintf('%.2f',(p1)) ' / bulb p ' sprintf('%.2f',(p2)) '/ all p ' sprintf('%.2f',(p))]);
                %ylim([0 35])

                pf1= polyfit(H1,F1,1);
                line([min(H1),max(H1)],pf1(2)+[min(H1),max(H1)]*pf1(1),'Color',Gpcolor{1},'Linewidth',2)
                pf2= polyfit(H2,F2,1);
                line([min(H2),max(H2)],pf2(2)+[min(H2),max(H2)]*pf2(1),'Color',Gpcolor{2},'Linewidth',2)
                pf3= polyfit([H1;H2],[F1;F2],1);
                line([min([H1;H2]),max([H1;H2])],pf3(2)+[min([H1;H2]),max([H1;H2])]*pf3(1),'Color',Gpcolor{2},'Linewidth',1,'LineStyle',':')

                

                set(gcf, 'Name', ParamName)
                
                R{i-1}=[R{i-1};r1,r2,r];
                P{i-1}=[P{i-1};p1,p2,p];
        
            end
        JumpThresh=[JumpThresh;JumpTh];
        
        legend('sham', 'bulb')
        saveFigure (gcf,['Corr_' ParamName '-Freez'], ['/media/DataMOBsRAID/ProjetAversion/PAIN/manip22souris_sham-obx' ])
        saveas (gcf, ['/media/DataMOBsRAID/ProjetAversion/PAIN/manip22souris_sham-obx/Corr_' ParamName '-Freez.fig'])
    end

end % end of JumpTh loop

save (['CorrCoef_Temp_' Param2corr '_' type ],'R','P','JumpThresh')

for i=(2:4)
    figure('Position', [2061    534   794  308]), hold on
    colori={[0.5 0.5 0.5],[0 0 0],[0 0 0]};
    styli={'-','-',':'};
    subplot(1,2,1)
    for nn=1:3
        plot(JumpThresh,R{i-1}(:,nn),'Color',colori{nn},'LineStyle',styli{nn},'LineWidth',2),hold on
    end
    xlabel('JumpThresh'),title(type)
    if strcmp(type, 'Pearson'), ylabel('R'),elseif strcmp(type, 'Spearman'), ylabel('Rho'),end
    Y=ylim;
    text(-30,Y(2),StepNameFreeze{i})
    subplot(1,2,2)

    for nn=1:3
        plot(JumpThresh,P{i-1}(:,nn),'Color',colori{nn},'LineStyle',styli{nn},'LineWidth',2),hold on
    end
    xlabel('JumpThresh'),ylabel('p'), title(type)
    legend({'sham','bulb'});
    plot([JumpThresh(1) JumpThresh(end)],[0.05 0.05],':r')

    saveas (gcf, ['/media/DataMOBsRAID/ProjetAversion/PAIN/manip22souris_sham-obx/CorrCoef_Temp_' Param2corr '_' type '_' StepNameFreeze{i} '.fig'])
    saveFigure (gcf,['CorrCoef_Temp_' Param2corr '_' type '_' StepNameFreeze{i}(end-3:end)], ['/media/DataMOBsRAID/ProjetAversion/PAIN/manip22souris_sham-obx' ])
end

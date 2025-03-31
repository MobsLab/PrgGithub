% PlotHabDistanceAndMovt
% 02.12.2015
sav=0;
cd('/media/DataMOBsRAID/ProjetAversion/PAIN/manip22souris_sham-obx')
res=pwd;
list=dir(res);

% ActivityFolder=([res '/PAIN2_activity_6souris_test']);
% RearingFolder=([res '/PAIN2_rearing_6souris_test']);
% rearingsuffix='-03122015-01-PAIN';
% ActivityFolder=([res '/HAB2_activity_22souris_sham-obx']);
% RearingFolder=([res '/HAB2_rearing_22souris_sham-obx']);
% rearingsuffix='-02122015-01-HABenvtest';

ActivityFolder=([res '/PAIN_activity_22souris_sham-obx']);
RearingFolder=([res '/PAIN_rearing_22souris_sham-obx']);
rearingsuffix='-04122015-01-COND';

a=1;
%% define groups
obxNb=[269:279];
for k=1:length(obxNb)
    obx{k}=num2str(obxNb(k));
end
obxmice=obx';
shamNb=[280:290];
%shamNb=[281:290];
for k=1:length(shamNb)
    sham{k}=num2str(shamNb(k));
end
shammice=sham';

% shammice={'263';'264';'265';'266';'267';'268'};
% obxmice={};
rearTh=1.5;
indivfig=0;

expgroup={shammice,obxmice};
groupname={'sham','bulb'};

RampeSize=15;
final_time=900;

%% LOAD OR COMPUTE DATA
try load(['PainData_22souris_rampe' num2str(RampeSize)])
    
catch
    
    Dist=nan(2, max(length(shammice), length(obxmice)));
    Movt=nan(2, max(length(shammice), length(obxmice)));
    RearTotal=nan(2, max(length(shammice), length(obxmice)));
    JumpTotal=nan(2, max(length(shammice), length(obxmice)));
    LickTotal=nan(2, max(length(shammice), length(obxmice)));

    for  g=1:2
        group=expgroup{g};
    %     groupFig=figure('Position', [503  101  1327  834]);%503 496 3147  439

        for mousenb=1:length(group)
            if indivfig
                indivFig{g,mousenb}=figure;
            end
            try
                %% distance and movement
                cd([ ActivityFolder '/M' num2str(group{mousenb}) ])
                load('Behavior.mat');
                X=PosMat(:,2);
                Y=PosMat(:,3);
                d=sqrt(diff(X).*diff(X)+diff(Y).*diff(Y));

                %subplot(length(group), 5, (mousenb-1)*5+[2:5])
                if indivfig
                    subplot(2, 5,[1:5])
                    plot(Range(Movtsd,'s'),Data(Movtsd),'k'), hold on


                    title([ 'M' num2str(group{mousenb}) '  '  sprintf('%.0f',nansum(d)) 'cm'])
                end
                Dist(g,mousenb)=nansum(d);
                Movt(g,mousenb)=nansum(Data(Movtsd));
            catch
                disp(['pb with M' num2str(group{mousenb}) ])

            end
                %% rearing, licking, jump
                cd([ RearingFolder '/FEAR-Mouse-' num2str(group{mousenb}) rearingsuffix ]) ;

                load('Behavior.mat');

                RearEp=thresholdIntervals(Movtsd,rearTh,'Direction','Below', 'b');
                AutoRearMatrix=Start(RearEp)'*1E-4;
                RearTotal(g,mousenb)=length(Start(RearEp));
                JumpTotal(g,mousenb)=length(JumpMatrix);
                LickTotal(g,mousenb)=length(LickMatrix);

                % plot
                if indivfig
                    subplot(2, 5,[6:10]);hold on 
                    if ~isempty(RearMatrix), plot(RearMatrix,10,'.r'); end
                    if ~isempty(JumpMatrix), plot(JumpMatrix,12,'*c'); end
                    if ~isempty(LickMatrix), plot(LickMatrix,15,'*g'); end

                    plot(Range(Movtsd,'s'),Data(Movtsd)), hold on 
                    if ~isempty(Start(RearEp))
                        for k=1:(length(Start(RearEp)))
                            plot(Range(Restrict(Movtsd,subset(RearEp,k)),'s'),Data(Restrict(Movtsd,subset(RearEp,k))),'k'),
                        end
                    end
                    legend({'rearing ';'jump';'lick'})

                    %saveas(indivFig{g,mousenb},[res '/indivFig/M' num2str(group{mousenb}) '_pain.fig'])
                    %saveFigure(indivFig{g,mousenb}, ['M' num2str(group{mousenb}) '_pain'], [res '/indivFig/'])
                end

                for i=1:RampeSize
                    %final_time=floor(max(Range(Movtsd, 's')));
                    interval_deb=(i-1)/RampeSize*final_time;
                    interval_fin=(i)/RampeSize*final_time;
                    AutoRearNb{g}(mousenb,i)=sum(AutoRearMatrix>interval_deb & AutoRearMatrix<interval_fin);
                    RearNb{g}(mousenb,i)=sum(RearMatrix>interval_deb & RearMatrix<interval_fin);
                    LickNb{g}(mousenb,i)=sum(LickMatrix>interval_deb & LickMatrix<interval_fin);
                    JumpNb{g}(mousenb,i)=sum(JumpMatrix>interval_deb & JumpMatrix<interval_fin);
                end

            cd(res)
        end

    
    %saveas(painfig, ['pain_' groupname{g} '.fig'])
    end

    save (['PainData_22souris_rampe' num2str(RampeSize)], 'RearNb','AutoRearNb','JumpNb','LickNb','Dist','Movt','TimeStamp','Temperature','groupname')
end

%% PLOT
for g=1:2
    x_axisNb=[30:45];
    for k=1:length(x_axisNb)
        x_axis_label{k}=num2str(x_axisNb(k));
    end


    TimeStamp=[0:final_time/RampeSize:final_time-(final_time/RampeSize)];
    Temperature=[30:(45-30)/RampeSize:45-(45-30)/RampeSize];
    painfig=figure('Position', [ 1640 94 337 880]);
    subplot(4,1,1),PlotErrorBarN(RearNb{1,g},0,1); ylabel('rear');ylim([0 15]); set(gca,'XTick',[1:16]);set(gca,'XTickLabel',x_axis_label);title(groupname{g})
    subplot(4,1,2),PlotErrorBarN(AutoRearNb{1,g},0,1); ylabel('auto-rear');ylim([0 15]); set(gca,'XTick',[1:16]);set(gca,'XTickLabel',x_axis_label);
    subplot(4,1,3),PlotErrorBarN(JumpNb{1,g},0,1); ylabel('jump'); set(gca,'XTick',[1:16]);set(gca,'XTickLabel',x_axis_label);
    subplot(4,1,4),PlotErrorBarN(LickNb{1,g},0,1); ylabel('lick'); set(gca,'XTick',[1:16]);set(gca,'XTickLabel',x_axis_label);
end
cd(res);
h_movt=figure('Position', [ 1289  412    449 562]);
subplot(2,1,1)
PlotErrorBarN(Dist',0,0);%1=newfig, 0=unpaired; default test=ranksum
ylabel('travelled distance');
set(gca,'XTick',[1:2]);
set(gca,'XTickLabel',{'sham','obx'});
subplot(2,1,2)
PlotErrorBarN(Movt',0,0);
ylabel('movement');
set(gca,'XTick',[1:2]);
set(gca,'XTickLabel',{'sham','obx'});

if sav
    saveas(h_movt, ['movement.fig'])
    saveFigure(h_movt, ['movement'], res)
end

%% error bar plot for all 4 parameters
if 0
    Gpcolor={[0.7 0.7 0.7],[0 0 0]};
    figure('Position',[ 1183  25 584   949])
    for g=1:2
    subplot(4,1,1),
    errorbar(nanmean(RearNb{1,g}), nanstd(RearNb{1,g})./sqrt(size(RearNb{1,g},2)), 'Color',Gpcolor{g}, 'LineWidth', 2), hold on; 
    ylabel('rear');ylim([0 15]); set(gca,'XTick',[1:16]);set(gca,'XTickLabel',x_axis_label);title(groupname{g})

    subplot(4,1,2),
    errorbar(nanmean(AutoRearNb{1,g}), nanstd(AutoRearNb{1,g})./sqrt(size(AutoRearNb{1,g},2)), 'Color',Gpcolor{g}, 'LineWidth', 2), hold on
    ylabel('auto-rear'); set(gca,'XTick',[1:16]);set(gca,'XTickLabel',x_axis_label);title(groupname{g})
    
    subplot(4,1,3),
    errorbar(nanmean(JumpNb{1,g}), nanstd(JumpNb{1,g})./sqrt(size(JumpNb{1,g},2)), 'Color',Gpcolor{g}, 'LineWidth', 2), hold on
    ylabel('jump'); set(gca,'XTick',[1:16]);set(gca,'XTickLabel',x_axis_label);title(groupname{g})
    
    subplot(4,1,4),
    errorbar(nanmean(LickNb{1,g}), nanstd(LickNb{1,g})./sqrt(size(LickNb{1,g},2)), 'Color',Gpcolor{g}, 'LineWidth', 2), hold on
    ylabel('lick'), set(gca,'XTick',[1:16]);set(gca,'XTickLabel',x_axis_label);title(groupname{g})
    end

end

%% Figure pour article 4Hz

%% figure with temperature ramp
Gpcolor={[0.7 0.7 0.7],[0 0 0]};
jumpfig=figure('Position',[ 1183  25 584   400]);
for g=1:2
    plot([1:15],nanmean(JumpNb{1,g}),'o', 'MarkerFaceColor',Gpcolor{g},'MarkerEdgeColor',Gpcolor{g}),hold on;
    legend(groupname, 'Location','NorthWest')
end
for g=1:2
    errorbar(nanmean(JumpNb{1,g}), nanstd(JumpNb{1,g})./sqrt(size(JumpNb{1,g},2)), 'Color',Gpcolor{g}, 'LineWidth', 2), hold on; 

    ylabel('jump nb');xlabel('temperature (deg C)'), set(gca,'XTick',[1:16]);set(gca,'XTickLabel',x_axis_label);
    
end
% stars
for i=1:size(JumpNb{1,g},2)
    x=JumpNb{1,1}(:,i);
    y=JumpNb{1,2}(:,i);
    if sum(~isnan(x))==0 ||sum(~isnan(y))==0
        Pmw=NaN; 
    else
        [Pmw,h_mw,table_mw] = ranksum(x(~isnan(x)), y(~isnan(y)));
    end
    p_mw(i)=Pmw;
    stats_mw(i)=table_mw;
    max=ylim;
    if Pmw<0.01
        text(i,0.9*max(2),'**','Color','r', 'FontSize', 20)
    elseif Pmw<0.05
        text(i,0.9*max(2),'*','Color','r', 'FontSize', 20)

    end  
end
 
if sav
    saveas(jumpfig, ['JumpRamp.fig'])
    saveFigure(jumpfig, ['JumpRamp'], res)
end

%% bar plot on averages - SUM
rangeT=[11:15];
rangeT=[13:14];
rangeT=[1:15];
JumpBar=figure('Position',[ 1183  25 300   400]);
for g=1:2
    bar(g, nanmean(nansum(JumpNb{1,g}(:,rangeT),2)) ), hold on; 
    %errorbar(g, nanmean(nansum(JumpNb{1,g}(:,:),2)), nanstd(nansum(JumpNb{1,g}(:,:),2))./sqrt(size(nansum(JumpNb{1,g}(:,:),2),2)))   
    errorbar(g, nanmean(nansum(JumpNb{1,g}(:,rangeT),2)), nanstd(nansum(JumpNb{1,g}(:,rangeT),2))./sqrt(size(nansum(JumpNb{1,g}(:,rangeT),2),2)))   
    ylabel('jump nb');
    
end
set(gca,'XTick', [1 2 ],'XTickLabel',groupname); 
% x=nansum(JumpNb{1,1}(:,:));
% y=nansum(JumpNb{1,2}(:,:));
x=nansum(JumpNb{1,1}(:,rangeT));
y=nansum(JumpNb{1,2}(:,rangeT));
[Pmw,h_mw,table_mw] = ranksum(x(~isnan(x)), y(~isnan(y)));
title([' ranksum (' num2str(30+rangeT(1)) ':'  num2str(30+rangeT(end))  ') p =' num2str(Pmw)])
if sav
    saveas(JumpBar, ['JumpBar_' num2str(30+rangeT(1)) '-'  num2str(30+rangeT(end)) '.fig'])
    saveFigure(JumpBar, ['JumpBar_' num2str(30+rangeT(1)) '-'  num2str(30+rangeT(end))], res)
end


%% bar plot on averages - AVERAGE
rangeT=[11:15];
%rangeT=[13:14];
%rangeT=[1:15];
JumpBar=figure('Position',[  1183          64         197         256]);
for g=1:2
    bar(g, nanmean(nanmean(JumpNb{1,g}(:,rangeT),2)),'k' ), hold on; 
    %errorbar(g, nanmean(nansum(JumpNb{1,g}(:,:),2)), nanstd(nansum(JumpNb{1,g}(:,:),2))./sqrt(size(nansum(JumpNb{1,g}(:,:),2),2)))   
    errorbar(g, nanmean(nanmean(JumpNb{1,g}(:,rangeT),2)), nanstd(nanmean(JumpNb{1,g}(:,rangeT),2))./sqrt(size(nanmean(JumpNb{1,g}(:,rangeT),2),2)),'Color',[0.5 0.5 0.5]) 
    ylabel('jump nb');
    
end
set(gca,'XTick', [1 2 ],'XTickLabel',groupname); 
% x=nansum(JumpNb{1,1}(:,:));
% y=nansum(JumpNb{1,2}(:,:));
x=nanmean(JumpNb{1,1}(:,rangeT));
y=nanmean(JumpNb{1,2}(:,rangeT));
[Pmw,h_mw,table_mw] = ranksum(x(~isnan(x)), y(~isnan(y)));
title([' ranksum (' num2str(30+rangeT(1)) ':'  num2str(30+rangeT(end))  ') p =' num2str(Pmw)])
if sav
    saveas(JumpBar, ['JumpBar_mean_' num2str(30+rangeT(1)) '-'  num2str(30+rangeT(end)) '.fig'])
    saveFigure(JumpBar, ['JumpBar_mean_' num2str(30+rangeT(1)) '-'  num2str(30+rangeT(end))], res)
end

%% plotSpread on averages
JumpSpread=figure('Position',[ 1183  25 300   400]);
rangeT=[11:15];
plotSpread({nansum(JumpNb{1,1}(:,rangeT),2); nansum(JumpNb{1,2}(:,rangeT),2)},'distributionColors',{[0.5 0.5 0.5]; [0 0 0]},'showMM',3);
ylabel('jump nb');
set(gca,'XTick', [1 2 ],'XTickLabel',groupname); 
title([' ranksum (' num2str(30+rangeT(1)) ':'  num2str(30+rangeT(end))  ') p =' num2str(Pmw)])

if sav
    saveas(JumpSpread, ['JumpSpread.fig'])
    saveFigure(JumpSpread, ['JumpSpread'], res)
end


% for i=1:length(list)
%      if list(i).isdir==1&list(i).name(1)~='.' &list(i).name(1)=='M'  % if the folder is indeed a mouse name folder
%         %cd([res '/' list(i).name(1)])
%         cd([ res '/' list(i).name])
%         load('Behavior.mat');
%         subplot(2,10,i)
%         %plot(Range(Movtsd,'s'),Data(Movtsd),'k')
%         X=PosMat(:,2);
%         Y=PosMat(:,3);
%         plot(X,Y)
%         d=sqrt(diff(X).*diff(X)+diff(Y).*diff(Y));
%         Dist=[Dist;nansum(d)];
%         title([ list(i).name '  '  sprintf('%.0f',nansum(d)) 'cm'])
%         
%         a=a+1;
% 
%      end
%      cd(res)
% end

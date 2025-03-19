% PlotHabDistanceAndMovt
clear all
cd('/media/DataMOBsRAID/ProjetAversion/PAIN/manip22souris_sham-obx')
res=pwd;
list=dir(res);

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

Dist=nan(2, max(length(shammice), length(obxmice)));
Movt=nan(2, max(length(shammice), length(obxmice)));
RearTotal=nan(2, max(length(shammice), length(obxmice)));
JumpTotal=nan(2, max(length(shammice), length(obxmice)));
LickTotal=nan(2, max(length(shammice), length(obxmice)));
RampeSize=15;

final_time=900;
TimeStamp=[0:final_time/RampeSize:final_time-(final_time/RampeSize)];
Temperature=[30:(45-30)/RampeSize:45-(45-30)/RampeSize];

expgroup={shammice,obxmice};
groupname={'sham','bulb'};
for  g=1:2
    group=expgroup{g};
    %     groupFig=figure('Position', [503  101  1327  834]);%503 496 3147  439
    
    for mousenb=1:length(group)
        if indivfig
            indivFig{g,mousenb}=figure;
        end
        %% rearing, licking, jump
        cd([ RearingFolder '/FEAR-Mouse-' num2str(group{mousenb}) rearingsuffix ]) ;
        
        load('Behavior.mat');
        
        RearEp=thresholdIntervals(Movtsd,rearTh,'Direction','Below', 'b');
        AutoRearMatrix=Start(RearEp)'*1E-4;
        RearTotal(g,mousenb)=length(Start(RearEp));
        JumpTotal(g,mousenb)=length(JumpMatrix);
        LickTotal(g,mousenb)=length(LickMatrix);
        
        for i=1:RampeSize
            %final_time=floor(max(Range(Movtsd, 's')));
            interval_deb=(i-1)/RampeSize*final_time;
            interval_fin=(i)/RampeSize*final_time;
            AutoRearNb{g}(mousenb,i)=sum(AutoRearMatrix>interval_deb & AutoRearMatrix<interval_fin);
            RearNb{g}(mousenb,i)=sum(RearMatrix>interval_deb & RearMatrix<interval_fin);
            LickNb{g}(mousenb,i)=sum(LickMatrix>interval_deb & LickMatrix<interval_fin);
            JumpNb{g}(mousenb,i)=sum(JumpMatrix>interval_deb & JumpMatrix<interval_fin);
        end
        
        %end
        cd(res)
    end
end

Cols1=[0,146,146;189,109,255]/263;
figure
subplot(1,3,[1:2])
[hl,hp]=boundedline(Temperature,nanmean(JumpNb{1}),[stdError(JumpNb{1});stdError(JumpNb{1})]','alpha');
set(hl,'Color',Cols1(1,:)*0.7,'linewidth',2)
set(hp,'FaceColor',Cols1(1,:))
hold on
[hl,hp]=boundedline(Temperature,nanmean(JumpNb{2}),[stdError(JumpNb{2});stdError(JumpNb{2})]','alpha');
set(hl,'Color',Cols1(2,:)*0.7,'linewidth',2)
set(hp,'FaceColor',Cols1(2,:))
xlabel('temperature (°)'), ylabel('number of jumps')
subplot(1,3,3)
for k=1:11
    temp=find(JumpNb{1}(k,:)>0,1,'first');
    if isempty(temp),temp=length(JumpNb{1}(k,:)); end
    ValCtrl(k)=Temperature(temp);
    %     ValCtrl(k)=sum(JumpNb{1}(k,:));
    temp=find(JumpNb{2}(k,:)>0,1,'first');
    if isempty(temp),temp=length(JumpNb{2}(k,:)); end
    ValOBX(k)=Temperature(temp);
    %         ValOBX(k)=sum(JumpNb{2}(k,:));
    
end
line([0.7 1.3],[1 1]*nanmean(ValCtrl),'color','k','linewidth',2), hold on
line([1.7 2.3],[1 1]*nanmean(ValOBX),'color','k','linewidth',2)
plotSpread({ValCtrl,ValOBX},'distributionColors',[Cols1(1,:);Cols1(2,:)]), hold on
[p,h]=ranksum(ValCtrl,ValOBX);
H=sigstar({[1,2]},p);set(H(1),'Color','w');set(H(2),'FontSize',14)
set(gca,'XTickLabel',{'Ctrl','OBX'})
ylabel('Temp to first jump')
xlim([0.5 2.5])

CSPLUS=[408 478 628 689 789 862 927 1007 1117 1178 1256 1320];
CSEpoch=intervalSet(CSPLUS*1e4,CSPLUS*1e4+30*1e4);

Dir=PathForExperimentFEAR('FearCBNov15');
Dir=RestrictPathForExperiment(Dir,'Session','EXT-24h');
for mm=1:length(Dir.path)
    cd(Dir.path{mm})
    load('Behavior.mat')
    FzPerc(mm,1)=100*length(Range(Restrict(Movtsd,and(FreezeEpoch,CSEpoch))))./length(Range(Restrict(Movtsd,CSEpoch)));
    MouseNum(mm)=eval(Dir.name{mm}(end-2:end));
end


% Correlation
JumpThreshAll=[ValOBX,ValCtrl];
figure
scatter(JumpThreshAll(1:11),FzPerc(1:11),50,[0 0.7 0.7],'o','filled'), hold on
scatter(JumpThreshAll(12:end),FzPerc(12:end),50,[0.6 0.4 0.8],'s','filled'), hold on
[r1,p1]=corr(JumpThreshAll(1:11)',FzPerc(1:11),'type','Spearman');
[r1,p1]=corr(JumpThreshAll(12:end)',FzPerc(12:end),'type','Spearman');
[r1,p1]=corr(JumpThreshAll',FzPerc,'type','Spearman');

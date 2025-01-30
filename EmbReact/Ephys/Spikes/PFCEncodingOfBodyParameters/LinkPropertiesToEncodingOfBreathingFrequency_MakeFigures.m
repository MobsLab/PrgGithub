%% Get All info about units
clear all
load('/media/DataMOBsRAIDN/ProjectEmbReact/Figures/SpikeAnalysis/PFCNeurons_UMazeSpatialFiring/Firing_Hab_NewRandomisation.mat')

cd /media/DataMOBsRAIDN/ProjectEmbReact/Figures/SpikeAnalysis/
load('PFCUnitFiringOnOBFrequency.mat')
load('PFCUnitsResponseToOBPhaseTwoFZ.mat')
SaveFigsTo = '/media/DataMOBsRAIDN/ProjectEmbReact/Figures/SpikeAnalysis/PFCOnOBFrequency/'
MiceNumber=[490,507,508,509,510,512,514];
FreqLims=[2.5:0.15:6];

% Correlation with OB frequency
GoodNeur = [];
PNeur = [];
RNeur = [];
% Modulation index by OB phase
KappaShock = [];
KappaSafe = [];
pShock = [];
pSafe = [];
MuShock = [];
MuSafe = [];

AllSpk=[];

for mouse_num=1:length(MiceNumber)
        AllSpk =[AllSpk;(MeanSpk{mouse_num}(find(IsPFCNeuron{mouse_num}),:))];

    for sp=1:length(RSpk{mouse_num})
        if IsPFCNeuron{mouse_num}(sp)==1
            
            if RSpk{mouse_num}(sp)>prctile(RSpk_btstrp{mouse_num}(sp,:),97.5)
                GoodNeur = [GoodNeur,1];
            elseif RSpk{mouse_num}(sp)<prctile(RSpk_btstrp{mouse_num}(sp,:),2.5);
                GoodNeur = [GoodNeur,-1];
            else
                GoodNeur = [GoodNeur,0];
            end
            PNeur = [PNeur,PSpk{mouse_num}(sp)];
            RNeur = [RNeur,RSpk{mouse_num}(sp)];
            
            
            KappaSafe = [KappaSafe,Kappa{mouse_num}.Safe(sp)];
            KappaShock = [KappaShock,Kappa{mouse_num}.Shock(sp)];
            pShock = [pShock,pval{mouse_num}.Shock(sp)];
            pSafe = [pSafe,pval{mouse_num}.Safe(sp)];
            MuShock = [MuShock,mu{mouse_num}.Shock(sp)];
            MuSafe = [MuSafe,mu{mouse_num}.Safe(sp)];
            
            
        end
    end
end

% Compare Kappa on both sides
A = {KappaShock(pShock<0.05 | pSafe<0.05),KappaSafe(pShock<0.05 | pSafe<0.05)};
Cols = {UMazeColors('Shock'),UMazeColors('Safe')}
MakeSpreadAndBoxPlot_SB(A,Cols,[1,2])
[p,h,stats] = signrank(A{1}, A{2})
set(gca,'FontSize',15,'linewidth',2,'XTick',[1:2],'XTickLabel',{'Shock','Safe'})
ylabel('Kappa')
sigstar_DB({[1,2]},p)

figure
clf
subplot(3,3,[2,3,5,6])
hold on
line([0 4*pi],[0 4*pi],'color',[0.8 0.8 0.8],'linestyle','--','linewidth',4)
line([0 2*pi],[2*pi 4*pi],'color',[0.8 0.8 0.8],'linestyle','--','linewidth',4)
line([2*pi 4*pi],[0 2*pi],'color',[0.8 0.8 0.8],'linestyle','--','linewidth',4)
plot([MuShock(pShock<0.05 | pSafe<0.05),MuShock(pShock<0.05 | pSafe<0.05)+2*pi,MuShock(pShock<0.05 | pSafe<0.05)+2*pi,MuShock(pShock<0.05 | pSafe<0.05)],...
    [MuSafe(pShock<0.05 | pSafe<0.05),MuSafe(pShock<0.05 | pSafe<0.05)+2*pi,MuSafe(pShock<0.05 | pSafe<0.05),MuSafe(pShock<0.05 | pSafe<0.05)+2*pi],'k.','MarkerSize',10)
xlim([0 4*pi])
ylim([0 4*pi])
set(gca,'FontSize',15,'linewidth',2,'YTick',[0:2*pi:4*pi],'YTickLabel',{'0','2pi','4pi'},'XTickLabel',{'0','2pi','4pi'})
box off
subplot(3,3,[1,4])
[Y,X] = hist(MuSafe(pShock<0.05 | pSafe<0.05),20);
stairs([Y,Y],[X,X+2*pi],'linewidth',3,'color',UMazeColors('safe'))
ylim([0 4*pi])
set(gca,'FontSize',15,'linewidth',2,'YTick',[0:2*pi:4*pi],'YTickLabel',{'0','2pi','4pi'})
box off
ylabel('Phase - safe')
xlabel('Cell count')
xlim([0 20])
subplot(3,3,[8,9])
[Y,X] = hist(MuShock(pShock<0.05 | pSafe<0.05),20);
stairs([X,X+2*pi],[Y,Y],'linewidth',3,'color',UMazeColors('shock'))
xlim([0 4*pi])
set(gca,'FontSize',15,'linewidth',2,'XTick',[0:2*pi:4*pi],'XTickLabel',{'0','2pi','4pi'})
box off
xlabel('Phase - shock')
ylabel('Cell count')
ylim([0 20])

[mu_Safe, Kappa_Safe, pval_Safe, Rmean_Safe, delta, sigma,confDw,confUp] = CircularMean(MuSafe(pShock<0.05 | pSafe<0.05));
[mu_Shock, Kappa_Shock, pval_Shock, Rmean, delta, sigma,confDw,confUp] = CircularMean(MuShock(pShock<0.05 | pSafe<0.05));
[pval, f] = circ_ktest(MuSafe(pShock<0.05 | pSafe<0.05), (MuShock(pShock<0.05 | pSafe<0.05)));


figure
subplot(121)
Del = find(isnan(pSafe) | isnan(pShock));
pSafe(Del) = [];
pShock(Del) = [];
pie([nanmean(pShock<0.05 & pSafe<0.05),nanmean(pShock>=0.05 & pSafe<0.05),nanmean(pShock>=0.05 & pSafe>=0.05),nanmean(pShock<0.05 & pSafe>=0.05)])
colormap([(UMazeColors('shock')+UMazeColors('safe'))/2;UMazeColors('safe');[1 1 1];UMazeColors('shock')])
 [h,p, chi2stat,df] = prop_test([nansum(pShock<0.05),nansum(pSafe<0.05)] , [317 317],1)


freezeColors(gca)
subplot(122)
pie([nanmean(pSafe<0.05),1-nanmean(pSafe<0.05)])
colormap([UMazeColors('safe');[1 1 1]])


 [h,p, chi2stat,df] = prop_test([nansum(pShock<0.05),nansum(pSafe<0.05)] , [317 317],1)
 
figure
nhist({MuSafe(pShock<0.05 | pSafe<0.05),MuShock(pShock<0.05 | pSafe<0.05)},'binfactor',4,'samebins','noerror')

% modulation index
cd /media/DataMOBsRAIDN/ProjectEmbReact/Figures/SpikeAnalysis/PFCNeurons_UMazeSpatialFiring
SessNames={'Habituation','TestPre', 'UMazeCond','TestPost','Extinction'};
load('DataForeSpatialLinearizedSpiking.mat')
NumLims = 40; %Number of spatial bins
x = [2:NumLims-1];

MITypes = {'Hab','FzCond','RunCond','Ext'};
for type = 1 : length(MITypes)
    load(['Firing_',MITypes{type},'_NewRandomisation.mat'])
    
    FR.(MITypes{type}).Shock=[];
    FR.(MITypes{type}).Safe=[];
    
    Duration.(MITypes{type}).Shock=[];
    Duration.(MITypes{type}).Safe=[];
    
    MouseNum.(MITypes{type})=[];
    
    IsSig.(MITypes{type})=[];
    
    FLD = fieldnames(EpochFR{1}(1));
    
    for mouse_num=1:7
        for sp=1:length(EpochFR{mouse_num})
            if IsPFCNeuron{mouse_num}(sp)==1
                
                FR.(MITypes{type}).Shock = [FR.(MITypes{type}).Shock , EpochFR{mouse_num}(sp).(FLD{1}).Shock.real];
                FR.(MITypes{type}).Safe = [FR.(MITypes{type}).Safe , EpochFR{mouse_num}(sp).(FLD{1}).NoShock.real];
                
                Duration.(MITypes{type}).Shock = [Duration.(MITypes{type}).Shock , EpochDur.(FLD{1}){mouse_num}(1)];
                Duration.(MITypes{type}).Safe = [Duration.(MITypes{type}).Safe , EpochDur.(FLD{1}){mouse_num}(2)];
                
                MouseNum.(MITypes{type}) = [MouseNum.(MITypes{type}) , mouse_num];
                
                IsSig.(MITypes{type})=[IsSig.(MITypes{type}) , EpochFR{mouse_num}(sp).(FLD{1}).Shock_NoShock.IsSig];
                
                
            end
        end
    end
    
    MI.(MITypes{type})=(FR.(MITypes{type}).Shock-FR.(MITypes{type}).Safe)./(FR.(MITypes{type}).Shock+FR.(MITypes{type}).Safe);
    
end

%% ripple response
cd /media/DataMOBsRAIDN/ProjectEmbReact/Figures/SpikeAnalysis/RippleTriggeredActivity
load('RippleTriggeredFiring2.mat')
RippleSession = {'UMazeCond','SleepPreUMaze','SleepPostUMaze'};
for ss=1:3
    AllRip.(RippleSession{ss})=[];
    for mouse_num=1:7
        if not(size(RippleResponse_Units.(RippleSession{ss}){mouse_num},1)==1)
            for sp=1:length(EpochFR{mouse_num})
                if IsPFCNeuron{mouse_num}(sp)==1
                    AllRip.(RippleSession{ss})=[AllRip.(RippleSession{ss});RippleResponse_Units.(RippleSession{ss}){mouse_num}(sp,:)/0.01];
                end
            end
        else
                        for sp=1:length(EpochFR{mouse_num})
                            AllRip.(RippleSession{ss})=[AllRip.(RippleSession{ss});nan(1,size(RippleResponse_Units.UMazeCond{1},2))];
                        end
        end
    end
end



%% Link between modulation index and correlation
fig=figure;
subplot(141)
plot(RNeur,MI.Hab,'*')
hold on
plot(RNeur(abs(GoodNeur)>0),MI.Hab(abs(GoodNeur)>0),'*')
xlabel('CorrWiOBFreq'), ylabel('ShckvsSafe RUN MI Hab')
[R,P]=corrcoef(RNeur(not(isnan(MI.Hab))),MI.Hab(not(isnan(MI.Hab))))
R=floor(R*1000)/1000;
P=floor(P*1000)/1000;
title(['R=',num2str(R(1,2)),' P=', num2str(P(1,2))])

subplot(142)
plot(RNeur,MI.FzCond,'*')
hold on
plot(RNeur(abs(GoodNeur)>0),MI.FzCond(abs(GoodNeur)>0),'*')
xlabel('CorrWiOBFreq'), ylabel('ShckvsSafe FZ MI Cond')
[R,P]=corrcoef(RNeur(not(isnan(MI.FzCond))),MI.FzCond(not(isnan(MI.FzCond))))
R=floor(R*1000)/1000;
P=floor(P*1000)/1000;
title(['R=',num2str(R(1,2)),' P=', num2str(P(1,2))])

subplot(143)
plot(RNeur,MI.RunCond,'*')
hold on
plot(RNeur(abs(GoodNeur)>0),MI.RunCond(abs(GoodNeur)>0),'*')
xlabel('CorrWiOBFreq'), ylabel('ShckvsSafe RUN MI Ext')
[R,P]=corrcoef(RNeur(not(isnan(MI.RunCond))),MI.RunCond(not(isnan(MI.RunCond))));
R=floor(R*1000)/1000;
P=floor(P*1000)/1000;
title(['R=',num2str(R(1,2)),' P=', num2str(P(1,2))])

subplot(144)
plot(RNeur,MI.Ext,'*')
hold on
plot(RNeur(abs(GoodNeur)>0),MI.Ext(abs(GoodNeur)>0),'*')
xlabel('CorrWiOBFreq'), ylabel('ShckvsSafe RUN MI Ext')
[R,P]=corrcoef(RNeur(not(isnan(MI.Ext))),MI.Ext(not(isnan(MI.Ext))));
R=floor(R*1000)/1000;
P=floor(P*1000)/1000;
title(['R=',num2str(R(1,2)),' P=', num2str(P(1,2))])
fig.Position = [2094 315 1649 342];
saveas(fig.Number,[SaveFigsTo,'PFCNeuronsCorrOBFreqAndMI.fig'])
saveas(fig.Number,[SaveFigsTo,'PFCNeuronsCorrOBFreqAndMI.png'])

fig=figure;
A=(RNeur(find(abs(GoodNeur)>0)));
B=KappaSafe(find(abs(GoodNeur)>0))-KappaShock(find(abs(GoodNeur)>0));
histogram(A(B<0),[-0.4:0.02:0.4],'FaceColor','r')
hold on
histogram(A(B>0),[-0.4:0.02:0.4],'FaceColor','b')
box off
xlabel('CorrWiObFrequency')
legend('HighKappaShock','HighKappaSafe')
fig.Position =  [2265 81 853 605];
saveas(fig.Number,[SaveFigsTo,'distribOfCorrDependingOnKappaOnlySigCorr.fig'])
saveas(fig.Number,[SaveFigsTo,'distribOfCorrDependingOnKappaOnlySigCorr.png'])


fig=figure;
SigKap = find((pSafe<0.05 | pShock<0.05));
A=(RNeur(SigKap));
B=KappaSafe(SigKap)-KappaShock(SigKap);
histogram(A(B<0),[-0.4:0.02:0.4],'FaceColor','r')
hold on
histogram(A(B>0),[-0.4:0.02:0.4],'FaceColor','b')
xlabel('CorrWiObFrequency')
legend('HighKappaShock','HighKappaSafe')
saveas(fig.Number,[SaveFigsTo,'distribOfCorrDependingOnKappaOnlySigKappa.fig'])
saveas(fig.Number,[SaveFigsTo,'distribOfCorrDependingOnKappaOnlySigKappa.png'])

fig=figure;
SigKap = find((pSafe<0.05 | pShock<0.05)&abs(GoodNeur)>0);
A=(RNeur(SigKap));
B=KappaSafe(SigKap)-KappaShock(SigKap);
histogram(A(B<0),[-0.4:0.02:0.4],'FaceColor','r')
hold on
histogram(A(B>0),[-0.4:0.02:0.4],'FaceColor','b')
xlabel('CorrWiObFrequency')
legend('HighKappaShock','HighKappaSafe')
saveas(fig.Number,[SaveFigsTo,'distribOfCorrDependingOnKappaOnlySigKappa&Corr.fig'])
saveas(fig.Number,[SaveFigsTo,'distribOfCorrDependingOnKappaOnlySigKappa&Corr.png'])

fig=figure;
scatter(KappaSafe,KappaShock,20,(RNeur),'filled')
hold on
scatter(KappaSafe(SigKap),KappaShock(SigKap),40,(RNeur(SigKap)),'filled')
line([0 1],[0 1])
colormap redblue
clim([-0.2 0.2])
xlim([-0 0.6]), ylim([0 0.6]), axis square
xlabel('KappaSafe'),ylabel('KappaShock')
saveas(fig.Number,[SaveFigsTo,'CorrelationCorrandKappa.fig'])
saveas(fig.Number,[SaveFigsTo,'CorrelationCorrandKappa&Corr.png'])

%% Link with ripples

fig=figure;
colormap paruly
for ss=1:3
    subplot(3,3,ss)
    tempmat=sortrows([RNeur',nanzscore(AllRip.(RippleSession{ss})')']);
    
    tempmat(find(sum(isnan(tempmat'))),:)=[];
    imagesc(tpsUnitRipResp,1:size(AllRip,1),(tempmat(:,2:end)))
    hold on
    line([0 0],ylim,'color',[0 0 0])
    clim([-2 2])
    title(RippleSession{ss})
    xlabel('time to rip (s)')
    xlim([-1 1])
    
    subplot(3,3,ss+3)
    plot(tpsUnitRipResp,runmean(nanmean(nanzscore(AllRip.(RippleSession{ss})(find(GoodNeur<0),:)')'),3),'r'), hold on
    plot(tpsUnitRipResp,runmean(nanmean(nanzscore(AllRip.(RippleSession{ss})(find(GoodNeur<0),:)')'),3),'b'), hold on
    shadedErrorBar(tpsUnitRipResp,runmean(nanmean(nanzscore(AllRip.(RippleSession{ss})(find(GoodNeur<0),:)')'),3),[runmean(stdError(nanzscore(AllRip.(RippleSession{ss})(find(GoodNeur<0),:)')'),3);runmean(stdError(nanzscore(AllRip.(RippleSession{ss})(find(GoodNeur<0),:)')'),3)],'b')
    shadedErrorBar(tpsUnitRipResp,runmean(nanmean(nanzscore(AllRip.(RippleSession{ss})(find(GoodNeur>0),:)')'),3),[runmean(stdError(nanzscore(AllRip.(RippleSession{ss})(find(GoodNeur>0),:)')'),3);runmean(stdError(nanzscore(AllRip.(RippleSession{ss})(find(GoodNeur>0),:)')'),3)],'r')
    xlim([-1 1])
    legend('PosCorr','NegCorr','Location','NorthWest')
    ylim([-0.7 2.5])
    xlabel('time to rip (s)')
        line([0 0],ylim,'color',[0.6 0.6 0.6])


    subplot(3,6,(ss-1)*2+13)
    shadedErrorBar(tpsUnitRipResp,runmean(nanmean((AllRip.(RippleSession{ss})(find(GoodNeur<0),:)')'),3),[runmean(stdError((AllRip.(RippleSession{ss})(find(GoodNeur<0),:)')'),3);runmean(stdError((AllRip.(RippleSession{ss})(find(GoodNeur<0),:)')'),3)],'b')
    xlim([-1 1])
    line([0 0],ylim,'color',[0.6 0.6 0.6])
    xlabel('time to rip (s)')
    

    subplot(3,6,(ss-1)*2+14)
    shadedErrorBar(tpsUnitRipResp,runmean(nanmean((AllRip.(RippleSession{ss})(find(GoodNeur>0),:)')'),3),[runmean(stdError((AllRip.(RippleSession{ss})(find(GoodNeur>0),:)')'),3);runmean(stdError((AllRip.(RippleSession{ss})(find(GoodNeur>0),:)')'),3)],'r')
    xlim([-1 1])
    line([0 0],ylim,'color',[0.6 0.6 0.6])
    xlabel('time to rip (s)')
    

end
fig.Position = [2197 -2 1421 976];
saveas(fig.Number,[SaveFigsTo,'LinkCorrelationAndRipples.fig'])
saveas(fig.Number,[SaveFigsTo,'LinkCorrelationAndRipples&Corr.png'])

%% Link overall firing rates

fig=figure;
hold on
subplot(421)
plotSpread({log(FR.Hab.Shock((GoodNeur)>0)),log(FR.Hab.Shock((GoodNeur)<0)),log(FR.Hab.Shock((GoodNeur)==0))},'showMM',2)
line(xlim,[0 0],'color',[0.6 0.6 0.6]),set(gca,'XTick',[1:3],'XTickLabel',{'Pos','Neg','Null'})
ylabel('Hab')
title('Shock')
subplot(422)
plotSpread({log(FR.Hab.Safe((GoodNeur)>0)),log(FR.Hab.Safe((GoodNeur)<0)),log(FR.Hab.Safe((GoodNeur)==0))},'showMM',2)
line(xlim,[0 0],'color',[0.6 0.6 0.6]),set(gca,'XTick',[1:3],'XTickLabel',{'Pos','Neg','Null'})
title('Safe')

subplot(423)
plotSpread({log(FR.FzCond.Shock((GoodNeur)>0)),log(FR.FzCond.Shock((GoodNeur)<0)),log(FR.FzCond.Shock((GoodNeur)==0))},'showMM',2)
line(xlim,[0 0],'color',[0.6 0.6 0.6]),set(gca,'XTick',[1:3],'XTickLabel',{'Pos','Neg','Null'})
ylabel('FzCond')
subplot(424)
plotSpread({log(FR.FzCond.Safe((GoodNeur)>0)),log(FR.FzCond.Safe((GoodNeur)<0)),log(FR.FzCond.Safe((GoodNeur)==0))},'showMM',2)
line(xlim,[0 0],'color',[0.6 0.6 0.6]),set(gca,'XTick',[1:3],'XTickLabel',{'Pos','Neg','Null'})

subplot(425)
plotSpread({log(FR.RunCond.Shock((GoodNeur)>0)),log(FR.RunCond.Shock((GoodNeur)<0)),log(FR.RunCond.Shock((GoodNeur)==0))},'showMM',2)
line(xlim,[0 0],'color',[0.6 0.6 0.6]),set(gca,'XTick',[1:3],'XTickLabel',{'Pos','Neg','Null'})
ylabel('RunCond')
subplot(426)
plotSpread({log(FR.RunCond.Safe((GoodNeur)>0)),log(FR.RunCond.Safe((GoodNeur)<0)),log(FR.RunCond.Safe((GoodNeur)==0))},'showMM',2)
line(xlim,[0 0],'color',[0.6 0.6 0.6]),set(gca,'XTick',[1:3],'XTickLabel',{'Pos','Neg','Null'})

subplot(427)
plotSpread({log(FR.Ext.Shock((GoodNeur)>0)),log(FR.Ext.Shock((GoodNeur)<0)),log(FR.Ext.Shock((GoodNeur)==0))},'showMM',2)
line(xlim,[0 0],'color',[0.6 0.6 0.6]),set(gca,'XTick',[1:3],'XTickLabel',{'Pos','Neg','Null'})
ylabel('Ext')
subplot(428)
plotSpread({log(FR.Ext.Safe((GoodNeur)>0)),log(FR.Ext.Safe((GoodNeur)<0)),log(FR.Ext.Safe((GoodNeur)==0))},'showMM',2)
line(xlim,[0 0],'color',[0.6 0.6 0.6]),set(gca,'XTick',[1:3],'XTickLabel',{'Pos','Neg','Null'})
fig.Position = [2280 20 1188 939];
saveas(fig.Number,[SaveFigsTo,'LinkCorrelationAndFiringRate.fig'])
saveas(fig.Number,[SaveFigsTo,'LinkCorrelationAndFiringRate&Corr.png'])

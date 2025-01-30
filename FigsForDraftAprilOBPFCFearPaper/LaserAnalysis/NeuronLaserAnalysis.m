% Calculate spectra,coherence and Granger
clear all
obx=0;
FreqBand=[3 6];
plo=0;
% Get data
OBXEphys=[230,249,250,291,297,298];
CtrlEphys=[242,248,244,243,253,254,258,259,299,394,395,402,403,450,451];
close all
[params,movingwin,suffix]=SpectrumParametersML('low');
rmpath('/home/vador/Dropbox/Kteam/PrgMatlab/Fra/UtilsStats')


Dir.path={
    '/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse458/20161117';
    '/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse459/20161123';
    '/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse465/20170126';
    '/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse467/20170202';
    };

numNeurons=[];

n=1;
AllCrossCorr=[];
AllMod=[];
Allp=[];
AllSp=[];
% 
% for mm=2:length(Dir.path)
%     Dir.path{mm}
%     cd(Dir.path{mm})
%     
%     clear chH chB chP
%     load('StateEpoch.mat','SWSEpoch')
%     %% get the n° of the neurons of PFCx
%     numtt=[]; % nb tetrodes ou montrodes du PFCx
%     if exist('SpikeData.mat')>0
%         
%         load('StimInfo.mat')
%         fq_list=unique(StimInfo.Freq);
%         for fq=1:length(fq_list)
%             ind_OI{fq}=find(StimInfo.Freq==fq_list(fq));
%         end
%         int_laser=intervalSet(StimInfo.StartTime*1E4, StimInfo.StopTime*1E4);
%         
%         load('LFPData/DigInfo4.mat')
% 
%         clear S
%         load SpikeData.mat
%         removMUA=1;res=pwd;
%         [S,NumNeurons,numtt,TT]=GetSpikesFromStructure('PFCx',S,res,removMUA);
%         
%         load('ChannelsToAnalyse/Bulb_deep.mat')
%         clear LFP
%         load(['LFPData/LFP',num2str(channel),'.mat'])
%         
%         for fq=1:length(fq_list);
%             StimEp=subset(int_laser,ind_OI{fq});
%             FilLFP=FilterLFP(Restrict(LFP,intervalSet(Start(StimEp)-5*1e4,Stop(StimEp)+5*1e4)),[fq_list(fq)-0.5 fq_list(fq)+0.5],1024);
%             StimEp=and(SWSEpoch,StimEp);
%             for i=1:length(NumNeurons)
%                 try
%                 [ph.OB{i,fq},mu.OB(i,fq), Kappa.OB(i,fq), pval.OB(i,fq),B,~]=ModulationThetaCorrection(S{NumNeurons(i)},FilLFP,StimEp,30);
%                 [Y,X]=hist(Data(ph.OB{i,fq}{1}),B);Y=Y/sum(Y);
%                 [fitresult, gof] = FitVonMises(X, Y);
%                 Err.OB(i,fq)=gof;
%                 FitRes.OB{i,fq}=fitresult;
%                 [C,phi,S12,S1,S2,t,f{i},zerosp,confC,phistd]=cohgramcpt(Data(Restrict(LFP,StimEp)),Range(S{NumNeurons(i)},'s'),movingwin,params);
%                 MeanC.OB{i,fq}=nanmean(C);
%                 close all
%                 catch
%                     ph.OB{i,fq}=NaN;
%                     mu.OB(i,fq)=NaN;
%                     Kappa.OB(i,fq)=NaN;
%                     pval.OB(i,fq)=NaN;
%                     Err.OB(i,fq).sse=NaN;
%                     MeanC.OB{i,fq}=NaN;
%                 end
%                 [ph.Laser{i,fq}] = ModulationSquaredSignal(Restrict(DigTSD,StimEp),Restrict(S{NumNeurons(i)},StimEp), 1,0);
%                 try,[mu.Laser(i,fq), Kappa.Laser(i,fq), pval.Laser(i,fq)] =JustPoltMod(ph.Laser{i,fq},25);
%                 catch
%                     mu.Laser(i,fq)=NaN;
%                     Kappa.Laser(i,fq)=NaN; pval.Laser(i,fq)=NaN;
%                 end
%                 FR{i,fq}=length(Range(Restrict(S{NumNeurons(i)},StimEp)))./sum(Stop(StimEp,'s')-Start(StimEp,'s'));
%             end
%         end
%     end
%     delete('NeuronRespLaserOB.m')
%     save('NeuronRespLaserOB.mat','FR','MeanC','ph','mu','Kappa','pval','Err','FitRes')
%     clear('FR','MeanC','ph','mu','Kappa','pval','Err','FitRes')
% 
% end

close all
AllKappa.OB=[];
AllKappa.Laser=[];
Allpval.OB=[];
Allpval.Laser=[];
AllFr=[];
Allmu.Laser=[];
Allmu.OB=[];
AllErr.OB=[];
for f=1:8
AllCoh.OB{f}=[];
end

for mm=1:length(Dir.path)
    cd(Dir.path{mm})
    
    load('NeuronRespLaserOB.mat')
    AllKappa.OB=[AllKappa.OB;Kappa.OB];
    AllKappa.Laser=[AllKappa.Laser;Kappa.Laser];
    Allpval.OB=[Allpval.OB;pval.OB];
    Allpval.Laser=[Allpval.Laser;pval.Laser];
    AllFr=[AllFr;reshape([FR{:}],size(FR,1),size(FR,2))];
    Allmu.Laser=[Allmu.Laser;mu.Laser];
    Allmu.OB=[Allmu.OB;mu.OB];
    for i=1:size(Err.OB,1)
        for ii=1:size(Err.OB,2)
            if isempty(Err.OB(i,ii).rmse)
                Err.OB(i,ii).rsquare=NaN;
            end
        end
    end
    AllErr.OB=[AllErr.OB; reshape([Err.OB.rsquare],size(Err.OB,1),size(Err.OB,2))];
    for f=1:8
        for i=1:size(MeanC.OB,1)
        if isnan(MeanC.OB{i,f})
            MeanC.OB{i,f}=nan(1,261);
        end
        end
    
    AllCoh.OB{f}=[AllCoh.OB{f};reshape([MeanC.OB{:,f}],261,size(MeanC.OB,1))'];
    end
end


alphaval=500;
NeurSig4_10Freq_OB=find(and(Allpval.OB(:,3)'<alphaval, Allpval.OB(:,5)'<alphaval));
ModI{1}=(AllKappa.OB(NeurSig4_10Freq_OB,3)-AllKappa.OB(NeurSig4_10Freq_OB,5))./(AllKappa.OB(NeurSig4_10Freq_OB,3)+AllKappa.OB(NeurSig4_10Freq_OB,5));
NeurSig4_10Freq_Laser=find(and(Allpval.Laser(:,3)'<alphaval, Allpval.Laser(:,5)'<alphaval));
ModI{2}=(AllKappa.Laser(NeurSig4_10Freq_Laser,3)-AllKappa.Laser(NeurSig4_10Freq_Laser,5))./(AllKappa.Laser(NeurSig4_10Freq_Laser,3)+AllKappa.Laser(NeurSig4_10Freq_Laser,5));
figure
plotSpread(ModI,'distributionColors',[0.4 0.4 0.4],'xNames',{'OB','Laser'},'xValues',[1,2])
hold on
line(xlim,[0 0],'color','k')
line([0.6 1.4],[1 1]*nanmedian(ModI{1}),'color','k','linewidth',2)
line([1.6 2.4],[1 1]*nanmedian(ModI{2}),'color','k','linewidth',2)
[p(1),h,stats(1)]=signrank(ModI{1});
[p(2),h,stats(2)]=signrank(ModI{2});
for i=1:2
    if p(i)<0.001
        text(i-0.1,1,'***','FontSize',15)
    elseif p(i)<0.01
                text(i-0.1,1,'**','FontSize',15)
    elseif p(i)<0.05
                text(i,1,'*','FontSize',15)
    end
end
ylim([-1.2 1.2])
box off

%% Make bokplot versions
figure
X =ModI{1};
a=iosr.statistics.boxPlot(1,X,'boxColor',[0.9 0.9 0.9],'lineColor',[0.9 0.9 0.9],'medianColor','k','boxWidth',0.5,'showOutliers',false);
a.handles.upperWhiskers.Visible='off';a.handles.upperWhiskerTips.Visible='off';
a.handles.lowerWhiskers.Visible='off';a.handles.lowerWhiskerTips.Visible='off';
a.handles.medianLines.LineWidth = 5;

handlesplot=plotSpread(X,'distributionColors',[0.6,0.6,0.6]*0.2,'xValues',1,'spreadWidth',0.3), hold on;
set(handlesplot{1},'MarkerSize',22)
handlesplot=plotSpread(X,'distributionColors',[0.6,0.6,0.6],'xValues',1,'spreadWidth',0.3), hold on;
set(handlesplot{1},'MarkerSize',12)

line([0 2],[0 0],'linestyle','--','linewidth',1,'color',[0.6 0.6 0.6])
xlim([0.5 1.5])
ylim([-1.2 1.2])
set(gca,'FontSize',18,'XTick',[])
ylabel('MI - Kappa')
box off

figure
X =ModI{2};
a=iosr.statistics.boxPlot(1,X,'boxColor',[0.9 0.9 0.9],'lineColor',[0.9 0.9 0.9],'medianColor','k','boxWidth',0.5,'showOutliers',false);
a.handles.upperWhiskers.Visible='off';a.handles.upperWhiskerTips.Visible='off';
a.handles.lowerWhiskers.Visible='off';a.handles.lowerWhiskerTips.Visible='off';
a.handles.medianLines.LineWidth = 5;

handlesplot=plotSpread(X,'distributionColors',[0.6,0.6,0.6]*0.2,'xValues',1,'spreadWidth',0.3), hold on;
set(handlesplot{1},'MarkerSize',22)
handlesplot=plotSpread(X,'distributionColors',[0.6,0.6,0.6],'xValues',1,'spreadWidth',0.3), hold on;
set(handlesplot{1},'MarkerSize',12)

line([0 2],[0 0],'linestyle','--','linewidth',1,'color',[0.6 0.6 0.6])
xlim([0.5 1.5])
ylim([-1.2 1.2])
set(gca,'FontSize',18,'XTick',[])
ylabel('MI - Kappa')
box off


% pie chart
figure
alphaval=0.05;
cols=lines(8);
cols=cols([1,6,5,3,2],:);cols=[[0 0 0.5];cols;[0.8 0 0;0.5 0 0]];
A=[sum(Allpval.OB(:,3)<=alphaval&Allpval.OB(:,5)>alphaval),...
    sum(Allpval.OB(:,3)<=alphaval&Allpval.OB(:,5)<=alphaval),...
    sum(Allpval.OB(:,3)>alphaval&Allpval.OB(:,5)<=alphaval),...
    sum(Allpval.OB(:,3)>alphaval&Allpval.OB(:,5)>alphaval)];
subplot(211)
h=pie(A)
set(h(1), 'FaceColor', cols(3,:));
hh1 = hatchfill(h(3), 'single', -90, 10,cols(5,:));
hh1.LineWidth=3;
hh1.Color=cols(3,:);
set(h(5), 'FaceColor', cols(5,:));
set(h(7), 'FaceColor', 'w');
title('OB')
B=[sum(Allpval.Laser(:,3)<=alphaval&Allpval.Laser(:,5)>alphaval),...
    sum(Allpval.Laser(:,3)<=alphaval&Allpval.Laser(:,5)<=alphaval),...
    sum(Allpval.Laser(:,3)>alphaval&Allpval.Laser(:,5)<=alphaval),...
    sum(Allpval.Laser(:,3)>alphaval&Allpval.Laser(:,5)>alphaval)];
subplot(212)
h=pie(A)
set(h(1), 'FaceColor', cols(3,:));
hh1 = hatchfill(h(3), 'single', -90, 10,cols(5,:));
hh1.LineWidth=3;
hh1.Color=cols(3,:);
set(h(5), 'FaceColor', cols(5,:));
set(h(7), 'FaceColor', 'w');
title('Laser')
[h,p, chi2stat,df]=prop_test([sum(Allpval.Laser(:,3)<=alphaval),sum(Allpval.Laser(:,5)<=alphaval)],[length(Allpval.Laser(:,3)<=alphaval),length(Allpval.Laser(:,3)<=alphaval)],'true');

%% Get example neuron
% 
% figure
% for k=1:size(ph.OB,1)
%     subplot(211)
%     histogram([Data(ph.OB{k,3}{1});Data(ph.OB{k,3}{1})+2*pi],60,'Normalization','probability')
%     title(num2str(Kappa.OB(k,3)))
%                 ylim([0 0.03])
% subplot(212)
%     histogram([Data(ph.OB{k,5}{1});Data(ph.OB{k,5}{1})+2*pi],60,'Normalization','probability')
%         title(num2str(Kappa.OB(k,5)))
%         ylim([0 0.03])
%     pause
%     hold on
%     clf
% end

cd('/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse458/20161117')
load('NeuronRespLaserOB.mat')

% modif faite pour figure 03.04.2018
k=30
figure
subplot(211)
histogram([(ph.Laser{k,3});(ph.Laser{k,3})+2*pi],30,'Normalization','probability')
title(num2str(Kappa.Laser(k,3)))
% ylim([0 0.03])
subplot(212)
histogram([(ph.Laser{k,5});(ph.Laser{k,5})+2*pi],30,'Normalization','probability')
title(num2str(Kappa.Laser(k,5)))
% ylim([0 0.03])

k=30
figure
subplot(211)
histogram([(Data(ph.OB{k,3}{1}));(Data(ph.OB{k,3}{1}))+2*pi],30,'Normalization','probability')
title(num2str(Kappa.OB(k,3)))
% ylim([0 0.03])
subplot(212)
histogram([(Data(ph.OB{k,5}{1}));(Data(ph.OB{k,5}{1}))+2*pi],30,'Normalization','probability')
title(num2str(Kappa.OB(k,5)))
% ylim([0 0.03])

% Figreus not in paper

AlLFreq=[1,2,4,7,10,13,15,20];
NeurSigOneFreq=find(sum(Allpval.OB'<0.01));
figure
subplot(221)
errorbar([1:8],nanmean(AllKappa.OB(NeurSigOneFreq,:))',stdError(AllKappa.OB(NeurSigOneFreq,:)),'linewidth',2), hold on, set(gca,'XTick',[1:8],'XTickLabel',[1,2,4,7,10,13,15,20,])
subplot(222)
errorbar([1:8],nanmean(AllKappa.Laser(NeurSigOneFreq,:))',stdError(AllKappa.Laser(NeurSigOneFreq,:)),'linewidth',2), hold on, set(gca,'XTick',[1:8],'XTickLabel',[1,2,4,7,10,13,15,20,])
subplot(223)
bar(nansum(Allpval.OB(NeurSigOneFreq,:)<0.01)), hold on, set(gca,'XTick',[1:8],'XTickLabel',[1,2,4,7,10,13,15,20,])
subplot(224)
bar(nansum(Allpval.Laser(NeurSigOneFreq,:)<0.01)), hold on, set(gca,'XTick',[1:8],'XTickLabel',[1,2,4,7,10,13,15,20,])

figure
subplot(223)
errorbar([1:8],nanmean(AllErr.OB(NeurSigOneFreq,:))',stdError(AllErr.OB(NeurSigOneFreq,:)),'linewidth',2), hold on, set(gca,'XTick',[1:8],'XTickLabel',[1,2,4,7,10,13,15,20,])
subplot(224)
errorbar([1:8],nanmean(AllFr(NeurSigOneFreq,:))',stdError(AllFr(NeurSigOneFreq,:)),'linewidth',2), hold on, set(gca,'XTick',[1:8],'XTickLabel',[1,2,4,7,10,13,15,20,])



figure
frbin=[0:260]/13;
for f=1:8
    if f==1
        Lims=[1:find(frbin<AlLFreq(f)+1,1,'last')];
    else
        Lims=[find(frbin<AlLFreq(f)-1,1,'last'):find(frbin<AlLFreq(f)+1,1,'last')];
    end
    KeepCoh(f,:)=nanmean(zscore(AllCoh.OB{f}(NeurSigOneFreq,:)')');
    CohVal(f)=nanmean(KeepCoh(f,Lims));
end

figure
imagesc(zscore(KeepCoh'))


for f=1:8
subplot(2,8,f)
hist(Allmu.OB(:,f))
xlim([0 2*pi])
subplot(2,8,f+8)
hist(Allmu.Laser(:,f))
xlim([0 2*pi])
end

figure
for f=1:8
subplot(4,2,f)
hist(mod(Allmu.OB(NeurSigOneFreq,f)-Allmu.Laser(NeurSigOneFreq,f),2*pi),20)
xlim([0 2*pi])
end

for f=1:8
subplot(2,8,f)
hist(Allmu.OB(:,f)/(2*pi*AlLFreq(f)))
xlim([0 1])
subplot(2,8,f+8)
hist(Allmu.Laser(:,f)/(2*pi*AlLFreq(f)))
xlim([0 1])
end

NeurSig4_10Freq=find((Allpval.OB(:,3)'<alphaval | Allpval.OB(:,5)'<alphaval));
figure
plot(AllKappa.OB(NeurSig4_10Freq,3),AllKappa.OB(NeurSig4_10Freq,5),'k*')
line([0 1.2],[0 1.2],'color','k')
xlim([0 0.7]),ylim([0 0.7]),axis square
hold on
NeurSig4_10Freq=find((Allpval.Laser(:,3)'<alphaval | Allpval.Laser(:,5)'<alphaval));
plot(AllKappa.Laser(NeurSig4_10Freq,3),AllKappa.Laser(NeurSig4_10Freq,5),'r*')
line([0 1.2],[0 1.2],'color','k')
xlim([0 0.7]),ylim([0 0.7]), axis square
box off

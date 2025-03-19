clear all, close all

experiment= 'Fear-electrophy';
Dir=PathForExperimentFEAR(experiment);
%Dir = RestrictPathForExperiment(Dir,'nMice',[253 254]);
%nameSession=unique(Dir.Session);

% nameGroups=unique(Dir.group);
% nameGroups=[nameGroups(~strcmp(nameGroups,'CTRL')),nameGroups(strcmp(nameGroups,'CTRL'))];
nameGroups={'OBX', 'CTRL'};

Dir=RestrictPathForExperiment(Dir,'Group',{'OBX','CTRL'});
[B,IX] = sort(Dir.group);
Dir.path=Dir.path(IX);
Dir.name=Dir.name(IX);
Dir.manipe=Dir.manipe(IX);
Dir.group=B;
Dir.Session=Dir.Session(IX);

channelstoAnalyse={'dHPC_rip','PFCx_deep','Bulb_deep'}
cols=jet(9);
startvals=[1:0.5:20];
envals=[1:0.5:20]+2;
%clear RocVal
for m=2:length(Dir.group)
    try
        cd(Dir.path{m})
        load('behavResources.mat')
        load('StateEpoch.mat')
        clear Fr
        for ch=1:length(channelstoAnalyse)
            ch
            if exist(['ChannelsToAnalyse/' channelstoAnalyse{ch} '.mat'])>0
                load(['ChannelsToAnalyse/' channelstoAnalyse{ch} '.mat'],'channel');
                if not(isempty(channel))
                    load(['LFPData/LFP',num2str(channel),'.mat'])
                    for slidwin=1:length(startvals)
                        
                        FilDelta=FilterLFP(LFP,[startvals(slidwin) envals(slidwin)],1024);
                        HilDelta=hilbert(Data(FilDelta));
                        H=abs(HilDelta);
                        Htsd=tsd(Range(LFP),H);
                        TotEpoch=intervalSet(0,max(Range(LFP)))-NoiseEpoch-GndNoiseEpoch;
                        FreezeEpoch=FreezeEpoch-NoiseEpoch-GndNoiseEpoch-WeirdNoiseEpoch;
                        NoFreezeEpoch=TotEpoch-FreezeEpoch;
                        NoFreezeEpoch=NoFreezeEpoch-NoiseEpoch-GndNoiseEpoch-WeirdNoiseEpoch;
                        
                        % Freezing data
                        begin=Start(FreezeEpoch);
                        endin=Stop(FreezeEpoch);
                        Fr{ch,1}=zeros(1,1);
                        index=1;
                        for ff=1:length(begin)
                            dur=endin(ff)-begin(ff);
                            numbins=round(dur/(2*1E4));
                            epdur=(dur/1E4)/numbins;
                            for nn=1:numbins
                                startcounting=begin(ff)+(nn-1)*dur/numbins;
                                stopcounting=begin(ff)+nn*dur/numbins;
                                Fr{ch,1}(index,1)=mean(Data(Restrict(Htsd,intervalSet(startcounting,stopcounting))));
                                index=index+1;
                            end
                        end
                        
                        % No freezing data
                        begin=Start(NoFreezeEpoch);
                        endin=Stop(NoFreezeEpoch);
                        Fr{ch,2}=zeros(1,1);
                        index=1;
                        for ff=1:length(begin)
                            dur=endin(ff)-begin(ff);
                            numbins=round(dur/(2*1E4));
                            epdur=(dur/1E4)/numbins;
                            for nn=1:numbins
                                startcounting=begin(ff)+(nn-1)*dur/numbins;
                                stopcounting=begin(ff)+nn*dur/numbins;
                                Fr{ch,2}(index,1)=mean(Data(Restrict(Htsd,intervalSet(startcounting,stopcounting))));
                                index=index+1;
                            end
                        end
                        
                        alpha=[];
                        beta=[];
                        minval=min([Fr{ch,2};Fr{ch,1}]);
                        maxval=max([Fr{ch,2};Fr{ch,1}]);
                        delval=(maxval-minval)/20;
                        for z=[min([Fr{ch,2};Fr{ch,1}])-delval:delval:max([Fr{ch,2};Fr{ch,1}])+delval]
                            alpha=[alpha,sum(Fr{ch,2}>z)/length(Fr{ch,2})];
                            beta=[beta,sum(Fr{ch,1}>z)/length(Fr{ch,1})];
                        end
                        %plot(alpha,beta,'color',cols(ch,:)), hold on
                        RocVal{m}(ch,slidwin)=sum(beta-alpha)/length(beta)+0.5;
                        clear Fr alpha beat Htsd
                        
                    end
                else
                    disp('bou')
                    RocVal{m}(ch,slidwin)=NaN;
                end
            end
        end
        % Do coherence
        disp('coherence')
        clear C
        if strcmp(Dir.group{m},'CTRL')
            if exist('CohgramcDataL') >0
                load(['ChannelsToAnalyse/' channelstoAnalyse{2} '.mat'],'channel');
                channelP=channel;
                load(['ChannelsToAnalyse/' channelstoAnalyse{3} '.mat'],'channel');
                channelB=channel;
                if not(isempty(channelB)) & not(isempty(channelP))
                    cd CohgramcDataL/
                    if exist(['Cohgram_' num2str(channelP) '_' num2str(channelB) '.mat'])>0
                        load(['Cohgram_' num2str(channelP) '_' num2str(channelB) '.mat'])
                    elseif exist(['Cohgram_' num2str(channelB) '_' num2str(channelP) '.mat'])>0
                        load(['Cohgram_' num2str(channelB) '_' num2str(channelP) '.mat'])
                    end
                    for slidwin=1:length(startvals)
                        fstr=find(f>startvals(slidwin),1,'first');
                        fstp=find(f<envals(slidwin),1,'last');
                        Ctsd=tsd(t*1e4,mean(C(:,fstr:fstp)')');
                        
                        % Freezing data
                        begin=Start(FreezeEpoch);
                        endin=Stop(FreezeEpoch);
                        Fr{ch,1}=zeros(1,1);
                        index=1;
                        for ff=1:length(begin)
                            dur=endin(ff)-begin(ff);
                            numbins=round(dur/(2*1E4));
                            epdur=(dur/1E4)/numbins;
                            for nn=1:numbins
                                startcounting=begin(ff)+(nn-1)*dur/numbins;
                                stopcounting=begin(ff)+nn*dur/numbins;
                                Fr{ch,1}(index,1)=mean(Data(Restrict(Ctsd,intervalSet(startcounting,stopcounting))));
                                index=index+1;
                            end
                        end
                        
                        % No freezing data
                        begin=Start(NoFreezeEpoch);
                        endin=Stop(NoFreezeEpoch);
                        Fr{ch,2}=zeros(1,1);
                        index=1;
                        for ff=1:length(begin)
                            dur=endin(ff)-begin(ff);
                            numbins=round(dur/(2*1E4));
                            epdur=(dur/1E4)/numbins;
                            for nn=1:numbins
                                startcounting=begin(ff)+(nn-1)*dur/numbins;
                                stopcounting=begin(ff)+nn*dur/numbins;
                                Fr{ch,2}(index,1)=mean(Data(Restrict(Ctsd,intervalSet(startcounting,stopcounting))));
                                index=index+1;
                            end
                        end
                        
                        alpha=[];
                        beta=[];
                        minval=min([Fr{ch,2};Fr{ch,1}]);
                        maxval=max([Fr{ch,2};Fr{ch,1}]);
                        delval=(maxval-minval)/20;
                        for z=[min([Fr{ch,2};Fr{ch,1}])-delval:delval:max([Fr{ch,2};Fr{ch,1}])+delval]
                            alpha=[alpha,sum(Fr{ch,2}>z)/length(Fr{ch,2})];
                            beta=[beta,sum(Fr{ch,1}>z)/length(Fr{ch,1})];
                        end
                        %plot(alpha,beta,'color',cols(ch,:)), hold on
                        RocValCoh{m}(slidwin)=sum(beta-alpha)/length(beta)+0.5;
                        clear Fr alpha beat Ctsd
                    end
                end
            end
        end
    end
end

%%%%%%%
close all, clear all
startvals=[1:0.5:20];
load('/home/vador/Bureau/RocValsFreezing17092015.mat','RocVal','RocValCoh')
% 11 excluded ---> too little freezing
BBXdat=[];
for m=[18:19,23:25]
BBXdat=[BBXdat;RocVal{m}(2,:)];
end
CTLdat=[];
for m=[2:10,12:17]
    try
CTLdat=[CTLdat;RocVal{m}(2,:)];
    end
end
CTLdatC=[];
for m=[2:10,12:17]
    try
CTLdatC=[CTLdatC;RocValCoh{m}];
    end
end
figure(1)
subplot(211)
hold on
g=shadedErrorBar(startvals+1,mean(CTLdat),[std(CTLdat);std(CTLdat)],'r' )
g=shadedErrorBar(startvals+1,mean(BBXdat),[std(BBXdat);std(BBXdat)],'b')
ylabel('ROC value')
xlim([0 20])
figure(2)
subplot(211)
bar([1:2],[mean([mean(BBXdat(:,3:9)')./mean(BBXdat(:,13:21)')]),mean([mean(CTLdat(:,3:9)')./mean(CTLdat(:,13:21)')])],'FaceColor',[0.6 0.6 0.6],'EdgeColor','w')
hold on
errorbar([1:2],[mean([mean(BBXdat(:,3:9)')./mean(BBXdat(:,13:21)')]),mean([mean(CTLdat(:,3:9)')./mean(CTLdat(:,13:21)')])],[stdError([mean(BBXdat(:,3:9)')./mean(BBXdat(:,13:21)')]),stdError([mean(CTLdat(:,3:9)')./mean(CTLdat(:,13:21)')])],'.k')
[h,p]=ttest2([mean(BBXdat(:,3:9)')./mean(BBXdat(:,13:21)')],[mean(CTLdat(:,3:9)')./mean(CTLdat(:,13:21)')])
xlim([0 3])
ylim([0 1.8])
ylabel('ROC value 3-6/8-12')
sigstar({[1,2]},p)
set(gca,'XTick',[1,2],'XTickLabel',{'BBX','CTRL'})

load('/home/vador/Bureau/SpectraFreezing17092015.mat')
fSp=f;
figure(1)
BBXSp=[];
for m=[18:19,23:25]
BBXSp=[BBXSp;fSp.*Spectr{m,2}];
end
CTLSp=[];
for m=[2:10,12:17]
    try
CTLSp=[CTLSp;fSp.*Spectr{m,2}];
    end
end
subplot(212)
hold on
g=shadedErrorBar(fSp,mean(CTLSp),[std(CTLSp);std(CTLSp)],'r' )
g=shadedErrorBar(fSp,mean(BBXSp),[std(BBXSp);std(BBXSp)],'b')
xlim([0 20])
ylabel('Power AU (denoised)')
figure(2)
subplot(212)
bar([1:2],[mean([mean(BBXSp(:,11:21)')./mean(BBXSp(:,27:40)')]),mean([mean(CTLSp(:,11:21)')./mean(CTLSp(:,27:40)')])],'FaceColor',[0.6 0.6 0.6],'EdgeColor','w')
hold on
errorbar([1:2],[mean([mean(BBXSp(:,11:21)')./mean(BBXSp(:,27:40)')]),mean([mean(CTLSp(:,11:21)')./mean(CTLSp(:,27:40)')])],[stdError([mean(BBXSp(:,11:21)')./mean(BBXSp(:,27:40)')]),stdError([mean(CTLSp(:,11:21)')./mean(CTLSp(:,27:40)')])],'.k')
ylabel('Power AU (denoised) 3-6/8-12')
[h,p]=ttest2([mean(BBXSp(:,11:21)')./mean(BBXSp(:,27:40)')],[mean(CTLSp(:,11:21)')./mean(CTLSp(:,27:40)')])
xlim([0 3])
ylim([0 4])
sigstar({[1,2]},p)
set(gca,'XTick',[1,2],'XTickLabel',{'BBX','CTRL'})

load('/home/vador/Bureau/CoherenceFreezing17092015.mat','Cspectr','Cspectr2','f')
fCo=f;
figure(3)
CTLCo=[];
for m=[2:10,12:17]
    try
CTLCo=[CTLCo;Cspectr{m,1}];
    end
end
subplot(211)
g=shadedErrorBar(fCo,nanmean(CTLCo),[nanstd(CTLCo);nanstd(CTLCo)],'r')
ylabel('Coherence')
subplot(212)
g=shadedErrorBar(startvals+1,mean(CTLdatC),[std(CTLdatC);std(CTLdatC)],'r')
xlim([0 20])
ylabel('ROC value on coherence')

% Is there more or less noise in peak

for k=1:size(BBXdat,1)
        PeakBBX(k)=startvals(find(BBXdat(k,:)==max(BBXdat(k,:))))+1;
end
for k=1:size(CTLdat,1)
        PeakCTL(k)=startvals(find(CTLdat(k,:)==max(CTLdat(k,:))))+1;
        PeakCTLSp(k)=f(find(CTLSp(k,:)==max(CTLSp(k,:))))+1;
end
for k=1:size(CTLdatC,1)
    PeakCTLC(k)=startvals(find(CTLdatC(k,:)==max(CTLdatC(k,:))))+1;
    PeakCTLCCo(k)=f(find(CTLCo(k,:)==max(CTLCo(k,:))))+1;
end



figure(5)
subplot(211)
CTLdat=[];
for m=[2:10,12:17]
    try
CTLdat=[CTLdat;RocVal{m}(1,:)];
    end
end
CTLdat=CTLdat([1,4:11],:);
plot(startvals+1,mean(CTLdat),'c','linewidth',3)
hold on
subplot(212)
bar(1,mean(mean(CTLdat(:,3:9))),'FaceColor','c','EdgeColor','w')
hold on
errorbar(1,mean(mean(CTLdat(:,3:9))),std(mean(CTLdat(:,3:9))),'.k')
subplot(211)
CTLdat=[];
for m=[2:10,12:17]
    try
CTLdat=[CTLdat;RocVal{m}(2,:)];
    end
end
plot(startvals+1,mean(CTLdat),'r','linewidth',3)
subplot(212)
bar(2,mean(mean(CTLdat(:,3:9))),'FaceColor','r','EdgeColor','w')
hold on
errorbar(2,mean(mean(CTLdat(:,3:9))),std(mean(CTLdat(:,3:9))),'.k')
subplot(211)
CTLdat=[];
for m=[2:10,12:17]
    try
CTLdat=[CTLdat;RocVal{m}(3,:)];
    end
end
plot(startvals+1,mean(CTLdat),'b','linewidth',3)
plot(startvals+1,0.5*ones(1,length(startvals)),'--k','linewidth',2)
subplot(212)
bar(3,mean(mean(CTLdat(:,3:9))),'FaceColor','b','EdgeColor','w')
hold on
errorbar(3,mean(mean(CTLdat(:,3:9))),std(mean(CTLdat(:,3:9))),'.k')
ylim([0.4 0.8])

figure(6)
% is the ROC correlated with power in delta band or theta band?
CTLSpHFNF=nan(11,164);
num=1;
for m=[2:10,12:17]
try
    CTLSpHFNF(num,:)=[(Spectr{m,1}-Spectr2{m,1})./sum(Spectr{m,1}+Spectr2{m,1})]';
end
num=num+1;
end

CTLSpPFNF=nan(11,164);
num=1;
for m=[2:10,12:17]
try
    CTLSpPFNF(num,:)=[(Spectr{m,2}-Spectr2{m,2})./sum(Spectr{m,2}+Spectr2{m,2})]';
end
num=num+1;
end

CTLSpBFNF=nan(11,164);
num=1;
for m=[2:10,12:17]
try
    CTLSpBFNF(num,:)=[(Spectr{m,3}-Spectr2{m,3})./sum(Spectr{m,3}+Spectr2{m,3})]';
end
num=num+1;
end

num=1;
CTLdatP=nan(11,39);
for m=[2:10,12:17]
    try
        CTLdatP(num,:)=RocVal{m}(2,:);
    end
    num=num+1;
end

num=1;
CTLdatH=nan(11,39);
for m=[2:10,12:17]
    try
        CTLdatH(num,:)=RocVal{m}(1,:);
    end
    num=num+1;
end

num=1;
CTLdatB=nan(11,39);
for m=[2:10,12:17]
    try
        CTLdatB(num,:)=RocVal{m}(3,:);
    end
    num=num+1;
end

DelPow=[];
ThetPow=[];
RocPerf=[];
DelPow=[mean(CTLSpPFNF(:,11:21)');mean(CTLSpHFNF(:,11:21)');mean(CTLSpBFNF(:,11:21)')];
ThetPow=[mean(CTLSpPFNF(:,27:40)');mean(CTLSpHFNF(:,27:40)');mean(CTLSpBFNF(:,27:40)')];
RocPerf=[mean(CTLdatP(:,3:9)');mean(CTLdatH(:,3:9)');mean(CTLdatB(:,3:9)')];

subplot(221)
plot(ThetPow(1,:),RocPerf(1,:),'c.'), hold on
plot(ThetPow(2,:),RocPerf(2,:),'r.')
plot(ThetPow(3,:),RocPerf(3,:),'b.')
xlabel('thetFr-ThetNoFR')
ylabel('RocPerf Del')
clear P
[R,P{1}]=corrcoef(ThetPow(1,not(isnan(ThetPow(1,:)))),RocPerf(1,not(isnan(ThetPow(1,:)))));
[R,P{2}]=corrcoef(ThetPow(2,not(isnan(ThetPow(2,:)))),RocPerf(2,not(isnan(ThetPow(2,:)))));
[R,P{3}]=corrcoef(ThetPow(3,not(isnan(ThetPow(3,:)))),RocPerf(3,not(isnan(ThetPow(3,:)))));
[r,m,b] = regression(ThetPow(1,:),RocPerf(1,:))
plot([min(ThetPow(1,:)):0.001:max(ThetPow(1,:))],[min(ThetPow(1,:)):0.001:max(ThetPow(1,:))]*m+b,'c')
ylim([0.3 0.8])

subplot(222)
plot(DelPow(1,:),RocPerf(1,:),'c.'), hold on
plot(DelPow(2,:),RocPerf(2,:),'r.')
plot(DelPow(3,:),RocPerf(3,:),'b.')
xlabel('DelFr-DelNoFr')
ylabel('RocPerf Del')
clear P
[R,P{1}]=corrcoef(DelPow(1,not(isnan(DelPow(1,:)))),RocPerf(1,not(isnan(DelPow(1,:)))));
[R,P{2}]=corrcoef(DelPow(2,not(isnan(DelPow(2,:)))),RocPerf(2,not(isnan(DelPow(2,:)))));
[R,P{3}]=corrcoef(DelPow(3,not(isnan(DelPow(3,:)))),RocPerf(3,not(isnan(DelPow(3,:)))));
[r,m,b] = regression(DelPow(1,:),RocPerf(1,:))
plot([min(DelPow(1,:)):0.001:max(DelPow(1,:))],[min(DelPow(1,:)):0.001:max(DelPow(1,:))]*m+b,'c')
[r,m,b] = regression(DelPow(2,:),RocPerf(2,:))
plot([min(DelPow(2,:)):0.001:max(DelPow(2,:))],[min(DelPow(2,:)):0.001:max(DelPow(2,:))]*m+b,'r')
[r,m,b] = regression(DelPow(3,:),RocPerf(3,:))
plot([min(DelPow(3,:)):0.001:max(DelPow(3,:))],[min(DelPow(3,:)):0.001:max(DelPow(3,:))]*m+b,'b')
ylim([0.3 0.8])

RocPerf=[1-mean(CTLdatP(:,13:21)');1-mean(CTLdatH(:,13:21)');1-mean(CTLdatB(:,13:21)')];
subplot(223)
plot(ThetPow(1,:),RocPerf(1,:),'c.'), hold on
plot(ThetPow(2,:),RocPerf(2,:),'r.')
plot(ThetPow(3,:),RocPerf(3,:),'b.')
xlabel('thetFr-ThetNoFR')
ylabel('RocPerf Thet')
clear P
[R,P{1}]=corrcoef(ThetPow(1,not(isnan(ThetPow(1,:)))),RocPerf(1,not(isnan(ThetPow(1,:)))));
[R,P{2}]=corrcoef(ThetPow(2,not(isnan(ThetPow(2,:)))),RocPerf(2,not(isnan(ThetPow(2,:)))));
[R,P{3}]=corrcoef(ThetPow(3,not(isnan(ThetPow(3,:)))),RocPerf(3,not(isnan(ThetPow(3,:)))));
[r,m,b] = regression(ThetPow(1,:),RocPerf(1,:))
plot([min(ThetPow(1,:)):0.001:max(ThetPow(1,:))],[min(ThetPow(1,:)):0.001:max(ThetPow(1,:))]*m+b,'c')
[r,m,b] = regression(ThetPow(2,:),RocPerf(2,:))
plot([min(ThetPow(2,:)):0.001:max(ThetPow(2,:))],[min(ThetPow(2,:)):0.001:max(ThetPow(2,:))]*m+b,'r')
[r,m,b] = regression(ThetPow(3,:),RocPerf(3,:))
plot([min(ThetPow(3,:)):0.001:max(ThetPow(3,:))],[min(ThetPow(3,:)):0.001:max(ThetPow(3,:))]*m+b,'b')
ylim([0.2 0.5])
subplot(224)
plot(DelPow(1,:),RocPerf(1,:),'c.'), hold on
plot(DelPow(2,:),RocPerf(2,:),'r.')
plot(DelPow(3,:),RocPerf(3,:),'b.')
xlabel('DelFr-DelNoFr')
ylabel('RocPerf Thet')
clear P
[R,P{1}]=corrcoef(DelPow(1,not(isnan(DelPow(1,:)))),RocPerf(1,not(isnan(DelPow(1,:)))));
[R,P{2}]=corrcoef(DelPow(2,not(isnan(DelPow(2,:)))),RocPerf(2,not(isnan(DelPow(2,:)))));
[R,P{3}]=corrcoef(DelPow(3,not(isnan(DelPow(3,:)))),RocPerf(3,not(isnan(DelPow(3,:)))));
[r,m,b] = regression(DelPow(1,:),RocPerf(1,:))
plot([min(DelPow(1,:)):0.001:max(DelPow(1,:))],[min(DelPow(1,:)):0.001:max(DelPow(1,:))]*m+b,'c')
ylim([0.3 0.8])

figure
subplot(121)
g=shadedErrorBar(fSp,nanmean(CTLSpPFNF),[nanstd(CTLSpPFNF);nanstd(CTLSpPFNF)],'r')
hold on
g=shadedErrorBar(fSp,nanmean(CTLSpBFNF),[nanstd(CTLSpBFNF);nanstd(CTLSpBFNF)],'b')
g=shadedErrorBar(fSp,nanmean(CTLSpHFNF),[nanstd(CTLSpHFNF);nanstd(CTLSpHFNF)],'c')
xlim([0 20])
subplot(122)
plot(fSp,nanmean(CTLSpPFNF),'r'), hold on
plot(fSp,nanmean(CTLSpBFNF),'b')
plot(fSp,nanmean(CTLSpHFNF),'c')
xlim([0 20])

%%%%

CTLCoBFNF=nan(11,261);
num=1;
for m=[2:10,12:17]
try
    CTLCoBFNF(num,:)=[(Cspectr{m,1})]';
end
num=num+1;
end

CTLCoHFNF=nan(11,261);
num=1;
for m=[2:10,12:17]
try
    CTLCoHFNF(num,:)=[(Cspectr{m,2})]';
end
num=num+1;
end
figure(8)
subplot(211)
g=shadedErrorBar(fCo,nanmean(CTLCoBFNF),[nanstd(CTLCoBFNF);nanstd(CTLCoBFNF)],'b'), hold on
subplot(212)
g=shadedErrorBar(fCo,nanmean(CTLCoHFNF),[nanstd(CTLCoHFNF);nanstd(CTLCoHFNF)],'c'), hold on
CTLCoBFNF=nan(11,261);
num=1;
for m=[2:10,12:17]
try
    CTLCoBFNF(num,:)=[(Cspectr2{m,1})]';
end
num=num+1;
end

CTLCoHFNF=nan(11,261);
num=1;
for m=[2:10,12:17]
try
    CTLCoHFNF(num,:)=[(Cspectr2{m,2})]';
end
num=num+1;
end
figure(8)
subplot(211)
g=shadedErrorBar(fCo,nanmean(CTLCoBFNF),[nanstd(CTLCoBFNF);nanstd(CTLCoBFNF)],'--b'), hold on
xlabel('freq')
ylabel('Coh OB-PFC')
subplot(212)
g=shadedErrorBar(fCo,nanmean(CTLCoHFNF),[nanstd(CTLCoHFNF);nanstd(CTLCoHFNF)],'--c'), hold on
ylim([0.4 1])
xlabel('freq')
ylabel('Coh HPC-PFC')

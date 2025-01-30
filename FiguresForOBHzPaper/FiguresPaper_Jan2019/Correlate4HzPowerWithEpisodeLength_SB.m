clear all
Dir = PathForExperimentFEAR('Fear-electrophy');
Dir1 = RestrictPathForExperiment(Dir,'Session','EXT-24h-envC');
Dir2 = RestrictPathForExperiment(Dir,'Session','EXT-24h-envB');
Dir3 = RestrictPathForExperiment(Dir,'Session','EXT-48h-envC');
Dir4 = RestrictPathForExperiment(Dir,'Session','EXT-48h-envB');
Dir = MergePathForExperiment(Dir1,Dir2);
Dir = MergePathForExperiment(Dir,Dir3);

Dir = MergePathForExperiment(Dir,Dir4);

cd /media/nas4/SophieToCopy
load('SoundTimes.mat','SoundEpoch')

Types = {'All','CSMnEpoch','CSplEpoch','CSMnSounds','CSplSounds','NoSounds'};


for tt = 1:length(Types)
    clear PeakTime EpDur PeakVal MeanVal MeanVal_Beg MeanVal_End MaxVal_Beg MaxVal_End TimeToNextFreezing
    mousenum=0;
    for mm=1:length(Dir.path)
        
        if strcmp(Dir.group{mm},'CTRL')
            cd(Dir.path{mm})
            if exist('B_Low_Spectrum.mat')>0 | exist('ChannelsToAnalyse/Bulb_deep.mat')>0
                
                mousenum = mousenum+1;
                disp(Dir.path{mm})
                
                
                clear Movtsd FreezeEpoch FreezeAccEpoch Spectro
                
                try, load('behavResources.mat');catch,load('Behavior.mat'); end
                if exist('FreezeAccEpoch','var')
                    FreezeEpoch = FreezeAccEpoch;
                end
                
                
                % Restrictions
                Types = {'All','CSMnEpoch','CSplEpoch','CSMnSounds','CSplSounds','NoSounds'};
                switch Types{tt}
                    case 'All'
                        TotEpoch = intervalSet(0,max(Range(Movtsd)));
                    case 'CSMnEpoch'
                        TotEpoch = intervalSet(120*1E4,400*1E4);
                    case 'CSplEpoch'
                        TotEpoch = intervalSet(400*1E4,1400*1E4);
                    case 'CSMnSounds'
                        TotEpoch = and(intervalSet(120*1E4,400*1E4),SoundEpoch);
                    case 'CSplSounds'
                        TotEpoch = and(intervalSet(400*1E4,1400*1E4),SoundEpoch);
                    case 'NoSounds'
                        TotEpoch =  intervalSet(0,max(Range(Movtsd)))- SoundEpoch;
                end
                
                % Pre CS
                st = Start(FreezeEpoch);
                st_res = Start(and(FreezeEpoch,TotEpoch));
                stp = Stop(FreezeEpoch);
                stp_res = Stop(and(FreezeEpoch,TotEpoch));
                
                FreezeEpoch = subset(FreezeEpoch,find(and(ismember(st,st_res),ismember(stp,stp_res))));
                
                FreezeEpoch = mergeCloseIntervals(FreezeEpoch,2*1e4);
                FreezeEpoch = dropShortIntervals(FreezeEpoch,4*1e4);
                
                
                load('B_Low_Spectrum.mat')
                sptsd=tsd(Spectro{2}*1e4,(Spectro{1}));
                Pow4 = nanmean(Spectro{1}(:,find(Spectro{3}<3,1,'last'):find(Spectro{3}<6,1,'last'))')';
                PowBe = nanmean(Spectro{1}')';
                
                Pow4Hz = tsd(Spectro{2}*1e4,Pow4./PowBe);
                if length(Start(FreezeEpoch))>0
                    for ep = 1:length(Start(FreezeEpoch))
                        
                        Epo = subset(FreezeEpoch,ep);
                        LitPow4Hz = Restrict(Pow4Hz,Epo);
                        
                        [val,ind] = max(Data(LitPow4Hz));
                        tps = Range(LitPow4Hz,'s');
                        PeakTime{mousenum}(ep)= tps(ind)-tps(1);
                        EpDur{mousenum}(ep)= tps(end)-tps(1);
                        PeakVal{mousenum}(ep)= val;
                        MeanVal{mousenum}(ep)=  mean(Data(LitPow4Hz));
                        
                        MeanVal_Beg{mousenum}(ep)=  mean(Data(Restrict(Pow4Hz,intervalSet(Start(Epo),Start(Epo)+2*1e4))));
                        MeanVal_End{mousenum}(ep)=  mean(Data(Restrict(Pow4Hz,intervalSet(Stop(Epo)-2*1e4,Stop(Epo)))));
                        
                        MaxVal_Beg{mousenum}(ep)=  max(Data(Restrict(Pow4Hz,intervalSet(Start(Epo),Start(Epo)+2*1e4))));
                        MaxVal_End{mousenum}(ep)=  max(Data(Restrict(Pow4Hz,intervalSet(Stop(Epo)-2*1e4,Stop(Epo)))));
                        
                        TimeToNextFreezing{mousenum}(ep)= NaN;
                        
                    end
                end
            end
        end
        
    end
    
    AllData = [];
    for mm = 1:length(EpDur)
        AllData = [AllData,[EpDur{mm};TimeToNextFreezing{mm};...
            PeakTime{mm};PeakVal{mm};MeanVal{mm};MaxVal_Beg{mm};MaxVal_End{mm}]];
    end
    %1 : dur, 2: time to next freezing
    %3: Time of peak; 4: Val of peak; 5: Mean Val; 6: Mean Val Beg; 7: Mean Val
    %End
    
    fig = figure;
    subplot(4,1,1)
    plot(AllData(1,:),AllData(4,:),'k.'), hold on
    set(gca,'xscale','log')
    xlim([2 120])
    xlabel('Ep dur (s)')
    ylabel('Peak 4Hz SNR')
    [R,P]=corrcoef(AllData(1,not(isnan(AllData(4,:)))),AllData(4,not(isnan(AllData(4,:)))));
    if P(1,2)>0.05, title([num2str(R(1,2)), ' NS']), else,title(num2str(R(1,2))), end
    makepretty
    ylim([0 7])
    
    subplot(4,1,2)
    plot(AllData(1,:),AllData(5,:),'k.'), hold on
    set(gca,'xscale','linear')
    xlim([2 120])
    xlabel('Ep dur (s)')
    ylabel('Mean 4Hz SNR')
    [R,P]=corrcoef(AllData(1,not(isnan(AllData(5,:)))),AllData(5,not(isnan(AllData(5,:)))));
    if P(1,2)>0.05, title([num2str(R(1,2)), ' NS']), else,title(num2str(R(1,2))), end
    makepretty
    set(gca,'xscale','log')
    ylim([0 7])
    
    subplot(4,1,3)
    plot(AllData(1,:),AllData(6,:),'k.'), hold on
    set(gca,'xscale','log')
    xlim([2 120])
    xlabel('Ep dur (s)')
    ylabel('4Hz SNR - Beginning')
    [R,P]=corrcoef(AllData(1,not(isnan(AllData(6,:)))),AllData(6,not(isnan(AllData(6,:)))));
    if P(1,2)>0.05, title([num2str(R(1,2)), ' NS']), else,title(num2str(R(1,2))), end
    makepretty
    ylim([0 7])
    
    subplot(4,1,4)
    plot(AllData(1,:),AllData(7,:),'k.'), hold on
    set(gca,'xscale','log')
    xlim([2 120])
    xlabel('Ep dur (s)')
    ylabel('4Hz SNR - End')
    [R,P]=corrcoef(AllData(1,not(isnan(AllData(7,:)))),AllData(7,not(isnan(AllData(7,:)))));
    if P(1,2)>0.05, title([num2str(R(1,2)), ' NS']), else,title(num2str(R(1,2))), end
    makepretty
    ylim([0 7])
    
    saveas(fig.Number, ['/home/mobsmorty/Dropbox/Mobs_member/SophieBagur/Revision Papier/Review2NatComm/Corr',Types{tt},'.fig'])
    saveas(fig.Number,[ '/home/mobsmorty/Dropbox/Mobs_member/SophieBagur/Revision Papier/Review2NatComm/Corr',Types{tt},'.png'])
    save([ '/home/mobsmorty/Dropbox/Mobs_member/SophieBagur/Revision Papier/Review2NatComm/Corr',Types{tt},'.mat'],'AllData')
    
end


for tt = 1:length(Types)
    load([ '/home/gruffalo/Dropbox/Mobs_member/SophieBagur/Revision Papier/Review2NatComm/Corr',Types{tt},'.mat'])
    
    [R,P]=corrcoef(log(AllData(1,not(isnan(AllData(7,:))))),AllData(7,not(isnan(AllData(7,:)))));
    Rval_off(tt) = R(1,2);
    Pval_off(tt) = P(1,2);
    
    [R,P]=corrcoef(log(AllData(1,not(isnan(AllData(6,:))))),AllData(6,not(isnan(AllData(6,:)))));
    Rval_on(tt) = R(1,2);
    Pval_on(tt) = P(1,2);
    
    [R,P]=corrcoef(log(AllData(1,not(isnan(AllData(4,:))))),AllData(4,not(isnan(AllData(4,:)))));
    Rval_all(tt) = R(1,2);
    Pval_all(tt) = P(1,2);
    
end

figure
subplot(211)
bar(Rval_all([1,2,3,6]),'Facecolor',[0.6 0.6 0.6])
makepretty
set(gca,'XTick',[1:4],'XTickLabels',Types([1,2,3,6]))
xtickangle(45)
ylabel('Corr. Coeff')

subplot(212)
bar(Rval_off([1,2,3,6]),'Facecolor',[102 0 204]/258), hold on
bar(Rval_on([1,2,3,6]),'Facecolor',[246 163 97]/258)
makepretty
set(gca,'XTick',[1:4],'XTickLabels',Types([1,2,3,6]))
xtickangle(45)all
ylabel('Corr. Coeff')



tt=1

load([ '/home/gruffalo/Dropbox/Mobs_member/SophieBagur/Revision Papier/Review2NatComm/Corr',Types{tt},'.mat'])

fig = figure;
subplot(131)
plot(AllData(1,:),AllData(4,:),'.','color',[0.4 0.4 0.4]), hold on
set(gca,'xscale','log')
xlim([2 120])
xlabel('Ep dur (s)')
ylabel('4Hz SNR - Total')
[R,P]=corrcoef(log(AllData(1,not(isnan(AllData(4,:))))),AllData(4,not(isnan(AllData(4,:)))));
if P(1,2)>0.05, title([num2str(R(1,2)), ' NS']), else,title(num2str(R(1,2))), end
X = log(AllData(1,not(isnan(AllData(4,:)))));
kk=1;
for k =1:0.5:5
    val(kk) = nanmean(AllData(4,X>=k & X<=k+1));
    std(kk) = stdError(AllData(4,X>=k & X<=k+1));    
    kk=kk+1;
end
errorbar(exp(1.2:0.5:5.2),val,std,'linewidth',3,'color','k')
set(gca,'XTick',[5,10,20,50])
makepretty
ylim([0 10])


subplot(132)
plot(AllData(1,:),AllData(6,:),'.','color',[0.4 0.4 0.4]), hold on
set(gca,'xscale','log')
xlim([2 120])
xlabel('Ep dur (s)')
ylabel('4Hz SNR - Onset')
[R,P]=corrcoef(log(AllData(1,not(isnan(AllData(4,:))))),AllData(6,not(isnan(AllData(6,:)))));
if P(1,2)>0.05, title([num2str(R(1,2)), ' NS']), else,title(num2str(R(1,2))), end
X = log(AllData(1,not(isnan(AllData(4,:)))));
kk=1;
for k =1:0.5:5
    val(kk) = nanmean(AllData(6,X>=k & X<=k+1));
    std(kk) = stdError(AllData(6,X>=k & X<=k+1));    
    kk=kk+1;
end
errorbar(exp(1.2:0.5:5.2),val,std,'linewidth',3,'color','k')
set(gca,'XTick',[5,10,20,50])
makepretty
ylim([0 10])

subplot(133)
plot(AllData(1,:),AllData(7,:),'.','color',[0.4 0.4 0.4]), hold on
set(gca,'xscale','log')
xlim([2 120])
xlabel('Ep dur (s)')
ylabel('4Hz SNR - Offset')
[R,P]=corrcoef(log(AllData(1,not(isnan(AllData(4,:))))),AllData(7,not(isnan(AllData(7,:)))));
if P(1,2)>0.05, title([num2str(R(1,2)), ' NS']), else,title(num2str(R(1,2))), end
X = log(AllData(1,not(isnan(AllData(7,:)))));
kk=1;
for k =1:0.5:5
    val(kk) = nanmean(AllData(7,X>=k & X<=k+1));
    std(kk) = stdError(AllData(7,X>=k & X<=k+1));    
    kk=kk+1;
end
errorbar(exp(1.2:0.5:5.2),val,std,'linewidth',3,'color','k')
set(gca,'XTick',[5,10,20,50])
makepretty
ylim([0 10])


%%

fig = figure;
num=1;
for tt=[2,3,6]
    
    load([ '/home/gruffalo/Dropbox/Mobs_member/SophieBagur/Revision Papier/Review2NatComm/Corr',Types{tt},'.mat'])
    
    subplot(1,3,num)
    plot(AllData(1,:),AllData(4,:),'.','color',[0.4 0.4 0.4]), hold on
    set(gca,'xscale','log')
    xlim([2 120])
    xlabel('Ep dur (s)')
    ylabel('4Hz SNR - Total')
    [R,P]=corrcoef(log(AllData(1,not(isnan(AllData(4,:))))),AllData(4,not(isnan(AllData(4,:)))));
    if P(1,2)>0.05, title([num2str(R(1,2)), ' NS']), else,title(num2str(R(1,2))), end
    X = log(AllData(1,not(isnan(AllData(4,:)))));
    kk=1;
    for k =1:0.5:5
        val(kk) = nanmean(AllData(4,X>=k & X<=k+1));
        std(kk) = stdError(AllData(4,X>=k & X<=k+1));
        kk=kk+1;
    end
    errorbar(exp(1.2:0.5:5.2),val,std,'linewidth',3,'color','k')
    set(gca,'XTick',[5,10,20,50])
    makepretty
    ylim([0 10])
    num=num+1;
end

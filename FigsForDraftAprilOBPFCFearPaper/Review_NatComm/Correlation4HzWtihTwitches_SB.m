
clear all
FreqRange=[3,6];
Dir.path{1} ='/media/DataMOBsRAID/ProjetAversion/DATA-Fear/Mouse248/20150326-EXT-24h-envC';
Dir.path{2} ='/media/DataMOBsRAID/ProjetAversion/DATA-Fear/Mouse244/20150507-EXT-24h-envB';
Dir.path{3} ='/media/DataMOBsRAID/ProjetAversion/DATA-Fear/Mouse244/20150507-EXT-24h-envB';
Dir.path{4} ='/media/DataMOBsRAID/ProjetAversion/DATA-Fear/Mouse243/20150507-EXT-24h-envB';
Dir.path{5} ='/media/DataMOBsRAID/ProjetAversion/DATA-Fear/Mouse253/20150703-EXT-24h-envC';
Dir.path{6} ='/media/DataMOBsRAID/ProjetAversion/DATA-Fear/Mouse254/20150703-EXT-24h-envC';
Dir.path{7} ='/media/DataMOBsRAID/ProjetAversion/DATA-Fear/Mouse258/20151204-EXT-24h-envC';
Dir.path{8} ='/media/DataMOBsRAID/ProjetAversion/DATA-Fear/Mouse259/20151204-EXT-24h-envC';
Dir.path{9} ='/media/DataMOBsRAID/ProjetAversion/DATA-Fear/Mouse299/20151217-EXT-24h-envC';
Dir.path{10} ='/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse394/FEAR-Mouse-394-EXT-24-envBraye_161020_163239';
Dir.path{11} ='/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse395/FEAR-Mouse-395-EXT-24-envBraye_161020_155350';
Dir.path{12} ='/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse402/FEAR-Mouse-402-EXT-24-envB_raye_161026_164106';
Dir.path{13} ='/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse403/FEAR-Mouse-403-EXT-24-envB_raye_161026_171611';
Dir.path{14} ='/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse450/FEAR-Mouse-450-EXT-24-envB_161026_174952';
Dir.path{15} ='/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse451/FEAR-Mouse-451-EXT-24-envB_161026_182307';

DirB.path{1} ='/media/DataMOBsRAID/ProjetAversion/DATA-Fear/Mouse291/20151204-EXT-24h-envC';
DirB.path{2} ='/media/DataMOBsRAID/ProjetAversion/DATA-Fear/Mouse297/20151217-EXT-24h-envC';
DirB.path{3} ='/media/DataMOBsRAID/ProjetAversion/DATA-Fear/Mouse298/20151217-EXT-24h-envC';

cd /media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse403/FEAR-Mouse-403-EXT-24-envB_raye_161026_171611
load('behavResources.mat','BeepTimes')
timebef = 4; % now use 5s always

Seui = 0.7*1E8;
neur = 1;
mouse=1;
for k = 1:length(Dir.path)
    cd(Dir.path{k})
    
    if exist('SpikeData.mat')>0
        try
            clear FreezeAccEpoch Kappa mu pval S MovAcctsd
            load('behavResources.mat')
            if not(exist('FreezeAccEpoch'))
                FreezeAccEpoch = FreezeEpoch;
            end
            
            FreezeAccEpoch =  dropShortIntervals(FreezeAccEpoch,5*1E4);
            TotalEpoch = intervalSet(0,max(Range(MovAcctsd)))
            load('NeuronLFPCoupling_OB4HzPaper/AllEpochNeuronModFreqMiniMaxiPhaseCorrected_OB1.mat')
            
            [numNeurons, numtt, TT]=GetSpikesFromStructure('PFCx', 'remove_MUA',1);
            load('SpikeData.mat')
            S = S(numNeurons);
            BeppEpoch = or(intervalSet(BeepTimes.CSP*1E4-1E4,BeepTimes.CSP*1E4+2E4),intervalSet(BeepTimes.CSM*1E4-1E4,BeepTimes.CSM*1E4+2E4));
            Times = thresholdIntervals(Restrict(MovAcctsd,FreezeAccEpoch),Seui,'Direction','Above');
            Times = mergeCloseIntervals(Times,0.5*1E4);
%             Times = Times - BeppEpoch;
            Times = Start(Times);
            
            

            tps=[0.05:0.05:1];
            
            load('B_Low_Spectrum.mat')
            Sptsd = tsd(Spectro{2}*1E4,(Spectro{1}));
            Val1 = nanmean(Spectro{1}(:,find(Spectro{3}<FreqRange(1),1,'last'):find(Spectro{3}<FreqRange(2),1,'last'))')';
            Val2 = nanmean(Spectro{1}(:,find(Spectro{3}<8,1,'last'):end)')';
            PowerOB =  tsd(Spectro{2}*1e4,Val1./Val2);
            TimesQ =  tsd(Range(Sptsd),hist(Times,Range(Sptsd))');
            [R,P] = corrcoef(Data(Restrict(PowerOB,FreezeAccEpoch)),full(Data(Restrict(TimesQ,FreezeAccEpoch))));
           
            RRem(mouse) = R(1,2);
            PRem(mouse) = P(1,2);
            JumpyEpoch = intervalSet(Times-0.5*1E4,Times+0.1*1E4);
            WithJumps(mouse,:) = nanmean(Data(Restrict(Sptsd,JumpyEpoch)))./nanmean(Val2)
            WithNoJumps(mouse,:) = nanmean(Data(Restrict(Sptsd,FreezeAccEpoch - JumpyEpoch)))./nanmean(Val2);
            
            TimesQ =  tsd(Range(MovAcctsd),hist(Times,Range(MovAcctsd))');
            [Mov(mouse,:), B] = xcorr(Data(TimesQ),Data(MovAcctsd),100);

            mouse = mouse+1;
        end
    end
end

%% Link 4Hz to beep amplitude
figure
AllX = [];
AllY = [];
for mm=1:(mouse)-1
plot(log(OBPower{mm}),nanmean(Mov_beeptime{mm}'),'k*')
hold on
AllX = [AllX,log(OBPower{mm})];
AllY = [AllY,nanmean(Mov_beeptime{mm}')];
end
[R,P] = corrcoef(AllX,AllY)
title(['R= ' num2str(R(1,2)) '  P= ' num2str(P(1,2))])
axis square
xlabel('OB 4Hz power (log)')
ylabel('Jump size to beep')
makepretty

clear stdVal MeanVal
for k = 1:10
    MeanVal(k) = nanmean(AllY(AllX>(k-1)*0.4 & AllX<(k)*0.4));
    stdVal(k) = stdError(AllY(AllX>(k-1)*0.4 & AllX<(k)*0.4));
end
hold on




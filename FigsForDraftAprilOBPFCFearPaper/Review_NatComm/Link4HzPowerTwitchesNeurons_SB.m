

clear all
% FreqRange=[3,6];
% Dir.path{1} ='D:\SophieToCopy\_media_DataMOBsRAID_ProjetAversion_DATA-Fear_Mouse248_20150326-EXT-24h-envC\20150326-EXT-24h-envC';
% Dir.path{2} ='D:\SophieToCopy\_media_DataMOBsRAID_ProjetAversion_DATA-Fear_Mouse244_20150507-EXT-24h-envB\20150507-EXT-24h-envB';
% Dir.path{3} ='D:\SophieToCopy\_media_DataMOBsRAID_ProjetAversion_DATA-Fear_Mouse244_20150507-EXT-24h-envB\20150507-EXT-24h-envB';
% Dir.path{4} ='D:\SophieToCopy\_media_DataMOBsRAID_ProjetAversion_DATA-Fear_Mouse243_20150507-EXT-24h-envB\20150507-EXT-24h-envB';
% Dir.path{5} ='D:\SophieToCopy\_media_DataMOBsRAID_ProjetAversion_DATA-Fear_Mouse253_20150703-EXT-24h-envC_FEAR-Mouse-253-03072015\FEAR-Mouse-253-03072015';
% Dir.path{6} ='D:\SophieToCopy\_media_DataMOBsRAID_ProjetAversion_DATA-Fear_Mouse254_20150703-EXT-24h-envC\20150703-EXT-24h-envC';
% Dir.path{7} ='D:\SophieToCopy\_media_DataMOBsRAID_ProjetAversion_DATA-Fear_Mouse258_20151204-EXT-24h-envC\20151204-EXT-24h-envC';
% Dir.path{8} ='D:\SophieToCopy\_media_DataMOBsRAID_ProjetAversion_DATA-Fear_Mouse259_20151204-EXT-24h-envC\20151204-EXT-24h-envC';
% Dir.path{9} ='D:\SophieToCopy\_media_DataMOBsRAID_ProjetAversion_DATA-Fear_Mouse299_20151217-EXT-24h-envC\20151217-EXT-24h-envC';
% Dir.path{10} ='D:\SophieToCopy\_media_DataMOBsRAIDN_ProjetAversion_DATA-Fear_Mouse394_FEAR-Mouse-394-EXT-24-envBraye_161020_163239_\FEAR-Mouse-394-EXT-24-envBraye_161020_163239';
% Dir.path{11} ='D:\SophieToCopy\_media_DataMOBsRAIDN_ProjetAversion_DATA-Fear_Mouse395_FEAR-Mouse-395-EXT-24-envBraye_161020_155350_\FEAR-Mouse-395-EXT-24-envBraye_161020_155350';
% Dir.path{12} ='D:\SophieToCopy\_media_DataMOBsRAIDN_ProjetAversion_DATA-Fear_Mouse402_FEAR-Mouse-402-EXT-24-envB_raye_161026_164106_\FEAR-Mouse-402-EXT-24-envB_raye_161026_164106';
% Dir.path{13} ='D:\SophieToCopy\_media_DataMOBsRAIDN_ProjetAversion_DATA-Fear_Mouse403_FEAR-Mouse-403-EXT-24-envB_raye_161026_171611_\FEAR-Mouse-403-EXT-24-envB_raye_161026_171611';
% Dir.path{14} ='D:\SophieToCopy\_media_DataMOBsRAIDN_ProjetAversion_DATA-Fear_Mouse450_FEAR-Mouse-450-EXT-24-envB_161026_174952_\FEAR-Mouse-450-EXT-24-envB_161026_174952';
% Dir.path{15} ='D:\SophieToCopy\_media_DataMOBsRAIDN_ProjetAversion_DATA-Fear_Mouse451_FEAR-Mouse-451-EXT-24-envB_161026_182307_\FEAR-Mouse-451-EXT-24-envB_161026_182307';
% 
% DirB.path{1} ='D:\SophieToCopy\_media_DataMOBsRAID_ProjetAversion_DATA-Fear_Mouse291_20151204-EXT-24h-envC\20151204-EXT-24h-envC';
% DirB.path{2} ='D:\SophieToCopy\_media_DataMOBsRAID_ProjetAversion_DATA-Fear_Mouse297_20151217-EXT-24h-envC\20151217-EXT-24h-envC';
% DirB.path{3} ='D:\SophieToCopy\_media_DataMOBsRAID_ProjetAversion_DATA-Fear_Mouse298_20151217-EXT-24h-envC\20151217-EXT-24h-envC';
% 
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
            clear FreezeAccEpoch Kappa mu pval S MovAcctsd MovAccSmotsd
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
            % Beeps
            BeppEpoch = or(intervalSet(BeepTimes.CSP*1E4,BeepTimes.CSP*1E4+0.2*1E4),intervalSet(BeepTimes.CSM*1E4,BeepTimes.CSM*1E4+0.2*1E4));
            BeppEpoch = and(BeppEpoch,FreezeAccEpoch);
            Times = Start(BeppEpoch);
            
            % Movements
            %             Times = thresholdIntervals(Restrict(MovAcctsd,FreezeAccEpoch),Seui,'Direction','Above');
            %             Times = mergeCloseIntervals(Times,0.5*1E4);
            %             Times = Start(Times);
            
            load('B_Low_Spectrum.mat')
            Sptsd = tsd(Spectro{2}*1E4,(Spectro{1}));
            Val1 = nanmean(Spectro{1}(:,find(Spectro{3}<FreqRange(1),1,'last'):find(Spectro{3}<FreqRange(2),1,'last'))')';
            Val2 = nanmean(Spectro{1}(:,find(Spectro{3}<8,1,'last'):end)')';
            PowerOB =  tsd(Spectro{2}*1e4,Val1./Val2);
            
            Qtsd = MakeQfromS(S,0.01*1E4);
            NumBeepsInFreezing(mouse) = length(Times);
            for t = 1:length(Times)
                LitEp = intervalSet(Times(t)-0.4*1E4,Times(t)+0.8*1E4);
                temp = Data(Restrict(MovAcctsd,LitEp));
                temp = temp(1:40);
                Mov_beep{mouse}(t) = nanmean(Data(Restrict(MovAcctsd,LitEp)));
                Mov_beeptime{mouse}(t,:) = temp;
                OBPower{mouse}(t) = nanmean(Data(Restrict(PowerOB,LitEp)));
                
                temp = full(Data(Restrict(Qtsd,LitEp)))';
                temp = temp(:,1:110);
                NeuronResp{mouse}(t,:,:) = temp;
                TimeFromFreezeStart{mouse}(t) = Times(t) - Start(subset(FreezeAccEpoch,find((Times(t)-Start(FreezeAccEpoch))>0,1,'last')));
                FreezeDur{mouse}(t) = Stop(subset(FreezeAccEpoch,find((Times(t)-Start(FreezeAccEpoch))>0,1,'last')))-Start(subset(FreezeAccEpoch,find((Times(t)-Start(FreezeAccEpoch))>0,1,'last')));
            end
            
            OBPowerAllFz{mouse} = Data(Restrict(PowerOB,FreezeAccEpoch-BeppEpoch));
            AllMov{mouse} = Data(Restrict(MovAccSmotsd,ts(Range(Restrict(PowerOB,FreezeAccEpoch-BeppEpoch)))));
            
            
            
            for i = 1:length(S)
                [C{mouse}(i,:),B] = CrossCorr(Times,Range(S{i}),20,200);
                
                KappaNeur{mouse}(i) = Kappa{i}.Transf;
                PhaseNeur{mouse}(i) = mu{i}.Transf;
                PValNeur{mouse}(i) = pval{i}.Transf;
                
            end
            mouse = mouse+1;
            
        end
    end
end


figure
AllX = [];
AllY = [];
AllKappa = [];
AllPval = [];
AvOB = [];
AvOBAll = [];
AllMovAll = [];
for mm=1:(mouse)-1
    if NumBeepsInFreezing(mm)>50
        AllX = [AllX;zscore(squeeze(nanmean(NeuronResp{mm},1))')'];
        AllY = [AllY;zscore(C{mm}')'];
        AllKappa=[AllKappa,KappaNeur{mm}];
        AllPval=[AllPval,PValNeur{mm}];
        AvOB = [AvOB,OBPower{mm}];
        AvOBAll = [AvOBAll,OBPowerAllFz{mm}'];
        AllMovAll = [AllMovAll,AllMov{mm}'];
        
    end
end



RRes = [];
PRes = [];
for mm=1:(mouse)-1
    if NumBeepsInFreezing(mm)>50
        for nn = 1:size(NeuronResp{mm},2)
            [R,P] = corrcoef( Mov_beep{mm},squeeze(nanmean(NeuronResp{mm}(:,nn,30:50),3)));
            RRes = [RRes,R(1,2)];
            PRes = [PRes,P(1,2)];
        end
    end
end

A = nanmean(AllY(:,90:110)');
figure
plot(A(PRes<0.05),RRes(PRes<0.05),'.','MarkerSize',20)
hold on
plot(A(PRes>0.05),RRes(PRes>0.05),'.','MarkerSize',20)

AllT = [];
AllMov = [];
for mm=1:(mouse)-1
    plot(TimeFromFreezeStart{mm}./FreezeDur{mm},Mov_beep{mm},'.')
    AllT = [AllT,TimeFromFreezeStart{mm}./FreezeDur{mm}];
    AllMov = [AllMov,Mov_beep{mm}];
    
    hold on
end


figure
clear AllMovBinned
for t = 1:9
    for mm=1:(mouse)-1
        temp = TimeFromFreezeStart{mm}./FreezeDur{mm};
        AllMovBinned(mm,t) = nanmean(Mov_beep{mm}(temp<t/10 & temp>(t-1)/10));
    end
end

errorbar(1:9,nanmean(AllMovBinned),stdError(AllMovBinned),'linewidth',2)
xlabel('Time norm')
ylabel('Movement amplitude')
makepretty



RRes = [];
PRes = [];
for mm=1:(mouse)-1
            [R,P] = corrcoef( AllMov{mm},OBPowerAllFz{mm});
            RRes = [RRes,R(1,2)];
            PRes = [PRes,P(1,2)];
        
    
end

%% Link 4Hz to beep amplitude
figure
AllX = [];
AllY = [];
for mm=1:(mouse)-1
plot(log(OBPower{mm}),nanmean(Mov_beeptime{mm}'),'k.')
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




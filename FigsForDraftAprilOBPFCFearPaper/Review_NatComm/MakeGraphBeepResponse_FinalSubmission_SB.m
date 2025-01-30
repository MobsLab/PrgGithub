
clear all
FreqRange=[3,6];
Dir.path{1} ='D:\SophieToCopy\_media_DataMOBsRAID_ProjetAversion_DATA-Fear_Mouse248_20150326-EXT-24h-envC\20150326-EXT-24h-envC';
Dir.path{2} ='D:\SophieToCopy\_media_DataMOBsRAID_ProjetAversion_DATA-Fear_Mouse244_20150507-EXT-24h-envB\20150507-EXT-24h-envB';
Dir.path{3} ='D:\SophieToCopy\_media_DataMOBsRAID_ProjetAversion_DATA-Fear_Mouse244_20150507-EXT-24h-envB\20150507-EXT-24h-envB';
Dir.path{4} ='D:\SophieToCopy\_media_DataMOBsRAID_ProjetAversion_DATA-Fear_Mouse243_20150507-EXT-24h-envB\20150507-EXT-24h-envB';
Dir.path{5} ='D:\SophieToCopy\_media_DataMOBsRAID_ProjetAversion_DATA-Fear_Mouse253_20150703-EXT-24h-envC_FEAR-Mouse-253-03072015\FEAR-Mouse-253-03072015';
Dir.path{6} ='D:\SophieToCopy\_media_DataMOBsRAID_ProjetAversion_DATA-Fear_Mouse254_20150703-EXT-24h-envC\20150703-EXT-24h-envC';
Dir.path{7} ='D:\SophieToCopy\_media_DataMOBsRAID_ProjetAversion_DATA-Fear_Mouse258_20151204-EXT-24h-envC\20151204-EXT-24h-envC';
Dir.path{8} ='D:\SophieToCopy\_media_DataMOBsRAID_ProjetAversion_DATA-Fear_Mouse259_20151204-EXT-24h-envC\20151204-EXT-24h-envC';
Dir.path{9} ='D:\SophieToCopy\_media_DataMOBsRAID_ProjetAversion_DATA-Fear_Mouse299_20151217-EXT-24h-envC\20151217-EXT-24h-envC';
Dir.path{10} ='D:\SophieToCopy\_media_DataMOBsRAIDN_ProjetAversion_DATA-Fear_Mouse394_FEAR-Mouse-394-EXT-24-envBraye_161020_163239_\FEAR-Mouse-394-EXT-24-envBraye_161020_163239';
Dir.path{11} ='D:\SophieToCopy\_media_DataMOBsRAIDN_ProjetAversion_DATA-Fear_Mouse395_FEAR-Mouse-395-EXT-24-envBraye_161020_155350_\FEAR-Mouse-395-EXT-24-envBraye_161020_155350';
Dir.path{12} ='D:\SophieToCopy\_media_DataMOBsRAIDN_ProjetAversion_DATA-Fear_Mouse402_FEAR-Mouse-402-EXT-24-envB_raye_161026_164106_\FEAR-Mouse-402-EXT-24-envB_raye_161026_164106';
Dir.path{13} ='D:\SophieToCopy\_media_DataMOBsRAIDN_ProjetAversion_DATA-Fear_Mouse403_FEAR-Mouse-403-EXT-24-envB_raye_161026_171611_\FEAR-Mouse-403-EXT-24-envB_raye_161026_171611';
Dir.path{14} ='D:\SophieToCopy\_media_DataMOBsRAIDN_ProjetAversion_DATA-Fear_Mouse450_FEAR-Mouse-450-EXT-24-envB_161026_174952_\FEAR-Mouse-450-EXT-24-envB_161026_174952';
Dir.path{15} ='D:\SophieToCopy\_media_DataMOBsRAIDN_ProjetAversion_DATA-Fear_Mouse451_FEAR-Mouse-451-EXT-24-envB_161026_182307_\FEAR-Mouse-451-EXT-24-envB_161026_182307';

DirB.path{1} ='D:\SophieToCopy\_media_DataMOBsRAID_ProjetAversion_DATA-Fear_Mouse291_20151204-EXT-24h-envC\20151204-EXT-24h-envC';
DirB.path{2} ='D:\SophieToCopy\_media_DataMOBsRAID_ProjetAversion_DATA-Fear_Mouse297_20151217-EXT-24h-envC\20151217-EXT-24h-envC';
DirB.path{3} ='D:\SophieToCopy\_media_DataMOBsRAID_ProjetAversion_DATA-Fear_Mouse298_20151217-EXT-24h-envC\20151217-EXT-24h-envC';

cd D:\SophieToCopy\_media_DataMOBsRAIDN_ProjetAversion_DATA-Fear_Mouse451_FEAR-Mouse-451-EXT-24-envB_161026_182307_\FEAR-Mouse-451-EXT-24-envB_161026_182307
load('behavResources.mat','BeepTimes')
timebef = 4; % now use 5s always

neur = 1;
mouse=1;
for k = 1:length(Dir.path)
    cd(Dir.path{k})
    k
    if exist('SpikeData.mat')>0
        try
            clear FreezeAccEpoch Kappa mu pval S MovAcctsd MovAccSmotsd BeepTimes Vtsd V Movtsd
            load('behavResources.mat')
            if not(exist('FreezeAccEpoch'))
                FreezeAccEpoch = FreezeEpoch;
            end
            
            if not(exist('Vtsd')) & exist('V')
                Vtsd = V;
            elseif not(exist('Vtsd')) & exist('Movtsd')
                Vtsd = Movtsd;
            end
            
            FreezeAccEpoch =  dropShortIntervals(FreezeAccEpoch,5*1E4);
            TotalEpoch = intervalSet(0,max(Range(MovAcctsd)));
            
            % Beeps
            BeppEpoch = or(intervalSet(BeepTimes.CSP*1E4,BeepTimes.CSP*1E4+0.2*1E4),intervalSet(BeepTimes.CSM*1E4,BeepTimes.CSM*1E4+0.2*1E4));
            BeppEpoch = and(BeppEpoch,FreezeAccEpoch);
            Times = Start(BeppEpoch);
            
            load('B_Low_Spectrum.mat')
            Sptsd = tsd(Spectro{2}*1E4,(Spectro{1}));
            Val1 = nanmean(Spectro{1}(:,find(Spectro{3}<FreqRange(1),1,'last'):find(Spectro{3}<FreqRange(2),1,'last'))')';
            Val2 = nanmean(Spectro{1}(:,find(Spectro{3}<8,1,'last'):end)')';
            PowerOB =  tsd(Spectro{2}*1e4,Val1./Val2);
            
            NumBeepsInFreezing(mouse) = length(Times);
            for t = 1:length(Times)
                LitEp = intervalSet(Times(t)-0.4*1E4,Times(t)+0.8*1E4);
                temp = Data(Restrict(MovAcctsd,LitEp));
                temp = temp(1:40);
                Mov_beep{mouse}(t) = nanmean(Data(Restrict(MovAcctsd,LitEp)));
                Mov_beeptime{mouse}(t,:) = temp;
                OBPower{mouse}(t) = nanmean(Data(Restrict(PowerOB,LitEp)));
                
                TimeFromFreezeStart{mouse}(t) = Times(t) - Start(subset(FreezeAccEpoch,find((Times(t)-Start(FreezeAccEpoch))>0,1,'last')));
            end
            
            
%             [tempM,~] = PlotRipRaw((MovAcctsd),Times(find(log(OBPower{mouse})<2))/1E4,2000,0,0,0);
%             MovBeepLow4(mouse,:) = tempM(:,2);
%             [tempM,~] = PlotRipRaw((MovAcctsd),Times(find(log(OBPower{mouse})>3))/1E4,2000,0,0,0);
%             MovBeepHigh4(mouse,:) = tempM(:,2);
%             [tempM,~] = PlotRipRaw((MovAcctsd),Stop(FreezeAccEpoch,'s'),2000,0,0,0);
%             MovEndFz(mouse,:) = tempM(:,2);
%             
%             MeanValHigh4(mouse) = nanmean(Data(Restrict(Vtsd,intervalSet(Times(find(log(OBPower{mouse})<2)),Times(find(log(OBPower{mouse})<2))+1E4))));
%             MeanValLow4(mouse) = nanmean(Data(Restrict(Vtsd,intervalSet(Times(find(log(OBPower{mouse})>3)),Times(find(log(OBPower{mouse})>3))+1E4))));
%             MeanValMov(mouse) = nanmean(Data(Restrict(Vtsd,TotalEpoch-FreezeAccEpoch)));
%             
%             MeanValHigh4Acc(mouse) = nanmean(Data(Restrict(MovAcctsd,intervalSet(Times(find(log(OBPower{mouse})<2)),Times(find(log(OBPower{mouse})<2))+1E4))));
%             MeanValLow4Acc(mouse) = nanmean(Data(Restrict(MovAcctsd,intervalSet(Times(find(log(OBPower{mouse})>3)),Times(find(log(OBPower{mouse})>3))+1E4))));
%             MeanValMovAcc(mouse) = nanmean(Data(Restrict(MovAcctsd,TotalEpoch-FreezeAccEpoch)));
%             
            
            OBPowerAllFz{mouse} = Data(Restrict(PowerOB,FreezeAccEpoch-BeppEpoch));
            AllMov{mouse} = Data(Restrict(MovAccSmotsd,ts(Range(Restrict(PowerOB,FreezeAccEpoch-BeppEpoch)))));
            
            
            for fzep = 1:length(Start(FreezeAccEpoch))
                OBPowerEp{mouse}(fzep) = nanmean(Data(Restrict(PowerOB,subset(FreezeAccEpoch,fzep))));
                FreezeDur{mouse}(fzep) = Stop(subset(FreezeAccEpoch,fzep))-Start(subset(FreezeAccEpoch,fzep));
            end
            
            if sum(FreezeDur{mouse}<10*1E4)>2 & sum(FreezeDur{mouse}>10*1E4)>2
                MeanOBShortFz(mouse,:) = nanmean(Data(Restrict(Sptsd,subset(FreezeAccEpoch,FreezeDur{mouse}<10*1E4))))./nanmean(nanmean(Data(Restrict(Sptsd,FreezeAccEpoch))));
                MeanOBLongFz(mouse,:) = nanmean(Data(Restrict(Sptsd,subset(FreezeAccEpoch,FreezeDur{mouse}>10*1E4))))./nanmean(nanmean(Data(Restrict(Sptsd,FreezeAccEpoch))));
            end
            
            mouse = mouse+1;
            mouse
        end
    end
end

figure
AllX = [];
AllY = [];
for mm=1:(mouse)-1
plot(log(OBPower{mm}),nanmean(Mov_beeptime{mm}'),'.','color',[0.6 0.6 0.6])
hold on
AllX = [AllX,log(OBPower{mm})];
AllY = [AllY,nanmean(Mov_beeptime{mm}')];
[R,P] = corrcoef(AllX,AllY)
RMouse(mm) = R(1,2);
PMouse(mm) = P(1,2);

end
[R,P] = corrcoef(AllX,AllY)
title(['R= ' num2str(R(1,2)) '  P= ' num2str(P(1,2))])
clear stdVal MeanVal
for k = 1:9
    MeanVal(k) = nanmean(AllY(AllX>(k+1)*0.4 & AllX<(k+2)*0.4));
    stdVal(k) = stdError(AllY(AllX>(k+1)*0.4 & AllX<(k+2)*0.4));
end
hold on

errorbar([2.5:10.5]*0.4,MeanVal,stdVal,'linewidth',3,'color','k')
 ylim([0 8*1E7])
xlim([0.5 4.5])
xlabel('OB 4Hz power (log)')
ylabel('Micromovement to beep') 
makepretty

figure
plot(runmean(nanmean(MovBeepHigh4),1),'linewidth',2,'color','r')
hold on
plot(runmean(nanmean(MovBeepLow4),1),'linewidth',2,'color','b')
xlim([70 140])
set(gca,'XTick',[],'YTick',[])

figure


figure
plot(Spectro{3},nanmean(MeanOBLongFz))
hold on
plot(Spectro{3},nanmean(MeanOBShortFz))

figure
hold on
H = shadedErrorBar(tempM(:,1)+0.5,nanmean(runmean(MovBeepHigh4',1)'),stdError(runmean(MovBeepHigh4',1)'));
H.patch.FaceColor = [1 0.4 0.4];
H.patch.FaceAlpha = 0.5;	
H.mainLine.Color = 'r';	
H.patch.EdgeColor = [1 0.4 0.4];
H.edge(1).Color= [1 0.4 0.4];
H.edge(2).Color= [1 0.4 0.4];

H = shadedErrorBar(tempM(:,1)+0.5,nanmean(runmean(MovBeepLow4',1)'),stdError(runmean(MovBeepLow4',1)'));
H.patch.FaceColor = [0.4 0.4 1];
H.patch.FaceAlpha = 0.3;	
H.mainLine.Color = 'b';	
H.edge(1).Color= [0.4 0.4 1];
H.edge(2).Color= [0.4 0.4 1];
xlim([0 1])
xlabel('Time from beep (s)')
ylabel('Movement (AU)')
makepretty

figure
AllX = [];
AllY = [];
for mm=1:(mouse)-1
plot((FreezeDur{mm}'),log(OBPowerEp{mm})'.','color',[0.6 0.6 0.6])
hold on
AllX = [AllX,log(OBPowerEp{mm})];
AllY = [AllY,(FreezeDur{mm})];
[R,P] = corrcoef(log(OBPowerEp{mm}),(FreezeDur{mm}'))
RMouse(mm) = R(1,2);
PMouse(mm) = P(1,2);

end
[R,P] = corrcoef(AllX,AllY)
title(['R= ' num2str(R(1,2)) '  P= ' num2str(P(1,2))])
axis square
xlabel('OB 4Hz power (log)')
ylabel('Jump size to beep')
makepretty

clear stdVal MeanVal
for k = 1:9
    MeanVal(k) = nanmean(AllY(AllX>(k+1)*0.4 & AllX<(k+2)*0.4));
    stdVal(k) = stdError(AllY(AllX>(k+1)*0.4 & AllX<(k+2)*0.4));
end
hold on


errorbar([2.5:10.5]*0.4,MeanVal,stdVal,'linewidth',2,'color','k')
 ylim([0 8*1E7])
xlim([0.5 4.5])
xlabel('Time to beep (s)')
ylabel('Jump size to beep')
makepretty

figure
hold on
H = shadedErrorBar(Spectro{3},nanmean(MeanOBLongFz),stdError(MeanOBLongFz));
H.patch.FaceColor = [1 0.4 0.4];
H.patch.FaceAlpha = 0.5;	
H.mainLine.Color = 'r';	
H.patch.EdgeColor = [1 0.4 0.4];
H.edge(1).Color= [1 0.4 0.4];
H.edge(2).Color= [1 0.4 0.4];

H = shadedErrorBar(Spectro{3},nanmean(MeanOBShortFz),stdError(MeanOBShortFz));
H.patch.FaceColor = [0.4 0.4 1];
H.patch.FaceAlpha = 0.3;	
H.mainLine.Color = 'b';	
H.edge(1).Color= [0.4 0.4 1];
H.edge(2).Color= [0.4 0.4 1];

xlabel('Frequency (Hz)')
ylabel('Power')
makepretty

FreqLims = find(Spectro{3}<FreqRange(1),1,'last'):find(Spectro{3}<FreqRange(2),1,'last');
figure
ShortVals = nanmean(MeanOBShortFz(:,FreqLims)')./nanmean(MeanOBShortFz'); ShortVals(ShortVals==0) = NaN;
LongVals = nanmean(MeanOBLongFz(:,FreqLims)')./nanmean(MeanOBLongFz'); LongVals(LongVals==0) = NaN;
[p,h] = signrank(LongVals,ShortVals)
MakeSpreadAndBoxPlot_SB({ShortVals,LongVals},{[0.4 0.4 1],[1 0.4 0.4]},[1,3],{'Short','Long'},1)
sigstar({{1,3}},p)
ylabel('3-6Hz SNR')
makepretty

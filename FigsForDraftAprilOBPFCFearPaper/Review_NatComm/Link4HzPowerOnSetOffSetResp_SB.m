clear all

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

%
neur = 1;
MeanSpecWk = [];
MeanSpecStr = [];
AllDur = [];
AllPow = [];

for k = 1:length(Dir.path)
    cd(Dir.path{k})
    
    if exist('SpikeData.mat')>0
        clear FreezeAccEpoch Kappa mu pval S
        [numNeurons, numtt, TT]=GetSpikesFromStructure('PFCx', 'remove_MUA',1);
        load('SpikeData.mat')
        S = S(numNeurons);
        load('behavResources.mat')
        if exist('FreezeAccEpoch')
            FreezeEpoch = FreezeAccEpoch;
        end
        TotEpoch = intervalSet(0,max(Range(Movtsd)));
        %                 load('NeuronLFPCoupling_OB4HzPaper\AllEpochNeuronModFreqMiniMaxiPhaseCorrected_OB1.mat','pval','Kappa','mu')
        load('NeuronLFPCoupling_OB4HzPaper\AllEpochNeuronModFreqMiniMaxiPhaseCorrected_OB1.mat')
        %         load('NeuronLFPCoupling\FzNeuronModFreqMiniMaxiPhaseCorrected_OB1.mat','pval','Kappa','mu')
        %         pval = pval.Real;
        %         Kappa = Kappa.Real;
        %         mu = mu.Real;
        
        
        
        clear Spectro Sptsd
        load('B_Low_Spectrum.mat')
        Sptsd = tsd(Spectro{2}*1E4,Spectro{1})
        clear PowRatio Spec Dur
        Lims = [find(Spectro{3}>3,1,'first'):find(Spectro{3}>6,1,'first')];
        for ep = 1:length(Start(FreezeEpoch))
            LitEp = subset(FreezeEpoch,ep);
            Spec(ep,:) = nanmean(Data(Restrict(Sptsd,LitEp)));
            PowRatio(ep) = nanmean(Spec(ep,Lims))/nanmean(Spec(ep,Lims(end):end));
            Dur(ep) = Stop(LitEp,'s') - Start(LitEp,'s');
        end
        MeanSpecStr = [MeanSpecStr;nanmean(Spec(find(zscore(PowRatio)>0),:))];
        MeanSpecWk = [MeanSpecWk;nanmean(Spec(find(zscore(PowRatio)<0),:))];
        AllDur = [AllDur,Dur];
        AllPow = [AllPow,zscore(PowRatio)];
        
        for num = 1:length(S)
            [StartRespStr(neur,:), B] = CrossCorr(Start(subset(FreezeEpoch,find(zscore(PowRatio)>0))),Range(S{num}),40,125);
            [StopRespStr(neur,:), B] = CrossCorr(Stop(subset(FreezeEpoch,find(zscore(PowRatio)>0))),Range(S{num}),40,125);
            [StartRespWk(neur,:), B] = CrossCorr(Start(subset(FreezeEpoch,find(zscore(PowRatio)<0))),Range(S{num}),40,125);
            [StopRespWk(neur,:), B] = CrossCorr(Stop(subset(FreezeEpoch,find(zscore(PowRatio)<0))),Range(S{num}),40,125);
            
            
            [~,MeanNoFz(neur)] = FiringRateEpoch(S{num},TotEpoch-FreezeEpoch);
            [~,MeanFz(neur)] = FiringRateEpoch(S{num},FreezeEpoch);
            Q = MakeQfromS(S(num),0.04*1E4);
            StdNeur(neur) = std(Data(Restrict(Q,TotEpoch-FreezeEpoch)));
            KappaNeur(neur) = Kappa{num};
            PhaseNeur(neur) = mu{num};
            PValNeur(neur) = pval{num};
            
            neur = neur+1;
        end
    end
    
end

% Get the time bins
MidVal = find(B>=0,1,'first')-1;
AllNoFz = [1:MidVal,MidVal*3+3:MidVal*5+3,MidVal*7+5:MidVal*8+4]
FzWk = [MidVal+1:MidVal*3+2];
FzStr = [MidVal*5+4:MidVal*7+4];
OnSetWk = [MidVal+1:MidVal+ceil(MidVal/3)];
OnSetStr = [MidVal+1:MidVal+ceil(MidVal/3)]+MidVal*4;
OffSetWk = [ MidVal*3+3: MidVal*3+3+ceil(MidVal/3)];
OffSetStr = [ MidVal*3+3+1: MidVal*3+3+ceil(MidVal/3)]+MidVal*4;

figure
DatMat = (zscore([StartRespWk,StopRespWk,StartRespStr,StopRespStr]')');
% for neur = 1:size(DatMat,1)
%     DatMat(neur,:) = (DatMat(neur,:) - MeanNoFz(neur))/StdNeur(neur);
% end
[EigVect,EigVals]=PerformPCA(DatMat);
[val,ind] = sort(EigVect(:,1));
subplot(3,1,1:2)
imagesc(DatMat(ind,:)), hold on
plot(AllNoFz,AllNoFz*0 + 220,'k*')
plot(FzWk,FzWk*0 + 220,'c*')
plot(FzStr,FzStr*0 + 220,'c*')
caxis([-3 3])
xlabel('Time to Fz onset(s)')
set(gca,'LineWidth',2,'FontSize',12), box off
subplot(3,1,3)
plot(EigVect(:,1)'*zscore(DatMat')')
hold on
plot(EigVect(:,2)'*zscore(DatMat')')
set(gca,'LineWidth',2,'FontSize',12), box off
xlabel('Time to Fz onset(s)')




% look at 3 types of response
clear DatMatCl
DatMat = (([StartRespWk,StopRespWk,StartRespStr,StopRespStr]')');
for neur = 1:size(DatMat,1)
    %     MeanNoFzNew(neur) = (nanmean(DatMat(neur,AllNoFz)));
    %     MeanFzNew(neur) = (nanmean(DatMat(neur,FzStr)+nanmean(DatMat(neur,FzWk))))/2;
    %     Skeletton = [ones(1,MidVal)*MeanNoFzNew(neur),ones(1,MidVal*2+2)*MeanFzNew(neur),ones(1,MidVal)*MeanNoFzNew(neur),ones(1,MidVal)*MeanNoFzNew(neur),ones(1,MidVal*2+2)*MeanFzNew(neur),ones(1,MidVal)*MeanNoFzNew(neur)];
    Skeletton = [ones(1,MidVal)*MeanNoFz(neur),ones(1,MidVal*2+2)*MeanFz(neur),ones(1,MidVal)*MeanNoFz(neur),ones(1,MidVal)*MeanNoFz(neur),ones(1,MidVal*2+2)*MeanFz(neur),ones(1,MidVal)*MeanNoFz(neur)];
    DatMatCl(neur,:) =  DatMat(neur,:)-Skeletton;
end

figure
[EigVect,EigVals]=PerformPCA(zscore(DatMatCl));
[val,ind] = sort(EigVect(:,2));
subplot(3,1,1:2)
imagesc([B;B+5000]/1E3,size(DatMatCl,2),DatMatCl(ind,:))
caxis([-3 3])
xlabel('Time to Fz onset(s)')
set(gca,'LineWidth',2,'FontSize',12), box off
subplot(3,1,3)
plot(EigVect(:,1)'*zscore(DatMatCl')')
hold on
plot(EigVect(:,2)'*zscore(DatMatCl')')
set(gca,'LineWidth',2,'FontSize',12), box off
xlabel('Time to Fz onset(s)')
legend('PC1','PC2')

figure
subplot(131)
% ValsToSort = range(DatMatCl(:,OnSetWk)');
% ValsToSort2 = range(DatMatCl(:,OnSetStr)');
[val,ind] = max(abs(DatMatCl(:,OnSetWk)'));
ValsToSort = abs(DatMatCl(sub2ind(size(DatMatCl),[1:size(DatMatCl,1)],OnSetWk(ind))));
[val,ind] = max(abs(DatMatCl(:,OnSetStr)'));
ValsToSort2 = abs(DatMatCl(sub2ind(size(DatMatCl),[1:size(DatMatCl,1)],OnSetStr(ind))));

MakeSpreadAndBoxPlot_SB({ValsToSort,ValsToSort2},{[0.5 0.5 0.5],[1 0.4 0.4]},[1,2],{'Wk','Str'},0)
[p,h] = signrank(ValsToSort,ValsToSort2);
sigstar({{1,2}},p)
title('Onset')

subplot(132)
% ValsToSort = range(DatMatCl(:,OffSetWk)');
% ValsToSort2 = range(DatMatCl(:,OffSetStr)');
[val,ind] = max(abs(DatMatCl(:,OffSetWk)'));
ValsToSort = abs(DatMatCl(sub2ind(size(DatMatCl),[1:size(DatMatCl,1)],OffSetWk(ind))));
[val,ind] = max(abs(DatMatCl(:,OffSetStr)'));
ValsToSort2 = abs(DatMatCl(sub2ind(size(DatMatCl),[1:size(DatMatCl,1)],OffSetStr(ind))));

MakeSpreadAndBoxPlot_SB({ValsToSort,ValsToSort2},{[0.5 0.5 0.5],[1 0.4 0.4]},[1,2],{'Wk','Str'},0)
[p,h] = signrank(ValsToSort,ValsToSort2);
sigstar({{1,2}},p)
title('Offset')

subplot(133)
MeanNoFzLoc = (nanmean(DatMat(:,AllNoFz)'));
MeanFzLoc = (nanmean(DatMat(:,FzWk)'))
MI = (MeanNoFzLoc-MeanFzLoc)./ (MeanNoFzLoc+MeanFzLoc);
MeanFzLoc = (nanmean(DatMat(:,FzStr)'))
MI2 = (MeanNoFzLoc-MeanFzLoc)./ (MeanNoFzLoc+MeanFzLoc);
BadGuys = (abs(MI)>20 |abs(MI2)>20);
MI(BadGuys) = [];
MI2(BadGuys) = [];
MakeSpreadAndBoxPlot_SB({abs(MI),abs(MI2)},{[0.5 0.5 0.5],[1 0.4 0.4]},[1,2],{'Wk','Str'},0)
[p,h] = signrank(MI,MI2);
sigstar({{1,2}},p)
title('Sustained')


figure
subplot(311)
[val,ind] = max(abs(DatMatCl(:,OnSetWk)'));
ValsToSort = DatMatCl(sub2ind(size(DatMatCl),[1:size(DatMatCl,1)],OnSetWk(ind)));
[val,ind] = max(abs(DatMatCl(:,OnSetStr)'));
ValsToSort2 = DatMatCl(sub2ind(size(DatMatCl),[1:size(DatMatCl,1)],OnSetStr(ind)));
sg = sign(ValsToSort);
plot([B;B+5000]/1E3,nanmean(DatMatCl(:,1:250).*sg'))
hold on
sg = sign(ValsToSort2);
plot([B;B+5000]/1E3,nanmean(DatMatCl(:,251:end).*sg'))
plot(AllNoFz*0.04-2.5,AllNoFz*0 + 2.2,'k*')
plot(FzWk*.04-2.5,FzWk*0 + 2.2,'c*')
xlim([-2.5 7.5])
title('Onset')
xlabel('Time to Fz on')
makepretty
legend('Wk4Hz','Str4Hz')

subplot(312)
[val,ind] = max(abs(DatMatCl(:,OffSetWk)'));
ValsToSort = DatMatCl(sub2ind(size(DatMatCl),[1:size(DatMatCl,1)],OffSetWk(ind)));
[val,ind] = max(abs(DatMatCl(:,OffSetStr)'));
ValsToSort2 = DatMatCl(sub2ind(size(DatMatCl),[1:size(DatMatCl,1)],OffSetStr(ind)));
sg = (sign(ValsToSort));
plot([B;B+5000]/1E3,nanmean(DatMatCl(:,1:250).*sg'))
hold on
sg = (sign(ValsToSort2));
plot([B;B+5000]/1E3,nanmean(DatMatCl(:,251:end).*sg'))
plot(AllNoFz*0.04-2.5,AllNoFz*0 + 2.2,'k*')
plot(FzWk*.04-2.5,FzWk*0 + 2.2,'c*')
xlim([-2.5 7.5])
title('Offset')
xlabel('Time to Fz on')
makepretty
legend('Wk4Hz','Str4Hz')

subplot(313)
sg = sign(MI);
plot([B;B+5000]/1E3,nanmean(DatMat(:,1:250).*sg'))
hold on
sg = sign(MI2);
plot([B;B+5000]/1E3,nanmean(DatMat(:,251:end).*sg'))
plot(AllNoFz*0.04-2.5,AllNoFz*0 + 6.5,'k*')
plot(FzWk*.04-2.5,FzWk*0 + 6.5,'c*')
xlim([-2.5 7.5])
title('Offset')
xlabel('Time to Fz on')
makepretty
legend('Wk4Hz','Str4Hz')


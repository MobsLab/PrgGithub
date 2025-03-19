
clear all

cd /media/gruffalo/09E7077B1FE07CCB/ARCHT/ArchT/916/laser_hab


[numNeurons, numtt, TT]=GetSpikesFromStructure('PFCx', 'remove_MUA',1);
load('SpikeData.mat');
%%
load('LFPData/DigInfo9.mat');

StimOn = thresholdIntervals(DigTSD,0.9,'Direction','Above');
StimOff = intervalSet(0,900*1e4)-StimOn;
%%
    for sp = 1:length(numNeurons)
    [Y,X] = hist(Range(S{numNeurons(sp)},'s'),[0:0.1:900]);
    PETHtsd = tsd([0:0.1:900]*1e4,Y');
    
    %subplot(211)
    %plot(X,zscore(Y)), hold on
    %plot(Range(DigTSD,'s'),Data(DigTSD))
    %subplot(212)
    [M,T]=PlotRipRaw(PETHtsd,Start(StimOn,'s'),90000,0,0);
    %plot(M(:,1),M(:,2))
    %TetName(sp) = TT{sp}(1);
    RemResp(sp,:) = M(:,2);
    %line([0 0],ylim,'color','k'),line([45 45],ylim,'color','k')
    FiringOff(sp) = length(Range(Restrict(S{numNeurons(sp)},StimOff)))./sum(Stop(StimOff,'s')-Start(StimOff,'s'));
    FiringOn(sp) = length(Range(Restrict(S{numNeurons(sp)},StimOn)))./sum(Stop(StimOn,'s')-Start(StimOn,'s'));
    
    %FiringOnClose(sp) = length(Range(Restrict(S{numNeurons(sp)},StimOnClose)))./sum(Stop(StimOnClose,'s')-Start(StimOnClose,'s'));
    end
    %%
    

    %%
ModIndx = ((FiringOn-FiringOff)./(FiringOn+FiringOff));
 
%[UnitID,AllParams,WFInfo,figid] = MakeData_ClassifySpikeWaveforms(W,[dropbox '/Kteam'],1);
load('NeuronClassification.mat')

IDint=find(UnitID==-1);
IDpyr=find(UnitID==+1);
unitid=UnitID(numNeurons);
S1=S{IDint};
S2=S{IDpyr};
% figure
% for i=1:length(int)
%     subplot(1,length(int),i), plot(W2{int(i)}'), title(ModIndx(int(i)))
% end
% 
% 
% figure
% for i=1:length(pyr)
%     subplot(1,length(pyr),i), plot(W2{pyr(i)}'), title(ModIndx(pyr(i)))
% end
% 
% 
% a=a+1;
% [C,B]=CrossCorr(Range(S2{pyr(a)}),Range(S2{pyr(a)}),1,100);
% C(B==0)=0;
% figure, plot(B/1E3,C,'k')
% 
% for a=1:length(pyr)
%     for b=1:length(int)
% [C,B]=CrossCorr(Range(S2{pyr(a)}),Range(S2{int(b)}),10,200);
% figure, bar(B/1E3,C,1,'k'), line([0 0],ylim,'color','r'), title([num2str(a), ' ',num2str(b)])
%     end
% end



%%


figure('color',[1 1 1])

a=7; [C,B]=CrossCorr(Start(StimOn),Range(S2{pyr(a)}),2000,200);
subplot(3,2,2), bar(B/1E3,C,1,'k'), line([0 0],ylim,'color','r'), title(['Pyr ',num2str(a)]), xlim([-45 200])
line([45 45],ylim,'color',[0.7 0.7 0.7])

a=6; 
%a=3; 
[C,B]=CrossCorr(Start(StimOn),Range(S2{pyr(a)}),2000,200);
subplot(3,2,4), bar(B/1E3,C,1,'k'), line([0 0],ylim,'color','r'), title(['Pyr ',num2str(a)]), xlim([-45 200])
line([45 45],ylim,'color',[0.7 0.7 0.7])

a=2;
[C,B]=CrossCorr(Start(StimOn),Range(S2{int(a)}),2000,200);
subplot(3,2,6), bar(B/1E3,C,1,'k'), line([0 0],ylim,'color','r'), title(['Int ',num2str(a)]), xlim([-45 200])
ylim([0 2.5])
line([45 45],ylim,'color',[0.7 0.7 0.7])

subplot(3,2,[1 3 5]), PlotErrorBar2(ModIndx(unitid==1),ModIndx(unitid==-1),0)
ylabel('modulation by laser')
xticklabels({'Pyr','Int'})
xticks([1:2])

%%
a=7;
[C,B]=CrossCorr(Start(StimOn),Range(S2{IDpyr(a)}),2000,200);
subplot(3,2,2), bar(B/1E3,C,1,'k'), line([0 0],ylim,'color','r'), title(['Pyr ',num2str(a)]), xlim([-45 200])
line([45 45],ylim,'color',[0.7 0.7 0.7])

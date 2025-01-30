clear all
load('SleepSubstages.mat')
load('SpikeData.mat')
load('DownState.mat')
load('LFPData/LFP1.mat')

[numNeurons, numtt, TT] = GetSpikesFromStructure('PFCx','remove_MUA',1);
% S = tsdArray(S);
S = S(numNeurons);
if ~isa(S,'tsdArray')
    S = tsdArray(S);
end
Q = MakeQfromS(S,2*1e4);
% AllTime = tsd(Range(LFP),[1:length(Range(LFP))]');
% timeDown = Data(Restrict(AllTime,down_PFCx));
% AllTime = Data(AllTime)*0+1;
% AllTime(timeDown) = 0;
% out=DownSampleByBlocks(tsd(Range(LFP),AllTime),2,'mean')
% out = Restrict(out,ts(Range(Q)));
% DatQ = Data(Q);
% for sp = 1:length(numNeurons)
%     DatQ(:,sp) = DatQ(:,sp).*Data(out);
% end
% Q = tsd(Range(Q),DatQ);

clear Vals
Vals.N1 = Data(Restrict(Q,Epoch{1}));
Vals.N2 = Data(Restrict(Q,Epoch{2}));
Vals.N3 = Data(Restrict(Q,Epoch{3}));
Vals.REM = Data(Restrict(Q,Epoch{4}));
Vals.Wake = Data(Restrict(Q,Epoch{5}));
fields = fieldnames(Vals);
cols = lines(5);
Vect1 = full(nanmean(Vals.N1(1:end/2,:))-nanmean(Vals.Wake(1:end/2,:)));
Vect2 = full(nanmean(Vals.N1(1:end/2,:))-nanmean(Vals.N3(1:end/2,:)));

figure, hold on

for ff = 1:5
    Proj1 = full(Vals.(fields{ff})(end/2:end,:)*Vect1');
    Proj2 = full(Vals.(fields{ff})(end/2:end,:)*Vect2');
    subplot(3,3,[1,4])
    [Y,X] = hist(Proj2,100);
    stairs(Y/sum(Y),X,'LineWidth',3,'color',cols(ff,:)), hold on
    subplot(3,3,[8,9])
    [Y,X] = hist(Proj1,100);
    stairs(X,Y/sum(Y),'LineWidth',3,'color',cols(ff,:)), hold on
    subplot(3,3,[2,3,5,6])
    
    distances = tsd(1:length(Proj1),(Proj1 - nanmean(Proj1)).^2 + (Proj2 - nanmean(Proj2)).^2);
    Proj1 = tsd(1:length(Proj1),Proj1);
    Proj2 = tsd(1:length(Proj2),Proj2);
    %     for thres = 0.8:-0.1:0.4
    thres = 0.5;
    threshold = percentile(Data(distances),thres);
    SubEpoch = thresholdIntervals(distances,threshold,'Direction','Below');
    Proj1sub = Data(Restrict(Proj1,SubEpoch));
    Proj2sub = Data(Restrict(Proj2,SubEpoch));
    
    K=convhull(Proj1sub,Proj2sub);
    plot(Proj1sub(K),Proj2sub(K),'LineWidth',3,'color',cols(ff,:)), hold on
    %         P = patch(Proj1sub(K),Proj2sub(K),cols(ff,:));hold on
    %         set(P,'FaceAlpha',0.3)
    %         set(P,'EdgeColor','none')
    %
    %     end
end
legend(fields)



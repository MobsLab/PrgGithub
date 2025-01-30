clear MeanResp
Stim = [62,82,102];
for m =1:14
cd(Dir.path{m})
clear MovAcctsd
load('behavResources.mat')
[M,T] = PlotRipRaw(MovAcctsd,Stim',20000);
MeanResp(m,:) = M(:,2);
[M2,T] = PlotRipRaw(MovAcctsd,Stim'+80,20000);
MeanRespRand(m,:) = M2(:,2);

end
close all
figure
subplot(211)
shadedErrorBar(M(:,1),runmean(mean(MeanResp(1:7,:)),5),runmean(stdError(MeanResp(1:7,:)),5))
subplot(212)
shadedErrorBar(M(:,1),runmean(mean(MeanResp(8:14,:)),5),runmean(stdError(MeanResp(8:14,:)),5))
subplot(211)
shadedErrorBar(M(:,1),runmean(mean(MeanRespRand(1:7,:)),5),runmean(stdError(MeanRespRand(1:7,:)),5))
subplot(212)
shadedErrorBar(M(:,1),runmean(mean(MeanRespRand(8:14,:)),5),runmean(stdError(MeanRespRand(8:14,:)),5))

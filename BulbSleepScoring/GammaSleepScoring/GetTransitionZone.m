function GetTransitionZone(Var,Val,jtouse,suffix,threshold,MatX,MatY,SWSEpoch)

%% INPUTS
% Var is the parameter to use, smooth_ghi or EMGData
% Val comes from MakeTransitionMaps
% jtouse indicate which value of time to use for defining transition epochs

temp=nanmean(Val{jtouse}');
[C,I]=min(temp(20:80));
I=I+19;
%  Lim2=ceil(0.2/mean(diff(MatX)))+I;
%  Lim1=I-ceil(0.2/mean(diff(MatX)));

Lim2=find(temp(I:end)>(1+C)/2,1,'first')+I+1;
Lim1=find(temp(1:I)>(1+C)/2,1,'last');

% Make a figure with transition map and definition of transition zone
fig=figure;
subplot(3,1,1:2)
imagesc(MatX,MatY,Val{jtouse}')
axis xy
subplot(3,1,3)
plot(MatX(1:end-1),(temp))
hold on
plot(MatX(Lim1),temp(Lim1),'*r')
plot(MatX(Lim2),temp(Lim2),'*r')
line([log(threshold)-nanmean(log(Data(Restrict(Var,SWSEpoch)))) log(threshold)-nanmean(log(Data(Restrict(Var,SWSEpoch))))],[get(gca,'Ylim')])
xlim([min(MatX) max(MatX)])
saveas(fig,['TransitionFig',suffix,'.eps'])
saveas(fig,['TransitionFig',suffix,'.fig'])


%Define Transition Epochs NO temporal constraints
X1=exp(MatX(Lim1)+nanmean(log(Data(Restrict(Var,SWSEpoch)))));
X2=exp(MatX(Lim2)+nanmean(log(Data(Restrict(Var,SWSEpoch)))));
TransitionEpoch1=thresholdIntervals(Var,X1,'Direction','Above');
TransitionEpoch2=thresholdIntervals(Var,X2,'Direction','Below');
TransitionEpoch=and(TransitionEpoch1,TransitionEpoch2);

%Define Transition types, 1 second constraint
StartType=[];
StopType=[];
strt=Start(TransitionEpoch);
stp=Stop(TransitionEpoch);
for k=1:length(Start(TransitionEpoch))
    StartType(k)=Data(Restrict(Var,strt(k)))>threshold;
    StopType(k)=Data(Restrict(Var,stp(k)))>threshold;
end

% Create epochs with the 4 types
AbortTrans{1}=mergeCloseIntervals((subset(TransitionEpoch,(intersect(find(StartType==1),find(StopType==1))))),1e4); % WW
AbortTrans{2}=mergeCloseIntervals((subset(TransitionEpoch,(intersect(find(StartType==0),find(StopType==1))))),1e4); %SW
AbortTrans{3}=mergeCloseIntervals((subset(TransitionEpoch,(intersect(find(StartType==1),find(StopType==0))))),1e4); % WS
AbortTrans{4}=mergeCloseIntervals((subset(TransitionEpoch,(intersect(find(StartType==0),find(StopType==0))))),1e4); % SS

save(strcat('TransLims',suffix,'.mat'),'X1','X2','TransitionEpoch','AbortTrans')
end


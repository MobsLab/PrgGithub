function [idx,neurons]=RasterPlotKarimDetail(h,p,neurons,centername,TStart,TEnd,fenetre,synchro)

% h voie hippocampe
% p voie Pfc
%
% if centername='all' on prend tous les neurones
% if center name ='kappa' on ne montre que les neurons modul?? par thetaet avec un kappa superieur ?? 0.1
%
%
%
%

try 
eval(['load DataFinalUnSat EEG',num2str(h), ' EEG',num2str(p)])
fichier='DataFinalUnSat';
catch 	try 
eval(['load Data0507 EEG',num2str(h), ' EEG',num2str(p)])
fichier='Data0507';
catch	try 
eval(['load DataFinal EEG',num2str(h), ' EEG',num2str(p)])
fichier='DataFinal';
end
end
end

eval(['EEGp=EEG',num2str(p),';'])
eval(['EEGh=EEG', num2str(h),';'])

load SpikeData
load behavResources
st=Range(startTrial{1}); to=Range(trialOutcome{1});
mazeEpoch=intervalSet(st(1),to(end));

eval(['center=',centername,';'])
try
if neurons=='all'
neurons=[1:length(S)];
end
end

try
if neurons=='theta'
neurons=[1:length(S)];
neuronsname='theta';
end
end


try
if neurons=='kappa'
neurons=[1:length(S)];
neuronsname='kappa';
end
end

movingwin=[fenetre,0.01];
params.trialave = 0;
params.err = [1 0.05];

fp1=4;
fp2=12;
params.fpass = [fp1 fp2];

params.Fs = 1/median(diff(Range(Restrict(EEGh,mazeEpoch), 's')));
params.tapers=[3 5];
params.pad=0;

Height=1;
BarFraction=0.8;
LineWidth=2;

center=ts(center);

TStart=TStart*10000;
TEnd=TEnd*10000;

%-------------------------------------------------------------------------------------------

load ThetaModulation
ModTheta=max(modTheta')';
ProbaTheta=min(probaTheta')';

Epoch= intervalSet(Range(center)-50000, Range(center)+50000);

EEGp=Restrict(EEGp,Epoch);
EEGh=Restrict(EEGh,Restrict(EEGp,Epoch));

[C,phi,Sph,Sp,Sh,t,f,confC,phierr]=cohgramc(Data(EEGp),Data(EEGh),movingwin,params);
%  [C,phi,Sph,Sp,Sh,t,f,confC,phierr]=cohgramc(Data(Restrict(EEGp,Restrict(EEGh,Epoch))),Data(Restrict(EEGh,Epoch)),movingwin,params);

is = intervalSet(Range(center)+TStart, Range(center)+TEnd);
EEGp=Restrict(EEGp,is);
EEGh=Restrict(EEGh,Restrict(EEGp,is));

EEGhf=FilterRythm(EEGh,'theta');
EEGpf=FilterRythm(EEGp,'theta');


try
if neuronsname=='theta'
neurons=neurons(find(ProbaTheta(neurons)<0.05));
end
end


try
if neuronsname=='kappa'
neurons=neurons(find(ProbaTheta(neurons)<0.05&ModTheta(neurons)>0.1));
end
end

%-----------------------------------------------------------------------------------------------------------------------------------------------------------------

try 
eval(['load DataFinalUnSat CoherenceThetaTsd',num2str(h), num2str(p)])
catch 	try 
eval(['load Data0507 CoherenceThetaTsd',num2str(h), num2str(p)])
catch	try 
eval(['load DataFinal CoherenceThetaTsd',num2str(h), num2str(p)])
end
end
end

eval(['Coherence=CoherenceThetaTsd', num2str(h),num2str(p),';'])

seuilT=0.7;
HighCoh = thresholdIntervals(Coherence, seuilT, 'Direction','Above');
HighCohM=mergeCloseIntervals(HighCoh,2000);
HighCohMd=dropShortIntervals(HighCohM,1000);


[sigHiCo, sigLoCo,nbBinsHiCo,nbBinsLoCo,QHiCo,rHiCo,QLoCo,rLoCo,pc1]=PCACellAssemblyPPC(S(neurons),is,synchro,[1,2]);

figure,
%  subplot(4,1,3),hold on, plot((Range(QHiCo,'s')-Start(is,'s')+TStart/10000)*1000,rHiCo,'r')

subplot(3,1,2),hold on, plot((Range(QHiCo,'s')-Start(is,'s')+TStart/10000)*1000,rHiCo,'k','lineWidth',3)

%  subplot(4,1,3),hold on, plot((Range(QLoCo,'s')-Start(is,'s')+TStart/10000)*1000,rLoCo,'b'), title('First PC (red), second PC (blue)'), 
x=xlim(gca); axis([x,-5 max(max(rLoCo),max(rHiCo))])

%-----------------------------------------------------------------------------------------------------------------------------------------------------------------


%  [B,idx]=sort(ModTheta(neurons),'descend');
[B,idx]=sort(pc1,'descend');


%  subplot(4,1,2), hold on,plot((Range(EEGhf,'s')-Start(is,'s')+TStart/10000)*1000,Data(EEGhf)*(length(neurons)/2/max(max(Data(EEGhf))))+length(neurons)/2,'r','linewidth',1); 

a=1;

for n=neurons(idx)
	sweeps = intervalSplit(S{n}, is, 'OffsetStart', TStart);
	sp = Range(sweeps{1}, 'ms');
	sx = [sp sp repmat(NaN, length(sp), 1)];
	sy = repmat([(a*Height) (a*Height + Height *BarFraction) NaN], length(sp), 1);
	sx = reshape(sx', 1, length(sp)*3);
	sy = reshape(sy', 1, length(sp)*3);
%  	subplot(4,1,2), hold on, subplot(4,1,1), line(sx, sy, 'Color', 'k', 'LineWidth', LineWidth);

	subplot(3,1,1), hold on, subplot(3,1,1), line(sx, sy, 'Color', 'k', 'LineWidth', LineWidth);

	set(gca, 'ylim', [1 length(neurons)+1]);
	hold on
	clear sweeps
	
	a=a+1;
end
subplot(3,1,1), y=ylim(gca);
%  subplot(4,1,2), y=ylim(gca);
axis([TStart/10 TEnd/10 y])

%  subplot(4,1,1), hold on,plot((Range(EEGpf,'s')-Start(is,'s')+TStart/10000)*1000,Data(EEGpf)*(length(neurons)/2/max(max(Data(EEGpf))))+length(neurons)/2,'b','linewidth',1); 

%  a=1;
%  
%  for n=neurons(idx)
%  	sweeps = intervalSplit(S{n}, is, 'OffsetStart', TStart);
%  	sp = Range(sweeps{1}, 'ms');
%  	sx = [sp sp repmat(NaN, length(sp), 1)];
%  	sy = repmat([(a*Height) (a*Height + Height *BarFraction) NaN], length(sp), 1);
%  	sx = reshape(sx', 1, length(sp)*3);
%  	sy = reshape(sy', 1, length(sp)*3);
%  	subplot(4,1,1),hold on, subplot(4,1,2),line(sx, sy, 'Color', 'k', 'LineWidth', LineWidth);
%  	set(gca, 'ylim', [1 length(neurons)+1]);
%  	hold on
%  	clear sweeps
%  	
%  	a=a+1;
%  end
%  subplot(4,1,1), y=ylim(gca); axis([TStart/10 TEnd/10 y])
%  
%  subplot(4,1,1),set(gca, 'TickLength',[0,0])
%  subplot(4,1,2),set(gca, 'TickLength',[0,0])
subplot(3,1,1),set(gca, 'TickLength',[0,0])

%  subplot(4,1,4), imagesc(t(t>5+TStart/10000&t<5+TEnd/10000)-5,f,Smooth(C(t>5+TStart/10000&t<5+TEnd/10000,:),[1,1])'),axis xy, caxis([0,1])
subplot(3,1,3), imagesc(t(t>5+TStart/10000&t<5+TEnd/10000)-5,f,Smooth(C(t>5+TStart/10000&t<5+TEnd/10000,:),[1,1])'),axis xy, caxis([0,1])


%  keyboard
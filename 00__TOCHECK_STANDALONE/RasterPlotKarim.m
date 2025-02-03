function RasterPlotKarim(h,p,neurons,centername,TStart,TEnd,fenetre)

%
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
if neurons=='kappa'
neurons=[1:length(S)];
neuronsname='kappa';
end
end

movingwin=[fenetre,0.01];
params.trialave = 0;
params.err = [1 0.05];

fp1=4;
fp2=15;
params.fpass = [fp1 fp2];

params.Fs = 1/median(diff(Range(Restrict(EEGh,mazeEpoch), 's')));
params.tapers=[3 5];
params.pad=0;

Height=1;
BarFraction=0.8;
LineWidth=1;

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

neurons=neurons(find(ProbaTheta(neurons)<0.05));

try
if neuronsname=='kappa'
neurons=neurons(find(ModTheta(neurons)>0.1));
end
end

[B,idx]=sort(ModTheta(neurons),'descend');

%  figure(1),clf

figure('Position',[1,700,1000,900])
a=1;

for n=neurons(idx)
	sweeps = intervalSplit(S{n}, is, 'OffsetStart', TStart);
	sp = Range(sweeps{1}, 'ms');
	sx = [sp sp repmat(NaN, length(sp), 1)];
	sy = repmat([(a*Height) (a*Height + Height *BarFraction) NaN], length(sp), 1);
	sx = reshape(sx', 1, length(sp)*3);
	sy = reshape(sy', 1, length(sp)*3);
	hold on, subplot(8,1,[1:3]), hold on, line(sx, sy, 'Color', 'k', 'LineWidth', LineWidth);set(gca, 'TickLength',[0,0])
	set(gca, 'ylim', [1 length(neurons)+1]);
	hold on
	clear sweeps
	
	a=a+1;
end
subplot(8,1,[1:3]),title(centername)
subplot(8,1,4), hold on, plot(Range(EEGpf,'s')-Start(is,'s')+TStart/10000,Data(EEGpf)*4,'linewidth',2), title('Pfc (blue) Hpc (red)')
subplot(8,1,4), hold on, plot(Range(EEGhf,'s')-Start(is,'s')+TStart/10000,Data(EEGhf)*2,'r','linewidth',2); axis([TStart/10000 TEnd/10000 min(min(Data(EEGhf)*2),min(Data(EEGpf)*4)) max(max(Data(EEGhf)*2),max(Data(EEGpf)*4))]), y=ylim(gca);

sts=Range(startTrial{1},'s');
tos=Range(trialOutcome{1},'s');

tpsSt=sts-Start(is,'s')+TStart/10000;
tpsTo=tos-Start(is,'s')+TStart/10000;

tpsSt=sign(tpsSt(find(abs(tpsSt)==min(abs(tpsSt)))))*min(abs(tpsSt));
tpsTo=sign(tpsTo(find(abs(tpsTo)==min(abs(tpsTo)))))*min(abs(tpsTo));

subplot(8,1,4), hold on, line([tpsSt tpsSt],y,'Color','b') ; 
subplot(8,1,4), hold on, line([tpsTo tpsTo],y,'Color','k') 


subplot(8,1,5), imagesc(t(t>5+TStart/10000&t<5+TEnd/10000)-5,f,Smooth(C(t>5+TStart/10000&t<5+TEnd/10000,:),[1,1])'),axis xy, caxis([0,1])
subplot(8,1,6), imagesc(t(t>5+TStart/10000&t<5+TEnd/10000)-5,f,Smooth(phi(t>5+TStart/10000&t<5+TEnd/10000,:),[1,1])'),axis xy, caxis([-3.14,3.14])

subplot(8,1,7), imagesc(t(t>5+TStart/10000&t<5+TEnd/10000)-5,f,Smooth(log(Sp(t>5+TStart/10000&t<5+TEnd/10000,:)+eps)',[0.5 0.5])),axis xy
subplot(8,1,8), imagesc(t(t>5+TStart/10000&t<5+TEnd/10000)-5,f,Smooth(log(Sh(t>5+TStart/10000&t<5+TEnd/10000,:)+eps)',[0.5 0.5])),axis xy

%  figure(2),clf
figure('Position',[1015,1000,500,400])
subplot(4,1,[1:3]), plot(Data(Restrict(XS{1},mazeEpoch)),Data(Restrict(YS{1},mazeEpoch)))
subplot(4,1,[1:3]), hold on, plot(Data(Restrict(XS{1},is)),Data(Restrict(YS{1},is)),'or','linewidth',5)

subplot(4,1,4),plot(Range(EEGp,'s')-Start(is,'s')+TStart/10000,Data(EEGp)*4,'linewidth',1)
subplot(4,1,4), hold on, plot(Range(EEGh,'s')-Start(is,'s')+TStart/10000,Data(EEGh)*2+2,'r','linewidth',1); axis([TStart/10000 TEnd/10000 min(min(Data(EEGh)*2+2),min(Data(EEGp)*4)) max(max(Data(EEGh)*2+2),max(Data(EEGp)*4))])



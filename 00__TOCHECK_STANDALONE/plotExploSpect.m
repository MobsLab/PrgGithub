function plotExploSpect(LFP,ch1,ch2,Fh,tapers,mov,debut,interval,Co)

clf

smoo=3;

try 
    Co;
    
catch
    
for i=1:length(LFP)
    
    Co{i}='k';
end
end

EpochSpec=intervalSet(debut*1E4,(debut+interval)*1E4);

EEGsleep=Restrict(LFP,EpochSpec);

if length(tapers)==1
params.tapers=[tapers max(floor(tapers*2-1),2)];
else
params.tapers=tapers;
    
end
% Fh=150;
params.Fs =1/median(diff(Range(LFP{1},'s')));
params.fpass = [0 Fh];
params.err = [1, 0.95];
params.trialave = 0;
if length(mov)==1
movingwin = [mov, mov/100];
else
movingwin = [mov(1) mov(2)]
end


params.pad=1;

% [S1,t1,f1,Serr1]=mtspecgramc(Data(EEGsleep{ch1}),movingwin,params);
% [S2,t2,f2,Serr2]=mtspecgramc(Data(EEGsleep{ch2}),movingwin,params);

%[C,phi,S12,S1,S2,t,f,confC,phistd]=cohgramc(Data(EEGsleep{ch1}),Data(EEGsleep{ch2}),movingwin,params);
[C,phi,S12,S1,S2,t,f]=cohgramc(Data(EEGsleep{ch1}),Data(EEGsleep{ch2}),movingwin,params);

params2=params;
%--------------------------------------------------------------------------
%params2.tapers=[5 9];
params2.tapers=[10 19];
 % params2.tapers=[tapers(1)*3 tapers(1)*6-1];
params2.pad=4;
%--------------------------------------------------------------------------
% [S1b,f1b,Serr1b]=mtspectrumc(Data(EEGsleep{ch1}),params2);
% [S2b,f2b,Serr2b]=mtspectrumc(Data(EEGsleep{ch2}),params2);

%[Cb,phi,S12,S1b,S2b,fb,confC,phistd]=coherencyc(Data(EEGsleep{ch1}),Data(EEGsleep{ch2}),params2);
[Cb,phi,S12,S1b,S2b,fb]=coherencyc(Data(EEGsleep{ch1}),Data(EEGsleep{ch2}),params2);

fac=1;
subplot(4,5,[1:2]),hold on
imagesc(t+Start(EpochSpec,'s'),f,SmoothDec(C',[smoo,smoo])), axis xy, ylim([0 Fh]), caxis([0 1])

subplot(4,5,6),hold on
plot(10*log10(f),mean(C),'k','linewidth',1), 
plot(10*log10(fb),(Cb),'r','linewidth',1), 
xlim([-5 max(10*log10(f))])

subplot(4,5,7),hold on
plot(f,mean(C),'k','linewidth',1), 
plot(fb,(Cb),'r','linewidth',1), 
xlim([0 Fh])

subplot(4,5,[3,4,5,8,9,10]),hold on

										   
%for i=1:length(EEGsleep)
%	plot(Range(EEGsleep{i},'s'),fac*Data(EEGsleep{i})/1000+fac*i+fac*2.5,'color',Co{i})
%end
%plot(Range(EEGsleep{ch1},'s'),fac*Data(EEGsleep{ch1})/1000+fac*ch1+fac*2.5,'color',Co{ch1},'linewidth',2)
%plot(Range(EEGsleep{ch2},'s'),fac*Data(EEGsleep{ch2})/1000+fac*ch2+fac*2.5,'color',Co{ch2},'linewidth',2)

for i=1:length(EEGsleep)
plot(Range(EEGsleep{i},'s'),fac*rescale(Data(EEGsleep{i}),0,1)+fac*i+fac*2.5,'color',Co{i})
end
										   
plot(Range(EEGsleep{ch1},'s'),fac*rescale(Data(EEGsleep{ch1}),0,1)+fac*ch1+fac*2.5,'color',Co{ch1},'linewidth',2)
plot(Range(EEGsleep{ch2},'s'),fac*rescale(Data(EEGsleep{ch2}),0,1)+fac*ch2+fac*2.5,'color',Co{ch2},'linewidth',2)
										   
										   
xlim([Start(EpochSpec,'s') End(EpochSpec,'s')])
ylim([0 length(LFP)+5])
   
    
subplot(4,5,11), hold on,
plot(10*log10(f),mean(10*log10(S1)),'k','linewidth',1), 
plot(10*log10(fb),(10*log10(S1b)),'r','linewidth',1), 
xlim([-5 max(10*log10(f))]), ylabel(['channel ',num2str(ch1)])

subplot(4,5,12), hold on
plot(f, mean(10*log10(S1)),'k','linewidth',1), xlim([0 Fh])
plot(fb,(10*log10(S1b)),'r','linewidth',1), xlim([0 Fh])

subplot(4,5,13:15),hold on
imagesc(t+Start(EpochSpec,'s'),f,10*log10(S1')), axis xy, ylim([0 Fh]), xlim([Start(EpochSpec,'s') End(EpochSpec,'s')])


subplot(4,5,16), hold on
plot(10*log10(f),mean(10*log10(S2)),'k','linewidth',1)
plot(10*log10(fb),(10*log10(S2b)),'r','linewidth',1), 
xlim([-5 max(10*log10(f))]), ylabel(['channel ',num2str(ch2)])
subplot(4,5,17), hold on
plot(f, mean(10*log10(S2)),'k','linewidth',1), xlim([0 Fh])
plot(fb,(10*log10(S2b)),'r','linewidth',1), xlim([0 Fh])
subplot(4,5,18:20),hold on
imagesc(t+Start(EpochSpec,'s'),f,10*log10(S2')), axis xy, ylim([0 Fh]), xlim([Start(EpochSpec,'s') End(EpochSpec,'s')])



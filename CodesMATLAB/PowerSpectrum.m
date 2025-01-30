% function PowerSpectrum

try
load Data
end

voie=2;
Fup=0.1;
limitF=5/data(end,1);

Fpass=[limitF 60];
% Fpass=[0 0.5];
try
    chF;
catch
    
chF=100;
end

resamp=10000/chF;


Y=resample(data(:,voie),1,resamp);

% Y=smooth(Y,3);
Y=Y(20:end-20);

params.Fs=10000/resamp;
params.pad=3;

params.tapers=[3 5];
% params.tapers=[2 3];

params.fpass = Fpass;
params.trialave = 0;
params.err = [1 0.05];

tps=[0:length(Y)-1]/params.Fs;

% Y=sin(2*pi*30*tps)'+randn(length(tps),1);

if length(Y)>5E4
[S,f]=mtspectrumc(Y(1:5E4),params);
else
[S,f]=mtspectrumc(Y,params);
end

Fpass2=[limitF Fup];
params.fpass = Fpass2;
if length(Y)>5E4
[S2,f2]=mtspectrumc(Y(1:5E4),params);
else
[S2,f2]=mtspectrumc(Y,params);
end



figure('Color',[1 1 1])
subplot(7,1,1), plot(tps,Y), title(['Frequency: ',num2str(params.Fs),'Hz. Limite Inf: ',num2str(limitF)])
subplot(7,1,2), plot(f,S)
subplot(7,1,3), plot(f,f'.*S)
subplot(7,1,4), plot(f2,SmoothDec(f2'.*S2,3),'r','linewidth',2), xlim([0 Fup]), ca=ylim;
subplot(7,1,5), plot(f,log(S))
subplot(7,1,6), plot(log(f),S)
subplot(7,1,7), plot(log(f),log(S))
m=50;
movingwin=[m,5];
[S3,t3,f3]=mtspecgramc(Y,movingwin,params);        
figure('Color',[1 1 1])
subplot(3,1,1), plot(tps,Y,'k')
xlim([tps(1)+m tps(end)-m])
% imagesc(t3,f3,log(S3)'), axis xy
F3=ones(size(S3,1),1)*f3;

S3p=F3'.*S3';
S3p=SmoothDec(S3p,[3,4]);

subplot(3,1,[2:3]),imagesc(t3,f3,S3p), axis xy
% caxis(ca/2)
% caxis(ca)
xlim([tps(1)+m tps(end)-m])

%  figure, hist(Y(10:end-10),100)
% 
% h=hist(Y,[-85:0.1:-50]);
% 
% 
%         Fpass=[0.05 2.5];
%         movingwin=[50,5];
%         
%         params.trialave = 0;
%         params.err = [1 0.05];
%         params.tapers=[10 19];
%         params.pad=0;
%         params.Fs=100;
%         params.fpass=Fpass;
%         
%         [Spect,freq]=mtspectrumc(yy,params);
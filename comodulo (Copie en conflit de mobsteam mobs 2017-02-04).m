function [VFreq0,VFreq1,Comodulo]=comodulo(LFPi,LFPo,rgFreq,plo)

% [VFreq0,VFreq1,Comodulo]=comodulo(LFPi,LFPo,rgFreq)
% rgFreq=[Fdeb Ffin]; frequence en x

try
    plo;
catch
    plo=1;
end

tic

% clear all
% close all

%% Signal Generation
% periods=50;
% 
% 
% %fech=300;
% 
% 
% fp=5;
% Afp=1;
% 
% fa1=80;
% Afa1=0.1;
% fa2=100;
% Afa2=0.2;
% 
% ANoise=0.1;
% 
% VTime=(0:1/fech:periods/fp);
% SgnTheta=sin(2*pi*fp*VTime);
% Sgnfa1=Afa1*sin(2*pi*fa1*VTime).*(0.5*(SgnTheta+1));
% Sgnfa2=Afa2*sin(2*pi*fa2*VTime).*(0.5*(SgnTheta+1));
% Noise=ANoise*randn(size(SgnTheta));
% Sgn=SgnTheta+Sgnfa1+Sgnfa2+Noise;

%clear SgnTheta Sgnfa1 Sgnfa2

fech=1/median(diff(Range(LFPi,'s')));
VTime=Range(LFPi,'s');
Sgn=Data(LFPi)';

try
    LFPo;
catch
    LFPo=LFPi;
end

fechO=1/median(diff(Range(LFPo,'s')));
VTimeO=Range(LFPo,'s');
SgnO=Data(LFPo)';

% 
% figure(1);
% plot(VTime,Sgn);

% figure(2);
% plot(VTime, Sgnfa2);

%% MI
leng=size(Sgn,2);
NFFT=2^nextpow2(leng);
NFFT=leng;

densityf=fech/NFFT;  % Hz/case
TFSgn=fft(Sgn,NFFT);
TFSgn_display=fftshift(TFSgn);

TFSgnO=fft(SgnO,NFFT);
TFSgnO_display=fftshift(TFSgnO);


VFreq=fech/2*(linspace(-1,1,NFFT));
% 
% figure(3);
% plot(VFreq,abs(TFSgn));

%% Control panel
%filter0
try
    rgFreq;
debut0=rgFreq(1);
fin0=rgFreq(2);
catch
debut0=4;
fin0=11;
end

pas0=0.5;
largeur0=1.5;

%filter1
% debut1=10;
% fin1=140;

debut1=5;
fin1=80;


pas1=2; %5
largeur1=6; %Conseil! superieur a deux fois de la frequence modulante

%% treatment 
fin0=debut0+pas0*(ceil((fin0-debut0)/pas0));
fin1=debut1+pas1*(ceil((fin1-debut1)/pas1));

Comodulo=3*ones((fin1-debut1)/pas1+1,(fin0-debut0)/pas0+1);
count0=0;
count1=0;


%% MI looping
for filter0center=debut0:pas0:fin0
    count0=count0+1;
    count1=0;
%% filter0
%filter0 construction
filter0width=largeur0;
filter0semiwidth=filter0width/2;

%indice finding
indice_filter0center=round(filter0center/densityf);
indice_filter0semiwidth=round(filter0semiwidth/densityf);

Filter0=zeros(1,NFFT);
Filter0(indice_filter0center-indice_filter0semiwidth:indice_filter0center+indice_filter0semiwidth)=ones(1,indice_filter0semiwidth*2+1);
Filter0(NFFT-(indice_filter0center+indice_filter0semiwidth-1):NFFT-(indice_filter0center-indice_filter0semiwidth-1))=ones(1,indice_filter0semiwidth*2+1);

% figure(4);
% plot(VFreq,Filter0);

%filtering
TFSgnFiltre0=TFSgn.*Filter0;
SgnFiltre0=real(ifft(TFSgnFiltre0));

% figure(5);
% plot(abs(TFSgnFiltre0));
% 
% figure(6);
% plot(VTime,SgnFiltre0);

for filter1center=debut1:pas1:fin1
    count1=count1+1;
%% filter1
%filter1 construction

filter1width=largeur1;
filter1semiwidth=filter1width/2;

%index finding
indice_filter1center=round(filter1center/densityf);
indice_filter1semiwidth=round(filter1semiwidth/densityf);

Filter1=zeros(1,NFFT);
Filter1(indice_filter1center-indice_filter1semiwidth:indice_filter1center+indice_filter1semiwidth)=ones(1,indice_filter1semiwidth*2+1);
Filter1(NFFT-(indice_filter1center+indice_filter1semiwidth-1):NFFT-(indice_filter1center-indice_filter1semiwidth-1))=ones(1,indice_filter1semiwidth*2+1);

% figure(7);
% plot(VFreq,Filter1);

%filtering
TFSgnFiltre1=TFSgnO.*Filter1;
SgnFiltre1=real(ifft(TFSgnFiltre1));

% figure(8);
% plot(VTime,SgnFiltre1);

%% Hilbert
PhaseTheta=angle(hilbert(SgnFiltre0))*180/pi+180;
AmpSgn1=abs(hilbert(SgnFiltre1));
% figure(9);
% plot(VTime,PhaseTheta);
% hold on
% plot(VTime,SgnFiltre0);
% title(['SgnFiltre0(Theta), filter center=',num2str(filter0center),'Hz']);
% hold off
% 
% figure(10);
% plot(VTime,AmpSgn1);
% hold on 
% plot(VTime,SgnFiltre1);
% title(['SgnFiltre1, filter center=',num2str(filter1center),'Hz']);
% hold off

N=18;
interval=360/N;
BinnedPhase=floor(PhaseTheta/interval)+1;
VBinnedPhase=[interval/2:interval:360-interval/2];
for i=1:N
    P(i)=mean(AmpSgn1(find(BinnedPhase==i)));
end
%normalisation
P=P/sum(P);
%display
% figure(11);
% bar(VBinnedPhase,P);

%MI calculation
U=ones(1,N);
U=U/sum(U);
Dkl=0;
for i=1:N
    Dkl=Dkl+P(i)*log(P(i)/U(i));
end
MI=Dkl/log(N);
Comodulo(count1,count0)=MI;
end
end

%% display

VFreq0=[debut0:pas0:fin0];
VFreq1=[debut1:pas1:fin1];

if plo==1
    
figure('color',[1 1 1])
% contourf(VFreq0,VFreq1,Comodulo,'linestyle','none'); colorbar;
contourf(VFreq0,VFreq1,SmoothDec(Comodulo,[1 1]),[min(min(Comodulo)):(max(max(Comodulo))-min(min(Comodulo)))/50:max(max(Comodulo))],'linestyle','none'), axis xy
title('Comodulogramme');
xlabel('Phase Frequency(Hz), modulating');
ylabel('Amplitude Frequency(Hz), modulated');
% 
% subplot(1,2,2), contourf(VFreq0,VFreq1,log(Comodulo),'linestyle','none'); colorbar;
% 
% title('Comodulogramme (log scale)');
% xlabel('Phase Frequency(Hz), modulating');
% ylabel('Amplitude Frequency(Hz), modulated');


elseif plo==2
    
figure('color',[1 1 1])
% contourf(VFreq0,VFreq1,Comodulo,'linestyle','none'); colorbar;
subplot(2,2,1), contourf(VFreq0,VFreq1,SmoothDec(Comodulo,[1 1]),[min(min(Comodulo)):(max(max(Comodulo))-min(min(Comodulo)))/50:max(max(Comodulo))],'linestyle','none'), axis xy
xlabel('Phase Frequency(Hz), modulating');
ylabel('Amplitude Frequency(Hz), modulated');
title('Comodulogramme');
subplot(2,2,2), imagesc(VFreq0,VFreq1,SmoothDec(Comodulo,[1 1])), axis xy
xlabel('Phase Frequency(Hz), modulating');
ylabel('Amplitude Frequency(Hz), modulated');
subplot(2,2,3), contourf(VFreq0,VFreq1,10*log10(SmoothDec(Comodulo,[1 1])),[min(min(10*log10(Comodulo))):(max(max(10*log10(Comodulo)))-min(min(10*log10(Comodulo))))/50:max(max(10*log10(Comodulo)))],'linestyle','none'), axis xy
xlabel('Phase Frequency(Hz), modulating');
ylabel('Amplitude Frequency(Hz), modulated');
subplot(2,2,4), imagesc(VFreq0,VFreq1,10*log10(SmoothDec(Comodulo,[1 1]))), axis xy
xlabel('Phase Frequency(Hz), modulating');
ylabel('Amplitude Frequency(Hz), modulated');


end


toc



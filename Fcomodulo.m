function Fcomodulo(VTime,SgnFiltre0,SgnFiltre1)

%% Hilbert
PhaseTheta=angle(hilbert(SgnFiltre0))*180/pi+180;
AmpSgn1=abs(hilbert(SgnFiltre1));
figure(9);
plot(VTime,PhaseTheta);
hold on
plot(VTime,SgnFiltre0);
title(['SgnFiltre0(Theta), filter center=',num2str(filter0center),'Hz']);
hold off

figure(10);
plot(VTime,AmpSgn1);
hold on 
plot(VTime,SgnFiltre1);
title(['SgnFiltre1, filter center=',num2str(filter1center),'Hz']);
hold off

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
figure(11);
bar(VBinnedPhase,P);

%MI calculation
U=ones(1,N);
U=U/sum(U);
Dkl=0;
for i=1:N
    Dkl=Dkl+P(i)*log(P(i)/U(i));
end
MI=Dkl/log(N);
Comodulo(count1,count0)=MI;



%% display

VFreq0=[debut0:pas0:fin0];
VFreq1=[debut1:pas1:fin1];

figure(20)
imagesc(VFreq0,VFreq1,Comodulo); colorbar;
title('Comodulogramme');
xlabel('Phase Frequency(Hz), modulating');
ylabel('Amplitude Frequency(Hz), modulated');




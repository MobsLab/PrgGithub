%CaractSpectrumNoelia


cd \\NASDELUXE\DataMOBs\ProjetLPS

try
    load DataCaractSpectrumNoelia
S;
catch

S=sin([1:2000]/20);
S2=sin([1:1000]/20);
S3=2*sin([1:1000]/20);
S4=3*sin([1:1000]/20);

A=rand(1E4,1);
tt=([1:1E4]-1)/250;

B=A;
B(5001:7000)=B(5001:7000)+S';

C=A;
C(5001:6000)=C(5001:6000)+S2';

D=A;
D(5001:6000)=D(5001:6000)+S3';

E=A;
E(5001:6000)=E(5001:6000)+S4';

params.fpass=[1 3.5];
params.Fs=250;
params.pad=0;

[Sa,fa]=mtspectrumc(A,params);
[Sb,fb]=mtspectrumc(B,params);
[Sc,fc]=mtspectrumc(C,params);
[Sd,fd]=mtspectrumc(D,params);
[Se,fe]=mtspectrumc(E,params);

end

figure('color',[1 1 1])
subplot(1,3,1:2),hold on, plot(tt,A,'k'), plot(tt,E,'color',[0.7 0.7 0.7]),plot(tt,D,'color','r','linewidth',2), plot(tt,B,'b','linewidth',2), plot(tt,C,'color',[0.3 0.3 0.3],'linewidth',1),xlim([4000 8000]/250)
subplot(1,3,3),hold on, plot(fa,(Sa),'k'),hold on, plot(fb,(Sb),'b','linewidth',2),hold on, plot(fd,(Sd),'r','linewidth',2), plot(fc,(Sc),'color',[0.3 0.3 0.3],'linewidth',2), plot(fe,(Se),'color',[0.7 0.7 0.7],'linewidth',2)


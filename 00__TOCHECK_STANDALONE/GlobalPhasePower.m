function [h1,b1a,b1b,h2,b2a,b2b,h3,b3a,b3b,h4,b4a,b4b,h5,b5a,b5b,h6,b6a,b6b]=GlobalPhasePower(lfp1,lfp2,param1,param2,smo)

tic

sizeBin=60;
try
    smo;
catch
    smo=0.7;
end

fil1=FilterLFP(lfp1,[param1(1) param1(2)],param1(3));
fil2=FilterLFP(lfp2,[param2(1) param2(2)],param2(3));

hil1=hilbert(Data(fil1));
hil2=hilbert(Data(fil2));


ph1=atan2(imag(hil1),real(hil1)); ph1(ph1<0)=ph1(ph1<0)+2*pi;
ph2=atan2(imag(hil2),real(hil2)); ph2(ph2<0)=ph2(ph2<0)+2*pi;

[h1,b1a,b1b]=hist2d(abs(hil1),abs(hil2),sizeBin,sizeBin);
[h2,b2a,b2b]=hist2d(abs(hil1),ph1,sizeBin,sizeBin);
[h3,b3a,b3b]=hist2d(abs(hil1),ph2,sizeBin,sizeBin);
[h4,b4a,b4b]=hist2d(abs(hil2),ph1,sizeBin,sizeBin);
[h5,b5a,b5b]=hist2d(abs(hil2),ph2,sizeBin,sizeBin);
[h6,b6a,b6b]=hist2d(ph1,ph2,sizeBin,sizeBin);


[hpo1,bpo1]=hist(abs(hil1),sizeBin);
[hpo2,bpo2]=hist(abs(hil2),sizeBin);
% 
% sm=1;
% [hpo1,bpo1]=hist(SmoothDec(abs(hil1),sm),sizeBin);
% [hpo2,bpo2]=hist(SmoothDec(abs(hil2),sm),sizeBin);

[hph1,bph1]=hist(ph1,sizeBin);
[hph2,bph2]=hist(ph2,sizeBin);

h1s=SmoothDec(h1,[smo smo]);h1s=h1s(3:end-2,3:end-2); b1as=b1a(3:end-2); b1bs=b1b(3:end-2);
h2s=SmoothDec(h2,[smo smo]);h2s=h2s(3:end-2,3:end-2); b2as=b2a(3:end-2); b2bs=b2b(3:end-2);
h3s=SmoothDec(h3,[smo smo]);h3s=h3s(3:end-2,3:end-2); b3as=b3a(3:end-2); b3bs=b3b(3:end-2);
h4s=SmoothDec(h4,[smo smo]);h4s=h4s(3:end-2,3:end-2); b4as=b4a(3:end-2); b4bs=b4b(3:end-2);
h5s=SmoothDec(h5,[smo smo]);h5s=h5s(3:end-2,3:end-2); b5as=b5a(3:end-2); b5bs=b5b(3:end-2);
h6s=SmoothDec(h6,[smo smo]);h6s=h6s(3:end-2,3:end-2); b6as=b6a(3:end-2); b6bs=b6b(3:end-2);

H1s=h1s-mean(h1s(:));
H2s=h2s-mean(h2s(:));
H3s=h3s-mean(h3s(:));
H4s=h4s-mean(h4s(:));
H5s=h5s-mean(h5s(:));
H6s=h6s-mean(h6s(:));

fac=1.5;
th=mean(H1s(:))+fac*std(H1s(:));th2=mean(H1s(:))-fac*std(H1s(:));h1ss=H1s;h1ss(h1ss<th&h1ss>th2)=0;
th=mean(H2s(:))+fac*std(H2s(:));th2=mean(H2s(:))-fac*std(H2s(:));h2ss=H2s;h2ss(h2ss<th&h2ss>th2)=0;
th=mean(H3s(:))+fac*std(H3s(:));th2=mean(H3s(:))-fac*std(H3s(:));h3ss=H3s;h3ss(h3ss<th&h3ss>th2)=0;
th=mean(H4s(:))+fac*std(H4s(:));th2=mean(H4s(:))-fac*std(H4s(:));h4ss=H4s;h4ss(h4ss<th&h4ss>th2)=0;
th=mean(H5s(:))+fac*std(H5s(:));th2=mean(H5s(:))-fac*std(H5s(:));h5ss=H5s;h5ss(h5ss<th&h5ss>th2)=0;
th=mean(H6s(:))+fac*std(H6s(:));th2=mean(H6s(:))-fac*std(H6s(:));h6ss=H6s;h6ss(h6ss<th&h6ss>th2)=0;


figure('color',[1 1 1]),
subplot(2,5,1), bar(bpo1,hpo1,'k'), title('power 1')
subplot(2,5,2), bar(bpo2,hpo2,'k'), title('power 2')
subplot(2,5,3), imagesc(b1as,b1bs,h1s), title('power 1 vs power 2'),axis xy
subplot(2,5,4), imagesc(b2as,b2bs,h2s), title('power 1 vs phase 1'),axis xy
subplot(2,5,5), imagesc(b3as,b3bs,h3s), title('power 1 vs phase 2'),axis xy
subplot(2,5,6), bar(bph1,hph1,'k'), xlim([0 6.29]), title('phase 1')
subplot(2,5,7), bar(bph2,hph2,'k'), xlim([0 6.29]), title('phase 2')
subplot(2,5,8), imagesc(b4as,b4bs,h4s), title('power 2 vs phase 1'),axis xy
subplot(2,5,9), imagesc(b5as,b5bs,h5s), title('power 2 vs phase 2'),axis xy
subplot(2,5,10), imagesc(b6as,b6bs,h6s), title('phase 1 vs phase 2'),axis xy



figure('color',[1 1 1]),
subplot(2,5,1), bar(bpo1,hpo1,'k'), title('power 1')
subplot(2,5,2), bar(bpo2,hpo2,'k'), title('power 2')
subplot(2,5,3), imagesc(b1as,b1bs,h1ss), title('power 1 vs power 2'),axis xy
subplot(2,5,4), imagesc(b2as,b2bs,h2ss), title('power 1 vs phase 1'),axis xy
subplot(2,5,5), imagesc(b3as,b3bs,h3ss), title('power 1 vs phase 2'),axis xy
subplot(2,5,6), bar(bph1,hph1,'k'), xlim([0 6.29]), title('phase 1')
subplot(2,5,7), bar(bph2,hph2,'k'), xlim([0 6.29]), title('phase 2')
subplot(2,5,8), imagesc(b4as,b4bs,h4ss), title('power 2 vs phase 1'),axis xy
subplot(2,5,9), imagesc(b5as,b5bs,h5ss), title('power 2 vs phase 2'),axis xy
subplot(2,5,10), imagesc(b6as,b6bs,h6ss), title('phase 1 vs phase 2'),axis xy
colormap(hot)

toc


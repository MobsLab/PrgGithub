function [r,p,r2,p2]=CrossFreqCoupling(Sp1,t1,f1,Sp2,t2,f2,Epoch)


% [r,p,r2,p2]=CrossFreqCoupling(Sp1,t1,f1,Sp2,t2,f2,Epoch)
% Sp1, Sp2 = spectra data (matrix)
% t1,t2 = time / f1,f2 = frequency - f1 should contain the lower
% frequencies

inver=0;
if floor(f1(1))>floor(f2(1))
    inver=1;
    f3=f2;
    t3=t2;
    Sp3=Sp2;
    
    f2=f1;
    t2=t1;
    Sp2=Sp1;
    
    f1=f3;
    t1=t3;
    Sp1=Sp3;
    
    disp(' *** *** ***')
    disp('inversed')
    disp(' *** *** ***')
    disp(' ')
end


S1tsd=tsd(t1*1E4,Sp1);
S2tsd=tsd(t2*1E4,Sp2);

try
    Epoch;
    S1tsd=Restrict(S1tsd,Epoch);
    S2tsd=Restrict(S2tsd,Epoch);    
    t1=Range(S1tsd,'s');
    t2=Range(S2tsd,'s');
end

    
if length(t1)>length(t2)
    eS1tsd=S1tsd;    
    eS2tsd=Restrict(S2tsd,eS1tsd);
else
    eS2tsd=S2tsd;    
    eS1tsd=Restrict(S1tsd,eS2tsd);  
end

eSp1=Data(eS1tsd);
eSp2=Data(eS2tsd);


for i=1:10 
    if size(eSp1,2)<length(f1)
    f1=f1(1:end-1);
    end
end

for i=1:10
    if size(eSp2,2)<length(f2)
    f2=f2(1:end-1);
    end
end



[r,p]=corrcoef(10*log10([eSp1,eSp2]));
[r2,p2]=corrcoef(([eSp1,eSp2]));

%r=r2;p=p2;

figure('color',[1 1 1],'visible','on'),
% Cross correlation 
subplot(2,2,1), 
imagesc(f1,f2,SmoothDec(r(length(f1)+1:end,1:length(f1)),[1 1])), axis xy%, colorbar
ca=caxis;
title(['CrossCorr scale: ',num2str(floor(ca(1)*100)/100),' --- ',num2str(floor(ca(2)*100)/100)])

if inver
    xlabel('S2')
    ylabel('S1')
else
    xlabel('S1')
    ylabel('S2')  
end

% Auto correlation Sp1
subplot(2,2,3), 
imagesc(f1,f1,r(1:length(f1),1:length(f1))), axis xy%, colorbar
hold on, plot(f1,rescale(mean(Data(eS1tsd)),f1(1),f1(end)-2),'k','linewidth',2)
hold on, plot(f1,rescale(10*log10(mean(Data(eS1tsd))),f1(1),f1(end)-1),'w','linewidth',2)
xlabel('S1'), ylabel('S1') 
ca=caxis;
title(['AutoCorr Sp1 scale: ',num2str(floor(ca(1)*10)/10),' --- ',num2str(floor(ca(2)*10)/10)])

% Auto correlation Sp2
subplot(2,2,2), 
% imagesc(f2,f2,SmoothDec(r(length(f1)+1:end,length(f1)+1:end),[1 1])), axis xy%, colorbar
imagesc(f2,f2,r(length(f1)+1:end,length(f1)+1:end)), axis xy%, colorbar
hold on, plot(f2,rescale(mean(Data(eS2tsd)),f2(1),f2(end)-2),'k','linewidth',2)
hold on, plot(f2,rescale(10*log10(mean(Data(eS2tsd))),f2(1),f2(end)-1),'w','linewidth',2)
ca=caxis;
title(['AutoCorr Sp2 scale: ',num2str(floor(ca(1)*10)/10),' --- ',num2str(floor(ca(2)*10)/10)])
xlabel('mean spectrograms: black=raw, white=10log10')

for i=1:length(p)
    p(i,i)=0;
end

% Cross correlation significance
subplot(2,2,4), 
%imagesc(f2,f2,(SmoothDec(p(length(f1)+1:end,length(f1)+1:end),[1 1]))), axis xy%, colorbar
% imagesc(f1,f2,SmoothDec(p(length(f1)+1:end,1:length(f1)),[smo smo])), axis xy%, colorbar
imagesc(f1,f2,p(length(f1)+1:end,1:length(f1))), axis xy%, colorbar
caxis([0 0.05])
ca=caxis;
title(['CrossCorr Significance scale: ',num2str(floor(ca(1)*100)/100),' --- ',num2str(floor(ca(2)*100)/100)])
if inver
    xlabel('S2')
    ylabel('S1')
else
    xlabel('S1')
    ylabel('S2')  
end

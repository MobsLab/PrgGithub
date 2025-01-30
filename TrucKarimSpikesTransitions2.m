%TrucKarimSpikesTransitions

% Dir=PathForExperimentsMLnew('BASALlongSleep');
Dir=PathForExperimentsMLnew('Spikes');


CCparam1=100;
CCparam2=150;
plo=0;

CtN1=[];
CtN2=[];
CtN3=[];
CtRE=[];
CtRE2=[];
CtWA=[];
CtN1e=[];
CtN2e=[];
CtN3e=[];
CtREe=[];
CtRE2e=[];
CtWAe=[];
listMouse=[];
for p=1:length(Dir.path)
disp(' ')
disp('****************************************************************')
eval(['cd(Dir.path{',num2str(p),'}'')'])
disp(pwd)
clear S
clear N1
% try
% load SleepSubstages
% N1=Epoch{1};
% N2=Epoch{2};
% N3=Epoch{3};
% REM=Epoch{4};
% Wake=Epoch{5};
% catch

[Wake,REM,N1,N2,N3]=RunSubstages;
close
% end
REM2=dropShortIntervals(REM,20E4);
try
    load SpikeData
     numNeurons=GetSpikesFromStructure('PFCx');
     nN=numNeurons;
            for s=1:length(numNeurons)
                if TT{numNeurons(s)}(2)==1
                    nN(nN==numNeurons(s))=[];
                end
            end
            
%    numNeurons=GetSpikesFromStructure('Bulb');
    %num=GetSpikesFromStructure('PFCx');
    %numNeurons=1:length(S);
    %numNeurons(num)=[];
    S=S(nN);
end
try
N1;
S;
clear CN1
clear CN2
clear CN3
clear CRE
clear CRE2
clear CWA
clear CN1e
clear CN2e
clear CN3e
clear CREe
clear CRE2e
clear CWAe
%
% for a=1:length(S)
% [CN1(a,:),B]=CrossCorr(Range(S{a}),Start(N1),CCparam1,CCparam2);
% [CN2(a,:),B]=CrossCorr(Range(S{a}),Start(N2),CCparam1,CCparam2);
% [CN3(a,:),B]=CrossCorr(Range(S{a}),Start(N3),CCparam1,CCparam2);
% [CRE(a,:),B]=CrossCorr(Range(S{a}),Start(REM),CCparam1,CCparam2);
% [CWA(a,:),B]=CrossCorr(Range(S{a}),Start(Wake),CCparam1,CCparam2);
% [CN1e(a,:),B]=CrossCorr(Range(S{a}),End(N1),CCparam1,CCparam2);
% [CN2e(a,:),B]=CrossCorr(Range(S{a}),End(N2),CCparam1,CCparam2);
% [CN3e(a,:),B]=CrossCorr(Range(S{a}),End(N3),CCparam1,CCparam2);
% [CREe(a,:),B]=CrossCorr(Range(S{a}),End(REM),CCparam1,CCparam2);
% [CWAe(a,:),B]=CrossCorr(Range(S{a}),End(Wake),CCparam1,CCparam2);
% listlocal(a)=p;
% end
for a=1:length(S)
[CN1(a,:),B]=CrossCorr(Start(N1),Range(S{a}),CCparam1,CCparam2);
[CN2(a,:),B]=CrossCorr(Start(N2),Range(S{a}),CCparam1,CCparam2);
[CN3(a,:),B]=CrossCorr(Start(N3),Range(S{a}),CCparam1,CCparam2);
[CRE(a,:),B]=CrossCorr(Start(REM),Range(S{a}),CCparam1,CCparam2);
[CRE2(a,:),B]=CrossCorr(Start(REM2),Range(S{a}),CCparam1,CCparam2);
[CWA(a,:),B]=CrossCorr(Start(Wake),Range(S{a}),CCparam1,CCparam2);
[CN1e(a,:),B]=CrossCorr(End(N1),Range(S{a}),CCparam1,CCparam2);
[CN2e(a,:),B]=CrossCorr(End(N2),Range(S{a}),CCparam1,CCparam2);
[CN3e(a,:),B]=CrossCorr(End(N3),Range(S{a}),CCparam1,CCparam2);
[CREe(a,:),B]=CrossCorr(End(REM),Range(S{a}),CCparam1,CCparam2);
[CRE2e(a,:),B]=CrossCorr(End(REM2),Range(S{a}),CCparam1,CCparam2);
[CWAe(a,:),B]=CrossCorr(End(Wake),Range(S{a}),CCparam1,CCparam2);
listlocal(a)=p;
end
CtN1=[CtN1;CN1];
CtN2=[CtN2;CN2];
CtN3=[CtN3;CN3];
CtRE=[CtRE;CRE];
CtRE2=[CtRE2;CRE2];
CtWA=[CtWA;CWA];
CtN1e=[CtN1e;CN1e];
CtN2e=[CtN2e;CN2e];
CtN3e=[CtN3e;CN3e];
CtREe=[CtREe;CREe];
CtRE2e=[CtRE2e;CRE2e];
CtWAe=[CtWAe;CWAe];
listMouse=[listMouse;listlocal'];

CzN1=zscore(CN1')';
CzN2=zscore(CN2')';
CzN3=zscore(CN3')';
CzRE=zscore(CRE')';
CzRE2=zscore(CRE2')';
CzWA=zscore(CWA')';
limid=30;
[BE,idn1]=sort(mean(CzN1(:,CCparam2/2:CCparam2/2+limid),2));
[BE,idn2]=sort(mean(CzN2(:,CCparam2/2:CCparam2/2+limid),2));
[BE,idn3]=sort(mean(CzN3(:,CCparam2/2:CCparam2/2+limid),2));
[BE,idre]=sort(mean(CzRE(:,CCparam2/2:CCparam2/2+limid),2));
[BE,idwa]=sort(mean(CzWA(:,CCparam2/2:CCparam2/2+limid),2));
if plo
figure,
subplot(5,5,1), imagesc(B/1E3, 1:size(CN1,1),CzN1(idn1,:)), line([0 0],[0.5 length(S)-0.5],'color','k')
subplot(5,5,2), imagesc(B/1E3, 1:size(CN1,1),CzN1(idn2,:)), line([0 0],[0.5 length(S)-0.5],'color','k')
subplot(5,5,3), imagesc(B/1E3, 1:size(CN1,1),CzN1(idn3,:)), line([0 0],[0.5 length(S)-0.5],'color','k'), title(pwd)
subplot(5,5,4), imagesc(B/1E3, 1:size(CN1,1),CzN1(idre,:)), line([0 0],[0.5 length(S)-0.5],'color','k')
subplot(5,5,5), imagesc(B/1E3, 1:size(CN1,1),CzN1(idwa,:)), line([0 0],[0.5 length(S)-0.5],'color','k')
subplot(5,5,6), imagesc(B/1E3, 1:size(CN1,1),CzN2(idn1,:)), line([0 0],[0.5 length(S)-0.5],'color','k')
subplot(5,5,7), imagesc(B/1E3, 1:size(CN1,1),CzN2(idn2,:)), line([0 0],[0.5 length(S)-0.5],'color','k')
subplot(5,5,8), imagesc(B/1E3, 1:size(CN1,1),CzN2(idn3,:)), line([0 0],[0.5 length(S)-0.5],'color','k')
subplot(5,5,9), imagesc(B/1E3, 1:size(CN1,1),CzN2(idre,:)), line([0 0],[0.5 length(S)-0.5],'color','k')
subplot(5,5,10), imagesc(B/1E3, 1:size(CN1,1),CzN2(idwa,:)), line([0 0],[0.5 length(S)-0.5],'color','k')
subplot(5,5,11), imagesc(B/1E3, 1:size(CN1,1),CzN3(idn1,:)), line([0 0],[0.5 length(S)-0.5],'color','k')
subplot(5,5,12), imagesc(B/1E3, 1:size(CN1,1),CzN3(idn2,:)), line([0 0],[0.5 length(S)-0.5],'color','k')
subplot(5,5,13), imagesc(B/1E3, 1:size(CN1,1),CzN3(idn3,:)), line([0 0],[0.5 length(S)-0.5],'color','k')
subplot(5,5,14), imagesc(B/1E3, 1:size(CN1,1),CzN3(idre,:)), line([0 0],[0.5 length(S)-0.5],'color','k')
subplot(5,5,15), imagesc(B/1E3, 1:size(CN1,1),CzN3(idwa,:)), line([0 0],[0.5 length(S)-0.5],'color','k')
subplot(5,5,16), imagesc(B/1E3, 1:size(CN1,1),CzRE(idn1,:)), line([0 0],[0.5 length(S)-0.5],'color','k')
subplot(5,5,17), imagesc(B/1E3, 1:size(CN1,1),CzRE(idn2,:)), line([0 0],[0.5 length(S)-0.5],'color','k')
subplot(5,5,18), imagesc(B/1E3, 1:size(CN1,1),CzRE(idn3,:)), line([0 0],[0.5 length(S)-0.5],'color','k')
subplot(5,5,19), imagesc(B/1E3, 1:size(CN1,1),CzRE(idre,:)), line([0 0],[0.5 length(S)-0.5],'color','k')
subplot(5,5,20), imagesc(B/1E3, 1:size(CN1,1),CzRE(idwa,:)), line([0 0],[0.5 length(S)-0.5],'color','k')
subplot(5,5,21), imagesc(B/1E3, 1:size(CN1,1),CzWA(idn1,:)), line([0 0],[0.5 length(S)-0.5],'color','k')
subplot(5,5,22), imagesc(B/1E3, 1:size(CN1,1),CzWA(idn2,:)), line([0 0],[0.5 length(S)-0.5],'color','k')
subplot(5,5,23), imagesc(B/1E3, 1:size(CN1,1),CzWA(idn3,:)), line([0 0],[0.5 length(S)-0.5],'color','k')
subplot(5,5,24), imagesc(B/1E3, 1:size(CN1,1),CzWA(idre,:)), line([0 0],[0.5 length(S)-0.5],'color','k')
subplot(5,5,25), imagesc(B/1E3, 1:size(CN1,1),CzWA(idwa,:)), line([0 0],[0.5 length(S)-0.5],'color','k')
pause(0)
end
catch
disp(' ')
disp(' ')
disp(['Problem  ',pwd])
disp(' ')
disp(' ')
end
end
CtzN1=zscore(CtN1')';
CtzN2=zscore(CtN2')';
CtzN3=zscore(CtN3')';
CtzRE=zscore(CtRE')';
CtzRE2=zscore(CtRE2')';
CtzWA=zscore(CtWA')';
CtzN1e=zscore(CtN1e')';
CtzN2e=zscore(CtN2e')';
CtzN3e=zscore(CtN3e')';
CtzREe=zscore(CtREe')';
CtzRE2e=zscore(CtRE2e')';
CtzWAe=zscore(CtWAe')';
% [BE,idtn1]=sort(mean(CtzN1(:,CCparam2/2:CCparam2/2+limid),2));
% [BE,idtn2]=sort(mean(CtzN2(:,CCparam2/2:CCparam2/2+limid),2));
% [BE,idtn3]=sort(mean(CtzN3(:,CCparam2/2:CCparam2/2+limid),2));
% [BE,idtre]=sort(mean(CtzRE(:,CCparam2/2:CCparam2/2+limid),2));
% [BE,idtwa]=sort(mean(CtzWA(:,CCparam2/2:CCparam2/2+limid),2));
limid=30;
limid2=0;
[BE,idtn1]=sort(mean(CtzN1(:,CCparam2/2-limid2:CCparam2/2+limid),2));
[BE,idtn2]=sort(mean(CtzN2(:,CCparam2/2-limid2:CCparam2/2+limid),2));
[BE,idtn3]=sort(mean(CtzN3(:,CCparam2/2-limid2:CCparam2/2+limid),2));
[BE,idtre]=sort(mean(CtzRE(:,CCparam2/2-limid2:CCparam2/2+limid),2));
[BE,idtwa]=sort(mean(CtzWA(:,CCparam2/2-limid2:CCparam2/2+limid),2));
ca=3;
figure,
subplot(5,5,1), imagesc(B/1E3, 1:size(CtN1,1),runmean(CtzN1(idtn1,:),2,2)), line([0 0],[0.5 size(CtN1,1)-0.5],'color','k'),caxis([-ca ca])
subplot(5,5,2), imagesc(B/1E3, 1:size(CtN1,1),runmean(CtzN1(idtn2,:),2,2)), line([0 0],[0.5 size(CtN1,1)-0.5],'color','k'),caxis([-ca ca])
subplot(5,5,3), imagesc(B/1E3, 1:size(CtN1,1),runmean(CtzN1(idtn3,:),2,2)), line([0 0],[0.5 size(CtN1,1)-0.5],'color','k'),caxis([-ca ca])
subplot(5,5,4), imagesc(B/1E3, 1:size(CtN1,1),runmean(CtzN1(idtre,:),2,2)), line([0 0],[0.5 size(CtN1,1)-0.5],'color','k'),caxis([-ca ca])
subplot(5,5,5), imagesc(B/1E3, 1:size(CtN1,1),runmean(CtzN1(idtwa,:),2,2)), line([0 0],[0.5 size(CtN1,1)-0.5],'color','k'),caxis([-ca ca])
subplot(5,5,6), imagesc(B/1E3, 1:size(CtN1,1),runmean(CtzN2(idtn1,:),2,2)), line([0 0],[0.5 size(CtN1,1)-0.5],'color','k'),caxis([-ca ca])
subplot(5,5,7), imagesc(B/1E3, 1:size(CtN1,1),runmean(CtzN2(idtn2,:),2,2)), line([0 0],[0.5 size(CtN1,1)-0.5],'color','k'),caxis([-ca ca])
subplot(5,5,8), imagesc(B/1E3, 1:size(CtN1,1),runmean(CtzN2(idtn3,:),2,2)), line([0 0],[0.5 size(CtN1,1)-0.5],'color','k'),caxis([-ca ca])
subplot(5,5,9), imagesc(B/1E3, 1:size(CtN1,1),runmean(CtzN2(idtre,:),2,2)), line([0 0],[0.5 size(CtN1,1)-0.5],'color','k'),caxis([-ca ca])
subplot(5,5,10), imagesc(B/1E3, 1:size(CtN1,1),runmean(CtzN2(idtwa,:),2,2)), line([0 0],[0.5 size(CtN1,1)-0.5],'color','k'),caxis([-ca ca])
subplot(5,5,11), imagesc(B/1E3, 1:size(CtN1,1),runmean(CtzN3(idtn1,:),2,2)), line([0 0],[0.5 size(CtN1,1)-0.5],'color','k'),caxis([-ca ca])
subplot(5,5,12), imagesc(B/1E3, 1:size(CtN1,1),runmean(CtzN3(idtn2,:),2,2)), line([0 0],[0.5 size(CtN1,1)-0.5],'color','k'),caxis([-ca ca])
subplot(5,5,13), imagesc(B/1E3, 1:size(CtN1,1),runmean(CtzN3(idtn3,:),2,2)), line([0 0],[0.5 size(CtN1,1)-0.5],'color','k'),caxis([-ca ca])
subplot(5,5,14), imagesc(B/1E3, 1:size(CtN1,1),runmean(CtzN3(idtre,:),2,2)), line([0 0],[0.5 size(CtN1,1)-0.5],'color','k'),caxis([-ca ca])
subplot(5,5,15), imagesc(B/1E3, 1:size(CtN1,1),runmean(CtzN3(idtwa,:),2,2)), line([0 0],[0.5 size(CtN1,1)-0.5],'color','k'),caxis([-ca ca])
subplot(5,5,16), imagesc(B/1E3, 1:size(CtN1,1),runmean(CtzRE(idtn1,:),2,2)), line([0 0],[0.5 size(CtN1,1)-0.5],'color','k'),caxis([-ca ca])
subplot(5,5,17), imagesc(B/1E3, 1:size(CtN1,1),runmean(CtzRE(idtn2,:),2,2)), line([0 0],[0.5 size(CtN1,1)-0.5],'color','k'),caxis([-ca ca])
subplot(5,5,18), imagesc(B/1E3, 1:size(CtN1,1),runmean(CtzRE(idtn3,:),2,2)), line([0 0],[0.5 size(CtN1,1)-0.5],'color','k'),caxis([-ca ca])
subplot(5,5,19), imagesc(B/1E3, 1:size(CtN1,1),runmean(CtzRE(idtre,:),2,2)), line([0 0],[0.5 size(CtN1,1)-0.5],'color','k'),caxis([-ca ca])
subplot(5,5,20), imagesc(B/1E3, 1:size(CtN1,1),runmean(CtzRE(idtwa,:),2,2)), line([0 0],[0.5 size(CtN1,1)-0.5],'color','k'),caxis([-ca ca])
subplot(5,5,21), imagesc(B/1E3, 1:size(CtN1,1),runmean(CtzWA(idtn1,:),2,2)), line([0 0],[0.5 size(CtN1,1)-0.5],'color','k'),caxis([-ca ca])
subplot(5,5,22), imagesc(B/1E3, 1:size(CtN1,1),runmean(CtzWA(idtn2,:),2,2)), line([0 0],[0.5 size(CtN1,1)-0.5],'color','k'),caxis([-ca ca])
subplot(5,5,23), imagesc(B/1E3, 1:size(CtN1,1),runmean(CtzWA(idtn3,:),2,2)), line([0 0],[0.5 size(CtN1,1)-0.5],'color','k'),caxis([-ca ca])
subplot(5,5,24), imagesc(B/1E3, 1:size(CtN1,1),runmean(CtzWA(idtre,:),2,2)), line([0 0],[0.5 size(CtN1,1)-0.5],'color','k'),caxis([-ca ca])
subplot(5,5,25), imagesc(B/1E3, 1:size(CtN1,1),runmean(CtzWA(idtwa,:),2,2)), line([0 0],[0.5 size(CtN1,1)-0.5],'color','k'),caxis([-ca ca])
limid=0;
limid2=30;
[BE,idtn1e]=sort(mean(CtzN1e(:,CCparam2/2-limid2:CCparam2/2+limid),2));
[BE,idtn2e]=sort(mean(CtzN2e(:,CCparam2/2-limid2:CCparam2/2+limid),2));
[BE,idtn3e]=sort(mean(CtzN3e(:,CCparam2/2-limid2:CCparam2/2+limid),2));
[BE,idtree]=sort(mean(CtzREe(:,CCparam2/2-limid2:CCparam2/2+limid),2));
[BE,idtwae]=sort(mean(CtzWAe(:,CCparam2/2-limid2:CCparam2/2+limid),2));
figure,
subplot(5,5,1), imagesc(B/1E3, 1:size(CtN1,1),runmean(CtzN1e(idtn1e,:),2,2)), line([0 0],[0.5 size(CtN1,1)-0.5],'color','k'),caxis([-ca ca])
subplot(5,5,2), imagesc(B/1E3, 1:size(CtN1,1),runmean(CtzN1e(idtn2e,:),2,2)), line([0 0],[0.5 size(CtN1,1)-0.5],'color','k'),caxis([-ca ca])
subplot(5,5,3), imagesc(B/1E3, 1:size(CtN1,1),runmean(CtzN1e(idtn3e,:),2,2)), line([0 0],[0.5 size(CtN1,1)-0.5],'color','k'),caxis([-ca ca])
subplot(5,5,4), imagesc(B/1E3, 1:size(CtN1,1),runmean(CtzN1e(idtree,:),2,2)), line([0 0],[0.5 size(CtN1,1)-0.5],'color','k'),caxis([-ca ca])
subplot(5,5,5), imagesc(B/1E3, 1:size(CtN1,1),runmean(CtzN1e(idtwae,:),2,2)), line([0 0],[0.5 size(CtN1,1)-0.5],'color','k'),caxis([-ca ca])
subplot(5,5,6), imagesc(B/1E3, 1:size(CtN1,1),runmean(CtzN2e(idtn1e,:),2,2)), line([0 0],[0.5 size(CtN1,1)-0.5],'color','k'),caxis([-ca ca])
subplot(5,5,7), imagesc(B/1E3, 1:size(CtN1,1),runmean(CtzN2e(idtn2e,:),2,2)), line([0 0],[0.5 size(CtN1,1)-0.5],'color','k'),caxis([-ca ca])
subplot(5,5,8), imagesc(B/1E3, 1:size(CtN1,1),runmean(CtzN2e(idtn3e,:),2,2)), line([0 0],[0.5 size(CtN1,1)-0.5],'color','k'),caxis([-ca ca])
subplot(5,5,9), imagesc(B/1E3, 1:size(CtN1,1),runmean(CtzN2e(idtree,:),2,2)), line([0 0],[0.5 size(CtN1,1)-0.5],'color','k'),caxis([-ca ca])
subplot(5,5,10), imagesc(B/1E3, 1:size(CtN1,1),runmean(CtzN2e(idtwae,:),2,2)), line([0 0],[0.5 size(CtN1,1)-0.5],'color','k'),caxis([-ca ca])
subplot(5,5,11), imagesc(B/1E3, 1:size(CtN1,1),runmean(CtzN3e(idtn1e,:),2,2)), line([0 0],[0.5 size(CtN1,1)-0.5],'color','k'),caxis([-ca ca])
subplot(5,5,12), imagesc(B/1E3, 1:size(CtN1,1),runmean(CtzN3e(idtn2e,:),2,2)), line([0 0],[0.5 size(CtN1,1)-0.5],'color','k'),caxis([-ca ca])
subplot(5,5,13), imagesc(B/1E3, 1:size(CtN1,1),runmean(CtzN3e(idtn3e,:),2,2)), line([0 0],[0.5 size(CtN1,1)-0.5],'color','k'),caxis([-ca ca])
subplot(5,5,14), imagesc(B/1E3, 1:size(CtN1,1),runmean(CtzN3e(idtree,:),2,2)), line([0 0],[0.5 size(CtN1,1)-0.5],'color','k'),caxis([-ca ca])
subplot(5,5,15), imagesc(B/1E3, 1:size(CtN1,1),runmean(CtzN3e(idtwae,:),2,2)), line([0 0],[0.5 size(CtN1,1)-0.5],'color','k'),caxis([-ca ca])
subplot(5,5,16), imagesc(B/1E3, 1:size(CtN1,1),runmean(CtzREe(idtn1e,:),2,2)), line([0 0],[0.5 size(CtN1,1)-0.5],'color','k'),caxis([-ca ca])
subplot(5,5,17), imagesc(B/1E3, 1:size(CtN1,1),runmean(CtzREe(idtn2e,:),2,2)), line([0 0],[0.5 size(CtN1,1)-0.5],'color','k'),caxis([-ca ca])
subplot(5,5,18), imagesc(B/1E3, 1:size(CtN1,1),runmean(CtzREe(idtn3e,:),2,2)), line([0 0],[0.5 size(CtN1,1)-0.5],'color','k'),caxis([-ca ca])
subplot(5,5,19), imagesc(B/1E3, 1:size(CtN1,1),runmean(CtzREe(idtree,:),2,2)), line([0 0],[0.5 size(CtN1,1)-0.5],'color','k'),caxis([-ca ca])
subplot(5,5,20), imagesc(B/1E3, 1:size(CtN1,1),runmean(CtzREe(idtwae,:),2,2)), line([0 0],[0.5 size(CtN1,1)-0.5],'color','k'),caxis([-ca ca])
subplot(5,5,21), imagesc(B/1E3, 1:size(CtN1,1),runmean(CtzWAe(idtn1e,:),2,2)), line([0 0],[0.5 size(CtN1,1)-0.5],'color','k'),caxis([-ca ca])
subplot(5,5,22), imagesc(B/1E3, 1:size(CtN1,1),runmean(CtzWAe(idtn2e,:),2,2)), line([0 0],[0.5 size(CtN1,1)-0.5],'color','k'),caxis([-ca ca])
subplot(5,5,23), imagesc(B/1E3, 1:size(CtN1,1),runmean(CtzWAe(idtn3e,:),2,2)), line([0 0],[0.5 size(CtN1,1)-0.5],'color','k'),caxis([-ca ca])
subplot(5,5,24), imagesc(B/1E3, 1:size(CtN1,1),runmean(CtzWAe(idtree,:),2,2)), line([0 0],[0.5 size(CtN1,1)-0.5],'color','k'),caxis([-ca ca])
subplot(5,5,25), imagesc(B/1E3, 1:size(CtN1,1),runmean(CtzWAe(idtwae,:),2,2)), line([0 0],[0.5 size(CtN1,1)-0.5],'color','k'),caxis([-ca ca])
figure,
subplot(5,5,1), imagesc(B/1E3, 1:size(CtN1,1),runmean(CtzN1(idtn1e,:),2,2)), line([0 0],[0.5 size(CtN1,1)-0.5],'color','k'),caxis([-ca ca])
subplot(5,5,2), imagesc(B/1E3, 1:size(CtN1,1),runmean(CtzN1(idtn2e,:),2,2)), line([0 0],[0.5 size(CtN1,1)-0.5],'color','k'),caxis([-ca ca])
subplot(5,5,3), imagesc(B/1E3, 1:size(CtN1,1),runmean(CtzN1(idtn3e,:),2,2)), line([0 0],[0.5 size(CtN1,1)-0.5],'color','k'),caxis([-ca ca])
subplot(5,5,4), imagesc(B/1E3, 1:size(CtN1,1),runmean(CtzN1(idtree,:),2,2)), line([0 0],[0.5 size(CtN1,1)-0.5],'color','k'),caxis([-ca ca])
subplot(5,5,5), imagesc(B/1E3, 1:size(CtN1,1),runmean(CtzN1(idtwae,:),2,2)), line([0 0],[0.5 size(CtN1,1)-0.5],'color','k'),caxis([-ca ca])
subplot(5,5,6), imagesc(B/1E3, 1:size(CtN1,1),runmean(CtzN2(idtn1e,:),2,2)), line([0 0],[0.5 size(CtN1,1)-0.5],'color','k'),caxis([-ca ca])
subplot(5,5,7), imagesc(B/1E3, 1:size(CtN1,1),runmean(CtzN2(idtn2e,:),2,2)), line([0 0],[0.5 size(CtN1,1)-0.5],'color','k'),caxis([-ca ca])
subplot(5,5,8), imagesc(B/1E3, 1:size(CtN1,1),runmean(CtzN2(idtn3e,:),2,2)), line([0 0],[0.5 size(CtN1,1)-0.5],'color','k'),caxis([-ca ca])
subplot(5,5,9), imagesc(B/1E3, 1:size(CtN1,1),runmean(CtzN2(idtree,:),2,2)), line([0 0],[0.5 size(CtN1,1)-0.5],'color','k'),caxis([-ca ca])
subplot(5,5,10), imagesc(B/1E3, 1:size(CtN1,1),runmean(CtzN2(idtwae,:),2,2)), line([0 0],[0.5 size(CtN1,1)-0.5],'color','k'),caxis([-ca ca])
subplot(5,5,11), imagesc(B/1E3, 1:size(CtN1,1),runmean(CtzN3(idtn1e,:),2,2)), line([0 0],[0.5 size(CtN1,1)-0.5],'color','k'),caxis([-ca ca])
subplot(5,5,12), imagesc(B/1E3, 1:size(CtN1,1),runmean(CtzN3(idtn2e,:),2,2)), line([0 0],[0.5 size(CtN1,1)-0.5],'color','k'),caxis([-ca ca])
subplot(5,5,13), imagesc(B/1E3, 1:size(CtN1,1),runmean(CtzN3(idtn3e,:),2,2)), line([0 0],[0.5 size(CtN1,1)-0.5],'color','k'),caxis([-ca ca])
subplot(5,5,14), imagesc(B/1E3, 1:size(CtN1,1),runmean(CtzN3(idtree,:),2,2)), line([0 0],[0.5 size(CtN1,1)-0.5],'color','k'),caxis([-ca ca])
subplot(5,5,15), imagesc(B/1E3, 1:size(CtN1,1),runmean(CtzN3(idtwae,:),2,2)), line([0 0],[0.5 size(CtN1,1)-0.5],'color','k'),caxis([-ca ca])
subplot(5,5,16), imagesc(B/1E3, 1:size(CtN1,1),runmean(CtzRE(idtn1e,:),2,2)), line([0 0],[0.5 size(CtN1,1)-0.5],'color','k'),caxis([-ca ca])
subplot(5,5,17), imagesc(B/1E3, 1:size(CtN1,1),runmean(CtzRE(idtn2e,:),2,2)), line([0 0],[0.5 size(CtN1,1)-0.5],'color','k'),caxis([-ca ca])
subplot(5,5,18), imagesc(B/1E3, 1:size(CtN1,1),runmean(CtzRE(idtn3e,:),2,2)), line([0 0],[0.5 size(CtN1,1)-0.5],'color','k'),caxis([-ca ca])
subplot(5,5,19), imagesc(B/1E3, 1:size(CtN1,1),runmean(CtzRE(idtree,:),2,2)), line([0 0],[0.5 size(CtN1,1)-0.5],'color','k'),caxis([-ca ca])
subplot(5,5,20), imagesc(B/1E3, 1:size(CtN1,1),runmean(CtzRE(idtwae,:),2,2)), line([0 0],[0.5 size(CtN1,1)-0.5],'color','k'),caxis([-ca ca])
subplot(5,5,21), imagesc(B/1E3, 1:size(CtN1,1),runmean(CtzWA(idtn1e,:),2,2)), line([0 0],[0.5 size(CtN1,1)-0.5],'color','k'),caxis([-ca ca])
subplot(5,5,22), imagesc(B/1E3, 1:size(CtN1,1),runmean(CtzWA(idtn2e,:),2,2)), line([0 0],[0.5 size(CtN1,1)-0.5],'color','k'),caxis([-ca ca])
subplot(5,5,23), imagesc(B/1E3, 1:size(CtN1,1),runmean(CtzWA(idtn3e,:),2,2)), line([0 0],[0.5 size(CtN1,1)-0.5],'color','k'),caxis([-ca ca])
subplot(5,5,24), imagesc(B/1E3, 1:size(CtN1,1),runmean(CtzWA(idtree,:),2,2)), line([0 0],[0.5 size(CtN1,1)-0.5],'color','k'),caxis([-ca ca])
subplot(5,5,25), imagesc(B/1E3, 1:size(CtN1,1),runmean(CtzWA(idtwae,:),2,2)), line([0 0],[0.5 size(CtN1,1)-0.5],'color','k'),caxis([-ca ca])
figure,
subplot(2,5,1), hold on,
plot(B/1E3, runmean(mean(CtzN1),2),'k')
line([0 0],[-0.4 0.4],'color',[0.6 0.6 0.6])
ylim([-0.4 0.4])
xlim([-15 15])
subplot(2,5,6), hold on,
plot(B/1E3, runmean(mean(CtzN1e),2),'k')
line([0 0],[-0.4 0.4],'color',[0.6 0.6 0.6])
ylim([-0.4 0.4])
xlim([-15 15])
subplot(2,5,2), hold on,
plot(B/1E3, runmean(mean(CtzN2),2),'k')
line([0 0],[-0.4 0.4],'color',[0.6 0.6 0.6])
ylim([-0.4 0.4])
xlim([-15 15])
subplot(2,5,7), hold on,
plot(B/1E3, runmean(mean(CtzN2e),2),'k')
line([0 0],[-0.4 0.4],'color',[0.6 0.6 0.6])
ylim([-0.4 0.4])
xlim([-15 15])
subplot(2,5,3), hold on,
plot(B/1E3, runmean(mean(CtzN3),2),'k')
line([0 0],[-0.4 0.4],'color',[0.6 0.6 0.6])
ylim([-0.4 0.4])
xlim([-15 15])
subplot(2,5,8), hold on,
plot(B/1E3, runmean(mean(CtzN3e),2),'k')
line([0 0],[-0.4 0.4],'color',[0.6 0.6 0.6])
ylim([-0.4 0.4])
xlim([-15 15])
subplot(2,5,4), hold on,
plot(B/1E3, runmean(mean(CtzRE2),2),'r')
plot(B/1E3, runmean(mean(CtzRE),2),'k')
line([0 0],[-0.4 0.4],'color',[0.6 0.6 0.6])
ylim([-0.4 0.4])
xlim([-15 15])
subplot(2,5,9), hold on,
plot(B/1E3, runmean(mean(CtzRE2e),2),'r')
plot(B/1E3, runmean(mean(CtzREe),2),'k')
line([0 0],[-0.4 0.4],'color',[0.6 0.6 0.6])
ylim([-0.4 0.4])
xlim([-15 15])
subplot(2,5,5), hold on,
plot(B/1E3, runmean(mean(CtzWA),2),'k')
line([0 0],[-0.4 0.4],'color',[0.6 0.6 0.6])
ylim([-0.4 0.4])
xlim([-15 15])
subplot(2,5,10), hold on,
plot(B/1E3, runmean(mean(CtzWAe),2),'k')
line([0 0],[-0.4 0.4],'color',[0.6 0.6 0.6])
ylim([-0.4 0.4])
xlim([-15 15])
% title('Start N1')
% title('Start N2')
% title('Start N3')
% title('Start REM')
% title('Start Wake')
% title('End N1')
% title('End N2')
% title('End N3')
% title('End REM')
% title('End Wake')


















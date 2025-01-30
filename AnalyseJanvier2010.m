

cd F:\DataEnCours\ManuP\NewData
load DataJanvier2010


try
    fp1;
    fp2;
catch
fp1=5; fp2=40; % calcul de la coherence entre 15 et 40 Hz
end

params.trialave = 1;
params.err = [2 0.05];
params.fpass = [fp1 fp2];
params.tapers=[3 5];
params.pad=0;

params.Fs = 1/median(diff(Range(lfp1, 's')));

movingwin = [1, 0.01];



% EpochTestCorrect1=intervalSet((Start(Correct1)-20000),End(Correct1)+20000
% );

EpochTestCorrect1=intervalSet(COR1-35000,COR1+20000);

EpochTest1Correct1_all=[];AA=[];

for i=1:length(COR1(:,1))
    % tu peux utiliser size(COR,1) pour avoir la taille sur les colonnes ou
    % size(Cor,2) pour les lignes
      AA=Data(Restrict(lfp1,subset(EpochTestCorrect1,i)));name1='lfp1';
%       AA=Data(Restrict(lfp2,subset(EpochTestCorrect1,i)));name1='lfp2';
  if length(AA)>4686
EpochTest1Correct1_all=[EpochTest1Correct1_all,AA(1:4687,:)];
    end
end


EpochTest2Correct1_all=[];

for i=1:length(COR1(:,1))
%       AA=Data(Restrict(lfp2,subset(EpochTestCorrect1,i)));name2='lfp2';
      AA=Data(Restrict(lfp3,subset(EpochTestCorrect1,i)));name2='lfp3';
  if length(AA)>4686
EpochTest2Correct1_all=[EpochTest2Correct1_all,AA(1:4687,:)];
    end
end


%%%%%%%%%%%% moyennes  %%%%%%%%%%%%%

for i=1:length(EpochTest1Correct1_all(:,1))
EpochTest1Correct1_allmean(i,1)=mean(EpochTest1Correct1_all(i,:));
end
for i=1:length(EpochTest2Correct1_all(:,1))
EpochTest2Correct1_allmean(i,1)=mean(EpochTest2Correct1_all(i,:));
end

[CCorrect1,phiCorrect1,S12Correct1,S1Correct1,S2Correct1,t,f]=cohgramc(EpochTest1Correct1_allmean,EpochTest2Correct1_allmean,movingwin,params);


figure; subplot(4,1,1);imagesc(t,f,log(S1Correct1)');axis xy;title(['Spectrum ', name1,' Correct1 mean']);colorbar;
%hold on, plot(t,10+10*smooth(mean(C(:,find(f>12&f<16))')',2),'k'), axis xy;
subplot(4,1,2); imagesc(t,f,log(S2Correct1)');axis xy;title(['Spectrum ', name2,' Correct1 mean']);colorbar;
subplot(4,1,3);imagesc(t,f,CCorrect1'); axis xy;title(['coherence ',name1,' ',name2,' Correct1 mean']);colorbar;
subplot(4,1,4); imagesc(t,f,phiCorrect1');axis xy; title (['phi ',name1,' ',name2,' Correct1 mean']);colorbar;  





LFP1=[];
LFP3=[];
    
% EpochTestCorrect1=intervalSet((Start(Correct1)-35000),End(Correct1)+20000);

EpochTestCorrect1=intervalSet(COR1-35000,COR1+20000);


%-10000 tu prends 1 seconde avant et +10000 !seconde aprs ta periode
%d'interet ca t'evite les effets de bords potentiels


for i=1:length(Start(EpochTestCorrect1))
    % tu peux utiliser size(COR,1) pour avoir la taille sur les colonnes ou
    % size(Cor,2) pour les lignes
        A=Data(Restrict(lfp1,Restrict(lfp3,subset(EpochTestCorrect1,i))));
%         A=Data(Restrict(lfp1,Restrict(lfp2,subset(EpochTestCorrect1,i)))); name1='lfp1';
%         A=Data(Restrict(lfp2,Restrict(lfp3,subset(EpochTestCorrect1,i)))); name1='lfp2';
        %tu restreints ton lfp1 au lpf3 ca t'evite d'avoir des lfp de
        %taille differente
%         B=Data(Restrict(lfp3,subset(EpochTestCorrect1,i))); name2='lfp3';
%         B=Data(Restrict(lfp2,subset(EpochTestCorrect1,i))); name2='lfp2';
        B=Data(Restrict(lfp3,subset(EpochTestCorrect1,i))); 
        try
        LFP1=[LFP1 A];
        LFP3=[LFP3 B];
        catch
        LFP1=[LFP1 [A;A(end)]];
        LFP3=[LFP3 [B;B(end)]];  
        end
        
end

[Coh,phi,S12,S1,S2,t,f,confC,phierr,Cerr]=cohgramc(LFP1,LFP3,movingwin,params);

figure, imagesc(t,f,Coh'),axis xy, title(['Coherence ',name1,' vs ',name2])


%--------------------------------------------------------------------------
%--------------------------------------------------------------------------




Filt=[14 18];
FilB1=FilterLFP(lfp1,Filt);
FilB2=FilterLFP(lfp2,Filt);
FilB3=FilterLFP(lfp3,Filt);

[St, En] = findTheta(FilB1, 200, 200);
ThetaEpoch=intervalSet(St,En);

FilB1=Restrict(FilB1,ThetaEpoch);
FilB2=Restrict(FilB2,ThetaEpoch);
FilB3=Restrict(FilB3,ThetaEpoch);

% [phaseTsd, phB1] = firingPhaseHilbert(FilB1, S) ;
% [phaseTsd, phB2] = firingPhaseHilbert(FilB2, S) ;
% [phaseTsd, phB3] = firingPhaseHilbert(FilB3, S) ;

[tt,phB1]=CalCulPrefPhase(Restrict(S,ThetaEpoch),FilB1,'H');
[tt,phB2]=CalCulPrefPhase(Restrict(S,ThetaEpoch),FilB2,'H');
[tt,phB3]=CalCulPrefPhase(Restrict(S,ThetaEpoch),FilB3,'H');

% [tt,phB1]=CalCulPrefPhase(S,FilB1,'H');
% [tt,phB2]=CalCulPrefPhase(S,FilB2,'H');
% [tt,phB3]=CalCulPrefPhase(S,FilB3,'H');


PhE{1}=tsd(sort(Range(phB1{1})),Data(phB1{1})); %3
PhE{2}=tsd(sort(Range(phB1{2})),Data(phB1{2})); %4
PhE{3}=tsd(sort(Range(phB1{3})),Data(phB1{3})); %5
PhE{4}=tsd(sort(Range(phB1{4})),Data(phB1{4})); %6

PhE{5}=tsd(sort(Range(phB2{1})),Data(phB2{1})); %7
PhE{6}=tsd(sort(Range(phB2{2})),Data(phB2{2})); %8
PhE{7}=tsd(sort(Range(phB2{3})),Data(phB2{3})); %9
PhE{8}=tsd(sort(Range(phB2{4})),Data(phB2{4})); %10


PhE{9}=tsd(sort(Range(phB3{1})),Data(phB3{1})); %11
PhE{10}=tsd(sort(Range(phB3{2})),Data(phB3{2})); %12
PhE{11}=tsd(sort(Range(phB3{3})),Data(phB3{3}));% 13
PhE{12}=tsd(sort(Range(phB3{4})),Data(phB3{4})); %14

PhE=tsdArray(PhE);
nBins=20;

for i=1:12
    
    figure
    Epoch=InCorrect;
    try
        subplot(3,1,1), JustPoltMod(Data(Restrict(PhE{i},Epoch)),nBins)
    end
    Epoch=Correct1;
    try
        subplot(3,1,2), JustPoltMod(Data(Restrict(PhE{i},Epoch)),nBins)
    end
    Epoch=Correct;
    try
        subplot(3,1,3), JustPoltMod(Data(Restrict(PhE{i},Epoch)),nBins)
    end
    
end




% RE=REPTouch*10000;
% SE=SEATouch*10000;
% C1=COR1*10000;
% C=COR*10000;
% I=IC*10000;


deb=-20000;
fin=0;

bCorrect1=intervalSet(C1+deb,C1+fin);
bCorrect=intervalSet(C+deb,C+fin);
bInCorrect=intervalSet(I+deb,I+fin);

bSea=intervalSet(SE+deb,SE+fin);
bRep=intervalSet(RE+deb,RE+fin);

Sr=Restrict(S,ThetaEpoch);

[H1,Ph1,MT1]=RayleighFreq(lfp1,Restrict(Sr{2},bInCorrect));

[H2,Ph2,MT2]=RayleighFreq(lfp1,Restrict(Sr{2},bCorrect1));

[H3,Ph3,MT3]=RayleighFreq(lfp1,Restrict(Sr{2},bCorrect));

[H4,Ph4,MT4]=RayleighFreq(lfp1,Restrict(Sr{2},bSea));

[H5,Ph5,MT5]=RayleighFreq(lfp1,Restrict(Sr{2},Rep));



deb=0;
fin=20000;

aCorrect1=intervalSet(C1+deb,C1+fin);
aCorrect=intervalSet(C+deb,C+fin);
aInCorrect=intervalSet(I+deb,I+fin);

aSea=intervalSet(SE+deb,SE+fin);
aRep=intervalSet(RE+deb,RE+fin);


[H6,Ph6,MT6]=RayleighFreq(lfp1,Restrict(Sr{2},aInCorrect));

[H7,Ph7,MT7]=RayleighFreq(lfp1,Restrict(Sr{2},aCorrect1));

[H8,Ph8,MT8]=RayleighFreq(lfp1,Restrict(Sr{2},aCorrect));

[H9,Ph9,MT9]=RayleighFreq(lfp1,Restrict(Sr{2},aSea));

[H10,Ph10,MT10]=RayleighFreq(lfp1,Restrict(Sr{2},aRep));



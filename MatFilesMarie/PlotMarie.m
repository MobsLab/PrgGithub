function PlotMarie(i,Ph,S,C1,C,I)

nBins=10;
% i=3;

deb=-15000;
fin=0;

Correct1=intervalSet(C1+deb,C1+fin);
Correct=intervalSet(C+deb,C+fin);
InCorrect=intervalSet(I+deb,I+fin);

Epoch=InCorrect;
figure(1),clf 
subplot(3,1,1), JustPoltMod(Data(Restrict(Ph{i},Epoch)),nBins)
Epoch=Correct1;
subplot(3,1,2), JustPoltMod(Data(Restrict(Ph{i},Epoch)),nBins)
Epoch=Correct;
subplot(3,1,3), JustPoltMod(Data(Restrict(Ph{i},Epoch)),nBins)



deb=0;
fin=15000;

Correct1=intervalSet(C1+deb,C1+fin);
Correct=intervalSet(C+deb,C+fin);
InCorrect=intervalSet(I+deb,I+fin);

Epoch=InCorrect;
figure(2), clf
subplot(3,1,1), JustPoltMod(Data(Restrict(Ph{i},Epoch)),nBins)
Epoch=Correct1;
subplot(3,1,2), JustPoltMod(Data(Restrict(Ph{i},Epoch)),nBins)
Epoch=Correct;
subplot(3,1,3), JustPoltMod(Data(Restrict(Ph{i},Epoch)),nBins)

figure(5), clf,  RasterPETH(S{mod(i,3)}, ts(C), -20000, +20000,'BinSize',1000);
figure(4), clf,  RasterPETH(S{mod(i,3)}, ts(C1), -20000, +20000,'BinSize',1000);
figure(3), clf,  RasterPETH(S{mod(i,3)}, ts(I), -20000, +20000,'BinSize',1000);

%--------------------------------------------------------------------------
%---------------

k=2;

Col=colormap(HSV);
for i=1:64
list(i)=65-i;
end
A=Col(list,:);

Si={};
sq={};
sweeps={};

split=4;
siz=ceil(split/2);

ref=C1;
figure(7), clf
figure(6),clf, hold on,
for i=1:split

    abo=(i-1)*2*pi/split;
    bel=i*2*pi/split;
    Sa=thresholdIntervals(Ph{k},abo,'Direction','Above');
    Sb=thresholdIntervals(Ph{k},bel,'Direction','Below');
    Si=Restrict(S{mod(k,3)},and(Sa,Sb),'align','equal');
% 	[Si{i},sq{i},sweeps{i}]=PlotRasterPETHCouleur(S,neuron,EEGf,mazeEpoch,'I',st,to,(i-1)*2*pi/split,i*2*pi/split,A(floor(i*64/split),:),BinSize,1);
% 	hold on, plot(Range(sq{i}, 'ms'), Data(sq{i})/length(sweeps{i}), 'Color',A(floor(i*64/split),:), 'lineWidth',2);
    B{1}=A(floor(i*64/split),:); 
    [sq{i},sweeps{i}] = RasterPETHKarimCoul(Si, ts(ref), -20000, 20000, 'BinSize', 1000, 'BarColor',B,'FigureHandle', 6);

end

for i=1:split
figure(7), hold on, plot(Range(sq{i}, 'ms'), Data(sq{i})/length(sweeps{i}), 'Color',A(floor(i*64/split),:), 'lineWidth',2);
end


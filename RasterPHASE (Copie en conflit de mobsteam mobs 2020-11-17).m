function [Si,sq,sweeps]=RasterPHASE(S,neuron,EEGh,Epoch,st,to,split,BinSize,Avant,Apres,rythm,smo)

try
    rythm;
catch
rythm='beta';
end

try
    smo;
catch
    smo=0;
end

BinSize=BinSize*10;
Avant=Avant*10;
Apres=Apres*10;

EEGf=FilterRythm(EEGh,rythm,1024);

[phaseTsd, ph] = firingPhaseHilbert(EEGf, Restrict(S,Epoch)) ;

Si=Restrict(S(neuron),Epoch);

Si=S{neuron};

C=colormap(HSV);
for i=1:64
list(i)=65-i;
end
A=C(list,:);



Si={};
sq={};
sweeps={};

figure(1),clf,
figure(2),clf,

siz=ceil(split/2);

for i=1:split

	[Si{i},sq{i},sweeps{i}]=PlotRasterPETHCouleur2(S,neuron,EEGf,Epoch,'I',st,to,(i-1)*2*pi/split,i*2*pi/split,A(floor(i*64/split),:),BinSize,1,Avant,Apres);
	if smo>0
    figure(2), hold on, plot(Range(sq{i}, 'ms'), SmoothDec(Data(sq{i})/length(sweeps{i}),smo), 'Color',A(floor(i*64/split),:), 'lineWidth',2);
    else
    figure(2), hold on, plot(Range(sq{i}, 'ms'), Data(sq{i})/length(sweeps{i}), 'Color',A(floor(i*64/split),:), 'lineWidth',2);   
    end

end
tt=Range(sq{i}, 'ms');
figure(2), xlim([tt(1) tt(end)])
yl=ylim;
line([0 0],yl,'color','k', 'linestyle','--')


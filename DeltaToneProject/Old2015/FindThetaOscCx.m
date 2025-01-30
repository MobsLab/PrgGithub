function [Epoch,val,val2]=FindThetaOscCx(Sp,t,f,EpochTest,plo,lim3)


% tic

try
    plo;
catch 
    plo=0;
end

lim1=[4 10];
lim2=[1 4];
try
    lim3;
catch
    lim3=[10 12];%[5 6];
end
a=1;
th=2;

if plo
    figure('color',[1 1 1]),
end
for fac=1:2:18
    Stsd=tsd(t*1E4,Sp);
    V1=mean(Sp(:,find(f>lim1(1)&f<lim1(2))),2);
    V2=mean(Sp(:,find(f>lim2(1)&f<lim2(2))),2);
    V3=mean(Sp(:,find(f>lim3(1)&f<lim3(2))),2);
    Vts=tsd(t*1E4,(V1./mean([V2,fac*V3],2)));
    
    EpochUp=thresholdIntervals(Vts,th,'Direction','Above');
    try
    Epoch{a}=and(EpochUp,EpochTest);
    val(a)=length(find(Data(Restrict(Vts,EpochTest))>th))/length(Data(Restrict(Vts,EpochTest)))*100;
    val2(a)=mean(V2)/(fac*mean(V3));
    catch
     Epoch{a}=intervalSet([],[]);
     val(a)=0;
     val2(a)=0;
    end
    
    if plo
    subplot(3,3,a),
    imagesc(Range(Restrict(Vts,Epoch{a}),'s'),f,10*log10(Data(Restrict(Stsd,Epoch{a})))'), axis xy
    hold on, plot(Range(Restrict(Vts,Epoch{a}),'s'),Data(Restrict(Vts,Epoch{a}))*50,'k')
    title([num2str(fac), ', ', num2str(floor(val(a)*10)/10),'%, ', num2str(floor(mean(V2)/(fac*mean(V3))*10)/10)])
    end
    a=a+1;
end

Vts2=tsd(t*1E4,(V1./V2));

EpochUp=thresholdIntervals(Vts2,th,'Direction','Above');
Epoch{a}=and(EpochUp,EpochTest);
val(a)=length(find(Data(Restrict(Vts,EpochTest))>th))/length(Data(Restrict(Vts,EpochTest)))*100;
val2(a)=mean(V2./V1);

a=a+1;
EpochUp=thresholdIntervals(Vts2,1,'Direction','Above');
Epoch{a}=and(EpochUp,EpochTest);
val(a)=length(find(Data(Restrict(Vts,EpochTest))>1))/length(Data(Restrict(Vts,EpochTest)))*100;
val2(a)=mean(V2./V1);
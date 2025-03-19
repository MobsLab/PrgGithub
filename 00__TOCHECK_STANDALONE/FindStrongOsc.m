function [Epoch,val,val2]=FindStrongOsc(Sp,t,f,EpochTest,plo,lim1, lim2,lim3)

% this fct finds the periods of strong oscillations in a given
% frequence range(lim1) by selecting intervals in which intensity in lim1 is above 
% the mean intensity in the frequency range below (lim2) and above (lim3)
% (done for different weight of lim 3
% plot : 9 nine 
%
% INPUTS
% Sp : spectrum
% t : time in SECONDS
% f : frequency range
% lim1 : frequency range of interest
% lim2 : frequency range below
% lim3 : frequency range above
%
% OUTPUTS
% Epoch : intervalset (period of strong oscillations)
% val : percentage of the time of the session selected by the fct
% val2 : ratio between intensity in lim2 and lim3 in the selected intervals
%
% MOBS team april 2015

try
    plo;
catch 
    plo=0;
end

a=1;
th=2; % threshold for comparison: intensity in lim1 should be above th*(intensity in lim2 and lim 3) 

if plo
    figure('color',[1 1 1],'Position',[  1922  168  1275  662]),
end

% intensity of signal in lim1 is compared to intensity in lim2 and lim 3, 
% lim 3 is multiplied by an increasing factor  'fac' (criterion more and
% more drastic)
for fac=1:2:18 
    Stsd=tsd(t*1E4,Sp);
    V1=mean(Sp(:,find(f>lim1(1)&f<lim1(2))),2); % average Sp on frequency band lim1
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
    subplot(4,3,a),
    imagesc(Range(Restrict(Vts,Epoch{a}),'s'),f,10*log10(Data(Restrict(Stsd,Epoch{a})))'), axis xy
    hold on, plot(Range(Restrict(Vts,Epoch{a}),'s'),Data(Restrict(Vts,Epoch{a}))*50,'k')
    title([num2str(fac), ', ', num2str(floor(val(a)*10)/10),'% of period, low/high = ', num2str(floor(mean(V2)/(fac*mean(V3))*10)/10)])
    end
    a=a+1;
end

fac=fac+1;
% same, only taking into acount signal intensity in lim2 
% lim1 compared to lim2*2
Vts2=tsd(t*1E4,(V1./V2));
EpochUp=thresholdIntervals(Vts2,th,'Direction','Above');
Epoch{a}=and(EpochUp,EpochTest);
val(a)=length(find(Data(Restrict(Vts,EpochTest))>th))/length(Data(Restrict(Vts,EpochTest)))*100;
val2(a)=mean(V2./V1);
if plo
    subplot(4,3,a),
    imagesc(Range(Restrict(Vts,Epoch{a}),'s'),f,10*log10(Data(Restrict(Stsd,Epoch{a})))'), axis xy
    hold on, plot(Range(Restrict(Vts,Epoch{a}),'s'),Data(Restrict(Vts,Epoch{a}))*50,'k')
    title([num2str(fac), ', ', num2str(floor(val(a)*10)/10),'% of period, comp to 2 x low'])
end
a=a+1;   

% lim1 compared to lim2 (same lines except the 1st one)
fac=fac+1;
EpochUp=thresholdIntervals(Vts2,1,'Direction','Above');
Epoch{a}=and(EpochUp,EpochTest);
val(a)=length(find(Data(Restrict(Vts,EpochTest))>1))/length(Data(Restrict(Vts,EpochTest)))*100;
val2(a)=mean(V2./V1);
if plo
    subplot(4,3,a),
    imagesc(Range(Restrict(Vts,Epoch{a}),'s'),f,10*log10(Data(Restrict(Stsd,Epoch{a})))'), axis xy
    hold on, plot(Range(Restrict(Vts,Epoch{a}),'s'),Data(Restrict(Vts,Epoch{a}))*50,'k')
    title([num2str(fac), ', ', num2str(floor(val(a)*10)/10),'% of period, comp to low'])
end

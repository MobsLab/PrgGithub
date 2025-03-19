
function [zeroCrossTsd,AmplitudeRespi,Zinteger,zeroCross,zeroMeanValue]=FindZeroCrossML(tsa,param,integer)

%params [3*1E4 6 1]
DesiredSampling=50;%Hz
try
    integer(1);
catch
    integer=0;
end
try
    param(1);
    fac=param(1);
catch
    fac=0;
end

try
    param(2);
    smo=param(2);
catch
    smo=0;
end
try
    param(3);
    plo=param(3);
catch
    plo=0;
end
eegd=SmoothDec(Data(tsa),smo)'-fac;
eegdINI=SmoothDec(Data(tsa),smo)';
td=Range(tsa);

eegdplus1=[0 eegd];
eegdplus0=[eegd 0];
zeroCross1=find(eegdplus0<0 & eegdplus1>0);
zeroCross2=find(eegdplus0>0 & eegdplus1<0);
zeroCrossIdx = [zeroCross1 zeroCross2];
zeroCrossIdx = sort(zeroCrossIdx);
zeroCross=td(zeroCrossIdx);

if length(zeroCrossIdx)<1
    disp('Problem')
    zeroCrossTsd=nan;
    AmplitudeRespi=nan;
    zeroCross=nan;
    zeroMeanValue=nan;
    maxAmpIndx=nan;
else
    
    if integer 
        
        Z=ones(1,length(zeroCrossIdx)-1);timeAmp=Z-1;
        for ii=1:length(zeroCrossIdx)-1
            Z(ii)=trapz(eegdINI(zeroCrossIdx(ii):zeroCrossIdx(ii+1))-fac);
           
            if Z(ii)>=0, 
                timeAmp(ii)=zeroCrossIdx(ii)+min(find(eegdINI(zeroCrossIdx(ii):zeroCrossIdx(ii+1))==max(eegdINI(zeroCrossIdx(ii):zeroCrossIdx(ii+1)))))-1;
            else
                timeAmp(ii)=zeroCrossIdx(ii)+min(find(eegdINI(zeroCrossIdx(ii):zeroCrossIdx(ii+1))==min(eegdINI(zeroCrossIdx(ii):zeroCrossIdx(ii+1)))))-1;
            end
            zeroMeanValue(ii)=Z(ii);
            maxAmpIndx(ii)=Z(ii);
        end
        
        Zinteger=tsd(td(zeroCrossIdx(1:end-1)),Z');
        
        zeroMeanValue(length(zeroCrossIdx))=zeroMeanValue(length(zeroCrossIdx)-1);
        zeroCrossTsd=tsd(td(zeroCrossIdx),zeroMeanValue');
        
        temp=abs(zeroMeanValue(1:2:end-1))+abs(zeroMeanValue(2:2:end));
        try AmplitudeRespi=tsd(td(timeAmp(1:2:end-1)),temp');
        catch, AmplitudeRespi=tsd(td(timeAmp(1:2:end)),temp');
        end
        
        ok='n';
        while ok~='y'
        figure('Color',[1 1 1]), plot(Range(Zinteger,'s'),Data(Zinteger))
        hold on, plot(Range(zeroCrossTsd,'s'),Data(zeroCrossTsd),'r.')
        hold on, plot(Range(AmplitudeRespi,'s'),Data(AmplitudeRespi),'g.')
        hold on, plot(Range(tsa,'s'),Data(tsa)*100,'k')
        legend('trapz(Respi)','ZeroCross','Amplitude','Respi')
        ok=input('Are you satisfied with the calculated signal integer and amplitude? (y/n) ','s');
        if ok~='y'; keyboard; else close;end
        end
    else
        for ii=1:length(zeroCrossIdx)-1
            
            zeroMeanValue(ii)=max(abs(eegdINI(zeroCrossIdx(ii):zeroCrossIdx(ii+1))));
            
            if max(abs(eegdINI(zeroCrossIdx(ii):zeroCrossIdx(ii+1))))==max(eegdINI(zeroCrossIdx(ii):zeroCrossIdx(ii+1)))
                maxAmpIndx(ii)=zeroCrossIdx(ii)+min(find(eegdINI(zeroCrossIdx(ii):zeroCrossIdx(ii+1))==max(eegdINI(zeroCrossIdx(ii):zeroCrossIdx(ii+1)))))-1;
            else
                maxAmpIndx(ii)=zeroCrossIdx(ii)+min(find(eegdINI(zeroCrossIdx(ii):zeroCrossIdx(ii+1))==min(eegdINI(zeroCrossIdx(ii):zeroCrossIdx(ii+1)))))-1;
                zeroMeanValue(ii)=-zeroMeanValue(ii);
            end
        end
        
        zeroMeanValue(length(zeroCrossIdx))=zeroMeanValue(length(zeroCrossIdx)-1);
        zeroCrossTsd=tsd(td(zeroCrossIdx),zeroMeanValue');
        
        AmplitudeRespi=abs(zeroMeanValue(1:2:end-1))+abs(zeroMeanValue(2:2:end));
        
        try
            
            if mean(zeroMeanValue(1:2:end-1))>mean(zeroMeanValue(2:2:end))
                ad=length(maxAmpIndx(1:2:end))-length(AmplitudeRespi);
                if ad<0 AmplitudeRespi=tsd(td(maxAmpIndx(1:2:end))',AmplitudeRespi(1:end+ad)');
                else AmplitudeRespi=tsd(td(maxAmpIndx(1:2:end-ad))',AmplitudeRespi');
                end
                
            else
                ad=length(maxAmpIndx(2:2:end))-length(AmplitudeRespi);
                if ad<0 AmplitudeRespi=tsd(td(maxAmpIndx(2:2:end))',AmplitudeRespi(1:end+ad)');
                else AmplitudeRespi=tsd(td(maxAmpIndx(2:2:end-ad))',AmplitudeRespi');
                end
            end
        catch
            disp('Error FindZeroCrossML')
            keyboard
        end
        
    end
    
    if plo
        figure('color',[1 1 1]), hold on,
        plot(Range(tsa,'s'),-Data(tsa),'m')
        plot(Range(tsa,'s'),-SmoothDec(Data(tsa),smo),'b','linewidth',2)
        plot(Range(zeroCrossTsd,'s'),zeroMeanValue,'ko','markerfacecolor','k')
        plot(Range(AmplitudeRespi,'s'),Data(AmplitudeRespi)/2,'ko','markerfacecolor','y')
        plot(Range(zeroCrossTsd,'s'),fac+zeros(length(Range(zeroCrossTsd,'s')),1),'ro','markerfacecolor','r')
        set(gcf,'position',[5 56 1826 420])
    end
end





















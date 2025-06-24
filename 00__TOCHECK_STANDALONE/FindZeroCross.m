
function [zeroCrossTsd,AmplitudeRespi,zeroCross,zeroMeanValue]=FindZeroCross(tsa,param)

%params [3*1E4 6 1]


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
    else
        
         for ii=1:length(zeroCrossIdx)-1
           zeroMeanValue(ii)=max(abs(eegdINI(zeroCrossIdx(ii):zeroCrossIdx(ii+1)))); 
         end

        zeroMeanValue(length(zeroCrossIdx))=zeroMeanValue(length(zeroCrossIdx)-1);
        zeroCrossTsd=tsd(td(zeroCrossIdx),zeroMeanValue');  

        AmplitudeRespi=zeroMeanValue(1:2:end-1)+zeroMeanValue(2:2:end);
        
        tdiff=diff(zeroCross);
        if mean(tdiff(1:2:end))>mean(tdiff(2:2:end))   
                try
                AmplitudeRespi=tsd(zeroCross(1:2:end),AmplitudeRespi');
                catch
                AmplitudeRespi=tsd(zeroCross(1:2:end-1),AmplitudeRespi');
                end
        else
                try
                AmplitudeRespi=tsd(zeroCross(2:2:end),AmplitudeRespi');
                catch
                AmplitudeRespi=tsd(zeroCross(2:2:end-1),AmplitudeRespi');
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
    
    
    
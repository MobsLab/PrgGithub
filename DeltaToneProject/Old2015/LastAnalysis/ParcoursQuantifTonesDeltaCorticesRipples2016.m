function [ResTones,Res]=ParcoursQuantifTonesDeltaCorticesRipples2016(Generate,exp,ton)

try
    savfig;
catch
    savfig=0;
end

try
    Generate;
catch
    Generate=1;
end

try
    exp;
catch
    exp='Basal';
end

try
    ton;
catch
    ton=1;
end

cd /media/DataMOBsRAID/ProjetBreathDeltaFeedback



if Generate
    Dir=PathForExperimentsDeltaSleep2016(exp);
    a=1;
    for i=1:length(Dir.path)
        %            try
        disp(' ')
        disp('****************************************************************')
        eval(['cd(Dir.path{',num2str(i),'}'')'])
        disp(pwd)
        [Res(a,:),ResTones(a,:),dpfcRip(a,:),dpfcNoRip(a,:)]=QuantifTonesDeltaCorticesRipples2016(ton,0.14*1E4);
        
        disp('generation of Quantif Delta Cortices Ripples 2016')
        MiceName{a}=Dir.name{i};
        PathOK{a}=Dir.path{i};
        a=a+1;
    end
    clear savfig
    cd /media/DataMOBsRAID/ProjetBreathDeltaFeedback
    eval(['save ParcoursQuantifTonesDeltaCorticesRipples2015',exp,'-Tone',num2str(ton)])
end

figure('color',[1 1 1]),
subplot(2,1,1), PlotErrorBarN(dpfcRip,0);title('Nb Delta Pfc Rip'), subplot(2,1,2),PlotErrorBarN(dpfcNoRip,0);title('Nb Delta Pfc  no Rip')

k=0;
k=k+1; ti{k}='SPW-Rs';
k=k+1; ti{k}='Delta Pfc';
k=k+1; ti{k}='SWS';
k=k+1; ti{k}='REM';
k=k+1; ti{k}='Wake';
k=k+1; ti{k}='SPW with tones';
k=k+1; ti{k}='SPW without tones';
k=k+1; ti{k}='Delta Pfc with tones';
k=k+1; ti{k}='Delta Pfc without tones';


try
exp==(['Basal']);
    a=1;
    figure('color',[1 1 1])
    for i=1:5:25
        subplot(2,3,a), PlotErrorBarN(Res(:,i:i+4),0);try, title(ti{a}), end
        a=a+1;
    end
    
    a=1;
    figure('color',[1 1 1])
    for i=1:5:25
        subplot(2,3,a), PlotErrorBarN(Res(:,i:i+4)./Res(:,11:15),0);try, title(ti{a}), end
        a=a+1;
    end
catch
    a=1;
    figure('color',[1 1 1])
    for i=1:5:45
        subplot(3,3,a), PlotErrorBarN(Res(:,i:i+4),0);try, title(ti{a}), end
        a=a+1;
    end
    
    a=1;
    figure('color',[1 1 1])
    for i=1:5:45
        subplot(3,3,a), PlotErrorBarN(Res(:,i:i+4)./Res(:,11:15),0);try, title(ti{a}), end
        a=a+1;
    end
end
    
end



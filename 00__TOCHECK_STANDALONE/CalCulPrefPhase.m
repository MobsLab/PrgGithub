function [Ph,phasesandtimes,powerTsd]=CalCulPrefPhase(S,Fil,method)

%[Ph,phasesandtimes,powerTsd]=CalCulPrefPhase(S,Fil,method)
%
% method = Hilbert or Francesco
%

try
    S=tsdArray(S);
end

% method = Hilbert or Francesco


zr = hilbert(Data(Fil));
power=abs(zr);
powerTsd=tsd(Range(Fil),power);

if method(1)=='H'


   
    [phaseTsd, Ph] = firingPhaseHilbert(Fil, S) ;

    for i=1:length(S)
    phasesandtimes{i}=tsd(Range(S{i}),Data(Ph{i}));
    end
    
    phasesandtimes=tsdArray(phasesandtimes);

else
        
    [phe, thpeaks] = TethaPhase2(S, Fil);
        for i=1:length(S)
        temp=Data(phe{i});
        Phe=temp(:,1);
        Ph{i}=tsd(sort(Phe(:,1)*2*pi),Phe(:,1)*2*pi);
        try
            phasesandtimes{i}=tsd(Range(S{1}),Phe(:,1)*2*pi);
        catch
            phasesandtimes{i}=tsd(0,0);
        end
        clear Phe
        end
    Ph=tsdArray(Ph);
    phasesandtimes=tsdArray(phasesandtimes);
    
    
end


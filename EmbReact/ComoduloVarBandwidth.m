function [LowFreqVals,HighFreqVals,Dkl,DklSurr,Prc99]=ComoduloVarBandwidth(LFPlow,LFPhigh,LowFreqRg,HighFreqRg,LowFreqStep,HighFreqStep,BinNumbers,plo,NumSurrogates)

%% Function changed from original Comodulo function to adapt the bandwidth of the amp-frequ to that of the phase-freq
%% SB nov. 2016

% [VFreq0,VFreq1,Comodulo]=comodulo(LFPi,LFPo,LowFreqRg,HighFreqRg,plo)
% LFPlow = the low frequency LFP, that will be used to extract phase
% LFPhigh = the high frequency LFP, that will be used to extract amplitude
% LowFreqRg=[Fdeb Ffin]; frequency for phase , ex --> [2 15]
% HighFreqRg=[Fdeb Ffin]; frequency for amp ex--> [30 200]
% LowFreqStep : sampling of low frequencies; ex--> 1Hz between each freq
% HighFreqStep : sampling of high frequencies ex--> 4Hz between each freq
% Bin Numbers  : how many bins in 360° : suggested 18
% plo=1 for plot, plo=0 for no plot
% NumSurrogates=0 if no surrogate data is to be generated for statistical
% tesing, otherwise give number of passes to perform. ex 200

try,plo;catch,plo=1;end
interval=360/BinNumbers;
% Uniform distribution
U=ones(1,BinNumbers);
U=U/sum(U);
SurrLim=99;
tic

LowFreqVals=[LowFreqRg(1):LowFreqStep:LowFreqRg(2)];
HighFreqVals=[HighFreqRg(1):HighFreqStep:HighFreqRg(2)];

%% MI looping
for ll=1:length(LowFreqVals)
    
    % Filter modulating signal at a given low frequency
    LowFilterCenter=LowFreqVals(ll);
    if LowFilterCenter<12
        fi=1024;
    elseif LowFilterCenter<30
        fi=512;
    else
        fi=256;
    end
    FilLFPL=FilterLFP(LFPlow,[LowFilterCenter-0.5 LowFilterCenter+1],fi);
    HilLow=hilbert(Data(FilLFPL));
    PhaseLFP=angle(HilLow)*180/pi+180;
    BinnedPhase=floor(PhaseLFP/interval)+1;
    
    % Surrogartes for Stats
    for ns=1:NumSurrogates
        snip=ceil(rand(1)*length(PhaseLFP));
        PhaseLFPSurr=[PhaseLFP(snip:end);PhaseLFP(1:snip-1)];
        BinnedPhaseSurr{ns}=floor(PhaseLFPSurr/interval)+1;
    end
    
    
    for hh=1:length(HighFreqVals)
        clear P
        HighFilterCenter=HighFreqVals(hh);
        if HighFilterCenter>LowFilterCenter*2
            if HighFilterCenter<12
                fi=1024;
            elseif HighFilterCenter<30
                fi=512;
            else
                fi=256;
            end
            
            FilLFPH=FilterLFP(LFPhigh,[HighFilterCenter-LowFilterCenter HighFilterCenter+LowFilterCenter],fi);
            HilHigh=hilbert(Data(FilLFPH));
            AmpLFP=abs(HilHigh);
            
            for i=1:BinNumbers
                P(i)=mean(AmpLFP(find(BinnedPhase==i)));
            end
            %normalisation
            P=P/sum(P);
            %MI calculation
            Dkl(ll,hh)=(log(BinNumbers)+sum(P.*log(P)))./log(BinNumbers);
            
            % Surrogates for Stats
            for ns=1:NumSurrogates
                P=[];
                for i=1:BinNumbers
                    P(i)=mean(AmpLFP(find(BinnedPhaseSurr{ns}==i)));
                end
                %normalisation
                P=P/sum(P);
                %MI calculation
                DklSurr{ns}(ll,hh)=(log(BinNumbers)+sum(P.*log(P)))./log(BinNumbers);
            end
            
        else
            Dkl(ll,hh)=NaN;
            for ns=1:NumSurrogates
                DklSurr{ns}(ll,hh)=NaN;
            end
        end
    end
end




%% display

if plo==1
    if NumSurrogates==0
    figure
    imagesc(LowFreqVals,HighFreqVals,Dkl'), axis xy
    DklSurr=[];
    Prc99=[];
    else
       
        for k=1:length(LowFreqVals)
            for l=1:length(HighFreqVals)
                temp=[];
                for s=1:NumSurrogates
                    temp=[temp,DklSurr{s}(k,l)];
                end
                Prc99(k,l)=prctile(temp,SurrLim);
            end
        end
        figure
        subplot(121)
        imagesc(LowFreqVals,HighFreqVals,Dkl'), axis xy, freezeColors
        xlabel('Modulating Freq'),ylabel('carrier frequency')
        subplot(122)
        imagesc(LowFreqVals,HighFreqVals,Dkl'.*(Dkl'>Prc99')), axis xy
        xlabel('Modulating Freq'),ylabel('carrier frequency')
        colormap([[1,1,1];paruly])
        
    end
    
    
   
end


toc



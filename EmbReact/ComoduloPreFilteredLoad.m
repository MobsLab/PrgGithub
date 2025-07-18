function [LowFreqVals,HighFreqVals,Dkl,DklSurr,Prc99]=ComoduloPreFilteredLoad(FilteredLowLoadName,FilteredHighSaveName,LowFreqRg,HighFreqRg,LowFreqStep,HighFreqStep,BinNumbers,plo,NumSurrogates)


%% Function changed fril ComoduloVarBandwidth to allow input of signal filtered in the correct bands
%% Function changed from original Comodulo function to adapt the bandwidth of the amp-frequ to that of the phase-freq
%% SB nov. 2016
%% function changed again to successively load the required files to avoid overloading matlab's memory

% [VFreq0,VFreq1,Comodulo]=comodulo(FilteredLow,FilteredHigh,LowFreqRg,HighFreqRg,LowFreqStep,HighFreqStep,BinNumbers,plo,NumSurrogates)
% FilteredLow = the low frequency LFP already filtered in the correct bands, that will be used to extract phase
% LFPhigh = the high frequency LFP already filtered in the correct bands, that will be used to extract amplitude
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


% Load Low frequency
load(FilteredLowLoadName);FilteredLow=LowFilLFP.FilLFP;clear LowFilLFP;

%% MI looping
for ll=1:length(LowFreqVals)
    
    % Filter modulating signal at a given low frequency
    LowFilterCenter=LowFreqVals(ll);

    HilLow=hilbert(Data(FilteredLow{ll}));
    PhaseLFP=angle(HilLow)*180/pi+180;
    BinnedPhase=floor(PhaseLFP/interval)+1;
    
    % Surrogartes for Stats
    for ns=1:NumSurrogates
        snip=ceil(rand(1)*length(PhaseLFP));
        PhaseLFPSurr=[PhaseLFP(snip:end);PhaseLFP(1:snip-1)];
        BinnedPhaseSurr{ns}=floor(PhaseLFPSurr/interval)+1;
    end
    
    % load correct HighFrequFiltered signal
    load([FilteredHighSaveName,num2str(LowFreqVals(ll)),'.mat'])
    FilteredHigh=HighFilLFP.FilLFP; clear HighFilLFP
    
    for hh=1:length(HighFreqVals)
        clear P
        HighFilterCenter=HighFreqVals(hh);
        if HighFilterCenter>LowFilterCenter*2
            
            HilHigh=hilbert(Data(FilteredHigh{hh}));
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
    clear FilteredHigh
end




%% display




if NumSurrogates==0
    DklSurr=[];
    Prc99=[];
    if plo==1
        figure
        imagesc(LowFreqVals,HighFreqVals,Dkl'), axis xy
    end
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
    if plo==1
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



%% Comodulation in three states : REM, SWS, Locomotion
clear all


Files=PathForExperimentsEmbReact('Habituation');
% Params
LowFreqRg=[2 15];
HighFreqRg=[30 250];
LowFreqStep=1;
HighFreqStep=4;
BinNumbers=18;
NumSurrogates=200;
Struc={'HPC','OB','PFCx'};
DidntWork={};d=1;

for pp=1:length(Files.path)
    pp
    for c=1
        try
            cd(Files.path{pp}{c})
            try
                load('ChannelsToAnalyse/dHPC_deep.mat')
                chH=channel;
            catch
                
                load('ChannelsToAnalyse/dHPC_rip.mat')
                chH=channel;
            end
            load(['LFPData/LFP',num2str(chH),'.mat']);
            [y, ARmodel] = WhitenSignal(Data(LFP),[],1,[],2);
            LFPAll.HPC=tsd(Range(LFP),y);
            
            load('ChannelsToAnalyse/Bulb_deep.mat')
            chB=channel;
            load(['LFPData/LFP',num2str(chB),'.mat']);
            [y, ARmodel] = WhitenSignal(Data(LFP),[],1,[],2);
            LFPAll.OB=tsd(Range(LFP),y);
            
            load('ChannelsToAnalyse/PFCx_deep.mat')
            chP=channel;
            load(['LFPData/LFP',num2str(chP),'.mat']);
            [y, ARmodel] = WhitenSignal(Data(LFP),[],1,[],2);
            LFPAll.PFCx=tsd(Range(LFP),y);
            
            Epoch=intervalSet(0,max(Range(LFP)));
            
            for ss=1:3
                ss
                for sss=1:3
                    [LowFreqVals,HighFreqVals,Dkl{ss,sss},~,~]=ComoduloVarBandwidth(Restrict(eval(['LFPAll.',Struc{ss}]),Epoch),Restrict(eval(['LFPAll.',Struc{sss}]),Epoch),LowFreqRg,HighFreqRg,...
                        LowFreqStep,HighFreqStep,BinNumbers,1,0);
                end
            end
            save('CoModulo3StrucWhit.mat','Dkl','Prc99')
            clear Dkl Prc99
        catch
            DidntWork{d}=Files.path{pp}{c};
            d=d+1;
        end
    end
end

figure
            for ss=1:3
                ss
                for sss=1:3
subplot(3,3,(ss-1)*3+sss)
imagesc(LowFreqVals,HighFreqVals,Dkl{ss,sss}'), axis xy
                end
            end




MultiFilLFP=FilterRangeOfBdWidths(LFP,FreqRg,FreqStep,BandWidth,HalBandWidth)
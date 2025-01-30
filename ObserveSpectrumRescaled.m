function [val,SpectrumN1,SpectrumN2,SpectrumN3,SpectrumSWS,SpectrumREM,SpectrumWake]=ObserveSpectrumRescaled(struct,tps,nbfreq,plo)


% 
% cd('/Volumes/My Passport/DataElectroPhy/DataMice/SleepBasal/Mouse243')
% cd('/Volumes/My Passport/DataElectroPhy/DataMice/SleepBasal/Mouse244')
% cd('/Volumes/My Passport/DataElectroPhy/DataMice/Mouse244/20150220/Breath-Mouse-244-20022015')


plo=0;

try
    tps(1);
catch
    tps=[0:0.05:1];
end

try
   nbfreq(1);
catch
   nbfreq=40;
end


try
        load NREMsubstages
        MATEP;
        nameEpochs;
    catch
        load StateEpochSB TotalNoiseEpoch
        % dans un dossier particulier
        [op,NamesOp,Dpfc,Epoch,noise]=FindNREMepochsML;
        %NamesOp={'PFsupOsci','PFdeepOsci','BurstDelta','REM','WAKE','SWS','PFswa','OBswa'}
        [MATEP,nameEpochs]=DefineSubStages(op,TotalNoiseEpoch);
        N1=MATEP{1};
        N2=MATEP{2};
        N3=MATEP{3};
        save NREMsubstages N1 N2 N3 MATEP nameEpochs op NamesOp Dpfc Epoch noise TotalNoiseEpoch
end
    

load StateEpochSB SWSEpoch REMEpoch Wake
% load ChannelsToAnalyse/dHPC_deep

try
    eval(['load ChannelsToAnalyse/',struct,'_deep'])
    eval(['load(''SpectrumDataL/Spectrum',num2str(channel),'.mat'')'])
    Sp;
catch
        load LFPData/InfoLFP.mat
        eval(['load ChannelsToAnalyse/',struct,'_deep'])
        [params,movingwin,suffix]=SpectrumParametersML('low');
        ComputeSpectrogram_newML(movingwin,params,InfoLFP,struct,'deep',suffix);
        eval(['load(''SpectrumDataL/Spectrum',num2str(channel),'.mat'')'])
end

        
Stsd=tsd(t*1E4,Sp);

SpectrumN1=RescaleSpectroram0to1(Stsd,f, MATEP{1},tps,nbfreq);
SpectrumN2=RescaleSpectroram0to1(Stsd,f, MATEP{2},tps,nbfreq);
SpectrumN3=RescaleSpectroram0to1(Stsd,f, MATEP{3},tps,nbfreq);
SpectrumSWS=RescaleSpectroram0to1(Stsd,f, SWSEpoch,tps,nbfreq);
SpectrumREM=RescaleSpectroram0to1(Stsd,f, REMEpoch,tps,nbfreq);
SpectrumWake=RescaleSpectroram0to1(Stsd,f, Wake,tps,nbfreq);

val(1,:)=mean(SpectrumN1(:,4:8),2);
val(2,:)=mean(SpectrumN2(:,4:8),2);
val(3,:)=mean(SpectrumN3(:,4:8),2);
val(4,:)=mean(SpectrumSWS(:,4:8),2);
val(5,:)=mean(SpectrumREM(:,12:20),2);
val(6,:)=mean(SpectrumWake(:,12:20),2);

if plo
figure('color',[1 1 1])
subplot(6,1,1), imagesc(tps,f,10*log10(SmoothDec(SpectrumN1,[0.8 0.5]))'), axis xy
subplot(6,1,2), imagesc(tps,f,10*log10(SmoothDec(SpectrumN2,[0.8 0.5]))'), axis xy
subplot(6,1,3), imagesc(tps,f,10*log10(SmoothDec(SpectrumN3,[0.8 0.5]))'), axis xy
subplot(6,1,4), imagesc(tps,f,10*log10(SmoothDec(SpectrumSWS,[0.8 0.5]))'), axis xy
subplot(6,1,5), imagesc(tps,f,10*log10(SmoothDec(SpectrumREM,[0.8 0.5]))'), axis xy
subplot(6,1,6), imagesc(tps,f,10*log10(SmoothDec(SpectrumWake,[0.8 0.5]))'), axis xy
end



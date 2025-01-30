
function [TidalVolume,Frequency,fac,multCalib,NormRespiTSD,newRespiTSD,zeroCrossTsd,CorrectedzeroCrossTsd]=PlethysmoSignalML(RespiTSD,CalibrationTSD,smo,plo,aberentThreshold)

% [TidalVolume,Frequency,fac,multCalib,newRespiTSD,zeroCrossTsd,Correctedze
% roCrossTsd]=PlethysmoSignalML(RespiTSD,CalibrationTSD,smo,plo,aberentThreshold)
%
% inputs:
% RespiTSD = tsd of Plethysmograph row signal 
% smo = smoothing parameter

% outputs:
% TidalVolume = tsd( time of inspiration start, TidalVolume of this inspiration) 
% Frequency = tsd( time of inspiration start, instantaneous frequency (Hz) of this respiration cycle)
% fac = parameter giving the baseline of plethysmograph signal
% multCalib = parameter of volume calibration
% zeroCrossTsd =
% CorrectedzeroCrossTsd =



%% initialisation

if ~exist('smo','var');  smo=0;end
if ~exist('plo','var');  plo=0;end

newRespiTSD=FilterLFP(RespiTSD,[1 10]);
if exist('aberentThreshold','var')
    tempR=Range(newRespiTSD);
    tempD=Data(newRespiTSD);
    indx=find(abs(tempD)<aberentThreshold);
    newRespiTSD=tsd(tempR(indx),tempD(indx));
    clear tempR tempD indx
end


%% param

figure('Color',[1 1 1]), hist(Data(newRespiTSD),1000); 
xlabel('distribution of RespiTSD values'); title('click on the value of the histogram between the two peaks');
disp('click on the value of the histogram between the two peaks');
fac=ginput(1); close; fac=fac(1);


%% Calibration

eegd=SmoothDec(Data(CalibrationTSD),smo)'-fac;
td=Range(CalibrationTSD);

eegdplus1=[0 eegd];
eegdplus0=[eegd 0];
zeroCrossIdx = [find(eegdplus0<0 & eegdplus1>0) find(eegdplus0>0 & eegdplus1<0)];
zeroCrossIdx = sort(zeroCrossIdx);

IntegerBetwZC=zeros(1,length(zeroCrossIdx)-1);
for ii=1:length(zeroCrossIdx)-1
    IntegerBetwZC(ii)=trapz(eegd(zeroCrossIdx(ii):zeroCrossIdx(ii+1)));
end
AmpInteger=tsd(td(zeroCrossIdx(1:end-1)),IntegerBetwZC');

ok='n';
while ok~='y'
    figure('Color',[1 1 1]), plot(Range(AmpInteger,'s'),Data(AmpInteger))
    nbcal=input('Enter the different volumes of aspiration in mL for calibration (e.g. [0.3 0.1 0.2]): ');
    disp('Follow instructions on figure..');
    for j=1:length(nbcal)
        title(['Click min of the ',num2str(nbcal(1,j)),'mL period for tidal volume'])
        A=ginput(1);
        nbcal(2,j)=A(2);
        hold on, line([A(1) A(1)],[nbcal(2,j) 0],'color','r','linewidth',2)
        text(A(1),A(2)*1.1,[num2str(nbcal(1,j)),'mL'])
    end
    multCalib=mean(nbcal(1,:)./abs(nbcal(2,:)));
    title(['multcalib = ',num2str(multCalib)]);
    
    ok=input('Are you satisfied with calibration (y/n)? ','s');
    close
end



%% zerocross

eegd=SmoothDec(Data(newRespiTSD),smo)'-fac;

td=Range(newRespiTSD);

eegdplus1=[0 eegd];
eegdplus0=[eegd 0];
zeroCross1=find(eegdplus0<0 & eegdplus1>0);
zeroCross2=find(eegdplus0>0 & eegdplus1<0);
zeroCrossIdx = [zeroCross1 zeroCross2];
zeroCrossIdx = sort(zeroCrossIdx);


%% TidalVolume & Frequency

if length(zeroCrossIdx)<1
    disp('Problem')
    TidalVolume=nan;
    Frequency=nan;
    zeroCrossTsd=nan;
else
    
    % ZeroCross tsd
    zeroCrossTsd=tsd(td(zeroCrossIdx),zeros(1,length(zeroCrossIdx))'+fac);

    
    % integer between two zerocross
    IntegerBetwZC=zeros(1,length(zeroCrossIdx)-1);
    for ii=1:length(zeroCrossIdx)-1
        IntegerBetwZC(ii)=trapz(eegd(zeroCrossIdx(ii):zeroCrossIdx(ii+1)));
    end
    
    
    % remove aberent detected zerocross
    
    nAbZC = hist(abs(IntegerBetwZC),100);
    if nAbZC(1)<0.1*sum(nAbZC)
        temp= sort(abs(IntegerBetwZC));
        
        nAbZC=temp(nAbZC(1));
        
        CorrectedzeroCrossIdx=zeroCrossIdx(1:end-1);
        CorrectedzeroCrossIdx(find(abs(IntegerBetwZC)<nAbZC))=[];
        
        CorrectedIntegerBetwZC=zeros(1,length(CorrectedzeroCrossIdx)-1);
        for ii=1:length(CorrectedzeroCrossIdx)-1
            CorrectedIntegerBetwZC(ii)=trapz(eegd(CorrectedzeroCrossIdx(ii):CorrectedzeroCrossIdx(ii+1)));
        end
        CorrectedzeroCrossTsd=tsd(td(CorrectedzeroCrossIdx),zeros(1,length(CorrectedzeroCrossIdx))'+fac);
    else
        nAbZC=0;
        CorrectedzeroCrossIdx=zeroCrossIdx;
        CorrectedIntegerBetwZC=IntegerBetwZC;
        CorrectedzeroCrossTsd=zeroCrossTsd;
    end
    
    
    
    % TidalVolume
    TidalVolume=tsd(td(CorrectedzeroCrossIdx(find(CorrectedIntegerBetwZC<0))),-multCalib*CorrectedIntegerBetwZC(find(CorrectedIntegerBetwZC<0))');
    
    
    % instaneous frequency
    TempRange=Range(TidalVolume);
    Frequency=tsd(TempRange(1:end-1),1E4./diff(TempRange)); %Hz
    
    
    % display computed values
    if plo
        ok='n';
        while ok~='y'
            figure('Color',[1 1 1]), 
            subplot(2,1,1),
            plot(Range(newRespiTSD,'s'),Data(newRespiTSD),'k')
            hold on, plot(Range(zeroCrossTsd,'s'),Data(zeroCrossTsd),'m.')
            hold on, plot(Range(CorrectedzeroCrossTsd,'s'),Data(CorrectedzeroCrossTsd),'r.')
            hold on, plot(Range(TidalVolume,'s'),Data(TidalVolume)*mean(abs(Data(newRespiTSD)))/mean(Data(TidalVolume)),'g.')
            legend('RespiTSD','ZeroCross','CorrectedZeroCross','TidalVolume (au)')
            
            subplot(2,1,2), 
            DTV=Data(TidalVolume);
            scatter(Range(Frequency,'s'),DTV(1:end-1),2,Data(Frequency))
            colorbar; title('TidalVolume (mL) colored by Frequency');
            
            ok=input('Are you satisfied with the calculated signal integer and amplitude? (y/n) ','s');
            if ok~='y'; keyboard; else close;end
        end
    end
        
end


NormRespiTSD=tsd(Range(newRespiTSD),multCalib*Data(newRespiTSD));

% Good Soliste Day > Rat19 - 03.09

% Sleep Scoring : Hpc channel > # 5 & 6
!gunzip 190309eeg5.mat.gz
load('/media/2E3B0B762A23E6AB/DataExt3/Data/Rat19/190309/190309eeg5.mat')
!gzip 190309eeg5.mat

!gunzip 190309eeg6.mat.gz
load('/media/2E3B0B762A23E6AB/DataExt3/Data/Rat19/190309/190309eeg6.mat')
!gzip 190309eeg6.mat

% Sleep Scoring : PFCx channel > # 1 , 2 , 3 & 4
!gunzip 190309eeg1.mat.gz
load('/media/2E3B0B762A23E6AB/DataExt3/Data/Rat19/190309/190309eeg1.mat')
!gzip 190309eeg1.mat

!gunzip 190309eeg2.mat.gz
load('/media/2E3B0B762A23E6AB/DataExt3/Data/Rat19/190309/190309eeg2.mat')
!gzip 190309eeg2.mat

!gunzip 190309eeg3.mat.gz
load('/media/2E3B0B762A23E6AB/DataExt3/Data/Rat19/190309/190309eeg3.mat')
!gzip 190309eeg3.mat

!gunzip 190309eeg4.mat.gz
load('/media/2E3B0B762A23E6AB/DataExt3/Data/Rat19/190309/190309eeg4.mat')
!gzip 190309eeg4.mat


figure, plot(Range(EEG5,'s'),Data(EEG5))
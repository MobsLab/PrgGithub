clear all
FileNames=GetAllMouseTaskSessions(668);

clf
subplot(511)
load('LFPData/DigInfo1.mat')
plot(Range(DigTSD),Data(DigTSD))
subplot(512)
load('LFPData/DigInfo2.mat')
plot(Range(DigTSD),Data(DigTSD))
subplot(513)
load('LFPData/DigInfo3.mat')
plot(Range(DigTSD),Data(DigTSD))
subplot(514)
load('LFPData/DigInfo4.mat')
plot(Range(DigTSD),Data(DigTSD))
subplot(515)
load('B_Low_Spectrum.mat')
imagesc(Spectro{2},Spectro{3},log(Spectro{1}')), axis xy, hold on

for k = 1:length(FileNames)
    cd(FileNames{k})
    
    clear ExpeInfo
    load('ExpeInfo.mat')
    ExpeInfo.DigID{1} = 'ONOFF';
    ExpeInfo.DigID{2} = 'STIM';
    ExpeInfo.DigID{3} = NaN;
    ExpeInfo.DigID{4} = 'CAMERASYNC';
    %     ExpeInfo.DigID{1} = 'ONOFF';
    %     ExpeInfo.DigID{2} = 'CAMERASYNC';
    %     ExpeInfo.DigID{3} = 'STIM';
    %     ExpeInfo.DigID{4} = NaN;
    
    ExpeInfo.StimulationInt = 2.5;
    
    save('ExpeInfo.mat','ExpeInfo')
end



function Bimod_All_OB(filename,smootime,channels)
% Get all OB channels

close all
cd(filename)
% load('LFPData/InfoLFP.mat')
% channels=[strmatch('Bulb',InfoLFP.structure);strmatch('OB',InfoLFP.structure)]-1;
if length(channels)==0
   return 
end

% Get right Epochs
load(strcat('LFPData/LFP',num2str(channels(1)),'.mat'));
load('StateEpochSB.mat');
rg=Range(LFP);
TotalEpoch=intervalSet(0,rg(end))-NoiseEpoch-GndNoiseEpoch;
TotalEpoch=And(TotalEpoch,Epoch);
TotalEpoch=CleanUpEpoch(TotalEpoch);
try
    load('behavResources.mat','PreEpoch');
    TotalEpoch=And(TotalEpoch,PreEpoch);
end

if length(channels)==0
   return 
end
figname=figure;

for ch=1:length(channels)
    try
    disp(strcat('bulb comp for chan',num2str(channels(ch))))
    clear LFP smooth_ghi
load(strcat('LFPData/LFP',num2str(channels(ch)),'.mat'));
                Filgamma=FilterLFP(LFP,[50 70],1024);
            Restrict(Filgamma,TotalEpoch);
            Hilgamma=hilbert(Data(Filgamma));
            Hilgamma=tsd(Range(Filgamma),abs(Hilgamma));
            smooth_ghi=tsd(Range(Hilgamma),runmean(Data(Hilgamma),ceil(smootime/median(diff(Range(LFP,'s'))))));
            [rms{ch},dist{ch},coeff{ch},cf1,cf2]=BimodParams(smooth_ghi);
            
            [Y{ch},X{ch}]=hist(log(Data(Restrict(smooth_ghi,Epoch))),700);  
            Y{ch}=Y{ch}/sum(Y{ch});
            figure(figname)
            subplot(length(channels),1,ch)
            plot(X{ch},Y{ch},'color','k','linewidth',2)
            hold on
            legend(num2str(channels(ch)))
            
    end
end

saveas(figname,strcat('OBDistribsSuperposed.png'))
            saveas(figname,strcat('OBDistribsSuperposed.fig'))

save(strcat('OBAllChannels.mat'),'rms','dist','coeff','channels','X','Y')
close all
end
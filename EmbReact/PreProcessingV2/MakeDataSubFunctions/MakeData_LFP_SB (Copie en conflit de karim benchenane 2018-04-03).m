disp(' '); disp('LFP Data')
load(['LFPData/InfoLFP.mat'],'InfoLFP');
res=pwd;

% LFPs
disp(' ');
disp('...Creating LFPData.mat')
try
    for i=1:length(InfoLFP.channel)
        LFP_temp=GetLFP(InfoLFP.channel(i));
        disp(['loading and saving LFP',num2str(InfoLFP.channel(i)),' in LFPData...']);
        LFP=tsd(LFP_temp(:,1)*1E4,LFP_temp(:,2));
        save([res,'/LFPData/LFP',num2str(InfoLFP.channel(i))],'LFP');
        clear LFP LFP_temp
    end
    disp('Done')
catch
    disp('problem for lfp')
    keyboard
end
clear LFP InfoLFP

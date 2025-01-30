% makeLFPDataKJ
% 09.10.2017 KJ
%
% generate lfp data
%
% Info
%   see makeDataBulbeSB
%

%clearvars -except Dir p


disp(' '); disp('LFP Data')

try
    load LFPData
    Range(LFP{1});
    FragmentLFP=input('LFPData.mat exists, do you want to fragment LFPData.mat in folder LFPData (y/n) ? ','s');
catch
    FragmentLFP='y';
end

if FragmentLFP=='y';
    try
        % infoLFP for each channel
        disp(' ');
        disp('...Creating InfoLFP.mat')
        try
            InfoLFP = listLFP_to_InfoLFP_ML(res);
        catch
            disp('retry listLFP_to_InfoLFP_ML');keyboard;
        end

        % LFPs
        disp(' ');
        disp('...Creating LFPData.mat')

        for i=1:length(InfoLFP.channel)
            if ~exist(sprintf('LFPData/LFP%d.mat',InfoLFP.channel(i)),'file')
                if setCu==0
                    SetCurrentSession
                    SetCurrentSession('same')
                    setCu=1;
                end

                disp(['loading and saving LFP',num2str(InfoLFP.channel(i)),' in LFPData...']);
                LFP_temp=GetLFP(InfoLFP.channel(i));
                LFP = tsd(LFP_temp(:,1)*1E4,LFP_temp(:,2));
                if exist('reverseData','var'), 
                    LFP = tsd(LFP_temp(:,1)*1E4,-LFP_temp(:,2));
                end
                
                save([res,'/LFPData/LFP',num2str(InfoLFP.channel(i))],'-v7.3','LFP');
                clear LFP LFP_temp
            end
        end

        disp('Done')
    catch
        disp('problem for lfp')
    end
else
    disp('Done')
end

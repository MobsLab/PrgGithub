
% MakeData_LFP_BM, from MakeData_LFP but h=just deal with OE files, cut LFP to TTL start and stop


function SessLength = MakeData_LFP_BM(foldername)

%% Initiation
if nargin < 1
    foldername = pwd;
end
if foldername(end)~=filesep
    foldername(end+1) = filesep;
end

%load InfoLFP
disp(' '); disp('LFP Data')
load(fullfile(foldername,'LFPData','InfoLFP.mat'), 'InfoLFP');
load('ExpeInfo.mat')

%% Create LFPs
disp(' ');
disp('...Creating LFPData.mat')
load('behavResources.mat', 'TTLInfo') % add by BM
try
    for i=1:length(InfoLFP.channel)
        if ~exist(['LFPData/LFP' num2str(InfoLFP.channel(i)) '.mat'],'file') %only LFP signals
            
            disp(['loading and saving LFP' num2str(InfoLFP.channel(i)) ' in LFPData...']);
            % FMA toolbox function to load LFP
            LFP_temp = GetLFP(InfoLFP.channel(i));
            %data to tsd
            LFP = tsd(LFP_temp(:,1)*1E4, LFP_temp(:,2));
            SessLength = max(LFP_temp(:,1));
            
            % add by BM
            if convertCharsToStrings(ExpeInfo.PreProcessingInfo.TypeOfSystem)=='OpenEphys'
                
                GoodEpoch = intervalSet(TTLInfo.StartSession , TTLInfo.StopSession +2e4);
                
                old_LFP = LFP;
                R=Range(LFP);
                LFP_New = Restrict(LFP,GoodEpoch);
                R2=Range(LFP_New)-TTLInfo.StartSession;
                LFP = tsd(R2 , Data(LFP_New));
            end
            
            %save
            save([foldername '/LFPData/LFP' num2str(InfoLFP.channel(i))], 'LFP');
            clear LFP LFP_temp
        end
    end
    disp('Done')
catch
    disp('problem for lfp')
    
end
clear LFP InfoLFP

end





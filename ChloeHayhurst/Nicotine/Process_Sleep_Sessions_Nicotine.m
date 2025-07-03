clear all, close all

GetNicotineSessions_CH

Name = {'NicotineOFSleep'};
Session_type = {'Pre','Post'};


Mouse_names_Nic_Sleep = {'M1500','M1531','M1742','M1743','M1745','M1746','M1747'};

sizeMap = 100;
sizeMap2 = 1000;


clear ActiveEpoch

disp('Fetching data...')

for group = 1:length(Name)
    if group == 1
        Mouse_names = Mouse_names_Nic_Sleep;
    elseif group == 2
        Mouse_names = Mouse_names_Saline_Sleep;
    end
    for mouse=1:length(Mouse_names)
        for sess=1:2
            
            path = sprintf('%s.%s{%d}', Name{group}, Session_type{sess}, mouse);
            folder_path = eval(path);
            cd(folder_path);
            disp(folder_path);
            
            try
                MakeHeartRateForSession_BM
            catch
                disp('No heart channel')
            end
            try
                CreateRipplesSleep('restrict',0)
            catch
                disp('no ripples channel')
            end
            try
                CreateSleepSignals
            end
            
            % Add thigmotaxis homecage, grooming measures...
            
            try
                load('SWR.mat'), load('behavResources.mat','MovAcctsd')
                if ~exist('RipDens_tsd')
                    
                    Rg_Acc = Range(MovAcctsd);
                    i=1; bin_length = ceil(2/median(diff(Range(MovAcctsd,'s')))); % in 2s
                    for bin=1:bin_length:length(Rg_Acc)-bin_length
                        SmallEpoch=intervalSet(Rg_Acc(bin),Rg_Acc(bin+bin_length));
                        RipDensity_temp(i) = length(Start(and(RipplesEpoch , SmallEpoch)));
                        TimeRange(i) = Rg_Acc(bin);
                        i=i+1;
                    end
                    
                    RipDens_tsd = tsd(TimeRange' , RipDensity_temp');
                    save('SWR.mat','RipDens_tsd','-append')
                    
                end
            catch
                disp('Didnt find SWR.mat')
            end
            clear RipDens_tsd TimeRange RipDensity_temp Rg_Acc bin_length
        end
    end
end

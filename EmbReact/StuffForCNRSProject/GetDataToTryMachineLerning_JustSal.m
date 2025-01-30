clear all
MouseGroup = {'Sal'};
Mice.Sal = [688,739,777,779,849,893];

cd /media/nas4/ProjetEmbReact/Mouse688/20180209/ProjectEmbReact_M688_20180209_ExtinctionBlockedSafe_PostDrug/Ext1
load('B_Low_Spectrum.mat')
fLow = Spectro{3};
load('H_VHigh_Spectrum.mat')
fHigh = Spectro{3};
Cols{1} = [[1 0.6 0.6]*0.5;[1 0.6 0.6]] ;
Cols{2} = [[0.6 0.6 1]*0.5;[0.6 0.6 1]] ;
%%
SessNames_Combi{1}={'UMazeCondExplo_PostDrug' 'UMazeCondBlockedShock_PostDrug' 'UMazeCondBlockedSafe_PostDrug' 'UMazeCondExplo_PreDrug' 'UMazeCondBlockedShock_PreDrug' 'UMazeCondBlockedSafe_PreDrug' }

SessNum_Combi{1} = [2,2,2,2,2,2];
VarNames = {'Pos','Fz','Blk','Zn','BInstP','BInstW','HR','EKG','Respi','RespiISI','HeartISI'};


%%
% sesstype = 1
for sesstype = 1
    SessNames = SessNames_Combi{sesstype};
    SessNum = SessNum_Combi{sesstype};
    
    for mg = 1:length(MouseGroup)
        Files.(MouseGroup{mg}) = cell(1,length(Mice.(MouseGroup{mg})));
    end
    
    for sess = 1 : length(SessNames)
        Dir=PathForExperimentsEmbReact(SessNames{sess});
        for d = 1:length(Dir.path)
            
            for mg = 1:length(MouseGroup)
                
                if sum(ismember(Mice.(MouseGroup{mg}),Dir.ExpeInfo{d}{1}.nmouse))
                    
                    for p = 1:length(Dir.path{d})
                        Files.(MouseGroup{mg}){find(ismember(Mice.(MouseGroup{mg}),Dir.ExpeInfo{d}{1}.nmouse))}{end+1} = Dir.path{d}{p};
                    end
                end
            end
        end
    end
    
    for mg = 1:length(MouseGroup)
        disp(['getting ' MouseGroup{mg} ' files'])
        for mm = 1:size(Files.(MouseGroup{mg}),2)
            mm
            
            % Behavioural variables
            Pos.(MouseGroup{mg}){mm} = ConcatenateDataFromFolders_SB(Files.(MouseGroup{mg}){mm},'LinearPosition');
            Fz.(MouseGroup{mg}){mm} = ConcatenateDataFromFolders_SB(Files.(MouseGroup{mg}){mm},'Epoch','epochname','freezeepoch');
            Blk.(MouseGroup{mg}){mm} = ConcatenateDataFromFolders_SB(Files.(MouseGroup{mg}){mm},'Epoch','epochname','blockedepoch');
            Zn.(MouseGroup{mg}){mm} = ConcatenateDataFromFolders_SB(Files.(MouseGroup{mg}){mm},'Epoch','epochname','zoneepoch');
            
            % Bretahing rate and heartrate
            BInstP.(MouseGroup{mg}){mm} = ConcatenateDataFromFolders_SB(Files.(MouseGroup{mg}){mm},'instfreq','suffix_instfreq','B','method','PT');
            BInstW.(MouseGroup{mg}){mm} = ConcatenateDataFromFolders_SB(Files.(MouseGroup{mg}){mm},'instfreq','suffix_instfreq','B','method','WV');
            HR.(MouseGroup{mg}){mm} = ConcatenateDataFromFolders_SB(Files.(MouseGroup{mg}){mm},'heartrate_evenbad');
            
            % Breathing rate and heartrate
            
            load([Files.Sal{mm}{1} '/ChannelsToAnalyse/EKG.mat'])
            EKG.(MouseGroup{mg}){mm} = ConcatenateDataFromFolders_SB(Files.(MouseGroup{mg}){mm},'LFP','channumber',channel);
            EKG.(MouseGroup{mg}){mm} = FilterLFP( EKG.(MouseGroup{mg}){mm},[3 500],1024);
            
            load([Files.Sal{mm}{1} '/ChannelsToAnalyse/Bulb_deep.mat'])
            Respi.(MouseGroup{mg}){mm} = ConcatenateDataFromFolders_SB(Files.(MouseGroup{mg}){mm},'LFP','channumber',channel);
            Respi.(MouseGroup{mg}){mm} = FilterLFP( Respi.(MouseGroup{mg}){mm},[0.1 10],1024);
            
            %% ISIs
            RespiISI.(MouseGroup{mg}){mm} = ConcatenateDataFromFolders_SB(Files.(MouseGroup{mg}){mm},'respi_ISI');
            HeartISI.(MouseGroup{mg}){mm} = ConcatenateDataFromFolders_SB(Files.(MouseGroup{mg}){mm},'heart_ISI');

            
            
        end
    end
    
    for v = 1:length(VarNames)
        save(['/media/nas4/ProjetEmbReact/DrugEffectFigures/DataSal_ForDecoding_',VarNames{v},'.mat'],VarNames{v},'-v7.3')
    end
end

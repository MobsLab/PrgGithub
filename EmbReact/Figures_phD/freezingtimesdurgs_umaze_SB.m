clear all
MouseGroup = {'Sal','Mdz','Flx','FlxChr'};
Mice.Sal = [688,739,777,779,849,893];
Mice.Flx = [740,750,778,775,794];
Mice.Mdz = [829,851,856,857,858,859];
Mice.FlxChr = [876,877];

cd /media/DataMOBsRAIDN/ProjectEmbReact/Mouse688/20180209/ProjectEmbReact_M688_20180209_UMazeCondBlockedShock_PreDrug/Cond1
load('B_Low_Spectrum.mat')
fLow = Spectro{3};
load('H_VHigh_Spectrum.mat')
fHigh = Spectro{3};
Cols{1} = [[1 0.6 0.6]*0.5;[1 0.6 0.6]] ;
Cols{2} = [[0.6 0.6 1]*0.5;[0.6 0.6 1]] ;
%%
SessNames_Combi{1}={'UMazeCondExplo_PostDrug' 'UMazeCondBlockedShock_PostDrug' 'UMazeCondBlockedSafe_PostDrug' 'TestPost_PostDrug' 'ExtinctionBlockedShock_PostDrug' 'ExtinctionBlockedSafe_PostDrug' };

SessNames_Combi{2}={'ExtinctionBlockedShock_PostDrug' 'ExtinctionBlockedSafe_PostDrug'};

SessNames_Combi{3}={'UMazeCondBlockedShock_PostDrug' 'UMazeCondBlockedSafe_PostDrug'};

SessNames_Combi{4}={'UMazeCondBlockedShock_PreDrug' 'UMazeCondBlockedSafe_PreDrug' 'UMazeCondExplo_PreDrug'};

SessNum_Combi{1} = [2,2,2,4,2,2];
SessNum_Combi{2} = [2,2];
SessNum_Combi{3} = [2,2];
SessNum_Combi{4} = [2,2,2];
SessNum_Combi{5} = [2,2,2];

for sesstype = 1:length(SessNames_Combi)
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
            Fz.(MouseGroup{mg}){mm} = ConcatenateDataFromFolders_SB(Files.(MouseGroup{mg}){mm},'Epoch','epochname','freezeepoch');
            Zn.(MouseGroup{mg}){mm} = ConcatenateDataFromFolders_SB(Files.(MouseGroup{mg}){mm},'Epoch','epochname','zoneepoch');
            LFP.(MouseGroup{mg}){mm} = ConcatenateDataFromFolders_SB(Files.(MouseGroup{mg}){mm},'LFP','ChanNumber',0);
            
        end
    end 
        
        for mg = 1:length(MouseGroup)
            
            disp(['getting ' MouseGroup{mg} ' files'])
            for m = 1:size(Files.(MouseGroup{mg}),2)
                
                ShockEpoch = and(Fz.(MouseGroup{mg}){m},Zn.(MouseGroup{mg}){m}{1});
                SafeEpoch = and(Fz.(MouseGroup{mg}){m},Zn.(MouseGroup{mg}){m}{2});
                
                Fzdur.Tot.(MouseGroup{mg}){sesstype}(m) = length(Data(Restrict(LFP.(MouseGroup{mg}){m},Fz.(MouseGroup{mg}){m})))./length(Data(LFP.(MouseGroup{mg}){m}));
                Fzdur.Shk.(MouseGroup{mg}){sesstype}(m) = length(Data(Restrict(LFP.(MouseGroup{mg}){m},ShockEpoch)))./length(Data((LFP.(MouseGroup{mg}){m})));;
                Fzdur.Saf.(MouseGroup{mg}){sesstype}(m) = length(Data(Restrict(LFP.(MouseGroup{mg}){m},SafeEpoch)))./length(Data((LFP.(MouseGroup{mg}){m})));
                
            end
        end
end
    
Cols2 = {[0.6 0.6 0.6],[0.6 1 0.6],[1 0.8 1],[0.6 0.4 0.6]};
clf
for sesstype = 1 : length(SessNames_Combi)
    subplot(1, length(SessNames_Combi),sesstype)
    A = {100*Fzdur.Tot.Sal{sesstype};100*Fzdur.Tot.Mdz{sesstype};100*Fzdur.Tot.Flx{sesstype};100*Fzdur.Tot.FlxChr{sesstype}};
    MakeSpreadAndBoxPlot_SB(A,Cols2,[1,2,3,4])
    [p(sesstype),h] = ranksum(A{1},A{2})
end
set(gca,'xticklabel',{'Sal','Mdz','','Flx-Ac','Flx-Ch'},'xtick',1:4);
set(gca,'LineWidth',2,'FontSize',15), box off
ylabel('% time freezing')


clf
for sesstype = 1 : length(SessNames_Combi)
    subplot(1, length(SessNames_Combi),sesstype)
    A = {Fzdur.Shk.Sal{sesstype};Fzdur.Shk.Mdz{sesstype};Fzdur.Shk.Flx{sesstype};Fzdur.Shk.FlxChr{sesstype}};
    MakeSpreadAndBoxPlot_SB(A,Cols2,[1,2,3,4])
    [p,h] = ranksum(A{1},A{2})
end


clf
for sesstype = 1 : length(SessNames_Combi)
    subplot(1, length(SessNames_Combi),sesstype)
    A = {Fzdur.Saf.Sal{sesstype};Fzdur.Saf.Mdz{sesstype};Fzdur.Saf.Flx{sesstype};Fzdur.Saf.FlxChr{sesstype}};
    MakeSpreadAndBoxPlot_SB(A,Cols2,[1,2,3,4])
    [p,h] = ranksum(A{1},A{2})
end
 

figure
clf
for sesstype = 4
    A = {100*Fzdur.Tot.Sal{sesstype};100*Fzdur.Tot.Mdz{sesstype};100*Fzdur.Tot.Flx{sesstype};100*Fzdur.Tot.FlxChr{sesstype}};
    MakeSpreadAndBoxPlot_SB(A,Cols2,[1,2,3,4])
    [p,h] = ranksum(A{1},A{2})
end
set(gca,'xticklabel',{'Sal','Mdz','','Flx-Ac','Flx-Ch'},'xtick',1:4);
set(gca,'LineWidth',2,'FontSize',15), box off
ylabel('% time freezing')

 
 
 
 
 
 
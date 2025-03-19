figure
clear all

SessNames={'Habituation' 'TestPre' 'UMazeCond' 'TestPost' 'Extinction',...
    'HabituationNight' 'TestPreNight' 'UMazeCondNight' 'TestPostNight' 'ExtinctionNight'};


for ss=1:length(SessNames)
    Dir=PathForExperimentsEmbReact(SessNames{ss});
    MouseToAvoid=[117,431]; % mice with noisy data to exclude
    Dir=RemoveElementsFromDir(Dir,'nmouse',MouseToAvoid);
    disp(SessNames{ss})
    for d=1:length(Dir.path)
            
            TotTime=0;TotFz=0;TotStims=0;
            MouseName{ss,d}=num2str(Dir.ExpeInfo{d}{1}.nmouse);
            disp(MouseName{ss,d})
            for dd=1:length(Dir.path{d})
                cd(Dir.path{d}{dd})
                load('behavResources_SB.mat')
                if not(isfield(Behav,'LinearDist'))
                    if dd==1
                        imagesc(Params.mask+Params.Zone{1})
                        curvexy=ginput(4);
                        clf
                    end
                    
                    mapxy=[Data(Behav.Xtsd)';Data(Behav.Ytsd)']';
                    [xy,distance,t] = distance2curve(curvexy,mapxy/Params.pixratio,'linear');
                    Behav.LinearDist=tsd(Range(Behav.Xtsd),t);
                    subplot(211)
                    imagesc(Params.mask+Params.Zone{1})
                    hold on
                    plot(Data(Behav.Xtsd)/Params.pixratio,Data(Behav.Ytsd)/Params.pixratio)
                    subplot(212)
                    plot(t), ylim([0 1])
                    keyboard
                    clf
                    save('behavResources_SB.mat','Behav','-append')
                    clear Behav Params t xy distance mapxy
                end
            end
        end
end
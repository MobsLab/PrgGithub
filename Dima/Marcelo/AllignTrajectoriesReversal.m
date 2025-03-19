clear all

ExperimentFolder = ['/media/vador/DataMOBS104/Marcelo/M938/SleepImport'];
cd(ExperimentFolder)
Folder = dir;
Folder = Folder(~ismember({Folder.name}, {'.', '..'}));


%This loop goes through every subfolder in the experiment AllignedCleanPosMatInit
for kk = 1:numel(Folder)
    load([ExperimentFolder,'/',Folder(kk).name,'/cleanBehavResources.mat']);
    if kk == 1
        [AlignedYtsd,AlignedXtsd,~,XYOutput] = MorphMazeToSingleShape_EmbReact_DB_MO...
            (CleanYtsd,CleanXtsd,Zone{1},ref,Ratio_IMAonREAL);
    elseif mask == OldMask
        [AlignedYtsd,AlignedXtsd,~,XYOutput] = MorphMazeToSingleShape_EmbReact_DB_MO...
            (CleanYtsd,CleanXtsd,Zone{1},ref,Ratio_IMAonREAL,XYOutput);
    else
        [AlignedYtsd,AlignedXtsd,~,XYOutput] = MorphMazeToSingleShape_EmbReact_DB_MO...
            (CleanYtsd,CleanXtsd,Zone{1},ref,Ratio_IMAonREAL);
    end
    OldMask = mask;
    
    AllignedCleanPosMatInit = CleanPosMatInit;
    AllignedCleanPosMatInit(:,3) = Data(AlignedXtsd);
    AllignedCleanPosMatInit(:,2) = Data(AlignedYtsd);

    save([ExperimentFolder,'/',Folder(kk).name,'/cleanBehavResources.mat'],...
        'AllignedCleanPosMatInit','-append')
end

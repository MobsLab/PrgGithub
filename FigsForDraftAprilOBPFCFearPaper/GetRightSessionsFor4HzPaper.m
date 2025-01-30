function [Dir,KeepFirstSessionOnly,CtrlEphys]=GetRightSessionsFor4HzPaper(SessName)

if strcmp(SessName,'CtrlAllData')
    Dir=PathForExperimentFEAR('Fear-electrophy');
    CtrlEphys=[242,248,244,243,253,254,258,259,299,394,395,402,403,450,451];
    Dir=RestrictPathForExperiment(Dir,'nMice',CtrlEphys);
    Dir=RestrictPathForExperiment(Dir,'Session','EXT-24h-env');
    KeepFirstSessionOnly=[1,2,3,4,7,8:length(Dir.path)];
    
elseif strcmp(SessName,'CtrlBBXAllData')
    
    Dir=   PathForExperimentFEAR('Fear-electrophy');
    CtrlEphys=[242,248,244,243,253,254,258,259,299,394,395,402,403,450,451];
    OBXEphys=[230,291,297,298];
    Dir=RestrictPathForExperiment(Dir,'nMice',[CtrlEphys,OBXEphys]);
    Dir=RestrictPathForExperiment(Dir,'Session','EXT-24h-env');
    KeepFirstSessionOnly=[1,2,3,4,7,8:length(Dir.path)];
    
elseif strcmp(SessName,'BBXAllData')
    
    Dir=PathForExperimentFEAR('Fear-electrophy');
    OBXEphys=[230,291,297,298];
    CtrlEphys=[];
    Dir=RestrictPathForExperiment(Dir,'nMice',OBXEphys);
    Dir=RestrictPathForExperiment(Dir,'Session','EXT-24h-env');
    KeepFirstSessionOnly=[1:length(Dir.path)];
    
elseif strcmp(SessName,'CtrlRipplesOnly')
    
    Dir=PathForExperimentFEAR('Fear-electrophy');
    CtrlEphys=[248,244,253,254,258,259,299,394,403];
    Dir=RestrictPathForExperiment(Dir,'nMice',CtrlEphys);
    Dir=RestrictPathForExperiment(Dir,'Session','EXT-24h-env');
    KeepFirstSessionOnly=[1,2,4:length(Dir.path)];
    
elseif strcmp(SessName,'CtrlHPCLocalOnly')
    
    Dir=PathForExperimentFEAR('Fear-electrophy');
    CtrlEphys=[253,254,258,299,395,403,451];
    Dir=RestrictPathForExperiment(Dir,'nMice',CtrlEphys);
    Dir=RestrictPathForExperiment(Dir,'Session','EXT-24h-env');
    KeepFirstSessionOnly=[1:length(Dir.path)];
    
elseif strcmp(SessName,'CtrlHPCLocal&RipOnly')
    
    Dir=PathForExperimentFEAR('Fear-electrophy');
    CtrlEphys=[253,254,258,299,403];
    Dir=RestrictPathForExperiment(Dir,'nMice',CtrlEphys);
    Dir=RestrictPathForExperiment(Dir,'Session','EXT-24h-env');
    KeepFirstSessionOnly=[1:length(Dir.path)];
    
    
elseif strcmp(SessName,'BBXRipplesOnly')
    
    Dir=PathForExperimentFEAR('Fear-electrophy');
    OBXEphys=[291,297];
    CtrlEphys=[];
    Dir=RestrictPathForExperiment(Dir,'nMice',OBXEphys);
    Dir=RestrictPathForExperiment(Dir,'Session','EXT-24h-env');
    KeepFirstSessionOnly=[1:length(Dir.path)];
    
elseif strcmp(SessName,'BBXHPCLocalOnly')
    
    Dir=PathForExperimentFEAR('Fear-electrophy');
    OBXEphys=[297];
    CtrlEphys=[];
    Dir=RestrictPathForExperiment(Dir,'nMice',OBXEphys);
    Dir=RestrictPathForExperiment(Dir,'Session','EXT-24h-env');
    KeepFirstSessionOnly=[1:length(Dir.path)];
    
    
elseif strcmp(SessName,'CtrlAllDataSpikes')
    CtrlEphys=[244,243,253,254,258,259,299,394,395,402,403,450,451,248];
    Dir=PathForExperimentFEAR('Fear-electrophy');
    Dir=RestrictPathForExperiment(Dir,'nMice',[CtrlEphys]);
    Dir=RestrictPathForExperiment(Dir,'Session','EXT-24h-env');
    KeepFirstSessionOnly=[1,5:length(Dir.path)];
    
elseif strcmp(SessName,'CtrlBBXAllDataSpikes')
    OBXEphys=[291,297,298];
    CtrlEphys=[244,243,253,254,258,259,299,394,395,402,403,450,451,248];
    Dir=PathForExperimentFEAR('Fear-electrophy');
    Dir=RestrictPathForExperiment(Dir,'nMice',[CtrlEphys,OBXEphys]);
    Dir=RestrictPathForExperiment(Dir,'Session','EXT-24h-env');
    KeepFirstSessionOnly=[1,5:length(Dir.path)];
    
elseif strcmp(SessName,'BBXAllDataSpikes')
    OBXEphys=[291,297,298];
    CtrlEphys = [];
    Dir=PathForExperimentFEAR('Fear-electrophy');
    Dir=RestrictPathForExperiment(Dir,'nMice',OBXEphys);
    Dir=RestrictPathForExperiment(Dir,'Session','EXT-24h-env');
    KeepFirstSessionOnly=[1:4];
    
elseif  strcmp(SessName,'CtrlAllData_Beeps')
    Dir=PathForExperimentFEAR('Fear-electrophy');
    CtrlEphys=[253,254,395,402,403,450,451];
    Dir=RestrictPathForExperiment(Dir,'nMice',CtrlEphys);
    Dir=RestrictPathForExperiment(Dir,'Session','EXT-24h-env');
    KeepFirstSessionOnly=[1:length(Dir.path)];
    
elseif strcmp(SessName,'CtrlRipplesOnly_BothExt')
    
    Dir=PathForExperimentFEAR('Fear-electrophy');
    CtrlEphys=[248,244,253,254,258,259,299,394,403];
    Dir=RestrictPathForExperiment(Dir,'nMice',CtrlEphys);
    KeepFirstSessionOnly=[1:length(Dir.path)];
    
elseif strcmp(SessName,'CtrlAllData_BothExt')
    Dir=PathForExperimentFEAR('Fear-electrophy');
    CtrlEphys=[242,248,244,243,253,254,258,259,299,394,395,402,403,450,451];
    Dir=RestrictPathForExperiment(Dir,'nMice',CtrlEphys);
    KeepFirstSessionOnly=[1,2,3,4,7,8:length(Dir.path)];


    
end

end

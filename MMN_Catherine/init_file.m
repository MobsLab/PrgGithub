function info = init_file;
info = [];
%specifies most of the structure of data
info.rootDir = '/Volumes/Elements/ProjectMMN/Catherine/';
info.subjectDir = 'Mouse99/';
info.acquisitionDir = {'20131024' '20131025'};
info.maindir = '/Volumes/Elements/ProjectMMN/Catherine/Mouse55-63/23092013/';%Mouse99/20131024/';

load([info.maindir '/LFPData/InfoLFP.mat']);
info.channelNames = InfoLFP.structure;
info.channelNumber = 1:numel(info.channelNames);


info.StateEpochDir = '/EpochInfo';
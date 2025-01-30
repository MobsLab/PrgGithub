parent_dir = pwd;

cd /home/fpbatta/Data/WarpRat

S.id = 'EpochLimits';
S.varName = 'epoch_limits';
S.type = 'numeric';
S.dimensions = { 1, 2};
S.requires = {};
pb.dataset{1} = {'*'};
pb.op = {'run'};
pb.args = { 'retrieve_epoch_limits'};
S.providedBy = pb;
S.description = ['the flags entered during recording for the start and', ...
		 ' stop of maze period'];

R = Resource(S);
load resources 

resources{'EpochLimits'} = R;

save resources resources

cd(parent_dir)



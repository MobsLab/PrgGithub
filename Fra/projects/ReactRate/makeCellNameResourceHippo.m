parent_dir = pwd;

cd /home/fpbatta/Data/WarpRat

S.id = 'CortCellNames';
S.varName = 'cellnames';
S.type = 'cell';
S.dimensions = { [], 1};
S.requires = {};
pb.dataset{1} = {'*'};
pb.op = {'list'};
pb.args = { 'cort_cells.list'};
S.providedBy = pb;
S.description = ['list of t-file names corresponding to cells that were' ...
		 ' attributed to cortex'];

R = Resource(S);
resources = dictArray;

resources{'CortCellNames'} = R;

save resources resources

cd(parent_dir)



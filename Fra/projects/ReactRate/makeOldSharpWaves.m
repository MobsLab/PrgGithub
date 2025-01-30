parent_dir = pwd;

cd /home/fpbatta/Data/WarpRat
load resources 

s1 = List2Cell('s1.list');
s2 = List2Cell('s2.list');
s3 = List2Cell('s3.list');

S.id = 'OldSharpWavesS_S1';
S.varName = 'S_s1';
S.type = 'cell';
S.dimensions = {1, 1};
S.requires = {};
pb.dataset{1} = s1;
pb.dataset{2} = s2;
pb.dataset{3} = s3;

pb.op = {'mfile', 'mfile', 'mfile'};
pb.args = { 'old_analysis/SPWtimes0301.mat', 'old_analysis/spw0718.mat',...
	  'SPW0916.mat' };
S.providedBy = pb;
S.description = ['the sharp waves start in the original 2001/2002/analysis' ...
		 ' format: sleep 1'];

R = Resource(S);

resources{'OldSharpWavesS_S1'} = R;


S.id = 'OldSharpWavesS_S2';
S.varName = 'S_s2';
S.type = 'cell';
S.dimensions = {1, 1};
S.requires = {};
pb.dataset{1} = s1;
pb.dataset{2} = s2;
pb.dataset{3} = s3;

pb.op = {'mfile', 'mfile', 'mfile'};
pb.args = { 'old_analysis/SPWtimes0301.mat', 'old_analysis/spw0718.mat',...
	  'SPW0916.mat' };
S.providedBy = pb;
S.description = ['the sharp waves start in the original 2001/2002/analysis' ...
		 ' format: sleep 2'];

R = Resource(S);

resources{'OldSharpWavesS_S2'} = R;


S.id = 'OldSharpWavesE_S1';
S.varName = 'E_s1';
S.type = 'cell';
S.dimensions = {1, 1};
S.requires = {};
pb.dataset{1} = s1;
pb.dataset{2} = s2;
pb.dataset{3} = s3;

pb.op = {'mfile', 'mfile', 'mfile'};
pb.args = { 'old_analysis/SPWtimes0301.mat', 'old_analysis/spw0718.mat',...
	  'SPW0916.mat' };
S.providedBy = pb;
S.description = ['the sharp waves end in the original 2001/2002/analysis' ...
		 ' format: sleep 2'];

R = Resource(S);

resources{'OldSharpWavesE_S1'} = R;


S.id = 'OldSharpWavesE_S2';
S.varName = 'E_s2';
S.type = 'cell';
S.dimensions = {1, 1};
S.requires = {};
pb.dataset{1} = s1;
pb.dataset{2} = s2;
pb.dataset{3} = s3;

pb.op = {'mfile', 'mfile', 'mfile'};
pb.args = { 'old_analysis/SPWtimes0301.mat', 'old_analysis/spw0718.mat',...
	  'SPW0916.mat' };
S.providedBy = pb;
S.description = ['the sharp waves end in the original 2001/2002/analysis' ...
		 ' format: sleep 2'];

R = Resource(S);

resources{'OldSharpWavesE_S2'} = R;



S.id = 'OldSharpWavesM_S1';
S.varName = 'M_s1';
S.type = 'cell';
S.dimensions = {1, 1};
S.requires = {};
pb.dataset{1} = s1;
pb.dataset{2} = s2;
pb.dataset{3} = s3;

pb.op = {'mfile', 'mfile', 'mfile'};
pb.args = { 'old_analysis/SPWtimes0301.mat', 'old_analysis/spw0718.mat',...
	  'SPW0916.mat' };
S.providedBy = pb;
S.description = ['the sharp waves peaks in the original 2001/2002/analysis' ...
		 ' format: sleep1'];

R = Resource(S);

resources{'OldSharpWavesM_S1'} = R;


S.id = 'OldSharpWavesM_S2';
S.varName = 'M_s2';
S.type = 'cell';
S.dimensions = {1, 1};
S.requires = {};
pb.dataset{1} = s1;
pb.dataset{2} = s2;
pb.dataset{3} = s3;

pb.op = {'mfile', 'mfile', 'mfile'};
pb.args = { 'old_analysis/SPWtimes0301.mat', 'old_analysis/spw0718.mat',...
	  'SPW0916.mat' };
S.providedBy = pb;
S.description = ['the sharp waves peaks in the original 2001/2002/analysis' ...
		 ' format: sleep2'];

R = Resource(S);

resources{'OldSharpWavesM_S2'} = R;













save resources resources

cd(parent_dir)



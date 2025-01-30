

cd /home/fpbatta/Data/WarpRat
parent_dir = pwd;
load resources
datasets = List2Cell([ parent_dir filesep 'dirs_rate_react.list' ] );


pb.dataset{1} = datasets;
pb.op = {'mfile'};
pb.args = { 'SQspecgram'};


S.id = 'SQSpecgramFastS1';
S.varName = 'SQ_specgram_fast_s1';
S.type = 'tsdArray';
S.dimensions = { 1, 1};
S.requires = {};
S.providedBy = pb;
S.description = ['the multitaper power spectrum with higher temporal',  ...
		 ' resolution for the global activity, computed with', ...
		 ' a sliding window of 256/200 s, for sleep 1'];
R = Resource(S);
resources{'SQSpecgramFastS1'} = R;



S.id = 'SQSpecgramFastS2';
S.varName = 'SQ_specgram_fast_s2';
S.type = 'tsdArray';
S.dimensions = { 1, 1};
S.requires = {};
S.providedBy = pb;
S.description = ['the multitaper power spectrum with higher temporal',  ...
		 ' resolution for the global activity, computed with', ...
		 ' a sliding window of 256/200 s, for sleep 2'];
R = Resource(S);
resources{'SQSpecgramFastS2'} = R;




S.id = 'SQSpecgramSlowS1';
S.varName = 'SQ_specgram_slow_s1';
S.type = 'tsdArray';
S.dimensions = { 1, 1};
S.requires = {};
S.providedBy = pb;
S.description = ['the multitaper power spectrum with higher frequency',  ...
		 ' resolution for the global activity, computed with', ...
		 ' a sliding window of 2048/200 s, for sleep 1. ', ...
		 'Frequency resolution is 0.78 Hz' ];
R = Resource(S);
resources{'SQSpecgramSlowS1'} = R;



S.id = 'SQSpecgramSlowS2';
S.varName = 'SQ_specgram_slow_s2';
S.type = 'tsdArray';
S.dimensions = { 1, 1};
S.requires = {};
S.providedBy = pb;
S.description = ['the multitaper power spectrum with higher frequency',  ...
		 ' resolution for the global activity, computed with', ...
		 ' a sliding window of 2048/200 s, for sleep 2.', ...
		 'Frequency resolution is 0.78 Hz.'];
R = Resource(S);
resources{'SQSpecgramSlowS2'} = R;









save resources resources

cd(parent_dir)



hm = getenv('HOME')
pdir = [hm filesep 'Data' filesep 'amyphys'];


A = Analysis(pwd);


datasets = List2Cell('datasets_shrieker.list');
A = getResource('ExprSelective', datasets);
A = getResource(A, 'NThreatPlus', datasets);
A = getResource(A, 'NThreatMinus', datasets);
parent_dir =  '/media/sdb6/Data'
cd(parent_dir);
A = Analysis(parent_dir);

datasets = List2Cell([ parent_dir filesep 'datasets_rat20.list' ] );

nbDays = length(datasets);

A = getResource(A,'CorrectError',datasets);

perf = zeros(nbDays,1);

for day=1:nbDays

	fprintf([datasets{day} '\n']);
	ce = Data(correctError{day});
	perf(day) = length(find(ce == 1))/length(ce);

end

figure(1)
plot([1:nbDays],perf);
title('Day by day performance')

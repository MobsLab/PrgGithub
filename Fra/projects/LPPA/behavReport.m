function A = behavReport(A)

A= getResource(A, 'TrialOutcome');
side = Data(trialOutcome{1});

A = getResource(A, 'LightRecord');
lite = Data(lightRecord{1});

A = getResource(A, 'CorrectError');
ce = Data(correctError{1});

[success, message, messageid] = mkdir(parent_dir(A), 'BehavReport');

behavdir = [parent_dir(A), filesep 'BehavReport'];
[p,ds,e] = fileparts(current_dir(A));

fid = fopen([behavdir filesep ds '_behavior.txt'], 'wt');

fprintf(fid,'Trials \t rat \t light \t C/E\n');

for i =1:length(side)

	if ce(i) == 1
		ceSt = 'C'
	else
		ceSt = 'E'
	end	
	if side(i) == 1
		sideSt = 'L'
	else
		sideSt = 'R'
	end	

	if lite(i) == 1
		liteSt = 'L'
	else
		liteSt = 'R'
	end	
		
	fprintf(fid, '%i \t %s \t %s \t %s \n',i, sideSt, liteSt, ceSt);
	
end

fclose(fid);
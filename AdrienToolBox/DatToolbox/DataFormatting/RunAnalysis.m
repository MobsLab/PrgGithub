function RunAnalysis(fction,datasets,overwrite,varargin)

% USAGE:
%     RunAnalysis(fction,datasets,overwrite,arguments)
% INPUTS:
%     fction: name of the function to be called
%     datasets: a cell array of directories
%     overwrite: will overwrite, even if function already done. 
%
% Adrien Peyrache 2011

arg = '';
if ~isempty(varargin)
    if ischar(varargin{1})
        arg = varargin{1};
    end
end

parent_dir = pwd;
for ii=1:length(datasets)
    fbasename = datasets{ii};
    fprintf('Launch %s for %s\n', fction,fbasename);
    cd(fbasename);
    
    logfname = ['RunAnalysisLog.mat'];
    
    doIt=1;
    
    if exist(logfname,'file') && ~overwrite
        warning off
        % Tricky here. In RunAnalysisLog, there a variable with the same 
        % name as the function called.So be careful not to do any mystake
        % in variable handling/function calling
        load(logfname,fction);
        warning on
        test = who(fction);

        if ~isempty(test)
            eval(['report = ' fction ';']);
            if report.success
                fprintf('%s was run successfully for %s the %s\n',fction,fbasename,report.date);
                doIt=0;
%               fprintf('Warning! %s was run successfully for %s the %s\n',fction,fbasename,report.date);
%                 answer = input('Do you want to continue - and overwrite? [Y(default)/N]','s');
%                 if strcmp(answer,'N')
%                     doIt=0;
%                 end
            end
            eval(['clear ' fction ';']);
        end
    end
    
    if doIt
        tic
        try
            eval([fction '(' arg ');']);
            returnVar=1;
            msg = 'everything went well';
        catch
            keyboard
            returnVar=0;
            msg = lasterr;         
        end

        timeSpt = toc;
        if returnVar
            fprintf('   ...done in %d sec.\n',round(timeSpt));
        else
            fprintf('   ...error: %s\n',msg);
        end

        report.date = date;
        report.success = returnVar;
        report.returnMsg = msg;
        report.TimeSpent = timeSpt;
        func_name = which(fction);
        fid = fopen(func_name, 'r');
        report.fctScript = fscanf(fid, '%c', inf); %same as above!
        fclose(fid);
        eval([fction ' = report;']);

        if exist(logfname,'file')
            save(logfname,fction,'-append');
        else
            save(logfname,fction);
        end
        eval(['clear ' fction ';']);
    end
    fprintf('\n')
    cd(parent_dir);
end

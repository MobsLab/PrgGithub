%%%% Concatenate whole day of spike recordings
%
% It copies .xml file from PostSleep folder, check that you can generalize
% it before you go
%
% !!!!!!To do on the hard drive!!!!!!!

%% Parameters
curdir = '/media/DataMOBsRAIDN/ProjetERC2/Mouse-711/17032018/'; % folder with a day to concatenate
phasename = 'AllSpikes';
txtfile = 'list_orig_files.txt';

%Re-referecing
chan_toproc = [0:3 12:21 23:31];
chan_ref = [0:3 12:21 23:31];
chan_leave = [4:11 22 32:35];

%% Housekeeping
% Create a folder to fill out with files
mkdir(curdir, phasename);
cd([curdir phasename]);

% Copy and change ExpeInfo
copyfile([curdir 'PostSleep/ExpeInfo.mat'], [curdir phasename]);
load('ExpeInfo.mat');
ExpeInfo.phase = phasename;
save('ExpeInfo.mat');
clear ExpeInfo

% Copy 'ChannelsToAnalyse' folder
copyfile([curdir 'PostSleep/ChannelsToAnalyse'], [curdir phasename]);

%% Copy files
a = 1; % count
fid = fopen(txtfile, 'w+');

% Copy .xml files (from PostSleep foldes)
if exist ([curdir 'PostSleep/ERC-Mouse-' num2str(ExpeInfo.nmouse) '-' ExpeInfo.date '-PostSleep.xml']) == 2
    copyfile([curdir 'PostSleep/ERC-Mouse-' num2str(ExpeInfo.nmouse) '-' ExpeInfo.date '-PostSleep.xml'],...
        [curdir phasename]);
    movefile ([curdir phasename '/ERC-Mouse-' num2str(ExpeInfo.nmouse) '-' ExpeInfo.date '-PostSleep.xml'],...
        [curdir phasename '/ERC-Mouse-' num2str(ExpeInfo.nmouse) '-' ExpeInfo.date '-' ExpeInfo.phase '.xml']);
else
    error('You do not have PostSleep .xml file');
end
if exist ([curdir 'PostSleep/ERC-Mouse-' num2str(ExpeInfo.nmouse) '-' ExpeInfo.date '-PostSleep_SpikeRef.xml']) == 2
    copyfile([curdir 'PostSleep/ERC-Mouse-' num2str(ExpeInfo.nmouse) '-' ExpeInfo.date '-PostSleep_SpikeRef.xml'],...
        [curdir phasename]);
    movefile ([curdir phasename '/ERC-Mouse-' num2str(ExpeInfo.nmouse) '-' ExpeInfo.date '-PostSleep_SpikeRef.xml'],...
        [curdir phasename '/ERC-Mouse-' num2str(ExpeInfo.nmouse) '-' ExpeInfo.date '-' ExpeInfo.phase '_SpikeRef.xml']);
else
    error('You do not have PostSleep _SpikeRef.xml file');
end


% PreSleep
if exist([curdir 'PreSleep']) == 7
    copyfile([curdir 'PreSleep/ERC-Mouse-' num2str(ExpeInfo.nmouse) '-' ExpeInfo.date '-PreSleep_original_original.dat'],...
        [curdir phasename]);
    movefile([curdir phasename '/ERC-Mouse-' num2str(ExpeInfo.nmouse) '-' ExpeInfo.date '-PreSleep_original_original.dat'],...
        ['ERC-Mouse-' num2str(ExpeInfo.nmouse) '-' ExpeInfo.date '-' ExpeInfo.phase '-0' num2str(a) '-wideband.dat']);
    fprintf(fid, '%2.2d ', a);
    fprintf(fid, 'PreSleep\n');
    a=a+1;
else
    error('You do not have PreSleep session');
end

% Habituation
if exist([curdir 'Hab']) == 7
    copyfile([curdir 'Hab/ERC-Mouse-' num2str(ExpeInfo.nmouse) '-' ExpeInfo.date '-Hab_original_original.dat'],...
        [curdir phasename]);
    movefile([curdir phasename '/ERC-Mouse-' num2str(ExpeInfo.nmouse) '-' ExpeInfo.date '-Hab_original_original.dat'],...
        ['ERC-Mouse-' num2str(ExpeInfo.nmouse) '-' ExpeInfo.date '-' ExpeInfo.phase '-0' num2str(a) '-wideband.dat']);
    fprintf(fid, '%2.2d ', a);
    fprintf(fid, 'Hab\n');
    a=a+1;
else
    error('You do not have Hab session');
end

% TestPre
if exist([curdir 'TestPre']) == 7
    for i = 1:4
        if exist([curdir 'TestPre/TestPre' num2str(i)]) == 7
            copyfile([curdir 'TestPre/TestPre' num2str(i) '/ERC-Mouse-' num2str(ExpeInfo.nmouse) '-' ExpeInfo.date...
                '-TestPre' num2str(1) '.dat'], [curdir phasename]);
            movefile([curdir phasename '/ERC-Mouse-' num2str(ExpeInfo.nmouse) '-' ExpeInfo.date '-TestPre' num2str(1) '.dat'],...
            ['ERC-Mouse-' num2str(ExpeInfo.nmouse) '-' ExpeInfo.date '-' ExpeInfo.phase '-0' num2str(a) '-wideband.dat']);
            a=a+1;
            fprintf(fid, '%2.2d ', a);
            fprintf(fid, ['TestPre' num2str(a) '\n']);
        else
            error(['You do not have TestPre' num2str(i) ' session');
        end
    end
else
    error('You do not have TestPre sessions');
end


% Cond
if exist([curdir 'Cond']) == 7
    for i = 1:4
        if exist([curdir 'Cond/Cond' num2str(i)]) == 7
            copyfile([curdir 'Cond/Cond' num2str(i) '/ERC-Mouse-' num2str(ExpeInfo.nmouse) '-' ExpeInfo.date...
                '-Cond' num2str(1) '_original_original.dat'], [curdir phasename]);
            if a<10
            movefile([curdir phasename '/ERC-Mouse-' num2str(ExpeInfo.nmouse) '-' ExpeInfo.date '-Cond' num2str(1)...
                '_original_original.dat'],...
            ['ERC-Mouse-' num2str(ExpeInfo.nmouse) '-' ExpeInfo.date '-' ExpeInfo.phase '-0' num2str(a) '-wideband.dat']);
            else
                movefile([curdir phasename '/ERC-Mouse-' num2str(ExpeInfo.nmouse) '-' ExpeInfo.date '-Cond'...
                    num2str(1) '_original_original.dat'],...
            ['ERC-Mouse-' num2str(ExpeInfo.nmouse) '-' ExpeInfo.date '-' ExpeInfo.phase '-' num2str(a) '-wideband.dat']);
            fprintf(fid, '%2.2d ', a);
            fprintf(fid, ['Cond' num2str(a) '\n']);
            a=a+1;
            end
        else
            error(['You do not have Cond' num2str(i) ' session');
        end
    end
else
    error('You do not have Cond sessions');
end

% TestPost
if exist([curdir 'TestPost']) == 7
    for i = 1:4
        if exist([curdir 'TestPost/TestPost' num2str(i)]) == 7
            copyfile([curdir 'TestPost/TestPost' num2str(i) '/ERC-Mouse-' num2str(ExpeInfo.nmouse) '-' ExpeInfo.date...
                '-TestPost' num2str(1) '.dat'], [curdir phasename]);
            movefile([curdir phasename '/ERC-Mouse-' num2str(ExpeInfo.nmouse) '-' ExpeInfo.date '-TestPost' num2str(1) '.dat'],...
            ['ERC-Mouse-' num2str(ExpeInfo.nmouse) '-' ExpeInfo.date '-' ExpeInfo.phase '-' num2str(a) '-wideband.dat']);
            fprintf(fid, '%2.2d ', a);
            fprintf(fid, ['TestPost' num2str(a) '\n']);
            a=a+1;
        else
            error(['You do not have TestPost' num2str(i) ' session');
        end
    end
else
    error('You do not have TestPost sessions');
end

% PostSleep
if exist([curdir 'PostSleep']) == 7
    copyfile([curdir 'PostSleep/ERC-Mouse-' num2str(ExpeInfo.nmouse) '-' ExpeInfo.date '-PostSleep_original_original.dat'],...
        [curdir phasename]);
    movefile([curdir phasename '/ERC-Mouse-' num2str(ExpeInfo.nmouse) '-' ExpeInfo.date '-PostSleep_original_original.dat'],...
        ['ERC-Mouse-' num2str(ExpeInfo.nmouse) '-' ExpeInfo.date '-' ExpeInfo.phase '-' num2str(a) '-wideband.dat']);
    fprintf(fid, '%2.2d ', a);
    fprintf(fid, 'PostSleep\n');
    a=a+1;
else
    error('You do not have PostSleep session');
end

fclose(fid);
%% NDM commands
% Concatenate
system(['ndm_concatenate ' 'ERC-Mouse-' num2str(ExpeInfo.nmouse) '-' ExpeInfo.date '-' ExpeInfo.phase '.xml']);

% Re-reference to the common reference
RefSubtraction_multi_AverageChans(['ERC-Mouse-' num2str(ExpeInfo.nmouse) '-' ExpeInfo.date '-' ExpeInfo.phase '.dat'],...
    length(ExpeInfo.RecordElecs.channel), 1, 'SpikeRef', chan_toproc, chan_ref, chan_leave);

% Filter
system(['ndm_hipass ' 'ERC-Mouse-' num2str(ExpeInfo.nmouse) '-' ExpeInfo.date '-' ExpeInfo.phase '_SpikeRef.xml']);

% Extract spikes
system(['ndm_extractspikes ' 'ERC-Mouse-' num2str(ExpeInfo.nmouse) '-' ExpeInfo.date '-' ExpeInfo.phase '_SpikeRef.xml']);

% Perform PCA
system(['ndm_pca ' 'ERC-Mouse-' num2str(ExpeInfo.nmouse) '-' ExpeInfo.date '-' ExpeInfo.phase '_SpikeRef.xml']);

%% Fin
fprintf ('-------------We''re done, boy (or girl)---------');
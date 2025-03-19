%%%% Concatenate whole day of spike recordings
%
% It copies .xml file from PostSleep folder, check that you can generalize
% it before you go
%
% !!!!!!To do on the hard drive!!!!!!!

%% Parameters
curdir = '/media/mobsrick/DataMOBS87/Mouse-798/12112018/'; % folder with a day to concatenate
phasename = 'AllSpikes';
txtfile = 'list_orig_files.txt';

%Re-referecing
chan_toproc_left = [0:3];
chan_ref_left = [0:3];
chan_leave_left = [4:35];

chan_toproc_right = [12:19];
chan_ref_right = [12:19];
chan_leave_right = [0:11 20:35];

%% Housekeeping
% Create a folder to fill out with files
mkdir(curdir, phasename);
cd([curdir phasename]);

% Copy and change ExpeInfo
copyfile([curdir 'PostSleep/ExpeInfo.mat'], [curdir phasename]);
load('ExpeInfo.mat');
ExpeInfo.phase = phasename;
save('ExpeInfo.mat');

% Copy 'ChannelsToAnalyse' folder
mkdir([curdir phasename], 'ChannelsToAnalyse');
copyfile([curdir 'PostSleep/ChannelsToAnalyse'], [curdir phasename '/ChannelsToAnalyse']);

%% Copy files
a = 1; % count
fid = fopen(txtfile, 'w+');

% Copy .xml files (from PostSleep foldes)
if exist ([curdir 'PostSleep/ERC-Mouse-' num2str(ExpeInfo.nmouse) '-' ExpeInfo.date '-PostSleep.xml']) == 2
    copyfile([curdir 'PostSleep/ERC-Mouse-' num2str(ExpeInfo.nmouse) '-' ExpeInfo.date '-PostSleep.xml'],...
        [curdir phasename]);
    movefile ([curdir phasename '/ERC-Mouse-' num2str(ExpeInfo.nmouse) '-' ExpeInfo.date '-PostSleep.xml'],...
        [curdir phasename '/ERC-Mouse-' num2str(ExpeInfo.nmouse) '-' ExpeInfo.date '-' ExpeInfo.phase '.xml']);
    copyfile([curdir 'PostSleep/ERC-Mouse-' num2str(ExpeInfo.nmouse) '-' ExpeInfo.date '-PostSleep.xml'],...
        [curdir phasename]);
    movefile ([curdir phasename '/ERC-Mouse-' num2str(ExpeInfo.nmouse) '-' ExpeInfo.date '-PostSleep.xml'],...
        [curdir phasename '/ERC-Mouse-' num2str(ExpeInfo.nmouse) '-' ExpeInfo.date '-' ExpeInfo.phase '_SpikeRef.xml']);
else
    error('You do not have PostSleep .xml file');
end
% if exist ([curdir 'PostSleep/ERC-Mouse-' num2str(ExpeInfo.nmouse) '-' ExpeInfo.date '-PostSleep_SpikeRef.xml']) == 2
%     copyfile([curdir 'PostSleep/ERC-Mouse-' num2str(ExpeInfo.nmouse) '-' ExpeInfo.date '-PostSleep_SpikeRef.xml'],...
%         [curdir phasename]);
%     movefile ([curdir phasename '/ERC-Mouse-' num2str(ExpeInfo.nmouse) '-' ExpeInfo.date '-PostSleep_SpikeRef.xml'],...
%         [curdir phasename '/ERC-Mouse-' num2str(ExpeInfo.nmouse) '-' ExpeInfo.date '-' ExpeInfo.phase '_SpikeRef.xml']);
% else
%     error('You do not have PostSleep _SpikeRef.xml file');
% end


% PreSleep
if exist([curdir 'PreSleep']) == 7
    copyfile([curdir 'PreSleep/ERC-Mouse-' num2str(ExpeInfo.nmouse) '-' ExpeInfo.date '-PreSleep.dat'],...
        [curdir phasename]);
    movefile([curdir phasename '/ERC-Mouse-' num2str(ExpeInfo.nmouse) '-' ExpeInfo.date '-PreSleep.dat'],...
        ['ERC-Mouse-' num2str(ExpeInfo.nmouse) '-' ExpeInfo.date '-' ExpeInfo.phase '-0' num2str(a) '-wideband.dat']);
    fprintf(fid, '%2i ', a);
    fprintf(fid, 'PreSleep\n');
    a=a+1;
else
    error('You do not have PreSleep session');
end

% Habituation
if exist([curdir 'Hab']) == 7
    copyfile([curdir 'Hab/ERC-Mouse-' num2str(ExpeInfo.nmouse) '-' ExpeInfo.date '-Hab.dat'],...
        [curdir phasename]);
    movefile([curdir phasename '/ERC-Mouse-' num2str(ExpeInfo.nmouse) '-' ExpeInfo.date '-Hab.dat'],...
        ['ERC-Mouse-' num2str(ExpeInfo.nmouse) '-' ExpeInfo.date '-' ExpeInfo.phase '-0' num2str(a) '-wideband.dat']);
    fprintf(fid, '%2i ', a);
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
                '-TestPre' num2str(i) '.dat'], [curdir phasename]);
            movefile([curdir phasename '/ERC-Mouse-' num2str(ExpeInfo.nmouse) '-' ExpeInfo.date '-TestPre' num2str(i) '.dat'],...
            ['ERC-Mouse-' num2str(ExpeInfo.nmouse) '-' ExpeInfo.date '-' ExpeInfo.phase '-0' num2str(a) '-wideband.dat']);
            a=a+1;
            fprintf(fid, '%2i ', a);
            fprintf(fid, ['TestPre' num2str(a) '\n']);
        else
            error(['You do not have TestPre' num2str(i) ' session']);
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
                '-Cond' num2str(i) '.dat'], [curdir phasename]);
            if a<10
                movefile([curdir phasename '/ERC-Mouse-' num2str(ExpeInfo.nmouse) '-' ExpeInfo.date '-Cond' num2str(i)...
                    '.dat'],...
                    ['ERC-Mouse-' num2str(ExpeInfo.nmouse) '-' ExpeInfo.date '-' ExpeInfo.phase '-0' num2str(a) '-wideband.dat']);
            else
                movefile([curdir phasename '/ERC-Mouse-' num2str(ExpeInfo.nmouse) '-' ExpeInfo.date '-Cond'...
                    num2str(i) '.dat'],...
                    ['ERC-Mouse-' num2str(ExpeInfo.nmouse) '-' ExpeInfo.date '-' ExpeInfo.phase '-' num2str(a) '-wideband.dat']);
            end
            fprintf(fid, '%2i ', a);
            fprintf(fid, ['Cond' num2str(i) '\n']);
            a=a+1;
        else
            error(['You do not have Cond' num2str(i) ' session']);
        end
    end
else
    error('You do not have Cond sessions');
end

% PostSleep
if exist([curdir 'PostSleep']) == 7
    copyfile([curdir 'PostSleep/ERC-Mouse-' num2str(ExpeInfo.nmouse) '-' ExpeInfo.date '-PostSleep.dat'],...
        [curdir phasename]);
    movefile([curdir phasename '/ERC-Mouse-' num2str(ExpeInfo.nmouse) '-' ExpeInfo.date '-PostSleep.dat'],...
        ['ERC-Mouse-' num2str(ExpeInfo.nmouse) '-' ExpeInfo.date '-' ExpeInfo.phase '-' num2str(a) '-wideband.dat']);
    fprintf(fid, '%2i ', a);
    fprintf(fid, 'PostSleep\n');
    a=a+1;
else
    error('You do not have PostSleep session');
end

% TestPost
if exist([curdir 'TestPost']) == 7
    for i = 1:4
        if exist([curdir 'TestPost/TestPost' num2str(i)]) == 7
            copyfile([curdir 'TestPost/TestPost' num2str(i) '/ERC-Mouse-' num2str(ExpeInfo.nmouse) '-' ExpeInfo.date...
                '-TestPost' num2str(i) '.dat'], [curdir phasename]);
            movefile([curdir phasename '/ERC-Mouse-' num2str(ExpeInfo.nmouse) '-' ExpeInfo.date '-TestPost' num2str(i) '.dat'],...
            ['ERC-Mouse-' num2str(ExpeInfo.nmouse) '-' ExpeInfo.date '-' ExpeInfo.phase '-' num2str(a) '-wideband.dat']);
            fprintf(fid, '%2i ', a);
            fprintf(fid, ['TestPost' num2str(i) '\n']);
            a=a+1;
        else
            error(['You do not have TestPost' num2str(i) ' session']);
        end
    end
else
    error('You do not have TestPost sessions');
end

fclose(fid);
%% NDM commands
% Concatenate
system(['ndm_concatenate ' 'ERC-Mouse-' num2str(ExpeInfo.nmouse) '-' ExpeInfo.date '-' ExpeInfo.phase '.xml']);

% Re-reference to the common reference
% Left
RefSubtraction_multi_AverageChans(['ERC-Mouse-' num2str(ExpeInfo.nmouse) '-' ExpeInfo.date '-' ExpeInfo.phase '.dat'],...
    length(ExpeInfo.RecordElecs.channel), 1, 'SpikeRef', chan_toproc_left, chan_ref_left, chan_leave_left);
movefile(['ERC-Mouse-' num2str(ExpeInfo.nmouse) '-' ExpeInfo.date '-' ExpeInfo.phase '_original.dat'],...
     ['ERC-Mouse-' num2str(ExpeInfo.nmouse) '-' ExpeInfo.date '-' ExpeInfo.phase '_original1.dat']);
 movefile(['ERC-Mouse-' num2str(ExpeInfo.nmouse) '-' ExpeInfo.date '-' ExpeInfo.phase '_SpikeRef.dat'],...
     ['ERC-Mouse-' num2str(ExpeInfo.nmouse) '-' ExpeInfo.date '-' ExpeInfo.phase '.dat']);
% Right
RefSubtraction_multi_AverageChans(['ERC-Mouse-' num2str(ExpeInfo.nmouse) '-' ExpeInfo.date '-' ExpeInfo.phase '.dat'],...
    length(ExpeInfo.RecordElecs.channel), 1, 'SpikeRef', chan_toproc_right, chan_ref_right, chan_leave_right);

% Filter
system(['ndm_hipass ' 'ERC-Mouse-' num2str(ExpeInfo.nmouse) '-' ExpeInfo.date '-' ExpeInfo.phase '_SpikeRef.xml']);

% Extract spikes
system(['ndm_extractspikes ' 'ERC-Mouse-' num2str(ExpeInfo.nmouse) '-' ExpeInfo.date '-' ExpeInfo.phase '_SpikeRef.xml']);

% Perform PCA
system(['ndm_pca ' 'ERC-Mouse-' num2str(ExpeInfo.nmouse) '-' ExpeInfo.date '-' ExpeInfo.phase '_SpikeRef.xml']);

%% Fin
fprintf ('-------------We''re done, boy (or girl)---------');
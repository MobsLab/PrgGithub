% PreProcessDeltaFeedback
%
% 02.12.2016 KJ
%
% - Semi-automatically preprocessing of the data
%

%processes done
init_done_done = 0;
make_folder_done = 0;
move_file_done = 0;
create_links_done = 0;
first_ndm_start_done = 0;
refsub_done = 0;
subspike_done = 0;
originalfiles_folder_done = 0;
mice_folders_done = 0;

try
    load preprocessInfo
end

%% Initiation
warning off

if ~init_done_done
    %list directories in pwd
    mainFolder = pwd;
    d=dir();
    nameFolders = {d([d(:).isdir]).name};
    nameFolders = sort(nameFolders(3:end));
    nb_folders = length(nameFolders);

    % Ask names for experiment and sessions
    defaultvalues1={'Breath-Mouse-'};
    Prompt = {'Name of the Experiment'};
    for i=1:nb_folders
        defaultvalues1{end+1} = ['0' num2str(i) '-'];
        Prompt{end+1} = nameFolders{i};
    end
    if exist('answer_init','var')
        if length(defaultvalues1)==length(answer_init)
            defaultvalues1=answer_init;
        end
    end
    answer_init = inputdlg(Prompt,'Inputs for Preprocessing',1,defaultvalues1);
    experiment_name = answer_init{1};
    for i=1:nb_folders
        sessions_name{i} = answer_init{i+1};
    end
    init_done_done =1;
    save preprocessInfo answer_init mainFolder init_done_done experiment_name
end
    
%% make folder
if ~make_folder_done
    expe_folder = [mainFolder '/' experiment_name];
    wideband_folder = [mainFolder '/' experiment_name '-wideband'];
    accelero_folder = [mainFolder '/' experiment_name '-accelero'];
    analog_folder = [mainFolder '/' experiment_name '-analog'];
    info_folder = [mainFolder '/Info'];

    mkdir(expe_folder);
    mkdir(wideband_folder);
    mkdir(accelero_folder);
    mkdir(analog_folder);
    mkdir(info_folder);
    disp('Folders created');
    make_folder_done = 1;
    save preprocessInfo -append  make_folder_done expe_folder 
end

%% move wideband
if ~move_file_done
    for i=1:nb_folders
        cd(mainFolder)
        eval(['cd(nameFolders{' num2str(i) '})'])
        %wideband
        wideband_name = [experiment_name '-' sessions_name{i} '-wideband.dat'];
        movefile('amplifier.dat',wideband_name)
        movefile(wideband_name, expe_folder);
        %accelero
        accelero_name = [experiment_name '-' sessions_name{i} '-accelero.dat'];
        movefile('auxiliary.dat',accelero_name)
        movefile(accelero_name, expe_folder);
        %analog
        try
            analog_name = [experiment_name '-' sessions_name{i} '-analog.dat'];
            movefile('analogin.dat',analog_name)
            movefile(analog_name, expe_folder);
        end
        %Info
        f=dir();
        nameFiles = {f(~[f(:).isdir]).name};
        nameFiles = sort(nameFiles);
        clear f
        for f=1:length(nameFiles)
            movefile(nameFiles{f}, info_folder);
        end

    end
    
    %remove old folders
    cd(mainFolder)
    for i=1:nb_folders
        rmdir(nameFolders{i})
    end
    
    move_file_done = 1;
    save preprocessInfo -append move_file_done
end

%% create symbolic link
if ~create_links_done
    cd(expe_folder)
    wideband_files = dir('*-wideband.dat');
    for i=1:length(wideband_files)
        command = ['ln -s ' wideband_files(i).name ' ' wideband_folder];
        system(command);
    end
    accelero_files = dir('*-accelero.dat');
    for i=1:length(accelero_files)
        command = ['ln -s ' accelero_files(i).name ' ' accelero_folder];
        system(command);
    end
    analog_files = dir('*-analog.dat');
    for i=1:length(analog_files)
        command = ['ln -s ' analog_files(i).name ' ' analog_folder];
        system(command);
    end
    
    create_links_done = 1;
    save preprocessInfo -append create_links_done
end


%% check if xml is ok
cd(mainFolder)
while isempty(dir([experiment_name '.xml']))
    disp(['The xml file ' experiment_name '.xml is needed'])
    m = input('press any key to continue');
end

disp(['Check the xml file ' experiment_name '.xml is ready for the next processing'])
m = input('press any key to continue');


%% launch ndm start
if ~first_ndm_start_done
    cd(mainFolder)
    command = ['ndm_start ' experiment_name];
    system(command);
    
    first_ndm_start_done = 1;
    save preprocessInfo -append first_ndm_start_done
end


%TODO

%% Ref_Substraction
if ~refsub_done
    
    %go in the .dat folder
    nb_mice= input('How many mice in this record ?');
    
    Prompt2 = {'.dat file', 'total number of channels','number of animals'};
    defaultvalues2 = {[experiment_name '.dat'],'70','2'};
    idx_animals = [];
    for i=1:nb_mice
        Prompt2{end+1} = ['Name of animal ' num2str(i)];
        defaultvalues2{end+1} = 'Mouse-';
        idx_animals = [idx_animals length(Prompt2)];
        
        Prompt2{end+1} = ['Channels of animal ' num2str(i)];
        defaultvalues2{end+1} = '0:31';
        
        Prompt2{end+1} = ['Reference of animal ' num2str(i)];
        defaultvalues2{end+1} = '23';
        
        Prompt2{end+1} = ['Accelero of animal ' num2str(i)];
        defaultvalues2{end+1} = '[64 65 66]';
    end

    answer_refsub = inputdlg(Prompt2,'Inputs for RefSubstraction_multi',1,defaultvalues2);
    
    for i=1:length(idx_animals)
        mice_name{i} = answer_refsub{idx_animals(i)};
    end
    
    cd(expe_folder)
    RefSubtraction_multi(answer_refsub{1}, str2num(answer_refsub{2}), str2num(answer_refsub{3}),... 
        answer_refsub{4}, str2num(answer_refsub{5}), str2num(answer_refsub{6}), str2num(answer_refsub{7}),...
        answer_refsub{8}, str2num(answer_refsub{9}), str2num(answer_refsub{10}), str2num(answer_refsub{11}));
    
    cd(mainFolder)
    refsub_done = 1;
    save preprocessInfo -append refsub_done answer_refsub mice_name
end


%% Ask for a check
disp('Check the new files are as long as the original')
m = input('press any key to continue');


%% Substraction on signals for spike sorting 
% 
% if ~subspike_done  
%     
%     %adapt the previous prompt
%     Prompt3 = Prompt2;
%     defaultvalues3 = defaultvalues2;
%     toRemove = [];
%     for i=1:length(idx_animals)
%         defaultvalues3{3+(i-1)*4+1} = strrep(answer_refsub{3 +(i-1)*4+1}, 'Mouse', 'SubSpike');
%         Prompt3{3+(i-1)*4+2} = ['Tetrode channels of animal ' num2str(i)];
%         defaultvalues3{3+(i-1)*4+2} = answer_refsub{3 +(i-1)*4+2};
%         Prompt3{3+(i-1)*4+4} = ['ChannelsToKeep of animal ' num2str(i)];
%         defaultvalues3{3+(i-1)*4+4} = answer_refsub{3 +(i-1)*4+4};
%         toRemove = [toRemove 3+(i-1)*4+3];
%     end
%     Prompt3(:,toRemove) = []; %no need of reference, tetrode channels are their own reference
%     defaultvalues3(:,toRemove) = [];
%     
% 
%     answer_subspike = inputdlg(Prompt3,'Inputs for RefSubtraction_multi_AverageChans',1,defaultvalues3);
%         
%     cd(expe_folder)
%     RefSubtraction_multi_AverageChans(answer_refsub{1}, str2num(answer_refsub{2}), str2num(answer_refsub{3}),... 
%         answer_refsub{4}, str2num(answer_refsub{5}), str2num(answer_refsub{6}), str2num(answer_refsub{7}),...
%         answer_refsub{8}, str2num(answer_refsub{9}), str2num(answer_refsub{10}), str2num(answer_refsub{11}));
%     
%     cd(mainFolder)
%     subspike_done = 1;
%     save preprocessInfo -append subspike_done
% end

%% create orginal Files folder
if ~originalfiles_folder_done
    cd(mainFolder)
    mkdir('OriginalFiles');
    for m=1:length(mice_name)
        cd(mainFolder)
        mouse_folder{m} = strrep(mice_name{m},'-','');
        mkdir(mouse_folder{m});
        cd(mouse_folder{m})
        mouse_data_folder{m} = ['Breath-' mice_name{m} 
    end
    
    cd(expe_folder)
    
    %copy .cat.evt
    
    originalfiles_folder_done = 1;
    save preprocessInfo -append originalfiles_folder_done
end


%% Create folders for each mice
if ~mice_folders_done
    for i=1:length(mice_name)
        cd(mainFolder)

        mouse_folder{i} = ['Mouse' mice_name{i}(end-2:end)];
        mkdir(mouse_folder);
        cd(mouse_folder)
        
        mouse_expe{i} = ['Breath-' mice_name{i} '-' experiment_name(end-7:end)]; 
        mkdir(mouse_expe{i});
        cd(mouse_expe{i}); mouse_path{i} = pwd;  cd(mouse_folder);
        mkdir([mouse_expe{i} '-wideband']);
        
        while isempty(dir([mouse_expe{i} '.xml']))
            disp(['The xml file ' mouse_expe{i} '.xml is needed'])
            m = input('press any key to continue');
        end

    end
    
    mice_folders_done = 1;
    save preprocessInfo -append mice_folders_done
end


%% launch ndm_start for each mice
if ~mouse_ndm_start_done
    
    for i=1:length(mouse_path)
        cd(mouse_path{i})
        disp(['Check the xml file ' mouse_expe{i} '.xml is ready for the next processing'])
        m = input('press any key to continue');
    end

    mouse_ndm_start_done = 1;
    save preprocessInfo -append mouse_ndm_start_done
end







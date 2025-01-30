% PreProcessDeltaFeedback2
%
% 20.11.2017 KJ
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
mice_folders_done = 0;
refsub_tetrode_done=0;
mouse_lfp_done = 0;
klustakwik_done = 0;
clean_folders_done = 0;

try
    load preprocessInfo
end

%% Initialisation
warning off

if ~init_done_done
    disp('Initialisation..')
    
    %list directories in pwd
    mainFolder = pwd;
    d=dir();
    nameFolders = {d([d(:).isdir]).name};
    nameFolders = sort(nameFolders(3:end));
    nb_folders = length(nameFolders);

    % Ask names for experiment and sessions, and the number of mice
    defaultvalues1={'Breath-Mouse-'};
    Prompt = {'Name of the Experiment'};
    
    defaultvalues1{end+1} = '2';
    Prompt{end+1} = 'How many mice ?';
    
    for m=1:nb_folders
        defaultvalues1{end+1} = ['0' num2str(m) '-'];
        Prompt{end+1} = nameFolders{m};
    end
    if exist('answer_init','var')
        if length(defaultvalues1)==length(answer_init)
            defaultvalues1=answer_init;
        end
    end
    answer_init = inputdlg(Prompt,'Inputs for Preprocessing',1,defaultvalues1);
    experiment_name = answer_init{1};
    nb_mice = str2num(answer_init{2});
    for m=1:nb_folders
        sessions_name{m} = answer_init{m+2};
    end

    

    cd(mainFolder)
    init_done_done = 1; 
    save preprocessInfo mainFolder answer_init experiment_name init_done_done nb_folders nameFolders
end



%% make folder
if ~make_folder_done
    disp('Make folders..')
    
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
    
    cd(mainFolder)
    make_folder_done = 1;
    save preprocessInfo -append  make_folder_done expe_folder wideband_folder accelero_folder analog_folder info_folder
end


%% move wideband
if ~move_file_done
    disp('Moving files..')
    
    for m=1:nb_folders
        cd(mainFolder)
        eval(['cd(nameFolders{' num2str(m) '})'])
        %wideband
        wideband_name = [experiment_name '-' sessions_name{m} '-wideband.dat'];
        movefile('amplifier.dat',wideband_name);
        movefile(wideband_name, expe_folder);
        %accelero
        accelero_name = [experiment_name '-' sessions_name{m} '-accelero.dat'];
        movefile('auxiliary.dat',accelero_name);
        movefile(accelero_name, expe_folder);
        %analog
        try
            analog_name = [experiment_name '-' sessions_name{m} '-analog.dat'];
            movefile('analogin.dat',analog_name);
            movefile(analog_name, expe_folder);
        end
        %Info
        f=dir();
        nameFiles = {f(~[f(:).isdir]).name};
        nameFiles = sort(nameFiles);
        clear f
        for f=1:length(nameFiles)
            new_name = [experiment_name '-' sessions_name{m} '-' nameFiles{f}];
            movefile(nameFiles{f}, new_name);
            movefile(new_name, info_folder);
        end

    end
    
    %remove old folders
    cd(mainFolder)
    for m=1:nb_folders
        rmdir(nameFolders{m})
    end
    
    move_file_done = 1;
    save preprocessInfo -append move_file_done
end


%% create symbolic link
if ~create_links_done
    disp('Create symbolic links...')
    
    cd(expe_folder)
    wideband_files = dir('*-wideband.dat');
    for m=1:length(wideband_files)
        command = ['ln -s ' wideband_files(m).name ' ' wideband_folder];
        system(command);
    end
    accelero_files = dir('*-accelero.dat');
    for m=1:length(accelero_files)
        command = ['ln -s ' accelero_files(m).name ' ' accelero_folder];
        system(command);
    end
    analog_files = dir('*-analog.dat');
    for m=1:length(analog_files)
        command = ['ln -s ' analog_files(m).name ' ' analog_folder];
        system(command);
    end
    
    cd(mainFolder)
    create_links_done = 1;
    save preprocessInfo -append create_links_done
end


%% launch ndm start
if ~first_ndm_start_done
    disp('ndm_start...')
    
    % check if xml is ok
    cd(mainFolder)
    while isempty(dir([experiment_name '.xml']))
        disp(['The xml file ' experiment_name '.xml is needed'])
        m = input('press any key to continue');
    end
    disp(['Check the xml file ' experiment_name '.xml is ready for the next processing'])
    m = input('press any key to continue');
    
    %launch the command
    cd(mainFolder)
    command = ['ndm_start ' experiment_name];
    system(command);
    
    cd(mainFolder)
    first_ndm_start_done = 1;
    save preprocessInfo -append first_ndm_start_done
end


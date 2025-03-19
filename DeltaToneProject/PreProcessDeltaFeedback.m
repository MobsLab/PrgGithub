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

    
    Prompt2 = {'.dat file', 'total number of channels','number of animals'};
    defaultvalues2 = {[experiment_name '.dat'],'73','2'};
    idx_animals = [];
    for m=1:nb_mice
        Prompt2{end+1} = ['Name of animal ' num2str(m)];
        defaultvalues2{end+1} = 'Mouse-';
        idx_animals = [idx_animals length(Prompt2)];
        
        Prompt2{end+1} = ['Channels of animal ' num2str(m)];
        defaultvalues2{end+1} = '0:31';
        
        Prompt2{end+1} = ['Reference of animal ' num2str(m)];
        defaultvalues2{end+1} = '24';
        
        Prompt2{end+1} = ['Channels to keep ' num2str(m) ' (accelero,analog...)'];
        defaultvalues2{end+1} = '[64 65 66 70 71 72]';
        
        Prompt2{end+1} = ['Tetrode channels ' num2str(m)];
        defaultvalues2{end+1} = '';
        
    end

    answer_refsub = inputdlg(Prompt2,'Inputs for RefSubstraction_multi',1,defaultvalues2);
    
    for m=1:length(idx_animals)
        mice_name{m} = answer_refsub{idx_animals(m)};
    end

    cd(mainFolder)
    init_done_done = 1; 
    save preprocessInfo mainFolder answer_init answer_refsub experiment_name mice_name init_done_done nb_folders nameFolders
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


%% Ref_Substraction
if ~refsub_done
    disp('Ref Substraction...')
    
    cd(expe_folder)
    if nb_mice==1
        RefSubtraction_multi(answer_refsub{1}, str2num(answer_refsub{2}), str2num(answer_refsub{3}),... 
            answer_refsub{4}, str2num(answer_refsub{5}), str2num(answer_refsub{6}), str2num(answer_refsub{7}));
    elseif nb_mice==2
        RefSubtraction_multi(answer_refsub{1}, str2num(answer_refsub{2}), str2num(answer_refsub{3}),... 
            answer_refsub{4}, str2num(answer_refsub{5}), str2num(answer_refsub{6}), str2num(answer_refsub{7}),...
            answer_refsub{9}, str2num(answer_refsub{10}), str2num(answer_refsub{11}), str2num(answer_refsub{12}));
    end
    cd(mainFolder)
    refsub_done = 1;
    save preprocessInfo -append refsub_done
end


%% Create folders for each mice
if ~mice_folders_done
    disp('Mice folders...')
    
    %remove old folder
    try
        rmdir(wideband_folder,'s'); 
        rmdir(accelero_folder,'s'); 
        rmdir(analog_folder,'s');
    end

    %Event file (.cat.evt)
    cd(expe_folder)
    file_event = dir('*.cat.evt');
    file_event = [expe_folder '/' file_event(1).name];
    cd(mainFolder)
    mkdir('OriginalFiles');
    copyfile(file_event,'OriginalFiles');
    
    for m=1:length(mice_name)
        cd(mainFolder)
        
        %Main folder for the Mouse
        mouse_folder{m} = ['Mouse' mice_name{m}(end-2:end)];
        mkdir(mouse_folder{m});
        cd(mouse_folder{m})
        
        %Many subfolders
        mouse_expe{m} = ['Breath-' mice_name{m} '-' experiment_name(end-7:end)]; 
        mkdir(mouse_expe{m});
        mkdir([mouse_expe{m} '-wideband']); 
        cd(mouse_expe{m}); mouse_path{m} = pwd; cd('..'); %path to the principal subfolder, with data
        
        %copy .cat.evt and replace string inside
        fin = fopen(file_event);
        fout = fopen([mouse_path{m} '/' mouse_expe{m} '.cat.evt'], 'wt');
        while ~feof(fin)
           s = fgetl(fin);
           s = strrep(s, experiment_name, mouse_expe{m});
           fprintf(fout,'%s',s);
           fprintf(fout,'\n');
        end
        fclose(fin); fclose(fout);
        
        
        %copy .dat
        cd(expe_folder)
        movefile([experiment_name '_' mice_name{m} '.dat'], [mouse_expe{m} '.dat']);
        movefile([mouse_expe{m} '.dat'], mouse_path{m});
        
    end
    
    cd(mainFolder)
    %remove old folder
    try
        rmdir(experiment_name,'s'); 
    end
    %save
    mice_folders_done = 1;
    save preprocessInfo -append mice_folders_done mouse_expe mouse_path mice_name 
end


%% ref substraction spike ref
% if ~refsub_tetrode_done
%     disp('RefSubstraction for spike sorting...')
%     % For each mouse
%     for m=1:length(mice_name)
%         cd(mouse_path{m})
%         nb_channels = length([str2num(answer_refsub{5+5*(m-1)}) str2num(answer_refsub{7+5*(m-1)})]);
%         all_channels = 0:nb_channels-1;
%         channels_to_keep = 0:length(str2num(answer_refsub{5+5*(m-1)}))-1;
%         tetrode_channels = str2num(answer_refsub{8+5*(m-1)});
%         if any(tetrode_channels>31)
%            tetrode_channels = tetrode_channels - 32; 
%         end
%         all_channels(ismember(all_channels,tetrode_channels))=[];
%         all_channels(~ismember(all_channels,channels_to_keep))=[];
%         RefSubtraction_multi_AverageChans([mouse_expe{m} '.dat'],nb_channels,1,'SpikeRef',tetrode_channels,tetrode_channels,all_channels);
%         movefile([mouse_expe{m} '_original.dat'], [mouse_expe{m} '.dat']);
%     end
%     
%     %save
%     cd(mainFolder)
%     refsub_tetrode_done = 1;
%     save preprocessInfo -append refsub_tetrode_done
%     
% end

    
% %% launch ndm start for each mouse
% if ~mouse_lfp_done
%     disp('Mice LFP generation...')
%     
%     % For each mouse
%     for m=1:length(mice_name)
%         
%         %SPIKE REF
%         cd(mouse_path{m})
%         eval('cd ..')
%         %create folder for spike ref
%         mkdir('SpikeRef')
%         cd('SpikeRef')
%         mkdir([mouse_expe{m} '_SpikeRef']);
%         mkdir([mouse_expe{m} '_SpikeRef-wideband']);        
%         movefile([mouse_path{m} '/' mouse_expe{m} '_SpikeRef.dat'], [mouse_path{m} '/../SpikeRef/' mouse_expe{m} '_SpikeRef']);
%         %check xml
%         cd([mouse_path{m} '/../SpikeRef/'])
%         while isempty(dir([mouse_expe{m} '_SpikeRef.xml']))
%             disp(['The xml file ' mouse_expe{m} '_SpikeRef.xml is needed'])
%             input('press any key to continue');
%         end
%         %launch ndm_start
%         command = ['ndm_start ' mouse_expe{m} '_SpikeRef'];
%         system(command);
%         
%         
% %         %LFP
% %         %check xml
% %         cd(mouse_path{m})
% %         eval('cd ..')
% %         while isempty(dir([mouse_expe{m} '.xml']))
% %             disp(['The xml file ' mouse_expe{m} '.xml is needed'])
% %             input('press any key to continue');
% %         end        
% %         %launch ndm_start
% %         command = ['ndm_start ' mouse_expe{m}];
% %         system(command);
%     end
%     
%     %save
%     cd(mainFolder)
%     mouse_lfp_done = 1;
%     save preprocessInfo -append mouse_lfp_done
% end
% 
% 
% 
% %% Klustakwik
% if ~klustakwik_done
%     disp('Klustakwik spike sorting...')
%     
%     % For each mouse
%     for m=1:length(mice_name)
%         mouse_spikeref{m} = [mouse_path{m} '/../SpikeRef/' mouse_expe{m} '_SpikeRef'];
%         cd(mouse_spikeref{m});
%         nb_spikegroup = length(dir('*.fet.*'));
%         
%         %launch klustakwik
%         for i=1:ceil(nb_spikegroup/2)
%             if ~(exist([mouse_expe{m} '_SpikeRef.fet.' num2str(2*i-1)],'file')==2)
%                 command = ['KlustaKwiknew ' mouse_expe{m} '_SpikeRef ' num2str(2*i-1)];
%             end
%             if exist([mouse_expe{m} '_SpikeRef.fet.' num2str(2*i)],'file')==2 && ~(exist([mouse_expe{m} '_SpikeRef.fet.' num2str(2*i)],'file')==2)
%                 command_bis = ['KlustaKwiknew ' mouse_expe{m} '_SpikeRef ' num2str(2*i)];
%                 command = [command ' & ' command_bis];
%             end
%             
%             system(command);
%         end
% 
%     end
%     
%     %save
%     cd(mainFolder)
%     klustakwik_done = 1;
%     save preprocessInfo -append mouse_spikeref klustakwik_done
% end 
% 
% 
% %% clean folders
% if ~clean_folders_done
%     disp('Cleaning folders...') 
%     
%     
%     % For each mouse
%     for m=1:length(mice_name)
%         cd(mouse_spikeref{m});
%         nb_clu = length(dir('*.clu.*'));
%         
%         for i=1:nb_clu
%             name_file_clu = [mouse_expe{m} '_SpikeRef.clu.' num2str(i)];
%             name_file_spk = [mouse_expe{m} '_SpikeRef.spk.' num2str(i)];
%             name_file_res = [mouse_expe{m} '_SpikeRef.res.' num2str(i)];
%             name_file_fet = [mouse_expe{m} '_SpikeRef.fet.' num2str(i)];
%             
%             movefile(name_file_clu, mouse_path{m});
%             movefile(name_file_spk, mouse_path{m});
%             movefile(name_file_res, mouse_path{m});
%             movefile(name_file_fet, mouse_path{m});
%         end
%         
%         % in the lfp path
%         cd(mouse_path{m});
%         for i=1:nb_clu
%             name_file_clu = [mouse_expe{m} '_SpikeRef.clu.' num2str(i)];
%             name_file_spk = [mouse_expe{m} '_SpikeRef.spk.' num2str(i)];
%             name_file_res = [mouse_expe{m} '_SpikeRef.res.' num2str(i)];
%             name_file_fet = [mouse_expe{m} '_SpikeRef.fet.' num2str(i)];
%             
%             movefile(name_file_clu, strrep(name_file_clu,'_SpikeRef',''));
%             movefile(name_file_spk, strrep(name_file_spk,'_SpikeRef',''));
%             movefile(name_file_res, strrep(name_file_res,'_SpikeRef',''));
%             movefile(name_file_fet, strrep(name_file_fet,'_SpikeRef',''));
%         end
%         
%         %save a copy of original .clu
%         mkdir('OldClu')
%         for i=1:nb_clu
%             name_file_clu = [mouse_expe{m} '.clu.' num2str(i)];
%             copyfile(name_file_clu,'OldClu');
%         end
%         
%         %delete SpikeRef Folder
%         cd([mouse_spikeref{m} '/../..']);
%         rmdir SpikeRef s
%         
%     end
%     
%     %save
%     cd(mainFolder)
%     clean_folders_done = 1;
%     save preprocessInfo -append clean_folders_done
% end 
% 
% 










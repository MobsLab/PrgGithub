function CreateEpochs(fbasename)

% This function creates a DatSegments.mat file which contains:
% time from start to end of SleepPRE/POS and WAKE epochs
% indices of original dat files associated to each of those epochs
% 
% Adrien Peyrache 2011

disp(['CreateEpochs for ' fbasename '...']) 

fname = [fbasename filesep 'DatSegments.txt'];
t = load(fname);
t = [0;cumsum(t)];

epochs = {'sleepPreEp';'wakeEp';'sleepPostEp'};

fname = [fbasename filesep 'BehavEpochs.mat'];
README = 'xxxEpIx indicate the indices of original dat files,xxxEp give the time (in timestamps - should be 1/1250 sec.)';
README = [README ' of start and ends of the different epochs'];

save(fname,'README');

for ii=1:length(epochs)

    done=0;
    while ~done
        ix1=[];
        while isempty(ix1)
            ix1 = inputdlg(['First ' epochs{ii} ' dat file Indice (0 if nothing)']);
            ix1 = str2num(ix1{1});
        end
        if ix1~=0
            ix2=[];
            while isempty(ix2)
                ix2 = inputdlg(['Last ' epochs{ii} ' dat file Indice (0 if nothing)']);
                ix2 = str2num(ix2{1});
            end
            if ix2<ix1
                disp('Second indice cannot be smaller than the first one, start again')
            else
                if ix1~=ix2
                    eval([epochs{ii} 'Ix = [ix1 ix2];']);
                else
                    eval([epochs{ii} 'Ix = ix1;']);
                end

                eval([epochs{ii} ' = [t(ix1)+1 t(ix2+1)];']);
                done=1;
            end
        else
            eval([epochs{ii} 'Ix = [];']);
            eval([epochs{ii} ' = [];']);            
            done=1;
        end
        if done
            eval(['save(fname,''' epochs{ii} ''',''' epochs{ii} 'Ix'',''-append'')']);
        end
    end    
end

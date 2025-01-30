function CreateEpochs()

% USAGE
%     CreateEpochs(fbasename)
% 
% This function creates a BehEpoch.mat file which contains:
% time from start to end of SleepPRE/POS and WAKE epochs
% indices of original dat files associated to each of those epochs.
% Must be launched within merged data folder with either be either specifying the file basename or just calling
% 'CreateEpochs(pwd)'
% 
% Adrien Peyrache 2011

[dummy fbasename dummy] = extractfbasename(pwd);

disp(['CreateEpochs for ' fbasename '...']) 
if ~exist('Analysis','dir')
    mkdir('Analysis')
end

epochs = {'sleepPreEp';'wakeEp';'sleepPostEp';'radEp';'radRestEp';'wakeOptoEp';'restOptoEp'};

fname = ['Analysis/BehavEpochs.mat'];
README = 'xxxEpIx indicate the indices of original dat files,xxxEp is an intervalSet from the TStoolbox';
README = [README ' of start and ends of the different epochs'];

save(fname,'README');
ixall = [];
for ii=1:length(epochs)
    ix1 = inputdlg(['List ' epochs{ii} ' dat file indices (0 if nothing)']);
    ix1 = ix1{1};
    ix1 = str2num(ix1);
    
    if ix1~=0
        if any(ismember(ixall,ix1))
            warning('Watch out! Already entered indices')
            keyboard
        end
        ixall = [ixall ix1];
        eval([epochs{ii} 'Ix = ix1;']);
        ep = LoadEpochFromDatSeg(ix1);
        eval([epochs{ii} ' = ep;']);
        eval(['save(fname,''' epochs{ii} ''',''' epochs{ii} 'Ix'',''-append'')']);
    end
end

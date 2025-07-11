%% processing pipeline for a mouse
% initialise
info = init_file;

% building of LFP data

% tracking of movement

% create file with name of each electrode
ChannelName = [{''}, {''}, {''}];
% %% saving LFP data individualy for each channel
% filename_LFP = 'LFPData';
% SaveLFP(filename_LFP)


%% sanity check on behavioral data
a = dir('LocalGlobalAssignment*.mat');
figure;
for i = 1:numel(a)
    load(a(i).name)
    list_var = who;
    for v =1:length(list_var)
        if ~isempty(strfind(list_var{v}, 'Local'))||~isempty(strfind(list_var{v}, 'Omi'))
            if list_var{v}(end)=='A'
                hold on; eval(['plot(' list_var{v} '/1e4, ones(1, numel(' list_var{v} ')), ''.b'')'])
            else
                hold on; eval(['plot(' list_var{v} '/1e4, ones(1, numel(' list_var{v} ')), ''.r'')'])
            end
        end
    end
    
    
end

%% extract interesting periods (ask each time that an event structure already exists if we want to recompute it
% do the sleepscoring : gets periods of mouvement, periods of rest, sleep,
% high and low theta, infers sws, remsleep and wake



load LocalGlobalAssignment1.mat
Epoch = intervalSet(1, max(LocalStdGlobStdA(end),LocalStdGlobStdB(end)));

sleepscoring_CW(LFP,Tracking, Epoch);

%% Save the trials for each condition
% for all type

smo=2;
load([info.maindir,'/LFPData/InfoLFP']);

pre=-2000;
post=+13000;

a = dir([info.maindir '/LFPData/LFP*.mat']);
NameBlocs = dir('LocalGlobalAssignment*.mat');

for num=1:numel(a)
    clearvars LFP* LFP2
    
    load([info.maindir,'/LFPData/LFP',num2str(num)]);
    try 
        LFP2=ResampleTSD(LFP,500);
    catch
        eval(['LFP2 = ResampleTSD(LFP' num2str(num) ',500);'])
    end
    for bloc = 1:numel(NameBlocs);
        load(NameBlocs(bloc).name)
        
        
        figure, [fh, rasterAx, histAx, freqXX(bloc, num)]=ImagePETH(LFP2, ts(sort([LocalStdGlobStdA;LocalStdGlobStdB])), pre, post,'BinSize',800);close
        figure, [fh, rasterAx, histAx, freqXY(bloc,num)]=ImagePETH(LFP2, ts(sort([LocalDvtGlobStdA;LocalDvtGlobStdB])), pre, post,'BinSize',800);close
        figure, [fh, rasterAx, histAx, rareXY(bloc,num)]=ImagePETH(LFP2, ts(sort([LocalStdGlobDvtA;LocalStdGlobDvtB])), pre, post,'BinSize',800);close
        figure, [fh, rasterAx, histAx, rareXX(bloc,num)]=ImagePETH(LFP2, ts(sort([LocalDvtGlobDvtA;LocalDvtGlobDvtB])), pre, post,'BinSize',800);close
        figure, [fh, rasterAx, histAx, OmiFreq(bloc,num)] = ImagePETH(LFP2, ts(sort([OmiAAAA;OmiBBBB])), pre, post,'BinSize',800);close
        figure, [fh, rasterAx, histAx, OmiRare(bloc,num)] = ImagePETH(LFP2, ts(sort([OmissionRareA;OmissionRareB])), pre, post,'BinSize',800);close%% attention, les omissions ne sont pas codées comme omissions dans un bloc XX ou XY
        
    end
    
    
end

cd([info.maindir '/LFPData/'])
save ConditionsMMN_Main freqXX freqXY rareXX rareXY OmiFreq OmiRare
save freqXX freqXX
save freqXY freqXY
save rareXX rareXX
save rareXY rareXY
save OmiFreq OmiFreq
save OmiRare OmiRare


%% Plot responses
ContrastName = {'LocalXX', 'LocalXY', 'GlobalXX', 'GlobalXY', 'Omi'};%, 'LocalEffect', 'GlobalEffect'};
Contrast = {{'freqXX', 'freqXY'}, {'rareXY','rareXX'},{'freqXX','rareXY'}, {'freqXY','rareXX'},{'OmiFreq','OmiRare'}};%, {'allXX','allXY'},{'allFreq','allRare'}};
A =whos('freqXX','size');
for c = 1:numel(ContrastName)
    figure('Position', [100 200 1200 800], 'Color', [1 1 1]);
    for chan = 1:A.size( 2)
        cfg = [];
        cfg.chan = chan;
        cfg.Effect = ContrastName{c};
        cfg.structure= InfoLFP.structure{chan+1};
        
        subplot(floor(sqrt(A.size(2))),A.size(2)/floor(sqrt(A.size(2))), chan) ;
        eval(['plot_contrast( cfg,' Contrast{c}{1} ',' Contrast{c}{2} ')'])
    end
end

%%
MetaContrastName = {'LocalEffect', 'GlobalEffect'};
MetaContrast = {{'freqXX', 'rareXY','rareXX', 'freqXY'}, {'freqXY', 'freqXX','rareXX', 'rareXY'}};
A =whos('freqXX','size');
for c = 1:numel(MetaContrastName)
    
    for chan = 1:A.size(2)
        figure('Position', [100 200 1200 800], 'Color', [1 1 1]);
        cfg = [];
        cfg.chan = chan;
        cfg.Effect = MetaContrastName{c};
        cfg.structure= InfoLFP.structure{chan+1};
        
        %subplot(floor(sqrt(A.size(2))),A.size(2)/floor(sqrt(A.size(2))), chan) ;
        eval(['plot_metacontrast( cfg,' MetaContrast{c}{1} ',' MetaContrast{c}{2} ',' MetaContrast{c}{3} ',' MetaContrast{c}{4} ')'])
    end
end




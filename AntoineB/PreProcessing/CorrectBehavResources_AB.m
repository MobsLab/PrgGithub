% Script based on CorrectBehavResources.m
% Coded by Antoine Bergel antoine.bergel[at]espci.fr
% 03/09/2021

% Moves all behavResources.mat and cleanbehavResources.mat in the folder Old
% Regenerates behavResources.mat in the right format (namely Xtsd, Ytsd,
% AlignedXtsd and AlignedYtsd

% The general rationale is that in the new format the process of cleaning
% tsd in performed automatically so no need to 

% Load all experiments in
Dir = PathForExperimentsReversalBehavior_AB('Hab');
all_experiments = {'Hab', 'Ext' , 'TestPre', 'TestProbe',...
    'TestPostPAG', 'TestPostMFB',...
    'CondPAG', 'CondWallShockPAG', 'CondWallSafePAG',...
    'CondMFB', 'CondWallShockMFB', 'CondWallSafeMFB'};
all_but_hab = {'Ext','TestPre', 'TestProbe','TestPostPAG','TestPostMFB',...
    'CondPAG','CondWallShockPAG','CondWallSafePAG',...
    'CondMFB','CondWallShockMFB','CondWallSafeMFB'};
for i =1:length(all_but_hab)
    Dir2 = PathForExperimentsReversalBehavior_AB(char(all_but_hab(i)));
    Dir = MergePathForExperiment(Dir,Dir2);
end


% Restrict to some mice if needed
mice = [863 913 932 934 935 938];   % Marcelo's Data
%mice = [1138 1139 1140 1141 1142 1143];   % Mathilde's Data
Dir_ = RestrictPathForExperiment(Dir, 'nMice', mice);

% % Restrict to some group if needed
Dir_=RestrictPathForExperiment(Dir,'Group','ReversalSham');

n_exp = length(Dir.path);
for iexp = 1:n_exp
    
    n_rec = length(Dir.path{iexp});
    for irec = 1:n_rec
        cd(Dir.path{iexp}{irec});
        
        % If Old dir does not exist, create it and move behavResources.mat and
        % cleanBehavResources.mat if exist
        if ~exist(fullfile(pwd,'Old'),'dir')
            mkdir('Old');
            if exist('behavResources.mat','file')
                movefile('behavResources.mat', fullfile(pwd,'Old'));
                fprintf('File behavResources.mat => [%s].\n',fullfile(pwd,'Old'));
            end
            if exist('cleanbehavResources.mat','file')
                movefile('cleanbehavResources.mat', fullfile(pwd,'Old'));
                fprintf('File cleanbehavResources.mat => [%s].\n',fullfile(pwd,'Old'));
            end
        end
        
        % Load old data
        if exist(fullfile(pwd,'Old','cleanbehavResources.mat'),'file')
            load(fullfile('Old','cleanbehavResources.mat'));
        elseif exist(fullfile(pwd,'Old','behavResources.mat'),'file')
            load(fullfile('Old','behavResources.mat'));
        else
            warning('No data found in repository [%s]',fullfile(pwd,'Old'));
        end
        
        %% Process data
        % Create info
        Info.Align = true;
        Info.Clean = true;
        
        time = Range(CleanXtsd, 's');
        X = Data(CleanXtsd);
        Y = Data(CleanYtsd);
        events = PosMat(:,4);
        CleanPosMat = [time X Y events];
        PosMat = CleanPosMat;
        
        Xtemp = Data(CleanXtsd);
        T1 = Range(CleanXtsd);
%        XXX = floor(Data(CleanXtsd)*Ratio_IMAonREAL);
        XXX = floor(Data(CleanYtsd)*Ratio_IMAonREAL);
        XXX(isnan(XXX)) = 240;
%        YYY = floor(Data(CleanYtsd)*Ratio_IMAonREAL);
        YYY = floor(Data(CleanXtsd)*Ratio_IMAonREAL);
        YYY(isnan(YYY)) = 320;
%         CleanZoneIndices=[];
%         CleanZoneEpoch=[];
        for t = 1:length(Zone)
            Old.CleanZoneIndices{t}=find(diag(Zone{t}(XXX,YYY)));
            Xtemp2=Xtemp*0;
            Xtemp2(Old.CleanZoneIndices{t})=1;
            Old.CleanZoneEpoch{t}=thresholdIntervals(tsd(T1,Xtemp2),0.5,'Direction','Above');
        end
        
        Old.CleanVtsd = tsd(CleanPosMat(1:end-1,1)*1e4,(sqrt(diff(CleanPosMat(:,2)).^2+diff(CleanPosMat(:,3)).^2)./(diff(CleanPosMat(:,1)))));
        
        % Create a backup old variables
        Old.Xtsd = Xtsd;
        Old.Ytsd = Ytsd;
        Old.Vtsd = Vtsd;
        Old.CleanXtsd = CleanXtsd;
        Old.CleanYtsd = CleanYtsd;
%        Old.CleanVtsd = CleanVtsd;
        Old.PosMat = PosMat;
        Old.CleanPosMat = CleanPosMat;
%         Old.CleanPosMatInit = CleanPosMatInit;
%         Old.AlignedXtsd = AlignedXtsd;
%         Old.AlignedYtsd = AlignedYtsd;
        Old.CleanAlignedXtsd = CleanAlignedXtsd;
        Old.CleanAlignedYtsd = CleanAlignedYtsd;
%         Old.CleanZoneEpoch = CleanZoneEpoch;
        Old.CleanZoneEpochAligned = CleanZoneEpochAligned;
%         Old.CleanZoneIndices = CleanZoneIndices;
        Old.ZoneEpoch = ZoneEpoch;
%         Old.ZoneEpochAligned = ZoneEpochAligned;
        Old.ZoneIndices = ZoneIndices;
%         Old.LinearDist = LinearDist;
%         Old.CleanLinearDist = CleanLinearDist;        
%         Old.behavResources = behavResources;
        
        % Remove all unneccessary vars
        clear Xtsd Ytsd Vtsd CleanXtsd CleanYtsd CleanVtsd PosMat CleanPosMat CleanPosMatInit
        clear AlignedXtsd AlignedYtsd CleanAlignedXtsd CleanAlignedYtsd CleanZoneEpoch
        clear CleanZoneEpochAligned ZoneEpoch ZoneEpochAligned ZoneIndices
        clear LinearDist CleanLinearDist CleanZoneIndices
        clear behavResources
        
        % Substitute stand-alone variables
        Xtsd = Old.CleanXtsd;
        Ytsd = Old.CleanYtsd;
        AlignedXtsd = Old.CleanAlignedXtsd;
        AlignedYtsd = Old.CleanAlignedYtsd;
        %     AlignedXtsd = Old.AlignedXtsd; % for Sam
        %     AlignedYtsd = Old.AlignedYtsd;  % for Sam
        Vtsd = Old.CleanVtsd;
        
        PosMat = Old.CleanPosMat;
        ZoneIndices = Old.CleanZoneIndices;
        ZoneEpoch = Old.CleanZoneEpoch;
%         LinearDist = Old.CleanLinearDist;
        
        % Save
        save('behavResources.mat', '-regexp', '^(?!(Dir|mice|iexp|Old)$).');
        fprintf('> File behavResources.mat saved [%s].\n',pwd);
        clearvars -except Dir mice iexp irec n_exp n_rec
    end
end
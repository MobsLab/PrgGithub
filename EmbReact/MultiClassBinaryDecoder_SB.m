function [Acc_all,Acc_ConfMat,MeanW] = MultiClassBinaryDecoder_SB(Vals,varargin)

% Impelements All-On-All multiclasse classification

%% INPUTS
% Vals      : a structure containing the classes you want to distinguish
% permutnum : number of permutations of data to perform
% dorand    : DoRandomizedData
% testonfr  : instead of decoding ,all weights are set to one

%% OUTPUTS
% Acc_all   : all to all accuracy
% Acc_ConfMat :  confusion matrix
% MeanW :   decoding vector

% Parse parameter list
for i = 1:2:length(varargin)
    if ~ischar(varargin{i})
        error(['Parameter ' num2str(i+2) ' is not a property.']);
    end
    switch(lower(varargin{i}))
        case 'permutnum'
            permutnum = varargin{i+1};
        case 'dorand'
            dorand = varargin{i+1};
        case 'testonfr'
            testonfr = varargin{i+1};
        case 'crossval_half'
            crossval_half = varargin{i+1};
        otherwise
            error(['Unknown property ''' num2str(varargin{i}) '''.']);
    end
end

% set defaults
if ~exist('permutnum','var')
    permutnum = 100;
end
if ~exist('crossval_half','var')
    crossval_half = 0;
end
if ~exist('dorand','var')
    dorand = 0;
end
if ~exist('testonfr','var')
    testonfr = 0;
end

% get lowest number of trials of all classes so that have same number of
% elements per class
fields = fieldnames(Vals);
for f = 1:length(fields)
    Vals.(fields{f}) = full(Vals.(fields{f}));
    numelem(f) = size(Vals.(fields{f}),1);
end
Minnumelem = min(numelem);

% make sur its divisible by 4 (for rand)
Minnumelem = floor(Minnumelem/4)*4;

% get the random trial numbers for all permutations
if crossval_half
    permutnum = 2;
    for f = 1:length(fields)
        TrialID_test{f} = [[1:Minnumelem/2]; [Minnumelem/2:Minnumelem-1]]';
        TrialID_train{f} = [[Minnumelem/2:Minnumelem-1];[1:Minnumelem/2]]';
        
    end
    
else
    for f = 1:length(fields)
        RandVals = rand(size(Vals.(fields{f}),1),permutnum);
        [I,C] = sort(RandVals);
        TrialID_test{f} = C(1:Minnumelem/2,:);
        TrialID_train{f} = C(Minnumelem/2+1:Minnumelem,:);
    end
end

% Binary decoder for each class vs each class
for pp = 1:permutnum
    for f = 1:length(fields)
        for ff = 1:length(fields)
            
            if f==ff
                Acc_ConfMat(f,ff,pp) = NaN;
                Acc_ConfMat(ff,f,pp) = NaN;
                
                SaveW(f,ff,:) = nan(1,size(Vals.(fields{f}),2));
                SaveBiais(f,ff) = NaN;
            else
                
                A = Vals.(fields{f})(TrialID_train{f}(:,pp),:);
                B = Vals.(fields{ff})(TrialID_train{ff}(:,pp),:);
                
                A_test = Vals.(fields{f})(TrialID_test{f}(:,pp),:);
                B_test = Vals.(fields{ff})(TrialID_test{ff}(:,pp),:);
                
                if dorand
                    A_temp = [A(1:Minnumelem/4,:);B(Minnumelem/4+1:Minnumelem/2,:)];
                    B = [A(Minnumelem/4+1:Minnumelem/2,:);B(1:Minnumelem/4,:)];
                    A = A_temp;
                    A_temp = [A_test(1:Minnumelem/4,:);B_test(Minnumelem/4+1:Minnumelem/2,:)];
                    B_test = [A_test(Minnumelem/4+1:Minnumelem/2,:);B_test(1:Minnumelem/4,:)];
                    A_test = A_temp;
                end
                
                % vector : subtraction of average activity on training trials
                W = nanmean(A - B);
                
                % Just test on firing rate (same weigth for each neuron)
                if testonfr
                    W = W.*0+1;
                    if nanmean(A*W')<nanmean(B*W')
                        W = -W;
                    end
                end
                W = W./norm(W);
                % Bias : centre between tow sets of data after projection
                Biais = nanmean(A*W' + B*W')/2;
                % TestValues
                Acc_ConfMat(f,ff,pp) = nanmean((A_test*W'-Biais)>0);
                Acc_ConfMat(ff,f,pp) = nanmean((B_test*W'-Biais)<0);
                
                SaveW(f,ff,:) = W;
                SaveBiais(f,ff) = Biais;
            end
            
        end
    end
    %
    % Get overall accuracy
    
    for f = 1:length(fields)
        ValsForTesting{f} =  Vals.(fields{f})(TrialID_test{f}(:,pp),:);
    end
    
    if dorand
        AllVals  = [];
        for f = 1:length(fields)
            AllVals  =[AllVals;ValsForTesting{f}];
        end
        AllVals = AllVals(randperm(size(AllVals,1),size(AllVals,1)),:);
        for f = 1:length(fields)
            ValsForTesting{f} =  AllVals(1+size(ValsForTesting{f},1)*(f-1):size(ValsForTesting{f},1)+size(ValsForTesting{f},1)*(f-1),:);
        end
    end
    
    
    
    for f = 1:length(fields)
        % for each trial of type f, get the scores on all combinations of
        % decoding
        clear ValueToUse
        for f1 = 1:length(fields)
            for f2 = 1:length(fields)
                ValueToUse(f1,f2,:) = (ValsForTesting{f}*squeeze(SaveW(f1,f2,:)))-SaveBiais(f1,f2);
                if f1 ==f2
                    ValueToUse(f1,f2,:) = ValueToUse(f1,f2,:)*NaN;
                end
                % the value should be positive if the trial is f1
            end
        end
        % average over second dimension, to get the lines where f1=f
        [maxval,maxcol] = nanmax(squeeze(nanmean(ValueToUse,2)));
        Acc_all(f,pp) = nanmean(squeeze(maxcol)==f);
        
    end
    MeanW (:,:,pp,:) = SaveW;
end
%
% %
% %
% figure
% clf
% f=2
% for f1 = 1:length(fields)
%     for f2 = 1:length(fields)
%         subplot(5,5,(f1-1)*5+f2)
%         nhist(squeeze(ValueToUse(f1,f2,:)));
%         G(f1,f2) = mean(squeeze(ValueToUse(f1,f2,:)));
%         %         nhist({ValsForTesting{f}*squeeze(SaveW(f1,f2,:))-SaveBiais(f1,f2)})
%         %         ,...
%         %            Vals.(fields{f2})(TrialID_train{f2}(:,pp),:)*squeeze(SaveW(f1,f2,:))-SaveBiais(f1,f2)})
%         title([num2str(f1) '-' num2str(f2)])
%
%     end
% end
% %
%
%

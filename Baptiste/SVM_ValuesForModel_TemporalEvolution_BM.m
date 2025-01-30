

clear all

ParToKeep = {[1:8],[1,4:8],[1,4:5 7:8]};
ParNames = {'All','NoHeart','NoHeartNoRip'};
kernels = {'linear','rbf'};
PosLimStep = 0.5;
PosLims = [0.3 0.6];
DoZscore = 0;
SaveLoc = '/media/nas7/ProjetEmbReact/DataEmbReact/PaperData/';

% load('/media/nas7/ProjetEmbReact/DataEmbReact/Data_Physio_Freezing_Saline_all_Cond_2sFullBins.mat')
load('/media/nas7/ProjetEmbReact/DataEmbReact/NewData/Data_Physio_Freezing_Saline_Eyelid_Cond_2sFullBins.mat')
SessionTypes = {'Cond'}; sess=1;
SessType = SessionTypes{sess};

AllMice = fieldnames(DATA.(SessType));
MergedData = [];
MouseId = [];
Pos = [];
for mm = 1:length(AllMice)
    MergedData = cat(2,MergedData,DATA.(SessType).(AllMice{mm})(1:8,:));
    MouseId = cat(2,MouseId,ones(1,size(DATA.(SessType).(AllMice{mm}),2))*mm);
    Pos = cat(2,Pos,DATA.(SessType).(AllMice{mm})(9,:));
end

GoodMice = unique(MouseId);

n=1;
for parToUse = 1:length(ParNames)
    for svm_type = 1%1:length(kernels)
        
        %% Contols train and test
        % Only keep subset of parameters
        DATA2 = MergedData(ParToKeep{parToUse},:);
        
        
        %% LOO iteration
        for mm = 1:length(GoodMice)
            
            % Define train and test sets
            train_X = DATA2(:,find(MouseId~=GoodMice(mm)));
            test_X = DATA2(:,find(MouseId==GoodMice(mm)));
            train_Y = Pos(find(MouseId~=GoodMice(mm)));
            test_Y = Pos(find(MouseId==GoodMice(mm)));
            test_Pos =  Pos(find(MouseId==GoodMice(mm)));
            
            % Only keep interpretable positions for training
            Bad = (train_Y<PosLims(2) & train_Y>PosLims(1));
            train_X(:,Bad) = [];
            train_Y(Bad) = [];
            
            % Binarize in the middle of the maze
            train_Y = train_Y'>PosLimStep; % 1 for safe, 0 for shock
            test_Y = test_Y'>PosLimStep; % 1 for safe, 0 for shock
            
            % Keep only mice with full set of value
            train_Y(sum(isnan(train_X))>0) = [];
            test_Y(sum(isnan(test_X))>0) = [];
            
            train_X(:,sum(isnan(train_X))>0) = [];
            Time_svm = DATA.Cond.(AllMice{mm})(10,~sum(isnan(test_X))>0);
            test_X(:,sum(isnan(test_X))>0) = [];
            size(test_X);
            
            
            if ~isempty(test_X)
                
                % balance the data
                numclass = min([sum(train_Y==0),sum(train_Y==1)]);
                SkId = find(train_Y==0);
                SkId = SkId(randperm(length(SkId),numclass));
                SfId = find(train_Y==1);
                SfId = SfId(randperm(length(SfId),numclass));
                train_Y = train_Y([SkId;SfId]);
                train_X = train_X(:,[SkId;SfId]);
                
                
                classifier_controltrain = fitcsvm(train_X',train_Y,...
                    'ClassNames',[0,1],'KernelFunction',kernels{svm_type});
                [prediction,scores2_test] = predict(classifier_controltrain,test_X');
                
                scores2_test_ByMouse{n}{mm} = scores2_test;
                try, RipDensity{mm} = test_X(6,:); end
                SVMScores_Sk_Ctrl{svm_type}{parToUse}{mm} = scores2_test(test_Y==0);
                SVMScores_Sf_Ctrl{svm_type}{parToUse}{mm} = scores2_test(test_Y==1);
                SVMChoice_Sk_Ctrl{svm_type}{parToUse}{mm} = prediction(test_Y==0);
                SVMChoice_Sf_Ctrl{svm_type}{parToUse}{mm} = prediction(test_Y==1);
                LinPos_Sk_Ctrl{svm_type}{parToUse}{mm} = test_Pos(test_Y==0);
                LinPos_Sf_Ctrl{svm_type}{parToUse}{mm} = test_Pos(test_Y==1);
                
                SVMScores_Sk_Ctrl_Mn{svm_type}(parToUse,mm) = nanmean(scores2_test(test_Y==0));
                SVMScores_Sf_Ctrl_Mn{svm_type}(parToUse,mm) = nanmean(scores2_test(test_Y==1));
                SVMChoice_Sk_Ctrl_Mn{svm_type}(parToUse,mm) = nanmean(prediction(test_Y==0));
                SVMChoice_Sf_Ctrl_Mn{svm_type}(parToUse,mm) = nanmean(prediction(test_Y==1));
                
                SVMScores_Sk_tsd{n}{mm} = tsd(Time_svm(test_Y==0) , SVMScores_Sk_Ctrl{svm_type}{parToUse}{mm}(:,1));
                SVMScores_Sf_tsd{n}{mm} = tsd(Time_svm(test_Y==1) , SVMScores_Sf_Ctrl{svm_type}{parToUse}{mm}(:,1));
                
                % SVM temporal evol
                try
                    SVMScores_Sk_Ctrl_interp(parToUse,mm,:) = interp1(linspace(0,1,length(SVMScores_Sk_Ctrl{svm_type}{parToUse}{mm})) , SVMScores_Sk_Ctrl{svm_type}{parToUse}{mm} , linspace(0,1,100));
                    SVMScores_Sf_Ctrl_interp(parToUse,mm,:) = interp1(linspace(0,1,length(SVMScores_Sf_Ctrl{svm_type}{parToUse}{mm})) , SVMScores_Sf_Ctrl{svm_type}{parToUse}{mm} , linspace(0,1,100));
                    SVMChoice_Sk_Ctrl_interp(parToUse,mm,:) = interp1(linspace(0,1,length(SVMChoice_Sk_Ctrl{svm_type}{parToUse}{mm})) , SVMChoice_Sk_Ctrl{svm_type}{parToUse}{mm} , linspace(0,1,100));
                    SVMChoice_Sf_Ctrl_interp(parToUse,mm,:) = interp1(linspace(0,1,length(SVMChoice_Sf_Ctrl{svm_type}{parToUse}{mm})) , SVMChoice_Sf_Ctrl{svm_type}{parToUse}{mm} , linspace(0,1,100));
                end
                
            else
                SVMScores_Sk_Ctrl{svm_type}{parToUse}{mm} = [];
                SVMScores_Sf_Ctrl{svm_type}{parToUse}{mm} = [];
                SVMChoice_Sk_Ctrl{svm_type}{parToUse}{mm} = [];
                SVMChoice_Sf_Ctrl{svm_type}{parToUse}{mm} = [];
                LinPos_Sf_Ctrl{svm_type}{parToUse}{mm} = [];
                LinPos_Sk_Ctrl{svm_type}{parToUse}{mm} = [];
                
                SVMScores_Sk_Ctrl_Mn{svm_type}(parToUse,mm) = NaN;
                SVMScores_Sf_Ctrl_Mn{svm_type}(parToUse,mm) = NaN;
                SVMChoice_Sk_Ctrl_Mn{svm_type}(parToUse,mm) = NaN;
                SVMChoice_Sf_Ctrl_Mn{svm_type}(parToUse,mm) = NaN;
            end
            disp(GoodMice(mm))
        end
    end
    n=n+1;
end

SVMScores_Sk_Ctrl_interp(SVMScores_Sk_Ctrl_interp==0)=NaN;
SVM_score_FzShock_Cond_interp = squeeze(SVMScores_Sk_Ctrl_interp(1,:,:));
SVM_score_FzShock_Cond_interp(find(sum(isnan(squeeze(SVMScores_Sk_Ctrl_interp(1,:,:))'))==100),:) = SVMScores_Sk_Ctrl_interp(2,find(sum(isnan(squeeze(SVMScores_Sk_Ctrl_interp(1,:,:))'))==100),:);
SVMScores_Sf_Ctrl_interp(SVMScores_Sf_Ctrl_interp==0)=NaN;
SVM_score_FzSafe_Cond_interp = squeeze(SVMScores_Sf_Ctrl_interp(1,:,:));
SVM_score_FzSafe_Cond_interp(find(sum(isnan(squeeze(SVMScores_Sf_Ctrl_interp(1,:,:))'))==100),:) = SVMScores_Sf_Ctrl_interp(2,find(sum(isnan(squeeze(SVMScores_Sf_Ctrl_interp(1,:,:))'))==100),:);

save('SVMScores_Eyelid.mat','SVM_score_FzShock_Cond_interp','SVM_score_FzSafe_Cond_interp','-append')

for mm = 1:length(GoodMice)
    try
        SVM_Sk_TSD{mm} = SVMScores_Sk_tsd{1}{mm};
        n=2;
        while isempty(SVM_Sk_TSD{mm})
            SVM_Sk_TSD{mm} = SVMScores_Sk_tsd{n}{mm};
            n=n+1;
        end
    end
    try
        SVM_Sf_TSD{mm} = SVMScores_Sf_tsd{1}{mm};
        n=2;
        while isempty(SVM_Sf_TSD{mm})
            SVM_Sf_TSD{mm} = SVMScores_Sf_tsd{n}{mm};
            n=n+1;
        end
    end
end
save('/media/nas7/ProjetEmbReact/DataEmbReact/NewData/SVM_tsd.mat','SVM_Sk_TSD','SVM_Sf_TSD')

%% mean values for a mice group
clear all

ParToKeep = {[1:8],[1,4:8]};
ParNames = {'All','NoHeart'};
kernels = {'linear','rbf'};
DoZscore = 0;
codename = mfilename;
SaveLoc = '/media/nas7/ProjetEmbReact/DataEmbReact/PaperData/';
SessionTypes = {'Cond'};
Mouse=Drugs_Groups_UMaze_BM(11);

load('/media/nas7/ProjetEmbReact/DataEmbReact/ThesisData/Physio_BehavGroup.mat', 'OutPutData')
load('/media/nas7/ProjetEmbReact/DataEmbReact/Data_Physio_Freezing_FlxChr_Fear_2sFullBins.mat', 'Params')

% load data
for sess = 1:length(SessionTypes)
    
    SessType = SessionTypes{sess};
    
    AllMice = Mouse;
    clear DATA_Ctrl
    for n= 1:8
        DATA_Ctrl(n,:) = [OutPutData.(SessType).(Params{n}).mean(:,5)' OutPutData.(SessType).(Params{n}).mean(:,6)'];
    end
    
    for parToUse = 1:length(ParNames)
        for svm_type = 1%:length(kernels)
            
            %% Contols train and test
            % Only keep subset of parameters
            DATA2 = DATA_Ctrl(ParToKeep{parToUse},:);
            
            % Only keep mice with no NaNs
            totnummice_train = size(DATA2,2)/2;
            BadGuys = sum(isnan(DATA2))>0;
            BadGuys = BadGuys(1:totnummice_train) + BadGuys(totnummice_train+1:end);
            GoodGuys = find(BadGuys==0);
            BadGuys = [BadGuys,BadGuys]>0;
            
            DATA2(:,BadGuys)=[];
            totnummice_train = size(DATA2,2)/2;
            if DoZscore
                Remstd = std(DATA2');
                RemMn = mean(DATA2');
                DATA2 = zscore(DATA2')';
            end
            
            %% LOO iteration
            for perm = 1:size(DATA2,2)/2
                DATA_train = DATA2;
                DATA_train(:,perm+size(DATA2,2)/2) = [];
                DATA_train(:,perm) = [];
                DATA_test = DATA2(:,[perm,perm+size(DATA2,2)/2]);
                
                classifier_controltrain = fitcsvm(DATA_train',[zeros(1,size(DATA_train,2)/2),ones(1,size(DATA_train,2)/2)],...
                    'ClassNames',[0,1],'KernelFunction',kernels{svm_type});
                [prediction,scores2_train] = predict(classifier_controltrain,DATA_test');
                
                SVMScores_Sk_Ctrl{svm_type}(parToUse,GoodGuys(perm)) = scores2_train(1,1);
                SVMScores_Sf_Ctrl{svm_type}(parToUse,GoodGuys(perm)) = scores2_train(2,1);
                SVMChoice_Sk_Ctrl{svm_type}(parToUse,GoodGuys(perm)) = prediction(1,1);
                SVMChoice_Sf_Ctrl{svm_type}(parToUse,GoodGuys(perm)) = prediction(2,1);
                
            end
        end
    end
end
SVMScores_Sk_Ctrl{1}(SVMScores_Sk_Ctrl{1}==0)=NaN;
SVM_score_FzShock_Cond = SVMScores_Sk_Ctrl{1}(1,:);
SVM_score_FzShock_Cond(1,find(isnan(SVMScores_Sk_Ctrl{1}(1,:)))) = SVMScores_Sk_Ctrl{1}(2,find(isnan(SVMScores_Sk_Ctrl{1}(1,:))));
SVMScores_Sf_Ctrl{1}(SVMScores_Sf_Ctrl{1}==0)=NaN;
SVM_score_FzSafe_Cond = SVMScores_Sf_Ctrl{1}(1,:);
SVM_score_FzSafe_Cond(1,find(isnan(SVMScores_Sf_Ctrl{1}(1,:)))) = SVMScores_Sf_Ctrl{1}(2,find(isnan(SVMScores_Sf_Ctrl{1}(1,:))));

save('SVMScores_Eyelid.mat','SVM_score_FzShock_Cond','SVM_score_FzSafe_Cond','SVMChoice_Sk_Ctrl','SVMChoice_Sf_Ctrl')




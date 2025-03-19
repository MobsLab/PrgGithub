clear all
% Variable order
Var = {'respi_freq_bm','heartrate','heartratevar','ob_gamma_freq','ob_gamma_power'};

% Load the UMaze mice - already calculated
l_maze = load('/media/nas7/ProjetEmbReact/DataEmbReact/DataForSVM_AllStates_SB.mat');
l_maze.DATA2  = rmfield(l_maze.DATA2,'ActiveWake');
AllEpoch = fieldnames(l_maze.DATA2);
for ep = 1:length(AllEpoch)
    CatData.(AllEpoch{ep}) = l_maze.DATA2.(AllEpoch{ep})(1:5,:);
end

% Load the sound conditionning mice 
% Data created with : /home/pinky/git_hub/mobs_codes/PrgGithub/Baptiste/FreezingComparison_Maze_SoundCond_BM.m
l_sound=load('/media/nas7/ProjetEmbReact/DataEmbReact/Data_SoundTest_MazeMice.mat');
for mm = 1:length(l_sound.Mouse)
    for var = 1:length(Var)
        if not(isempty(l_sound.OutPutData.sound_test_umze.(Var{var}).tsd{mm,1}))
        CatData.SoundCond(var,mm) = nanmean(Data(Restrict(l_sound.OutPutData.sound_test_umze.(Var{var}).tsd{mm,1},l_sound.Epoch1.sound_test_umze{mm,3})));
        else
         CatData.SoundCond(var,mm) = NaN;   
        end
    end
end
clear l_sound

% % Load the context conditionning mice 
% l_ctxt=load('/media/nas7/ProjetEmbReact/DataEmbReact/Data_FearCtxt.mat');
% % Data created with : /home/pinky/git_hub/mobs_codes/PrgGithub/Baptiste/FreezingComparison_Maze_SoundCond_BM.m
% for mm = 1:length(l_ctxt.Mouse)
%     for var = 1:length(Var)
%         if not(isempty(l_ctxt.OutPutData.fear_ctxt.(Var{var}).tsd{mm,1}))
%             CatData.ContextCond(var,mm) = nanmean(Data(Restrict(l_ctxt.OutPutData.fear_ctxt.(Var{var}).tsd{mm,1},l_ctxt.Epoch1.fear_ctxt{mm,2})));
%         else
%             CatData.ContextCond(var,mm) = NaN;
%         end
%     end
% end
% clear l_ctxt


%% Two By two decoding
Classes = fieldnames(CatData);
for cl1 = 1:length(Classes)
    for cl2 = 1:length(Classes)
        
        if cl1~=cl2
            
            Dat_Cl1 = CatData.(Classes{cl1});
            Dat_Cl2 = CatData.(Classes{cl2});
            % Get rid of mice with just nans
            Dat_Cl1(:,sum(isnan(Dat_Cl1))==5) = [];
            Dat_Cl2(:,sum(isnan(Dat_Cl2))==5) = [];
            
           
            EpType_Red = [zeros(size(Dat_Cl1,2),1);ones(size(Dat_Cl2,2),1)];
            Data_All = [Dat_Cl1,Dat_Cl2];
            
            % Leave One Out
            clear Corr Scores
            for loo = 1:size(Data_All,2)
                % Train data - exclude one mouse
                Data_All_train = Data_All;
                Data_All_train(:,loo) = [];
                EpType_Red_train = EpType_Red;
                EpType_Red_train(loo) = [];
                
                % Test data - keep just that mouse
                Data_All_test = Data_All(:,loo);
                EpType_Red_test = EpType_Red(loo);
                
                % Only keep variables available of test mouse
                GoodVar = find((not(isnan(Data_All_test))));
                Data_All_test = Data_All_test(GoodVar,:);
                Data_All_train = Data_All_train(GoodVar,:);
                EpType_Red_train = EpType_Red_train(sum(~isnan(Data_All_train))==length(GoodVar));
                Data_All_train = Data_All_train(:,sum(~isnan(Data_All_train))==length(GoodVar));
                
                % Equalize group size
                MinClassNumber = min([sum(EpType_Red_train==0),sum(EpType_Red_train==1)]);
                Class0Id = find(EpType_Red_train==0);
                Class0Id = Class0Id(randperm(length(Class0Id),MinClassNumber));
                Class1Id = find(EpType_Red_train==1);
                Class1Id = Class1Id(randperm(length(Class1Id),MinClassNumber));
                EpType_Red_train = EpType_Red_train([Class0Id;Class1Id]);
                Data_All_train = Data_All_train(:,[Class0Id,Class1Id]);

                
                if sum(sum(isnan(Data_All_train)))>0
                    disp('problem')
                end
                Mdl = fitcecoc(Data_All_train',EpType_Red_train);
                [OutPut,score] = predict(Mdl,Data_All_test');
                Corr(loo) = double(OutPut == EpType_Red_test);
                Scores(loo) = score(1);
            end
            Acc(cl1,cl2) = nanmean(Corr);
            Scoressvm(cl1,cl2) = nanmean(Scores);
        end
    end
end



clear all
GroupNames = {'FlxChr','FlxChr_Ctrl','RipInhib','RipInhib_Ctrl'};
PosLimStep = 0.1;


% load saline data
cd /media/nas7/ProjetEmbReact/DataEmbReact
load('Data_Physio_Freezing_Saline_all_CondPost_2sFullBins.mat')


AllMice = fieldnames(DATA.CondPost);

% quick look qt vqriqbles
% for mm = 1:length(AllMice)
%     ha = tight_subplot(10,1);
%     for var = 1:9
%         axes(ha(var))
%         plot(DATA.CondPost.(AllMice{mm})(var,:))
%         title(Params{var})
%     end
%     pause
%     clf
% end


MergedData = [];
MouseId = [];
Pos = [];
for mm = 1:length(AllMice)
    MergedData = cat(2,MergedData,DATA.CondPost.(AllMice{mm})(1:8,:));
    MouseId = cat(2,MouseId,ones(1,size(DATA.CondPost.(AllMice{mm}),2))*mm);
    Pos = cat(2,Pos,DATA.CondPost.(AllMice{mm})(9,:));
end

MergedData_keep = MergedData;
Pos_keep = Pos;
MouseId_keep = MouseId;

for gg = 1:length(GroupNames)
    
    
    load(['/media/nas7/ProjetEmbReact/DataEmbReact/Data_Physio_Freezing_',GroupNames{gg},'_CondPost_2sFullBins.mat'])
    AllMice_Drg = fieldnames(DATA.CondPost);
    MergedData_Drg = [];
    MouseId_Drg = [];
    Pos_Drg = [];
    for mm = 1:length(AllMice_Drg)
        MergedData_Drg = cat(2,MergedData_Drg,DATA.CondPost.(AllMice_Drg{mm})(1:8,:));
        MouseId_Drg = cat(2,MouseId_Drg,ones(1,size(DATA.CondPost.(AllMice_Drg{mm}),2))*mm);
        Pos_Drg = cat(2,Pos_Drg,DATA.CondPost.(AllMice_Drg{mm})(9,:));
    end
    
    MergedData_keep_Drg = MergedData_Drg;
    Pos_keep_Drg = Pos_Drg;
    MouseId_keep_Drg = MouseId_Drg;
    
    % Train the SVM on the saline, tewt on the drug groups
    % different types of kernels
    kernels = {'linear','rbf'};%,'poly2','poly3','poly4'};
    DataTypes = {'all','noHeart','noRip','noRespi','noGamma','noLowHpc','noHRVar'};
    if gg==1 | gg==2
    DataTypeDef = {1:8,[1,4:8],[1:5,7:8],[2:8],[1:3,6:8],[1:6],[1,2,4:8]};
    else
        % always exclude ripples
        DataTypeDef = {[1:5,7,8],[1,4,5,7,8],[1:5,7:8],[2:5,7,8],[1:3,7:8],[1:5],[1,2,4,5,7:8]};
    end
    
    for dt = 1:size(DataTypeDef,2)
        for kk = 1%:length(kernels)
            for ii = 1:9
                
                
                % Z-score everything together
                temp = [MergedData_keep,MergedData_keep_Drg];
                temp = nanzscore(temp')';
                
                % Clean up depending on variables in use for training
                MergedData = temp(DataTypeDef{dt},1:size(MergedData_keep,2));
                Pos = Pos_keep;
                MouseId = MouseId_keep;
                if size(MergedData,1)>1
                    Bad = sum(isnan(MergedData),1)>0;
                    MergedData(:,Bad) = [];
                    Pos(Bad) = [];
                    MouseId(Bad) = [];
                else
                    Bad = isnan(MergedData)>0;
                    MergedData(Bad) = [];
                    Pos(Bad) = [];
                    MouseId(Bad) = [];
                end
                
                theclass =Pos'<PosLimStep*ii;
                
                % Define train and test sets
                train_X = MergedData;
                train_Y = theclass;
                
                
                % Clean up the data on the drug group
                MergedData_Drg = temp(DataTypeDef{dt},size(MergedData_keep,2)+1:end);
                Pos_Drg = Pos_keep_Drg;
                MouseId_Drg = MouseId_keep_Drg;
                if size(MergedData_Drg,1)>1
                    Bad = sum(isnan(MergedData_Drg),1)>0;
                    MergedData_Drg(:,Bad) = [];
                    Pos_Drg(Bad) = [];
                    MouseId_Drg(Bad) = [];
                else
                    Bad = isnan(MergedData_Drg)>0;
                    MergedData_Drg(Bad) = [];
                    Pos_Drg(Bad) = [];
                    MouseId_Drg(Bad) = [];
                end
                
                theclass_Drg =Pos_Drg'<PosLimStep*ii;
                
                test_X = MergedData_Drg;
                test_Y = theclass_Drg;
                test_mouse = MouseId_Drg;
                
                % balance the data
                numclass = min([sum(train_Y==0),sum(train_Y==1)]);
                SkId = find(train_Y==1);
                SkId = SkId(randperm(length(SkId),numclass));
                SfId = find(train_Y==0);
                SfId = SfId(randperm(length(SfId),numclass));
                train_Y = train_Y([SkId;SfId]);
                train_X = train_X(:,[SkId;SfId]);
                
                % train the decoder
                if contains(kernels{kk},'poly')
                    cl = fitcsvm(train_X',train_Y,'KernelFunction','polynomial',...
                        'ClassNames',[0,1],'PolynomialOrder',eval(kernels{kk}(end)));
                else
                    cl = fitcsvm(train_X',train_Y,'KernelFunction',kernels{kk},...
                        'ClassNames',[0,1]);
                end
                
                [y,scores2_train] = predict(cl,train_X');
                y(isnan(train_Y)) = [];
                train_Y(isnan(train_Y)) = [];
                trainscore(ii) = nanmean(y==train_Y);
                trainscore_sf(ii) =  nanmean(y(train_Y==0)==0);
                trainscore_shk(ii) =  nanmean(y(train_Y==1)==1);
                proj_train_sf{ii} = scores2_train(train_Y==0,1);
                proj_train_shk{ii} = scores2_train(train_Y==1,1);
                
                % test on the drug group
                [y,scores2_test] = predict(cl,test_X');
                y(isnan(test_Y)) = [];
                test_Y(isnan(test_Y)) = [];
                testscore(ii) =  nanmean(y==test_Y);
                testscore_sf(ii) =  nanmean(y(test_Y==0)==0);
                testscore_shk(ii) =  nanmean(y(test_Y==1)==1);
                proj_test_sf{ii} = scores2_test(test_Y==0,1);
                proj_test_shk{ii} = scores2_test(test_Y==1,1);
                
            end
            
            save(['/media/nas7/ProjetEmbReact/DataEmbReact/DecodingResults_Corr/SVM_2s',kernels{kk},'_',DataTypes{dt},'Group',GroupNames{gg},'Final.mat'],...
                'testscore','testscore_shk','testscore_sf','proj_test_shk','proj_test_sf',...
                'trainscore','trainscore_sf','trainscore_shk','proj_train_shk','proj_train_sf','MouseId')
            clear testscore testscore_shk testscore_sf proj_test_shk proj_test_sf trainscore trainscore_shk trainscore_sf
        end
    end
end


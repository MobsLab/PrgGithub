clear all
cd /media/nas7/ProjetEmbReact/DataEmbReact
load('Data_Physio_Freezing_Saline_CondPost_2sBin.mat')

AllMice = fieldnames(DATA.CondPost);

% % quick look qt vqriqbles
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

PosLimStep = 0.1;


MergedData = [];
MouseId = [];
Pos = [];
for mm = 1:length(AllMice)
    MergedData = cat(2,MergedData,DATA.CondPost.(AllMice{mm})(1:8,:));
    MouseId = cat(2,MouseId,ones(1,size(DATA.CondPost.(AllMice{mm}),2))*mm);
    Pos = cat(2,Pos,DATA.CondPost.(AllMice{mm})(9,:));
end

if size(MergedData,1)>1
    MergedData = nanzscore(MergedData')';
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

% different types of kernels
kernels = {'linear','rbf','poly2','poly3','poly4'};
DataTypes = {'all','noHeart','noRip','noRespi','noGamma','noLowHpc'};
DataTypeDef = {1:8,[1,4:8],[1:5,7:8],[2:8],[1:3,6:8],[1:6]};

for dt = 5:size(DataTypeDef,2)
    disp(DataTypeDef{dt})
    for kk = 1%:length(kernels)
            disp(kernels{kk})

        for mm = 1:max(MouseId)
            for ii = 1:9
                
                theclass =Pos'<PosLimStep*ii; % 0 for safe, 1 for shock
                
                % Define train and test sets
                train_X = MergedData(DataTypeDef{dt},find(MouseId~=mm));
                test_X = MergedData(DataTypeDef{dt},find(MouseId==mm));
                train_Y = theclass(find(MouseId~=mm));
                test_Y = theclass(find(MouseId==mm));
                
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
                
                
                % test on left out mouse
                [y,scores2_train] = predict(cl,train_X');
                trainscore(ii,mm) = nanmean(y==train_Y);
                trainscore_sf(ii,mm) =  nanmean(y(train_Y==0)==0);
                trainscore_shk(ii,mm) =  nanmean(y(train_Y==1)==1);
                proj_train_sf{ii}{mm} = scores2_train(train_Y==0,1);
                proj_train_shk{ii}{mm} = scores2_train(train_Y==1,1);
                
                % test on left out mouse
                [y,scores2_test] = predict(cl,test_X');
                testscore(ii,mm) =  nanmean(y==test_Y);
                testscore_sf(ii,mm) =  nanmean(y(test_Y==0)==0);
                testscore_shk(ii,mm) =  nanmean(y(test_Y==1)==1);
                proj_test_sf{ii}{mm} = scores2_test(test_Y==0,1);
                proj_test_shk{ii}{mm} = scores2_test(test_Y==1,1);
                
            end
        end
        save(['/media/nas7/ProjetEmbReact/DataEmbReact/DecodingResults/SVM_2s',kernels{kk},'_',DataTypes{dt},'.mat'],...
            'testscore','testscore_shk','testscore_sf','proj_test_shk','proj_test_sf',...
            'trainscore','trainscore_sf','trainscore_shk','proj_train_shk','proj_train_sf','MouseId')
                clear testscore testscore_shk testscore_sf proj_test_shk proj_test_sf trainscore trainscore_shk trainscore_sf

    end
end

%% Mouse by mouse
% different types of kernels
kernels = {'linear','rbf','poly2','poly3','poly4'};
DataTypes = {'all','noHeart','noRip','noRespi','noGamma','noLowHpc'};
DataTypeDef = {1:8,[1,4:8],[1:5,7:8],[2:8],[1:3,6:8],[1:6]};

for dt = 1:size(DataTypeDef,2)
    for kk = 1:length(kernels)
        for mm = 1:max(MouseId)
            for ii = 1:9
                
                theclass_temp =Pos'<PosLimStep*ii;
                
                % Define train and test sets
                train_X_temp = MergedData(DataTypeDef{dt},find(MouseId~=mm));
                test_X_temp = MergedData(DataTypeDef{dt},find(MouseId==mm));
                train_Y_temp = theclass(find(MouseId~=mm));
                test_Y_temp = theclass(find(MouseId==mm));
                train_mouse = MouseId(find(MouseId~=mm))';
                
                % Average all data from each mouse
                train_X = [];test_X = [];test_Y = [];train_Y = [];
                for mm2 = 1:max(MouseId)
                    if mm2 == mm
                        test_X(:,1) = nanmean(test_X_temp(:,find(test_Y_temp==0)),2);
                        test_X(:,2) = nanmean(test_X_temp(:,find(test_Y_temp==1)),2);
                        test_Y = [0,1];
                    else
                        train_X = cat(2,train_X,nanmean(train_X_temp(:,find(train_mouse==mm2 & train_Y_temp==0)),2));
                        train_X = cat(2,train_X,nanmean(train_X_temp(:,find(train_mouse==mm2 & train_Y_temp==1)),2));
                        train_Y = cat(2,train_Y,[0,1]);
                    end
                end
                
                
                % train the decoder
                if contains(kernels{kk},'poly')
                    cl = fitcsvm(train_X',train_Y,'KernelFunction','polynomial',...
                        'ClassNames',[0,1],'PolynomialOrder',eval(kernels{kk}(end)));
                else
                    cl = fitcsvm(train_X',train_Y,'KernelFunction',kernels{kk},...
                        'ClassNames',[0,1]);
                end
                
                
                [y,scores2_train] = predict(cl,train_X');
                trainscore(ii,mm) = nanmean(y==train_Y');
                trainscore_sf(ii,mm) =  nanmean(y(train_Y==0)==0);
                trainscore_shk(ii,mm) =  nanmean(y(train_Y==1)==1);
                proj_train_sf{ii}{mm} = scores2_train(train_Y==0,1);
                proj_train_shk{ii}{mm} = scores2_train(train_Y==1,1);
                
                % test on left out mouse
                [y,scores2_test] = predict(cl,test_X');
                testscore(ii,mm) =  nanmean(y==test_Y');
                testscore_sf(ii,mm) =  nanmean(y(test_Y==0)==0);
                testscore_shk(ii,mm) =  nanmean(y(test_Y==1)==1);
                proj_test_sf{ii}{mm} = scores2_test(test_Y==0,1);
                proj_test_shk{ii}{mm} = scores2_test(test_Y==1,1);
                
                
            end
        end
        save(['/media/nas7/ProjetEmbReact/DataEmbReact/DecodingResults/SVM_MsByMs',kernels{kk},'_',DataTypes{dt},'.mat'],...
            'testscore','testscore_shk','testscore_sf','proj_test_shk','proj_test_sf','trainscore','trainscore_shk','trainscore_sf','MouseId')
        clear testscore testscore_shk testscore_sf proj_test_shk proj_test_sf trainscore trainscore_shk trainscore_sf
    end
end


%% Episodes
clear all
cd /media/nas7/ProjetEmbReact/DataEmbReact
load('Data_Physio_Freezing_Saline_CondPost_Episodes.mat')

AllMice = fieldnames(DATA.CondPost);

% % quick look qt vqriqbles
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

PosLimStep = 0.1;


MergedData = [];
MouseId = [];
Pos = [];
for mm = 1:length(AllMice)
    MergedData = cat(2,MergedData,DATA.CondPost.(AllMice{mm})(1:8,:));
    MouseId = cat(2,MouseId,ones(1,size(DATA.CondPost.(AllMice{mm}),2))*mm);
    Pos = cat(2,Pos,DATA.CondPost.(AllMice{mm})(9,:));
end

if size(MergedData,1)>1
    MergedData = nanzscore(MergedData')';
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

% different types of kernels
kernels = {'linear','rbf','poly2','poly3','poly4'};
DataTypes = {'all','noHeart','noRip','noRespi','noGamma','noLowHpc'};
DataTypeDef = {1:8,[1,4:8],[1:5,7:8],[2:8],[1:3,6:8],[1:6]};

for dt = 1:2%size(DataTypeDef,2)
    disp(DataTypeDef{dt})
    for kk = 1:length(kernels)
            disp(kernels{kk})

        for mm = 1:max(MouseId)
            for ii = 1:9
                
                theclass =Pos'<PosLimStep*ii; % 0 for safe, 1 for shock
                
                % Define train and test sets
                train_X = MergedData(DataTypeDef{dt},find(MouseId~=mm));
                test_X = MergedData(DataTypeDef{dt},find(MouseId==mm));
                train_Y = theclass(find(MouseId~=mm));
                test_Y = theclass(find(MouseId==mm));
                
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
                
                
                % test on left out mouse
                [y,scores2_train] = predict(cl,train_X');
                trainscore(ii,mm) = nanmean(y==train_Y);
                trainscore_sf(ii,mm) =  nanmean(y(train_Y==0)==0);
                trainscore_shk(ii,mm) =  nanmean(y(train_Y==1)==1);
                proj_train_sf{ii}{mm} = scores2_train(train_Y==0,1);
                proj_train_shk{ii}{mm} = scores2_train(train_Y==1,1);
                
                % test on left out mouse
                [y,scores2_test] = predict(cl,test_X');
                testscore(ii,mm) =  nanmean(y==test_Y);
                testscore_sf(ii,mm) =  nanmean(y(test_Y==0)==0);
                testscore_shk(ii,mm) =  nanmean(y(test_Y==1)==1);
                proj_test_sf{ii}{mm} = scores2_test(test_Y==0,1);
                proj_test_shk{ii}{mm} = scores2_test(test_Y==1,1);
                
            end
        end
        save(['/media/nas7/ProjetEmbReact/DataEmbReact/DecodingResults/SVM_Episodes',kernels{kk},'_',DataTypes{dt},'.mat'],...
            'testscore','testscore_shk','testscore_sf','proj_test_shk','proj_test_sf',...
            'trainscore','trainscore_sf','trainscore_shk','proj_train_shk','proj_train_sf','MouseId')
                clear testscore testscore_shk testscore_sf proj_test_shk proj_test_sf trainscore trainscore_shk trainscore_sf

    end
end


figure
subplot(1,4,1)
plot([0.1:0.1:0.9],testscore,'color',[0.6 0.6 0.6])
hold on
errorbar([0.1:0.1:0.9],nanmean(testscore'),stdError(testscore'),'color','k','linewidth',3)
    ylim([0 1])

subplot(1,4,2)
plot([0.1:0.1:0.9],testscore_shk,'color',[1 0.6 0.6])
hold on
errorbar([0.1:0.1:0.9],nanmean(testscore_shk'),stdError(testscore_shk'),'color','r','linewidth',3)
ylim([0 1])

subplot(1,4,3)
plot([0.1:0.1:0.9],testscore_sf,'color',[0.6 0.6 1])
hold on
errorbar([0.1:0.1:0.9],nanmean(testscore_sf'),stdError(testscore_sf'),'color','b','linewidth',3)
ylim([0 1])

for ii = 1:9
    Proj_shk_all{ii} = [];
    Proj_sf_all{ii} = [];
    for mm = 1:max(MouseId)
        Proj_shk_all{ii} = [Proj_shk_all{ii};proj_test_shk{ii}{mm}];
        Proj_sf_all{ii} = [Proj_sf_all{ii}; proj_test_sf{ii}{mm}];
    end
end

subplot(1,4,4)
nhist({Proj_shk_all{5},Proj_sf_all{5}})

    %
    %  SupportVector = cl.SupportVectors;
    %  figure
    % scatter3(data3(1:10:end,1),data3(1:10:end,2),data3(1:10:end,3),10,categorical(theclass(1:10:end)),'filled','MarkerEdgeColor','r' )
    % xlabel('variable 1');ylabel('variable 2');zlabel('variable 3');
    % hold on
    % numGrid = 20;
    % [x1Grid,x2Grid,x3Grid] = meshgrid(linspace(min(data3(:,1)),max(data3(:,1)),numGrid),...
    %     linspace(min(data3(:,2)),max(data3(:,2)),numGrid),linspace(min(data3(:,3)),max(data3(:,3)),numGrid));
    % xList = [x1Grid(:),x2Grid(:),x3Grid(:)];
    % [~,scores] = predict(cl,xList);
    % [faces,verts] = isosurface(x1Grid,x2Grid,x3Grid, reshape(scores(:,2),size(x1Grid)),0);
    % p=patch('Vertices', verts, 'Faces', faces, 'FaceColor','k','edgecolor', 'none', 'FaceAlpha', 0.5);
    % p.FaceColor = 'red';
    % grid on; box on
clear all
GroupNames = {'FlxChr','FlxChr_Ctrl'};
PosLimStep = 0.1;


% load saline data
cd /media/nas7/ProjetEmbReact/DataEmbReact
load('Data_Physio_Freezing_Saline_CondPost_2sBin.mat')
% load('Data_Physio_Freezing_FlxChr_Ctrl_ext_2sbins.mat')

% Use a proper control so there is no leakage between fluo chronic salines
% and all train set
% load('Data_Physio_Freezing_SalNoFlxChrCtrl_CondPost_2sbins.mat')

SessType = 'CondPost';
AllMice = fieldnames(DATA.(SessType));

% quick look qt vqriqbles
% for mm = 1:length(AllMice)
%     ha = tight_subplot(10,1);
%     for var = 1:9
%         axes(ha(var))
%         plot(DATA.(SessType).(AllMice{mm})(var,:))
%         title(Params{var})
%     end
%     pause
%     clf
% end


MergedData = [];
MouseId = [];
Pos = [];
for mm = 1:length(AllMice)
    MergedData = cat(2,MergedData,DATA.(SessType).(AllMice{mm})(1:8,:));
    MouseId = cat(2,MouseId,ones(1,size(DATA.(SessType).(AllMice{mm}),2))*mm);
    Pos = cat(2,Pos,DATA.(SessType).(AllMice{mm})(9,:));
end

MergedData_keep = MergedData;
Pos_keep = Pos;
MouseId_keep = MouseId;

for gg = 1:length(GroupNames)
    
    SessType = 'ext';
    load(['/media/nas7/ProjetEmbReact/DataEmbReact/Data_Physio_Freezing_',GroupNames{gg},'_',SessType,'_2sbins.mat'])
    AllMice_Drg = fieldnames(DATA.(SessType));
    MergedData_Drg = [];
    MouseId_Drg = [];
    Pos_Drg = [];
    for mm = 1:length(AllMice_Drg)
        MergedData_Drg = cat(2,MergedData_Drg,DATA.(SessType).(AllMice_Drg{mm})(1:8,:));
        MouseId_Drg = cat(2,MouseId_Drg,ones(1,size(DATA.(SessType).(AllMice_Drg{mm}),2))*mm);
        Pos_Drg = cat(2,Pos_Drg,DATA.(SessType).(AllMice_Drg{mm})(9,:));
    end
    
    MergedData_keep_Drg = MergedData_Drg;
    Pos_keep_Drg = Pos_Drg;
    MouseId_keep_Drg = MouseId_Drg;
    
    % Train the SVM on the saline, tewt on the drug groups
    % different types of kernels
    kernels = {'linear','rbf'};%,'poly2','poly3','poly4'};
    DataTypes = {'all','noHeart','noRip','noRespi','noGamma','noLowHpc','noHRVar','noHRNoRip','noRespiNoHR'};
    DataTypeDef = {1:8,[1,4:8],[1:5,7:8],[2:8],[1:3,6:8],[1:6],[1,2,4:8],[1,4,5,7:8],[4:8]};
    
    
    for dt = 1:size(DataTypeDef,2)
        for kk = 1%:length(kernels)
            
            
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
            
            
            % Define train and test sets
            
            
            
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
            
            for ii = 1:9
                theclass =Pos'<PosLimStep*ii;
                theclass_Drg =Pos_Drg'<PosLimStep*ii;
                train_X = MergedData;
                train_Y = theclass;
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
                MouseId_Drg(isnan(test_Y)) = [];
                test_Y(isnan(test_Y)) = [];
                
                testscore(ii) =  nanmean(y==test_Y);
                testscore_sf(ii) =  nanmean(y(test_Y==0)==0);
                testscore_shk(ii) =  nanmean(y(test_Y==1)==1);
                proj_test_sf{ii} = scores2_test(test_Y==0,1);
                proj_test_shk{ii} = scores2_test(test_Y==1,1);
                
                %%Accuracy by mouse
                MouseNames = unique(MouseId_Drg);
                for mm = 1:length(MouseNames)
                    Score_Sf{ii}(mm) = nanmean(y(test_Y==0 & MouseId_Drg' == MouseNames(mm))==0);
                    Score_Shk{ii}(mm) = nanmean(y(test_Y==1 & MouseId_Drg' == MouseNames(mm))==1);
                end
                
                
            end
            
            save(['/media/nas7/ProjetEmbReact/DataEmbReact/DecodingResults_Corr/SVM_2s',kernels{kk},'_',DataTypes{dt},'Group',GroupNames{gg},'.mat'],...
                'testscore','testscore_shk','testscore_sf','proj_test_shk','proj_test_sf',...
                'trainscore','trainscore_sf','trainscore_shk','proj_train_shk','proj_train_sf','MouseId_Drg','Score_Sf','Score_Shk')
            clear testscore testscore_shk testscore_sf proj_test_shk proj_test_sf trainscore trainscore_shk trainscore_sf Score_Sf Score_Shk
        end
    end
end


%% Look at decoding accuracy throughout
figure
clf
for dt = 1:size(DataTypeDef,2)
    load(['/media/nas7/ProjetEmbReact/DataEmbReact/DecodingResults_Corr/SVM_2s',kernels{kk},'_',DataTypes{dt},'Group',GroupNames{2},'.mat'])
    subplot(3,3,dt)
    plot([0.1:0.1:0.9],trainscore_sf,'color',[0.4 0.4 1],'linestyle',':','linewidth',2)
    hold on
    plot([0.1:0.1:0.9],trainscore_shk,'color',[1 0.4 0.4],'linestyle',':','linewidth',2)
    
    plot([0.1:0.1:0.9],testscore_sf,'b','linewidth',2)
    hold on
    plot([0.1:0.1:0.9],testscore_shk,'r','linewidth',2)
    load(['/media/nas7/ProjetEmbReact/DataEmbReact/DecodingResults_Corr/SVM_2s',kernels{kk},'_',DataTypes{dt},'Group',GroupNames{1},'.mat'])
    
    plot([0.1:0.1:0.9],testscore_sf,'color',[0.4 0.8 1],'linewidth',2)
    hold on
    plot([0.1:0.1:0.9],testscore_shk,'color',[1 0.4 0.8],'linewidth',2)
    makepretty
    xlabel('PosThresh')
    ylabel('Accuracy')
    ylim([0 1])
    title(DataTypes{dt})
    if dt ==1
        legend('Sf-train','Sk-train','Sf-saline','Sk-saline','Sf-FlxChr','Sk-FlxChr')
    end
    
end

%% Get accuracy mouse by mouse
figure
clf
lim = 4:7;
clear Score_Sf_ChrFl Score_Shk_ChrFl Score_Sf_Ctrl Score_Shk_Ctrl p
for dt = 1:size(DataTypeDef,2)
    clear vals_Shk vals_Sf
    % Control animals
    load(['/media/nas7/ProjetEmbReact/DataEmbReact/DecodingResults_Corr/SVM_2s',kernels{kk},'_',DataTypes{dt},'Group',GroupNames{2},'.mat'])
    for ll = 1:length(lim)
        vals_Shk(ll,:) = Score_Shk{lim(ll)};
        vals_Sf(ll,:) = Score_Sf{lim(ll)};
    end
    A{1} = nanmean(vals_Shk);
    A{3} = nanmean(vals_Sf);
    
    % Flx Chr animals
    load(['/media/nas7/ProjetEmbReact/DataEmbReact/DecodingResults_Corr/SVM_2s',kernels{kk},'_',DataTypes{dt},'Group',GroupNames{1},'.mat'])
    clear vals_Shk vals_Sf
    for ll = 1:length(lim)
        vals_Shk(ll,:) = Score_Shk{lim(ll)};
        vals_Sf(ll,:) = Score_Sf{lim(ll)};
    end
    A{2} = nanmean(vals_Shk);
    A{4} = nanmean(vals_Sf);
    
    subplot(3,3,dt)
    MakeSpreadAndBoxPlot_SB(A,{[1,0,0],[1 0.4 0.8],[0,0,1],[0.4 0.8 1]},[1:4],{'Shk-saline','Shk-FlxChr','Sf-saline','Sf-FlxChr'},1,0)
    title(DataTypes{dt})
    ylabel('Accuracy')
    xtickangle(45)
    [p(1),h] = ranksum(A{1},A{2});
    [p(2),h] = ranksum(A{3},A{4});
    sigstar({[1,2],[3,4]},p)
    ylim([0 1.2])
    
end


figure
clf
lim = 6;
for dt = 1:size(DataTypeDef,2)
    % Control
    load(['/media/nas7/ProjetEmbReact/DataEmbReact/DecodingResults_Corr/SVM_2s',kernels{kk},'_',DataTypes{dt},'Group',GroupNames{2},'.mat'])
    subplot(3,3,dt)
    A{1} = proj_test_shk{6};
    A{3} = proj_test_sf{6};
    
    % Flx chr
    load(['/media/nas7/ProjetEmbReact/DataEmbReact/DecodingResults_Corr/SVM_2s',kernels{kk},'_',DataTypes{dt},'Group',GroupNames{1},'.mat'])
    A{2} = proj_test_shk{6};
    A{4} = proj_test_sf{6};
    colormap([[1,0,0];[1 0.4 0.8];[0,0,1];[0.4 0.8 1]])
    nhist(A,'color','colormap')
    title(DataTypes{dt})
    xl = xlim;
    xlim([-max(abs(xl)) max(abs(xl))])
    makepretty
    xlabel('Shk vs Safe projection')
    line([0 0],ylim,'color','k','linewidth',3)
    if dt ==1
        legend('Shk-saline','Shk-FlxChr','Sf-saline','Sf-FlxChr')
    end
end




%% Quick look at all the data
close all
clear all
SessType = 'ext';
cd /media/nas7/ProjetEmbReact/DataEmbReact
% load('Data_Physio_Freezing_FlxChr_CondPost_2sbins.mat')
load('Data_Physio_Freezing_FlxChr_ext_2sbins.mat')
figure
AllMice = fieldnames(DATA.(SessType));
for ii = 1:length(Params)
    subplot(3,3,ii)
    AllSk =  [];
    AllSf = [];
    for mm= 1 :length(AllMice)
        AllSk =  [AllSk,DATA.(SessType).(AllMice{mm})(ii,DATA.(SessType).(AllMice{mm})(9,:)<0.5)];
        AllSf =  [AllSf,DATA.(SessType).(AllMice{mm})(ii,DATA.(SessType).(AllMice{mm})(9,:)>0.5)];
    end
    nhist({AllSf,AllSk})
    title(Params{ii})
    xl{ii} = xlim;
end

% load('Data_Physio_Freezing_FlxChr_Ctrl_CondPost_2sbins.mat')
load('Data_Physio_Freezing_FlxChr_Ctrl_ext_2sbins.mat')

figure
AllMice = fieldnames(DATA.(SessType));
for ii = 1:length(Params)
    subplot(3,3,ii)
    AllSk =  [];
    AllSf = [];
    for mm= 1 :length(AllMice)
        AllSk =  [AllSk,DATA.(SessType).(AllMice{mm})(ii,DATA.(SessType).(AllMice{mm})(9,:)<0.5)];
        AllSf =  [AllSf,DATA.(SessType).(AllMice{mm})(ii,DATA.(SessType).(AllMice{mm})(9,:)>0.5)];
    end
    nhist({AllSf,AllSk})
    title(Params{ii})
    xlim(xl{ii})
end

i=0,
i=i+1;figure(rem(i,2)+1)
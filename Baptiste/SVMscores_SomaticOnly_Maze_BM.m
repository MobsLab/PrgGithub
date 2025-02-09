
clear all

ParToKeep = {[1:5]};
ParNames = {'NoHpc'};
kernels = {'linear','rbf'};
DoZscore = 0;
codename = mfilename;
SessionTypes = {'Cond'};

%% load data
SessType = SessionTypes{1};
load('/media/nas7/ProjetEmbReact/DataEmbReact/Data_Physio_Freezing_Saline_Eyelid_Cond_2sFullBins.mat')

AllMice = fieldnames(DATA.(SessType));
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

figure
MakeSpreadAndBoxPlot3_SB({SVMScores_Sk_Ctrl{1} SVMScores_Sf_Ctrl{1}},{[1 .5 .5],[.5 .5 1]},[1 3],{'shock','safe'},'showpoints',0,'paired',1);
ylabel('SVM score (a.u.)')
makepretty_BM2
hline(0,'--r')

figure
PlotErrorBarN_KJ({1-SVMChoice_Sk_Ctrl{svm_type}(parToUse,:),SVMChoice_Sf_Ctrl{svm_type}(parToUse,:)},...
    'barcolors',{[1 0.5 0.5],[0.5 0.5 1]},'x_data',[1,2],'showPoints',0,'ShowSigstar','sig');
ylabel('Cross validated SVM accuracy')
set(gca,'XTick',1:2,'XtickLabel',{'Shock','Safe'})
line(xlim,[0.5 0.5],'color','k','linestyle',':','linewidth',5)
makepretty
ylim([0 1])


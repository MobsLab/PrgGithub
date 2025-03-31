clear all

ParToKeep = {[1,3:6],[3:6],[1,4,5,6],[1,3,5,6],[1,3]};
ParNames = {'All','NoResp','NoOB','NoRip','NoHpc'};
kernels = {'linear','rbf'};
DoZscore = 0;
codename = mfilename;
SaveLoc = '/media/nas7/ProjetEmbReact/DataEmbReact/PaperData/';
SessionTypes = {'CondPost'};

%% load data

for sess = 1:length(SessionTypes)
    % cd /media/nas7/ProjetEmbReact/DataEmbReact
    
    cd /home/mobsrick/Documents/Data_PaperSBBM
    SessType = SessionTypes{sess};
    
    load(['Data_Physio_Freezing_Saline_all_',SessType,'_2sFullBins.mat'])
    
    AllMice = fieldnames(DATA.(SessType));
    clear DATA_Ctrl
    for n= 1:8
        DATA_Ctrl(n,:) = [OutPutData.(SessType).(Params{n}).mean(:,5)' OutPutData.(SessType).(Params{n}).mean(:,6)'];
    end
    
    % None of the conditinned mice have a heart
    DATA_Ctrl(2:3,:) = [];
    
    load('FearCondSound.mat')
    DATA2(2:3,:) = [];
    DATATone = DATA2;
    clear DATA2
    
    for parToUse = 1:length(ParNames)
        for svm_type = 1:length(kernels)
            
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
            
            % same for cond
            DATA2Tone = DATATone(ParToKeep{parToUse},:);
            totnummice_tone = size(DATA2Tone,2);
            BadGuys_tone = sum(isnan(DATA2Tone))>0;
            GoodGuys_tone = find(BadGuys_tone==0);
            DATA2Tone(:,BadGuys_tone)=[];
            totnummice_tone = size(DATA2Tone,2);
            
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
                [prediction,scores2_test] = predict(classifier_controltrain,DATA_test');

                
                SVMScores_Sk_Ctrl{svm_type}(parToUse,GoodGuys(perm)) = scores2_test(1,1);
                SVMScores_Sf_Ctrl{svm_type}(parToUse,GoodGuys(perm)) = scores2_test(2,1);
                SVMChoice_Sk_Ctrl{svm_type}(parToUse,GoodGuys(perm)) = prediction(1,1);
                SVMChoice_Sf_Ctrl{svm_type}(parToUse,GoodGuys(perm)) = prediction(2,1);
              
                
                [prediction,scores] = predict(classifier_controltrain,DATA2Tone');

                SVMScores_Tn_Ctrl{svm_type}(parToUse,GoodGuys_tone,perm) = scores(:,1);
                SVMChoice_Tn_Ctrl{svm_type}(parToUse,GoodGuys_tone,perm) = prediction;
                SVMScores_Tn_Ctrl{svm_type}(parToUse,BadGuys_tone,perm) = NaN;
                SVMChoice_Tn_Ctrl{svm_type}(parToUse,BadGuys_tone,perm) = NaN;

                
            end
        end
        
    end
    
    codename = mfilename;
    save([SaveLoc,'SVM_Sal_MouseByMouse_',SessType,'Witone.mat'],'SVMScores_Sk_Ctrl','SVMScores_Sf_Ctrl','SVMChoice_Sk_Ctrl','SVMChoice_Sf_Ctrl',...
        'ParNames','ParToKeep','codename')
    clear('SVMScores_Sk_Ctrl','SVMScores_Sf_Ctrl','SVMChoice_Sk_Ctrl','SVMChoice_Sf_Ctrl')
end

%% Figures

load([SaveLoc,'SVM_Sal_MouseByMouse_',SessType,'Witone.mat'])
ParNames = {'All','NoResp','NoOB','NoRip','NoHpc'};

% Get rid of mice that were missint variables
for svm_type = 1
    figure
    SVMChoice_Sf_Ctrl{svm_type}(SVMScores_Sf_Ctrl{svm_type}==0) = NaN;
    SVMScores_Sf_Ctrl{svm_type}(SVMScores_Sf_Ctrl{svm_type}==0) = NaN;
    SVMChoice_Sk_Ctrl{svm_type}(SVMScores_Sk_Ctrl{svm_type}==0) = NaN;
    SVMScores_Sk_Ctrl{svm_type}(SVMScores_Sk_Ctrl{svm_type}==0) = NaN;
    SVMChoice_Tn_Ctrl{svm_type}(SVMScores_Tn_Ctrl{svm_type}==0) = NaN;
    SVMScores_Tn_Ctrl{svm_type}(SVMScores_Tn_Ctrl{svm_type}==0) = NaN;

    
    clear ShockVals SafeVals
    Cols_Sk = {};
    Cols_Sf = {};
    for parToUse = 1:length(ParNames)
        ShockVals{parToUse} = SVMScores_Sk_Ctrl{svm_type}(parToUse,:);
        SafeVals{parToUse} = SVMScores_Sf_Ctrl{svm_type}(parToUse,:);
        ToneVals{parToUse} = squeeze(nanmean(SVMScores_Tn_Ctrl{svm_type}(parToUse,:,:),3));
        
        ShockVals_Acc{parToUse} = 1-SVMChoice_Sk_Ctrl{svm_type}(parToUse,:);
        SafeVals_Acc{parToUse} = SVMChoice_Sf_Ctrl{svm_type}(parToUse,:);
        ToneVals_Acc{parToUse} = 1-squeeze(nanmean(SVMChoice_Tn_Ctrl{svm_type}(parToUse,:,:),3)<0.5);
        ToneVals_Acc{parToUse}(isnan(nanmean(SVMChoice_Tn_Ctrl{svm_type}(parToUse,:,:),3))) = NaN;
        Acc{parToUse} = ( ShockVals_Acc{parToUse} + SafeVals_Acc{parToUse} )/2;
        Cols_Sk{parToUse} = [1 0.5 0.5];
        Cols_Sf{parToUse} = [0.5 0.5 1];
                Cols_Tn{parToUse} = [0.5 1 0.5];

    end
    subplot(211)
    MakeSpreadAndBoxPlot2_SB(ShockVals,Cols_Sk,[1:3:17],ParNames,'paired',0,'showsigstar','none');
    hold on
       MakeSpreadAndBoxPlot2_SB(ToneVals,Cols_Tn,[3:3:17],ParNames,'paired',0,'showsigstar','none');
    MakeSpreadAndBoxPlot2_SB(SafeVals,Cols_Sf,[2:3:17],ParNames,'paired',0,'showsigstar','none');
 ylim([-max(abs(ylim)) max(abs(ylim))])
    xlim([0 19])
    line(xlim,[0 0])
    ylabel('SVM score')
    subplot(212)
    PlotErrorBarN_KJ(Acc,'newfig',0,'showpoints',0)
    set(gca,'XTick',1:7,'XtickLabel',ParNames)
    ylim([0 1.1])
    xtickangle(45)
    ylabel('Accuracy')
    
    
end


%% Figure for paper
svm_type = 1; % linear
parToUse = 3; % all variables

figure
SVMChoice_Sf_Ctrl{svm_type}(SVMScores_Sf_Ctrl{svm_type}==0) = NaN;
SVMScores_Sf_Ctrl{svm_type}(SVMScores_Sf_Ctrl{svm_type}==0) = NaN;
SVMChoice_Sk_Ctrl{svm_type}(SVMScores_Sk_Ctrl{svm_type}==0) = NaN;
SVMScores_Sk_Ctrl{svm_type}(SVMScores_Sk_Ctrl{svm_type}==0) = NaN;

MakeSpreadAndBoxPlot_SB({SVMScores_Sk_Ctrl{svm_type}(parToUse,:),SVMScores_Sf_Ctrl{svm_type}(parToUse,:),squeeze(nanmean(SVMScores_Tn_Ctrl{svm_type}(parToUse,:,:),3))},...
    {[1 0.5 0.5],[0.5 0.5 1],[0.5 1 0.5]},[1,2,3],{'Shock','Safe','Tone'},1,0);
ylabel('Cross validated SVM score')

[p,h,stats] = signrank(SVMScores_Sk_Ctrl{svm_type}(parToUse,:),SVMScores_Sf_Ctrl{svm_type}(parToUse,:))
[p,h,stats] = ranksum(squeeze(nanmean(SVMScores_Tn_Ctrl{svm_type}(parToUse,:,:),3)),SVMScores_Sf_Ctrl{svm_type}(parToUse,:))
[p,h,stats] = ranksum(SVMScores_Sk_Ctrl{svm_type}(parToUse,:),squeeze(nanmean(SVMScores_Tn_Ctrl{svm_type}(parToUse,:,:),3)))
line(xlim,[0 0])

figure
A = squeeze(nanmean(SVMChoice_Tn_Ctrl{svm_type}(parToUse,:,:),3)<0.5);
A = double(A);
A(isnan(nanmean(SVMChoice_Tn_Ctrl{svm_type}(parToUse,:,:),3))) = NaN;

PlotErrorBarN_KJ({1-SVMChoice_Sk_Ctrl{svm_type}(parToUse,:),SVMChoice_Sf_Ctrl{svm_type}(parToUse,:),A},...
    'barcolors',{[1 0.5 0.5],[0.5 0.5 1],[0.5 1 0.5]},'x_data',[1,2,3],'showPoints',0,'ShowSigstar','sig','newfig',0);
ylabel('Cross validated SVM accuracy')
set(gca,'XTick',1:2,'XtickLabel',{'Shock','Safe'})
line(xlim,[0.5 0.5],'color','k','linestyle',':','linewidth',5)
makepretty
ylim([0 1])



%% Figure for paper - average over all combinations of parameters
figure
MakeSpreadAndBoxPlot_SB({nanmean(SVMScores_Sk_Ctrl{svm_type}),nanmean(SVMScores_Sf_Ctrl{svm_type}),nanmean(squeeze(nanmean(SVMScores_Tn_Ctrl{svm_type}(:,:,:),3)))},...
    {[1 0.5 0.5],[0.5 0.5 1],[0.5 1 0.5]},[1,2,3],{'Shock','Safe','Tone'},1,0);
[p,h,stats] = signrank(nanmean(SVMScores_Sk_Ctrl{svm_type}),nanmean(SVMScores_Sf_Ctrl{svm_type}))
[p,h,stats] = ranksum(nanmean(SVMScores_Sk_Ctrl{svm_type}),nanmean(squeeze(nanmean(SVMScores_Tn_Ctrl{svm_type}(:,:,:),3))))
[p,h,stats] = ranksum(nanmean(squeeze(nanmean(SVMScores_Tn_Ctrl{svm_type}(:,:,:),3))),nanmean(SVMScores_Sf_Ctrl{svm_type}))
line(xlim,[0 0])
ylabel('Cross validated SVM score')

figure
A = squeeze(nanmean(SVMChoice_Tn_Ctrl{svm_type}(:,:,:),3)<0.5);
A = double(A);
A(isnan(nanmean(SVMChoice_Tn_Ctrl{svm_type}(:,:,:),3))) = NaN;

PlotErrorBarN_KJ({nanmean(1-SVMChoice_Sk_Ctrl{svm_type}),nanmean(SVMChoice_Sf_Ctrl{svm_type}),nanmean(1-squeeze(nanmean(SVMChoice_Tn_Ctrl{svm_type}(:,:,:),3)<0.5))},...
    'barcolors',{[1 0.5 0.5],[0.5 0.5 1],[0.5 1 0.5]},'x_data',[1,2,3],'showPoints',0,'ShowSigstar','sig','newfig',0);
ylabel('Cross validated SVM accuracy')
set(gca,'XTick',1:3,'XtickLabel',{'Shock','Safe','Tone'})
line(xlim,[0.5 0.5],'color','k','linestyle',':','linewidth',5)
makepretty
ylim([0 1])




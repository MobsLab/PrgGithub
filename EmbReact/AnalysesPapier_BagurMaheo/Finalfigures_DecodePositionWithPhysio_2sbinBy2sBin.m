clear all

ParToKeep = {[1:8],[2:8],[1,4:8],[1,2,3,6:8],[1:5,7,8],[1:6],[1,4,5,7:8]};
ParNames = {'All','NoResp','NoHeart','NoOB','NoRip','NoHpc','NoRipNoHeart'};
kernels = {'linear','rbf'};
PosLimStep = 0.5;
PosLims = [0.3 0.7];
DoZscore = 0;
SaveLoc = '/media/nas7/ProjetEmbReact/DataEmbReact/PaperData/';

%% load data
% cd /media/nas7/ProjetEmbReact/DataEmbReact
SessionTypes = {'CondPost'};

for sess = 1:length(SessionTypes)
    
    cd /home/mobsrick/Documents/Data_PaperSBBM
    SessType = SessionTypes{sess};
    load(['Data_Physio_Freezing_Saline_all_',SessType,'_2sFullBins.mat'])
    
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
    
    for parToUse = 1:length(ParNames)
        for svm_type    = 1:length(kernels)
            
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
                train_Y = train_Y'>PosLimStep; % 0 for safe, 1 for shock
                test_Y = test_Y'>PosLimStep; % 0 for safe, 1 for shock
                
                
                % Keep only mice with full set of value
                train_Y(sum(isnan(train_X))>0) = [];
                test_Y(sum(isnan(test_X))>0) = [];
                
                train_X(:,sum(isnan(train_X))>0) = [];
                test_X(:,sum(isnan(test_X))>0) = [];
                size(test_X)
                
                
                if ~isempty(test_X)
                    
                    % balance the data
                    numclass = min([sum(train_Y==0),sum(train_Y==1)]);
                    SkId = find(train_Y==1);
                    SkId = SkId(randperm(length(SkId),numclass));
                    SfId = find(train_Y==0);
                    SfId = SfId(randperm(length(SfId),numclass));
                    train_Y = train_Y([SkId;SfId]);
                    train_X = train_X(:,[SkId;SfId]);
                    
                    
                    classifier_controltrain = fitcsvm(train_X',train_Y,...
                        'ClassNames',[0,1],'KernelFunction',kernels{svm_type});
                    [prediction,scores2_test] = predict(classifier_controltrain,test_X');
                    
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
                
                
                
            end
        end
    end
    codename = mfilename;
    save([SaveLoc,'SVM_Sal_2sBin_',SessType,'.mat'],'SVMScores_Sk_Ctrl','SVMScores_Sf_Ctrl','SVMChoice_Sk_Ctrl','SVMChoice_Sf_Ctrl',...
        'SVMScores_Sk_Ctrl_Mn','SVMScores_Sf_Ctrl_Mn','SVMChoice_Sk_Ctrl_Mn','SVMChoice_Sf_Ctrl_Mn',...
        'ParNames','ParToKeep','codename','LinPos_Sf_Ctrl','LinPos_Sk_Ctrl')
    clear('SVMScores_Sk_Ctrl','SVMScores_Sf_Ctrl','SVMChoice_Sk_Ctrl','SVMChoice_Sf_Ctrl',...
        'SVMScores_Sk_Ctrl_Mn','SVMScores_Sf_Ctrl_Mn','SVMChoice_Sk_Ctrl_Mn','SVMChoice_Sf_Ctrl_Mn','LinPos_Sf_Ctrl','LinPos_Sk_Ctrl')
    
end


%% Figures
cd(SaveLoc)
load('SVM_Sal_2sBin_CondPost.mat')

% Get rid of mice that were missint variables
for svm_type = 1:length(kernels)
    figure
    SVMChoice_Sf_Ctrl_Mn{svm_type}(SVMChoice_Sf_Ctrl_Mn{svm_type}==0) = NaN;
    SVMScores_Sf_Ctrl_Mn{svm_type}(SVMScores_Sf_Ctrl_Mn{svm_type}==0) = NaN;
    SVMChoice_Sk_Ctrl_Mn{svm_type}(SVMChoice_Sk_Ctrl_Mn{svm_type}==0) = NaN;
    SVMScores_Sk_Ctrl_Mn{svm_type}(SVMScores_Sk_Ctrl_Mn{svm_type}==0) = NaN;
    
    clear ShockVals SafeVals
    Cols_Sk = {};
    Cols_Sf = {};
    for parToUse = 1:length(ParNames)
        ShockVals{parToUse} = SVMScores_Sk_Ctrl_Mn{svm_type}(parToUse,:);
        SafeVals{parToUse} = SVMScores_Sf_Ctrl_Mn{svm_type}(parToUse,:);
        ShockVals_Acc{parToUse} = 1-SVMChoice_Sk_Ctrl_Mn{svm_type}(parToUse,:);
        SafeVals_Acc{parToUse} = SVMChoice_Sf_Ctrl_Mn{svm_type}(parToUse,:);
        Acc{parToUse} = ( ShockVals_Acc{parToUse} + SafeVals_Acc{parToUse} )/2;
        Cols_Sk{parToUse} = [1 0.5 0.5];
        Cols_Sf{parToUse} = [0.5 0.5 1];
    end
    subplot(211)
    MakeSpreadAndBoxPlot2_SB(ShockVals,Cols_Sk,[1:3:22],ParNames,'paired',0,'showsigstar','none');
    hold on
    MakeSpreadAndBoxPlot2_SB(SafeVals,Cols_Sf,[2:3:22],ParNames,'paired',0,'showsigstar','none');
    ylim([-max(abs(ylim)) max(abs(ylim))])
    xlim([0 23])
    line(xlim,[0 0])
    ylabel('SVM score')
    subplot(212)
    PlotErrorBarN_KJ(Acc,'newfig',0,'showpoints',0)
    set(gca,'XTick',1:7,'XtickLabel',ParNames)
    ylim([0 1.1])
    xtickangle(45)
    ylabel('Accuracy')
    
    
end



%% As a function of position
svm_type = 1;
Positions = [0:0.1:1];
clear AvScore_Pos
for parToUse = 1:length(ParNames)
    for mm = 1:length(SVMScores_Sk_Ctrl{svm_type}{parToUse})
        
        AllScores = [SVMScores_Sk_Ctrl{svm_type}{parToUse}{mm};SVMScores_Sf_Ctrl{svm_type}{parToUse}{mm}];
        AllPos = [LinPos_Sk_Ctrl{svm_type}{parToUse}{mm},LinPos_Sf_Ctrl{svm_type}{parToUse}{mm}]';
        
        for l = 1:length(Positions)-1
            AvScore_Pos{parToUse}(mm,l) = nanmean(AllScores(AllPos>Positions(l) & AllPos<Positions(l+1)));
            
        end
    end
end

figure
bar(Positions(1:end-1)+0.05,runmean(nanmean(AvScore_Pos{1}),2),'FaceColor',[0.6 0.6 0.6],'EdgeColor',[0.6 0.6 0.6])
hold on
errorbar(Positions(1:end-1)+0.05,runmean(nanmean(AvScore_Pos{1}),2),stdError(AvScore_Pos{1}),'.k')
ylim([-max(abs(ylim)) max(abs(ylim))])
makepretty
xlabel('Linear distance')
ylabel('SVM score')
xlabel('Linear position in maze')

%% Simplified figure- paper

svm_type = 1; % linear
parToUse = 1; % all variables

figure
SVMChoice_Sf_Ctrl_Mn{svm_type}(SVMScores_Sf_Ctrl_Mn{svm_type}==0) = NaN;
SVMScores_Sf_Ctrl_Mn{svm_type}(SVMScores_Sf_Ctrl_Mn{svm_type}==0) = NaN;
SVMChoice_Sk_Ctrl_Mn{svm_type}(SVMScores_Sk_Ctrl_Mn{svm_type}==0) = NaN;
SVMScores_Sk_Ctrl_Mn{svm_type}(SVMScores_Sk_Ctrl_Mn{svm_type}==0) = NaN;

GoodGuys = not(isnan(SVMScores_Sk_Ctrl_Mn{svm_type}(parToUse,:)) | isnan(SVMScores_Sf_Ctrl_Mn{svm_type}(parToUse,:)));
A = {SVMScores_Sk_Ctrl_Mn{svm_type}(parToUse,GoodGuys),SVMScores_Sf_Ctrl_Mn{svm_type}(parToUse,GoodGuys)};
MakeSpreadAndBoxPlot_BM(A,...
    {[1 0.5 0.5],[0.5 0.5 1]},[1,2],{'Shock','Safe'},1,1);
ylabel('Cross validated SVM score')

[p,h,stats] = signrank(SVMScores_Sk_Ctrl_Mn{svm_type}(parToUse,:),SVMScores_Sf_Ctrl_Mn{svm_type}(parToUse,:))

figure
PlotErrorBarN_KJ({1-SVMChoice_Sk_Ctrl_Mn{svm_type}(parToUse,:),SVMChoice_Sf_Ctrl_Mn{svm_type}(parToUse,:)},...
    'barcolors',{[1 0.5 0.5],[0.5 0.5 1]},'x_data',[1,2],'showPoints',0,'ShowSigstar','sig');
ylabel('Cross validated SVM accuracy')
set(gca,'XTick',1:2,'XtickLabel',{'Shock','Safe'})
line(xlim,[0.5 0.5],'color','k','linestyle',':','linewidth',5)
makepretty
ylim([0 1])





l_maze=load('/media/nas7/ProjetEmbReact/DataEmbReact/Data_Physio_Freezing_Saline_Eyelid_Ext_2sFullBins.mat');
l_sound=load('/media/nas7/ProjetEmbReact/DataEmbReact/Data_SoundTest.mat');
l_ctxt=load('/media/nas7/ProjetEmbReact/DataEmbReact/Data_FearCtxt.mat');


%%
ParToKeep = {[1 4:5]};
ParNames = {'NoHpc'};
kernels = {'linear'};
DoZscore = 0;
codename = mfilename;
SessionTypes = {'Ext'};
sess=1;
SessType = SessionTypes{sess};
Params = fieldnames(l_maze.OutPutData.(SessType));
parToUse = 1;
svm_type = 1;


%%
n=1;
for i=ParToKeep{1}
    DATA_Maze(n,:) = [l_maze.OutPutData.(SessType).(Params{i}).mean(:,5)' l_maze.OutPutData.(SessType).(Params{i}).mean(:,6)'];
    DATA_Sound(n,:) = l_sound.OutPutData.sound_test.(Params{i}).mean(:,2)' ;
    DATA_Ctxt(n,:) = l_ctxt.OutPutData.fear_ctxt.(Params{i}).mean(:,2)';
    n=n+1;
end
DATA_Ctxt(1,5) = 3.8725;
        
%% Contols train and test
% Only keep subset of parameters
DATA2 = DATA_Maze;

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
DATA_train = DATA2;
DATA_test1 = DATA_Sound;
DATA_test2 = DATA_Ctxt;

classifier_controltrain = fitcsvm(DATA_train',[zeros(1,size(DATA_train,2)/2),ones(1,size(DATA_train,2)/2)],...
    'ClassNames',[0,1],'KernelFunction',kernels{svm_type});
[prediction1,scores2_train1] = predict(classifier_controltrain,DATA_test1');
[prediction2,scores2_train2] = predict(classifier_controltrain,DATA_test2');

SVMScores_Sound = scores2_train1(:,1);
SVMScores_Ctxt = scores2_train2(:,1);
SVMChoice_Sound = prediction1(:,1);
SVMChoice_Ctxt = prediction2(:,1);



figure
subplot(221)
MakeSpreadAndBoxPlot4_SB(SVMScores_Sound,{[.3 .5 .7]},[1],{'Sound'},'showpoints',1,'paired',0);
ylabel('SVM score (a.u.)'), ylim([-4 4])
makepretty_BM2
hline(0,'--r')

subplot(222)
b=bar(nanmean(1-SVMChoice_Sound)); b.FaceColor=[.3 .5 .7];
hold on
eb = errorbar(1,nanmean(1-SVMChoice_Sound),std(1-SVMChoice_Sound)./sqrt(length(SVMChoice_Sound)),'+','Color','k');
line(xlim,[0.5 0.5],'color','k','linestyle',':','linewidth',5)
ylim([0 1]), ylabel('accuracy'), xticklabels({'Sound'})
makepretty


subplot(223)
MakeSpreadAndBoxPlot4_SB(SVMScores_Ctxt,{[.7 .5 .3]},[1],{'Context'},'showpoints',1,'paired',0);
ylabel('SVM score (a.u.)'), ylim([-1.5 1.5])
makepretty_BM2
hline(0,'--r')

subplot(224)
b=bar(nanmean(1-SVMChoice_Ctxt)); b.FaceColor=[.7 .5 .3];
hold on
eb = errorbar(1,nanmean(1-SVMChoice_Ctxt),std(1-SVMChoice_Ctxt)./sqrt(length(SVMChoice_Ctxt)),'+','Color','k');
line(xlim,[0.5 0.5],'color','k','linestyle',':','linewidth',5)
ylim([0 1]), ylabel('accuracy'), xticklabels({'Context'})
makepretty







clear all

ParToKeep = {[1:8],[2:8],[1,4:8],[1,2,3,6:8],[1:5,7,8],[1:6],[1,4,5,7:8]};
ParNames = {'All','NoResp','NoHeart','NoOB','NoRip','NoHpc','NoRipNoHeart'};
kernels = {'linear','rbf'};
DoZscore = 0;
sess=1;

%% load data
SessType = 'Ext';
L = load(['/media/nas7/ProjetEmbReact/DataEmbReact/Data_Physio_Freezing_Saline_all_',SessType,'_2sFullBins.mat']);
Params = L.Params;

AllMice = fieldnames(L.DATA.(SessType));
clear DATA_Ctrl
ind = [1 4:8];
for n= 1:8
    DATA_Ctrl(n,:) = [L.OutPutData.(SessType).(Params{n}).mean(:,5)' L.OutPutData.(SessType).(Params{n}).mean(:,6)'];
end

for parToUse = 1:length(ParNames)
    for svm_type = 1%:length(kernels)
        
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
        
        DATA_train = DATA2;
        classifier_controltrain{parToUse} = fitcsvm(DATA_train',[zeros(1,size(DATA_train,2)/2),ones(1,size(DATA_train,2)/2)],...
            'ClassNames',[0,1],'KernelFunction',kernels{svm_type});
        
        clear DATA_TEST, i=1; sess = 1;
        M=load('/media/nas7/ProjetEmbReact/DataEmbReact/PaperData/FearCondSound.mat');
        SessionTypes = {'sound_test'};
        SessType = SessionTypes{sess};
        
        for n= ParToKeep{parToUse}
            DATA_TEST(i,:) = [M.OutPutData.(SessType).(Params{n}).mean(:,2)];
            i=i+1;
        end
        
        [~,scores2_train{parToUse}] = predict(classifier_controltrain{parToUse},DATA_TEST');
        
        clear DATA_TEST2, i=1; sess= 1;
        P=load('/media/nas7/ProjetEmbReact/DataEmbReact/PaperData/FearCtxt.mat');
        SessionTypes = {'fear_ctxt'};
        SessType = SessionTypes{sess};
        
        for n= ParToKeep{parToUse}
            DATA_TEST2(i,:) = [P.OutPutData.(SessType).(Params{n}).mean(:,2)];
            i=i+1;
        end
        figure, [~,~,Freq_Max1] = Plot_MeanSpectrumForMice_BM(squeeze(P.OutPutData.fear_ctxt.ob_low.mean(:,2,:)), 'threshold' , 26); close
        DATA_TEST2(1,:) = Freq_Max1;
        DATA_TEST2(2,5) = nanmedian(DATA_TEST2(2,1:4));
        
        [~,scores2_train2{parToUse}] = predict(classifier_controltrain{parToUse},DATA_TEST2');
    end
end


figure
subplot(121)
hist(scores2_train{3}(:,1))
subplot(122)
hist(scores2_train2{3}(:,1))


subplot(122)
hist(scores2_train{7}(:,1))





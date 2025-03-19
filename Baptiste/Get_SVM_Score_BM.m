


function [OutPut , Acc] = Get_SVM_Score_BM(Input)

load('/media/nas7/ProjetEmbReact/DataEmbReact/PaperData/SVM_Sal_MouseByMouse_CondPost.mat', 'classifier_controltrain_ByPar')

classif = classifier_controltrain_ByPar;
ParToKeep = {[1:8],[2:8],[1,4:8],[1,2,3,6:8],[1:5,7,8],[1:6],[1,4,5,7:8]};
ParNames = {'All','NoResp','NoHeart','NoOB','NoRip','NoHpc','NoRipNoHeart'};

if size(Input,2)~=8
    Input=Input';
end
for par=1:length(ParToKeep)
    try, [Acc(par,:),b{par}] = predict(classif{par},Input(:,ParToKeep{par})); end
    OutPut(par,:) = b(1);
end








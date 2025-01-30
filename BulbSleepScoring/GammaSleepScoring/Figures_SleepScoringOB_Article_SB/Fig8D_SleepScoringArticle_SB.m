clear all, close all
AllSlScoringMice_SleepScoringArticle_SB


for mm=1:m
    cd(filename2{mm})
    load('StateEpochSBAllOB.mat','REMEpoch','SWSEpoch','smooth_1015','TenFif_thresh');
    REMEpoch1=REMEpoch;SWSEpoch1=SWSEpoch;
    load('StateEpochSB','REMEpoch','Sleep','SWSEpoch');
    
    a=size(Data(Restrict(smooth_1015,or(REMEpoch,REMEpoch1))),1);    
    b=size(Data(Restrict(smooth_1015,REMEpoch)),1);
    Ratio(mm,1)=b/a;
    
    a=size(Data(Restrict(smooth_1015,or(REMEpoch,REMEpoch1))),1);
    b=size(Data(Restrict(smooth_1015,REMEpoch1)),1);
    Ratio(mm,2)=b/a;
    
    a=size(Data(Restrict(smooth_1015,or(SWSEpoch,SWSEpoch1))),1);    
    b=size(Data(Restrict(smooth_1015,SWSEpoch)),1);
    Ratio(mm,3)=b/a; 
    
    a=size(Data(Restrict(smooth_1015,or(SWSEpoch,SWSEpoch1))),1);
    b=size(Data(Restrict(smooth_1015,SWSEpoch1)),1);
    Ratio(mm,4)=b/a;    

end
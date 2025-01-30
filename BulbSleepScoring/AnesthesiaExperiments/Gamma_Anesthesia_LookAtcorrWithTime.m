clear all, close all
cd /media/DataMOBsRAIDN/ProjetSlSc/FiguresReview
load('Gamma_HR_Corr_Response_RangeOfTimeBins.mat','T','Time','GammaThresh','MeannGamSleep','MeannGamWake')

% Put data together for correlations


TimeWindow.Mov = [find(Time.Mov<0.05,1,'last'):find(Time.Mov<0.5,1,'last')];
TimesToTest = [-100:10:-20,-10:1:-1;-110:10:-30,-11:1:-2]-0.5;


for TtoT = 1 :size(TimesToTest,2)
    
    AllGamma_OB = [];
    AllReac = [];
    Allexp = []; AllMice = [];
    for exp = 1
        if exp == 1
            Stim = 1;
        else
            Stim = 2;
        end
        
        for  k = 1:4
            AllGamma_OB = [AllGamma_OB,T.GammaOB{exp,k,Stim}(TtoT,:)./(GammaThresh(k))];
            AllReac = [AllReac,nanmean(T.Mov{exp,k,Stim}(:,TimeWindow.Mov)')];
            AllMice = [AllMice, k*ones(1,size(nanmean(T.Mov{exp,k,Stim}(:,TimeWindow.Mov)'),2))];
            Allexp = [Allexp, exp*ones(1,size(nanmean(T.Mov{exp,k,Stim}(:,TimeWindow.Mov)'),2))];
            
        end
    end
    AllReac(isnan(AllGamma_OB))=[];
    AllMice(isnan(AllGamma_OB))=[];
    Allexp(isnan(AllGamma_OB))=[];
    AllGamma_OB(isnan(AllGamma_OB))=[];
    [R,P] = corrcoef(log(AllGamma_OB),log(AllReac));
    RTime(TtoT)=R(1,2);
end
function [y,PFCModel]=ModelWeightedSum(x,varargin)

global TrialSet time InputInfo
% input parameters are amplitude of OB and HPC respectively


%parameters
amp1=x(1);
amp2=x(2);

NumTrials=size(TrialSet.HPC,1);

for nt=1:NumTrials
    % make model of signal
    y1=TrialSet.OB(nt,:)*amp1;% Ob contribution
    y2=TrialSet.HPC(nt,:)*amp2;% HPC contribution
    y1=y1(1:length(TrialSet.HPC(nt,:)));
    y2=y2(1:length(TrialSet.HPC(nt,:)));
    
    % reconstruction of stim
    sumY=std(TrialSet.PFCx(nt,:)).*(y1+y2)./std(y1+y2);
    PFCModel(nt,:)=sumY;
    % Error
    Err{1}(nt,:)=sumY-TrialSet.PFCx(nt,:);
    Err{2}(nt,:)=sumY+TrialSet.PFCx(nt,:);
end

y=sum(Err{1}(:).^2)/sum(Err{2}(:).^2);

end
function y=ErrorModelWeightedDelaySum(x,varargin)

global TrialSet time InputInfo

% input parameters are amplitude of OB and HPC respectively


%parameters
amp1=x(1);
amp2=x(2);
tau1=x(3); % delay for OB from -InputInfo.MaxDel to InputInfo.MaxDel
tau2=x(4); % delay for HPC from -InputInfo.MaxDel to InputInfo.MaxDel
keyboard
MaxBinDel=floor(InputInfo.MaxDel*InputInfo.SampleRate)+1;
if abs(floor(tau1*InputInfo.SampleRate)-tau1*InputInfo.SampleRate)>abs(ceil(tau1*InputInfo.SampleRate)-tau1*InputInfo.SampleRate)
    tau1=floor(tau1*InputInfo.SampleRate);
else
    tau1=ceil(tau1*InputInfo.SampleRate);
end

if abs(floor(tau2*InputInfo.SampleRate)-tau2*InputInfo.SampleRate)>abs(ceil(tau2*InputInfo.SampleRate)-tau2*InputInfo.SampleRate)
    tau2=floor(tau2*InputInfo.SampleRate);
else
    tau2=ceil(tau2*InputInfo.SampleRate);
end


NumTrials=size(TrialSet.HPC,1);

for nt=1:NumTrials
    % make model of signal
    y1=TrialSet.OB(nt,:)*amp1;% Ob contribution
    y2=TrialSet.HPC(nt,:)*amp2;% HPC contribution
    y1=[zeros(1,tau1),y1];y1=y1(MaxBinDel:length(TrialSet.PFCx)-MaxBinDel);
    y2=[zeros(1,tau2),y2];y2=y2(MaxBinDel:length(TrialSet.PFCx)-MaxBinDel);
    
    
    % reconstruction of stim
    PFCData=TrialSet.PFCx(nt,MaxBinDel:end-MaxBinDel);
    sumY=std(TrialSet.PFCx(nt,:)).*(y1+y2)./std(y1+y2);
    
    % Error
    Err{1}(nt,:)=sumY-PFCData;
    Err{2}(nt,:)=sumY+PFCData;
end

y=sum(Err{1}(:).^2)/sum(Err{2}(:).^2);

end
function y=ErrorModelAlphaFunctionOBFixedHPCRes(x,varargin)

global TrialSet time InputInfo
% input parameters are amplitude of OB and HPC respectively

%parameters
amp1=InputInfo.FixedOB(1);
n1=InputInfo.FixedOB(2);
tau1=InputInfo.FixedOB(3);
amp2=x(1);
n2=x(2);
tau2=x(3);

% time vector
t=[0:0.1/InputInfo.SampleRate:InputInfo.MaxKernelDur];
MaxBinDel=floor(InputInfo.MaxKernelDur*InputInfo.SampleRate)+1;

%alpha functions
Alpha1=amp1*(t).^n1.*exp(-(t)./tau1);
Alpha2=amp2*(t).^n2.*exp(-(t)./tau2);

NumTrials=size(TrialSet.HPC,1);

for nt=1:NumTrials
    
    PFCData=TrialSet.PFCx(nt,MaxBinDel:length(TrialSet.PFCx(nt,:))-MaxBinDel);
    % make model of signal
    y1=conv(TrialSet.OB(nt,:),Alpha1);
    y2=conv(TrialSet.HPC(nt,:),Alpha2);
    y1=y1(MaxBinDel:length(TrialSet.PFCx(nt,:))-MaxBinDel);
    y2=y2(MaxBinDel:length(TrialSet.PFCx(nt,:))-MaxBinDel);
        
    % reconstruction of stim with just OB
    %sumYtemp=std(PFCData).*(y1)./std(y1);
    sumYtemp=y1;
    ResY=sumYtemp-PFCData;
    sumY=y2;

    % Error
    Err{1}(nt,:)=sumY-ResY;
    Err{2}(nt,:)=sumY+ResY;
end

y=sum(Err{1}(:).^2)/sum(Err{2}(:).^2);

end
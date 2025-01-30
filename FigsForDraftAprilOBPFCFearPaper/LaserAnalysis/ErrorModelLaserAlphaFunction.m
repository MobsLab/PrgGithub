function y=ErrorModelLaserAlphaFunction(x,varargin)

global TrialSet time InputInfo
% input parameters are amplitude of OB and HPC respectively

%parameters
amp1=x(1);
n1=x(2);
tau1=x(3);
amp2=x(4);
n2=x(5);
tau2=x(6);

% time vector
t=[0:0.1/InputInfo.SampleRate:InputInfo.MaxKernelDur];
MaxBinDel=floor(InputInfo.MaxKernelDur*InputInfo.SampleRate)+1;

%alpha functions
Alpha1=amp1*(t).^n1.*exp(-(t)./tau1);
Alpha2=amp2*(t).^n2.*exp(-(t)./tau2);

NumTrials=size(TrialSet.In,1);

for nt=1:NumTrials
    OutData=TrialSet.Out(nt,MaxBinDel:length(TrialSet.Out(nt,:))-MaxBinDel);
    % make model of signal
    y1=conv(TrialSet.In(nt,:),Alpha1);
    y1=y1(MaxBinDel:length(TrialSet.Out(nt,:))-MaxBinDel);
    y2=conv(TrialSet.In(nt,:),Alpha2);
    y2=y2(MaxBinDel:length(TrialSet.Out(nt,:))-MaxBinDel);

    % Error
    Err{1}(nt,:)=y1+y2-OutData;
    Err{2}(nt,:)=y1+y2+OutData;
end

y=sum(Err{1}(:).^2)/sum(Err{2}(:).^2);

end
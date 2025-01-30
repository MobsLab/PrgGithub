
%--------------------------------------------------------------------------------------------------------------------------------------

res=pwd;
load DeltaSleepEvent
load([res,'/LFPData/InfoLFP']);

%--------------------------------------------------------------------------------------------------------------------------------------
rawLFP_TONEtime1={};
rawLFP_TONEtime2={};
rawLFP_DeltaDetect={};

a=1;
for num=1:length(InfoLFP.channel)-3;
    ch=InfoLFP.channel(num);
    clear LFP
    load([res,'/LFPData/LFP',num2str(ch)]);
    try
    rawLFP=PlotRipRaw(LFP,TONEtime1/1E4,1000); close
    rawLFP_TONEtime1{num}=rawLFP;
    end
    try
    rawLFP=PlotRipRaw(LFP,TONEtime2/1E4,1000); close
    rawLFP_TONEtime2{num}=rawLFP;
    end
    try
    rawLFP=PlotRipRaw(LFP,DeltaDetect/1E4,1000); close
    rawLFP_DeltaDetect{num}=rawLFP;
    end
    disp(['channel # ',num2str(ch),' > done'])
    a=a+1;
end
save rawLFP_DeltaDetect  rawLFP_DeltaDetect 
save rawLFP_TONEtime rawLFP_TONEtime1 rawLFP_TONEtime2
%----------------------------------------------------------------------------------------------------------------

rawLFP_TONEtime1={};
rawLFP_TONEtime2={};
rawLFP_DeltaDetect={};

a=1;
for num=1:length(InfoLFP.channel)-3;
    ch=InfoLFP.channel(num);
    clear LFP
    load([res,'/LFPData/LFP',num2str(ch)]);
    try
    rawLFP=PlotRipRaw(LFP,TONEtime1_SWS/1E4,1000); close
    rawLFP_TONEtime1{num}=rawLFP;
    end
    try
    rawLFP=PlotRipRaw(LFP,TONEtime2_SWS/1E4,1000); close
    rawLFP_TONEtime2{num}=rawLFP;
    end
    try
    rawLFP=PlotRipRaw(LFP,DeltaDetect_SWS/1E4,1000); close
    rawLFP_DeltaDetect{num}=rawLFP;
    end
    disp(['channel # ',num2str(ch),' > done'])
    a=a+1;
end
save rawLFP_DeltaDetect_SWS  rawLFP_DeltaDetect 
save rawLFP_TONEtime_SWS rawLFP_TONEtime1 rawLFP_TONEtime2



%--------------------------------------------------------------------------------------------------------------------------------------
rawLFP_TONEtime1_REM={};
rawLFP_TONEtime2_REM={};
rawLFP_DeltaDetect_REM={};

a=1;
for num=1:length(InfoLFP.channel)-3;
    ch=InfoLFP.channel(num);
    clear LFP
    load([res,'/LFPData/LFP',num2str(ch)]);
    try
    rawLFP=PlotRipRaw(LFP,TONEtime1_REM/1E4,1000); close
    rawLFP_TONEtime1_REM{num}=rawLFP;
    end
    try
    rawLFP=PlotRipRaw(LFP,TONEtime2_REM/1E4,1000); close
    rawLFP_TONEtime2_REM{num}=rawLFP;
    end
    try
    rawLFP=PlotRipRaw(LFP,DeltaDetect_REM/1E4,1000); close
    rawLFP_DeltaDetect_REM{num}=rawLFP;
    end
    disp(['channel # ',num2str(ch),' > done'])
    a=a+1;
end
save rawLFP_DeltaDetect_REM  rawLFP_DeltaDetect 
save rawLFP_TONEtime_REM rawLFP_TONEtime1 rawLFP_TONEtime2
%----------------------------------------------------------------------------------------------------------------







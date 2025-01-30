res=pwd;
load([res,'/LFPData/LFP',num2str(0)]);
Xaxis=Data(LFP);
Xtime=Range(LFP);
load([res,'/LFPData/LFP',num2str(1)]);
Yaxis=Data(LFP);
Ytime=Range(LFP);
load([res,'/LFPData/LFP',num2str(2)]);
Zaxis=Data(LFP);
Ztime=Range(LFP);
    
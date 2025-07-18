function  [X,nameCh]=LoadingFiles(Epoch,freq,Fil,ch)

%
% deb et fin en secondes
%

%LoadPATHKB;

%cd('/Volumes/DataMOBsRAID5/ProjetAstro/DataPlethysmo/Mouse060/20130503');

   
load LFPData/InfoLFP;

try
%%%% RESPI
load LFPData RespiTSD;
respi=ResampleTSD(RespiTSD,freq);
end

try
    ch;
catch
    ch=1:length(InfoLFP.channel);
end

if 0
    
    %%%% BULB
    load ChannelsToAnalyse/Bulb_deep
    eval(['load LFPData/LFP',num2str(channel)])
    %load LFPData/LFP11;%8;
    try
        Fil;
        if Fil(1)>0
            LFP=FilterLFP(LFP,Fil,1024);
        end
    end
    lfpa=ResampleTSD(LFP,freq);

    %%%% PFC
    load ChannelsToAnalyse/PFCx_deep
    eval(['load LFPData/LFP',num2str(channel)])
    %load LFPData/LFP8; %5;
    try
        Fil;
        LFP=FilterLFP(LFP,Fil);
    end
    lfpb=ResampleTSD(LFP,freq);

    %%%% PAR
    %load LFPData/LFP5; %7;
    load ChannelsToAnalyse/PaCx_deep
    eval(['load LFPData/LFP',num2str(channel)])

    try
        Fil;
        LFP=FilterLFP(LFP,Fil);
    end
    lfpc=ResampleTSD(LFP,freq);

    %%%% HPC
    load ChannelsToAnalyse/dHPC_deep
    eval(['load LFPData/LFP',num2str(channel)])
    %load LFPData/LFP2;
    try
        Fil;
        LFP=FilterLFP(LFP,Fil);
    end
    lfpd=ResampleTSD(LFP,freq);

    % %%%% HPC
    % load LFPData/LFP4;
    % try
    %     Fil;
    %     LFP=FilterLFP(LFP,Fil);
    % end
    % lfpe=ResampleTSD(LFP,freq);




    %%%%%%%%%%%% RANGE
    %Epoch=intervalSet(deb*1E4,fin*1E4);

    %%%%%%%%%%%% 
    b1=2*zscore(Data(ResampleTSD(Restrict(RespiTSD,Restrict(lfpa,Epoch)),freq))); % Respi
    b2=2*zscore(Data(ResampleTSD(Restrict(lfpa,Epoch),freq))); % Bulb
    b3=2*zscore(Data(ResampleTSD(Restrict(lfpb,Epoch),freq)));  %Pfc
    b4=2*zscore(Data(ResampleTSD(Restrict(lfpc,Epoch),freq)));  %Par
    b5=2*zscore(Data(ResampleTSD(Restrict(lfpd,Epoch),freq)));  %Hpc
    %b6=2*zscore(Data(ResampleTSD(Restrict(lfpe,Epoch),freq)));  %Hpc

    b1=b1-mean(b1);
    b2=b2-mean(b2);
    b3=b3-mean(b3);
    b4=b4-mean(b4);
    b5=b5-mean(b5);
    %b6=b6-mean(b6);

    %%%%%%%%%%%% RETURN
    X = [b1';b2';b3';b4';b5'];

else

    X = [];
    a=1;
    for i=ch
        eval(['load LFPData/LFP',num2str(i)])
        nameCh{a}=InfoLFP.structure{InfoLFP.channel==i};
        try
        Fil;
        if Fil(1)>0
            LFP=FilterLFP(Restrict(LFP,Epoch),Fil,1024);
        end
        end
    
        if freq<1000
        lfpT{a}=ResampleTSD(Restrict(LFP,Epoch),freq);
        else
        lfpT{a}=Restrict(LFP,Epoch);
            
        end
        
        b=2*zscore(Data(ResampleTSD(Restrict(lfpT{a},Epoch),freq)));
        b=b-mean(b);
        X = [X;b'];
        a=a+1;
    end

    try
        lfpT=tsdArray(lfpT);
    end

end

try
    b1=3*zscore(Data(ResampleTSD(Restrict(RespiTSD,Restrict(lfpT{1},Epoch)),freq)));
    b1=b1-mean(b1);
    X = [X;b1'];
    nameCh{a}='Respi';
end

%%%%%%%%%%%% PLOT
%subplot(2, 2, [1 2]); plot(rand(10, 3));
%figure(7), clf reset, subplot(2, 2, [1 2]), plot(Range(Restrict(lfpa,Epoch),'s'),1E-3+Data(Restrict(lfpa,Epoch)),'k'),hold on, plot(Range(Restrict(respi,Epoch),'s'),Data(Restrict(respi,Epoch))/100,'r'),plot(Range(Restrict(lfpb,Epoch),'s'),2E-3+Data(Restrict(lfpb,Epoch)),'k'),plot(Range(Restrict(lfpc,Epoch),'s'),3E-3+Data(Restrict(lfpc,Epoch)),'k'),plot(Range(Restrict(lfpd,Epoch),'s'),4.5E-3+Data(Restrict(lfpd,Epoch)),'k')%,plot(Range(Restrict(lfpe,Epoch),'s'),6E-3+Data(Restrict(lfpe,Epoch)),'k')

figure(7),clf, hold on
%for i=1:length(InfoLFP.channel)
for i=1:length(ch)
    subplot(2, 2, [1 2]), hold on, plot(Range(Restrict(lfpT{i},Epoch),'s'),2*i*std(Data(Restrict(lfpT{1},Epoch)))+Data(Restrict(lfpT{i},Epoch)),'k'),
end
try
    hold on, plot(Range(Restrict(respi,Epoch),'s'),rescale(Data(Restrict(respi,Epoch)),-2*std(Data(Restrict(lfpT{1},Epoch))),std(Data(Restrict(lfpT{1},Epoch)))),'r')
end
ylim([-3 size(X,1)+3]*2*std(Data(Restrict(lfpT{1},Epoch))))

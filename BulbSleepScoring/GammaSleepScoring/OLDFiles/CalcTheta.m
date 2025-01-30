function CalcTheta(Epoch,ThetaI,chH,filename)


load(strcat('LFPData/LFP',num2str(chH),'.mat'));

pasTheta=100; 

% find theta epochs

    disp(' ');
    disp('... Creating Theta Epochs ');
    FilTheta=FilterLFP(LFP,[5 10],1024);
    FilDelta=FilterLFP(LFP,[3 6],1024);
    HilTheta=hilbert(Data(FilTheta));
    HilDelta=hilbert(Data(FilDelta));
    H=abs(HilDelta);
    H(H<100)=100;
    ThetaRatio=abs(HilTheta)./H;
    rgThetaRatio=Range(FilTheta,'s');
    ThetaRatio=SmoothDec(ThetaRatio(1:pasTheta:end),50);
    rgThetaRatio=rgThetaRatio(1:pasTheta:end);
    ThetaRatioTSD=tsd(rgThetaRatio*1E4,ThetaRatio);
    smooth_Theta=tsd(Range(ThetaRatioTSD),smooth(Data(ThetaRatioTSD),12));


    save(strcat(filename,'StateEpochSB'),'smooth_Theta','ThetaRatioTSD','ThetaI','-v7.3','-append');


end
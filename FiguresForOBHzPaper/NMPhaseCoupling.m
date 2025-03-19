clear all
% Parameters that don't change
Options.n=1; % n:m coupling
Options.m=2; % n:m coupling
Options.dt=0.001; % time step for euler method, seconds
Options.TMax=100; % duration of simulation, seconds
Options.FreqRange1=[2:12;4:14]; % Frequencies to filter
Options.FreqRange2=[2:12;4:14]; % Frequencies to filter
Options.BinNum=80;
Options.Shuffles=100;
Options.NMRatiosToTest=[1,1;1,1.5;1,2;1,3;1,4];
Options.MeanFrq1=4*(2*pi); % Mean Freq for first oscillator
Options.MeanFrq2=9*(2*pi); % Mean Freq for first oscillator
Options.alpha=0.01;
Options.StdFrq1=1*(2*pi); % Std of freq for first oscillator
Options.StdFrq2=1*(2*pi); % Std of freq for first oscillator
Options.smoofactfreq=10; % what timescale should frequency noise vary on

%  different degrees of coupling
Str=[0,0.2,1,2,3,7,10,15];
for k=1:length(Str)
    Options.eps=Str(k); % strength of coupling
    [Res.Index{k,1},Res.IndexRand{k,1},Res.IsSig{k,1},Res.LFP1{k,1},Res.LFP2{k,1},Res.PhaseDiff{k,1}]=SimulatePhaseCoupling(Options,1);
    Res.Options{k,1}=Options;
end

params.Fs=1000;
params.trialave=0;
params.err=[1 0.0500];
params.pad=2;
params.fpass=[0 20];
movingwin=[3 0.2];
params.tapers=[3 5];
disp('... Calculating spectrogramm.');




figure
for k=1:length(Str)
    CaxLim=[];
    [Sp1,t,f]=mtspecgramc(Data(Res.LFP1{k,1}),movingwin,params);
    [Sp2,t,f]=mtspecgramc(Data(Res.LFP2{k,1}),movingwin,params);
    
    for n=1:5
        subplot(length(Str),5,(k-1)*5+n)
        imagesc(mean(Options.FreqRange1),mean(Options.FreqRange1),squeeze(Res.IsSig{k,1}.Shannon(:,:,n).*Res.Index{k,1}.Shannon(:,:,n))), hold on
        axis xy
        if k==1
            title([num2str( Options.NMRatiosToTest(n,1)),':',num2str( Options.NMRatiosToTest(n,2))])
        end
        if n==1
            ylabel(['Coup Str:',num2str(Str(k))])
        end
        plot(f,10*mean(Sp1)/max(mean(Sp1))+3,'w')
        plot(10*mean(Sp2)/max(mean(Sp2))+3,f,'w')
        if sum(sum(squeeze(Res.IsSig{k,1}.Shannon(:,:,n).*Res.Index{k,1}.Shannon(:,:,n))))>0
            CaxLim=[CaxLim;clim];
        end
    end
    for n=1:5
        clim([0 max(CaxLim(:,2))]);
    end
    colorbar('East','color','w')
end
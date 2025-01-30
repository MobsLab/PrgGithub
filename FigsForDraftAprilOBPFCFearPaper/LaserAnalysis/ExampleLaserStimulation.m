Ep = intervalSet(15341*1e4,15383*1e4);
figure
load('/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse465/20170126/LFPData/DigInfo4.mat')
EpLas=thresholdIntervals(((DigTSD)),0.9);
EpLas = and(EpLas,Ep);
for k = 1:length(Start(EpLas))
    strt = Start(subset(EpLas,k),'s');
        stp = Stop(subset(EpLas,k),'s');

p = patch([strt strt stp stp],[-6e4 4e4 4e4 -6e4],'b');
p.FaceAlpha = 0.2;
p.EdgeColor = [0 0 1];
p.EdgeAlpha = 0.2;

end
hold on
load('/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse465/20170126/LFPData/LFP24.mat')
plot(Range(Restrict(LFP,Ep),'s'),Data(Restrict(LFP,Ep)),'k')
load('/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse465/20170126/LFPData/LFP25.mat')
plot(Range(Restrict(LFP,Ep),'s'),Data(Restrict(LFP,Ep))-1*1e4,'k')
load('/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse465/20170126/LFPData/LFP26.mat')
plot(Range(Restrict(LFP,Ep),'s'),Data(Restrict(LFP,Ep))-2*1e4,'k')
ylim([-3e4 1e4])
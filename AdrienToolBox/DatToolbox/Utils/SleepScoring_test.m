fbasename = 'Mouse08-120321';

load([fbasename '.eegseg.mat']);

dt = median(diff(t));

gamma = squeeze(sum(y(:,f>0.5&f<55,:),2));
beta = squeeze(sum(y(:,f>0.5&f<20,:),2));
theta = squeeze(sum(y(:,f>0.5&f<9,:),2));
delta = squeeze(sum(y(:,f>0.5&f<4.5,:),2));

ratio1 = sum(beta./gamma,2);
ratio2 = sum(delta./theta,2);

w = hann(20/dt); %20sec length Hanning window

ratio1 = conv(ratio1,w,'same');
ratio2 = conv(ratio2,w,'same');

epr = load([fbasename '.sts.REM'])/1250;
eps = load([fbasename '.sts.SWS'])/1250;

epr = intervalSet(epr(:,1),epr(:,2));
eps = intervalSet(eps(:,1),eps(:,2));

r1 = tsd(t,ratio1);
r2 = tsd(t,ratio2);


figure(1),clf
    plot(ratio2,ratio1,'k.')
    hold on
    plot(Data(Restrict(r2,epr)),Data(Restrict(r1,epr)),'g.')
    plot(Data(Restrict(r2,eps)),Data(Restrict(r1,eps)),'r.')
    



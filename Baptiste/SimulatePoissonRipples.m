

close all
ripfreq = 0.2;
clear r r_hist
for episodedur = 1:50
    r(episodedur,:) = poissrnd(ripfreq*episodedur,1,1000);
    r_hist(episodedur,:) = hist(r(episodedur,:)/episodedur,[0:0.01:1]);
end
figure
imagesc(1:50,[0:0.05:1],r_hist')
axis xy
xlabel('episode duration')
ylabel('ripple density')

figure
AllDur = [];
AllRipDens = [];
for episodedur = 1:50
AllDur = [AllDur,r(episodedur,:)*0+episodedur];
AllRipDens = [AllRipDens,r(episodedur,:)/episodedur];

plot(episodedur,r(episodedur,:)/episodedur,'k.')
hold on
end
xlabel('episode duration')
ylabel('ripple density')
title('R=-0.0037, P = 0.4051')

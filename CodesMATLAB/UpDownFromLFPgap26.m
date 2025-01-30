function [amplUp,amplUp_gap26,amplUpBis,amplUpBis_gap26]=UpDownFromLFPgap26(pre,post)


smo=10;
binS=500;


pre=pre(1:20:end,:);
post=post(1:20:end,:);
Y=locdetrend(pre(:,2),1/median(diff(pre(:,1))),[200,10]);
Yp=locdetrend(post(:,2),1/median(diff(post(:,1))),[200,10]);

params.tapers=[1 2];
params.Fs=1/median(diff(pre(:,1)));
movingwin=[1,0.05];
[Sp,tp,fp]=mtspecgramc(Yp,movingwin,params);
[S,t,f]=mtspecgramc(Y,movingwin,params);

id=find(f>55);
Pw=mean(10*log10(S(:,id)),2);
Pwp=mean(10*log10(Sp(:,id)),2);

id1=find(f>4);
id2=find(f<4);
Pw2=mean(10*log10(S(:,id1)),2)./mean(10*log10(S(:,id2)),2);
Pwp2=mean(10*log10(Sp(:,id1)),2)./mean(10*log10(Sp(:,id2)),2);




[c]=kmeans(Pw,2);
amplUp=abs(c(1)-c(2));
        
[c]=kmeans(Pwp,2);
amplUp_gap26=abs(c(1)-c(2));

[c]=kmeans(Pw2,2);
amplUpBis=abs(c(1)-c(2));
        
[c]=kmeans(Pwp2,2);
amplUpBis_gap26=abs(c(1)-c(2));







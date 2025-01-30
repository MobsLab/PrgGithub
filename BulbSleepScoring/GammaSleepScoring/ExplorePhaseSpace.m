function ExplorePhaseSpace
load(strcat(filename,'StateEpochSB.mat'))

dur1=[];
dur2=[];
dur3=[];
dur4=[];
dur5=[];
dur6=[];
dur7=[];
dur8=[];

t=Range(smooth_ghi);
t=t(1:100:end);
a=Data(Restrict(smooth_ghi,ts(t)));
b=Data(Restrict(smooth_Theta,ts(t)));

for k=2:size(t)-1

dur1(k)=sqrt((b(k-1)-b(k))^2);
dur2(k)=sqrt((a(k-1)-a(k))^2);
dur3(k)=sqrt((b(k-1)-b(k+1))^2+(a(k-1)-a(k+1))^2);
dur4(k)=abs(b(k-1)-b(k))/abs(b(k-1)-b(k+1));
dur5(k)=abs(a(k-1)-a(k))/abs(a(k-1)-a(k+1));
dur6(k)=(sqrt((b(k-1)-b(k))^2+(a(k-1)-a(k))^2))/(sqrt((b(k-1)-b(k+1))^2+(a(k-1)-a(k+1))^2));
dur7(k)=((b(k-1)-b(k+1)));
dur8(k)=((a(k-1)-a(k+1)));
dur9(k)=sqrt((b(k-1)-b(k))^2)/b(k);
dur10(k)=sqrt((a(k-1)-a(k))^2)/a(k);

end
dur1(1)=0;
dur1(size(t))=0;
dur2(1)=0;
dur3(1)=0;
dur2(length(t))=0;
dur3(length(t))=0;
dur4(1)=0;
dur4(length(t))=0;
dur5(1)=0;
dur5(length(t))=0;
dur6(1)=0;
dur6(length(t))=0;
dur7(1)=0;
dur7(length(t))=0;
dur8(1)=0;
dur8(length(t))=0;
dur9(1)=0;
dur9(length(t))=0;
dur10(1)=0;
dur10(length(t))=0;

%SpeedTheta
figure
subplot(221)
scatter(log(a),log(b),10*ones(1,k+1),log(dur2))
subplot(222)
scatter(log(a),log(b),10*ones(1,k+1),log(dur1))
subplot(223)
scatter(log(a),log(b),10*ones(1,k+1),log(dur2))



%SpeedGamma



%Delta


% EpochLength



end



%% play around with phase spaces
X=log(Data(theta_new));
Y=log(Data(ghi_new));
[occH, x1, x2] = hist2d(X,Y,300,300);
occH2=SmoothDec(occH,[1,1]);
ghi_new=Restrict(smooth_ghi,PlotEp);
thetasp_new=Restrict(smooth_Theta,PlotEp);
t=Range(theta_new);
ti=t(1:length(t));
ghi_new=(Restrict(ghi_new,ts(ti)));
theta_new=(Restrict(theta_new,ts(ti)));
ghi_new=Restrict(ghi_new,ts(Range(theta_new)));
sleeptheta=(Restrict(theta_new,And(PlotEp,SWSEpoch)));
ghi_new_s=Restrict(ghi_new,ts(Range(sleeptheta)))
hold on
remtheta=(Restrict(theta_new,And(PlotEp,REMEpoch)));
ghi_new_r=Restrict(ghi_new,ts(Range(remtheta)));
waketheta=(Restrict(theta_new,Wake));
ghi_new_w=Restrict(ghi_new,ts(Range(waketheta)));


perc=[0:0.1:1];
a=Data(ghi_new_s);
b=Data(sleeptheta);
vits=smooth(sqrt((b(1:end-1)-b(2:end)).^2+(a(1:end-1)-a(2:end)).^2),10);
dists=sqrt((a-mean(a)).^2+(b-mean(b)).^2);
for k=1:10
    mvits(k)=mean(vits(find(dists(1:end-1)>percentile(dists(1:end-1),perc(k)) & dists(1:end-1)<percentile(dists(1:end-1),perc(k+1)))));
end
a=Data(ghi_new_r);
b=Data(remtheta);
vitr=smooth(sqrt((b(1:end-1)-b(2:end)).^2+(a(1:end-1)-a(2:end)).^2),10);
distr=sqrt((a-mean(a)).^2+(b-mean(b)).^2);
for k=1:10
    mvitr(k)=mean(vitr(find(distr(1:end-1)>percentile(distr(1:end-1),perc(k)) & distr(1:end-1)<percentile(distr(1:end-1),perc(k+1)))));
end

a=Data(ghi_new_w);
b=Data(waketheta);
vitw=smooth(sqrt((b(1:end-1)-b(2:end)).^2+(a(1:end-1)-a(2:end)).^2),10);
distw=sqrt((a-mean(a)).^2+(b-mean(b)).^2);
for k=1:10
    mvitw(k)=mean(vitw(find(distw(1:end-1)>percentile(distw(1:end-1),perc(k)) & distw(1:end-1)<percentile(distw(1:end-1),perc(k+1)))));
end

clf
imagesc(x2,x1,(occH2))
colormap gray
axis xy

X=log(Data(ghi_new_w));
Y=log(Data(waketheta));
xm=mean(X);
ym=mean(Y);
xdiff=(X-xm).^2;
ydiff=(Y-ym).^2;
s(1)=sum(sqrt(xdiff+ydiff));


[IDX,C,sumd,D] = kmeans(X,k)




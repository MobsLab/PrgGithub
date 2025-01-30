function FindGammaEpochv2(Epoch,chB,mindur,filename)

smootime=3;
load(strcat('LFPData/LFP',num2str(chB),'.mat'));


% find gamma epochs
disp(' ');
disp('... Creating Gamma Epochs ');
FilGamma=FilterLFP(LFP,[50 70],1024);
HilGamma=hilbert(Data(FilGamma));
H=abs(HilGamma);
tot_ghi=Restrict(tsd(Range(LFP),H),Epoch);
smooth_ghi=tsd(Range(tot_ghi),runmean(Data(tot_ghi),(smootime/8)*1e4));

% a=percentile(Data(smooth_ghi),0.99);
sm_ghi=Data(Restrict(smooth_ghi,Epoch));
% smooth_ghi_new_range=sm_ghi(sm_ghi<a);
[Y,X]=hist(log(sm_ghi),1000);
cf_=createFiGt(X,Y/sum(Y));
a=coeffvalues(cf_);
peak_thresh_g=a(2)+2*a(3);
mX=max(X);
mx=min(X);
X=X-mx;
X=X*15e4/mX;
tseries=timeseries(Y,X);
time=[0:100:15e4];
rsts=resample(tseries,time);
X=rsts.time;
z=rsts.Data;
for t=1:length(z)
    Y(t)=z(1,1,t);
end
smo=20;
fil=FilterLFP(tsd(sort(X)',smooth(Y',smo)),[0.001 1]);
d=diff(Data(fil));
fild=Data(fil);
filr=Range(fil);
a=find(d<0);
da=diff(a);
peak_thresh=filr(a(find(da~=1,1,'first'))+1)*mX/15e4+mx;
peak_thresh_norm=filr(a(find(da~=1,1,'first'))+1);

[Y,X]=hist(log(sm_ghi),1000);
figure
plot(X,Y)
hold on

line([(peak_thresh_g) (peak_thresh_g)],[0 10000],'linewidth',4,'color','g')
try
    line([(peak_thresh) (peak_thresh)],[0 10000],'linewidth',4,'color','r')
end
legend('data','gaussianfit','bimodal')
in=input('which do you prefer? 0 for bimodal, 1 for gauss, 2 for manual');
if in==0
    peak_thresh_fin=exp(peak_thresh);
elseif in==1
    peak_thresh_fin=exp(peak_thresh_g);
else
    [peak_thresh_fin,~]=(ginput(1));
    peak_thresh_fin=exp(peak_thresh_fin);
end
sleepper=thresholdIntervals(smooth_ghi,peak_thresh_fin,'Direction','Below');
sleepper=mergeCloseIntervals(sleepper,mindur*1e4);
sleepper=dropShortIntervals(sleepper,mindur*1e4);
 
save(strcat(filename,'StateEpochSB'),'sleepper', 'peak_thresh_fin','peak_thresh_g','peak_thresh_norm','peak_thresh','mindur','smooth_ghi','-v7.3','-append');




end


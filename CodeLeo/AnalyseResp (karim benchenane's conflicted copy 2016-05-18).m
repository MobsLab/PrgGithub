clear all
Del=10000;
dt=50*1E-6;
stdtimes=3;

%cd /Users/sophiebagur/Desktop/DataLeo/11022016/
[d,si,h]=abfload('04042016 cell6_0002.abf');


str=find(squeeze(d(:,3,1))>1,1,'First');
if isempty(h.tags)
    TracesToDo=[1:size(d,3)];
else
    TracesToDo=find(h.sweepStartInPts*dt<h.tags(1).timeSinceRecStart);
    TracesToDo=TracesToDo(1:end-1)';
end

clear rep st mn data downst RespSt Amp PeakTime EndTime FinalVals
for k=1:length(TracesToDo)
    k
    subplot(121)
    temprep=runmean(squeeze(d(:,1,TracesToDo(k))),10);
    rep(k,:)=temprep(str-10000:str+10000);  % on prend 0.5s autour de la stim
    st(k)=std(rep(k,1:8000)');
    mn(k)=mean(rep(k,1:8000)');
    data=rep(k,:);
    
    if not(isempty(find(rep(k,Del:end)<mn(k)-stdtimes*st(k))))
        downst(k)=find(rep(k,Del:end)<mn(k)-stdtimes*st(k),1,'first')+Del;
        deriv=diff(data(downst(k)-200:downst(k)));
        RespSt(k)=downst(k)-(200-find(deriv>0,1,'last'));
        if RespSt(k)<Del,  RespSt(k)=NaN; EndTime(k)=NaN; FinalVals(k,:)=nan(1,7);PeakTime(k)=NaN;
            FinalVals(k,7)=0;
            title('problem')
        else
            % Negative peak
            [Amp(k),PeakTime(k)]=min(data(downst(k):downst(k)+1000));
            PeakTime(k)=PeakTime(k)+downst(k);
            % Fit to get tau
            x=[0:1000];
            y=data(PeakTime(k):PeakTime(k)+1000)-mn(k);
            try
                [cf_,goodness]=createExpFit(x,y,[Amp(k),0.1,0]);
            catch
                [cf_,goodness]=createExpFit(x,y,[Amp(k),0.2,0]);
            end
            CF=coeffvalues(cf_);
            if goodness.rsquare<0.9
                goodness.rsquare=NaN;
                CF(2)=NaN;
            end
            % Get width
            EndTime(k)=find(data(PeakTime(k):end)>mn(k),1,'first')+PeakTime(k);
            FinalVals(k,:)=[[RespSt(k)-Del,PeakTime(k)-Del,1./CF(2),EndTime(k)-RespSt(k)]*dt,Amp(k)-data(RespSt(k)),goodness.rsquare,NaN];
            title('neg resp')
        end
    elseif not(isempty(find(rep(k,Del:end)>mn(k)+stdtimes*st(k))))
        downst(k)=find(rep(k,Del:end)>mn(k)+stdtimes*st(k),1,'first')+Del;
        deriv=diff(data(downst(k)-200:downst(k)));
        RespSt(k)=downst(k)-(200-find(deriv<0,1,'last'));
        if RespSt(k)<Del,  RespSt(k)=NaN; EndTime(k)=NaN; FinalVals(k,:)=nan(1,7);PeakTime(k)=NaN;
            FinalVals(k,7)=0;
            title('problem')
        else
            % Positive peak
            [Amp(k),PeakTime(k)]=max(data(downst(k):downst(k)+1000));
            PeakTime(k)=PeakTime(k)+downst(k);
            % Fit to get tau
            x=[0:1000];
            y=data(PeakTime(k):PeakTime(k)+1000)-mn(k);
            try
                [cf_,goodness]=createExpFit(x,y,[Amp(k),0.1,0]);
            catch
                [cf_,goodness]=createExpFit(x,y,[Amp(k),0.2,0]);
            end
            CF=coeffvalues(cf_);
            if goodness.rsquare<0.9
                goodness.rsquare=NaN;
                CF(2)=NaN;
            end
            % Get width
            EndTime(k)=find(data(PeakTime(k):end)>mn(k),1,'first')+PeakTime(k);
            FinalVals(k,:)=[[RespSt(k)-Del,PeakTime(k)-Del,1./CF(2),EndTime(k)-RespSt(k)]*dt,Amp(k)-data(RespSt(k)),goodness.rsquare,NaN];
            title('pos resp')
        end
        
    else
        FinalVals(k,:)=nan(1,7);
        title('miss trial')
    end
    
    subplot(121)
    plot([-10000:10000]*dt,data)
    hold on
    try
    plot(RespSt(k)*dt-10000*dt,data(RespSt(k)),'r*')
    plot(PeakTime(k)*dt-10000*dt,data(PeakTime(k)),'r*')
    plot(EndTime(k)*dt-10000*dt,data(EndTime(k)),'r*')
    end
    xlim([-0.05 0.1])
    subplot(122)
    plot(x,y)
    hold on
    plot(cf_)
    legend('hide')
    FinalVals(k,end)=input('0=moche, 1=miss,2=bien?');
    %keyboard
    clf
end

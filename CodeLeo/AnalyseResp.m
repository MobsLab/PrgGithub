clear all,close all
addpath(genpath('/Users/mobs/Dropbox/Kteam/PrgMatlab'))
Del=10000;
dt=50*1E-6;
stdtimes=3;
%% Le dossier où il y a les données
FileToUse='/Users/mobs/Documents/analysematlabpharma';
cd(FileToUse)
FileToSave='/Users/mobs/Documents/resultpharma'
fichier=dir;
Titles={'Lat','MaxTime','Tau','Duration','Amp','Der0.5'};

for kk=6 :length(dir)
    
    [d,si,h]=abfload(fichier(kk).name);
    TracesToDo=[];
    str=find(squeeze(d(:,3,1))>1,1,'First');
    if isempty(h.tags)
        TracesToDo=[1:size(d,3)];
    else
        %TracesToDo=find(h.sweepStartInPts*dt<h.tags(1).timeSinceRecStart);
        %TracesToDo=TracesToDo(1:end-1)';
        TracesToDo=[1:h.tags(1).episodeIndex-1];
        for t=1:size(h.tags,2)
            if strcmp(h.tags(t).comment(1:3),'-60')
                if t<size(h.tags,2)
                    TracesToDo=[TracesToDo,[h.tags(t).episodeIndex:h.tags(t+1).episodeIndex-1]];
                else
                    TracesToDo=[TracesToDo,[h.tags(t).episodeIndex:size(d,3)]];
                end
            end
        end
    end
    
    
    %% Make sure we've got the right sweeps
    figure
    a=squeeze(d(:,1,:));
    a=a(:);
    atsd=tsd(linspace(0,length(a)*dt,length(a)),a(:));
    plot(Range(atsd),Data(atsd),'k')
    hold on
    temp=[1:size(d,3)]; temp(TracesToDo)=[];
    a=squeeze(d(:,1,:));
    a(:,temp)=0;    a=a(:);
    atsd=tsd(linspace(0,length(a)*dt,length(a)),a(:));
    plot(Range(atsd),Data(atsd),'r')
    for t=1:size(h.sweepStartInPts,1)
        line([1 1]*h.sweepStartInPts(t)*dt,ylim*0.8)
        text(h.sweepStartInPts(t)*dt,max(a),{num2str(t)},'color','k')
        if ismember(t,TracesToDo)
            text(h.sweepStartInPts(t)*dt,max(a),{num2str(t)},'color','r')
        end
    end
    if not(isempty(h.tags))
        for t=1:size(h.tags,2)
            text(h.tags(t).timeSinceRecStart,min(ylim)*0.9,h.tags(t).comment,'color','b')
        end
    end
    ans=input('Do you agree? 1 or 0')
    while ans==0
        disp(['Current Trials :', num2str(TracesToDo)])
        TracesToDo=input('Please give new trials');
        clf
        a=squeeze(d(:,1,:));
        a=a(:);
        atsd=tsd(linspace(0,length(a)*dt,length(a)),a(:));
        plot(Range(atsd),Data(atsd),'k')
        hold on
        temp=[1:size(d,3)]; temp(TracesToDo)=[];
        a=squeeze(d(:,1,:));
        a(:,temp)=0;    a=a(:);
        atsd=tsd(linspace(0,length(a)*dt,length(a)),a(:));
        plot(Range(atsd),Data(atsd),'r')
        for t=1:size(h.sweepStartInPts,1)
            line([1 1]*h.sweepStartInPts(t)*dt,ylim*0.8,'color','b')
            text(h.sweepStartInPts(t)*dt,max(a),{num2str(t)},'color','k')
            if ismember(t,TracesToDo)
                text(h.sweepStartInPts(t)*dt,max(a),{num2str(t)},'color','r')
            end
        end
        if not(isempty(h.tags))
            for t=1:size(h.tags,2)
                text(h.tags(t).timeSinceRecStart,min(ylim)*0.9,h.tags(t).comment,'color','b')
            end
        end
        ans=input('Do you agree? 1 or 0')
    end
    
    KeepFig=figure;
    %% Go trace by trace
    clear rep st mn data downst RespSt Amp PeakTime EndTime FinalVals
    for k=1:length(TracesToDo)
        k
        subplot(121)
        temprep=runmean(squeeze(d(:,1,TracesToDo(k))),10);
        rep(k,:)=temprep(str-10000:str+10000);  % on prend 0.5s autour de la stim
        st(k)=std(rep(k,1:8000)');
        mn(k)=mean(rep(k,1:8000)');
        data=rep(k,:);
        try
        if not(isempty(find(rep(k,Del:Del+1000)<mn(k)-stdtimes*st(k)))) & abs(min(rep(k,Del:Del+1000))-mn(k))>abs(max(rep(k,Del:Del+1000))-mn(k))
            downst(k)=find(rep(k,Del:end)<mn(k)-stdtimes*st(k),1,'first')+Del;
            deriv=diff(data(downst(k)-200:downst(k)));
            RespSt(k)=downst(k)-(200-find(deriv>0,1,'last'));
            if RespSt(k)<Del,  RespSt(k)=NaN; EndTime(k)=NaN; FinalVals(k,1:8)=nan(1,8);PeakTime(k)=NaN;
                FinalVals(k,8)=0;
                title('problem')
            else
                % Negative peak
                [Amp(k),PeakTime(k)]=min(data(downst(k):downst(k)+1000));
                PeakTime(k)=PeakTime(k)+downst(k);
                
                % Get width
              EndTime(k)=find(data(PeakTime(k):end)>mn(k),1,'first')+PeakTime(k); 
                % Fit to get tau
                x=[0:1000];
                y=data(PeakTime(k):PeakTime(k)+1000)-mn(k);
                try
                    [cf_,goodness]=createExpFit(x,y,[Amp(k)-mn(k),0.1,0]);CF=coeffvalues(cf_);
                catch
                    try,[cf_,goodness]=createExpFit(x,y,[Amp(k)-mn(k),0.2,0]);CF=coeffvalues(cf_);
                    catch
                        goodness.rsquare=0.1;
                    end
                end
                
                if goodness.rsquare<0.9
                    goodness.rsquare=NaN;
                    CF(2)=NaN;
                end
                
                % Get half-rise derivative
                y1=data(find(data(downst(k):PeakTime(k))<(mn(k)-abs(Amp(k)-mn(k))/2),1,'first')+downst(k)-20:...
                    find(data(downst(k):PeakTime(k))<(mn(k)-abs(Amp(k)-mn(k))/2),1,'first')+downst(k)+20);
                FinalVals(k,:)=[[RespSt(k)-Del,PeakTime(k)-Del,1./CF(2),EndTime(k)-RespSt(k)]*dt,Amp(k)-data(RespSt(k)),mean(diff(y1))/dt,goodness.rsquare,NaN];
                title('neg resp')
            end
        elseif not(isempty(find(rep(k,Del:Del+1000)>mn(k)+stdtimes*st(k)))) & abs(min(rep(k,Del:Del+1000))-mn(k))<abs(max(rep(k,Del:Del+1000))-mn(k))
            downst(k)=find(rep(k,Del:end)>mn(k)+stdtimes*st(k),1,'first')+Del;
            deriv=diff(data(downst(k)-200:downst(k)));
            RespSt(k)=downst(k)-(200-find(deriv<0,1,'last'));
            if RespSt(k)<Del,  RespSt(k)=NaN; EndTime(k)=NaN; FinalVals(k,1:8)=nan(1,8);PeakTime(k)=NaN;
                FinalVals(k,8)=0;
                title('problem')
            else
                % Positive peak
                [Amp(k),PeakTime(k)]=max(data(downst(k):downst(k)+1000));
                PeakTime(k)=PeakTime(k)+downst(k);
                % Get width
                EndTime(k)=find(data(PeakTime(k):end)<mn(k),1,'first')+PeakTime(k);
                % Fit to get tau
                x=[0:1000];
                y=data(PeakTime(k):PeakTime(k)+1000)-mn(k);
                try
                    [cf_,goodness]=createExpFit(x,y,[Amp(k)-mn(k),0.1,0]);CF=coeffvalues(cf_);
                catch
                    try,[cf_,goodness]=createExpFit(x,y,[Amp(k)-mn(k),0.2,0]);CF=coeffvalues(cf_);
                    catch
                        goodness.rsquare=0.1;
                    end
                end
                
                if goodness.rsquare<0.9
                    goodness.rsquare=NaN;
                    CF(2)=NaN;
                end
                % Get half-rise derivative
                y1=data(find(data(downst(k):PeakTime(k))>(mn(k)+abs(Amp(k)-mn(k))/2),1,'first')+downst(k)-20:...
                    find(data(downst(k):PeakTime(k))>(mn(k)+abs(Amp(k)-mn(k))/2),1,'first')+downst(k)+20);
                FinalVals(k,:)=[[RespSt(k)-Del,PeakTime(k)-Del,1./CF(2),EndTime(k)-RespSt(k)]*dt,Amp(k)-data(RespSt(k)),mean(diff(y1))/dt,goodness.rsquare,NaN];
                title('pos resp')
            end
            
        else
            FinalVals(k,:)=nan(1,8);                FinalVals(k,8)=0;
            disp('miss trial')
        end
        catch
           disp('failed trial')
           FinalVals(k,1:8)=nan(1,8);
        end
        
        subplot(121)
        plot([-10000:10000]*dt,data)
        xlim([-0.05 0.3])
        hold on
        try
            plot(RespSt(k)*dt-10000*dt,data(RespSt(k)),'r*')
            plot(PeakTime(k)*dt-10000*dt,data(PeakTime(k)),'r*')
            plot(EndTime(k)*dt-10000*dt,data(EndTime(k)),'r*')
            subplot(122)
            plot(x,y)
            hold on
            plot(cf_)
        end
        legend('hide')
        ans=input('Do by hand? 1/0');
        if ans==1
            figtemp=figure('Position',[500 500 1000 1000]);
            plot(data), hold on
            line([10000 10000],ylim)
            % moment où il faut cliquer  --> xlim à changer
            xlim([9500 20000])
            [x,y]=ginput(3);
            RespSt(k)=round(x(1));
            downst(k)=RespSt(k)+20;
            PeakTime(k)=round(x(2));
            EndTime(k)=round(x(3));
            Amp(k)=y(2);
            % Fit to get tau
            x=[0:1000];
            y=data(PeakTime(k):PeakTime(k)+1000)-mn(k);
               try
                    [cf_,goodness]=createExpFit(x,y,[Amp(k)-mn(k),0.1,0]);CF=coeffvalues(cf_);
                catch
                    try,[cf_,goodness]=createExpFit(x,y,[Amp(k)-mn(k),0.2,0]);CF=coeffvalues(cf_);
                    catch
                        goodness.rsquare=0.1;
                    end
               end
                
                
      
            if goodness.rsquare<0.9
                goodness.rsquare=NaN;
                CF(2)=NaN;
            end
            % Get half-rise derivative
            if Amp(k)>mn(k)
                y1=data(find(data(downst(k):PeakTime(k))>(mn(k)+abs(Amp(k)-mn(k))/2),1,'first')+downst(k)-20:...
                    find(data(downst(k):PeakTime(k))>(mn(k)+abs(Amp(k)-mn(k))/2),1,'first')+downst(k)+20);
            else
                y1=data(find(data(downst(k):PeakTime(k))<(mn(k)-abs(Amp(k)-mn(k))/2),1,'first')+downst(k)-20:...
                    find(data(downst(k):PeakTime(k))<(mn(k)-abs(Amp(k)-mn(k))/2),1,'first')+downst(k)+20);
            end
            FinalVals(k,:)=[[RespSt(k)-Del,PeakTime(k)-Del,1./CF(2),EndTime(k)-RespSt(k)]*dt,Amp(k)-data(RespSt(k)),mean(diff(y1))/dt,goodness.rsquare,NaN];
            close(figtemp)
        end
        
        figure(KeepFig)
        subplot(121)
        plot([-10000:10000]*dt,data)
        xlim([-0.05 0.2])
        hold on
        try
            plot(RespSt(k)*dt-10000*dt,data(RespSt(k)),'g*')
            plot(PeakTime(k)*dt-10000*dt,data(PeakTime(k)),'g*')
            plot(EndTime(k)*dt-10000*dt,data(EndTime(k)),'g*')
            subplot(122)
            plot(x,y)
            hold on
            plot(cf_,'g')
            legend('hide')
        end
        
        FinalVals(k,end)=input('0=moche, 1=miss,2=bien?');
        %keyboard
        clf
    end
    
    % Do same on average traces
    AllResp=runmean(squeeze(d(:,1,TracesToDo(FinalVals(:,end)==2))),10);
    AllResp=mean(AllResp');
    AllResp=AllResp(str-10000:str+10000);  % on prend 0.5s autour de la stim
    mnval=mean(AllResp(1:8000)');
    stval=std((AllResp(1:8000)));
    data=AllResp;
    if abs(min(AllResp(Del:Del+1000))-mn(k))>abs(max(AllResp(Del:Del+1000))-mn(k))
        downstval=find(AllResp(Del:end)<(mnval-stdtimes*stval),1,'first')+Del;
        deriv=diff(data(downstval-200:downstval));
        RespStval=downstval-(200-find(deriv>0,1,'last'));
        if RespStval<Del,  RespStval=NaN; EndTimeVal=NaN; FinalVals(end+1,:)=nan(1,7);PeakTimeval=NaN;
            FinalVals(end,7)=0;
            title('problem')
        else
            % Negative peak
            [Ampval,PeakTimeVal]=min(data(downstval:downstval+1000));
            PeakTimeVal=PeakTimeVal+downstval;
            % Get width
            EndTimeVal=find(data(PeakTimeVal:end)>mnval-stval,1,'first')+PeakTimeVal;
            % Fit to get tau
            x=[0:1000];
            y=data(PeakTimeVal:PeakTimeVal+1000)-mnval;
               try
                    [cf_,goodness]=createExpFit(x,y,[Ampval-mnval,0.1,0]);CF=coeffvalues(cf_);
                catch
                    try,[cf_,goodness]=createExpFit(x,y,[Ampval-mnval,0.2,0]);CF=coeffvalues(cf_);
                   catch
                        goodness.rsquare=0.1;
                    end
                end
                
            if goodness.rsquare<0.9
                goodness.rsquare=NaN;
                CF(2)=NaN;
            end
            % Get half-rise derivative
            y1=data(find(data(downstval:PeakTimeVal)<(mnval-abs(Ampval-mnval)/2),1,'first')+downstval-20:...
                find(data(downstval:PeakTimeVal)<(mnval-abs(Ampval-mnval)/2),1,'first')+downstval+20);
            FinalVals(end+1,:)=[[RespStval-Del,PeakTimeVal-Del,1./CF(2),EndTimeVal-RespStval]*dt,Ampval-data(RespStval),mean(diff(y1))/dt,goodness.rsquare,99];
        end
    else
        downstval=find(AllResp(Del:end)>mnval+3*stval,1,'first')+Del;
        deriv=diff(data(downstval-200:downstval));
        RespStval=downstval-(200-find(deriv<0,1,'last'));
        if RespStval<Del,  RespStval=NaN; EndTimeVal=NaN; FinalVals(end+1,:)=nan(1,7);PeakTimeval=NaN;
            FinalVals(end,7)=0;
            title('problem')
        else
            % Positive peak
            [Ampval,PeakTimeVal]=max(data(downstval:downstval+1000));
            PeakTimeVal=PeakTimeVal+downstval;
            % Get width
            EndTimeVal=find(data(PeakTimeVal:end)<mnval+stval,1,'first')+PeakTimeVal;
            % Fit to get tau
            x=[0:1000];
            y=data(PeakTimeVal:PeakTimeVal+1000);
            y=data(PeakTimeVal:PeakTimeVal+1000)-mnval;
               try
                    [cf_,goodness]=createExpFit(x,y,[Ampval-mnval,0.1,0]);CF=coeffvalues(cf_);
                catch
                    try,[cf_,goodness]=createExpFit(x,y,[Ampval-mnval,0.2,0]);CF=coeffvalues(cf_);
                   catch
                        goodness.rsquare=0.1;
                    end
                end
            if goodness.rsquare<0.9
                goodness.rsquare=NaN;
                CF(2)=NaN;
            end
            % Get half-rise derivative
            y1=data(find(data(downstval:PeakTimeVal)>(mnval+abs(Ampval-mnval)/2),1,'first')+downstval-20:...
                find(data(downstval:PeakTimeVal)>(mnval+abs(Ampval-mnval)/2),1,'first')+downstval+20);
            FinalVals(end+1,:)=[[RespStval-Del,PeakTimeVal-Del,1./CF(2),EndTimeVal-RespStval]*dt,Ampval-data(RespStval),mean(diff(y1))/dt,goodness.rsquare,99];
        end
        
    end
    
    save([FileToSave filesep fichier(kk).name(1:end-4),'Results.mat'],'FinalVals')
    
    fig=figure;
    subplot(2,5,1:5)
    plot([-10000:10000]*dt,data)
    xlim([-0.1 0.2])
    hold on
    line([0 0.005],[1 1]*abs(max(ylim))*1.1*sign(max(ylim)),'color','c','linewidth',4)
    plot(RespStval*dt-10000*dt,data(RespStval),'r*')
    plot(PeakTimeVal*dt-10000*dt,data(PeakTimeVal),'r*')
    plot(EndTimeVal*dt-10000*dt,data(EndTimeVal),'r*')
    for q=1:6
        subplot(2,6,q+6)
        plotSpread(FinalVals(find(FinalVals(:,end)==2),q),'distributionColors',[0.6 0.6 0.6],'showMM',4)
        hold on
        line([0.5 1.5],[1 1]*(FinalVals(end,q)),'color','k','linewidth',3)
        errorbar(0,mean(FinalVals(find(FinalVals(:,end)==2),q)),stdError(FinalVals(find(FinalVals(:,end)==2),q)),'k')
        title(Titles{q})
    end
    saveas(fig,[FileToSave filesep fichier(kk).name(1:end-4),'Results.fig'])
    saveas(fig,[FileToSave filesep fichier(kk).name(1:end-4),'Results.png'])
    close all
    clear FinalVals PeakTime RespSt EndTime
end



clear all, close all
m=1;
filename2{m}='/media/DataMOBSSlSc/SleepScoringMice/M60/20130415/';
m=2;
filename2{m}='/media/DataMOBSSlSc/SleepScoringMice/M82/20130730/';
m=3;
filename2{m}='/media/DataMOBSSlSc/SleepScoringMice/M83/20130729/';
m=4;
filename2{m}='/media/DataMOBSSlSc/SleepScoringMice/M123/LPSD1/';
m=5;
filename2{m}='/media/DataMOBSSlSc/SleepScoringMice/M51/09112012/';
m=6;
filename2{m}='/media/DataMOBSSlSc/SleepScoringMice/M61/20130415/';
m=7;
filename2{m}='/media/DataMOBSSlSc/SleepScoringMice/M147/';
m=8;
filename2{m}='/media/DataMOBSSlSc/SleepScoringMice/M148/20140828/';
m=9;
filename2{m}='/media/DataMOBSSlSc/SleepScoringMice/M243/01042015/';
m=10;
filename2{m}='/media/DataMOBSSlSc/SleepScoringMice/M244/09042015/';
m=11;
filename2{m}='/media/DataMOBSSlSc/SleepScoringMice/M251/21052015/';
m=12;
filename2{m}='/media/DataMOBSSlSc/SleepScoringMice/M252/21052015/';
m=13;
filename2{m}='/media/DataMOBSSlSc/SleepScoringMice/M177178/M177178-Sleep-22102014/M178/';

for mm=1:m
    mm
    cd(filename2{mm})
    load('StateEpochSB.mat')
    t=Range(smooth_ghi);
    GhiSubSample=(Restrict(smooth_ghi,ts(t)));
    ThetaSubSample=(Restrict(smooth_Theta,ts(t)));
    dt=median(diff(t))/1e4;

    
    %% Look at speed relative to position
    
    nn=1;
    for y=[1,50,100,600,1200,2400]
        t=Range(smooth_ghi);
        t=t(1:y:end);
        GhiSubSample=(Restrict(smooth_ghi,ts(t)));
        ThetaSubSample=(Restrict(smooth_Theta,ts(t)));
        gammadata=Data(GhiSubSample);
        thetadata=Data(ThetaSubSample);
        SpeedGamma{nn}=sqrt((gammadata(2:end)-gammadata(1:end-1)).^2);
        SpeedTheta{nn}=sqrt((thetadata(2:end)-thetadata(1:end-1)).^2);
        nn=nn+1;
    end
    
    %% Look at time to next transition
    ListTransitions=sort(unique([0;Start(SWSEpoch);Stop(SWSEpoch);Start(REMEpoch);Stop(REMEpoch);Start(Wake);Stop(Wake);max(t)]));
    DisttoTrans1=[];DisttoTrans2=[];
    for l=1:length(ListTransitions)-1
        DisttoTrans1=[DisttoTrans1;abs(t(find(t>ListTransitions(l) & t<ListTransitions(l+1)))-ListTransitions(l+1))];
        DisttoTrans2=[DisttoTrans2;abs(t(find(t>ListTransitions(l) & t<ListTransitions(l+1)))-ListTransitions(l))];
    end
    
    save('TransitionInfo.mat','DisttoTrans1','DisttoTrans2','SpeedGamma','SpeedTheta')
    clear DisttoTrans1 DisttoTrans2 SpeedGamma SpeedTheta Ddist
end

% 
% %% Get all diffusion curves
% 
% for mm=1:m
%     mm
%     cd(filename2{mm})
%     load('StateEpochSB.mat')
%     t=Range(smooth_ghi);
%     GhiSubSample=(Restrict(smooth_ghi,ts(t)));
%     ThetaSubSample=(Restrict(smooth_Theta,ts(t)));
%     a=[Coeff{1,:}]; a=a(2:2:end);
%     dt=median(diff(t))/1e4;
%     
%     
%     %% Look at diffusion coefficient
%     clear Ddist
%     for k=1:length(Start(Wake))
%         temp1=Data(Restrict(GhiSubSample,subset(Wake,k)));
%         temp2=Data(Restrict(ThetaSubSample,subset(Wake,k)));
%         if length(temp)*dt>10
%             midtemp=ceil(length(temp)/2);
%             try,Ddist{1}(k,:)=(temp1(midtemp-3/dt:midtemp+3/dt)-temp1(1)).^2+(temp2(midtemp-3/dt:midtemp+3/dt)-temp2(1)).^2; end
%         end
%     end
%     
% end


%% To execute
for mm=1:m
    mm
    cd(filename2{mm})
     load('Maps.mat')
    load('StateEpochSB.mat')
    AvSWS=[median(Stop(SWSEpoch)-Start(SWSEpoch))/1e4];
    AvRem=[median(Stop(REMEpoch)-Start(REMEpoch))/1e4];
    AvWake=[median(Stop(Wake)-Start(Wake))/1e4];
    
    MatX=[-0.7:3.2/99:2.5];
    MatY=[-1.5:3.5/99:2];
    t=Range(smooth_ghi);
    t=t(1:10:end);
    GhiSubSample=(Restrict(smooth_ghi,ts(t)));
    ThetaSubSample=(Restrict(smooth_Theta,ts(t)));
    gammadata=log(Data(GhiSubSample))-nanmean(log(Data(Restrict(smooth_ghi,SWSEpoch))));
    thetadata=log(Data(ThetaSubSample))-nanmean(log(Data(Restrict(smooth_Theta,SWSEpoch))));
    gammorig=Data(GhiSubSample);    thetorig=Data(ThetaSubSample);
    for xx=1:length(MatX)-1
        xx
        for yy=1:length(MatY)-1
            datpoints=find(gammadata<MatX(xx+1) & gammadata>MatX(xx) & thetadata<MatY(yy+1) & thetadata>MatY(yy));
            if isempty(datpoints)
                Val(xx,yy)=NaN;Val2(xx,yy)=NaN;Val3(xx,yy)=NaN;Val4(xx,yy)=NaN;Val5(xx,yy)=NaN;
                Val6(xx,yy)=NaN;Val7(xx,yy)=NaN;
            else
                Val(xx,yy)=nanmean(SpeedGamma(datpoints)/mean(gammorig(datpoints)))+nanmean(SpeedTheta(datpoints)/mean(thetorig(datpoints)));
                Val2(xx,yy)=nanmean(DisttoTrans1(datpoints));
                Val3(xx,yy)=nanmean(DisttoTrans2(datpoints));
                Val4(xx,yy)=nanmean(SpeedGamma(datpoints)/mean(gammorig(datpoints)));
                Val5(xx,yy)=nanmean(SpeedTheta(datpoints)/mean(thetorig(datpoints)));
                
                if MatX(xx)>log(gamma_thresh)-nanmean(log(Data(Restrict(smooth_ghi,SWSEpoch))))
                    Val6(xx,yy)=nanmean(DisttoTrans1(datpoints))/AvWake;
                    Val7(xx,yy)=nanmean(DisttoTrans2(datpoints))/AvWake;
                else
                    if MatY(yy)>log(theta_thresh)-nanmean(log(Data(Restrict(smooth_Theta,SWSEpoch))))
                        Val6(xx,yy)=nanmean(DisttoTrans1(datpoints))/AvRem;
                        Val7(xx,yy)=nanmean(DisttoTrans2(datpoints))/AvRem;
                    else
                        Val6(xx,yy)=nanmean(DisttoTrans1(datpoints))/AvSWS;
                        Val7(xx,yy)=nanmean(DisttoTrans2(datpoints))/AvSWS;
                    end
                    
                end
                
            end
        end
        
    end
    save Maps.mat Val Val2 Val3 Val4 Val5 Val6 Val7
    clear Val Val2 Val3 Val4 Val5 Val6 Val7

end


%%% Look at different sampling for speed

%% To execute
SamplDT=[1,50,100,600,1200,2400];
MatX=[-0.7:3.2/99:2.5];
MatY=[-1.5:3.5/99:2];
for mm=1:m
    mm
    cd(filename2{mm})
    load('StateEpochSB.mat')
    load('TransitionInfo.mat')
    for ss=1:length(SamplDT)
        ss
        t=Range(smooth_ghi);
        t=t(1:SamplDT(ss):end);
        GhiSubSample=(Restrict(smooth_ghi,ts(t)));
        ThetaSubSample=(Restrict(smooth_Theta,ts(t)));
        gammadata=log(Data(GhiSubSample))-nanmean(log(Data(Restrict(smooth_ghi,SWSEpoch))));
        thetadata=log(Data(ThetaSubSample))-nanmean(log(Data(Restrict(smooth_Theta,SWSEpoch))));
        gammorig=Data(GhiSubSample);    thetorig=Data(ThetaSubSample);
        for xx=1:length(MatX)-1
            
            for yy=1:length(MatY)-1
                datpoints=find(gammadata<MatX(xx+1) & gammadata>MatX(xx) & thetadata<MatY(yy+1) & thetadata>MatY(yy));
                datpoints(datpoints==size(SpeedGamma{ss},1)+1)=[];
                if isempty(datpoints)
                    Val1{mm,ss}(xx,yy)=NaN;Val2{mm,ss}(xx,yy)=NaN;
                else
                    Val1{mm,ss}(xx,yy)=nanmean(SpeedGamma{ss}(datpoints)/mean(gammorig(datpoints)));
                    Val2{mm,ss}(xx,yy)=nanmean(SpeedTheta{ss}(datpoints)/mean(thetorig(datpoints)));
                end
            end
        end
    end
end
save(['/media/DataMOBSSlSc/SleepScoringMice/AnalysisResults/','SpeedMaps.mat'],'Val1','Val2')

for ss=1:
temp=zeros(99,99);
for mm=1:m
        cd(filename2{mm})
    load('Maps.mat')
    for xx=1:99
        for yy=1:99
            temp(xx,yy)=nansum([temp(xx,yy),Val7(xx,yy)/nansum(Val7(:))],2);
        end
    end
end
figure
subplot(121)
imagesc(MatX,MatY,temp'), axis xy
for xx=1:99
    temp(xx,:)=runmean(temp(xx,:),1);
end
for yy=1:99
    temp(:,yy)=runmean(temp(:,yy),1);
end
subplot(122)
imagesc(MatX,MatY,temp'), axis xy
end



%% To execute
SamplDT=[1,50,100,600,1200,2400];
MatX=[-0.7:3.2/99:2.5];
MatY=[-1.5:3.5/99:2];
for mm=1:m
    mm
    cd(filename2{mm})
    load('StateEpochSB.mat')
    load('TransitionInfo.mat')
    for j=1:3
        if j==1
            EpToUse=SWSEpoch;
            EpToUse=intervalSet(Start(EpToUse),Stop(EpToUse)+2.9*1e4);
            EpToUse=DropShortIntervals(EpToUse,1)

        elseif j==2
            EpToUse=REMEpoch;
            EpToUse=intervalSet(Start(EpToUse),Stop(EpToUse)+2.9*1e4);
            EpToUse=DropShortIntervals(EpToUse,1)
        elseif j==3
            EpToUse=Wake;
            EpToUse=DropShortIntervals(EpToUse,1);
            EpToUse=MergeCloseIntervals(EpToUse,1);                      
            EpToUse=intervalSet(Start(EpToUse),Stop(EpToUse)+2.9*1e4);
            EpToUse=DropShortIntervals(EpToUse,1);
            EpToUse=MergeCloseIntervals(EpToUse,1);                       
        end
        
        for ss=4:6
            ss
            t=Range(smooth_ghi);
            t=t(1:SamplDT(ss):end);
            GhiSubSample=(Restrict(smooth_ghi,ts(t)));
            ThetaSubSample=(Restrict(smooth_Theta,ts(t)));
            gammadata=log(Data(GhiSubSample))-nanmean(log(Data(Restrict(smooth_ghi,SWSEpoch))));
            thetadata=log(Data(ThetaSubSample))-nanmean(log(Data(Restrict(smooth_Theta,SWSEpoch))));
            
            rgtouse=Range(GhiSubSample);
            rgtouse=rgtouse(1:end-1);
            gammDat=tsd(rgtouse,gammadata(1:end-1));
            thetDat=tsd(rgtouse,thetadata(1:end-1));
            SpeedGammatsd=tsd(rgtouse,SpeedGamma{ss});
            SpeedThetatsd=tsd(rgtouse,SpeedTheta{ss});
            gammDat=Restrict(gammDat,EpToUse);
            thetDat=Restrict(thetDat,EpToUse);
            t=Range(gammDat);
            
            SpeedGammatsd=Restrict(SpeedGammatsd,ts(t));
            SpeedThetatsd=Restrict(SpeedThetatsd,ts(t));
            SpeedGamma1{ss}=Data(SpeedGammatsd);
            SpeedTheta1{ss}=Data(SpeedThetatsd);
            gammadata=Data(gammDat);thetadata=Data(thetDat);
            gammorig=Data(Restrict(GhiSubSample,ts(t)));    thetorig=Data(Restrict(ThetaSubSample,ts(t)));
            
            for xx=1:length(MatX)-1
                
                for yy=1:length(MatY)-1
                    datpoints=find(gammadata<MatX(xx+1) & gammadata>MatX(xx) & thetadata<MatY(yy+1) & thetadata>MatY(yy));
                    datpoints(datpoints==size(SpeedGamma{ss},1)+1)=[];
                    if isempty(datpoints)
                        Val1{mm,ss,j}(xx,yy)=NaN;Val2{mm,ss,j}(xx,yy)=NaN;
                    else
                        Val1{mm,ss,j}(xx,yy)=nanmean(SpeedGamma1{ss}(datpoints)/mean(gammorig(datpoints)));
                        Val2{mm,ss,j}(xx,yy)=nanmean(SpeedTheta1{ss}(datpoints)/mean(thetorig(datpoints)));
                    end
                end
            end
        end
        
    end
end

save(['/media/DataMOBSSlSc/SleepScoringMice/AnalysisResults/','SpeedMaps',num2str(j),'.mat'],'Val1','Val2')
load(['/media/DataMOBSSlSc/SleepScoringMice/AnalysisResults/','SpeedMaps.mat'],'Val1','Val2')

for j=1
    for ss=3
        temp=zeros(99,99);
        for mm=1:m-1
            for xx=1:99
                for yy=1:99
temp(xx,yy)=nansum([temp(xx,yy),Val1{mm,ss,j}(xx,yy)/nansum(Val1{mm,ss,j}(:))],2);                end
            end
        end
        figure
        subplot(121)
        imagesc(MatX,MatY,temp'), axis xy
        for xx=1:99
            temp(xx,:)=runmean(temp(xx,:),1);
        end
        for yy=1:99
            temp(:,yy)=runmean(temp(:,yy),1);
        end
        subplot(122)
        imagesc(MatX,MatY,temp'), axis xy
    end
end







clear all, close all

%% Get all diffusion curves

DiffDurTimes=4; % duratio of period to consider
dt=0.0008;
cd('/media/nas7/React_Passive_AG/OBG/Labneh/freely-moving/20221221_long')

load('StateEpochSB.mat')
t=Range(smooth_ghi);
REMEpoch = and(Sleep,Epoch_01_05);
SWSEpoch = and(Sleep,Epoch-Epoch_01_05);

GhiSubSample=(Restrict(smooth_ghi,ts(t)));
ThetaSubSample=(Restrict(smooth_01_05,ts(t)));
DelGhi{1,1}=max(Data(Restrict(GhiSubSample,Wake)))-min(Data(Restrict(GhiSubSample,Wake))); 
DelTheta{1,1}=max(Data(Restrict(ThetaSubSample,Wake)))-min(Data(Restrict(ThetaSubSample,Wake)));

DelGhi{2,1}=max(Data(Restrict(GhiSubSample,Wake)))-min(Data(Restrict(GhiSubSample,SWSEpoch)));
DelTheta{2,1}=max(Data(Restrict(ThetaSubSample,Wake)))-min(Data(Restrict(ThetaSubSample,SWSEpoch)));

DelGhi{3,1}=max(Data(Restrict(GhiSubSample,Wake)))-min(Data(Restrict(GhiSubSample,REMEpoch)));
DelTheta{3,1}=max(Data(Restrict(ThetaSubSample,Wake)))-min(Data(Restrict(ThetaSubSample,REMEpoch)));

DelGhi{1,2}=max(Data(Restrict(GhiSubSample,Wake)))-min(Data(Restrict(GhiSubSample,Wake)));
DelTheta{1,2}=max(Data(Restrict(ThetaSubSample,Wake)))-min(Data(Restrict(ThetaSubSample,Wake)));

DelGhi{2,2}=max(Data(Restrict(GhiSubSample,Wake)))-min(Data(Restrict(GhiSubSample,SWSEpoch)));
DelTheta{2,2}=max(Data(Restrict(ThetaSubSample,Wake)))-min(Data(Restrict(ThetaSubSample,SWSEpoch)));

DelGhi{3,2}=max(Data(Restrict(GhiSubSample,Wake)))-min(Data(Restrict(GhiSubSample,REMEpoch)));
DelTheta{3,2}=max(Data(Restrict(ThetaSubSample,Wake)))-min(Data(Restrict(ThetaSubSample,REMEpoch)));

%% Look at diffusion coefficient at heart of Epoch
%Wake
disp('wake')
num=1;
for k=1:length(Start(Wake))
    Duration=(Stop(subset(Wake,k))-Start(subset(Wake,k)))/1e4;
    if Duration>2*3+DiffDur
        StrtTime=Start(subset(Wake,k));
        NumWindows=floor((Duration-(2*3))-DiffDur+1);
        DataToUse=[ceil(NumWindows/2)-10:ceil(NumWindows/2)+9];
        if sum(DataToUse<0)+sum(DataToUse>NumWindows)>0
            DataToUse=[1:NumWindows];
        end
        for nn=DataToUse
            tempG=Data(Restrict(GhiSubSample,intervalSet(StrtTime+(nn-1)*1e4,StrtTime+(DiffDur+nn-1)*1e4)));
            tempT=Data(Restrict(ThetaSubSample,intervalSet(StrtTime+(nn-1)*1e4,StrtTime+(DiffDur+nn-1)*1e4)));
            
            if size(tempG,1)==normaldur
                GammDisp{1}(num,:)=(tempG-tempG(1)).^2;
                ThetDisp{1}(num,:)=(tempT-tempT(1)).^2;
                num=num+1;
            end
        end
    end
end

%SWS
disp('SWS')
num=1;
for k=1:length(Start(SWSEpoch))
    Duration=(Stop(subset(SWSEpoch,k))-Start(subset(SWSEpoch,k)))/1e4;
    if Duration>2*3+DiffDur
        StrtTime=Start(subset(SWSEpoch,k));
        NumWindows=floor((Duration-(2*3))-DiffDur+1);
        DataToUse=[ceil(NumWindows/2)-10:ceil(NumWindows/2)+9];
        if sum(DataToUse<0)+sum(DataToUse>NumWindows)>0
            DataToUse=[1:NumWindows];
        end
        for nn=DataToUse
            tempG=Data(Restrict(GhiSubSample,intervalSet(StrtTime+(nn-1)*1e4,StrtTime+(DiffDur+nn-1)*1e4)));
            tempT=Data(Restrict(ThetaSubSample,intervalSet(StrtTime+(nn-1)*1e4,StrtTime+(DiffDur+nn-1)*1e4)));
            if size(tempG,1)==normaldur
                GammDisp{2}(num,:)=(tempG-tempG(1)).^2;
                ThetDisp{2}(num,:)=(tempT-tempT(1)).^2;
                num=num+1;
            end
        end
    end
end


%REM
disp('REM')
num=1;
for k=1:length(Start(REMEpoch))
    Duration=(Stop(subset(REMEpoch,k))-Start(subset(REMEpoch,k)))/1e4;
    if Duration>2*3+DiffDur
        StrtTime=Start(subset(REMEpoch,k));
        NumWindows=floor((Duration-(2*3))-DiffDur+1);
        DataToUse=[ceil(NumWindows/2)-10:ceil(NumWindows/2)+9];
        if sum(DataToUse<0)+sum(DataToUse>NumWindows)>0
            DataToUse=[1:NumWindows];
        end
        for nn=DataToUse
            tempG=Data(Restrict(GhiSubSample,intervalSet(StrtTime+(nn-1)*1e4,StrtTime+(DiffDur+nn-1)*1e4)));
            tempT=Data(Restrict(ThetaSubSample,intervalSet(StrtTime+(nn-1)*1e4,StrtTime+(DiffDur+nn-1)*1e4)));
            if size(tempG,1)==normaldur
                GammDisp{3}(num,:)=(tempG-tempG(1)).^2;
                ThetDisp{3}(num,:)=(tempT-tempT(1)).^2;
                num=num+1;
            end
        end
    end
end


%% Now look specifically at transitions
% Wake and SWS
[aft_cell,bef_cell]=transEpoch(SWSEpoch,Wake);
NumWindows=DiffDur+1;
%W--S
disp('wake-->sleep')
LengthAfter=(Stop(bef_cell{1,2})-Start(bef_cell{1,2}))/1e4;
LengthBefore=(Stop(aft_cell{2,1})-Start(aft_cell{2,1}))/1e4;
Transitions=Start(bef_cell{1,2});
num=1;
for k=1:length(Start(bef_cell{1,2}))
    if LengthAfter(k)>3+DiffDur & LengthBefore(k)>3+DiffDur
        TransTime=Transitions(k);
        for nn=1:NumWindows
            tempG=Data(Restrict(GhiSubSample,intervalSet(TransTime-(DiffDur-nn+1)*1e4,TransTime+(nn-1)*1e4)));
            tempT=Data(Restrict(ThetaSubSample,intervalSet(TransTime-(DiffDur-nn+1)*1e4,TransTime+(nn-1)*1e4)));
            if size(tempG,1)==normaldur
                GammDisp{4}(num,:)=(tempG-tempG(1)).^2;
                ThetDisp{4}(num,:)=(tempT-tempT(1)).^2;
                num=num+1;
            end
        end
    end
end

NumWindows=DiffDur+1;
%S--W
disp('sleep-->wake')
LengthAfter=(Stop(bef_cell{2,1})-Start(bef_cell{2,1}))/1e4;
LengthBefore=(Stop(aft_cell{1,2})-Start(aft_cell{1,2}))/1e4;
Transitions=Start(bef_cell{2,1});
num=1;
for k=1:length(Start(bef_cell{2,1}))
    if LengthAfter(k)>3+DiffDur & LengthBefore(k)>3+DiffDur
        TransTime=Transitions(k);
        for nn=1:NumWindows
            tempG=Data(Restrict(GhiSubSample,intervalSet(TransTime-(DiffDur-nn+1)*1e4,TransTime+(nn-1)*1e4)));
            tempT=Data(Restrict(ThetaSubSample,intervalSet(TransTime-(DiffDur-nn+1)*1e4,TransTime+(nn-1)*1e4)));
            if size(tempG,1)==normaldur
                GammDisp{5}(num,:)=(tempG-tempG(1)).^2;
                ThetDisp{5}(num,:)=(tempT-tempT(1)).^2;
                num=num+1;
            end
        end
    end
end


% Wake and REM
[aft_cell,bef_cell]=transEpoch(REMEpoch,Wake);
NumWindows=DiffDur+1;
% R-W
disp('REM-->wake')
LengthAfter=(Stop(bef_cell{2,1})-Start(bef_cell{2,1}))/1e4;
LengthBefore=(Stop(aft_cell{1,2})-Start(aft_cell{1,2}))/1e4;
Transitions=Start(bef_cell{2,1});
num=1;
for k=1:length(Start(bef_cell{2,1}))
    if LengthAfter(k)>3+DiffDur & LengthBefore(k)>3+DiffDur
        TransTime=Transitions(k);
        for nn=1:NumWindows
            tempG=Data(Restrict(GhiSubSample,intervalSet(TransTime-(DiffDur-nn+1)*1e4,TransTime+(nn-1)*1e4)));
            tempT=Data(Restrict(ThetaSubSample,intervalSet(TransTime-(DiffDur-nn+1)*1e4,TransTime+(nn-1)*1e4)));
            if size(tempG,1)==normaldur
                GammDisp{6}(num,:)=(tempG-tempG(1)).^2;
                ThetDisp{6}(num,:)=(tempT-tempT(1)).^2;
                num=num+1;
            end
        end
    end
end


% REM and SWS
[aft_cell,bef_cell]=transEpoch(SWSEpoch,REMEpoch);
NumWindows=DiffDur+1;
%R--S
disp('REM-->sleep')
LengthAfter=(Stop(bef_cell{1,2})-Start(bef_cell{1,2}))/1e4;
LengthBefore=(Stop(aft_cell{2,1})-Start(aft_cell{2,1}))/1e4;
Transitions=Start(bef_cell{1,2});
num=1;
for k=1:length(Start(bef_cell{1,2}))
    if LengthAfter(k)>3+DiffDur & LengthBefore(k)>3+DiffDur
        TransTime=Transitions(k);
        for nn=1:NumWindows
            tempG=Data(Restrict(GhiSubSample,intervalSet(TransTime-(DiffDur-nn+1)*1e4,TransTime+(nn-1)*1e4)));
            tempT=Data(Restrict(ThetaSubSample,intervalSet(TransTime-(DiffDur-nn+1)*1e4,TransTime+(nn-1)*1e4)));
            if size(tempG,1)==normaldur
                GammDisp{7}(num,:)=(tempG-tempG(1)).^2;
                ThetDisp{7}(num,:)=(tempT-tempT(1)).^2;
                num=num+1;
            end
        end
    end
end

NumWindows=DiffDur+1;
%S--R
disp('sleep-->REM')
LengthAfter=(Stop(bef_cell{2,1})-Start(bef_cell{2,1}))/1e4;
LengthBefore=(Stop(aft_cell{1,2})-Start(aft_cell{1,2}))/1e4;
Transitions=Start(bef_cell{2,1});
num=1;
for k=1:length(Start(bef_cell{2,1}))
    if LengthAfter(k)>3+DiffDur & LengthBefore(k)>3+DiffDur
        TransTime=Transitions(k);
        for nn=1:NumWindows
            tempG=Data(Restrict(GhiSubSample,intervalSet(TransTime-(DiffDur-nn+1)*1e4,TransTime+(nn-1)*1e4)));
            tempT=Data(Restrict(ThetaSubSample,intervalSet(TransTime-(DiffDur-nn+1)*1e4,TransTime+(nn-1)*1e4)));
            if size(tempG,1)==normaldur
                GammDisp{8}(num,:)=(tempG-tempG(1)).^2;
                ThetDisp{8}(num,:)=(tempT-tempT(1)).^2;
                num=num+1;
            end
        end
    end
end
save(strcat('DisplacementMeasure',num2str(DiffDur),'Part1.mat'),'GammDisp','ThetDisp','DelGhi','DelTheta','-v7.3')
clear GammDisp ThetDisp


%% Cover Sleep to Wake transition in both directions
[aft_cell,bef_cell]=transEpoch(SWSEpoch,Wake);
% Start(bef_cell{1,2}) ---> beginning of all SWS that is preceded by Wake
% (W-->S)
%Start(bef_cell{2,1})---> beginning of all Wake  that is preceded by SWS
%(S-->W)

num=1;
MinDur=15;
EpToUse=bef_cell{1,2};
EpToUse2=aft_cell{2,1};
NumWindowsLg=(MinDur-3)*2-(DiffDur)+1;
for k=1:length(Start(EpToUse))
    Duration=(Stop(subset(EpToUse,k))-Start(subset(EpToUse,k)))/1e4;
    Duration1=(Stop(subset(EpToUse2,k))-Start(subset(EpToUse2,k)))/1e4;
    if Duration>MinDur & Duration1>MinDur
        StrtTime=Start(subset(EpToUse,k));
        NumWindows=((MinDur-3)*2-(DiffDur)+1)*10;
        for nn=1:NumWindows
            tempG=Data(Restrict(GhiSubSample,intervalSet(StrtTime+(-(MinDur-3)+(nn-1)*0.1)*1e4,StrtTime+(-(MinDur-3)+(nn-1)*0.1+DiffDur)*1e4)));
            tempT=Data(Restrict(ThetaSubSample,intervalSet(StrtTime+(-(MinDur-3)+(nn-1)*0.1)*1e4,StrtTime+(-(MinDur-3)+(nn-1)*0.1+DiffDur)*1e4)));
            if size(tempG,1)==normaldur
                GammDisp(num,:)=(tempG-tempG(1)).^2;
                ThetDisp(num,:)=(tempT-tempT(1)).^2;
                num=num+1;
            else
                GammDisp(num,:)=nan(1,normaldur);
                ThetDisp(num,:)=nan(1,normaldur);
                num=num+1;
            end
        end
    end
end
save(strcat('DisplacementMeasure',num2str(DiffDur),'Part2.mat'),'GammDisp','ThetDisp','NumWindowsLg','-v7.3')
clear GammDisp ThetDisp


num=1;
MinDur=10;
NumWindowsSh=(MinDur-3)*2-(DiffDur)+1;
EpToUse=bef_cell{1,2};
EpToUse2=aft_cell{2,1};
for k=1:length(Start(EpToUse))
    Duration=(Stop(subset(EpToUse,k))-Start(subset(EpToUse,k)))/1e4;
    Duration1=(Stop(subset(EpToUse2,k))-Start(subset(EpToUse2,k)))/1e4;
    if Duration>MinDur & Duration1>MinDur
        StrtTime=Start(subset(EpToUse,k));
        NumWindows=((MinDur-3)*2-(DiffDur)+1)*10;
        for nn=1:NumWindows
            tempG=Data(Restrict(GhiSubSample,intervalSet(StrtTime+(-(MinDur-3)+(nn-1)*0.1)*1e4,StrtTime+(-(MinDur-3)+(nn-1)*0.1+DiffDur)*1e4)));
            tempT=Data(Restrict(ThetaSubSample,intervalSet(StrtTime+(-(MinDur-3)+(nn-1)*0.1)*1e4,StrtTime+(-(MinDur-3)+(nn-1)*0.1+DiffDur)*1e4)));
            
            if size(tempG,1)==normaldur
                GammDisp(num,:)=(tempG-tempG(1)).^2;
                ThetDisp(num,:)=(tempT-tempT(1)).^2;
                num=num+1;
            else
                GammDisp(num,:)=nan(1,normaldur);
                ThetDisp(num,:)=nan(1,normaldur);
                num=num+1;
            end
        end
    end
end
save(strcat('DisplacementMeasure',num2str(DiffDur),'Part3.mat'),'GammDisp','ThetDisp','NumWindowsSh','-v7.3')
clear GammDisp ThetDisp


num=1;
MinDur=15;
EpToUse=bef_cell{2,1};
EpToUse2=aft_cell{1,2};
for k=1:length(Start(EpToUse))
    Duration=(Stop(subset(EpToUse,k))-Start(subset(EpToUse,k)))/1e4;
    Duration1=(Stop(subset(EpToUse2,k))-Start(subset(EpToUse2,k)))/1e4;
    if Duration>MinDur & Duration1>MinDur
        StrtTime=Start(subset(EpToUse,k));
        NumWindows=((MinDur-3)*2-(DiffDur)+1)*10;
        for nn=1:NumWindows
            tempG=Data(Restrict(GhiSubSample,intervalSet(StrtTime+(-(MinDur-3)+(nn-1)*0.1)*1e4,StrtTime+(-(MinDur-3)+(nn-1)*0.1+DiffDur)*1e4)));
            tempT=Data(Restrict(ThetaSubSample,intervalSet(StrtTime+(-(MinDur-3)+(nn-1)*0.1)*1e4,StrtTime+(-(MinDur-3)+(nn-1)*0.1+DiffDur)*1e4)));
            if size(tempG,1)==normaldur
                GammDisp(num,:)=(tempG-tempG(1)).^2;
                ThetDisp(num,:)=(tempT-tempT(1)).^2;
                num=num+1;
            else
                GammDisp(num,:)=nan(1,normaldur);
                ThetDisp(num,:)=nan(1,normaldur);
                num=num+1;
            end
        end
    end
end
save(strcat('DisplacementMeasure',num2str(DiffDur),'Part4.mat'),'GammDisp','ThetDisp','NumWindowsSh','-v7.3')
clear GammDisp ThetDisp


num=1;
MinDur=10;
EpToUse=bef_cell{2,1};
EpToUse2=aft_cell{1,2};
for k=1:length(Start(EpToUse))
    Duration=(Stop(subset(EpToUse,k))-Start(subset(EpToUse,k)))/1e4;
    Duration1=(Stop(subset(EpToUse2,k))-Start(subset(EpToUse2,k)))/1e4;
    if Duration>MinDur & Duration1>MinDur
        StrtTime=Start(subset(EpToUse,k));
        NumWindows=((MinDur-3)*2-(DiffDur)+1)*10;
        for nn=1:NumWindows
            tempG=Data(Restrict(GhiSubSample,intervalSet(StrtTime+(-(MinDur-3)+(nn-1)*0.1)*1e4,StrtTime+(-(MinDur-3)+(nn-1)*0.1+DiffDur)*1e4)));
            tempT=Data(Restrict(ThetaSubSample,intervalSet(StrtTime+(-(MinDur-3)+(nn-1)*0.1)*1e4,StrtTime+(-(MinDur-3)+(nn-1)*0.1+DiffDur)*1e4)));
            if size(tempG,1)==normaldur
                GammDisp(num,:)=(tempG-tempG(1)).^2;
                ThetDisp(num,:)=(tempT-tempT(1)).^2;
                num=num+1;
            else
                GammDisp(num,:)=nan(1,normaldur);
                ThetDisp(num,:)=nan(1,normaldur);
                num=num+1;
            end
        end
    end
end
save(strcat('DisplacementMeasure',num2str(DiffDur),'Part5.mat'),'GammDisp','ThetDisp','NumWindowsSh','-v7.3')
clear GammDisp ThetDisp


%% Plots

figure
time=[dt:dt:dt*normaldur];
mm=1;

load(strcat('DisplacementMeasure',num2str(DiffDur),'Part1.mat'))
disp('Part1')
g=1;if not(isempty(ThetDisp{g})),[cf_,goodness]=FitDiffusion(time,mean(ThetDisp{g}));    temp=coeffvalues(cf_);CoeffAT(g,mm)=temp(2);CoeffDT(g,mm)=temp(1);RsqT(g,mm)=goodness.rsquare;end %Wake
g=g+1;if not(isempty(ThetDisp{g})),[cf_,goodness]=FitDiffusion(time,mean(ThetDisp{g}));     temp=coeffvalues(cf_);CoeffAT(g,mm)=temp(2);CoeffDT(g,mm)=temp(1);RsqT(g,mm)=goodness.rsquare; end%SWS
g=g+1;if not(isempty(ThetDisp{g})),[cf_,goodness]=FitDiffusion(time,mean(ThetDisp{g}));     temp=coeffvalues(cf_);CoeffAT(g,mm)=temp(2);CoeffDT(g,mm)=temp(1);RsqT(g,mm)=goodness.rsquare; end %REM
g=g+1;if not(isempty(ThetDisp{g})),[cf_,goodness]=FitDiffusion(time,mean(ThetDisp{g}));     temp=coeffvalues(cf_);CoeffAT(g,mm)=temp(2);CoeffDT(g,mm)=temp(1);RsqT(g,mm)=goodness.rsquare; end%WtoS
g=g+1;if not(isempty(ThetDisp{g})),[cf_,goodness]=FitDiffusion(time,mean(ThetDisp{g}));     temp=coeffvalues(cf_);CoeffAT(g,mm)=temp(2);CoeffDT(g,mm)=temp(1);RsqT(g,mm)=goodness.rsquare; end%StoW
g=g+1;if not(isempty(ThetDisp{g})),[cf_,goodness]=FitDiffusion(time,mean(ThetDisp{g}));     temp=coeffvalues(cf_);CoeffAT(g,mm)=temp(2);CoeffDT(g,mm)=temp(1);RsqT(g,mm)=goodness.rsquare; end%RtoS
g=g+1;if not(isempty(ThetDisp{g})),[cf_,goodness]=FitDiffusion(time,mean(ThetDisp{g}));     temp=coeffvalues(cf_);CoeffAT(g,mm)=temp(2);CoeffDT(g,mm)=temp(1);RsqT(g,mm)=goodness.rsquare; end%SltoR
g=g+1;if not(isempty(ThetDisp{g})),[cf_,goodness]=FitDiffusion(time,mean(ThetDisp{g}));     temp=coeffvalues(cf_);CoeffAT(g,mm)=temp(2);CoeffDT(g,mm)=temp(1);RsqT(g,mm)=goodness.rsquare; end%RtoSl

g=1;if not(isempty(GammDisp{g})),[cf_,goodness]=FitDiffusion(time,mean(GammDisp{g}));    temp=coeffvalues(cf_);CoeffAG(g,mm)=temp(2);CoeffDG(g,mm)=temp(1);RsqG(g,mm)=goodness.rsquare;end %Wake
g=g+1;if not(isempty(GammDisp{g})),[cf_,goodness]=FitDiffusion(time,mean(GammDisp{g}));     temp=coeffvalues(cf_);CoeffAG(g,mm)=temp(2);CoeffDG(g,mm)=temp(1);RsqG(g,mm)=goodness.rsquare; end%SWS
g=g+1;if not(isempty(GammDisp{g})),[cf_,goodness]=FitDiffusion(time,mean(GammDisp{g}));     temp=coeffvalues(cf_);CoeffAG(g,mm)=temp(2);CoeffDG(g,mm)=temp(1);RsqG(g,mm)=goodness.rsquare; end %REM
g=g+1;if not(isempty(GammDisp{g})),[cf_,goodness]=FitDiffusion(time,mean(GammDisp{g}));     temp=coeffvalues(cf_);CoeffAG(g,mm)=temp(2);CoeffDG(g,mm)=temp(1);RsqG(g,mm)=goodness.rsquare; end%WtoS
g=g+1;if not(isempty(GammDisp{g})),[cf_,goodness]=FitDiffusion(time,mean(GammDisp{g}));     temp=coeffvalues(cf_);CoeffAG(g,mm)=temp(2);CoeffDG(g,mm)=temp(1);RsqG(g,mm)=goodness.rsquare; end%StoW
g=g+1;if not(isempty(GammDisp{g})),[cf_,goodness]=FitDiffusion(time,mean(GammDisp{g}));     temp=coeffvalues(cf_);CoeffAG(g,mm)=temp(2);CoeffDG(g,mm)=temp(1);RsqG(g,mm)=goodness.rsquare; end%RtoS
g=g+1;if not(isempty(GammDisp{g})),[cf_,goodness]=FitDiffusion(time,mean(GammDisp{g}));     temp=coeffvalues(cf_);CoeffAG(g,mm)=temp(2);CoeffDG(g,mm)=temp(1);RsqG(g,mm)=goodness.rsquare; end%SltoR
g=g+1;if not(isempty(GammDisp{g})),[cf_,goodness]=FitDiffusion(time,mean(GammDisp{g}));     temp=coeffvalues(cf_);CoeffAG(g,mm)=temp(2);CoeffDG(g,mm)=temp(1);RsqG(g,mm)=goodness.rsquare; end%RtoSl
subplot(231), plot(time,mean(GammDisp{1})/CoeffDG(1,mm)), hold on
subplot(232), plot(time,mean(GammDisp{2}/CoeffDG(2,mm))), hold on
subplot(233), plot(time,mean(GammDisp{3}/CoeffDG(3,mm))), hold on
subplot(234), plot(time,mean(ThetDisp{1})/CoeffDT(1,mm)), hold on
subplot(235), plot(time,mean(ThetDisp{2}/CoeffDT(2,mm))), hold on
subplot(236), plot(time,mean(ThetDisp{3}/CoeffDT(3,mm))), hold on


g=1;
disp('Part2')
load(strcat('DisplacementMeasure',num2str(DiffDur),'Part2.mat'))
if not(isempty(GammDisp))
    WindowsG=cell(1,10);WindowsT=cell(1,10);
    numevents=size(GammDisp,1)/(NumWindowsLg*10);
    for t=1:numevents
        temp=(GammDisp(1+NumWindowsLg*10*(t-1):NumWindowsLg*10*t,:));
        tempT=(ThetDisp(1+NumWindowsLg*10*(t-1):NumWindowsLg*10*t,:));
        for k=1:10
            WindowsG{1,k}=[WindowsG{1,k};temp(1+NumWindowsLg*(k-1):NumWindowsLg*k,:)];
            WindowsT{1,k}=[WindowsT{1,k};tempT(1+NumWindowsLg*(k-1):NumWindowsLg*k,:)];
        end
    end
    for k=1:10
        [cf_,goodness]=FitDiffusion(time,nanmean(WindowsG{1,k}));
        temp=coeffvalues(cf_);
        CoeffAGTr{g}(k,mm)=temp(2);CoeffDGTr{g}(k,mm)=temp(1);RsqGTr{g}(k,mm)=goodness.rsquare;
        [cf_,goodness]=FitDiffusion(time,nanmean(WindowsT{1,k}));
        temp=coeffvalues(cf_);
        CoeffATTr{g}(k,mm)=temp(2);CoeffDTTr{g}(k,mm)=temp(1);RsqTTr{g}(k,mm)=goodness.rsquare;
    end
end


g=2;
load(strcat('DisplacementMeasure',num2str(DiffDur),'Part4.mat'))
if not(isempty(GammDisp))
    WindowsG=cell(1,10);WindowsT=cell(1,10);
    numevents=size(GammDisp,1)/(NumWindowsLg*10);
    for t=1:numevents
        temp=(GammDisp(1+NumWindowsLg*10*(t-1):NumWindowsLg*10*t,:));
        tempT=(ThetDisp(1+NumWindowsLg*10*(t-1):NumWindowsLg*10*t,:));
        for k=1:10
            WindowsG{1,k}=[WindowsG{1,k};temp(1+NumWindowsLg*(k-1):NumWindowsLg*k,:)];
            WindowsT{1,k}=[WindowsT{1,k};tempT(1+NumWindowsLg*(k-1):NumWindowsLg*k,:)];
        end
    end
    for k=1:10
        [cf_,goodness]=FitDiffusion(time,nanmean(WindowsG{1,k}));
        temp=coeffvalues(cf_);
        CoeffAGTr{g}(k,mm)=temp(2);CoeffDGTr{g}(k,mm)=temp(1);RsqGTr{g}(k,mm)=goodness.rsquare;
        [cf_,goodness]=FitDiffusion(time,nanmean(WindowsT{1,k}));
        temp=coeffvalues(cf_);
        CoeffATTr{g}(k,mm)=temp(2);CoeffDTTr{g}(k,mm)=temp(1);RsqTTr{g}(k,mm)=goodness.rsquare;
    end
end

disp('Part3')
g=3;
load(strcat('DisplacementMeasure',num2str(DiffDur),'Part3.mat'))
if not(isempty(GammDisp))
    WindowsG=cell(1,10);WindowsT=cell(1,10);
    numevents=size(GammDisp,1)/(NumWindowsSh*10);
    for t=1:numevents
        temp=(GammDisp(1+NumWindowsSh*10*(t-1):NumWindowsSh*10*t,:));
        tempT=(ThetDisp(1+NumWindowsSh*10*(t-1):NumWindowsSh*10*t,:));
        for k=1:10
            WindowsG{1,k}=[WindowsG{1,k};temp(1+NumWindowsSh*(k-1):NumWindowsSh*k,:)];
            WindowsT{1,k}=[WindowsT{1,k};tempT(1+NumWindowsSh*(k-1):NumWindowsSh*k,:)];
        end
    end
    for k=1:10
        [cf_,goodness]=FitDiffusion(time,nanmean(WindowsG{1,k}));
        temp=coeffvalues(cf_);
        CoeffAGTr{g}(k,mm)=temp(2);CoeffDGTr{g}(k,mm)=temp(1);RsqGTr{g}(k,mm)=goodness.rsquare;
        [cf_,goodness]=FitDiffusion(time,nanmean(WindowsT{1,k}));
        temp=coeffvalues(cf_);
        CoeffATTr{g}(k,mm)=temp(2);CoeffDTTr{g}(k,mm)=temp(1);RsqTTr{g}(k,mm)=goodness.rsquare;
    end
end

g=4;
load(strcat('DisplacementMeasure',num2str(DiffDur),'Part5.mat'))
if not(isempty(GammDisp))
    WindowsG=cell(1,10);WindowsT=cell(1,10);
    numevents=size(GammDisp,1)/(NumWindowsSh*10);
    for t=1:numevents
        temp=(GammDisp(1+NumWindowsSh*10*(t-1):NumWindowsSh*10*t,:));
        tempT=(ThetDisp(1+NumWindowsSh*10*(t-1):NumWindowsSh*10*t,:));
        for k=1:10
            WindowsG{1,k}=[WindowsG{1,k};temp(1+NumWindowsSh*(k-1):NumWindowsSh*k,:)];
            WindowsT{1,k}=[WindowsT{1,k};tempT(1+NumWindowsSh*(k-1):NumWindowsSh*k,:)];
        end
    end
    for k=1:10
        [cf_,goodness]=FitDiffusion(time,nanmean(WindowsG{1,k}));
        temp=coeffvalues(cf_);
        CoeffAGTr{g}(k,mm)=temp(2);CoeffDGTr{g}(k,mm)=temp(1);RsqGTr{g}(k,mm)=goodness.rsquare;
        [cf_,goodness]=FitDiffusion(time,nanmean(WindowsT{1,k}));
        temp=coeffvalues(cf_);
        CoeffATTr{g}(k,mm)=temp(2);CoeffDTTr{g}(k,mm)=temp(1);RsqTTr{g}(k,mm)=goodness.rsquare;
    end
end


% Average Diffusion rates
ToUse=[1:5,7,8];
figure
subplot(221)
PlotErrorBar(CoeffAG(ToUse,:)',0)
for g=1:7
    plot(g-0.3,CoeffAG(ToUse(g),:),'.','color','w','MarkerSize',21)
    plot(g-0.3,CoeffAG(ToUse(g),:),'.','color','k','MarkerSize',10)
end
title(num2str(DiffDur))
set(gca,'XTick',[1:7],'Xticklabel',{'Wake','SWS','REM','W--S','S--W','S--R','R--S'})
ylabel('Gamma - alpha')
subplot(223)
PlotErrorBar( (CoeffDG(ToUse,:)'./(CoeffDG(1,:)'*ones(7,1)')),0)
for g=1:7
    plot(g-0.3,CoeffDG(ToUse(g),:)./CoeffDG(1,:),'.','color','w','MarkerSize',21)
    plot(g-0.3,CoeffDG(ToUse(g),:)./CoeffDG(1,:),'.','color','k','MarkerSize',10)
end
set(gca,'XTick',[1:7],'Xticklabel',{'Wake','SWS','REM','W--S','S--W','S--R','R--S'})
ylabel('Gamma-D')

subplot(222)
PlotErrorBar(CoeffAT(ToUse,:)',0)
for g=1:7
    plot(g-0.3,CoeffAT(g,:),'.','color','w','MarkerSize',21)
    plot(g-0.3,CoeffAT(g,:),'.','color','k','MarkerSize',10)
end
ylabel('Theta - alpha')
set(gca,'XTick',[1:7],'Xticklabel',{'Wake','SWS','REM','W--S','S--W','S--R','R--S'})
subplot(224)
PlotErrorBar( (CoeffDT(ToUse,:)'./(CoeffDT(1,:)'*ones(7,1)')),0)
for g=1:7
    plot(g-0.3,CoeffDT(g,:)./CoeffDT(1,:),'.','color','w','MarkerSize',21)
    plot(g-0.3,CoeffDT(g,:)./CoeffDT(1,:),'.','color','k','MarkerSize',10)
end
set(gca,'XTick',[1:7],'Xticklabel',{'Wake','SWS','REM','W--S','S--W','S--R','R--S'})
ylabel('Theta - D')


%Evolution of Diffusion rates
figure
subplot(2,2,1)
PlotErrorBar(CoeffAGTr{1}',0)
for g=1:10
    plot(g-0.3,CoeffAGTr{1}(g,:),'.','color','w','MarkerSize',21)
    plot(g-0.3,CoeffAGTr{1}(g,:),'.','color','k','MarkerSize',10)
end
ylim([0 4])
plot([5.5 5.5],[0 4],'r','linewidth',3)
set(gca,'XTick',[1:10],'XTickLabel',{'-9.1','-7.1','-5.1','-3.1','-1.1','1.1','3.1','5.1','7.1','9.1'})
subplot(2,2,3)
PlotErrorBar(CoeffAGTr{3}',0)
for g=1:10
    plot(g-0.3,CoeffAGTr{3}(g,:),'.','color','w','MarkerSize',21)
    plot(g-0.3,CoeffAGTr{3}(g,:),'.','color','k','MarkerSize',10)
end
ylim([0 4])
plot([5.5 5.5],[0 4],'r','linewidth',3)
set(gca,'XTick',[1:10],'XTickLabel',{'-4.5','-3.5','-2.5','-1.5','-0.5','0.5','1.5','2.5','3.5','4.5'})
subplot(2,2,2)
PlotErrorBar(CoeffAGTr{2}',0)
for g=1:10
    plot(g-0.3,CoeffAGTr{2}(g,:),'.','color','w','MarkerSize',21)
    plot(g-0.3,CoeffAGTr{2}(g,:),'.','color','k','MarkerSize',10)
end
ylim([0 4])
plot([5.5 5.5],[0 4],'r','linewidth',3)
set(gca,'XTick',[1:10],'XTickLabel',{'-9.1','-7.1','-5.1','-3.1','-1.1','1.1','3.1','5.1','7.1','9.1'})
subplot(2,2,4)
PlotErrorBar(CoeffAGTr{4}',0)
for g=1:10
    plot(g-0.3,CoeffAGTr{4}(g,:),'.','color','w','MarkerSize',21)
    plot(g-0.3,CoeffAGTr{4}(g,:),'.','color','k','MarkerSize',10)
end
ylim([0 4])
plot([5.5 5.5],[0 4],'r','linewidth',3)
set(gca,'XTick',[1:10],'XTickLabel',{'-4.5','-3.5','-2.5','-1.5','-0.5','0.5','1.5','2.5','3.5','4.5'})


%Evolution of Diffusion rates
figure
subplot(2,2,1)
PlotErrorBar(CoeffATTr{1}',0)
for g=1:10
    plot(g-0.3,CoeffATTr{1}(g,:),'.','color','w','MarkerSize',21)
    plot(g-0.3,CoeffATTr{1}(g,:),'.','color','k','MarkerSize',10)
end
ylim([0 2.5])
plot([5.5 5.5],[0 2.5],'r','linewidth',3)
set(gca,'XTick',[1:10],'XTickLabel',{'-9.1','-7.1','-5.1','-3.1','-1.1','1.1','3.1','5.1','7.1','9.1'})
subplot(2,2,3)
PlotErrorBar(CoeffATTr{3}',0)
for g=1:10
    plot(g-0.3,CoeffATTr{3}(g,:),'.','color','w','MarkerSize',21)
    plot(g-0.3,CoeffATTr{3}(g,:),'.','color','k','MarkerSize',10)
end
ylim([0 2.5])
plot([5.5 5.5],[0 2.5],'r','linewidth',3)
set(gca,'XTick',[1:10],'XTickLabel',{'-4.5','-3.5','-2.5','-1.5','-0.5','0.5','1.5','2.5','3.5','4.5'})
subplot(2,2,2)
PlotErrorBar(CoeffATTr{2}',0)
for g=1:10
    plot(g-0.3,CoeffATTr{2}(g,:),'.','color','w','MarkerSize',21)
    plot(g-0.3,CoeffATTr{2}(g,:),'.','color','k','MarkerSize',10)
end
ylim([0 2.5])
plot([5.5 5.5],[0 2.5],'r','linewidth',3)
set(gca,'XTick',[1:10],'XTickLabel',{'-9.1','-7.1','-5.1','-3.1','-1.1','1.1','3.1','5.1','7.1','9.1'})
subplot(2,2,4)
PlotErrorBar(CoeffATTr{4}',0)
for g=1:10
    plot(g-0.3,CoeffATTr{4}(g,:),'.','color','w','MarkerSize',21)
    plot(g-0.3,CoeffATTr{4}(g,:),'.','color','k','MarkerSize',10)
end
ylim([0 2.5])
plot([5.5 5.5],[0 2.5],'r','linewidth',3)
set(gca,'XTick',[1:10],'XTickLabel',{'-4.5','-3.5','-2.5','-1.5','-0.5','0.5','1.5','2.5','3.5','4.5'})




%%




subplot(231), plot(time,mean(GammDisp{1})/CoeffDG(1,mm)), hold on
subplot(232), plot(time,mean(GammDisp{2}/CoeffDG(2,mm))), hold on
subplot(233), plot(time,mean(GammDisp{3}/CoeffDG(3,mm))), hold on
subplot(234), plot(time,mean(ThetDisp{1})/CoeffDT(1,mm)), hold on
subplot(235), plot(time,mean(ThetDisp{2}/CoeffDT(2,mm))), hold on
subplot(236), plot(time,mean(ThetDisp{3}/CoeffDT(3,mm))), hold on


subplot(231), plot(time,mean(GammDisp{1})/CoeffAG(1,mm)), hold on
subplot(232), plot(time,mean(GammDisp{2}/CoeffAG(2,mm))), hold on
subplot(233), plot(time,mean(GammDisp{3}/CoeffAG(3,mm))), hold on
subplot(234), plot(time,mean(ThetDisp{1})/CoeffAT(1,mm)), hold on
subplot(235), plot(time,mean(ThetDisp{2}/CoeffAT(2,mm))), hold on
subplot(236), plot(time,mean(ThetDisp{3}/CoeffAT(3,mm))), hold on





for k=1:length(Start(bef_cell{1,2}))
    if LengthAfter(k)>3+DiffDur & LengthBefore(k)>3+DiffDur
        TransTime=Transitions(k);
        for nn=1:NumWindows
            tempG(nn)=Data(Restrict(GhiSubSample,intervalSet(TransTime-(DiffDur-nn+1)*1e4,TransTime+(nn-1)*1e4)));
            tempT(nn)=Data(Restrict(ThetaSubSample,intervalSet(TransTime-(DiffDur-nn+1)*1e4,TransTime+(nn-1)*1e4)));
            if size(tempG,1)==normaldur
                GammDisp{4}(num,:)=(tempG-tempG(1)).^2;
                ThetDisp{4}(num,:)=(tempT-tempT(1)).^2;
                num=num+1;
            end
        end
    end
end



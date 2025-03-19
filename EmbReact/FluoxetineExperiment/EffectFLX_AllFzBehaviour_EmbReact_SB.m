clear all
SessNames={'UMazeCondBlockedShock_PostDrug' 'UMazeCondBlockedSafe_PostDrug' 'UMazeCondExplo_PostDrug'...
    'TestPost_PostDrug','ExtinctionBlockedShock_PostDrug' 'ExtinctionBlockedSafe_PostDrug' };
% SessNames={'ExtinctionBlockedShock_PostDrug' 'ExtinctionBlockedSafe_PostDrug' };

SALMice = [688,739,777,779,849];
FLXMice = [740,750,778,775,794,796];
MDZMice = [829,851,856,857,858,859];

SALFiles = {};
FLXFiles = {};
MDZFiles = {};

for sess = 1 : length(SessNames)
    Dir=PathForExperimentsEmbReact(SessNames{sess});
    for d = 1:length(Dir.path)
        
        if sum(ismember(SALMice,Dir.ExpeInfo{d}{1}.nmouse))
            SALFiles{end+1} = Dir.path{d}{1};
            SALFiles{end+1} = Dir.path{d}{2};
        elseif sum(ismember(FLXMice,Dir.ExpeInfo{d}{1}.nmouse))
            FLXFiles{end+1} = Dir.path{d}{1};
            FLXFiles{end+1} = Dir.path{d}{2};
        elseif sum(ismember(MDZMice,Dir.ExpeInfo{d}{1}.nmouse))
            MDZFiles{end+1} = Dir.path{d}{1};
            MDZFiles{end+1} = Dir.path{d}{2};
        end
        
    end
end


All_B.Sal = ConcatenateDataFromFolders_SB(SALFiles,'spectrum','prefix','B_Low');
All_HLow.Sal = ConcatenateDataFromFolders_SB(SALFiles,'spectrum','prefix','H_Low');
All_Pos.Sal = ConcatenateDataFromFolders_SB(SALFiles,'LinearPosition');
All_Fz.Sal = ConcatenateDataFromFolders_SB(SALFiles,'Epoch','epochname','freezeepoch');
All_H.Sal = ConcatenateDataFromFolders_SB(SALFiles,'spectrum','prefix','H_VHigh');
% All_BInst.Sal = ConcatenateDataFromFolders_SB(SALFiles,'instfreq','suffix_instfreq','B','method','PT');

All_B.Flx = ConcatenateDataFromFolders_SB(FLXFiles,'spectrum','prefix','B_Low');
All_HLow.Flx = ConcatenateDataFromFolders_SB(FLXFiles,'spectrum','prefix','H_Low');
All_Pos.Flx = ConcatenateDataFromFolders_SB(FLXFiles,'LinearPosition');
All_Fz.Flx = ConcatenateDataFromFolders_SB(FLXFiles,'Epoch','epochname','freezeepoch');
All_H.Flx = ConcatenateDataFromFolders_SB(FLXFiles,'spectrum','prefix','H_VHigh');
% All_BInst.Flx = ConcatenateDataFromFolders_SB(FLXFiles,'instfreq','suffix_instfreq','B','method','PT');

All_B.Mdz = ConcatenateDataFromFolders_SB(MDZFiles,'spectrum','prefix','B_Low');
All_HLow.Mdz = ConcatenateDataFromFolders_SB(MDZFiles,'spectrum','prefix','H_Low');
All_Pos.Mdz = ConcatenateDataFromFolders_SB(MDZFiles,'LinearPosition');
All_Fz.Mdz = ConcatenateDataFromFolders_SB(MDZFiles,'Epoch','epochname','freezeepoch');
All_H.Mdz = ConcatenateDataFromFolders_SB(MDZFiles,'spectrum','prefix','H_VHigh');
% All_BInst.Mdz = ConcatenateDataFromFolders_SB(FLXFiles,'instfreq','suffix_instfreq','B','method','PT');

load('B_Low_Spectrum.mat')
fLow = Spectro{3};
load('H_VHigh_Spectrum.mat')
fHigh = Spectro{3};


SALSpec = Restrict(All_B.Sal,All_Fz.Sal);
SALSpecH = (Restrict(All_H.Sal,ts(Range(SALSpec))));
SALPos = (Restrict(All_Pos.Sal,ts(Range(SALSpec))));
% SALBFreq = (Restrict(All_BInst.Sal,ts(Range(SALSpec))));
SALSpecHLow = (Restrict(All_HLow.Sal,ts(Range(SALSpec))));

FLXSpec = Restrict(All_B.Flx,All_Fz.Flx);
FLXSpecH = (Restrict(All_H.Flx,ts(Range(FLXSpec))));
FLXPos = (Restrict(All_Pos.Flx,ts(Range(FLXSpec))));
% FLXBFreq = (Restrict(All_BInst.Flx,ts(Range(FLXSpec))));
FLXSpecHLow = (Restrict(All_HLow.Flx,ts(Range(FLXSpec))));

MDZSpec = Restrict(All_B.Mdz,All_Fz.Mdz);
MDZSpecH = (Restrict(All_H.Mdz,ts(Range(MDZSpec))));
MDZPos = (Restrict(All_Pos.Mdz,ts(Range(MDZSpec))));
% MDZBFreq = (Restrict(All_BInst.Mdz,ts(Range(FLXSpec))));
MDZSpecHLow = (Restrict(All_HLow.Mdz,ts(Range(MDZSpec))));


%% Saline
Pos = SALPos;
Spec = SALSpec;
SpecHLow = SALSpecHLow;
SpecH = SALSpecH;
figure(3)
clf
%% FLuoxetine
Pos = FLXPos;
Spec = FLXSpec;
SpecHLow = FLXSpecHLow;
SpecH = FLXSpecH;
figure(4)
clf
%% midazolam
Pos = MDZPos;
Spec = MDZSpec;
SpecHLow = MDZSpecHLow;
SpecH = MDZSpecH;
figure(5)
clf

X = Data(Pos);
subplot(4,4,1:3)
[Mat,Ind] = sortrows([X,(Data(Spec))]);
X = X(Ind);
ShockSide = find(X<0.2,1,'last');
SafeSide = find(X<0.9,1,'last');
line([ShockSide ShockSide],ylim,'color','r')
line([SafeSide SafeSide],ylim,'color','b')
Mat= Mat(:,2:end);
imagesc(1:length(Mat),fLow,zscore(Mat')), clim([-3 3])
axis xy
colormap jet
title('OB Spec')
ylabel('Frequency (Hz)')
text(500,15,'Shock','color','r')
text(length(X)-500,15,'Safe','color','b')

subplot(4,4,4)
plot(fLow,nanmean(Mat(1:ShockSide,:)),'r'), hold on
plot(fLow,nanmean(Mat(SafeSide:end,:)),'b')
xlabel('Frequency (Hz)')

subplot(4,4,5:7)
Mat3 = sortrows([Ind,log(Data(SpecHLow))]);
Mat3= Mat3(:,2:end);
imagesc(1:length(Mat),fLow,zscore(Mat3')), clim([-3 3])
line([ShockSide ShockSide],ylim,'color','r')
line([SafeSide SafeSide],ylim,'color','b')
axis xy
colormap jet
title('HPC Spec')
ylabel('Frequency (Hz)')
text(500,15,'Shock','color','r')
text(length(X)-500,15,'Safe','color','b')


subplot(4,4,8)
plot(fLow,nanmean(Mat3(1:ShockSide,:)),'r'), hold on
plot(fLow,nanmean(Mat3(SafeSide:end,:)),'b')
xlabel('Frequency (Hz)')

subplot(4,4,9:11)
Mat2 = sortrows([Ind,log(Data(SpecH))]);
Mat2= Mat2(:,2:end);
imagesc(1:length(Mat2),fHigh,zscore(Mat2')), clim([-3 3])
line([ShockSide ShockSide],ylim,'color','r')
line([SafeSide SafeSide],ylim,'color','b')
axis xy
colormap jet
title('HPC Spec high')
ylabel('Frequency (Hz)')
text(500,200,'Shock','color','r')
text(length(X)-500,200,'Safe','color','b')

subplot(4,4,12)
plot(fHigh,nanmean(Mat2(1:ShockSide,:)),'r'), hold on
plot(fHigh,nanmean(Mat2(SafeSide:end,:)),'b')
xlabel('Frequency (Hz)')

subplot(4,4,13:15)
plot(X)
ShockSide = find(X<0.2,1,'last');
SafeSide = find(X<0.9,1,'last');
line([ShockSide ShockSide],ylim,'color','r')
line([SafeSide SafeSide],ylim,'color','b')
xlim([0 length(X)])
ylabel('Position')
text(500,0.8,'Shock','color','r')
text(length(X)-500,0.8,'Safe','color','b')


%% Saline
Pos = SALPos;
Spec = SALSpec;
SpecHLow = SALSpecHLow;
SpecH = SALSpecH;
figure(5)
clf
%% FLuoxetine
Pos = FLXPos;
Spec = FLXSpec;
SpecHLow = FLXSpecHLow;
SpecH = FLXSpecH;
figure(6)
clf
%% Midazolam
Pos = MDZPos;
Spec = MDZSpec;
SpecHLow = MDZSpecHLow;
SpecH = MDZSpecH;
figure(6)
clf

clf
A = SmoothDec(Data(Spec),[2 0.01]);
[val,ind] = max(A(:,30:end)');
[sr,srind] = sort(ind);
FreqOrd = fLow(30+ind(srind));
LowFreq = find(FreqOrd<3.5,1,'last');
HighFreq = find(FreqOrd>3.5 & FreqOrd<6.5 ,1,'last');

subplot(4,4,1:3)
imagesc(1:length(A),fLow,zscore(A(srind,:)')), axis xy, clim([-3 3])
line([LowFreq LowFreq],ylim,'color','b')
line([HighFreq HighFreq],ylim,'color','r')
subplot(4,4,4)
nhist({FreqOrd(1:LowFreq),FreqOrd(LowFreq:HighFreq)},'proportion')

subplot(4,4,5:7)
A = (log(Data(SpecHLow)));
B = (A(srind,:));
imagesc(1:length(A),fLow,zscore(B')), axis xy,clim([-3 3])
line([LowFreq LowFreq],ylim,'color','b')
line([HighFreq HighFreq],ylim,'color','r')
subplot(4,4,8)
plot(fLow,nanmean(B(1:LowFreq,:)),'b'), hold on
plot(fLow,nanmean(B(LowFreq:HighFreq,:)),'r')


subplot(4,4,9:11)
A = SmoothDec(log(Data(SpecH)),[1 0.5]);
B = (A(srind,:));
imagesc(1:length(A),fHigh,(B')), axis xy,
PowRip = nanmean(B(:,55:80)');
hold on
plot(100*movmean(PowRip,100)-200)
subplot(4,4,12)
plot(fHigh,nanmean(B(1:LowFreq,:)),'b'), hold on
plot(fHigh,nanmean(B(LowFreq:HighFreq,:)),'r')

subplot(4,4,13:15)
A = Data(Pos);
B = (A(srind,:)');
plot(runmean(B,50))
subplot(4,4,16)
nhist({B(1:LowFreq),B(LowFreq:HighFreq)},'proportion')




figure(3)
clf
A = SmoothDec(Data(FLXSpec),[2 0.01]);
[val,ind] = max(A(:,30:end)');
[sr,srind] = sort(ind);
subplot(211)
imagesc(1:length(A),fLow,log(A(srind,:))'), axis xy
subplot(413)
A = SmoothDec(Data(FLXSpecH),[3 3]);
B = (A(srind,:)');
plot(runmean(nanmean(B(60:80,:)),20))
subplot(414)
A = Data(FLXPos);
B = (A(srind,:)');
plot(runmean(B,50))
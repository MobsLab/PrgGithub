
function indx=ObsBinCohrT(Mat,smoo)

% ------------------------------------------------------------------------
% ------------------------------------------------------------------------
% Modification Karim
% ------------------------------------------------------------------------
% ------------------------------------------------------------------------

try
    cd H:\Data_Astros_Field
    catch
    cd /Users/karimbenchenane/Documents/Data/Lisa/Data_Astros_Field
end


    
load ResultsCompLFP

Mat(isnan(Mat))=0;


Mat=zscore(Mat')';

binCrossT=Mat;

try
smo=[0.001 smoo];
catch
smo=[0.001 1.5];    
end

binCrossTz=binCrossT;
binCrossTz(isnan(binCrossTz))=0;
binCrossTz=zscore(binCrossTz')';


[MTz,MidTz]=max(binCrossTz');
[mTz,midTz]=min(binCrossTz');
[BE,id]=sort(lCross(MidTz));
lCrossMz=lCross(MidTz);
lCrossmz=lCross(midTz);

% figure('color',[1 1 1])
% imagesc(lCross,[1:size(binCrossTz,1)],binCrossTz(id,:))
% hold on, line([0 0],[0.5 size(binCrossTz,1)+05],'Color','k','linewidth',2)
% hold on, plot(lCrossMz(id), [1:size(binCrossT,1)],'ko','MarkerFaceColor','k')
% hold on, plot(lCrossmz(id), [1:size(binCrossT,1)],'wo','MarkerFaceColor','w')


% ------------------------------------------------------------------------

binCrossTzs=SmoothDec(binCrossTz,smo);

[MTzs,MidTzs]=max(binCrossTzs');
[mTzs,midTzs]=min(binCrossTzs');
[BE,ids]=sort(lCross(MidTzs));
lCrossMzs=lCross(MidTzs);
lCrossmzs=lCross(midTzs);


% [MTzsP,MidTzsP]=max(binCrossTzs(:,lCross>0)');
% [mTzsP,midTzsP]=min(binCrossTzs(:,lCross>0)');
% [MTzsN,MidTzsN]=max(binCrossTzs(:,lCross<0)');
% [mTzsN,midTzsN]=min(binCrossTzs(:,lCross<0)');
% lCrossP=lCross(lCross>0);
% lCrossN=lCross(lCross<0);
% lCrossMzsP=lCrossP(MidTzsP);
% lCrossmzsP=lCrossP(midTzsP);
% lCrossMzsN=lCrossN(MidTzsN);
% lCrossmzsN=lCrossN(midTzsN);


figure('color',[1 1 1])
imagesc(lCross,[1:size(binCrossTz,1)],binCrossTzs(ids,:))
hold on, line([0 0],[0.5 size(binCrossTz,1)+05],'Color','k','linewidth',2)
% hold on, plot(lCrossMzs(ids), [1:size(binCrossT,1)],'ko','MarkerFaceColor','k')
% hold on, plot(lCrossmzs(ids), [1:size(binCrossT,1)],'wo','MarkerFaceColor','w')

% hold on, plot(lCrossMzsP(ids), [1:size(binCrossT,1)],'-ko','MarkerFaceColor','k','linewidth',2)
% hold on, plot(lCrossmzsP(ids), [1:size(binCrossT,1)],'-wo','MarkerFaceColor','w','linewidth',2)
% hold on, plot(lCrossMzsN(ids), [1:size(binCrossT,1)],'-ko','MarkerFaceColor','k','linewidth',2)
% hold on, plot(lCrossmzsN(ids), [1:size(binCrossT,1)],'-wo','MarkerFaceColor','w','linewidth',2)
% ------------------------------------------------------------------------



try

% ------------------------------------------------------------------------
    
for i=1:size(binCrossTz,1)

dth = diff(binCrossTzs(ids(i),:));
dth1 = [0 dth];
dth2 = [dth 0];
clear dth;

thpeaks = lCross(find(dth1 > 0 & dth2 < 0));

thpeaksP=thpeaks(find(thpeaks>0));
thpeaksN=thpeaks(find(thpeaks<0));

for z=1:length(thpeaksP)
idxpeaksP(z)=find(lCross==thpeaksP(z));
end

for z=1:length(thpeaksN)
idxpeaksN(z)=find(lCross==thpeaksN(z));
end

thpeaksP=thpeaksP(find(binCrossTzs(ids(i),idxpeaksP)>0));
thpeaksN=thpeaksN(find(binCrossTzs(ids(i),idxpeaksN)>0));
% 
%     thpeaks=[thpeaksN,thpeaksP];

if length(thpeaksP)==0
    thpeaksP=thpeaks(find(thpeaks>0));
end

if length(thpeaksN)==0
    thpeaksN=thpeaks(find(thpeaks<0));
end

clear idxpeaksP
clear idxpeaksN

thpeaksP=min(abs(thpeaksP));    
thpeaksN=-min(abs(thpeaksN));
 
M1=binCrossTzs(ids(i),find(lCross==thpeaksP));
M2=binCrossTzs(ids(i),find(lCross==thpeaksN));

% PMax(i)=lCross(find(binCrossTz(ids(i),:)==max(M1,M2)));
[temp,idx]=min(abs([lCross(find(binCrossTzs(ids(i),:)==M1)),lCross(find(binCrossTzs(ids(i),:)==M2))]));
Ppr0(i)=(-1)^(idx-1)*temp;



thtrough = lCross(find(dth1 < 0 & dth2 > 0));

thtroughP=thtrough(find(thtrough>0));
thtroughN=thtrough(find(thtrough<0));

for z=1:length(thtroughP)
idxtroughP(z)=find(lCross==thtroughP(z));
end

for z=1:length(thtroughN)
idxtroughN(z)=find(lCross==thtroughN(z));
end

try
thtroughP=thtroughP(find(binCrossTzs(ids(i),idxtroughP)<0));
catch
thtroughP=thtrough(find(thtrough>0));
end

try
thtroughN=thtroughN(find(binCrossTzs(ids(i),idxtroughN)<0));
catch
thtroughN=thtrough(find(thtrough<0));
end


if length(thtroughP)==0
thtroughP=thtrough(find(thtrough>0));
end

if length(thtroughN)==0
thtroughN=thtrough(find(thtrough<0));
end

%     thtrough=[thtroughN,thtroughP];

clear idxtroughP
clear idxtroughN    

thtroughP=min(abs(thtroughP)); 
thtroughN=-min(abs(thtroughN));

M1=binCrossTzs(ids(i),find(lCross==thtroughP));
M2=binCrossTzs(ids(i),find(lCross==thtroughN));

% TMax(i)=lCross(find(binCrossTz(ids(i),:)==min(M1,M2)));

[temp,idx]=min(abs([lCross(find(binCrossTzs(ids(i),:)==M1)),lCross(find(binCrossTzs(ids(i),:)==M2))]));
Tpr0(i)=(-1)^(idx-1)*temp;


    hold on, plot(thpeaks, (i)*ones(length(thpeaks),1),'k.')
    hold on, plot(thtrough, (i)*ones(length(thtrough),1),'w.')

% keyboard

end

hold on, plot(Ppr0, [1:size(binCrossTz,1)],'-ko','MarkerFaceColor','k','linewidth',2)
hold on, plot(Tpr0, [1:size(binCrossTz,1)],'-wo','MarkerFaceColor','w','linewidth',2)


[BE,indx]=sort(Ppr0);
figure('color',[1 1 1])
imagesc(lCross,[1:size(binCrossTz,1)],binCrossTzs(ids(indx),:))
hold on, line([0 0],[0.5 size(binCrossTz,1)+05],'Color','k','linewidth',2)
% hold on, plot(PMax, [1:size(binCrossTz,1)],'-ko','MarkerFaceColor','k','linewidth',2)
hold on, plot(Ppr0(indx), [1:size(binCrossTz,1)],'-ko','MarkerFaceColor','k','linewidth',2)
hold on, plot(Tpr0(indx), [1:size(binCrossTz,1)],'-wo','MarkerFaceColor','w','linewidth',2)

% ------------------------------------------------------------------------



catch
    
    indx=ids;
    figure('color',[1 1 1])
imagesc(lCross,[1:size(binCrossTz,1)],binCrossTz(id,:))
hold on, line([0 0],[0.5 size(binCrossTz,1)+05],'Color','k','linewidth',2)
hold on, plot(lCrossMz(id), [1:size(binCrossT,1)],'-ko','MarkerFaceColor','k','linewidth',2)
hold on, plot(lCrossmz(id),[1:size(binCrossT,1)],'-wo','MarkerFaceColor','w','linewidth',2)
title('Maximum')

end



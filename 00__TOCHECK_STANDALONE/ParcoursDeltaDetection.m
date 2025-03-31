% ParcoursDeltaDetection

profSup=1;
%profSup=0;

tic
%Dir=PathForExperimentsDeltaSleepNew('DeltaTone');
Dir=PathForExperimentsDeltaSleepKJ_062016('basal');

a=1;
for i=1:length(Dir.path)
% try
    eval(['cd(Dir.path{',num2str(i),'}'')'])
    disp(pwd)
    disp(num2str(a))
    [m{a},m2{a},m3{a},t{a},l{a},l2{a},l3{a},tt{a},nb{a},nb2{a},nb3{a},nbDelta{a},nbDelta2{a},mD1{a},tD1{a},mD2{a},mD3{a},mDlfp1{a},mDlfp2{a},mDlfp3{a},mD1b{a},tD1b{a},mD2b{a},mD3b{a},mDlfp1b{a},mDlfp2b{a},mDlfp3b{a},NbNumNeu(a)]=DeltaDetectionTh(0,profSup);close all
    MiceName{a}=Dir.name{i};
    PathOK{a}=Dir.path{i};
    a=a+1;
% end
end

cd /media/DataMOBsRAID/ProjetBreathDeltaFeedback
% save DataParcoursDeltaDetection

toc





for a=1:length(nbDelta)
nombreDelta(a,1)=nbDelta{a};
nombreDelta(a,2)=nbDelta2{a};
end










figure('color',[1 1 1])
for i=1:length(nbDelta)
subplot(2,length(nbDelta),i), plot(t{i},m{i},'color',[0.7 0.7 0.7]), title(MiceName{i}), yl=ylim; ylim([0 0.08]), hold on, plot(t{i},mD1{i},'g','linewidth',2)
subplot(2,length(nbDelta),i+length(nbDelta)), plot(tt{i},l{i},'k'), title(MiceName{i}), hold on, plot(tD1{i},mDlfp1{i},'g','linewidth',2)
end

subplot(2, length(nbDelta),1), ylabel('Diff')   


 figure('color',[1 1 1])
for i=1:length(nbDelta)
subplot(2,length(nbDelta),i), plot(t{i},m2{i},'color',[0.7 0.7 0.7]), title(MiceName{i}), yl=ylim; ylim([0 0.08])
subplot(2,length(nbDelta),i+length(nbDelta)), plot(tt{i},l2{i},'b'), title(MiceName{i})
end
   
subplot(2, length(nbDelta),1), ylabel('Deep')   
    

 figure('color',[1 1 1])
for i=1:length(nbDelta)
subplot(2,length(nbDelta),i), plot(t{i},m3{i},'color',[0.7 0.7 0.7]), title(MiceName{i}), yl=ylim; ylim([0 0.08])
subplot(2,length(nbDelta),i+length(nbDelta)), plot(tt{i},l3{i},'r'), title(MiceName{i})
end
subplot(2, length(nbDelta),1), ylabel('Sup')   

% 
%  figure('color',[1 1 1]), hold on
% for i=1:length(nbDelta)
% subplot(1,3,1), hold on, plot(0.2:0.2:4,m{i}(:,98),'k')
% subplot(1,3,2), hold on, plot(0.2:0.2:4,m2{i}(:,98),'b')
% subplot(1,3,3), hold on, plot(0.2:0.2:4,m3{i}(:,98),'r')
% end

 figure('color',[1 1 1]), hold on
for i=1:length(nbDelta)
subplot(1,3,1), hold on, plot(0.2:0.2:4,min(m{i}'),'k')
subplot(1,3,2), hold on, plot(0.2:0.2:4,min(m2{i}'),'b')
subplot(1,3,3), hold on, plot(0.2:0.2:4,min(m3{i}'),'r')
end
 figure('color',[1 1 1]), hold on
for i=1:length(nbDelta)
subplot(1,3,1), hold on, plot(0.2:0.2:4,NbNumNeu(i)*min(m{i}'),'k')
subplot(1,3,2), hold on, plot(0.2:0.2:4,NbNumNeu(i)*min(m2{i}'),'b')
subplot(1,3,3), hold on, plot(0.2:0.2:4,NbNumNeu(i)*min(m3{i}'),'r')
end


nombreDelta(find(nombreDelta(:,1)>2),:)=[];

 figure('color',[1 1 1]), hold on
for i=1:length(nbDelta)
subplot(1,3,1), hold on, plot(0.2:0.2:4,nb{i},'k'), xl=xlim; line(xl, [nombreDelta(:,1) nombreDelta(:,1)]','color',[0.7 0.7 0.7])
subplot(1,3,2), hold on, plot(0.2:0.2:4,nb2{i},'b'), xl=xlim; line(xl, [nombreDelta(:,1) nombreDelta(:,1)]','color',[0.7 0.7 0.7])
subplot(1,3,3), hold on, plot(0.2:0.2:4,nb3{i},'r'), xl=xlim; line(xl, [nombreDelta(:,1) nombreDelta(:,1)]','color',[0.7 0.7 0.7])
end


%%

k=28;

load('/Users/karimbenchenane/Dropbox/Mac/Downloads/matrix_data_paper.mat')
data=matrix_data_paper;
nam=matrix_data_paper_labels;

idG1=find(data(:,1)==1);
idG2=find(data(:,1)==2);
idG3=find(data(:,1)==3);
idG4=find(data(:,1)==4);

idG=find(data(:,1)>1);

data=data(idG,:);

%data=data+rand(size(data,1),size(data,2))/1E4;
data(data==0)=data(data==0)+rand(size(data(data==0),1),size(data(data==0),2))/1E3;
data(find(data(:,1)==2),1)=3;
%data(find(data(:,1)==2),1)=2.5;
%data(find(data(:,1)==3),1)=2.5;
%
%liste=[2:size(data,2)];
%liste=[2:20,21,23,24,26,27,28];
% liste=[2:19,size(data,2)];
%liste=[1:3:size(data,2)];
%liste=[1,2,3,4,11,12,13,20,21,22,28];
liste=[2,3,5,6,8,9,11,12,14,15,17,18,20,21,23,24,26,27,28];

le=length(liste);
data=data(:,liste);
nam=nam(liste);

% liste=[2:size(data,2)];
% le=length(liste);
% data=data(:,liste);
% nam=nam(liste);

% idelete=find(data(:,1)>1);
% data(idelete,:)=[];

d=zscore(data);
if 0
    figure, 
    subplot(2,1,1),hold on,
    plot(data(idG1,:)','ko-')
    plot(data(idG2,:)','ro-')
    plot(data(idG3,:)','ro-')
    plot(data(idG4,:)','bo-','markerfacecolor','b')
    set(gca,'XTick',1:length(nam),'XTickLabel',nam);
    ylim([0 109])
    xlim([0.1 le+0.9])
    subplot(2,1,2),hold on,
    plot(d(idG1,:)','ko-')
    plot(d(idG2,:)','ro-')
    plot(d(idG3,:)','ro-')
    plot(d(idG4,:)','bo-','markerfacecolor','b')
    set(gca,'XTick',1:length(nam),'XTickLabel',nam);
    xlim([0.1 le+0.9])
end

k=find(liste==k);
id=[1:size(data,2)];id(k)=[];
dataC=data(:,id);
val=data(:,k);



glmModels = fitglm(dataC, val,'Distribution', 'normal', 'Link', 'reciprocal');
predictions = predict(glmModels, dataC);

pval=glmModels.Coefficients{:,'pValue'};pval(1)=[];
coef=glmModels.Coefficients{:,'Estimate'};coef(1)=[];

[BE,idx]=sort(val);
idp=find(pval<0.05);
id=id';
figure, 
subplot(3,1,1),plot(val(idx),'ko'), hold on, plot(predictions(idx),'r*'), title(nam{k})
% plot(idx(idG1),val(idx(idG1)),'ko','markerfacecolor','k')
% plot(idx(idG4),val(idx(idG4)),'ko','markerfacecolor','r')
subplot(3,1,2), plot(pval,'ko-'), line(xlim,[0.05 0.05])
hold on, plot((idp),pval(idp),'ko','markerfacecolor','r')
set(gca,'XTick',1:length(nam(id)),'XTickLabel',nam(id));
subplot(3,1,3), plot(abs(coef),'ko-')
set(gca,'XTick',1:length(nam(id)),'XTickLabel',nam(id));
glmModels


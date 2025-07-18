function [R,R2]=AnalysisZap2(Mt,NumSouris,lim)

plo=1;

%num=5;
figure('color',[1 1 1])
num=gcf;

smo=50;

A=[];
for k=lim
    SignalPar=zscore(smooth(Mt{NumSouris,4,k},smo));
    SignalPfc=zscore(smooth(Mt{NumSouris,3,k},smo));
    SignalBO=zscore(smooth(Mt{NumSouris,2,k},smo));
    SignalRespi=zscore(smooth(Mt{NumSouris,1,k},smo));
    Mat=[rescale(SignalRespi',-1,1);rescale(SignalBO',-1,1);rescale(SignalPfc',-1,1);rescale(SignalPar',-1,1)];
    A=[A;Mat];
end



B=[];
for k=lim
    SignalPar=smooth(Mt{NumSouris,4,k},100);
    SignalPfc=smooth(Mt{NumSouris,3,k},100);
    SignalBO=smooth(Mt{NumSouris,2,k},100);
    SignalRespi=smooth(Mt{NumSouris,1,k},100);
    Mat=[rescale(SignalRespi',-1,1);rescale(SignalBO',-1,1);rescale(SignalPfc',-1,1);rescale(SignalPar',-1,1)];
    B=[B;Mat];
end


C=[];
for k=lim
    SignalPar=smooth(Mt{NumSouris,4,k},100);
    SignalPfc=smooth(Mt{NumSouris,3,k},100);
    SignalBO=smooth(Mt{NumSouris,2,k},100);
    SignalRespi=smooth(Mt{NumSouris,1,k},100);
    Mat=[SignalRespi';SignalBO';SignalPfc';SignalPar'];
    C=[C;Mat];
end




mask=A(1:4:end,:);
mask(abs(mask)<0.5)=0;
mask(abs(mask)>0.5)=1;


temp=A(1:4:end,:); R(1)=(nanstd(temp(mask==1))-nanstd(temp(mask==0)))./nanstd(temp(mask==0))*100;
temp=A(2:4:end,:); R(2)=(nanstd(temp(mask==1))-nanstd(temp(mask==0)))./nanstd(temp(mask==0))*100;
temp=A(3:4:end,:); R(3)=(nanstd(temp(mask==1))-nanstd(temp(mask==0)))./nanstd(temp(mask==0))*100;
temp=A(4:4:end,:); R(4)=(nanstd(temp(mask==1))-nanstd(temp(mask==0)))./nanstd(temp(mask==0))*100;

temp=B(1:4:end,:); R(5)=(nanstd(temp(mask==1))-nanstd(temp(mask==0)))./nanstd(temp(mask==0))*100;
temp=B(2:4:end,:); R(6)=(nanstd(temp(mask==1))-nanstd(temp(mask==0)))./nanstd(temp(mask==0))*100;
temp=B(3:4:end,:); R(7)=(nanstd(temp(mask==1))-nanstd(temp(mask==0)))./nanstd(temp(mask==0))*100;
temp=B(4:4:end,:); R(8)=(nanstd(temp(mask==1))-nanstd(temp(mask==0)))./nanstd(temp(mask==0))*100;

temp=C(1:4:end,:); R(9)=(nanstd(temp(mask==1))-nanstd(temp(mask==0)))./nanstd(temp(mask==0))*100;
temp=C(2:4:end,:); R(10)=(nanstd(temp(mask==1))-nanstd(temp(mask==0)))./nanstd(temp(mask==0))*100;
temp=C(3:4:end,:); R(11)=(nanstd(temp(mask==1))-nanstd(temp(mask==0)))./nanstd(temp(mask==0))*100;
temp=C(4:4:end,:); R(12)=(nanstd(temp(mask==1))-nanstd(temp(mask==0)))./nanstd(temp(mask==0))*100;



for a=1:length(lim)
    
    mask2=mask(a,:); 
    temp=A(1:4:end,:); temp2=temp(a,:); R2(1,a)=(nanstd(temp2(mask2==1))-nanstd(temp(mask2==0)))./nanstd(temp(mask2==0))*100;
    temp=A(2:4:end,:); temp2=temp(a,:); R2(2,a)=(nanstd(temp2(mask2==1))-nanstd(temp(mask2==0)))./nanstd(temp(mask2==0))*100;
    temp=A(3:4:end,:); temp2=temp(a,:); R2(3,a)=(nanstd(temp2(mask2==1))-nanstd(temp(mask2==0)))./nanstd(temp(mask2==0))*100;
    temp=A(4:4:end,:); temp2=temp(a,:); R2(4,a)=(nanstd(temp2(mask2==1))-nanstd(temp(mask2==0)))./nanstd(temp(mask2==0))*100;

    temp=B(1:4:end,:); temp2=temp(a,:); R2(5,a)=(nanstd(temp2(mask2==1))-nanstd(temp(mask2==0)))./nanstd(temp(mask2==0))*100;
    temp=B(2:4:end,:); temp2=temp(a,:); R2(6,a)=(nanstd(temp2(mask2==1))-nanstd(temp(mask2==0)))./nanstd(temp(mask2==0))*100;
    temp=B(3:4:end,:); temp2=temp(a,:); R2(7,a)=(nanstd(temp2(mask2==1))-nanstd(temp(mask2==0)))./nanstd(temp(mask2==0))*100;
    temp=B(4:4:end,:); temp2=temp(a,:); R2(8,a)=(nanstd(temp2(mask2==1))-nanstd(temp(mask2==0)))./nanstd(temp(mask2==0))*100;

    temp=C(1:4:end,:); temp2=temp(a,:); R2(9,a)=(nanstd(temp2(mask2==1))-nanstd(temp(mask2==0)))./nanstd(temp(mask2==0))*100;
    temp=C(2:4:end,:); temp2=temp(a,:); R2(10,a)=(nanstd(temp2(mask2==1))-nanstd(temp(mask2==0)))./nanstd(temp(mask2==0))*100;
    temp=C(3:4:end,:); temp2=temp(a,:); R2(11,a)=(nanstd(temp2(mask2==1))-nanstd(temp(mask2==0)))./nanstd(temp(mask2==0))*100;
    temp=C(4:4:end,:); temp2=temp(a,:); R2(12,a)=(nanstd(temp2(mask2==1))-nanstd(temp(mask2==0)))./nanstd(temp(mask2==0))*100;
end




if plo

    figure(num),clf

    subplot(3,4,1), imagesc(A(1:4:end,:)),title(num2str(R(1))), hold on, plot(R2(1,:)*5,1:length(lim),'k','linewidth',2)
    subplot(3,4,2), imagesc(A(2:4:end,:)),title(num2str(R(2))), hold on, plot(R2(2,:)*20,1:length(lim),'k','linewidth',2)
    subplot(3,4,3), imagesc(A(3:4:end,:)),title(num2str(R(3))), hold on, plot(R2(3,:)*20,1:length(lim),'k','linewidth',2)
    subplot(3,4,4), imagesc(A(4:4:end,:)),title(num2str(R(4))), hold on, plot(R2(4,:)*20,1:length(lim),'k','linewidth',2)

    subplot(3,4,5), imagesc(B(1:4:end,:)),title(num2str(R(5))), hold on, plot(R2(5,:)*5,1:length(lim),'k','linewidth',2)
    subplot(3,4,6), imagesc(B(2:4:end,:)),title(num2str(R(6))), hold on, plot(R2(6,:)*20,1:length(lim),'k','linewidth',2)
    subplot(3,4,7), imagesc(B(3:4:end,:)),title(num2str(R(7))), hold on, plot(R2(7,:)*20,1:length(lim),'k','linewidth',2)
    subplot(3,4,8), imagesc(B(4:4:end,:)),title(num2str(R(8))), hold on, plot(R2(8,:)*20,1:length(lim),'k','linewidth',2)

    subplot(3,4,9), imagesc(C(1:4:end,:)),title(num2str(R(9))), hold on, plot(R2(9,:)*5,1:length(lim),'k','linewidth',2)
    subplot(3,4,10), imagesc(C(2:4:end,:)),title(num2str(R(10))), hold on, plot(R2(10,:)*5,1:length(lim),'k','linewidth',2)
    subplot(3,4,11), imagesc(C(3:4:end,:)),title(num2str(R(11))), hold on, plot(R2(11,:)*5,1:length(lim),'k','linewidth',2)
    subplot(3,4,12), imagesc(C(4:4:end,:)),title(num2str(R(12))), hold on, plot(R2(12,:)*5,1:length(lim),'k','linewidth',2)

end




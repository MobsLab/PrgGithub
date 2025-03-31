function [Spnew,tnew]=DownSampleSpectra(Sp,t,fact)

q=1;
for k=fact:fact:length(t)-fact
Spnew(q,:)=mean(Sp(k:k+fact,:));
tnew(q)=mean(t(k:k+fact));
q=q+1;
end

end
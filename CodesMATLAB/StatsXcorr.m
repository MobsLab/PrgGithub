function [C,lag,P,CPM,CPm]=StatsXcorr(S1,S2,Freq,nbootstrap)

% S1 est la reference
% Freq: frequance d'acquisition
%
% p proba
% CPM SEM




if size(S1)~=size(S2)
    disp('erroe format S1 ans S2')

else
    
if size(S1,1)==1
    transp=1;
    S1=S1';
    S2=S2';
else
    transp=0;
end


try
    nbootstrap;
catch
    nbootstrap=1000;
end


[C,lag] = xcorr(S1,S2,'coeff'); % ref: F= field

lags=lag/Freq;

CP=[];

for i=1:nbootstrap
    [Cr, lagr] = xcorr(S1(randperm(length(S1))),S2(randperm(length(S2))),'coeff');
    lagsr=lagr/Freq;
    CP=[CP,Cr];
end

CPM=max(CP')';
CPm=min(CP')';

Cp=C;
Cp(find(C>CPm&C<CPM))=0;

P=ones(length(C),1);
P(find(C>CPm&C<CPM))=0;  
        

if 0

    figure('Color',[1 1 1]), hold on
    plot(lags,CPm,'r','linewidth',2)
    plot(lags,CPM,'r','linewidth',2)
    plot(lags,C,'k','linewidth',2)

end

        
if transp==1
    C=C';
    P=P';
else
    lags=lags';
    
end

end

        
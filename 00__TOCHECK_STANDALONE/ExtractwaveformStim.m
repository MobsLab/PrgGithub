function [spikes,tps,Epoch1]=ExtractwaveformStim(numSession,numChannel,numchannels)

% [spikes,tps]=ExtractwaveformStim(numSession,numChannel,numchannels)
%
% numSession
% numChannel
% numchannels
%
%


load behavResources

plo=0;

SetCurrentSession

for i=1:length(numSession)
    Epoch=intervalSet(tpsdeb{numSession(i)}*1E4,tpsfin{numSession(i)}*1E4);
    try
        Epoch1=or(Epoch,Epoch1);
    catch
        Epoch1=Epoch;
    end

end



Epoch1=mergeCloseIntervals(Epoch1,10);

stim1=Restrict(stim,Epoch1);
st=Range(stim1,'s');



Data=[];
    for i=1:length(st)
        [data,indices] = GetWideBandData(numChannel,'intervals',[st(i)-0.003 st(i)+0.005]);
        Data=[Data;data(:,2)'];
    end
    
    a=1;
for n=numchannels
    
    Data2=[];
    for i=1:length(st)
        [data,indices] = GetWideBandData(n,'intervals',[st(i)-0.003 st(i)+0.005]);
        Data2=[Data2;data(:,2)'];
    end
    Mref=Data;
    M=Data2;
    le=size(Mref,1);
    si=size(Mref,2);
    M2{a}=[zeros(le,40)];
    for i=1:le
        try
            [ME,id]=min(Mref(i,:));
            M2{a}(i,1:40)=M(i,id-15:id+24);
        end
    end

    if plo
    figure(1),clf
    subplot(2,1,1), imagesc(M2{a})
    subplot(2,1,2), plot(mean(M2{a}),'k','linewidth',2), title(num2str(n)), ylim([-1200 600])

    pause(2)
    end
    a=a+1;
end





clear spikes
for j=1:length(numchannels)

    spikes(:,j,:)=M2{j}(:,5:36);

end
% spikes(:,2,:)=M2{12}(:,5:36);
% spikes(:,3,:)=M2{13}(:,5:36);
% spikes(:,4,:)=M2{14}(:,5:36);
tps=Range(stim1,'s');



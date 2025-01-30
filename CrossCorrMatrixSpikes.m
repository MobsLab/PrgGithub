
Epoch=or(Epoch1,Epoch3);
Epoch=Epoch1;

tbin=10;
nbbins=80;

tbin=1;
nbbins=30;


figure('color',[1 1 1]), hold on

k=2;

l=2;
[C,B] = CrossCorr(Range(Restrict(S{k},Epoch)), Range(Restrict(S{l},Epoch)), tbin,nbbins); C(B==0)=0; if tbin==1, id=find(B==0);C([id-2,id-1,id+1])=0;end
subplot(4,4,13)
bar(B,C,1,'g')
yl=ylim;
hold on, line([0 0],[0 yl(2)],'color','r')
xlim([-nbbins*tbin/2 nbbins*tbin/2])

l=3;
[C,B] = CrossCorr(Range(Restrict(S{k},Epoch)), Range(Restrict(S{l},Epoch)), tbin,nbbins);
subplot(4,4,9)
bar(B,C,1,'k')
yl=ylim;
hold on, line([0 0],[0 yl(2)],'color','r')
xlim([-nbbins*tbin/2 nbbins*tbin/2])

l=4;
[C,B] = CrossCorr(Range(Restrict(S{k},Epoch)), Range(Restrict(S{l},Epoch)), tbin,nbbins);
subplot(4,4,5)
bar(B,C,1,'k')
yl=ylim;
hold on, line([0 0],[0 yl(2)],'color','r')
xlim([-nbbins*tbin/2 nbbins*tbin/2])

l=6;
[C,B] = CrossCorr(Range(Restrict(S{k},Epoch)), Range(Restrict(S{l},Epoch)), tbin,nbbins);
subplot(4,4,1)
bar(B,C,1,'k')
yl=ylim;
hold on, line([0 0],[0 yl(2)],'color','r')
xlim([-nbbins*tbin/2 nbbins*tbin/2])



k=3;

l=3;
[C,B] = CrossCorr(Range(Restrict(S{k},Epoch)), Range(Restrict(S{l},Epoch)), tbin,nbbins);C(B==0)=0;
subplot(4,4,10)
bar(B,C,1,'b')
yl=ylim;
hold on, line([0 0],[0 yl(2)],'color','r')
xlim([-nbbins*tbin/2 nbbins*tbin/2])

l=4;
[C,B] = CrossCorr(Range(Restrict(S{k},Epoch)), Range(Restrict(S{l},Epoch)), tbin,nbbins);
subplot(4,4,6)
bar(B,C,1,'k')
yl=ylim;
hold on, line([0 0],[0 yl(2)],'color','r')
xlim([-nbbins*tbin/2 nbbins*tbin/2])

l=6;
[C,B] = CrossCorr(Range(Restrict(S{k},Epoch)), Range(Restrict(S{l},Epoch)), tbin,nbbins);
subplot(4,4,2)
bar(B,C,1,'k')
yl=ylim;
hold on, line([0 0],[0 yl(2)],'color','r')
xlim([-nbbins*tbin/2 nbbins*tbin/2])

k=4;

l=4;
[C,B] = CrossCorr(Range(Restrict(S{k},Epoch)), Range(Restrict(S{l},Epoch)), tbin,nbbins);C(B==0)=0;
subplot(4,4,7)
bar(B,C,1,'c')
yl=ylim;
hold on, line([0 0],[0 yl(2)],'color','r')
xlim([-nbbins*tbin/2 nbbins*tbin/2])

l=6;
[C,B] = CrossCorr(Range(Restrict(S{k},Epoch)), Range(Restrict(S{l},Epoch)), tbin,nbbins);
subplot(4,4,3)
bar(B,C,1,'k')
yl=ylim;
hold on, line([0 0],[0 yl(2)],'color','r')
xlim([-nbbins*tbin/2 nbbins*tbin/2])



k=6;

l=6;
[C,B] = CrossCorr(Range(Restrict(S{k},Epoch)), Range(Restrict(S{l},Epoch)), tbin,nbbins);C(B==0)=0;
subplot(4,4,4)
bar(B,C,1,'r')
yl=ylim;
hold on, line([0 0],[0 yl(2)],'color','r')
xlim([-nbbins*tbin/2 nbbins*tbin/2])












Epoch=intervalSet(0,s(end,1)*1E4);
le=length(S);
tbin=1;
nbbins=30;
figure('color',[1 1 1]), hold on
a=1;
for k=12:le
for l=k:le
figure('color',[1 1 1]), hold on

[C,B] = CrossCorr(Range(Restrict(S{k},Epoch)), Range(Restrict(S{l},Epoch)), tbin,nbbins); if l==k, C(B==0)=0; end
bar(B,C,1,'k')
yl=ylim;
hold on, line([0 0],[0 yl(2)],'color','r')
xlim([-nbbins*tbin/2 nbbins*tbin/2])
title([cellnames{k},' vs ',cellnames{l}])
eval(['saveFigure(','1',',''Croosneuron',num2str(a),''',''/Users/karimbenchenane/Dropbox/MMNP3b'')'])
a=a+1;
close
end

end



tbin=10;
nbbins=80;

a=1;
for k=1:le
for l=k:le
figure('color',[1 1 1]), hold on

[C,B] = CrossCorr(Range(Restrict(S{k},Epoch)), Range(Restrict(S{l},Epoch)), tbin,nbbins); if l==k, C(B==0)=0; end
bar(B,C,1,'k')
yl=ylim;
hold on, line([0 0],[0 yl(2)],'color','r')
xlim([-nbbins*tbin/2 nbbins*tbin/2])
title([cellnames{k},' vs ',cellnames{l}])
eval(['saveFigure(','1',',''CroosLargeneuron',num2str(a),''',''/Users/karimbenchenane/Dropbox/MMNP3b'')'])
a=a+1;
close
end

end




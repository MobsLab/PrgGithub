epoch = and(GoodEpoch200,hab);
epocht = hab;
figure,
hold on;
% subplot(3,1,1), hold on,plot(Range(Restrict(LinearTrueTsd36,epocht)), Data(Restrict(LinearTrueTsd36,epocht)), 'k-', 'linewidth', 0.5)
% plot(Range(Restrict(LinearPredTsd36,epoch)), Data(Restrict(LinearPredTsd36,epoch)), 'r.', 'markersize', 2)
subplot(3,1,2), hold on,plot(Range(Restrict(LinearTrueTsd200,epocht)), Data(Restrict(LinearTrueTsd200,epocht)), 'r', 'linewidth', 2, 'DisplayName', 'True Position')
plot(Range(Restrict(LinearPredTsd200,epoch)), Data(Restrict(LinearPredTsd200,epoch)), 'b.', 'markersize', 15)
% subplot(3,1,3), hold on,plot(Range(Restrict(LinearTrueTsd504,epocht)), Data(Restrict(LinearTrueTsd504,epocht)), 'k', 'linewidth', 0.5)
% plot(Range(Restrict(LinearPredTsd504,epoch)), Data(Restrict(LinearPredTsd504,epoch)), 'r.', 'markersize', 2)


id=find(SI>1);
spk=PoolNeurons(S,id);
subplot(3,1,2), plot(Range(Restrict(spk,hab)),0.2,'ko', 'markerfacecolor', 'b')


% plot(Range(Restrict(spk,hab),'s'),0.3,'bo')
% plot(Range(Restrict(spk,hab)),0.3,'bo')
% id=find(SI>0.8);
% spk=PoolNeurons(S,id);
% plot(Range(Restrict(spk,hab)),0.2,'b.')
% id=find(SI>1);
% spk=PoolNeurons(S,id);
% plot(Range(Restrict(spk,hab)),0.2,'b.')
% plot(Range(Restrict(spk,hab)),0.2,'g.')
% plot(Range(Restrict(spk,hab)),0.2,'go')
% plot(Range(Restrict(spk,hab)),0.2,'ko','markerfacecolor','b')
% plot(Range(Restrict(spk,hab)),0.2,'ko','markerfacecolor','b')
% id=find(SI>0.9);
% spk=PoolNeurons(S,id);
% plot(Range(Restrict(spk,hab)),0.3,'ko','markerfacecolor','m')
% id
% 
% id =
% 
%     16    17    21
% 
% m=map{id(1)}.rate/max(max(map{id(1)}.rate));
% for k=id
%  m=m+map{k}.rate/max(max(map{k}.rate));
%  end
%    

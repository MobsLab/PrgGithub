function [X,Y,px,py]=TestRealignSpike(Pos,spk,beg, en,ploo)

try
    ploo;
catch
    ploo=0;
end

if ploo(1)==0
    
 figure('Color',[1 1 1])
            
a=1;
for deb=-9:2:9
    for fin=-9:2:9
            tps=Pos(:,1);
            tps=rescale(tps,beg,en-fin-deb)*1E4+deb*1E4;
            X=tsd(tps,Pos(:,2));
            Y=tsd(tps,Pos(:,3));
            px =Data(Restrict(X,spk,'align','closest'));
            py =Data(Restrict(Y,spk,'align','closest'));
            subplot(10,10,a),hold on, plot(Data(X),Data(Y),'Color',[0.7 0.7 0.7])
            plot(px,py,'r.'),plot(px(floor(length(px)/2)),py(floor(length(px)/2)),'bo','MarkerFaceColor','b')%, xlim(xl); ylim(yl);


            a=a+1;
    end
end



else
    
    deb=ploo(1);
    fin=ploo(2);
 figure('Color',[1 1 1])
            tps=Pos(:,1);
            tps=rescale(tps,beg,en-fin-deb)*1E4+deb*1E4;
            X=tsd(tps,Pos(:,2));
            Y=tsd(tps,Pos(:,3));
            px =Data(Restrict(X,spk,'align','closest'));
            py =Data(Restrict(Y,spk,'align','closest'));
            hold on, plot(Data(X),Data(Y),'Color',[0.7 0.7 0.7])
            plot(px,py,'r.'),plot(px(floor(length(px)/2)),py(floor(length(px)/2)),'bo','MarkerFaceColor','b')%, xlim(xl); ylim(yl);


    
end


            tps=rescale(tps,beg,en)*1E4;
            X=tsd(tps,Pos(:,2));
            Y=tsd(tps,Pos(:,3));
            px =Data(Restrict(X,spk,'align','closest'));
            py =Data(Restrict(Y,spk,'align','closest'));
            

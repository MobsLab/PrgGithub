function position=extractpos(fname,totmask)


for i=1:length(files)
    eval(strcat('load(''',files(i).name,''')'))
    
    if i==1
        t0=datas.time;
    end
    
        position(1,i)=datas.centroids(1);
        position(2,i)=datas.centroids(2);
    position(3,i)=etime(datas.time,t0);
    if i~=1
        position(4,i)=sum(sum(datas.image-lastimage));
    end
    lastimage=datas.image;
    
end
imagesc(datas.image);

a=totmask(max(floor(position(2,:)),1),max(floor(position(1,:)),1));
g=dia(a);
ind=find(~g);
hold on
scatter(position(1,:),position(2,:),'r')
scatter(position(1,ind),position(2,ind),'g')
position(1,ind)=NaN;
position(2,ind)=NaN;

end

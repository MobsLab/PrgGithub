function [val,tiden,tadv,tdelay]=MinimalDistanceEvents(trainref,train)

tiden=[];
tadv=[];
tdelay=[];

try
    
if trainref==train
    
    for i=1:length(trainref)
        traintemp=train;
        traintemp(i)=[];
            v=abs(traintemp-trainref(i));
            v2=traintemp-trainref(i);
            [vmin,id]=min(v);
            if vmin==0
                val(i)=0;
                tiden=[tiden,trainref(i)];
            else
                val(i)=vmin*v2(id(1))/abs(v2(id(1)));
                if v2(id(1))/abs(v2(id(1)))>0
                    tadv=[tadv,trainref(i)];
                else
                    tdelay=[tdelay,trainref(i)];
                end
            end
    end
        
    
else
    
        for i=1:length(trainref)
            v=abs(train-trainref(i));
            v2=train-trainref(i);
            [vmin,id]=min(v);
            if vmin==0
                val(i)=0;
                tiden=[tiden,trainref(i)];
            else
                val(i)=vmin*v2(id(1))/abs(v2(id(1)));
                if v2(id(1))/abs(v2(id(1)))>0
                    tadv=[tadv,trainref(i)];
                else
                    tdelay=[tdelay,trainref(i)];
                end
            end
        end

end



catch
    
 for i=1:length(trainref)
            v=abs(train-trainref(i));
            v2=train-trainref(i);
            [vmin,id]=min(v);
            if vmin==0
                val(i)=0;
                tiden=[tiden,trainref(i)];
            else
                val(i)=vmin*v2(id(1))/abs(v2(id(1)));
                if v2(id(1))/abs(v2(id(1)))>0
                    tadv=[tadv,trainref(i)];
                else
                    tdelay=[tdelay,trainref(i)];
                end
            end
 end
        
end



function dur=FindEpochLength(t,varargin)

here=0;
maxp=size(varargin,2);
p=1;
while here(1)==0
    if p<maxp+1
    a=Restrict(ts(t),varargin{p});
    here=size(a);
    if here(1)~=0
        st=Start(varargin{p});
        ind=find((st-t)<0,1,'last');
      dur=Stop(subset(varargin{p},ind))-Start(subset(varargin{p},ind));
    end
    end
    p=p+1;
end
end

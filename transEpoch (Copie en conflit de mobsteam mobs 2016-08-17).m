function [aft_cell,bef_cell]=transEpoch(varargin)

%aft_cell(i,j)=intervalset of Epochi that is followed by EPochj
%bef_cell(i,j)=intervalset of Epochi that follows EPochj

k=size(varargin,2);
aft_cell=cell(k,k);
for i=1:k
    bef=Stop(varargin{i});
    for j=1:k
        if i~=j
            aft=Start(varargin{j});
            ind=[];
          for t=1:length(bef)
            if sum(bef(t)==aft)==1
                ind=[ind t];
            end
          end
            aft_cell{i,j}=subset(varargin{i},ind);
        end
    end
end
  
bef_cell=cell(k,k);
for i=1:k
    bef=Start(varargin{i});
    for j=1:k
        if i~=j
            aft=Stop(varargin{j});
            ind=[];
          for t=1:length(bef)
            if sum(bef(t)==aft)==1
                ind=[ind t];
            end
          end
            bef_cell{i,j}=subset(varargin{i},ind);
        end
    end
end
end  

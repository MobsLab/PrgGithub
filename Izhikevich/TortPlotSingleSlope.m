function [spkformB,spkformR,spkformK]=TortPlotSingleSlope(Vlt,spkwidth,firings,Ne,Nfs,No)


%%TortPlotSlope
    
N=Ne+Nfs+No;
spkformB=[];
spkformR=[];
spkformK=[];




spkwidth=spkwidth*10;

tic

a=1;

for i=1:Ne
    temp=firings(find(firings(:,2)==i),1)*10;
    
    for j=1:length(temp)
            try
            spkformK(a,:)=Vlt(i,[temp(j)-spkwidth:temp(j)+spkwidth]);
            a=a+1;  
            end
    end
end

clear temp

a=1;

for i=Ne+1:Ne+Nfs
    temp=firings(find(firings(:,2)==i),1)*10;

    for j=1:length(temp)
        
            try
            spkformR(a,:)=Vlt(i,[temp(j)-spkwidth:temp(j)+spkwidth]);
            a=a+1;  
            end
        
    end
end

clear temp




a=1;

for i=Ne+Nfs+1:Ne+Nfs+No

    temp=firings(find(firings(:,2)==i),1)*10;

    for j=1:length(temp)

            try
            spkformB(a,:)=Vlt(i,[temp(j)-spkwidth:temp(j)+spkwidth]);
            a=a+1;  
            end


    end
end

toc

clear temp











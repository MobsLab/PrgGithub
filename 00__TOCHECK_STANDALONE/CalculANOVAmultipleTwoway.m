function  [p,t,st,Pt1,Pt2,Pt3,group]=CalculANOVAmultipleTwoway(A,B)

if length(B)==length(A)
    
    X=[];
    G1=[];
    G2=[];
    for i=1:length(A)
    if length(A{i})>1
    X=[X;A{i}];
    G1=[G1;i*ones(size(A{i},1),1)];
    G2=[G2;1*ones(size(A{i},1),1)];
    end
    end

    for i=1:length(B)
    if length(B{i})>1
    X=[X;B{i}];
    G1=[G1;i*ones(size(A{i},1),1)];
    G2=[G2;2*ones(size(A{i},1),1)];
    end
    end



    group{1}=G1;
    group{2}=G2;
    [p,t,st] = anovan(X, group,'model','full');

    comp=multcompare(st);

    % [anvA, anvB, anvAB] = TwoWayAnova(X, GA, GB);

    for i=1:length(A)
        for j=i+1:length(A)
    [h,Pt1{i,j}]=ttest2(A{i},A{j});
        end
    end

    for i=1:length(A)
        for j=i+1:length(A)
    [h,Pt2{i,j}]=ttest2(A{i},A{j});
        end
    end

    for i=1:length(A)
        for j=i:length(B)
    [h,Pt3{i,j}]=ttest2(A{i},B{j});
        end
    end



end


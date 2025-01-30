function Mout=CleanLocalGlobal(M,th,i)

try
    i;
    
   [rows,cols,vals] =find(M{i}>th|M{i}<-th);
   M{i}(rows,:)=[];
   
   Mout=M{i};
   
catch
    
   [rows,cols,vals] =find(M>th|M<-th);
   M(rows,:)=[];
   
   Mout=M;
    
    
    
end





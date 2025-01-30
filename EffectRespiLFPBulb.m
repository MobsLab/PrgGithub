function [M,Mo,Mf,Ms,tp,id]=EffectRespiLFPBulb(tsa,tps,Epoch,plo,idx)

     tref=Restrict(ts(tps*1E4),Epoch);
     tref=Range(tref);
    
     if length(idx)<1
        idx=[1:length(tref)]; 
     end
         
     try
         idx;
         if idx(end)>length(tref)
             idx=idx(1):length(tref);
         end
     catch
         idx=[1:length(tref)];
     end
     
if length(tref(idx))>50

    figure, [fh, rasterAx, histAx, matVal] = ImagePETH(tsa, ts(tref(idx)), -5000, +6000,'BinSize',1000); 
    if plo==0
        close
    end
    M=Data(matVal)';
    tp=Range(matVal);
    [Mo,Mf,Ms,id]=ReordPCA(M,400:600);

else
    disp(['too short, ',num2str(length(tref(idx))), ' cycles'])
      M=[];  
      Mo=[];  
      Mf=[];  
      Ms=[];  
      id=[];  
      tp=[];  
end


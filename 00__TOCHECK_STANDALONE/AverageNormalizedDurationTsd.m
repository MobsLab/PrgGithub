function [A,S,tps]=AverageNormalizedDurationTsd(Stsd,Epoch,numbin,plo)

try
    plo;
catch
    plo=1;
end

tps=[0 1/(numbin-1) 1];

for i=1:length(Start(Epoch))
  
  tp=ts([Start(subset(Epoch,i)):(End(subset(Epoch,i))-Start(subset(Epoch,i)))/(numbin-1):End(subset(Epoch,i))]);
  S{i}=Data(Restrict(Stsd,tp));
  
  if i==1
      A=S{1}';
  else
      A=A+S{i}';
  end
    
end

if plo
figure, imagesc(A), axis xy
end

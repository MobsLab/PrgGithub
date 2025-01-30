function PlotErrorBar(A,info)

% if info=0 sans les zeros

try
info;
catch
info=1;
end


taille=size(A,2);

%  for i=1:taille
%  
%  	E(i)=stdError(A(:,i));
%  
%  end



% if info==0
% 
% [R,S,E]=MeanDifZero(A);
% 
% else

[R,S,E]=MeanDifNan(A);

% end

if info~=0
    figure('Color',[1 1 1]),
end

errorbar(R,E,'+','Color','k')

hold on, bar(R,'k')

xlim([0 taille+1])



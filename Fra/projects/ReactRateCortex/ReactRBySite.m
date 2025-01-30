


r_site = zeros(12, 12);
n_site = zeros(12, 12);

for i = 1:12
  for j = 1:12
    ix = find(CellColumn == j & CellRow == i);
    n = sum(isfinite(X_MS1(ix)+ X_S2S1(ix)));

    if n > 10
      r = nancorrcoef(X_MS1(ix), X_S2S1(ix));
      r = r(2,1);
    else
      r = NaN;
    end
    
      
    r_site(i,j) = r;
    n_site(i,j) = n;
  end
end



figure(1), clf


 imagesc(r_site);
 axis xy
 
 
 for i = 1:12
   for j = 1:12
     if isnan(r_site(i,j))
       patch(j+[-0.5, -0.5, 0.5, 0.5], i+[0.5, -0.5, -0.5, 0.5], ...
	     [0.5, 0.5, 0.5], 'EdgeColor', 'none');
     
     end    
     text(j-0.45, i+0.1, num2str(n_site(i,j)), 'fontSize', 14, 'FontName', ...
	  'Arial', 'FontWeight', 'bold');
   end
 end
 
 set(gca, 'xtick', 1:12, 'ytick', 1:12)
 set(gca, 'yticklabel', {'A', 'B', 'C', 'D', 'E', 'F', ...
		    'G', 'H', 'I', 'J', 'K', 'L'});
 
 colorbar



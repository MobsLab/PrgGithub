function [EV, EV_int] = ReactEVCV(x_s1_cv, x_s1, x_s2, x_m, alpha)
  
  
  
  if nargout == 1
  
  [a, b, r, p] = regression_line(x_s1_cv, x_m);
  res_m = x_m - a - b * x_s1_cv;
  
  if ~isfinite(a)
    EV = NaN;
    EV_int = [NaN NaN];
  end
  
    
  [a, b, r, p] = regression_line(x_s1, x_s2);
  res_s2 = x_s2 - a - b * x_s2;
  
  EV = ReactCC(res_m, res_s2);
  
  if nargin == 5
    EV = sign(EV) * EV^2;
  else
    EV = EV^2;
  end
  
    
  else
    
    alpha = 0.05;
    nboot = 20 * 2/alpha;
    
    n_points= length(x_s1);

    for i = 1:nboot
      ix = ceil(n_points * rand(n_points,1));
      try
	EV(i) = ReactEVCV(x_s1_cv(ix), x_s1(ix), x_s2(ix), x_m(ix), 1);
      catch
	EV(i) = NaN;
      end
      
    end
    
    EV = EV(find(isfinite(EV)));
    nboot = length(EV);
    EV = sort(EV);
    EV_int(1) = EV(max(floor(nboot * alpha / 2), 1));
    EV_int(2) = EV(floor(nboot * (1-alpha/2)));
    EV = ReactEVCV(x_s1_cv, x_s1, x_s2, x_m, 1);
    
  end
  
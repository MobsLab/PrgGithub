function pfh = hsvPlaceF(pf)

pf = gausssmooth(pf,20);
pfh = 1-((pf-min(pf(:)))/(1.5*(max(pf(:))-min(pf(:))))+0.333);
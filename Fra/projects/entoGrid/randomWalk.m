function [x, y] = randomWalk(n, cs)


  Hd = entoFilt;
  nx = unidrnd(3, 1, n) - 2;
  ny = unidrnd(3, 1, n) - 2;
  
  
  nxf = filter(Hd, nx);
  nyf = filter(Hd, ny);  
  
  x = cumsum(nxf);
  y = cumsum(nyf);
  [x,y] = cageWalls(x,y, cs);
  plot(x,y);
  

  
  
  
function [xc, yc] = cageWalls(x,y, cs)
  
  md = mod(floor(x/cs),2);
  xc(find(md)) = mod(x(find(md)),cs);
  xc(find(~md)) = cs-mod(x(find(~md)),cs);
   
  
  md = mod(floor(y/cs),2);
  yc(find(md)) = mod(y(find(md)),cs);
  yc(find(~md)) = cs-mod(y(find(~md)),cs);
   
  
 
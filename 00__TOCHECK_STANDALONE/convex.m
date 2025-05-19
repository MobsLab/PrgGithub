function c = convex(X)
% Array c is 1 where polygon is convex, -1 where curve is concave
%  Input: X = n by 2 array of x and y values

% Are Mjaavatten, November 2021

  n = size(X,1);
  Z = [X,zeros(n,1)];
  c = NaN(n,1);
  for i = 2:n-1
    cc = cross(Z(i,:)-Z(i-1,:),Z(i+1,:)-Z(i-1,:));
    c(i) = -sign(cc(3));
  end
  % Change sign if the points are not in clockwise order:
  clockwise = sign(sum(circshift(X(:,1),-1).*X(:,2)-X(:,1).*circshift(X(:,2),-1)));
  c = c*clockwise;
end
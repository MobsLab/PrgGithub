function montest()

x=[1;2];
tic
for i = 1:100000
   x(:, ones(3, 1));
end
toc
tic

for i = 1:100000
   repmat(x, [1 3]);
end
toc
end


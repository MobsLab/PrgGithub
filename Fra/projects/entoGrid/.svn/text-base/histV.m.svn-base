nh = 20;
s = 50/nh;

for i = 1:nh
    for j = 1:nh
        ix = find(xx > (i-1) * s & xx < i * s & yy > (j-1)*s & yy < j * s);
        C(i,j) = mean(Vconf(ncell,ix));
    end
end
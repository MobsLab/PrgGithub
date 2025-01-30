


ret1_1 = customgauss([1e2,1e3], 7, 30, 0, 0, 5, [30,300]);
ret1_2 = customgauss([1e2,1e3], 6, 20, 0, 0, 3, [20,260]);
ret1_3 = customgauss([1e2,1e3], 8, 40, 0, 0, 2, [8,220]);

ret1 = -ret1_1-ret1_2-ret1_3;

figure
mesh(ret1)
colormap jet


ret2_1 = customgauss([1e2,1e3], 6, 40, 0, 0, 4, [-25,300]);
ret2_2 = customgauss([1e2,1e3], 6, 40, 0, 0, 3, [-25,400]);
ret2_3 = customgauss([1e2,1e3], 6, 40, 0, 0, 3, [-25,150]);

ret2 = -ret2_1-ret2_2+ret2_3;

figure
mesh(ret2')
colormap jet



ret = ret1+ret2;

figure
mesh(ret)
colormap jet




l1 = linspace(-400,0,100); l2 = linspace(-50,50,100);
for i=1:30
    
    retx{i} = customgauss([1e2,1e3], 4+rand()*2, 40+rand()*20, 0, 0, 1+rand(), [l2(round(rand()*100)) l1(round(rand()*100))]);
    ret_all(i,:,:) = -retx{i};
    
end
ret_all2 = (squeeze(sum(ret_all)))./2;

subplot(121)
mesh(ret_all2)
subplot(122)
imagesc(ret_all2')



ret_f = ret+ret_all2;


figure
mesh(ret_f)
grid off
axis off
colormap jet
alpha .3
caxis([-5 0])


[H,B]=hist(Data(dist2WallTsd),[0.01:0.01:0.2]);
figure;
plot(B,H)
distHab = Restrict(dist2WallTsd,hab);
distCondi = Restrict(dist2WallTsd,condi);
distHabData = Data(distHab);
distCondiData = Data(distCondi);
distTestPost = Restrict(dist2WallTsd,testPost);
distTestPostData = Data(distTestPost);
mean(distHabData)
mean(distCondiData)
mean(distTestPostData)

dist2Walltsd = distanceToTheWall(X,Y);
figure, scatter(Data(X),Data(Y), 10,Data(dist2Walltsd),'filled')
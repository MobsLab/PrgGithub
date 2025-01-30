A = getResource(A,'CM',dset);
A = getResource(A,'FiringS1',dset);
A = getResource(A,'FiringS2',dset);

cM = cM{1};
firingS1 = zTransform(firingS1{1}');
firingS2 = zTransform(firingS2{1}');

nbCells = size(cM,1);
[V,D] = eig(cM);
Mask = diag(V(:,nbCells)>0.2);



t1 = size(firingS1,2);
t2 = size(firingS2,2);

R1 = zeros(t1,1);
R2 = zeros(t2,1);

R1M = zeros(t1,1);
R2M = zeros(t2,1);


for t=1:t1

	w = firingS1(:,t);
	R1(t) = w'*cM*w;

	w = Mask*firingS1(:,t);
	R1M(t) = w'*cM*w;

end


for t=1:t2

	w = firingS2(:,t);
	R2(t) = w'*cM*w;

	w = Mask*firingS2(:,t);
	R2M(t) = w'*cM*w;

end

R1 = conv(R1,gausswin(50));
R1 = R1(25:end-25);
R1M = conv(R1M,gausswin(50));
R1M = R1M(25:end-25);
%  
%  R1 = R1/max([R1;R1M]);
%  R1M = R1M/max([R1;R1M]);

R2 = conv(R2,gausswin(50));
R2 = R2(25:end-25);
R2M = conv(R2M,gausswin(50));
R2M = R2M(25:end-25);
%  
%  R2 = R2/max([R2;R2M]);
%  R2M = R2M/max([R2;R2M]);

R1M = R1M/max([R1M;R2M]);
R2M = R2M/max([R1M;R2M]);



figure(1),clf
subplot(2,1,1)
	plot([1:t1]/10,R1M)
subplot(2,1,2)
	plot([1:t2]/10,R2M)

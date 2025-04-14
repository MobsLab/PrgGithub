decoupage_hilbert

eta=0.01;
N=size(images,1);
efficiency=1;



images_normees=[]; %---images normalisees stockees ici
label=[]; %---label de chaque image, 1 avec un spike, -1 sinon
%----- Normalisation des images
for i = 1:N
	images_moyenne=images(i,2:end);
	for j = 2:size(images(i,2:end),2)-1
		images_moyenne(j)=(images(i,j)+images(i,j+1)+images(i,j+2))/3;
	end
    images_normees=[images_normees;abs(normalise(images(i,2:end)))];
    label=[label 2*images(i,1)-1];
end

%----- Generation des parametres
w=rand(1,bin_size*2);
w=normalise(w);







%----- Learning loop
training_error=N;
prw_training_error=N;
time=0;
while training_error>N*(1-efficiency)
	for i = 1:N
		scal_prod=sum(w.*images_normees(i,:));
		if scal_prod*label(i)<=0
			w=w+eta*label(i)*images_normees(i,:);
			w=normalise(w);
		end
	end

	training_error=0;
	for i = 1:N
		scal_prod=sum(w.*images_normees(i,:));
		if scal_prod*label(i)<=0
			training_error=training_error+1;
		end
	end
	time=time+1;
	training_error;

	if prw_training_error<training_error
		eta=eta/1.3;
		if eta < 0.00000001
			eta = 0.01;
		end
	end
	prw_training_error=training_error;

	if mod(time,15)==0
		time
		training_error
	end
end






subplot(2,1,1);
plot(images_normees(136,:));
subplot(2,1,2);
plot(w(:));
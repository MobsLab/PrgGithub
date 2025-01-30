decoupage_hilbert

subplot(2,1,1);
for i = 1:size(images,1)
	if images(i,1)==1
		plot(normalise(images(i,2:end)));hold on;
	end
end
subplot(2,1,2);
for j = 1:size(images2,1)
	if images2(j,1)==1
		plot(normalise(abs(images2(j,2:end))));hold on;
	end
end
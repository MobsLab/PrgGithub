function indec = get_1dec(model,trial);

dec = model.dec((trial-1)*model.num+1:trial*model.num,:);
wind = model.windows((trial-1)*model.num+1:trial*model.num,:);
rnum = model.num;
while (rnum>0)&(dec(rnum,1)==-1), rnum = rnum-1; end;
indec = dec(1:rnum,:);
indec(:,4) = indec(:,4)+wind(1:rnum,1);
indec(:,5) = indec(:,5)+wind(1:rnum,2);
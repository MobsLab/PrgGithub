val1=Data(Restrict(LinearPredTsd200,and(hab,GoodEpoch200)));
val2=Data(Restrict(LinearTrueTsd200,and(hab,GoodEpoch200)));
id = randperm(length(val1));
normalVSshuffled = [mean(abs(val1-val2)), mean(abs(val1(id)-val2)), mean(abs(val1-val2(id)))]

randomList = rand(length(val1), 1);
normalVSrandom = [mean(abs(val1-val2)), mean(abs(randomList-val2)), mean(abs(val1-randomList))]



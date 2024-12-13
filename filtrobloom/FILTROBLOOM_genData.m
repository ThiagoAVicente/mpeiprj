dic = readcell("save/reduced.csv");
userNames = dic(:,1);

save("save/output.mat", "userNames", '-mat');
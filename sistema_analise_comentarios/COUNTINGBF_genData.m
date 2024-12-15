dic = readcell("test_15000.csv");
users = dic(:,1);

save("save/output.mat", "users", '-mat');
formatSpec = '%C%f%f%f%f%C%C';

data = readtable('prestige.csv','Delimiter',',','Format',formatSpec); %load into table


%split data
y = table2array(data(:,5));
X = table2array(data(:,2:4));
[num_data,tmp] = size(X);
X = cat(2, ones(num_data,1),X); %adds an intercept

%compute the estimator

betahat = inv(X'*X)*X'*y;

% Fill in the blanks
betacov = ?
se_beta = ?

clear ; close all; clc
numCategories = 3;
%% Read in Saxophone Audio Files
soundFiles = dir('../../soundfiles/sax/*.wav'); 
numsfiles = length(soundFiles);
mydata = cell(1, numsfiles);

for k = 1:numsfiles
  fname = strcat('../../soundfiles/sax/', soundFiles(k).name);
  [mydata{k}, Fs] = audioread(fname);
end

minDim = size(mydata{1});

for k = 1:numsfiles
    [m, n] = size(mydata{k});
    minDim = min(minDim, m);
end

S = [];

for k = 1:numsfiles
    S = [S, mydata{k}(1:minDim,1)];
end

%% Read in Violin Audio 
soundFiles = dir('../../soundfiles/vio/*.wav'); 
numvfiles = length(soundFiles);
mydata = cell(1, numvfiles);

for k = 1:numvfiles
  fname = strcat('../../soundfiles/vio/', soundFiles(k).name);
  [mydata{k}, Fs] = audioread(fname); 
end

minDim = size(mydata{1});

for k = 1:numvfiles
    [m, n] = size(mydata{k});
    minDim = min(minDim, m);
end

V = [];

for k = 1:numvfiles
    V = [V, mydata{k}(1:minDim,1)];
end

%% Read in Piano Audio 
soundFiles = dir('../../soundfiles/pia/*.wav'); 
numpfiles = length(soundFiles);
mydata = cell(1, numpfiles);

for k = 1:numpfiles
  fname = strcat('../../soundfiles/pia/', soundFiles(k).name);
  [mydata{k}, Fs] = audioread(fname); 
end

minDim = size(mydata{1});

for k = 1:numpfiles
    [m, n] = size(mydata{k});
    minDim = min(minDim, m);
end

P = [];

for k = 1:numpfiles
    P = [P, mydata{k}(1:minDim,1)];
end

%% Merge all data matrix
[v1, temp] = size(V(:,1));
[p1, temp] = size(P(:,1));
[s1, temp] = size(S(:,1));
dim = min([v1 p1 s1]);

% The data matrix
D = [S(1:dim,:),P(1:dim,:),V(1:dim,:)];

%% Normal k-means++ clustering
D = D';
v = kmeans(D, 7);


%% Diffusion on weighted graph
% diff_cluster(D, numCategories, numpfiles, numsfiles, numvfiles)

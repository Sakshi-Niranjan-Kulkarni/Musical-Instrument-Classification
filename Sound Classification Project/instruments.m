clear ; close all; clc
numCategories = 3;
%% Read in Guitar Audio Files
soundFiles = dir('soundfiles/Guitar/*.wav'); 
numgfiles = length(soundFiles);
mydata = cell(1, numgfiles);

for k = 1:numgfiles
  fname = strcat('soundfiles/Guitar/', soundFiles(k).name);
  [mydata{k}, Fs] = audioread(fname); 
end

minDim = size(mydata{1});

for k = 1:numgfiles
    [m, n] = size(mydata{k});
    minDim = min(minDim, m);
end

G = [];

for k = 1:numgfiles
    G = [G, mydata{k}(1:minDim,1)];
end

%% Read in Violin Audio 
soundFiles = dir('soundfiles/Violin/*.mp3'); 
numvfiles = length(soundFiles);
mydata = cell(1, numvfiles);

for k = 1:numvfiles
  fname = strcat('soundfiles/Violin/', soundFiles(k).name);
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
soundFiles = dir('soundfiles/Piano/*.wav'); 
numpfiles = length(soundFiles);
mydata = cell(1, numpfiles);

for k = 1:numpfiles
  fname = strcat('soundfiles/Piano/', soundFiles(k).name);
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
[g1, temp] = size(G(:,1));
dim = min([v1 p1 g1]);

% The data matrix
D = [G(1:dim,:),P(1:dim,:),V(1:dim,:)];

%% Clustering data using diffusion on weighted graph
% Sigma value, pivotal to the clustering algorithm
sigma = 40;

% The size of the data matrix
[row, numSamples] = size(D);

% Graph Laplacian
L = zeros(numSamples, numSamples);

% Calculate the weight of each link in the graph
for i = 1:numSamples
   for j = 1:numSamples
       L(i, j) = exp(-(norm(D(:,i) - D(:, j))^2)/(2*sigma^2));
   end
end

for i = 1:numSamples
    L(i, i) = 0;
    for j = 1:numSamples
       if j ~= i
           L(i, i) = L(i, i) - L(i, j);
       end
    end
end

% Find eigenvalues and eigenvectors of the graph Laplacian
[Vec, Val] = eig(L);

% New matrix of leading numCategories eigenvectors of L
Dnew = zeros(numCategories, numSamples);

for i = 1:numCategories
   Dnew(i, :) = (Vec(:, numSamples - i + 1))';
end

scale = 1;

for i = 1:numgfiles
   plot3(Dnew(1, i)*scale,Dnew(2, i)*scale,Dnew(3, i)*scale,'.','MarkerSize',5);
   hold on;
end

for i = 1:numpfiles
   plot3(Dnew(1, i + numgfiles)*scale,Dnew(2, i + numgfiles)*scale,Dnew(3, i + numgfiles)*scale,'x','MarkerSize',5);
   hold on;
end
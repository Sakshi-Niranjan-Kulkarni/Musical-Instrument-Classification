clear ; close all; clc
%% Read in Guitar Audio Files
soundFiles = dir('soundfiles/Guitar/*.wav'); 
numfiles = length(soundFiles);
mydata = cell(1, numfiles);

for k = 1:numfiles
  fname = strcat('soundfiles/Guitar/', soundFiles(k).name);
  [mydata{k}, Fs] = audioread(fname); 
end

minDim = size(mydata{1});

for k = 1:numfiles
    [m, n] = size(mydata{k});
    minDim = min(minDim, m);
end

G = [];

for k = 1:numfiles
    G = [G, mydata{k}(1:minDim,1)];
end

%% Read in Violin Audio 
soundFiles = dir('soundfiles/Violin/*.mp3'); 
numfiles = length(soundFiles);
mydata = cell(1, numfiles);

for k = 1:numfiles
  fname = strcat('soundfiles/Violin/', soundFiles(k).name);
  [mydata{k}, Fs] = audioread(fname); 
end

minDim = size(mydata{1});

for k = 1:numfiles
    [m, n] = size(mydata{k});
    minDim = min(minDim, m);
end

V = [];

for k = 1:numfiles
    V = [V, mydata{k}(1:minDim,1)];
end

%% Read in Piano Audio 
soundFiles = dir('soundfiles/Piano/*.wav'); 
numfiles = length(soundFiles);
mydata = cell(1, numfiles);

for k = 1:numfiles
  fname = strcat('soundfiles/Piano/', soundFiles(k).name);
  [mydata{k}, Fs] = audioread(fname); 
end

minDim = size(mydata{1});

for k = 1:numfiles
    [m, n] = size(mydata{k});
    minDim = min(minDim, m);
end

P = [];

for k = 1:numfiles
    P = [P, mydata{k}(1:minDim,1)];
end

%% Merge all data matrix
[v1, temp] = size(V(:,1));
[p1, temp] = size(P(:,1));
[g1, temp] = size(G(:,1));
dim = min([v1 p1 g1]);

% The data matrix
D = [G(1:dim,:),P(1:dim,:),V(1:dim,:)];

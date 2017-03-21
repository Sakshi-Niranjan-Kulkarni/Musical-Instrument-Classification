%% Read in audio file
clear ; close all; clc
soundFiles = dir('soundfiles/Guitar/*.wav'); 
numfiles = length(soundFiles)
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

A = [];

for k = 1:numfiles
    A = [A, mydata{k}(1:minDim,1)];
end

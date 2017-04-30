% DFT: Discrete fourier transform: fft() in matlab

%Fourier transform vector's real part is always symmetric
% maindir = '/home/dan/math/150/project/';
path = string('../../soundfiles/');
%instr = ['gui/';'bss/';'vio/'];
instr = ['sax/';'pia/';'vio/'];
%instr = ['sax/';'pia/';'vio/';'tru/';'org/';'flu/';'gac/';'gel/';'sax/';'voi/'];
instr = string(instr);
minDim = 65773;

numCategories = 2;
numfiles = zeros(3,1);
n = 20;
D = [];
B = [];
% md = 1000000;
%for i = 1:size(instr,1)
for i = 1:numCategories
    folder = path+instr(i);
    folder = char(folder);
    files = dir(folder);
    files = files(3:end);
    for j = 1:size(files,1)
        numfiles(i,1) = size(files,1);
        name = string(folder)+string(files(j).name);
        name = char(name);
        [inst, fs] = audioread(name);
        % md = min(md, size(inst(:,1)));
        %inst = inst(1:int32(size(inst,1)*(2/440)));
        %inst = inst(1:500,:);
        [row1, col1, inst] = find(inst);
        %[m,k] = max(inst);
        %inst = inst(k:int32(2*fs/440)+k);
        inst = inst(1:int32(2*fs/440));
        B = [B, inst];
        profile = tambre(inst);
        [row,col,v] = find(profile);
        %B = [row v];
        %B = sortrows(B,2);
        %D = [D, B(end:-1:(end-n-1),1)];
        D = [D, profile];
    end
    % run PCA for each instrument
end

%{
mu = mean(D);
for k=1:size(D,1)
    D(k,:)=D(k,:)-mu;
end
%}

%plot(D(:,1));


% plot(D);
plot(D(:,1:numfiles(1)), '-r');
xlabel('frequency');
ylabel('amplitude');
hold on;
plot(D(:,(numfiles(1)+1):(numfiles(1)+numfiles(2))), '-b');
plot(D(:,(numfiles(1)+numfiles(2)+1):(numfiles(1)+numfiles(2)+numfiles(3))), '-k');
hold off;


D = D';
v = kmeans(D, 2);


%{
% Sigma value, pivotal to the clustering algorithm
sigma = 1;

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

for i = 1:(numCategories)
   Dnew(i, :) = (Vec(:, numSamples - i + 1))';
end

%% Plot the new data points
figure;
hold on;
for i = 1:numfiles(1)
   %plot(Dnew(2, i),Dnew(3, i),'o','MarkerSize',5);
    plot(Dnew(2, i),'o','MarkerSize',5);
end
 
for i = (numfiles(1)+1):(numfiles(1)+numfiles(2))
   %plot(Dnew(2, i),Dnew(3, i),'x','MarkerSize',5);
   plot(Dnew(2, i),'x','MarkerSize',5);
end

for i = (numfiles(1)+numfiles(2)+1):(numfiles(1)+numfiles(2)+numfiles(3))
    plot(Dnew(2, i),Dnew(3, i),'*','MarkerSize',5);
end

hold off;

v = kmeans(Dnew', 2);
%}
%% Accuracy
numCorrect = 0;
numFalse = 0;
for i = 1:numfiles(1)
   if v(i,:) == 1
       numCorrect = numCorrect + 1;
   else
       numFalse = numFalse + 1;
   end
end

for i = (numfiles(1)+1):(numfiles(1)+numfiles(2))
   if v(i,:) == 2
       numCorrect = numCorrect + 1;
   else
       numFalse = numFalse + 1;
   end
end

for i = (numfiles(1)+numfiles(2)+1):(numfiles(1)+numfiles(2)+numfiles(3))
   if v(i,:) == 3
       numCorrect = numCorrect + 1;
   else
       numFalse = numFalse + 1;
   end
end
% run PCA for everything
%[U,S,V] = svd(D);
%plot(S)


% clustering

%[row,col,v] = find(profile);

% Col 1 of B: freq
% Col 2 of B: amp

%{
B = [row v];
B = sort(B,2);
plot(B(:,1))
%}
%{
for i = 1:size(row,1)
    B(i,2) = profile(row(i));
end

% Sort by frequency
B = sort(B,2);

plot(B(:,2))
%}
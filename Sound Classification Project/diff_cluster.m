%% Clustering data using diffusion on weighted graph
function diff_cluster(D, numCategories, numpfiles, numsfiles, numvfiles)
% Sigma value, pivotal to the clustering algorithm
sigma = 30;

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

for i = 1:(numCategories + 2)
   Dnew(i, :) = (Vec(:, numSamples - i + 1))';
end

%% Plot the new data points
figure;
hold on;
for i = 1:numsfiles
   plot(Dnew(2, i),Dnew(3, i),'.','MarkerSize',5);
end

for i = (numsfiles + 1):(numsfiles+ numvfiles)
   plot(Dnew(2, i),Dnew(3, i),'x','MarkerSize',5);
end

for i = (numsfiles + numvfiles + 1):(numsfiles + numvfiles + numpfiles)
    plot(Dnew(2, i),Dnew(3, i),'*','MarkerSize',5);
end

hold off;
pause;

%% Cluster the new data points (indirectly cluster the original points)
clf;
Dnew = Dnew';
v = kmeans(Dnew,7); hold on;
plot(Dnew(v==1,2),Dnew(v==1,3),'.b','Markersize',10);
plot(Dnew(v==2,2),Dnew(v==2,3),'.g','Markersize',10);
plot(Dnew(v==3,2),Dnew(v==3,3),'.r','Markersize',10);
plot(Dnew(v==4,2),Dnew(v==4,3),'.m','Markersize',10);
plot(Dnew(v==5,2),Dnew(v==5,3),'.y','Markersize',10);
plot(Dnew(v==6,2),Dnew(v==6,3),'.k','Markersize',10);
plot(Dnew(v==7,2),Dnew(v==7,3),'.c','Markersize',10);
hold off;
end
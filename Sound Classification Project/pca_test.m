function Dpca = pca(D)
% This function performs principal component analysis on a data set
% and return the resulting data matrix
[row, col] = size(D);

L = zeros(row, row);

for i = 1:col
   L = L + (1/n)*(D(:,i)*D(:,i)'); 
end

[Vec, Val] = eig(L);

Val

numDim = input(prompt);

Dpca = L;
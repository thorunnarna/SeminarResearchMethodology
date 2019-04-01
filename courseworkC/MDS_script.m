%% Read data

D = csvread('MDSdata.csv');
D = 1-D;
for i = 1:n
   D(i,i) = 0;
end

%% Compute Gram matrix using double centering
% That means constructing G from D

n = length(D);

I = eye(n);
e = ones(n,n);

G = -0.5 * (I - (1/n)*e) * D * (I - (1/n)*e);

%% Compute eigenvalues and eigenvectors of G
% D*U = U*E

[U_unsorted,E_unsorted] = eig(G);
[U,E] = sortem(U_unsorted,E_unsorted);

%% Compute resulting points

d = 1;
X = zeros(d,n);

for i = 1:n
   for j = 1:d
      X(j,i) = sqrt(E(j,j))*U(i,j);
   end
end

Z = zeros(d,n);
for j = 1:d
   Z(j,:) = (sqrt(E(j,j))*U(:,j))';
end

%scatter(X(1,:),X(2,:));

%% Compute stress

S = zeros(n,1);
stressSum = 0;

% Compute Sum( (d_ij - x_ij)^2 )
for i = 1:n
    summation = 0;
    for j = 1:i
        summation = summation + (D(i,j)-norm(X(:,i)-X(:,j)))^2;
    end
    stressSum = stressSum + summation;
end

% Compute Sum( (d_ij)^2 )
total = 0;
for i = 1:n
    for j = 1:n
        total = total + (D(i,j))^2;
    end
end
total = total / 2;

% Compute sqrt of ratio
stress = sqrt(stressSum / total);


%%

[Y,k] = mdscale(D,1);
%scatter(Y(:,1),Y(:,2));

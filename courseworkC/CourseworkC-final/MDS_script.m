%% Classical Multidimensional Scaling

%% -- Read and prepare data -- %%

%% Color Wavelength data set
%{
similarities = csvread('MDSdata.csv');
D = 1-similarities;  % Input dissimilarity matrix
n = length(D);

% Make sure that the diagonals are still 0
for i = 1:n
   D(i,i) = 0;
end
%}

%% WoodyPlants data set
%{
woodyPlants = load('WoodyPlants50.mat');
D = woodyPlants.d.data;
n = length(D);
%}

%% DelftGestures data set

delftgestures = load('DelftGestures.mat');
D = delftgestures.d.data;
D = D(1:300,1:300);
n = length(D);


%% Flowers data set
% Contains some code copied from our file PCA_2, since we used the data set
% there as well.
%{
  maxImg = 500;
  initMatrix = [];
  imageDir = './FlowerSubset/';
  ImageDirJpg = imageDir+"*.jpg";
  imagefiles = dir(ImageDirJpg);      
  nfiles = length(imagefiles);    % Number of files found
  rows =[]
  columns = []
  %find the size of all images
  for i=1:maxImg
      currentfilename = imagefiles(i).name
      currentimage = imread(strcat(imageDir,currentfilename));
      rows = [rows size(currentimage,1)];
      columns = [columns size(currentimage,2)]  ;  
  end
  minRows = min(rows)
  minColumns = min(columns)
  %go though all images and trim them so they are all of the same size.
  for i=1:maxImg
        currentfilename = imagefiles(i).name
        currentimage = imread(strcat(imageDir,currentfilename));
        currentimage = rgb2gray(currentimage);
        %trim and resize to 150x150 pixles
        trimmedImg = trimImage(currentimage,minRows,minColumns);
        trimmedImg =imresize(trimmedImg, [150 150]);
        [h w d]=size(trimmedImg);
         %vectorize
        x = double(reshape(trimmedImg,w*h,d))/255;
        initMatrix = [initMatrix; x'];

  end
  initMatrix = initMatrix';
   
  n = maxImg;
  D = zeros(n,n);
  for i = 1:n
      for j = 1:n
         D(i,j) = norm(initMatrix(:,i)-initMatrix(:,j));
      end
  end
%}

%% Compute Gram matrix using double centering

I = eye(n);
e = ones(n,n);

G = -0.5 * (I - (1/n)*e) * (D .* D) * (I - (1/n)*e);

%% Compute eigenvalues and eigenvectors of G
% We use a function called sortem to ensure proper sorting of eigenvalues
% and eigenvectors

[U_unsorted,E_unsorted] = eig(G);
[U,E] = sortem(U_unsorted,E_unsorted);

%% Compute resulting points

d = 3;          % Desired dimension of the solution
X = zeros(d,n); % Matrix that will store the d-dimensional coordinates

% Use the eigenvalues and eigenvectors to find the coordinates
for i = 1:n
   for j = 1:d
      X(j,i) = sqrt(E(j,j))*U(i,j);
   end
end

%% Matlab function for comparison purposes
[Y,k] = cmdscale(D,d);
Y = Y';

%% Compute stress
stressSum = 0;

% Compute Sum( (d_ij - ||x_i-x_j||)^2 )
for i = 1:n
    for j = 1:i-1
        stressSum = stressSum + (D(i,j)-norm(X(:,i)-X(:,j)))^2;
    end
end

% Compute Sum( (d_ij)^2 )
total = 0;
for i = 1:n
    for j = 1:i-1
        total = total + (D(i,j))^2;
    end
end

% Compute sqrt of ratio
stress = sqrt(stressSum / total);

%% 
if (d==2)
    figure(1);
    scatter(X(1,:),X(2,:),'k','linewidth',1);
    figure(2);
    scatter(Y(1,:),Y(2,:),'k','linewidth',1);
end
if (d==3)
    figure(1);
    scatter3(X(1,:),X(2,:),X(3,:),'k');
    figure(2);
    scatter3(Y(1,:),Y(2,:),Y(3,:));
end

%%

function trimmedImg = trimImage(img,rows,columns)
    CenterRow = size(img,1)/2;
    CenterColumn = round(size(img,2)/2);
   
    row1 = (CenterRow-rows/2)+1;
    row2 = CenterRow+rows/2;
    col1 = (CenterColumn-columns/2)+1;
    col2 = CenterColumn+columns/2;
    trimmedImg = img(row1:row2, col1:col2);
end

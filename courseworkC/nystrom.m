% This is the implementation of the nystrom method

% 1. Select pixels that will serve as landmarks
% 2. Compute the center of the points and center them
% 3. For all i, compute the columns of the covariance matrix CTilda
% 4. Compute eigen values and eigenvectors of A which is the top part of
% CTilda
% 5. Get the approximate PCA modes
% 6. Don't forget to repermutate the stuff

% For testing purposes
% 5. reconstruct the images by projecting on these new basis vectors.

% We get the matrix.
% -----
maxImg = 200;
initMatrix = [];
imagefiles = dir('img_align_celeba/*.jpg');      
nfiles = length(imagefiles);    % Number of files found
for ii=1:maxImg
    currentfilename = imagefiles(ii).name
    currentimage = imread(strcat('img_align_celeba/',currentfilename));
    currentimage = rgb2gray(currentimage);
    [h w d]=size(currentimage);
    x = double(reshape(currentimage,w*h,d))/255;
    initMatrix = [initMatrix; x'];
end
initMatrix = initMatrix';

%%

landToTest = [100 300 500 700 1000 1500 2000 3000 4000 5000];
distancesFromOriginalNystrom = [];
timeNystrom = [];

for ld = 1:size(landToTest,2)

    tic;

    % Select pixels that will serve as landmarks
    % (randomly for now)
    nbLandmark = landToTest(ld) 
    indicesLandmark = sort(randperm(size(initMatrix,1),nbLandmark));



    % Get the permutation matrix, it stores on the first column the row to
    % change and on the second column where it should go. Using an identity
    % matrix is not possible because it becomes too big
    permMat = zeros(nbLandmark,2);
    for i=1:nbLandmark
        permMat(i,:) = [indicesLandmark(1,i) i];
    end

    % Get the center of the points and center everything
    center = mean(initMatrix,2);
    centeredPoints = initMatrix - center;

    % We permutate our matrix such that the landmarks are the first l ones
    permutatedPoints = centeredPoints;
    for i=1:nbLandmark
    %     permutatedPoints([permMat(i,1) permMat(i,2)],:) = permutatedPoints([permMat(i,2) permMat(i,1)],:);
        temp = permutatedPoints(permMat(i,2),:);
        permutatedPoints(permMat(i,2),:) = permutatedPoints(permMat(i,1),:);
        permutatedPoints(permMat(i,1),:) = temp;
    end

    % indicesLandmark(1,1)
    % centeredPoints(indicesLandmark([1:20]),1)
    % permutatedPoints([1:20],1)

    % We get CTilda
    CTilda = permutatedPoints * permutatedPoints([1:nbLandmark],:)';
    A = CTilda([1:nbLandmark],:);
    size(A)
    B = CTilda([nbLandmark+1:end],:);
    size(B)

    % We calculate the eigenvectors and eigenvalues
    [V,D] = eig(A);
    % We change order the vectors in increasing order
    D = rot90(fliplr(D),-1);
    V = flip(V,2);

    % We remove the eigenvectors with really small eigenvalues in order for the
    % inverse to work properly
    limitSmall = 1;
    while (limitSmall <= size(D,1)) & (D(limitSmall, limitSmall) > 0.001);
       limitSmall = limitSmall + 1;
    end

    if limitSmall > 1
        limitSmall = limitSmall - 1;
    end

    D = D([1:limitSmall], [1:limitSmall]);
    V = V(:,[1:limitSmall]);


    % We get the PCA modes
    bottomU = B * V * inv(D);
    U = [V; bottomU];

    % We normalize the new U's
    for i = 1:size(U,2)
        U(:,i) = U(:,i) / norm(U(:,i));
    end
    norm(U(:,1))

    % We permutate back
    for i=1:nbLandmark
        %U([permMat(i,2) permMat(i,1)],:) = U([permMat(i,1) permMat(i,2)],:);
        temp = U(permMat(i,2),:);
        U(permMat(i,2),:) = U(permMat(i,1),:);
        U(permMat(i,1),:) = temp;
    end

    elapsed = toc;
    
    % We collect the data
    timeNystrom = [timeNystrom elapsed]
    
    % We get the mean distance from the original points
    % take the mean distance
    matrixCenter = zeros(size(initMatrix,1), size(initMatrix,2));
    for i = 1:size(initMatrix,2)
        matrixCenter(:,i) = center; 
    end
    
    reconstructedMatrix = (permutatedPoints' * U * U')' + matrixCenter;
    
    distVec = [];
    for i = 1:size(initMatrix,2)
       distVec = [distVec pdist([initMatrix(:,i)' ; reconstructedMatrix(:,i)'])];
    end
    
    distancesFromOriginalNystrom = [distancesFromOriginalNystrom mean(distVec)];

end

timeNystrom
distancesFromOriginalNystrom
%%
% Testing
% We project on the new space
matrixCenter = zeros(size(initMatrix,1), size(initMatrix,2));
for i = 1:size(initMatrix,2)
   matrixCenter(:,i) = center; 
end

%size(centeredPoints' * U * U')
reconstructedMatrix = (permutatedPoints' * U * U')' + matrixCenter;

% We show the mean image
image = uint8(reshape(reconstructedMatrix(:,100),h,w,d)*255);
figure, imshow(image)

%% plot
plot(landToTest,timeNystrom)
%title("effect of number of snapshots on the time")
xlabel("nb of landmarks")
ylabel("time in seconds")

figure, plot(landToTest,distancesFromOriginalNystrom)
xlabel("nb of landmarks")
ylabel("mean euclidian distance from the original point")

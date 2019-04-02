% This is the implementation of the snapshot method

% 1. Select datapoints that will serve as snapshots
% 2. Build the gram Matrix of these snapshots (using the centered points)
% 3. Get the eigenvalues and eigenvectors
% 4. Compute the basis vectors

% For testing purposes
% 5. reconstruct the images by projecting on these new basis vectors.

% We get the matrix.
% -----
maxImg = 2000
initMatrix = []
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
% -------
%%

snapToTest = [10 50 100 200 300 400 500 750 1000 1500];
distancesFromOriginal = [];
timeSnap = [];

for sn = 1:size(snapToTest,2)
    
    % start the time
    tic;
    
    % Get the snapshots
    % We select them randomly for now
    nbSnapshots = snapToTest(sn)
    indicesSnapshots = randperm(maxImg,nbSnapshots);
    snapshotMatrix = initMatrix(:,indicesSnapshots);

    %snapshotMatrix = zeros(size(initMatrix,1), nbSnapshots);


    % Get the center
    center = mean(initMatrix,2);
    centeredPoints = initMatrix - center;

    % Get the centerd points
    y = snapshotMatrix - center;

    % get the Gram Matrix
    gram = y' * y;

    % get the eigenvalues and eigenvectors
    [V,D] = eig(gram);
    % We change order the vectors in increasing order
    D = rot90(fliplr(D),-1);
    V = flip(V,2);

    % We get the basis vectors
    U = zeros(size(initMatrix,1), size(D,1));
    for i = 1:size(D,1)
       U(:,i) = (1/(sqrt(D(i,i)))) * (y * V(:,i));
    end

    elapsed = toc;
    timeSnap = [timeSnap elapsed];
    
    % take the mean distance
    matrixCenter = zeros(size(initMatrix,1), size(initMatrix,2));
    for i = 1:size(initMatrix,2)
        matrixCenter(:,i) = center; 
    end
    
    reconstructedMatrix = (centeredPoints' * U * U')' + matrixCenter;
    
    distVec = [];
    for i = 1:size(initMatrix,2)
       distVec = [distVec pdist([initMatrix(:,i)' ; reconstructedMatrix(:,i)'])];
    end
    
    distancesFromOriginal = [distancesFromOriginal mean(distVec)];
    
end
timeSnap
distancesFromOriginal

%%
% Testing
% We project on the new space
matrixCenter = zeros(size(initMatrix,1), size(initMatrix,2));
for i = 1:size(initMatrix,2)
   matrixCenter(:,i) = center; 
end

%size(centeredPoints' * U * U')
reconstructedMatrix = (centeredPoints' * U * U')' + matrixCenter;

% We show the mean image
image = uint8(reshape(reconstructedMatrix(:,100),h,w,d)*255);
figure, imshow(image)

%% plot
plot(snapToTest,timeSnap)
%title("effect of number of snapshots on the time")
xlabel("nb of snapshots")
ylabel("time in seconds")

figure, plot(snapToTest,distancesFromOriginal)
xlabel("nb of snapshots")
ylabel("mean euclidian distance from the original point")

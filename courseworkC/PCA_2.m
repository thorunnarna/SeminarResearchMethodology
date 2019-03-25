% We implement the PCA using the second algorithms

% 1. Get the center of the points
% 2. Compute the centered points
% 3. Compute the Gram Matrix
% 4. Compute eigenvalues and eigenvectors of the Gram Matrix
% 5. Compute the basis vector of the affine space

% For testing purposes
% 6. We reconstruct the original matrix by projecting on the new affine
% space.

% -----
maxImg = 1000
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
image =uint8(reshape(x + center,h,w,d)*255);
figure, imshow(image)

% -------
%%
% Get the center
center = mean(initMatrix,2);

% Get the centerd points
y = initMatrix - center;

% get the Gram Matrix
gram = y' * y;

% get the eigenvalues and eigenvectors
[V,D] = eig(gram);
% We change the order of the vectors
D = rot90(fliplr(D),-1);
V = flip(V,2);

% We get the basis vectors
U = zeros(size(y,1), size(D,1));
for i = 1:size(D,1)
   U(:,i) = (1/(sqrt(D(i,i)))) * (y * V(:,i));
end
U;

% Testing
% We project on the new space
matrixCenter = zeros(size(center,1), size(U,2));
for i = 1:size(U,2)
   matrixCenter(:,i) = center; 
end

reconstructedMatrix = (y' * U * U')' + matrixCenter;

% We show the mean image
image = uint8(reshape(reconstructedMatrix(:,5),h,w,d)*255);
figure, imshow(image)


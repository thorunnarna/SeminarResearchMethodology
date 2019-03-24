% We implement the PCA using the second algorithms

% 1. Get the center of the points
% 2. Compute the centered points
% 3. Compute the Gram Matrix
% 4. Compute eigenvalues and eigenvectors of the Gram Matrix
% 5. Compute the basis vector of the affine space

% get the matrix:
% image=imread('lena_gray.png');
% [h w d]=size(image);
% x = double(reshape(image,w*h,d))/255;
% initMatrix = x;


% ------
maxImg = 200
initMatrix = []
imagefiles = dir('img_align_celeba/*.jpg');      
nfiles = length(imagefiles);    % Number of files found
for ii=1:maxImg
    currentfilename = imagefiles(ii).name
    currentimage = imread(strcat('img_align_celeba/',currentfilename));
    currentimage = rgb2gray(currentimage);
    %imshow(currentimage)
    [h w d]=size(currentimage);
    x = double(reshape(currentimage,w*h,d))/255;
    initMatrix = [initMatrix; x'];
    %images{ii} = currentimage;
end
initMatrix = initMatrix';

% -------
%%
% Get the center
center = 1/size(initMatrix,2) * sum(initMatrix,2);

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
   U(:,i) = (y * V(:,i)) * (1/(sqrt(D(i,i))));
end
U;

% We project on the new space
% reconstructedMatrix = zeros(size(initMatrix))
% for i = 1:size(initMatrix,2)
%     result = reconstructedMatrix(:,i);
%     myX = initMatrix(:,i);
%     size(myX)
%     for j = 1:size(myX,1)
%         result = result + (myX(j) * U(j,:) + center);
%     end
%     reconstructedMatrix(:,i) = result;
% end
matrixCenter = zeros(size(center,1), size(U,2));
for i = 1:size(U,2)
   matrixCenter(:,i) = center; 
end

reconstructedMatrix = (initMatrix' * U * U')' + matrixCenter;
reconstructedMatrix;

image =uint8(reshape(mean(reconstructedMatrix,2),h,w,d)*255);
figure, imshow(image)
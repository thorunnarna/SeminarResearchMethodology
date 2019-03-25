
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
imagefiles = dir('C:/Users/thoru/Downloads/img_align_celeba/image_subset/*.jpg');      
nfiles = length(imagefiles);    % Number of files found
for i=1:maxImg
    currentfilename = imagefiles(i).name
    currentimage = imread(strcat('C:/Users/thoru/Downloads/img_align_celeba/image_subset/',currentfilename));
    currentimage = rgb2gray(currentimage);
    %imshow(currentimage)
    [h w d]=size(currentimage);
    x = double(reshape(currentimage,w*h,d))/255;
    initMatrix = [initMatrix; x'];

end
initMatrix = initMatrix';

% -------
%%
tic
% Get the center
center = 1/size(initMatrix,2) * sum(initMatrix,2);

% Get the centerd points
y = initMatrix - center;

% compute the Covarience matrix
covarience = y * y';

% get the eigenvalues and eigenvectors
[V,D] = eigs(covarience,1);

%find the biggest eigenvectos   
em1=V(:,1);

matrixCenter = zeros(size(center,1), size(V,2));
for i = 1:size(V,2)
   matrixCenter(:,i) = center; 
end

reconstructedMatrix = (y' * em1 * em1')' + matrixCenter;
reconstructedMatrix;
timeCov = toc
image =uint8(reshape(mean(reconstructedMatrix,2),h,w,d)*255);
figure, imshow(image)

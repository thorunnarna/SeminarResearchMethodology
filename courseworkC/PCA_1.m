
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

maxImg = 1000
initMatrix = []

Celeb=1
Flower = 0
if Celeb==1
    imageDir =  './CelebritySubset/'
    ImageDirJpg = imageDir+"*.jpg"
    imagefiles = dir(ImageDirJpg);      
    nfiles = length(imagefiles);    % Number of files found
    for i=1:maxImg
        currentfilename = imagefiles(i).name
        currentimage = imread(strcat(imageDir,currentfilename));
        currentimage = rgb2gray(currentimage);
        [h w d]=size(currentimage);
        x = double(reshape(currentimage,w*h,d))/255;
        initMatrix = [initMatrix; x'];

    end
    initMatrix = initMatrix';

end
if Flower==1
  imageDir = './FlowerSubset/'
  ImageDirJpg = imageDir+"*.jpg"
  imagefiles = dir(ImageDirJpg);      
  nfiles = length(imagefiles);    % Number of files found
  rows =[]
  columns = []
  %find the size of all images
  for i=1:maxImg
      currentfilename = imagefiles(i).name
      currentimage = imread(strcat(imageDir,currentfilename));
      rows = [rows size(currentimage,1)]
      columns = [columns size(currentimage,2)]    
  end
  minRows = min(rows)
  minColumns = min(columns)
  %go though all images and trim them so they are all of the same size.
  for i=1:maxImg
        currentfilename = imagefiles(i).name
        currentimage = imread(strcat(imageDir,currentfilename));
        currentimage = rgb2gray(currentimage);
        trimmedImg = trimImage(currentimage,minRows,minColumns);    
        %trim to resize to 150x150 pixles
        trimmedImg =imresize(trimmedImg, [150 150]) ;     
        [h w d]=size(trimmedImg);
        %vectorize
        x = double(reshape(trimmedImg,w*h,d))/255;
        initMatrix = [initMatrix; x'];

  end
  initMatrix = initMatrix';
end


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
[V,D] = eigs(covarience,100);

%find the biggest eigenvectos   
%em1=V(:,1);

matrixCenter = zeros(size(center,1), size(y,2));
for i = 1:size(y,2)
   matrixCenter(:,i) = center; 
end

reconstructedMatrix = (y' * V * V')' + matrixCenter;
reconstructedMatrix;
timeCov = toc
image =uint8(reshape(mean(reconstructedMatrix,2),h,w,d)*255);
figure, imshow(image)

memory

%calculate difference
DiffCov = initMatrix-reconstructedMatrix;
NormCov =norm(DiffCov)
function trimmedImg = trimImage(img,rows,columns)
    CenterRow = size(img,1)/2
    CenterColumn = round(size(img,2)/2)
   
    row1 = (CenterRow-rows/2)+1;
    row2 = CenterRow+rows/2;
    col1 = (CenterColumn-columns/2)+1;
    col2 = CenterColumn+columns/2;
    trimmedImg = img(row1:row2, col1:col2);
end

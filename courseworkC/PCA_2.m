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
maxImg= 1000
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
        %imshow(currentimage)
        [h w d]=size(currentimage);
        x = double(reshape(currentimage,w*h,d))/255;
        initMatrix = [initMatrix; x'];

    end
    initMatrix = initMatrix';

end
if Flower==1
  imageDir =  './FlowerSubset/'
  ImageDirJpg = imageDir+"*.jpg"
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
end

% -------
%%
tic
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
timeGram = toc
% We show the mean image
image = uint8(reshape(mean(reconstructedMatrix,2),h,w,d)*255);
figure, imshow(image)
memory

%calculate difference 
DiffCov = initMatrix-reconstructedMatrix;
NormGram =norm(DiffCov)
function trimmedImg = trimImage(img,rows,columns)
    CenterRow = size(img,1)/2;
    CenterColumn = round(size(img,2)/2);
   
    row1 = (CenterRow-rows/2)+1;
    row2 = CenterRow+rows/2;
    col1 = (CenterColumn-columns/2)+1;
    col2 = CenterColumn+columns/2;
    trimmedImg = img(row1:row2, col1:col2);
end


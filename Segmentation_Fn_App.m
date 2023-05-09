function [highlighted_img, alert, imgThr] = Segmentation_Fn_App(img2, img1, objThresh, min_objSize, max_objSize)
size_img1 = size(img1);
%% make them gray
img1gray = rgb2gray(img1);
img2gray = rgb2gray(img2);
figure
imshow(img1gray);
figure
imshow(img2gray);

%% reshape image if needed
img2gray_rs = imresize(img2gray, [size_img1(1),size_img1(2)]);

%% image substraction
imgDiff = abs(img1gray - img2gray_rs);
figure
imshow(imgDiff);

%% find Maximum
maxDiff = max(max(imgDiff));
[iRow, iCol] = find(imgDiff == maxDiff);
[m, n] = size(imgDiff);

imshow(imgDiff)
hold on
plot(iCol, iRow, 'r*')

%% Threshold
imgThr = imgDiff > objThresh;; % all those values with diference above the 50%, if the num is smaller, it allows more quantites
figure
imshow(imgThr);
hold on
plot(iCol, iRow, 'r*')

%% Fill in the gaps
imgFilled = bwareaopen(imgThr, 30); %elimina objetos en la imagen con menos de x (30) pixeles
figure
imshow(imgFilled);

%% Compare (Insert binary image in original)
size_img1 = size(img1);
img2_rs= imresize(img2, [size_img1(1),size_img1(2)]);
imgComp = imoverlay(img2_rs,imgFilled,[1 0 0]); % imoverlay(A, B, color) -> La imagen de entrada A (RGB o gray)
                                                % se 'graba' o 'rellena'
                                                % con una mascara binaria
                                                % que es B con un color.
                                                % Graba a imagen binaria
                                                % con el color indicado
% figure
highlighted_img = imgComp;

%% Only Care About Things Large Than objSize

imageStats = regionprops(imgFilled, 'MajorAxisLength');
imgLengths = [imageStats.MajorAxisLength];
idx = [];
for i = 1:length(imgLengths)
    if imgLengths(i) < max_objSize && imgLengths(i) > min_objSize
        idx = [idx i];
    end
end
%idx = imgLengths > min_objSize;
imageStatsFinal = imageStats(idx);
%disp(imageStatsFinal)

%% Determine if Change is Significant
if isempty(imageStatsFinal);
    %disp('Nothing Different Here')
    alert = false;
else
    disp('Something is Here!')
    alert = true;
end




function gammaLoop_tif(inputDir, outputDir, ENL)
files = dir(fullfile(inputDir, '*.tif'));
winSize = 5;  % Finestra 5x5

for k=1:length(files)
    k
    img_name = files(k).name;
    img_path = fullfile(inputDir,img_name);
    img = imread(img_path);   
    img = double(img);
    img = img.^2;
    imgD = Gamma_MAP(img, winSize, ENL);
    img_out_dir = fullfile(outputDir, img_name);
    imgD = sqrt(imgD);
    imgD = clip(imgD , 0 , 255);
    imgD = uint8(imgD);
    imwrite(imgD,img_out_dir);
end
end
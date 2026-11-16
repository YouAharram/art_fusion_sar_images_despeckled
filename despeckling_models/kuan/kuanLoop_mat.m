function kuanLoop_mat(inputDir, outputDir, ENL)
files = dir(fullfile(inputDir, '*.mat'));
winSize = 5;  % Finestra 5x5
for k=1:length(files)
    k
    img_name = files(k).name;
    img_path = fullfile(inputDir,img_name);
    imgS = load(img_path);
    imgS = imgS.imSpeckle;
    imgS = double(imgS);
    imgS = imgS.^2;
    imgD = kuanFilterSAR(imgS, winSize, ENL);
    img_out_dir = fullfile(outputDir, img_name);
    imgD = sqrt(imgD); %?
    save(img_out_dir,"imgD");
end
end
function gammaLoop_mat(inputDir, outputDir, ENL)
files = dir(fullfile(inputDir, '*.mat'));
winSize = 5;  % Finestra 5x5

for k=1:length(files)
    img_name = files(k).name;
    img_path = fullfile(inputDir,img_name);
    img = load(img_path);   
    img = img.imSpeckle;
    img = img.^2;
    imgD = Gamma_MAP(img, winSize, ENL);
    img_out_dir = fullfile(outputDir, img_name);
    imgD = sqrt(imgD);
	k    
    save(img_out_dir, "imgD");
end
end

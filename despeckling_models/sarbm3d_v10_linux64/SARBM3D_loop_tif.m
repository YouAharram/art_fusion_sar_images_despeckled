function SARBM3D_loop_tif(folderIN,folderOUT,L)

files = dir(fullfile(folderIN,'*.tif'));

for i = 1:length(files)
    if ~files(i).isdir
        fileName = files(i).name;
        fullPath = fullfile(folderIN,fileName);
        disp(fullPath);
        imgS = imread(fullPath);
        imgS = double(imgS);
        imgD = SARBM3D_v10(imgS,L);
        dirImgOut =  fullfile(folderOUT, fileName);
        imwrite(uint8(imgD),dirImgOut);
    end
end
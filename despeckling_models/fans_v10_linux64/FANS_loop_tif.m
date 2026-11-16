function FANS_loop_tif(folderIN, folderOUT, L)

files = dir(fullfile(folderIN,'*.tif'));

for i = 1:length(files)
    if ~files(i).isdir
        fileName = files(i).name;
        fullPath = fullfile(folderIN,fileName);
        disp(fullPath);
        imgS = imread(fullPath);
        imgS = double(imgS);
        imgD = FANS(imgS,L);
        imgOutDir = fullfile(folderOUT,fileName);
        imwrite(uint8(imgD), imgOutDir);
        i
    end
end

function SARBM3D_loop(folderIN,folderOUT,L)

files = dir(fullfile(folderIN,'*'));

for i = 1:length(files)
    if ~files(i).isdir
        fileName = files(i).name;
        fullPath = fullfile(folderIN,fileName);
        disp(fullPath);
        imgS = imread(fullPath);
        imgD = SARBM3D_v10(double(imgS),L);
        imwrite(uint8(imgD),[folderOUT fileName])
    end
end
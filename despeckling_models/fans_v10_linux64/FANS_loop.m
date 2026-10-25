function FANS_loop(folderIN, folderOUT, L)

files = dir(fullfile(folderIN,'*'));

for i = 1:length(files)
    if ~files(i).isdir
        fileName = files(i).name;
        fullPath = fullfile(folderIN,fileName);
        disp(fullPath);
        imgS = imread(fullPath);
        imgD = FANS(double(imgS),L);
        imwrite(uint8(imgD), fullfile(folderOUT, fileName));
    end
end

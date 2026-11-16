function FANS_loop_mat(folderIN, folderOUT, L)

files = dir(fullfile(folderIN,'*.mat'));

for i = 1:length(files)
    if ~files(i).isdir
        fileName = files(i).name;
        fullPath = fullfile(folderIN,fileName);
        disp(fullPath);
        imgS = load(fullPath);
        imgS = imgS.imSpeckle;

       
        imgD = FANS(imgS,L);
        imgOutDir = fullfile(folderOUT,fileName);
        save(imgOutDir, "imgD");
        i
    end
end

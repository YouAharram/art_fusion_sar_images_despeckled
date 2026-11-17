function SARBM3D_loop_mat(folderIN,folderOUT,L)

files = dir(fullfile(folderIN,'*.mat'));

for i = 1:length(files)
    if ~files(i).isdir
        fileName = files(i).name;
        fullPath = fullfile(folderIN,fileName);
        disp(fullPath);
        imgS = load(fullPath);
        imgS = imgS.imSpeckle;
        imgS = double(imgS);
        imgD = SARBM3D_v10(imgS,L);
        dirImgOut =  fullfile(folderOUT, fileName);
        save(dirImgOut,"imgD");
		i
     end
end

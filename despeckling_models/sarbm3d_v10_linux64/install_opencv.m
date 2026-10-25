%% script to copy the OpenCV shared libraries in external libraries forder of your MATLAB 
mfiledir = fileparts(which(mfilename()));
unix(['sudo cp ' fullfile(mfiledir,'lib_opencv210','glnxa64','libcxcore.so*'), ' ',fullfile(matlabroot(),'extern','lib','glnxa64')])
unix(['sudo chmod 755 ',fullfile(matlabroot,'extern','lib','glnxa64','libcxcore.so*')])
unix(['sudo cp ' fullfile(mfiledir,'lib_opencv210','glnxa64','libcv.so*'), ' ',fullfile(matlabroot(),'extern','lib','glnxa64')])
unix(['sudo chmod 755 ',fullfile(matlabroot,'extern','lib','glnxa64','libcv.so*')])


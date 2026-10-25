function mat_img = tif_to_mat(input_dir, output_dir)
	files = dir(input_dir)
	for k=1:lenght(files)
		img = files(k).name
	end
end


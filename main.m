# Load the images
for i=1:6
	file_name = sprintf('image%i.jpg', i);

	[I1,map] = imread(file_name);

	row_count = round(rows(I1)/3);

	B = I1(1 : row_count, :);
	G = I1((row_count + 1) : (row_count*2), :);
	R = I1((row_count * 2) + 1 : (row_count*3), :); 

	# Construct the blurred image
	bgr(:,:, 2) = G;
	bgr(:,:, 3) = B;
	bgr(:,:, 1) = R;

	# Save the blurred color image we created.
	color_file_name = sprintf('image%i-color.jpg', i);
	imwrite(bgr, color_file_name);

	# Clear all the user variables except the loop index
	clear -x i
end

clear all;

for i=1:6
	file_name = sprintf('image%i-color.jpg', i);
	[I1,map] = imread(file_name);
	r = I1(:,:,1);
	g = I1(:,:,2);
	b = I1(:,:,3);

	# Align each image using ssd, ncc & corner detection

	# SSD
	[bgr] = im_align1(b, g, r);

	aligned_file_name = sprintf('image%i-ssd.jpg', i);
	imwrite(bgr, aligned_file_name);
	clear aligned_file_name;

	# NCC
	[bgr] = im_align2(b, g, r);

	aligned_file_name = sprintf('image%i-ncc.jpg', i);
	imwrite(bgr, aligned_file_name);
	clear aligned_file_name;

	# Harris Corner Detector
	


	# Clear all the user variables except the loop index
	clear -x i
end

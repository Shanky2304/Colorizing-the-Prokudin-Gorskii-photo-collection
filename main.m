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
	[xb, yb, scores_b, xg, yg, scores_g, xr, yr, scores_r] = harris(b, g, r);

	# Sort rows in the descending order of cornerness scores
	[sorted_scores_b, indices_b] = sort(scores_b',  "descend");
	sort_xb = xb(indices_b);
	sort_yb = yb(indices_b);

	# Get top 200 corners 
	scores_b = sorted_scores_b(1:200);

	xb = sort_xb(1:200);

	yb = sort_yb(1:200);

	[sorted_scores_g, indices_g] = sort(scores_g',  "descend");
	sort_xg = xg(indices_g);
	sort_yg = yg(indices_g);


	scores_g = sorted_scores_g(1:200);

	xg = sort_xg(1:200);

	yg = sort_yg(1:200);


	[sorted_scores_r, indices_r] = sort(scores_r',  "descend");
	sort_xr = xr(indices_r);
	sort_yr = yr(indices_r);

	scores_r = sorted_scores_r(1:200);

	xr = sort_xr(1:200);

	yr = sort_yr(1:200);

	# Plot the detected corners over the image and save it.

	imshow(b);
	hold on
	plot(xb, yb, 'r+', 'MarkerSize', 3, 'LineWidth', 1)
	corner_file_name_b = sprintf('image%i-detected-corner-b.jpg', i);
	saveas(gcf, corner_file_name_b);
	hold off

    imshow(g);
	hold on
	plot(xg, yg, 'r+', 'MarkerSize', 3, 'LineWidth', 1)
	corner_file_name_g = sprintf('image%i-detected-corner-g.jpg', i);
	saveas(gcf, corner_file_name_g);
	hold off

	imshow(r);
	hold on
	plot(xr, yr, 'r+', 'MarkerSize', 3, 'LineWidth', 1)
	corner_file_name_r = sprintf('image%i-detected-corner-r.jpg', i);
	saveas(gcf, corner_file_name_r);
	hold off

	# Ransac
	[offset_x_bg, offset_y_bg] = im_align3(b, xb, yb, g, xg, yg);
	[offset_x_br, offset_y_br] = im_align3(b, xb, yb, r, xr, yr);

	# Shift by offset
	g1 = circshift(g,[offset_x_bg offset_y_bg]);
	r1 = circshift(r,[offset_x_br offset_y_br]);

	# Construct the aligned image
	bgr(:,:, 2) = g1;
	bgr(:,:, 3) = b;
	bgr(:,:, 1) = r1;

	aligned_file_name = sprintf('image%i-corner.jpg', i);
	imwrite(bgr, aligned_file_name);
	clear aligned_file_name;

	# Clear all the user variables except the loop index
	clear -x i
end

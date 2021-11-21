function [offset_x, offset_y] = im_align3(b, xb, yb, g, xg, yg)

max_inliers = -1;
offset_x = 0;
offset_y = 0;

for i = 1:500

	rand_idx_b = randi(size(xb,1),1);
	rand_idx_g = randi(size(xg,1),1);

	feature_b = [xb(rand_idx_b), yb(rand_idx_b)];
	feature_g = [xg(rand_idx_g), yg(rand_idx_g)];

	# Calculate the shift matrix to align feature_b & feature_g

	shift = feature_b - feature_g;

	xg_shifted = xg + shift(1);
	yg_shifted = yg + shift(2);

	# Check for inliers after shift
	inlier_count = 0;
	for j = 1:size(xb, 1)
		if (j == rand_idx_b || j == rand_idx_g)
			continue;
		endif

		for k = 1:size(xg_shifted, 1)
			# We check for an exact point but a window might be better
			if (xg_shifted(k) == xb(j) && yg_shifted(k) == yb(j))
				inlier_count = inlier_count + 1;
			endif
		end
	end
	if (inlier_count > max_inliers)
		max_inliers = inlier_count;
		offset_x = shift(1);
		offset_y = shift(2);
	endif
end
disp("Max inlier count is : "), disp(max_inliers);
disp("X offset is : "), disp(offset_x);
disp("Y offset is : "), disp(offset_y);

end
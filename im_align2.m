function [bgr] = im_align2(b, g, r)
	max_score_bg = -1;
	max_score_br = -1;
	min_offset_bg = 0;
	min_offset_br = 0;
	for v = -15:1:15
		g1 = circshift(g,[v 0]);
	    r1 = circshift(r,[v 0]);

	    mean_b = sum(sum(b)) / (rows(b) * columns(b));
	    mean_r = sum(sum(r1)) / (rows(r1) * columns(r1));
	    mean_g = sum(sum(g1)) / (rows(g1) * columns(g1));

	    b1 = b - mean_b;
	    r2 = r1 - mean_r;
	    g2 = g1 - mean_g;
		
	    ncc_num_bg = sum(sum(b1 .* g2));
	    ncc_num_br = sum(sum(b1 .* r2));

	    b1_sq = b1.^2;
	    g2_sq = g2.^2;
	    r2_sq = r2.^2;

	    ncc_dem_bg = sqrt(sum(sum(b1_sq)) * sum(sum(g2_sq)));
	    ncc_dem_br = sqrt(sum(sum(b1_sq)) * sum(sum(r2_sq)));

	    score_bg = ncc_num_bg / ncc_dem_bg;
	    score_br = ncc_num_br / ncc_dem_br;

	    if (score_bg > max_score_bg)
	    	max_score_bg = score_bg;
	    	min_offset_bg = v;
		endif
		if (score_br > max_score_br)
	    	max_score_br = score_br;
	    	min_offset_br = v;
		endif
	end

	disp("Shift offset for blue - green with NCC = "), disp(min_offset_bg);
	disp("Shift offset for blue - red with NCC = "), disp(min_offset_br);

	r = circshift(r,[min_offset_br 0]);
	g = circshift(g,[min_offset_bg 0]);

	# Construct the aligned image
	bgr(:,:, 2) = g;
	bgr(:,:, 3) = b;
	bgr(:,:, 1) = r;

end
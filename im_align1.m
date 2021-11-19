function [min_offset_bg, min_offset_br] = im_align1(b, g, r)
	min_score_bg = intmax('uint64');
	min_score_br = intmax('uint64');
	min_offset_bg = 0;
	min_offset_br = 0;
	for v = -15:1:15
		g1 = circshift(g,[v 0]);
	    r1 = circshift(r,[v 0]);
		b1 = b - g1;
	    b2 = b - r1;
	    b1 = b1.^2;
	    b2 = b2.^2;
	    score_bg = sum(sum(b1));
	    score_br = sum(sum(b2));
	    if (score_bg < min_score_bg)
	    	min_score_bg = score_bg;
	    	min_offset_bg = v;
		endif
		if (score_br < min_score_br)
	    	min_score_br = score_br;
	    	min_offset_br = v;
		endif
	end	
	disp(min_score_bg);
	disp(min_offset_bg);
	disp(min_score_br);
	disp(min_offset_br);
end
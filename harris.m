function [xb, yb, scores_b, xg, yg, scores_g, xr, yr, scores_r] = harris(b, g, r)
	
    k = 0.04;

	# Get x & y gradient using sobel approximation
	[Ixb, Iyb] = imgradientxy(b);
	[Ixg, Iyg] = imgradientxy(g);
	[Ixr, Iyr] = imgradientxy(r);

    g = fspecial('gaussian');

    Ixb2 = imfilter(Ixb .^2, g);
    Iyb2 = imfilter(Iyb .^2, g);
    Ixyb = imfilter(Ixb .* Iyb, g);

    Ixg2 = imfilter(Ixg .^2, g);
    Iyg2 = imfilter(Iyg .^2, g);
    Ixyg = imfilter(Ixg .* Iyg, g);

    Ixr2 = imfilter(Ixr .^2, g);
    Iyr2 = imfilter(Iyr .^2, g);
    Ixyr = imfilter(Ixr .* Iyr, g);

    H_b = zeros(rows(b), col(b));
    H_g = zeros(rows(b), col(b));
    H_r = zeros(rows(b), col(b));

    for y = 6:rows(b)-6     
        for x = 6:cols(b)-6  
            
            Ixb2_matrix = Ixb2(y-2:y+2,x-2:x+2);
            Ixg2_matrix = Ixg2(y-2:y+2,x-2:x+2);
            Ixr2_matrix = Ixr2(y-2:y+2,x-2:x+2);
            Sxb2 = sum(Ixb2_matrix(:));
            Sxg2 = sum(Ixg2_matrix(:));
            Sxr2 = sum(Ixr2_matrix(:));
            
            
            Iyb2_matrix = Iyb2(y-2:y+2,x-2:x+2);
            Iyg2_matrix = Iyg2(y-2:y+2,x-2:x+2);
            Iyr2_matrix = Iyr2(y-2:y+2,x-2:x+2);
            Syb2 = sum(Iyb2_matrix(:));
            Syg2 = sum(Iyg2_matrix(:));
            Syr2 = sum(Iyr2_matrix(:));
            
            
            Ixyb_matrix = Ixyb(y-2:y+2,x-2:x+2);
            Ixyg_matrix = Ixyg(y-2:y+2,x-2:x+2);
            Ixyr_matrix = Ixyr(y-2:y+2,x-2:x+2);
            Sxyb = sum(Ixyb_matrix(:));
            Sxyg = sum(Ixyg_matrix(:));
            Sxyr = sum(Ixyr_matrix(:));
            
            matrix_b = [Sxb2, Sxyb; 
                      Sxyb, Syb2];

            matrix_g = [Sxg2, Sxyg; 
                      Sxyg, Syg2];

            matrix_r = [Sxr2, Sxyr; 
                      Sxyr, Syr2];

            R_b = det(matrix_b) - (k * trace(matrix_b)^2);

            R_b = det(matrix_g) - (k * trace(matrix_g)^2);

            R_r = det(matrix_r) - (k * trace(matrix_r)^2);
            
            H_b(y,x) = R_b;
            H_g(y,x) = R_g;
            H_r(y,x) = R_r;
           
        end
    end

    R_mean_b = mean(mean(H_b));
    R_mean_g = mean(mean(H_g));
    R_mean_r = mean(mean(H_r));

    threshold_b = abs(5 * R_mean_b);
    threshold_g = abs(5 * R_mean_g);
    threshold_r = abs(5 * R_mean_r);

    [row_b, col_b] = find(H_b > threshold_b);
    [row_g, col_g] = find(H_g > threshold_g);
    [row_r, col_r] = find(H_r > threshold_r);

    scores_b = [];
    scores_g = [];
    scores_r = [];

    for idxb = 1:size(row_b,1)
    
        rb = row(idxb);
        cb = col(idxb);
        scores_b = cat(2, scores_b, H_b(rb,cb));
    end

    for idxg = 1:size(row_g,1)
    
        rg = row(idxg);
        cg = col(idxg);
        scores_g = cat(2, scores_g, H_b(rg,cg));
    end

    for idxr = 1:size(row_r,1)
    
        rr = row(idxr);
        cr = col(idxr);
        scores_r = cat(2, scores_r, H_b(rr,cr));
    end

    xb = col_b;
    yb = row_b;
    xg = col_g;
    yg = row_g;
    xr = col_r;
    yr = row_r;

end
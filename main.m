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

color_file_name = sprintf('image%i-color.jpg', i);
imwrite(bgr, color_file_name);
clear -x i
end


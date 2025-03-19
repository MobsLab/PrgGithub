%% Correlation Test
image_file = 'Test3.bmp';
template_file = 'Test4.bmp';
image = (imread(image_file)); % set the image that is to be used
template = (imread(template_file)); % set the template that is to be used
%max_template = imrotate(template, -45, 'nearest', 'loose'); % find the maximum template size at 45 degrees
dim_image = [size(image, 1) size(image, 2)];  % store the dimensions of the image size
i = 1; % set i to 1
% find the maximum template size by cycling through each angle
for angle = 0:-20:-180,
    rotate_template = imrotate(template, angle, 'nearest', 'loose'); % rotate template around specified angle -- without cropping 
    dim_rot(:, :, i) = ([size(rotate_template, 1) size(rotate_template,2)]); % store the dimensions of each rotation in array 'dim_rot'
    i = i + 1;  % increment 'i' each loop   
end
dim_max = max(dim_rot,[],3); % find the values of the rotated template with maximum dimensions
correlation_matrix = zeros((dim_image(1) + dim_max(1) - 1), (dim_image(2) + dim_max(2) - 1), i-1); % set up the correlation matrix size (zeroed)
i = 1; % reset i to 1
for angle = 0:-20:-180,
    rotate_template = imrotate(template, angle, 'nearest', 'loose'); % rotate template around specified angle -- without cropping
      for k = 1:2,
          state = mod(size(rotate_template, k), 2);
          if state == 0,
              if k == 1,
                  rotate_template(size(rotate_template, k), :) = [];
              end
              if k == 2,
                  rotate_template(:, size(rotate_template, k)) = [];
              end
          end
      end
      dim_rot_new = [size(rotate_template, 1) size(rotate_template, 2)];
      rotate_template_new = padarray(rotate_template, [((dim_max(1) - dim_rot_new(:, 1))/2) ((dim_max(2) - dim_rot_new(:, 2))/2)], 0, 'both'); % pad 'rotate_template' array with zeros 
      correlation_matrix(:, :, i) = normxcorr2(rotate_template_new, image); % perform normalised cross colleration and store coefficient results in 'correlation_matrix'
      figure(i);
      subplot(1,2,1);
      imshow(rotate_template);
      title('Rotated Template');
      subplot(1,2,2);
      imshow(correlation_matrix(:,:,i));
      title('Correlated Matrix');
      i = i+1; % increment 'i' each loop 
end
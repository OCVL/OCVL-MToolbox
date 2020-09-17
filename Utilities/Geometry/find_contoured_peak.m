function [peak_location, peak_value] = find_contoured_peak(data_map)
% [peak_location, peak_value] = find_contoured_peak(data_map)
%
% This function takes in a data map of any type, smooths it, contours it,
% fits an ellipse, then finds its center. This is considered the "peak"
% location of the data map.
%
% It only finds *one* peak, so the expectation is that the data being fed
% in is unimodal...
%
% Created by Robert F Cooper, 2020/09/17
%


    data_map(isnan(data_map)) = 0;
    smoothed_data_map = imgaussfilt(data_map,8);

    smoothmaptheshold = quantile(smoothed_data_map(smoothed_data_map>0),.95);

    figure(10); clf; hold on;
    imagesc(smoothed_data_map); axis image;
    [clvls]=contour(smoothed_data_map, [smoothmaptheshold smoothmaptheshold]);

    [maxlvl]=max(clvls(1,:));

    bloblocs = find(clvls(1,:)==maxlvl); % Sometimes we have multiple contour pieces at the same lvl.

    upperclvl=[];
    for b=1:length(bloblocs)
        blobval = clvls(1 ,bloblocs(b));    
        upperclvl = [upperclvl; clvls(:,bloblocs(b)+1:bloblocs(b)+clvls(2,bloblocs(b)))'];
    end
    convpts = convhull(upperclvl(:,1), upperclvl(:,2));
    foveapts = upperclvl(convpts,:);
    plot(foveapts(:,1),foveapts(:,2),'.');

    ellipsefit = fit_ellipse(foveapts(:,1),foveapts(:,2));

    peak_location = [ellipsefit.X0_in ellipsefit.Y0_in];

    % rotation matrix to rotate the axes with respect to an angle phi
    cos_phi = cos( ellipsefit.phi );
    sin_phi = sin( ellipsefit.phi );
    R = [ cos_phi sin_phi; -sin_phi cos_phi ];

    % the ellipse
    theta_r         = linspace(0,2*pi);
    ellipse_x_r     = ellipsefit.X0 + ellipsefit.a*cos( theta_r );
    ellipse_y_r     = ellipsefit.Y0 + ellipsefit.b*sin( theta_r );
    rotated_ellipse = R * [ellipse_x_r;ellipse_y_r];

    plot( rotated_ellipse(1,:),rotated_ellipse(2,:),'r' );
    plot(peak_location(:,1), peak_location(:,2),'*');
    
    axis off;
        
    peak_value = data_map(round(peak_location(2)), round(peak_location(1)));
end


%%Counts number of centroids from a bw image

function Centroids = CountCentroids(x)

cc = bwconncomp(x);
    stats = regionprops(cc,'Area','Centroid','BoundingBox','Eccentricity','PixelIdxList');

    for i = 1:length(stats)
    Area(i) = stats(i).Area;
    end
clear i

stats(Area < 100) = []; %% Eliminates noise by removing any centroids with area < 100 pixels

Centroids = length(stats);
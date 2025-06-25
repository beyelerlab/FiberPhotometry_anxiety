function dist_vector = get_euclidean_distance(x_vector,y_vector)
    dx = diff(x_vector);
    dy=diff(y_vector);
    dist_vector = sqrt((dx.*dx)+(dy.*dy));
end


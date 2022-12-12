function [value_map]=brushfire(map)
    value_map = map;
    nghbrs = [-1 0; 0 1; 1 0; 0 -1];% Neighborhood directions. In this case is 8 neighbors

    [height, width] = size(value_map);
    cost = 0;
    while nnz(value_map) ~= height*width
        cost= cost+ 1;
        [nghbrs_row,nghbrs_col] = find(value_map == cost);% Get all the points of last labels and then start to grow
        nghbrs_idx= [nghbrs_row,nghbrs_col];
        for i = 1 : size(nghbrs_row,1)
            for k = 1 : 4
                Nxt_nghbrs= nghbrs_idx(i,:) +nghbrs(k,:);
                if Nxt_nghbrs(1)  < 1 ||  Nxt_nghbrs(1) > height ||  Nxt_nghbrs(2) < 1 || Nxt_nghbrs(2) > width  || value_map(Nxt_nghbrs(1),Nxt_nghbrs(2)) ~=0 
                    continue
                end
                value_map(Nxt_nghbrs(1),Nxt_nghbrs(2)) = cost + 1;
            end
        end
    end    
end
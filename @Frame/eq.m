function flag = eq(A, B)
% Check if two frames are equal in value
arguments (Input)
    A
    B
end
arguments (Output)
    flag logical
end

% If both are scalar, their properties must have the same handles
if isscalar(A) && isscalar(B)
    flag = (A.uID == B.uID) && ...
           all(A.locat == B.locat) && ...
           all(A.angles == B.angles) && ...
           (A.seqID == B.seqID) && ...
           (A.ref == B.ref);
	
% If both have the same size
elseif all(size(A) == size(B))
    % If both are empty, they are the same
    if isempty(A) && isempty(B)
        flag = true;
    % Otherwise, they are checked element-wise
    else
        flag = arrayfun(@(a, b) a == b, A, B);
    end

% If only one is scalar, it is compared to all the elements of the other array
else
    if isempty(A) || isempty(B)
        flag = false(size(A));
    elseif isscalar(A)
        flag = arrayfun(@(b) A == b, B);
    elseif isscalar(B)
        flag = arrayfun(@(a) a == B, A);
    end
end
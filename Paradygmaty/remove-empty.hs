{--
Define a recursive function which removes empty sub-lists from the list of lists.

Example: for the list  [[2,9],[],[5,6,7],[],[0]] we obtain [[2,9],[5,6,7],[0]].

NOTE - elements of sub-lists do not have to be numbers.

--}

removempty :: [[a]] -> [[a]]
removempty [] = []
removempty (x:xs) = (if(length x==0) then [] else [x]) ++ removempty xs  
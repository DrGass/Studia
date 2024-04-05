{--
Define a recursive function which removes one-element sub-lists from the list of lists.

Example: for the list [[], [3], [4,5], [9], [3,2,1]] we obtain [[], [4,5], [3,2,1] ].

NOTE - elements of sub-lists do not have to be numbers.

--}

removing :: [[a]] -> [[a]]
removing [] = []
removing (x:xs) = (if (length x == 1) then [] else [x]) ++ removing xs 
{--
Define a recursive function that creates a list of the last elements of the sub-lists for the list of lists given as an argument. Take into account the case when a sub-list is empty.

For example, for [[7, 3, 4], [], [3, 4, 0, 5], [2]] we get  [4, 5, 2].

NOTE - elements of sub-lists do not have to be numbers.

--}

lastelement :: [[a]] -> [a]
lastelement [] = []
lastelement (x:xs)
    | length x>0 = (last x):(lastelement xs)
    | otherwise = lastelement xs 
{--
--Define a recursive function that creates a list of the first elements of the sub-lists
--for the list of lists given as an argument. Take into account the case when a sub-list is empty.
--For example, for [[7, 3, 4], [], [3, 4, 0, 5], [2]] we get [7, 3, 2].

--}

first :: [[a]] -> [a]
first [] = []
first (x:xs)
    | length x>0 = (head x) : (first xs)
    | otherwise = first xs 
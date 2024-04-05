multiplyListBy5 :: [Double] -> [Double]
multiplyListBy5 = map (* 5)

multiplyListBy5Rec :: [Double] -> [Double]
multiplyListBy5Rec [] = [] -- gdy lista jest pusta, zwróć pustą listę
multiplyListBy5Rec (x:xs) = x*5 : multiplyListBy5Rec xs -- mnożenie pierwszego elementu przez 5 i rekurencyjne wywołanie dla reszty listy

removeSingletonLists :: [[a]] -> [[a]]
removeSingletonLists [] = [] -- gdy lista jest pusta, zwróć pustą listę
removeSingletonLists (x:xs)
  | length x == 1 = removeSingletonLists xs -- jeśli pierwsza podlista ma tylko jeden element, usuń ją i rekurencyjnie wywołaj dla reszty listy
  | otherwise = x : removeSingletonLists xs -- jeśli pierwsza podlista ma więcej niż jeden element, dodaj ją do wynikowej listy i rekurencyjnie wywołaj dla reszty listy


removeEmptyLists :: [[a]] -> [[a]]
removeEmptyLists [] = [] -- gdy lista jest pusta, zwróć pustą listę
removeEmptyLists (x:xs)
  | null x = removeEmptyLists xs -- jeśli pierwsza podlista jest pusta, usuń ją i rekurencyjnie wywołaj dla reszty listy
  | otherwise = x : removeEmptyLists xs -- jeśli pierwsza podlista nie jest pusta, dodaj ją do wynikowej listy i rekurencyjnie wywołaj dla reszty listy

removeEmptyLists' :: [[a]] -> [[a]]
removeEmptyLists' [] = [] -- gdy lista jest pusta, zwróć pustą listę
removeEmptyLists' (x:xs)
  | null x = removeEmptyLists xs -- jeśli pierwsza podlista jest pusta, usuń ją i rekurencyjnie wywołaj dla reszty listy
  | otherwise = x : removeEmptyLists xs -- jeśli pierwsza podlista nie jest pusta, dodaj ją do wynikowej listy i rekurencyjnie wywołaj dla reszty listy

divideListBy4 :: [Double] -> [Double]
divideListBy4 = map (/ 4)

divideListBy4Rec :: [Double] -> [Double]
divideListBy4Rec [] = [] -- gdy lista jest pusta, zwróć pustą listę
divideListBy4Rec (x:xs) = x/4 : divideListBy4Rec xs -- mnożenie pierwszego elementu przez 5 i rekurencyjne wywołanie dla reszty listy


add5 :: [Double] -> [Double]
add5 = map (+5)

add5Rec :: [Double] -> [Double]
add5Rec = map (+ 5)

negSublists :: [[Double]] -> [[Double]]
negSublists [] = []
negSublists (xs:xss) = negSublist xs : negSublists xss
  where negSublist [] = []
        negSublist (y:ys) = (-y) : negSublist ys

getFirsts' :: [(a,b)] -> [a]
getFirsts' pairs = [fst p | p <- pairs]

getFirstsRec :: [(a,b)] -> [a]
getFirstsRec = map fst

sequence' :: Int -> Int
sequence' 1 = 1
sequence' 2 = 3
sequence' n = 2 * sequence' (n - 1) + sequence' (n - 2)

seqList n = take (n+2) [sequence' i | i <-[1..]]

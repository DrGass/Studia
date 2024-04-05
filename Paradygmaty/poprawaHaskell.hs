-- Zadanie 1
-- a)
firsts' = map fst 
--b)
firsts :: [(a,b)] -> [a]
firsts xs = [x | (x,_) <- xs]

first[]=[]
first ((x,y):xs) = y:first xs

-- Zadanie 2
b n
  | n < 1 = error "Bledny argument"
  | n == 1 = 1
  | n == 2 = 3
  | otherwise = 2* b (n-1)+ b(n-2)

blist n = take (n+2) [b i | i <-[1..]]


-- Zadanie 4

count:: [[a]] -> Int
count [] = 0
count (x:xs) = if length x == 1 then 1 + count xs else count xs


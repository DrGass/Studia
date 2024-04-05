{--
Define the sequence(andn)n = 1 , 2 , ...such that and n= 2 ( n - 1)2 when n is divisible by 3, and andn = 1 in other cases.

Define a function that for an argumentncreates the list of n initial numbers of the sequence(andn)n = 1 , 2 , ....
--}

seqAn n
    | (mod n 3) == 0 = 2*(n-1)*(n-1)
    | otherwise = 1

nseqAn n = take n ([seqAn x | x<-[1,2..]])

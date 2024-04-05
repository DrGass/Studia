{--
Define a recursive function that for a given list of lists of real numbers changes the sign of each element of the sub-lists.
Example:
for the list  [[2,3,4.7],[],[1,6.67,9,0]] we obtain   [[-2.0,-3.0,-4.7],[],[-1.0,-6.67,-9.0,-0.0]].

--}
 
oppositeSign [] = []
oppositeSign (x:xs)
    |length x > 0 = [a * (-1) | a <- x]:(oppositeSign xs)
    |otherwise = []:oppositeSign xs
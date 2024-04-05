from numpy import matrix
from math import inf
from copy import deepcopy

# Złożoność obliczeniowa O(n^3), ponieważ mamy 3 pętle w funkcji find_lowests_costs.
# Złożoność pamięciowa O(n^2), ponieważ mamy matrycę kwadratową.
# Złożonośc obliczeniowa show_path w najgorszym przypadku jest liniowa O(n), a w najlepszym O(1)
# Złożoność pamięciowa show_path O(n^2), ponieważ mamy matrycę kwadratową.
graph = [
    [0, inf, -2, inf],
    [4, 0, 3,    inf],
    [inf, inf, 0,  2],
    [inf, -1, inf, 0]
]


class FloydWarshall:
    def __init__(self, given_graph):
        self.lowests_costs = deepcopy(given_graph)
        self.next_node = deepcopy(given_graph)

        for i in range(len(self.next_node)):
            for j in range(len(self.next_node)):
                self.next_node[i][j] = j
        print(self.next_node)

    def __repr__(self):
        return_string = 'Lowests costs graph\n' + str(matrix(self.lowests_costs)) + '\n'
        return_string += '\nNext node graph\n' + str(matrix(self.next_node))
        return return_string

    def find_lowests_costs(self):
        n = len(self.lowests_costs)
        for k in range(n):
            for x in range(n):
                for y in range(n):
                    current_cost = self.lowests_costs[x][y]
                    new_cost = self.lowests_costs[x][k] + self.lowests_costs[k][y]
                    self.lowests_costs[x][y] = min(current_cost, new_cost)

                    if new_cost < current_cost:
                        self.next_node[x][y] = self.next_node[x][k]

    def show_path(self, start_node, end_node):
        if start_node == end_node:
            return []
        if self.lowests_costs[start_node][end_node] == inf:
            return []
        return_path = [start_node]
        while start_node != end_node:
            start_node = self.next_node[start_node][end_node]
            return_path.append(start_node)
        return return_path


floyd_warshall = FloydWarshall(graph)
floyd_warshall.find_lowests_costs()
print(f'\n{floyd_warshall}')
print(f'\nPath from 0 to 1\n{floyd_warshall.show_path(0, 1)}')


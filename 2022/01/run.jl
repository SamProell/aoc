##
using Revise
import Elves

elves = Elves.read_elves_calories("2022/data/01.txt")
##
Elves.most_calories_carried(elves)
##
Elves.sum_top_n_elves(elves, n=3)
##

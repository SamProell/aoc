##
using Revise
using Elves
##
data = readlines("2023/data/01.txt")
##
# Part 1
sum(map(Elves.extract_number, data))
##
# Part 2
sum(map(Elves.extract_written_number, data))

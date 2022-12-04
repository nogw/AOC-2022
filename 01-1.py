def readInput(filename: str) -> str:
  f = open(filename, "r")
  data = f.read()
  f.close()
  return data

if __name__ == "__main__":
  content = readInput("./input.txt").split("\n\n")
  content = list(map(lambda e : e.split("\n"), content))
  content = list(map(lambda e : list(map(int,e)) , content))
  content = list(map(sum, content))
  print(max(content))

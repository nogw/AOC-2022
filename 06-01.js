import fs from "fs"

const iread = (filename) => {
  const data = fs.readFileSync(filename, "utf-8")
  return data
}

const check = (sequence, size) => {
  const filtered = sequence.filter((char, index) => sequence.indexOf(char) != index)
  return sequence.length === size && filtered.length === 0
}

const first = (input) => {
  const data = input.split("")
  
  for (let el in data) {
    const size = 4
    const index = parseInt(el) + size
    const tmp = data
    const group = tmp.slice(index - size, index)
    
    // console.log(group)

    if (check(group, size)) {
      return index
    }
  }
}

console.log(first(iread("input.txt")))
// intentionally ugly

import fs from "fs";
import path from "path";

const readInput = (filename: string): string => {
  const filepath = path.resolve(filename);
  const filedata = fs.readFileSync(filepath, "utf-8");

  return filedata;
};

const refineInput = (content: string): string[][] => {
  const lines = content.split("\n");
  const plays = lines.map((line) => line.split(" "));
  return plays;
};

const info = (play: string) => ({
  A: { counter: "Y", equal: "X" },
  B: { counter: "Z", equal: "Y" },
  C: { counter: "X", equal: "Z" }
}[play]!!);

const win = (play: string) => ({ 
  A: "Z", B: "X", C: "Y" 
}[play]!!);

const points = (play: string) => ({ 
  X: 1, Y: 2, Z: 3 
}[play]!!);

const get_play = (play: string, pl: string) => ({
  X: win(pl),
  Y: info(pl).equal, 
  Z: info(pl).counter 
}[play]!!);

const winner = (plays: string[]): number => {
  const [play0, mode] = plays;
  const play1 = get_play(mode, play0)!!;

  const { counter, equal } = info(play0)!!;
  const p = points(play1)!!;
  const e = equal === play1
  const w = counter === play1;

  if (e) return p + 3;
  else if (w) return p + 6;
  else return p + 0;
};

console.log(
  refineInput(readInput("./input.txt"))
    .map((plays) => winner(plays))
    .reduce((acc, curr) => acc + curr, 0)
);

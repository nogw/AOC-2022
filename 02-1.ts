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

const info = (play: string) =>
  ({
    A: { counter: "Y", equal: "X" },
    B: { counter: "Z", equal: "Y" },
    C: { counter: "X", equal: "Z" }
  }[play]);

const points = (play: string) => ({ X: 1, Y: 2, Z: 3 }[play]);

const winner = (plays: string[]): number => {
  const [play1, play2] = plays;

  const { counter, equal } = info(play1)!!;
  const p = points(play2)!!;
  const w = counter === play2;
  const e = equal === play2;

  if (e) return p + 3;
  else if (w) return p + 6;
  else return p + 0;
};

console.log(
  refineInput(readInput("./input.txt"))
    .map((plays) => winner(plays))
    .reduce((acc, curr) => acc + curr, 0)
);

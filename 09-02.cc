using namespace std;

#include <iostream>
#include <cassert>
#include <vector>
#include <set>

struct pos: pair<int, int> 
{
  pos(int x = 0, int y = 0): pair<int, int>(x, y) {}

  void step(char directory);

  void follow(pos const &p);
};

void pos::step(char directory) 
{
  switch (directory)
  {
    case 'L': --first; break;
    case 'R': ++first; break;
    case 'D': --second; break;
    case 'U': ++second; break;
    default: assert(
      directory == 'L' || 
      directory == 'R' || 
      directory == 'U' || 
      directory == 'D'
    );
  }
}

void pos::follow(pos const &p) 
{
  int dirx = p.first - first;
  int diry = p.second - second;

  if (abs(dirx) <= 1 && abs(diry) <= 1) return;

  auto org = [](int d) { 
    return d == 0 ? 0 : (d > 0 ? +1 : -1); 
  };

  first += org(dirx);
  second += org(diry);

  assert(
    abs(p.first - first) <= 1 && 
    abs(p.second - second) <= 1
  );
}

void rope_bridge(int knots) 
{
  assert(knots >= 2);

  vector<pos> rope(knots);

  pos &head = rope.front();
  pos &tail = rope.back();

  set<pos> tail_positions;
  tail_positions.emplace(tail);

  char dir;
  int steps;

  while (cin >> dir >> steps) 
  {
    for (int _ = 0; _ < steps; ++_)
    {
      head.step(dir);

      for (size_t i = 1; i < rope.size(); ++i)
        rope[i].follow(rope[i - 1]);

      tail_positions.emplace(tail);
    }
  }

  cout << tail_positions.size() << '\n';
}

// g++ 09-02.cc -o main
// usage: ./main <ENTER> <paste input> <CTRL+D>

int main(int argc, char **argv) {
  rope_bridge(10);

  return 0;
}
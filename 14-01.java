// https://stackoverflow.com/questions/4716503/reading-a-plain-text-file-in-java
// hmm, complex to implement (its friday and im dying of laziness)
// so, to use just run javac 14-02.java && java Main, paste input and CTRL+ENTER

import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashSet;
import java.util.List;
import java.util.Scanner;
import java.util.Set;

class Main {
  public static void main(String[] args) {
    List<List<int[]>> paths = read_input();
    
    Set<List<Integer>> cave = new HashSet<>();

    int x_min = Integer.MAX_VALUE, x_max = Integer.MIN_VALUE, y_max = Integer.MIN_VALUE;

    for (List<int[]> path : paths) {
      for (int i = 1; i < path.size(); i++) {
        int[] p1 = path.get(i - 1);
        int[] p2 = path.get(i);
        add_line(cave, p1, p2);

        x_min = Math.min(x_min, Math.min(p1[0], p2[0]));
        x_max = Math.max(x_max, Math.max(p1[0], p2[0]));
        y_max = Math.max(y_max, Math.max(p1[1], p2[1]));
      }
    }

    int units = 0;

    while (true) {
      int[] sand = {500, 0};
      boolean has_rest = false;

      while (!has_rest && sand[0] >= x_min && sand[0] <= x_max && sand[1] <= y_max) {
          has_rest = move_sand(cave, sand);
      }

      if (has_rest) {
          units++;
      }

      if (sand[0] < x_min || sand[0] > x_max || sand[1] > y_max) {
          break;
      }
    }

    System.out.println(units);
  }

  private static boolean move_sand(Set<List<Integer>> cave, int[] sand) {
    boolean has_rest = false;

    if (!cave.contains(Arrays.asList(sand[0], sand[1] + 1))) {
      sand[1] += 1;
    } else if (!cave.contains(Arrays.asList(sand[0] - 1, sand[1] + 1))) {
      sand[0] -= 1;
      sand[1] += 1;
    } else if (!cave.contains(Arrays.asList(sand[0] + 1, sand[1] + 1))) {
      sand[0] += 1;
      sand[1] += 1;
    } else {
      cave.add(Arrays.asList(sand[0], sand[1]));
      has_rest = true;
    }

    return has_rest;
  }

  private static void add_line(Set<List<Integer>> cave, int[] p1, int[] p2) {
    if (p1[0] == p2[0]) {
      int x = p1[0];

      for (int y = Math.min(p1[1], p2[1]); y <= Math.max(p1[1], p2[1]); y++) {
          cave.add(Arrays.asList(x, y));
      }
    } else {
      int y = p1[1];

      for (int x = Math.min(p1[0], p2[0]); x <= Math.max(p1[0], p2[0]); x++) {
          cave.add(Arrays.asList(x, y));
      }
    }
  }

  private static List<List<int[]>> read_input() {
    Scanner sc = new Scanner(System.in);
    
    List<List<int[]>> paths = new ArrayList<>();

    String input = sc.nextLine();

    while (input.length() > 0) {
      List<int[]> path = new ArrayList<>();

      for (String point : input.split(" -> ")) {
          int x = Integer.parseInt(point.split(",")[0]);
          int y = Integer.parseInt(point.split(",")[1]);
          path.add(new int[]{x, y});
      }
      
      paths.add(path);
      
      input = sc.nextLine();
    }

    sc.close();

    return paths;
  }
}

use std::fs;

fn read_input(filename: &str) -> String {
    fs::read_to_string(filename).expect("i can't read the file")
}

fn main() {
    let contents = read_input("input.txt");

    let mut sum: i64 = 0;

    for line in contents.lines() {
        let elves: Vec<&str> = line.split(',').collect::<Vec<&str>>();
        let (a_min, a_max) = get_pair(elves[0]);
        let (b_min, b_max) = get_pair(elves[1]);

        if (a_min <= b_min && a_max >= b_max) || (b_min <= a_min && b_max >= a_max) {
            sum += 1;
        }
    }

    println!("{}", sum)
}

fn get_pair(input: &str) -> (i64, i64) {
    let i = input.split("-").collect::<Vec<_>>();

    let v = i.iter().map(|s| s.parse::<i64>().unwrap()).collect::<Vec<_>>();

    (v[0], v[1])
}

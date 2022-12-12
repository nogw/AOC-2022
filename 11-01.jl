module Day11Part1
  mutable struct Monkey
    number::Int64
    items::Vector{Int64}
    operation::Function
    div::Int64
    tru::Int64
    fal::Int64
    inspections::Int64
  end

  function parsemonkey(input)::Monkey
    pattern = r"Monkey (\d+):\s+Starting items: ((?:\d+, )*\d+)\s+Operation: new = old ([\*\+]) (old|\d+)\s+Test: divisible by (\d+)\s+If true: throw to monkey (\d+)\s+If false: throw to monkey (\d+)"
  
    matched = match(pattern, input)
  
    mon = parse(Int64, matched[1])
    items = map(i -> parse(Int64, i), split(matched[2], ", "))
    opr = matched[3] == "+" ? (+) : (*)
    opd = matched[4]
    div = parse(Int64, matched[5])
    tru = parse(Int64, matched[6])
    fal = parse(Int64, matched[7])
  
    if opd == "old"
      operation = old -> opr(old, old)
    else
      parse(Int64, opd) |> opd -> operation = old -> opr(old, opd)
    end
  
    return Monkey(mon, items, operation, div, tru, fal, 0)
  end
  
  function parsemonkeys(input)
    return map(m -> parsemonkey(m), filter(!isempty, split(input, "\n\n")))
  end
  
  function doround!(monkeys::Vector{Monkey}, reduceworrylevel::Function)
    for monkey in monkeys
      while !isempty(monkey.items)
        item = popfirst!(monkey.items)
  
        monkey.inspections += 1
  
        worrylevel = monkey.operation(item)
        worrylevel = reduceworrylevel(worrylevel)
  
        if worrylevel % monkey.div == 0
          target = monkey.tru
        else
          target = monkey.fal
        end
  
        push!(filter(m -> m.number == target, monkeys)[1].items, worrylevel)
      end
    end
  end
  
  function solve(monkeys::Vector{Monkey}, iterations::Int64, reduceworrylevel::Function)
    for _ = 1:iterations
      doround!(monkeys, reduceworrylevel)
    end
  
    return reduce(*, sort(map(m -> m.inspections, monkeys), rev=true)[1:2])
  end
  
  read("input.txt", String) |> parsemonkeys |> monkeys -> solve(monkeys, 20, worrylevel -> worrylevel ÷ 3) |> println
end
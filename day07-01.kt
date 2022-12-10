package day07

import java.io.File

abstract class Entry(
  val name: String, 
  val size: Int
) {
  abstract fun show(indent: Int = 0)
}

class Directory(
  name: String, 
  val contents: List<Entry>
): Entry(name, contents.map(Entry::size).sum()) {
  override fun show(indent: Int) {
    println("${"  ".repeat(indent)}- $name (dir, size=$size)")
    contents.forEach { it.show(indent + 1) }
  }
}

class File(
  name: String, 
  size: Int
): Entry(name, size) {
  override fun show(indent: Int) {
    println("${"  ".repeat(indent)} - $name (file, size=$size)")
  }
}

fun parseInput(data: String): Entry {
  val fst = Regex("""\p{Sc}\s*cd\s+([^.\s]+)\n\p{Sc}\s+ls""").replace(data, "CDLS $1")
  val snd = Regex("""\p{Sc}\s*cd\s+\.\.""").replace(fst, "BACK")

  val lines = snd.split('\n').filterNot { it.startsWith("dir") }

  @Suppress("NON_TAIL_RECURSIVE_CALL")
  tailrec fun aux(lines: List<String> = lines, entries: List<Entry> = emptyList()): Pair<List<String>, List<Entry>> = when {
    lines.isEmpty() && entries.size == 1 && entries.first().name == "/" -> Pair(lines, entries)
    lines.isEmpty() || lines.first() == "BACK" -> Pair(lines.drop(1), entries)

    lines.first().first().isDigit() -> {
      val (size, name) = lines.first().split(' ')
      aux(lines.drop(1), entries + File(name, size.toInt()))
    }

    lines.first().startsWith("CDLS") -> {
      val dirName = lines.first().split(' ')[1]
      val (remainingLines, dirContents) = aux(lines.drop(1))
      aux(remainingLines, entries + Directory(dirName, dirContents))
    }

    else -> throw IllegalArgumentException("Illegal termination")
  }

  return aux().second[0]
}

fun extractDirectories(entry: Entry): List<Entry> {
  tailrec fun aux(
    entries: List<Entry> = listOf(entry), 
    directories: List<Entry> = emptyList()
  ): List<Entry> = when {
    entries.isEmpty() -> directories
    
    entries.first() is Directory ->
      aux(entries.drop(1) + (entries.first() as Directory).contents,
      directories + entries.first())
      
    else -> aux(entries.drop(1), directories)
  }

  return aux()
}

fun main() {
  val data = parseInput(File("input.txt").readText())
  println(extractDirectories(data).filter { it.size < 100000 }.map(Entry::size).sum())
}
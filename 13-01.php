<?php

class Packet {
  private readonly array $value;

  public function __construct(string $input) {
    $this->value = json_decode($input, true);
  }

  private static function _compare(int|array $left, int|array $right): int {
    if (is_int($left) && is_int($right)) {
      // The <=> ("Spaceship") operator will offer combined comparison in that it will :
      // Return 0 if values on either side are equal
      // Return 1 if the value on the left is greater
      // Return -1 if the value on the right is greater
      return $left <=> $right;
    }

    $left = (array) $left;
    $right = (array) $right;

    $leftCount = count($left);
    $rightCount = count($right);
    $minCount = min($leftCount, $rightCount);
    
    for ($i = 0; $i < $minCount; ++$i) {
      if ($res = self::_compare($left[$i], $right[$i])) {
        return $res;
      }
    }

    return $leftCount <=> $rightCount;
  }

  public function compare(Packet $other): int {
    return self::_compare($this->value, $other->value);
  }
}

function reducePackets(array $packets): int {
  $result = 0;

  for ($i = 1; count($packets); ++$i) {
    if (-1 == array_shift($packets)->compare(array_shift($packets))) {
      $result += $i;
    }
  }

  return $result;
}

$input = explode(PHP_EOL, trim(file_get_contents('./input.txt')));
$packetsFiltered = array_filter($input, fn (string $s): bool => '' !== $s);
$packets = array_map(fn ($s) => new Packet($s), $packetsFiltered);

printf("%d", reducePackets($packets));
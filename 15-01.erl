-module(aoc).

-export([main/1]).

% how use it?
% access /setups/15_01_erl and run
% rebar3 escriptize && ./_build/default/bin/aoc ./input.txt 2000000

main(Args) ->
  % parse command line arguments
  [FileName, BeaconsRowYRaw] = Args,
  {BeaconsRowY, _} = string:to_integer(BeaconsRowYRaw),

  % parse it into a list of sensor/beacon pairs
  {ok, RawBinaryInput} = file:read_file(FileName),
  SensorsWithBeacons = parse_data(RawBinaryInput),

  % pos where beacons cannot be placed
  Positions = find_positions_where_beacon_cannot_be(SensorsWithBeacons, BeaconsRowY),

  % beacon pos from sensor/beacon pairs
  Beacons = lists:map(fun({_, Beacon}) -> Beacon end, SensorsWithBeacons),

  % compute answer and print
  Answer = compute_answer(Positions, Beacons),
  io:format("Answer: ~p~n", [Answer]),

  % exit the program
  erlang:halt(0).

compute_answer(Positions, Beacons) ->
  % compute the set of pos where beacons can be placed
  PossiblePositions =
    lists:uniq(
      lists:flatten(Positions)),

  % remove pos where there already is a beacon
  UniquePossiblePositions = PossiblePositions -- Beacons,

  % compute the number of unique possible positions
  length(UniquePossiblePositions).

find_positions_where_beacon_cannot_be(SensorsWithBeacons, BeaconsRowY) ->
  lists:map(fun({Sensor, Beacon}) -> find_positions_for_beacon(Sensor, Beacon, BeaconsRowY)
            end,
            SensorsWithBeacons).

find_positions_for_beacon({SensorX, SensorY}, Beacon, BeaconsRowY)
  when BeaconsRowY > SensorY ->
  SensorToBeaconDistance = manhattan_distance({SensorX, SensorY}, Beacon),
  VerticalDistance = BeaconsRowY - SensorY,
  HorizontalDistanceLeft = SensorToBeaconDistance - abs(VerticalDistance),
  case HorizontalDistanceLeft =< 0 of
    true ->
      [];
    false ->
      [{X, BeaconsRowY}
       || X <- lists:seq(SensorX - HorizontalDistanceLeft, SensorX + HorizontalDistanceLeft)]
  end;
find_positions_for_beacon({SensorX, SensorY}, Beacon, BeaconsRowY) ->
  SensorToBeaconDistance = manhattan_distance({SensorX, SensorY}, Beacon),
  VerticalDistance = SensorY - BeaconsRowY,
  HorizontalDistanceLeft = SensorToBeaconDistance - abs(VerticalDistance),
  case HorizontalDistanceLeft =< 0 of
    true ->
      [];
    false ->
      [{X, BeaconsRowY}
       || X <- lists:seq(SensorX - HorizontalDistanceLeft, SensorX + HorizontalDistanceLeft)]
  end.

manhattan_distance({X1, Y1}, {X2, Y2}) ->
  abs(X2 - X1) + abs(Y2 - Y1).

parse_data(RawBinaryInput) ->
  % convert binary input to list of strings
  RawLstInput = binary:bin_to_list(RawBinaryInput),
  % to list of sensor/beacon pairs
  RawSensorsList = string:split(RawLstInput, "\n", all),
  % parse sensor/beacon pair into a tuple of tuples
  ParsedSensorsList = lists:map(fun parse_sensor/1, RawSensorsList),
  % parsed sensor/beacon pairs
  ParsedSensorsList.

parse_sensor(RawSensorAndBeacon) ->
  % split the sensor/beacon pair into its individual parts
  [RawSensor, RawClosestBeacon] =
    string:split(RawSensorAndBeacon, ": closest beacon is at "),
  [RawSensorX, RawSensorY] = string:split(RawSensor, ", "),
  [_, SensorXStr] = string:split(RawSensorX, "="),
  [_, SensorYStr] = string:split(RawSensorY, "="),
  [RawClosestBeaconX, RawClosestBeaconY] = string:split(RawClosestBeacon, ", "),
  [_, ClosestBeaconXStr] = string:split(RawClosestBeaconX, "="),
  [_, ClosestBeaconYStr] = string:split(RawClosestBeaconY, "="),
  % convert the string values to integers
  SensorX = list_to_integer(SensorXStr),
  SensorY = list_to_integer(SensorYStr),
  ClosestBeaconX = list_to_integer(ClosestBeaconXStr),
  ClosestBeaconY = list_to_integer(ClosestBeaconYStr),
  % tuple of tuples == sensor and its closest beacon
  {{SensorX, SensorY}, {ClosestBeaconX, ClosestBeaconY}}.

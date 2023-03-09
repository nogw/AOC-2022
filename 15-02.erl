-module(aoc).

-export([main/1]).

% how use it?
% access /setups/15_02_erl and run
% rebar3 escriptize && ./_build/default/bin/aoc ./input.txt 2000000

main(Args) ->
    [FileName, RawBeaconsXandYMax] = Args,
    {ok, RawBinaryInput} = file:read_file(FileName),
    {BeaconsXandYMax, ""} = string:to_integer(RawBeaconsXandYMax),
    PotentialDistressBeaconRows =
        [{{0, Y}, {BeaconsXandYMax, Y}} || Y <- lists:seq(0, BeaconsXandYMax)],
    [{{X, Y}, {X, Y}}] =
        elim_positions(parse_data(RawBinaryInput), PotentialDistressBeaconRows),
    Answer = X * 4000000 + Y,
    io:format("~p~n", [Answer]),
    Answer.

%% eliminates impossible positions for the distress beacon based on sensor data.
elim_positions(SensorsWithBeacons, PotentialDistressBeaconRows) ->
    lists:foldl(fun(SensorWithBeacon, PotentialRows) ->
                   NewPotentialRows = cut_down_row(SensorWithBeacon, PotentialRows),
                   lists:flatten(NewPotentialRows)
                end,
                PotentialDistressBeaconRows,
                SensorsWithBeacons).

cut_down_row({Sensor = {SensorX, SensorY}, Beacon}, PotentialDistressBeaconRows) ->
    lists:map(fun(Row = {From = {FromX, FromY}, To = {ToX, ToY}}) ->
                 case {SensorX < FromX, SensorX > ToX} of
                     {true, _} ->
                         Shorten =
                             manhattan_distance(Sensor, Beacon) - manhattan_distance(Sensor, From),
                         case Shorten >= 0 of
                             true ->
                                 NewFromX = FromX + Shorten + 1,
                                 case NewFromX >= ToX of
                                     true -> [];
                                     false -> {{NewFromX, FromY}, {ToX, ToY}}
                                 end;
                             false -> Row
                         end;
                     {_, true} ->
                         Shorten =
                             manhattan_distance(Sensor, Beacon) - manhattan_distance(Sensor, To),
                         case Shorten >= 0 of
                             true ->
                                 NewToX = ToX - Shorten - 1,
                                 case NewToX =< FromX of
                                     true -> [];
                                     false -> {{FromX, FromY}, {NewToX, ToY}}
                                 end;
                             false -> Row
                         end;
                     _ ->
                         Shorten =
                             manhattan_distance(Sensor, Beacon)
                             - manhattan_distance({0, SensorY}, {0, FromY})
                             + 1,
                         case Shorten > 0 of
                             true ->
                                 [begin
                                      NewX1 = SensorX - Shorten,
                                      case FromX =< NewX1 of
                                          false -> [];
                                          true -> {{FromX, FromY}, {NewX1, ToY}}
                                      end
                                  end,
                                  begin
                                      NewX2 = SensorX + Shorten,
                                      case NewX2 =< ToX of
                                          false -> [];
                                          true -> {{NewX2, FromY}, {ToX, ToY}}
                                      end
                                  end];
                             false -> Row
                         end
                 end
              end,
              PotentialDistressBeaconRows).

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

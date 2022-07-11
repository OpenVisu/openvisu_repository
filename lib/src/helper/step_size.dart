// Copyright (C) 2022 Robin Jespersen
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU Affero General Public License as
// published by the Free Software Foundation, either version 3 of the
// License, or (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU Affero General Public License for more details.
//
// You should have received a copy of the GNU Affero General Public License
// along with this program.  If not, see <http://www.gnu.org/licenses/>.

class StepSize {
  final Duration delta;

  StepSize.fromStartStop(
    final DateTime start,
    final DateTime stop,
  ) : delta = _getTimeFrameResolution(stop.difference(start));

  StepSize.fromTimeFrame(
    final Duration timeFrame,
  ) : delta = _getTimeFrameResolution(timeFrame);

  const StepSize._fromDelta(this.delta);

  factory StepSize.fromDelta(final Duration d) {
    if (!StepSize._validResolutions.contains(StepSize._fromDelta(d))) {
      throw const FormatException('invalid stepSize');
    }
    return StepSize._fromDelta(d);
  }

  StepSize? zoomIn() {
    if (this == _validResolutions.first) {
      return null;
    }
    return _validResolutions.lastWhere((s) => s.delta < delta);
  }

  StepSize? zoomOut() {
    if (this == _validResolutions.last) {
      return null;
    }
    return _validResolutions.firstWhere((s) => s.delta > delta);
  }

  // must match backend/modules/dashboard/models/TimeSerial->getEveryInSeconds()
  static Duration _getTimeFrameResolution(
    final Duration timeframe,
  ) {
    if (timeframe <= const Duration(minutes: 1)) {
      return const Duration(seconds: 1);
    } else if (timeframe <= const Duration(minutes: 15)) {
      return const Duration(seconds: 10);
    } else if (timeframe <= const Duration(hours: 1)) {
      return const Duration(minutes: 1);
    } else if (timeframe <= const Duration(hours: 8)) {
      return const Duration(minutes: 10);
    } else if (timeframe <= const Duration(days: 3)) {
      return const Duration(hours: 1);
    } else if (timeframe <= const Duration(days: 7)) {
      return const Duration(hours: 2);
    } else if (timeframe <= const Duration(days: 90)) {
      return const Duration(days: 1);
    } else {
      return const Duration(days: 7);
    }
  }

  // list must be sorted
  static const List<StepSize> _validResolutions = [
    StepSize._fromDelta(Duration(seconds: 1)),
    StepSize._fromDelta(Duration(seconds: 10)),
    StepSize._fromDelta(Duration(minutes: 1)),
    StepSize._fromDelta(Duration(minutes: 10)),
    StepSize._fromDelta(Duration(hours: 1)),
    StepSize._fromDelta(Duration(hours: 2)),
    StepSize._fromDelta(Duration(days: 1)),
    StepSize._fromDelta(Duration(days: 7))
  ];

  /// Whether this [StepSize] is smaller than [other].
  bool operator <(StepSize other) => delta < other.delta;

  /// Whether this [StepSize] is bigger than [other].
  bool operator >(StepSize other) => delta > other.delta;

  /// Whether this [StepSize] is smaller than or equal to [other].
  bool operator <=(StepSize other) => delta <= other.delta;

  /// Whether this [Duration] is bigger than or equal to [other].
  bool operator >=(StepSize other) => delta >= other.delta;

  /// Whether this [StepSize] has the same size as [other].
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StepSize &&
          runtimeType == other.runtimeType &&
          delta == other.delta;

  @override
  int get hashCode => delta.hashCode;

  @override
  String toString() {
    return 'StepSize($delta)';
  }
}

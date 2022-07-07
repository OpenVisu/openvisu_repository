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

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class StepSize implements Equatable {
  @visibleForTesting
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
    if (!StepSize._validResolutions.contains(d)) {
      throw const FormatException('invalid stepSize');
    }
    return StepSize._fromDelta(d);
  }

  // must match backend/modules/dashboard/models/TimeSerial->getEveryInSeconds()
  static Duration _getTimeFrameResolution(
    final Duration timeframe,
  ) {
    if (timeframe < const Duration(minutes: 1)) {
      return const Duration(seconds: 1);
    } else if (timeframe < const Duration(minutes: 15)) {
      return const Duration(seconds: 10);
    } else if (timeframe < const Duration(hours: 1)) {
      return const Duration(minutes: 1);
    } else if (timeframe < const Duration(hours: 8)) {
      return const Duration(minutes: 10);
    } else if (timeframe < const Duration(days: 3)) {
      return const Duration(hours: 1);
    } else if (timeframe < const Duration(days: 7)) {
      return const Duration(hours: 2);
    } else if (timeframe < const Duration(days: 90)) {
      return const Duration(days: 1);
    } else {
      return const Duration(days: 7);
    }
  }

  static const List<Duration> _validResolutions = [
    Duration(seconds: 1),
    Duration(seconds: 10),
    Duration(minutes: 1),
    Duration(minutes: 10),
    Duration(hours: 1),
    Duration(hours: 2),
    Duration(days: 1),
    Duration(days: 7)
  ];

  @override
  List<Object?> get props => [delta];

  @override
  bool? get stringify => true;
}

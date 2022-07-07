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

import 'package:flutter_test/flutter_test.dart';
import 'package:openvisu_repository/src/helper/step_size.dart';

void main() {
  group('StepSize', () {
    late final DateTime now;
    late final DateTime before20minutes;

    setUpAll(() {
      now = DateTime.now();
      before20minutes = now.subtract(const Duration(minutes: 20));
    });

    test('test fromStartStop()', () {
      final StepSize stepSize = StepSize.fromStartStop(before20minutes, now);
      expect(stepSize.delta, const Duration(minutes: 1));
    });

    test('test fromTimeFrame()', () {
      final StepSize stepSize = StepSize.fromTimeFrame(
        now.difference(before20minutes),
      );
      expect(stepSize.delta, const Duration(minutes: 1));
    });

    test('test ==', () {
      final StepSize stepSize1 = StepSize.fromStartStop(before20minutes, now);
      //final StepSize stepSize2 = StepSize.fromStartStop(before20minutes, now);
      final StepSize stepSize2 = StepSize.fromTimeFrame(
        now.difference(before20minutes),
      );
      expect(stepSize1.delta == stepSize2.delta, true);
      expect(stepSize1 == stepSize2, true);
    });

    test('test fromDelta()', () {
      final StepSize stepSize = StepSize.fromDelta(
        const Duration(minutes: 1),
      );
      expect(stepSize.delta, const Duration(minutes: 1));
    });

    test('test fromDelta() invalid', () {
      expect(
        () => StepSize.fromDelta(
          const Duration(seconds: 20),
        ),
        throwsA(isA<FormatException>()),
      );
    });

    test('test zoomIn()', () {
      StepSize? stepSize = StepSize.fromDelta(
        const Duration(days: 7),
      );
      expect(stepSize.delta, const Duration(days: 7));
      stepSize = stepSize.zoomIn();
      expect(stepSize!.delta, const Duration(days: 1));
      stepSize = stepSize.zoomIn();
      expect(stepSize!.delta, const Duration(hours: 2));
      stepSize = stepSize.zoomIn();
      expect(stepSize!.delta, const Duration(hours: 1));
      stepSize = stepSize.zoomIn();
      expect(stepSize!.delta, const Duration(minutes: 10));
      stepSize = stepSize.zoomIn();
      expect(stepSize!.delta, const Duration(minutes: 1));
      stepSize = stepSize.zoomIn();
      expect(stepSize!.delta, const Duration(seconds: 10));
      stepSize = stepSize.zoomIn();
      expect(stepSize!.delta, const Duration(seconds: 1));
      stepSize = stepSize.zoomIn();
      expect(stepSize, null);
    });
    test('test zoomOut()', () {
      StepSize? stepSize = StepSize.fromDelta(
        const Duration(seconds: 1),
      );
      expect(stepSize.delta, const Duration(seconds: 1));
      stepSize = stepSize.zoomOut();
      expect(stepSize!.delta, const Duration(seconds: 10));
      stepSize = stepSize.zoomOut();
      expect(stepSize!.delta, const Duration(minutes: 1));
      stepSize = stepSize.zoomOut();
      expect(stepSize!.delta, const Duration(minutes: 10));
      stepSize = stepSize.zoomOut();
      expect(stepSize!.delta, const Duration(hours: 1));
      stepSize = stepSize.zoomOut();
      expect(stepSize!.delta, const Duration(hours: 2));
      stepSize = stepSize.zoomOut();
      expect(stepSize!.delta, const Duration(days: 1));
      stepSize = stepSize.zoomOut();
      expect(stepSize!.delta, const Duration(days: 7));
      stepSize = stepSize.zoomOut();
      expect(stepSize, null);
    });
  });
}

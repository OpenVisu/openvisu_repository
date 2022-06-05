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

enum ChartType {
  line,
  bar,
  barLive,
  area,
  pie;

  static ChartType fromString(final String s) {
    switch (s) {
      case 'line':
        return ChartType.line;
      case 'bar':
        return ChartType.bar;
      case 'bar-live':
        return ChartType.barLive;
      case 'area':
        return ChartType.area;
      case 'pie':
        return ChartType.pie;
    }
    return ChartType.line;
  }

  @override
  String toString() {
    if (this == ChartType.barLive) return 'bar-live';
    return name;
  }

  bool isLive() {
    switch (this) {
      case ChartType.barLive:
      case ChartType.pie:
        return true;
      case ChartType.line:
      case ChartType.bar:
      case ChartType.area:
        return false;
    }
  }
}

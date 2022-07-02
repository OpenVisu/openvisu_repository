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

enum PageType {
  none,
  text,
  iframe,
  image,
  chart,
  singleValue;

  static PageType fromString(final String s) {
    switch (s) {
      case 'text_page':
        return PageType.text;
      case 'iframe_page':
        return PageType.iframe;
      case 'image_page':
        return PageType.image;
      case 'chart_page':
        return PageType.chart;
      case 'single_value_page':
        return PageType.singleValue;
      default:
        return PageType.none;
    }
  }

  @override
  String toString() {
    switch (this) {
      case PageType.text:
        return 'text_page';
      case PageType.iframe:
        return 'iframe_page';
      case PageType.image:
        return 'image_page';
      case PageType.chart:
        return 'chart_page';
      case PageType.singleValue:
        return 'single_value_page';
      case PageType.none:
        return 'null';
    }
  }
}

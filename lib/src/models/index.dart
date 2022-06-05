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

import 'chart_page.dart';
import 'dashboard.dart';
import 'i_frame.dart';
import 'iframe_page.dart';
import 'image_page.dart';
import 'library_entry.dart';
import 'node.dart';
import 'page.dart';
import 'server.dart';
import 'single_value.dart';
import 'text_page.dart';
import 'time_serial.dart';

class Index {
  // not all are listed yet by purpose
  static const List<String> collections = [
    Server.collection,
    Node.collection,
    Dashboard.collection,
    Page.collection,
    ImagePage.collection,
    IframePage.collection,
    SingleValuePage.collection,
    TextPage.collection,
    ChartPage.collection,
    TimeSerial.collection,
    LibraryEntry.collection,
    IFrame.collection,
  ];
}

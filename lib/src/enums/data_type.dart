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

// ignore_for_file: constant_identifier_names

import 'dart:core' as dc;
import 'dart:math';

enum DataType {
  none,
  Boolean,
  Byte,
  ByteString,
  DataValue,
  DateTime,
  DiagnosticInfo,
  Double,
  ExpandedNodeId,
  ExtensionObject,
  Float,
  Guid,
  Int16,
  Int32,
  Int64,
  LocalizedText,
  NodeId,
  Null,
  QualifiedName,
  SByte,
  StatusCode,
  String,
  UInt16,
  UInt32,
  UInt64,
  Variant,
  XmlElement;

  final floatMaxFinite = 3.4028235e+38; // TODO validate 3.4028235e+38

  static DataType fromString(final dc.String t) {
    return DataType.values.firstWhere(
      (element) => element.name.toLowerCase() == t.toLowerCase(),
      orElse: () => DataType.none,
    );
  }

  @dc.override
  dc.String toString() {
    return name;
  }

  static dc.List<DataType> numeric() {
    return [
      Boolean,
      Float,
      Double,
      Int16,
      Int32,
      Int64,
      UInt16,
      UInt32,
      UInt64,
    ];
  }

  dc.bool isNumeric() {
    return DataType.numeric().contains(this);
  }

  static dc.List<DataType> trackable() {
    return [
      DataType.Boolean,
      DataType.Float,
      DataType.Double,
      DataType.String,
      DataType.Int16,
      DataType.Int32,
      DataType.Int64,
      DataType.UInt16,
      DataType.UInt32,
      DataType.UInt64,
    ];
  }

  dc.bool isTrackable() {
    return DataType.trackable().contains(this);
  }

  dc.bool isEditable() => isTrackable();

  dc.String? validate(dc.String? value) {
    if (value == null) {
      return null;
    }
    switch (this) {
      case Boolean:
        dc.int? v = dc.int.tryParse(value);
        if (v == null || (v != 0 && v != 1)) {
          return 'Invalid Boolean';
        }
        break;
      case Float:
        dc.double? v = dc.double.tryParse(value);
        if (v == null) {
          return 'Invalid Float';
        } else if (v > floatMaxFinite) {
          return 'Too big for Float';
        }
        break;
      case Double:
        dc.double? v = dc.double.tryParse(value);
        if (v == null) {
          return 'Invalid Double';
        } else if (v > dc.double.maxFinite) {
          return 'Too big for Double';
        }
        break;
      case Int16:
        dc.int? v = dc.int.tryParse(value);
        if (v == null) {
          return 'Invalid Int16';
        } else if (v > pow(2, 15) - 1) {
          return 'Too big for Int16';
        } else if (v < -pow(2, 15)) {
          return 'Too small for Int16';
        }
        break;
      case Int32:
        dc.int? v = dc.int.tryParse(value);
        if (v == null) {
          return 'Invalid Int32';
        } else if (v > pow(2, 31) - 1) {
          return 'Too big for Int32';
        } else if (v < -pow(2, 31)) {
          return 'Too small for Int32';
        }
        break;
      case Int64:
        dc.int? v = dc.int.tryParse(value);
        if (v == null) {
          return 'Invalid Int64';
        }
        // NOTE: cant give more detailed feedback as bigger / smaller numbers
        // can not be handled
        break;
      case UInt16:
        dc.int? v = dc.int.tryParse(value);
        if (v == null) {
          return 'Invalid UInt16';
        } else if (v < 0) {
          return 'Too small for UInt16';
        } else if (v > pow(2, 16) - 1) {
          return 'Too big for UInt16';
        }
        break;
      case UInt32:
        dc.int? v = dc.int.tryParse(value);
        if (v == null) {
          return 'Invalid UInt32';
        } else if (v < 0) {
          return 'Too small for UInt32';
        } else if (v > pow(2, 32) - 1) {
          return 'Too big for UInt32';
        }
        break;
      case UInt64:
        dc.int? v = dc.int.tryParse(value);
        if (v == null) {
          return 'Invalid UInt64';
        } else if (v < 0) {
          return 'Too small for UInt64';
        }
        // NOTE: cant give more detailed feedback as bigger
        // numbers can not be handled
        break;
      case String:
        if (value.length > 255) {
          return 'String max length is 255';
        }
        break;
      case DataType.none:
      case DataType.Byte:
      case DataType.ByteString:
      case DataType.DataValue:
      case DataType.DateTime:
      case DataType.DiagnosticInfo:
      case DataType.ExpandedNodeId:
      case DataType.ExtensionObject:
      case DataType.Guid:
      case DataType.LocalizedText:
      case DataType.NodeId:
      case DataType.Null:
      case DataType.QualifiedName:
      case DataType.SByte:
      case DataType.StatusCode:
      case DataType.Variant:
      case DataType.XmlElement:
        return 'Unsupported DataType: $name';
    }
    return null;
  }

  dc.dynamic cast(dc.String? value) {
    if (value == null) {
      return null;
    }
    switch (this) {
      case Boolean:
        return (dc.int.parse(value) == 1);
      case Float:
        dc.double v = dc.double.parse(value);
        if (v > floatMaxFinite) {
          throw const dc.FormatException('Too big for Float');
        }
        return v;
      case Double:
        return dc.double.parse(value);
      case Int16:
        return dc.int.parse(value).toSigned(16);
      case Int32:
        return dc.int.parse(value).toSigned(32);
      case Int64:
        return dc.int.parse(value);
      case UInt16:
        return dc.int.parse(value).toUnsigned(16);
      case UInt32:
        return dc.int.parse(value).toUnsigned(32);
      case UInt64:
        return dc.int.parse(value).toUnsigned(64);
      case String:
        if (value.length > 255) {
          throw const dc.FormatException('String max length is 255');
        }
        return value;
      case DataType.none:
      case DataType.Byte:
      case DataType.ByteString:
      case DataType.DataValue:
      case DataType.DateTime:
      case DataType.DiagnosticInfo:
      case DataType.ExpandedNodeId:
      case DataType.ExtensionObject:
      case DataType.Guid:
      case DataType.LocalizedText:
      case DataType.NodeId:
      case DataType.Null:
      case DataType.QualifiedName:
      case DataType.SByte:
      case DataType.StatusCode:
      case DataType.Variant:
      case DataType.XmlElement:
        throw dc.FormatException('Unsupported DataType: $name');
    }
    return null;
  }
}

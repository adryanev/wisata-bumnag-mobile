// Copyright (c) 2022, Adryan Eka Vandra
// https://github.com/adryanev/flutter-template-architecture-template
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:wisatabumnag/app/app.dart';
import 'package:wisatabumnag/bootstrap.dart';
import 'package:wisatabumnag/core/utils/constants.dart';

void main() {
  bootstrap(() => const App(), environment: Environment.development);
}

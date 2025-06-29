// Copyright (c) 2022, Adryan Eka Vandra
// https://github.com/adryanev/flutter-template-architecture-template
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:flutter/widgets.dart';
import 'package:wisatabumnag/l10n/l10n.dart';
export 'package:wisatabumnag/l10n/arb/app_localizations.dart';

extension AppLocalizationsX on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);
}

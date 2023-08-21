import 'package:flutter/material.dart';
import 'master.dart';

///This is the main entry point to run the source code.
///Please refer to ari.dart for various http requests
///and other .dart files for actual code.
///
///Below is the list of documents that might be useful.
///   * Hardware Overview
/// http://docs.pal-robotics.com/ari/sdk/23.1/hardware/hardware_overview.html
///
///   * REST interface
/// http://docs.pal-robotics.com/ari/sdk/23.1/development/js-api.html
///
///   * webGUI
///http://docs.pal-robotics.com/ari/sdk/23.1/management/webgui.html
///

void main() {
  runApp(const Master());
}

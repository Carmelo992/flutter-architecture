#!/bin/zsh
dart pub global activate flutter_gen
flutter pub get
dart run build_runner build
sh ./strings_link.sh

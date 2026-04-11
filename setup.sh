#!/bin/zsh
cd model
flutter pub get
cd ../view_model
flutter pub get
cd ../view
./setup.sh
cd ..
flutter pub get
./go_router.sh

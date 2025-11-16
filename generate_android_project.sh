PACKAGE_NAME=com.gameengine.game
rm -rf SDL3-3.2.26 || true 
rm -rf SDL3-devel-3.2.26-android || true 
wget -q https://github.com/libsdl-org/SDL/releases/download/release-3.2.26/SDL3-3.2.26.zip && unzip SDL3-3.2.26.zip && rm SDL3-3.2.26.zip
wget -q https://github.com/libsdl-org/SDL/releases/download/release-3.2.26/SDL3-devel-3.2.26-android.zip && unzip SDL3-devel-3.2.26-android.zip  -d SDL3-devel-3.2.26-android && rm SDL3-devel-3.2.26-android.zip
python generate_android_project.py  --variant aar --output .  $PACKAGE_NAME main.c
cp SDL3-devel-3.2.26-android/SDL3-3.2.26.aar $PACKAGE_NAME/app/libs/SDL3-3.2.26.aar
rm -rf SDL3-3.2.26 || true 
rm -rf SDL3-devel-3.2.26-android || true 

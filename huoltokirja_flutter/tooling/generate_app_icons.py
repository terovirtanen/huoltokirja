from pathlib import Path
import shutil
import subprocess
import tempfile

ROOT = Path(__file__).resolve().parents[1]
SRC = ROOT / 'assets/icon/app_icon.svg'

TARGETS = [
    (48, 'android/app/src/main/res/mipmap-mdpi/ic_launcher.png'),
    (72, 'android/app/src/main/res/mipmap-hdpi/ic_launcher.png'),
    (96, 'android/app/src/main/res/mipmap-xhdpi/ic_launcher.png'),
    (144, 'android/app/src/main/res/mipmap-xxhdpi/ic_launcher.png'),
    (192, 'android/app/src/main/res/mipmap-xxxhdpi/ic_launcher.png'),
    (32, 'web/favicon.png'),
    (192, 'web/icons/Icon-192.png'),
    (512, 'web/icons/Icon-512.png'),
    (20, 'ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-20x20@1x.png'),
    (40, 'ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-20x20@2x.png'),
    (60, 'ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-20x20@3x.png'),
    (29, 'ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-29x29@1x.png'),
    (58, 'ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-29x29@2x.png'),
    (87, 'ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-29x29@3x.png'),
    (40, 'ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-40x40@1x.png'),
    (80, 'ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-40x40@2x.png'),
    (120, 'ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-40x40@3x.png'),
    (120, 'ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-60x60@2x.png'),
    (180, 'ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-60x60@3x.png'),
    (76, 'ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-76x76@1x.png'),
    (152, 'ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-76x76@2x.png'),
    (167, 'ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-83.5x83.5@2x.png'),
    (1024, 'ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-1024x1024@1x.png'),
    (16, 'macos/Runner/Assets.xcassets/AppIcon.appiconset/app_icon_16.png'),
    (32, 'macos/Runner/Assets.xcassets/AppIcon.appiconset/app_icon_32.png'),
    (64, 'macos/Runner/Assets.xcassets/AppIcon.appiconset/app_icon_64.png'),
    (128, 'macos/Runner/Assets.xcassets/AppIcon.appiconset/app_icon_128.png'),
    (256, 'macos/Runner/Assets.xcassets/AppIcon.appiconset/app_icon_256.png'),
    (512, 'macos/Runner/Assets.xcassets/AppIcon.appiconset/app_icon_512.png'),
    (1024, 'macos/Runner/Assets.xcassets/AppIcon.appiconset/app_icon_1024.png'),
]


def render_png(size: int, relative_path: str) -> None:
    out_path = ROOT / relative_path
    out_path.parent.mkdir(parents=True, exist_ok=True)
    with out_path.open('wb') as stream:
        subprocess.run(
            [
                '/opt/homebrew/bin/rsvg-convert',
                '-w',
                str(size),
                '-h',
                str(size),
                str(SRC),
            ],
            check=True,
            stdout=stream,
        )


for icon_size, output_path in TARGETS:
    render_png(icon_size, output_path)

shutil.copyfile(ROOT / 'web/icons/Icon-192.png', ROOT / 'web/icons/Icon-maskable-192.png')
shutil.copyfile(ROOT / 'web/icons/Icon-512.png', ROOT / 'web/icons/Icon-maskable-512.png')

ffmpeg = shutil.which('ffmpeg')
if ffmpeg:
    temp_png = Path(tempfile.gettempdir()) / 'huoltokirja_app_icon.png'
    with temp_png.open('wb') as stream:
        subprocess.run(
            ['/opt/homebrew/bin/rsvg-convert', '-w', '256', '-h', '256', str(SRC)],
            check=True,
            stdout=stream,
        )
    subprocess.run(
        [ffmpeg, '-y', '-loglevel', 'error', '-i', str(temp_png), str(ROOT / 'windows/runner/resources/app_icon.ico')],
        check=True,
    )
    temp_png.unlink(missing_ok=True)

print('App icons generated from', SRC)

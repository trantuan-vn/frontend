import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:smartconsultor/core/components/colors.dart';
import 'package:smartconsultor/core/components/spacing.dart';
import 'package:smartconsultor/core/components/typography.dart';
import 'package:smartconsultor/core/utils/utils.dart';

class GetStarted extends StatelessWidget {
  const GetStarted({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: border)),
      margin: blockMargin,
      padding: const EdgeInsets.all(40),
      child: Align(
        alignment: Alignment.center,
        child: Container(
          constraints: const BoxConstraints(maxWidth: 780),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text("Made by ",
                      style: headlineSecondaryTextStyle.copyWith(fontSize: 24)),
                  Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: Image.asset("assets/images/google_logo.png",
                        width: 75, height: 24, fit: BoxFit.fill),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 32),
                child: RichText(
                  text: TextSpan(
                    children: [
                      const TextSpan(
                          text:
                              "Flutter is Google’s UI toolkit for building beautiful, natively compiled applications for ",
                          style: headlineSecondaryTextStyle),
                      TextSpan(
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              openUrl("https://flutter.dev/docs");
                            },
                          text: "mobile",
                          style: headlineSecondaryTextStyle.copyWith(
                              color: primary)),
                      const TextSpan(
                          text: ", ", style: headlineSecondaryTextStyle),
                      TextSpan(
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              openUrl("https://flutter.dev/web");
                            },
                          text: "web",
                          style: headlineSecondaryTextStyle.copyWith(
                              color: primary)),
                      const TextSpan(
                          text: ", and ", style: headlineSecondaryTextStyle),
                      TextSpan(
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              openUrl("https://flutter.dev/desktop");
                            },
                          text: "desktop",
                          style: headlineSecondaryTextStyle.copyWith(
                              color: primary)),
                      const TextSpan(
                          text: " from a single codebase.",
                          style: headlineSecondaryTextStyle),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 32),
                child: ResponsiveRowColumn(
                  layout: ResponsiveBreakpoints.of(context).largerThan(MOBILE) ? ResponsiveRowColumnType.COLUMN: ResponsiveRowColumnType.ROW,
                  rowMainAxisAlignment: MainAxisAlignment.center,
                  rowCrossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ResponsiveRowColumnItem(
                      child: TextButton(
                        onPressed: () => openUrl(
                            "https://flutter.dev/docs/get-started/install"),
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all<Color>(primary),
                            overlayColor:
                                MaterialStateProperty.resolveWith<Color>(
                              (Set<MaterialState> states) {
                                if (states.contains(MaterialState.hovered)) {
                                  return buttonPrimaryDark;
                                }
                                if (states.contains(MaterialState.focused) ||
                                    states.contains(MaterialState.pressed)) {
                                  return buttonPrimaryDarkPressed;
                                }
                                return primary;
                              },
                            ),
                            // Shape sets the border radius from default 3 to 0.
                            shape: MaterialStateProperty.resolveWith<
                                OutlinedBorder>(
                              (Set<MaterialState> states) {
                                if (states.contains(MaterialState.focused) ||
                                    states.contains(MaterialState.pressed)) {
                                  return const RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(0)));
                                }
                                return const RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(0)));
                              },
                            ),
                            padding:
                                MaterialStateProperty.all<EdgeInsetsGeometry>(
                                    const EdgeInsets.symmetric(
                                        vertical: 32, horizontal: 84)),
                            // Side adds pressed highlight outline.
                            side: MaterialStateProperty.resolveWith<BorderSide>(
                                (Set<MaterialState> states) {
                              if (states.contains(MaterialState.focused) ||
                                  states.contains(MaterialState.pressed)) {
                                return const BorderSide(
                                    width: 3,
                                    color: buttonPrimaryPressedOutline);
                              }
                              // Transparent border placeholder as Flutter does not allow
                              // negative margins.
                              return const BorderSide(
                                  width: 3, color: Colors.white);
                            })),
                        child: Text(
                          "Get started",
                          style: buttonTextStyle.copyWith(fontSize: 18),
                        ),
                      ),
                    ),
                    ResponsiveRowColumnItem(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: TextButton(
                          onPressed: () => {},
                          style: TextButton.styleFrom(
                            shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(0))),
                            padding: const EdgeInsets.symmetric(
                                vertical: 20, horizontal: 20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Padding(
                                padding: EdgeInsets.only(right: 8),
                                child: Icon(
                                  Icons.play_circle_filled,
                                  size: 24,
                                  color: primary,
                                ),
                              ),
                              Text(
                                "Watch video",
                                style: buttonTextStyle.copyWith(
                                    fontSize: 16, color: primary),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: RichText(
                  text: TextSpan(children: [
                    const TextSpan(
                        text: "Coming from another platform? Docs: ",
                        style: bodyTextStyle),
                    TextSpan(
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            openUrl(
                                "https://flutter.dev/docs/get-started/flutter-for/ios-devs");
                          },
                        text: "iOS",
                        style: bodyLinkTextStyle),
                    const TextSpan(text: ", ", style: bodyTextStyle),
                    TextSpan(
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            openUrl(
                                "https://flutter.dev/docs/get-started/flutter-for/android-devs");
                          },
                        text: "Android",
                        style: bodyLinkTextStyle),
                    const TextSpan(text: ", ", style: bodyTextStyle),
                    TextSpan(
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            openUrl(
                                "https://flutter.dev/docs/get-started/flutter-for/web-devs");
                          },
                        text: "Web",
                        style: bodyLinkTextStyle),
                    const TextSpan(text: ", ", style: bodyTextStyle),
                    TextSpan(
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            openUrl(
                                "https://flutter.dev/docs/get-started/flutter-for/react-native-devs");
                          },
                        text: "React Native",
                        style: bodyLinkTextStyle),
                    const TextSpan(text: ", ", style: bodyTextStyle),
                    TextSpan(
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            openUrl(
                                "https://flutter.dev/docs/get-started/flutter-for/xamarin-forms-devs");
                          },
                        text: "Xamarin",
                        style: bodyLinkTextStyle),
                    const TextSpan(text: ".", style: bodyTextStyle),
                  ]),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
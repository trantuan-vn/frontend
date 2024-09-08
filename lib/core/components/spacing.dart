import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

// Margin
const EdgeInsets marginBottom12 = EdgeInsets.only(bottom: 12);
const EdgeInsets marginBottom24 = EdgeInsets.only(bottom: 24);
const EdgeInsets marginBottom40 = EdgeInsets.only(bottom: 40);

// Padding
const EdgeInsets paddingBottom24 = EdgeInsets.only(bottom: 24);

// Block Spacing
List<Condition> blockWidthConstraints = [
  Condition.equals(name: MOBILE, value: const BoxConstraints(maxWidth: 600)),
  Condition.equals(name: TABLET, value: const BoxConstraints(maxWidth: 700)),
  Condition.largerThan(name: TABLET, value: const BoxConstraints(maxWidth: 1280)),
];

EdgeInsets blockPadding(BuildContext context) => ResponsiveValue(context,
        conditionalValues: [
          Condition.smallerThan(
              name: TABLET,
              value: const EdgeInsets.symmetric(horizontal: 15, vertical: 45))
        ],
        defaultValue: const EdgeInsets.symmetric(horizontal: 55, vertical: 80),
        ).value!;

const EdgeInsets blockMargin = EdgeInsets.fromLTRB(10, 0, 10, 32);
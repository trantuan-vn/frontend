import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class QuoteView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return Container(
      constraints: const BoxConstraints(
            maxWidth: 450,
            maxHeight: 470,
      ), 
      child: Stack(
        children: [
          // Background image
          SvgPicture.asset(
            "images/quote_background.svg",
            //height: double.infinity,
            fit: BoxFit.cover,
            //width: double.infinity,
          ),
          Align(
            alignment: Alignment.center, // Căn giữa theo trục X và Y
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    "images/quote_string.svg",
                    fit: BoxFit.cover,
                  ),              
                  const SizedBox(height: 20),
                  Text(
                      '"Triết lý đầu tư của tôi là: đừng mất tiền"',
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: Colors.white,
                      ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "Jack Ma",
                    style: theme.textTheme.bodyLarge?.copyWith(
                        color: Colors.white,
                    ),
                  ),
                ],
              ),
          ),
        ],
      ),
    );
  }
}

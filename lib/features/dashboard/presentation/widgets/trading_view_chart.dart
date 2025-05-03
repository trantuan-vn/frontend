import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:universal_html/html.dart' as html;

import 'web_view_registry_stub.dart'
    if (dart.library.html) 'web_view_registry.dart';

class TradingViewWidget extends StatelessWidget {
  final String symbol;
  final String interval;
  final String theme;

  const TradingViewWidget({
    super.key,
    this.symbol = 'BINANCE:BTCUSDT',
    this.interval = 'D',
    this.theme = 'dark',
  });

  String get htmlContent => '''
    <!DOCTYPE html>
    <html>
    <head>
      <style>
        html, body {
          margin: 0;
          padding: 0;
          width: 100%;
          height: 100%;
          overflow: hidden;
        }
        #tv_chart_container {
          width: 100%;
          height: 100%;
        }
      </style>
    </head>
    <body>
      <div id="tv_chart_container"></div>
      <script type="text/javascript" src="https://s3.tradingview.com/tv.js"></script>
      <script type="text/javascript">
        new TradingView.widget({
          "autosize": true,
          "symbol": "$symbol",
          "interval": "$interval",
          "timezone": "Etc/UTC",
          "theme": "$theme",
          "style": "1",
          "locale": "en",
          "toolbar_bg": "#f1f3f6",
          "enable_publishing": false,
          "allow_symbol_change": true,
          "container_id": "tv_chart_container"
        });
      </script>
    </body>
    </html>
  ''';

  @override
  Widget build(BuildContext context) {
    final String viewId =
        'tradingview-${DateTime.now().millisecondsSinceEpoch}';

    if (kIsWeb) {
      registerViewFactory(viewId, (int _) {
        final html.IFrameElement element = html.IFrameElement()
          ..width = '100%'
          ..height = '100%'
          ..srcdoc = htmlContent
          ..style.border = 'none';
        return element;
      });
    }

    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: kIsWeb
          ? HtmlElementView(viewType: viewId)
          : const Center(child: Text('WebView chỉ hỗ trợ trên Flutter Web')),
    );
  }
}

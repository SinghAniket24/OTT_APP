import 'dart:html' as html;
import 'dart:ui' as ui;
import 'package:flutter/material.dart';

class GamesPage extends StatefulWidget {
  @override
  _GamesPageState createState() => _GamesPageState();
}

class _GamesPageState extends State<GamesPage> {
  late String _selectedUrl;
  late String _currentViewId;

  final Map<String, String> _games = {
    'Zombie Mission': 'https://html5.gamemonetize.co/w9h0ox73ecodjfss7y26nqxyrntaz37c/',
    'Moto X3M': 'https://html5.gamemonetize.co/n0y6xdgb46bawirv0asddwh4qie2fnju/',
    'Stack Colors': 'https://html5.gamemonetize.co/34nwkjqmsl1gc36sefoqb52hxd2570ub/',
  };

  @override
  void initState() {
    super.initState();
    _selectedUrl = _games.values.first;
    _currentViewId = 'game-${_selectedUrl.hashCode}';
    _registerIframe(_selectedUrl);
  }

  void _registerIframe(String url) {
    final newViewId = 'game-${url.hashCode}';

    // Register the iframe
    // ignore: undefined_prefixed_name
    ui.platformViewRegistry.registerViewFactory(newViewId, (int viewId) {
      final iframe = html.IFrameElement()
        ..src = url
        ..style.border = 'none'
        ..style.width = '100%'
        ..style.height = '100%'
        ..allowFullscreen = true
        ..attributes['allowfullscreen'] = 'true'
        ..attributes['loading'] = 'eager';
      return iframe;
    });

    setState(() {
      _selectedUrl = url;
      _currentViewId = newViewId;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🎮 Play Online Games'),
        backgroundColor: Colors.deepPurple,
        elevation: 8,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _games.entries.map((entry) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: ChoiceChip(
                      label: Text(entry.key),
                      selected: _selectedUrl == entry.value,
                      onSelected: (_) => _registerIframe(entry.value),
                      selectedColor: Colors.deepPurple[300],
                      labelStyle: TextStyle(
                        color: _selectedUrl == entry.value
                            ? Colors.white
                            : Colors.deepPurple,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.deepPurple, width: 2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: HtmlElementView(
                  key: ValueKey(_currentViewId),
                  viewType: _currentViewId,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

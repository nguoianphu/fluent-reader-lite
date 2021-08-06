import 'package:fluent_reader_lite/components/list_tile_group.dart';
import 'package:fluent_reader_lite/components/my_list_tile.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:fluent_reader_lite/models/global_model.dart';
import 'package:fluent_reader_lite/utils/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';

class GeneralPage extends StatefulWidget {
  @override
  _GeneralPageState createState() => _GeneralPageState();
}

class _GeneralPageState extends State<GeneralPage> {
  bool _clearingCache = false;
  double textScale;

  void _clearCache() async {
    setState(() {
      _clearingCache = true;
    });
    await DefaultCacheManager().emptyCache();
    if (!mounted) return;
    setState(() {
      _clearingCache = false;
    });
  }

  @override
  Widget build(BuildContext context) => CupertinoPageScaffold(
        backgroundColor: MyColors.background,
        navigationBar: CupertinoNavigationBar(
          middle: Text(AppLocalizations.of(context).general),
        ),
        child: Consumer<GlobalModel>(
          builder: (context, globalModel, child) {
            final useSystemTextScale = globalModel.textScale == null;
            final textScaleItems = ListTileGroup([
              MyListTile(
                title: Text(AppLocalizations.of(context).followSystem),
                trailing: CupertinoSwitch(
                  value: useSystemTextScale,
                  onChanged: (v) {
                    textScale = null;
                    globalModel.textScale = v ? null : 1;
                  },
                ),
                trailingChevron: false,
                withDivider: !useSystemTextScale,
              ),
              if (!useSystemTextScale)
                MyListTile(
                  title: Expanded(
                      child: CupertinoSlider(
                    min: 0.5,
                    max: 1.5,
                    divisions: 8,
                    value: textScale ?? globalModel.textScale,
                    onChanged: (v) {
                      setState(() {
                        textScale = v;
                      });
                    },
                    onChangeEnd: (v) {
                      textScale = null;
                      globalModel.textScale = v;
                    },
                  )),
                  trailingChevron: false,
                  withDivider: false,
                ),
            ], title: AppLocalizations.of(context).fontSize);
            final syncItems = ListTileGroup([
              MyListTile(
                title: Text(AppLocalizations.of(context).syncOnStart),
                trailing: CupertinoSwitch(
                  value: globalModel.syncOnStart,
                  onChanged: (v) {
                    globalModel.syncOnStart = v;
                    setState(() {});
                  },
                ),
                trailingChevron: false,
              ),
              MyListTile(
                title: Text(AppLocalizations.of(context).inAppBrowser),
                trailing: CupertinoSwitch(
                  value: globalModel.inAppBrowser,
                  onChanged: (v) {
                    globalModel.inAppBrowser = v;
                    setState(() {});
                  },
                ),
                trailingChevron: false,
                withDivider: false,
              ),
            ], title: AppLocalizations.of(context).preferences);
            final storageItems = ListTileGroup([
              MyListTile(
                title: Text(AppLocalizations.of(context).clearCache),
                onTap: _clearingCache ? null : _clearCache,
                trailing: _clearingCache ? CupertinoActivityIndicator() : null,
                trailingChevron: !_clearingCache,
              ),
              MyListTile(
                title: Text(AppLocalizations.of(context).autoDelete),
                trailing: Text(AppLocalizations.of(context)
                    .daysAgo(globalModel.keepItemsDays)),
                trailingChevron: false,
                withDivider: false,
              ),
              MyListTile(
                title: Expanded(
                    child: CupertinoSlider(
                  min: 1,
                  max: 4,
                  divisions: 3,
                  value: (globalModel.keepItemsDays ~/ 7).toDouble(),
                  onChanged: (v) {
                    globalModel.keepItemsDays = (v * 7).toInt();
                    setState(() {});
                  },
                )),
                trailingChevron: false,
                withDivider: false,
              ),
            ], title: AppLocalizations.of(context).storage);
            final themeItems = ListTileGroup.fromOptions(
              [
                Tuple2(AppLocalizations.of(context).followSystem,
                    ThemeSetting.Default),
                Tuple2(AppLocalizations.of(context).light, ThemeSetting.Light),
                Tuple2(AppLocalizations.of(context).dark, ThemeSetting.Dark),
              ],
              globalModel.theme,
              (t) {
                globalModel.theme = t;
              },
              title: AppLocalizations.of(context).theme,
            );
            final localeItems = ListTileGroup.fromOptions(
              [
                Tuple2(AppLocalizations.of(context).followSystem, null),
                const Tuple2("Deutsch", Locale("de")),
                const Tuple2("English", Locale("en")),
                const Tuple2("Español", Locale("es")),
                const Tuple2("中文（简体）", Locale("zh")),
              ],
              globalModel.locale,
              (l) {
                globalModel.locale = l;
              },
              title: AppLocalizations.of(context).language,
            );
            return ListView(
              children: [
                syncItems,
                textScaleItems,
                storageItems,
                themeItems,
                localeItems,
              ],
            );
          },
        ),
      );
}

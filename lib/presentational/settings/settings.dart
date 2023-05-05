import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:shopping_list/services/settings/settings.service.dart';

class SettingsPage {
  BuildContext context;
  SettingsPage(this.context);

  final _settingsService = new SettingsService();
  int currentLocaleIndex;

  Future<void> showSettings() async {
    currentLocaleIndex = await _settingsService.getLocale() == 'en' ? 0 : 1;

    return showGeneralDialog(
      transitionBuilder: (context, anim1, anim2, child) {
        return SlideTransition(
          position:
              Tween(begin: Offset(0, 1), end: Offset(0, 0)).animate(anim1),
          child: child,
        );
      },
      context: context,
      barrierDismissible: false,
      barrierLabel: "Settings",
      transitionDuration: Duration(milliseconds: 200),
      pageBuilder: (_, __, ___) {
        return Scaffold(
            appBar: AppBar(
              // elevation: 0,
              title: Text('Settings', style: TextStyle(fontSize: 16)),
              toolbarHeight: 40,
              leading: IconButton(
                icon: Icon(Icons.close),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
            body: ListView(
              primary: false,
              children: [_language(), _currency()],
            ));
      },
    );
  }

  Widget _currency() {
    return Container(
      height: 40,
      // margin: EdgeInsets.symmetric(vertical: 30.0),
      padding: EdgeInsets.only(left: 20.0),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.grey,
            width: 0.3,
          ),
        ),
      ),
      child: StreamBuilder<Object>(
          stream: _settingsService.currentCurrency,
          builder: (context, snapshot) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(AppLocalizations.of(context).currency),
                FutureBuilder<Currencies>(
                    future: _settingsService.getCurrency(),
                    builder: (context, currencySnapshot) {
                      return Container(
                        margin: EdgeInsets.only(bottom: 10),
                        child: CupertinoSegmentedControl(
                            pressedColor: Colors.transparent,
                            groupValue: currencySnapshot.data,
                            onValueChanged: (value) {
                              _settingsService.updateCurrency(value);
                            },
                            children: {
                              Currencies.usd: Container(
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  child: Text('\$')),
                              Currencies.euro: Container(
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  child: Text('€')),
                              Currencies.ron: Container(
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  child: Text('RON')),
                            }),
                      );
                    }),
              ],
            );
          }),
    );
  }

  Widget _language() {
    return Container(
      height: 35,
      margin: EdgeInsets.symmetric(vertical: 30.0),
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 20.0),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.grey,
            width: 0.3,
          ),
        ),
      ),
      child: InkWell(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(AppLocalizations.of(context).language),
              FutureBuilder<String>(
                  future: _settingsService.getLocale(),
                  builder: (context, localeSnapshot) {
                    var value = AppLocalizations.of(context).english;
                    if (localeSnapshot.data == 'ro') {
                      value = AppLocalizations.of(context).romanian;
                    }
                    return Text(
                      value,
                      style: TextStyle(color: Colors.red),
                    );
                  }),
            ],
          ),
          onTap: () => showlanguagePicker()),
    );
  }

  showlanguagePicker() {
    var brightness = MediaQuery.of(context).platformBrightness;
    bool darkModeOn = brightness == Brightness.dark;
    return showCupertinoModalPopup(
      context: context,
      builder: (_) => Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: !darkModeOn
              ? Color.fromARGB(255, 255, 255, 255)
              : Colors.transparent,
        ),
        height: 170,
        child: Stack(
          children: [
            Container(
              margin: EdgeInsets.only(top: 20.0),
              height: 100,
              child: CupertinoPicker(
                  useMagnifier: true,
                  itemExtent: 26.0,
                  scrollController: FixedExtentScrollController(
                      initialItem: currentLocaleIndex),
                  onSelectedItemChanged: (int value) {
                    currentLocaleIndex = value;
                  },
                  children: [
                    Text(
                      AppLocalizations.of(context).english,
                      style: TextStyle(
                          color: Theme.of(context).textTheme.button.color),
                    ),
                    Text(
                      AppLocalizations.of(context).romanian,
                      style: TextStyle(
                          color: Theme.of(context).textTheme.button.color),
                    ),
                  ]),
            ),
            Positioned(
              top: 0,
              right: 2,
              child: CupertinoButton(
                  child: Text(AppLocalizations.of(context).confirm),
                  onPressed: () {
                    _settingsService
                        .updateLocale(currentLocaleIndex == 0 ? 'en' : 'ro');
                    Navigator.of(context).pop();
                  }),
            )
          ],
        ),
      ),
    );
  }
}

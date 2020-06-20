import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:select_dialog/select_dialog.dart';

import 'channels/channels.dart';
import 'contact_utils.dart';
import 'localization/localization.dart';
import 'permissions/permissions.dart';
import 'sms/sms.dart';
import 'widgets/action_button.dart';
import 'widgets/avatar_button.dart';

lightTheme(BuildContext context) => ThemeData(
      brightness: Brightness.light,
      primarySwatch: Colors.pink,
      visualDensity: VisualDensity.adaptivePlatformDensity,
    );

darkTheme(BuildContext context) => ThemeData(
      brightness: Brightness.dark,
      primarySwatch: Colors.pink,
      visualDensity: VisualDensity.adaptivePlatformDensity,
    );

final fullPage = (Widget widget) => SizedBox.expand(
      child: SafeArea(
        minimum: const EdgeInsets.all(10.0),
        child: widget,
      ),
    );

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      onGenerateTitle: (c) => AppLocalizations.of(c).appTitle,
      theme: lightTheme(context),
      darkTheme: darkTheme(context),
      home: Home(),
      localizationsDelegates: AppLocalizations.delegates,
      localeResolutionCallback: AppLocalizations.resolutionCallback,
    );
  }
}

class Home extends StatefulWidget {
  Home({Key key}) : super(key: key);

  @override
  createState() => _HomeState();
}

class _HomeState extends State<Home> {
  static const phoneChannel = const PhoneChannel();
  static const intentsChannel = const IntentsChannel();

  static final _initialAvatar = Image.asset('assets/add-contact.png');

  // Selected contact's name
  String _name;

  // Selected contact's phone number
  String _number;

  // Selected contact's avatar
  Image _avatar = _initialAvatar;

  // Currently-selected SIM card
  SimCard _simCard;

  // Flags
  bool _isSelectingContacts = false;
  bool _isLaunchingSmsComposer = false;

  /// Makes sure we've got a SIM card
  /// If [force] is set, disregard current state.
  _selectSimCardIfNeeded(BuildContext context, [bool force = false]) async {
    // Make sure we can access telephony services
    if (!await Permissions(context, intentsChannel).phone) return false;

    // Grab all the SIM cards information
    final cards = await phoneChannel.simCards();
    if (cards.length == 0) return false;

    if (!force) {
      // If the currently-selected SIM card still exists, refresh its
      // information (slot or subscription may have changed) and
      // return.
      for (var card in cards) {
        if (card.number == _simCard?.number) {
          setState(() {
            _simCard = card;
          });
          return true;
        }
      }

      // If there's only one SIM card, use it.
      if (cards.length == 1) {
        final card = cards[0];
        setState(() {
          _simCard = card;
        });
        return true;
      }
    }

    // No SIM card could be automatically selected, so we ask the user
    // to manually pick one.
    var selected = false;
    await SelectDialog.showModal<SimCard>(context,
        label: AppLocalizations.of(context).pickSimCard,
        titleStyle: TextStyle(color: Colors.brown),
        showSearchBox: false,
        items: cards, onChange: (selectedCard) {
      selected = true;
      setState(() {
        _simCard = selectedCard;
      });
    }, itemBuilder: (BuildContext context, SimCard item, bool isSelected) {
      return Container(
        decoration: !isSelected
            ? null
            : BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Colors.white,
                border: Border.all(
                  color: Theme.of(context).primaryColor,
                ),
              ),
        child: ListTile(
          selected: isSelected,
          title: Text(
            item.number,
            style: Theme.of(context).textTheme.subtitle1.copyWith(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
          ),
          subtitle: Text(
            item.name,
          ),
        ),
      );
    });

    return selected;
  }

  /// Send a command to the mimamori keitai.
  _sendSmsCommand(BuildContext context, String command) async {
    // Can't do that without a number…
    final number = _number;
    if (number == null) return;

    // Make sure we have everything needed
    if (!await Permissions(context, intentsChannel).sms) return;
    if (!await _selectSimCardIfNeeded(context)) return;

    // and send
    await phoneChannel.sendTextMessage(number, command, _simCard.subscription);
  }

  _openSmsComposer(BuildContext context) async {
    if (_isLaunchingSmsComposer) return;
    _isLaunchingSmsComposer = true;

    try {
      final number = _number;
      if (number == null) return;

      await intentsChannel.startComposingMessage(number);
    } finally {
      _isLaunchingSmsComposer = false;
    }
  }

  _selectContact(BuildContext context) async {
    if (!await Permissions(context, intentsChannel).contacts) return;

    if (_isSelectingContacts) return;
    _isSelectingContacts = true;

    try {
      _setContact(await ContactsService.openDeviceContactPicker());
    } catch (FormOperationException) {
      // no-op
    }
    _isSelectingContacts = false;
  }

  _setContact(Contact contact) => setState(() {
        _number = contact?.bestPhoneNumberForSms;
        if (_number == null) {
          _name = null;
          _avatar = _initialAvatar;
          return;
        }

        _name = contact?.displayName ?? _number;

        // Avatar
        final avatarBytes = contact?.avatar;
        if (avatarBytes != null && avatarBytes.length > 0)
          _avatar = Image.memory(avatarBytes);
        else
          _avatar = Image.asset('assets/default-avatar.png');
      });

  @override
  build(BuildContext context) {
    //final query = MediaQuery.of(context);

    final avatar = Flexible(
      flex: 0,
      fit: FlexFit.tight,
      child: Column(
        children: [
          AvatarButton(
            onTap: () async {
              await _selectContact(context);
            },
            image: _avatar,
            size: 150,
          ),
          Padding(
            padding: EdgeInsets.only(top: 8.0),
            child: Text(
              _name ?? AppLocalizations.of(context).pickContact,
              style: Theme.of(context).textTheme.button.copyWith(
                    fontSize: 16.0,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
            ),
          ),
        ],
      ),
    );

    final menu = _number == null
        ? Container()
        : SingleChildScrollView(
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            ActionButton(
              label: AppLocalizations.of(context).requestMostRecentLocation,
              imageName: 'location',
              onTap: () async {
                await _sendSmsCommand(
                    context, SmsCommands.requestMostRecentLocation);
              },
            ),
            ActionButton(
              label: AppLocalizations.of(context).requestLocationLog,
              imageName: 'location-log',
              onTap: () async {
                await _sendSmsCommand(context, SmsCommands.requestLocationLog);
              },
            ),
            ActionButton(
              label: AppLocalizations.of(context).switchContinuousTrackingOn,
              imageName: 'start',
              onTap: () async {
                await _sendSmsCommand(
                    context, SmsCommands.switchContinuousTrackingOn);
              },
            ),
            ActionButton(
              label: AppLocalizations.of(context).switchContinuousTrackingOff,
              imageName: 'stop',
              onTap: () async {
                await _sendSmsCommand(
                    context, SmsCommands.switchContinuousTrackingOff);
              },
            ),
            ActionButton(
              label: AppLocalizations.of(context).startChat,
              imageName: 'chat',
              onTap: () async {
                await _openSmsComposer(context);
              },
            ),
            ActionButton(
              label: AppLocalizations.of(context).triggerAlarm,
              imageName: 'alarm',
              onTap: () async {
                await _sendSmsCommand(context, SmsCommands.triggerAlarm);
              },
            ),
          ]));

    return Scaffold(
      extendBodyBehindAppBar: true,
      body: OrientationBuilder(
        builder: (context, orientation) {
          return fullPage(Row(
            children: <Widget>[
              orientation == Orientation.portrait ? Container() : avatar,
              Flexible(
                  flex: 2,
                  child: Column(
                    children: [
                      orientation == Orientation.landscape
                          ? Container()
                          : avatar,
                      Expanded(
                        child: menu,
                      ),
                    ],
                  )),
            ],
          ));
        },
      ),
    );
  }
}

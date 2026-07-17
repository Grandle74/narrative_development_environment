import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Narrative Development Environment'**
  String get appTitle;

  /// No description provided for @charactersTitle.
  ///
  /// In en, this message translates to:
  /// **'Characters'**
  String get charactersTitle;

  /// No description provided for @addCharacter.
  ///
  /// In en, this message translates to:
  /// **'Add Character'**
  String get addCharacter;

  /// No description provided for @nameLabel.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get nameLabel;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @noCharactersYet.
  ///
  /// In en, this message translates to:
  /// **'No characters yet. Tap + to add one.'**
  String get noCharactersYet;

  /// No description provided for @unnamedCharacter.
  ///
  /// In en, this message translates to:
  /// **'Unnamed'**
  String get unnamedCharacter;

  /// No description provided for @characterDetailTitle.
  ///
  /// In en, this message translates to:
  /// **'Character'**
  String get characterDetailTitle;

  /// No description provided for @saved.
  ///
  /// In en, this message translates to:
  /// **'Saved'**
  String get saved;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @appearanceTitle.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get appearanceTitle;

  /// No description provided for @themeSystem.
  ///
  /// In en, this message translates to:
  /// **'System default'**
  String get themeSystem;

  /// No description provided for @themeLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get themeLight;

  /// No description provided for @themeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get themeDark;

  /// No description provided for @darkBackgroundTitle.
  ///
  /// In en, this message translates to:
  /// **'Dark background'**
  String get darkBackgroundTitle;

  /// No description provided for @darkVariantGray.
  ///
  /// In en, this message translates to:
  /// **'Dark Gray'**
  String get darkVariantGray;

  /// No description provided for @darkVariantOled.
  ///
  /// In en, this message translates to:
  /// **'OLED (pure black)'**
  String get darkVariantOled;

  /// No description provided for @sectionIdentity.
  ///
  /// In en, this message translates to:
  /// **'Identity'**
  String get sectionIdentity;

  /// No description provided for @sectionPowers.
  ///
  /// In en, this message translates to:
  /// **'Powers'**
  String get sectionPowers;

  /// No description provided for @sectionNarrative.
  ///
  /// In en, this message translates to:
  /// **'Narrative'**
  String get sectionNarrative;

  /// No description provided for @sectionInternalState.
  ///
  /// In en, this message translates to:
  /// **'Core'**
  String get sectionInternalState;

  /// No description provided for @sectionDecisionModel.
  ///
  /// In en, this message translates to:
  /// **'Decision Making'**
  String get sectionDecisionModel;

  /// No description provided for @sectionKnowledge.
  ///
  /// In en, this message translates to:
  /// **'Secrets'**
  String get sectionKnowledge;

  /// No description provided for @sectionExpression.
  ///
  /// In en, this message translates to:
  /// **'Expression'**
  String get sectionExpression;

  /// No description provided for @attrAlias.
  ///
  /// In en, this message translates to:
  /// **'Alias'**
  String get attrAlias;

  /// No description provided for @attrSpecies.
  ///
  /// In en, this message translates to:
  /// **'Species'**
  String get attrSpecies;

  /// No description provided for @attrBirth.
  ///
  /// In en, this message translates to:
  /// **'Birth'**
  String get attrBirth;

  /// No description provided for @attrNationality.
  ///
  /// In en, this message translates to:
  /// **'Nationality'**
  String get attrNationality;

  /// No description provided for @attrCurrentArc.
  ///
  /// In en, this message translates to:
  /// **'Current Arc'**
  String get attrCurrentArc;

  /// No description provided for @attrRole.
  ///
  /// In en, this message translates to:
  /// **'Role'**
  String get attrRole;

  /// No description provided for @attrAffiliation.
  ///
  /// In en, this message translates to:
  /// **'Affiliation'**
  String get attrAffiliation;

  /// No description provided for @attrProductionStatus.
  ///
  /// In en, this message translates to:
  /// **'Production Status'**
  String get attrProductionStatus;

  /// No description provided for @attrNarrativePurpose.
  ///
  /// In en, this message translates to:
  /// **'Narrative Purpose'**
  String get attrNarrativePurpose;

  /// No description provided for @attrFirstAppearanceVolume.
  ///
  /// In en, this message translates to:
  /// **'First Appearance (Volume)'**
  String get attrFirstAppearanceVolume;

  /// No description provided for @attrFirstAppearanceChapter.
  ///
  /// In en, this message translates to:
  /// **'First Appearance (Chapter)'**
  String get attrFirstAppearanceChapter;

  /// No description provided for @attrCoreBelief.
  ///
  /// In en, this message translates to:
  /// **'Core Belief'**
  String get attrCoreBelief;

  /// No description provided for @attrCoreDesire.
  ///
  /// In en, this message translates to:
  /// **'Core Desire'**
  String get attrCoreDesire;

  /// No description provided for @attrCoreFear.
  ///
  /// In en, this message translates to:
  /// **'Core Fear'**
  String get attrCoreFear;

  /// No description provided for @attrCoreConflict.
  ///
  /// In en, this message translates to:
  /// **'Core Conflict'**
  String get attrCoreConflict;

  /// No description provided for @attrDecisionProcess.
  ///
  /// In en, this message translates to:
  /// **'Decision Process'**
  String get attrDecisionProcess;

  /// No description provided for @attrNeverDoes.
  ///
  /// In en, this message translates to:
  /// **'Never Does'**
  String get attrNeverDoes;

  /// No description provided for @attrNeverSays.
  ///
  /// In en, this message translates to:
  /// **'Never Says'**
  String get attrNeverSays;

  /// No description provided for @attrNeverAdmits.
  ///
  /// In en, this message translates to:
  /// **'Never Admits'**
  String get attrNeverAdmits;

  /// No description provided for @attrKnownSecret.
  ///
  /// In en, this message translates to:
  /// **'Known Secret'**
  String get attrKnownSecret;

  /// No description provided for @attrHiddenSecret.
  ///
  /// In en, this message translates to:
  /// **'Hidden Secret'**
  String get attrHiddenSecret;

  /// No description provided for @attrFalseAssumption.
  ///
  /// In en, this message translates to:
  /// **'False Assumption'**
  String get attrFalseAssumption;

  /// No description provided for @attrDialogueStyle.
  ///
  /// In en, this message translates to:
  /// **'Dialogue Style'**
  String get attrDialogueStyle;

  /// No description provided for @attrTypicalBehavior.
  ///
  /// In en, this message translates to:
  /// **'Typical Behavior'**
  String get attrTypicalBehavior;

  /// No description provided for @attrBodyLanguage.
  ///
  /// In en, this message translates to:
  /// **'Body Language'**
  String get attrBodyLanguage;

  /// No description provided for @speciesHuman.
  ///
  /// In en, this message translates to:
  /// **'Human'**
  String get speciesHuman;

  /// No description provided for @speciesMonster.
  ///
  /// In en, this message translates to:
  /// **'Monster'**
  String get speciesMonster;

  /// No description provided for @speciesSkeleton.
  ///
  /// In en, this message translates to:
  /// **'Skeleton'**
  String get speciesSkeleton;

  /// No description provided for @speciesHalfHumanMonster.
  ///
  /// In en, this message translates to:
  /// **'Half-Human, Half-Monster'**
  String get speciesHalfHumanMonster;

  /// No description provided for @speciesHalfHumanSkeleton.
  ///
  /// In en, this message translates to:
  /// **'Half-Human, Half-Skeleton'**
  String get speciesHalfHumanSkeleton;

  /// No description provided for @prodConcept.
  ///
  /// In en, this message translates to:
  /// **'Concept'**
  String get prodConcept;

  /// No description provided for @prodDeveloping.
  ///
  /// In en, this message translates to:
  /// **'Developing'**
  String get prodDeveloping;

  /// No description provided for @prodActive.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get prodActive;

  /// No description provided for @prodFinal.
  ///
  /// In en, this message translates to:
  /// **'Final'**
  String get prodFinal;

  /// No description provided for @prodCut.
  ///
  /// In en, this message translates to:
  /// **'Cut'**
  String get prodCut;

  /// No description provided for @mainPowerLabel.
  ///
  /// In en, this message translates to:
  /// **'Main Power'**
  String get mainPowerLabel;

  /// No description provided for @stonePowersLabel.
  ///
  /// In en, this message translates to:
  /// **'Power Stones'**
  String get stonePowersLabel;

  /// No description provided for @powerNone.
  ///
  /// In en, this message translates to:
  /// **'None'**
  String get powerNone;

  /// No description provided for @powerFire.
  ///
  /// In en, this message translates to:
  /// **'Fire Nature'**
  String get powerFire;

  /// No description provided for @powerIce.
  ///
  /// In en, this message translates to:
  /// **'Ice Nature'**
  String get powerIce;

  /// No description provided for @powerMist.
  ///
  /// In en, this message translates to:
  /// **'Mist Nature'**
  String get powerMist;

  /// No description provided for @powerEarth.
  ///
  /// In en, this message translates to:
  /// **'Earth Nature'**
  String get powerEarth;

  /// No description provided for @powerWater.
  ///
  /// In en, this message translates to:
  /// **'Water Nature'**
  String get powerWater;

  /// No description provided for @powerAir.
  ///
  /// In en, this message translates to:
  /// **'Air Nature'**
  String get powerAir;

  /// No description provided for @powerElectro.
  ///
  /// In en, this message translates to:
  /// **'Electro Nature'**
  String get powerElectro;

  /// No description provided for @powerPlant.
  ///
  /// In en, this message translates to:
  /// **'Plant Nature'**
  String get powerPlant;

  /// No description provided for @powerDark.
  ///
  /// In en, this message translates to:
  /// **'Dark Nature'**
  String get powerDark;

  /// No description provided for @tagAddHint.
  ///
  /// In en, this message translates to:
  /// **'Add…'**
  String get tagAddHint;

  /// No description provided for @undo.
  ///
  /// In en, this message translates to:
  /// **'Undo'**
  String get undo;

  /// No description provided for @removedTag.
  ///
  /// In en, this message translates to:
  /// **'Removed'**
  String get removedTag;

  /// No description provided for @unlockToEdit.
  ///
  /// In en, this message translates to:
  /// **'Unlock to edit'**
  String get unlockToEdit;

  /// No description provided for @lockEditing.
  ///
  /// In en, this message translates to:
  /// **'Lock'**
  String get lockEditing;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}

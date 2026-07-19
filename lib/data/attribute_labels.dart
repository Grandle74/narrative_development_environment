import '../l10n/generated/app_localizations.dart';

/// Attribute keys and layers are stable identifiers (registry data, not
/// UI strings). This file is the one place that maps those identifiers
/// to bilingual display text, so adding a new attribute means adding
/// one line here plus one line in the .arb files — not touching any
/// screen.

String attributeLabel(AppLocalizations l10n, String attrKey) {
  switch (attrKey) {
    case 'name':
      return l10n.nameLabel;
    case 'alias':
      return l10n.attrAlias;
    case 'species':
      return l10n.attrSpecies;
    case 'birth':
      return l10n.attrBirth;
    case 'nationality':
      return l10n.attrNationality;
    case 'participated_arcs':
      return l10n.attrParticipatedArcs;
    case 'role':
      return l10n.attrRole;
    case 'affiliation':
      return l10n.attrAffiliation;
    case 'production_status':
      return l10n.attrProductionStatus;
    case 'narrative_purpose':
      return l10n.attrNarrativePurpose;
    case 'first_appearance_volume':
      return l10n.attrFirstAppearanceVolume;
    case 'first_appearance_chapter':
      return l10n.attrFirstAppearanceChapter;
    case 'core_belief':
      return l10n.attrCoreBelief;
    case 'core_desire':
      return l10n.attrCoreDesire;
    case 'core_fear':
      return l10n.attrCoreFear;
    case 'core_conflict':
      return l10n.attrCoreConflict;
    case 'decision_process':
      return l10n.attrDecisionProcess;
    case 'never_does':
      return l10n.attrNeverDoes;
    case 'never_says':
      return l10n.attrNeverSays;
    case 'never_admits':
      return l10n.attrNeverAdmits;
    case 'known_secret':
      return l10n.attrKnownSecret;
    case 'hidden_secret':
      return l10n.attrHiddenSecret;
    case 'false_assumption':
      return l10n.attrFalseAssumption;
    case 'dialogue_style':
      return l10n.attrDialogueStyle;
    case 'typical_behavior':
      return l10n.attrTypicalBehavior;
    case 'body_language':
      return l10n.attrBodyLanguage;
    default:
      return attrKey;
  }
}

String sectionLabel(AppLocalizations l10n, String layer) {
  switch (layer) {
    case 'identity':
      return l10n.sectionIdentity;
    case 'powers':
      return l10n.sectionPowers;
    case 'narrative':
      return l10n.sectionNarrative;
    case 'internal_state':
      return l10n.sectionInternalState;
    case 'decision_model':
      return l10n.sectionDecisionModel;
    case 'knowledge':
      return l10n.sectionKnowledge;
    case 'expression':
      return l10n.sectionExpression;
    default:
      return layer;
  }
}

String enumOptionLabel(AppLocalizations l10n, String attrKey, String value) {
  switch ('$attrKey.$value') {
    case 'species.human':
      return l10n.speciesHuman;
    case 'species.monster':
      return l10n.speciesMonster;
    case 'species.skeleton':
      return l10n.speciesSkeleton;
    case 'species.half_human_monster':
      return l10n.speciesHalfHumanMonster;
    case 'species.half_human_skeleton':
      return l10n.speciesHalfHumanSkeleton;
    case 'production_status.concept':
      return l10n.prodConcept;
    case 'production_status.developing':
      return l10n.prodDeveloping;
    case 'production_status.active':
      return l10n.prodActive;
    case 'production_status.final':
      return l10n.prodFinal;
    case 'production_status.cut':
      return l10n.prodCut;
    default:
      return value;
  }
}

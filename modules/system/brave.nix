{ pkgs, ... }:

let
  policy = name: attrs: {
    "brave/policies/managed/${name}.json".source =
      pkgs.writeText "brave-${name}-policy.json" (builtins.toJSON attrs);
  };
in
{
  environment.systemPackages = [ pkgs.brave-origin ];

  environment.etc =
    policy "autofill" {
      PasswordManagerEnabled = false;
      AutofillAddressEnabled = false;
      AutofillCreditCardEnabled = false;
    }
    // policy "privacy" {
      MetricsReportingEnabled = false;
      SearchSuggestEnabled = false;
      BackgroundModeEnabled = false;
      PromotionsEnabled = false;
      WebRtcIPHandling = "default_public_interface_only";
      NetworkPredictionOptions = 2;
      HighEfficiencyModeEnabled = true;
      BraveP3AEnabled = false;
      BraveStatsPingEnabled = false;
      BraveWebDiscoveryEnabled = false;
      BraveRewardsDisabled = true;
      BraveAIChatEnabled = false;
      BraveNewsDisabled = true;
      BraveVPNDisabled = true;
      BraveWalletDisabled = true;
      SyncDisabled = true;
      BrowserSignin = 0;
      UrlKeyedAnonymizedDataCollectionEnabled = false;
      SafeBrowsingExtendedReportingEnabled = false;
      SafeBrowsingSurveysEnabled = false;
      SafeBrowsingDeepScanningEnabled = false;
      PasswordLeakDetectionEnabled = false;
      SpellCheckServiceEnabled = false;
      TranslateEnabled = false;
      AlternateErrorPagesEnabled = false;
      DomainReliabilityAllowed = false;
      WebRtcEventLogCollectionAllowed = false;
      UserFeedbackAllowed = false;
      FeedbackSurveysEnabled = false;
      MediaRecommendationsEnabled = false;
      ShoppingListEnabled = false;
      TorDisabled = true;
      BraveTalkDisabled = true;
      BraveGlobalPrivacyControlEnabled = true;
      PaymentMethodQueryEnabled = false;
      BravePlaylistEnabled = false;
      BraveDeAmpEnabled = true;
      BraveDebouncingEnabled = true;
      BraveTrackingQueryParametersFilteringEnabled = true;
    };
}

{
  config,
  pkgs,
  ...
}: {
  home.packages = [
    pkgs.vesktop
  ];

  # based on <https://github.com/Marcus-Arcadius/nixdots/blob/main/modules/home/programs/discocss/default.nix>
  xdg.configFile."Vencord/settings/quickCss.css".text = with config.colorscheme.colors; ''
    /**
     * @name Discord base 16 Nix theme
     * @author sioodmy
     * @version 0.0.1
     * @description Automatically generated theme
     * @website https://github.com/sioodmy/nixdots
     * @source https://github.com/sioodmy/nixdots
     **/

    .theme-dark {
        --header-primary: #${base07} !important;
        --header-secondary: #${base0A} !important;
        --background-primary: #${base00} !important;
        --background-primary-alt: #${base00} !important;
        --background-mobile-primary: #${base00} !important;
        --background-secondary: #${base01} !important;
        --background-secondary-alt: #${base01} !important;
        --background-mobile-secondary: #${base01} !important;
        --background-tertiary: #${base02} !important;
        --background-floating: #${base00} !important;
        --background-mentioned: #${base01} !important;
        --background-mentioned-hover: #${base02} !important;
        --background-accent: #${base0F} !important;
        --background-modifier-selected: #${base00} !important;
        --background-modifier-accent: #${base00} !important;
        --background-modifier-hover: #${base0A} !important;
        --text-normal: #${base07} !important;
        --text-muted: #${base0F} !important;
        --text-link: #${base03} !important;
        --channels-default: #${base0F} !important;
        --channeltextarea-background: #${base0A} !important;
        --activity-card-background: #${base00} !important;
        --interactive-normal: #${base07} !important;
        --interactive-muted: #${base0A} !important;
        --interactive-hover: #${base0F} !important;
        --interactive-active: #${base0A} !important;
        --scrollbar-thin-thumb: #${base02} !important;
        --scrollbar-thin-track: transparent !important;
        --scrollbar-auto-thumb: #${base02} !important;
        --scrollbar-auto-track: #${base0A} !important;
        --scrollbar-auto-scrollbar-color-thumb: #${base01} !important;
        --scrollbar-auto-scrollbar-color-track: #${base0A} !important;
        --deprecated-store-bg: #${base02} !important;
        --input-background: #${base01} !important;
    }

    /* Mentions */
    .mentioned-Tre-dv .mention.interactive {
        color: var(--base07) !important;
    }

    .mentioned-Tre-dv::before {
        background-color: var(--base07) !important;
    }

    /* Remaining CSS rules... */


          /* Home */
          .container-2cd8Mz {
          	background-color: var(--black2) !important;
          }

          /* Autocomplete popup */
          .autocomplete-3NRXG8 {
          	background-color: var(--black2) !important;
          }

          .wrapper-1NNaWG.categoryHeader-OpJ1Ly {
          	background-color: var(--black2) !important;
          }

          .autocomplete-3NRXG8 {
          	background-color: var(--black2) !important;
          }

          /* Autocomplete popup selection */
          .selected-3H3-RC {
          	background-color: var(--black3) !important;
          }

          /* Search: Items */
          .container-2McqkF {
          	background-color: var(--black0) !important;
          }

          .searchOption-351dTI:hover {
          	background-color: var(--black3) !important;
          }

          /* Search: No shadows */
          .option-ayUoaq:after {
          	background: none !important;
          }

          /* Search: in-section */
          .queryContainer-ZunrLZ {
          	background-color: var(--black0) !important;
          }

          /* Search: History */
          .option-ayUoaq:hover {
          	background-color: var(--black3) !important;
          }

          /* Search: Little Icon Thingy */
          .searchFilter-2UfsDk,
          .searchAnswer-23w-CH {
          	background-color: var(--black3) !important;
          }

          /* IN ORDER: New-Unreads-Btn,jumpToPresentBar,CTRL+K */
          .bar-2eAyLE,.jumpToPresentBar-1cEnH0,.input-3r5zZY {
          	background-color: var(--gray0) !important;
          }

          /* New Message Bar */
          .newMessagesBar-1hF-9G:before {
          	content: "";
          	position: absolute;
          	top: 0;
          	right: 0;
          	bottom: 0;
          	left: 0;
          	background: var(--gray0) !important;
          	border-radius:0 0 3px 3px;
          }

          /* New Messages Flag */
          .isUnread-3Lojb- {
          	border-color: var(--gray0) !important;
          }

          .unreadPill-3nEWYM {
          	background-color: var(--gray0) !important;
          }

          .unreadPillCapStroke-1nE1Q8 {
          	fill: var(--gray0) !important;
          	color: var(--gray0) !important;
          }

          .isUnread-3Lojb- .content-3spvdd {
          	color: var(--gray0) !important;
          }

          /* Server Modals */
          .root-g14mjS,
          .separator-2lLxgC {
          	background-color: var(--black2) !important;
          }

          .footer-31IekZ {
          	background-color: var(--black1) !important;
          }

          /* Boost Page */
          .perksModal-CLcR1c {
          	background-color: var(--black1) !important;
          }

          .tierMarkerBackground-G8FoN4 {
          	background-color: var(--black2) !important;
          }

          /* Emoji Popout */
          .popoutContainer-2wbmiM {
          	background-color: var(--black1) !important;
          }

          /* Presence Buttons */
          .lookFilled-yCfaCM.colorGrey-2iAG-B,
          .lookFilled-yCfaCM.colorPrimary-2AuQVo {
          	background-color: var(--black3) !important;
          }

          /* Primary Card */
          .cardPrimary-3qRT__ {
          	background-color: var(--black1) !important;
          }

          /* Payment Page Boxes */
          .paymentPane-ut5qKZ,
          .paginator-1eqD2g,
          .payment-2bOh4k,
          .codeRedemptionRedirect-3SBiCp {
          	background-color: var(--black1) !important;
          }

          .bottomDivider-ZmTm-j {
          	border-bottom-color: var(--black2) !important;
          }

          /* Spotify Invite */
          .invite-3uuHYQ {
          	background-color: var(--black1) !important;
          }

          /* Edit Attachment */
          .footer-VCsJQY {
          	background-color: var(--black1) !important;
          }

          /* Spoilers */
          .spoilerText-27bIiA.hidden-3B-Rum,
          .inlineContent-2YnoDy {
          	background-color: var(--black3) !important;
          }

          /* Stream Preview */
          .streamPreview-I7itZ6 {
          	background-color: var(--black2) !important;
          }

          /* Selection */
          ::-moz-selection {
          	color: var(--white) !important;
          	background: var(--black4) !important;
          }

          ::selection {
          	color: var(--white) !important;
          	background: var(--black4) !important;
          }

          /* Delete Message Confirmation */
          .message-G6O-Wv {
          	background-color: var(--black2) !important;
          	box-shadow: 0 0 0 1px hsla(var(--black3_hsl), 0.6), 0 2px 10px 0 hsla(var(--black3_hsl), 0.1) !important;
          }

          /* Command Option */
          .pill-1HLSrc,
          .optionKey-1tfFt_ {
          	background-color: var(--black2) !important;
          }

          /* Volume Slider */
          .tooltipContent-Nejnvh {
          	background-color: var(--black2) !important;
          }

          .grabber-2GQyvM {
          	background-color: var(--white) !important;
          }

          .bar-1Bhnl9 {
          	background-color: var(--gray0) !important;
          }

          .tooltipPointer-3L49xb {
          	border-top-color: var(--black2) !important;
          }

          /* Call Page */
          .tile-2TcwiO {
          	background-color: var(--black0) !important;
          }

          .button-3Vyz67 {
          	background-color: var(--black2) !important;
          }

          .buttonColor-28DXIe,
          .colorable-3rVGna.primaryDark-2UJt1G {
          	background-color: var(--black2) !important;
          }

          .emptyPreview-1SMLD4 {
          	background: var(--black0) !important;
          }

          /* Reactors List */
          .scroller-2GkvCq {
          	background: var(--black1) !important;
          }

          .reactionDefault-1Sjj1f:hover,
          .reactionSelected-1aMb2K {
          	background-color: var(--black2) !important;
          }

          .reactors-1VXca7 {
          	background-color: var(--black2) !important;
          }
  '';
}

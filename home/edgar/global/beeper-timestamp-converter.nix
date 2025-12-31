{pkgs, ...}: let
  # I sometimes paste messages from Beeper into my notes, and the timestamps are in
  # a format like: [12/31/2023, 11:59:59 AM] Message but I want [2023-12-31 11:59]
  # Also converts timestamps from Element: Fri, Jun 13, 2025, 22:39:16 into [2025-06-13 22:39]
  beeper-timestamp-converter =
    pkgs.writers.writePython3Bin "beeper-timestamp-converter"
    {
      libraries = [pkgs.python3Packages.python-dateutil];
      flakeIgnore = ["E501"]; # line too long
    } ''
      import sys
      from dateutil import parser
      import re

      if len(sys.argv) != 2:
          print("Usage: fix-dates <filename>")
          sys.exit(1)

      file = sys.argv[1]

      with open(file, "r") as f:
          text = f.read()


      def repl(match):
          original = match.group(0)
          date_str = original.strip("[]")
          dt = parser.parse(date_str)
          return f"[{dt.strftime('%Y-%m-%d %H:%M')}]"


      # Beeper format: [12/31/2023, 11:59:59 AM]
      beeper_pattern = r"\[\d{1,2}/\d{1,2}/\d{4}, \d{1,2}:\d{2}:\d{2} (AM|PM)\]"

      # Element format: [Fri, Jun 13, 2025, 22:39:16]
      element_pattern = r"[A-Za-z]{3}, [A-Za-z]{3} \d{1,2}, \d{4}, \d{2}:\d{2}:\d{2}"

      text = re.sub(beeper_pattern, repl, text)
      text = re.sub(element_pattern, repl, text)

      with open(file, "w") as f:
          f.write(text)
    '';
in {
  home.packages = [
    beeper-timestamp-converter
  ];
}

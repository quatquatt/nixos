{ pkgs, lib, ... }:
let
  kitterhouse = pkgs.writeShellApplication
  {
    name = "kitterhouse";
    text = 
    ''
      id="$KITTY_WINDOW_ID"
      file_text=$(kitty @ get-text -m "id:$id")

      status_line=$(echo "$file_text" | rg -Po '(?:NOR|INS|SEL)\s+[\x{2800}-\x{28FF}]*\s+\S*\s[^│]* \d+:*.*')

      file_name=$(echo "$status_line" | awk '{print $2}')
      echo "$file_name"

    '';
  };
in
{
  environment.systemPackages = lib.singleton kitterhouse;  
}


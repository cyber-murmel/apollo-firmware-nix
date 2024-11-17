let
  fetchGitHubArchive = { owner, repo, rev }:
    builtins.fetchTarball {
      url = "https://github.com/${owner}/${repo}/archive/${rev}.tar.gz";
    };

in
{
  nixpkgs = fetchGitHubArchive {
    owner = "NixOS";
    repo = "nixpkgs";
    rev = "79baff8812a0d68e24a836df0a364c678089e2c7";
  };

  apollo = fetchGitHubArchive {
    owner = "cyber-murmel";
    repo = "apollo";
    rev = "ca117e66dca9c3828eab817aac5490950f53e2b7";
  };

  tinyusb = fetchGitHubArchive {
    owner = "cyber-murmel";
    repo = "tinyusb";
    rev = "55593100ff3641b4b1cd5f148f8295433a524075";
  };

  microchip_driver = fetchGitHubArchive {
    owner = "hathach";
    repo = "microchip_driver";
    rev = "9e8b37e307d8404033bb881623a113931e1edf27";
  };

  uf2 = fetchGitHubArchive {
    owner = "microsoft";
    repo = "uf2";
    rev = "19615407727073e36d81bf239c52108ba92e7660";
  };

}

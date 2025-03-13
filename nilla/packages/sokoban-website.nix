{
  config.packages.sokoban-website = {
    systems = [ "x86_64-linux" ];

    package = { fetchFromGitHub }:
      fetchFromGitHub {
        owner = "jakehamilton";
        repo = "sokoban.app";
        rev = "db66504d7283606f147a31e37772fbe6e95afdfb";
        sha256 = "0ibfvfmimb9qcgfvyi62fc14krglzkfl3vksbzsrlrwr1sxzfqpd";
      };
  };
}

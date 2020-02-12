let
  pkgs = import <nixpkgs> {};
  dyn-gem = { name, fullName, version, platform, remotes }:
    pkgs.runCommand "dyn-gem-${name}-${version}" {} ''
      ${pkgs.ruby}/bin/ruby ${/Users/burke/src/github.com/Shopify/bundix/bin/dyn-gem}         "${name}" "${fullName}" "${version}" "${platform}" "${builtins.concatStringsSep "\" \"" remotes}" > $out
    '';
in {
  addressable = (let dyn = (import (dyn-gem {
    fullName = "addressable-2.7.0";
    name = "addressable";
    platform = "ruby";
    remotes = ["https://packages.shopify.io/shopify/gems/" "https://rubygems.org/"];
    version = "2.7.0";
  })); in {
    dependencies = ["public_suffix"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = [dyn.remote];
      sha256 = dyn.sha256;
      type = "gem";
    };
    version = dyn.version;
  });
  ansi = (let dyn = (import (dyn-gem {
    fullName = "ansi-1.5.0";
    name = "ansi";
    platform = "ruby";
    remotes = ["https://packages.shopify.io/shopify/gems/" "https://rubygems.org/"];
    version = "1.5.0";
  })); in {
    dependencies = [];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = [dyn.remote];
      sha256 = dyn.sha256;
      type = "gem";
    };
    version = dyn.version;
  });
  anyway_config = (let dyn = (import (dyn-gem {
    fullName = "anyway_config-1.4.4";
    name = "anyway_config";
    platform = "ruby";
    remotes = ["https://packages.shopify.io/shopify/gems/" "https://rubygems.org/"];
    version = "1.4.4";
  })); in {
    dependencies = [];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = [dyn.remote];
      sha256 = dyn.sha256;
      type = "gem";
    };
    version = dyn.version;
  });
  ast = (let dyn = (import (dyn-gem {
    fullName = "ast-2.4.0";
    name = "ast";
    platform = "ruby";
    remotes = ["https://packages.shopify.io/shopify/gems/" "https://rubygems.org/"];
    version = "2.4.0";
  })); in {
    dependencies = [];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = [dyn.remote];
      sha256 = dyn.sha256;
      type = "gem";
    };
    version = dyn.version;
  });
  builder = (let dyn = (import (dyn-gem {
    fullName = "builder-3.2.3";
    name = "builder";
    platform = "ruby";
    remotes = ["https://packages.shopify.io/shopify/gems/" "https://rubygems.org/"];
    version = "3.2.3";
  })); in {
    dependencies = [];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = [dyn.remote];
      sha256 = dyn.sha256;
      type = "gem";
    };
    version = dyn.version;
  });
  byebug = (let dyn = (import (dyn-gem {
    fullName = "byebug-11.1.1";
    name = "byebug";
    platform = "ruby";
    remotes = ["https://packages.shopify.io/shopify/gems/" "https://rubygems.org/"];
    version = "11.1.1";
  })); in {
    dependencies = [];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = [dyn.remote];
      sha256 = dyn.sha256;
      type = "gem";
    };
    version = dyn.version;
  });
  coderay = (let dyn = (import (dyn-gem {
    fullName = "coderay-1.1.2";
    name = "coderay";
    platform = "ruby";
    remotes = ["https://packages.shopify.io/shopify/gems/" "https://rubygems.org/"];
    version = "1.1.2";
  })); in {
    dependencies = [];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = [dyn.remote];
      sha256 = dyn.sha256;
      type = "gem";
    };
    version = dyn.version;
  });
  crack = (let dyn = (import (dyn-gem {
    fullName = "crack-0.4.3";
    name = "crack";
    platform = "ruby";
    remotes = ["https://packages.shopify.io/shopify/gems/" "https://rubygems.org/"];
    version = "0.4.3";
  })); in {
    dependencies = ["safe_yaml"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = [dyn.remote];
      sha256 = dyn.sha256;
      type = "gem";
    };
    version = dyn.version;
  });
  declarative = (let dyn = (import (dyn-gem {
    fullName = "declarative-0.0.10";
    name = "declarative";
    platform = "ruby";
    remotes = ["https://packages.shopify.io/shopify/gems/" "https://rubygems.org/"];
    version = "0.0.10";
  })); in {
    dependencies = [];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = [dyn.remote];
      sha256 = dyn.sha256;
      type = "gem";
    };
    version = dyn.version;
  });
  declarative-option = (let dyn = (import (dyn-gem {
    fullName = "declarative-option-0.1.0";
    name = "declarative-option";
    platform = "ruby";
    remotes = ["https://packages.shopify.io/shopify/gems/" "https://rubygems.org/"];
    version = "0.1.0";
  })); in {
    dependencies = [];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = [dyn.remote];
      sha256 = dyn.sha256;
      type = "gem";
    };
    version = dyn.version;
  });
  digest-crc = (let dyn = (import (dyn-gem {
    fullName = "digest-crc-0.4.1";
    name = "digest-crc";
    platform = "ruby";
    remotes = ["https://packages.shopify.io/shopify/gems/" "https://rubygems.org/"];
    version = "0.4.1";
  })); in {
    dependencies = [];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = [dyn.remote];
      sha256 = dyn.sha256;
      type = "gem";
    };
    version = dyn.version;
  });
  faraday = (let dyn = (import (dyn-gem {
    fullName = "faraday-0.17.3";
    name = "faraday";
    platform = "ruby";
    remotes = ["https://packages.shopify.io/shopify/gems/" "https://rubygems.org/"];
    version = "0.17.3";
  })); in {
    dependencies = ["multipart-post"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = [dyn.remote];
      sha256 = dyn.sha256;
      type = "gem";
    };
    version = dyn.version;
  });
  google-api-client = (let dyn = (import (dyn-gem {
    fullName = "google-api-client-0.36.4";
    name = "google-api-client";
    platform = "ruby";
    remotes = ["https://packages.shopify.io/shopify/gems/" "https://rubygems.org/"];
    version = "0.36.4";
  })); in {
    dependencies = ["addressable" "googleauth" "httpclient" "mini_mime" "representable" "retriable" "signet"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = [dyn.remote];
      sha256 = dyn.sha256;
      type = "gem";
    };
    version = dyn.version;
  });
  google-cloud-core = (let dyn = (import (dyn-gem {
    fullName = "google-cloud-core-1.5.0";
    name = "google-cloud-core";
    platform = "ruby";
    remotes = ["https://packages.shopify.io/shopify/gems/" "https://rubygems.org/"];
    version = "1.5.0";
  })); in {
    dependencies = ["google-cloud-env" "google-cloud-errors"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = [dyn.remote];
      sha256 = dyn.sha256;
      type = "gem";
    };
    version = dyn.version;
  });
  google-cloud-env = (let dyn = (import (dyn-gem {
    fullName = "google-cloud-env-1.3.0";
    name = "google-cloud-env";
    platform = "ruby";
    remotes = ["https://packages.shopify.io/shopify/gems/" "https://rubygems.org/"];
    version = "1.3.0";
  })); in {
    dependencies = ["faraday"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = [dyn.remote];
      sha256 = dyn.sha256;
      type = "gem";
    };
    version = dyn.version;
  });
  google-cloud-errors = (let dyn = (import (dyn-gem {
    fullName = "google-cloud-errors-1.0.0";
    name = "google-cloud-errors";
    platform = "ruby";
    remotes = ["https://packages.shopify.io/shopify/gems/" "https://rubygems.org/"];
    version = "1.0.0";
  })); in {
    dependencies = [];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = [dyn.remote];
      sha256 = dyn.sha256;
      type = "gem";
    };
    version = dyn.version;
  });
  google-cloud-storage = (let dyn = (import (dyn-gem {
    fullName = "google-cloud-storage-1.25.1";
    name = "google-cloud-storage";
    platform = "ruby";
    remotes = ["https://packages.shopify.io/shopify/gems/" "https://rubygems.org/"];
    version = "1.25.1";
  })); in {
    dependencies = ["addressable" "digest-crc" "google-api-client" "google-cloud-core" "googleauth" "mini_mime"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = [dyn.remote];
      sha256 = dyn.sha256;
      type = "gem";
    };
    version = dyn.version;
  });
  googleauth = (let dyn = (import (dyn-gem {
    fullName = "googleauth-0.10.0";
    name = "googleauth";
    platform = "ruby";
    remotes = ["https://packages.shopify.io/shopify/gems/" "https://rubygems.org/"];
    version = "0.10.0";
  })); in {
    dependencies = ["faraday" "jwt" "memoist" "multi_json" "os" "signet"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = [dyn.remote];
      sha256 = dyn.sha256;
      type = "gem";
    };
    version = dyn.version;
  });
  hashdiff = (let dyn = (import (dyn-gem {
    fullName = "hashdiff-1.0.0";
    name = "hashdiff";
    platform = "ruby";
    remotes = ["https://packages.shopify.io/shopify/gems/" "https://rubygems.org/"];
    version = "1.0.0";
  })); in {
    dependencies = [];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = [dyn.remote];
      sha256 = dyn.sha256;
      type = "gem";
    };
    version = dyn.version;
  });
  httpclient = (let dyn = (import (dyn-gem {
    fullName = "httpclient-2.8.3";
    name = "httpclient";
    platform = "ruby";
    remotes = ["https://packages.shopify.io/shopify/gems/" "https://rubygems.org/"];
    version = "2.8.3";
  })); in {
    dependencies = [];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = [dyn.remote];
      sha256 = dyn.sha256;
      type = "gem";
    };
    version = dyn.version;
  });
  jaro_winkler = (let dyn = (import (dyn-gem {
    fullName = "jaro_winkler-1.5.4";
    name = "jaro_winkler";
    platform = "ruby";
    remotes = ["https://packages.shopify.io/shopify/gems/" "https://rubygems.org/"];
    version = "1.5.4";
  })); in {
    dependencies = [];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = [dyn.remote];
      sha256 = dyn.sha256;
      type = "gem";
    };
    version = dyn.version;
  });
  jwt = (let dyn = (import (dyn-gem {
    fullName = "jwt-2.2.1";
    name = "jwt";
    platform = "ruby";
    remotes = ["https://packages.shopify.io/shopify/gems/" "https://rubygems.org/"];
    version = "2.2.1";
  })); in {
    dependencies = [];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = [dyn.remote];
      sha256 = dyn.sha256;
      type = "gem";
    };
    version = dyn.version;
  });
  litecable = (let dyn = (import (dyn-gem {
    fullName = "litecable-0.6.0";
    name = "litecable";
    platform = "ruby";
    remotes = ["https://packages.shopify.io/shopify/gems/" "https://rubygems.org/"];
    version = "0.6.0";
  })); in {
    dependencies = ["anyway_config"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = [dyn.remote];
      sha256 = dyn.sha256;
      type = "gem";
    };
    version = dyn.version;
  });
  memoist = (let dyn = (import (dyn-gem {
    fullName = "memoist-0.16.2";
    name = "memoist";
    platform = "ruby";
    remotes = ["https://packages.shopify.io/shopify/gems/" "https://rubygems.org/"];
    version = "0.16.2";
  })); in {
    dependencies = [];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = [dyn.remote];
      sha256 = dyn.sha256;
      type = "gem";
    };
    version = dyn.version;
  });
  method_source = (let dyn = (import (dyn-gem {
    fullName = "method_source-0.9.2";
    name = "method_source";
    platform = "ruby";
    remotes = ["https://packages.shopify.io/shopify/gems/" "https://rubygems.org/"];
    version = "0.9.2";
  })); in {
    dependencies = [];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = [dyn.remote];
      sha256 = dyn.sha256;
      type = "gem";
    };
    version = dyn.version;
  });
  mini_mime = (let dyn = (import (dyn-gem {
    fullName = "mini_mime-1.0.2";
    name = "mini_mime";
    platform = "ruby";
    remotes = ["https://packages.shopify.io/shopify/gems/" "https://rubygems.org/"];
    version = "1.0.2";
  })); in {
    dependencies = [];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = [dyn.remote];
      sha256 = dyn.sha256;
      type = "gem";
    };
    version = dyn.version;
  });
  minitest = (let dyn = (import (dyn-gem {
    fullName = "minitest-5.14.0";
    name = "minitest";
    platform = "ruby";
    remotes = ["https://packages.shopify.io/shopify/gems/" "https://rubygems.org/"];
    version = "5.14.0";
  })); in {
    dependencies = [];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = [dyn.remote];
      sha256 = dyn.sha256;
      type = "gem";
    };
    version = dyn.version;
  });
  minitest-reporters = (let dyn = (import (dyn-gem {
    fullName = "minitest-reporters-1.4.2";
    name = "minitest-reporters";
    platform = "ruby";
    remotes = ["https://packages.shopify.io/shopify/gems/" "https://rubygems.org/"];
    version = "1.4.2";
  })); in {
    dependencies = ["ansi" "builder" "minitest" "ruby-progressbar"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = [dyn.remote];
      sha256 = dyn.sha256;
      type = "gem";
    };
    version = dyn.version;
  });
  mocha = (let dyn = (import (dyn-gem {
    fullName = "mocha-1.11.2";
    name = "mocha";
    platform = "ruby";
    remotes = ["https://packages.shopify.io/shopify/gems/" "https://rubygems.org/"];
    version = "1.11.2";
  })); in {
    dependencies = [];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = [dyn.remote];
      sha256 = dyn.sha256;
      type = "gem";
    };
    version = dyn.version;
  });
  multi_json = (let dyn = (import (dyn-gem {
    fullName = "multi_json-1.14.1";
    name = "multi_json";
    platform = "ruby";
    remotes = ["https://packages.shopify.io/shopify/gems/" "https://rubygems.org/"];
    version = "1.14.1";
  })); in {
    dependencies = [];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = [dyn.remote];
      sha256 = dyn.sha256;
      type = "gem";
    };
    version = dyn.version;
  });
  multipart-post = (let dyn = (import (dyn-gem {
    fullName = "multipart-post-2.1.1";
    name = "multipart-post";
    platform = "ruby";
    remotes = ["https://packages.shopify.io/shopify/gems/" "https://rubygems.org/"];
    version = "2.1.1";
  })); in {
    dependencies = [];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = [dyn.remote];
      sha256 = dyn.sha256;
      type = "gem";
    };
    version = dyn.version;
  });
  nio4r = (let dyn = (import (dyn-gem {
    fullName = "nio4r-2.5.2";
    name = "nio4r";
    platform = "ruby";
    remotes = ["https://packages.shopify.io/shopify/gems/" "https://rubygems.org/"];
    version = "2.5.2";
  })); in {
    dependencies = [];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = [dyn.remote];
      sha256 = dyn.sha256;
      type = "gem";
    };
    version = dyn.version;
  });
  os = (let dyn = (import (dyn-gem {
    fullName = "os-1.0.1";
    name = "os";
    platform = "ruby";
    remotes = ["https://packages.shopify.io/shopify/gems/" "https://rubygems.org/"];
    version = "1.0.1";
  })); in {
    dependencies = [];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = [dyn.remote];
      sha256 = dyn.sha256;
      type = "gem";
    };
    version = dyn.version;
  });
  parallel = (let dyn = (import (dyn-gem {
    fullName = "parallel-1.19.1";
    name = "parallel";
    platform = "ruby";
    remotes = ["https://packages.shopify.io/shopify/gems/" "https://rubygems.org/"];
    version = "1.19.1";
  })); in {
    dependencies = [];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = [dyn.remote];
      sha256 = dyn.sha256;
      type = "gem";
    };
    version = dyn.version;
  });
  parser = (let dyn = (import (dyn-gem {
    fullName = "parser-2.7.0.2";
    name = "parser";
    platform = "ruby";
    remotes = ["https://packages.shopify.io/shopify/gems/" "https://rubygems.org/"];
    version = "2.7.0.2";
  })); in {
    dependencies = ["ast"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = [dyn.remote];
      sha256 = dyn.sha256;
      type = "gem";
    };
    version = dyn.version;
  });
  pry = (let dyn = (import (dyn-gem {
    fullName = "pry-0.12.2";
    name = "pry";
    platform = "ruby";
    remotes = ["https://packages.shopify.io/shopify/gems/" "https://rubygems.org/"];
    version = "0.12.2";
  })); in {
    dependencies = ["coderay" "method_source"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = [dyn.remote];
      sha256 = dyn.sha256;
      type = "gem";
    };
    version = dyn.version;
  });
  pry-byebug = (let dyn = (import (dyn-gem {
    fullName = "pry-byebug-3.8.0";
    name = "pry-byebug";
    platform = "ruby";
    remotes = ["https://packages.shopify.io/shopify/gems/" "https://rubygems.org/"];
    version = "3.8.0";
  })); in {
    dependencies = ["byebug" "pry"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = [dyn.remote];
      sha256 = dyn.sha256;
      type = "gem";
    };
    version = dyn.version;
  });
  public_suffix = (let dyn = (import (dyn-gem {
    fullName = "public_suffix-4.0.3";
    name = "public_suffix";
    platform = "ruby";
    remotes = ["https://packages.shopify.io/shopify/gems/" "https://rubygems.org/"];
    version = "4.0.3";
  })); in {
    dependencies = [];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = [dyn.remote];
      sha256 = dyn.sha256;
      type = "gem";
    };
    version = dyn.version;
  });
  puma = (let dyn = (import (dyn-gem {
    fullName = "puma-4.3.1";
    name = "puma";
    platform = "ruby";
    remotes = ["https://packages.shopify.io/shopify/gems/" "https://rubygems.org/"];
    version = "4.3.1";
  })); in {
    dependencies = ["nio4r"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = [dyn.remote];
      sha256 = dyn.sha256;
      type = "gem";
    };
    version = dyn.version;
  });
  rainbow = (let dyn = (import (dyn-gem {
    fullName = "rainbow-3.0.0";
    name = "rainbow";
    platform = "ruby";
    remotes = ["https://packages.shopify.io/shopify/gems/" "https://rubygems.org/"];
    version = "3.0.0";
  })); in {
    dependencies = [];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = [dyn.remote];
      sha256 = dyn.sha256;
      type = "gem";
    };
    version = dyn.version;
  });
  rake = (let dyn = (import (dyn-gem {
    fullName = "rake-13.0.1";
    name = "rake";
    platform = "ruby";
    remotes = ["https://packages.shopify.io/shopify/gems/" "https://rubygems.org/"];
    version = "13.0.1";
  })); in {
    dependencies = [];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = [dyn.remote];
      sha256 = dyn.sha256;
      type = "gem";
    };
    version = dyn.version;
  });
  redcarpet = (let dyn = (import (dyn-gem {
    fullName = "redcarpet-3.5.0";
    name = "redcarpet";
    platform = "ruby";
    remotes = ["https://packages.shopify.io/shopify/gems/" "https://rubygems.org/"];
    version = "3.5.0";
  })); in {
    dependencies = [];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = [dyn.remote];
      sha256 = dyn.sha256;
      type = "gem";
    };
    version = dyn.version;
  });
  representable = (let dyn = (import (dyn-gem {
    fullName = "representable-3.0.4";
    name = "representable";
    platform = "ruby";
    remotes = ["https://packages.shopify.io/shopify/gems/" "https://rubygems.org/"];
    version = "3.0.4";
  })); in {
    dependencies = ["declarative" "declarative-option" "uber"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = [dyn.remote];
      sha256 = dyn.sha256;
      type = "gem";
    };
    version = dyn.version;
  });
  retriable = (let dyn = (import (dyn-gem {
    fullName = "retriable-3.1.2";
    name = "retriable";
    platform = "ruby";
    remotes = ["https://packages.shopify.io/shopify/gems/" "https://rubygems.org/"];
    version = "3.1.2";
  })); in {
    dependencies = [];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = [dyn.remote];
      sha256 = dyn.sha256;
      type = "gem";
    };
    version = dyn.version;
  });
  rubocop = (let dyn = (import (dyn-gem {
    fullName = "rubocop-0.79.0";
    name = "rubocop";
    platform = "ruby";
    remotes = ["https://packages.shopify.io/shopify/gems/" "https://rubygems.org/"];
    version = "0.79.0";
  })); in {
    dependencies = ["jaro_winkler" "parallel" "parser" "rainbow" "ruby-progressbar" "unicode-display_width"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = [dyn.remote];
      sha256 = dyn.sha256;
      type = "gem";
    };
    version = dyn.version;
  });
  rubocop-performance = (let dyn = (import (dyn-gem {
    fullName = "rubocop-performance-1.5.2";
    name = "rubocop-performance";
    platform = "ruby";
    remotes = ["https://packages.shopify.io/shopify/gems/" "https://rubygems.org/"];
    version = "1.5.2";
  })); in {
    dependencies = ["rubocop"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = [dyn.remote];
      sha256 = dyn.sha256;
      type = "gem";
    };
    version = dyn.version;
  });
  rubrowser = (let dyn = (import (dyn-gem {
    fullName = "rubrowser-2.7.1";
    name = "rubrowser";
    platform = "ruby";
    remotes = ["https://packages.shopify.io/shopify/gems/" "https://rubygems.org/"];
    version = "2.7.1";
  })); in {
    dependencies = ["litecable" "parser" "puma" "websocket"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = [dyn.remote];
      sha256 = dyn.sha256;
      type = "gem";
    };
    version = dyn.version;
  });
  ruby-progressbar = (let dyn = (import (dyn-gem {
    fullName = "ruby-progressbar-1.10.1";
    name = "ruby-progressbar";
    platform = "ruby";
    remotes = ["https://packages.shopify.io/shopify/gems/" "https://rubygems.org/"];
    version = "1.10.1";
  })); in {
    dependencies = [];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = [dyn.remote];
      sha256 = dyn.sha256;
      type = "gem";
    };
    version = dyn.version;
  });
  safe_yaml = (let dyn = (import (dyn-gem {
    fullName = "safe_yaml-1.0.5";
    name = "safe_yaml";
    platform = "ruby";
    remotes = ["https://packages.shopify.io/shopify/gems/" "https://rubygems.org/"];
    version = "1.0.5";
  })); in {
    dependencies = [];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = [dyn.remote];
      sha256 = dyn.sha256;
      type = "gem";
    };
    version = dyn.version;
  });
  session = (let dyn = (import (dyn-gem {
    fullName = "session-3.2.0";
    name = "session";
    platform = "ruby";
    remotes = ["https://packages.shopify.io/shopify/gems/" "https://rubygems.org/"];
    version = "3.2.0";
  })); in {
    dependencies = [];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = [dyn.remote];
      sha256 = dyn.sha256;
      type = "gem";
    };
    version = dyn.version;
  });
  shopify-cops = (let dyn = (import (dyn-gem {
    fullName = "shopify-cops-0.0.22";
    name = "shopify-cops";
    platform = "ruby";
    remotes = ["https://packages.shopify.io/shopify/gems/" "https://rubygems.org/"];
    version = "0.0.22";
  })); in {
    dependencies = ["rubocop"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = [dyn.remote];
      sha256 = dyn.sha256;
      type = "gem";
    };
    version = dyn.version;
  });
  signet = (let dyn = (import (dyn-gem {
    fullName = "signet-0.12.0";
    name = "signet";
    platform = "ruby";
    remotes = ["https://packages.shopify.io/shopify/gems/" "https://rubygems.org/"];
    version = "0.12.0";
  })); in {
    dependencies = ["addressable" "faraday" "jwt" "multi_json"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = [dyn.remote];
      sha256 = dyn.sha256;
      type = "gem";
    };
    version = dyn.version;
  });
  smart_todo = (let dyn = (import (dyn-gem {
    fullName = "smart_todo-1.2.0";
    name = "smart_todo";
    platform = "ruby";
    remotes = ["https://packages.shopify.io/shopify/gems/" "https://rubygems.org/"];
    version = "1.2.0";
  })); in {
    dependencies = [];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = [dyn.remote];
      sha256 = dyn.sha256;
      type = "gem";
    };
    version = dyn.version;
  });
  sorbet = (let dyn = (import (dyn-gem {
    fullName = "sorbet-0.5.5200";
    name = "sorbet";
    platform = "ruby";
    remotes = ["https://packages.shopify.io/shopify/gems/" "https://rubygems.org/"];
    version = "0.5.5200";
  })); in {
    dependencies = ["sorbet-static"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = [dyn.remote];
      sha256 = dyn.sha256;
      type = "gem";
    };
    version = dyn.version;
  });
  sorbet-static = (let dyn = (import (dyn-gem {
    fullName = "sorbet-static-0.5.5200-universal-darwin-14";
    name = "sorbet-static";
    platform = "universal-darwin-14";
    remotes = ["https://packages.shopify.io/shopify/gems/" "https://rubygems.org/"];
    version = "0.5.5200";
  })); in {
    dependencies = [];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = [dyn.remote];
      sha256 = dyn.sha256;
      type = "gem";
    };
    version = dyn.version;
  });
  timecop = (let dyn = (import (dyn-gem {
    fullName = "timecop-0.9.1";
    name = "timecop";
    platform = "ruby";
    remotes = ["https://packages.shopify.io/shopify/gems/" "https://rubygems.org/"];
    version = "0.9.1";
  })); in {
    dependencies = [];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = [dyn.remote];
      sha256 = dyn.sha256;
      type = "gem";
    };
    version = dyn.version;
  });
  uber = (let dyn = (import (dyn-gem {
    fullName = "uber-0.1.0";
    name = "uber";
    platform = "ruby";
    remotes = ["https://packages.shopify.io/shopify/gems/" "https://rubygems.org/"];
    version = "0.1.0";
  })); in {
    dependencies = [];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = [dyn.remote];
      sha256 = dyn.sha256;
      type = "gem";
    };
    version = dyn.version;
  });
  unicode-display_width = (let dyn = (import (dyn-gem {
    fullName = "unicode-display_width-1.6.0";
    name = "unicode-display_width";
    platform = "ruby";
    remotes = ["https://packages.shopify.io/shopify/gems/" "https://rubygems.org/"];
    version = "1.6.0";
  })); in {
    dependencies = [];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = [dyn.remote];
      sha256 = dyn.sha256;
      type = "gem";
    };
    version = dyn.version;
  });
  vcr = (let dyn = (import (dyn-gem {
    fullName = "vcr-5.1.0";
    name = "vcr";
    platform = "ruby";
    remotes = ["https://packages.shopify.io/shopify/gems/" "https://rubygems.org/"];
    version = "5.1.0";
  })); in {
    dependencies = [];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = [dyn.remote];
      sha256 = dyn.sha256;
      type = "gem";
    };
    version = dyn.version;
  });
  webmock = (let dyn = (import (dyn-gem {
    fullName = "webmock-3.8.1";
    name = "webmock";
    platform = "ruby";
    remotes = ["https://packages.shopify.io/shopify/gems/" "https://rubygems.org/"];
    version = "3.8.1";
  })); in {
    dependencies = ["addressable" "crack" "hashdiff"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = [dyn.remote];
      sha256 = dyn.sha256;
      type = "gem";
    };
    version = dyn.version;
  });
  websocket = (let dyn = (import (dyn-gem {
    fullName = "websocket-1.2.8";
    name = "websocket";
    platform = "ruby";
    remotes = ["https://packages.shopify.io/shopify/gems/" "https://rubygems.org/"];
    version = "1.2.8";
  })); in {
    dependencies = [];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = [dyn.remote];
      sha256 = dyn.sha256;
      type = "gem";
    };
    version = dyn.version;
  });
  yard = (let dyn = (import (dyn-gem {
    fullName = "yard-0.9.24";
    name = "yard";
    platform = "ruby";
    remotes = ["https://packages.shopify.io/shopify/gems/" "https://rubygems.org/"];
    version = "0.9.24";
  })); in {
    dependencies = [];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = [dyn.remote];
      sha256 = dyn.sha256;
      type = "gem";
    };
    version = dyn.version;
  });
  yard-coderay = (let dyn = (import (dyn-gem {
    fullName = "yard-coderay-0.1.0";
    name = "yard-coderay";
    platform = "ruby";
    remotes = ["https://packages.shopify.io/shopify/gems/" "https://rubygems.org/"];
    version = "0.1.0";
  })); in {
    dependencies = ["coderay" "yard"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = [dyn.remote];
      sha256 = dyn.sha256;
      type = "gem";
    };
    version = dyn.version;
  });
}

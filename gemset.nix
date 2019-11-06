{
  bundix = {
    dependencies = [];
    groups = ["default"];
    platforms = [];
    source = {
      path = "true";
      type = "path";
    };
    version = "2.5.0";
  };
  minitest = {
    dependencies = [];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0zjm24aiz42i9n37mcw8lydd7n0y7wfk27by06jx77ypcld3qvkw";
      type = "gem";
    };
    version = "5.12.2";
  };
  sorbet = {
    dependencies = ["sorbet-static"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1rsp5sshssw733il7skyb87wbjb8yg94s5zw81ypgs9dq0gqqsil";
      type = "gem";
    };
    version = "0.4.4901";
  };
  sorbet-static = {
    dependencies = [];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0ii9a3r1m08c3k87a2spk7pfhfq450xd0mbgcr0nknjd8jf42wwb";
      type = "gem";
    };
    version = "0.4.4901-universal-darwin-19";
  };
}

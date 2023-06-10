{ lib, python3 }:

python3.pkgs.buildPythonApplication rec {
  version = "0.5.0b3.dev71";
  pname = "pyload-ng";
  format = "pyproject";

  src = python3.pkgs.fetchPypi {
    inherit pname version;
    hash = "sha256-66hE5uFJZoxWgMTbVNSb2a8PeEWRD9gWAQeIjBV1S8k=";
  };

  postPatch = ''
    # relax version bounds
    sed -i 's/\([A-z0-9]*\)~=.*$/\1/' setup.cfg
    # Flask-Session2 is required for Flask 2.3
    # https://github.com/pyload/pyload/commit/d0d378ff46195574a4251a3f828ff94254f9b4f6
    # current: flask.version = "2.2.2"
    # TODO assert flask.version < "2.3"
    sed -i '/Flask-Session2/d' setup.cfg
  '';

  propagatedBuildInputs = with python3.pkgs; [
    setuptools
    cheroot
    pycurl
    filetype
    flask
    semver
    bitmath
    cryptography
    certifi
    js2py
    flask-themes2
    flask-session
    flask-compress
    flask-babel
    flask-caching
  ];

  passthru.optional-dependencies = {
    plugins = with python3.pkgs; [
      beautifulsoup4 # for some plugins
      slixmpp # XMPP plugin
      send2trash # send some files to trash instead of deleting them
      pillow # for some CAPTCHA plugin
      colorlog # colorful console logging
    ];
  };

  meta = with lib; {
    description = "Free and open-source download manager with support for 1-click-hosting sites";
    homepage = "https://github.com/pyload/pyload";
    license = licenses.agpl3Plus;
    maintainers = with maintainers; [ ruby0b ];
  };
}

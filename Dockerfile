# ZAP with JavaFX (OpenJFX) so the "Browser View" add-on's
# "Render HTML" response view works inside Webswing.
FROM ghcr.io/zaproxy/zaproxy:stable

USER root

# Debian 12 ships OpenJFX 17, which matches the image's OpenJDK 17
RUN apt-get update \
    && apt-get install -y --no-install-recommends openjfx \
    && rm -rf /var/lib/apt/lists/*

# Webswing launches the ZAP app in its own JVM using launcherConfig.
# Add vmArgs so that JVM gets JavaFX on its module path.
RUN sed -i 's#"javaFx" : true,#"javaFx" : true,\
      "vmArgs" : [ "--module-path", "/usr/share/openjfx/lib", "--add-modules", "javafx.controls,javafx.web,javafx.swing,javafx.fxml" ],#' \
    /zap/webswing/webswing.config \
    && grep -A1 '"javaFx"' /zap/webswing/webswing.config

USER zap

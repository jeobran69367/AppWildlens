# Utilisez l'image de base officielle de Flutter
FROM ubuntu:20.04

# Installez les dépendances nécessaires
RUN apt-get update && apt-get install -y \
  git \
  curl \
  unzip \
  xz-utils \
  zip \
  libglu1-mesa \
  && rm -rf /var/lib/apt/lists/*

# Téléchargez et installez le SDK Flutter
RUN git clone https://github.com/flutter/flutter.git /usr/local/flutter
ENV PATH="/usr/local/flutter/bin:${PATH}"

# Mettez à jour le PATH pour inclure le répertoire Flutter
ENV PATH="K:/SDK/flutter/bin"
ENV ANDROID_HOME = "C:/Users/jeobr/AppData/Local/Android/Sdk"


# Copiez les fichiers du projet dans le conteneur Docker
COPY . /app
WORKDIR /app

# Exécutez les commandes Flutter pour récupérer les dépendances et construire l'application
# flutter pub get
# flutter build apk --release

# Configurez un serveur Web pour servir les fichiers de l'application (optionnel)
# FROM nginx:latest
# COPY build/web /usr/share/nginx/html
# EXPOSE 80

# La commande par défaut pour exécuter l'application (optionnel)
# CMD ["nginx", "-g", "daemon off;"]

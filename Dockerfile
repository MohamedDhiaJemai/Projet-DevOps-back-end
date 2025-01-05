# Utiliser une image de base officielle Node.js
FROM node:16

# Créer et définir le répertoire de travail pour l'application
WORKDIR /usr/src/app

# Copier le fichier package.json et package-lock.json dans le conteneur
COPY package*.json ./

# Installer les dépendances de l'application
RUN npm install

# Copier tout le code source de l'application dans le conteneur
COPY . .

# Exposer le port sur lequel l'application backend écoute
EXPOSE 8080

# Lancer l'application en utilisant la commande node
CMD ["node", "server.js"]


# Guide de mise en ligne — St Tropez Security

## 1. À remplacer avant publication (placeholders)

| Quoi | Où | Valeur actuelle |
|---|---|---|
| Numéro de téléphone | toutes les pages | `+33 7 53 46 39 08` |
| Numéro WhatsApp | liens `wa.me/33753463908` sur toutes les pages | `33753463908` |
| Email | toutes les pages | `contact@sttropezsecurity.com` |
| N° CNAPS | pieds de page + mentions légales | `[à compléter]` |
| Infos société (SIREN, adresse, gérant…) | `mentions-legales.html` | `[à compléter]` |
| Nom de domaine | balises `canonical` et `og:url` de chaque page | `sttropezsecurity.com` |

Astuce : recherche/remplace global sur `33753463908` et `contact@sttropezsecurity.com`.

## 2. Le formulaire

Le formulaire (EN sur `index.html`, FR sur `accueil.html`) ouvre directement **WhatsApp** avec le message prérempli — aucune configuration nécessaire, aucune donnée stockée. Il suffit de remplacer le numéro `33753463908` partout par ton vrai numéro WhatsApp Business.

## 3. Mise en ligne

Le dossier `public/` correspond à la structure **Firebase Hosting** :

```bash
npm install -g firebase-tools
firebase login
firebase init hosting   # si pas déjà fait — choisir "public" comme dossier
firebase deploy
```

Alternative sans compte Google : **Netlify** (glisser-déposer le dossier `public/` sur https://app.netlify.com/drop).

## 4. Nom de domaine

- Acheter le domaine (ex. `sttropezsecurity.com`) chez OVH, Gandi ou Ionos (~10 €/an)
- Le connecter dans Firebase Hosting → « Custom domain » (ou Netlify → Domain settings)
- Mettre à jour les balises `canonical` / `og:url` avec le vrai domaine

## 5. Être trouvé sur Google (essentiel pour vous)

1. **Google Business Profile** (gratuit, priorité n°1) : créer la fiche « St Tropez Security » à Saint-Tropez — c'est ce qui apparaît sur Google Maps et dans « sécurité saint-tropez »
2. **Google Search Console** : déclarer le site pour suivre l'indexation
3. Demander à ton associé (transport privé) un **lien depuis son site** vers le tien — un lien local pertinent vaut de l'or en SEO
4. Récolter des **avis Google** dès les premiers clients

## 6. Photos

Le site utilise pour l'instant des photos **Unsplash** (licence gratuite, usage commercial autorisé, sans attribution) : galerie sur l'accueil + en-têtes des 3 pages prestations.

**À remplacer dès que possible par vos propres photos** (villa cliente avec accord, équipe, véhicules) — c'est ce qui crédibilise vraiment une entreprise locale :

1. Crée un dossier `img/` dans `public/`
2. Dépose tes photos (format paysage, min 1600 px de large, compressées via https://squoosh.app)
3. Remplace les URLs `images.unsplash.com` par `img/ma-photo.jpg` dans `index.html` et les 3 pages prestations

Attention : jamais de photo d'un client ou d'une propriété identifiable sans accord écrit — encore plus sensible dans votre métier.

## 7. Rappel légal important

Une entreprise de sécurité privée doit avoir l'**autorisation CNAPS** (et les agents leur carte professionnelle) **avant** de communiquer commercialement. Le site mentionne CNAPS partout — ne le mets pas en ligne avec un faux numéro : complète-le avec le vrai dès obtention.

# Vice Sweety — Pomelli Packaging Guide v3
### Direction photo : été, soleil, plage, féminin, Miami

---

## La vision

La fille a 24 ans, c'est l'été à Marseille. Elle sort de la plage, elle a chaud, elle a envie de se faire plaisir. Elle entre chez Vice Sweety, elle repart avec un smoothie sunset dans un gobelet brandé. Elle le tient devant la mer, elle prend la photo. Le soleil tape, les couleurs du smoothie brillent à travers le plastique, les palmiers roses du gobelet se découpent contre le ciel bleu.

**C'est ça la photo qu'on veut.** Pas un studio sombre avec des néons. Du soleil, de la lumière, de la chaleur, des couleurs vibrantes. Les produits Vice Sweety sont faits pour l'été — les photos doivent le montrer.

---

## Direction photo — Les règles

1. **Lumière naturelle chaude** — soleil d'été, golden hour, lumière douce et chaude. Pas de studio dark, pas de néon artificiel.
2. **Fonds clairs et chauds** — rose blush (#FDE8EF), sable clair, marbre rose pâle, surface en terrazzo rose. Jamais de fond noir.
3. **Touches de couleur estivales** — le bleu ciel, le turquoise de la mer, le vert des palmiers en arrière-plan flou. Ça ancre dans l'été et Miami.
4. **Le produit brille** — la lumière du soleil traverse le gobelet transparent, les couleurs du smoothie sont ultra-vibrantes, ça donne soif et envie.
5. **Ambiance lifestyle** — pas juste un gobelet posé, c'est un moment de vie. On devine une terrasse, une plage, un rebord de piscine. Le produit vit dans un contexte.
6. **Féminin sans forcer** — des éléments doux en arrière-plan (fleurs, tissu rose, lunettes de soleil, un magazine). Pas de stéréotype, juste de la douceur.
7. **Gobelet transparent, ouvert, pas de paille** — les mêmes règles que avant pour le cup
8. **Pattern palmiers moyens** — 6-8 visibles, bien espacés, logo au tiers supérieur
9. **Garniture simple** — tranche de fruit sur le bord
10. **Format carré 1:1**

---

## Brand Color Spec

| Token | Hex | Usage |
|-------|-----|-------|
| Pink | `#F990E8` | Logo, palmiers sur cups, branding |
| Hot Pink | `#FF69B4` | Accents forts |
| Blush | `#FDE8EF` | Fonds photo, surfaces |
| Cream | `#FFFAF6` | Fonds alternatifs |
| Coral | `#e8775a` | Touches chaudes sunset |
| Cyan | `#0BD2D3` | Accents secondaires (pas dominant dans les photos) |

---

## Les 3 images de référence Pomelli (pour tous les drinks)

| Slot | Quoi |
|------|------|
| Réf 1 | Le gobelet Vice Sweety winner du round 2 (palmiers + mangue) |
| Réf 2 | `assets/vice-sweety-logo-cropped.png` |
| Réf 3 | `assets/palmier_transparent.svg` |

---

## PROMPT TEMPLATE — Drinks (smoothies, milkshakes, jus)

```
Product photography of a branded clear plastic takeaway cup for "Vice Sweety" premium dessert brand. Summer vibes, bright and warm.

THE CUP:
- Clear transparent plastic cup, open top, no lid, no straw
- Filled with [VARIABLE: contenu]
- Cup is filled almost to the brim, generous amount
- "Vice Sweety" logo in pink script (#F990E8) printed directly on the clear plastic, positioned in the upper third of the cup
- Medium-sized palm tree pattern (#F990E8) printed on the clear plastic, well-spaced and airy, approximately 6-8 palm trees visible on the front face
- No paper sleeve, no cardboard wrapper

THE GARNISH:
- [VARIABLE: garniture] resting on the rim of the cup

THE SETTING & LIGHT:
- Bright warm natural sunlight, golden hour feel
- Background: soft blurred summer scene — hints of [VARIABLE: contexte été]
- Surface: [VARIABLE: surface] with soft warm shadows from the sunlight
- The sunlight passes through the transparent cup, making the drink colors glow and look ultra vibrant
- Warm, inviting, summery atmosphere — this is a drink you want on a hot day

CAMERA:
- Straight-on, very slight low perspective
- Sharp focus on the cup, gentle warm bokeh in the background
- Professional food/beverage photography, editorial quality
- Square format 1:1
```

---

## Produit 1 : SMOOTHIE SUNSET

### Variables
```
[CONTENU]: a tropical mango-passion fruit smoothie with a natural gradient — golden mango yellow at top, warm orange-coral at bottom
[GARNITURE]: A fresh mango slice
[CONTEXTE ÉTÉ]: turquoise sea water and palm tree shadows in the distance
[SURFACE]: light pink terrazzo or rose marble surface
```

### Prompt complet
```
Product photography of a branded clear plastic takeaway cup for "Vice Sweety" premium dessert brand. Summer vibes, bright and warm.

THE CUP:
- Clear transparent plastic cup, open top, no lid, no straw
- Filled with a tropical mango-passion fruit smoothie with a natural gradient — golden mango yellow at top, warm orange-coral at bottom
- Cup is filled almost to the brim, generous amount
- "Vice Sweety" logo in pink script (#F990E8) printed directly on the clear plastic, positioned in the upper third of the cup
- Medium-sized palm tree pattern (#F990E8) printed on the clear plastic, well-spaced and airy, approximately 6-8 palm trees visible on the front face
- No paper sleeve, no cardboard wrapper

THE GARNISH:
- A fresh mango slice resting on the rim of the cup

THE SETTING & LIGHT:
- Bright warm natural sunlight, golden hour feel
- Background: soft blurred summer scene — hints of turquoise sea water and palm tree shadows in the distance
- Surface: light pink terrazzo or rose marble surface with soft warm shadows from the sunlight
- The sunlight passes through the transparent cup, making the mango-orange colors glow and look ultra vibrant
- Warm, inviting, summery atmosphere — this is a drink you want on a hot day

CAMERA:
- Straight-on, very slight low perspective
- Sharp focus on the cup, gentle warm bokeh in the background
- Professional food/beverage photography, editorial quality
- Square format 1:1
```

---

## Produit 2 : MILKSHAKE VICE

### Variables
```
[CONTENU]: a thick creamy pink strawberry milkshake, rich and opaque, soft pink color throughout with fluffy whipped cream on top
[GARNITURE]: A fresh strawberry half
[CONTEXTE ÉTÉ]: a bright pink bougainvillea wall and warm afternoon light
[SURFACE]: white washed concrete or pale pink surface
```

### Prompt complet
```
Product photography of a branded clear plastic takeaway cup for "Vice Sweety" premium dessert brand. Summer vibes, bright and warm.

THE CUP:
- Clear transparent plastic cup, open top, no lid, no straw
- Filled with a thick creamy pink strawberry milkshake, rich and opaque, soft pink color throughout with fluffy whipped cream on top
- Cup is filled almost to the brim, generous amount
- "Vice Sweety" logo in pink script (#F990E8) printed directly on the clear plastic, positioned in the upper third of the cup
- Medium-sized palm tree pattern (#F990E8) printed on the clear plastic, well-spaced and airy, approximately 6-8 palm trees visible on the front face
- No paper sleeve, no cardboard wrapper

THE GARNISH:
- A fresh strawberry half resting on the rim of the cup

THE SETTING & LIGHT:
- Bright warm natural sunlight, golden hour feel
- Background: soft blurred scene of a bright pink bougainvillea wall and warm afternoon light
- Surface: white washed concrete or pale pink surface with soft warm shadows
- The sunlight illuminates the pink milkshake through the cup, making it glow
- Warm, feminine, summery atmosphere

CAMERA:
- Straight-on, very slight low perspective
- Sharp focus on the cup, gentle warm bokeh in the background
- Professional food/beverage photography, editorial quality
- Square format 1:1
```

---

## Produit 3 : JUS FRAIS

### Prompt complet
```
Product photography of a branded clear plastic takeaway cup for "Vice Sweety" premium dessert brand. Summer vibes, bright and warm.

THE CUP:
- Clear transparent plastic cup, open top, no lid, no straw
- Filled with fresh vibrant cold-pressed orange juice, bright vivid orange, slightly pulpy natural texture visible
- Cup is filled almost to the brim, generous amount
- "Vice Sweety" logo in pink script (#F990E8) printed directly on the clear plastic, positioned in the upper third of the cup
- Medium-sized palm tree pattern (#F990E8) printed on the clear plastic, well-spaced and airy
- No paper sleeve, no cardboard wrapper

THE GARNISH:
- A fresh orange slice resting on the rim of the cup

THE SETTING & LIGHT:
- Bright warm morning sunlight, fresh and energizing feel
- Background: soft blurred citrus grove or green leaves with dappled sunlight
- Surface: light natural wood or pale sand-colored surface with soft warm shadows
- The sunlight passes through the orange juice making it glow like liquid sunshine
- Fresh, vibrant, morning-at-the-beach atmosphere

CAMERA:
- Straight-on, very slight low perspective
- Sharp focus on the cup, gentle warm bokeh in the background
- Professional food/beverage photography, editorial quality
- Square format 1:1
```

---

## Produit 4 : COOKIE VICE (sachet matte noir)

### Références Pomelli
| Slot | Quoi |
|------|------|
| Réf 1 | Google : "premium matte black paper bag bakery summer setting bright" |
| Réf 2 | `assets/vice-sweety-logo-cropped.png` |
| Réf 3 | `assets/palmier_flamant.svg` |

### Prompt
```
Product photography of a branded matte black paper bag for "Vice Sweety" premium cookies. Summer setting, bright and warm.

THE BAG:
- Small matte black paper bag, standing upright, about 14cm wide × 20cm tall
- "Vice Sweety" logo in pink script (#F990E8) printed large and centered on the front
- Hot pink palm trees and flamingo silhouettes (#FF69B4) printed as a subtle pattern across the bag at 40% opacity
- Top slightly folded and sealed with a round black sticker with Vice Sweety logo in pink

THE COOKIE:
- One large dark chocolate cookie with gooey melted center, partially pulled out of the bag
- Rich deep brown color, cracked artisan surface, melted chocolate oozing
- A few natural crumbs on the surface

THE SETTING & LIGHT:
- Bright warm afternoon sunlight from the side
- Background: soft blurred outdoor café terrace, pink wall or bougainvillea in the distance
- Surface: light marble or pale pink table with warm sun shadows
- The contrast of the matte black bag against the bright summery background makes it pop
- The sunlight catches the gooey chocolate, making it look irresistible

CAMERA:
- Straight-on, slight low angle
- Sharp focus on bag and cookie, gentle warm bokeh background
- Professional food photography, editorial quality
- Square format 1:1
```

---

## Produit 5 : COOKIE DOUGH (pot brandé 8oz)

### Prompt
```
Product photography of a branded small clear plastic pot for "Vice Sweety" edible cookie dough. Summer setting, feminine and warm.

THE POT:
- Small clear transparent plastic pot/tub, 8oz size, short and wide
- "Vice Sweety" logo in pink script (#F990E8) printed directly on the clear plastic, centered
- Medium palm tree pattern (#F990E8) printed on the plastic, well-spaced
- Clear dome lid removed and placed beside the pot

THE PRODUCT:
- Raw edible cookie dough inside, soft creamy beige texture
- Visible chocolate chips embedded throughout
- Dough slightly mounded above the rim, generous and inviting
- Small wooden spoon sticking out at a slight angle

THE SETTING & LIGHT:
- Bright warm natural light, cozy afternoon feel
- Background: soft blurred pink blanket or cozy summer setting — beach picnic vibes
- Surface: light linen fabric or pale sand-colored surface
- Warm, inviting, the kind of treat you eat on a lazy summer afternoon

CAMERA:
- Slight overhead angle (about 30 degrees), showing the dough while still seeing the logo
- Sharp macro detail on dough texture and chocolate chips
- Professional food photography, editorial quality
- Square format 1:1
```

---

## Produit 6 : MINI PANCAKES (barquette dark purple)

### Prompt
```
Product photography of a branded dark purple cardboard food tray for "Vice Sweety" mini pancakes. Summer brunch vibes, bright and colorful.

THE TRAY:
- Small rectangular cardboard boat/tray, dark purple color (#1a0a2e), about 16cm x 10cm
- "Vice Sweety" logo in pink script (#F990E8) printed on the front side
- Medium palm tree pattern (#F990E8) printed on the outer sides at 40% opacity
- Inside: delicate pale pink tissue paper (#FDE8EF) lining the bottom, visible at the edges

THE FOOD:
- 6-8 golden mini pancakes arranged beautifully on the pink tissue paper
- Drizzled with melted Nutella/chocolate sauce
- Fresh fruit on top: sliced strawberries, raspberries, blueberries
- Small swirl of pink whipped cream on the side
- Everything looks indulgent, colorful, summer brunch perfection

THE SETTING & LIGHT:
- Bright warm morning sunlight, golden and fresh
- Background: soft blurred outdoor brunch table, flowers, orange juice in the distance
- Surface: light natural wood table or wicker surface with warm dappled shadows
- The bright colors of the fruit and the pink tissue paper pop in the sunlight
- Feels like Sunday brunch on a rooftop terrace in summer

CAMERA:
- Overhead angle (about 45 degrees) — the Instagram flat lay angle
- Sharp focus on the food details, gentle warm bokeh on edges
- Professional food photography, editorial quality
- Square format 1:1
```

---

## Produit 7 : CRÊPES

### Prompt
```
Product photography of a branded dark purple cardboard food tray for "Vice Sweety" crepes. Summer afternoon vibes, feminine and warm.

THE TRAY:
- Same dark purple cardboard tray as the mini pancakes (#1a0a2e)
- "Vice Sweety" logo in pink script (#F990E8) on the side
- Pale pink tissue paper (#FDE8EF) lining the inside

THE FOOD:
- One folded crepe generously filled with Nutella, fresh strawberry slices, and banana
- Topped with a dusting of powdered sugar and a drizzle of chocolate sauce
- Whipped cream rosette on the side, a few fresh raspberries scattered around
- Looks messy-but-pretty, indulgent, impossible to resist

THE SETTING & LIGHT:
- Bright warm afternoon sunlight, soft and golden
- Background: soft blurred summer terrace or Mediterranean street scene
- Surface: light stone or pale pink table with warm shadows from the sunlight
- The powdered sugar catches the light beautifully

CAMERA:
- Slight overhead angle (about 35 degrees), showing the filling and toppings
- Sharp focus on the crepe details, gentle warm bokeh background
- Professional food photography, editorial quality
- Square format 1:1
```

---

## Après génération — Noms de fichiers

Sauvegarde dans `img/` :
- `smoothie-sunset.webp`
- `milkshake-vice.webp`
- `jus-frais.webp`
- `cookie-vice.webp`
- `cookie-dough.webp`
- `mini-pancakes.webp`
- `crepe-vice.webp`

Dis-moi quand c'est fait → je mets à jour le site.

---

## Résumé DA v3

**1. Summer first** — Chaque photo respire l'été, le soleil, la chaleur. La fille voit la photo et elle a envie d'être dehors avec ce produit dans la main. Fonds clairs, lumière naturelle chaude, touches de bleu ciel et de vert tropical en arrière-plan.

**2. Le produit brille** — La lumière du soleil traverse les gobelets transparents et fait vibrer les couleurs des smoothies. L'orange du mango sunset, le pink du milkshake, le orange vif du jus — tout glow naturellement sous le soleil, pas sous un néon.

**3. Lifestyle, pas packshot** — Chaque photo raconte un moment : le smoothie à la plage, le milkshake devant un mur de bougainvilliers, le cookie dough sur une couverture de pique-nique, les pancakes au brunch du dimanche. Le produit vit dans un monde, pas dans un studio.

**4. Féminin par l'ambiance** — Pas de rose forcé partout. La féminité vient des surfaces douces (terrazzo, linen, marbre rose pâle), de la lumière chaude, des fleurs en arrière-plan, de l'atmosphère de détente. Le noir du sachet cookies contraste avec la luminosité du décor — c'est le "vice" dans le "sweet".

**5. Le packaging est l'identité** — Le gobelet avec ses palmiers roses, le sachet noir, la barquette purple avec le papier de soie — ce sont des objets beaux EN EUX-MÊMES dans la lumière du soleil. Le branding Vice Sweety est lisible, reconnaissable, instagrammable sans effort.

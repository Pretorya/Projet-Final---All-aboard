puts "Resetting StudyLink demo data..."

Message.destroy_all
ConversationParticipant.destroy_all
Conversation.destroy_all
Bookmark.destroy_all
Like.destroy_all
Comment.destroy_all
PostTag.destroy_all
Post.destroy_all
Tag.destroy_all
Resource.destroy_all
Event.destroy_all
EventCandidate.destroy_all
SubjectRequest.destroy_all
Subject.destroy_all
User.destroy_all

# ——— SUBJECTS ———

subjects = [
  {
    name: "Mathématiques",
    slug: "mathematiques",
    description: "Algèbre, analyse, géométrie, probabilités...",
    icon: "fa-calculator",
    accent_color: "#60a5fa"
  },
  {
    name: "Physique-Chimie",
    slug: "physique-chimie",
    description: "Mécanique, électromagnétisme, chimie organique...",
    icon: "fa-atom",
    accent_color: "#c084fc"
  },
  {
    name: "Informatique",
    slug: "informatique",
    description: "Python, JavaScript, algorithmes, bases de données...",
    icon: "fa-code",
    accent_color: "#4ade80"
  },
  {
    name: "Littérature",
    slug: "litterature",
    description: "Analyse de texte, dissertation, grammaire...",
    icon: "fa-book",
    accent_color: "#facc15"
  },
  {
    name: "Histoire-Géo",
    slug: "histoire-geo",
    description: "Histoire moderne, géopolitique, cartographie...",
    icon: "fa-landmark",
    accent_color: "#f87171"
  },
  {
    name: "Langues",
    slug: "langues",
    description: "Anglais, espagnol, allemand, traduction...",
    icon: "fa-globe",
    accent_color: "#22d3ee"
  }
].map { |attrs| Subject.create!(attrs) }.index_by(&:slug)

# ——— USERS ———

admin = User.create!(
  email: "admin@studylink.test",
  password: "password123",
  full_name: "Admin StudyLink",
  headline: "Administrateur de la plateforme",
  education_level: "N/A",
  bio: "Compte administrateur. Gestion de la plateforme, modération et contenu.",
  avatar_url: "https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?w=100&h=100&fit=crop",
  role: "admin"
)

# Mentors
lucas = User.create!(
  email: "lucas@studylink.test",
  password: "password123",
  full_name: "Lucas M.",
  headline: "Ingénieur logiciel — Mentor JavaScript & Ruby",
  education_level: "Master Informatique",
  bio: "5 ans d'expérience en développement web. Je partage mes ressources sur React, Ruby on Rails et les bonnes pratiques.",
  avatar_url: "https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=100&h=100&fit=crop",
  rating: 4.9,
  mentor: true
)

thomas = User.create!(
  email: "thomas@studylink.test",
  password: "password123",
  full_name: "Thomas D.",
  headline: "Doctorant en Mathématiques — Mentor",
  education_level: "Doctorat Maths",
  bio: "Je travaille sur la théorie des graphes. J'aime aider sur l'algorithmie, les preuves formelles et l'analyse.",
  avatar_url: "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=100&h=100&fit=crop",
  rating: 4.8,
  mentor: true
)

# Élèves / étudiants
marie = User.create!(
  email: "marie@studylink.test",
  password: "password123",
  full_name: "Marie L.",
  headline: "Terminale S, toujours prête à aider en maths",
  education_level: "Terminale S",
  bio: "Je réponds surtout aux questions d'analyse et de dérivation.",
  avatar_url: "https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=100&h=100&fit=crop",
  rating: 4.7
)

sarah = User.create!(
  email: "sarah@studylink.test",
  password: "password123",
  full_name: "Sarah K.",
  headline: "Prépa HEC — Littérature & Philo",
  education_level: "Prépa HEC",
  bio: "Littérature, philosophie et méthodes de dissertation. En quête de réflexions profondes.",
  avatar_url: "https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=100&h=100&fit=crop",
  rating: 4.6
)

camille = User.create!(
  email: "camille@studylink.test",
  password: "password123",
  full_name: "Camille R.",
  headline: "Licence LLCER — Langues & Cultures",
  education_level: "Licence LLCER",
  bio: "Langues vivantes, analyse de texte et traduction. J'apprends l'allemand en ce moment.",
  avatar_url: "https://images.unsplash.com/photo-1544723795-3fb6469f5b39?w=100&h=100&fit=crop",
  rating: 4.5
)

hugo = User.create!(
  email: "hugo@studylink.test",
  password: "password123",
  full_name: "Hugo B.",
  headline: "BTS SIO — Développement d'applications",
  education_level: "BTS SIO",
  bio: "Je découvre Rails et Python. Passionné par la cybersécurité.",
  avatar_url: "https://images.unsplash.com/photo-1599566150163-29194dcaad36?w=100&h=100&fit=crop",
  rating: 4.3
)

all_users = { admin: admin, lucas: lucas, thomas: thomas, marie: marie, sarah: sarah, camille: camille, hugo: hugo }

# ——— POSTS ———

posts = []

posts << Post.new(
  user: marie,
  subject: subjects["mathematiques"],
  title: "Besoin d'aide pour dériver cette fonction composée",
  body: "Je bloque sur la dérivation de f(x) = ln(x² + 1). J'ai essayé avec la règle de la chaîne mais je ne suis pas sûre du résultat. Quelqu'un peut m'expliquer étape par étape ?",
  code_snippet: "f(x) = ln(x² + 1)\nf'(x) = ?  # utiliser la dérivée de ln(u)",
  urgent: true,
  education_level: "Terminale S",
  tag_list: "Dérivation, Terminale, Analyse",
  created_at: 2.hours.ago
)

posts << Post.new(
  user: hugo,
  subject: subjects["informatique"],
  title: "Problème avec React useEffect et boucle infinie",
  body: "Mon composant re-render en boucle à cause de useEffect. Je comprends pas pourquoi mon state se met à jour sans arrêt alors que je n'ai rien changé...",
  code_snippet: "useEffect(() => {\n  fetchData();\n}, [data]); // data change à chaque render !",
  urgent: true,
  education_level: "BTS SIO",
  tag_list: "React, JavaScript, Hooks",
  created_at: 5.hours.ago
)

posts << Post.new(
  user: sarah,
  subject: subjects["litterature"],
  title: "Analyse de la conclusion de Candide — \"cultiver son jardin\"",
  body: "Je ne comprends pas la signification de la conclusion de Voltaire : \"il faut cultiver notre jardin\". Est-ce un repli sur soi ou une vraie philosophie de l'action ?",
  code_snippet: "",
  urgent: false,
  education_level: "Prépa HEC",
  tag_list: "Voltaire, Philosophie, Dissertation",
  created_at: 1.day.ago
)

posts << Post.new(
  user: camille,
  subject: subjects["langues"],
  title: "Comment améliorer mon expression écrite en anglais académique ?",
  body: "J'ai du mal à rendre mes introductions plus naturelles et moins scolaires. Vous avez une méthode ou des exemples de structure pour un essai argumentatif ?",
  code_snippet: "",
  urgent: false,
  education_level: "Licence LLCER",
  tag_list: "Anglais, Rédaction, Méthode",
  created_at: 9.hours.ago
)

posts << Post.new(
  user: hugo,
  subject: subjects["informatique"],
  title: "Différence entre TCP et UDP — exercice de TP réseau",
  body: "Mon prof nous demande de comparer TCP et UDP dans un tableau. J'ai les bases mais je vois pas concrètement quand utiliser l'un vs l'autre dans un vrai projet.",
  code_snippet: "",
  urgent: false,
  education_level: "BTS SIO",
  tag_list: "Réseau, TCP, UDP, BTS",
  created_at: 2.days.ago
)

posts << Post.new(
  user: marie,
  subject: subjects["mathematiques"],
  title: "Intégration par parties — je rate toujours le choix de u et v'",
  body: "Chaque fois que j'intègre par parties je fais le mauvais choix entre u et v'. Y a-t-il une règle mnémotechnique fiable ?",
  code_snippet: "∫ x·eˣ dx\n# u = x, v' = eˣ ?\n# ou u = eˣ, v' = x ?",
  urgent: false,
  education_level: "Terminale S",
  tag_list: "Intégration, Terminale, Méthode",
  created_at: 3.days.ago
)

posts.each do |post|
  tag_list = post.tag_list
  post.tag_list = nil
  post.save!
  post.sync_tags!(tag_list)
end

# ——— COMMENTS ———

Comment.create!(
  post: posts[0],
  user: thomas,
  body: "La règle de la chaîne donne : (ln u)' = u'/u. Ici u = x² + 1, donc u' = 2x et f'(x) = 2x / (x² + 1). Pense à toujours identifier la fonction intérieure u d'abord.",
  created_at: 1.hour.ago
)

Comment.create!(
  post: posts[0],
  user: lucas,
  body: "Thomas a raison. Pour vérifier, tu peux aussi passer par la définition limite si tu veux consolider. Mais la règle de la chaîne est largement suffisante ici.",
  created_at: 45.minutes.ago
)

Comment.create!(
  post: posts[1],
  user: lucas,
  body: "Le souci vient du tableau de dépendances : si fetchData modifie `data`, l'effet repart indéfiniment. Essaie `[]` pour un appel unique au montage, ou useCallback pour stabiliser fetchData.",
  created_at: 3.hours.ago
)

Comment.create!(
  post: posts[2],
  user: camille,
  body: "Voltaire oppose l'optimisme naïf (Pangloss) à l'action concrète. La formule finale est un appel à agir à son échelle plutôt qu'à spéculer sans fin sur le meilleur des mondes.",
  created_at: 18.hours.ago
)

Comment.create!(
  post: posts[2],
  user: thomas,
  body: "Pour compléter : \"cultiver son jardin\" peut aussi être lu comme une critique des philosophes qui commentent le monde sans jamais agir dessus. Très utile pour une intro de disso.",
  created_at: 16.hours.ago
)

Comment.create!(
  post: posts[4],
  user: lucas,
  body: "TCP : connexion fiable, ordre garanti, acquittement (HTTP, transfert de fichiers). UDP : pas de connexion, rapide, pertes tolérées (streaming vidéo, jeux en ligne, DNS). Le choix dépend de si tu peux te permettre de perdre des paquets.",
  created_at: 1.day.ago
)

# ——— LIKES ———

Like.create!(user: thomas,  post: posts[0])
Like.create!(user: lucas,   post: posts[0])
Like.create!(user: camille, post: posts[0])
Like.create!(user: marie,   post: posts[1])
Like.create!(user: hugo,    post: posts[2])
Like.create!(user: sarah,   post: posts[2])
Like.create!(user: thomas,  post: posts[3])
Like.create!(user: marie,   post: posts[4])
Like.create!(user: hugo,    post: posts[5])

# ——— BOOKMARKS ———

Bookmark.create!(user: thomas, post: posts[0])
Bookmark.create!(user: marie,  post: posts[2])
Bookmark.create!(user: hugo,   post: posts[1])
Bookmark.create!(user: sarah,  post: posts[4])

# ——— RESOURCES (mentors only) ———

Resource.create!(
  user: lucas,
  subject: subjects["informatique"],
  title: "Les fondamentaux de Git en 10 commandes",
  body: <<~BODY,
    # Les fondamentaux de Git

    Git est l'outil de gestion de version incontournable. Voici les 10 commandes que tout développeur doit maîtriser.

    ## Initialiser et cloner
    - `git init` — initialise un dépôt local
    - `git clone <url>` — clone un dépôt distant

    ## Travailler au quotidien
    - `git status` — état de l'arbre de travail
    - `git add .` — staging de tous les fichiers modifiés
    - `git commit -m "message"` — créer un commit

    ## Branches
    - `git checkout -b ma-branche` — créer et basculer sur une branche
    - `git merge ma-branche` — fusionner une branche dans la courante

    ## Synchronisation
    - `git pull` — récupérer et fusionner les changements distants
    - `git push` — pousser vos commits vers le dépôt distant

    ## Inspecter
    - `git log --oneline` — historique compact des commits

    ## Conseil pratique
    Commitez souvent, avec des messages clairs au présent impératif : "Ajoute le formulaire de connexion" plutôt que "Ajout form".
  BODY
  created_at: 3.days.ago
)

Resource.create!(
  user: lucas,
  subject: subjects["informatique"],
  title: "Comprendre les closures en JavaScript",
  body: <<~BODY,
    # Les closures en JavaScript

    Une closure est une fonction qui « se souvient » des variables de son environnement lexical, même après que cet environnement ait disparu.

    ## Exemple simple

    ```javascript
    function compteur() {
      let count = 0;
      return function() {
        count++;
        return count;
      };
    }

    const inc = compteur();
    inc(); // 1
    inc(); // 2
    inc(); // 3
    ```

    `count` reste accessible même après la fin de l'exécution de `compteur()`.

    ## Cas d'usage fréquents
    - Encapsulation (simuler des variables privées)
    - Mémorisation (memoization)
    - Callbacks avec contexte (event listeners, setTimeout)

    ## Piège classique : closures dans une boucle

    ```javascript
    for (var i = 0; i < 3; i++) {
      setTimeout(() => console.log(i), 100); // Affiche 3, 3, 3 !
    }
    // Solution : utiliser let à la place de var
    ```

    Retenir : `let` crée une nouvelle variable à chaque itération, `var` partage la même.
  BODY
  created_at: 1.day.ago
)

Resource.create!(
  user: thomas,
  subject: subjects["mathematiques"],
  title: "Méthode pour réussir une récurrence en Maths",
  body: <<~BODY,
    # La démonstration par récurrence

    La récurrence est une technique fondamentale pour prouver qu'une propriété P(n) est vraie pour tout entier naturel n ≥ n₀.

    ## Les 3 étapes obligatoires

    ### 1. Initialisation
    Vérifier que P(n₀) est vraie. C'est souvent trivial mais indispensable.

    ### 2. Hérédité
    Supposer que P(k) est vraie pour un certain k ≥ n₀ (**hypothèse de récurrence**), puis montrer que P(k+1) est vraie.

    ### 3. Conclusion
    "Par le principe de récurrence, P(n) est vraie pour tout n ≥ n₀."

    ## Exemple : somme des n premiers entiers

    **Propriété P(n)** : 1 + 2 + ... + n = n(n+1)/2

    **Init (n=1)** : 1 = 1·2/2 = 1 ✓

    **Hérédité** : supposons P(k) vraie.
    1 + 2 + ... + k + (k+1) = k(k+1)/2 + (k+1) = (k+1)(k+2)/2 ✓

    **Conclusion** : P(n) est vraie ∀ n ≥ 1.

    ## Erreurs fréquentes
    - Oublier l'initialisation
    - Ne pas utiliser l'hypothèse de récurrence dans l'hérédité
    - Sauter des étapes dans le calcul algébrique
  BODY
  created_at: 5.hours.ago
)

Resource.create!(
  user: thomas,
  subject: subjects["informatique"],
  title: "Complexité algorithmique — O(n) expliqué simplement",
  body: <<~BODY,
    # La complexité algorithmique

    La notation O (grand O) mesure comment le temps d'exécution ou la mémoire évoluent quand la taille de l'entrée augmente.

    ## Les classes principales

    | Notation | Nom | Exemple |
    |---|---|---|
    | O(1) | Constante | Accès à un tableau par index |
    | O(log n) | Logarithmique | Recherche dichotomique |
    | O(n) | Linéaire | Parcourir un tableau |
    | O(n log n) | Linéarithmique | Tri fusion, tri rapide |
    | O(n²) | Quadratique | Tri à bulles, boucle imbriquée |
    | O(2ⁿ) | Exponentielle | Sous-ensembles d'un ensemble |

    ## Règles pratiques

    1. **Ignorer les constantes** : O(3n) = O(n)
    2. **Garder le terme dominant** : O(n² + n) = O(n²)
    3. **Boucles imbriquées** = multiplication : deux boucles en n → O(n²)

    ## Exemple concret

    ```python
    # O(n²) — à éviter sur de grandes données
    def contient_doublon(lst):
        for i in range(len(lst)):
            for j in range(i+1, len(lst)):
                if lst[i] == lst[j]:
                    return True
        return False

    # O(n) — bien mieux !
    def contient_doublon_v2(lst):
        return len(lst) != len(set(lst))
    ```
  BODY
  created_at: 2.days.ago
)

# ——— EVENTS ———

Event.create!(
  title: "Hackathon 48h — IA & Développement Durable",
  description: "72 heures pour construire une solution tech au service de l'environnement. Équipes de 2 à 5 personnes. Prix : 5000 € et mentorat startup. Ouvert à tous niveaux.",
  event_type: "hackathon",
  starts_at: 3.weeks.from_now,
  ends_at: 3.weeks.from_now + 2.days,
  location: "Station F, Paris 13e",
  organizer: "GreenTech Challenge",
  online: false,
  external_url: "https://example.com/hackathon-ia-durabilite",
  subject: subjects["informatique"]
)

Event.create!(
  title: "Portes ouvertes — École 42 Paris",
  description: "Venez découvrir la pédagogie par projets de 42 : pas de cours magistraux, 100 % pratique. Rencontrez des étudiants et des alumnis, testez la piscine. Inscription en ligne obligatoire.",
  event_type: "open_house",
  starts_at: 2.weeks.from_now,
  ends_at: 2.weeks.from_now + 1.day,
  location: "École 42, Paris 17e",
  organizer: "École 42",
  online: false,
  external_url: "https://example.com/42-portes-ouvertes",
  subject: nil
)

Event.create!(
  title: "Conférence — DevOps & Cloud Native 2025",
  description: "Une journée de conférences autour de Kubernetes, CI/CD, GitOps et observabilité. Speakers issus de l'industrie. 400 participants attendus. Networking le soir.",
  event_type: "conference",
  starts_at: 5.weeks.from_now,
  ends_at: 5.weeks.from_now,
  location: "La Défense, Paris",
  organizer: "CloudCraft Community",
  online: false,
  external_url: "https://example.com/devops-cloud-native-2025",
  subject: subjects["informatique"]
)

Event.create!(
  title: "Meetup — Ruby on Rails Paris #42",
  description: "La communauté Rails se retrouve pour des talks de 15 min sur Rails 8, Hotwire et les pratiques modernes. Bières et networking à l'issue.",
  event_type: "meetup",
  starts_at: 10.days.from_now,
  ends_at: 10.days.from_now,
  location: "Le Wagon Paris, Paris 9e",
  organizer: "Paris.rb",
  online: false,
  external_url: "https://example.com/paris-rb-meetup-42",
  subject: subjects["informatique"]
)

Event.create!(
  title: "Webinaire — Introduction à la cybersécurité offensive",
  description: "Comprendre les bases du pentesting : OWASP Top 10, outils Kali Linux, premiers CTF. Idéal pour les étudiants en BTS/Licence qui veulent se spécialiser en sécu.",
  event_type: "webinar",
  starts_at: 1.week.from_now,
  ends_at: 1.week.from_now,
  location: nil,
  organizer: "SecuriLearn",
  online: true,
  external_url: "https://example.com/webinaire-cybersec",
  subject: subjects["informatique"]
)

Event.create!(
  title: "Forum des métiers — Numérique & IA",
  description: "Rencontrez des professionnels du numérique : développeurs, data scientists, UX designers, DevOps. Tables rondes, speed meetings et offres de stage. Gratuit sur inscription.",
  event_type: "conference",
  starts_at: 4.weeks.from_now,
  ends_at: 4.weeks.from_now,
  location: "Palais des Congrès, Paris",
  organizer: "Pôle Emploi Digital",
  online: false,
  external_url: "https://example.com/forum-numerique-ia",
  subject: nil
)

Event.create!(
  title: "Hackathon Maths — Modélisation & Data",
  description: "Résoudre des problèmes de modélisation mathématique avec des données réelles (météo, épidémies, marchés financiers). Pour étudiants L2+ et prépas. Encadrés par des chercheurs.",
  event_type: "hackathon",
  starts_at: 6.weeks.from_now,
  ends_at: 6.weeks.from_now + 1.day,
  location: "Université Paris-Saclay",
  organizer: "Société Mathématique de France",
  online: false,
  external_url: "https://example.com/hackathon-maths-data",
  subject: subjects["mathematiques"]
)

Event.create!(
  title: "Webinaire — Réussir son entrée en prépa littéraire",
  description: "Conseils de méthode, organisation, lectures incontournables et retours d'expérience d'actuels khâgneux. Pour les lycéens de Terminale envisageant une prépa lettres.",
  event_type: "webinar",
  starts_at: 3.days.from_now,
  ends_at: 3.days.from_now,
  location: nil,
  organizer: "Réseaux Prépas",
  online: true,
  external_url: "https://example.com/webinaire-prepa-lettres",
  subject: subjects["litterature"]
)

# ——— CONVERSATIONS ———

conv1 = Conversation.find_or_create_direct!(
  sender: marie,
  recipient: thomas,
  topic: posts[0].title
)
conv1.mark_read_for!(marie)
conv1.mark_read_for!(thomas)
[
  [marie,  "Salut Thomas ! Tu as un moment pour m'aider sur l'exo de dérivation ?", 20.minutes.ago],
  [thomas, "Bien sûr ! C'est lequel exactement ?", 18.minutes.ago],
  [marie,  "La fonction composée avec ln. J'arrive pas à identifier u.", 16.minutes.ago],
  [thomas, "Rappelle-toi : u est toujours ce qui est « à l'intérieur ». Ici, ln(x² + 1) → u = x² + 1.", 14.minutes.ago],
  [marie,  "Ah oui ! Donc u' = 2x et f'(x) = 2x/(x²+1) ?", 12.minutes.ago],
  [thomas, "Exactement. Tu peux vérifier en développant via la définition si tu veux consolider.", 10.minutes.ago],
  [marie,  "Super, merci beaucoup !", 8.minutes.ago]
].each do |user, body, created_at|
  Message.create!(conversation: conv1, user: user, body: body, created_at: created_at, updated_at: created_at)
end
conv1.mark_read_for!(thomas)
conv1.conversation_participants.find_by!(user: marie).update!(last_read_at: 9.minutes.ago)

conv2 = Conversation.find_or_create_direct!(
  sender: hugo,
  recipient: lucas,
  topic: posts[1].title
)
conv2.mark_read_for!(hugo)
conv2.conversation_participants.find_by!(user: lucas).update!(last_read_at: 2.days.ago)
[
  [hugo,  "Hey Lucas, mon useEffect part en boucle... j'ai essayé de changer les deps mais rien.", 4.hours.ago],
  [lucas, "Montre-moi ton code, on va regarder ensemble.", 3.hours.ago],
  [hugo,  "useEffect(() => { fetchData(); }, [data]) — fetchData met à jour data à chaque fois.", 2.hours.ago],
  [lucas, "Voilà le problème ! fetchData modifie data → l'effet se relance → fetchData modifie data... Utilise [] pour un appel unique au montage.", 90.minutes.ago]
].each do |user, body, created_at|
  Message.create!(conversation: conv2, user: user, body: body, created_at: created_at, updated_at: created_at)
end

conv3 = Conversation.find_or_create_direct!(
  sender: sarah,
  recipient: camille,
  topic: "Méthode pour la dissertation de littérature"
)
conv3.mark_read_for!(sarah)
conv3.mark_read_for!(camille)
[
  [sarah,   "Tu as une bonne structure de disso pour les sujets de type 'commentez cette affirmation' ?", 3.days.ago],
  [camille, "Oui ! Thèse / Antithèse / Synthèse. La partie 3 doit toujours dépasser les deux premières.", 3.days.ago],
  [sarah,   "Et pour l'intro, tu commences par quoi ?", 3.days.ago],
  [camille, "Accroche (citation ou fait) → contextualisation → problématique → annonce du plan. Dans cet ordre strict.", 3.days.ago]
].each do |user, body, created_at|
  Message.create!(conversation: conv3, user: user, body: body, created_at: created_at, updated_at: created_at)
end

# ——— SUBJECT REQUESTS ———

SubjectRequest.create!(
  user: hugo,
  name: "Cybersécurité",
  description: "Besoin d'une catégorie dédiée au pentest, aux CTF, à OWASP et aux outils Kali. Il y a beaucoup d'étudiants en BTS/Licence sécu sans espace de discussion.",
  status: "pending",
  created_at: 2.days.ago
)

SubjectRequest.create!(
  user: camille,
  name: "Philosophie",
  description: "La philo est souvent mélangée avec la littérature alors que ce sont des méthodologies très différentes. Une matière séparée aiderait beaucoup les prépas.",
  status: "pending",
  created_at: 4.days.ago
)

# ——— DONE ———

puts ""
puts "✓ Seed terminé !"
puts ""
puts "  Comptes disponibles :"
puts "  ┌─────────────────────────────────────┬──────────────┬─────────────┐"
puts "  │ Email                               │ Mot de passe │ Rôle        │"
puts "  ├─────────────────────────────────────┼──────────────┼─────────────┤"
puts "  │ admin@studylink.test                │ password123  │ Admin       │"
puts "  │ lucas@studylink.test                │ password123  │ Mentor      │"
puts "  │ thomas@studylink.test               │ password123  │ Mentor      │"
puts "  │ marie@studylink.test                │ password123  │ Élève       │"
puts "  │ sarah@studylink.test                │ password123  │ Élève       │"
puts "  │ camille@studylink.test              │ password123  │ Élève       │"
puts "  │ hugo@studylink.test                 │ password123  │ Élève       │"
puts "  └─────────────────────────────────────┴──────────────┴─────────────┘"
puts ""
puts "  Données créées :"
puts "  - #{Subject.count} matières"
puts "  - #{User.count} utilisateurs (1 admin, 2 mentors, 4 élèves)"
puts "  - #{Post.count} posts, #{Comment.count} commentaires, #{Like.count} likes, #{Bookmark.count} bookmarks"
puts "  - #{Resource.count} ressources pédagogiques"
puts "  - #{Event.count} événements"
puts "  - #{Conversation.count} conversations, #{Message.count} messages"
puts "  - #{SubjectRequest.count} demandes de matières"

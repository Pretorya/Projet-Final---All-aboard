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
Subject.destroy_all
User.destroy_all

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
].map { |attributes| Subject.create!(attributes) }.index_by { |subject| subject.slug }

users = [
  {
    email: "marie@studylink.test",
    password: "password123",
    full_name: "Marie L.",
    headline: "Terminale S, toujours prête à aider en maths",
    education_level: "Terminale S",
    bio: "Je réponds surtout aux questions d'analyse et de dérivation.",
    avatar_url: "https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=100&h=100&fit=crop",
    rating: 4.9
  },
  {
    email: "lucas@studylink.test",
    password: "password123",
    full_name: "Lucas M.",
    headline: "Licence Informatique",
    education_level: "Licence Informatique",
    bio: "React, Ruby, SQL. Je débloque surtout les problèmes front et algo.",
    avatar_url: "https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=100&h=100&fit=crop",
    rating: 4.8
  },
  {
    email: "sarah@studylink.test",
    password: "password123",
    full_name: "Sarah K.",
    headline: "Prépa HEC",
    education_level: "Prépa HEC",
    bio: "Littérature, philo et méthodes de dissertation.",
    avatar_url: "https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=100&h=100&fit=crop",
    rating: 4.7
  },
  {
    email: "thomas@studylink.test",
    password: "password123",
    full_name: "Thomas D.",
    headline: "Étudiant L2 Maths-Info",
    education_level: "L2 Maths-Info",
    bio: "J'aime les sujets croisés entre logique, preuve et programmation.",
    avatar_url: "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=100&h=100&fit=crop",
    rating: 4.8
  },
  {
    email: "camille@studylink.test",
    password: "password123",
    full_name: "Camille R.",
    headline: "Licence LLCER",
    education_level: "Licence LLCER",
    bio: "Langues et analyse de texte.",
    avatar_url: "https://images.unsplash.com/photo-1544723795-3fb6469f5b39?w=100&h=100&fit=crop",
    rating: 4.6
  }
].map { |attributes| User.create!(attributes) }.index_by(&:email)

posts = [
  {
    user: users["marie@studylink.test"],
    subject: subjects["mathematiques"],
    title: "Besoin d'aide pour dériver cette fonction composée",
    body: "Je bloque sur la dérivation de f(x) = ln(x² + 1). J'ai essayé avec u'v + uv' mais je ne suis pas sûre du résultat. Quelqu'un peut-il m'expliquer étape par étape ?",
    code_snippet: "f(x) = ln(x² + 1)\nf'(x) = ?",
    urgent: true,
    education_level: "Terminale S",
    tag_list: "Dérivation, Terminale, Analyse",
    created_at: 2.hours.ago
  },
  {
    user: users["lucas@studylink.test"],
    subject: subjects["informatique"],
    title: "Problème avec React useEffect et boucle infinie",
    body: "Mon composant re-render en boucle à cause de useEffect. Je comprends pas pourquoi mon state se met à jour sans arrêt...",
    code_snippet: "useEffect(() => {\n  fetchData();\n}, [data]);",
    urgent: false,
    education_level: "Licence Informatique",
    tag_list: "React, JavaScript, Hooks",
    created_at: 5.hours.ago
  },
  {
    user: users["sarah@studylink.test"],
    subject: subjects["litterature"],
    title: "Analyse de Candide, chapitre 30",
    body: "Je ne comprends pas la signification de la conclusion \"il faut cultiver notre jardin\". Quelqu'un peut m'expliquer la philosophie de Voltaire derrière cette phrase ?",
    code_snippet: "",
    urgent: false,
    education_level: "Prépa HEC",
    tag_list: "Voltaire, Philosophie, Dissertation",
    created_at: 1.day.ago
  },
  {
    user: users["camille@studylink.test"],
    subject: subjects["langues"],
    title: "Comment améliorer mon expression écrite en anglais académique ?",
    body: "J'ai du mal à rendre mes introductions plus naturelles et moins scolaires. Vous avez une méthode ou des exemples de structure ?",
    code_snippet: "",
    urgent: false,
    education_level: "Licence LLCER",
    tag_list: "Anglais, Rédaction, Méthode",
    created_at: 9.hours.ago
  }
].map do |attributes|
  tag_list = attributes.delete(:tag_list)
  post = Post.create!(attributes)
  post.sync_tags!(tag_list)
  post
end

Comment.create!(
  post: posts.first,
  user: users["thomas@studylink.test"],
  body: "Tu dois utiliser la dérivation d'une fonction composée : (ln u)' = u'/u. Ici u = x² + 1, donc u' = 2x et f'(x) = 2x / (x² + 1).",
  created_at: 1.hour.ago
)

Comment.create!(
  post: posts.second,
  user: users["marie@studylink.test"],
  body: "Le souci vient bien du tableau de dépendances : si fetchData modifie data, l'effet repart. Essaie de déclencher l'effet avec [] ou avec un autre state source.",
  created_at: 3.hours.ago
)

Comment.create!(
  post: posts.third,
  user: users["camille@studylink.test"],
  body: "Voltaire oppose l'optimisme abstrait à l'action concrète. La formule finale invite à agir à son échelle plutôt qu'à spéculer sans fin.",
  created_at: 18.hours.ago
)

Like.create!(user: users["thomas@studylink.test"], post: posts.first)
Like.create!(user: users["lucas@studylink.test"], post: posts.first)
Like.create!(user: users["marie@studylink.test"], post: posts.second)
Like.create!(user: users["sarah@studylink.test"], post: posts.second)
Like.create!(user: users["camille@studylink.test"], post: posts.third)

Bookmark.create!(user: users["thomas@studylink.test"], post: posts.first)
Bookmark.create!(user: users["marie@studylink.test"], post: posts.third)

conversation = Conversation.find_or_create_direct!(
  sender: users["thomas@studylink.test"],
  recipient: users["marie@studylink.test"],
  topic: posts.first.title
)

conversation.mark_read_for!(users["thomas@studylink.test"])
conversation.mark_read_for!(users["marie@studylink.test"])

[
  [ users["marie@studylink.test"], "Salut ! Tu as un moment pour m'aider sur l'exercice de maths ?", 6.minutes.ago ],
  [ users["thomas@studylink.test"], "Oui bien sûr ! C'est lequel ?", 5.minutes.ago ],
  [ users["marie@studylink.test"], "Le 15 de la feuille 3, je comprends pas la question 2.", 4.minutes.ago ],
  [ users["thomas@studylink.test"], "Il faut utiliser le théorème des valeurs intermédiaires. Si tu veux on détaille ligne par ligne.", 3.minutes.ago ],
  [ users["marie@studylink.test"], "Super merci beaucoup pour ton aide !", 2.minutes.ago ]
].each do |user, body, created_at|
  Message.create!(conversation: conversation, user: user, body: body, created_at: created_at, updated_at: created_at)
end

conversation.mark_read_for!(users["thomas@studylink.test"])
conversation.conversation_participants.find_by!(user: users["marie@studylink.test"]).update!(last_read_at: 4.minutes.ago)

second_conversation = Conversation.find_or_create_direct!(
  sender: users["lucas@studylink.test"],
  recipient: users["thomas@studylink.test"],
  topic: posts.second.title
)
second_conversation.mark_read_for!(users["lucas@studylink.test"])
second_conversation.conversation_participants.find_by!(user: users["thomas@studylink.test"]).update!(last_read_at: 1.day.ago)
Message.create!(conversation: second_conversation, user: users["lucas@studylink.test"], body: "J'ai une autre question sur React...", created_at: 3.hours.ago, updated_at: 3.hours.ago)

puts "Seed complete."
puts "Demo login: marie@studylink.test / password123"

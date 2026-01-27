import 'package:flutter/material.dart';
import '../../core/config/colors.dart';
import '../../core/widgets/app_bar_custom.dart';

// Contenu éditorial figé dans l'application : il n'y a pas encore d'endpoint
// culture côté API.
const _traditions = [
  _CultureTopic(
    icon: Icons.people,
    title: 'Traditions Ancestrales',
    description:
        'Le Burkina Faso est riche de traditions ancestrales qui se perpétuent de génération en génération. Les cérémonies traditionnelles, les danses rituelles et les pratiques coutumières constituent le cœur de l\'identité culturelle burkinabè.',
  ),
  _CultureTopic(
    icon: Icons.music_note,
    title: 'Musique et Danse',
    description:
        'La musique et la danse occupent une place centrale dans la culture locale. Des instruments traditionnels comme le balafon, le djembé et la kora accompagnent les célébrations et les événements importants de la vie communautaire.',
  ),
];

const _gastronomie = [
  _CultureTopic(
    icon: Icons.restaurant,
    title: 'Plats Traditionnels',
    description:
        'La cuisine burkinabè est variée et savoureuse. Le Tô (à base de mil, sorgho ou maïs) servi avec différentes sauces reste le plat de base. Le Riz gras, le Babenda et le Poulet bicyclette sont également des incontournables de la gastronomie locale.',
  ),
  _CultureTopic(
    icon: Icons.local_drink,
    title: 'Boissons Locales',
    description:
        'Le Dolo (bière de mil), le Jus de Bissap (hibiscus) et le Zoom-Koom sont des boissons traditionnelles très appréciées. Ces breuvages accompagnent souvent les repas et les célébrations.',
  ),
];

const _evenements = [
  _CultureTopic(
    icon: Icons.celebration,
    title: 'FESPACO',
    description:
        'Le Festival Panafricain du Cinéma et de la Télévision de Ouagadougou (FESPACO) est le plus grand festival de cinéma africain. Il se tient tous les deux ans et attire des cinéastes du monde entier.',
  ),
  _CultureTopic(
    icon: Icons.theater_comedy,
    title: 'SIAO',
    description:
        'Le Salon International de l\'Artisanat de Ouagadougou (SIAO) est une vitrine de l\'artisanat africain. Cet événement biennal met en valeur le savoir-faire des artisans de tout le continent.',
  ),
  _CultureTopic(
    icon: Icons.festival,
    title: 'Fêtes Traditionnelles',
    description:
        'Les fêtes de masques, les cérémonies d\'initiation et les festivals culturels locaux rythment la vie des communautés tout au long de l\'année.',
  ),
];

class CultureScreen extends StatefulWidget {
  const CultureScreen({super.key});

  @override
  State<CultureScreen> createState() => _CultureScreenState();
}

class _CultureScreenState extends State<CultureScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const AppBarCustom(
        title: 'Culture Locale',
      ),
      body: Column(
        children: [
          Container(
            color: Colors.white,
            child: TabBar(
              controller: _tabController,
              labelColor: AppColors.evergreen,
              unselectedLabelColor: AppColors.textSecondary,
              indicatorColor: AppColors.evergreen,
              indicatorWeight: 3,
              labelStyle: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
              tabs: const [
                Tab(text: 'Traditions'),
                Tab(text: 'Gastronomie'),
                Tab(text: 'Événements'),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: const [
                _CultureTab(topics: _traditions),
                _CultureTab(topics: _gastronomie),
                _CultureTab(topics: _evenements),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CultureTopic {
  final IconData icon;
  final String title;
  final String description;

  const _CultureTopic({
    required this.icon,
    required this.title,
    required this.description,
  });
}

class _CultureTab extends StatelessWidget {
  final List<_CultureTopic> topics;

  const _CultureTab({required this.topics});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        for (var i = 0; i < topics.length; i++) ...[
          if (i > 0) const SizedBox(height: 16),
          _CultureInfoCard(topic: topics[i]),
        ],
      ],
    );
  }
}

class _CultureInfoCard extends StatelessWidget {
  final _CultureTopic topic;

  const _CultureInfoCard({required this.topic});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.evergreen.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    topic.icon,
                    size: 28,
                    color: AppColors.evergreen,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    topic.title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.evergreen,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              topic.description,
              style: const TextStyle(
                fontSize: 15,
                color: AppColors.textSecondary,
                height: 1.6,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

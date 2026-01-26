import 'package:flutter/material.dart';
import '../../core/config/colors.dart';
import '../../core/widgets/app_bar_custom.dart';

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
          // Tabs
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

          // Contenu des tabs
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildTraditionsTab(),
                _buildGastronomieTab(),
                _buildEvenementsTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTraditionsTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildInfoCard(
          icon: Icons.people,
          title: 'Traditions Ancestrales',
          description:
              'Le Burkina Faso est riche de traditions ancestrales qui se perpétuent de génération en génération. Les cérémonies traditionnelles, les danses rituelles et les pratiques coutumières constituent le cœur de l\'identité culturelle burkinabè.',
          color: AppColors.evergreen,
        ),
        const SizedBox(height: 16),
        _buildInfoCard(
          icon: Icons.music_note,
          title: 'Musique et Danse',
          description:
              'La musique et la danse occupent une place centrale dans la culture locale. Des instruments traditionnels comme le balafon, le djembé et la kora accompagnent les célébrations et les événements importants de la vie communautaire.',
          color: AppColors.evergreen,
        ),
      ],
    );
  }

  Widget _buildGastronomieTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildInfoCard(
          icon: Icons.restaurant,
          title: 'Plats Traditionnels',
          description:
              'La cuisine burkinabè est variée et savoureuse. Le Tô (à base de mil, sorgho ou maïs) servi avec différentes sauces reste le plat de base. Le Riz gras, le Babenda et le Poulet bicyclette sont également des incontournables de la gastronomie locale.',
          color: AppColors.evergreen,
        ),
        const SizedBox(height: 16),
        _buildInfoCard(
          icon: Icons.local_drink,
          title: 'Boissons Locales',
          description:
              'Le Dolo (bière de mil), le Jus de Bissap (hibiscus) et le Zoom-Koom sont des boissons traditionnelles très appréciées. Ces breuvages accompagnent souvent les repas et les célébrations.',
          color: AppColors.evergreen,
        ),
      ],
    );
  }

  Widget _buildEvenementsTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildInfoCard(
          icon: Icons.celebration,
          title: 'FESPACO',
          description:
              'Le Festival Panafricain du Cinéma et de la Télévision de Ouagadougou (FESPACO) est le plus grand festival de cinéma africain. Il se tient tous les deux ans et attire des cinéastes du monde entier.',
          color: AppColors.evergreen,
        ),
        const SizedBox(height: 16),
        _buildInfoCard(
          icon: Icons.theater_comedy,
          title: 'SIAO',
          description:
              'Le Salon International de l\'Artisanat de Ouagadougou (SIAO) est une vitrine de l\'artisanat africain. Cet événement biennal met en valeur le savoir-faire des artisans de tout le continent.',
          color: AppColors.evergreen,
        ),
        const SizedBox(height: 16),
        _buildInfoCard(
          icon: Icons.festival,
          title: 'Fêtes Traditionnelles',
          description:
              'Les fêtes de masques, les cérémonies d\'initiation et les festivals culturels locaux rythment la vie des communautés tout au long de l\'année.',
          color: AppColors.evergreen,
        ),
      ],
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required String description,
    required Color color,
  }) {
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
                    color: color.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    icon,
                    size: 28,
                    color: color,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              description,
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

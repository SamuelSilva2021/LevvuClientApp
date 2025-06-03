import 'package:flutter/material.dart';
import 'package:levvu_client/core/constants/app_colors.dart';
import 'package:levvu_client/core/provider/user_provider.dart';
import 'package:levvu_client/presentation/pages/freight_request_page.dart';
import 'package:levvu_client/presentation/pages/historico_fretes_page.dart';
import 'package:levvu_client/presentation/pages/perfil_usuario_page.dart';
import 'package:levvu_client/presentation/pages/solicitacao_frete_page.dart';
import 'package:levvu_client/presentation/pages/visualizacao_propostas_page.dart';
import 'package:levvu_client/presentation/widgets/home/request_freight_card.dart';
import 'package:levvu_client/presentation/widgets/home/ongoing_shipments_section.dart';
import 'package:levvu_client/presentation/widgets/home/recent_proposals_section.dart';
import 'package:levvu_client/presentation/widgets/home/popular_services_section.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  // Lista de páginas para a navegação inferior
  final List<Widget> _pages = const [
    HomeContent(),
    VisualizacaoPropostasPage(),
    HistoricoFretesPage(),
    PerfilUsuarioPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Usando IndexedStack para manter o estado das páginas ao navegar
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textLight,
        selectedLabelStyle:
            const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
        unselectedLabelStyle: const TextStyle(fontSize: 12),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Início',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.description_outlined),
            activeIcon: Icon(Icons.description),
            label: 'Propostas',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history_outlined),
            activeIcon: Icon(Icons.history),
            label: 'Histórico',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Perfil',
          ),
        ],
      ),
    );
  }
}

class HomeContent extends StatelessWidget {
  const HomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    //Acessar o provider do usuário
    final userProvider = Provider.of<UserProvider>(context);
    if (userProvider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    final String userName =
        userProvider.userName.split(' ')[0]; //Pegar apenas o primeiro nome

    // Dados simulados
    final List<Map<String, dynamic>> ongoingShipments = [
      {
        'id': '1001',
        'origem': 'Av. Paulista, 1000',
        'destino': 'Rua Augusta, 500',
        'status': 'Em trânsito',
        'parceiro': 'Transportes Rápidos',
        'tempoRestante': '30 min',
      },
    ];

    final List<Map<String, dynamic>> recentProposals = [
      {
        'id': '2001',
        'parceiro': 'Transportes Rápidos',
        'valor': 'R\$ 120,00',
        'origem': 'Av. Paulista, 1000',
        'destino': 'Rua Augusta, 500',
        'avaliacao': 4.8,
      },
    ];

    final List<Map<String, dynamic>> services = [
      {
        'title': 'Mudança Residencial',
        'icon': Icons.home_outlined,
        'color': Colors.blue,
      },
      {
        'title': 'Entrega Expressa',
        'icon': Icons.local_shipping_outlined,
        'color': Colors.orange,
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Levvu'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {
              // Implementar visualização de notificações
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Saudação ao usuário
            Text(
              'Olá, $userName!',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'O que você precisa transportar hoje?',
              style: TextStyle(
                fontSize: 16,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 24),

            // Card principal para solicitar frete
            RequestFreightCard(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const FreightRequestPage(),
                  ),
                );
              },
            ),
            const SizedBox(height: 24),

            // Fretes em andamento
            OngoingShipmentsSection(
              shipments: ongoingShipments,
              onViewAll: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const HistoricoFretesPage(
                      initialTabIndex: 1, // Aba "Em andamento"
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 24),

            // Propostas recentes
            RecentProposalsSection(
              proposals: recentProposals,
              onViewAll: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const VisualizacaoPropostasPage(),
                  ),
                );
              },
            ),
            const SizedBox(height: 24),

            // Serviços populares
            PopularServicesSection(
              services: services,
              onViewAll: () {
                // Implementar navegação para ver todos os serviços
              },
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

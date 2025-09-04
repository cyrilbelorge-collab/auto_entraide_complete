import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../providers/auth_provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, _) {
        if (authProvider.isLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (!authProvider.isLoggedIn) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            context.go('/login');
          });
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        return Scaffold(
          appBar: AppBar(
            title: const Text('Auto Entraide'),
            actions: [
              IconButton(
                icon: const Icon(Icons.logout),
                onPressed: () => authProvider.logout(),
              ),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Bienvenue, ${authProvider.user?.name ?? ''}!',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: GridView.count(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    children: [
                      _buildFeatureCard(
                        context,
                        'Problèmes',
                        'Consulter et publier des problèmes automobiles',
                        Icons.build,
                        () => context.go('/problems'),
                      ),
                      _buildFeatureCard(
                        context,
                        'Codes DTC',
                        'Rechercher des codes d\'erreur',
                        Icons.error_outline,
                        () => context.go('/dtc'),
                      ),
                      _buildFeatureCard(
                        context,
                        'OBD2',
                        'Diagnostics en temps réel',
                        Icons.usb,
                        () => ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Fonctionnalité bientôt disponible')),
                        ),
                      ),
                      _buildFeatureCard(
                        context,
                        'Chat',
                        'Discuter avec la communauté',
                        Icons.chat,
                        () => ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Fonctionnalité bientôt disponible')),
                        ),
                      ),
                      _buildFeatureCard(
                        context,
                        'Maintenance',
                        'Carnet d\'entretien',
                        Icons.calendar_today,
                        () => ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Fonctionnalité bientôt disponible')),
                        ),
                      ),
                      _buildFeatureCard(
                        context,
                        'Profil',
                        'Gérer mon compte',
                        Icons.person,
                        () => ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Fonctionnalité bientôt disponible')),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildFeatureCard(BuildContext context, String title, String description, IconData icon, VoidCallback onTap) {
    return Card(
      elevation: 4,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 48, color: Theme.of(context).primaryColor),
              const SizedBox(height: 8),
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: Theme.of(context).textTheme.bodySmall,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
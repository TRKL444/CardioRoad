import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cardioroad/shared/themes/app_colors.dart';
import 'package:cardioroad/features/settings/widgets/profile_header.dart';
import 'package:cardioroad/features/settings/widgets/settings_option_tile.dart';
import 'package:cardioroad/features/auth/screens/login_screen.dart'; // Assumindo que você tem uma tela de login

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  Future<void> _signOut(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      // Navegar para a tela de login ou outra tela inicial após o logout
      if (context.mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
              builder: (context) =>
                  const LoginScreen()), // Substitua por sua tela de login
          (Route<dynamic> route) => false,
        );
      }
    } catch (e) {
      // Usar print para debug, mas mostrar SnackBar para o usuário
      // print('Erro ao fazer logout: $e');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Erro ao fazer logout: ${e.toString()}'),
              backgroundColor: AppColors.error),
        );
      }
    }
  }

  // Widget simples para evitar a complexidade do FutureBuilder
  Widget _buildContent(BuildContext context, User user) {
    // --- MOCK DATA E FALLBACK ---
    // Removemos a busca do Firestore. Usamos dados do Auth e mock data.
    final userName = user.displayName ?? 'Nathalia'; // Mock Data
    final userEmail = user.email ?? 'sem.email@exemplo.com';
    // --- FIM MOCK DATA ---

    return ListView(
      children: [
        ProfileHeader(
          userName: userName,
          userEmail: userEmail,
        ),
        const Divider(),
        _buildSectionHeader('Conta'),
        SettingsOptionTile(
          icon: Icons.person_outline,
          title: 'Editar Perfil',
          onTap: () {
            // TODO: Implementar navegação para tela de edição de perfil
            // (Esta ação precisa ser implementada no futuro)
            print('Navegar para Edição de Perfil');
          },
        ),
        SettingsOptionTile(
          icon: Icons.lock_outline,
          title: 'Alterar Palavra-passe',
          onTap: () {
            // Implementar alteração de senha com Firebase Auth
            if (user.email != null) {
              FirebaseAuth.instance.sendPasswordResetEmail(email: user.email!);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('E-mail de redefinição de senha enviado!'),
                  backgroundColor: AppColors.success,
                ),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                      'Não foi possível enviar o e-mail de redefinição. E-mail não encontrado.'),
                  backgroundColor: AppColors.error,
                ),
              );
            }
          },
        ),
        SettingsOptionTile(
          icon: Icons.logout,
          title: 'Sair',
          onTap: () => _signOut(context),
        ),
        const Divider(),
        _buildSectionHeader('Geral'),
        SettingsOptionTile(
          icon: Icons.notifications_none,
          title: 'Notificações',
          trailing: Switch(
            value: true, // TODO: Implementar estado real de notificações
            onChanged: (bool value) {
              // TODO: Implementar lógica de notificações
            },
            activeColor: AppColors.primary,
          ),
          onTap: () {},
        ),
        const Divider(),
        _buildSectionHeader('Outros'),
        SettingsOptionTile(
          icon: Icons.info_outline,
          title: 'Sobre o CardioRoad',
          onTap: () {},
        ),
        SettingsOptionTile(
          icon: Icons.description_outlined,
          title: 'Termos de Serviço',
          onTap: () {},
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Configurações'),
        backgroundColor: AppColors.darkBackground,
        iconTheme: const IconThemeData(color: AppColors.white),
        titleTextStyle: const TextStyle(
          color: AppColors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      body: user == null
          ? const Center(child: Text('Nenhum usuário logado'))
          // Chama a nova função _buildContent diretamente com o usuário
          : _buildContent(context, user),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: AppColors.primary,
        ),
      ),
    );
  }
}

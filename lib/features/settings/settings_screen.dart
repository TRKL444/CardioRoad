import 'package:flutter/material.dart';
import 'package:cardioroad/shared/themes/app_colors.dart';
import 'package:cardioroad/features/settings/widgets/profile_header.dart';
import 'package:cardioroad/features/settings/widgets/settings_option_tile.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
      body: ListView(
        children: [
          const ProfileHeader(
            userName: "Nathalia", // Dado de exemplo
            userEmail: "nathalia.exemplo@email.com", // Dado de exemplo
          ),
          const Divider(),
          _buildSectionHeader('Conta'),
          SettingsOptionTile(
            icon: Icons.person_outline,
            title: 'Editar Perfil',
            onTap: () {},
          ),
          SettingsOptionTile(
            icon: Icons.lock_outline,
            title: 'Alterar Palavra-passe',
            onTap: () {},
          ),
          const Divider(),
          _buildSectionHeader('Geral'),
          SettingsOptionTile(
            icon: Icons.notifications_none,
            title: 'Notificações',
            trailing: Switch(
              value: true, // Valor de exemplo
              onChanged: (bool value) {},
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
      ),
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

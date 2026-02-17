import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/more_cubit.dart';
import '../cubit/more_state.dart';
import 'package:go_router/go_router.dart';

class MorePage extends StatelessWidget {
  final VoidCallback onOpenProfile;
  final VoidCallback onOpenChangePassword;
  final VoidCallback onOpenChangeEmail;

  const MorePage({
    super.key,
    required this.onOpenProfile,
    required this.onOpenChangePassword,
    required this.onOpenChangeEmail,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MoreCubit, MoreState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(title: const Text('More')),
          body: ListView(
            padding: const EdgeInsets.all(12),
            children: [
              _SectionTitle('Account'),
              _Tile(
                icon: Icons.person,
                title: 'Profile',
                subtitle: 'View and edit your profile',
                onTap: onOpenProfile,
              ),
              _Tile(
                icon: Icons.lock,
                title: 'Change password',
                onTap: onOpenChangePassword,
              ),
              _Tile(
                icon: Icons.email_outlined,
                title: 'Change email',
                onTap: onOpenChangeEmail,
              ),
              const SizedBox(height: 16),

              _SectionTitle('App'),
              _Tile(
                icon: Icons.info_outline,
                title: 'About the app',
                onTap: () => context.push('/home/more/about'),
              ),
              SwitchListTile(
                value: state.isDarkMode,
                onChanged: (_) => context.read<MoreCubit>().toggleTheme(),
                title: const Text('Dark mode'),
              ),
              _Tile(
                icon: Icons.language,
                title: 'Language',
                subtitle: 'Current: ${state.languageCode}',
                onTap: () => _showLanguageSheet(context, state.languageCode),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showLanguageSheet(BuildContext context, String current) {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              RadioListTile(
                value: 'en',
                groupValue: current,
                title: const Text('English'),
                onChanged: (_) {
                  context.read<MoreCubit>().setLanguage('en');
                  Navigator.pop(context);
                },
              ),
              RadioListTile(
                value: 'ar',
                groupValue: current,
                title: const Text('Arabic'),
                onChanged: (_) {
                  context.read<MoreCubit>().setLanguage('ar');
                  Navigator.pop(context);
                },
              ),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String text;
  const _SectionTitle(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 10, 4, 6),
      child: Text(
        text,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
      ),
    );
  }
}

class _Tile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback onTap;

  const _Tile({
    required this.icon,
    required this.title,
    this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(icon),
        title: Text(title),
        subtitle: subtitle == null ? null : Text(subtitle!),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}

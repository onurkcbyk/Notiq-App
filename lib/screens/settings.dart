import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/settings_provider.dart';
import '../screens/about.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<SettingsProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Theme.of(context).colorScheme.onBackground,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // APPEARANCE SECTION
            _SettingsSection(
              title: 'Appearance',
              icon: Icons.palette_outlined,
              children: [
                _ModernSettingItem(
                  icon: Icons.dark_mode_outlined,
                  title: 'Dark Mode',
                  trailing: Switch(
                    value: settings.brightness == Brightness.dark,
                    onChanged: (val) {
                      settings.updateTheme(val ? Brightness.dark : Brightness.light);
                    },
                  ),
                ),
                _ModernSettingItem(
                  icon: Icons.format_size_outlined,
                  title: 'Text Size',
                  subtitle: '${settings.textSize.toInt()} pt',
                  onTap: () => _showTextSizeSlider(context),
                ),
                _ModernSettingItem(
                  icon: Icons.color_lens_outlined,
                  title: 'App Color',
                  subtitle: 'Current color',
                  trailing: Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: settings.primaryColor,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                  ),
                  onTap: () => _showColorPicker(context),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // MORE SETTINGS SECTION
            _SettingsSection(
              title: 'More',
              icon: Icons.settings_outlined,
              children: [
                _ModernSettingItem(
                  icon: Icons.info_outline,
                  title: 'About',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => AboutScreen()),
                    );
                  },
                ),
                _ModernSettingItem(
                  icon: Icons.share_outlined,
                  title: 'Share App',
                  onTap: () {},
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showTextSizeSlider(BuildContext context) {
    final settings = Provider.of<SettingsProvider>(context, listen: false);

    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Text Size',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Slider(
              value: settings.textSize,
              min: 12,
              max: 32,
              divisions: 10,
              label: '${settings.textSize.toInt()}',
              onChanged: (val) => settings.updateTextSize(val),
            ),
            SizedBox(height: 8),
            Text(
              'Preview Text',
              style: TextStyle(fontSize: settings.textSize),
            ),
          ],
        ),
      ),
    );
  }

  void _showColorPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => Container(
        padding: EdgeInsets.all(24),
        height: MediaQuery.of(context).size.height * 0.6,
        child: Column(
          children: [
            Text(
              'Choose App Color',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Expanded(
              child: GridView.count(
                crossAxisCount: 6,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                children: [
                  _colorCircle(Colors.red, context),
                  _colorCircle(Colors.pink, context),
                  _colorCircle(Colors.purple, context),
                  _colorCircle(Colors.deepPurple, context),
                  _colorCircle(Colors.indigo, context),
                  _colorCircle(Colors.blue, context),
                  _colorCircle(Colors.lightBlue, context),
                  _colorCircle(Colors.cyan, context),
                  _colorCircle(Colors.teal, context),
                  _colorCircle(Colors.green, context),
                  _colorCircle(Colors.lightGreen, context),
                  _colorCircle(Colors.lime, context),
                  _colorCircle(Colors.amber, context),
                  _colorCircle(Colors.orange, context),
                  _colorCircle(Colors.deepOrange, context),
                  _colorCircle(Colors.brown, context),
                  _colorCircle(Colors.grey, context),
                  _colorCircle(Colors.blueGrey, context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _colorCircle(Color color, BuildContext context) {
    return GestureDetector(
      onTap: () {
        Provider.of<SettingsProvider>(context, listen: false)
            .updatePrimaryColor(color);
        Navigator.pop(context);
      },
      child: Container(
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
      ),
    );
  }
}

// MODERN SECTION WIDGET
class _SettingsSection extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<Widget> children;

  const _SettingsSection({
    required this.title,
    required this.icon,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Icon(icon, size: 20),
                SizedBox(width: 8),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ],
            ),
          ),
          ...children,
        ],
      ),
    );
  }
}

// MODERN SETTING ITEM WIDGET
class _ModernSettingItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;

  const _ModernSettingItem({
    required this.icon,
    required this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      subtitle: subtitle != null ? Text(subtitle!) : null,
      trailing: trailing ?? Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
      contentPadding: EdgeInsets.symmetric(horizontal: 16),
    );
  }
}
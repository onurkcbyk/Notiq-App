import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({Key? key}) : super(key: key);

  Future<PackageInfo> _getPackageInfo() async {
    return await PackageInfo.fromPlatform();
  }

  _launchURL(String url) async {
    try {
      await launchUrl(
        Uri.parse(url),
        mode: LaunchMode.externalApplication,
      );
    } catch (e) {
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('About'),
      ),
      body: FutureBuilder<PackageInfo>(
        future: _getPackageInfo(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          final packageInfo = snapshot.data!;

          return Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Column(
                    children: [
                      Icon(Icons.note_alt_rounded, size: 64, color: Theme.of(context).colorScheme.primary),
                      SizedBox(height: 16),
                      Text(
                        'Notiq',
                        style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Version ${packageInfo.version}',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 32),

                Text(
                  'Notiq is a modern and fast note-taking app. '
                      'With dark mode, color customization and many more features, '
                      'you can easily manage your notes.',
                  style: TextStyle(fontSize: 16, height: 1.5),
                ),

                SizedBox(height: 24),

                // AYNI KALDI
                _buildLinkItem(
                  context,
                  'Privacy Policy',
                  Icons.privacy_tip,
                      () => _launchURL('https://onurkcbyk.github.io/Notiq-App/privacy-policy/'),
                ),
                _buildLinkItem(
                  context,
                  'Terms of Service',
                  Icons.description,
                      () => _launchURL('https://onurkcbyk.github.io/Notiq-App/terms-of service/'),
                ),
                _buildLinkItem(
                  context,
                  'Contact Support',
                  Icons.contact_support,
                      () => _launchURL('mailto:onurkcbyk@hotmail.com'),
                ),

                Spacer(),

                Center(
                  child: Text(
                    '© 2024 Notiq. All rights reserved.',
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildLinkItem(BuildContext context, String title, IconData icon, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, size: 20),
      title: Text(title),
      trailing: Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
      contentPadding: EdgeInsets.zero,
    );
  }
}
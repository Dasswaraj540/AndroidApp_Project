import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('About'),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  Container(
                    width: constraints.maxWidth * 0.8,
                    height: constraints.maxWidth * 0.5,
                    child: Image(
                      image: AssetImage('assets/images/logo.png'),
                      fit: BoxFit.contain,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'PeerPulse is a community and safety application designed to enhance neighborhood security through real-time alerts and communication. It allows residents to report incidents, share updates, and stay informed about local safety concerns. By fostering a connected and vigilant community, PeerPulse helps ensure a safer living environment for everyone.',
                      textAlign: TextAlign.justify,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Divider(),
                  _buildInfoRow('Version', '1.0.1'),
                  Divider(),
                  _buildInfoRow('Made Using:', ''),
                  const SizedBox(height: 10),
                  _buildTechInfoRow('assets/images/flutter.png', 'Flutter', '3.18.9'),
                  const SizedBox(height: 10),
                  _buildTechInfoRow('assets/images/dart.png', 'Dart', '3.3.9'),
                  const SizedBox(height: 10),
                  _buildTechInfoRow('assets/images/firebase.png', 'Firebase', '32.1.9'),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        children: [
          Text(
            label,
            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20),
          ),
          SizedBox(width: 8),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 20,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTechInfoRow(String imagePath, String techName, String version) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        children: [
          SizedBox(
            width: 30,
            height: 30,
            child: Image(image: AssetImage(imagePath)),
          ),
          SizedBox(width: 10),
          Text(
            techName,
            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20),
          ),
          SizedBox(width: 10),
          Text(
            version,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 20,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}

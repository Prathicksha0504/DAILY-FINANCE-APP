import 'package:flutter/material.dart';

class HelpPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Help & Support'),
          backgroundColor: Colors.purple[100],
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: const SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 10),

                Text(
                  'FAQs',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                ExpansionTile(
                  title: Text('How to update my profile?'),
                  children: [
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'To update your profile, go to the "Profile" section in the app. Tap on "Edit Profile" '
                        'to make changes, then save your updates.',
                      ),
                    ),
                  ],
                ),

                ExpansionTile(
                  title: Text('How can I delete my account?'),
                  children: [
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'To delete your account, go to Settings > Account Settings > Delete Account. '
                        'Alternatively, you can contact support for assistance.',
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 20),

                // Contact Support with ExpansionTile
                Text(
                  'Contact Support',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),

                ExpansionTile(
                  title: Text('Email Support'),
                  children: [
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                          'For email support, contact us at support@helpapp.com. We respond within 24 hours.'),
                    ),
                  ],
                ),
                ExpansionTile(
                  title: Text('Call Us'),
                  children: [
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'You can reach us via our toll-free number: 1-800-555-0199. Available Monday to Friday, 9 AM to 6 PM.',
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

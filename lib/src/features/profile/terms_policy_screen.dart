import 'package:flutter/material.dart';
import 'package:rentit/src/common/const/global_variable.dart';

class TermsPolicyScreen extends StatefulWidget {
  const TermsPolicyScreen({super.key});

  @override
  State<TermsPolicyScreen> createState() => _TermsPolicyScreenState();
}

class _TermsPolicyScreenState extends State<TermsPolicyScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Terms & Policy")),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          spacing: 2,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("1. Overview", style: txtTheme(context).titleSmall),
            Text(
              "Welcome to Roomify! By using our services, you agree to the following terms and conditions. Roomify serves as an intermediary between students and hostel managers, assisting students in finding suitable hostels based on their preferences. Roomify does not own or operate any hostels and is not responsible for the management or upkeep of the hostels listed on our platform.",
              style: txtTheme(context).bodySmall,
            ),
            SizedBox(height: 6),
            Text("2. Services Provided", style: txtTheme(context).titleSmall),
            Text(
              "Roomify connects students with hostels and charges hostel managers a fee for each student placed. We provide assistance in guiding students to hostels based on their preferences, location, and availability. Contacting us via the app's Contact button allows us to follow up and connect you with your desired hostel.",
              style: txtTheme(context).bodySmall,
            ),
            SizedBox(height: 6),
            Text("3. Responsibilities", style: txtTheme(context).titleSmall),
            Text(
              "Roomify is responsible for facilitating contact between students and hostels. Roomify is not responsible for the quality, safety, cleanliness, or any other aspect of the hostels. Once the student is placed in a hostel, all further matters, including disputes, maintenance, security, and other issues, are strictly between the student and the hostel management.",
              style: txtTheme(context).bodySmall,
            ),
            SizedBox(height: 6),
            Text("4. Fees and Payments", style: txtTheme(context).titleSmall),
            Text(
              " Roomify charges hostel managers a fee for each student referred and placed through our platform. Students are not charged for using the Roomify platform, but hostel costs are to be discussed directly with the hostel manager.",
              style: txtTheme(context).bodySmall,
            ),
            SizedBox(height: 6),
            Text(
              "5. Limitation of Liability",
              style: txtTheme(context).titleSmall,
            ),
            Text(
              "Roomify is not responsible for any problems, disputes, or incidents that arise between the student and the hostel, including but not limited to:",
              style: txtTheme(context).bodySmall,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 6),
              child: Text(
                "> Issues related to safety and security.",
                style: txtTheme(context).bodySmall,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 6),
              child: Text(
                "> Room quality or condition.",
                style: txtTheme(context).bodySmall,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 6),
              child: Text(
                "> Hostel rules and regulations.",
                style: txtTheme(context).bodySmall,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 6),
              child: Text(
                "> Financial disputes.",
                style: txtTheme(context).bodySmall,
              ),
            ),
            Text(
              "Roomify acts solely as a facilitator and is not liable for any loss, damages, or grievances experienced by students during or after their stay at the hostel.",
              style: txtTheme(context).bodySmall,
            ),
            SizedBox(height: 6),
            Text(
              "6. User Responsibilities",
              style: txtTheme(context).titleSmall,
            ),
            Text(
              "Students must verify the conditions, rules, and regulations of the hostel they choose. Users are responsible for providing accurate information when using the Roomify app. Any agreements made between the student and the hostel are independent of Roomify and should be reviewed carefully.",
              style: txtTheme(context).bodySmall,
            ),
            SizedBox(height: 6),
            Text("7. Changes to Terms", style: txtTheme(context).titleSmall),
            Text(
              "Roomify reserves the right to update these terms at any time. Users will be notified of any significant changes, and continued use of the platform will constitute acceptance of the updated terms.",
              style: txtTheme(context).bodySmall,
            ),
            SizedBox(height: 6),
            Text("8. Contact Information", style: txtTheme(context).titleSmall),
            Text(
              "For any questions or concerns, users can reach out through the Contact button in the Roomify app. However, for issues related to the hostel, users must contact the hostel manager directly.",
              style: txtTheme(context).bodySmall,
            ),
            SizedBox(height: 6),
          ],
        ),
      ),
    );
  }
}

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:no_code/pages/ai/chat_bot.dart';
import 'package:no_code/pages/appointment_booking/appointment_booking_page.dart';
import 'package:no_code/pages/medication_reminders/medicine_reminders.dart';
import 'package:no_code/pages/personalized_care/personalized_care.dart';
import 'package:no_code/pages/predictive_diagnosis/predictive_diagnosis.dart';
import 'package:no_code/pages/records_analysis_page/records_page.dart';
import 'package:no_code/pages/symptom_checker/symptom_checker.dart';
import 'package:no_code/pages/telemedicine_page/tele_medicines.dart';

import '../../constants/appbar.dart';
import '../../constants/end_drawer.dart';

class HomePage extends StatefulWidget {
  static final String route_name = '/home';
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // List of AI for Healthcare features with icon, label, and placeholder action
  final List<Map<String, dynamic>> features = [
    {
      'icon': Icons.health_and_safety,
      'label': 'Symptom Checker',
      'onTap': () {
        Get.to(SymptomCheckerPage());
      },
    },
    {
      'icon': Icons.event_available,
      'label': 'Appointment Booking',
      'onTap': () {
        Get.to(AppointmentBookingPage());
      },
    },
    {
      'icon': Icons.video_call,
      'label': 'Telemedicine',
      'onTap': () {
        // Navigate to Telemedicine
        Get.to(TelemedicinePage());
      },
    },
    {
      'icon': Icons.analytics,
      'label': 'Records Analysis',
      'onTap': () {
        // Navigate to Health Records Analysis
        Get.to(RecordsAnalysisPage());
      },
    },
    {
      'icon': Icons.alarm,
      'label': 'Medication Reminders',
      'onTap': () {
        Get.to(MedicationRemindersPage());
      },
    },
    {
      'icon': Icons.insights,
      'label': 'Predictive Diagnostics',
      'onTap': () {
        Get.to(PredictiveDiagnosticsPage());
      },
    },
    {
      'icon': Icons.person_search,
      'label': 'Personalized Care Plans',
      'onTap': () {
        // Navigate to Care Plans
        Get.to(CarePlanPage());
      },
    },
    {
      'icon': Icons.chat,
      'label': 'AI Chatbot Support',
      'onTap': () {
        Get.to(AiChatApp());
      },
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: get_app_bar('Home', true),
      endDrawer: get_end_drawer(context),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Features Grid Section
            const Text(
              'MediAI Features',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            GridView.builder(
              itemCount: features.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1.1,
              ),
              itemBuilder: (context, index) {
                final feature = features[index];
                return _buildFeatureCard(
                  icon: feature['icon'],
                  label: feature['label'],
                  onTap: feature['onTap'],
                );
              },
            ),
            const SizedBox(height: 24),
            // About Section
            const Text(
              'About AI Health Hub',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  'AI Health Hub leverages cutting-edge artificial intelligence to improve patient outcomes. From symptom assessment to predictive diagnostics, our platform empowers both providers and patients with actionable insights and seamless virtual care.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            ),
            const SizedBox(height: 24),
            // Footer Section
            Center(
              child: Text(
                '© 2025 AI Health Hub. All rights reserved.',
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureCard({
    required IconData icon,
    required String label,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 40, color: Colors.blueAccent),
              const SizedBox(height: 12),
              Flexible(
                child: Text(
                  label,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

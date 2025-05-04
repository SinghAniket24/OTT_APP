import 'package:flutter/material.dart';

class SubscriptionPage extends StatefulWidget {
  const SubscriptionPage({super.key});

  @override
  State<SubscriptionPage> createState() => _SubscriptionPageState();
}

class _SubscriptionPageState extends State<SubscriptionPage> {
  String selectedPlan = '';
  String billingCycle = 'Monthly';

  void toggleBillingCycle(String cycle) {
    setState(() {
      billingCycle = cycle;
    });
  }

  void selectPlan(String plan) {
    setState(() {
      selectedPlan = selectedPlan == plan ? '' : plan;
    });
  }

  @override
  Widget build(BuildContext context) {
    final plans = [
      {
        'title': 'Basic Membership',
        'price': 'Ads/month',
        'offer': 'Save 25% on Yearly',
        'features': ['Details coming soon.', 'Watch with ads.'],
        'icon': Icons.lock_outline
      },
      {
        'title': 'Premium Membership',
        'price': '₹79/month',
        'offer': 'Save 25% on Yearly',
        'features': ['Details coming soon.', 'Watch without ads.', 'High Quality.'],
        'icon': Icons.workspace_premium_outlined
      },
      {
        'title': 'Referrals',
        'price': '10 Referrals/month',
        'offer': 'Save 25% on Yearly',
        'features': ['Details coming soon.', 'Watch without ads: for 2 hours (10 referrals)'],
        'icon': Icons.people_alt_outlined
      },
    ];

    return Scaffold(
      backgroundColor: const Color(0xFF0F1C2F),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F1C2F),
        title: const Text("Subscribe", style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                buildBillingOption('Monthly'),
                const SizedBox(width: 12),
                buildBillingOption('Yearly'),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: plans.length,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemBuilder: (context, index) {
                final plan = plans[index];
                final isSelected = selectedPlan == plan['title'];

                return Card(
                  color: isSelected ? Colors.green.shade700 : const Color(0xFF1E2A38),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  child: ExpansionTile(
                    key: Key(plan['title'] as String),
                    tilePadding: const EdgeInsets.symmetric(horizontal: 16),
                    collapsedIconColor: Colors.white,
                    iconColor: Colors.white,
                    title: Row(
                      children: [
                        Icon(plan['icon'] as IconData, color: Colors.white70),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(plan['title'] as String,
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold)),
                              const SizedBox(height: 4),
                              Text(plan['price'] as String,
                                  style: const TextStyle(color: Colors.white70)),
                              Text(plan['offer'] as String,
                                  style: const TextStyle(color: Colors.white38)),
                            ],
                          ),
                        ),
                        Icon(
                          isSelected ? Icons.check_circle : Icons.circle_outlined,
                          color: isSelected ? Colors.white : Colors.white38,
                        )
                      ],
                    ),
                    children: [
                      ...List<Widget>.from((plan['features'] as List<String>).map(
                        (f) => ListTile(
                          title: Text(f, style: const TextStyle(color: Colors.white)),
                          leading: const Icon(Icons.check, color: Colors.white),
                        ),
                      )),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: ElevatedButton(
                          onPressed: () => selectPlan(plan['title'] as String),
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8))),
                          child: Text("Choose ${plan['title']}"),
                        ),
                      )
                    ],
                    onExpansionChanged: (isExpanded) {
                      if (isExpanded) {
                        selectPlan(plan['title'] as String);
                      }
                    },
                  ),
                );
              },
            ),
          )
        ],
      ),
      bottomNavigationBar: selectedPlan.isEmpty
          ? const SizedBox.shrink()
          : Container(
              color: const Color(0xFF0F1C2F),
              padding: const EdgeInsets.all(16),
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12))),
                child: Text("Continue with $selectedPlan"),
              ),
            ),
    );
  }

  Widget buildBillingOption(String label) {
    final isSelected = billingCycle == label;

    return Expanded(
      child: GestureDetector(
        onTap: () => toggleBillingCycle(label),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? Colors.green : Colors.transparent,
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: Colors.green),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.green,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
